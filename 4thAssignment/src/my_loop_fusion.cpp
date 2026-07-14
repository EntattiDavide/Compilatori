#include "llvm/ADT/SmallVector.h"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/Analysis/PostDominators.h"
#include "llvm/Analysis/ScalarEvolution.h"
#include "llvm/IR/Dominators.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/ValueMap.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

namespace {

static bool areAdjacent(Loop *First, Loop *Second) {
  if (!First || !Second || First == Second) return false;

  BasicBlock *SecondPreheader = Second->getLoopPreheader();
  if (!SecondPreheader) return false;

  for (auto &I : *SecondPreheader) {
    if (!I.isTerminator()) {
        //The preheader must only contain a terminator instruction,
        //otherwise it means other operations are happening inbetween
        return false; 
    }
  }

  SmallVector<BasicBlock *, 8> ExitBlocks;
  First->getExitBlocks(ExitBlocks);
  for (BasicBlock *ExitBB : ExitBlocks) {
    if (ExitBB == SecondPreheader) return true;
  }

  return false;
}

static bool haveSameTripCount(Loop *First, Loop *Second, ScalarEvolution &SE) {
  const SCEV *FirstTrip = SE.getBackedgeTakenCount(First);
  const SCEV *SecondTrip = SE.getBackedgeTakenCount(Second);
  // Check for same number of backedge taken
  if (!FirstTrip || !SecondTrip || isa<SCEVCouldNotCompute>(FirstTrip)) return false;
  return FirstTrip == SecondTrip;
}

static bool areControlEquivalent(Loop *First, Loop *Second, DominatorTree &DT, PostDominatorTree &PDT) {
  BasicBlock *H1 = First->getHeader();
  BasicBlock *H2 = Second->getHeader();

  // Loop 1 dominates Loop 2 and Loop 2 postdominates Loop 1
  return DT.dominates(H1, H2) && PDT.dominates(H2, H1);
}

// Three blocks: Header, Body, Latch
static bool hasExactlyThreeBlocks(Loop *L) {
  return L && L->getNumBlocks() == 3;
}

static BasicBlock* getBodyBlock(Loop *L) {
  BasicBlock *Header = L->getHeader();
  BasicBlock *Latch = L->getLoopLatch();
  for (BasicBlock *BB : L->getBlocks()) {
    if (BB != Header && BB != Latch) return BB;
  }
  return nullptr;
}

static bool hasSinglePhiInstruction(Loop *L) {
  unsigned PhiCount = 0;
  for (BasicBlock *BB : L->getBlocks()) {
    for (Instruction &I : *BB) {
      if (isa<PHINode>(I)) {
        PhiCount++;
      }
    }
  }
  return PhiCount == 1;
}

static bool hasNoNegativeDistanceDependencies(Loop *First, Loop *Second, ScalarEvolution &SE) {
  // Olny load and store instructions can cause data dependencies
  SmallVector<Instruction *, 16> Instructions1, Instructions2;
  for (BasicBlock *BB : First->getBlocks())
    for (Instruction &I : *BB) 
      if (isa<LoadInst>(I) || isa<StoreInst>(I)) Instructions1.push_back(&I);

  for (BasicBlock *BB : Second->getBlocks())
    for (Instruction &I : *BB) 
      if (isa<LoadInst>(I) || isa<StoreInst>(I)) Instructions2.push_back(&I);

  for (Instruction *I1 : Instructions1) {
    for (Instruction *I2 : Instructions2) {
      // Both load, no conflict
      if (isa<LoadInst>(I1) && isa<LoadInst>(I2)) continue;

      // Get pointers
      Value *Ptr1 = isa<LoadInst>(I1) ? cast<LoadInst>(I1)->getPointerOperand() : cast<StoreInst>(I1)->getPointerOperand();
      Value *Ptr2 = isa<LoadInst>(I2) ? cast<LoadInst>(I2)->getPointerOperand() : cast<StoreInst>(I2)->getPointerOperand();

      // Alalyze the SCEV expressions for the pointers
      const SCEVAddRecExpr *AR1 = dyn_cast<SCEVAddRecExpr>(SE.getSCEV(Ptr1));
      const SCEVAddRecExpr *AR2 = dyn_cast<SCEVAddRecExpr>(SE.getSCEV(Ptr2));

      if (AR1 && AR2) {
        // Check for same step recurrence
        if (AR1->getStepRecurrence(SE) != AR2->getStepRecurrence(SE)) return false;

        // Calculate distance
        const SCEV *DistSCEV = SE.getMinusSCEV(AR1->getStart(), AR2->getStart());
        
        if (const SCEVConstant *ConstDist = dyn_cast<SCEVConstant>(DistSCEV)) {
          const SCEV *Step = AR1->getStepRecurrence(SE);

          // Check for negative distance
          if (SE.isKnownPositive(Step) && SE.isKnownNegative(DistSCEV) || SE.isKnownNegative(Step) && SE.isKnownPositive(DistSCEV)) {
            return false; 
          }
        }
      }
    }
  }
  return true;
}

struct MyLoopFusion : PassInfoMixin<MyLoopFusion> {
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &FAM) {
    auto &LI = FAM.getResult<LoopAnalysis>(F);
    auto &DT = FAM.getResult<DominatorTreeAnalysis>(F);
    auto &PDT = FAM.getResult<PostDominatorTreeAnalysis>(F);
    auto &SE = FAM.getResult<ScalarEvolutionAnalysis>(F);

    bool Modified = false;

    SmallVector<Loop *, 16> AllLoops(LI.begin(), LI.end());

    for (Loop *Second : AllLoops) {
      for (Loop *First : AllLoops) {
        if (First == Second) continue;

        if (!areAdjacent(First, Second) ||
            !haveSameTripCount(First, Second, SE) ||
            !areControlEquivalent(First, Second, DT, PDT) ||
            !hasNoNegativeDistanceDependencies(First, Second, SE)) {
          continue;
        }
        
        if (!hasExactlyThreeBlocks(First) || !hasExactlyThreeBlocks(Second)) {
          continue;
        }

        BasicBlock *FirstBody = getBodyBlock(First);
        BasicBlock *SecondBody = getBodyBlock(Second);
        PHINode *IV1 = First->getCanonicalInductionVariable();
        PHINode *IV2 = Second->getCanonicalInductionVariable();

        if (!FirstBody || !SecondBody || !IV1 || !IV2 || !hasSinglePhiInstruction(First) || !hasSinglePhiInstruction(Second)) {
          continue;
        }

        // --- FUSION ---

        // 1. RAUW: Replace All Uses of Second's Induction Variable with First's Induction Variable
        IV2->replaceAllUsesWith(IV1);

        // 2. Sposta le istruzioni
        Instruction *IP = FirstBody->getTerminator();
        for (auto It = SecondBody->begin(); It != SecondBody->end(); ) {
          Instruction &I = *It++;
          if (I.isTerminator()) continue;
          I.moveBefore(IP);
        }

        // 3. Redirect the exit of the first loop to the exit of the second loop
        BasicBlock *H1 = First->getHeader();
        Instruction *H1Term = H1->getTerminator();
        BasicBlock *FirstExit = First->getExitBlock();
        BasicBlock *SecondExit = Second->getExitBlock();
        // Move first header successor to second loop exit
        for (unsigned i = 0; i < H1Term->getNumSuccessors(); ++i) {
            if (H1Term->getSuccessor(i) == FirstExit) {
                // Remove old exit block
                FirstExit->eraseFromParent();
                H1Term->setSuccessor(i, SecondExit);
            }
        }

        // 4. Cleanup: Remove the second loop from the LoopInfo and delete its blocks
        BasicBlock *H2 = Second->getHeader();
        BasicBlock *L2 = Second->getLoopLatch();
        
        LI.erase(Second);

        // Remove Header, Body and Latch of the second loop
        L2->eraseFromParent();
        SecondBody->eraseFromParent();
        H2->eraseFromParent();
        

        Modified = true;
        break;
      }
    }
    return Modified ? PreservedAnalyses::none() : PreservedAnalyses::all();
  }
};

} // namespace

extern "C" LLVM_ATTRIBUTE_WEAK ::llvm::PassPluginLibraryInfo llvmGetPassPluginInfo() {
  return {LLVM_PLUGIN_API_VERSION, "MyLoopFusion", LLVM_VERSION_STRING,
          [](PassBuilder &PB) {
            PB.registerPipelineParsingCallback(
                [](StringRef Name, FunctionPassManager &FPM, ...) {
                  if (Name == "my-loop-fusion") {
                    FPM.addPass(MyLoopFusion());
                    return true;
                  }
                  return false;
                });
          }};
}
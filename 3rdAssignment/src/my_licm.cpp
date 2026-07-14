//=============================================================================
// FILE:
//    my_licm.cpp
//
// DESCRIPTION:
//    A simple implementation of loop-invariant code motion (LICM).
//
// USAGE:
//    New PM
//      opt -load-pass-plugin=<path-to>libMyLicm.so -passes="my-licm" `\`
//        -disable-output <input-llvm-file>
//
//
// License: MIT
//=============================================================================
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/IR/Argument.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/Dominators.h"
#include "llvm/IR/Instructions.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

namespace {

static bool isLoopInvariantInstruction(
    Instruction &I, const DenseSet<BasicBlock *> &LoopBlocks,
    const DenseSet<Instruction *> &InvariantInstructions) {
  if (isa<PHINode>(I) || I.isTerminator()) {
    return false;
  }

  if (I.mayHaveSideEffects() || I.mayThrow() || I.mayReadOrWriteMemory()) {
    return false;
  }

  for (Value *Operand : I.operands()) {
    if (auto *OpInst = dyn_cast<Instruction>(Operand)) {
      if (LoopBlocks.contains(OpInst->getParent()) &&
          !InvariantInstructions.contains(OpInst)) {
        return false;
      }
    } else if (!isa<Constant>(Operand) && !isa<Argument>(Operand) &&
               !isa<GlobalValue>(Operand)) {
      return false;
    }
  }

  return true;
}

static SmallVector<BasicBlock *, 8> getBlocksInDFSOrder(Loop &L) {
  SmallVector<BasicBlock *, 8> Order;
  DenseSet<BasicBlock *> Visited;
  SmallVector<BasicBlock *, 8> Stack;
  Stack.push_back(L.getHeader());

  while (!Stack.empty()) {
    BasicBlock *BB = Stack.pop_back_val();
    // Tries to add the block to the set, if it was already there, we skip it
    if (!Visited.insert(BB).second) {
      continue;
    }

    Order.push_back(BB);

    for (BasicBlock *Succ : successors(BB)) {
      if (L.contains(Succ) && !Visited.contains(Succ)) {
        Stack.push_back(Succ);
      }
    }
  }

  return Order;
}

struct MyLicm : PassInfoMixin<MyLicm> {
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &FAM) {
    auto &LI = FAM.getResult<LoopAnalysis>(F);
    auto &DT = FAM.getResult<DominatorTreeAnalysis>(F);

    bool Modified = false;

    for (Loop *L : LI) {
      if (!L->getLoopPreheader()) {
        continue;
      }

      DenseSet<BasicBlock *> LoopBlocks;
      for (BasicBlock *BB : L->getBlocks()) {
        LoopBlocks.insert(BB);
      }

      // Get all Loop Invariant Instructions
      SmallVector<BasicBlock *, 8> DFSOrder = getBlocksInDFSOrder(*L);
      DenseSet<Instruction *> InvariantInstructions;
      bool Changed = true;

      while (Changed) {
        Changed = false;
        for (BasicBlock *BB : DFSOrder) {
          for (Instruction &I : *BB) {
            if (InvariantInstructions.contains(&I)) {
              continue;
            }

            if (isLoopInvariantInstruction(I, LoopBlocks, InvariantInstructions)) {
              InvariantInstructions.insert(&I);
              Changed = true;
            }
          }
        }
      }

      // Create set of all exit blocks of the loop
      DenseSet<BasicBlock *> ExitBlocks;
      for (BasicBlock *BB : L->getBlocks()) {
        for (BasicBlock *Succ : successors(BB)) {
          if (!LoopBlocks.contains(Succ)) {
            ExitBlocks.insert(Succ);
          }
        }
      }

      // Move all movable Instructions
      DenseSet<Instruction *> MovedInstructions;
      for (BasicBlock *BB : DFSOrder) {
        for (auto Iter = BB->begin(); Iter != BB->end();) {
          Instruction &I = *Iter++;
          if (!InvariantInstructions.contains(&I)) {
            continue;
          }

          // Can't move PHI instrucions, void expressions may have side effects.
          if (!I.getType()->isVoidTy() && !isa<PHINode>(I)) {
            bool DominatesAllExits = true;
            for (BasicBlock *ExitBB : ExitBlocks) {
              if (!DT.dominates(BB, ExitBB)) {
                DominatesAllExits = false;
                break;
              }
            }

            bool DeadAtExit = true;
            for (User *U : I.users()) {
              if (auto *UserInst = dyn_cast<Instruction>(U)) {
                if (!LoopBlocks.contains(UserInst->getParent())) {
                  DeadAtExit = false;
                  break;
                }
              } else {
                DeadAtExit = false;
                break;
              }
            }

            bool DominatesAllUsers = true;
            for (User *U : I.users()) {
              if (auto *UserInst = dyn_cast<Instruction>(U)) {
                if (LoopBlocks.contains(UserInst->getParent()) &&
                    !DT.dominates(BB, UserInst->getParent())) {
                  DominatesAllUsers = false;
                  break;
                }
              }
            }

            // Check if the instruction depends only on other moved instructions 
            // or instructions that are not in the loop
            bool DependsOnlyOnMoved = true;
            for (Value *Operand : I.operands()) {
              if (auto *OpInst = dyn_cast<Instruction>(Operand)) {
                if (LoopBlocks.contains(OpInst->getParent()) &&
                    InvariantInstructions.contains(OpInst) &&
                    !MovedInstructions.contains(OpInst)) {
                  DependsOnlyOnMoved = false;
                  break;
                }
              }
            }

            // Move instruction if possible
            if ((DominatesAllExits || DeadAtExit) && DominatesAllUsers &&
                DependsOnlyOnMoved) {
              BasicBlock *PreHeader = L->getLoopPreheader();
              if (PreHeader) {
                errs() << "Moved from: " << I << "\n";
                I.moveBefore(PreHeader->getTerminator());
                MovedInstructions.insert(&I);
                errs() << "Moved to:   " << I << "\n";
                Modified = true;
              }
            }
          }
        }
      }
    }

    return Modified ? PreservedAnalyses::none() : PreservedAnalyses::all();
  }

  static bool isRequired() { return true; }
};

} // namespace

//-----------------------------------------------------------------------------
// New PM Registration
//-----------------------------------------------------------------------------
llvm::PassPluginLibraryInfo getMyLicmPluginInfo() {
  return {LLVM_PLUGIN_API_VERSION, "MyLicm", LLVM_VERSION_STRING,
          [](PassBuilder &PB) {
            PB.registerPipelineParsingCallback(
                [](StringRef Name, FunctionPassManager &FPM,
                   ArrayRef<PassBuilder::PipelineElement>) {
                  if (Name == "my-licm") {
                    FPM.addPass(MyLicm());
                    return true;
                  }
                  return false;
                });
          }};
}

extern "C" LLVM_ATTRIBUTE_WEAK ::llvm::PassPluginLibraryInfo
llvmGetPassPluginInfo() {
  return getMyLicmPluginInfo();
}
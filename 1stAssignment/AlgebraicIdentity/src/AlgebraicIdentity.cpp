//=============================================================================
// FILE:
//    AlgebraicIdentity.cpp
//
// DESCRIPTION:
//    Transofrms a function by replacing every occurrence of x+0, 0+x, x-0, x*1, 1*x, x/1 with x,
//    and every occurrence of 0*x, x*0, 0/x with 0
//
// USAGE:
//    New PM
//      opt -load-pass-plugin=<path-to>libAlgebraicIdentity.so -passes="algebraic-identity" `\`
//        -disable-output <input-llvm-file>
//
//
// License: MIT
//=============================================================================
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Instructions.h"

using namespace llvm;

namespace {

struct AlgebraicIdentity : PassInfoMixin<AlgebraicIdentity> {
 PreservedAnalyses run(Function &F, FunctionAnalysisManager &) {
  bool Modified = false;

  for (auto &BB : F) {
    for (auto Iter = BB.begin(); Iter != BB.end();) {
      //Get the current instruction and immediatly increment the iterator
      Instruction &I = *Iter++;

      //Case: Sum
      if (I.getOpcode() == Instruction::Add) {
        Value *Op0 = I.getOperand(0);
        Value *Op1 = I.getOperand(1);

        ConstantInt *C = nullptr;
        Value *V = nullptr;

        if ((C = dyn_cast<ConstantInt>(Op0))) {
          V = Op1;
        } else if ((C = dyn_cast<ConstantInt>(Op1))) {
          V = Op0;
        } else continue; //No constant operand

        if (C->isZero()) {
          I.replaceAllUsesWith(V);
          I.eraseFromParent();
          Modified = true;
          continue;
        }
      }

      //Case: Subtraction
      if (I.getOpcode() == Instruction::Sub) {
        Value *Op0 = I.getOperand(0);
        Value *Op1 = I.getOperand(1);
        
        //We can't optimize case 0-x, only case x-0
        if (ConstantInt *C = dyn_cast<ConstantInt>(Op1)) {
          if (C->isZero()) {
            I.replaceAllUsesWith(Op0);
            I.eraseFromParent();
            Modified = true;
            continue;
          }
        }
      }

      //Case: Multiplication
      if (I.getOpcode() == Instruction::Mul) {
        Value *Op0 = I.getOperand(0);
        Value *Op1 = I.getOperand(1);

        ConstantInt *C = nullptr;
        Value *V = nullptr;

        if ((C = dyn_cast<ConstantInt>(Op0))) {
          V = Op1;
        } else if ((C = dyn_cast<ConstantInt>(Op1))) {
          V = Op0;
        } else continue; //No constant operand

        if (C->isOne()) {
          I.replaceAllUsesWith(V);
          I.eraseFromParent();
          Modified = true;
          continue;
        }
        
        if (C->isZero()) {
          I.replaceAllUsesWith(C);
          I.eraseFromParent();
          Modified = true;
          continue;
        }
      }
          
      //Case: Division
      if (I.getOpcode() == Instruction::SDiv || I.getOpcode() == Instruction::UDiv) {
        Value *Op0 = I.getOperand(0);
        Value *Op1 = I.getOperand(1);

        //We can't opitmize cases: 1/x and x/0, only cases: x/1 and 0/x, case 0/0 is an exeption and is not optimized
        if (ConstantInt *C = dyn_cast<ConstantInt>(Op0)) {
            if (C->isZero()) {
              ConstantInt *C1 = dyn_cast<ConstantInt>(Op1);
              if (C1 && C1->isZero())
                continue; // Avoid division by zero
              I.replaceAllUsesWith(C);
              I.eraseFromParent();
              Modified = true;
              continue;
            }
          }
        if (ConstantInt *C = dyn_cast<ConstantInt>(Op1)) {
          if (C->isOne()) {
            I.replaceAllUsesWith(Op0);
            I.eraseFromParent();
            Modified = true;
            continue;
          }
        }
      }
    } 
  }
    return Modified ? PreservedAnalyses::none() : PreservedAnalyses::all();

  }
  static bool isRequired() { return true; }
};

}// namespace

//-----------------------------------------------------------------------------
// New PM Registration
//-----------------------------------------------------------------------------
llvm::PassPluginLibraryInfo getAlgebraicIdentityPluginInfo() {
  return {LLVM_PLUGIN_API_VERSION, "AlgebraicIdentity", LLVM_VERSION_STRING,
    [](PassBuilder &PB) {
      PB.registerPipelineParsingCallback(
          [](StringRef Name, FunctionPassManager &FPM,
              ArrayRef<PassBuilder::PipelineElement>) {
            if (Name == "algebraic-identity") {
              FPM.addPass(AlgebraicIdentity());
              return true;
            }
            return false;
          });
    }};
}

extern "C" LLVM_ATTRIBUTE_WEAK ::llvm::PassPluginLibraryInfo
llvmGetPassPluginInfo() {
  return getAlgebraicIdentityPluginInfo();
}
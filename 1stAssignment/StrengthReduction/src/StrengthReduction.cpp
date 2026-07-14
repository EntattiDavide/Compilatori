//=============================================================================
// FILE:
//    StrengthReduction.cpp
//
// DESCRIPTION:
//    Transofrms a function by replacing every occurrence of x*(2^n), x*(2^n-1), x*(2^n+1), x/(2^n)
//    with equivalent shift and add/sub instructions,
//
// USAGE:
//    New PM
//      opt -load-pass-plugin=<path-to>libStrengthReduction.so -passes="strength-reduction" `\`
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

struct StrengthReduction : PassInfoMixin<StrengthReduction> {
 PreservedAnalyses run(Function &F, FunctionAnalysisManager &) {
  bool Modified = false;

  for (auto &BB : F) {
    for (auto Iter = BB.begin(); Iter != BB.end();) {
      Instruction &I = *Iter++;

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

        APInt ConstVal = C->getValue();
        // Case x*(2^n)
        if (ConstVal.isPowerOf2()) {
            unsigned exp = ConstVal.exactLogBase2();
            ConstantInt *shift = cast<ConstantInt>(ConstantInt::get(V->getType(), exp));
            Instruction *Shl = BinaryOperator::Create(Instruction::Shl, V, shift);
            Shl ->insertBefore(&I);
            I.replaceAllUsesWith(Shl);
            I.eraseFromParent();
            Modified = true;
            continue;
        }
        // Case x*(2^n-1)
        if ((ConstVal + 1).isPowerOf2()) {
            unsigned exp = (ConstVal + 1).logBase2();
            ConstantInt *shift = cast<ConstantInt>(ConstantInt::get(V->getType(), exp));
            Instruction *Shl = BinaryOperator::Create(Instruction::Shl, V, shift);
            Instruction *Sub = BinaryOperator::Create(Instruction::Sub, Shl, V);
            Shl ->insertBefore(&I);
            Sub ->insertBefore(&I);
            I.replaceAllUsesWith(Sub);
            I.eraseFromParent();
            Modified = true;
            continue;
        }
        // Case x*(2^n+1)
        if ((ConstVal - 1).isPowerOf2()) {
            unsigned exp = (ConstVal - 1).logBase2();
            ConstantInt *shift = cast<ConstantInt>(ConstantInt::get(V->getType(), exp));
            Instruction *Shl = BinaryOperator::Create(Instruction::Shl, V, shift);
            Instruction *Add = BinaryOperator::Create(Instruction::Add, Shl, V);
            Shl ->insertBefore(&I);
            Add ->insertBefore(&I);
            I.replaceAllUsesWith(Add);
            I.eraseFromParent();
            Modified = true;
            continue;
        }
      }
      //Case: Unsigned Division
      if (I.getOpcode() == Instruction::UDiv) {
        Value *Op0 = I.getOperand(0);
        Value *Op1 = I.getOperand(1);

        if (ConstantInt *C = dyn_cast<ConstantInt>(Op1)) {
          APInt ConstVal = C->getValue();
          if (ConstVal.isPowerOf2()) {
              unsigned exp = ConstVal.exactLogBase2();
              ConstantInt *shift = cast<ConstantInt>(ConstantInt::get(Op0->getType(), exp));
              Instruction *LShr = BinaryOperator::Create(Instruction::LShr, Op0, shift);
              LShr ->insertBefore(&I);
              I.replaceAllUsesWith(LShr);
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
llvm::PassPluginLibraryInfo getStrengthReductionPluginInfo() {
  return {LLVM_PLUGIN_API_VERSION, "StrengthReduction", LLVM_VERSION_STRING,
    [](PassBuilder &PB) {
      PB.registerPipelineParsingCallback(
          [](StringRef Name, FunctionPassManager &FPM,
              ArrayRef<PassBuilder::PipelineElement>) {
            if (Name == "strength-reduction") {
              FPM.addPass(StrengthReduction());
              return true;
            }
            return false;
          });
    }};
}

extern "C" LLVM_ATTRIBUTE_WEAK ::llvm::PassPluginLibraryInfo
llvmGetPassPluginInfo() {
  return getStrengthReductionPluginInfo();
}
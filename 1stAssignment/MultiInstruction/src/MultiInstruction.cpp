//=============================================================================
// FILE:
//    MultiInstruction.cpp
//
// DESCRIPTION:
//    Transofrms a function by replacing every occurrence of x+0, 0+x, x-0, x*1, 1*x, x/1 with x,
//    and every occurrence of 0*x, x*0, 0/x with 0
//
// USAGE:
//    New PM
//      opt -load-pass-plugin=<path-to>libMultiInstruction.so -passes="multi-instruction" `\`
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

struct MultiInstruction : PassInfoMixin<MultiInstruction> {
 PreservedAnalyses run(Function &F, FunctionAnalysisManager &) {
  bool Modified = false;

  for (auto &BB : F) {
    for (auto Iter = BB.begin(); Iter != BB.end();) {
      //Get the current instruction and immediatly increment the iterator
      Instruction &I = *Iter++;
      unsigned opcode = I.getOpcode();

      if (opcode == Instruction::Add || opcode == Instruction::Mul || opcode == Instruction::Sub || opcode == Instruction::UDiv || opcode == Instruction::SDiv) {
        Value *Op0 = I.getOperand(0);
        Value *Op1 = I.getOperand(1);

        ConstantInt *C = nullptr;
        Value *V = nullptr;

        // Addition and Multiplication are commutative
        if(opcode == Instruction::Add || opcode == Instruction::Mul){
          
          if ((C = dyn_cast<ConstantInt>(Op0))) {
            V = Op1;
          } else if ((C = dyn_cast<ConstantInt>(Op1))) {
            V = Op0;
          } else continue; //No constant 
          
        // Subtraction and Division are not commutative
        } else if ((opcode == Instruction::Sub || opcode == Instruction::UDiv || opcode == Instruction::SDiv) &&
          (C = dyn_cast<ConstantInt>(I.getOperand(1)))) {
            V = I.getOperand(0);
        } else continue;

        // Check if V is the result of previous instruction
        if (Instruction *Prev = dyn_cast<Instruction>(V)) {
          
          unsigned prevOpcode = Prev->getOpcode();
          Value *prevOp0 = Prev->getOperand(0);
          Value *prevOp1 = Prev->getOperand(1);

          ConstantInt *prevC = nullptr;
          Value *prevV = nullptr;
          
          //Addition and Multiplication are commutative
          if(prevOpcode == Instruction::Add || prevOpcode == Instruction::Mul) {

            if ((prevC = dyn_cast<ConstantInt>(prevOp0))) {
              prevV = prevOp1;
            } else if ((prevC = dyn_cast<ConstantInt>(prevOp1))) {
              prevV = prevOp0;
            } else continue; //No constant operand

          // Subtraction and Division are not commutative
          }else if ((prevOpcode == Instruction::Sub || prevOpcode == Instruction::UDiv || prevOpcode == Instruction::SDiv) &&
            (prevC = dyn_cast<ConstantInt>(Prev->getOperand(1)))) {
              prevV = Prev->getOperand(0);
          } else continue;

          if (prevC ->getValue() != C->getValue()) {
            continue; // The constants are different
          }

          bool possible = false;
          if (opcode == Instruction::Sub && prevOpcode == Instruction::Add) {
            possible = true;
          } else if (opcode == Instruction::Add && prevOpcode == Instruction::Sub) {
            possible = true;
            //Multiplication and Division can't be optimized if the multiplication can overflow
          } else if ((opcode == Instruction::UDiv && prevOpcode == Instruction::Mul) && (Prev->hasNoUnsignedWrap())) {
            possible = true;
          } else if ((opcode == Instruction::SDiv && prevOpcode == Instruction::Mul) && (Prev->hasNoSignedWrap())) {
            possible = true;
            //Division and Multiplication can't be optimized if the module is not zero
          } else if ((opcode == Instruction::Mul && (prevOpcode == Instruction::UDiv || prevOpcode == Instruction::SDiv) && (cast<BinaryOperator>(Prev)->isExact()))) {
            possible = true;
          }
          
          if (possible) {
            I.replaceAllUsesWith(prevV);
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
llvm::PassPluginLibraryInfo getMultiInstructionPluginInfo() {
  return {LLVM_PLUGIN_API_VERSION, "MultiInstruction", LLVM_VERSION_STRING,
    [](PassBuilder &PB) {
    PB.registerPipelineParsingCallback(
        [](StringRef Name, FunctionPassManager &FPM,
            ArrayRef<PassBuilder::PipelineElement>) {
            if (Name == "multi-instruction") {
            FPM.addPass(MultiInstruction());
            return true;
            }
            return false;
        });
    }};
}

extern "C" LLVM_ATTRIBUTE_WEAK ::llvm::PassPluginLibraryInfo
llvmGetPassPluginInfo() {
  return getMultiInstructionPluginInfo();
}
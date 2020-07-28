package dk.camelot64.kickc.passes;

import dk.camelot64.cpufamily6502.AsmAddressingMode;
import dk.camelot64.cpufamily6502.AsmInstructionSet;
import dk.camelot64.cpufamily6502.AsmOpcode;
import dk.camelot64.kickc.asm.*;
import dk.camelot64.kickc.model.Program;

import java.util.List;
import java.util.ListIterator;

/**
 * Maps out register values entering all instructions. Removes unnecessary loads / clears / sets
 */
public class Pass5UnnecesaryLoadElimination extends Pass5AsmOptimization {

   public Pass5UnnecesaryLoadElimination(Program program) {
      super(program);
   }

   @Override
   public boolean optimize() {
      AsmProgramStaticRegisterValues staticValues = new AsmProgramStaticRegisterValues(getAsmProgram());
      boolean modified = false;

      for(AsmChunk chunk : getAsmProgram().getChunks()) {
         List<AsmLine> lines = chunk.getLines();
         ListIterator<AsmLine> lineIt = lines.listIterator();
         while(lineIt.hasNext()) {
            AsmLine line = lineIt.next();
            if(line instanceof AsmInstruction) {
               AsmInstruction instruction = (AsmInstruction) line;
               if(instruction.isDontOptimize()) {
                  continue;
               }
               AsmOpcode asmOpcode = instruction.getAsmOpcode();

               if(asmOpcode.getMnemonic().equals("lda") && asmOpcode.getAddressingMode().equals(AsmAddressingMode.IMM)) {
                  String immValue = instruction.getOperand1();
                  AsmProgramStaticRegisterValues.AsmRegisterValues instructionValues = staticValues.getValues(instruction);
                  if(AsmProgramStaticRegisterValues.matchImm(instructionValues.getA(), immValue)) {
                     modified = remove(lineIt);
                  } else if(AsmProgramStaticRegisterValues.matchImm(instructionValues.getX(), immValue)) {
                     getLog().append("Replacing instruction " + instruction + " with TXA");
                     instruction.setAsmOpcode(AsmInstructionSet.getOpcode("txa", AsmAddressingMode.NON, false));
                     instruction.setOperand1(null);
                  } else if(AsmProgramStaticRegisterValues.matchImm(instructionValues.getY(), immValue)) {
                     getLog().append("Replacing instruction " + instruction + " with TYA");
                     instruction.setAsmOpcode(AsmInstructionSet.getOpcode("tya", AsmAddressingMode.NON, false));
                     instruction.setOperand1(null);
                  }
               }
               if(asmOpcode.getMnemonic().equals("lda") && (asmOpcode.getAddressingMode().equals(AsmAddressingMode.ZP) || asmOpcode.getAddressingMode().equals(AsmAddressingMode.ABS))) {
                  String memValue = instruction.getOperand1();
                  AsmProgramStaticRegisterValues.AsmRegisterValues instructionValues = staticValues.getValues(instruction);
                  if(instructionValues.getaMem() != null && instructionValues.getaMem().equals(memValue)) {
                     modified = remove(lineIt);
                  } else if(instructionValues.getxMem() != null && instructionValues.getxMem().equals(memValue)) {
                     getLog().append("Replacing instruction " + instruction + " with TXA");
                     instruction.setAsmOpcode(AsmInstructionSet.getOpcode("txa", AsmAddressingMode.NON, false));
                     instruction.setOperand1(null);
                  } else if(instructionValues.getyMem() != null && instructionValues.getyMem().equals(memValue)) {
                     getLog().append("Replacing instruction " + instruction + " with TYA");
                     instruction.setAsmOpcode(AsmInstructionSet.getOpcode("tya", AsmAddressingMode.NON, false));
                     instruction.setOperand1(null);
                  }
               }
               if(asmOpcode.getMnemonic().equals("ldx") && asmOpcode.getAddressingMode().equals(AsmAddressingMode.IMM)) {
                  String immValue = instruction.getOperand1();
                  AsmProgramStaticRegisterValues.AsmRegisterValues instructionValues = staticValues.getValues(instruction);
                  if(AsmProgramStaticRegisterValues.matchImm(instructionValues.getX(), immValue)) {
                     modified = remove(lineIt);
                  } else if(AsmProgramStaticRegisterValues.matchImm(instructionValues.getA(), immValue)) {
                     getLog().append("Replacing instruction " + instruction + " with TAX");
                     instruction.setAsmOpcode(AsmInstructionSet.getOpcode("tax", AsmAddressingMode.NON, false));
                     instruction.setOperand1(null);
                  }
               }
               if(asmOpcode.getMnemonic().equals("ldx") && (asmOpcode.getAddressingMode().equals(AsmAddressingMode.ZP) || asmOpcode.getAddressingMode().equals(AsmAddressingMode.ABS))) {
                  String memValue = instruction.getOperand1();
                  AsmProgramStaticRegisterValues.AsmRegisterValues instructionValues = staticValues.getValues(instruction);
                  if(instructionValues.getxMem() != null && instructionValues.getxMem().equals(memValue)) {
                     modified = remove(lineIt);
                  } else if(instructionValues.getaMem() != null && instructionValues.getaMem().equals(memValue)) {
                     getLog().append("Replacing instruction " + instruction + " with TAX");
                     instruction.setAsmOpcode(AsmInstructionSet.getOpcode("tax", AsmAddressingMode.NON, false));
                     instruction.setOperand1(null);
                  }
               }
               if(asmOpcode.getMnemonic().equals("ldy") && asmOpcode.getAddressingMode().equals(AsmAddressingMode.IMM)) {
                  String immValue = instruction.getOperand1();
                  AsmProgramStaticRegisterValues.AsmRegisterValues instructionValues = staticValues.getValues(instruction);
                  if(AsmProgramStaticRegisterValues.matchImm(instructionValues.getY(), immValue)) {
                     modified = remove(lineIt);
                  } else if(AsmProgramStaticRegisterValues.matchImm(instructionValues.getA(), immValue)) {
                     getLog().append("Replacing instruction " + instruction + " with TAY");
                     instruction.setAsmOpcode(AsmInstructionSet.getOpcode("tay", AsmAddressingMode.NON, false));
                     instruction.setOperand1(null);
                  }
               }
               if(asmOpcode.getMnemonic().equals("ldy") && (asmOpcode.getAddressingMode().equals(AsmAddressingMode.ZP) || asmOpcode.getAddressingMode().equals(AsmAddressingMode.ABS))) {
                  String memValue = instruction.getOperand1();
                  AsmProgramStaticRegisterValues.AsmRegisterValues instructionValues = staticValues.getValues(instruction);
                  if(instructionValues.getyMem() != null && instructionValues.getyMem().equals(memValue)) {
                     modified = remove(lineIt);
                  } else if(instructionValues.getaMem() != null && instructionValues.getaMem().equals(memValue)) {
                     getLog().append("Replacing instruction " + instruction + " with TAY");
                     instruction.setAsmOpcode(AsmInstructionSet.getOpcode("tay", AsmAddressingMode.NON, false));
                     instruction.setOperand1(null);
                  }
               }
               if(asmOpcode.getMnemonic().equals("clc")) {
                  AsmProgramStaticRegisterValues.AsmRegisterValues instructionValues = staticValues.getValues(instruction);
                  if(Boolean.FALSE.equals(instructionValues.getC())) {
                     modified = remove(lineIt);
                  }
               }
               if(asmOpcode.getMnemonic().equals("sec")) {
                  AsmProgramStaticRegisterValues.AsmRegisterValues instructionValues = staticValues.getValues(instruction);
                  if(Boolean.TRUE.equals(instructionValues.getC())) {
                     modified = remove(lineIt);
                  }
               }
            }
         }
      }
      return modified;
   }

}

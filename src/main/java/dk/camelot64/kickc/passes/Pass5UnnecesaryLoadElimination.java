package dk.camelot64.kickc.passes;

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
               AsmInstructionType instructionType = instruction.getType();

               if(instructionType.getMnemnonic().equals("lda") && instructionType.getAddressingMode().equals(AsmAddressingMode.IMM)) {
                  String immValue = instruction.getParameter();
                  AsmProgramStaticRegisterValues.AsmRegisterValues instructionValues = staticValues.getValues(instruction);
                  if(AsmProgramStaticRegisterValues.matchImm(instructionValues.getA(), immValue)) {
                     modified = remove(lineIt);
                  } else if(AsmProgramStaticRegisterValues.matchImm(instructionValues.getX(), immValue)) {
                     getLog().append("Replacing instruction " + instruction + " with TXA");
                     instruction.setType(AsmInstructionSet.getInstructionType("txa", AsmAddressingMode.NON, false));
                     instruction.setParameter(null);
                  } else if(AsmProgramStaticRegisterValues.matchImm(instructionValues.getY(), immValue)) {
                     getLog().append("Replacing instruction " + instruction + " with TYA");
                     instruction.setType(AsmInstructionSet.getInstructionType("tya", AsmAddressingMode.NON, false));
                     instruction.setParameter(null);
                  }
               }
               if(instructionType.getMnemnonic().equals("lda") && (instructionType.getAddressingMode().equals(AsmAddressingMode.ZP) || instructionType.getAddressingMode().equals(AsmAddressingMode.ABS))) {
                  String memValue = instruction.getParameter();
                  AsmProgramStaticRegisterValues.AsmRegisterValues instructionValues = staticValues.getValues(instruction);
                  if(instructionValues.getaMem() != null && instructionValues.getaMem().equals(memValue)) {
                     modified = remove(lineIt);
                  } else if(instructionValues.getxMem() != null && instructionValues.getxMem().equals(memValue)) {
                     getLog().append("Replacing instruction " + instruction + " with TXA");
                     instruction.setType(AsmInstructionSet.getInstructionType("txa", AsmAddressingMode.NON, false));
                     instruction.setParameter(null);
                  } else if(instructionValues.getyMem() != null && instructionValues.getyMem().equals(memValue)) {
                     getLog().append("Replacing instruction " + instruction + " with TYA");
                     instruction.setType(AsmInstructionSet.getInstructionType("tya", AsmAddressingMode.NON, false));
                     instruction.setParameter(null);
                  }
               }
               if(instructionType.getMnemnonic().equals("ldx") && instructionType.getAddressingMode().equals(AsmAddressingMode.IMM)) {
                  String immValue = instruction.getParameter();
                  AsmProgramStaticRegisterValues.AsmRegisterValues instructionValues = staticValues.getValues(instruction);
                  if(AsmProgramStaticRegisterValues.matchImm(instructionValues.getX(), immValue)) {
                     modified = remove(lineIt);
                  } else if(AsmProgramStaticRegisterValues.matchImm(instructionValues.getA(), immValue)) {
                     getLog().append("Replacing instruction " + instruction + " with TAX");
                     instruction.setType(AsmInstructionSet.getInstructionType("tax", AsmAddressingMode.NON, false));
                     instruction.setParameter(null);
                  }
               }
               if(instructionType.getMnemnonic().equals("ldx") && (instructionType.getAddressingMode().equals(AsmAddressingMode.ZP) || instructionType.getAddressingMode().equals(AsmAddressingMode.ABS))) {
                  String memValue = instruction.getParameter();
                  AsmProgramStaticRegisterValues.AsmRegisterValues instructionValues = staticValues.getValues(instruction);
                  if(instructionValues.getxMem() != null && instructionValues.getxMem().equals(memValue)) {
                     modified = remove(lineIt);
                  } else if(instructionValues.getaMem() != null && instructionValues.getaMem().equals(memValue)) {
                     getLog().append("Replacing instruction " + instruction + " with TAX");
                     instruction.setType(AsmInstructionSet.getInstructionType("tax", AsmAddressingMode.NON, false));
                     instruction.setParameter(null);
                  }
               }
               if(instructionType.getMnemnonic().equals("ldy") && instructionType.getAddressingMode().equals(AsmAddressingMode.IMM)) {
                  String immValue = instruction.getParameter();
                  AsmProgramStaticRegisterValues.AsmRegisterValues instructionValues = staticValues.getValues(instruction);
                  if(AsmProgramStaticRegisterValues.matchImm(instructionValues.getY(), immValue)) {
                     modified = remove(lineIt);
                  } else if(AsmProgramStaticRegisterValues.matchImm(instructionValues.getA(), immValue)) {
                     getLog().append("Replacing instruction " + instruction + " with TAY");
                     instruction.setType(AsmInstructionSet.getInstructionType("tay", AsmAddressingMode.NON, false));
                     instruction.setParameter(null);
                  }
               }
               if(instructionType.getMnemnonic().equals("ldy") && (instructionType.getAddressingMode().equals(AsmAddressingMode.ZP) || instructionType.getAddressingMode().equals(AsmAddressingMode.ABS))) {
                  String memValue = instruction.getParameter();
                  AsmProgramStaticRegisterValues.AsmRegisterValues instructionValues = staticValues.getValues(instruction);
                  if(instructionValues.getyMem() != null && instructionValues.getyMem().equals(memValue)) {
                     modified = remove(lineIt);
                  } else if(instructionValues.getaMem() != null && instructionValues.getaMem().equals(memValue)) {
                     getLog().append("Replacing instruction " + instruction + " with TAY");
                     instruction.setType(AsmInstructionSet.getInstructionType("tay", AsmAddressingMode.NON, false));
                     instruction.setParameter(null);
                  }
               }
               if(instructionType.getMnemnonic().equals("clc")) {
                  AsmProgramStaticRegisterValues.AsmRegisterValues instructionValues = staticValues.getValues(instruction);
                  if(Boolean.FALSE.equals(instructionValues.getC())) {
                     modified = remove(lineIt);
                  }
               }
               if(instructionType.getMnemnonic().equals("sec")) {
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

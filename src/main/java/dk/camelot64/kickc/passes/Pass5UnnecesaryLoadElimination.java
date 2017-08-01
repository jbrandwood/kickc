package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.asm.*;
import dk.camelot64.kickc.asm.AsmProgramStaticRegisterValues;
import dk.camelot64.kickc.icl.Program;

import java.util.ArrayList;
import java.util.List;

/**
 * Maps out register values entering all instructions. Removes unnecessary loads / clears / sets
 */
public class Pass5UnnecesaryLoadElimination extends Pass5AsmOptimization {

   public Pass5UnnecesaryLoadElimination(Program program, CompileLog log) {
      super(program, log);
   }

   @Override
   public boolean optimize() {
      AsmProgramStaticRegisterValues staticValues = new AsmProgramStaticRegisterValues(getAsmProgram());
      List<AsmLine> removes = new ArrayList<>();

      for (AsmSegment segment : getAsmProgram().getSegments()) {
         for (AsmLine line : segment.getLines()) {
            if (line instanceof AsmInstruction) {
               AsmInstruction instruction = (AsmInstruction) line;
               AsmInstructionType instructionType = instruction.getType();
               if (instructionType.getMnemnonic().equals("lda") && instructionType.getAddressingMode().equals(AsmAddressingMode.IMM)) {
                  try {
                     int immValue = Integer.parseInt(instruction.getParameter());
                     AsmProgramStaticRegisterValues.AsmRegisterValues instructionValues = staticValues.getValues(instruction);
                     if (instructionValues.getA() != null && instructionValues.getA().equals(immValue)) {
                        removes.add(instruction);
                     }
                  } catch (NumberFormatException e) {
                     // ignore
                  }
               }
               if (instructionType.getMnemnonic().equals("ldx") && instructionType.getAddressingMode().equals(AsmAddressingMode.IMM)) {
                  try {
                     int immValue = Integer.parseInt(instruction.getParameter());
                     AsmProgramStaticRegisterValues.AsmRegisterValues instructionValues = staticValues.getValues(instruction);
                     if (instructionValues.getX() != null && instructionValues.getX().equals(immValue)) {
                        removes.add(instruction);
                     }
                  } catch (NumberFormatException e) {
                     // ignore
                  }

               }
               if (instructionType.getMnemnonic().equals("ldy") && instructionType.getAddressingMode().equals(AsmAddressingMode.IMM)) {
                  try {
                     int immValue = Integer.parseInt(instruction.getParameter());
                     AsmProgramStaticRegisterValues.AsmRegisterValues instructionValues = staticValues.getValues(instruction);
                     if (instructionValues.getY() != null && instructionValues.getY().equals(immValue)) {
                        removes.add(instruction);
                     }
                  } catch (NumberFormatException e) {
                     // ignore
                  }
               }
               if (instructionType.getMnemnonic().equals("clc")) {
                  AsmProgramStaticRegisterValues.AsmRegisterValues instructionValues = staticValues.getValues(instruction);
                  if (Boolean.FALSE.equals(instructionValues.getC())) {
                     removes.add(instruction);
                  }
               }
               if (instructionType.getMnemnonic().equals("sec")) {
                  AsmProgramStaticRegisterValues.AsmRegisterValues instructionValues = staticValues.getValues(instruction);
                  if (Boolean.TRUE.equals(instructionValues.getC())) {
                     removes.add(instruction);
                  }
               }
            }
         }
      }
      remove(removes);
      return removes.size() > 0;
   }
}

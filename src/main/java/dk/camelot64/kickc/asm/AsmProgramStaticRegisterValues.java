package dk.camelot64.kickc.asm;

import dk.camelot64.kickc.asm.*;
import dk.camelot64.kickc.asm.parser.AsmClobber;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Perform static analysis of an ASM program infering information about the values of registers entering each instruction
 */
public class AsmProgramStaticRegisterValues {

   private AsmProgram program;

   private Map<AsmInstruction, AsmRegisterValues> values;

   public AsmProgramStaticRegisterValues(AsmProgram program) {
      this.program = program;
      this.values = new LinkedHashMap<>();
      initValues();
   }

   public AsmRegisterValues getValues(AsmInstruction instruction) {
      return values.get(instruction);
   }

   private void initValues() {
      AsmRegisterValues current = new AsmRegisterValues();
      for (AsmSegment segment : program.getSegments()) {
         for (AsmLine line : segment.getLines()) {
            current = updateStaticRegisterValues(current, line);
         }
      }
   }

   private AsmRegisterValues updateStaticRegisterValues(AsmRegisterValues current, AsmLine line) {
      if (line instanceof AsmLabel) {
         current = new AsmRegisterValues();
      } else if (line instanceof AsmInstruction) {
         AsmInstruction instruction = (AsmInstruction) line;
         values.put(instruction, current);
         current = new AsmRegisterValues(current);
         AsmInstructionType instructionType = instruction.getType();
         AsmClobber clobber = instructionType.getClobber();
         if (clobber.isClobberA()) {
            current.setA(null);
         }
         if (clobber.isClobberX()) {
            current.setX(null);
         }
         if (clobber.isClobberY()) {
            current.setY(null);
         }
         if (clobber.isClobberC()) {
            current.setC(null);
         }
         if (clobber.isClobberN()) {
            current.setN(null);
         }
         if (clobber.isClobberV()) {
            current.setV(null);
         }
         if (clobber.isClobberZ()) {
            current.setZ(null);
         }
         if (instructionType.getMnemnonic().equals("lda") && instructionType.getAddressingMode().equals(AsmAddressingMode.IMM)) {
            try {
               int immValue = Integer.parseInt(instruction.getParameter());
               current.setZ(immValue == 0);
               current.setN(immValue > 127);
               current.setA(immValue);
            } catch (NumberFormatException e) {
               // ignore
            }
         }
         if (instructionType.getMnemnonic().equals("ldx") && instructionType.getAddressingMode().equals(AsmAddressingMode.IMM)) {
            try {
               int immValue = Integer.parseInt(instruction.getParameter());
               current.setZ(immValue == 0);
               current.setN(immValue > 127);
               current.setX(immValue);
            } catch (NumberFormatException e) {
               // ignore
            }
         }
         if (instructionType.getMnemnonic().equals("ldy") && instructionType.getAddressingMode().equals(AsmAddressingMode.IMM)) {
            try {
               int immValue = Integer.parseInt(instruction.getParameter());
               current.setZ(immValue == 0);
               current.setN(immValue > 127);
               current.setY(immValue);
            } catch (NumberFormatException e) {
               // ignore
            }
         }
         if (instructionType.getMnemnonic().equals("sec")) {
            current.setC(Boolean.TRUE);
         }
         if (instructionType.getMnemnonic().equals("clc")) {
            current.setC(Boolean.FALSE);
         }
      }
      return current;
   }

   /**
    * Known values of registers/flags at an instruction. null where value is unknown.
    */
   public static class AsmRegisterValues {
      private Integer a;
      private Integer x;
      private Integer y;
      private Boolean c;
      private Boolean v;
      private Boolean n;
      private Boolean z;

      public AsmRegisterValues() {
      }

      public AsmRegisterValues(AsmRegisterValues original) {
         this.a = original.getA();
         this.x = original.getX();
         this.y = original.getY();
         this.c = original.getC();
         this.v = original.getV();
         this.n = original.getN();
         this.z = original.getZ();
      }

      public Integer getA() {
         return a;
      }

      public Integer getX() {
         return x;
      }

      public Integer getY() {
         return y;
      }

      public Boolean getC() {
         return c;
      }

      public Boolean getV() {
         return v;
      }

      public Boolean getN() {
         return n;
      }

      public Boolean getZ() {
         return z;
      }

      public void setA(Integer a) {
         this.a = a;
      }

      public void setX(Integer x) {
         this.x = x;
      }

      public void setY(Integer y) {
         this.y = y;
      }

      public void setC(Boolean c) {
         this.c = c;
      }

      public void setV(Boolean v) {
         this.v = v;
      }

      public void setN(Boolean n) {
         this.n = n;
      }

      public void setZ(Boolean z) {
         this.z = z;
      }

   }

}

package dk.camelot64.kickc.asm;

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
      } else if (line instanceof AsmScopeBegin) {
         current = new AsmRegisterValues();
      } else if (line instanceof AsmScopeEnd) {
         current = new AsmRegisterValues();
      } else if (line instanceof AsmInstruction) {
         AsmInstruction instruction = (AsmInstruction) line;
         values.put(instruction, current);
         current = new AsmRegisterValues(current);
         AsmInstructionType instructionType = instruction.getType();
         AsmClobber clobber = instructionType.getClobber();
         if (clobber.isClobberA()) {
            current.setA(null);
            current.setaMem(null);
         }
         if (clobber.isClobberX()) {
            current.setX(null);
            current.setxMem(null);
         }
         if (clobber.isClobberY()) {
            current.setY(null);
            current.setyMem(null);
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
            current.setA(instruction.getParameter());
            current.setaMem(null);

            Integer immValue = getImmValue(instruction.getParameter());
            if (immValue != null) {
               current.setZ(immValue == 0);
               current.setN(immValue > 127);
            }
         }
         if (instructionType.getMnemnonic().equals("sta") && (instructionType.getAddressingMode().equals(AsmAddressingMode.ZP) || instructionType.getAddressingMode().equals(AsmAddressingMode.ABS))) {
            current.setaMem(instruction.getParameter());
         }
         if (instructionType.getMnemnonic().equals("ldx") && instructionType.getAddressingMode().equals(AsmAddressingMode.IMM)) {
            current.setX(instruction.getParameter());
            current.setxMem(null);
            Integer immValue = getImmValue(instruction.getParameter());
            if (immValue != null) {
               current.setZ(immValue == 0);
               current.setN(immValue > 127);
            }
         }
         if (instructionType.getMnemnonic().equals("stx") && (instructionType.getAddressingMode().equals(AsmAddressingMode.ZP) || instructionType.getAddressingMode().equals(AsmAddressingMode.ABS))) {
            current.setxMem(instruction.getParameter());
         }
         if (instructionType.getMnemnonic().equals("ldy") && instructionType.getAddressingMode().equals(AsmAddressingMode.IMM)) {
            current.setY(instruction.getParameter());
            current.setyMem(null);
            Integer immValue = getImmValue(instruction.getParameter());
            if (immValue != null) {
               current.setZ(immValue == 0);
               current.setN(immValue > 127);
            }
         }
         if (instructionType.getMnemnonic().equals("sty") && (instructionType.getAddressingMode().equals(AsmAddressingMode.ZP) || instructionType.getAddressingMode().equals(AsmAddressingMode.ABS))) {
            current.setyMem(instruction.getParameter());
         }
         if (instructionType.getMnemnonic().equals("txa")) {
            current.setA(current.getX());
            current.setaMem(current.getxMem());
         }
         if (instructionType.getMnemnonic().equals("tax")) {
            current.setX(current.getA());
            current.setxMem(current.getaMem());
         }
         if (instructionType.getMnemnonic().equals("tya")) {
            current.setA(current.getY());
            current.setaMem(current.getyMem());
         }
         if (instructionType.getMnemnonic().equals("tay")) {
            current.setY(current.getA());
            current.setyMem(current.getaMem());
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

   public static Integer getImmValue(String parameter) {
      Integer immValue = null;
      if (parameter != null) {
         if(parameter.startsWith("<")) {
            try {
               int parValue = Integer.parseInt(parameter.substring(1));
               return 0xff & parValue;
            } catch (NumberFormatException e) {
               // ignore
            }
         } else if(parameter.startsWith(">")) {
            try {
               int parValue = Integer.parseInt(parameter.substring(1));
               return 0xff & (parValue / 0x100);
            } catch (NumberFormatException e) {
               // ignore
            }
         } else {
            try {
               immValue = Integer.parseInt(parameter);
               return immValue;
            } catch (NumberFormatException e) {
               // ignore
            }
         }
      }
      return immValue;
   }

   public static boolean matchImm(String immVal1, String immVal2) {
      if (immVal1 != null && immVal2 != null && immVal1.equals(immVal2)) {
         return true;
      }
      Integer immInt1 = getImmValue(immVal1);
      Integer immInt2 = getImmValue(immVal2);
      if (immInt1 != null && immInt2 != null && immInt1.equals(immInt2)) {
         return true;
      }
      return false;
   }

   /**
    * Known values of registers/flags at an instruction. null where value is unknown.
    */
   public static class AsmRegisterValues {
      private String a;
      private String x;
      private String y;
      private Boolean c;
      private Boolean v;
      private Boolean n;
      private Boolean z;
      private String aMem;
      private String xMem;
      private String yMem;

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
         this.aMem = original.getaMem();
         this.xMem = original.getxMem();
         this.yMem = original.getyMem();
      }

      public String getA() {
         return a;
      }

      public String getaMem() {
         return aMem;
      }

      public String getX() {
         return x;
      }

      public String getY() {
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

      public void setX(String x) {
         this.x = x;
      }

      public void setY(String y) {
         this.y = y;
      }

      public void setA(String a) {
         this.a = a;
      }

      public void setaMem(String aMem) {
         this.aMem = aMem;
      }

      public String getxMem() {
         return xMem;
      }

      public void setxMem(String xMem) {
         this.xMem = xMem;
      }

      public String getyMem() {
         return yMem;
      }

      public void setyMem(String yMem) {
         this.yMem = yMem;
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

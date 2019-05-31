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

   public static Integer getImmValue(String parameter) {
      Integer immValue = null;
      if(parameter != null) {
         if(parameter.startsWith("<")) {
            try {
               int parValue = Integer.parseInt(parameter.substring(1));
               return 0xff & parValue;
            } catch(NumberFormatException e) {
               // ignore
            }
         } else if(parameter.startsWith(">")) {
            try {
               int parValue = Integer.parseInt(parameter.substring(1));
               return 0xff & (parValue / 0x100);
            } catch(NumberFormatException e) {
               // ignore
            }
         } else {
            try {
               immValue = Integer.parseInt(parameter);
               return immValue;
            } catch(NumberFormatException e) {
               // ignore
            }
         }
      }
      return immValue;
   }

   public static boolean matchImm(String immVal1, String immVal2) {
      if(immVal1 != null && immVal2 != null && immVal1.equals(immVal2)) {
         return true;
      }
      Integer immInt1 = getImmValue(immVal1);
      Integer immInt2 = getImmValue(immVal2);
      if(immInt1 != null && immInt2 != null && immInt1.equals(immInt2)) {
         return true;
      }
      return false;
   }

   public AsmRegisterValues getValues(AsmInstruction instruction) {
      return values.get(instruction);
   }

   private void initValues() {
      AsmRegisterValues current = new AsmRegisterValues();
      for(AsmSegment segment : program.getSegments()) {
         for(AsmLine line : segment.getLines()) {
            current = updateStaticRegisterValues(current, line);
         }
      }
   }

   private AsmRegisterValues updateStaticRegisterValues(AsmRegisterValues current, AsmLine line) {
      if(line instanceof AsmLabel) {
         current = new AsmRegisterValues();
      } else if(line instanceof AsmScopeBegin) {
         current = new AsmRegisterValues();
      } else if(line instanceof AsmScopeEnd) {
         current = new AsmRegisterValues();
      } else if(line instanceof AsmInstruction) {
         AsmInstruction instruction = (AsmInstruction) line;
         values.put(instruction, current);
         current = new AsmRegisterValues(current);
         AsmInstructionType instructionType = instruction.getType();
         AsmClobber clobber = instructionType.getClobber();
         if(instruction.getType().getMnemnonic().equals("jsr")) {
            clobber = AsmClobber.CLOBBER_ALL;
         }
         if(clobber.isClobberA()) {
            current.setA(null);
            current.setaMem(null);
         }
         if(clobber.isClobberX()) {
            current.setX(null);
            current.setxMem(null);
         }
         if(clobber.isClobberY()) {
            current.setY(null);
            current.setyMem(null);
         }
         if(clobber.isClobberC()) {
            current.setC(null);
         }
         if(clobber.isClobberN()) {
            current.setN(null);
         }
         if(clobber.isClobberV()) {
            current.setV(null);
         }
         if(clobber.isClobberZ()) {
            current.setZ(null);
         }
         String mnemnonic = instructionType.getMnemnonic();
         AsmAddressingMode addressingMode = instructionType.getAddressingMode();
         if((mnemnonic.equals("inc") || mnemnonic.equals("dec") || mnemnonic.equals("ror") || mnemnonic.equals("rol") || mnemnonic.equals("lsr") || mnemnonic.equals("asl")) && (addressingMode.equals(AsmAddressingMode.ZP) || addressingMode.equals(AsmAddressingMode.ABS))) {
            String modParam = instruction.getParameter();
            if(current.getaMem() != null && current.getaMem().equals(modParam)) {
               current.setaMem(null);
            }
            if(current.getxMem() != null && current.getxMem().equals(modParam)) {
               current.setxMem(null);
            }
            if(current.getyMem() != null && current.getyMem().equals(modParam)) {
               current.setyMem(null);
            }
         }
         if(mnemnonic.equals("lda") && addressingMode.equals(AsmAddressingMode.IMM)) {
            current.setA(instruction.getParameter());
            current.setaMem(null);
            Integer immValue = getImmValue(instruction.getParameter());
            if(immValue != null) {
               current.setZ(immValue == 0);
               current.setN(immValue > 127);
            }
         }
         if(mnemnonic.equals("lda") && (addressingMode.equals(AsmAddressingMode.ZP) || addressingMode.equals(AsmAddressingMode.ABS))) {
            current.setaMem(instruction.getParameter());
            current.setA(null);
         }
         if(mnemnonic.equals("sta") && (addressingMode.equals(AsmAddressingMode.ZP) || addressingMode.equals(AsmAddressingMode.ABS))) {
            current.setaMem(instruction.getParameter());
            if(instruction.getParameter().equals(current.getyMem())) current.setyMem(null);
            if(instruction.getParameter().equals(current.getxMem())) current.setxMem(null);
         }
         if(mnemnonic.equals("ldx") && addressingMode.equals(AsmAddressingMode.IMM)) {
            current.setX(instruction.getParameter());
            current.setxMem(null);
            Integer immValue = getImmValue(instruction.getParameter());
            if(immValue != null) {
               current.setZ(immValue == 0);
               current.setN(immValue > 127);
            }
         }
         if(mnemnonic.equals("ldx") && (addressingMode.equals(AsmAddressingMode.ZP) || addressingMode.equals(AsmAddressingMode.ABS))) {
            current.setxMem(instruction.getParameter());
            current.setX(null);
         }
         if(mnemnonic.equals("stx") && (addressingMode.equals(AsmAddressingMode.ZP) || addressingMode.equals(AsmAddressingMode.ABS))) {
            current.setxMem(instruction.getParameter());
            if(instruction.getParameter().equals(current.getyMem())) current.setyMem(null);
            if(instruction.getParameter().equals(current.getaMem())) current.setaMem(null);
         }
         if(mnemnonic.equals("ldy") && addressingMode.equals(AsmAddressingMode.IMM)) {
            current.setY(instruction.getParameter());
            current.setyMem(null);
            Integer immValue = getImmValue(instruction.getParameter());
            if(immValue != null) {
               current.setZ(immValue == 0);
               current.setN(immValue > 127);
            }
         }
         if(mnemnonic.equals("ldy") && (addressingMode.equals(AsmAddressingMode.ZP) || addressingMode.equals(AsmAddressingMode.ABS))) {
            current.setyMem(instruction.getParameter());
         }
         if(mnemnonic.equals("sty") && (addressingMode.equals(AsmAddressingMode.ZP) || addressingMode.equals(AsmAddressingMode.ABS))) {
            current.setyMem(instruction.getParameter());
            if(instruction.getParameter().equals(current.getxMem())) current.setxMem(null);
            if(instruction.getParameter().equals(current.getaMem())) current.setaMem(null);
         }
         if(mnemnonic.equals("txa")) {
            current.setA(current.getX());
            current.setaMem(current.getxMem());
         }
         if(mnemnonic.equals("tax")) {
            current.setX(current.getA());
            current.setxMem(current.getaMem());
         }
         if(mnemnonic.equals("tya")) {
            current.setA(current.getY());
            current.setaMem(current.getyMem());
         }
         if(mnemnonic.equals("tay")) {
            current.setY(current.getA());
            current.setyMem(current.getaMem());
         }
         if(mnemnonic.equals("sec")) {
            current.setC(Boolean.TRUE);
         }
         if(mnemnonic.equals("clc")) {
            current.setC(Boolean.FALSE);
         }
      }
      return current;
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

      public void setA(String a) {
         this.a = a;
      }

      public String getaMem() {
         return aMem;
      }

      public void setaMem(String aMem) {
         this.aMem = aMem;
      }

      public String getX() {
         return x;
      }

      public void setX(String x) {
         this.x = x;
      }

      public String getY() {
         return y;
      }

      public void setY(String y) {
         this.y = y;
      }

      public Boolean getC() {
         return c;
      }

      public void setC(Boolean c) {
         this.c = c;
      }

      public Boolean getV() {
         return v;
      }

      public void setV(Boolean v) {
         this.v = v;
      }

      public Boolean getN() {
         return n;
      }

      public void setN(Boolean n) {
         this.n = n;
      }

      public Boolean getZ() {
         return z;
      }

      public void setZ(Boolean z) {
         this.z = z;
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


   }

}

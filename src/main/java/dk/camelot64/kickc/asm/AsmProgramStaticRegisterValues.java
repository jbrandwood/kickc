package dk.camelot64.kickc.asm;

import dk.camelot64.cpufamily6502.CpuAddressingMode;
import dk.camelot64.cpufamily6502.CpuClobber;
import dk.camelot64.cpufamily6502.CpuOpcode;

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
               return 0xff & ((parValue & 0xffff) / 0x100);
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
      for(AsmChunk chunk : program.getChunks()) {
         for(AsmLine line : chunk.getLines()) {
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
         CpuOpcode cpuOpcode = instruction.getCpuOpcode();
         CpuClobber cpuClobber = cpuOpcode.getClobber();
         if(instruction.getCpuOpcode().getMnemonic().equals("jsr")) {
            cpuClobber = CpuClobber.CLOBBER_ALL;
         }
         if(cpuClobber.isRegisterA()) {
            current.setA(null);
            current.setaMem(null);
         }
         if(cpuClobber.isRegisterX()) {
            current.setX(null);
            current.setxMem(null);
         }
         if(cpuClobber.isRegisterY()) {
            current.setY(null);
            current.setyMem(null);
         }
         if(cpuClobber.isRegisterZ()) {
            current.setZ(null);
            current.setzMem(null);
         }
         if(cpuClobber.isFlagC()) {
            current.setFlagC(null);
         }
         if(cpuClobber.isFlagN()) {
            current.setFlagN(null);
         }
         if(cpuClobber.isFlagV()) {
            current.setFlagV(null);
         }
         if(cpuClobber.isFlagZ()) {
            current.setFlagZ(null);
         }
         String mnemnonic = cpuOpcode.getMnemonic();
         CpuAddressingMode addressingMode = cpuOpcode.getAddressingMode();
         if((mnemnonic.equals("inc") || mnemnonic.equals("dec") || mnemnonic.equals("ror") || mnemnonic.equals("rol") || mnemnonic.equals("lsr") || mnemnonic.equals("asl")) && (addressingMode.equals(CpuAddressingMode.ZP) || addressingMode.equals(CpuAddressingMode.ABS))) {
            String modParam = instruction.getOperand1();
            if(current.getaMem() != null && current.getaMem().equals(modParam)) {
               current.setaMem(null);
            }
            if(current.getxMem() != null && current.getxMem().equals(modParam)) {
               current.setxMem(null);
            }
            if(current.getyMem() != null && current.getyMem().equals(modParam)) {
               current.setyMem(null);
            }
            if(current.getzMem() != null && current.getzMem().equals(modParam)) {
               current.setzMem(null);
            }
         }
         if(mnemnonic.equals("lda") && addressingMode.equals(CpuAddressingMode.IMM)) {
            current.setA(instruction.getOperand1());
            current.setaMem(null);
            Integer immValue = getImmValue(instruction.getOperand1());
            if(immValue != null) {
               current.setFlagZ(immValue == 0);
               current.setFlagN(immValue > 127);
            }
         }
         if(mnemnonic.equals("lda") && (addressingMode.equals(CpuAddressingMode.ZP) || addressingMode.equals(CpuAddressingMode.ABS))) {
            current.setaMem(instruction.getOperand1());
            current.setA(null);
         }
         if(mnemnonic.equals("sta") && (addressingMode.equals(CpuAddressingMode.ZP) || addressingMode.equals(CpuAddressingMode.ABS))) {
            current.setaMem(instruction.getOperand1());
            if(instruction.getOperand1().equals(current.getyMem())) current.setyMem(null);
            if(instruction.getOperand1().equals(current.getxMem())) current.setxMem(null);
            if(instruction.getOperand1().equals(current.getzMem())) current.setzMem(null);
         }
         if(mnemnonic.equals("ldx") && addressingMode.equals(CpuAddressingMode.IMM)) {
            current.setX(instruction.getOperand1());
            current.setxMem(null);
            Integer immValue = getImmValue(instruction.getOperand1());
            if(immValue != null) {
               current.setFlagZ(immValue == 0);
               current.setFlagN(immValue > 127);
            }
         }
         if(mnemnonic.equals("ldx") && (addressingMode.equals(CpuAddressingMode.ZP) || addressingMode.equals(CpuAddressingMode.ABS))) {
            current.setxMem(instruction.getOperand1());
            current.setX(null);
         }
         if(mnemnonic.equals("stx") && (addressingMode.equals(CpuAddressingMode.ZP) || addressingMode.equals(CpuAddressingMode.ABS))) {
            current.setxMem(instruction.getOperand1());
            if(instruction.getOperand1().equals(current.getaMem())) current.setaMem(null);
            if(instruction.getOperand1().equals(current.getyMem())) current.setyMem(null);
            if(instruction.getOperand1().equals(current.getzMem())) current.setzMem(null);
         }
         if(mnemnonic.equals("ldy") && addressingMode.equals(CpuAddressingMode.IMM)) {
            current.setY(instruction.getOperand1());
            current.setyMem(null);
            Integer immValue = getImmValue(instruction.getOperand1());
            if(immValue != null) {
               current.setFlagZ(immValue == 0);
               current.setFlagN(immValue > 127);
            }
         }
         if(mnemnonic.equals("ldy") && (addressingMode.equals(CpuAddressingMode.ZP) || addressingMode.equals(CpuAddressingMode.ABS))) {
            current.setyMem(instruction.getOperand1());
         }
         if(mnemnonic.equals("sty") && (addressingMode.equals(CpuAddressingMode.ZP) || addressingMode.equals(CpuAddressingMode.ABS))) {
            current.setyMem(instruction.getOperand1());
            if(instruction.getOperand1().equals(current.getaMem())) current.setaMem(null);
            if(instruction.getOperand1().equals(current.getxMem())) current.setxMem(null);
            if(instruction.getOperand1().equals(current.getzMem())) current.setzMem(null);
         }
         if(mnemnonic.equals("ldz") && addressingMode.equals(CpuAddressingMode.IMM)) {
            current.setZ(instruction.getOperand1());
            current.setzMem(null);
            Integer immValue = getImmValue(instruction.getOperand1());
            if(immValue != null) {
               current.setFlagZ(immValue == 0);
               current.setFlagN(immValue > 127);
            }
         }
         if(mnemnonic.equals("ldz") && (addressingMode.equals(CpuAddressingMode.ZP) || addressingMode.equals(CpuAddressingMode.ABS))) {
            current.setzMem(instruction.getOperand1());
         }
         if(mnemnonic.equals("stz") && (addressingMode.equals(CpuAddressingMode.ZP) || addressingMode.equals(CpuAddressingMode.ABS))) {
            current.setzMem(instruction.getOperand1());
            if(instruction.getOperand1().equals(current.getaMem())) current.setaMem(null);
            if(instruction.getOperand1().equals(current.getxMem())) current.setxMem(null);
            if(instruction.getOperand1().equals(current.getyMem())) current.setyMem(null);
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
         if(mnemnonic.equals("tza")) {
            current.setA(current.getZ());
            current.setaMem(current.getzMem());
         }
         if(mnemnonic.equals("taz")) {
            current.setZ(current.getA());
            current.setzMem(current.getaMem());
         }
         if(mnemnonic.equals("sec")) {
            current.setFlagC(Boolean.TRUE);
         }
         if(mnemnonic.equals("clc")) {
            current.setFlagC(Boolean.FALSE);
         }
      }
      return current;
   }

   /**
    * Known values of registers/flags at an instruction. null where value is unknown.
    */
   public static class AsmRegisterValues {
      private Boolean flagC;
      private Boolean flagV;
      private Boolean flagN;
      private Boolean flagZ;
      private String a;
      private String x;
      private String y;
      private String z;
      private String aMem;
      private String xMem;
      private String yMem;
      private String zMem;

      public AsmRegisterValues() {
      }

      public AsmRegisterValues(AsmRegisterValues original) {
         this.a = original.getA();
         this.x = original.getX();
         this.y = original.getY();
         this.z = original.getZ();
         this.flagZ = original.getFlagZ();
         this.flagC = original.getFlagC();
         this.flagV = original.getFlagV();
         this.flagN = original.getFlagN();
         this.aMem = original.getaMem();
         this.xMem = original.getxMem();
         this.yMem = original.getyMem();
         this.zMem = original.getzMem();
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

      public String getZ() {
         return z;
      }

      public void setZ(String z) {
         this.z = z;
      }

      public Boolean getFlagC() {
         return flagC;
      }

      public void setFlagC(Boolean flagC) {
         this.flagC = flagC;
      }

      public Boolean getFlagV() {
         return flagV;
      }

      public void setFlagV(Boolean flagV) {
         this.flagV = flagV;
      }

      public Boolean getFlagN() {
         return flagN;
      }

      public void setFlagN(Boolean flagN) {
         this.flagN = flagN;
      }

      public Boolean getFlagZ() {
         return flagZ;
      }

      public void setFlagZ(Boolean flagZ) {
         this.flagZ = flagZ;
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

      public String getzMem() {
         return zMem;
      }

      public void setzMem(String zMem) {
         this.zMem = zMem;
      }


   }

}

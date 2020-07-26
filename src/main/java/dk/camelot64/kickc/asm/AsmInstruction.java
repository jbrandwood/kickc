package dk.camelot64.kickc.asm;

import dk.camelot64.cpufamily6502.AsmOpcode;

/** A specific assembler instruction line (opcode, addressing mode and specific parameter value)*/
public class AsmInstruction implements AsmLine {

   private AsmOpcode asmOpcode;

   private String parameter;

   private int index;

   private boolean dontOptimize;

   public AsmInstruction(AsmOpcode asmOpcode, String parameter) {
      this.asmOpcode = asmOpcode;
      this.parameter = parameter;
   }

   public String getParameter() {
      return parameter;
   }

   public void setParameter(String parameter) {
      this.parameter = parameter;
   }

   public AsmOpcode getAsmOpcode() {
      return asmOpcode;
   }

   public void setAsmOpcode(AsmOpcode type) {
      this.asmOpcode = type;
   }

   @Override
   public int getLineBytes() {
      return asmOpcode.getBytes();
   }

   @Override
   public double getLineCycles() {
      return asmOpcode.getCycles();
   }

   @Override
   public String getAsm() {
      return asmOpcode.getAsm(parameter);
   }

   @Override
   public String toString() {
      return getAsm();
   }

   @Override
   public int getIndex() {
      return index;
   }

   @Override
   public void setIndex(int index) {
      this.index = index;
   }

   public boolean isDontOptimize() {
      return dontOptimize;
   }

   public void setDontOptimize(boolean dontOptimize) {
      this.dontOptimize = dontOptimize;
   }
}

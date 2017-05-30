package dk.camelot64.kickc.asm;

import dk.camelot64.kickc.asm.parser.AsmClobber;

/** The instructions of the 6502 assembler instruction set */
public class AsmInstructionType {

   private int opcode;

   private String mnemnonic;

   private AsmAddressingMode addressingMode;

   private double cycles;

   private boolean jump;

   private AsmClobber clobber;

   public AsmInstructionType(int opcode, String mnemnonic, AsmAddressingMode addressingMode, double cycles) {
      this.opcode = opcode;
      this.mnemnonic = mnemnonic;
      this.addressingMode = addressingMode;
      this.cycles = cycles;
      this.clobber = new AsmClobber();
   }

   public String getMnemnonic() {
      return mnemnonic;
   }

   public AsmAddressingMode getAddressingMode() {
      return addressingMode;
   }

   public double getCycles() {
      return cycles;
   }

   public int getBytes() {
      return addressingMode.getBytes();
   }

   public String getAsm(String parameter) {
      return addressingMode.getAsm(mnemnonic, parameter);
   }

   /**
    * Tells if the instruction is a jump or a branch (and the parameter is therefore a label or destination address)
    * @return true if the instruction is a jump/branch
    */
   public boolean isJump() {
      return jump;
   }

   void setJump(boolean jump) {
      this.jump = jump;
   }

   public AsmClobber getClobber() {
      return clobber;
   }
}

package dk.camelot64.cpufamily6502;

/** A specific opcode in the instruction set of a 6502 family CPU. */
public class AsmOpcode {

   /** The opcode of the instruction. */
   private final int opcode;

   /** The mnemonic  of the instruction. */
   private final String mnemnonic;

   /** The addressing mode of the instruction. */
   private final AsmAddressingMode addressingMode;

   /**
    * The number of cycles that executing the instruction takes.
    * Some instructions use different number of cycles under different calling conditions, in that case this is an
    * estimate of the average cycles cost.
    */
   private final double cycles;

   /**
    * True if the instruction is a jump or a branch.
    * A jump is any instruction that can modify the program counter in a way that is not just incrementing it to the
    * next instruction in memory. This includes JSR and RTS.
    */
   private boolean jump;

   /** Which registers/flags of the CPU are clobbered by the instruction. */
   private final AsmClobber clobber;

   public AsmOpcode(int opcode, String mnemnonic, AsmAddressingMode addressingMode, double cycles) {
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

   public int getOpcode() {
      return opcode;
   }

   public String getAsm(String parameter) {
      return addressingMode.getAsm(mnemnonic, parameter);
   }

   /**
    * Tells if the instruction is a jump or a branch
    *
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

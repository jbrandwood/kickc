package dk.camelot64.cpufamily6502;

/** A specific opcode in the instruction set of a 6502 family CPU. */
public class AsmOpcode {

   /** The mnemonic of the instruction. */
   private final String mnemonic;

   /** The addressing mode of the instruction. */
   private final AsmAddressingMode addressingMode;

   /**
    * The byte opcodes of the instruction.
    * Most instructions only have a single byte instruction, but on the 45GS02 the 32-bit instructions are accessed
    * using prefix-bytes and thus effectively have  multiple byte opcodes.
    */
   private final int[] opcode;

   /**
    * The number of cycles that executing the instruction takes.
    * Some instructions use different number of cycles under different calling conditions, in that case this is an
    * estimate of the average cycles cost.
    */
   private final double cycles;

   /** Which registers/flags of the CPU are clobbered by the instruction. */
   private AsmClobber clobber;

   AsmOpcode(int opcode, String mnemonic, AsmAddressingMode addressingMode, double cycles, String clobberString) {
      this.opcode = new int[]{opcode};
      this.mnemonic = mnemonic;
      this.addressingMode = addressingMode;
      this.cycles = cycles;
      this.clobber = new AsmClobber(clobberString);
   }

   /**
    * Get the mnemonic of the instruction
    *
    * @return The mnemonic
    */
   public String getMnemonic() {
      return mnemonic;
   }

   /**
    * Get the addressing mode
    *
    * @return The addressing mdoe
    */
   public AsmAddressingMode getAddressingMode() {
      return addressingMode;
   }

   /**
    * Get the number of CPU cycles that execution of the instruction uses.
    * Some instructions use different number of cycles under different calling conditions, in that case this is an
    * estimate of the average cycles cost.
    *
    * @return The number of cycles.
    */
   public double getCycles() {
      return cycles;
   }

   /**
    * Get the number of bytes the instruction with operands takes up in memory
    *
    * @return The number of bytes.
    */
   public int getBytes() {
      return addressingMode.getBytes();
   }

   /**
    * Get the byte opcode bytes of the instruction.
    * Most instructions only have a single byte instruction, but on the 45GS02 the 32-bit instructions are accessed
    * using prefix-bytes and thus effectively have  multiple byte opcodes.
    *
    * @return The opcode bytes of the instruction.
    */
   public int[] getOpcode() {
      return opcode;
   }

   /**
    * Determines if this instruction has a specific single byte opcode
    * @param opcode The byte opcode to check
    * @return true if this instruction has a 1-byte opcode that matches the passed value.
    */
   public boolean hasOpcode(int opcode) {
      return this.opcode.length==1 && this.opcode[0]==(byte)opcode;
   }

   /**
    * Get the printed ASM code for the instruction with an operand value.
    * This prints to the syntax that KickAssembler expects.
    *
    * @param operand The operand value
    * @return The printed ASM code for the instruction
    */
   public String getAsm(String operand) {
      return addressingMode.getAsm(mnemonic, operand);
   }

   /**
    * Get information about which registers/flags of the CPU are clobbered by the instruction
    *
    * @return The clobber information
    */
   public AsmClobber getClobber() {
      return clobber;
   }

   /**
    * Tells if the instruction is a jump or a branch.
    * A jump is any instruction that can modify the program counter in a way that is not just incrementing it to the
    * next instruction in memory. This includes JSR and RTS.
    *
    * @return true if the instruction is a jump/branch
    */
   public boolean isJump() {
      return clobber.isRegisterPC();
   }

   /**
    * Set the clobber information of the opcode.
    * TODO: Remove this setter and initialize using the constructor instead.
    * @param asmClobber The new clobber information
    */
   public void setClobber(AsmClobber asmClobber) {
      this.clobber = asmClobber;
   }

}

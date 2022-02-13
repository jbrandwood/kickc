package dk.camelot64.cpufamily6502;

import java.util.Arrays;
import java.util.List;

/** A specific opcode in the instruction set of a 6502 family CPU. */
public class CpuOpcode {

   /** The mnemonic of the instruction. */
   private final String mnemonic;

   /** The addressing mode of the instruction. */
   private final CpuAddressingMode addressingMode;

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
   private final CpuClobber clobber;

   CpuOpcode(int[] opcode, String mnemonic, CpuAddressingMode addressingMode, double cycles, String clobberString) {
      this.opcode = opcode;
      this.mnemonic = mnemonic;
      this.addressingMode = addressingMode;
      this.cycles = cycles;
      this.clobber = new CpuClobber(clobberString);
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
   public CpuAddressingMode getAddressingMode() {
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
      return opcode.length + addressingMode.getBytes();
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
    * Get the printed ASM code for the instruction with an operand value.
    * This prints to the syntax that KickAssembler expects.
    *
    * @param operand The operand value. Null if addressing mode is Implied/A/None
    * @param operand2 The second operand value (only used for addressing mode Zeropage Test Relative)
    * @return The printed ASM code for the instruction
    */
   public String getAsm(String operand, String operand2, String operand3) {
      return addressingMode.getAsm(mnemonic, operand, operand2, operand3);
   }

   /**
    * Get information about which registers/flags of the CPU are clobbered by the instruction
    *
    * @return The clobber information
    */
   public CpuClobber getClobber() {
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

   @Override
   public String toString() {
      return
            Arrays.toString(opcode) +     " "+
                  mnemonic + " " + addressingMode.getName() + " - " +
                  "cycles:" +cycles + " " +
                  "clobber:" + clobber.toClobberString()
            ;
   }
}

package dk.camelot64.kickc.asm;

import dk.camelot64.cpufamily6502.AsmAddressingMode;
import dk.camelot64.cpufamily6502.AsmOpcode;
import dk.camelot64.kickc.model.InternalError;

/** A specific assembler instruction line (opcode, addressing mode and specific parameter value) */
public class AsmInstruction implements AsmLine {

   /** The instruction opcode. */
   private AsmOpcode asmOpcode;

   /** The ASM opcode parameter. Null if the opcode addressing mode is Implied/A/None {@link AsmAddressingMode#NON} - eg. DEX */
   private String operand1;

   /** The second ASM opcode parameter. Null if not used. Only used for addressing mode Zeropage Test Relative  {@link AsmAddressingMode#REZ} - eg. BBR0 $12,label */
   private String operand2;

   /** The index of the instruction in the program. */
   private int index;

   /** If true the instruction will not be optimized away. */
   private boolean dontOptimize;

   public AsmInstruction(AsmOpcode asmOpcode) {
      this.asmOpcode = asmOpcode;
      this.operand1 = null;
      this.operand2 = null;
   }

   public AsmInstruction(AsmOpcode asmOpcode, String operand1) {
      this.asmOpcode = asmOpcode;
      this.operand1 = operand1;
      this.operand2 = null;
   }

   public AsmInstruction(AsmOpcode asmOpcode, String operand1, String operand2) {
      this.asmOpcode = asmOpcode;
      this.operand1 = operand1;
      this.operand2 = operand2;
   }

   public String getOperand1() {
      return operand1;
   }

   public void setOperand1(String operand1) {
      this.operand1 = operand1;
   }

   public String getOperand2() {
      return operand2;
   }

   public void setOperand2(String operand2) {
      this.operand2 = operand2;
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
      return asmOpcode.getAsm(operand1, operand2);
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

   /***
    * Get the operand value that represents a jump target (if the opcode is a jump as defined by {@link AsmOpcode#isJump()}
    * @return The jump target operand
    */
   public String getOperandJumpTarget() {
      if(asmOpcode.isJump()) {
         if(AsmAddressingMode.REZ.equals(asmOpcode.getAddressingMode())) {
            // For addressing mode Zeropage Test Relative the jump target is operand2: bbr0 zp,rel
            return operand2;
         } else {
            // For all other jump addressing modes jump target is operand1
            return operand1;
         }
      } else
         // Not a jump
         return null;
   }

   /***
    * Set the operand value that represents a jump target (if the opcode is a jump as defined by {@link AsmOpcode#isJump()}
    * @param operand The new jump target operand
    */
   public void setOperandJumpTarget(String operand) {
      if(asmOpcode.isJump()) {
         if(AsmAddressingMode.REZ.equals(asmOpcode.getAddressingMode())) {
            // For addressing mode Zeropage Test Relative the jump target is operand2: bbr0 zp,rel
            operand2 = operand;
         } else {
            // For all other jump addressing modes jump target is operand1
            operand1 = operand;
         }
      } else {
         throw new InternalError("Error! Instruction is not a jump "+getAsm());
      }

   }



   }

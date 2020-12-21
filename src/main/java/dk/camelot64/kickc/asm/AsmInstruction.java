package dk.camelot64.kickc.asm;

import dk.camelot64.cpufamily6502.CpuAddressingMode;
import dk.camelot64.cpufamily6502.CpuOpcode;
import dk.camelot64.kickc.model.InternalError;

/** A specific assembler instruction line (opcode, addressing mode and specific parameter value) */
public class AsmInstruction extends AsmLine {

   /** The instruction opcode. */
   private CpuOpcode cpuOpcode;

   /** The ASM opcode parameter. Null if the opcode addressing mode is Implied/A/None {@link CpuAddressingMode#NON} - eg. DEX */
   private String operand1;

   /** The second ASM opcode parameter. Null if not used. Only used for addressing mode Zeropage Test Relative  {@link CpuAddressingMode#REZ} - eg. BBR0 $12,label */
   private String operand2;

   public AsmInstruction(CpuOpcode cpuOpcode, String operand1, String operand2) {
      this.cpuOpcode = cpuOpcode;
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

   public CpuOpcode getCpuOpcode() {
      return cpuOpcode;
   }

   public void setCpuOpcode(CpuOpcode type) {
      this.cpuOpcode = type;
   }

   @Override
   public int getLineBytes() {
      return cpuOpcode.getBytes();
   }

   @Override
   public double getLineCycles() {
      return cpuOpcode.getCycles();
   }

   @Override
   public String getAsm() {
      return cpuOpcode.getAsm(operand1, operand2);
   }

   @Override
   public String toString() {
      return getAsm();
   }

   /***
    * Get the operand value that represents a jump target (if the opcode is a jump as defined by {@link CpuOpcode#isJump()}
    * @return The jump target operand
    */
   public String getOperandJumpTarget() {
      if(cpuOpcode.isJump()) {
         if(CpuAddressingMode.REZ.equals(cpuOpcode.getAddressingMode())) {
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
    * Set the operand value that represents a jump target (if the opcode is a jump as defined by {@link CpuOpcode#isJump()}
    * @param operand The new jump target operand
    */
   public void setOperandJumpTarget(String operand) {
      if(cpuOpcode.isJump()) {
         if(CpuAddressingMode.REZ.equals(cpuOpcode.getAddressingMode())) {
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

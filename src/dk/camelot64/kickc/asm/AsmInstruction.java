package dk.camelot64.kickc.asm;

/** An assembler instruction */
public class AsmInstruction implements AsmLine {

   private AsmInstructionType type;

   private String parameter;

   private int invocationCountEstimate;

   public AsmInstruction(AsmInstructionType type, String parameter, int invocationCountEstimate) {
      this.type = type;
      this.parameter = parameter;
      this.invocationCountEstimate = invocationCountEstimate;
   }

   public String getParameter() {
      return parameter;
   }

   public AsmInstructionType getType() {
      return type;
   }

   @Override
   public int getLineBytes() {
      return type.getBytes();
   }

   @Override
   public double getLineCycles() {
      return type.getCycles();
   }

   @Override
   public int getInvocationCountEstimate() {
      return invocationCountEstimate;
   }

   @Override
   public double getEstimatedTotalCycles() {
      return getInvocationCountEstimate()*getLineCycles();
   }


   @Override
   public String getAsm() {
      return type.getAsm(parameter);
   }


}

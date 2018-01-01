package dk.camelot64.kickc.asm;

/** An assembler instruction */
public class AsmInstruction implements AsmLine {

   private AsmInstructionType type;

   private String parameter;

   private int index;

   public AsmInstruction(AsmInstructionType type, String parameter) {
      this.type = type;
      this.parameter = parameter;
   }

   public String getParameter() {
      return parameter;
   }

   public void setParameter(String parameter) {
      this.parameter = parameter;
   }

   public AsmInstructionType getType() {
      return type;
   }

   public void setType(AsmInstructionType type) {
      this.type = type;
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
   public String getAsm() {
      return type.getAsm(parameter);
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
}

package dk.camelot64.kickc.asm;

/** A labelled string data directive. */
public class AsmDataString extends AsmLine {

   private String label;
   private String value;

   public AsmDataString(String label, String value) {
      this.label = label;
      this.value = value;
   }

   @Override
   public int getLineBytes() {
      return value.length();
   }

   @Override
   public double getLineCycles() {
      return 0;
   }

   @Override
   public String getAsm() {
      StringBuilder asm = new StringBuilder();
      if(label!=null)
         asm.append(label + ": ");
      asm.append(".text ");
      asm.append(value);
      return asm.toString();
   }

}

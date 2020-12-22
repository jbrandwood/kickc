package dk.camelot64.kickc.asm;

/** Data alignment directive. */
public class AsmDataAlignment extends AsmLine {

   private String alignment;

   public AsmDataAlignment(String alignment) {
      this.alignment = alignment;
   }

   @Override
   public int getLineBytes() {
      return 0;
   }

   @Override
   public double getLineCycles() {
      return 0;
   }

   @Override
   public String getAsm() {
      StringBuilder asm = new StringBuilder();
      asm.append(".align ");
      asm.append(alignment);
      return asm.toString();
   }

}

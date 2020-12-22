package dk.camelot64.kickc.asm;

/** The beginning of a named scope (typically a procedure) */
public class AsmScopeBegin extends AsmLine {

   private String label;

   public AsmScopeBegin(String label) {
      this.label = label;
   }

   public String getLabel() {
      return label;
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
      return label + ":" + " {";
   }

   @Override
   public String toString() {
      return getAsm();
   }

}

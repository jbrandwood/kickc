package dk.camelot64.kickc.asm;

/** The beginning of a named scope (typically a procedure) */
public class AsmScopeBegin implements AsmLine {

   private String label;

   private int index;

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
   public int getIndex() {
      return index;
   }

   @Override
   public void setIndex(int index) {
      this.index = index;
   }

   @Override
   public String toString() {
      return getAsm();
   }

}

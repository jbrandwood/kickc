package dk.camelot64.kickc.asm;

/** A label / jump target */
public class AsmLabel extends AsmLine {

   private String label;

   private boolean dontOptimize;

   public AsmLabel(String label) {
      this.label = label;
   }

   public String getLabel() {
      return label;
   }

   public void setLabel(String label) {
      this.label = label;
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
      return label + ":";
   }

   public boolean isDontOptimize() {
      return dontOptimize;
   }

   public void setDontOptimize(boolean dontOptimize) {
      this.dontOptimize = dontOptimize;
   }

   @Override
   public String toString() {
      return getAsm();
   }
}

package dk.camelot64.kickc.asm;

/** Set the program counter */
public class AsmBasicUpstart implements AsmLine {

   private String label;
   private int index;

   public AsmBasicUpstart(String label) {
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
      return ":BasicUpstart(" + label + ")";
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

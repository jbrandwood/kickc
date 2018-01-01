package dk.camelot64.kickc.asm;

/** Set the program counter */
public class AsmBasicUpstart implements AsmLine {

   private final String function;
   private int index;

   public AsmBasicUpstart(String function) {
      this.function = function;
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
      return ":BasicUpstart(" + function + ")";
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

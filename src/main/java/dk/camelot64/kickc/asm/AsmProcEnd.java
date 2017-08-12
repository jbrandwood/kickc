package dk.camelot64.kickc.asm;

/** The end of a procedure (scope)  */
public class AsmProcEnd implements AsmLine {

   private int index;

   public AsmProcEnd() {
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
      return "}";
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

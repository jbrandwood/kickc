package dk.camelot64.kickc.asm;

/** The end of a scope */
public class AsmScopeEnd extends AsmLine {

   public AsmScopeEnd() {
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
   public String toString() {
      return getAsm();
   }

}

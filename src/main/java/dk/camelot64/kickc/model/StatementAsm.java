package dk.camelot64.kickc.model;

/** Inline ASM code */
public class StatementAsm extends StatementBase {

   /** ASM Fragment code. */
   private String asmFragment;

   public StatementAsm(String asmFragment) {
      super(null);
      this.asmFragment = asmFragment;
   }

   @Override
   public String toString(Program program) {
      return "asm { "+asmFragment+" }";
   }

   public String getAsmFragment() {
      return asmFragment;
   }
}

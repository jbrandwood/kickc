package dk.camelot64.kickc.asm;

/** A labelled data array initialized by kickasm code. */
public class AsmDataKickAsm extends AsmLine {

   private String label;

   private int bytes;

   private String kickAsmCode;

   public AsmDataKickAsm(String label, int bytes, String kickAsmCode) {
      this.label = label;
      this.bytes = bytes;
      this.kickAsmCode = kickAsmCode;
   }

   public String getKickAsmCode() {
      return kickAsmCode;
   }

   public void setKickAsmCode(String kickAsmCode) {
      this.kickAsmCode = kickAsmCode;
   }

   @Override
   public int getLineBytes() {
      return bytes;
   }

   @Override
   public double getLineCycles() {
      return 0;
   }

   @Override
   public String getAsm() {
      StringBuilder asm = new StringBuilder();
      asm.append(label + ":\n");
      asm.append(kickAsmCode);
      return asm.toString();
   }

   /**
    * Get the number of source lines in the inline assembler code (for line indexing)
    *
    * @return The number of source lines
    */
   public long getLineCount() {
      return kickAsmCode.chars().filter(x -> x == '\n').count() + 2;
   }

}

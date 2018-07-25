package dk.camelot64.kickc.asm;

/**
 * Inlined KickAssembler code.
 * If no cycles/byte size is specified it defaults to 256/256.
 */
public class AsmInlineKickAsm implements AsmLine {

   private String kickAsmCode;

   private int index;

   private int bytes;

   private double cycles;

   public AsmInlineKickAsm(String kickAsmCode, Long bytes, Long cycles) {
      this.kickAsmCode = kickAsmCode;
      if(bytes != null) {
         this.bytes = bytes.intValue();
      } else {
         this.bytes = 256;
      }
      if(cycles != null) {
         this.cycles = cycles;
      } else {
         this.cycles = 256;
      }
   }

   public String getKickAsmCode() {
      return kickAsmCode;
   }

   public void setKickAsmCode(String kickAsmCode) {
      this.kickAsmCode = kickAsmCode;
   }

   /**
    * Get the number of source lines in the inline assembler code (for line indexing)
    *
    * @return The number of source lines
    */
   public long getLineCount() {
      return kickAsmCode.chars().filter(x -> x == '\n').count() + 1;
   }

   @Override
   public int getLineBytes() {
      return bytes;
   }

   @Override
   public double getLineCycles() {
      return cycles;
   }

   public void setBytes(int bytes) {
      this.bytes = bytes;
   }

   public void setCycles(double cycles) {
      this.cycles = cycles;
   }

   @Override
   public String getAsm() {
      return kickAsmCode;
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

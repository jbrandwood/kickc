package dk.camelot64.kickc.asm;

/** Inlined KickAssembler code.
 * If no cycles/byte size is specified it defaults to 100/100.
 *  */
public class AsmInlineKickAsm implements AsmLine {

   private String kickAsmCode;

   private int index;

   private int bytes = 100;

   private double cycles = 100;

   public AsmInlineKickAsm(String kickAsmCode) {
      this.kickAsmCode= kickAsmCode;
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

package dk.camelot64.kickc.asm;

import dk.camelot64.kickc.model.values.StringEncoding;

/** Set the text encoding */
public class AsmSetEncoding implements AsmLine {

   private final StringEncoding encoding;
   private int index;

   public AsmSetEncoding(StringEncoding encoding) {
      this.encoding = encoding;
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
      return ".encoding \"" + encoding.asmEncoding+ "\"";
   }

   @Override
   public int getIndex() {
      return index;
   }

   @Override
   public void setIndex(int index) {
      this.index = index;
   }

   public StringEncoding getEncoding() {
      return encoding;
   }
}

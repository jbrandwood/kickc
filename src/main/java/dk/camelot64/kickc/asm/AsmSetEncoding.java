package dk.camelot64.kickc.asm;

import dk.camelot64.kickc.model.values.StringEncoding;

/** Set the text encoding */
public class AsmSetEncoding extends AsmLine {

   private final StringEncoding encoding;

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

   public StringEncoding getEncoding() {
      return encoding;
   }
}

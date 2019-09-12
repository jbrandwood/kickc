package dk.camelot64.kickc.asm;

import dk.camelot64.kickc.model.values.ConstantString;

/** Set the text encoding */
public class AsmSetEncoding implements AsmLine {

   private final ConstantString.Encoding encoding;
   private int index;

   public AsmSetEncoding(ConstantString.Encoding encoding) {
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
      return ".encoding \"" + encoding.name+ "\"";
   }

   @Override
   public int getIndex() {
      return index;
   }

   @Override
   public void setIndex(int index) {
      this.index = index;
   }

   public ConstantString.Encoding getEncoding() {
      return encoding;
   }
}

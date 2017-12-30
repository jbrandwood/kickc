package dk.camelot64.kickc.asm;

import dk.camelot64.kickc.fragment.AsmFormat;

/** A labelled numeric data directive. */
public class AsmDataFill implements AsmLine {

   private String label;
   private AsmDataNumeric.Type type;
   private int size;
   private String fillValue;
   private int index;


   public AsmDataFill(String label, AsmDataNumeric.Type type, int size, String fillValue) {
      this.label = label;
      this.type = type;
      this.size = size;
      this.fillValue = fillValue;
   }

   public int getElementBytes() {
      return type.bytes;
   }

   @Override
   public int getLineBytes() {
      return size*getElementBytes();
   }

   @Override
   public double getLineCycles() {
      return 0;
   }

   @Override
   public String getAsm() {
      StringBuilder asm = new StringBuilder();
      asm.append(label+": ");
      asm.append(".fill ");
      asm.append(AsmFormat.getAsmNumber(size*type.bytes));
      asm.append(", ");
      asm.append(fillValue);
      return asm.toString();
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

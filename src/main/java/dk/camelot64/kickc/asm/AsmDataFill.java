package dk.camelot64.kickc.asm;

/** A labelled numeric data directive. */
public class AsmDataFill implements AsmLine {

   private String label;
   /** The calculation of the total number of bytes in ASM-format */
   private String totalByteSizeAsm;
   /** The type of value being filled with. */
   private AsmDataNumeric.Type type;
   /** The number of elements*/
   private int numElements;
   /** The value to fill with in ASM-format */
   private String fillValue;

   private int index;


   public AsmDataFill(String label, AsmDataNumeric.Type type, String totalByteSizeAsm, int numElements, String fillValue) {
      this.label = label;
      this.type = type;
      this.totalByteSizeAsm = totalByteSizeAsm;
      this.numElements = numElements;
      this.fillValue = fillValue;
   }

   public int getElementBytes() {
      return type.bytes;
   }

   @Override
   public int getLineBytes() {
      return numElements * getElementBytes();
   }

   @Override
   public double getLineCycles() {
      return 0;
   }

   @Override
   public String getAsm() {
      StringBuilder asm = new StringBuilder();
      if(label!=null) {
         asm.append(label + ": ");
      }
      asm.append(".fill ");
      asm.append(totalByteSizeAsm);
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

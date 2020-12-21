package dk.camelot64.kickc.asm;

/** A labelled zero-filled data directive. */
public class AsmDataZeroFill extends AsmLine {

   private String label;
   /** The calculation of the total number of bytes in ASM-format */
   private String totalByteSizeAsm;
   /** The type of value being filled with. */
   private AsmDataNumeric.Type type;
   /** The number of elements*/
   private int numElements;

   public AsmDataZeroFill(String label, AsmDataNumeric.Type type, String totalByteSizeAsm, int numElements) {
      this.label = label;
      this.type = type;
      this.totalByteSizeAsm = totalByteSizeAsm;
      this.numElements = numElements;
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
      asm.append(", 0");
      return asm.toString();
   }

}

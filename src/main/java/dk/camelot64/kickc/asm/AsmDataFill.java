package dk.camelot64.kickc.asm;

/** A labelled numeric data directive. */
public class AsmDataFill implements AsmLine {

   private String label;
   private AsmDataNumeric.Type type;
   private String sizeAsm;
   private int size;
   private String fillValue;
   private int index;


   public AsmDataFill(String label, AsmDataNumeric.Type type, String sizeAsm, int size, String fillValue) {
      this.label = label;
      this.type = type;
      this.sizeAsm = sizeAsm;
      this.size = size;
      this.fillValue = fillValue;
   }

   public int getElementBytes() {
      return type.bytes;
   }

   @Override
   public int getLineBytes() {
      return size * getElementBytes();
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
      asm.append(sizeAsm);
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

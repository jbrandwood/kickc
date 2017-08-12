package dk.camelot64.kickc.asm;

/** A procedure - representing a label and a scope beginning*/
public class AsmProcBegin implements AsmLine {

   private String label;

   private int index;

   public AsmProcBegin(String label) {
      this.label = label;
   }

   public String getLabel() {
      return label;
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
      return label+":"+" {";
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

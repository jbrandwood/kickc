package dk.camelot64.kickc.asm;

/** A label declaration .label lbl = val */
public class AsmLabelDecl implements AsmLine {
   private final String name;
   private final String value;
   private int index;


   public AsmLabelDecl(String name, String value) {
      this.name = name;
      this.value = value;
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
      return ".label " + name + " = " + value;
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

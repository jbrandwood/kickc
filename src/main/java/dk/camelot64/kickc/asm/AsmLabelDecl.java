package dk.camelot64.kickc.asm;

import dk.camelot64.kickc.fragment.AsmFormat;

/** A label declaration .label lbl = val  */
public class AsmLabelDecl implements AsmLine {
   private final String name;
   private final int address;
   private int index;


   public AsmLabelDecl(String name, int address) {
      this.name = name;
      this.address = address;
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
      return ".label "+name+" = "+ AsmFormat.getAsmNumber(address);
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

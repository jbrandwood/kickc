package dk.camelot64.kickc.asm;

import dk.camelot64.kickc.fragment.AsmFormat;

/** Set the program counter */
public class AsmSetPc implements AsmLine {

   private final String name;
   private final String address;
   private int index;

   public AsmSetPc(String name, String address) {
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
      return ".pc = " + address + " \"" + name + "\"";
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

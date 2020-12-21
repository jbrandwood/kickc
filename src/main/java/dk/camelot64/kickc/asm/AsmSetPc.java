package dk.camelot64.kickc.asm;

/** Set the program counter */
public class AsmSetPc extends AsmLine {

   private final String name;
   private final String address;

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

}

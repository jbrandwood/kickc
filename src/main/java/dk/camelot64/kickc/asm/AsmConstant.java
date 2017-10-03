package dk.camelot64.kickc.asm;

/** ASM constant declaration  */
public class AsmConstant implements AsmLine {
   private final String name;
   private final String value;
   private int index;


   public AsmConstant(String name, String value) {
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
      return ".const "+name+" = "+value;
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

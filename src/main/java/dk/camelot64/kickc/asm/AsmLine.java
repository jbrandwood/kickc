package dk.camelot64.kickc.asm;

/** A line of 6502 assembler code */
public abstract class AsmLine {

   private int index;

   private AsmTags tags;

   public AsmLine() {
      this.tags = new AsmTags();
   }

   public abstract int getLineBytes();

   public abstract double getLineCycles();

   public abstract String getAsm();

   public int getIndex() {
      return index;
   }

   public void setIndex(int index) {
      this.index = index;
   }

   /**
    * Get the tags of the ASM line.
    * <p>
    * Tags are used by the compiler for marking up ASM lines in fragments that the compiler should treat in different ways
    *
    * @return The tags of the ASM line
    */
   public AsmTags getTags() {
      return tags;
   }

}

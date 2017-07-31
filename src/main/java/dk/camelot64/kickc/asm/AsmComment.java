package dk.camelot64.kickc.asm;

/** An assember comment */
public class AsmComment implements AsmLine {

   private String comment;

   private int index;

   public AsmComment(String comment) {
      this.comment = comment;
   }

   public String getComment() {
      return comment;
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
      return "// "+comment;
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

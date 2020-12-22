package dk.camelot64.kickc.asm;

/** An assembler comment */
public class AsmComment extends AsmLine {

   private String comment;

   private boolean isBlock;

   public AsmComment(String comment, boolean isBlock) {
      this.comment = comment;
      this.isBlock = isBlock;
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
      if(isBlock) {
         return "/*" + comment + "*/";

      } else {
         return "//" + comment;
      }
   }

   @Override
   public String toString() {
      return getAsm();
   }

   /**
    * Get the number of lines the comment has
    *
    * @return The number of lines
    */
   public long getLineCount() {
      return comment.chars().filter(x -> x == '\n').count() + 1;
   }

}

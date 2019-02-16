package dk.camelot64.kickc.model;

/**
 * A comment in the source code.
 * Comments are attached to symbols and statements and
 * can be output in the generated assembler code.
 **/
public class Comment {

   private String comment;

   public Comment(String comment) {
      this.comment = comment;
   }

   public String getComment() {
      return comment;
   }

}

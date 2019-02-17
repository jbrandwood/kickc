package dk.camelot64.kickc.model;

/**
 * A comment in the source code.
 * Comments are attached to symbols and statements and
 * can be output in the generated assembler code.
 **/
public class Comment {

   private String comment;

   /** The index of the hidden parser token containing the comment.
    * Used to prevent comments from being included multiple times.
    */
   private int tokenIndex;

   public Comment(String comment) {
      this.comment = comment;
   }

   public String getComment() {
      return comment;
   }

   public int getTokenIndex() {
      return tokenIndex;
   }

   public void setTokenIndex(int tokenIndex) {
      this.tokenIndex = tokenIndex;
   }
}

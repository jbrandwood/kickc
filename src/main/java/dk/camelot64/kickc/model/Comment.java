package dk.camelot64.kickc.model;

import java.io.Serializable;
import java.util.ArrayList;

/**
 * A comment in the source code.
 * Comments are attached to symbols and statements and
 * can be output in the generated assembler code.
 **/
public class Comment implements Serializable {

   /** Empty comments collection. */
   public static final ArrayList<Comment> NO_COMMENTS = new ArrayList<>();

   /** The comment. */
   private String comment;

   /** Specifies whether the comment is a block-comment. If false the comment is a single-line comment. */
   private boolean isBlock;

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

   public boolean isBlock() {
      return isBlock;
   }

   public void setBlock(boolean block) {
      isBlock = block;
   }
}

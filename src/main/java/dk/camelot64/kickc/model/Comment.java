package dk.camelot64.kickc.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Objects;

/**
 * A comment in the source code.
 * Comments are attached to symbols and statements and
 * can be output in the generated assembler code.
 **/
public class Comment implements Serializable {

   /** Empty comments collection. */
   public static final ArrayList<Comment> NO_COMMENTS = new ArrayList<>();

   /** Special comment used for constructor calls in __init(). */
   public static final Comment CONSTRUCTOR = new Comment("#pragma constructor");

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

   @Override
   public boolean equals(Object o) {
      if(this == o) return true;
      if(o == null || getClass() != o.getClass()) return false;
      Comment comment1 = (Comment) o;
      return isBlock == comment1.isBlock &&
            tokenIndex == comment1.tokenIndex &&
            Objects.equals(comment, comment1.comment);
   }

   @Override
   public int hashCode() {
      return Objects.hash(comment, isBlock, tokenIndex);
   }
}

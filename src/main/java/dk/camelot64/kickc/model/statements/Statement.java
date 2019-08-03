package dk.camelot64.kickc.model.statements;


import dk.camelot64.kickc.model.Comment;
import dk.camelot64.kickc.model.Program;

import java.io.Serializable;
import java.util.List;

/**
 * Single Static Assignment Form Statement.
 * Intermediate form used for compiler optimization.
 */
public interface Statement extends Serializable {

   String toString(Program program, boolean aliveInfo);

   /** Get the index of the statement. Indexes are used during live range analysis. */
   Integer getIndex();

   /** Set the index of the statement. Indexes are used during live range analysis. */
   void setIndex(Integer idx);

   /** Get the source for the statement */
    StatementSource getSource();

   /** Set the source for the statement */
   void setSource(StatementSource source);

   /** Get the comments  of the statement */
   List<Comment> getComments();

   /** Get the comments  of the statement */
   void setComments(List<Comment> comments);

}

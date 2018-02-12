package dk.camelot64.kickc.model;


/**
 * Single Static Assignment Form Statement.
 * Intermediate form used for compiler optimization.
 */
public interface Statement {

   String toString(Program program, boolean aliveInfo);

   /** Get the index of the statement. Indexes are used during live range analysis. */
   Integer getIndex();

   /** Set the index of the statement. Indexes are used during live range analysis. */
   void setIndex(Integer idx);
}

package dk.camelot64.kickc.icl;

import java.util.ArrayList;
import java.util.List;

/**
 * The range, where a variable or set of variables are alive. The live ranges require all statements of the program graph to be indexed as it is stored using statement indices.
 * <p>
 * The definition of a variable being alive during a statement is that it is used after the statement by some later instruction in the flow.
 * Note especially that a variable is not alive in the very last instruction that uses it. (Ie. in the statement x := y the variable y is not alive if it is not used again later. However in the preceding statement it is alive.)
 */
public class LiveRange {

   /**
    * Sorted non-overlapping intervals.
    */
   private List<LiveInterval> intervals;

   public static class LiveInterval {

      /**
       * The statement index of the first statement where the variable is assigned.
       */
      private int firstStatementIdx;

      /**
       * The statement index of the las statement where the variable alive when the statement ends.
       * <ul><li>
       * If the statement is in the middle of a block:
       * The variable is always used in the following statement for assignment or calculation - but never after.
       * </li><li>
       * If  the statement is the last in a block:
       * The variable is available for use in the first statement of following blocks. There the interval may "continue" as another interval - or it may end if the variable is used in the phi-block, and then no more.
       * </li></ul>
       */
      private int lastStatementIdx;

      public LiveInterval(int firstStatementIdx, int lastStatementIdx) {
         this.firstStatementIdx = firstStatementIdx;
         this.lastStatementIdx = lastStatementIdx;
      }

      public int getFirstStatementIdx() {
         return firstStatementIdx;
      }

      public int getLastStatementIdx() {
         return lastStatementIdx;
      }
   }

   public LiveRange() {
      this.intervals = new ArrayList<>();
   }

   /**
    * Add a statement to the live range
    *
    * @param statement The statement to add
    * @return true if the live range was modified by the addition. false otherwise
    */
   public boolean add(Statement statement) {
      return add(getIndex(statement));
   }

   private Integer getIndex(Statement statement) {
      Integer index = statement.getIndex();
      if (index == null) {
         throw new RuntimeException("Statement index not defined! Live Ranges only work after defining statement indexes (Pass3LiveRangesAnalysis.generateStatementIndexes).");
      }
      return index;
   }

   /**
    * Add an index to the live range
    * @param index The index to add
    * @return true if the live range was modified. false otherwise
    */
   public boolean add(int index) {
      for (int i = 0; i < intervals.size(); i++) {
         LiveInterval interval = intervals.get(i);
         if (index < interval.firstStatementIdx - 1) {
            // Add new interval before the current interval
            intervals.add(i, new LiveInterval(index, index));
            return true;
         } else if(index == interval.firstStatementIdx - 1) {
            // Extend the current interval downward
            interval.firstStatementIdx = index;
            return true;
         } else if(index <= interval.lastStatementIdx) {
            // Already inside the interval
            return false;
         } else if(index == interval.lastStatementIdx+1) {
            // Extend current interval upward - and check if next interval should be merged
            interval.lastStatementIdx = index;
            if(i<intervals.size()-1) {
               LiveInterval nextInterval = intervals.get(i + 1);
               if(nextInterval.firstStatementIdx==index+1) {
                  // Merge intervals
                  interval.lastStatementIdx = nextInterval.lastStatementIdx;
                  intervals.remove(i+1);
               }
            }
            return true;
         }
      }
      // Not added yet - add a new interval at the end
      intervals.add(new LiveInterval(index, index));
      return true;
   }

   /**
    * Determines if this live range overlaps another live range
    * @param other The other live range
    * @return true if there is an overlap
    */
   public boolean overlaps(LiveRange other) {
      if(this.getMaxIndex()==-1 || other.getMaxIndex()==-1) {
         return false;
      }
      int maxIdx = getMaxIndex();
      for(int i=0;i<=maxIdx; i++) {
         if(contains(i) && other.contains(i)) {
            return true;
         }
      }
      return false;
   }

   /**
    * Adds another live range to this one - extending this live range to include the other one.
    * @param other The live range to add
    */
   public void add(LiveRange other) {
      int otherMaxIndex = other.getMaxIndex();
      for(int i=0;i<=otherMaxIndex; i++) {
         if(other.contains(i)) {
            add(i);
         }
      }
   }

   /**
    * Determines if the live range contains a statement
    * @param statement The statement to examine
    * @return true if the live range contains the statement
    */
   public boolean contains(Statement statement) {
      return contains(getIndex(statement));
   }

   /**
    * Determines if the live range contains an index
    * @param index
    * @return true if the live range contains the index
    */
   private boolean contains(int index) {
      for (LiveInterval interval : intervals) {
         if(interval.lastStatementIdx>=index) {
            if(interval.firstStatementIdx<=index) {
               return true;
            } else {
               return false;
            }
         }
      }
      return false;
   }

   /**
    * Get the maximal index contained in the live range
    * @return The max index. -1 if the range is empty.
    */
   int getMaxIndex() {
      if(intervals.isEmpty()) {
         return -1;
      }
      return intervals.get(intervals.size()-1).lastStatementIdx;
   }


}

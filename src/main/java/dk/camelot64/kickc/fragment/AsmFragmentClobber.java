package dk.camelot64.kickc.fragment;

import dk.camelot64.kickc.asm.AsmClobber;

/** The clobber profile for a fragment template. Only distinguishes the 3 registers A/X/Y and not the flags. */
public class AsmFragmentClobber implements Comparable<AsmFragmentClobber> {

   private boolean clobberA;
   private boolean clobberX;
   private boolean clobberY;

   public AsmFragmentClobber(boolean clobberA, boolean clobberX, boolean clobberY) {
      this.clobberA = clobberA;
      this.clobberX = clobberX;
      this.clobberY = clobberY;
   }

   public AsmFragmentClobber(AsmClobber clobber) {
      this(clobber.isClobberA(), clobber.isClobberX(), clobber.isClobberY());
   }

   public boolean isClobberA() {
      return clobberA;
   }

   public boolean isClobberX() {
      return clobberX;
   }

   public boolean isClobberY() {
      return clobberY;
   }

   @Override
   public boolean equals(Object o) {
      if(this == o) return true;
      if(o == null || getClass() != o.getClass()) return false;
      AsmFragmentClobber that = (AsmFragmentClobber) o;
      if(clobberA != that.clobberA) return false;
      if(clobberX != that.clobberX) return false;
      return clobberY == that.clobberY;
   }

   @Override
   public int hashCode() {
      int result = (clobberA ? 1 : 0);
      result = 31 * result + (clobberX ? 1 : 0);
      result = 31 * result + (clobberY ? 1 : 0);
      return result;
   }

   /**
    * Determines if this clobber is a subset of the passed clobber.
    * If this clobber clobbers the same or fewer registers than the passed clobber it is a subset.
    * The empty clobber (clobbers no registers) is a subset of all clobbers.
    * @param other The other clobber to examine
    * @return true if this clobber clobbers the same or fewer registers than the passed clobber.
    */
   public boolean isSubset(AsmFragmentClobber other) {
      if(!other.isClobberA() && this.isClobberA()) {
         // This clobber clobbers A, while the other does not - not a subset
         return false;
      }
      if(!other.isClobberX() && this.isClobberX()) {
         // This clobber clobbers A, while the other does not - not a subset
         return false;
      }
      if(!other.isClobberY() && this.isClobberY()) {
         // This clobber clobbers A, while the other does not - not a subset
         return false;
      }
      // This is a subset
      return true;
   }

   /**
    * Determines if this clobber is a true subset of the passed clobber.
    * If this clobber clobbers the fewer registers than the passed clobber it is a subset.
    * If the two clobbers are equal they are not true subsets of each other.
    * @param other The other clobber to examine
    * @return true if this clobber clobbers the same or fewer registers than the passed clobber.
    */
   public boolean isTrueSubset(AsmFragmentClobber other) {
      return isSubset(other) && !equals(other);
   }

   @Override
   public String toString() {
      return (clobberA?"A ":"")+(clobberX?"X ":"")+(clobberY?"Y ":" ");
   }

   @Override
   public int compareTo(AsmFragmentClobber o) {
      return toString().compareTo(o.toString());
   }
}

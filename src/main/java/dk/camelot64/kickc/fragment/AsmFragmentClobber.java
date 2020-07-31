package dk.camelot64.kickc.fragment;

import dk.camelot64.cpufamily6502.CpuClobber;

import java.util.Objects;

/** The clobber profile for a fragment template. Only distinguishes the 3 registers A/X/Y and not the flags. */
public class AsmFragmentClobber implements Comparable<AsmFragmentClobber> {

   private boolean clobberA;
   private boolean clobberX;
   private boolean clobberY;
   private boolean clobberZ;

   public AsmFragmentClobber(boolean clobberA, boolean clobberX, boolean clobberY, boolean clobberZ) {
      this.clobberA = clobberA;
      this.clobberX = clobberX;
      this.clobberY = clobberY;
      this.clobberZ = clobberZ;
   }

   public AsmFragmentClobber(CpuClobber clobber) {
      this(clobber.isRegisterA(), clobber.isRegisterX(), clobber.isRegisterY(), clobber.isRegisterZ());
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

   public boolean isClobberZ() {
      return clobberY;
   }

   @Override
   public boolean equals(Object o) {
      if(this == o) return true;
      if(o == null || getClass() != o.getClass()) return false;
      AsmFragmentClobber that = (AsmFragmentClobber) o;
      return clobberA == that.clobberA &&
            clobberX == that.clobberX &&
            clobberY == that.clobberY &&
            clobberZ == that.clobberZ;
   }

   @Override
   public int hashCode() {
      return Objects.hash(clobberA, clobberX, clobberY, clobberZ);
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
         // This clobber clobbers X, while the other does not - not a subset
         return false;
      }
      if(!other.isClobberY() && this.isClobberY()) {
         // This clobber clobbers Y, while the other does not - not a subset
         return false;
      }
      if(!other.isClobberZ() && this.isClobberZ()) {
         // This clobber clobbers Z, while the other does not - not a subset
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
      return (clobberA?"A ":"")+(clobberX?"X ":"")+(clobberY?"Y ":" ")+(clobberZ?"Z ":" ");
   }

   @Override
   public int compareTo(AsmFragmentClobber o) {
      return toString().compareTo(o.toString());
   }

}

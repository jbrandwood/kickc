package dk.camelot64.kickc.fragment;

import dk.camelot64.kickc.asm.AsmClobber;

/** The clobber profile for a fragment template. Only distinguishes the 3 registers A/X/Y and not the flags. */
public class AsmFragmentClobber {

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
}

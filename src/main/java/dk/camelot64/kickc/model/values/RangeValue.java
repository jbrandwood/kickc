package dk.camelot64.kickc.model.values;

/**
 * Placeholder value that is part of a ranged for( byte b : a..b )
 * The placeholder value is changed to a suitable constant value as soon as both start and end values are resolved to constants.
 */
public abstract class RangeValue implements RValue {

   /** The first value of the ranged for(). */
   private RValue rangeFirst;
   /** The last value of the ranged for(). */
   private RValue rangeLast;

   public RangeValue(RValue rangeFirst, RValue rangeLast) {
      this.rangeFirst = rangeFirst;
      this.rangeLast = rangeLast;
   }

   public RValue getRangeFirst() {
      return rangeFirst;
   }

   public RValue getRangeLast() {
      return rangeLast;
   }

   public void setRangeFirst(RValue rangeFirst) {
      this.rangeFirst = rangeFirst;
   }

   public void setRangeLast(RValue rangeLast) {
      this.rangeLast = rangeLast;
   }

   @Override
   public String toString() {
      return toString(null);
   }
}

package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.types.SymbolType;

/**
 * Placeholder comparison value for the end of ranged for( byte b : a..b )
 * The placeholder value is changed to a suitable constant value as soon as both start and end values are resolved to constants.
 * The placeholder value is either resolved to last+1 (if last>first) or first-1 (if last<first).
 */
public class RangeComparison extends RangeValue {

   /** The type of the value. */
   private SymbolType type;

   public RangeComparison(RValue rangeFirst, RValue rangeLast, SymbolType type) {
      super(rangeFirst, rangeLast);
      this.type = type;
   }

   public SymbolType getType() {
      return type;
   }

   @Override
   public String toString(Program program) {
      return "rangelast("+getRangeFirst().toString(null)+","+getRangeLast().toString(null)+")";
   }
}

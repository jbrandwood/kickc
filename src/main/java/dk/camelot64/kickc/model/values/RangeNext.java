package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.types.SymbolType;

/**
 * Placeholder value for addition neede to move to the next value of a ranged for( byte b : a..b )
 * The placeholder value is changed to a suitable constant value as soon as both start and end values are resolved to constants.
 * The placeholder is replaced with 1 (last>first) or -1 (last<first).
 */
public class RangeNext extends RangeValue {

   public RangeNext(RValue rangeFirst, RValue rangeLast) {
      super(rangeFirst, rangeLast);
   }

   @Override
   public String toString(Program program) {
      return "rangenext("+getRangeFirst().toString(null)+","+getRangeLast().toString(null)+")";
   }
}

package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.types.SymbolType;

/** A Cast that requires no actual operation.
 * The types have the same size and the code will execute as if the value already had the type cast to.
 * Examples: byte to/from signed byte, word to/from sighed word.
 */
public class CastValue implements RValue {

   /** The type cast to. */
   private SymbolType toType;

   /** The value being cast. */
   private RValue value;

   public CastValue(SymbolType toType, RValue value) {
      this.toType = toType;
      this.value = value;
   }

   public SymbolType getToType() {
      return toType;
   }

   public void setToType(SymbolType toType) {
      this.toType = toType;
   }

   public RValue getValue() {
      return value;
   }

   public void setValue(RValue value) {
      this.value = value;
   }

   @Override
   public String toString(Program program) {
      return "("+ toType.toCDecl()+")"+ value.toString(program);
   }

   @Override
   public String toString() {
      return toString(null);
   }
}

package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.operators.OperatorUnary;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;

/** A Cast of a constant that requires no actual operation.
 * The types have the same size and the code will execute as if the value already had the type cast to.
 * Examples: byte to/from signed byte, word to/from sighed word.
 * Exactly the same as {@link CastValue} - just constant
 */
public class ConstantCastValue implements ConstantValue {

   /** The type cast to. */
   private SymbolType toType;

   /** The value being cast. */
   private ConstantValue value;

   public ConstantCastValue(SymbolType toType, ConstantValue value) {
      this.toType = toType;
      this.value = value;
   }

   @Override
   public SymbolType getType(ProgramScope scope) {
      return getToType();
   }

   @Override
   public ConstantLiteral calculateLiteral(ProgramScope scope) {
      ConstantLiteral valueLiteral = value.calculateLiteral(scope);
      OperatorUnary castOperator = Operators.getCastUnary(toType);
      return castOperator.calculateLiteral(valueLiteral, scope);
   }

   public SymbolType getToType() {
      return toType;
   }

   public void setToType(SymbolType toType) {
      this.toType = toType;
   }

   public ConstantValue getValue() {
      return value;
   }

   public void setValue(ConstantValue value) {
      this.value = value;
   }

   @Override
   public String toString(Program program) {
      return "("+ toType.toString()+")"+ value.toString(program);
   }

   @Override
   public String toString() {
      return toString(null);
   }
}

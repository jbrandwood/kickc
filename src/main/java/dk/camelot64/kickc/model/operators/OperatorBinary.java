package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.ConstantLiteral;

/** A binary expression operator */
public abstract class OperatorBinary extends Operator {

   public OperatorBinary(String operator, String asmOperator, int precedence) {
      super(operator, asmOperator, Type.BINARY, precedence);
   }

   /**
    * Calculate the literal value of the operator applied to constant operands
    * @param left The left constant operand
    * @param right The right constant operand
    * @return The literal value
    */
   public abstract ConstantLiteral calculateLiteral(ConstantLiteral left, ConstantLiteral right);

   /**
    * Infer the type of the operator applied to operands of a specific type
    * @param left The type of the left operand
    * @param right The type of the right operand
    * @return The type resulting from applying the operator to the operands
    */
   public abstract SymbolType inferType(SymbolType left, SymbolType right);

}

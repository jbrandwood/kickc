package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeSimple;
import dk.camelot64.kickc.model.values.ConstantLiteral;

/** A unary expression operator */
public abstract class OperatorUnary extends Operator {

   public OperatorUnary(String operator, String asmOperator, int precedence) {
      super(operator, asmOperator, Type.UNARY, precedence);
   }

   /**
    * Calculate the literal value of the operator applied to a constant operand
    * @param operand The constant operand
    * @return The literal value
    */
   public abstract ConstantLiteral calculateLiteral(ConstantLiteral operand);

   /**
    * Infer the type of the operator applied to an operand of a specific type
    * @param operandType The type of the operand
    * @return The type resulting from applying the operator to the operand
    */
   public abstract SymbolType inferType(SymbolTypeSimple operandType);

}

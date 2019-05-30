package dk.camelot64.kickc.model.iterator;

import dk.camelot64.kickc.model.operators.Operator;
import dk.camelot64.kickc.model.values.Value;

/** A unary or binary operator expression.
 * Iterable using {@link ProgramExpressionIterator}.
 * */
public interface ProgramExpression {

   /**
    * Get the operator
    *
    * @return the operator
    */
   Operator getOperator();

   /**
    * Replace the unary/binary expression with a new value.
    *
    * Throws an exception if replacement is not possible
    *
    * @param value The new value.
    */
   void set(Value value);
}

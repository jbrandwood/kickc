package dk.camelot64.kickc.model.iterator;

import dk.camelot64.kickc.model.operators.OperatorUnary;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.values.*;

/**
 * A binary expression in the program being iterated by {@link ProgramExpressionIterator}
 */
public interface ProgramExpressionUnary extends ProgramExpression {

   /**
    * Get the unary operator
    *
    * @return the operator
    */
   OperatorUnary getOperator();

   /**
    * Get the right operand
    *
    * @return The right operand
    */
   RValue getOperand();

   /** Unary expression assignment rvalue. */
   class ProgramExpressionUnaryAssignmentRValue implements ProgramExpressionUnary {
      private final StatementAssignment assignment;

      ProgramExpressionUnaryAssignmentRValue(StatementAssignment assignment) {
         this.assignment = assignment;
      }

      @Override
      public OperatorUnary getOperator() {
         return (OperatorUnary) assignment.getOperator();
      }

      @Override
      public RValue getOperand() {
         return assignment.getrValue2();
      }

      @Override
      public void set(Value value) {
         assignment.setrValue2((RValue) value);
         assignment.setOperator(null);
      }
   }

   /** Unary expression as part of a constant expression. */
   class ProgramExpressionUnaryConstant implements ProgramExpressionUnary {

      /** A ProgramValue containing a {@link ConstantUnary}. */
      private ProgramValue programValue;

      ProgramExpressionUnaryConstant(ProgramValue programValue) {
         this.programValue = programValue;
      }

      public ConstantUnary getConstantUnary() {
         return (ConstantUnary) programValue.get();
      }

      @Override
      public OperatorUnary getOperator() {
         return (getConstantUnary()).getOperator();
      }

      @Override
      public RValue getOperand() {
         return getConstantUnary().getOperand();
      }

      @Override
      public void set(Value value) {
         programValue.set(value);
      }

   }

   /** Unary cast expression {@link ConstantCastValue} as part of a constant expression. */
   class ProgramExpressionUnaryConstantCast implements ProgramExpressionUnary {

      /** A ProgramValue containing a {@link ConstantCastValue}. */
      private ProgramValue programValue;

      ProgramExpressionUnaryConstantCast(ProgramValue programValue) {
         this.programValue = programValue;
      }

      public ConstantCastValue getConstantUnary() {
         return (ConstantCastValue) programValue.get();
      }

      @Override
      public OperatorUnary getOperator() {
         return Operators.getCastUnary(getConstantUnary().getToType());
      }

      @Override
      public RValue getOperand() {
         return getConstantUnary().getValue();
      }

      @Override
      public void set(Value value) {
         programValue.set(value);
      }

   }

   /** Unary cast expression {@link CastValue} as part of a constant expression. */
   class ProgramExpressionUnaryCast implements ProgramExpressionUnary {

      /** A ProgramValue containing a {@link CastValue}. */
      private ProgramValue programValue;

      ProgramExpressionUnaryCast(ProgramValue programValue) {
         this.programValue = programValue;
      }

      public CastValue getConstantUnary() {
         return (CastValue) programValue.get();
      }

      @Override
      public OperatorUnary getOperator() {
         return Operators.getCastUnary(getConstantUnary().getToType());
      }

      @Override
      public RValue getOperand() {
         return getConstantUnary().getValue();
      }

      @Override
      public void set(Value value) {
         programValue.set(value);
      }

   }


}

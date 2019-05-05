package dk.camelot64.kickc.model.iterator;

import dk.camelot64.kickc.model.operators.OperatorBinary;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.statements.StatementConditionalJump;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.*;

/**
 * A binary expression in the program being iterated by {@link BinaryExpressionIterator}
 */
public interface BinaryExpression {

   /**
    * Get the left operand
    *
    * @return The left operand
    */
   RValue getLeft();

   /**
    * Get the binary operator
    *
    * @return the operator
    */
   OperatorBinary getOperator();

   /**
    * Get the right operand
    *
    * @return The right operand
    */
   RValue getRight();

   /**
    * Adds a cast to the right operand
    * @param toType The toType to cast to
    */
   void addRightCast(SymbolType toType);

   /** Binary expression assignment rvalue. */
   class BinaryExpressionAssignmentRValue implements BinaryExpression {
      private final StatementAssignment assignment;

      BinaryExpressionAssignmentRValue(StatementAssignment assignment) {
         this.assignment = assignment;
      }

      @Override
      public RValue getLeft() {
         return assignment.getrValue1();
      }

      @Override
      public OperatorBinary getOperator() {
         return (OperatorBinary) assignment.getOperator();
      }

      @Override
      public RValue getRight() {
         return assignment.getrValue2();
      }

      @Override
      public void addRightCast(SymbolType toType) {
         if(assignment.getrValue2() instanceof ConstantValue) {
            assignment.setrValue2(new ConstantCastValue(toType, (ConstantValue) assignment.getrValue2()));
         } else {
            throw new InternalError("Not implemented!");
         }
      }
   }

   /** Binary expression - assignment lvalue and the "total" rvalue. */
   class BinaryExpressionAssignmentLValue implements BinaryExpression {
      private final StatementAssignment assignment;

      BinaryExpressionAssignmentLValue(StatementAssignment assignment) {
         this.assignment = assignment;
      }

      @Override
      public RValue getLeft() {
         return assignment.getlValue();
      }

      @Override
      public OperatorBinary getOperator() {
         return Operators.ASSIGNMENT;
      }

      @Override
      public RValue getRight() {
         return new AssignmentRValue(assignment);
      }

      @Override
      public void addRightCast(SymbolType toType) {
         throw new InternalError("Not implemented!");
      }


   }


   /** Binary expression conditional jump. */
   class BinaryExpressionConditionalJump implements BinaryExpression {
      private final StatementConditionalJump conditionalJump;

      BinaryExpressionConditionalJump(StatementConditionalJump assignment) {
         this.conditionalJump = assignment;
      }

      @Override
      public RValue getLeft() {
         return conditionalJump.getrValue1();
      }

      @Override
      public OperatorBinary getOperator() {
         return (OperatorBinary) conditionalJump.getOperator();
      }

      @Override
      public RValue getRight() {
         return conditionalJump.getrValue2();
      }

      @Override
      public void addRightCast(SymbolType toType) {
         throw new InternalError("Not implemented!");
      }


   }

   /** Binary expression as part of a constant expression. */
   class BinaryExpressionConstant implements BinaryExpression {
      private ConstantBinary constantBinary;

      BinaryExpressionConstant(ConstantBinary constantBinary) {
         this.constantBinary = constantBinary;
      }

      @Override
      public RValue getLeft() {
         return constantBinary.getLeft();
      }

      @Override
      public OperatorBinary getOperator() {
         return constantBinary.getOperator();
      }

      @Override
      public RValue getRight() {
         return constantBinary.getRight();
      }

      @Override
      public void addRightCast(SymbolType toType) {
         constantBinary.setRight(new ConstantCastValue(toType, constantBinary.getRight()));
      }
   }
}

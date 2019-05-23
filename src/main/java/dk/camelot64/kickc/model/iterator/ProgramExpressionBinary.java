package dk.camelot64.kickc.model.iterator;

import dk.camelot64.kickc.model.Comment;
import dk.camelot64.kickc.model.InternalError;
import dk.camelot64.kickc.model.operators.OperatorBinary;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.statements.StatementConditionalJump;
import dk.camelot64.kickc.model.statements.StatementPhiBlock;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.symbols.VariableIntermediate;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeInference;
import dk.camelot64.kickc.model.values.*;

import java.util.ListIterator;

/**
 * A binary expression in the program being iterated by {@link ProgramExpressionIterator}
 */
public interface ProgramExpressionBinary extends ProgramExpression {

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
    * Adds a cast to the left operand
    *
    * @param toType The toType to cast to
    */
   void addLeftCast(SymbolType toType, ListIterator<Statement> stmtIt, ScopeRef currentScope, ProgramScope symbols);

   /**
    * Adds a cast to the right operand
    *
    * @param toType The toType to cast to
    */
   void addRightCast(SymbolType toType, ListIterator<Statement> stmtIt, ScopeRef currentScope, ProgramScope symbols);


   /** Binary expression assignment rvalue. */
   class ProgramExpressionBinaryAssignmentRValue implements ProgramExpressionBinary {

      private final StatementAssignment assignment;

      ProgramExpressionBinaryAssignmentRValue(StatementAssignment assignment) {
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
      public void set(Value value) {
         assignment.setrValue2((RValue) value);
         assignment.setOperator(null);
         assignment.setrValue1(null);
      }

      @Override
      public void addLeftCast(SymbolType toType, ListIterator<Statement> stmtIt, ScopeRef currentScope, ProgramScope symbols) {
         if(assignment.getrValue1() instanceof ConstantValue) {
            assignment.setrValue1(new ConstantCastValue(toType, (ConstantValue) assignment.getrValue1()));
         } else {
            Scope blockScope = symbols.getScope(currentScope);
            VariableIntermediate tmpVar = blockScope.addVariableIntermediate();
            tmpVar.setTypeInferred(toType);
            StatementAssignment newAssignment = new StatementAssignment(tmpVar.getRef(), Operators.getCastUnary(toType), assignment.getrValue1(), assignment.getSource(), Comment.NO_COMMENTS);
            assignment.setrValue1(tmpVar.getRef());
            stmtIt.previous();
            stmtIt.add(newAssignment);
            stmtIt.next();
         }
      }

      @Override
      public void addRightCast(SymbolType toType, ListIterator<Statement> stmtIt, ScopeRef currentScope, ProgramScope symbols) {
         if(assignment.getrValue2() instanceof ConstantValue) {
            assignment.setrValue2(new ConstantCastValue(toType, (ConstantValue) assignment.getrValue2()));
         } else {
            Scope blockScope = symbols.getScope(currentScope);
            VariableIntermediate tmpVar = blockScope.addVariableIntermediate();
            tmpVar.setTypeInferred(toType);
            StatementAssignment newAssignment = new StatementAssignment(tmpVar.getRef(), Operators.getCastUnary(toType), assignment.getrValue2(), assignment.getSource(), Comment.NO_COMMENTS);
            assignment.setrValue2(tmpVar.getRef());
            stmtIt.previous();
            stmtIt.add(newAssignment);
            stmtIt.next();
         }
      }
   }

   /** Binary expression - assignment lvalue and the "total" rvalue. */
   class ProgramExpressionBinaryAssignmentLValue implements ProgramExpressionBinary {
      private final StatementAssignment assignment;

      ProgramExpressionBinaryAssignmentLValue(StatementAssignment assignment) {
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
         if(assignment.getrValue1() == null && assignment.getOperator() == null) {
            return assignment.getrValue2();
         } else {
            return new AssignmentRValue(assignment);
         }
      }

      @Override
      public void set(Value value) {
         throw new InternalError("Updating an entire assignment is not allowed!");
      }

      @Override
      public void addLeftCast(SymbolType toType, ListIterator<Statement> stmtIt, ScopeRef currentScope, ProgramScope symbols) {
         if(assignment.getlValue() instanceof VariableRef) {
            Variable variable = symbols.getVariable((VariableRef) assignment.getlValue());
            if(variable.isInferredType())
               variable.setTypeInferred(toType);
            else
               throw new InternalError("Cannot cast declared type!" + variable.toString());
         } else {
            Scope blockScope = symbols.getScope(currentScope);
            VariableIntermediate tmpVar = blockScope.addVariableIntermediate();
            SymbolType rightType = SymbolTypeInference.inferType(symbols, getRight());
            tmpVar.setTypeInferred(rightType);
            StatementAssignment newAssignment = new StatementAssignment(assignment.getlValue(), Operators.getCastUnary(toType), tmpVar.getRef(), assignment.getSource(), Comment.NO_COMMENTS);
            assignment.setlValue(tmpVar.getRef());
            stmtIt.add(newAssignment);
         }
      }

      @Override
      public void addRightCast(SymbolType toType, ListIterator<Statement> stmtIt, ScopeRef currentScope, ProgramScope symbols) {
         if(assignment.getrValue1() == null && assignment.getOperator() == null) {
            assignment.setOperator(Operators.getCastUnary(toType));
         } else {
            Scope blockScope = symbols.getScope(currentScope);
            VariableIntermediate tmpVar = blockScope.addVariableIntermediate();
            SymbolType rightType = SymbolTypeInference.inferType(symbols, getRight());
            tmpVar.setTypeInferred(rightType);
            StatementAssignment newAssignment = new StatementAssignment(assignment.getlValue(), Operators.getCastUnary(toType), tmpVar.getRef(), assignment.getSource(), Comment.NO_COMMENTS);
            assignment.setlValue(tmpVar.getRef());
            stmtIt.add(newAssignment);
         }
      }

   }

   /** Binary expression conditional jump. */
   class ProgramExpressionBinaryConditionalJump implements ProgramExpressionBinary {
      private final StatementConditionalJump conditionalJump;

      ProgramExpressionBinaryConditionalJump(StatementConditionalJump assignment) {
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
      public void set(Value value) {
         conditionalJump.setrValue2((RValue) value);
         conditionalJump.setOperator(null);
         conditionalJump.setrValue1(null);
      }

      @Override
      public void addLeftCast(SymbolType toType, ListIterator<Statement> stmtIt, ScopeRef currentScope, ProgramScope symbols) {
         if(conditionalJump.getrValue1() instanceof ConstantValue) {
            conditionalJump.setrValue1(new ConstantCastValue(toType, (ConstantValue) conditionalJump.getrValue1()));
         } else {
            throw new InternalError("Not implemented!");
         }
      }

      @Override
      public void addRightCast(SymbolType toType, ListIterator<Statement> stmtIt, ScopeRef currentScope, ProgramScope symbols) {
         if(conditionalJump.getrValue2() instanceof ConstantValue) {
            conditionalJump.setrValue2(new ConstantCastValue(toType, (ConstantValue) conditionalJump.getrValue2()));
         } else {
            throw new InternalError("Not implemented!");
         }
      }


   }

   /** Binary expression as part of a constant expression. */
   class ProgramExpressionBinaryConstant implements ProgramExpressionBinary {
      /** A program value containing a {@link ConstantBinary}. */
      private ProgramValue programValue;

      public ProgramExpressionBinaryConstant(ProgramValue programValue) {
         this.programValue = programValue;
      }

      public ConstantBinary getConstantBinary() {
         return (ConstantBinary) programValue.get();
      }

      @Override
      public RValue getLeft() {
         return getConstantBinary().getLeft();
      }

      @Override
      public OperatorBinary getOperator() {
         return getConstantBinary().getOperator();
      }

      @Override
      public RValue getRight() {
         return getConstantBinary().getRight();
      }

      @Override
      public void set(Value value) {
         programValue.set(value);
      }

      @Override
      public void addLeftCast(SymbolType toType, ListIterator<Statement> stmtIt, ScopeRef currentScope, ProgramScope symbols) {
         getConstantBinary().setLeft(new ConstantCastValue(toType, getConstantBinary().getLeft()));
      }

      @Override
      public void addRightCast(SymbolType toType, ListIterator<Statement> stmtIt, ScopeRef currentScope, ProgramScope symbols) {
         getConstantBinary().setRight(new ConstantCastValue(toType, getConstantBinary().getRight()));
      }
   }

   /** Binary expression that is an indexed dereference of a pointer eg. ptr[i] or *(ptr+i). */
   class ProgramExpressionBinaryPointerDereferenceIndexed implements ProgramExpressionBinary {
      /** A program value containing a {@link ConstantBinary}. */
      private ProgramValue programValue;

      public ProgramExpressionBinaryPointerDereferenceIndexed(ProgramValue programValue) {
         this.programValue = programValue;
      }

      public PointerDereferenceIndexed getPointerDereferenceIndexed() {
         return (PointerDereferenceIndexed) programValue.get();
      }

      @Override
      public RValue getLeft() {
         return getPointerDereferenceIndexed().getPointer();
      }

      @Override
      public OperatorBinary getOperator() {
         return Operators.PLUS;
      }

      @Override
      public RValue getRight() {
         return getPointerDereferenceIndexed().getIndex();
      }

      @Override
      public void set(Value value) {
         programValue.set(value);
      }

      @Override
      public void addLeftCast(SymbolType toType, ListIterator<Statement> stmtIt, ScopeRef currentScope, ProgramScope symbols) {
         if(getPointerDereferenceIndexed().getPointer() instanceof ConstantValue) {
            getPointerDereferenceIndexed().setPointer(new ConstantCastValue(toType, (ConstantValue) getPointerDereferenceIndexed().getPointer()));
         } else {
            // Try to use CastValue - may later have to be supported!
            getPointerDereferenceIndexed().setPointer(new CastValue(toType, getPointerDereferenceIndexed().getPointer()));
         }
      }

      @Override
      public void addRightCast(SymbolType toType, ListIterator<Statement> stmtIt, ScopeRef currentScope, ProgramScope symbols) {
         if(getPointerDereferenceIndexed().getIndex() instanceof ConstantValue) {
            getPointerDereferenceIndexed().setIndex(new ConstantCastValue(toType, (ConstantValue) getPointerDereferenceIndexed().getIndex()));
         } else if( getPointerDereferenceIndexed().getIndex() instanceof VariableRef) {
            Variable variable = symbols.getVariable((VariableRef) getPointerDereferenceIndexed().getIndex());
            if(variable.isInferredType())
               variable.setTypeInferred(toType);
            else
               throw new InternalError("Cannot cast declared type!" + variable.toString());

         } else {
            // Try to use CastValue - may later have to be supported!
            getPointerDereferenceIndexed().setIndex(new CastValue(toType, getPointerDereferenceIndexed().getIndex()));
         }
      }
   }


   /** Assignment of a phi value to a phi variable. */
   class ProgramExpressionBinaryPhiValueAssignemnt implements ProgramExpressionBinary {

      private final StatementPhiBlock.PhiVariable phiVariable;
      private final StatementPhiBlock.PhiRValue value;

      public ProgramExpressionBinaryPhiValueAssignemnt(StatementPhiBlock.PhiVariable phiVariable, StatementPhiBlock.PhiRValue value) {
         this.phiVariable = phiVariable;
         this.value = value;
      }

      @Override
      public RValue getLeft() {
         return phiVariable.getVariable();
      }

      @Override
      public OperatorBinary getOperator() {
         return Operators.ASSIGNMENT;
      }

      @Override
      public RValue getRight() {
         return value.getrValue();
      }

      @Override
      public void addLeftCast(SymbolType toType, ListIterator<Statement> stmtIt, ScopeRef currentScope, ProgramScope symbols) {
         Variable variable = symbols.getVariable(phiVariable.getVariable());
         if(variable.isInferredType())
            variable.setTypeInferred(toType);
         else
            throw new InternalError("Cannot cast declared type!" + variable.toString());
      }

      @Override
      public void addRightCast(SymbolType toType, ListIterator<Statement> stmtIt, ScopeRef currentScope, ProgramScope symbols) {
         if(getRight() instanceof VariableRef) {
            Variable variable = symbols.getVariable((VariableRef) getRight());
            if(variable.isInferredType())
               variable.setTypeInferred(toType);
         } else if(getRight() instanceof ConstantValue) {
            value.setrValue(new ConstantCastValue(toType, (ConstantValue) getRight()));
         } else {
            value.setrValue(new CastValue(toType, getRight()));
         }
      }

      @Override
      public void set(Value value) {
         throw new InternalError("Not supported!");
      }
   }


}

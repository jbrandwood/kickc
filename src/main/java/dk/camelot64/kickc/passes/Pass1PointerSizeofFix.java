package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.Comment;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.operators.OperatorSizeOf;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.symbols.VariableIntermediate;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.values.ConstantRef;
import dk.camelot64.kickc.model.values.VariableRef;

import java.util.ListIterator;

/**
 * Fixes pointer math to use sizeof(type)
 */
public class Pass1PointerSizeofFix extends Pass1Base {

   public Pass1PointerSizeofFix(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         ListIterator<Statement> stmtIt = block.getStatements().listIterator();
         while(stmtIt.hasNext()) {
            Statement statement = stmtIt.next();
            if(statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               if((assignment.getrValue1() == null) && (assignment.getOperator() != null) && (assignment.getrValue2() instanceof VariableRef)) {
                  fixPointerUnary(assignment);
               } else if((assignment.getrValue1() instanceof VariableRef) && (assignment.getOperator() != null) && (assignment.getrValue2() != null)) {
                  fixPointerBinary(block, stmtIt, assignment);
               }
            }
         }
      }
      return false;
   }

   /**
    * Examine if the binary operation in the assignment is a pointer operation - and fix it to reflect sizeof()
    *
    * @param assignment The assignment statement
    */

   public void fixPointerBinary(ControlFlowBlock block, ListIterator<Statement> stmtIt, StatementAssignment assignment) {
      VariableRef varRef = (VariableRef) assignment.getrValue1();
      Variable variable = getScope().getVariable(varRef);
      if(variable.getType() instanceof SymbolTypePointer) {
         SymbolTypePointer pointerType = (SymbolTypePointer) variable.getType();
         if(pointerType.getElementType().getSizeBytes() > 1) {
            // Binary operation on a non-byte pointer - sizeof()-handling is probably needed!
            if(Operators.PLUS.equals(assignment.getOperator()) || Operators.MINUS.equals(assignment.getOperator())) {
               // Adding to a pointer - multiply by sizeof()
               getLog().append("Fixing pointer addition " + assignment.toString(getProgram(), false));
               VariableIntermediate tmpVar = getScope().getScope(block.getScope()).addVariableIntermediate();
               tmpVar.setType(SymbolType.BYTE);
               stmtIt.remove();
               ConstantRef sizeOfTargetType = OperatorSizeOf.getSizeOfConstantVar(getProgram().getScope(), pointerType.getElementType());
               stmtIt.add(new StatementAssignment(tmpVar.getRef(), assignment.getrValue2(), Operators.MULTIPLY, sizeOfTargetType, assignment.getSource(), Comment.NO_COMMENTS));
               stmtIt.add(assignment);
               assignment.setrValue2(tmpVar.getRef());
            }
         }
      }
   }

   /**
    * Examine if the unary operation in the assignment is a pointer operation - and fix it to reflect sizeof()
    *
    * @param assignment The assignment statement
    */
   public void fixPointerUnary(StatementAssignment assignment) {
      // Found assignment of unary operator
      VariableRef varRef = (VariableRef) assignment.getrValue2();
      Variable variable = getScope().getVariable(varRef);
      if(variable.getType() instanceof SymbolTypePointer) {
         SymbolTypePointer pointerType = (SymbolTypePointer) variable.getType();
         if(pointerType.getElementType().getSizeBytes() > 1) {
            // Unary operation on non-byte pointer type - sizeof()-handling is needed!
            if(Operators.INCREMENT.equals(assignment.getOperator())) {
               // Pointer increment - add sizeof(type) instead
               getLog().append("Fixing pointer increment " + assignment.toString(getProgram(), false));
               assignment.setrValue1(assignment.getrValue2());
               assignment.setOperator(Operators.PLUS);
               assignment.setrValue2(OperatorSizeOf.getSizeOfConstantVar(getProgram().getScope(), pointerType.getElementType()));
            } else if(Operators.DECREMENT.equals(assignment.getOperator())) {
               // Pointer Decrement - add sizeof(type) instead
               getLog().append("Fixing pointer decrement " + assignment.toString(getProgram(), false));
               assignment.setrValue1(assignment.getrValue2());
               assignment.setOperator(Operators.MINUS);
               assignment.setrValue2(OperatorSizeOf.getSizeOfConstantVar(getProgram().getScope(), pointerType.getElementType()));
            }
         }
      }
   }


}

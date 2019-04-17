package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.operators.OperatorSizeOf;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
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
                  // Found assignment of unary operator
                  VariableRef varRef = (VariableRef) assignment.getrValue2();
                  Variable variable = getScope().getVariable(varRef);
                  if(variable.getType() instanceof SymbolTypePointer) {
                     SymbolTypePointer pointerType = (SymbolTypePointer) variable.getType();
                     if(pointerType.getElementType().getSizeBytes() > 1) {
                        // Unary operation on non-byte pointer type - sizeof()-handling is needed!
                        if(Operators.INCREMENT.equals(assignment.getOperator())) {
                           // Pointer increment - add sizeof(type) instead
                           getLog().append("Fixing pointer increment " + statement.toString(getProgram(), false));
                           assignment.setrValue1(assignment.getrValue2());
                           assignment.setOperator(Operators.PLUS);
                           assignment.setrValue2(OperatorSizeOf.getSizeOfConstantVar(getProgram().getScope(), pointerType.getElementType()));
                        } else if(Operators.DECREMENT.equals(assignment.getOperator())) {
                           // Pointer Decrement - add sizeof(type) instead
                           getLog().append("Fixing pointer decrement " + statement.toString(getProgram(), false));
                           assignment.setrValue1(assignment.getrValue2());
                           assignment.setOperator(Operators.MINUS);
                           assignment.setrValue2(OperatorSizeOf.getSizeOfConstantVar(getProgram().getScope(), pointerType.getElementType()));
                        }
                     }
                  }
               }
            }
         }
      }
      return false;
   }


}

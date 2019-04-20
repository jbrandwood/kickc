package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.operators.OperatorCastPtr;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeInference;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.values.RValue;

/**
 * Eliminate casts that are not necessary
 */
public class Pass2EliminateRedundantCasts extends Pass2SsaOptimization {

   public Pass2EliminateRedundantCasts(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      boolean modified = false;
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               if(isRedundantCast(assignment)) {
                  // Redundant cast
                  getLog().append("Removing redundant cast " + statement.toString(getProgram(), false));
                  assignment.setOperator(null);
                  modified = true;
               }
            }
         }
      }
      return modified;
   }

   /**
    * Determines if the assignment is a redundant cast
    *
    * @param assignment The assignment to examine
    * @return true if is is a redundant cast
    */
   private boolean isRedundantCast(StatementAssignment assignment) {
      RValue rValue2 = assignment.getrValue2();
      SymbolType rValue2Type = SymbolTypeInference.inferType(getScope(), rValue2);
      if(Operators.CAST_BYTE.equals(assignment.getOperator()) && SymbolType.BYTE.equals(rValue2Type)) {
         return true;
      } else if(Operators.CAST_SBYTE.equals(assignment.getOperator()) && SymbolType.SBYTE.equals(rValue2Type)) {
         return true;
      } else if(Operators.CAST_WORD.equals(assignment.getOperator()) && SymbolType.WORD.equals(rValue2Type)) {
         return true;
      } else if(Operators.CAST_SWORD.equals(assignment.getOperator()) && SymbolType.SWORD.equals(rValue2Type)) {
         return true;
      } else if(Operators.CAST_DWORD.equals(assignment.getOperator()) && SymbolType.DWORD.equals(rValue2Type)) {
         return true;
      } else if(Operators.CAST_SDWORD.equals(assignment.getOperator()) && SymbolType.SDWORD.equals(rValue2Type)) {
         return true;
      } else if(Operators.CAST_BOOL.equals(assignment.getOperator()) && SymbolType.BOOLEAN.equals(rValue2Type)) {
         return true;
      } else if(assignment.getOperator() instanceof OperatorCastPtr) {
         // Casting to a pointer
         OperatorCastPtr operatorCastPtr = (OperatorCastPtr) assignment.getOperator();
         if(rValue2Type.equals(new SymbolTypePointer(operatorCastPtr.getElementType()))) {
            return true;
         }
      }
      return false;
   }

}

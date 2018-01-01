package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;

import java.util.List;
import java.util.ListIterator;

/**
 * Add casts in all assignments where types are not equal, but the rValue type can be promoted to the lValue type.
 */
public class Pass1AddTypePromotions extends Pass1Base {

   public Pass1AddTypePromotions(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      for(ControlFlowBlock block : getProgram().getGraph().getAllBlocks()) {
         List<Statement> statements = block.getStatements();
         ListIterator<Statement> stmtIt = statements.listIterator();
         while(stmtIt.hasNext()) {
            Statement statement = stmtIt.next();
            if(statement instanceof StatementAssignment) {
               getPromotionAssignment((StatementAssignment) statement, stmtIt);
            }
            // TODO: Implement promotion for calls
         }
      }
      return false;
   }

   /**
    * Examines an assignment to determine if a cast of the rValue is needed (the lvalue type and the rvalue type is not equal)
    * and possible (the types are promotion compatible).
    * <p>
    * If a promotion is needed it is added by adding a new tmp-var with a cast and modifying the statement.
    *
    * @param assignment The assignment to examine
    * @param stmtIt Iterator allowing the method to add a tmp-var-assignment.
    */
   private void getPromotionAssignment(StatementAssignment assignment, ListIterator<Statement> stmtIt) {
      LValue lValue = assignment.getlValue();
      SymbolType lValueType = SymbolTypeInference.inferType(getScope(), lValue);
      SymbolType rValueType = SymbolTypeInference.inferTypeRValue(getScope(), assignment);
      if(SymbolTypeInference.typeMatch(lValueType, rValueType)) {
         return;
      }
      // No direct type match - attempt promotion
      if(canPromote(lValueType, rValueType)) {
         // Promotion possible - add tmp-var and a cast
         if(assignment.getOperator() == null) {
            // No operator - add cast directly!
            assignment.setOperator(Operator.getCastUnary(lValueType));
            getProgram().getLog().append("Promoting " + rValueType + " to " + lValueType + " in " + assignment);
         } else {
            throw new RuntimeException("Tmp-var promotions not implemented yet " + assignment);
         }
      } else {
         String msg = "ERROR! Type mismatch (" + lValueType.getTypeName() + ") cannot be assigned from (" + rValueType.getTypeName() + "). " +
               "In " + assignment.toString(getProgram(), false);
         getProgram().getLog().append(msg);
         throw new CompileError(msg);
      }
   }

   /**
    * Determines if it is possible to promote (cast without loss) one type to another
    *
    * @param lValueType The type of the lValue
    * @param rValueType The type of the rValue (that will be cast)
    * @return True if a cast is possible without any loss
    */
   private boolean canPromote(SymbolType lValueType, SymbolType rValueType) {
      if(lValueType instanceof SymbolTypePointer && SymbolType.isWord(rValueType)) {
         return true;
      }
      if(lValueType.equals(SymbolType.WORD) && SymbolType.isByte(rValueType)) {
         return true;
      }
      // No type promotion found
      return false;
   }


}

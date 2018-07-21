package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.values.LValue;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeInference;

/**
 * Asserts that types match in all assignments and calculations
 */
public class Pass2AssertTypeMatch extends Pass2SsaAssertion {

   public Pass2AssertTypeMatch(Program program) {
      super(program);
   }

   @Override
   public void check() throws AssertionFailed {
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementAssignment) {
               checkAssignment((StatementAssignment) statement);
            }
            // TODO: Implement checking for calls / conditional jumps / ...
         }
      }

   }

   private void checkAssignment(StatementAssignment statement) {
      LValue lValue = statement.getlValue();
      SymbolType lValueType = SymbolTypeInference.inferType(getScope(), lValue);
      SymbolType rValueType = SymbolTypeInference.inferTypeRValue(getScope(), statement);
      if(SymbolTypeInference.typeMatch(lValueType, rValueType)) {
         return;
      }
      if(SymbolTypeInference.typeMatch(rValueType, lValueType)) {
         return;
      }
      // Types do not match
      getLog().append("ERROR! Type mismatch (" + lValueType.getTypeName() + ") cannot be assigned from (" + rValueType.getTypeName() + "). In " + statement.toString(getProgram(), false));
      throw new CompileError("ERROR! Type mismatch (" + lValueType.getTypeName() + ") cannot be assigned from (" + rValueType.getTypeName() + "). In " + statement.toString(getProgram(), false), statement.getSource());
   }

}

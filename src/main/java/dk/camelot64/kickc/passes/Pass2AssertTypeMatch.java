package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.statements.StatementConditionalJump;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeInference;
import dk.camelot64.kickc.model.types.SymbolTypeMatch;
import dk.camelot64.kickc.model.values.LValue;
import dk.camelot64.kickc.model.values.RValue;

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
            if(statement instanceof StatementConditionalJump) {
               StatementConditionalJump conditionalJump = (StatementConditionalJump) statement;
               if(conditionalJump.getOperator()==null) {
                  RValue rValue = conditionalJump.getrValue2();
                  SymbolType rValueType = SymbolTypeInference.inferType(getScope(), rValue);
                  if(!SymbolType.BOOLEAN.equals(rValueType)) {
                     getLog().append("ERROR! Type mismatch non-boolean condition from (" + rValueType.getTypeName() + "). In " + statement.toString(getProgram(), false));
                     throw new CompileError("ERROR! Type mismatch non-boolean condition from (" + rValueType.getTypeName() + "). In " + statement.toString(getProgram(), false), statement.getSource());
                  }
               } else {
                 // Conditions with operators always result in booleans?
               }
            }
            // TODO: Implement checking for calls / ...
         }
      }

   }

   private void checkAssignment(StatementAssignment statement) {
      LValue lValue = statement.getlValue();
      SymbolType lValueType = SymbolTypeInference.inferType(getScope(), lValue);
      SymbolType rValueType = SymbolTypeInference.inferTypeRValue(getScope(), statement);
      if(SymbolTypeMatch.assignmentTypeMatch(lValueType, rValueType)) return;
      // Types do not match
      getLog().append("ERROR! Type mismatch (" + lValueType.getTypeName() + ") cannot be assigned from (" + rValueType.getTypeName() + "). In " + statement.toString(getProgram(), false));
      throw new CompileError("ERROR! Type mismatch (" + lValueType.getTypeName() + ") cannot be assigned from (" + rValueType.getTypeName() + "). In " + statement.toString(getProgram(), false), statement.getSource());
   }

}

package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeConversion;
import dk.camelot64.kickc.model.types.SymbolTypeInference;
import dk.camelot64.kickc.model.values.AssignmentRValue;
import dk.camelot64.kickc.model.values.LValue;

/**
 * Asserts that types match in all assignments and calculations
 */
public class PassNAssertTypeMatch extends Pass2SsaAssertion {

   public PassNAssertTypeMatch(Program program) {
      super(program);
   }

   @Override
   public void check() throws AssertionFailed {
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementAssignment) {
               checkAssignment((StatementAssignment) statement);
            }
            // TODO: Implement checking for calls / ...
         }
      }
      for(Variable var : getScope().getAllVars(true)) {
         if(var.getInitValue()!=null) {
            checkVarInit(var);
         }
      }

   }

   private void checkVarInit(Variable variable) {

      SymbolType lValueType = variable.getType();
      SymbolType rValueType = variable.getInitValue().getType(getScope());
      if(SymbolTypeConversion.assignmentTypeMatch(lValueType, rValueType)) return;
      // Types do not match
      getLog().append("ERROR! Type mismatch (" + lValueType.getTypeName() + ") cannot be assigned from (" + rValueType.getTypeName() + "). In initialization of " + variable.toString(getProgram()));
      throw new CompileError("Type mismatch (" + lValueType.getTypeName() + ") cannot be assigned from (" + rValueType.getTypeName() + "). In initialization of " + variable.toString(getProgram()));
   }

   private void checkAssignment(StatementAssignment statement) {
      LValue lValue = statement.getlValue();
      SymbolType lValueType = SymbolTypeInference.inferType(getScope(), lValue);
      SymbolType rValueType = SymbolTypeInference.inferType(getScope(), new AssignmentRValue(statement));
      if(SymbolTypeConversion.assignmentTypeMatch(lValueType, rValueType)) return;
      // Types do not match
      getLog().append("ERROR! Type mismatch (" + lValueType.getTypeName() + ") cannot be assigned from (" + rValueType.getTypeName() + "). In " + statement.toString(getProgram(), false));
      throw new CompileError("Type mismatch (" + lValueType.getTypeName() + ") cannot be assigned from (" + rValueType.getTypeName() + "). In " + statement.toString(getProgram(), false), statement.getSource());
   }

}

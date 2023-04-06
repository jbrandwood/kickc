package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementLValue;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.values.VariableRef;

/**
 * Checks that no-modify variables are not assigned
 */
public class Pass1AssertNoModifyVars extends Pass1Base {

   public Pass1AssertNoModifyVars(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementLValue) {
               StatementLValue statementLValue = (StatementLValue) statement;
               if(!statementLValue.isInitialAssignment() && statementLValue.getlValue() instanceof VariableRef) {
                  Variable assignedVar = getProgramScope().getVariable((VariableRef) statementLValue.getlValue());
                  if(assignedVar.isNoModify())
                     throw new CompileError("const variable may not be modified! " + assignedVar.toString(), statement);
               }
            }
         }
      }
      return false;
   }
}

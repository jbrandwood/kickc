package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Graph;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementLValue;
import dk.camelot64.kickc.model.statements.StatementPhiBlock;
import dk.camelot64.kickc.model.values.LValue;
import dk.camelot64.kickc.model.values.VariableRef;

import java.util.LinkedHashMap;
import java.util.Map;

/** Asserts that each variable is only assigned once */
public class Pass2AssertSingleAssignment extends Pass2SsaAssertion {

   public Pass2AssertSingleAssignment(Program program) {
      super(program);
   }

   @Override
   public void check() throws AssertionFailed {

      Map<VariableRef, Statement> assignments = new LinkedHashMap<>();

      for(var statement : getGraph().getAllStatements()) {
         if (statement instanceof StatementLValue) {
            LValue lValue = ((StatementLValue) statement).getlValue();
            if (lValue instanceof VariableRef) {
               checkAssignment(assignments, (VariableRef) lValue, statement);
            }
         } else if (statement instanceof StatementPhiBlock) {
            for (StatementPhiBlock.PhiVariable phiVariable : ((StatementPhiBlock) statement).getPhiVariables()) {
               checkAssignment(assignments, phiVariable.getVariable(), statement);
            }
         }
      }

   }

   private void checkAssignment(Map<VariableRef, Statement> assignments, VariableRef lValue, Statement statement) {
      if(getScope().getVariable(lValue).isKindLoadStore())
         return;
      if(assignments.get(lValue) != null) {
         throw new AssertionFailed("Multiple assignments to variable " + lValue + " 1: " + assignments.get(lValue) + " 2:" + statement);
      } else {
         assignments.put(lValue, statement);
      }
   }

}

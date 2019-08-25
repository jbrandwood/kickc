package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementLValue;
import dk.camelot64.kickc.model.values.LValue;
import dk.camelot64.kickc.model.values.LvalueIntermediate;
import dk.camelot64.kickc.model.values.VariableRef;

/**
 * Asserts that all intermediate lvalues have been replaced by something else
 */
public class Pass1AssertNoLValueIntermediate extends Pass1Base {

   public Pass1AssertNoLValueIntermediate(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementLValue) {
               LValue lValue = ((StatementLValue) statement).getlValue();
               if(lValue instanceof LvalueIntermediate) {
                  VariableRef intermediateVar = ((LvalueIntermediate) lValue).getVariable();
                  StatementLValue assignment = getGraph().getAssignment(intermediateVar);
                  throw new CompileError("Error! LValue is illegal. " + statement + " - definition of lValue " + assignment, assignment.getSource());
               }
            }
         }
      }
      return false;
   }


}

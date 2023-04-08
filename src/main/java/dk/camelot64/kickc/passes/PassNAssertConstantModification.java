package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Graph;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementLValue;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.values.LValue;
import dk.camelot64.kickc.model.values.VariableRef;

import java.util.HashSet;
import java.util.Set;

/**
 * Asserts that constants are not modified
 */
public class PassNAssertConstantModification extends Pass2SsaOptimization {

   public PassNAssertConstantModification(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      Set<VariableRef> assigned = new HashSet<>();
      for(var block : getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementLValue) {
               LValue lValue = ((StatementLValue) statement).getlValue();
               if(lValue instanceof VariableRef) {
                  VariableRef variableRef = (VariableRef) lValue;
                  Variable variable = getProgramScope().getVariable(variableRef);
                  if(variable.isKindConstant() || variable.isNoModify()) {
                     if(assigned.contains(variableRef)) {
                        throw new CompileError("const variable may not be modified "+variable.toString(getProgram()), statement.getSource());
                     } else {
                        assigned.add(variableRef);
                     }
                  }
               }
            }
         }
      }
      return false;
   }


}

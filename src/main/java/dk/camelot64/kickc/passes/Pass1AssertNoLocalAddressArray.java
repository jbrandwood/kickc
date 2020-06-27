package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementLValue;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.values.ScopeRef;
import dk.camelot64.kickc.model.values.SymbolRef;
import dk.camelot64.kickc.model.values.VariableRef;

/**
 * Checks that no local variables with arrays and hard-coded addresses exist
 */
public class Pass1AssertNoLocalAddressArray extends Pass1Base {

   public Pass1AssertNoLocalAddressArray(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      for(Variable variable : getScope().getAllVars(true)) {
         if(!ScopeRef.ROOT.equals(variable.getScope()) && variable.isArray() && variable.getMemoryAddress()!=null)
            throw new CompileError("Error! Local array variables with __address() not allowed. "+variable.toString(getProgram()));
      }
      return false;
   }
}

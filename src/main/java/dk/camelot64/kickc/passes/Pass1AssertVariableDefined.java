package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.symbols.Variable;

/** Pass that checks that all variables declared have a definition*/
public class Pass1AssertVariableDefined extends Pass1Base {

   public Pass1AssertVariableDefined(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      for(Variable var : getScope().getAllVars(true)) {
         if(var.isDeclarationOnly())
            throw new CompileError("Error! Variable is declared but never defined: " +  var.getFullName());
      }
      return false;
   }

}

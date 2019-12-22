package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.symbols.Variable;

/**
 * Check that no parameters are declared const
 */
public class Pass1AssertNoConstParams extends Pass1Base {

   public Pass1AssertNoConstParams(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      for(Procedure procedure : getScope().getAllProcedures(true)) {
         for(Variable parameter : procedure.getParameters()) {
            if(parameter.isNoModify()) {
               throw new CompileError("Error! Const parameters not supported "+parameter.getName()+" in "+ procedure.getFullName()+"()");
            }
         }
      }
      return false;
   }
   
}


package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.symbols.Label;
import dk.camelot64.kickc.model.symbols.Procedure;

import java.util.Collection;

/** Pass that checks that all functions declared have a definition with a body*/
public class Pass1AssertProcedureDefined extends Pass1Base {

   public Pass1AssertProcedureDefined(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      final Collection<Procedure> allProcedures = getScope().getAllProcedures(true);
      for(Procedure procedure : allProcedures) {
         final Label procedureLabel = procedure.getLabel();
         final ControlFlowBlock procedureBlock = getGraph().getBlock(procedureLabel.getRef());
         if(procedureBlock == null)
            throw new CompileError("Error! Function is never declared: " + procedure.getFullName());
      }
      return false;
   }

}

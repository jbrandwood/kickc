package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.ProcedureCompilation;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.symbols.Label;
import dk.camelot64.kickc.model.symbols.Procedure;

import java.util.Collection;

/** Pass that checks that all functions declared have a definition with a body */
public class Pass1AssertProcedureDefined extends Pass1Base {

   public Pass1AssertProcedureDefined(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      final Collection<Procedure> allProcedures = getProgramScope().getAllProcedures(true);
      for(Procedure procedure : allProcedures) {
         if(procedure.isDeclaredIntrinsic()) {
            if(!Procedure.INTRINSIC_PROCEDURES.contains(procedure.getLocalName()))
               throw new CompileError("Error! Undefined intrinsic function: " + procedure.getFullName());
            continue;
         }
         final Label procedureLabel = procedure.getLabel();
         final ProcedureCompilation procedureCompilation = getProgram().getProcedureCompilation(procedure.getRef());
         if(procedureCompilation == null)
            throw new CompileError("Error! Function body is never defined: " + procedure.getFullName());
         final ControlFlowBlock procedureBlock = procedureCompilation.getGraph().getBlock(procedureLabel.getRef());
         if(procedureBlock == null)
            throw new CompileError("Error! Function body is never defined: " + procedure.getFullName());
      }
      return false;
   }

}

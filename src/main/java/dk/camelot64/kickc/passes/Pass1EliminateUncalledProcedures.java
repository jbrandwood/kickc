package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.values.ProcedureRef;
import dk.camelot64.kickc.passes.utils.ProcedureUtils;

import java.util.Collection;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

/** Eliminate uncalled methods */
public class Pass1EliminateUncalledProcedures extends Pass1Base {

   public Pass1EliminateUncalledProcedures(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      Set<ProcedureRef> calledProcedures = getGraph().getAllCalledProcedures();
      //calledProcedures.add(getProgram().getStartProcedure());

      Set<ProcedureRef> unusedProcedures = new LinkedHashSet<>();
      Collection<Procedure> allProcedures = getProgram().getScope().getAllProcedures(true);
      for(Procedure procedure : allProcedures)
         if(!ProcedureUtils.isEntrypoint(procedure.getRef(), getProgram()))
            if(!calledProcedures.contains(procedure.getRef()))
               // The procedure is not used - mark for removal!
               unusedProcedures.add(procedure.getRef());

      for(ProcedureRef unusedProcedure : unusedProcedures) {
         removeProcedure(getProgram(), unusedProcedure);
      }

      return unusedProcedures.size() > 0;
   }

   /**
    * Removed a procedure from the program (the symbol in the symbol table and all blocks in the control flow graph)
    *
    * @param program The program
    * @param procedureRef The procedure to be removed
    */
   public static void removeProcedure(Program program, ProcedureRef procedureRef) {
      if(program.getLog().isVerbosePass1CreateSsa()) {
         program.getLog().append("Removing unused procedure " + procedureRef);
      }
      Procedure procedure = program.getScope().getProcedure(procedureRef);
      List<ControlFlowBlock> procedureBlocks = program.getGraph().getScopeBlocks(procedureRef);
      for(ControlFlowBlock procedureBlock : procedureBlocks) {
         program.getGraph().remove(procedureBlock.getLabel());
      }
      procedure.getScope().remove(procedure);
   }

}

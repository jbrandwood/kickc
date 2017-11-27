package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;

import java.util.Collection;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

/**  Eliminate uncalled methods  */
public class Pass1EliminateUncalledProcedures {

   private Program program;

   public Pass1EliminateUncalledProcedures(Program program) {
      this.program = program;
   }

   public void eliminate() {
      Set<ProcedureRef> calledProcedures = new LinkedHashSet<>();
      for (ControlFlowBlock block : program.getGraph().getAllBlocks()) {
         for (Statement statement : block.getStatements()) {
            if(statement instanceof StatementCall) {
               StatementCall call = (StatementCall) statement;
               ProcedureRef procedureRef = call.getProcedure();
               calledProcedures.add(procedureRef);
            }
         }
      }

      Set<ProcedureRef> unusedProcedures = new LinkedHashSet<>();
      Collection<Procedure> allProcedures = program.getScope().getAllProcedures(true);
      for (Procedure procedure : allProcedures) {
         if(!calledProcedures.contains(procedure.getRef())) {
            // The procedure is not used - mark for removal!
            unusedProcedures.add(procedure.getRef());
         }
      }

      for (ProcedureRef unusedProcedure : unusedProcedures) {
         program.getLog().append("Removing unused procedure "+unusedProcedure);
         Procedure procedure = program.getScope().getProcedure(unusedProcedure);
         List<ControlFlowBlock> procedureBlocks = program.getGraph().getScopeBlocks(unusedProcedure);
         for (ControlFlowBlock procedureBlock : procedureBlocks) {
            program.getGraph().remove(procedureBlock.getLabel());
         }
         procedure.getScope().remove(procedure);
      }


   }

}

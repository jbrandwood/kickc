package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;

import java.util.Collection;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

/**  Eliminate uncalled methods  */
public class Pass1EliminateUncalledProcedures extends Pass1Base {

   public Pass1EliminateUncalledProcedures(Program program) {
      super(program);
   }

   @Override
   boolean executeStep() {
      Set<ProcedureRef> calledProcedures = new LinkedHashSet<>();
      for (ControlFlowBlock block : getProgram().getGraph().getAllBlocks()) {
         for (Statement statement : block.getStatements()) {
            if(statement instanceof StatementCall) {
               StatementCall call = (StatementCall) statement;
               ProcedureRef procedureRef = call.getProcedure();
               calledProcedures.add(procedureRef);
            }
         }
      }

      Set<ProcedureRef> unusedProcedures = new LinkedHashSet<>();
      Collection<Procedure> allProcedures = getProgram().getScope().getAllProcedures(true);
      for (Procedure procedure : allProcedures) {
         if(!calledProcedures.contains(procedure.getRef())) {
            // The procedure is not used - mark for removal!
            unusedProcedures.add(procedure.getRef());
         }
      }

      for (ProcedureRef unusedProcedure : unusedProcedures) {
         getLog().append("Removing unused procedure "+unusedProcedure);
         Procedure procedure = getProgram().getScope().getProcedure(unusedProcedure);
         List<ControlFlowBlock> procedureBlocks = getProgram().getGraph().getScopeBlocks(unusedProcedure);
         for (ControlFlowBlock procedureBlock : procedureBlocks) {
            getProgram().getGraph().remove(procedureBlock.getLabel());
         }
         procedure.getScope().remove(procedure);
      }

      return unusedProcedures.size()>0;
   }

}

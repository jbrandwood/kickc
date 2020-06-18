package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.values.ProcedureRef;

import java.util.Collection;
import java.util.HashSet;
import java.util.List;
import java.util.ListIterator;

/** Eliminates procedures that have empty bodies. Also removes any calls to the empty procedures. */
public class PassNEliminateEmptyProcedure extends Pass2SsaOptimization {

   public PassNEliminateEmptyProcedure(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      final Collection<Procedure> allProcedures = getScope().getAllProcedures(true);
      boolean optimized = false;
      for(Procedure procedure : allProcedures) {
         if(hasEmptyBody(procedure.getRef())) {
            // Remove all calls
            removeAllCalls(procedure.getRef());
            // Remove the procedure
            Pass2EliminateUnusedBlocks.removeProcedure(procedure.getRef(), new HashSet<>(),getProgram() );
            optimized = true;
         }
      }
      return optimized;
   }

   private void removeAllCalls(ProcedureRef ref) {
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         final ListIterator<Statement> stmtIt = block.getStatements().listIterator();
         while(stmtIt.hasNext()) {
            Statement statement = stmtIt.next();
            if(statement instanceof StatementCalling && ((StatementCalling) statement).getProcedure().equals(ref)) {
               getLog().append("Removing call to empty procedure "+statement.toString(getProgram(), false));
               stmtIt.remove();
            } else if(statement instanceof StatementCallPrepare && ((StatementCallPrepare) statement).getProcedure().equals(ref)) {
               getLog().append("Removing call to empty procedure "+statement.toString(getProgram(), false));
               stmtIt.remove();
            } else if(statement instanceof StatementCallFinalize && ((StatementCallFinalize) statement).getProcedure().equals(ref)) {
               getLog().append("Removing call to empty procedure "+statement.toString(getProgram(), false));
               stmtIt.remove();
            }
         }
      }
   }

   /**
    * Looks through a procedure to determine if it has an empty body.
    *
    * @param procedureRef The procedure to look through
    * @return true if the procedure body is empty.
    */
   private boolean hasEmptyBody(ProcedureRef procedureRef) {
      final List<ControlFlowBlock> procedureBlocks = getGraph().getScopeBlocks(procedureRef);
      // The single no-args no-return call of the procedure (if found)
      for(ControlFlowBlock block : procedureBlocks) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementReturn && ((StatementReturn) statement).getValue() == null) {
               // An empty return is OK
            } else
               // Any other statement is not an empty body
               return false;
         }
      }
      // If we get this far we have an empty body
      return true;
   }


}

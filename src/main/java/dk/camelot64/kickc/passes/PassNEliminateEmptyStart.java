package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Graph;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementCall;
import dk.camelot64.kickc.model.statements.StatementReturn;
import dk.camelot64.kickc.model.values.ProcedureRef;
import dk.camelot64.kickc.model.values.SymbolRef;

import java.util.HashSet;
import java.util.List;

/** Pass that eliminates the __start() procedure if it is empty (ie. only contains a call to main() ). */
public class PassNEliminateEmptyStart extends Pass2SsaOptimization {

   public PassNEliminateEmptyStart(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      final ProcedureRef startProcRef = new ProcedureRef(SymbolRef.START_PROC_NAME);
      StatementCall singleCall = getSingleCall(startProcRef);
      if(singleCall != null) {
         // Are there any constants in the scope that are used elsewhere?
         if(!PassNEliminateEmptyProcedure.hasExternalUsages(startProcRef, getProgram())) {
            // Start only has a single call - and no external usages
            getProgram().setStartProcedure(singleCall.getProcedure());
            Pass2EliminateUnusedBlocks.removeProcedure(startProcRef, new HashSet<>(), getProgram());
            return true;
         }
      }
      return false;
   }

   /**
    * Looks through a procedure to determine if it only contains a single no-args no-return call to another procedure.
    * If it does the call is returned.
    *
    * @param procedureRef The procedure to look through
    * @return The single no-args no-return call
    */
   private StatementCall getSingleCall(ProcedureRef procedureRef) {
      final List<Graph.Block> startBlocks = getGraph().getScopeBlocks(procedureRef);
      // The single no-args no-return call of the procedure (if found)
      StatementCall singleCall = null;
      for(var block : startBlocks) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementCall) {
               if(singleCall != null)
                  // Another call already encountered
                  return null;
               final StatementCall call = (StatementCall) statement;
               if(call.getParameters() == null && call.getlValue() == null)
                  // Call is no-args no-return
                  singleCall = call;
               else
                  // Call is not no-args no-return
                  return null;
            } else if(statement instanceof StatementReturn && ((StatementReturn) statement).getValue() == null) {
               // An empty return is OK
            } else
               // Any other statement is not a single call
               return null;
         }
      }
      // If we get this far we have a single call
      return singleCall;
   }


}

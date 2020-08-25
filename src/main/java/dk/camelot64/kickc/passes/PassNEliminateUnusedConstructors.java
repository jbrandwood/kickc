package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementCallFinalize;
import dk.camelot64.kickc.model.statements.StatementCallPrepare;
import dk.camelot64.kickc.model.statements.StatementCalling;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.values.ProcedureRef;
import dk.camelot64.kickc.model.values.SymbolRef;

import java.util.*;

/** Eliminates calls from __init() to unused constructor procedures. */
public class PassNEliminateUnusedConstructors extends Pass2SsaOptimization {

   public PassNEliminateUnusedConstructors(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      boolean optimized = false;
      // Find all used constructors
      Set<ProcedureRef> allConstructors = new LinkedHashSet<>();
      for(Procedure procedure : getScope().getAllProcedures(true)) {
         allConstructors.addAll(procedure.getConstructorRefs());
      }

      Procedure startProc = getScope().getLocalProcedure(SymbolRef.START_PROC_NAME);
      if(startProc != null) {
         // find all constructor-calls in __init() pointing to unused constructors
         List<ProcedureRef> unusedConstructors = new ArrayList<>();
         final List<ControlFlowBlock> startProcBlocks = getGraph().getScopeBlocks(startProc.getRef());
         for(ControlFlowBlock block : startProcBlocks) {
            for(Statement statement : block.getStatements()) {
               if(statement instanceof StatementCalling) {
                  final ProcedureRef procedureRef = ((StatementCalling) statement).getProcedure();
                  final Procedure procedure = getScope().getProcedure(procedureRef);
                  if(procedure.isConstructor()) {
                     // This is a constructor call!
                     if(!allConstructors.contains(procedureRef)) {
                        unusedConstructors.add(procedureRef);
                     }
                  }
               }
            }
         }
         // Remove all calls to unused constructors
         for(ProcedureRef unusedConstructor : unusedConstructors) {
            removeAllCalls(unusedConstructor, startProcBlocks);
            optimized = true;
         }
      }

      return optimized;
   }

   /**
    * Remove all calls to a procedure from a number of control flow graph blocks
    *
    * @param removeProcRef The procedure to remove calls for
    * @param blocks The blocks to remove the calls from
    */
   private void removeAllCalls(ProcedureRef removeProcRef, List<ControlFlowBlock> blocks) {
      for(ControlFlowBlock block : blocks) {
         final ListIterator<Statement> stmtIt = block.getStatements().listIterator();
         while(stmtIt.hasNext()) {
            Statement statement = stmtIt.next();
            if(statement instanceof StatementCalling && ((StatementCalling) statement).getProcedure().equals(removeProcRef)) {
               getLog().append("Removing call to constructor procedure " + statement.toString(getProgram(), false));
               stmtIt.remove();
            } else if(statement instanceof StatementCallPrepare && ((StatementCallPrepare) statement).getProcedure().equals(removeProcRef)) {
               getLog().append("Removing call to constructor procedure " + statement.toString(getProgram(), false));
               stmtIt.remove();
            } else if(statement instanceof StatementCallFinalize && ((StatementCallFinalize) statement).getProcedure().equals(removeProcRef)) {
               getLog().append("Removing call to constructor procedure " + statement.toString(getProgram(), false));
               stmtIt.remove();
            }
         }
         if(removeProcRef.getLabelRef().equals(block.getCallSuccessor())) {
            block.setCallSuccessor(null);
         }
      }
   }

}

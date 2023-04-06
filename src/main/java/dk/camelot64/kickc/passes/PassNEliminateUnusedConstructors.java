package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
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
      for(Procedure procedure : getProgramScope().getAllProcedures(true)) {
         allConstructors.addAll(procedure.getConstructorRefs());
      }

      Procedure startProc = getProgramScope().getLocalProcedure(SymbolRef.START_PROC_NAME);
      if(startProc != null) {
         // find all constructor-calls in __init() pointing to unused constructors
         List<ProcedureRef> unusedConstructors = new ArrayList<>();
         final List<ControlFlowBlock> startProcBlocks = getGraph().getScopeBlocks(startProc.getRef());
         for(ControlFlowBlock block : startProcBlocks) {
            for(Statement statement : block.getStatements()) {
               if(statement instanceof StatementCalling) {
                  final ProcedureRef procedureRef = ((StatementCalling) statement).getProcedure();
                  final Procedure procedure = getProgramScope().getProcedure(procedureRef);
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
            PassNEliminateEmptyProcedure.removeAllCalls(unusedConstructor, startProcBlocks, getLog());
            optimized = true;
         }
      }

      return optimized;
   }

}

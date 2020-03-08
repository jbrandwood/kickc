package dk.camelot64.kickc.passes.calcs;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.values.ProcedureRef;
import dk.camelot64.kickc.model.values.VariableRef;

import java.util.*;

/**
 * Find effective alive intervals for all variables in all statements. Add the intervals to the Program.
 */
public class PassNCalcLiveRangesEffectiveSimple extends PassNCalcBase<LiveRangeVariablesEffectiveSimple> {

   public PassNCalcLiveRangesEffectiveSimple(Program program) {
      super(program);
   }

   @Override
   public LiveRangeVariablesEffectiveSimple calculate() {
      final LiveRangeVariables liveRangeVariables = getProgram().getLiveRangeVariables();
      final CallGraph callGraph = getProgram().getCallGraph();
      final LiveRangeVariables.LiveRangeVariablesByStatement liveRangeVariablesByStatement = liveRangeVariables.getLiveRangeVariablesByStatement();

      // Find all alive vars from the recursive callers of each procedure
      Map<ProcedureRef, Collection<VariableRef>> callersAlive = new LinkedHashMap<>();
      Collection<Procedure> procedures = getProgram().getScope().getAllProcedures(true);
      for(Procedure procedure : procedures) {
         Collection<VariableRef> procCallersAlive = new LinkedHashSet<>();
         final Collection<CallGraph.CallBlock.Call> callers = callGraph.getRecursiveCallers(procedure.getRef());
         for(CallGraph.CallBlock.Call caller : callers) {
            final Integer callStatementIdx = caller.getCallStatementIdx();
            final List<VariableRef> callStatementAlive = liveRangeVariables.getAlive(callStatementIdx);
            procCallersAlive.addAll(callStatementAlive);
         }
         callersAlive.put(procedure.getRef(), procCallersAlive);
      }

      // Find all alive variables for all statements by adding the alive from all recursive callers
      final LinkedHashMap<Integer, Collection<VariableRef>> statementAliveEffective = new LinkedHashMap<>();
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         final Procedure procedure = block.getProcedure(getProgram());
         for(Statement statement : block.getStatements()) {
            final Collection<VariableRef> aliveStmt = new LinkedHashSet<>();
            aliveStmt.addAll(liveRangeVariablesByStatement.getAlive(statement.getIndex()));
            if(procedure!=null) {
               aliveStmt.addAll(callersAlive.get(procedure.getRef()));
            }
            statementAliveEffective.put(statement.getIndex(), aliveStmt);
         }
      }
      return new LiveRangeVariablesEffectiveSimple(statementAliveEffective);
   }


}

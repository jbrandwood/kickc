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
      final Map<ProcedureRef, Collection<VariableRef>> procedureReferencedVars = PassNCalcLiveRangeVariables.calculateProcedureReferencedVars(getProgram());

      // All variables alive outside a call. This is variables that are alive across the call that are not touched by the procedure (or any sub-procedure).
      Map<CallGraph.CallBlock.Call, Collection<VariableRef>> aliveOutsideCalls = new LinkedHashMap<>();
      // All variables alive outside all calls to a procedure. This is variables that are alive across a call that are not touched by the procedure (or any sub-procedure).
      Map<ProcedureRef, Collection<VariableRef>> aliveOutsideProcedures = new LinkedHashMap<>();
      Collection<Procedure> procedures = getProgram().getScope().getAllProcedures(true);
      for(Procedure procedure : procedures) {
         Collection<VariableRef> aliveOutsideProcedure = new LinkedHashSet<>();
         final Collection<CallGraph.CallBlock.Call> callers = callGraph.getRecursiveCallers(procedure.getRef());
         for(CallGraph.CallBlock.Call caller : callers) {
            final Integer callStatementIdx = caller.getCallStatementIdx();
            final Statement callStatement = getGraph().getStatementByIndex(callStatementIdx);
            final Collection<Statement> precedingStatements = PassNCalcLiveRangeVariables.getPrecedingStatement(callStatement, getGraph(), getProgram().getStatementInfos());
            Collection<VariableRef> aliveOutsideCall = new LinkedHashSet<>();
            for(Statement precedingStatement : precedingStatements) {
               final List<VariableRef> precedingStatementAlive = liveRangeVariables.getAlive(precedingStatement.getIndex());
               aliveOutsideCall.addAll(precedingStatementAlive);
            }
            final Collection<VariableRef> procedureReferenced = procedureReferencedVars.get(procedure.getRef());
            aliveOutsideCall.removeAll(procedureReferenced);
            aliveOutsideCalls.put(caller, aliveOutsideCall);
            aliveOutsideProcedure.addAll(aliveOutsideCall);
         }
         aliveOutsideProcedures.put(procedure.getRef(), aliveOutsideProcedure);
      }

      // Find all alive variables for all statements by adding the everything alive outside each call
      final LinkedHashMap<Integer, Collection<VariableRef>> statementAliveEffective = new LinkedHashMap<>();
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         final Procedure procedure = block.getProcedure(getProgram());
         for(Statement statement : block.getStatements()) {
            final Collection<VariableRef> aliveStmt = new LinkedHashSet<>();
            final List<VariableRef> aliveStatement = liveRangeVariablesByStatement.getAlive(statement.getIndex());
            aliveStmt.addAll(aliveStatement);
            if(procedure!=null) {
               final Collection<VariableRef> aliveOutsideProcedure = aliveOutsideProcedures.get(procedure.getRef());
               aliveStmt.addAll(aliveOutsideProcedure);
            }
            statementAliveEffective.put(statement.getIndex(), aliveStmt);
         }
      }
      return new LiveRangeVariablesEffectiveSimple(statementAliveEffective);
   }


}

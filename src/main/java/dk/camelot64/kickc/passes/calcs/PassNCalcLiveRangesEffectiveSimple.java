package dk.camelot64.kickc.passes.calcs;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.values.CastValue;
import dk.camelot64.kickc.model.values.ProcedureRef;
import dk.camelot64.kickc.model.values.RValue;
import dk.camelot64.kickc.model.values.VariableRef;
import dk.camelot64.kickc.passes.Pass2AliasElimination;
import dk.camelot64.kickc.passes.Pass2NopCastInlining;

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
               for(VariableRef precedingStatementAliveVarRef : precedingStatementAlive) {
                  if(!precedingStatementAliveVarRef.getScopeNames().equals(caller.getProcedure().getFullName())) {
                     // Skipping variables alive preceeding the caller from the called scope (these are parameters and are handled by local live ranges)
                     aliveOutsideCall.add(precedingStatementAliveVarRef);
                  }
               }
            }
            final Collection<VariableRef> procedureReferenced = procedureReferencedVars.get(procedure.getRef());
            aliveOutsideCall.removeAll(procedureReferenced);
            aliveOutsideCalls.put(caller, aliveOutsideCall);
            aliveOutsideProcedure.addAll(aliveOutsideCall);
         }
         aliveOutsideProcedures.put(procedure.getRef(), aliveOutsideProcedure);
      }

      // Find all alive variables for all statements by adding everything alive outside each call (not including variables from the called scope)
      final LinkedHashMap<Integer, Collection<VariableRef>> statementAliveEffective = new LinkedHashMap<>();
      for(var block : getGraph().getAllBlocks()) {
         final Procedure procedure = getProgram().getProcedure(block);
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

      // Find aliases inside each block
      Map<Integer, Pass2AliasElimination.Aliases> statementAliases = new LinkedHashMap<>();
      for(var block : getGraph().getAllBlocks()) {
         Pass2AliasElimination.Aliases blockAliases = new Pass2AliasElimination.Aliases();
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               if(assignment.getrValue1()==null && assignment.getOperator()==null) {

                  RValue rValue = assignment.getrValue2();
                  if(rValue instanceof CastValue) {
                     // A cast - examine if it is a noop-cast
                     final CastValue castValue = (CastValue) rValue;
                     if(castValue.getValue() instanceof VariableRef) {
                        final VariableRef subVarRef = (VariableRef) castValue.getValue();
                        final Variable subVar = getScope().getVariable(subVarRef);
                        if(Pass2NopCastInlining.isNopCast(castValue.getToType(), subVar.getType())) {
                           // Found a Nop Cast of a variable - use the variable
                           rValue = subVarRef;
                        }
                     }
                  }
                  if(assignment.getlValue() instanceof VariableRef && rValue instanceof VariableRef) {
                     final VariableRef lValueRef = (VariableRef) assignment.getlValue();
                     final VariableRef rValueRef = (VariableRef) rValue;
                     if((lValueRef.isIntermediate() || lValueRef.isVersion()) && (rValueRef.isIntermediate() || rValueRef.isVersion()) ) {
                        // Identified an alias assignment of versioned/intermediate variables!
                        blockAliases.add(lValueRef, rValueRef);
                     }
                  }
               }
            }
            statementAliases.put(statement.getIndex(), new Pass2AliasElimination.Aliases(blockAliases));
         }
      }

      return new LiveRangeVariablesEffectiveSimple(statementAliveEffective, statementAliases);
   }


}

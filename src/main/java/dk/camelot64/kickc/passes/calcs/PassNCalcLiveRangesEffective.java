package dk.camelot64.kickc.passes.calcs;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.statements.StatementPhiBlock;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.symbols.SymbolVariable;
import dk.camelot64.kickc.model.values.*;
import dk.camelot64.kickc.passes.Pass2AliasElimination;
import dk.camelot64.kickc.passes.Pass2ConstantIdentification;

import java.util.*;

/**
 * Find effective alive intervals for all variables in all statements. Add the intervals to the Program.
 */
public class PassNCalcLiveRangesEffective extends PassNCalcBase<LiveRangeVariablesEffective> {

   public PassNCalcLiveRangesEffective(Program program) {
      super(program);
   }

   /**
    * Call-paths for all procedures.
    */
   private Map<ProcedureRef, LiveRangeVariablesEffective.CallPaths> procedureCallPaths;

   /**
    * Normal variable live ranges.
    */
   private LiveRangeVariables liveRangeVariables;

   /**
    * Information about which procedures reference which variables.
    */
   private VariableReferenceInfos referenceInfo;

   @Override
   public LiveRangeVariablesEffective calculate() {
      this.liveRangeVariables = getProgram().getLiveRangeVariables();
      this.referenceInfo = getProgram().getVariableReferenceInfos();
      this.procedureCallPaths = new LinkedHashMap<>();
      populateProcedureCallPaths();
      LiveRangeVariablesEffective aliveEffective = new LiveRangeVariablesEffective(getProgram(), procedureCallPaths, liveRangeVariables, referenceInfo);
      return aliveEffective;
      //getLog().append("Calculated effective variable live ranges");
   }

   private void populateProcedureCallPaths() {
      this.procedureCallPaths = new LinkedHashMap<>();
      Collection<Procedure> procedures = getProgram().getScope().getAllProcedures(true);
      for(Procedure procedure : procedures) {
         populateProcedureCallPaths(procedure, new HashSet<>());
      }
   }

   private void populateProcedureCallPaths(Procedure procedure, Set<ProcedureRef> visited) {
      // Avoid recursion
      if(visited.contains(procedure.getRef()))
         return;
      visited.add(procedure.getRef());

      ProcedureRef procedureRef = procedure.getRef();
      LiveRangeVariablesEffective.CallPaths callPaths = procedureCallPaths.get(procedureRef);
      if(callPaths == null) {
         callPaths = new LiveRangeVariablesEffective.CallPaths(procedureRef);

         if(procedure.getInterruptType()!=null || Pass2ConstantIdentification.isAddressOfUsed(procedureRef, getProgram())) {
            // Interrupt is called outside procedure scope - create initial call-path.
            ArrayList<CallGraph.CallBlock.Call> rootPath = new ArrayList<>();
            ArrayList<VariableRef> rootAlive = new ArrayList<>();
            // Initialize with global cross-scope aliases (assumed empty)
            Pass2AliasElimination.Aliases rootAliases = new Pass2AliasElimination.Aliases();
            LiveRangeVariablesEffective.CallPath rootCallPath = new LiveRangeVariablesEffective.CallPath(rootPath, rootAlive, rootAliases, rootAliases);
            callPaths.add(rootCallPath);
         }

         Collection<CallGraph.CallBlock.Call> callers =
               getProgram().getCallGraph().getCallers(procedure.getRef());
         for(CallGraph.CallBlock.Call caller : callers) {
            // Each caller creates its own call-paths
            int callStatementIdx = caller.getCallStatementIdx();
            ControlFlowBlock callBlock = getProgram().getStatementInfos().getBlock(callStatementIdx);
            ScopeRef callScopeRef = callBlock.getScope();
            Scope callScope = getProgram().getScope().getScope(callScopeRef);
            if(callScope instanceof Procedure) {
               // Found calling procedure!
               Procedure callerProcedure = (Procedure) callScope;
               // Make sure we have populated the call-paths of the calling procedure
               populateProcedureCallPaths(callerProcedure, visited);
               // Find variables referenced in caller procedure
               Collection<VariableRef> referencedInCaller = referenceInfo.getReferencedVars(callerProcedure.getRef().getLabelRef());
               // For each caller path - create a new call-path
               LiveRangeVariablesEffective.CallPaths callerPaths = procedureCallPaths.get(callerProcedure.getRef());
               if(callerPaths!=null) 
               for(LiveRangeVariablesEffective.CallPath callerPath : callerPaths.getCallPaths()) {
                  ArrayList<CallGraph.CallBlock.Call> path = new ArrayList<>(callerPath.getPath());
                  path.add(caller);
                  Collection<VariableRef> alive = new LinkedHashSet<>();
                  alive.addAll(callerPath.getAlive());
                  alive.removeAll(referencedInCaller);
                  alive.addAll(liveRangeVariables.getAlive(callStatementIdx));
                  Pass2AliasElimination.Aliases innerAliases = getCallAliases(procedure, callBlock);
                  Pass2AliasElimination.Aliases pathAliases = new Pass2AliasElimination.Aliases();
                  pathAliases.addAll(callerPath.getPathAliases());
                  pathAliases.addAll(innerAliases);
                  LiveRangeVariablesEffective.CallPath callPath = new LiveRangeVariablesEffective.CallPath(path, alive, innerAliases, pathAliases);
                  callPaths.add(callPath);
               }
            } else {
               // main() call outside procedure scope - create initial call-path.
               ArrayList<CallGraph.CallBlock.Call> rootPath = new ArrayList<>();
               rootPath.add(caller);
               ArrayList<VariableRef> rootAlive = new ArrayList<>();
               // Initialize with global cross-scope aliases (assumed empty)
               Pass2AliasElimination.Aliases rootAliases = new Pass2AliasElimination.Aliases();
               LiveRangeVariablesEffective.CallPath rootCallPath = new LiveRangeVariablesEffective.CallPath(rootPath, rootAlive, rootAliases, rootAliases);
               callPaths.add(rootCallPath);
            }
         }
         procedureCallPaths.put(procedureRef, callPaths);
      }
   }

   /**
    * Find aliases defined when taking a specific call - meaning call parameters that have specific values when taking the specific call.
    *
    * @param procedure The called procedure
    * @param callBlock The block performing the call
    * @return Aliases defined by the specific call.
    */
   private Pass2AliasElimination.Aliases getCallAliases(Procedure procedure, ControlFlowBlock callBlock) {
      ControlFlowBlock procedureBlock = getProgram().getGraph().getBlock(procedure.getLabel().getRef());
      StatementPhiBlock procedurePhiBlock = null;
      if(procedureBlock.hasPhiBlock()) {
         procedurePhiBlock = procedureBlock.getPhiBlock();
      }
      Pass2AliasElimination.Aliases aliases = new Pass2AliasElimination.Aliases();
      // Find aliases inside the phi-block of the called method
      if(procedurePhiBlock != null) {
         for(StatementPhiBlock.PhiVariable phiVariable : procedurePhiBlock.getPhiVariables()) {
            RValue phiRvalue = phiVariable.getrValue(callBlock.getLabel());
            if(phiRvalue instanceof VariableRef) {
               aliases.add(phiVariable.getVariable(), (VariableRef) phiRvalue);
            }
         }
      }
      // Find call parameter aliases in the calling block before the call
      for(Statement statement : callBlock.getStatements()) {
         if(statement instanceof StatementAssignment) {
            StatementAssignment assignment = (StatementAssignment) statement;
            LValue lValue = assignment.getlValue();
            if(lValue instanceof VariableRef) {
               SymbolVariable lValueVar = getProgram().getScope().getVariable((VariableRef) lValue);
               if(lValueVar.getScope().equals(procedure)) {
                  // Assigning into the procedure scope
                  if(assignment.getrValue1() == null && assignment.getOperator() == null && assignment.getrValue2() instanceof VariableRef) {
                     aliases.add((VariableRef) lValue, (VariableRef) assignment.getrValue2());
                  }
               }
            }
         }
      }
      return aliases;
   }


}

package dk.camelot64.kickc.passes.calcs;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.statements.StatementConditionalJump;
import dk.camelot64.kickc.model.statements.StatementPhiBlock;
import dk.camelot64.kickc.model.values.*;

import java.util.Collection;

/**
 * Finds register weights for all variables.
 * <p>
 * The register weight signifies how beneficial it would be for the variable to assigned to a register (instead of zero page).
 * <p>
 * Uses Loop Depth and Live Ranges plus the statements of the control flow graph.
 * <p>
 * Based on ComputeWeight from http://compilers.cs.ucla.edu/fernando/projects/soc/reports/short_tech.pdf
 */
public class PassNCalcVariableRegisterWeight extends PassNCalcBase<VariableRegisterWeights> {

   public PassNCalcVariableRegisterWeight(Program program) {
      super(program);
   }

   /**
    * Find register weights for all variables
    */
   @Override
   public VariableRegisterWeights calculate() {
      NaturalLoopSet loopSet = getProgram().getLoopSet();
      final CallGraph callGraph = getProgram().getCallGraph();
      LiveRangeVariables liveRangeVariables = getProgram().getLiveRangeVariables();
      VariableRegisterWeights variableRegisterWeights = new VariableRegisterWeights();
      final StatementInfos statementInfos = getProgram().getStatementInfos();

      for(ControlFlowBlock block : getProgram().getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementPhiBlock) {
               for(StatementPhiBlock.PhiVariable phiVariable : ((StatementPhiBlock) statement).getPhiVariables()) {
                  // Add weights for the definition of the phi variable
                  VariableRef philVariable = phiVariable.getVariable();
                  for(StatementPhiBlock.PhiRValue phiRValue : phiVariable.getValues()) {
                     if(phiRValue.getrValue() instanceof VariableRef) {
                        addWeight(philVariable, phiRValue.getPredecessor(), liveRangeVariables, loopSet, callGraph, statementInfos, variableRegisterWeights);
                     }
                  }
                  // Add weights for each usage of a variable
                  for(StatementPhiBlock.PhiRValue phiRValue : phiVariable.getValues()) {
                     addUsageWeightRValue(phiRValue.getrValue(), phiRValue.getPredecessor(), variableRegisterWeights, loopSet, callGraph, statementInfos, liveRangeVariables);
                  }
               }
            } else if(statement instanceof StatementAssignment) {
               // Add weights for the definition of the variable
               addUsageWeightRValue(((StatementAssignment) statement).getlValue(), block.getLabel(), variableRegisterWeights, loopSet, callGraph, statementInfos, liveRangeVariables);
               // Add weights for each usage of variables
               addUsageWeightRValue(((StatementAssignment) statement).getrValue1(), block.getLabel(), variableRegisterWeights, loopSet, callGraph, statementInfos, liveRangeVariables);
               addUsageWeightRValue(((StatementAssignment) statement).getrValue2(), block.getLabel(), variableRegisterWeights, loopSet, callGraph, statementInfos, liveRangeVariables);
            } else if(statement instanceof StatementConditionalJump) {
               // Add weights for each usage of variables
               addUsageWeightRValue(((StatementConditionalJump) statement).getrValue1(), block.getLabel(), variableRegisterWeights, loopSet, callGraph, statementInfos, liveRangeVariables);
               addUsageWeightRValue(((StatementConditionalJump) statement).getrValue2(), block.getLabel(), variableRegisterWeights, loopSet, callGraph, statementInfos, liveRangeVariables);
            }
         }
      }
      return variableRegisterWeights;
   }

   private static void addUsageWeightRValue(Value rValue, LabelRef block, VariableRegisterWeights variableRegisterWeights, NaturalLoopSet loopSet, CallGraph callGraph, StatementInfos statementInfos, LiveRangeVariables liveRangeVariables) {
      if(rValue instanceof VariableRef) {
         addWeight((VariableRef) rValue, block, liveRangeVariables, loopSet, callGraph, statementInfos, variableRegisterWeights);
      } else if(rValue instanceof PointerDereferenceSimple) {
         addUsageWeightRValue(((PointerDereferenceSimple) rValue).getPointer(), block, variableRegisterWeights, loopSet, callGraph, statementInfos, liveRangeVariables);
      } else if(rValue instanceof PointerDereferenceIndexed) {
         addUsageWeightRValue(((PointerDereferenceIndexed) rValue).getPointer(), block, variableRegisterWeights, loopSet, callGraph, statementInfos, liveRangeVariables);
         addUsageWeightRValue(((PointerDereferenceIndexed) rValue).getIndex(), block, variableRegisterWeights, loopSet, callGraph, statementInfos, liveRangeVariables);
      }
   }

   private static double addWeight(VariableRef variable, LabelRef block, LiveRangeVariables liveRangeVariables, NaturalLoopSet loopSet, CallGraph callGraph, StatementInfos statementInfos, VariableRegisterWeights variableRegisterWeights) {
      int loopCallDepth = getLoopCallDepth(block, loopSet, callGraph,statementInfos);
      double w = 1.0 + Math.pow(10.0, loopCallDepth);
      LiveRange liveRange = liveRangeVariables.getLiveRange(variable);
      double s = liveRange == null ? 0.0 : liveRange.size();
      if(s < 0.01) {
         s = 0.1;
      }
      variableRegisterWeights.addWeight(variable, w / s);
      return w / s;
   }

   /**
    * Get the loop/call depth of a block.
    *
    * @param block The block to examine
    * @param loopSet The loop set
    * @param callGraph The call graph
    * @return The combined loop/call depth
    */
   private static int getLoopCallDepth(LabelRef block, NaturalLoopSet loopSet, CallGraph callGraph, StatementInfos statementInfos) {
      final String procedureName = block.getFullName().contains("::") ? block.getScopeNames() : block.getFullName();
      final ProcedureRef procedureRef = new ProcedureRef(procedureName);
      final Collection<CallGraph.CallBlock.Call> callers = callGraph.getCallers(procedureRef);
      int maxCallDepth = 0;
      for(CallGraph.CallBlock.Call caller : callers) {
         final Integer callStatementIdx = caller.getCallStatementIdx();
         final ControlFlowBlock callBlock = statementInfos.getBlock(callStatementIdx);
         int callDepth = getLoopCallDepth(callBlock.getLabel(), loopSet, callGraph, statementInfos) + 1;
         if(callDepth > maxCallDepth)
            maxCallDepth = callDepth;
      }
      int loopDepth = loopSet.getMaxLoopDepth(block);
      return maxCallDepth + loopDepth;
   }


}

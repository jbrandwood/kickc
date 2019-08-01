package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.statements.StatementConditionalJump;
import dk.camelot64.kickc.model.statements.StatementPhiBlock;
import dk.camelot64.kickc.model.values.*;

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
      LiveRangeVariables liveRangeVariables = getProgram().getLiveRangeVariables();
      VariableRegisterWeights variableRegisterWeights = new VariableRegisterWeights();

      for(ControlFlowBlock block : getProgram().getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementPhiBlock) {
               for(StatementPhiBlock.PhiVariable phiVariable : ((StatementPhiBlock) statement).getPhiVariables()) {
                  // Add weights for the definition of the phi variable
                  VariableRef philVariable = phiVariable.getVariable();
                  for(StatementPhiBlock.PhiRValue phiRValue : phiVariable.getValues()) {
                     if(phiRValue.getrValue() instanceof VariableRef) {
                        double w = addWeight(philVariable, phiRValue.getPredecessor(), variableRegisterWeights, loopSet, liveRangeVariables);
                        //log.append("Definition of " + philVariable + " w+:" + w + " - [" + statement.getIndex()+"]");
                     }
                  }
                  // Add weights for each usage of a variable
                  for(StatementPhiBlock.PhiRValue phiRValue : phiVariable.getValues()) {
                     addUsageWeightRValue(phiRValue.getrValue(), statement, phiRValue.getPredecessor(), variableRegisterWeights, loopSet, liveRangeVariables);
                  }
               }
            } else if(statement instanceof StatementAssignment) {
               // Add weights for the definition of the variable
               addUsageWeightRValue(((StatementAssignment) statement).getlValue(), statement, block.getLabel(), variableRegisterWeights, loopSet, liveRangeVariables);
               // Add weights for each usage of variables
               addUsageWeightRValue(((StatementAssignment) statement).getrValue1(), statement, block.getLabel(), variableRegisterWeights, loopSet, liveRangeVariables);
               addUsageWeightRValue(((StatementAssignment) statement).getrValue2(), statement, block.getLabel(), variableRegisterWeights, loopSet, liveRangeVariables);
            } else if(statement instanceof StatementConditionalJump) {
               // Add weights for each usage of variables
               addUsageWeightRValue(((StatementConditionalJump) statement).getrValue1(), statement, block.getLabel(), variableRegisterWeights, loopSet, liveRangeVariables);
               addUsageWeightRValue(((StatementConditionalJump) statement).getrValue2(), statement, block.getLabel(), variableRegisterWeights, loopSet, liveRangeVariables);
            }
         }
      }
      return variableRegisterWeights;
   }

   private static void addUsageWeightRValue(Value rValue, Statement statement, LabelRef block, VariableRegisterWeights variableRegisterWeights, NaturalLoopSet loopSet, LiveRangeVariables liveRangeVariables) {
      if(rValue instanceof VariableRef) {
         double w = addWeight((VariableRef) rValue, block, variableRegisterWeights, loopSet, liveRangeVariables);
         //log.append("Usage of " + rValue + " w+:" + w + " - [" + statement.getIndex()+"]");
      } else if(rValue instanceof PointerDereferenceSimple) {
         addUsageWeightRValue(((PointerDereferenceSimple) rValue).getPointer(), statement, block, variableRegisterWeights, loopSet, liveRangeVariables);
      } else if(rValue instanceof PointerDereferenceIndexed) {
         addUsageWeightRValue(((PointerDereferenceIndexed) rValue).getPointer(), statement, block, variableRegisterWeights, loopSet, liveRangeVariables);
         addUsageWeightRValue(((PointerDereferenceIndexed) rValue).getIndex(), statement, block, variableRegisterWeights, loopSet, liveRangeVariables);
      }
   }

   private static double addWeight(VariableRef variable, LabelRef block, VariableRegisterWeights variableRegisterWeights, NaturalLoopSet loopSet, LiveRangeVariables liveRangeVariables) {
      int depth = loopSet.getMaxLoopDepth(block);
      double w = 1.0 + Math.pow(10.0, depth);
      LiveRange liveRange = liveRangeVariables.getLiveRange(variable);
      double s = liveRange.size();
      if(s < 0.01) {
         s = 0.1;
      }
      variableRegisterWeights.addWeight(variable, w / s);
      return w / s;
   }


}

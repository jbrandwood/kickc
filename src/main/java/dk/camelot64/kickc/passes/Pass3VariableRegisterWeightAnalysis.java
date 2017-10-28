package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;

/**
 * Finds register weights for all variables.
 * <p>
 * The register weight signifies how beneficial it would be for the variable to assigned to a register (instead of zero page).
 * <p>
 * Uses Loop Depth and Live Ranges plus the statements of the control flow graph.
 * <p>
 * Based on ComputeWeight from http://compilers.cs.ucla.edu/fernando/projects/soc/reports/short_tech.pdf
 */
public class Pass3VariableRegisterWeightAnalysis extends Pass2Base {

   private NaturalLoopSet loopSet;
   private VariableRegisterWeights variableRegisterWeights;
   private LiveRangeVariables liveRangeVariables;

   public Pass3VariableRegisterWeightAnalysis(Program program) {
      super(program);
   }

   /**
    * Find register weights for all variables
    */
   public void findWeights() {

      variableRegisterWeights = new VariableRegisterWeights();
      loopSet = getProgram().getLoopSet();
      liveRangeVariables = getProgram().getLiveRangeVariables();

      for (ControlFlowBlock block : getProgram().getGraph().getAllBlocks()) {
         for (Statement statement : block.getStatements()) {
            if (statement instanceof StatementPhiBlock) {
               for (StatementPhiBlock.PhiVariable phiVariable : ((StatementPhiBlock) statement).getPhiVariables()) {
                  // Add weights for the definition of the phi variable
                  VariableRef philVariable = phiVariable.getVariable();
                  for (StatementPhiBlock.PhiRValue phiRValue : phiVariable.getValues()) {
                     if (phiRValue.getrValue() instanceof VariableRef) {
                        double w = addWeight(philVariable, phiRValue.getPredecessor());
                        //log.append("Definition of " + philVariable + " w+:" + w + " - [" + statement.getIndex()+"]");
                     }
                  }
                  // Add weights for each usage of a variable
                  for (StatementPhiBlock.PhiRValue phiRValue : phiVariable.getValues()) {
                     addUsageWeightRValue(phiRValue.getrValue(), statement, phiRValue.getPredecessor());
                  }
               }
            } else if (statement instanceof StatementAssignment) {
               // Add weights for the definition of the variable
               LValue lValue = ((StatementAssignment) statement).getlValue();
               if (lValue instanceof VariableRef) {
                  double w = addWeight((VariableRef) lValue, block.getLabel());
                  //log.append("Definition of " + lValue + " w+:" + w + " - [" + statement.getIndex()+"]");
               }
               // Also add weight to used pointers
               if(lValue instanceof PointerDereferenceSimple) {
                  addUsageWeightRValue(((PointerDereferenceSimple) lValue).getPointer(), statement, block.getLabel());
               } else if(lValue instanceof PointerDereferenceIndexed) {
                  addUsageWeightRValue(((PointerDereferenceIndexed) lValue).getPointer(), statement, block.getLabel());
                  addUsageWeightRValue(((PointerDereferenceIndexed) lValue).getIndex(), statement, block.getLabel());
               }
               // Add weights for each usage of variables
               addUsageWeightRValue(((StatementAssignment) statement).getrValue1(), statement, block.getLabel());
               addUsageWeightRValue(((StatementAssignment) statement).getrValue2(), statement, block.getLabel());
            } else if (statement instanceof StatementConditionalJump) {
               // Add weights for each usage of variables
               addUsageWeightRValue(((StatementConditionalJump) statement).getrValue1(), statement, block.getLabel());
               addUsageWeightRValue(((StatementConditionalJump) statement).getrValue2(), statement, block.getLabel());
            }
         }
      }

      getProgram().setVariableRegisterWeights(variableRegisterWeights);

   }

   private void addUsageWeightRValue(Value rValue, Statement statement, LabelRef block) {
      if (rValue instanceof VariableRef) {
         double w = addWeight((VariableRef) rValue, block);
         //log.append("Usage of " + rValue + " w+:" + w + " - [" + statement.getIndex()+"]");
      }
   }

   private double addWeight(VariableRef variable, LabelRef block) {
      Variable var = getProgram().getScope().getVariable(variable);
      int depth = loopSet.getMaxLoopDepth(block);
      double w = 1.0 + Math.pow(10.0, depth);
      LiveRange liveRange = liveRangeVariables.getLiveRange(variable);
      double s = liveRange.size();
      if(s<0.01) {
         s = 0.1;
      }
      variableRegisterWeights.addWeight(variable, w/s);
      return w/s;
   }


}

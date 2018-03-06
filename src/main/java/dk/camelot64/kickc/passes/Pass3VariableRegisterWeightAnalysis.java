package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.values.*;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.statements.StatementConditionalJump;
import dk.camelot64.kickc.model.statements.StatementPhiBlock;
import dk.camelot64.kickc.model.symbols.Variable;

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

      for(ControlFlowBlock block : getProgram().getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementPhiBlock) {
               for(StatementPhiBlock.PhiVariable phiVariable : ((StatementPhiBlock) statement).getPhiVariables()) {
                  // Add weights for the definition of the phi variable
                  VariableRef philVariable = phiVariable.getVariable();
                  for(StatementPhiBlock.PhiRValue phiRValue : phiVariable.getValues()) {
                     if(phiRValue.getrValue() instanceof VariableRef) {
                        double w = addWeight(philVariable, phiRValue.getPredecessor());
                        //log.append("Definition of " + philVariable + " w+:" + w + " - [" + statement.getIndex()+"]");
                     }
                  }
                  // Add weights for each usage of a variable
                  for(StatementPhiBlock.PhiRValue phiRValue : phiVariable.getValues()) {
                     addUsageWeightRValue(phiRValue.getrValue(), statement, phiRValue.getPredecessor());
                  }
               }
            } else if(statement instanceof StatementAssignment) {
               // Add weights for the definition of the variable
               addUsageWeightRValue(((StatementAssignment) statement).getlValue(), statement, block.getLabel());
               // Add weights for each usage of variables
               addUsageWeightRValue(((StatementAssignment) statement).getrValue1(), statement, block.getLabel());
               addUsageWeightRValue(((StatementAssignment) statement).getrValue2(), statement, block.getLabel());
            } else if(statement instanceof StatementConditionalJump) {
               // Add weights for each usage of variables
               addUsageWeightRValue(((StatementConditionalJump) statement).getrValue1(), statement, block.getLabel());
               addUsageWeightRValue(((StatementConditionalJump) statement).getrValue2(), statement, block.getLabel());
            }
         }
      }

      getProgram().setVariableRegisterWeights(variableRegisterWeights);

   }

   private void addUsageWeightRValue(Value rValue, Statement statement, LabelRef block) {
      if(rValue instanceof VariableRef) {
         double w = addWeight((VariableRef) rValue, block);
         //log.append("Usage of " + rValue + " w+:" + w + " - [" + statement.getIndex()+"]");
      } else if(rValue instanceof PointerDereferenceSimple) {
         addUsageWeightRValue(((PointerDereferenceSimple) rValue).getPointer(), statement, block);
      } else if(rValue instanceof PointerDereferenceIndexed) {
         addUsageWeightRValue(((PointerDereferenceIndexed) rValue).getPointer(), statement, block);
         addUsageWeightRValue(((PointerDereferenceIndexed) rValue).getIndex(), statement, block);
      }
   }

   private double addWeight(VariableRef variable, LabelRef block) {
      Variable var = getProgram().getScope().getVariable(variable);
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

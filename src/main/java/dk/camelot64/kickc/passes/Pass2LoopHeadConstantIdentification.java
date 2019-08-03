package dk.camelot64.kickc.passes;


import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementConditionalJump;
import dk.camelot64.kickc.model.statements.StatementPhiBlock;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.values.ConstantValue;
import dk.camelot64.kickc.model.values.LabelRef;
import dk.camelot64.kickc.model.values.ScopeRef;
import dk.camelot64.kickc.model.values.VariableRef;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

/**
 * Identify loop heads where the condition is constant when examind the first time
 */
public class Pass2LoopHeadConstantIdentification extends Pass2SsaOptimization {

   public Pass2LoopHeadConstantIdentification(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      VariableReferenceInfos variableReferenceInfos = getProgram().getVariableReferenceInfos();
      NaturalLoopSet loopSet = getProgram().getLoopSet();
      for(NaturalLoop loop : loopSet.getLoops()) {
         LabelRef loopHeadRef = loop.getHead();
         ControlFlowBlock loopHeadBlock = getGraph().getBlock(loopHeadRef);
         boolean modified = optimizeLoopHead(loopHeadBlock, loop, variableReferenceInfos);
         if(modified) {
            getProgram().clearLoopSet();
            getProgram().clearDominators();
            return true;
         }
      }
      return false;
   }

   private boolean optimizeLoopHead(ControlFlowBlock loopHeadBlock, NaturalLoop loop, VariableReferenceInfos variableReferenceInfos) {
      if(loopHeadBlock.getConditionalSuccessor() != null && loopHeadBlock.hasPhiBlock()) {
         // Find the variables used in the continue/end condition
         StatementConditionalJump condition = null;
         for(Statement statement : loopHeadBlock.getStatements()) {
            if(statement instanceof StatementConditionalJump) {
               condition = (StatementConditionalJump) statement;
            }
         }
         Collection<VariableRef> conditionVars = variableReferenceInfos.getUsedVars(condition);
         // Examines if they have constant values in the first iteration
         List<VariableRef> optimizeVars = new ArrayList<>();
         StatementPhiBlock phiBlock = loopHeadBlock.getPhiBlock();
         for(StatementPhiBlock.PhiVariable phiVariable : phiBlock.getPhiVariables()) {
            if(conditionVars.contains(phiVariable.getVariable())) {
               // PHI block for one of the condition variables
               List<StatementPhiBlock.PhiRValue> values = phiVariable.getValues();
               for(StatementPhiBlock.PhiRValue value : values) {
                  if(!loop.getBlocks().contains(value.getPredecessor())) {
                     // Predecessor it outside the loop
                     if(value.getrValue() instanceof ConstantValue) {
                        // The value is constant in the predecessor!!
                        // Optimization of the loop head is a good idea for this variable!
                        optimizeVars.add(phiVariable.getVariable());
                     }
                  }
               }
            }
         }

         // Is optimization a good idea?
         boolean doOptimize = true;
         for(VariableRef conditionVar : conditionVars) {
            if(!optimizeVars.contains(conditionVar)) {
               doOptimize = false;
            }
         }
         if(doOptimize) {
            // Optimization is a good idea since the condition is completely constant when entering!
            ScopeRef scopeRef = loopHeadBlock.getScope();
            Scope scope = getScope().getScope(scopeRef);

            // TODO: Copy the block and all statements - and redirect the PHI-entry to the copy!

         }
      }
      return false;
   }

}

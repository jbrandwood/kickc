package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementConditionalJump;
import dk.camelot64.kickc.model.statements.StatementPhiBlock;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.values.*;
import dk.camelot64.kickc.passes.utils.Unroller;

import java.util.ArrayList;
import java.util.Collection;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.concurrent.atomic.AtomicBoolean;

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
            getProgram().clearVariableReferenceInfos();
            getProgram().clearStatementInfos();
            getProgram().clearLoopSet();
            getProgram().clearDominators();
            return true;
         }
      }
      // TODO: Move to Program
      getProgram().clearStatementIndices();
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
         if(isVolatile(condition)) return false;

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
                        // Make sure it can be calculated as a literal
                        boolean isLiteral = true;
                        try {
                           ConstantValue constantValue = (ConstantValue) value.getrValue();
                           constantValue.calculateLiteral(getProgram().getScope());
                        } catch (ConstantNotLiteral e) {
                           // Not literal
                           isLiteral = false;
                        }
                        if(isLiteral) {
                           // Optimization of the loop head is a good idea for this variable!
                           optimizeVars.add(phiVariable.getVariable());
                        }
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
            BlockSet unrollBlocks = () -> {
               LinkedHashSet<LabelRef> blocks = new LinkedHashSet<>();
               blocks.add(loopHeadBlock.getLabel());
               return blocks;
            };

            //getLog().append("Unrolling Constant Loop Head " +loopHeadBlock.getLabel());

            // Copy the block and all statements - enter through the copy - finish through the original
            Unroller.UnrollStrategy unrollStrategy = new Unroller.UnrollStrategy() {
               @Override
               public TransitionHandling getEntryStrategy(LabelRef from, LabelRef to) {
                  if(loop.getBlocks().contains(from)) {
                     return TransitionHandling.TO_ORIGINAL;
                  }  else {
                     return TransitionHandling.TO_COPY;
                  }
               }

               @Override
               public TransitionHandling getInternalStrategy(LabelRef from, LabelRef to) {
                  return TransitionHandling.TO_ORIGINAL;
               }
            };
            Unroller unroller = new Unroller(getProgram(), unrollBlocks, unrollStrategy);
            unroller.unroll();
            return true;
         }
      }
      return false;
   }


   private boolean isVolatile(Statement condition) {
      AtomicBoolean isVol = new AtomicBoolean(false);
      ProgramValueIterator.execute(condition, (programValue, currentStmt, stmtIt, currentBlock) -> {
         if(programValue.get() instanceof PointerDereference) {
            isVol.set(true);
         }
         if(programValue.get() instanceof VariableRef) {
            Variable variable = getScope().getVariable((VariableRef) programValue.get());
            if(variable.isVolatile())
               isVol.set(true);
         }
      }, null, null);
      return isVol.get();
   }

}

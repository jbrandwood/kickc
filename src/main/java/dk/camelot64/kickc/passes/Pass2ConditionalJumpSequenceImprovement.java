package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Graph;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.operators.Operator;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementConditionalJump;
import dk.camelot64.kickc.model.values.LabelRef;

// If a conditional (on block A)  jumps to a block (B) that has the same default successor (C) as the current block (A) then
// negate the conditional to ensure sequence A->B->C, which generates optimal ASM.
public class Pass2ConditionalJumpSequenceImprovement extends Pass2SsaOptimization {

   public Pass2ConditionalJumpSequenceImprovement(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      boolean modified = false;
      for(var block : getGraph().getAllBlocks()) {
         Graph.Block conditionalSuccessor = getGraph().getConditionalSuccessor(block);
         Graph.Block defaultSuccessor = getGraph().getDefaultSuccessor(block);
         if(conditionalSuccessor != null && defaultSuccessor != null) {
            if(conditionalSuccessor.getDefaultSuccessor().equals(defaultSuccessor.getLabel())) {
               if(conditionalSuccessor.equals(block)) continue;
               // conditional successor is current blocks default successor
               // Negate condition and swap conditional/default successor.
               modified = negateCondition(block);
            }

         }
      }
      return modified;
   }

   private boolean negateCondition(Graph.Block block) {
      LabelRef defaultSuccessor = block.getDefaultSuccessor();
      LabelRef conditionalSuccessor = block.getConditionalSuccessor();
      for(Statement statement : block.getStatements()) {
         if(statement instanceof StatementConditionalJump) {
            StatementConditionalJump conditionalJump = (StatementConditionalJump) statement;
            if(negateOperator(conditionalJump.getOperator()) != null) {
               Operator negatedOperator = negateOperator(conditionalJump.getOperator());
               conditionalJump.setOperator(negatedOperator);
               conditionalJump.setDestination(defaultSuccessor);
               block.setConditionalSuccessor(defaultSuccessor);
               block.setDefaultSuccessor(conditionalSuccessor);
               getLog().append("Negating conditional jump and destination " + conditionalJump.toString(getProgram(), false));
               return true;
            }
         }
      }
      return false;
   }

   /**
    * Find the logic operator that returns the opposite result
    *
    * @param operator The operator to negate
    * @return The opposite logic operator. Null if not found.
    */
   private Operator negateOperator(Operator operator) {
      if(Operators.EQ.equals(operator))
         return Operators.NEQ;
      if(Operators.NEQ.equals(operator))
         return Operators.EQ;
      if(Operators.LT.equals(operator))
         return Operators.GE;
      if(Operators.LE.equals(operator))
         return Operators.GT;
      if(Operators.GT.equals(operator))
         return Operators.LE;
      if(Operators.GE.equals(operator))
         return Operators.LT;
      return null;
   }
}

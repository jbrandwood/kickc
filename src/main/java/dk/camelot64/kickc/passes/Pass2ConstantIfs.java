package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ConstantNotLiteral;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.operators.Operator;
import dk.camelot64.kickc.model.operators.OperatorBinary;
import dk.camelot64.kickc.model.operators.OperatorUnary;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementConditionalJump;
import dk.camelot64.kickc.model.values.ConstantBool;
import dk.camelot64.kickc.model.values.ConstantLiteral;
import dk.camelot64.kickc.model.values.ConstantValue;

import java.util.ListIterator;

/**
 * Compiler Pass identifying constant if() conditions
 */
public class Pass2ConstantIfs extends Pass2SsaOptimization {

   public Pass2ConstantIfs(Program program) {
      super(program);
   }

   /**
    * Identify constant conditions in if()'s
    *
    * @return true optimization was performed. false if no optimization was possible.
    */
   @Override
   public boolean step() {
      boolean modified = false;

      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         ListIterator<Statement> stmtIt = block.getStatements().listIterator();
         while(stmtIt.hasNext()) {
            Statement statement = stmtIt.next();
            if(statement instanceof StatementConditionalJump) {
               StatementConditionalJump conditional = (StatementConditionalJump) statement;
               ConstantLiteral literal = getConditionLiteralValue(conditional);
               if(literal!=null && literal instanceof ConstantBool) {
                  // Condition is a constant boolean
                  if(((ConstantBool) literal).getBool()) {
                     // Always true - replace default successor and drop conditional jump
                     Pass2EliminateUnusedBlocks.removePhiRValues(block.getLabel(), getGraph().getDefaultSuccessor(block), getLog());
                     block.setDefaultSuccessor(conditional.getDestination());
                     getLog().append("if() condition always true - replacing block destination " + conditional.toString(getProgram(), false));
                     stmtIt.remove();
                     block.setConditionalSuccessor(null);
                     modified = true;
                  }  else {
                     // Always false - drop the conditional jump
                     Pass2EliminateUnusedBlocks.removePhiRValues(block.getLabel(), getGraph().getConditionalSuccessor(block), getLog());
                     getLog().append("if() condition always false - eliminating " + conditional.toString(getProgram(), false));
                     stmtIt.remove();
                     block.setConditionalSuccessor(null);
                     modified = true;
                  }
               }
            }
         }
      }
      return modified;
   }

   /**
    * If the condition always evaluates to constant true or false this finds tha value.
    * @param conditional The conditional
    * @return The literal value of the condition
    */
   private ConstantLiteral getConditionLiteralValue(StatementConditionalJump conditional) {
      ConstantValue constValue1 = Pass2ConstantIdentification.getConstant(conditional.getrValue1());
      Operator operator = conditional.getOperator();
      ConstantValue constValue2 = Pass2ConstantIdentification.getConstant(conditional.getrValue2());
      try {

         // If all values are constant find the literal condition value

         if(conditional.getrValue1() == null && operator == null && constValue2 != null) {
            // Constant condition
            return constValue2.calculateLiteral(getScope());
         } else if(conditional.getrValue1() == null && operator != null && constValue2 != null) {
            // Constant unary condition
            ConstantValue constVal = Pass2ConstantIdentification.createUnary((OperatorUnary) operator, constValue2);
            return constVal.calculateLiteral(getScope());
         } else if(constValue1 != null && operator != null && constValue2 != null) {
            // Constant binary condition
            ConstantValue constVal = Pass2ConstantIdentification.createBinary(constValue1, (OperatorBinary) operator, constValue2, getScope());
            return constVal.calculateLiteral(getScope());
         }

         // Examine the intervals of the comparison parameters

         // TODO: Compare intervals based on the operator




      } catch (ConstantNotLiteral e) {
         // not literal - keep as null
      }
      return null;
   }

}

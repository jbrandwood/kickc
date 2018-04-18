package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementConditionalJump;
import dk.camelot64.kickc.model.values.ConstantBool;
import dk.camelot64.kickc.model.values.ConstantLiteral;
import dk.camelot64.kickc.model.values.ConstantValue;

import java.util.ListIterator;

/** Pass that eliminates constant if's - they are either removed (if false) or replaces the default successor (if true). */
public class Pass2ConstantIfs extends Pass2SsaOptimization {

   public Pass2ConstantIfs(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      boolean modified = false;
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         ListIterator<Statement> statementsIt = block.getStatements().listIterator();
         while(statementsIt.hasNext()) {
            Statement statement = statementsIt.next();
            if(statement instanceof StatementConditionalJump) {
               StatementConditionalJump conditionalJump = (StatementConditionalJump) statement;
               if(conditionalJump.getrValue1() == null && conditionalJump.getOperator() == null && conditionalJump.getrValue2() instanceof ConstantValue) {
                  // The if()-value is constant
                  ConstantValue constValue = (ConstantValue) conditionalJump.getrValue2();
                  ConstantLiteral literal = constValue.calculateLiteral(getScope());
                  if(literal instanceof ConstantBool) {
                     if(((ConstantBool) literal).getBool()) {
                        // if()-value always true - remove if and replace destination
                        getLog().append("if() condition always true - replacing block destination "+statement.toString(getProgram(), false));
                        block.setDefaultSuccessor(conditionalJump.getDestination());
                        statementsIt.remove();
                        block.setConditionalSuccessor(null);
                        modified = true;
                     }  else {
                        // if()-value always false - remove if()
                        getLog().append("if() condition always false - eliminating if "+statement.toString(getProgram(), false));
                        statementsIt.remove();
                        block.setConditionalSuccessor(null);
                        modified = true;
                     }
                  }
               }
            }
         }
      }
      return modified;
   }

}

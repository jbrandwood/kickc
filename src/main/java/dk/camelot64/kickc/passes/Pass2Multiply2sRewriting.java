package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ConstantNotLiteral;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.statements.StatementCall;
import dk.camelot64.kickc.model.statements.StatementCallPointer;
import dk.camelot64.kickc.model.symbols.ConstantVar;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.types.SymbolTypeProcedure;
import dk.camelot64.kickc.model.values.*;
import kickass.pass.expressions.expr.Constant;

import java.util.ListIterator;

/** Pass that replaces multiplications with factors of 2 with shifts */
public class Pass2Multiply2sRewriting extends Pass2SsaOptimization {

   public Pass2Multiply2sRewriting(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      boolean optimized = false;
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         ListIterator<Statement> statementsIt = block.getStatements().listIterator();
         while(statementsIt.hasNext()) {
            Statement statement = statementsIt.next();
            if(statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               if(Operators.MULTIPLY.equals(assignment.getOperator()) || Operators.DIVIDE.equals(assignment.getOperator())) {
                  ConstantLiteral constantLiteral = getConstantLiteral(assignment);
                  if(constantLiteral instanceof ConstantInteger) {
                     Long constantInt = ((ConstantInteger)constantLiteral).getInteger();
                     double power2 = Math.log(constantInt) / Math.log(2);
                     if(Math.round(power2)==power2) {
                        // Found a whole power of 2
                        if(Operators.MULTIPLY.equals(assignment.getOperator())) {
                           getLog().append("Rewriting multiplication to use shift "+statement.toString(getProgram(), false));
                           assignment.setOperator(Operators.SHIFT_LEFT);
                           assignment.setrValue2(new ConstantInteger((long)power2));
                           optimized = true;
                        }  else if(Operators.DIVIDE.equals(assignment.getOperator())) {
                           getLog().append("Rewriting division to use shift "+statement.toString(getProgram(), false));
                           assignment.setOperator(Operators.SHIFT_RIGHT);
                           assignment.setrValue2(new ConstantInteger((long)power2));
                           optimized = true;
                        }
                     }
                  }
               }
            }
         }
      }
      return optimized;
   }

   /**
    * Get the constant literal value for RValue2 - or null if not possible
    * @param assignment The Assignment
    * @return The constant literal value for RValue2 (or null)
    */
   private ConstantLiteral getConstantLiteral(StatementAssignment assignment) {
      if(assignment.getrValue2() instanceof ConstantValue) {
         ConstantValue constantValue = (ConstantValue) assignment.getrValue2();
         try {
            return constantValue.calculateLiteral(getScope());
         } catch(ConstantNotLiteral e) {
            return null;
         }
      } else {
         return null;
      }
   }


}

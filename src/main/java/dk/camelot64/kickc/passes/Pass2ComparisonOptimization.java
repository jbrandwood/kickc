package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ConstantNotLiteral;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Graph;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.operators.Operator;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementConditionalJump;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeInference;
import dk.camelot64.kickc.model.types.SymbolTypeIntegerFixed;
import dk.camelot64.kickc.model.values.ConstantBinary;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;
import dk.camelot64.kickc.model.values.ConstantValue;

/**
 * The 6502/6510 handles some comparisons much faster than others.
 * This optimization rewrites to faster comparisons when possible.
 * Unsigned A > C is rewritten to A >= C+1 if the constant is <max.
 * Unsigned A <= C is rewritten to A < C+1 if the constant is <max.
 */
public class Pass2ComparisonOptimization extends Pass2SsaOptimization {

   public Pass2ComparisonOptimization(Program program) {
      super(program);
   }

   /**
    * Rewrite comparisons to faster ones if possible
    *
    * @return true optimization was performed. false if no optimization was possible.
    */
   @Override
   public boolean step() {
      for(var statement : getGraph().getAllStatements()) {
         if(statement instanceof StatementConditionalJump) {
            StatementConditionalJump conditionalJump = (StatementConditionalJump) statement;
            Operator operator = conditionalJump.getOperator();
            if(operator!=null && conditionalJump.getrValue2() instanceof ConstantValue) {
               SymbolType valueType = SymbolTypeInference.inferType(getProgramScope(), conditionalJump.getrValue1());
               ConstantValue constantValue = (ConstantValue) conditionalJump.getrValue2();
               ConstantLiteral constantLiteral = null;
               try {
                  constantLiteral = constantValue.calculateLiteral(getProgramScope());
               } catch(ConstantNotLiteral e) {
                  // Ignore
               }
               if(Operators.GT.equals(operator) && valueType instanceof SymbolTypeIntegerFixed && constantLiteral instanceof ConstantInteger) {
                  // Found > C - rewrite to >= C+1 if possible
                  Long longValue = (Long) constantLiteral.getValue();
                  if(longValue > 0x00L && longValue < 0xffL) {
                     // Rewrite is possible - do it
                     getLog().append("Rewriting conditional comparison " + statement.toString(getProgram(), false));
                     conditionalJump.setOperator(Operators.GE);
                     conditionalJump.setrValue2(new ConstantBinary(constantValue, Operators.PLUS, new ConstantInteger(1L)));
                  }
               }
               if(Operators.LE.equals(operator) && valueType instanceof SymbolTypeIntegerFixed && constantLiteral instanceof ConstantInteger) {
                  // Found <= C - rewrite to < C+1 if possible
                  Long longValue = (Long) constantLiteral.getValue();
                  if(longValue > 0x00L && longValue < 0xffL) {
                     // Rewrite is possible - do it
                     getLog().append("Rewriting conditional comparison " + statement.toString(getProgram(), false));
                     conditionalJump.setOperator(Operators.LT);
                     conditionalJump.setrValue2(new ConstantBinary(constantValue, Operators.PLUS, new ConstantInteger(1L)));
                  }
               }
            }
         }
      }
      return false;
   }

}

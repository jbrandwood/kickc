package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ConstantNotLiteral;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.operators.Operator;
import dk.camelot64.kickc.model.operators.OperatorBinary;
import dk.camelot64.kickc.model.operators.OperatorUnary;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementConditionalJump;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeInference;
import dk.camelot64.kickc.model.types.SymbolTypeIntegerFixed;
import dk.camelot64.kickc.model.values.*;

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
               ConstantLiteral literal = findConditionLiteral(conditional);
               if(literal == null) {
                  literal = findConditionLiteralInterval(conditional);
               }
               if(literal != null && literal instanceof ConstantBool) {
                  // Condition is a constant boolean
                  if(((ConstantBool) literal).getBool()) {
                     // Always true - replace default successor and drop conditional jump
                     Pass2EliminateUnusedBlocks.removePhiRValues(block.getLabel(), getGraph().getDefaultSuccessor(block), getLog());
                     block.setDefaultSuccessor(conditional.getDestination());
                     getLog().append("if() condition always true - replacing block destination " + conditional.toString(getProgram(), false));
                     stmtIt.remove();
                     block.setConditionalSuccessor(null);
                     modified = true;
                  } else {
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
    *
    * @param conditional The conditional
    * @return The literal value of the condition
    */
   private ConstantLiteral findConditionLiteral(StatementConditionalJump conditional) {
      ConstantValue constValue1 = Pass2ConstantIdentification.getConstant(conditional.getrValue1());
      Operator operator = conditional.getOperator();
      ConstantValue constValue2 = Pass2ConstantIdentification.getConstant(conditional.getrValue2());
      try {

         // If all values are constant find the literal condition value
         if(conditional.getrValue1() == null && operator == null && constValue2 != null) {
            // Constant condition
            return constValue2.calculateLiteral(getProgramScope());
         } else if(conditional.getrValue1() == null && operator != null && constValue2 != null) {
            // Constant unary condition
            ConstantValue constVal = Pass2ConstantIdentification.createUnary((OperatorUnary) operator, constValue2);
            return constVal.calculateLiteral(getProgramScope());
         } else if(constValue1 != null && operator != null && constValue2 != null) {
            // Constant binary condition
            ConstantValue constVal = Pass2ConstantIdentification.createBinary(constValue1, (OperatorBinary) operator, constValue2, getProgramScope());
            return constVal.calculateLiteral(getProgramScope());
         }

      } catch(ConstantNotLiteral e) {
         // not literal - keep as null
      }
      return null;
   }

   /**
    * Examine the intervals of the conditions to see if they
    *
    * @param conditional The conditional
    * @return The literal value of the condition. Null if not literal.
    */
   private ConstantLiteral findConditionLiteralInterval(StatementConditionalJump conditional) {
      if(conditional.getrValue1() != null && conditional.getrValue2() != null) {
         IntValueInterval interval1 = getInterval(conditional.getrValue1());
         IntValueInterval interval2 = getInterval(conditional.getrValue2());
         if(interval1 != null && interval2 != null) {
            if(Operators.LT.equals(conditional.getOperator())) {
               if(interval1.maxValue < interval2.minValue) {
                  return new ConstantBool(true);
               } else if(interval1.minValue >= interval2.maxValue) {
                  return new ConstantBool(false);
               } else {
                  return null;
               }
            } else if(Operators.LE.equals(conditional.getOperator())) {
               if(interval1.maxValue <= interval2.minValue) {
                  return new ConstantBool(true);
               } else if(interval1.minValue > interval2.maxValue) {
                  return new ConstantBool(false);
               } else {
                  return null;
               }
            } else if(Operators.GT.equals(conditional.getOperator())) {
               if(interval1.minValue > interval2.maxValue) {
                  return new ConstantBool(true);
               } else if(interval1.maxValue <= interval2.minValue) {
                  return new ConstantBool(false);
               } else {
                  return null;
               }
            } else if(Operators.GE.equals(conditional.getOperator())) {
               if(interval1.minValue >= interval2.maxValue) {
                  return new ConstantBool(true);
               } else if(interval1.maxValue < interval2.minValue) {
                  return new ConstantBool(false);
               } else {
                  return null;
               }
         } else if(Operators.EQ.equals(conditional.getOperator())) {
            if(interval1.minValue > interval2.maxValue) {
               return new ConstantBool(false);
            } else if(interval1.maxValue < interval2.minValue) {
               return new ConstantBool(false);
            } else {
               return null;
            }
         } else if(Operators.NEQ.equals(conditional.getOperator())) {
            if(interval1.minValue > interval2.maxValue) {
               return new ConstantBool(true);
            } else if(interval1.maxValue < interval2.minValue) {
               return new ConstantBool(true);
            } else {
               return null;
            }
            }
         }
      }
      return null;
   }

   /** Interval of integer types. */
   static class IntValueInterval {
      long minValue;
      long maxValue;

      public IntValueInterval(long minValue, long maxValue) {
         this.minValue = minValue;
         this.maxValue = maxValue;
      }

   }

   private IntValueInterval getInterval(RValue rValue) {
      ConstantValue constValue = Pass2ConstantIdentification.getConstant(rValue);
      if(constValue != null) {
         try {
            ConstantLiteral constantLiteral = constValue.calculateLiteral(getProgramScope());
            if(constantLiteral instanceof ConstantInteger) {
               Long value = ((ConstantInteger) constantLiteral).getInteger();
               return new IntValueInterval(value, value);
            }
         } catch(ConstantNotLiteral e) {
            // not literal - keep as null
         }
      }
      // Not constant - find the interval of the type
      SymbolType symbolType = SymbolTypeInference.inferType(getProgramScope(), rValue);
      if(symbolType instanceof SymbolTypeIntegerFixed) {
         SymbolTypeIntegerFixed typeIntegerFixed = (SymbolTypeIntegerFixed) symbolType;
         return new IntValueInterval(typeIntegerFixed.getMinValue(), typeIntegerFixed.getMaxValue());
      } else if(symbolType.equals(SymbolType.UNUMBER)) {
         // Positive number
         return new IntValueInterval(0L, Long.MAX_VALUE);
      }
      // Not a constant integer
      return null;
   }

}

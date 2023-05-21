package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ConstantNotLiteral;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramExpressionBinary;
import dk.camelot64.kickc.model.iterator.ProgramExpressionIterator;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.ConstantBinary;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;
import dk.camelot64.kickc.model.values.ConstantValue;

import java.util.concurrent.atomic.AtomicBoolean;

/** Pass that replaces modulo with factors of 2 with binary and */
public class Pass2ModuloToAndRewriting extends Pass2SsaOptimization {

   public Pass2ModuloToAndRewriting(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      AtomicBoolean optimized = new AtomicBoolean(false);

      ProgramExpressionIterator.execute(getProgram(), (programExpression, currentStmt, stmtIt, currentBlock) -> {
         if(programExpression instanceof ProgramExpressionBinary) {
            ProgramExpressionBinary binary = (ProgramExpressionBinary) programExpression;
            if(binary.getOperator().equals(Operators.MODULO) && binary.getRight() instanceof ConstantValue) {
               final ConstantLiteral constantLiteral = getConstantLiteral((ConstantValue) binary.getRight());
               if(constantLiteral instanceof ConstantInteger) {
                  Long constantInt = ((ConstantInteger) constantLiteral).getInteger();
                  double power2 = Math.log(constantInt) / Math.log(2);
                  if(power2 >= 0.0 && Math.round(power2) == power2) {
                     // Modulo whole power of 2
                     binary.setOperator(Operators.BOOL_AND);
                     binary.getRightValue().set(new ConstantBinary((ConstantValue) binary.getRight(), Operators.MINUS, new ConstantInteger(1l, SymbolType.BYTE)));
                     getLog().append("Rewriting power 2 modulo to use AND " + binary.getLeft().toString()+" "+binary.getOperator().toString()+" "+binary.getRight().toString());
                     optimized.set(true);
                  }
               }
            }
         }
      });
      return optimized.get();
   }

   /**
    * Get the constant literal value for a constant value - or null if not possible
    *
    * @param constantValue The constant value
    * @return The constant literal value for RValue2 (or null)
    */
   private ConstantLiteral getConstantLiteral(ConstantValue constantValue) {
      try {
         return constantValue.calculateLiteral(getProgramScope());
      } catch(ConstantNotLiteral e) {
         return null;
      }
   }
}

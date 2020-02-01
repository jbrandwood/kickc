package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramExpressionIterator;
import dk.camelot64.kickc.model.iterator.ProgramExpressionUnary;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.symbols.Symbol;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.values.*;

/**
 * Add inferred volatile to all variables, where address-of is used
 */
public class Pass1AddressOfVolatile extends Pass2SsaOptimization {

   public Pass1AddressOfVolatile(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      ProgramExpressionIterator.execute(getProgram(), (programExpression, currentStmt, stmtIt, currentBlock) -> {
         if(Operators.ADDRESS_OF.equals(programExpression.getOperator())) {
            RValue rValue = ((ProgramExpressionUnary) programExpression).getOperand();
            if(rValue instanceof SymbolVariableRef) {
               Symbol toSymbol = getScope().getSymbol((SymbolVariableRef) rValue);
               if(toSymbol instanceof Variable) {
                  ((Variable) toSymbol).setInferredVolatile(true);
                  getLog().append("Setting inferred volatile on symbol affected by address-of " + currentStmt.toString(getProgram(), false));
               }
            }
         }
      });
      ProgramValueIterator.execute(getProgram(), (programValue, currentStmt, stmtIt, currentBlock) -> {
         if(programValue.get() instanceof ConstantSymbolPointer) {
            Value value = ((ConstantSymbolPointer) programValue.get()).getToSymbol();
            if(value instanceof SymbolVariableRef) {
               Symbol toSymbol = getScope().getSymbol((SymbolVariableRef) value);
               if(toSymbol instanceof Variable) {
                  ((Variable) toSymbol).setInferredVolatile(true);
                  final String stmtStr = currentStmt==null?toSymbol.toString(getProgram()):currentStmt.toString(getProgram(), false);
                  getLog().append("Setting inferred volatile on symbol affected by address-of " + stmtStr);
               }
            }
         }
      });
      return false;
   }


}

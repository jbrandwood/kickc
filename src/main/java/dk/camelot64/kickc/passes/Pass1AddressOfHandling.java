package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramExpressionIterator;
import dk.camelot64.kickc.model.iterator.ProgramExpressionUnary;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.symbols.Symbol;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;
import dk.camelot64.kickc.model.values.ConstantSymbolPointer;
import dk.camelot64.kickc.model.values.RValue;
import dk.camelot64.kickc.model.values.SymbolVariableRef;
import dk.camelot64.kickc.model.values.Value;

/**
 * Update variables properly if address-of is used
 */
public class Pass1AddressOfHandling extends Pass2SsaOptimization {

   public Pass1AddressOfHandling(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      // Expressions using & operator
      ProgramExpressionIterator.execute(getProgram(), (programExpression, currentStmt, stmtIt, currentBlock) -> {
         if(Operators.ADDRESS_OF.equals(programExpression.getOperator())) {
            RValue rValue = ((ProgramExpressionUnary) programExpression).getOperand();
            if(rValue instanceof SymbolVariableRef) {
               Symbol toSymbol = getScope().getSymbol((SymbolVariableRef) rValue);
               if(toSymbol instanceof Variable) {
                  final Variable variable = (Variable) toSymbol;
                  final String stmtStr = currentStmt.toString(getProgram(), false);
                  updateAddressOfVariable(variable, stmtStr);
               }
            }
         }
      });
      ProgramValueIterator.execute(getProgram(), (programValue, currentStmt, stmtIt, currentBlock) -> {
         if(programValue.get() instanceof ConstantSymbolPointer) {
            // Values containing constant pointers
            Value value = ((ConstantSymbolPointer) programValue.get()).getToSymbol();
            if(value instanceof SymbolVariableRef) {
               Symbol toSymbol = getScope().getSymbol((SymbolVariableRef) value);
               if(toSymbol instanceof Variable) {
                  final Variable variable = (Variable) toSymbol;
                  if(!variable.isNoModify() && !variable.isVolatile()) {
                     final String stmtStr = currentStmt == null ? toSymbol.toString(getProgram()) : currentStmt.toString(getProgram(), false);
                     updateAddressOfVariable(variable, stmtStr);
                  }
               }
            }
         }
      });
      return false;
   }

   private void updateAddressOfVariable(Variable variable, String stmtStr) {
      if(variable.getType() instanceof SymbolTypeStruct) {
         variable.setKind(Variable.Kind.LOAD_STORE);
         SymbolType typeQualified = variable.getType().getQualified(true, variable.getType().isNomodify());
         variable.setType(typeQualified);
         // TODO: remove
         variable.setVolatile(true);
         getLog().append("Setting struct to load/store in variable affected by address-of " + stmtStr);
         //getLog().append("Setting struct to load/store in variable affected by address-of: " + variable.toString() + " in " + stmtStr);
      } else {
         variable.setKind(Variable.Kind.LOAD_STORE);
         SymbolType typeQualified = variable.getType().getQualified(true, variable.getType().isNomodify());
         variable.setType(typeQualified);
         // TODO: remove
         variable.setVolatile(true);
         getLog().append("Setting inferred volatile on symbol affected by address-of " + stmtStr);
         //getLog().append("Setting inferred volatile on symbol affected by address-of: " + variable.toString() + " in " + stmtStr);
      }
   }


}

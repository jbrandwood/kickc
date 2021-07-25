package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramExpressionIterator;
import dk.camelot64.kickc.model.iterator.ProgramExpressionUnary;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.symbols.Symbol;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;
import dk.camelot64.kickc.model.values.ConstantSymbolPointer;
import dk.camelot64.kickc.model.values.RValue;
import dk.camelot64.kickc.model.values.SymbolRef;
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
            updateAddressOfValue(rValue, currentStmt);
         }
      });
      ProgramValueIterator.execute(getProgram(), (programValue, currentStmt, stmtIt, currentBlock) -> {
         if(programValue.get() instanceof ConstantSymbolPointer) {
            // Values containing constant pointers
            Value value = ((ConstantSymbolPointer) programValue.get()).getToSymbol();
            updateAddressOfValue(value, currentStmt);
         }
      });
      return false;
   }

   /**
    * Modify variable/procedure affected by address-of
    *
    * @param value The value affected by address-of
    * @param currentStmt The current statement
    */
   private void updateAddressOfValue(Value value, Statement currentStmt) {
      if(value instanceof SymbolRef) {
         Symbol toSymbol = getScope().getSymbol((SymbolRef) value);
         final String stmtStr = currentStmt == null ? toSymbol.toString(getProgram()) : currentStmt.toString(getProgram(), false);
         if(toSymbol instanceof Variable) {
            final Variable variable = (Variable) toSymbol;
            if(!variable.isNoModify() && !variable.isVolatile()) {
               if(variable.getArraySpec() != null)
                  return;

               if(variable.getType() instanceof SymbolTypeStruct) {
                  variable.setKind(Variable.Kind.LOAD_STORE);
                  SymbolType typeQualified = variable.getType().getQualified(true, variable.getType().isNomodify());
                  variable.setType(typeQualified);
                  variable.setStructUnwind(false);
                  getLog().append("Setting struct to load/store in variable affected by address-of " + stmtStr);
                  //getLog().append("Setting struct to load/store in variable affected by address-of: " + variable.toString() + " in " + stmtStr);
               } else {
                  variable.setKind(Variable.Kind.LOAD_STORE);
                  SymbolType typeQualified = variable.getType().getQualified(true, variable.getType().isNomodify());
                  variable.setType(typeQualified);
                  getLog().append("Setting inferred volatile on symbol affected by address-of " + stmtStr);
                  //getLog().append("Setting inferred volatile on symbol affected by address-of: " + variable.toString() + " in " + stmtStr);
               }
            }
         } else if(toSymbol instanceof Procedure) {
            if(((Procedure) toSymbol).getParameters().size() > 0) {
               ((Procedure) toSymbol).setCallingConvention(Procedure.CallingConvention.STACK_CALL);
               getLog().append("Setting inferred __stackcall on procedure affected by address-of " + toSymbol.toString(getProgram()) + " caused by statement " + stmtStr);
               ;
            }
         }
      }
   }


}

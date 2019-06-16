package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.symbols.Symbol;
import dk.camelot64.kickc.model.symbols.SymbolVariable;
import dk.camelot64.kickc.model.values.RValue;
import dk.camelot64.kickc.model.values.SymbolVariableRef;

/**
 * Add infered volatile to all variables, where address-of is used
 */
public class Pass1AddressOfVolatile extends Pass2SsaOptimization {

   public Pass1AddressOfVolatile(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      for(ControlFlowBlock block : getProgram().getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               if(Operators.ADDRESS_OF.equals(assignment.getOperator()) ) {
                  RValue rValue = assignment.getrValue2();
                  if(rValue instanceof SymbolVariableRef) {
                     Symbol toSymbol = getScope().getSymbol((SymbolVariableRef) rValue);
                     if(toSymbol instanceof SymbolVariable) {
                        ((SymbolVariable) toSymbol).setInferedVolatile(true);
                        getLog().append("Setting inferred volatile on symbol affected by address-of "+statement.toString(getProgram(), false));
                     }
                  }
               }
            }
         }
      }
      return false;
   }


}

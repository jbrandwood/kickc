package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramExpressionIterator;
import dk.camelot64.kickc.model.iterator.ProgramExpressionUnary;
import dk.camelot64.kickc.model.iterator.ProgramValue;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.symbols.Symbol;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;
import dk.camelot64.kickc.model.values.ConstantSymbolPointer;
import dk.camelot64.kickc.model.values.RValue;
import dk.camelot64.kickc.model.values.SymbolVariableRef;
import dk.camelot64.kickc.model.values.Value;

/**
 * Update variables properly if address-of is used
 */
public class Pass1AsmUsesHandling extends Pass2SsaOptimization {

   public Pass1AsmUsesHandling(Program program) {
      super(program);
   }

   @Override
   public boolean step() {

      ProgramValueIterator.execute(getProgram(), (programValue, currentStmt, stmtIt, currentBlock) -> {
          if(programValue instanceof ProgramValue.ProgramValueAsmReferenced || programValue instanceof ProgramValue.KickAsmUses || programValue instanceof ProgramValue.ProgramValueConstantArrayKickAsmUses) {
            // Symbol used in inline ASM or KickAsm
            final Value value = programValue.get();
            if(value instanceof SymbolVariableRef) {
               Variable variable = getScope().getVariable((SymbolVariableRef) value);
               if(!variable.isKindConstant() && !variable.isVolatile()) {
                  final String stmtStr = currentStmt == null ? value.toString(getProgram()) : currentStmt.toString(getProgram(), false);
                  updateAddressOfVariable(variable, stmtStr);
               }
            }
         }
      });
      return false;
   }

   private void updateAddressOfVariable(Variable variable, String stmtStr) {
      if(variable.getType() instanceof SymbolTypeStruct) {
         variable.setKind(Variable.Kind.LOAD_STORE);
         getLog().append("Setting struct to load/store in variable affected by address-of: " + variable.toString() + " in " + stmtStr);
      } else {
         variable.setKind(Variable.Kind.LOAD_STORE);
         variable.setVolatile(true);
         getLog().append("Setting inferred volatile on symbol affected by address-of: " + variable.toString() + " in " + stmtStr);
      }
   }


}

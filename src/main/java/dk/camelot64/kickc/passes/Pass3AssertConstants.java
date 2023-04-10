package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAsm;
import dk.camelot64.kickc.model.statements.StatementKickAsm;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.symbols.Symbol;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.values.ConstantValue;
import dk.camelot64.kickc.model.values.RValue;
import dk.camelot64.kickc.model.values.SymbolRef;
import java.util.List;
import java.util.Map;

/**
 * Asserts that some RValues have been resolved to Constants.
 * Checks:
 * - KickAssembler locations
 * - KickAssembler bytes
 * - KickAssembler cycles
 * - ASM referenced variables
 */
public class Pass3AssertConstants extends Pass2SsaAssertion {

   public Pass3AssertConstants(Program program) {
      super(program);
   }

   @Override
   public void check() throws AssertionFailed {
      for(var statement : getProgram().getGraph().getAllStatements()) {
         if(statement instanceof StatementKickAsm statementKickAsm) {
            RValue bytes = statementKickAsm.getBytes();
            if(bytes != null && !(bytes instanceof ConstantValue)) {
               throw new CompileError("KickAssembler bytes is not constant " + bytes.toString(), statement);
            }
            RValue cycles = statementKickAsm.getCycles();
            if(cycles != null && !(cycles instanceof ConstantValue)) {
               throw new CompileError("KickAssembler cycles is not constant " + cycles.toString(), statement);
            }
            List<SymbolRef> uses = statementKickAsm.getUses();
            for(SymbolRef use : uses) {
               checkReference(statement, use);
            }
         } else if(statement instanceof StatementAsm statementAsm) {
            Map<String, SymbolRef> referenced = statementAsm.getReferenced();
            for(String label : referenced.keySet()) {
               SymbolRef symbolRef = referenced.get(label);
               checkReference(statement, symbolRef);
            }
         }
      }
   }

   private void checkReference(Statement statement, SymbolRef symbolRef) {
      Symbol symbol = getScope().getSymbol(symbolRef);
      if(symbol instanceof Procedure)
         // Referencing procedures are fine!
         return;
      else if(symbol instanceof Variable && ((Variable) symbol).isKindConstant())
         // Referencing constants are fine!
         return;
      else if(symbol instanceof Variable && ((Variable) symbol).isKindLoadStore())
         // Referencing load/store is fine!
         return;
      else
         throw new CompileError("Inline ASM reference is not constant " + symbolRef, statement);
   }
}

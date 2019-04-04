package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.symbols.ConstantVar;
import dk.camelot64.kickc.model.symbols.Symbol;
import dk.camelot64.kickc.model.symbols.VariableUnversioned;
import dk.camelot64.kickc.model.values.SymbolRef;

import java.util.Collection;
import java.util.HashSet;

/** Asserts that the symbols in the symbol table match exactly the symbols in the program */
public class Pass2AssertSymbols extends Pass2SsaAssertion {

   public Pass2AssertSymbols(Program program) {
      super(program);
   }

   @Override
   public void check() throws AssertionFailed {

      HashSet<Symbol> codeSymbols = new HashSet<>();
      ProgramValueIterator.execute(getGraph(), (programValue, currentStmt, stmtIt, currentBlock) -> {
         if(programValue.get() instanceof SymbolRef) {
            Symbol symbol = getScope().getSymbol((SymbolRef) programValue.get());
            if(symbol != null)
               codeSymbols.add(symbol);
         }
      });

      // Check that all symbols found in the code is also in the symbol table
      for(Symbol codeSymbol : codeSymbols) {
         if(codeSymbol.getFullName().equals(SymbolRef.PROCEXIT_BLOCK_NAME)) continue;
         Symbol tableSymbol = getScope().getSymbol(codeSymbol.getFullName());
         if(tableSymbol == null) {
            throw new AssertionFailed("Compile process error. Symbol found in code, but not in symbol table. " + codeSymbol.getFullName());
         }
      }
      // Check that all symbols in the symbol table is also in the code
      Collection<Symbol> tableSymbols = getScope().getAllSymbols(true);
      for(Symbol tableSymbol : tableSymbols) {
         if(tableSymbol instanceof VariableUnversioned) continue;
         if(tableSymbol instanceof ConstantVar) continue;
         Symbol codeSymbol = null;
         String codeSymbolFullName = tableSymbol.getFullName();
         for(Symbol symbol : codeSymbols) {
            if(codeSymbolFullName.equals(symbol.getFullName())) {
               codeSymbol = symbol;
               break;
            }
         }
         if(codeSymbol == null) {
            throw new AssertionFailed("Compile process error. Symbol found in symbol table, but not in code. " + codeSymbolFullName);
         }
      }
   }

}

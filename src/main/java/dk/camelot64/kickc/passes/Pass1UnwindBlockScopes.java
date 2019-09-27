package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.symbols.*;
import dk.camelot64.kickc.model.values.*;

import java.util.ArrayList;
import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.Map;

/** Moves all symbols from block scopes to the surrounding function scope */
public class Pass1UnwindBlockScopes extends Pass1Base {

   public Pass1UnwindBlockScopes(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      Map<SymbolRef, SymbolRef> unwoundSymbols = new LinkedHashMap<>();
      for(Procedure procedure : getScope().getAllProcedures(true)) {
         for(Scope subScope : procedure.getAllScopes(false)) {
            unwindSubScope(subScope, procedure, unwoundSymbols);
         }
         Collection<Scope> subScopes = new ArrayList<>(procedure.getAllScopes(false));
         for(Scope subScope : subScopes) {
            procedure.remove(subScope);
         }
      }

      ProgramValueIterator.execute(getGraph(), (programValue, currentStmt, stmtIt, currentBlock) -> {
         Value value = programValue.get();
         if(value instanceof VariableRef) {
            SymbolRef unwound = unwoundSymbols.get(value);
            if(unwound!=null) {
               programValue.set(unwound);
            }
         } else if(value instanceof LabelRef) {
            SymbolRef unwound = unwoundSymbols.get(value);
            if(unwound!=null) {
               programValue.set(unwound);
            }
         }
      });

      return false;
   }

   /**
    * Unwind symbols inside a single block scope (recursively)
    * @param subScope The block scope
    * @param procedure The containing procedure
    * @param unwoundSymbols All unwound symbols
    */
   private void unwindSubScope(Scope subScope, Procedure procedure, Map<SymbolRef, SymbolRef> unwoundSymbols) {
      if(subScope instanceof BlockScope) {
         for(Symbol symbol : subScope.getAllSymbols()) {
            if(symbol instanceof Label) {
               if(symbol.getRef().isIntermediate()) {
                  Label unwound = procedure.addLabelIntermediate();
                  unwoundSymbols.put(symbol.getRef(), unwound.getRef());
               }  else {
                  String name = findLocalName(procedure, symbol);
                  Label unwound = procedure.addLabel(name);
                  unwoundSymbols.put(symbol.getRef(), unwound.getRef());
               }
            }  else if(symbol instanceof VariableUnversioned) {
               String name = findLocalName(procedure, symbol);
               VariableUnversioned var = (VariableUnversioned) symbol;
               VariableUnversioned unwound = procedure.addVariable(name, symbol.getType(), var.getDataSegment());
               unwound.setDeclaredAlignment(var.getDeclaredAlignment());
               unwound.setDeclaredConstant(var.isDeclaredConstant());
               unwound.setDeclaredVolatile(var.isDeclaredVolatile());
               unwound.setInferedVolatile(var.isInferedVolatile());
               unwound.setDeclaredRegister((var.getDeclaredRegister()));
               unwound.setDeclaredExport(var.isDeclaredExport());
               unwoundSymbols.put(symbol.getRef(), unwound.getRef());
            }  else if(symbol instanceof Variable && ((Variable) symbol).isIntermediate()) {
               Variable unwound = procedure.addVariableIntermediate();
               unwoundSymbols.put(symbol.getRef(), unwound.getRef());
            }  else if(symbol instanceof BlockScope) {
               // Recurse!
               unwindSubScope((Scope) symbol, procedure, unwoundSymbols);
            } else {
               throw new CompileError("ERROR! Unexpected symbol encountered in block scope "+symbol.toString(getProgram()));
            }
         }
      }
   }

   /**
    * Find a suitable name for the symbol in the surrounding procedure.
    * Avoids clashes with other symbols already in the procedure
    * @param procedure The procedure
    * @param symbol The symbol to find a good ,ocal name for
    * @return An unused local name
    */
   private String findLocalName(Procedure procedure, Symbol symbol) {
      String name = symbol.getLocalName();
      int idx = 0;
      while(procedure.getLocalSymbol(name)!=null) {
         name = symbol.getLocalName()+(++idx);
      }
      return name;
   }

   /**
    * Unwind all symbols in blocks scopes by moving them to the surrounding procedure scope.
    * @param scope The scope to unwind. Will recurse to all sub-scopes
    * @param unwound Map with all moved symbols.
    */

}

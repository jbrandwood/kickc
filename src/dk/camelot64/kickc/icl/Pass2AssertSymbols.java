package dk.camelot64.kickc.icl;

import java.util.HashSet;

/** Asserts that the symbols in the symbol table match exactly the symbols in the program */
public class Pass2AssertSymbols extends Pass2SsaAssertion {

   public Pass2AssertSymbols(ControlFlowGraph graph, Scope scope) {
      super(graph, scope);
   }

   @Override
   public void check() throws AssertionFailed {
      SymbolFinder symbolFinder = new SymbolFinder();
      symbolFinder.visitGraph(getGraph());
      HashSet<Symbol> codeSymbols = symbolFinder.getSymbols();
      // Check that all symbols found in the code is also oin the symbol tabel
      for (Symbol codeSymbol : codeSymbols) {
         if(codeSymbol.getFullName().equals("@RETURN")) continue;
         Symbol tableSymbol = getSymbols().getSymbol(codeSymbol.getFullName());
         if(tableSymbol==null) {
            throw new AssertionFailed("Compile process error. Symbol found in code, but not in symbol table. "+codeSymbol.getFullName());
         }
      }
      // Check that all symbols in the symbol table is also in the code
      HashSet<Symbol> tableSymbols = getAllSymbols(getSymbols());
      for (Symbol tableSymbol : tableSymbols) {
         if(tableSymbol instanceof VariableUnversioned) continue;
         Symbol codeSymbol = null;
         String codeSymbolFullName = tableSymbol.getFullName();
         for (Symbol symbol : codeSymbols) {
            if(codeSymbolFullName.equals(symbol.getFullName())) {
               codeSymbol = symbol;
               break;
            }
         }
         if(codeSymbol==null) {
            throw new AssertionFailed("Compile process error. Symbol found in symbol table, but not in code. "+ codeSymbolFullName);
         }
      }
   }

   private HashSet<Symbol> getAllSymbols(Scope symbols) {
      HashSet<Symbol> allSymbols = new HashSet<>();
      for (Symbol symbol : symbols.getSymbols()) {
         allSymbols.add(symbol);
         if(symbol instanceof Scope) {
            HashSet<Symbol> subSymbols = getAllSymbols((Scope) symbol);
            allSymbols.addAll(subSymbols);
         }
      }
      return allSymbols;
   }

   private static class SymbolFinder extends ControlFlowGraphBaseVisitor<Void> {

      private HashSet<Symbol> symbols = new HashSet<>();

      public HashSet<Symbol> getSymbols() {
         return symbols;
      }

      private void addSymbol(Value symbol) {
         if (symbol instanceof Symbol) {
            symbols.add((Symbol) symbol);
         } else if(symbol instanceof PointerDereferenceIndexed) {
            addSymbol(((PointerDereferenceIndexed) symbol).getPointer());
            addSymbol(((PointerDereferenceIndexed) symbol).getIndex());
         } else if(symbol instanceof PointerDereference) {
            addSymbol(((PointerDereference) symbol).getPointer());
         }
      }

      @Override
      public Void visitBlock(ControlFlowBlock block) {
         addSymbol(block.getLabel());
         addSymbol(block.getDefaultSuccessor());
         addSymbol(block.getConditionalSuccessor());
         addSymbol(block.getCallSuccessor());
         return super.visitBlock(block);
      }

      @Override
      public Void visitProcedureBegin(StatementProcedureBegin statement) {
         symbols.add(statement.getProcedure());
         return super.visitProcedureBegin(statement);
      }

      @Override
      public Void visitProcedureEnd(StatementProcedureEnd statement) {
         symbols.add(statement.getProcedure());
         return super.visitProcedureEnd(statement);
      }

      @Override
      public Void visitReturn(StatementReturn aReturn) {
         addSymbol(aReturn.getValue());
         return super.visitReturn(aReturn);
      }

      @Override
      public Void visitConditionalJump(StatementConditionalJump conditionalJump) {
         addSymbol(conditionalJump.getRValue1());
         addSymbol(conditionalJump.getRValue2());
         addSymbol(conditionalJump.getDestination());
         return super.visitConditionalJump(conditionalJump);
      }

      @Override
      public Void visitAssignment(StatementAssignment assignment) {
         addSymbol(assignment.getLValue());
         addSymbol(assignment.getRValue1());
         addSymbol(assignment.getRValue2());
         return super.visitAssignment(assignment);
      }

      @Override
      public Void visitJump(StatementJump jump) {
         addSymbol(jump.getDestination());
         return super.visitJump(jump);
      }

      @Override
      public Void visitJumpTarget(StatementLabel jumpTarget) {
         addSymbol(jumpTarget.getLabel());
         return super.visitJumpTarget(jumpTarget);
      }

      @Override
      public Void visitCall(StatementCall callLValue) {
         addSymbol(callLValue.getLValue());
         addSymbol(callLValue.getProcedure());
         if(callLValue.getParameters()!=null) {
            for (RValue param : callLValue.getParameters()) {
               addSymbol(param);
            }
         }
         return super.visitCall(callLValue);
      }

      @Override
      public Void visitPhi(StatementPhi phi) {
         addSymbol(phi.getLValue());
         for (StatementPhi.PreviousSymbol previousSymbol : phi.getPreviousVersions()) {
            addSymbol(previousSymbol.getRValue());
         }
         return super.visitPhi(phi);
      }
   }
}

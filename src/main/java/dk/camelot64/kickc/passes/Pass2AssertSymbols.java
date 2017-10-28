package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;

import java.util.HashSet;

/** Asserts that the symbols in the symbol table match exactly the symbols in the program */
public class Pass2AssertSymbols extends Pass2SsaAssertion {

   public Pass2AssertSymbols(Program program) {
      super(program);
   }

   @Override
   public void check() throws AssertionFailed {
      SymbolFinder symbolFinder = new SymbolFinder(getSymbols());
      symbolFinder.visitGraph(getGraph());
      HashSet<Symbol> codeSymbols = symbolFinder.getSymbols();
      // Check that all symbols found in the code is also oin the symbol tabel
      for (Symbol codeSymbol : codeSymbols) {
         if(codeSymbol.getFullName().equals(SymbolRef.PROCEXIT_BLOCK_NAME)) continue;
         Symbol tableSymbol = getSymbols().getSymbol(codeSymbol.getFullName());
         if(tableSymbol==null) {
            throw new AssertionFailed("Compile process error. Symbol found in code, but not in symbol table. "+codeSymbol.getFullName());
         }
      }
      // Check that all symbols in the symbol table is also in the code
      HashSet<Symbol> tableSymbols = getAllSymbols(getSymbols());
      for (Symbol tableSymbol : tableSymbols) {
         if(tableSymbol instanceof VariableUnversioned) continue;
         if(tableSymbol instanceof ConstantVar) continue;
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
      for (Symbol symbol : symbols.getAllSymbols()) {
         allSymbols.add(symbol);
         if(symbol instanceof Scope) {
            HashSet<Symbol> subSymbols = getAllSymbols((Scope) symbol);
            allSymbols.addAll(subSymbols);
         }
      }
      return allSymbols;
   }

   private static class SymbolFinder extends ControlFlowGraphBaseVisitor<Void> {

      private ProgramScope programScope;

      public SymbolFinder(ProgramScope programScope) {
         this.programScope = programScope;
      }

      private HashSet<Symbol> symbols = new HashSet<>();

      public HashSet<Symbol> getSymbols() {
         return symbols;
      }

      private void addSymbol(Value symbol) {
         if (symbol instanceof Symbol) {
            symbols.add((Symbol) symbol);
         } else if(symbol instanceof SymbolRef) {
            addSymbol(programScope.getSymbol((SymbolRef) symbol));
         } else if(symbol instanceof PointerDereferenceIndexed) {
            addSymbol(((PointerDereferenceIndexed) symbol).getPointer());
            addSymbol(((PointerDereferenceIndexed) symbol).getIndex());
         } else if(symbol instanceof PointerDereferenceSimple) {
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
      public Void visitProcedureBegin(StatementProcedureBegin procedureBegin) {
         ProcedureRef procedureRef = procedureBegin.getProcedure();
         Procedure procedure = programScope.getProcedure(procedureRef);
         symbols.add(procedure);
         return super.visitProcedureBegin(procedureBegin);
      }

      @Override
      public Void visitProcedureEnd(StatementProcedureEnd procedureEnd) {
         ProcedureRef procedureRef = procedureEnd.getProcedure();
         Procedure procedure = programScope.getProcedure(procedureRef);
         symbols.add(procedure);
         return super.visitProcedureEnd(procedureEnd);
      }

      @Override
      public Void visitReturn(StatementReturn aReturn) {
         addSymbol(aReturn.getValue());
         return super.visitReturn(aReturn);
      }

      @Override
      public Void visitConditionalJump(StatementConditionalJump conditionalJump) {
         addSymbol(conditionalJump.getrValue1());
         addSymbol(conditionalJump.getrValue2());
         addSymbol(conditionalJump.getDestination());
         return super.visitConditionalJump(conditionalJump);
      }

      @Override
      public Void visitAssignment(StatementAssignment assignment) {
         addSymbol(assignment.getlValue());
         addSymbol(assignment.getrValue1());
         addSymbol(assignment.getrValue2());
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
      public Void visitCall(StatementCall call) {
         addSymbol(call.getlValue());
         addSymbol(call.getProcedure());
         if(call.getParameters()!=null) {
            for (RValue param : call.getParameters()) {
               addSymbol(param);
            }
         }
         return super.visitCall(call);
      }

      @Override
      public Void visitPhiBlock(StatementPhiBlock phi) {
         for (StatementPhiBlock.PhiVariable phiVariable : phi.getPhiVariables()) {
            addSymbol(phiVariable.getVariable());
            for (StatementPhiBlock.PhiRValue phiRValue : phiVariable.getValues()) {
               addSymbol(phiRValue.getrValue());
            }
         }
         return super.visitPhiBlock(phi);
      }
   }
}

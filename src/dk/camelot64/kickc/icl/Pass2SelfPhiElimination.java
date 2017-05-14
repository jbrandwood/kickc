package dk.camelot64.kickc.icl;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

/** Compiler Pass eliminating phi self assignments  */
public class Pass2SelfPhiElimination extends Pass2Optimization{

   public Pass2SelfPhiElimination(ControlFlowGraph graph, SymbolTable symbolTable) {
      super(graph, symbolTable);
   }

   /**
    * Eliminate alias assignments replacing them with the aliased variable.
    */
   @Override
   public boolean optimize() {
      final Boolean[] optimized = {Boolean.FALSE};
      ControlFlowGraphBaseVisitor<Void> visitor = new ControlFlowGraphBaseVisitor<Void>() {
         @Override
         public Void visitPhi(StatementPhi phi) {
            for (Iterator<StatementPhi.PreviousSymbol> iterator = phi.getPreviousVersions().iterator(); iterator.hasNext(); ) {
               StatementPhi.PreviousSymbol previousSymbol = iterator.next();
               if (previousSymbol.getRValue().equals(phi.getLValue())) {
                  iterator.remove();
                  optimized[0] = Boolean.TRUE;
                  System.out.println("Self Phi Eliminated "+phi.getLValue());
               }
            }
            return null;
         }
      };
      visitor.visitGraph(getGraph());
      return optimized[0];
   }
}

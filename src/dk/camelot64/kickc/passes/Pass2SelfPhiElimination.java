package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.icl.*;

import java.util.Iterator;

/** Compiler Pass eliminating phi self assignments  */
public class Pass2SelfPhiElimination extends Pass2SsaOptimization {

   public Pass2SelfPhiElimination(ControlFlowGraph graph, ProgramScope scope, CompileLog log) {
      super(graph, scope, log);
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
               if (previousSymbol.getRValue().equals(phi.getlValue())) {
                  iterator.remove();
                  optimized[0] = Boolean.TRUE;
                  log.append("Self Phi Eliminated "+phi.getlValue().getAsTypedString(getSymbols()));
               }
            }
            return null;
         }
      };
      visitor.visitGraph(getGraph());
      return optimized[0];
   }
}

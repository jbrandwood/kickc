package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.icl.*;

import java.util.Iterator;

/** Compiler Pass eliminating phi self assignments  */
public class Pass2SelfPhiElimination extends Pass2SsaOptimization {

   public Pass2SelfPhiElimination(Program program) {
      super(program);
   }

   /**
    * Eliminate alias assignments replacing them with the aliased variable.
    */
   @Override
   public boolean optimize() {
      final Boolean[] optimized = {Boolean.FALSE};
      ControlFlowGraphBaseVisitor<Void> visitor = new ControlFlowGraphBaseVisitor<Void>() {
         @Override
         public Void visitPhiBlock(StatementPhiBlock phi) {
            for (StatementPhiBlock.PhiVariable phiVariable : phi.getPhiVariables()) {
               Iterator<StatementPhiBlock.PhiRValue> iterator = phiVariable.getValues().iterator();
               while (iterator.hasNext()) {
                  StatementPhiBlock.PhiRValue phiRValue = iterator.next();
                  if (phiRValue.getrValue().equals(phiVariable.getVariable())) {
                     iterator.remove();
                     optimized[0] = Boolean.TRUE;
                     getLog().append("Self Phi Eliminated "+phiVariable.getVariable().toString(getProgram()));
                  }
               }
            }
            return null;
         }
      };
      visitor.visitGraph(getGraph());
      return optimized[0];
   }
}

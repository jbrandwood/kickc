package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowGraphBaseVisitor;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.StatementPhiBlock;

import java.util.Iterator;

/** Compiler Pass eliminating phi self assignments */
public class Pass2SelfPhiElimination extends Pass2SsaOptimization {

   public Pass2SelfPhiElimination(Program program) {
      super(program);
   }

   /**
    * Eliminate phi variables pointing to themselves
    */
   @Override
   public boolean step() {
      final Boolean[] optimized = {Boolean.FALSE};
      ControlFlowGraphBaseVisitor<Void> visitor = new ControlFlowGraphBaseVisitor<Void>() {
         @Override
         public Void visitPhiBlock(StatementPhiBlock phi) {
            for(StatementPhiBlock.PhiVariable phiVariable : phi.getPhiVariables()) {
               Iterator<StatementPhiBlock.PhiRValue> iterator = phiVariable.getValues().iterator();
               while(iterator.hasNext()) {
                  StatementPhiBlock.PhiRValue phiRValue = iterator.next();
                  if(phiRValue.getrValue().equals(phiVariable.getVariable())) {
                     iterator.remove();
                     optimized[0] = Boolean.TRUE;
                     getLog().append("Self Phi Eliminated " + phiVariable.getVariable().toString(getProgram()));
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

package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;

/** Asserts that the program does not contain any lo/hi lvalues (&gt;plotter = $20) as they are replaced with =lo assignments ( plotter = plotter =lo $20 )  */
public class Pass2AssertNoLvalueLoHi extends Pass2SsaAssertion {

   public Pass2AssertNoLvalueLoHi(Program program) {
      super(program);
   }

   @Override
   public void check() throws AssertionFailed {

      ControlFlowGraphBaseVisitor<Void> checkCalls = new ControlFlowGraphBaseVisitor<Void>() {
         @Override
         public Void visitAssignment(StatementAssignment assignment) {
            if(assignment.getlValue() instanceof LvalueLoHiByte) {
               throw new AssertionFailed("No lValue lo/hi allowed! "+ assignment);
            }
            return null;
         }

      };
      checkCalls.visitGraph(getGraph());
   }

}

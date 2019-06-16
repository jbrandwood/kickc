package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.values.StructUnwoundPlaceholder;

import java.util.ListIterator;

/** Remove any assignments with {@link dk.camelot64.kickc.model.values.StructUnwoundPlaceholder} as RValue */
public class PassNEliminateStructUnwoundPlaceholder extends Pass2SsaOptimization {

   public PassNEliminateStructUnwoundPlaceholder(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         ListIterator<Statement> stmtIt = block.getStatements().listIterator();
         while(stmtIt.hasNext()) {
            Statement stmt = stmtIt.next();
            if(stmt instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) stmt;
               if(assignment.getOperator() == null && assignment.getrValue2() instanceof StructUnwoundPlaceholder) {
                  getLog().append("Eliminating struct unwound placeholder "+stmt.toString(getProgram(), false));
                  stmtIt.remove();
               }
            }
         }
      }
      return false;
   }


}

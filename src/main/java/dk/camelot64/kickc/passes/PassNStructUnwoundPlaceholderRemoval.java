package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.values.StructUnwoundPlaceholder;
import dk.camelot64.kickc.model.values.SymbolVariableRef;
import dk.camelot64.kickc.model.values.VariableRef;

import java.util.ListIterator;
import java.util.concurrent.atomic.AtomicBoolean;

/**
 * Rewrite struct address-of to use the first member if the struct is unwound
 */
public class PassNStructUnwoundPlaceholderRemoval extends Pass2SsaOptimization {

   public PassNStructUnwoundPlaceholderRemoval(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      AtomicBoolean modified = new AtomicBoolean(false);

      // Remove all StructUnwoundPlaceholder assignments for C-classic structs
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         ListIterator<Statement> stmtIt = block.getStatements().listIterator();
         while(stmtIt.hasNext()) {
            Statement statement = stmtIt.next();
            if(statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               if(assignment.getrValue2() instanceof StructUnwoundPlaceholder && assignment.getlValue() instanceof VariableRef)
                  if(getProgramScope().getVariable((SymbolVariableRef) assignment.getlValue()).isStructClassic()) {
                     getLog().append("Removing C-classic struct-unwound assignment "+assignment.toString(getProgram(), false));
                     stmtIt.remove();
                  }
            }
         }
      }
      return modified.get();
   }

}

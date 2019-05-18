package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ConstantNotLiteral;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.values.*;

import java.util.concurrent.atomic.AtomicBoolean;

/**
 * Simplify any constant expression evaluating to zero
 */
public class PassNSimplifyConstantZero extends Pass2SsaOptimization {

   public PassNSimplifyConstantZero(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      AtomicBoolean modified = new AtomicBoolean(false);

      ProgramValueIterator.execute(getProgram(), (programValue, currentStmt, stmtIt, currentBlock) -> {
         Value value = programValue.get();
         if(value instanceof ConstantValue && !(value instanceof ConstantInteger) &&!(value instanceof ConstantRef)) {
            ConstantLiteral literal;
            try {
               literal = ((ConstantValue) value).calculateLiteral(getProgram().getScope());
            } catch( ConstantNotLiteral e) {
               return;
            }
            if(literal instanceof ConstantInteger) {
               if(((ConstantInteger) literal).getInteger()==0L) {
                  getLog().append("Simplifying constant evaluating to zero "+value.toString(getProgram()) + " in "+(currentStmt==null?"":currentStmt.toString(getProgram(), false)));
                  programValue.set(new ConstantInteger(0L, ((ConstantInteger) literal).getType()));
                  modified.set(true);
               }
            }
         }
      });
      return modified.get();
   }

}

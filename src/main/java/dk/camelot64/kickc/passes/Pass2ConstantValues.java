package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.values.*;

import java.util.concurrent.atomic.AtomicBoolean;

/**
 * Compiler Pass identifying constants values
 */
public class Pass2ConstantValues extends Pass2SsaOptimization {

   public Pass2ConstantValues(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      AtomicBoolean modified = new AtomicBoolean(false);

      ProgramValueIterator.execute(getProgram().getGraph(), (programValue, currentStmt, stmtIt, currentBlock) -> {
         Value value = programValue.get();
         if((value instanceof RValue) && !(value instanceof ConstantValue)) {
            ConstantValue constant = Pass2ConstantIdentification.getConstant((RValue) value);
            if(constant!=null) {
               programValue.set(constant);
               getLog().append("Constant value identified " + value+ " in "+ (currentStmt==null?"":currentStmt.toString(getProgram(), false)));
               modified.set(true);
            }
         }
      });
      return modified.get();
   }

}

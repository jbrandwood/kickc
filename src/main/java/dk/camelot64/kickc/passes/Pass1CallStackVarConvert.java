package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.Comment;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.ProcedureRef;

import java.util.ListIterator;

/** Handle calling conventions {@link Procedure.CallingConvention#STACK_CALL} {@link Procedure.CallingConvention#VAR_CALL} by converting to call-prepare, call-execute, call-finalize */
public class Pass1CallStackVarConvert extends Pass2SsaOptimization {

   public Pass1CallStackVarConvert(Program program) {
      super(program);
   }

   @Override
   public boolean step() {

      // Transform STACK_CALL/VAR_CALL calls to call-prepare, call-execute, call-finalize
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         ListIterator<Statement> stmtIt = block.getStatements().listIterator();
         while(stmtIt.hasNext()) {
            Statement statement = stmtIt.next();
            if(statement instanceof StatementCall) {
               StatementCall call = (StatementCall) statement;
               ProcedureRef procedureRef = call.getProcedure();
               Procedure procedure = getScope().getProcedure(procedureRef);
               if(Procedure.CallingConvention.STACK_CALL.equals(procedure.getCallingConvention()) || Procedure.CallingConvention.VAR_CALL.equals(procedure.getCallingConvention())) {
                  boolean hasPrepare = (call.getParameters().size() > 0) || !SymbolType.VOID.equals(procedure.getReturnType());
                  stmtIt.remove();
                  stmtIt.add(new StatementCallPrepare(procedureRef, call.getParameters(), call.getSource(), hasPrepare?call.getComments():Comment.NO_COMMENTS));
                  stmtIt.add(new StatementCallExecute(procedureRef, call.getSource(), hasPrepare?Comment.NO_COMMENTS:call.getComments()));
                  stmtIt.add(new StatementCallFinalize(call.getlValue(), procedureRef, call.getSource(), Comment.NO_COMMENTS));
                  getLog().append("Calling convention " + procedure.getCallingConvention().getName() + " adding prepare/execute/finalize for " + call.toString(getProgram(), false));
               }
            }
         }
      }

      return false;
   }


}

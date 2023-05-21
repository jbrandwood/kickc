package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeInference;
import dk.camelot64.kickc.model.types.SymbolTypeProcedure;
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
      for(var block : getGraph().getAllBlocks()) {
         ListIterator<Statement> stmtIt = block.getStatements().listIterator();
         while(stmtIt.hasNext()) {
            Statement statement = stmtIt.next();
            if(statement instanceof StatementCall) {
               StatementCall call = (StatementCall) statement;
               ProcedureRef procedureRef = call.getProcedure();
               Procedure procedure = getProgramScope().getProcedure(procedureRef);
               Procedure.CallingConvention callingConvention = procedure.getCallingConvention();
               if(Procedure.CallingConvention.STACK_CALL.equals(callingConvention) || Procedure.CallingConvention.VAR_CALL.equals(callingConvention)) {
                  boolean hasParamOrReturn = (call.getParameters().size() > 0) || !SymbolType.VOID.equals(procedure.getReturnType());
                  stmtIt.remove();
                  stmtIt.add(new StatementCallPrepare(procedure.getType(), procedureRef, call.getParameters(), callingConvention, call.getSource(), hasParamOrReturn?call.getComments():Comment.NO_COMMENTS));
                  stmtIt.add(new StatementCallExecute(procedure.getType(), procedureRef, callingConvention, call.getSource(), hasParamOrReturn?Comment.NO_COMMENTS:call.getComments()));
                  stmtIt.add(new StatementCallFinalize(call.getlValue(), procedure.getType(), procedureRef, callingConvention, call.getSource(), Comment.NO_COMMENTS));
                  getLog().append("Calling convention " + callingConvention.getName() + " adding prepare/execute/finalize for " + call.toString(getProgram(), false));
               }
            } else if(statement instanceof StatementCallPointer) {
               StatementCallPointer call = (StatementCallPointer) statement;
               boolean hasParamOrReturn = call.getNumParameters() > 0 || call.getlValue() != null;
               //if(hasParamOrReturn) {
               final SymbolType procType = SymbolTypeInference.inferType(getProgramScope(), call.getProcedure());
               if(!(procType instanceof SymbolTypeProcedure)) {
                  throw new CompileError("Called object is not a function or function pointer "+call.getProcedure().toString(), call);
               }
               SymbolTypeProcedure procedureType = (SymbolTypeProcedure) procType;
                  // Perform stack call
                  stmtIt.remove();
                  stmtIt.add(new StatementCallPrepare(procedureType, null, call.getParameters(), Procedure.CallingConvention.STACK_CALL, call.getSource(), hasParamOrReturn?call.getComments():Comment.NO_COMMENTS));
                  stmtIt.add(new StatementCallExecute(procedureType, call.getProcedure(), Procedure.CallingConvention.STACK_CALL, call.getSource(), hasParamOrReturn?Comment.NO_COMMENTS:call.getComments()));
                  stmtIt.add(new StatementCallFinalize(call.getlValue(), procedureType, null, Procedure.CallingConvention.STACK_CALL, call.getSource(), Comment.NO_COMMENTS));
                  getLog().append("Calling convention " + Procedure.CallingConvention.STACK_CALL + " adding prepare/execute/finalize for " + call.toString(getProgram(), false));
               //}
            }

         }
      }

      return false;
   }


}

package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.Comment;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.ProcedureRef;
import dk.camelot64.kickc.model.values.VariableRef;

import java.util.ListIterator;
import java.util.Set;

/** Handle calling conventions {@link Procedure.CallingConvention#STACK_CALL} {@link Procedure.CallingConvention#VAR_CALL} by converting to call-prepare, call-execute, call-finalize */
public class Pass1CallStackVar extends Pass2SsaOptimization {

   public Pass1CallStackVar(Program program) {
      super(program);
   }

   @Override
   public boolean step() {

      // Set variables modified in STACK_CALL/VAR_CALL procedures to load/store
      for(Procedure procedure : getScope().getAllProcedures(true)) {
         if(Procedure.CallingConvention.STACK_CALL.equals(procedure.getCallingConvention()) || Procedure.CallingConvention.VAR_CALL.equals(procedure.getCallingConvention())) {
            Set<VariableRef> modifiedVars = getProgram().getProcedureModifiedVars().getModifiedVars(procedure.getRef());
            for(VariableRef modifiedVar : modifiedVars) {
               final Variable variable = getScope().getVariable(modifiedVar);
               if(variable.isKindPhiMaster()) {
                  getLog().append("Converting PHI-variable modified inside "+procedure.getCallingConvention().getName()+" procedure "+procedure.getFullName()+"() to load/store "+variable.toString(getProgram()));
                  variable.setKind(Variable.Kind.LOAD_STORE);
               }
            }
         }
      }

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

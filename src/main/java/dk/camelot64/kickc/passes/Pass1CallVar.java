package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.Comment;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.InternalError;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeInference;
import dk.camelot64.kickc.model.values.LValue;
import dk.camelot64.kickc.model.values.ParamValue;
import dk.camelot64.kickc.model.values.RValue;
import dk.camelot64.kickc.model.values.VariableRef;

import java.util.List;
import java.util.ListIterator;
import java.util.Set;

/** Handle calling convention {@link Procedure.CallingConvention#VAR_CALL } by converting the making control flow graph and symbols calling convention specific. */
public class Pass1CallVar extends Pass2SsaOptimization {

   public Pass1CallVar(Program program) {
      super(program);
   }

   @Override
   public boolean step() {

      // Set all parameter/return variables in VAR_CALL procedures to LOAD/STORE
      for(Procedure procedure : getScope().getAllProcedures(true)) {
         if(Procedure.CallingConvention.VAR_CALL.equals(procedure.getCallingConvention())) {
            for(Variable parameter : procedure.getParameters()) {
               parameter.setKind(Variable.Kind.LOAD_STORE);
               getLog().append("Converting parameter in "+procedure.getCallingConvention().getName()+" procedure to load/store "+parameter.toString(getProgram()));
            }
            if(!SymbolType.VOID.equals(procedure.getReturnType())) {
               Variable returnVar = procedure.getLocalVariable("return");
               returnVar.setKind(Variable.Kind.LOAD_STORE);
               getLog().append("Converting return in "+procedure.getCallingConvention().getName()+" procedure to load/store "+returnVar.toString(getProgram()));
            }
         }
      }

      // Convert param(xxx) to ??? = xxx
      ProgramValueIterator.execute(getGraph(), (programValue, currentStmt, stmtIt, currentBlock) -> {
               if(programValue.get() instanceof ParamValue) {
                  // Convert ParamValues to calling-convention specific param-value
                  ParamValue paramValue = (ParamValue) programValue.get();
                  VariableRef parameterRef = paramValue.getParameter();
                  SymbolType parameterType = SymbolTypeInference.inferType(getScope(), paramValue.getParameter());
                  final Variable paramVar = getScope().getVariable(parameterRef);
                  final Scope blockScope = paramVar.getScope();
                  if(blockScope instanceof Procedure) {
                     Procedure procedure = (Procedure) blockScope;
                     if(Procedure.CallingConvention.VAR_CALL.equals(procedure.getCallingConvention())) {
                        throw new InternalError(paramValue.toString());
                        //programValue.set(stackIdxValue);
                        //getLog().append("Calling convention " + Procedure.CallingConvention.STACK_CALL + " replacing " + paramValue.toString(getProgram()) + " with " + stackIdxValue.toString(getProgram()));
                     }
                  }
               }
            }
      );

      // Convert procedure return xxx to proc.return = xxx;
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         ListIterator<Statement> stmtIt = block.getStatements().listIterator();
         while(stmtIt.hasNext()) {
            Statement statement = stmtIt.next();
            if(statement instanceof StatementReturn) {
               final Scope blockScope = getScope().getScope(block.getScope());
               if(blockScope instanceof Procedure) {
                  Procedure procedure = (Procedure) blockScope;
                  final SymbolType returnType = procedure.getReturnType();
                  if(!SymbolType.VOID.equals(returnType) && Procedure.CallingConvention.VAR_CALL.equals(procedure.getCallingConvention())) {
                     final RValue value = ((StatementReturn) statement).getValue();
                     //stmtIt.previous();
                     //generateStackReturnValues(value, returnType, returnOffsetConstant, statement.getSource(), statement.getComments(), stmtIt);
                     //stmtIt.next();
                     //((StatementReturn) statement).setValue(null);
                     throw new InternalError(statement.toString());
                  }
               }
            }
         }
      }

      // Convert xxx = callfinalize to xxx = proc.return
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         ListIterator<Statement> stmtIt = block.getStatements().listIterator();
         while(stmtIt.hasNext()) {
            Statement statement = stmtIt.next();
            if(statement instanceof StatementCallFinalize) {
               final StatementCallFinalize call = (StatementCallFinalize) statement;
               Procedure procedure = getScope().getProcedure(call.getProcedure());
               final SymbolType returnType = procedure.getReturnType();
               if(Procedure.CallingConvention.VAR_CALL.equals(procedure.getCallingConvention())) {
                  final StatementSource source = call.getSource();
                  final List<Comment> comments = call.getComments();
                  final LValue lValue = call.getlValue();
                  if(lValue!=null) {
                     Variable returnVar = procedure.getLocalVariable("return");
                     stmtIt.previous();
                     stmtIt.add(new StatementAssignment(lValue, returnVar.getRef(), call.isInitialAssignment(), source, comments));
                     stmtIt.next();
                  }
                  stmtIt.remove();
               }
            }
         }
      }

      // Convert callprepare(xxx,yyy,) to proc.param = xxx, ...;
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         ListIterator<Statement> stmtIt = block.getStatements().listIterator();
         while(stmtIt.hasNext()) {
            Statement statement = stmtIt.next();
            if(statement instanceof StatementCallPrepare) {
               final StatementCallPrepare call = (StatementCallPrepare) statement;
               Procedure procedure = getScope().getProcedure(call.getProcedure());
               if(Procedure.CallingConvention.VAR_CALL.equals(procedure.getCallingConvention())) {
                  stmtIt.previous();
                  final StatementSource source = call.getSource();
                  List<Comment> comments = call.getComments();
                  final List<Variable> parameterDefs = procedure.getParameters();
                  for(int i = 0; i < parameterDefs.size(); i++) {
                     final RValue parameterVal = call.getParameters().get(i);
                     final Variable parameterDef = parameterDefs.get(i);
                     stmtIt.add(new StatementAssignment(parameterDef.getVariableRef(), parameterVal, false, source, comments));
                     comments = Comment.NO_COMMENTS;
                  }
                  stmtIt.next();
                  stmtIt.remove();
               }
            }
         }
      }
      return false;
   }

}

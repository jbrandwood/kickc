package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.Comment;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Graph;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;
import dk.camelot64.kickc.model.values.CastValue;
import dk.camelot64.kickc.model.values.LValue;
import dk.camelot64.kickc.model.values.RValue;
import dk.camelot64.kickc.model.values.ValueList;
import dk.camelot64.kickc.passes.unwinding.ValueSource;
import dk.camelot64.kickc.passes.unwinding.ValueSourceFactory;

import java.util.List;
import java.util.ListIterator;

/** Handle calling convention {@link Procedure.CallingConvention#VAR_CALL } by converting the making control flow graph and symbols calling convention specific. */
public class Pass1CallVar extends Pass2SsaOptimization {

   public Pass1CallVar(Program program) {
      super(program);
   }

   @Override
   public boolean step() {

      // Convert procedure return xxx to proc.return = xxx;
      for(var block : getGraph().getAllBlocks()) {
         ListIterator<Statement> stmtIt = block.getStatements().listIterator();
         while(stmtIt.hasNext()) {
            Statement statement = stmtIt.next();
            if(statement instanceof StatementReturn) {
               final Scope blockScope = getProgramScope().getScope(block.getScope());
               if(blockScope instanceof Procedure) {
                  Procedure procedure = (Procedure) blockScope;
                  final SymbolType returnType = procedure.getReturnType();
                  if(!SymbolType.VOID.equals(returnType) && Procedure.CallingConvention.VAR_CALL.equals(procedure.getCallingConvention())) {
                     final RValue value = ((StatementReturn) statement).getValue();
                     ((StatementReturn) statement).setValue(null);
                  }
               }
            }
         }
      }

      // Convert xxx = callfinalize to xxx = proc.return
      for(var block : getGraph().getAllBlocks()) {
         ListIterator<Statement> stmtIt = block.getStatements().listIterator();
         while(stmtIt.hasNext()) {
            Statement statement = stmtIt.next();
            if(statement instanceof StatementCallFinalize) {
               final StatementCallFinalize call = (StatementCallFinalize) statement;
               Procedure procedure = getProgramScope().getProcedure(call.getProcedure());
               if(Procedure.CallingConvention.VAR_CALL.equals(procedure.getCallingConvention())) {
                  final StatementSource source = call.getSource();
                  final List<Comment> comments = call.getComments();
                  final LValue lValue = call.getlValue();
                  if(lValue!=null) {
                     Variable returnVar = procedure.getLocalVariable("return");
                     generateCallFinalize(lValue, returnVar,  source, comments, stmtIt, statement);
                  }
                  stmtIt.remove();
               }
            }
         }
      }

      // Convert callprepare(xxx,yyy,) to proc.param = xxx, ...;
      for(var block : getGraph().getAllBlocks()) {
         ListIterator<Statement> stmtIt = block.getStatements().listIterator();
         while(stmtIt.hasNext()) {
            Statement statement = stmtIt.next();
            if(statement instanceof StatementCallPrepare) {
               final StatementCallPrepare call = (StatementCallPrepare) statement;
               Procedure procedure = getProgramScope().getProcedure(call.getProcedure());
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

   private void generateCallFinalize(LValue lValue, Variable returnVar, StatementSource source, List<Comment> comments, ListIterator<Statement> stmtIt, Statement currentStmt) {
      final SymbolType returnType = returnVar.getType();
      if(!(lValue instanceof ValueList) || !(returnType instanceof SymbolTypeStruct)) {
         // A simple value - add simple assignment
         final StatementAssignment stackPull = new StatementAssignment(lValue, returnVar.getRef(), false, source, comments);
         stmtIt.previous();
         stmtIt.add(stackPull);
         stmtIt.next();
         getLog().append("Calling convention " + Procedure.CallingConvention.VAR_CALL + " adding return value assignment " + stackPull);
      } else {
         final CastValue structLValue = new CastValue(returnType, lValue);
         // A struct to unwind
         final ValueSource lValueSource = ValueSourceFactory.getValueSource(structLValue, getProgram(), getProgramScope(), currentStmt, stmtIt, null);
         final ValueSource rValueSource = ValueSourceFactory.getValueSource(returnVar.getRef(), getProgram(), getProgramScope(), currentStmt, stmtIt, null);
         Pass1UnwindStructValues.copyValues(lValueSource, rValueSource, null, false, currentStmt, null, stmtIt, getProgram());
      }
   }

}

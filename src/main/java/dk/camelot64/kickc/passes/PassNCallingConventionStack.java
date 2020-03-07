package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CallingConventionStack;
import dk.camelot64.kickc.model.Comment;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.symbols.StructDefinition;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeInference;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;
import dk.camelot64.kickc.model.values.*;
import dk.camelot64.kickc.passes.utils.SizeOfConstants;

import java.util.*;

/** Handle calling convention {@link Procedure.CallingConvention#STACK_CALL} by converting the making control flow graph and symbols calling convention specific. */
public class PassNCallingConventionStack extends Pass2SsaOptimization {

   public PassNCallingConventionStack(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      // Offset-constants for all stack-call parameters
      Map<SymbolVariableRef, ConstantRef> offsetConstants = new HashMap<>();

      // Introduce STACK_OFFSET constants
      boolean createStackBase = false;
      for(Procedure procedure : getScope().getAllProcedures(true)) {
         if(Procedure.CallingConvention.STACK_CALL.equals(procedure.getCallingConvention())) {
            // Introduce the parameter offsets
            for(Variable parameter : procedure.getParameters()) {
               ConstantRef parameterOffsetConstant = CallingConventionStack.getParameterOffsetConstant(procedure, parameter);
               offsetConstants.put(parameter.getRef(), parameterOffsetConstant);
               createStackBase = true;
            }
            // Introduce the return value offset
            if(procedure.getReturnType() != null && !SymbolType.VOID.equals(procedure.getReturnType())) {
               CallingConventionStack.getReturnOffsetConstant(procedure);
               createStackBase = true;
            }
         }
      }

      // Add global STACK_BASE constant
      if(createStackBase)
         CallingConventionStack.getStackBaseConstant(getScope());

      // Transform STACK_CALL calls to call-prepare, call-execute, call-finalize
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         ListIterator<Statement> stmtIt = block.getStatements().listIterator();
         while(stmtIt.hasNext()) {
            Statement statement = stmtIt.next();
            if(statement instanceof StatementCall) {
               StatementCall call = (StatementCall) statement;
               ProcedureRef procedureRef = call.getProcedure();
               Procedure procedure = getScope().getProcedure(procedureRef);
               if(Procedure.CallingConvention.STACK_CALL.equals(procedure.getCallingConvention())) {
                  stmtIt.remove();
                  stmtIt.add(new StatementCallPrepare(procedureRef, call.getParameters(), call.getSource(), call.getComments()));
                  stmtIt.add(new StatementCallExecute(procedureRef, call.getSource(), call.getComments()));
                  stmtIt.add(new StatementCallFinalize(call.getlValue(), procedureRef, call.getSource(), call.getComments()));
                  getLog().append("Calling convention " + Procedure.CallingConvention.STACK_CALL + " adding prepare/execute/finalize for " + call.toString(getProgram(), false));
               }
            }
         }
      }

      // Convert param(xxx) to stackidx(PARAM_X) = xxx
      if(offsetConstants.size() > 0) {
         ProgramValueIterator.execute(getGraph(), (programValue, currentStmt, stmtIt, currentBlock) -> {
            if(programValue.get() instanceof ParamValue) {
               // Convert ParamValues to calling-convention specific param-value
               ParamValue paramValue = (ParamValue) programValue.get();
               VariableRef parameterRef = paramValue.getParameter();
               SymbolType parameterType = SymbolTypeInference.inferType(getScope(), paramValue.getParameter());
               if(offsetConstants.containsKey(parameterRef)) {
                  StackIdxValue stackIdxValue = new StackIdxValue(offsetConstants.get(parameterRef), parameterType);
                  programValue.set(stackIdxValue);
                  getLog().append("Calling convention " + Procedure.CallingConvention.STACK_CALL + " replacing " + paramValue.toString(getProgram()) + " with " + stackIdxValue.toString(getProgram()));
               }
            }
         });
      }

      // Convert procedure return xxx to stackidx(RETURN) = xxx;
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         ListIterator<Statement> stmtIt = block.getStatements().listIterator();
         while(stmtIt.hasNext()) {
            Statement statement = stmtIt.next();
            if(statement instanceof StatementReturn) {
               final Scope blockScope = getScope().getScope(block.getScope());
               if(blockScope instanceof Procedure) {
                  Procedure procedure = (Procedure) blockScope;
                  final SymbolType returnType = procedure.getReturnType();
                  if(!SymbolType.VOID.equals(returnType) && Procedure.CallingConvention.STACK_CALL.equals(procedure.getCallingConvention())) {
                     ConstantRef returnOffsetConstant = CallingConventionStack.getReturnOffsetConstant(procedure);
                     final RValue value = ((StatementReturn) statement).getValue();
                     stmtIt.previous();
                     generateStackReturnValues(value, returnType, returnOffsetConstant, statement.getSource(), statement.getComments(), stmtIt);
                     stmtIt.next();
                     ((StatementReturn) statement).setValue(null);
                  }
               }
            }
         }
      }

      // Convert xxx = callfinalize to xxx = stackpull(type);
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         ListIterator<Statement> stmtIt = block.getStatements().listIterator();
         while(stmtIt.hasNext()) {
            Statement statement = stmtIt.next();
            if(statement instanceof StatementCallFinalize) {
               final StatementCallFinalize call = (StatementCallFinalize) statement;
               Procedure procedure = getScope().getProcedure(call.getProcedure());
               final SymbolType returnType = procedure.getReturnType();
               if(Procedure.CallingConvention.STACK_CALL.equals(procedure.getCallingConvention())) {
                  long stackFrameByteSize = CallingConventionStack.getStackFrameByteSize(procedure);
                  long returnByteSize = procedure.getReturnType() == null ? 0 : procedure.getReturnType().getSizeBytes();
                  long stackCleanBytes = (call.getlValue() == null) ? stackFrameByteSize : (stackFrameByteSize - returnByteSize);
                  stmtIt.previous();
                  final StatementSource source = call.getSource();
                  final List<Comment> comments = call.getComments();
                  if(stackCleanBytes > 0) {
                     // Clean up the stack
                     stmtIt.add(new StatementExprSideEffect( new StackPullBytes(new ConstantInteger(stackCleanBytes)), source, comments));
                  }
                  final RValue value = call.getlValue();
                  if(value!=null)
                     generateStackPullValues(value, returnType, statement.getSource(), statement.getComments(), stmtIt);
                  stmtIt.next();
                  stmtIt.remove();
               }
            }
         }
      }

      // Convert callprepare(xxx,yyy,) stackpush(type)=xxx, ...;
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         ListIterator<Statement> stmtIt = block.getStatements().listIterator();
         while(stmtIt.hasNext()) {
            Statement statement = stmtIt.next();
            if(statement instanceof StatementCallPrepare) {
               final StatementCallPrepare call = (StatementCallPrepare) statement;
               Procedure procedure = getScope().getProcedure(call.getProcedure());
               if(Procedure.CallingConvention.STACK_CALL.equals(procedure.getCallingConvention())) {
                  stmtIt.previous();
                  final StatementSource source = call.getSource();
                  final List<Comment> comments = call.getComments();
                  final List<Variable> parameterDefs = procedure.getParameters();
                  for(int i=0;i<parameterDefs.size();i++) {
                     final RValue parameterVal = call.getParameters().get(i);
                     final Variable parameterDef = parameterDefs.get(i);
                     generateStackPushValues(parameterVal, parameterDef.getType(), statement.getSource(), statement.getComments(), stmtIt);
                  }
                  // Push additional bytes for padding if needed
                  long stackFrameByteSize = CallingConventionStack.getStackFrameByteSize(procedure);
                  long parametersByteSize = CallingConventionStack.getParametersByteSize(procedure);
                  final long stackPadBytes = stackFrameByteSize - parametersByteSize;
                  if(stackFrameByteSize > parametersByteSize) {
                     // Add padding to the stack to make room for the return value
                        stmtIt.add(new StatementExprSideEffect( new StackPushBytes(new ConstantInteger(stackPadBytes)), source, comments));
                  }
                  stmtIt.next();
                  stmtIt.remove();
               }
            }
         }
      }



      return false;
   }

   /**
    * Put a return value onto the stack by generating  stackidx(RETURN) = xxx assignments
    *
    * @param value The value to return
    * @param returnType The type of the value
    * @param stackReturnOffset The offset onto the stack to place the value at
    * @param source The source line
    * @param comments The comments
    * @param stmtIt The statment iterator used to add statements to.
    */
   private void generateStackReturnValues(RValue value, SymbolType returnType, ConstantValue stackReturnOffset, StatementSource source, List<Comment> comments, ListIterator<Statement> stmtIt) {
      if(!(value instanceof ValueList) || !(returnType instanceof SymbolTypeStruct)) {
         // A simple value to put on the stack
         final StatementAssignment stackReturn = new StatementAssignment(new StackIdxValue(stackReturnOffset, returnType), value, false, source, comments);
         stmtIt.add(stackReturn);
         getLog().append("Calling convention " + Procedure.CallingConvention.STACK_CALL + " adding stack return " + stackReturn);
      } else {
         // A struct to put on the stack
         final List<RValue> memberValues = ((ValueList) value).getList();
         final StructDefinition structDefinition = ((SymbolTypeStruct) returnType).getStructDefinition(getScope());
         final List<Variable> memberVars = new ArrayList<>(structDefinition.getAllVars(false));
         for(int i = 0; i < memberVars.size(); i++) {
            final Variable memberVar = memberVars.get(i);
            final RValue memberValue = memberValues.get(i);
            ConstantRef structMemberOffsetConstant = SizeOfConstants.getStructMemberOffsetConstant(getScope(), structDefinition, memberVar.getLocalName());
            ConstantBinary memberReturnOffsetConstant = new ConstantBinary(stackReturnOffset, Operators.PLUS, structMemberOffsetConstant);
            generateStackReturnValues(memberValue, memberVar.getType(), memberReturnOffsetConstant, source, comments, stmtIt);
         }
      }
   }

   /**
    * Generate stack pull xxx = stackpull(type) assignments
    *
    * @param value The value to return
    * @param symbolType The type of the value
    * @param source The source line
    * @param comments The comments
    * @param stmtIt The statement iterator used to add statements to.
    */
   private void generateStackPullValues(RValue value, SymbolType symbolType, StatementSource source, List<Comment> comments, ListIterator<Statement> stmtIt) {
      if(!(value instanceof ValueList) || !(symbolType instanceof SymbolTypeStruct)) {
         // A simple value to put on the stack
         final StatementAssignment stackPull = new StatementAssignment((LValue) value, new StackPullValue(symbolType), false, source, comments);
         stmtIt.add(stackPull);
         getLog().append("Calling convention " + Procedure.CallingConvention.STACK_CALL + " adding stack pull " + stackPull);
      } else {
         // A struct to put on the stack
         final List<RValue> memberValues = ((ValueList) value).getList();
         final StructDefinition structDefinition = ((SymbolTypeStruct) symbolType).getStructDefinition(getScope());
         final List<Variable> memberVars = new ArrayList<>(structDefinition.getAllVars(false));
         for(int i = 0; i < memberVars.size(); i++) {
            final Variable memberVar = memberVars.get(i);
            final RValue memberValue = memberValues.get(i);
            generateStackPullValues(memberValue, memberVar.getType(), source, comments, stmtIt);
         }
      }
   }

   /**
    * Generate stack push stackpull(type)=xxx assignments
    *
    * @param value The value to push
    * @param symbolType The type of the value
    * @param source The source line
    * @param comments The comments
    * @param stmtIt The statement iterator used to add statements to.
    */
   private void generateStackPushValues(RValue value, SymbolType symbolType, StatementSource source, List<Comment> comments, ListIterator<Statement> stmtIt) {
      if(!(value instanceof ValueList) || !(symbolType instanceof SymbolTypeStruct)) {
         // A simple value to put on the stack
         final StatementAssignment stackPull = new StatementAssignment(new StackPushValue(symbolType), value, false, source, comments);
         stmtIt.add(stackPull);
         getLog().append("Calling convention " + Procedure.CallingConvention.STACK_CALL + " adding stack push " + stackPull);
      } else {
         // A struct to put on the stack
         final List<RValue> memberValues = ((ValueList) value).getList();
         final StructDefinition structDefinition = ((SymbolTypeStruct) symbolType).getStructDefinition(getScope());
         final List<Variable> memberVars = new ArrayList<>(structDefinition.getAllVars(false));
         for(int i = 0; i < memberVars.size(); i++) {
            final Variable memberVar = memberVars.get(i);
            final RValue memberValue = memberValues.get(i);
            generateStackPushValues(memberValue, memberVar.getType(), source, comments, stmtIt);
         }
      }
   }

}

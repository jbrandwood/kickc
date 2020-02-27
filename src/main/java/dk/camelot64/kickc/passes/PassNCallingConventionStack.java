package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CallingConventionStack;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.symbols.*;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeInference;
import dk.camelot64.kickc.model.values.*;

import java.util.HashMap;
import java.util.ListIterator;
import java.util.Map;

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

      if(offsetConstants.size() > 0) {
         // Convert ParamValue to StackIdxValue
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
      return false;
   }

}

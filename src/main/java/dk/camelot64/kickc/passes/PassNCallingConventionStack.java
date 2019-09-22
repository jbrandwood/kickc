package dk.camelot64.kickc.passes;

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

/** Handle calling convention {@link Procedure.CallingConvension#STACK_CALL} by converting the making control flow graph and symbols calling convention specific. */
public class PassNCallingConventionStack extends Pass2SsaOptimization {

   public PassNCallingConventionStack(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      // Offset-constants for all stack-call parameters
      Map<VariableRef, ConstantRef> offsetConstants = new HashMap<>();

      // Introduce STACK_OFFSET constants
      for(Procedure procedure : getScope().getAllProcedures(true)) {
         if(Procedure.CallingConvension.STACK_CALL.equals(procedure.getCallingConvension())) {
            for(Variable parameter : procedure.getParameters()) {
               ConstantRef parameterOffsetConstant = getParameterOffsetConstant(procedure, parameter, getScope());
               offsetConstants.put(parameter.getRef(), parameterOffsetConstant);
            }
         }
      }

      // Transform STACK_CALL calls to call-prepare, call-execute, call-finalize
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         ListIterator<Statement> stmtIt = block.getStatements().listIterator();
         while(stmtIt.hasNext()) {
            Statement statement = stmtIt.next();
            if(statement instanceof StatementCall) {
               StatementCall call = (StatementCall) statement;
               ProcedureRef procedureRef = call.getProcedure();
               Procedure procedure = getScope().getProcedure(procedureRef);
               if(Procedure.CallingConvension.STACK_CALL.equals(procedure.getCallingConvension())) {
                  stmtIt.remove();
                  stmtIt.add(new StatementCallPrepare(procedureRef, call.getParameters(), call.getSource(), call.getComments()));
                  stmtIt.add(new StatementCallExecute(procedureRef, call.getSource(), call.getComments()));
                  stmtIt.add(new StatementCallFinalize(call.getlValue(), procedureRef, call.getSource(), call.getComments()));
                  getLog().append("Calling convention " + Procedure.CallingConvension.STACK_CALL + " adding prepare/execute/finalize for "+call.toString(getProgram(), false) );
               }
            }
         }
      }

      if(offsetConstants.size() > 0) {
         // Add global STACK_BASE constant
         long STACK_BASE = 0x103L;
         getScope().add(new ConstantVar("STACK_BASE", getScope(), SymbolType.WORD, new ConstantInteger(STACK_BASE, SymbolType.WORD), Scope.SEGMENT_DATA_DEFAULT));

         // Convert ParamValue to ParamStackValue
         ProgramValueIterator.execute(getGraph(), (programValue, currentStmt, stmtIt, currentBlock) -> {
            if(programValue.get() instanceof ParamValue) {
               // Convert ParamValues to calling-convention specific param-value
               ParamValue paramValue = (ParamValue) programValue.get();
               VariableRef parameterRef = paramValue.getParameter();
               SymbolType parameterType = SymbolTypeInference.inferType(getScope(), paramValue.getParameter());
               if(offsetConstants.containsKey(parameterRef)) {
                  ParamStackValue paramStackValue = new ParamStackValue(offsetConstants.get(parameterRef), parameterType);
                  programValue.set(paramStackValue);
                  getLog().append("Calling convention " + Procedure.CallingConvension.STACK_CALL + " replacing " + paramValue.toString(getProgram()) + " with " + paramStackValue.toString(getProgram()));
               }
            }
         });
      }
      return false;
   }

   /**
    * Get the constant variable containing the (byte) index of a parameter on the stack
    *
    * @param procedure The procedure
    * @param procedure The parameter
    * @param programScope The program scope (used for finding/adding the constant).
    * @return The constant variable
    */
   public static ConstantRef getParameterOffsetConstant(Procedure procedure, Variable parameter, ProgramScope programScope) {
      String paramOffsetConstantName = getParameterOffsetConstantName(parameter.getName());
      ConstantVar paramOffsetConstant = procedure.getConstant(paramOffsetConstantName);
      if(paramOffsetConstant == null) {
         // Constant not found - create it
         long paramByteOffset = getParameterByteOffset(procedure, parameter, programScope);
         paramOffsetConstant = new ConstantVar(paramOffsetConstantName, procedure, SymbolType.BYTE, new ConstantInteger(paramByteOffset & 0xff, SymbolType.BYTE), Scope.SEGMENT_DATA_DEFAULT);
         procedure.add(paramOffsetConstant);
      }
      return paramOffsetConstant.getRef();
   }

   /**
    * Get the name of the constant variable containing the (byte) offset of a specific parameter on the stack
    *
    * @param parameterName The name of the struct member
    * @return The name of the constant
    */
   private static String getParameterOffsetConstantName(String parameterName) {
      return "OFFSET_STACK_" + parameterName.toUpperCase();
   }

   /**
    * Get the number of bytes that a parameter is offset on the stack
    *
    * @param parameter The parameter to find offset for
    * @return The byte offset of the start of the member data
    */
   public static long getParameterByteOffset(Procedure procedure, Variable parameter, ProgramScope programScope) {
      long byteOffset = 0;
      for(Variable procedureParameter : procedure.getParameters()) {
         if(parameter.equals(procedureParameter)) {
            break;
         } else {
            // TODO: Consider hos passing a struct should handle inline arrays byteOffset += SymbolTypeStruct.getMemberSizeBytes(parameter.getType(), programScope);
            byteOffset += parameter.getType().getSizeBytes();
         }
      }
      return byteOffset;
   }

}

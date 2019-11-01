package dk.camelot64.kickc.model;

import dk.camelot64.kickc.model.symbols.*;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantRef;

/**
 * Utility methods for {@link dk.camelot64.kickc.model.symbols.Procedure.CallingConvension#STACK_CALL}
 */
public class CallingConventionStack {


   /**
    * Get the constant variable containing the (byte) index of the return value on the stack
    *
    * @param procedure The procedure
    * @return The return value stack offset constant
    */
   public static ConstantRef getReturnOffsetConstant(Procedure procedure) {
      String returnOffsetConstantName = "OFFSET_STACK_RETURN";
      ConstantVar returnOffsetConstant = procedure.getConstant(returnOffsetConstantName);
      if(returnOffsetConstant == null) {
         // Constant not found - create it
         long returnByteOffset = getReturnByteOffset(procedure);
         returnOffsetConstant = new ConstantVar(returnOffsetConstantName, procedure, SymbolType.BYTE, new ConstantInteger(returnByteOffset & 0xff, SymbolType.BYTE), Scope.SEGMENT_DATA_DEFAULT);
         procedure.add(returnOffsetConstant);
      }
      return returnOffsetConstant.getConstantRef();
   }

   /**
    * Get the constant variable containing the (byte) index of a parameter on the stack
    *
    * @param procedure The procedure
    * @param parameter The parameter
    * @return The constant variable
    */
   public static ConstantRef getParameterOffsetConstant(Procedure procedure, SymbolVariable parameter) {
      String paramOffsetConstantName = getParameterOffsetConstantName(parameter.getName());
      ConstantVar paramOffsetConstant = procedure.getConstant(paramOffsetConstantName);
      if(paramOffsetConstant == null) {
         // Constant not found - create it
         long paramByteOffset = getParameterByteOffset(procedure, parameter);
         paramOffsetConstant = new ConstantVar(paramOffsetConstantName, procedure, SymbolType.BYTE, new ConstantInteger(paramByteOffset & 0xff, SymbolType.BYTE), Scope.SEGMENT_DATA_DEFAULT);
         procedure.add(paramOffsetConstant);
      }
      return paramOffsetConstant.getConstantRef();
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
    * Get the number of bytes that needed on the stack to pass parameters/return value to/from a procedure
    *
    * @param procedure The procedure to find the stack frame size for
    * @return The byte size of the stack frame
    */
   public static long getStackFrameByteSize(Procedure procedure) {
      long byteSize = getParametersByteSize(procedure);
      if(procedure.getReturnType() != null) {
         int returnBytes = procedure.getReturnType().getSizeBytes();
         if(returnBytes > byteSize) byteSize = returnBytes;
      }
      return byteSize;
   }

   /**
    * Get the number of bytes needed on the stack to store the parameters from a procedure
    * @param procedure The procedure
    * @return The byte size of parameters
    */
   public static long getParametersByteSize(Procedure procedure) {
      long byteSize = 0;
      for(SymbolVariable procedureParameter : procedure.getParameters()) {
         byteSize += procedureParameter.getType().getSizeBytes();
      }
      return byteSize;
   }

   /**
    * Get the number of bytes that a parameter is offset on the stack
    *
    * @param parameter The parameter to find offset for
    * @return The byte offset of the start of the member data
    */
   public static long getParameterByteOffset(Procedure procedure, SymbolVariable parameter) {
      long byteOffset = 0;
      for(SymbolVariable procedureParameter : procedure.getParameters()) {
         if(parameter.equals(procedureParameter)) {
            break;
         } else {
            // TODO: Consider how passing a struct should handle inline arrays byteOffset += SymbolTypeStruct.getMemberSizeBytes(parameter.getType(), programScope);
            byteOffset += procedureParameter.getType().getSizeBytes();
         }
      }
      return byteOffset;
   }

   /**
    * Get the number of bytes that the return value is offset on the stack
    *
    * @param procedure The procedure
    * @return The byte offset of the return value
    */
   private static long getReturnByteOffset(Procedure procedure) {
      return getStackFrameByteSize(procedure) - procedure.getReturnType().getSizeBytes();
   }

   /**
    * Get he global STACK_BASE constant. Create it if it does not exist.
    *
    * @param programScope The program scope
    * @return The reference to the global constant
    */
   public static ConstantRef getStackBaseConstant(ProgramScope programScope) {
      long STACK_BASE_ADDRESS = 0x103L;
      ConstantVar stackBase = new ConstantVar("STACK_BASE", programScope, SymbolType.WORD, new ConstantInteger(STACK_BASE_ADDRESS, SymbolType.WORD), Scope.SEGMENT_DATA_DEFAULT);
      programScope.add(stackBase);
      return stackBase.getConstantRef();
   }

}

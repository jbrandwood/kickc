package dk.camelot64.kickc.model;

import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeProcedure;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantRef;

import java.util.ArrayList;
import java.util.Collections;

/**
 * Utility methods for {@link Procedure.CallingConvention#STACK_CALL}
 */
public class CallingConventionStack {

   /** Prefix of the constant holding the stack offset for parameters/return value. */
   public static final String OFFSET_STACK = "OFFSET_STACK_";

   /** Name of the constant holding the stack offset for the return value. */
   public static final String OFFSET_STACK_RETURN = OFFSET_STACK + "RETURN_";

   /**
    * Get the name of the constant variable containing the (byte) offset of a specific parameter on the stack
    *
    * @param parameterName The name of the struct member
    * @return The name of the constant
    */
   private static String getParameterOffsetConstantName(String parameterName) {
      return OFFSET_STACK + parameterName.toUpperCase();
   }

   /**
    * Get the constant variable containing the (byte) index of the return value on the stack
    *
    * @param procedureType The procedure type
    * @return The return value stack offset constant
    */
   public static ConstantRef getReturnOffsetConstant(SymbolTypeProcedure procedureType, Scope scope) {
      long returnByteOffset = getReturnByteOffset(procedureType);
      String offsetConstName = OFFSET_STACK_RETURN+returnByteOffset;
      Variable returnOffsetConstant = scope.getLocalConstant(offsetConstName);
      if(returnOffsetConstant == null) {
         // Constant not found - create it
         returnOffsetConstant = Variable.createConstant(offsetConstName, SymbolType.BYTE, scope, new ConstantInteger(returnByteOffset & 0xff, SymbolType.BYTE), Scope.SEGMENT_DATA_DEFAULT);
         scope.add(returnOffsetConstant);
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
   public static ConstantRef getParameterOffsetConstant(Procedure procedure, Variable parameter) {
      String paramOffsetConstantName = getParameterOffsetConstantName(parameter.getName());
      Variable paramOffsetConstant = procedure.getLocalConstant(paramOffsetConstantName);
      if(paramOffsetConstant == null) {
         // Constant not found - create it
         long paramByteOffset = getParameterByteOffset(procedure, parameter);
         paramOffsetConstant = Variable.createConstant(paramOffsetConstantName, SymbolType.BYTE, procedure, new ConstantInteger(paramByteOffset & 0xff, SymbolType.BYTE), Scope.SEGMENT_DATA_DEFAULT);
         procedure.add(paramOffsetConstant);
      }
      return paramOffsetConstant.getConstantRef();
   }

   /**
    * Get the number of bytes that needed on the stack to pass parameters/return value to/from a procedure
    *
    * @param procedureType The procedure type to find the stack frame size for
    * @return The byte size of the stack frame
    */
   public static long getStackFrameByteSize(SymbolTypeProcedure procedureType) {
      long byteSize = getParametersByteSize(procedureType);
      if(procedureType.getReturnType() != null) {
         int returnBytes = procedureType.getReturnType().getSizeBytes();
         if(returnBytes > byteSize) byteSize = returnBytes;
      }
      return byteSize;
   }

   /**
    * Get the number of bytes needed on the stack to store the parameters from a procedure
    *
    * @param procedureType The procedure type
    * @return The byte size of parameters
    */
   public static long getParametersByteSize(SymbolTypeProcedure procedureType) {
      long byteSize = 0;
      for(SymbolType paramType : procedureType.getParamTypes()) {
         byteSize += paramType.getSizeBytes();
      }
      return byteSize;
   }

   /**
    * Get the number of bytes that a parameter is offset on the stack
    *
    * @param parameter The parameter to find offset for
    * @return The byte offset of the start of the member data
    */
   public static long getParameterByteOffset(Procedure procedure, Variable parameter) {
      long byteOffset = 0;
      ArrayList<Variable> parameters = new ArrayList<>(procedure.getParameters());
      // Reverse because pushing is done in parameter order
      Collections.reverse(parameters);
      for(Variable procedureParameter : parameters) {
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
    * @param procedureType The procedure type
    * @return The byte offset of the return value
    */
   private static long getReturnByteOffset(SymbolTypeProcedure procedureType) {
      return getStackFrameByteSize(procedureType) - procedureType.getReturnType().getSizeBytes();
   }

   /**
    * Get he global STACK_BASE constant. Create it if it does not exist.
    *
    * @param programScope The program scope
    * @return The reference to the global constant
    */
   public static ConstantRef getStackBaseConstant(ProgramScope programScope) {
      long STACK_BASE_ADDRESS = 0x103L;
      Variable stackBase = Variable.createConstant("STACK_BASE", SymbolType.WORD, programScope, new ConstantInteger(STACK_BASE_ADDRESS, SymbolType.WORD), Scope.SEGMENT_DATA_DEFAULT);
      stackBase.setExport(true);
      programScope.add(stackBase);
      return stackBase.getConstantRef();
   }

}

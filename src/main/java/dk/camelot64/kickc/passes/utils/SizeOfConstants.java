package dk.camelot64.kickc.passes.utils;

import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.symbols.StructDefinition;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantRef;

import java.util.Locale;

/** Handler for SIZEOF and OFFSET constants. */
public class SizeOfConstants {
   /**
    * Get the constant variable containing the size of a specific type
    *
    * @param programScope The program scope (used for finding/adding the constant).
    * @param type The type to get the variable for
    * @return The constant variable
    */
   public static ConstantRef getSizeOfConstantVar(ProgramScope programScope, SymbolType type) {
      String typeConstName = getSizeofConstantName(type);
      Variable typeSizeConstant = programScope.getLocalConstant(typeConstName);
      if(typeSizeConstant == null) {
         // Constant not found - create it
         long typeSize = type.getSizeBytes();
         typeSizeConstant = Variable.createConstant(typeConstName, SymbolType.BYTE, programScope, null, new ConstantInteger(typeSize&0xff, SymbolType.BYTE), Scope.SEGMENT_DATA_DEFAULT);
         programScope.add(typeSizeConstant);
      }
      return typeSizeConstant.getConstantRef();
   }

   /**
    * Fix the size value of the constant variable if needed.
    * Sizes for structs and other complex types is not known until late in Pass1, so they may need fixing.
    * @param programScope The program scope (used for finding/adding the constant).
    * @param type The type to get the variable for
    */
   public static void fixSizeOfConstantVar(ProgramScope programScope, SymbolType type) {
      String typeConstName = getSizeofConstantName(type);
      Variable typeSizeConstant = programScope.getLocalConstant(typeConstName);
      if(typeSizeConstant != null) {
         // Constant found - update it
         long typeSize = type.getSizeBytes();
         typeSizeConstant.setInitValue(new ConstantInteger(typeSize&0xff, SymbolType.BYTE));
      }
   }

   /**
    * Get the name of the constant variable containing the size of a specific type
    *
    * @param type The type to get the variable for
    * @return The name of the constant
    */
   public static String getSizeofConstantName(SymbolType type) {
      if(type instanceof SymbolTypePointer) {
         return "SIZEOF_POINTER";
      } else {
         return "SIZEOF_" + type.getTypeName().toUpperCase(Locale.ENGLISH).replace(" ", "_");
      }
   }

   /**
    * Get the constant variable containing the (byte) index of a specific member
    *
    * @param programScope The program scope (used for finding/adding the constant).
    * @param structDefinition The struct
    * @param memberName The name of the struct member
    * @return The constant variable
    */
   public static ConstantRef getStructMemberOffsetConstant(ProgramScope programScope, StructDefinition structDefinition, String memberName) {
      String typeConstName = getStructMemberOffsetConstantName(structDefinition, memberName);
      Variable memberOffsetConstant = programScope.getLocalConstant(typeConstName);
      if(memberOffsetConstant == null) {
         // Constant not found - create it
         Variable memberDef = structDefinition.getMember(memberName);
         long memberByteOffset = structDefinition.getMemberByteOffset(memberDef, programScope);
         memberOffsetConstant = Variable.createConstant(typeConstName, SymbolType.BYTE, programScope, null, new ConstantInteger(memberByteOffset & 0xff, SymbolType.BYTE), Scope.SEGMENT_DATA_DEFAULT);
         programScope.add(memberOffsetConstant);
      }
      return memberOffsetConstant.getConstantRef();
   }

   /**
    * Get the name of the constant variable containing the (byte) index of a specific member in a struct
    *
    * @param structDefinition The struct
    * @param memberName The name of the struct member
    * @return The name of the constant
    */
   private static String getStructMemberOffsetConstantName(StructDefinition structDefinition, String memberName) {
      return "OFFSET_" + structDefinition.getType().getTypeName().toUpperCase(Locale.ENGLISH).replace(" ", "_") + "_" + memberName.toUpperCase();
   }
}

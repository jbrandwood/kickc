package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeNamed;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.types.SymbolTypeProcedure;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;
import dk.camelot64.kickc.model.values.ConstantRef;

import java.util.Locale;

/**
 * TypeId operator typeid(expr) returns byte value representing the type of the expression.
 * Will be resolved into a constant as soon as the expression has been resolved enough.
 */
public class OperatorTypeId extends OperatorUnary {

   public OperatorTypeId(int precedence) {
      super("typeid ", "_typeid_", precedence);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral operand, ProgramScope scope) {
      SymbolType type = operand.getType(scope);
      return new ConstantInteger((long) getTypeId(type));
   }

   @Override
   public SymbolType inferType(SymbolType operandType) {
      return SymbolType.BYTE;
   }

   /**
    * Get the constant variable containing the type ID of a specific type
    *
    * @param programScope The program scope (used for finding/adding the constant).
    * @param type The type to get the variable for
    * @return The constant variable
    */
   public static ConstantRef getTypeIdConstantVar(ProgramScope programScope, SymbolType type) {
      String typeConstName = "TYPEID_" + getTypeIdConstantName(type);
      Variable typeIdConstant = programScope.getConstant(typeConstName);
      if(typeIdConstant == null) {
         // Constant not found - create it
         long typeSize = getTypeId(type);
         typeIdConstant = new Variable(typeConstName, programScope, SymbolType.BYTE, null, Scope.SEGMENT_DATA_DEFAULT, new ConstantInteger(typeSize));
         programScope.add(typeIdConstant);
      }
      return typeIdConstant.getConstantRef();
   }

   /**
    * Get the name of the constant variable containing the type id of a specific type
    *
    * @param type The type to get the variable for
    * @return The name of the constant
    */
   private static String getTypeIdConstantName(SymbolType type) {
      if(type instanceof SymbolTypeProcedure) {
         return "PROCEDURE";
      } else if(type instanceof SymbolTypePointer) {
         return "POINTER_" + getTypeIdConstantName(((SymbolTypePointer) type).getElementType());
      } else {
         return type.getTypeName().toUpperCase(Locale.ENGLISH).replace(" ", "_");
      }
   }

   /**
    * Get the type ID of a type.
    * <p>
    * Simple Types:
    * - void : 0
    * - unsigned byte: 1
    * - signed byte: 2
    * - unsigned word: 3
    * - signed word: 4
    * - unsigned dword: 5
    * - signed dword: 6
    * - bool: 7
    * - procedure: 0xf
    * <p>
    * Pointers:
    * - 0x10 + type ID of pointed to sub-type
    * - Arrays? Strings?
    *
    * @param type The type
    * @return The ID
    */
   public static int getTypeId(SymbolType type) {
      if(SymbolTypeNamed.VOID.equals(type)) {
         return 0;
      } else if(SymbolTypeNamed.BYTE.equals(type)) {
         return 1;
      } else if(SymbolTypeNamed.SBYTE.equals(type)) {
         return 2;
      } else if(SymbolTypeNamed.WORD.equals(type)) {
         return 3;
      } else if(SymbolTypeNamed.SWORD.equals(type)) {
         return 4;
      } else if(SymbolTypeNamed.DWORD.equals(type)) {
         return 5;
      } else if(SymbolTypeNamed.SDWORD.equals(type)) {
         return 6;
      } else if(SymbolTypeNamed.BOOLEAN.equals(type)) {
         return 7;
      } else if(type instanceof SymbolTypeProcedure) {
         return 0x0f;
      } else if(type instanceof SymbolTypePointer) {
         return 0x10 + getTypeId(((SymbolTypePointer) type).getElementType());
      } else {
         return 0;
      }
   }

}

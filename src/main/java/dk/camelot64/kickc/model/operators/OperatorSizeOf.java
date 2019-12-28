package dk.camelot64.kickc.model.operators;

import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;
import dk.camelot64.kickc.model.values.ConstantRef;

import java.util.Locale;

/** SizeOf operator sizeof(expr). Will be resolved into a constant as soon as the expression has been resolved enough. */
public class OperatorSizeOf extends OperatorUnary {

   public OperatorSizeOf(int precedence) {
      super("sizeof ", "_sizeof_", precedence);
   }

   @Override
   public ConstantLiteral calculateLiteral(ConstantLiteral operand, ProgramScope scope) {
      SymbolType type = operand.getType(scope);
      return new ConstantInteger((long) type.getSizeBytes());
   }

   @Override
   public SymbolType inferType(SymbolType operandType) {
      return SymbolType.BYTE;
   }

   /**
    * Get the constant variable containing the size of a specific type
    *
    * @param programScope The program scope (used for finding/adding the constant).
    * @param type The type to get the variable for
    * @return The constant variable
    */
   public static ConstantRef getSizeOfConstantVar(ProgramScope programScope, SymbolType type) {
      String typeConstName = getSizeofConstantName(type);
      Variable typeSizeConstant = programScope.getConstant(typeConstName);
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
      Variable typeSizeConstant = programScope.getConstant(typeConstName);
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

}

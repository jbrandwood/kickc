package dk.camelot64.kickc.model.types;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.InternalError;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;
import dk.camelot64.kickc.model.values.ConstantValue;
import dk.camelot64.kickc.model.values.RValue;

/**
 * Rules for converting integer types.
 * <p>
 * Integer conversion implements C99 6.3.1.8 http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1570.pdf#page=70
 * <p>
 * The special number type is converted as described here https://gitlab.com/camelot/kickc/issues/181
 */
public class SymbolTypeConversion {

   /**
    * Find the integer type that results from a binary operator according to C99 6.3.1.8
    * http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1570.pdf#page=70
    *
    * @param type1 Left type in a binary expression
    * @param type2 Right type in a binary expression
    * @return The type resulting from a binary operator performed on the two parameters
    */
   public static SymbolType convertedMathType(SymbolTypeInteger type1, SymbolTypeInteger type2) {
      // If any of the two types are unresolved - return an unresolved result
      if(SymbolType.NUMBER.equals(type1) || SymbolType.NUMBER.equals(type2)) {
         return SymbolType.NUMBER;
      }
      SymbolTypeIntegerFixed fixed1 = (SymbolTypeIntegerFixed) type1;
      SymbolTypeIntegerFixed fixed2 = (SymbolTypeIntegerFixed) type2;
      // C99 6.3.1.8 a. If two operands have the same type no conversion is performed
      if(type1.equals(type2))
         return type1;
      // C99 6.3.1.8 b. If both are signed or both are unsigned then the smallest type is converted to the size of the large type (byte->word->sword, sbyte->sword->sdword)
      if(fixed1.isSigned() == fixed2.isSigned())
         return (fixed1.getBits() > fixed2.getBits()) ? fixed1 : fixed2;
      // C99 6.3.1.8 c. One is signed and one unsigned.
      // If the signed type can contain all values of the unsigned type then the unsigned value is converted to the signed type. (byte->sword, byte->sdword, word->sdword).
      SymbolTypeIntegerFixed typeS, typeU;
      if(fixed1.isSigned()) {
         typeS = fixed1;
         typeU = fixed2;
      } else {
         typeS = fixed2;
         typeU = fixed1;
      }
      if(typeS.getBits() > typeU.getBits())
         return typeS;
      // C99 6.3.1.8 d. The unsigned type is the same size as or larger than the signed type.
      // The signed value is first converted to the size of the unsigned type and then converted to unsigned changing the sign and the value
      // (sbyte->byte, sbyte->word, sbyte->dword, sword->word, sword->dword, sdword->dword).
      return typeU;
   }

   /**
    * Find the integer type that a number operand in a binary operator should be converted/cast to according to number type conversion https://gitlab.com/camelot/kickc/issues/181
    *
    * @param left The left value
    * @param right The right value
    * @param symbols The program scope symbols (used for looking up symbols and constants)
    * @param currentStmt The current statement (used only for exception context)
    * @return a non-null fixed integer type if a number type conversion is relevant.
    */
   public static SymbolType getNumberCastType(RValue left, RValue right, ProgramScope symbols, Statement currentStmt) {

      SymbolType leftType = SymbolTypeInference.inferType(symbols, left);
      SymbolType rightType = SymbolTypeInference.inferType(symbols, right);

      if(SymbolType.NUMBER.equals(leftType) || SymbolType.NUMBER.equals(rightType)) {
         // A special type number is assigned to integer constants without a postfix literal.
         // Numbers are flexible and will take a type based on their actual value when they meet a typed number in a calculation.
         // Number types are only usable at compile time.

         if(leftType.equals(rightType)) {
            // a) If the two operands are numbers the result is a number
            return null;
         }

         // Treat pointers like WORD
         if(leftType instanceof SymbolTypePointer) leftType = SymbolType.WORD;
         if(rightType instanceof SymbolTypePointer) rightType = SymbolType.WORD;

         RValue numberVal;
         SymbolTypeIntegerFixed fixedType;
         if(SymbolType.NUMBER.equals(leftType) && SymbolType.isInteger(rightType)) {
            // Left is the number type - right is the fixed type
            numberVal = left;
            fixedType = (SymbolTypeIntegerFixed) rightType;
         } else if(SymbolType.NUMBER.equals(rightType) && SymbolType.isInteger(leftType)) {
            // Right is the number type - left is the fixed type
            numberVal = right;
            fixedType = (SymbolTypeIntegerFixed) leftType;
         } else if(SymbolType.NUMBER.equals(leftType) && rightType instanceof SymbolTypePointer) {
            // Left is the number type - right is a pointer (effectively unsigned word)
            numberVal = left;
            fixedType = SymbolType.WORD;
         } else if(SymbolType.NUMBER.equals(rightType) && leftType instanceof SymbolTypePointer) {
            // Right is the number type - left is a pointer (effectively unsigned word)
            numberVal = right;
            fixedType = SymbolType.WORD;
         } else {
            // Binary operator combining number and non-integer
            return null;
         }

         if(numberVal instanceof ConstantValue) {
            ConstantLiteral constantLiteral = ((ConstantValue) numberVal).calculateLiteral(symbols);
            if(constantLiteral instanceof ConstantInteger) {
               ConstantInteger constantInteger = (ConstantInteger) constantLiteral;
               if(SymbolType.NUMBER.equals(constantInteger.getType())) {
                  Long value = constantInteger.getValue();
                  if(fixedType.isSigned()) {
                     // b) If one operand is a signed type and the other a number they are both converted to the smallest signed type that can hold the values.
                     SymbolTypeIntegerFixed smallestSignedType = SymbolTypeIntegerFixed.getSmallestSigned(value);
                     if(smallestSignedType == null) {
                        throw new CompileError("Number constant has value that cannot be represented by a signed type " + value, currentStmt);
                     }
                     return smallestSignedType.getBits() > fixedType.getBits() ? smallestSignedType : fixedType;
                  } else {
                     // c) If one operand is an unsigned type and the other a number they are both converted to the smallest unsigned type that can hold the values.
                     //    If the number value is negative it is converted to unsigned using two's complement.
                     SymbolTypeIntegerFixed smallestUnsignedType;
                     if(value < 0) {
                        smallestUnsignedType = SymbolTypeIntegerFixed.getSmallestUnsigned(-value);
                     } else {
                        smallestUnsignedType = SymbolTypeIntegerFixed.getSmallestUnsigned(value);
                     }
                     return smallestUnsignedType;
                     //return smallestUnsignedType.getBits() > fixedType.getBits() ? smallestUnsignedType : fixedType;
                  }
               } else {
                  throw new InternalError("Non-number constant has type number " + right.toString(), currentStmt);
               }
            }
         } else {
            // Postpone til later!
            return null;
         }
      }
      // No number conversion
      return null;
   }
}

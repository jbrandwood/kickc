package dk.camelot64.kickc.model.types;

import dk.camelot64.kickc.model.CompileError;

import java.util.ArrayList;
import java.util.Collection;

/** Symbol Types */
public interface SymbolType {

   /** Unsigned byte (8 bits)). */
   SymbolTypeIntegerFixed BYTE = new SymbolTypeIntegerFixed("byte", 0, 255, false, 8);
   /** Signed byte (8 bits). */
   SymbolTypeIntegerFixed SBYTE = new SymbolTypeIntegerFixed("signed byte", -128, 127, true, 8);
   /** Unsigned word (2 bytes, 16 bits). */
   SymbolTypeIntegerFixed WORD = new SymbolTypeIntegerFixed("word", 0, 65_535, false, 16);
   /** Signed word (2 bytes, 16 bits). */
   SymbolTypeIntegerFixed SWORD = new SymbolTypeIntegerFixed("signed word", -32_768, 32_767, true, 16);
   /** Unsigned double word (4 bytes, 32 bits). */
   SymbolTypeIntegerFixed DWORD = new SymbolTypeIntegerFixed("dword", 0, 4_294_967_296L, false, 32);
   /** Signed double word (4 bytes, 32 bits). */
   SymbolTypeIntegerFixed SDWORD = new SymbolTypeIntegerFixed("signed dword", -2_147_483_648, 2_147_483_647, true, 32);
   /** Integer with unknown size (used for constant expressions). */
   SymbolTypeIntegerAuto NUMBER = new SymbolTypeIntegerAuto("number");
   /** String value (treated like byte* ). */
   SymbolTypeNamed STRING = new SymbolTypeNamed("string", 99);
   /** Boolean value. */
   SymbolTypeNamed BOOLEAN = new SymbolTypeNamed("bool", 1);
   /** Numeric floating point value. */
   SymbolTypeNamed DOUBLE = new SymbolTypeNamed("double", 1);
   /** A label. Name of functions of jump-targets. */
   SymbolTypeNamed LABEL = new SymbolTypeNamed("label", 1);
   /** Void type representing no value. */
   SymbolTypeNamed VOID = new SymbolTypeNamed("void", 0);
   /** An unresolved type. Will be infered later. */
   SymbolTypeNamed VAR = new SymbolTypeNamed("var", -1);

   /**
    * Get a simple symbol type from the type name.
    *
    * @param name The type name.
    * @return The simple symbol type
    */
   static SymbolType get(String name) {
      switch(name) {
         case "byte":
            return BYTE;
         case "unsigned byte":
            return BYTE;
         case "signed byte":
            return SBYTE;
         case "char":
            return SBYTE;
         case "unsigned char":
            return BYTE;
         case "signed char":
            return SBYTE;
         case "word":
            return WORD;
         case "unsigned word":
            return WORD;
         case "signed word":
            return SWORD;
         case "short":
            return SWORD;
         case "unsigned short":
            return WORD;
         case "signed short":
            return SWORD;
         case "int":
            return SWORD;
         case "unsigned int":
            return WORD;
         case "signed int":
            return SWORD;
         case "dword":
            return DWORD;
         case "unsigned dword":
            return DWORD;
         case "signed dword":
            return SDWORD;
         case "long":
            return SDWORD;
         case "unsigned long":
            return DWORD;
         case "signed long":
            return SDWORD;
         case "string":
            return STRING;
         case "bool":
            return BOOLEAN;
         case "void":
            return VOID;
      }
      return null;
   }


   /**
    * Get the name of the type
    *
    * @return The type name
    */
   String getTypeName();

   /**
    * Get the size of the type (in bytes).
    * @return The size
    */
   int getSizeBytes();

   /**
    * Is the type {@link #BYTE} or compatible {@link SymbolTypeMulti}
    *
    * @param type The type to examine
    * @return true if the type is BYTE compatible
    */
   static boolean isByte(SymbolType type) {
      if(BYTE.equals(type)) {
         return true;
      } else if(type instanceof SymbolTypeMulti) {
         return ((SymbolTypeMulti) type).isByte();
      } else {
         return false;
      }
   }

   /**
    * Is the type {@link #SBYTE} or compatible {@link SymbolTypeMulti}
    *
    * @param type The type to examine
    * @return true if the type is SBYTE compatible
    */
   static boolean isSByte(SymbolType type) {
      if(SBYTE.equals(type)) {
         return true;
      } else if(type instanceof SymbolTypeMulti) {
         return ((SymbolTypeMulti) type).isSByte();
      } else {
         return false;
      }
   }

   /**
    * Is the type {@link #WORD} or compatible {@link SymbolTypeMulti}
    *
    * @param type The type to examine
    * @return true if the type is WORD compatible
    */
   static boolean isWord(SymbolType type) {
      if(WORD.equals(type)) {
         return true;
      } else if(type instanceof SymbolTypeMulti) {
         return ((SymbolTypeMulti) type).isWord();
      } else {
         return false;
      }
   }

   /**
    * Is the type {@link #SWORD} or compatible {@link SymbolTypeMulti}
    *
    * @param type The type to examine
    * @return true if the type is SWORD compatible
    */
   static boolean isSWord(SymbolType type) {
      if(SWORD.equals(type)) {
         return true;
      } else if(type instanceof SymbolTypeMulti) {
         return ((SymbolTypeMulti) type).isSWord();
      } else {
         return false;
      }
   }

   /**
    * Is the type {@link #DWORD} or compatible {@link SymbolTypeMulti}
    *
    * @param type The type to examine
    * @return true if the type is DWORD compatible
    */
   static boolean isDWord(SymbolType type) {
      if(DWORD.equals(type)) {
         return true;
      } else if(type instanceof SymbolTypeMulti) {
         return ((SymbolTypeMulti) type).isDWord();
      } else {
         return false;
      }
   }

   /**
    * Is the type {@link #SDWORD} or compatible {@link SymbolTypeMulti}
    *
    * @param type The type to examine
    * @return true if the type is SDWORD compatible
    */
   static boolean isSDWord(SymbolType type) {
      if(SDWORD.equals(type)) {
         return true;
      } else if(type instanceof SymbolTypeMulti) {
         return ((SymbolTypeMulti) type).isSWord();
      } else {
         return false;
      }
   }

   /**
    * Is the type an integer type (including {@link #NUMBER})
    *
    * @param type The type to examine
    * @return true if the type is integer
    */
   static boolean isInteger(SymbolType type) {
      return SDWORD.equals(type) || DWORD.equals(type) || SWORD.equals(type) || WORD.equals(type) || SBYTE.equals(type) || BYTE.equals(type) || NUMBER.equals(type);
   }

   /**
    * Get all integer types.
    *
    * @return All integeer types
    */
   static Collection<SymbolTypeIntegerFixed> getIntegerFixedTypes() {
      ArrayList<SymbolTypeIntegerFixed> types = new ArrayList<>();
      types.add(BYTE);
      types.add(SBYTE);
      types.add(WORD);
      types.add(SWORD);
      types.add(DWORD);
      types.add(SDWORD);
      return types;
   }

   /**
    * Find the integer type that results from a binary operator according to C99 6.3.1.8
    * http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1570.pdf#page=70
    *
    * @param type1 Left type in a binary expression
    * @param type2 Right type in a binary expression
    * @return The type resulting from a binary operator performed on the two parameters
    */
   static SymbolType convertedMathType(SymbolTypeInteger type1, SymbolTypeInteger type2) {
      if(SymbolType.NUMBER.equals(type1) || SymbolType.NUMBER.equals(type2)) {
         return NUMBER;
      }
      SymbolTypeIntegerFixed fixed1 = (SymbolTypeIntegerFixed) type1;
      SymbolTypeIntegerFixed fixed2 = (SymbolTypeIntegerFixed) type2;
      // C99 6.3.1.8 a. If two operands have the same type no conversion is performed
      if(type1.equals(type2))
         return type1;
      // C99 6.3.1.8 b. If both are signed or both are unsigned then the smallest type is converted to the size of the large type (byte->word->sword, sbyte->sword->sdword)
      if(fixed1.isSigned()==fixed2.isSigned())
         return (fixed1.getBits()>fixed2.getBits()) ? fixed1 : fixed2;
      // C99 6.3.1.8 c. One is signed and one unsigned.
      // If the signed type can contain all values of the unsigned type then the unsigned value is converted to the signed type. (byte->sword, byte->sdword, word->sdword).
      SymbolTypeIntegerFixed typeS, typeU;
      if(fixed1.isSigned()) {
         typeS = fixed1;
         typeU = fixed2;
      }  else {
         typeS = fixed2;
         typeU = fixed1;
      }
      if(typeS.getBits()>typeU.getBits())
         return typeS;
      // C99 6.3.1.8 d. The unsigned type is the same size as or larger than the signed type.
      // The signed value is first converted to the size of the unsigned type and then converted to unsigned changing the sign and the value
      // (sbyte->byte, sbyte->word, sbyte->dword, sword->word, sword->dword, sdword->dword).
      return typeU;
   }

   /**
    * Find the unsigned integer type that contains both sub-types usable for binary operations ( & | ^ ).
    *
    * @param type1 Left type in a binary expression
    * @param type2 Right type in a binary expression
    * @return
    */
   static SymbolType promotedBitwiseType(SymbolTypeIntegerFixed type1, SymbolTypeIntegerFixed type2) {
      for(SymbolTypeIntegerFixed candidate : getIntegerFixedTypes()) {
         if(!candidate.isSigned() && type1.getBits()<=candidate.getBits() && type2.getBits()<=candidate.getBits()) {
            return candidate;
         }
      }
      throw new CompileError("Cannot promote to a common type for "+type1.toString()+" and "+type2.toString());
   }

}

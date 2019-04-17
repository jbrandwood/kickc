package dk.camelot64.kickc.model.types;

import dk.camelot64.kickc.model.CompileError;

import java.util.ArrayList;
import java.util.Collection;

/** Symbol Types */
public interface SymbolType {

   /** Unsigned byte (8 bits)). */
   SymbolTypeInteger BYTE = new SymbolTypeInteger("byte", 0, 255, false, 8);
   /** Signed byte (8 bits). */
   SymbolTypeInteger SBYTE = new SymbolTypeInteger("signed byte", -128, 127, true, 8);
   /** Unsigned word (2 bytes, 16 bits). */
   SymbolTypeInteger WORD = new SymbolTypeInteger("word", 0, 65_535, false, 16);
   /** Signed word (2 bytes, 16 bits). */
   SymbolTypeInteger SWORD = new SymbolTypeInteger("signed word", -32_768, 32_767, true, 16);
   /** Unsigned double word (4 bytes, 32 bits). */
   SymbolTypeInteger DWORD = new SymbolTypeInteger("dword", 0, 4_294_967_296L, false, 32);
   /** Signed double word (4 bytes, 32 bits). */
   SymbolTypeInteger SDWORD = new SymbolTypeInteger("signed dword", -2_147_483_648, 2_147_483_647, true, 32);
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
    * Is the type an integer type or compatible {@link SymbolTypeMulti}
    *
    * @param type The type to examine
    * @return true if the type is integer
    */
   static boolean isInteger(SymbolType type) {
      return isSDWord(type) || isDWord(type) || isSWord(type) || isWord(type) || isSByte(type) || isByte(type);
   }

   /**
    * Get all integer types.
    *
    * @return All integeer types
    */
   static Collection<SymbolTypeInteger> getIntegerTypes() {
      ArrayList<SymbolTypeInteger> types = new ArrayList<>();
      types.add(BYTE);
      types.add(SBYTE);
      types.add(WORD);
      types.add(SWORD);
      types.add(DWORD);
      types.add(SDWORD);
      return types;
   }

   /**
    * Find the smallest integer type that contains both sub-types usable for math ( + - * / ).
    *
    * @param type1 Left type in a binary expression
    * @param type2 Right type in a binary expression
    * @return
    */
   static SymbolType promotedMathType(SymbolTypeInteger type1, SymbolTypeInteger type2) {
      for(SymbolTypeInteger candidate : getIntegerTypes()) {
         boolean match1 = type1.getMinValue() >= candidate.getMinValue() && type1.getMaxValue() <= candidate.getMaxValue();
         boolean match2 = type2.getMinValue() >= candidate.getMinValue() && type2.getMaxValue() <= candidate.getMaxValue();
         if(match1 && match2) {
            return candidate;
         }
      }
      throw new NoMatchingType("Cannot promote to a common type for "+type1.toString()+" and "+type2.toString());
   }

   /**
    * Find the unsigned integer type that contains both sub-types usable for binary operations ( & | ^ ).
    *
    * @param type1 Left type in a binary expression
    * @param type2 Right type in a binary expression
    * @return
    */
   static SymbolType promotedBitwiseType(SymbolTypeInteger type1, SymbolTypeInteger type2) {
      for(SymbolTypeInteger candidate : getIntegerTypes()) {
         if(!candidate.isSigned() && type1.getBits()<=candidate.getBits() && type2.getBits()<=candidate.getBits()) {
            return candidate;
         }
      }
      throw new CompileError("Cannot promote to a common type for "+type1.toString()+" and "+type2.toString());
   }

}

package dk.camelot64.kickc.model;

import java.util.ArrayList;
import java.util.Collection;

/** Symbol Types */
public interface SymbolType {

   /** Unsigned byte (8 bits)). */
   SymbolTypeInteger BYTE = new SymbolTypeInteger("byte", 0, 255);
   /** Signed byte (8 bits). */
   SymbolTypeInteger SBYTE = new SymbolTypeInteger("signed byte", -128, 127);
   /** Unsigned word (2 bytes, 16 bits). */
   SymbolTypeInteger WORD = new SymbolTypeInteger("word", 0, 65_535);
   /** Signed word (2 bytes, 16 bits). */
   SymbolTypeInteger SWORD = new SymbolTypeInteger("signed word", -32_768, 32_767);
   /** Unsigned double word (4 bytes, 32 bits). */
   SymbolTypeInteger DWORD = new SymbolTypeInteger("dword", 0, 4_294_967_296L);
   /** Signed double word (4 bytes, 32 bits). */
   SymbolTypeInteger SDWORD = new SymbolTypeInteger("signed dword", -2_147_483_648, 2_147_483_647);
   /** String value (treated like byte* ). */
   SymbolTypeBasic STRING = new SymbolTypeBasic("string");
   /** Boolean value. */
   SymbolTypeBasic BOOLEAN = new SymbolTypeBasic("boolean");
   /** Numeric floating point value. */
   SymbolTypeBasic DOUBLE = new SymbolTypeBasic("double");
   /** A label. Name of functions of jump-targets. */
   SymbolTypeBasic LABEL = new SymbolTypeBasic("label");
   /** Void type representing no value. */
   SymbolTypeBasic VOID = new SymbolTypeBasic("void");
   /** An unresolved type. Will be infered later. */
   SymbolTypeBasic VAR = new SymbolTypeBasic("var");

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
         case "signed byte":
            return SBYTE;
         case "word":
            return WORD;
         case "signed word":
            return SWORD;
         case "dword":
            return DWORD;
         case "signed dword":
            return SDWORD;
         case "string":
            return STRING;
         case "boolean":
            return BOOLEAN;
         case "void":
            return VOID;
      }
      return null;
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
    * Is the type {@link #BYTE} or compatible {@link SymbolTypeInline}
    *
    * @param type The type to examine
    * @return true if the type is BYTE compatible
    */
   static boolean isByte(SymbolType type) {
      if(BYTE.equals(type)) {
         return true;
      } else if(type instanceof SymbolTypeInline) {
         return ((SymbolTypeInline) type).isByte();
      } else {
         return false;
      }
   }

   /**
    * Is the type {@link #SBYTE} or compatible {@link SymbolTypeInline}
    *
    * @param type The type to examine
    * @return true if the type is SBYTE compatible
    */
   static boolean isSByte(SymbolType type) {
      if(SBYTE.equals(type)) {
         return true;
      } else if(type instanceof SymbolTypeInline) {
         return ((SymbolTypeInline) type).isSByte();
      } else {
         return false;
      }
   }

   /**
    * Is the type {@link #WORD} or compatible {@link SymbolTypeInline}
    *
    * @param type The type to examine
    * @return true if the type is WORD compatible
    */
   static boolean isWord(SymbolType type) {
      if(WORD.equals(type)) {
         return true;
      } else if(type instanceof SymbolTypeInline) {
         return ((SymbolTypeInline) type).isWord();
      } else {
         return false;
      }
   }

   /**
    * Is the type {@link #SWORD} or compatible {@link SymbolTypeInline}
    *
    * @param type The type to examine
    * @return true if the type is SWORD compatible
    */
   static boolean isSWord(SymbolType type) {
      if(SWORD.equals(type)) {
         return true;
      } else if(type instanceof SymbolTypeInline) {
         return ((SymbolTypeInline) type).isSWord();
      } else {
         return false;
      }
   }

   /**
    * Is the type {@link #DWORD} or compatible {@link SymbolTypeInline}
    *
    * @param type The type to examine
    * @return true if the type is DWORD compatible
    */
   static boolean isDWord(SymbolType type) {
      if(DWORD.equals(type)) {
         return true;
      } else if(type instanceof SymbolTypeInline) {
         return ((SymbolTypeInline) type).isDWord();
      } else {
         return false;
      }
   }

   /**
    * Is the type {@link #SDWORD} or compatible {@link SymbolTypeInline}
    *
    * @param type The type to examine
    * @return true if the type is SDWORD compatible
    */
   static boolean isSDWord(SymbolType type) {
      if(SDWORD.equals(type)) {
         return true;
      } else if(type instanceof SymbolTypeInline) {
         return ((SymbolTypeInline) type).isSWord();
      } else {
         return false;
      }
   }

   /**
    * Get the name of the type
    *
    * @return The type name
    */
   String getTypeName();

}

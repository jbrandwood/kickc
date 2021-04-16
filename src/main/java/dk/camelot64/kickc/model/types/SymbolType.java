package dk.camelot64.kickc.model.types;

import java.io.Serializable;

/** Symbol Types */
public interface SymbolType extends Serializable {

   /** Specifies that the value of the variable may change at any time, so the optimizer must not make assumptions. The variable must always live in memory to be available for any multi-threaded access (eg. in interrupts). (volatile keyword) */
   boolean isVolatile();

   /** Specifies that the variable is not allowed to be modified (const keyword). The compiler should try to detect modifications and generate compile-time errors if they occur.*/
   boolean isNomodify();

   /** Unsigned byte (8 bits)). */
   SymbolTypeIntegerFixed BYTE = new SymbolTypeIntegerFixed("byte", 0, 255, false, 8, false, false);
   /** Signed byte (8 bits). */
   SymbolTypeIntegerFixed SBYTE = new SymbolTypeIntegerFixed("signed byte", -128, 127, true, 8, false, false);
   /** Unsigned word (2 bytes, 16 bits). */
   SymbolTypeIntegerFixed WORD = new SymbolTypeIntegerFixed("word", 0, 65_535, false, 16, false, false);
   /** Signed word (2 bytes, 16 bits). */
   SymbolTypeIntegerFixed SWORD = new SymbolTypeIntegerFixed("signed word", -32_768, 32_767, true, 16, false, false);
   /** Unsigned double word (4 bytes, 32 bits). */
   SymbolTypeIntegerFixed DWORD = new SymbolTypeIntegerFixed("dword", 0, 4_294_967_296L, false, 32, false, false);
   /** Signed double word (4 bytes, 32 bits). */
   SymbolTypeIntegerFixed SDWORD = new SymbolTypeIntegerFixed("signed dword", -2_147_483_648, 2_147_483_647, true, 32, false, false);
   /** Integer with unknown size and unknown signedness (used for constant expressions). */
   SymbolTypeIntegerAuto NUMBER = new SymbolTypeIntegerAuto("number");
   /** Unsigned integer with unknown size (used for constant expressions). */
   SymbolTypeIntegerAuto UNUMBER = new SymbolTypeIntegerAuto("unumber");
   /** Signed integer with unknown size (used for constant expressions). */
   SymbolTypeIntegerAuto SNUMBER = new SymbolTypeIntegerAuto("snumber");
   /** Boolean value. */
   SymbolTypeNamed BOOLEAN = new SymbolTypeNamed("bool", 1, false, false);
   /** Numeric floating point value. */
   SymbolTypeNamed DOUBLE = new SymbolTypeNamed("double", 1, false, false);
   /** A label. Name of functions of jump-targets. */
   SymbolTypeNamed LABEL = new SymbolTypeNamed("label", 1, false, false);
   /** Void type representing no value. */
   SymbolTypeNamed VOID = new SymbolTypeNamed("void", 0, false, false);
   /** An unresolved type. Will be infered later. */
   SymbolTypeNamed VAR = new SymbolTypeNamed("var", -1, false, false);

   /**
    * Get a simple symbol type from the type name.
    *
    * @param name The type name.
    * @return The simple symbol type
    */
   static SymbolType get(String name) {
      switch(name) {
         case "byte":
         case "unsigned byte":
         case "char":
         case "unsigned char":
            return BYTE;
         case "signed byte":
         case "signed char":
            return SBYTE;
         case "word":
         case "unsigned word":
         case "unsigned short":
         case "unsigned int":
            return WORD;
         case "signed word":
         case "short":
         case "signed short":
         case "int":
         case "signed int":
            return SWORD;
         case "dword":
         case "unsigned dword":
         case "unsigned long":
            return DWORD;
         case "signed dword":
         case "long":
         case "signed long":
            return SDWORD;
         case "bool":
            return BOOLEAN;
         case "void":
            return VOID;
         case "number":
            return NUMBER;
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
    * @return The size. -1 if the type is compile-time only.
    */
   int getSizeBytes();

   /**
    * Is the type an integer type (including {@link #NUMBER})
    *
    * @param type The type to examine
    * @return true if the type is integer
    */
   static boolean isInteger(SymbolType type) {
      return SDWORD.equals(type) || DWORD.equals(type) || SWORD.equals(type) || WORD.equals(type) || SBYTE.equals(type) || BYTE.equals(type) || NUMBER.equals(type)|| UNUMBER.equals(type)|| SNUMBER.equals(type);
   }

}

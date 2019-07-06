package dk.camelot64.kickc.model.types;

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
   /** Integer with unknown size and unknown signedness (used for constant expressions). */
   SymbolTypeIntegerAuto NUMBER = new SymbolTypeIntegerAuto("number");
   /** Unsigned integer with unknown size (used for constant expressions). */
   SymbolTypeIntegerAuto UNUMBER = new SymbolTypeIntegerAuto("unumber");
   /** Signed integer with unknown size (used for constant expressions). */
   SymbolTypeIntegerAuto SNUMBER = new SymbolTypeIntegerAuto("snumber");
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
            return BYTE;
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

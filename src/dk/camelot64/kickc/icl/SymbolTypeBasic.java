package dk.camelot64.kickc.icl;

/** Basic Symbol Types */
public enum SymbolTypeBasic implements SymbolType {
   BYTE("byte"),
   WORD("word"),
   STRING("string"),
   BOOLEAN("boolean"),
   // A label
   LABEL("label"),
   // Void type.
   VOID("void"),
   // Unresolved type. Will be infered later
   VAR("var");

   private String typeName;

   SymbolTypeBasic(String typeName) {
      this.typeName = typeName;
   }

   public String getTypeName() {
      return typeName;
   }

   public static SymbolTypeBasic get(String name) {
      switch (name) {
         case "byte": return BYTE;
         case "word": return WORD;
         case "string": return STRING;
         case "boolean": return BOOLEAN;
         case "void": return VOID;
      }
      return null;
   }


}

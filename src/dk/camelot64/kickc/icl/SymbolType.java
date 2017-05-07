package dk.camelot64.kickc.icl;

/** Symbol Types */
public enum SymbolType {
   BYTE("byte"),
   WORD("word"),
   STRING("string"),
   BOOLEAN("boolean"),
   LABEL("label"),
   VAR("var");

   private String typeName;

   SymbolType(String typeName) {
      this.typeName = typeName;
   }

   public String getTypeName() {
      return typeName;
   }

   public static SymbolType get(String name) {
      switch (name) {
         case "byte": return BYTE;
         case "word": return WORD;
         case "string": return STRING;
         case "boolean": return BOOLEAN;
      }
      return null;
   }


}

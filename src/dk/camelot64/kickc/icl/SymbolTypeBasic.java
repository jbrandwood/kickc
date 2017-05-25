package dk.camelot64.kickc.icl;

/** Basic Symbol Types */
public enum SymbolTypeBasic implements SymbolType {
   BYTE("byte"),
   WORD("word"),
   STRING("string"),
   BOOLEAN("boolean"),
   LABEL("label"),
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
      }
      return null;
   }


}

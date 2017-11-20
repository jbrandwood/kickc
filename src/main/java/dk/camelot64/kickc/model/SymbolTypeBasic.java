package dk.camelot64.kickc.model;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;

/** Basic Symbol Types */
public class SymbolTypeBasic implements SymbolType {

   public static final SymbolTypeBasic BYTE = new SymbolTypeBasic("byte");
   public static final SymbolTypeBasic SBYTE = new SymbolTypeBasic("signed byte");

   public static final SymbolTypeBasic WORD = new SymbolTypeBasic("word");

   public static final SymbolTypeBasic STRING = new SymbolTypeBasic("string");
   public static final SymbolTypeBasic BOOLEAN = new SymbolTypeBasic("boolean");
   public static final SymbolTypeBasic DOUBLE = new SymbolTypeBasic("double");
   // A label
   public static final SymbolTypeBasic LABEL = new SymbolTypeBasic("label");
   // Void type.
   public static final SymbolTypeBasic VOID = new SymbolTypeBasic("void");
   // Unresolved type. Will be infered later
   public static final SymbolTypeBasic VAR = new SymbolTypeBasic("var");

   private String typeName;

   @JsonCreator
   SymbolTypeBasic(
         @JsonProperty("typeName") String typeName) {
      this.typeName = typeName;
   }

   public String getTypeName() {
      return typeName;
   }

   public static SymbolTypeBasic get(String name) {
      switch (name) {
         case "byte": return BYTE;
         case "signed byte": return SBYTE;
         case "word": return WORD;
         case "string": return STRING;
         case "boolean": return BOOLEAN;
         case "void": return VOID;
      }
      return null;
   }

   @Override
   public boolean equals(Object o) {
      if (this == o) {
         return true;
      }
      if (o == null || getClass() != o.getClass()) {
         return false;
      }

      SymbolTypeBasic that = (SymbolTypeBasic) o;

      return typeName != null ? typeName.equals(that.typeName) : that.typeName == null;
   }

   @Override
   public int hashCode() {
      return typeName != null ? typeName.hashCode() : 0;
   }

   @Override
   public String toString() {
      return getTypeName();
   }

}

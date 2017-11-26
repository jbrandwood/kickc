package dk.camelot64.kickc.model;

import java.util.Collection;

/**
 * Symbol Type of an inline numeric expression. Inline expressions can match multiple types depending on the actual value,
 * eg. the value 27 matches both byte and signed byte (which can in turn be promoted to word/signed word) , while the value -252 only matches signed word.
 */
public class SymbolTypeInline implements SymbolType {

   /**
    * All potential types for the inline constant.
    */
   private Collection<SymbolTypeInteger> types;

   public SymbolTypeInline(Collection<SymbolTypeInteger> types) {
      this.types = types;
   }

   public Collection<SymbolTypeInteger> getTypes() {
      return types;
   }

   @Override
   public String getTypeName() {
      StringBuilder name = new StringBuilder();
      boolean first = true;
      for (SymbolTypeInteger type : types) {
         if(first) {
            first = false;
         }  else {
            name.append("/");
         }
         name.append(type);
      }
      return name.toString();
   }

   @Override
   public boolean equals(Object o) {
      if (this == o) return true;
      if (o == null || getClass() != o.getClass()) return false;
      SymbolTypeInline that = (SymbolTypeInline) o;
      return types != null ? types.equals(that.types) : that.types == null;
   }

   @Override
   public int hashCode() {
      return types != null ? types.hashCode() : 0;
   }

   @Override
   public String toString() {
      return getTypeName();
   }

   /**
    * Is unsigned byte one of the potential types
    * @return true if unsigned byte is a potential type
    */
   public boolean isByte() {
      return types.contains(BYTE);
   }

   public boolean isSByte() {
      return types.contains(SBYTE);
   }

   public boolean isWord() {
      return types.contains(WORD);
   }

   public boolean isSWord() {
      return types.contains(SWORD);
   }
}

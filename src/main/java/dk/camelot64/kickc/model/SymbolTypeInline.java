package dk.camelot64.kickc.model;

import java.util.Arrays;
import java.util.Collection;

/**
 * Symbol Type of an inline expression. Inline expressions can match multiple types depending on the actual value,
 * eg. the value 27 matches both byte and signed byte (which can in turn be promoted to word/signed word), while the value -252 only matches signed word.
 */
public class SymbolTypeInline implements SymbolType {

   /** All numeric types. */
   public static final SymbolTypeInline NUMERIC = new SymbolTypeInline(Arrays.asList(BYTE, SBYTE, WORD, SWORD));
   /**
    * All potential types for the inline constant.
    */
   private Collection<SymbolType> types;

   public SymbolTypeInline(Collection<SymbolType> types) {
      this.types = types;
   }

   public Collection<SymbolType> getTypes() {
      return types;
   }

   @Override
   public String getTypeName() {
      StringBuilder name = new StringBuilder();
      boolean first = true;
      for(SymbolType type : types) {
         if(first) {
            first = false;
         } else {
            name.append("/");
         }
         name.append(type);
      }
      return name.toString();
   }

   @Override
   public boolean equals(Object o) {
      if(this == o) {
         return true;
      }
      if(o == null || getClass() != o.getClass()) {
         return false;
      }
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
    *
    * @return true if unsigned byte is a potential type
    */
   public boolean isByte() {
      return types.contains(BYTE);
   }

   /**
    * Is signed byte one of the potential types
    *
    * @return true if signed byte is a potential type
    */
   public boolean isSByte() {
      return types.contains(SBYTE);
   }

   /**
    * Is unsigned word one of the potential types
    *
    * @return true if unsigned word is a potential type
    */
   public boolean isWord() {
      return types.contains(WORD);
   }

   /**
    * Is signed word one of the potential types
    *
    * @return true if signed word is a potential type
    */
   public boolean isSWord() {
      return types.contains(SWORD);
   }

}

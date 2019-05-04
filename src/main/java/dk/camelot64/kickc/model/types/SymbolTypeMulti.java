package dk.camelot64.kickc.model.types;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;

/**
 * Symbol Type of an inline expression. Inline expressions can match multiple types depending on the actual value,
 * eg. the value 27 matches both byte and signed byte (which can in turn be promoted to word/signed word, dword/signed dword), while the value -252 only matches signed word or signed dword.
 */
public class SymbolTypeMulti implements SymbolType {

   /** All numeric types. */
   public static final SymbolTypeMulti NUMERIC = new SymbolTypeMulti(Arrays.asList(BYTE, SBYTE, WORD, SWORD, DWORD, SDWORD));

   /**
    * All potential types for the inline constant.
    */
   private Collection<SymbolType> types;

   public SymbolTypeMulti(Collection<SymbolType> types) {
      this.types = types;
   }

   public Collection<SymbolType> getTypes() {
      return types;
   }


   /**
    * Get the multi-type that can contain the passed number.
    * @param number The number
    * @return The multi-type
    */
   public static SymbolType getMultiType(Long number) {
      ArrayList<SymbolType> potentialTypes = new ArrayList<>();
      for(SymbolTypeIntegerFixed typeInteger : SymbolType.getIntegerFixedTypes()) {
         if(number >= typeInteger.getMinValue() && number <= typeInteger.getMaxValue()) {
            potentialTypes.add(typeInteger);
         }
      }
      return new SymbolTypeMulti(potentialTypes);
   }

   @Override
   public int getSizeBytes() {
      // Find the minimal sizeof - and return that
      Integer size = null;
      for(SymbolType type : types) {
         if(size==null) {
            size = type.getSizeBytes();
         }  else if(size>type.getSizeBytes()) {
            size = type.getSizeBytes();
         }
      }
      if(size==null) {
         return -1;
      }
      return size;
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
      SymbolTypeMulti that = (SymbolTypeMulti) o;
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

   /**
    * Is unsigned dword one of the potential types
    *
    * @return true if unsigned dword is a potential type
    */
   public boolean isDWord() {
      return types.contains(DWORD);
   }

   /**
    * Is signed dword one of the potential types
    *
    * @return true if signed dword is a potential type
    */
   public boolean isSDWord() {
      return types.contains(SDWORD);
   }


}

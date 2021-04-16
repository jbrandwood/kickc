package dk.camelot64.kickc.model.types;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Objects;

/** Integer type with a fixed size (byte, signed byte, word, ...). */
public class SymbolTypeIntegerFixed implements SymbolTypeInteger {

   private final String typeName;
   private final long minValue;
   private final long maxValue;
   private final boolean signed;
   private final int bits;
   private final boolean isVolatile;
   private final boolean isNomodify;

   SymbolTypeIntegerFixed(String typeName, long minValue, long maxValue, boolean signed, int bits, boolean isVolatile, boolean isNomodify) {
      this.typeName = typeName;
      this.minValue = minValue;
      this.maxValue = maxValue;
      this.signed = signed;
      this.bits = bits;
      this.isVolatile = isVolatile;
      this.isNomodify = isNomodify;
   }

   /**
    * Get all fixed size integer types.
    *
    * @return All fixed size integer types
    */
   public static Collection<SymbolTypeIntegerFixed> getIntegerFixedTypes() {
      ArrayList<SymbolTypeIntegerFixed> types = new ArrayList<>();
      types.add(BYTE);
      types.add(SBYTE);
      types.add(WORD);
      types.add(SWORD);
      types.add(DWORD);
      types.add(SDWORD);
      return types;
   }
   /**
    * Find the smallest signed type that can hold the passed value
    * @param value The value
    * @return The smallest signed type that can hold the value
    */
   public static SymbolTypeIntegerFixed getSmallestSigned(Long value) {
      for(SymbolTypeIntegerFixed fixedType : getIntegerFixedTypes()) {
         if(fixedType.isSigned() && fixedType.contains(value))
            return fixedType;
      }
      return null;
   }

   /**
    * Find the smallest unsigned type that can hold the passed value
    * @param value The value
    * @return The smallest unsigned type that can hold the value
    */
   public static SymbolTypeIntegerFixed getSmallestUnsigned(Long value) {
      for(SymbolTypeIntegerFixed fixedType : getIntegerFixedTypes()) {
         if(!fixedType.isSigned() && fixedType.contains(value))
            return fixedType;
      }
      return null;
   }

   @Override
   public boolean isVolatile() {
      return isVolatile;
   }

   @Override
   public boolean isNomodify() {
      return isNomodify;
   }

   /**
    * Determines if a value can be represented by the type without loss of information
    *
    * @param value The value to examine
    * @return true if the type contains the value
    */
   public boolean contains(Long number) {
      return number >= getMinValue() && number <= getMaxValue();
   }

   @Override
   public String getTypeName() {
      return typeName;
   }

   public long getMinValue() {
      return minValue;
   }

   public long getMaxValue() {
      return maxValue;
   }

   public boolean isSigned() {
      return signed;
   }

   public int getBits() {
      return bits;
   }

   @Override
   public int getSizeBytes() {
      return bits/8;
   }

   @Override
   public String toString() {
      return getTypeName();
   }

   @Override
   public boolean equals(Object o) {
      if(this == o) return true;
      if(o == null || getClass() != o.getClass()) return false;
      SymbolTypeIntegerFixed that = (SymbolTypeIntegerFixed) o;
      return Objects.equals(typeName, that.typeName);
   }

   @Override
   public int hashCode() {
      return Objects.hash(typeName);
   }
}

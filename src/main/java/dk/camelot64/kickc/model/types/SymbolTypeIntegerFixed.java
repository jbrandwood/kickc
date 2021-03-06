package dk.camelot64.kickc.model.types;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Locale;
import java.util.Objects;

/** Integer type with a fixed size (byte, signed byte, word, ...). */
public class SymbolTypeIntegerFixed implements SymbolTypeInteger {

   /** The basename of the the type (without any qualifiers). */
   private final String typeBaseName;
   /** The basename of the the C type (without any qualifiers). */
   private final String cTypeBaseName;

   private final long minValue;
   private final long maxValue;
   private final boolean signed;
   private final int bits;

   private final boolean isVolatile;
   private final boolean isNomodify;

   SymbolTypeIntegerFixed(String typeBaseName, String cTypeBaseName, long minValue, long maxValue, boolean signed, int bits, boolean isVolatile, boolean isNomodify) {
      this.typeBaseName = typeBaseName;
      this.cTypeBaseName = cTypeBaseName;
      this.minValue = minValue;
      this.maxValue = maxValue;
      this.signed = signed;
      this.bits = bits;
      this.isVolatile = isVolatile;
      this.isNomodify = isNomodify;
   }

   @Override
   public SymbolType getQualified(boolean isVolatile, boolean isNomodify) {
      return new SymbolTypeIntegerFixed(this.typeBaseName, this.cTypeBaseName, this.minValue, this.maxValue, this.signed, this.bits, isVolatile, isNomodify);
   }

   /**
    * Get all (unqualified) fixed size integer types.
    *
    * @return All (unqualified) fixed size integer types
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

   @Override
   public String getTypeName() {
      return typeBaseName;
   }

   /**
    * Determines if a value can be represented by the type without loss of information
    *
    * @param number The value to examine
    * @return true if the type contains the value
    */
   public boolean contains(Long number) {
      return number >= getMinValue() && number <= getMaxValue();
   }

   public String getCTypeBaseName() {
      return cTypeBaseName;
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
      return toCDecl();
   }

   @Override
   public String toCDecl(String parentCDecl) {
      StringBuilder cdecl = new StringBuilder();
      if(isVolatile())
         cdecl.append("volatile ");
      if(isNomodify())
         cdecl.append("const ");
      cdecl.append(this.getCTypeBaseName());
      if(parentCDecl.length()>0)
         cdecl.append(" ");
      cdecl.append(parentCDecl);
      return cdecl.toString();
   }

   @Override
   public String getConstantFriendlyName() {
      return cTypeBaseName.toUpperCase(Locale.ENGLISH).replace(" ", "_");
   }

   @Override
   public boolean equals(Object o) {
      if(this == o) return true;
      if(o == null || getClass() != o.getClass()) return false;
      SymbolTypeIntegerFixed that = (SymbolTypeIntegerFixed) o;
      return Objects.equals(typeBaseName, that.typeBaseName);
   }

   @Override
   public int hashCode() {
      return Objects.hash(typeBaseName);
   }
}

package dk.camelot64.kickc.model.types;

/** Integer symbol types (byte, signed byte, word, ...). */
public class SymbolTypeInteger implements SymbolTypeSimple {

   private final String typeName;
   private final long minValue;
   private final long maxValue;
   private final boolean signed;
   private final int bits;

   SymbolTypeInteger(String typeName, long minValue, long maxValue, boolean signed, int bits) {
      this.typeName = typeName;
      this.minValue = minValue;
      this.maxValue = maxValue;
      this.signed = signed;
      this.bits = bits;
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
   public String toString() {
      return getTypeName();
   }
}

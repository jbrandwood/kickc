package dk.camelot64.kickc.model;

/** Integer symbol types (byte, signed byte, word, ...). */
public class SymbolTypeInteger implements SymbolType {

   private final String typeName;
   private final long minValue;
   private final long maxValue;

   SymbolTypeInteger(String typeName, long minValue, long maxValue) {
      this.typeName = typeName;
      this.minValue = minValue;
      this.maxValue = maxValue;
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

   @Override
   public String toString() {
      return getTypeName();
   }
}

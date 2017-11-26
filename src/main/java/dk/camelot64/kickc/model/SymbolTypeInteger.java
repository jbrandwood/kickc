package dk.camelot64.kickc.model;

/** Integer symbol types (byte, signed byte, word, ...).  */
public class SymbolTypeInteger implements SymbolType {

   private final String typeName;
   private final int minValue;
   private final int maxValue;

   SymbolTypeInteger(String typeName, int minValue, int maxValue) {
      this.typeName = typeName;
      this.minValue = minValue;
      this.maxValue = maxValue;
   }

   @Override
   public String getTypeName() {
      return typeName;
   }

   public int getMinValue() {
      return minValue;
   }

   public int getMaxValue() {
      return maxValue;
   }

   @Override
   public String toString() {
      return getTypeName();
   }
}

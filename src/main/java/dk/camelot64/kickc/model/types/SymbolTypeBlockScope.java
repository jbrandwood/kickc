package dk.camelot64.kickc.model.types;

/** A block scope */
public class SymbolTypeBlockScope implements SymbolType {

   public SymbolTypeBlockScope() {
   }

   @Override
   public SymbolType getQualified(boolean isVolatile, boolean isNomodify) {
      return this;
   }

   @Override
   public boolean isVolatile() {
      return false;
   }

   @Override
   public boolean isNomodify() {
      return false;
   }

   @Override
   public String getTypeName() {
      return "BLOCK";
   }

   @Override
   public int getSizeBytes() {
      return -1;
   }

   @Override
   public int hashCode() {
      return 443;
   }

   @Override
   public boolean equals(Object obj) {
      return (obj instanceof SymbolTypeBlockScope);
   }

   @Override
   public String toString() {
      return getTypeName();
   }

}

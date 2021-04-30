package dk.camelot64.kickc.model.types;

/** The scope holding typedefs */
public class SymbolTypeTypeDefScope implements SymbolType {

   public SymbolTypeTypeDefScope() {
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
   public String getTypeBaseName() {
      return "TYPEDEF";
   }

   @Override
   public int getSizeBytes() {
      return -1;
   }

   @Override
   public int hashCode() {
      return 737;
   }

   @Override
   public boolean equals(Object obj) {
      return (obj instanceof SymbolTypeTypeDefScope);
   }

   @Override
   public String toString() {
      return getTypeName();
   }

}

package dk.camelot64.kickc.model.types;

/** A program */
public class SymbolTypeProgram implements SymbolType {

   public SymbolTypeProgram() {
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
      return "PROGRAM";
   }

   @Override
   public int getSizeBytes() {
      return -1;
   }

   @Override
   public int hashCode() {
      return 331;
   }

   @Override
   public boolean equals(Object obj) {
      return (obj instanceof SymbolTypeProgram);
   }

   @Override
   public String toString() {
      return getTypeName();
   }

}

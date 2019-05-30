package dk.camelot64.kickc.model.types;

/** A program */
public class SymbolTypeProgram implements SymbolType {

   public SymbolTypeProgram() {

   }

   @Override
   public String getTypeName() {
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

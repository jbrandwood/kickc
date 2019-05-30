package dk.camelot64.kickc.model.types;

/** Basic named (string, char, ...) Symbol Types */
public class SymbolTypeNamed implements SymbolType {

   private String typeName;

   private int sizeBytes;

   SymbolTypeNamed(String typeName, int sizeBytes) {
      this.typeName = typeName;
      this.sizeBytes = sizeBytes;
   }

   public String getTypeName() {
      return typeName;
   }

   @Override
   public int getSizeBytes() {
      return sizeBytes;
   }

   @Override
   public boolean equals(Object o) {
      if(this == o) {
         return true;
      }
      if(o == null || getClass() != o.getClass()) {
         return false;
      }

      SymbolTypeNamed that = (SymbolTypeNamed) o;

      return typeName != null ? typeName.equals(that.typeName) : that.typeName == null;
   }

   @Override
   public int hashCode() {
      return typeName != null ? typeName.hashCode() : 0;
   }

   @Override
   public String toString() {
      return getTypeName();
   }

}


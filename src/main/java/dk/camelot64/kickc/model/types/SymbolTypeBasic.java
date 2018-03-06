package dk.camelot64.kickc.model.types;

/** Basic Symbol Types */
public class SymbolTypeBasic implements SymbolType {

   private String typeName;

   SymbolTypeBasic(String typeName) {
      this.typeName = typeName;
   }

   public String getTypeName() {
      return typeName;
   }

   @Override
   public boolean equals(Object o) {
      if(this == o) {
         return true;
      }
      if(o == null || getClass() != o.getClass()) {
         return false;
      }

      SymbolTypeBasic that = (SymbolTypeBasic) o;

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

package dk.camelot64.kickc.model.types;

/** Basic named (string, char, ...) Symbol Types */
public class SymbolTypeNamed implements SymbolType {

   private String typeBaseName;
   private int sizeBytes;
   private final boolean isVolatile;
   private final boolean isNomodify;

   SymbolTypeNamed(String typeBaseName, int sizeBytes, boolean isVolatile, boolean isNomodify) {
      this.typeBaseName = typeBaseName;
      this.sizeBytes = sizeBytes;
      this.isVolatile = isVolatile;
      this.isNomodify = isNomodify;
   }

   @Override
   public SymbolType getQualified(boolean isVolatile, boolean isNomodify) {
      return new SymbolTypeNamed(this.typeBaseName, this.sizeBytes, isVolatile, isNomodify);
   }

   @Override
   public boolean isVolatile() {
      return isVolatile;
   }

   @Override
   public boolean isNomodify() {
      return isNomodify;
   }

   public String getTypeName() {
      String name = "";
      // TODO #121 Add
      /*
      if(isVolatile)
         name += "volatile ";
      if(isNomodify)
         name += "const ";
       */
      name += typeBaseName;
      return name;
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

      return typeBaseName != null ? typeBaseName.equals(that.typeBaseName) : that.typeBaseName == null;
   }

   @Override
   public int hashCode() {
      return typeBaseName != null ? typeBaseName.hashCode() : 0;
   }

   @Override
   public String toString() {
      return getTypeName();
   }

}


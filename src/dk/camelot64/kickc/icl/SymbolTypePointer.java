package dk.camelot64.kickc.icl;

/** A pointer */
public class SymbolTypePointer implements SymbolType {

   private SymbolType elementType;

   public SymbolTypePointer(SymbolType elementType) {
      this.elementType = elementType;
   }

   public SymbolType getElementType() {
      return elementType;
   }

   @Override
   public String getTypeName() {
      return elementType.getTypeName()+"*";
   }


}

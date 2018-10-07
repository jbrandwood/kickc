package dk.camelot64.kickc.model.types;

/** A local scope */
public class SymbolTypeBlockScope implements SymbolTypeSimple {

   public SymbolTypeBlockScope() {

   }

   @Override
   public String getTypeName() {
      return "LOCALSCOPE";
   }

   @Override
   public int hashCode() {
      return 773;
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

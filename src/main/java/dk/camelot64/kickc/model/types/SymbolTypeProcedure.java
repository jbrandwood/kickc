package dk.camelot64.kickc.model.types;

/** A function returning another type */
public class SymbolTypeProcedure implements SymbolTypeSimple {

   private SymbolType returnType;

   public SymbolTypeProcedure(SymbolType returnType) {
      this.returnType = returnType;
   }

   public SymbolType getReturnType() {
      return returnType;
   }

   @Override
   public String getTypeName() {
      return returnType.getTypeName() + "()";
   }

   @Override
   public String toString() {
      return getTypeName();
   }

}

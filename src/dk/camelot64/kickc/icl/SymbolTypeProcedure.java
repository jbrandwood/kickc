package dk.camelot64.kickc.icl;

/**  A function returning another type */
public class SymbolTypeProcedure implements SymbolType {

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
}

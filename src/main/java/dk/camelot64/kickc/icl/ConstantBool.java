package dk.camelot64.kickc.icl;

/**
 * SSA form constant integer value
 */
public class ConstantBool implements ConstantValue {

   private Boolean value;

   public ConstantBool(Boolean value) {
      this.value = value;
   }

   @Override
   public SymbolType getType(ProgramScope scope) {
      return SymbolTypeBasic.BOOLEAN;
   }

   @Override
   public String toString() {
      return toString(null);
   }

   @Override
   public String toString(Program program) {
      if(program ==null) {
         return Boolean.toString(value);
      }  else {
         return //"("+SymbolTypeBasic.BOOLEAN.getTypeName()+") "+
               Boolean.toString(value);
      }
   }

}

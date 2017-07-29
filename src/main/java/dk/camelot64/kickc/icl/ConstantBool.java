package dk.camelot64.kickc.icl;

/**
 * SSA form constant integer value
 */
public class ConstantBool implements Constant {

   private Boolean value;

   public ConstantBool(Boolean value) {
      this.value = value;
   }

   @Override
   public String toString() {
      return toString(null);
   }

   @Override
   public String toString(ProgramScope scope) {
      if(scope==null) {
         return Boolean.toString(value);
      }  else {
         return //"("+SymbolTypeBasic.BOOLEAN.getTypeName()+") "+
               Boolean.toString(value);
      }
   }

}

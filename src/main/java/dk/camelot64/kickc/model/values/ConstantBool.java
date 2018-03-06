package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;

/**
 * SSA form constant integer value
 */
public class ConstantBool implements ConstantLiteral<Boolean> {

   private Boolean value;

   public ConstantBool(Boolean value) {
      this.value = value;
   }

   @Override
   public SymbolType getType(ProgramScope scope) {
      return SymbolType.BOOLEAN;
   }

   @Override
   public Boolean getValue() {
      return value;
   }

   @Override
   public String toString() {
      return toString(null);
   }

   @Override
   public String toString(Program program) {
      if(program == null) {
         return Boolean.toString(value);
      } else {
         return //"("+SymbolTypeBasic.BOOLEAN.getTypeName()+") "+
               Boolean.toString(value);
      }
   }

}

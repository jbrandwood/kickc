package dk.camelot64.kickc.model;

/**
 * SSA form constant char value (a byte)
 */
public class ConstantChar implements ConstantValue {

   private Character value;

   public ConstantChar(Character value) {
      this.value = value;
   }

   @Override
   public SymbolType getType(ProgramScope scope) {
      return SymbolType.BYTE;
   }

   public Character getValue() {
      return value;
   }

   @Override
   public String toString() {
      return toString(null);
   }

   @Override
   public String toString(Program program) {
      if(program == null) {
         return "'" + value + "'";
      } else {
         return "(" + SymbolType.BYTE.getTypeName() + ") " + "'" + value + "'";
      }
   }

}

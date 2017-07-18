package dk.camelot64.kickc.icl;

/**
 * SSA form constant integer value
 */
public class ConstantInteger implements Constant {

   private Integer number;

   public ConstantInteger(Integer number) {
      this.number = number;
   }

   public Integer getNumber() {
      return number;
   }

   public SymbolType getType() {
      SymbolType type;
      if (getNumber() < 256) {
         type = SymbolTypeBasic.BYTE;
      } else {
         type = SymbolTypeBasic.WORD;
      }
      return type;
   }

   @Override
   public String toString() {
      return "("+getType().getTypeName()+") "+Integer.toString(number);
   }

}

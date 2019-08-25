package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.symbols.Symbol;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypePointer;

import java.util.Objects;

/** A pointer to a symbol (variable or procedure) */
public class ConstantSymbolPointer implements ConstantValue {

   /** The variable pointed to. */
   private SymbolRef toSymbol;

   public ConstantSymbolPointer(SymbolRef toSymbol) {
      this.toSymbol = toSymbol;
   }

   public SymbolRef getToSymbol() {
      return toSymbol;
   }

   public void setToSymbol(SymbolRef toSymbol) {
      this.toSymbol = toSymbol;
   }

   @Override
   public SymbolType getType(ProgramScope scope) {
      Symbol to = scope.getSymbol(toSymbol);
      return new SymbolTypePointer(to.getType());
   }

   @Override
   public ConstantLiteral calculateLiteral(ProgramScope scope) {
      // If the symbol has been allocated we can calculate a literal value!
      Symbol symbol = scope.getSymbol(toSymbol);
      if(symbol instanceof Variable) {
         Registers.Register allocation = ((Variable) symbol).getAllocation();
         if(allocation!=null && allocation.isZp()) {
            int zp = ((Registers.RegisterZp) allocation).getZp();
            return new ConstantInteger((long)zp, SymbolType.BYTE);
         }
      }
      // WE cannot calculate a literal value
      throw new ConstantNotLiteral("Cannot calculate literal var pointer");
   }

   @Override
   public String toString(Program program) {
      return "&" + toSymbol.toString(program);
   }

   @Override
   public String toString() {
      return toString(null);
   }

   @Override
   public boolean equals(Object o) {
      if(this == o) return true;
      if(o == null || getClass() != o.getClass()) return false;
      ConstantSymbolPointer that = (ConstantSymbolPointer) o;
      return Objects.equals(toSymbol, that.toSymbol);
   }

   @Override
   public int hashCode() {

      return Objects.hash(toSymbol);
   }
}

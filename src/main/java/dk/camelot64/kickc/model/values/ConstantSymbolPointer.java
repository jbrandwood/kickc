package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.symbols.Symbol;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypePointer;

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
}

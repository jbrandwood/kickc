package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.ConstantNotLiteral;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.Registers;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.symbols.Symbol;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypePointer;

import java.util.Collection;
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
         Variable variable = (Variable) symbol;
         if(variable.isVariable()) {

            // Hacky solution to get a version that has an allocation
            if(variable.isKindPhiMaster()) {
               Collection<Variable> versions = variable.getScope().getVersions(variable);
               for(Variable version : versions) {
                  if(variable.isVariable()) {
                     variable = version;
                     break;
                  }
               }
            }

            Registers.Register allocation = variable.getAllocation();
            if(allocation != null && Registers.RegisterType.ZP_MEM.equals(allocation.getType())) {
               int zp = ((Registers.RegisterZpMem) allocation).getZp();
               return new ConstantInteger((long) zp, SymbolType.BYTE);
            } else if(allocation != null && Registers.RegisterType.MAIN_MEM.equals(allocation.getType())) {
               throw ConstantNotLiteral.getException();
            }
         }
      }
      // We cannot calculate a literal value
      throw ConstantNotLiteral.getException();
   }

   @Override
   public String toString(Program program) {
      return "&" + toSymbol.toString(null);
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

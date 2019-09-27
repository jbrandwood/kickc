package dk.camelot64.kickc.model.symbols;

import dk.camelot64.kickc.model.Registers;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.VariableRef;

/** A Variable (or a Constant) */
public class Variable extends SymbolVariable {

   /** true if the variable is intermediate. */
   private boolean isIntermediate;

   /* true if the variable is a PHI version. (the variable has storage strategy PHI)*/
   private boolean isVersion;

   /** If the variable is assigned to a specific "register", this contains the register. If null the variable has no allocation (yet). Constants are never assigned to registers. */
   private Registers.Register allocation;

   public Variable(String name, Scope scope, SymbolType type, String dataSegment, boolean isIntermediate, boolean isVersion) {
      super(name, scope, type, dataSegment);
      this.isIntermediate = isIntermediate;
      this.isVersion = isVersion;
   }

   public Registers.Register getAllocation() {
      return allocation;
   }

   public void setAllocation(Registers.Register allocation) {
      this.allocation = allocation;
   }

   public boolean isVersioned() {
      return isVersion;
   }

   public boolean isIntermediate() {
      return isIntermediate;
   }

   public VariableRef getRef() {
      return new VariableRef(this);
   }

   @Override
   public boolean equals(Object o) {
      if(this == o) return true;
      if(o == null || getClass() != o.getClass()) return false;
      if(!super.equals(o)) return false;
      Variable variable = (Variable) o;
      return allocation != null ? allocation.equals(variable.allocation) : variable.allocation == null;
   }

   @Override
   public int hashCode() {
      int result = super.hashCode();
      result = 31 * result + (allocation != null ? allocation.hashCode() : 0);
      return result;
   }

}

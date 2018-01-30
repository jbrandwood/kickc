package dk.camelot64.kickc.model;

/** A Variable (or a Constant) */
public abstract class Variable extends SymbolVariable {

   /** If the variable is assigned to an ASM register, this contains the register. If null the variable has no allocation (yet). Constants are never assigned to registers. */
   private Registers.Register allocation;

   public Variable(String name, Scope scope, SymbolType type) {
      super(name, scope, type);
   }

   public Registers.Register getAllocation() {
      return allocation;
   }

   public void setAllocation(Registers.Register allocation) {
      this.allocation = allocation;
   }

   public abstract boolean isVersioned();

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

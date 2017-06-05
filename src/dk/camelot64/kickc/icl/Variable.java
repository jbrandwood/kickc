package dk.camelot64.kickc.icl;

/**
 * A Symbol (variable, jump label, etc.)
 */
public abstract class Variable implements Symbol, RValue, LValue {

   /**
    * The name of the symbol.
    */
   private String name;

   /**
    * Scope
    */
   private Scope scope;

   /**
    * The type of the symbol. VAR means tha type is unknown, and has not been inferred yet.
    */
   private SymbolType type;

   /**
    * true if the symbol type is infered (not declared)
    */
   private boolean inferredType;

   public Variable(String name, Scope scope, SymbolType type) {
      this.name = name;
      this.scope = scope;
      this.type = type;
      this.inferredType = false;
   }

   public String getLocalName() {
      return name;
   }

   @Override
   public String getFullName() {
      return Scope.getFullName(this);
   }

   @Override
   public String getTypedName() {
      return "(" + type.getTypeName() + (inferredType ? "~" : "") + ") " + getFullName();
   }

   public SymbolType getType() {
      return type;
   }

   public void setInferredType(SymbolType type) {
      this.type = type;
      this.inferredType = true;
   }

   public boolean isInferredType() {
      return inferredType;
   }

   public abstract boolean isVersioned();

   public abstract boolean isIntermediate();

   @Override
   public boolean equals(Object o) {
      if (this == o) return true;
      if (o == null || getClass() != o.getClass()) return false;

      Variable variable = (Variable) o;

      if (inferredType != variable.inferredType) return false;
      if (!name.equals(variable.name)) return false;
      if (scope != null ? !scope.equals(variable.scope) : variable.scope != null) return false;
      return type.equals(variable.type);
   }

   @Override
   public int hashCode() {
      int result = name.hashCode();
      result = 31 * result + (scope != null ? scope.hashCode() : 0);
      result = 31 * result + type.hashCode();
      result = 31 * result + (inferredType ? 1 : 0);
      return result;
   }

   @Override
   public String toString() {
      return getTypedName();
   }

   public Scope getScope() {
      return scope;
   }
}

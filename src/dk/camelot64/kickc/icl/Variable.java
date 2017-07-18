package dk.camelot64.kickc.icl;

import com.fasterxml.jackson.annotation.JsonIgnore;

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
   @JsonIgnore
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

   @Override
   public String getLocalName() {
      return name;
   }

   @Override
   public String getFullName() {
      return Scope.getFullName(this);
   }

   @Override
   @JsonIgnore
   public String getTypedName() {
      return "(" + type.getTypeName() + (inferredType ? "~" : "") + ") " + getFullName();
   }

   public SymbolType getType() {
      return type;
   }

   public void setTypeInferred(SymbolType type) {
      this.type = type;
      this.inferredType = true;
   }

   public boolean isInferredType() {
      return inferredType;
   }

   public void setInferredType(boolean inferredType) {
      this.inferredType = inferredType;
   }

   public void setScope(Scope scope) {
      this.scope = scope;
   }

   public void setType(SymbolType type) {
      this.type = type;
   }

   public void setName(String name) {
      this.name = name;
   }

   @JsonIgnore
   public abstract boolean isVersioned();

   @JsonIgnore
   public abstract boolean isIntermediate();

   @Override
   public boolean equals(Object o) {
      if (this == o) return true;
      if (o == null || getClass() != o.getClass()) return false;
      Variable variable = (Variable) o;
      if (inferredType != variable.inferredType) return false;
      if (!name.equals(variable.name)) return false;
      if (!getFullName().equals(variable.getFullName())) return false;
      return type.equals(variable.type);
   }

   @Override
   public int hashCode() {
      int result = getFullName().hashCode();
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

   @Override
   public int getScopeDepth() {
      if(scope==null) {
         return 0;
      } else {
         return scope.getScopeDepth()+1;
      }
   }

}

package dk.camelot64.kickc.icl;

import com.fasterxml.jackson.annotation.JsonIgnore;

/** A Variable (or a Constant) */
public abstract class Variable implements Symbol {

   /** The name of the variable. */
   private String name;

   /** The scope containing the variable */
   @JsonIgnore
   private Scope scope;

   /** The type of the variable. VAR means tha type is unknown, and has not been inferred yet. */
   private SymbolType type;

   /** true if the symbol type is infered (not declared) */
   private boolean inferredType;

   /** If the variable is assigned to an ASM register, this contains the register. If null the variable has no allocation (yet). Constants are never assigned to registers. */
   private Registers.Register allocation;

   /** A short name used for the variable in ASM code. If possible variable names of ZP variables are shortened in ASM code. This is possible, when all versions of the var use the same register. */
   private String asmName;

   /** If the variable is a constant this is the constant value. If null the variable is not considered constant.*/
   private Constant constant;

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

   public String getName() {
      return name;
   }

   public Registers.Register getAllocation() {
      return allocation;
   }

   public void setAllocation(Registers.Register allocation) {
      this.allocation = allocation;
   }

   public String getAsmName() {
      return asmName;
   }

   public void setAsmName(String asmName) {
      this.asmName = asmName;
   }

   public Constant getConstant() {
      return constant;
   }

   public void setConstant(Constant constant) {
      this.constant = constant;
   }

   @JsonIgnore
   public abstract boolean isVersioned();

   @JsonIgnore
   public abstract boolean isIntermediate();


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

   @JsonIgnore
   public VariableRef getRef() {
      return new VariableRef(this);
   }

   @Override
   public boolean equals(Object o) {
      if (this == o) return true;
      if (o == null || getClass() != o.getClass()) return false;
      Variable variable = (Variable) o;
      if (inferredType != variable.inferredType) return false;
      if (name != null ? !name.equals(variable.name) : variable.name != null) return false;
      if (scope != null ? !scope.equals(variable.scope) : variable.scope != null) return false;
      if (type != null ? !type.equals(variable.type) : variable.type != null) return false;
      if (allocation != null ? !allocation.equals(variable.allocation) : variable.allocation != null) return false;
      if (asmName != null ? !asmName.equals(variable.asmName) : variable.asmName != null) return false;
      return constant != null ? constant.equals(variable.constant) : variable.constant == null;
   }

   @Override
   public int hashCode() {
      int result = name != null ? name.hashCode() : 0;
      result = 31 * result + (scope != null ? scope.hashCode() : 0);
      result = 31 * result + (type != null ? type.hashCode() : 0);
      result = 31 * result + (inferredType ? 1 : 0);
      result = 31 * result + (allocation != null ? allocation.hashCode() : 0);
      result = 31 * result + (asmName != null ? asmName.hashCode() : 0);
      result = 31 * result + (constant != null ? constant.hashCode() : 0);
      return result;
   }

   @Override
   public String toString() {
      return toString(null);
   }

   @Override
   public String toString(Program program) {
      String s = new StringBuilder()
            .append("(")
            .append(type.getTypeName())
            .append(inferredType ? "~" : "")
            .append(") ")
            .append(getFullName()).toString();
      return s;
   }

}

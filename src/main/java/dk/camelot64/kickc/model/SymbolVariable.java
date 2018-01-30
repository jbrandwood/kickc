package dk.camelot64.kickc.model;

/** Abstract Variable or a Constant Variable */
public abstract class SymbolVariable implements Symbol {

   /** The name of the variable. */
   private String name;

   /** The scope containing the variable */
   private Scope scope;

   /** The type of the variable. VAR means tha type is unknown, and has not been inferred yet. */
   private SymbolType type;

   /** true if the symbol type is infered (not declared) */
   private boolean inferredType;

   /** A short name used for the variable in ASM code. If possible variable names of ZP variables are shortened in ASM code. This is possible, when all versions of the var use the same register. */
   private String asmName;

   /** Specifies that the variable is declared a constant. It will be replaced by a ConstantVar when possible. */
   private boolean declaredConstant;

   /** Specifies that the variable must be aligned in memory. Only allowed for arrays & strings. */
   private Integer declaredAlignment;

   public SymbolVariable(String name, Scope scope, SymbolType type) {
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

   public void setType(SymbolType type) {
      this.type = type;
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

   public String getName() {
      return name;
   }

   public void setName(String name) {
      this.name = name;
   }

   public String getAsmName() {
      return asmName;
   }

   public void setAsmName(String asmName) {
      this.asmName = asmName;
   }

   public Scope getScope() {
      return scope;
   }

   public void setScope(Scope scope) {
      this.scope = scope;
   }

   @Override
   public int getScopeDepth() {
      if(scope == null) {
         return 0;
      } else {
         return scope.getScopeDepth() + 1;
      }
   }

   public boolean isDeclaredConstant() {
      return declaredConstant;
   }

   public void setDeclaredConstant(boolean declaredConstant) {
      this.declaredConstant = declaredConstant;
   }

   public Integer getDeclaredAlignment() {
      return declaredAlignment;
   }

   public void setDeclaredAlignment(Integer declaredAlignment) {
      this.declaredAlignment = declaredAlignment;
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

   @Override
   public boolean equals(Object o) {
      if(this == o) {
         return true;
      }
      if(o == null || getClass() != o.getClass()) {
         return false;
      }

      SymbolVariable variable = (SymbolVariable) o;

      if(inferredType != variable.inferredType) {
         return false;
      }
      if(name != null ? !name.equals(variable.name) : variable.name != null) {
         return false;
      }
      if(scope != null ? !scope.equals(variable.scope) : variable.scope != null) {
         return false;
      }
      if(type != null ? !type.equals(variable.type) : variable.type != null) {
         return false;
      }
      return asmName != null ? asmName.equals(variable.asmName) : variable.asmName == null;
   }

   @Override
   public int hashCode() {
      int result = name != null ? name.hashCode() : 0;
      result = 31 * result + (scope != null ? scope.hashCode() : 0);
      result = 31 * result + (type != null ? type.hashCode() : 0);
      result = 31 * result + (inferredType ? 1 : 0);
      result = 31 * result + (asmName != null ? asmName.hashCode() : 0);
      return result;
   }
}

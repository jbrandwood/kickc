package dk.camelot64.kickc.model;

import com.fasterxml.jackson.annotation.JsonIgnore;

/** A named constant or a variable that has been inferred to be constant in the symbol table */
public class ConstantVar implements Symbol {

   /** The name of the variable. */
   private String name;

   /** The scope containing the variable */
   @JsonIgnore
   private Scope scope;

   /** The type of the variable. VAR means tha type is unknown, and has not been inferred yet. */
   private SymbolType type;

   /** The value of the constant. */
   private ConstantValue value;

   /** A short name used for the variable in ASM code. If possible variable names of ZP variables are shortened in ASM code. This is possible, when all versions of the var use the same register. */
   private String asmName;

   /** Specifies that the variable must be aligned in memory. Only allowed for arrays & strings. */
   private Integer declaredAlignment;

   public ConstantVar(String name, Scope scope, SymbolType type, ConstantValue value) {
      this.name = name;
      this.scope = scope;
      this.type = type;
      this.value = value;
   }

   public SymbolType getType(ProgramScope scope) {
      return type;
   }

   @Override
   public String getLocalName() {
      return name;
   }

   @Override
   public String getFullName() {
      return Scope.getFullName(this);
   }

   public String getAsmName() {
      return asmName;
   }

   public void setAsmName(String asmName) {
      this.asmName = asmName;
   }

   @Override
   public SymbolType getType() {
      return type;
   }

   @Override
   public Scope getScope() {
      return scope;
   }

   @Override
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

   public ConstantValue getValue() {
      return value;
   }

   public void setValue(ConstantValue value) {
      this.value = value;
   }

   public ConstantRef getRef() {
      return new ConstantRef(this);
   }

   public Integer getDeclaredAlignment() {
      return declaredAlignment;
   }

   public void setDeclaredAlignment(Integer declaredAlignment) {
      this.declaredAlignment = declaredAlignment;
   }

   @Override
   public String toString(Program program) {
      String s = new StringBuilder()
            .append("(")
            .append("const" + " ")
            .append(type.getTypeName())
            .append(") ")
            .append(getFullName()).toString();
      return s;
   }

   @Override
   public String toString() {
      return toString(null);
   }

   @Override
   public boolean equals(Object o) {
      if(this == o) {
         return true;
      }
      if(o == null || getClass() != o.getClass()) {
         return false;
      }

      ConstantVar that = (ConstantVar) o;

      if(name != null ? !name.equals(that.name) : that.name != null) {
         return false;
      }
      if(scope != null ? !scope.equals(that.scope) : that.scope != null) {
         return false;
      }
      if(type != null ? !type.equals(that.type) : that.type != null) {
         return false;
      }
      return value != null ? value.equals(that.value) : that.value == null;
   }

   @Override
   public int hashCode() {
      int result = name != null ? name.hashCode() : 0;
      result = 31 * result + (scope != null ? scope.hashCode() : 0);
      result = 31 * result + (type != null ? type.hashCode() : 0);
      result = 31 * result + (value != null ? value.hashCode() : 0);
      return result;
   }
}

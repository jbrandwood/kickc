package dk.camelot64.kickc.model.symbols;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.ConstantRef;
import dk.camelot64.kickc.model.values.ConstantValue;

/** A named constant or a variable that has been inferred to be constant in the symbol table */
public class ConstantVar extends SymbolVariable {

   /** The constant value. */
   private ConstantValue value;

   public ConstantVar(String name, Scope scope, SymbolType type, ConstantValue value, String dataSegment) {
      super(name, scope, type, dataSegment);
      this.value = value;
   }

   public ConstantValue getValue() {
      return value;
   }

   public void setValue(ConstantValue value) {
      this.value = value;
   }

   @Override
   public ConstantRef getRef() {
      return new ConstantRef(this);
   }

   @Override
   public String toString(Program program) {
      String s = new StringBuilder()
            .append("(")
            .append("const" + " ")
            .append(getType().getTypeName())
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
      if(this == o) return true;
      if(o == null || getClass() != o.getClass()) return false;
      if(!super.equals(o)) return false;

      ConstantVar that = (ConstantVar) o;

      return value != null ? value.equals(that.value) : that.value == null;
   }

   @Override
   public int hashCode() {
      int result = super.hashCode();
      result = 31 * result + (value != null ? value.hashCode() : 0);
      return result;
   }
}

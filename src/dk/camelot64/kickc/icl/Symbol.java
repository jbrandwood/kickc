package dk.camelot64.kickc.icl;

/** A Symbol (variable, jump label, etc.) */
public class Symbol implements RValue, LValue {

   private String name;

   private SymbolType type;

   private boolean intermediate;

   private boolean inferredType;

   public Symbol(String name, SymbolType type, boolean intermediate) {
      this.name = name;
      this.type = type;
      this.intermediate = intermediate;
      this.inferredType = false;
   }

   public String getName() {
      return name;
   }

   public SymbolType getType() {
      return type;
   }

   public void setInferredType(SymbolType type) {
      this.type = type;
      this.inferredType = true;
   }

   public boolean isIntermediate() {
      return intermediate;
   }

   @Override
   public String toString() {
      return "("+name + ": " + type.getTypeName() + (inferredType ?"*":"") + ")";
   }

   @Override
   public boolean equals(Object o) {
      if (this == o) return true;
      if (o == null || getClass() != o.getClass()) return false;
      Symbol symbol = (Symbol) o;
      if (intermediate != symbol.intermediate) return false;
      if (inferredType != symbol.inferredType) return false;
      if (!name.equals(symbol.name)) return false;
      return type == symbol.type;
   }

   @Override
   public int hashCode() {
      int result = name.hashCode();
      result = 31 * result + (type != null ? type.hashCode() : 0);
      result = 31 * result + (intermediate ? 1 : 0);
      result = 31 * result + (inferredType ? 1 : 0);
      return result;
   }
}

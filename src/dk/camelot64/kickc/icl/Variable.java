package dk.camelot64.kickc.icl;

/** A Symbol (variable, jump label, etc.) */
public abstract class Variable implements Symbol, RValue, LValue  {

   /** The name of the symbol. */
   private String name;

   /** The type of the symbol. VAR means tha type is unknown, and has not been inferred yet. */
   private SymbolType type;

   /** true if the symbol type is infered (not declared) */
   private boolean inferredType;

   public Variable(String name, SymbolType type) {
      this.name = name;
      this.type = type;
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

   public boolean isInferredType() {
      return inferredType;
   }

   public abstract boolean isVersioned();

   public abstract boolean isIntermediate();

   @Override
   public String toString() {
      return "("+type.getTypeName() + (inferredType ?"~":"") + ") "+name;
   }

   @Override
   public boolean equals(Object o) {
      if (this == o) return true;
      if (o == null || getClass() != o.getClass()) return false;
      Variable symbol = (Variable) o;
      if (!name.equals(symbol.name)) return false;
      return type == symbol.type;
   }

   @Override
   public int hashCode() {
      int result = name.hashCode();
      return result;
   }

}

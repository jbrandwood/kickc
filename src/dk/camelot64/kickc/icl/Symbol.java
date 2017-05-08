package dk.camelot64.kickc.icl;

/** A Symbol (variable, jump label, etc.) */
public class Symbol implements RValue, LValue {

   /** The name of the symbol. */
   private String name;

   /** The type of the symbol. VAR means tha type is unknown, and has not been inferred yet. */
   private SymbolType type;

   /** true if the symbol type is infered (not declared) */
   private boolean inferredType;

   /** true if this is an intermediate variable that is created as a part of evaluating an expression. */
   private boolean intermediate;

   /** If the symbol is a version of another symbol created during generation of single static assignment form (SSA) this contains the main symbol. */
   private Symbol versionOf;

   /** The number of the next version (if anyone versions this symbol)*/
   private Integer nextVersionNumber;

   public Symbol(String name, SymbolType type, boolean intermediate) {
      this.name = name;
      this.type = type;
      this.intermediate = intermediate;
      this.inferredType = false;
      this.versionOf = null;
      if(!intermediate) {
         this.nextVersionNumber = 0;
      }
   }

   Symbol(Symbol versionOf, int version) {
      this.name = versionOf.getName() + "#" + version;
      this.type = versionOf.getType();
      this.intermediate = versionOf.isIntermediate();
      this.inferredType = versionOf.isInferredType();
      this.versionOf = versionOf;
      this.nextVersionNumber = null;
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

   /** Get the version number of the next version. (if anyone versions the symbol). */
   int getNextVersionNumber() {
      return nextVersionNumber++;
   }

   @Override
   public String toString() {
      return "("+type.getTypeName() + (inferredType ?"*":"") + ") "+name;
   }

   @Override
   public boolean equals(Object o) {
      if (this == o) return true;
      if (o == null || getClass() != o.getClass()) return false;
      Symbol symbol = (Symbol) o;
      if (!name.equals(symbol.name)) return false;
      return type == symbol.type;
   }

   @Override
   public int hashCode() {
      int result = name.hashCode();
      return result;
   }

   public boolean isInferredType() {
      return inferredType;
   }

   public boolean isVersioned() {
      return versionOf != null;
   }

   public Symbol getVersionOf() {
      return versionOf;
   }
}

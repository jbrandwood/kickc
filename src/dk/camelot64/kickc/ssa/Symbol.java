package dk.camelot64.kickc.ssa;

/** A Symbol (variable, jump label, etc.) */
public class Symbol implements SSARValue, SSALValue, SSAFragment {

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
      return "("+name + (intermediate?"*":"") + ": " + type.getTypeName() + (inferredType ?"*":"") + ")";
   }

}

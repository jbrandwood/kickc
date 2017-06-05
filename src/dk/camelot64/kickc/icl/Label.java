package dk.camelot64.kickc.icl;

/** A jump label */
public class Label implements Symbol {

   /** The name of the label. */
   private String name;

   /** The name of the containing scope */
   private Scope scope;

   private boolean intermediate;

   public Label(String name, Scope scope, boolean intermediate) {
      this.name = name;
      this.scope = scope;
      this.intermediate = intermediate;
   }

   public String getLocalName() {
      return name;
   }

   @Override
   public Scope getScope() {
      return scope;
   }

   @Override
   public String getFullName() {
      return Scope.getFullName(this);
   }

   public boolean isIntermediate() {
      return intermediate;
   }

   public SymbolType getType() {
      return SymbolTypeBasic.LABEL;
   }

   public String getTypedName() {
      return "("+getType().getTypeName() + ") "+getFullName();
   }

   @Override
   public boolean equals(Object o) {
      if (this == o) return true;
      if (o == null || getClass() != o.getClass()) return false;

      Label label = (Label) o;

      if (intermediate != label.intermediate) return false;
      if (!name.equals(label.name)) return false;
      return scope != null ? scope.equals(label.scope) : label.scope == null;
   }

   @Override
   public int hashCode() {
      int result = name.hashCode();
      result = 31 * result + (scope != null ? scope.hashCode() : 0);
      result = 31 * result + (intermediate ? 1 : 0);
      return result;
   }

   @Override
   public String toString() {
      return getTypedName();
   }
}

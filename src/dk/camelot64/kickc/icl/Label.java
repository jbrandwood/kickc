package dk.camelot64.kickc.icl;

/** A Symbol (variable, jump label, etc.) */
public class Label implements Symbol {

   /** The name of the label. */
   private String name;

   private boolean intermediate;

   public Label(String name, boolean intermediate) {
      this.name = name;
      this.intermediate = intermediate;
   }

   public String getName() {
      return name;
   }

   public boolean isIntermediate() {
      return intermediate;
   }

   public SymbolType getType() {
      return SymbolTypeBasic.LABEL;
   }

   @Override
   public String toString() {
      return "("+getType().getTypeName() + ") "+name;
   }

   @Override
   public boolean equals(Object o) {
      if (this == o) {
         return true;
      }
      if (o == null || getClass() != o.getClass()) {
         return false;
      }

      Label that = (Label) o;

      return name.equals(that.name);
   }

   @Override
   public int hashCode() {
      return name.hashCode();
   }
}

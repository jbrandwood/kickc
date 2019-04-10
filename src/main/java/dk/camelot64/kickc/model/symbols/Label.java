package dk.camelot64.kickc.model.symbols;

import dk.camelot64.kickc.model.values.LabelRef;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.types.SymbolType;

/** A jump label */
public class Label implements Symbol {

   /** The name of the label. */
   private String name;

   /** The containing scope */
   private Scope scope;

   /** Full name of label (scope::name or name) */
   private String fullName;

   private boolean intermediate;

   public Label(String name, Scope scope, boolean intermediate) {
      this.name = name;
      this.scope = scope;
      this.intermediate = intermediate;
      setFullName();
   }

   private void setFullName() {
      String scopeName = (scope == null) ? "" : scope.getFullName();
      fullName = (scopeName.length() > 0) ? scopeName + "::" + name : name;
   }

   @Override
   public String getLocalName() {
      return name;
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

   @Override
   public String getFullName() {
      return fullName;
   }

   public boolean isIntermediate() {
      return intermediate;
   }

   public SymbolType getType() {
      return SymbolType.LABEL;
   }

   @Override
   public boolean equals(Object o) {
      if(this == o) return true;
      if(o == null || getClass() != o.getClass()) return false;

      Label label = (Label) o;

      if(intermediate != label.intermediate) return false;
      if(!name.equals(label.name)) return false;
      return getFullName().equals(label.getFullName());
   }

   @Override
   public int hashCode() {
      int result = getFullName().hashCode();
      result = 31 * result + (intermediate ? 1 : 0);
      return result;
   }

   @Override
   public String toString() {
      return toString(null);
   }

   @Override
   public String toString(Program program) {
      if(program == null) {
         return getFullName();
      } else {
         return "(" + getType().getTypeName() + ") " + getFullName();
      }
   }

   public LabelRef getRef() {
      return new LabelRef(this);
   }
}

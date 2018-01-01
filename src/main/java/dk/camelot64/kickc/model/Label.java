package dk.camelot64.kickc.model;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;

/** A jump label */
public class Label implements Symbol {

   /** The name of the label. */
   private String name;

   /** The containing scope */
   private Scope scope;

   private boolean intermediate;

   public Label(String name, Scope scope, boolean intermediate) {
      this.name = name;
      this.scope = scope;
      this.intermediate = intermediate;
   }

   @JsonCreator
   public Label(
         @JsonProperty("name") String name,
         @JsonProperty("intermediate") boolean intermediate) {
      this.name = name;
      this.scope = null;
      this.intermediate = intermediate;
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
      return Scope.getFullName(this);
   }

   public boolean isIntermediate() {
      return intermediate;
   }

   @JsonIgnore
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

   @JsonIgnore
   public LabelRef getRef() {
      return new LabelRef(this);
   }
}

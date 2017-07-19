package dk.camelot64.kickc.icl;

/** A reference to a variable from the symbol table */
public class VariableRef implements RValue, LValue {

   /** The full name of the variable. Allowing lookup in the symbol table. */
   private String fullName;

   public VariableRef(String fullName) {
      this.fullName = fullName;
   }

   public VariableRef(Variable variable) {
      this(variable.getFullName());
   }

   public String getFullName() {
      return fullName;
   }

   public void setFullName(String fullName) {
      this.fullName = fullName;
   }

   @Override
   public boolean equals(Object o) {
      if (this == o) {
         return true;
      }
      if (o == null || getClass() != o.getClass()) {
         return false;
      }

      VariableRef that = (VariableRef) o;

      return fullName != null ? fullName.equals(that.fullName) : that.fullName == null;
   }

   @Override
   public int hashCode() {
      return fullName != null ? fullName.hashCode() : 0;
   }

   @Override
   public String toString() {
      return getAsString();
   }

   @Override
   public String getAsTypedString(ProgramScope scope) {
      Variable variable = scope.getVariable(this);
      return variable.getTypedName();
   }

   @Override
   public String getAsString() {
      return fullName;
   }
}

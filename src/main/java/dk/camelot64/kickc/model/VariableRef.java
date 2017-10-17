package dk.camelot64.kickc.model;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;

/** A reference to a variable from the symbol table */
public class VariableRef extends SymbolRef implements RValue, LValue {

   @JsonCreator
   public VariableRef(
         @JsonProperty("fullName") String fullName) {
      super(fullName);
   }

   public VariableRef(Variable variable) {
      this(variable.getFullName());
   }

}

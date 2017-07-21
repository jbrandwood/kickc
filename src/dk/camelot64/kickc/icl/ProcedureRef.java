package dk.camelot64.kickc.icl;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;

/** A reference to a procedure */
public class ProcedureRef extends SymbolRef {

   @JsonCreator
   public ProcedureRef( @JsonProperty("fullName") String fullName) {
      super(fullName);
   }

   @JsonIgnore
   public LabelRef getLabelRef() {
      return new LabelRef(getFullName());
   }
}

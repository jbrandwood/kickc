package dk.camelot64.kickc.icl;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;

/** A reference to a procedure */
public class ProcedureRef extends ScopeRef {

   @JsonCreator
   public ProcedureRef( @JsonProperty("fullName") String fullName) {
      super(fullName);
   }

   /**
    * Get the label of the block where the procedure code starts
    * @return The label of the code block
    */
   @JsonIgnore
   public LabelRef getLabelRef() {
      return new LabelRef(getFullName());
   }

   /**
    * Get the label of the block containing the final procedure return
    * @return The label of the code block
    */
   @JsonIgnore
   public LabelRef getReturnBlock() {
      return new LabelRef(getFullName()+"::"+SymbolRef.PROCEXIT_BLOCK_NAME);
   }
}

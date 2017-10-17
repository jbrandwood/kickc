package dk.camelot64.kickc.model;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;

/**  A reference to a label */
public class LabelRef extends SymbolRef {

   @JsonCreator
   public LabelRef(
         @JsonProperty("fullName") String fullName) {
      super(fullName);
   }

   public LabelRef(Label label) {
      super(label.getFullName());
   }

}

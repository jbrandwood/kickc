package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.symbols.Label;

/** A reference to a label */
public class LabelRef extends SymbolRef {

   public LabelRef(String fullName) {
      super(fullName);
   }

   public LabelRef(Label label) {
      super(label.getFullName());
   }

}

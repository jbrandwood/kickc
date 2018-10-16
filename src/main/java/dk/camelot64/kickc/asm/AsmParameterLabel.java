package dk.camelot64.kickc.asm;

import dk.camelot64.kickc.model.values.LabelRef;

public class AsmParameterLabel implements AsmParameter {

   private LabelRef label;

   public AsmParameterLabel(LabelRef label) {
      this.label = label;
   }

   @Override
   public String getAsm() {
      return label.getLocalName().replace('@', 'b').replace(':', '_');
   }

}

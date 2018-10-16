package dk.camelot64.kickc.asm;

import dk.camelot64.kickc.model.values.LabelRef;

public class AsmParameterLabelTransition implements AsmParameter {

   private LabelRef fromLabel;
   private LabelRef toLabel;

   public AsmParameterLabelTransition(LabelRef fromLabel, LabelRef toLabel) {
      this.fromLabel = fromLabel;
      this.toLabel = toLabel;
   }

   @Override
   public String getAsm() {
      return (toLabel.getLocalName() + "_from_" + fromLabel.getLocalName()).replace('@', 'b').replace(':', '_');
   }

}

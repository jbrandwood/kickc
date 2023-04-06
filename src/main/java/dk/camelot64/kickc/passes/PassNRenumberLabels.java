package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.symbols.Label;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.symbols.Symbol;
import dk.camelot64.kickc.model.values.LabelRef;
import dk.camelot64.kickc.model.values.Value;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Renumber all labels in the program
 */
public class PassNRenumberLabels extends Pass2SsaOptimization {

   private boolean pass1;

   public PassNRenumberLabels(Program program, boolean pass1) {
      super(program);
      this.pass1 = pass1;
   }

   @Override
   public boolean step() {
      Map<LabelRef, LabelRef> renamed = new LinkedHashMap<>();
      renumberLabels(getProgramScope(), renamed);
      for(Scope scope : getProgramScope().getAllScopes(true)) {
         renumberLabels(scope, renamed);
      }
      ProgramValueIterator.execute(getGraph(), (programValue, currentStmt, stmtIt, currentBlock) -> {
               Value value = programValue.get();
               if(value instanceof LabelRef) {
                  LabelRef newLabelRef = renamed.get(value);
                  if(newLabelRef != null) {
                     programValue.set(newLabelRef);
                  }
               }
            }
      );
      return false;
   }

   private void renumberLabels(Scope scope, Map<LabelRef, LabelRef> renamed) {
      int labelIdx = 1;
      List<Label> oldLabels = new ArrayList<>();
      List<Label> newLabels = new ArrayList<>();
      for(Symbol symbol : scope.getAllSymbols()) {
         if(symbol instanceof Label) {
            Label oldLabel = (Label) symbol;
            if(oldLabel.isIntermediate()) {
               String newName = "@" + labelIdx++;
               if(!oldLabel.getLocalName().equals(newName)) {
                  Label newLabel = new Label(newName, scope, true);
                  oldLabels.add(oldLabel);
                  newLabels.add(newLabel);
                  renamed.put((oldLabel).getRef(), newLabel.getRef());
                  if(!pass1)
                     getLog().append("Renumbering block " + oldLabel.getFullName() + " to " + newLabel.getFullName());
               }
            }
         }
      }
      for(Label oldLabel : oldLabels) {
         scope.remove(oldLabel);
      }
      for(Label newLabel : newLabels) {
         scope.add(newLabel);
      }
      scope.setIntermediateLabelCount(labelIdx);
   }


}

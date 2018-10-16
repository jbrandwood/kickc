package dk.camelot64.kickc.model.symbols;

import dk.camelot64.kickc.model.types.SymbolType;

/**
 * A Scope that is a part of the call-graph.
 * This is the {@link ProgramScope} and {@link Procedure}
 */
public abstract class CallingScope extends Scope {

   private int intermediateVarCount = 0;
   private int intermediateLabelCount = 1;

   CallingScope(String name, Scope parentScope) {
      super(name, parentScope);
   }

   public String allocateIntermediateVariableName() {
      return "$" + intermediateVarCount++;
   }

   public String allocateIntermediateLabelName() {
      return "@" + intermediateLabelCount++;
   }

   public VariableIntermediate addVariableIntermediate() {
      String name = allocateIntermediateVariableName();
      VariableIntermediate symbol = new VariableIntermediate(name, this, SymbolType.VAR);
      add(symbol);
      return symbol;
   }


   public Label addLabelIntermediate() {
      String name = allocateIntermediateLabelName();
      Label symbol = new Label(name, this, true);
      add(symbol);
      return symbol;
   }


}

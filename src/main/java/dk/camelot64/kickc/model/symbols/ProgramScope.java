package dk.camelot64.kickc.model.symbols;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeProgram;

import java.util.HashMap;

/** The program scope containing the symbols of a program */
public class ProgramScope extends Scope {


   public ProgramScope() {
      super("", null);
   }

   private ProgramScope(
         String name,
         HashMap<String, Symbol> symbols,
         int intermediateVarCount,
         int intermediateLabelCount) {
      super(name, symbols, intermediateVarCount, intermediateLabelCount);
   }

   @Override
   public SymbolType getType() {
      return new SymbolTypeProgram();
   }

   public String getSymbolTableContents(Program program) {
      return toString(program, null);
   }

   @Override
   public String toString(Program program, Class symbolClass) {
      LiveRangeEquivalenceClassSet liveRangeEquivalenceClassSet = program.getLiveRangeEquivalenceClassSet();
      StringBuilder out = new StringBuilder();
      out.append(super.toString(program, symbolClass));
      if(liveRangeEquivalenceClassSet != null) {
         out.append("\n");
         for(LiveRangeEquivalenceClass liveRangeEquivalenceClass : liveRangeEquivalenceClassSet.getEquivalenceClasses()) {
            out.append(liveRangeEquivalenceClass);
            out.append("\n");
         }
      }
      return out.toString();
   }

   @Override
   public String toString(Program program) {
      return "program";
   }

}

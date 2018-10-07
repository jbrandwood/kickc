package dk.camelot64.kickc.model.symbols;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeProgram;
import dk.camelot64.kickc.model.values.CallingScopeRef;
import dk.camelot64.kickc.model.values.ProgramScopeRef;
import dk.camelot64.kickc.model.values.ScopeRef;

import java.util.HashMap;

/** The program scope containing the symbols of a program */
public class ProgramScope extends CallingScope  {

   public ProgramScope() {
      super(ProgramScopeRef.PROGRAM_SCOPE_NAME, null);
   }

   @Override
   public SymbolType getType() {
      return new SymbolTypeProgram();
   }

   @Override
   public ProgramScopeRef getRef() {
      return ProgramScopeRef.ROOT;
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

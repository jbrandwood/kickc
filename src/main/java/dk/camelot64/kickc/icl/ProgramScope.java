package dk.camelot64.kickc.icl;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.HashMap;

/** The program scope containing the symbols of a program */
public class ProgramScope extends Scope {


   public ProgramScope() {
      super("", null);
   }

   @JsonCreator
   private ProgramScope(
         @JsonProperty("name") String name,
         @JsonProperty("symbols") HashMap<String, Symbol> symbols,
         @JsonProperty("intermediateVarCount") int intermediateVarCount,
         @JsonProperty("intermediateLabelCount") int intermediateLabelCount) {
      super(name, symbols, intermediateVarCount, intermediateLabelCount);
   }

   @Override
   public SymbolType getType() {
      return new SymbolTypeProgram();
   }

   @JsonIgnore
   public String getSymbolTableContents(Program program) {
      return getSymbolTableContents(program, null);
   }

   @Override
   public String getSymbolTableContents(Program program, Class symbolClass) {
      LiveRangeEquivalenceClassSet liveRangeEquivalenceClassSet = program.getLiveRangeEquivalenceClassSet();
      StringBuilder out = new StringBuilder();
      out.append(super.getSymbolTableContents(program, symbolClass));
      if(liveRangeEquivalenceClassSet!=null) {
         out.append("\n");
         for (LiveRangeEquivalenceClass liveRangeEquivalenceClass : liveRangeEquivalenceClassSet.getEquivalenceClasses()) {
            out.append(liveRangeEquivalenceClass);
            out.append("\n");
         }
      }
      return out.toString();
   }

   @Override
   public LabelRef getScopeLabelRef() {
      return new LabelRef("");
   }

   @Override
   public String toString(Program program) {
      return "program";
   }

}

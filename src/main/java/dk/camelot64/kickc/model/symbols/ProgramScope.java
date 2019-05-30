package dk.camelot64.kickc.model.symbols;

import dk.camelot64.kickc.model.LiveRangeEquivalenceClass;
import dk.camelot64.kickc.model.LiveRangeEquivalenceClassSet;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeInference;
import dk.camelot64.kickc.model.types.SymbolTypeProgram;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;
import dk.camelot64.kickc.model.values.RValue;
import dk.camelot64.kickc.model.values.StructMemberRef;

/** The program scope containing the symbols of a program */
public class ProgramScope extends Scope {


   public ProgramScope() {
      super("", null);
   }

   @Override
   public SymbolType getType() {
      return new SymbolTypeProgram();
   }


   /**
    * Get the struct definition for a struct
    * @param structMemberRef
    * @return
    */
   public StructDefinition getStructDefinition(StructMemberRef structMemberRef) {
      RValue struct = structMemberRef.getStruct();
      SymbolType structType = SymbolTypeInference.inferType(this, struct);
      String structTypeName = ((SymbolTypeStruct) structType).getStructTypeName();
      StructDefinition structDefinition = getStructDefinition(structTypeName);
      return structDefinition;
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

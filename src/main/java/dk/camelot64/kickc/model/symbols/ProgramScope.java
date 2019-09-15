package dk.camelot64.kickc.model.symbols;

import dk.camelot64.kickc.model.LiveRangeEquivalenceClass;
import dk.camelot64.kickc.model.LiveRangeEquivalenceClassSet;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeProgram;

/** The program scope containing the symbols of a program */
public class ProgramScope extends Scope {


   public ProgramScope() {
      super("", null, Scope.SEGMENT_DATA_DEFAULT);
   }

   @Override
   public SymbolType getType() {
      return new SymbolTypeProgram();
   }


   @Override
   public String toString(Program program, Class symbolClass) {
      LiveRangeEquivalenceClassSet liveRangeEquivalenceClassSet = program.getLiveRangeEquivalenceClassSet();
      StringBuilder out = new StringBuilder();
      out.append(super.toString(program, symbolClass));
      if(liveRangeEquivalenceClassSet != null) {
         out.append("\n");
         for(LiveRangeEquivalenceClass liveRangeEquivalenceClass : liveRangeEquivalenceClassSet.getEquivalenceClasses()) {
            out.append(liveRangeEquivalenceClass.toString());
            out.append("\n");
         }
      }
      return out.toString();
   }

   @Override
   public String toString(Program program) {
      return "program";
   }

   private TypeDefsScope typeDefsScope = new TypeDefsScope("typedefs", this);

   public Scope getTypeDefScope() {
      return typeDefsScope;
   }

   /**
    * Get information about the size of the program
    * @return Size information
    */
   public String getSizeInfo() {
      StringBuilder sizeInfo = new StringBuilder();
      sizeInfo.append("SIZE procedures "+ getAllProcedures(true).size()).append("\n");
      sizeInfo.append("SIZE scopes "+ getAllScopes(true).size()).append("\n");
      sizeInfo.append("SIZE variables "+ getAllVariables(true).size()).append("\n");
      sizeInfo.append("SIZE constants  "+ getAllConstants(true).size()).append("\n");
      return sizeInfo.toString();
   }
}

package dk.camelot64.kickc.model.values;

/**
 * The program scope reference
 */
public class ProgramScopeRef extends CallingScopeRef {

   /** The (full) name of the PROGRAM scope. */
   public static final String PROGRAM_SCOPE_NAME = "";

   ProgramScopeRef() {
      super(PROGRAM_SCOPE_NAME);
   }

   /** The ROOT scope of the program. */
   public static final ProgramScopeRef ROOT = new ProgramScopeRef();

}

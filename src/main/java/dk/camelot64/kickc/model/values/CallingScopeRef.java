package dk.camelot64.kickc.model.values;

/**
 * Scope references that are part of the call-graph.
 * This is the Program Scope Reference and {@link ProcedureRef}
 */
public abstract class CallingScopeRef extends ScopeRef {

   public CallingScopeRef(String fullName) {
      super(fullName);
   }

}

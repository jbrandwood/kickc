package dk.camelot64.kickc.model.symbols;

/**
 * A Scope that is a part of the call-graph.
 * This is the {@link ProgramScope} and {@link Procedure}
 */
public abstract class CallingScope extends Scope {

   CallingScope(String name, Scope parentScope) {
      super(name, parentScope);
   }

}

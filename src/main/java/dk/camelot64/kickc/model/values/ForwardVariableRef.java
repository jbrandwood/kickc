package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.Program;

/** An unresolved forward variable reference.
 * Created in {@link dk.camelot64.kickc.passes.Pass0GenerateStatementSequence}.
 * Resolved in {@link dk.camelot64.kickc.passes.Pass1ResolveForwardReferences}.
 * After this point they are never present in the program.
 * */
public class ForwardVariableRef extends SymbolVariableRef implements LValue {

   /** The referenced unresolved variable name. */
   private String name;

   public ForwardVariableRef(String name) {
      super(name);
      this.name = name;
   }

   public String getName() {
      return name;
   }

   @Override
   public String toString(Program program) {
      return name;
   }
}

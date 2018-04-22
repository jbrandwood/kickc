package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.Program;

/** An unresolved forward variable reference.
 * Created in {@link dk.camelot64.kickc.passes.Pass0GenerateStatementSequence}.
 * Resolved in {@link }.
 * After this point they are never present in the program.
 * */
public class ForwardVariableRef implements RValue {

   /** The referenced unresolved variable name. */
   private String name;

   public ForwardVariableRef(String name) {
      this.name = name;
   }

   public String getName() {
      return name;
   }

   @Override
   public String toString(Program program) {
      return null;
   }
}

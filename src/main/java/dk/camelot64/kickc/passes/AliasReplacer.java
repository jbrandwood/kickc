package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.iterator.ReplaceableValue;
import dk.camelot64.kickc.model.iterator.Replacer;
import dk.camelot64.kickc.model.iterator.ValueReplacer;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.values.RValue;
import dk.camelot64.kickc.model.values.SymbolRef;

import java.util.ListIterator;
import java.util.Map;

/** A {@link ValueReplacer} that replaces symbols with their alias. */
public class AliasReplacer implements Replacer {


   /** true if anything has ben replaced. */
   private boolean replaced;

   /** The alias map. */
   private Map<? extends SymbolRef, ? extends RValue> aliases;

   public AliasReplacer(Map<? extends SymbolRef, ? extends RValue> aliases) {
      this.aliases = aliases;
      this.replaced = false;
   }

   public boolean isReplaced() {
      return replaced;
   }

   /**
    * Execute alias replacement on a replaceable value
    *
    * @param replaceable The replaceable value
    */
   @Override
   public void execute(ReplaceableValue replaceable, Statement currentStmt, ListIterator<Statement> stmtIt, ControlFlowBlock currentBlock) {
      if(replaceable.get() != null) {
         RValue replacement = getReplacement(replaceable.get(), aliases);
         if(replacement != null) {
            replaceable.set(replacement);
            this.replaced = true;
         }
      }
   }

   /**
    * Get the alias to use for an RValue.
    * Also looks inside any constant values for replacements.
    * If a replacement is found the replacement is performed and the new value is returned. If no replacement is found null is returned.
    *
    * @param rValue The RValue to find an alias for
    * @return The alias to use. Null if no alias exists.
    */
   private static RValue getReplacement(RValue rValue, Map<? extends SymbolRef, ? extends RValue> aliases) {
      if(rValue instanceof SymbolRef) {
         RValue alias = aliases.get(rValue);
         if(alias != null) {
            RValue replacement = getReplacement(alias, aliases);
            if(replacement != null) {
               return replacement;
            } else {
               return alias;
            }
         }
      }
      return null;
   }

}

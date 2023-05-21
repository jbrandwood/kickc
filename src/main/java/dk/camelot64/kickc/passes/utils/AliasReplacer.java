package dk.camelot64.kickc.passes.utils;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Graph;
import dk.camelot64.kickc.model.iterator.ProgramValue;
import dk.camelot64.kickc.model.iterator.ProgramValueHandler;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.values.RValue;
import dk.camelot64.kickc.model.values.SymbolRef;
import dk.camelot64.kickc.model.values.Value;

import java.util.ListIterator;
import java.util.Map;

/** A {@link ProgramValueIterator} that replaces symbols with their alias. */
public class AliasReplacer implements ProgramValueHandler {

   /** true if anything has been replaced. */
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
    * Execute alias replacement on a value
    *
    * @param programValue The value
    */
   @Override
   public void execute(ProgramValue programValue, Statement currentStmt, ListIterator<Statement> stmtIt, Graph.Block currentBlock) {
      if(programValue.get() != null) {
         Value replacement = getReplacement(programValue.get(), aliases, 0);
         if(replacement != null) {
            // System.out.println("Replacing "+programValue.get() + " with " +replacement + " in " +currentStmt);
            programValue.set(replacement);
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
   private static RValue getReplacement(Value rValue, Map<? extends SymbolRef, ? extends RValue> aliases, int depth) {
      if(depth>50) {
         StringBuilder aliasList = new StringBuilder();
         Value rVal = rValue;
         do {
            aliasList.append(rVal.toString()).append(" > ");
            rVal = aliases.get(rVal);
         } while(rVal!=rValue);
         aliasList.append(rVal.toString());
         throw new InternalError("Error! Recursive aliases: "+aliasList);
      }
      if(rValue instanceof SymbolRef) {
         RValue alias = aliases.get(rValue);
         if(alias != null) {
            RValue replacement = getReplacement(alias, aliases, depth+1);
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

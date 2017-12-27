package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;

import java.util.ArrayList;
import java.util.ListIterator;
import java.util.Map;

/** A {@link ValueReplacer} that replaces symbols with their alias. */
public class AliasReplacer implements ValueReplacer.Replacer {

   private Map<? extends SymbolRef, ? extends RValue> aliases;

   public AliasReplacer(Map<? extends SymbolRef, ? extends RValue> aliases) {
      this.aliases = aliases;
   }

   /**
    * Get the alias to use for an RValue.
    * Also looks inside any constant values for replacements.
    * If a replacement is found the replacement is performed and the new value is returned. If no replacement is found null is returned.
    *
    * @param rValue The RValue to find an alias for
    * @return The alias to use. Null if no alias exists.
    */
   public static RValue getReplacement(RValue rValue, Map<? extends SymbolRef, ? extends RValue> aliases) {
      if (rValue instanceof SymbolRef) {
         RValue alias = aliases.get(rValue);
         if (alias != null) {
            if (alias.equals(rValue)) {
               return alias;
            }
            RValue replacement = getReplacement(alias, aliases);
            if (replacement != null) {
               return replacement;
            } else {
               return alias;
            }
         }
      } else if (rValue instanceof ConstantUnary) {
         ConstantUnary constantUnary = (ConstantUnary) rValue;
         ConstantValue alias = (ConstantValue) getReplacement(constantUnary.getOperand(), aliases);
         if (alias != null) {
            return new ConstantUnary(constantUnary.getOperator(), alias);
         }
      } else if (rValue instanceof ConstantBinary) {
         ConstantBinary constantBinary = (ConstantBinary) rValue;
         ConstantValue aliasLeft = (ConstantValue) getReplacement(constantBinary.getLeft(), aliases);
         ConstantValue aliasRight = (ConstantValue) getReplacement(constantBinary.getRight(), aliases);
         if (aliasLeft != null || aliasRight != null) {
            if (aliasLeft == null) {
               aliasLeft = constantBinary.getLeft();
            }
            if (aliasRight == null) {
               aliasRight = constantBinary.getRight();
            }
            return new ConstantBinary(aliasLeft, constantBinary.getOperator(), aliasRight);
         }
      } else if (rValue instanceof ConstantArray) {
         ConstantArray constantArray = (ConstantArray) rValue;
         ArrayList<ConstantValue> replacementList = new ArrayList<>();
         boolean any = false;
         for (ConstantValue elemValue : constantArray.getElements()) {
            RValue elemReplacement = getReplacement(elemValue, aliases);
            if (elemReplacement != null) {
               replacementList.add((ConstantValue) elemReplacement);
               any = true;
            } else {
               replacementList.add(elemValue);
            }
         }
         if (any) {
            return new ConstantArray(replacementList, constantArray.getElementType());
         }
      }

      // No replacement found - return null
      return null;

   }

   /**
    * Execute alias replacement on a replaceable value
    * @param replaceable The replaceable value
    */
   @Override
   public void execute(ValueReplacer.ReplaceableValue replaceable, Statement currentStmt, ListIterator<Statement> stmtIt, ControlFlowBlock currentBlock) {
      if (replaceable.get() != null) {
         RValue replacement = getReplacement(replaceable.get(), aliases);
         if (replacement != null) {
            replaceable.set(replacement);
         }
      }
   }

}

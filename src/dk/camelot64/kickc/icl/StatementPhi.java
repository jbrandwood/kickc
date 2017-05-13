package dk.camelot64.kickc.icl;

import java.util.ArrayList;
import java.util.List;

/**
 * Single Static Assignment Form Phi Statement.
 * Selects appropriate value of a variable based on the actual control flow.
 * <br>
 * <i> X<sub>i</sub> := phi(X<sub>j</sub>, X<sub>k</sub>, ...) </i>
 */
public class StatementPhi implements Statement {

   /** The versioned variable being assigned a value by the statement. */
   private VariableVersion lValue;

   /** The previous version of the symbol from predeccesor control blocks. */
   private List<PreviousSymbol> previousVersions;

   public StatementPhi(VariableVersion lValue) {
      this.lValue = lValue;
      this.previousVersions = new ArrayList<>();
   }

   /**
    * A previous version of the symbol that the phi function might take its value from.
    * Which value is chosen depends on which block transition was made.
    */
   public static class PreviousSymbol {
      private ControlFlowBlock block;
      private VariableVersion symbol;

      public PreviousSymbol(ControlFlowBlock block, VariableVersion symbol) {
         this.block = block;
         this.symbol = symbol;
      }

      public ControlFlowBlock getBlock() {
         return block;
      }

      public Symbol getSymbol() {
         return symbol;
      }


   }

   public VariableVersion getlValue() {
      return lValue;
   }

   public void addPreviousVersion(ControlFlowBlock block, VariableVersion symbol) {
      previousVersions.add(new PreviousSymbol(block, symbol));
   }

   public List<PreviousSymbol> getPreviousVersions() {
      return previousVersions;
   }

   @Override
   public String toString() {
      StringBuilder out = new StringBuilder();
      out.append(lValue + " ← " + "phi(");
      for (PreviousSymbol previousSymbol : previousVersions) {
         out.append(" "+previousSymbol.getBlock().getLabel().getName()+"/"+previousSymbol.getSymbol().getName());
      }
      out.append(" )");
      return out.toString();
   }

}

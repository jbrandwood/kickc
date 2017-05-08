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
   private Symbol lValue;

   /** The previous version of the symbol from predeccesor control blocks. */
   private List<Symbol> previousVersions;


   public StatementPhi(Symbol lValue) {
      this.lValue = lValue;
      this.previousVersions = new ArrayList<>();
   }

   public LValue getlValue() {
      return lValue;
   }

   public void addPreviousVersion(Symbol previousVersion) {
      previousVersions.add(previousVersion);
   }

   public List<Symbol> getPreviousVersions() {
      return previousVersions;
   }

   @Override
   public String toString() {
      StringBuilder out = new StringBuilder();
      out.append(lValue + " ← " + "phi(");
      for (Symbol previousVersion : previousVersions) {
         out.append(" "+previousVersion.toString());
      }
      out.append(" )");
      return out.toString();
   }

}

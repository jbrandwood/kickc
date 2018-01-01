package dk.camelot64.kickc.model;

import com.ibm.icu.text.NumberFormat;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Locale;

/** Register Uplift information for a single scope. */
public class RegisterUpliftScope {

   /** The scope. */
   private ScopeRef scopeRef;

   /**
    * Live Range Equivalence Classes in the scope sorted by total variable register weight.
    */
   private List<LiveRangeEquivalenceClass> equivalenceClasses;

   public RegisterUpliftScope(ScopeRef scopeRef) {
      this.scopeRef = scopeRef;
      this.equivalenceClasses = new ArrayList<>();
   }

   public ScopeRef getScopeRef() {
      return scopeRef;
   }

   public Collection<LiveRangeEquivalenceClass> getEquivalenceClasses() {
      return equivalenceClasses;
   }

   public void setEquivalenceClasses(List<LiveRangeEquivalenceClass> equivalenceClasses) {
      this.equivalenceClasses = equivalenceClasses;
   }

   public String toString(VariableRegisterWeights weights) {
      StringBuilder out = new StringBuilder();
      out.append("Uplift Scope [" + scopeRef.toString() + "] ");
      for(LiveRangeEquivalenceClass equivalenceClass : equivalenceClasses) {
         if(weights != null) {
            NumberFormat fmt = NumberFormat.getInstance(Locale.ENGLISH);
            fmt.setMaximumFractionDigits(2);
            out.append(fmt.format(weights.getTotalWeight(equivalenceClass)) + ": ");
         }
         out.append(equivalenceClass.toString() + " ");
      }
      return out.toString();
   }

   @Override
   public String toString() {
      return toString(null);
   }

   /**
    * Get all register allocation combinations using the passed potential registers
    *
    * @param registerPotentials The potential registers to use for each live range equivalence class
    * @return Iterator of all combinations
    */
   public RegisterCombinationIterator getCombinationIterator(RegisterPotentials registerPotentials) {
      return new RegisterCombinationIterator(equivalenceClasses, registerPotentials);
   }

}

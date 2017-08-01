package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.icl.*;

import java.util.*;

/*** Find the variable equivalence classes to attempt to uplift in each scope */
public class Pass3RegisterUpliftScopeAnalysis extends Pass2Base {

   public Pass3RegisterUpliftScopeAnalysis(Program program) {
      super(program);
   }

   /*** Find the variable equivalence classes to attempt to uplift in each scope */
   public void findScopes() {
      LiveRangeEquivalenceClassSet equivalenceClassSet = getProgram().getLiveRangeEquivalenceClassSet();
      final VariableRegisterWeights registerWeights = getProgram().getVariableRegisterWeights();

      RegisterUpliftProgram registerUpliftProgram = new RegisterUpliftProgram();

      Collection<Scope> allScopes = getProgram().getScope().getAllScopes(true);
      allScopes.add(getSymbols());
      for (Scope scope : allScopes) {
         LabelRef scopeLabel = scope.getScopeLabelRef();
         RegisterUpliftScope registerUpliftScope = registerUpliftProgram.addRegisterUpliftScope(scopeLabel);

         // Find live range equivalence classes for the scope
         List<LiveRangeEquivalenceClass> equivalenceClasses = new ArrayList<>();
         for (LiveRangeEquivalenceClass equivalenceClass : equivalenceClassSet.getEquivalenceClasses()) {
            VariableRef variableRef = equivalenceClass.getVariables().get(0);
            if (variableRef.getScopeNames().equals(scopeLabel.getFullName())) {
               equivalenceClasses.add(equivalenceClass);
            }
         }
         Collections.sort(equivalenceClasses, new Comparator<LiveRangeEquivalenceClass>() {
            @Override
            public int compare(LiveRangeEquivalenceClass o1, LiveRangeEquivalenceClass o2) {
               return Double.compare(registerWeights.getTotalWeight(o2), registerWeights.getTotalWeight(o1));
            }
         });
         registerUpliftScope.setEquivalenceClasses(equivalenceClasses);
      }
      getProgram().setRegisterUpliftProgram(registerUpliftProgram);
   }


}

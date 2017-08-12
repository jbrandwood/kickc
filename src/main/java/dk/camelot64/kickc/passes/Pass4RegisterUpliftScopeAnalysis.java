package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.icl.*;

import java.util.*;

/*** Find the variable equivalence classes to attempt to uplift in each scope */
public class Pass4RegisterUpliftScopeAnalysis extends Pass2Base {

   public Pass4RegisterUpliftScopeAnalysis(Program program) {
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
         ScopeRef scopeRef = scope.getRef();
         RegisterUpliftScope registerUpliftScope = registerUpliftProgram.addRegisterUpliftScope(scopeRef);

         // Find live range equivalence classes for the scope
         List<LiveRangeEquivalenceClass> equivalenceClasses = new ArrayList<>();
         for (LiveRangeEquivalenceClass equivalenceClass : equivalenceClassSet.getEquivalenceClasses()) {
            VariableRef variableRef = equivalenceClass.getVariables().get(0);
            if (variableRef.getScopeNames().equals(scopeRef.getFullName())) {
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


      List<RegisterUpliftScope> upliftScopes = registerUpliftProgram.getRegisterUpliftScopes();
      Collections.sort(upliftScopes, new Comparator<RegisterUpliftScope>() {
         @Override
         public int compare(RegisterUpliftScope o1, RegisterUpliftScope o2) {
            return Double.compare(registerWeights.getTotalWeights(o2),registerWeights.getTotalWeights(o1));
         }
      });
      registerUpliftProgram.setRegisterUpliftScopes(upliftScopes);

      getProgram().setRegisterUpliftProgram(registerUpliftProgram);
   }


}

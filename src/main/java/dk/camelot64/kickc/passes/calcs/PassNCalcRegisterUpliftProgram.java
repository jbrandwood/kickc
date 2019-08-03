package dk.camelot64.kickc.passes.calcs;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.values.ScopeRef;
import dk.camelot64.kickc.model.values.VariableRef;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.List;

/*** Find the variable equivalence classes to attempt to uplift in each scope */
public class PassNCalcRegisterUpliftProgram extends PassNCalcBase<RegisterUpliftProgram> {

   public PassNCalcRegisterUpliftProgram(Program program) {
      super(program);
   }


   /*** Find the variable equivalence classes to attempt to uplift in each scope */
   @Override
   public RegisterUpliftProgram calculate() {
      LiveRangeEquivalenceClassSet equivalenceClassSet = getProgram().getLiveRangeEquivalenceClassSet();
      final VariableRegisterWeights registerWeights = getProgram().getVariableRegisterWeights();

      RegisterUpliftProgram registerUpliftProgram = new RegisterUpliftProgram();
      Collection<Scope> allScopes = getProgram().getScope().getAllScopes(true);
      allScopes.add(getScope());
      for(Scope scope : allScopes) {
         ScopeRef scopeRef = scope.getRef();
         RegisterUpliftScope registerUpliftScope = registerUpliftProgram.addRegisterUpliftScope(scopeRef);
         // Find live range equivalence classes for the scope
         List<LiveRangeEquivalenceClass> equivalenceClasses = new ArrayList<>();
         for(LiveRangeEquivalenceClass equivalenceClass : equivalenceClassSet.getEquivalenceClasses()) {
            VariableRef variableRef = equivalenceClass.getVariables().get(0);
            if(variableRef.getScopeNames().equals(scopeRef.getFullName())) {
               equivalenceClasses.add(equivalenceClass);
            }
         }
         Collections.sort(equivalenceClasses, (o1, o2) -> Double.compare(registerWeights.getTotalWeight(o2), registerWeights.getTotalWeight(o1)));
         registerUpliftScope.setEquivalenceClasses(equivalenceClasses);
      }

      List<RegisterUpliftScope> upliftScopes = registerUpliftProgram.getRegisterUpliftScopes();
      Collections.sort(upliftScopes, (o1, o2) -> Double.compare(registerWeights.getTotalWeights(o2), registerWeights.getTotalWeights(o1)));
      registerUpliftProgram.setRegisterUpliftScopes(upliftScopes);

      return registerUpliftProgram;
   }


}

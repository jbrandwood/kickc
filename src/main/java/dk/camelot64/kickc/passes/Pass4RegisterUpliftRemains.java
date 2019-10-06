package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.values.VariableRef;
import dk.camelot64.kickc.model.symbols.Scope;

import java.util.*;

/*** For each non-uplifted equivalence class attempt to put it in a register */
public class Pass4RegisterUpliftRemains extends Pass2Base {

   public Pass4RegisterUpliftRemains(Program program) {
      super(program);
   }

   public void performUplift(int maxCombinations) {

      LiveRangeEquivalenceClassSet equivalenceClassSet = getProgram().getLiveRangeEquivalenceClassSet();
      List<LiveRangeEquivalenceClass> equivalenceClasses = new ArrayList<>(equivalenceClassSet.getEquivalenceClasses());
      final VariableRegisterWeights registerWeights = getProgram().getVariableRegisterWeights();
      Collections.sort(equivalenceClasses, (o1, o2) -> Double.compare(registerWeights.getTotalWeight(o2), registerWeights.getTotalWeight(o1)));

      Set<String> unknownFragments = new LinkedHashSet<>();

      for(LiveRangeEquivalenceClass equivalenceClass : equivalenceClasses) {
         Registers.Register register = equivalenceClass.getRegister();
         boolean isByte1 = register.getType().equals(Registers.RegisterType.ZP_BYTE);
         boolean isByte2 = register instanceof Registers.RegisterZpMem && ((Registers.RegisterZpMem) register).getBytes()==1;
         if(isByte1 || isByte2) {
            getLog().append("Attempting to uplift remaining variables in" + equivalenceClass);
            RegisterCombinationIterator combinationIterator = new RegisterCombinationIterator(Arrays.asList(equivalenceClass), getProgram().getRegisterPotentials());
            VariableRef variableRef = equivalenceClass.getVariables().get(0);
            Scope testedScope = getProgram().getSymbolInfos().getVariable(variableRef).getScope();
            Pass4RegisterUpliftCombinations.chooseBestUpliftCombination(combinationIterator, maxCombinations, unknownFragments, testedScope.getRef(), getProgram());
         }
      }

      if(unknownFragments.size() > 0) {
         getLog().append("MISSING FRAGMENTS");
         for(String unknownFragment : unknownFragments) {
            getLog().append("  " + unknownFragment);
         }
      }

   }

}

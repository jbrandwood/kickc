package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.icl.*;

import java.util.Arrays;
import java.util.List;

/*** Uplift one variable into the A register - and check if the program still works */
public class Pass3RegisterUpliftTest extends Pass2Base {

   public Pass3RegisterUpliftTest(Program program) {
      super(program);
   }

   /** Uplift variables to registers */
   public void uplift() {
      VariableRegisterWeights variableRegisterWeights = getProgram().getVariableRegisterWeights();
      LiveRangeEquivalenceClassSet equivalenceClassSet = getProgram().getLiveRangeEquivalenceClassSet();

      double maxWeight = 0.0;
      LiveRangeEquivalenceClass maxEquivalenceClass = null;

      // Find the live range equivalence class with the highest total weight
      for (LiveRangeEquivalenceClass equivalenceClass : equivalenceClassSet.getEquivalenceClasses()) {
         double totalWeight = 0.0;
         List<VariableRef> vars = equivalenceClass.getVariables();
         for (VariableRef var : vars) {
            Double varWeight = variableRegisterWeights.getWeight(var);
            totalWeight += varWeight;
         }
         if (maxWeight < totalWeight) {
            maxEquivalenceClass = equivalenceClass;
            maxWeight = totalWeight;
         }
      }

      if (maxEquivalenceClass != null) {
         getLog().append("Uplifting max weight " + maxWeight + " live range equivalence class " + maxEquivalenceClass);
         // Try the A register first
         List<RegisterAllocation.Register> registers =
               Arrays.asList(
                     RegisterAllocation.getRegisterA(),
                     RegisterAllocation.getRegisterX(),
                     RegisterAllocation.getRegisterY());
         for (RegisterAllocation.Register register : registers) {
            attemptUplift(maxEquivalenceClass, register);
         }
      }

      RegisterAllocation allocation = getProgram().getLiveRangeEquivalenceClassSet().createRegisterAllocation();
      getProgram().setAllocation(allocation);

   }

   private void attemptUplift(LiveRangeEquivalenceClass equivalenceClass, RegisterAllocation.Register register) {
      RegisterAllocation allocation = getProgram().getLiveRangeEquivalenceClassSet().createRegisterAllocation();
      for (VariableRef var : equivalenceClass.getVariables()) {
         allocation.setRegister(var, register);
      }
      getProgram().setAllocation(allocation);
      new Pass4CodeGeneration(getProgram()).generate();
      Pass4AssertNoCpuClobber clobber = new Pass4AssertNoCpuClobber(getProgram());
      if (clobber.hasClobberProblem(false)) {
         getLog().append("Uplift to " + register + " resulted in clobber.");
      } else {
         getLog().append("Uplift to " + register + " succesfull.");
      }
   }


}

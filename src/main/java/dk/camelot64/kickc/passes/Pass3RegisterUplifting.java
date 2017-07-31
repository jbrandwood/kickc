package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.asm.AsmProgram;
import dk.camelot64.kickc.asm.parser.AsmClobber;
import dk.camelot64.kickc.icl.*;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;

/*** Uplift one variable into the A register - and check if the program still works */
public class Pass3RegisterUplifting {

   private Program program;
   private CompileLog log;

   public Pass3RegisterUplifting(Program program, CompileLog log) {
      this.program = program;
      this.log = log;
   }

   public Program getProgram() {
      return program;
   }

   public CompileLog getLog() {
      return log;
   }

   /**
    * Uplift one variable
    */
   public void uplift() {
      VariableRegisterWeights variableRegisterWeights = program.getScope().getVariableRegisterWeights();
      LiveRangeEquivalenceClassSet equivalenceClassSet = program.getScope().getLiveRangeEquivalenceClassSet();

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
         log.append("Uplifting max weight " + maxWeight + " live range equivalence class " + maxEquivalenceClass);
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

      RegisterAllocation allocation = program.getScope().getLiveRangeEquivalenceClassSet().createRegisterAllocation();
      program.getScope().setAllocation(allocation);

   }

   private void attemptUplift(LiveRangeEquivalenceClass equivalenceClass, RegisterAllocation.Register register) {
      RegisterAllocation allocation = program.getScope().getLiveRangeEquivalenceClassSet().createRegisterAllocation();
      for (VariableRef var : equivalenceClass.getVariables()) {
         allocation.setRegister(var, register);
      }
      program.getScope().setAllocation(allocation);
      Pass3AssertNoCpuClobber clobber = new Pass3AssertNoCpuClobber(program, log);
      if (clobber.hasClobberProblem(false, register)) {
         log.append("Uplift to " + register + " resulted in clobber.");
      } else {
         log.append("Uplift to " + register + " succesfull.");
      }
   }


}

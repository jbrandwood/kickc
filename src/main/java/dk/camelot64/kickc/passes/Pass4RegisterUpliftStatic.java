package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;

import java.util.HashSet;

/*** Find the variable equivalence classes to attempt to uplift in each scope */
public class Pass4RegisterUpliftStatic extends Pass2Base {

   public Pass4RegisterUpliftStatic(Program program) {
      super(program);
   }

   public void performUplift() {

      RegisterCombination combination = new RegisterCombination();
      /*
      // Combination with a live range overlap issue in liverange.kc
      setRegister(combination, "i#0", Registers.getRegisterX());
      setRegister(combination, "i#1", Registers.getRegisterX());
      setRegister(combination, "i#11", Registers.getRegisterX());
      setRegister(combination, "main::a#0", Registers.getRegisterA());
      setRegister(combination, "main::a#1", Registers.getRegisterA());
      setRegister(combination, "main::a#2", Registers.getRegisterA());
      setRegister(combination, "main::$0", Registers.getRegisterA());
      setRegister(combination, "main::$2", Registers.getRegisterA());
      setRegister(combination, "inc::return#0", Registers.getRegisterA());
      */

      /*
      setRegister(combination, "cnt#12", Registers.getRegisterX());
      setRegister(combination, "cnt2#11", Registers.getRegisterY());
      setRegister(combination, "cnt3#11", new Registers.RegisterZpByte(4));
      setRegister(combination, "cnt#1", Registers.getRegisterX());
      setRegister(combination, "main::$0", Registers.getRegisterA());
      setRegister(combination, "main::$1", Registers.getRegisterA());
      setRegister(combination, "inccnt::return#0", Registers.getRegisterA());
      */

      // Good combination for liverange.kc
      /*
      setRegister(combination, "inc::$0", Registers.getRegisterX());
      setRegister(combination, "main::$0", Registers.getRegisterA());
      setRegister(combination, "inc::return#0", Registers.getRegisterA());
      setRegister(combination, "main::a#1", new Registers.RegisterZpByte(2));
      setRegister(combination, "main::$2", Registers.getRegisterA());
      setRegister(combination, "main::a#2", Registers.getRegisterA());
      setRegister(combination, "i#11", Registers.getRegisterX());
      setRegister(combination, "inc::$0", Registers.getRegisterX());
      */

      // Clobber combination for scroll-clobber.kc
      /*
      setRegister(combination, "main::c#0", Registers.getRegisterA());
      setRegister(combination, "main::c#1", Registers.getRegisterA());
      setRegister(combination, "main::c#2", Registers.getRegisterA());
      setRegister(combination, "main::i#1", Registers.getRegisterX());
      setRegister(combination, "main::i#3", Registers.getRegisterX());
      setRegister(combination, "main::nxt#1", new Registers.RegisterZpPointerByte(2));
      */

      // ALU combination plotter ORA in bitmap-bresenham.kc
      /*
      collapseEquivalenceClasses("line::plotter#0", "line::plotter#1");
      //setRegister(combination, "line::plotter#1", new Registers.RegisterZpPointerByte(21));
      setRegister(combination, "line::$11", Registers.getRegisterA());
      setRegister(combination, "line::$9", Registers.getRegisterA());
      setRegister(combination, "line::$10", Registers.getRegisterALU());
      setRegister(combination, "line::$3", Registers.getRegisterA());
      setRegister(combination, "line::$5", Registers.getRegisterA());
      setRegister(combination, "line::$4", Registers.getRegisterALU());
      setRegister(combination, "line::$6", Registers.getRegisterA());
      setRegister(combination, "line::$8", Registers.getRegisterA());
      setRegister(combination, "line::$7", Registers.getRegisterALU());
      setRegister(combination, "initplottables::$6", Registers.getRegisterA());
      setRegister(combination, "initplottables::$7", Registers.getRegisterALU());
      setRegister(combination, "initplottables::$6", Registers.getRegisterA());
      */

      setRegister(combination, "plot::x#0", Registers.getRegisterX());
      setRegister(combination, "plot::x#1", Registers.getRegisterX());
      setRegister(combination, "plot::x#2", Registers.getRegisterX());
      setRegister(combination, "plot::x#3", Registers.getRegisterX());
      setRegister(combination, "main::i#1", Registers.getRegisterX());
      setRegister(combination, "main::i#2", Registers.getRegisterX());

      boolean success = Pass4RegisterUpliftCombinations.generateCombinationAsm(
            combination,
            getProgram(),
            new HashSet<String>(),
            null);

      if(success) {
         // If no clobber - Find value of the resulting allocation
         int combinationScore = Pass4RegisterUpliftCombinations.getAsmScore(getProgram());
         if(getLog().isVerboseUplift()) {
            StringBuilder msg = new StringBuilder();
            msg.append("Static Uplift ");
            msg.append(combinationScore);
            msg.append(" allocation: ").append(combination.toString());
            getLog().append(msg.toString());
         }
         combination.store(getProgram().getLiveRangeEquivalenceClassSet());
      } else {
         new Pass4AssertNoCpuClobber(getProgram()).check();
         throw new RuntimeException("Static uplift problem.");
      }

   }

   private void setRegister(RegisterCombination combination, String varFullName, Registers.Register register) {
      LiveRangeEquivalenceClassSet equivalenceClassSet = getProgram().getLiveRangeEquivalenceClassSet();
      ProgramScope scope = getProgram().getScope();
      VariableRef variableRef = scope.getVariable(varFullName).getRef();
      LiveRangeEquivalenceClass equivalenceClass = equivalenceClassSet.getEquivalenceClass(variableRef);
      combination.setRegister(equivalenceClass, register);
   }

   private void collapseEquivalenceClasses(String varFullName1, String varFullName2) {
      LiveRangeEquivalenceClassSet equivalenceClassSet = getProgram().getLiveRangeEquivalenceClassSet();
      ProgramScope scope = getProgram().getScope();
      VariableRef variableRef1 = scope.getVariable(varFullName1).getRef();
      LiveRangeEquivalenceClass equivalenceClass1 = equivalenceClassSet.getEquivalenceClass(variableRef1);
      VariableRef variableRef2 = scope.getVariable(varFullName2).getRef();
      LiveRangeEquivalenceClass equivalenceClass2 = equivalenceClassSet.getEquivalenceClass(variableRef2);
      if(!equivalenceClass1.equals(equivalenceClass2)) {
         equivalenceClassSet.consolidate(equivalenceClass1, equivalenceClass2);
      }
   }

}

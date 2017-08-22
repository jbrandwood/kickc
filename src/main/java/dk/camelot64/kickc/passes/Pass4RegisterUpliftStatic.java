package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.icl.*;

import java.util.HashSet;

/*** Find the variable equivalence classes to attempt to uplift in each scope */
public class Pass4RegisterUpliftStatic extends Pass2Base {

   public Pass4RegisterUpliftStatic(Program program) {
      super(program);
   }

   public void performUplift() {

      RegisterCombination combination = new RegisterCombination();
      setRegister(combination, "cnt#12", Registers.getRegisterX());
      setRegister(combination, "cnt2#11", Registers.getRegisterY());
      setRegister(combination, "cnt3#11", new Registers.RegisterZpByte(4));
      setRegister(combination, "cnt#1", Registers.getRegisterX());
      setRegister(combination, "main::$0", Registers.getRegisterA());
      setRegister(combination, "main::$1", Registers.getRegisterA());
      setRegister(combination, "inccnt::return#0", Registers.getRegisterA());

      boolean success = Pass4RegisterUpliftCombinations.generateAsm(
            combination,
            getProgram(),
            new HashSet<String>(),
            null);

      if (success) {
         // If no clobber - Find value of the resulting allocation
         int combinationScore = Pass4RegisterUpliftCombinations.getAsmScore(getProgram());
         if (getLog().isVerboseUplift()) {
            StringBuilder msg = new StringBuilder();
            msg.append("Static Uplift ");
            msg.append(combinationScore);
            msg.append(" allocation: ").append(combination.toString());
            getLog().append(msg.toString());
         }
      } else {
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


}

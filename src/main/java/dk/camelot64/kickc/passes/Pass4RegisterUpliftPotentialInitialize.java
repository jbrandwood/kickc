package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.values.ConstantVarPointer;
import dk.camelot64.kickc.model.values.VariableRef;
import dk.camelot64.kickc.model.symbols.ConstantVar;
import dk.camelot64.kickc.model.symbols.Variable;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;

/*** Initialize potential registers for each equivalence class.
 *
 * */
public class Pass4RegisterUpliftPotentialInitialize extends Pass2Base {

   public Pass4RegisterUpliftPotentialInitialize(Program program) {
      super(program);
   }

   /***
    * Initialize register potentials for each equivalence class with all potential registers
    */
   public void initPotentialRegisters() {
      LiveRangeEquivalenceClassSet liveRangeEquivalenceClassSet = getProgram().getLiveRangeEquivalenceClassSet();
      RegisterPotentials registerPotentials = new RegisterPotentials();
      for(LiveRangeEquivalenceClass equivalenceClass : liveRangeEquivalenceClassSet.getEquivalenceClasses()) {
         Registers.Register declaredRegister = null;
         for(VariableRef varRef : equivalenceClass.getVariables()) {
            Variable variable = getProgram().getScope().getVariable(varRef);
            if(variable.getDeclaredRegister() != null) {
               if(declaredRegister != null && !declaredRegister.equals(variable.getDeclaredRegister())) {
                  throw new CompileError("Equivalence class has variables with different declared registers \n" +
                        " - equivalence class: " + equivalenceClass.toString(true) + "\n" +
                        " - one register: " + declaredRegister.toString() + "\n" +
                        " - other register: " + variable.getDeclaredRegister().toString()
                  );
               }
               declaredRegister = variable.getDeclaredRegister();
            }
         }
         if(declaredRegister != null) {
            registerPotentials.setPotentialRegisters(equivalenceClass, Arrays.asList(declaredRegister));
         } else {
            Registers.Register defaultRegister = equivalenceClass.getRegister();
            Registers.RegisterType registerType = defaultRegister.getType();
            List<Registers.Register> potentials = new ArrayList<>();
            potentials.add(defaultRegister);
            if(registerType.equals(Registers.RegisterType.ZP_BYTE) && !varRefExtracted(equivalenceClass)) {
               potentials.add(Registers.getRegisterA());
               potentials.add(Registers.getRegisterX());
               potentials.add(Registers.getRegisterY());
            }
            if(registerType.equals(Registers.RegisterType.ZP_BOOL) && !varRefExtracted(equivalenceClass)) {
               potentials.add(Registers.getRegisterA());
            }
            registerPotentials.setPotentialRegisters(equivalenceClass, potentials);
         }
      }
      getProgram().setRegisterPotentials(registerPotentials);
   }

   /**
    * Determines if a variable reference is ever created for the variable using the address-of "&" operator
    * @param equivalenceClass The equivalence class
    * @return true if a variable reference is extracted
    */
   private boolean varRefExtracted(LiveRangeEquivalenceClass equivalenceClass) {
      Collection<ConstantVar> allConstants = getProgram().getScope().getAllConstants(true);
      for(ConstantVar allConstant : allConstants) {
         if(allConstant.getValue() instanceof ConstantVarPointer) {
            VariableRef toVar = ((ConstantVarPointer) allConstant.getValue()).getToVar();
            if(equivalenceClass.getVariables().contains(toVar)) {
               return true;
            }
         }
      }
      return false;
   }

   private boolean hasIntersection(Collection<VariableRef> vars1, List<VariableRef> vars2) {
      ArrayList<VariableRef> set = new ArrayList<>(vars1);
      set.retainAll(vars2);
      return set.size() > 0;
   }

}

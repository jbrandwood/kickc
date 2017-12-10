package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;

import java.util.Arrays;
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
      for (LiveRangeEquivalenceClass equivalenceClass : liveRangeEquivalenceClassSet.getEquivalenceClasses()) {
         Registers.Register defaultRegister = equivalenceClass.getRegister();
         Registers.RegisterType registerType = defaultRegister.getType();
         if (registerType.equals(Registers.RegisterType.ZP_BYTE)) {
            List<Registers.Register> potentials = Arrays.asList(
                  defaultRegister,
                  Registers.getRegisterA(),
                  Registers.getRegisterX(),
                  Registers.getRegisterY());
            registerPotentials.setPotentialRegisters(equivalenceClass, potentials);
         } else {
            registerPotentials.setPotentialRegisters(equivalenceClass, Arrays.asList(defaultRegister));
         }
      }
      getProgram().setRegisterPotentials(registerPotentials);
   }

}

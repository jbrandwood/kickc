package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.values.VariableRef;

import java.util.ArrayList;
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
      for(LiveRangeEquivalenceClass equivalenceClass : liveRangeEquivalenceClassSet.getEquivalenceClasses()) {
         Registers.Register declaredRegister = null;
         int bytes = -1;
         for(VariableRef varRef : equivalenceClass.getVariables()) {
            Variable variable = getProgram().getScope().getVariable(varRef);
            if(variable.getDeclaredRegister() != null) { //TODO: Handle register/memory/storage strategy differently!
               if(declaredRegister != null && !declaredRegister.equals(variable.getDeclaredRegister())) {
                  throw new CompileError("Equivalence class has variables with different declared registers \n" +
                        " - equivalence class: " + equivalenceClass.toString(true) + "\n" +
                        " - one register: " + declaredRegister.toString() + "\n" +
                        " - other register: " + variable.getDeclaredRegister().toString()
                  );
               }
               declaredRegister = variable.getDeclaredRegister();
               bytes = variable.getType().getSizeBytes();
            }
         }
         if(declaredRegister != null) {
            if(declaredRegister instanceof Registers.RegisterZpDeclared) {
               Registers.RegisterZpMem zpRegister = ((Registers.RegisterZpDeclared) declaredRegister).getZpRegister(bytes);
               registerPotentials.setPotentialRegisters(equivalenceClass, Arrays.asList(zpRegister));
            }  else {
               registerPotentials.setPotentialRegisters(equivalenceClass, Arrays.asList(declaredRegister));
            }
         } else {
            Registers.Register defaultRegister = equivalenceClass.getRegister();
            Registers.RegisterType registerType = defaultRegister.getType();
            List<Registers.Register> potentials = new ArrayList<>();
            potentials.add(defaultRegister);
            boolean isByte2 = defaultRegister.isZp() && defaultRegister.getBytes() == 1;
            if(isByte2  && !varVolatile(equivalenceClass)) {
               potentials.add(Registers.getRegisterA());
               potentials.add(Registers.getRegisterX());
               potentials.add(Registers.getRegisterY());
            }
            registerPotentials.setPotentialRegisters(equivalenceClass, potentials);
         }
      }
      getProgram().setRegisterPotentials(registerPotentials);
   }

   /**
    * Determine if any variable is declared as volatile
    *
    * @param equivalenceClass The variable equivalence class
    * @return true if any variable is volatile
    */
   private boolean varVolatile(LiveRangeEquivalenceClass equivalenceClass) {
      for(VariableRef variableRef : equivalenceClass.getVariables()) {
         Variable variable = getSymbols().getVariable(variableRef);
         if(variable.isVolatile() || variable.isStorageMemory()) {
            return true;
         }
      }
      return false;
   }


}

package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.icl.*;

import java.util.Collection;
import java.util.LinkedHashSet;
import java.util.Set;

/**
 * Move register allocation from equivalence classes to RegisterAllocation.
 * Also reallocate and rename zero page registers in the equivalence classes.
 */
public class Pass4RegistersFinalize extends Pass2Base {

   public Pass4RegistersFinalize(Program program) {
      super(program);
   }

   public void allocate(boolean reallocateZp) {
      LiveRangeEquivalenceClassSet liveRangeEquivalenceClassSet = getProgram().getLiveRangeEquivalenceClassSet();
      if (reallocateZp) {
         reallocateZpRegisters(liveRangeEquivalenceClassSet);
      }
      liveRangeEquivalenceClassSet.storeRegisterAllocation();
      if (reallocateZp) {
         shortenZpRegisterNames(liveRangeEquivalenceClassSet);
      }
   }

   /**
    * Shorten register names for ZP registers if possible
    *
    * @param equivalenceClassSet
    */
   private void shortenZpRegisterNames(LiveRangeEquivalenceClassSet equivalenceClassSet) {
      Collection<Scope> allScopes = getProgram().getScope().getAllScopes(true);
      allScopes.add(getProgram().getScope());
      for (Scope scope : allScopes) {
         Set<String> used = new LinkedHashSet<>();
         // Find all names without "#"
         for (Variable variable : scope.getAllVariables(false)) {
            if (variable.getAllocation() != null && variable.getAllocation().isZp()) {
               Registers.RegisterZp regZp = (Registers.RegisterZp) variable.getAllocation();
               String regZpName = regZp.getName();
               if (!regZpName.contains("#")) {
                  used.add(regZpName);
               }
            }
         }

         // For all names with "#" try to shorten
         for (Variable variable : scope.getAllVariables(false)) {
            if (variable.getAllocation() != null && variable.getAllocation().isZp()) {
               Registers.RegisterZp regZp = (Registers.RegisterZp) variable.getAllocation();
               String regZpName = regZp.getName();
               if (regZpName.contains("#")) {
                  regZpName = regZpName.substring(0, regZpName.indexOf("#"));
                  if (!used.contains(regZpName)) {
                     regZp.setName(regZpName);
                     used.add(regZpName);
                  }
               }
            }
         }

      }
   }

   /**
    * Reallocate all ZP registers to minimize ZP usage
    *
    * @param liveRangeEquivalenceClassSet The
    */
   private void reallocateZpRegisters(LiveRangeEquivalenceClassSet liveRangeEquivalenceClassSet) {
      for (LiveRangeEquivalenceClass equivalenceClass : liveRangeEquivalenceClassSet.getEquivalenceClasses()) {
         Registers.Register register = equivalenceClass.getRegister();
         if (register == null || register.isZp()) {
            String before = register == null ? null : register.toString();
            VariableRef variableRef = equivalenceClass.getVariables().get(0);
            Variable variable = getProgram().getScope().getVariable(variableRef);
            register = allocateNewRegisterZp(variable);
            equivalenceClass.setRegister(register);
            if (before == null || !before.equals(register.toString())) {
               getLog().append("Allocated " + (before == null ? "" : ("(was " + before + ") ")) + equivalenceClass.toString());
            }
         }
      }
   }

   /**
    * The current zero page used to create new registers when needed.
    */
   private int currentZp = 2;

   /**
    * Create a new register for a specific variable type.
    *
    * @param varType The variable type to create a register for.
    *                The register type created uses one or more zero page locations based on the variable type
    * @return The new zeropage register
    */
   private Registers.Register allocateNewRegisterZp(Variable variable) {
      SymbolType varType = variable.getType();
      String name = variable.getLocalName();
      if (varType.equals(SymbolTypeBasic.BYTE)) {
         return new Registers.RegisterZpByte(currentZp++, name, variable);
      } else if (varType.equals(SymbolTypeBasic.WORD)) {
         Registers.RegisterZpWord registerZpWord =
               new Registers.RegisterZpWord(currentZp, name, variable);
         currentZp = currentZp + 2;
         return registerZpWord;
      } else if (varType.equals(SymbolTypeBasic.BOOLEAN)) {
         return new Registers.RegisterZpBool(currentZp++, name, variable);
      } else if (varType.equals(SymbolTypeBasic.VOID)) {
         // No need to setRegister register for VOID value
         return null;
      } else if (varType instanceof SymbolTypePointer) {
         Registers.RegisterZpPointerByte registerZpPointerByte =
               new Registers.RegisterZpPointerByte(currentZp, name, variable);
         currentZp = currentZp + 2;
         return registerZpPointerByte;
      } else {
         throw new RuntimeException("Unhandled variable type " + varType);
      }
   }


}

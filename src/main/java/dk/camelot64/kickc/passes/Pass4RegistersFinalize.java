package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.icl.*;

/**
 * Move register allocation from equivalence classes to RegisterAllocation.
 * Also rebase zero page registers.
 */
public class Pass4RegistersFinalize extends Pass2Base {

   public Pass4RegistersFinalize(Program program) {
      super(program);
   }

   public void allocate(boolean reallocZp) {
      LiveRangeEquivalenceClassSet liveRangeEquivalenceClassSet = getProgram().getLiveRangeEquivalenceClassSet();
      if(reallocZp) {
         reallocateZp(liveRangeEquivalenceClassSet);
      }
      RegisterAllocation allocation = liveRangeEquivalenceClassSet.createRegisterAllocation();
      getProgram().setAllocation(allocation);
   }

   /**
    * Reallocate all ZP registers to minimize ZP usage
    *
    * @param liveRangeEquivalenceClassSet The
    */
   private void reallocateZp(LiveRangeEquivalenceClassSet liveRangeEquivalenceClassSet) {
      for (LiveRangeEquivalenceClass equivalenceClass : liveRangeEquivalenceClassSet.getEquivalenceClasses()) {
         RegisterAllocation.Register register = equivalenceClass.getRegister();
         if(register==null || register.isZp()) {
            String before = register==null?null:register.toString();
            VariableRef variable = equivalenceClass.getVariables().get(0);
            Variable symbol = getProgram().getScope().getVariable(variable);
            register = allocateNewRegisterZp(symbol.getType());
            equivalenceClass.setRegister(register);
            if(before==null || !before.equals(register.toString())) {
               getLog().append("Allocated " + (before==null?"":("(was "+before+") ")) + equivalenceClass.toString());
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
   private RegisterAllocation.Register allocateNewRegisterZp(SymbolType varType) {
      if (varType.equals(SymbolTypeBasic.BYTE)) {
         return new RegisterAllocation.RegisterZpByte(currentZp++);
      } else if (varType.equals(SymbolTypeBasic.WORD)) {
         RegisterAllocation.RegisterZpWord registerZpWord =
               new RegisterAllocation.RegisterZpWord(currentZp);
         currentZp = currentZp + 2;
         return registerZpWord;
      } else if (varType.equals(SymbolTypeBasic.BOOLEAN)) {
         return new RegisterAllocation.RegisterZpBool(currentZp++);
      } else if (varType.equals(SymbolTypeBasic.VOID)) {
         // No need to setRegister register for VOID value
         return null;
      } else if (varType instanceof SymbolTypePointer) {
         RegisterAllocation.RegisterZpPointerByte registerZpPointerByte =
               new RegisterAllocation.RegisterZpPointerByte(currentZp);
         currentZp = currentZp + 2;
         return registerZpPointerByte;
      } else {
         throw new RuntimeException("Unhandled variable type " + varType);
      }
   }



}

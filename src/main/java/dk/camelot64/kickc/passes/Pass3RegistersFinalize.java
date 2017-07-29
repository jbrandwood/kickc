package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.icl.*;

/**
 * Move register allocation from equivalence classes to RegisterAllocation.
 * Also rebase zero page registers.
 */
public class Pass3RegistersFinalize {

   private Program program;
   private CompileLog log;

   public Pass3RegistersFinalize(Program program, CompileLog log) {
      this.program = program;
      this.log = log;
   }

   public void allocate() {
      LiveRangeEquivalenceClassSet liveRangeEquivalenceClassSet = program.getScope().getLiveRangeEquivalenceClassSet();

      RegisterAllocation allocation = new RegisterAllocation();
      for (LiveRangeEquivalenceClass equivalenceClass : liveRangeEquivalenceClassSet.getEquivalenceClasses()) {
         RegisterAllocation.Register register = equivalenceClass.getRegister();
         if(register.isZp()) {
            String before = register.toString();
            VariableRef variable = equivalenceClass.getVariables().get(0);
            Variable symbol = program.getScope().getVariable(variable);
            register = allocateNewRegisterZp(symbol.getType());
            log.append("Re-allocated ZP register from "+before+" to "+register.toString());
         }
         for (VariableRef variable : equivalenceClass.getVariables()) {
            allocation.allocate(variable, register);
         }
      }
      program.getScope().setAllocation(allocation);

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
         // No need to allocate register for VOID value
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

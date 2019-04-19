package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.values.VariableRef;
import dk.camelot64.kickc.model.symbols.ConstantVar;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypePointer;

import java.util.*;

/**
 * Move register allocation from equivalence classes to RegisterAllocation.
 * Also reallocate and rename zero page registers in the equivalence classes.
 */
public class Pass4RegistersFinalize extends Pass2Base {

   /**
    * The current zero page used to create new registers when needed.
    */
   private int currentZp = 2;

   /** All reserved zeropage addresses not available for the compiler. */
   private List<Number> reservedZp;

   public Pass4RegistersFinalize(Program program) {
      super(program);
      this.reservedZp = new ArrayList<>();
      this.reservedZp.addAll(program.getReservedZps());
      for(Procedure procedure : getSymbols().getAllProcedures(true)) {
         List<Number> procedureReservedZps = procedure.getReservedZps();
         if(procedureReservedZps!=null) {
            this.reservedZp.addAll(procedureReservedZps);
         }
      }
   }

   public void allocate(boolean reallocateZp) {
      LiveRangeEquivalenceClassSet liveRangeEquivalenceClassSet = getProgram().getLiveRangeEquivalenceClassSet();
      for(LiveRangeEquivalenceClass equivalenceClass : liveRangeEquivalenceClassSet.getEquivalenceClasses()) {
         for(VariableRef variableRef : equivalenceClass.getVariables()) {
            Variable variable = getProgram().getScope().getVariable(variableRef);
            if(variable.getDeclaredRegister()!=null) {
               if(equivalenceClass.getRegister()!=null && !variable.getDeclaredRegister().equals(equivalenceClass.getRegister())) {
                  throw new CompileError("Equivalence class has variables with different declared registers \n" +
                        " - equivalence class: " + equivalenceClass.toString(true) + "\n" +
                        " - one register: " + equivalenceClass.getRegister().toString() + "\n" +
                        " - other register: " + variable.getDeclaredRegister().toString()
                  );
               }
               equivalenceClass.setRegister(variable.getDeclaredRegister());
            }
         }
      }

      
      if(reallocateZp) {
         reallocateZpRegisters(liveRangeEquivalenceClassSet);
      }
      liveRangeEquivalenceClassSet.storeRegisterAllocation();
      if(reallocateZp) {
         shortenZpRegisterNames();
      }
   }

   /**
    * Shorten register names for ZP registers if possible
    */
   private void shortenZpRegisterNames() {
      Collection<Scope> allScopes = getProgram().getScope().getAllScopes(true);
      allScopes.add(getProgram().getScope());
      for(Scope scope : allScopes) {
         // Create initial short names - and remember the ones without "#"
         for(Variable variable : scope.getAllVariables(false)) {
            if(variable.getAllocation() != null && variable.getAllocation().isZp()) {
               variable.setAsmName(variable.getLocalName());
            } else {
               variable.setAsmName(null);
            }
         }
         for(ConstantVar constantVar : scope.getAllConstants(false)) {
            constantVar.setAsmName(constantVar.getLocalName());
         }

         // Find short asm names for all variables if possible
         Map<String, Registers.Register> shortNames = new LinkedHashMap<>();

         for(Variable variable : scope.getAllVariables(false)) {
            Registers.Register allocation = variable.getAllocation();
            if(allocation != null && allocation.isZp()) {
               String asmName = variable.getAsmName();
               if(asmName.contains("#")) {
                  String shortName = asmName.substring(0, asmName.indexOf("#"));
                  if(shortNames.get(shortName) == null || shortNames.get(shortName).equals(allocation)) {
                     // Short name is usable!
                     variable.setAsmName(shortName);
                     shortNames.put(shortName, allocation);
                     continue;
                  }
               }
               if(shortNames.get(asmName) == null || shortNames.get(asmName).equals(allocation)) {
                  // Try the full name instead
                  variable.setAsmName(asmName);
                  shortNames.put(asmName, allocation);
                  continue;
               } else {
                  // Be unhappy (if this triggers in the future extend with ability to create new names by adding suffixes)
                  throw new RuntimeException("ASM name already used " + asmName);
               }
            }
         }

         for(ConstantVar constantVar : scope.getAllConstants(false)) {
            String asmName = constantVar.getAsmName();
            Registers.Register allocation = new Registers.RegisterConstant(constantVar.getValue());
            if(asmName.contains("#")) {
               String shortName = asmName.substring(0, asmName.indexOf("#"));
               if(shortNames.get(shortName) == null || shortNames.get(shortName).equals(allocation)) {
                  // Short name is usable!
                  constantVar.setAsmName(shortName);
                  shortNames.put(shortName, allocation);
                  continue;
               }
            }
            if(shortNames.get(asmName) == null || shortNames.get(asmName).equals(allocation)) {
               // Try the full name instead
               constantVar.setAsmName(asmName);
               shortNames.put(asmName, allocation);
               continue;
            } else {
               // Be unhappy (if this triggers in the future extend with ability to create new names by adding suffixes)
               throw new RuntimeException("ASM name already used " + asmName);
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
      for(LiveRangeEquivalenceClass equivalenceClass : liveRangeEquivalenceClassSet.getEquivalenceClasses()) {
         Registers.Register register = equivalenceClass.getRegister();
         if(register == null || register.isZp()) {
            String before = register == null ? null : register.toString();
            VariableRef variableRef = equivalenceClass.getVariables().get(0);
            Variable variable = getProgram().getSymbolInfos().getVariable(variableRef);
            register = allocateNewRegisterZp(variable);
            equivalenceClass.setRegister(register);
            if(before == null || !before.equals(register.toString())) {
               getLog().append("Allocated " + (before == null ? "" : ("(was " + before + ") ")) + equivalenceClass.toString());
            }
         }
      }
   }

   /**
    * Allocate bytes on zeropage.
    * Avoids reserved zero page addresses.
    * @param size The number of bytes to allocate
    * @return The address of the first byte.
    */
   private int allocateZp(int size) {
      // Find a ZP sequence of size without any reserved ZP
      boolean reserved;
      do {
         reserved = false;
         int candidateZp = currentZp;
         for(int i=0;i<size;i++) {
            if(reservedZp.contains(new Long(candidateZp+i))) {
               reserved = true;
               currentZp++;
               break;
            }
         }
      } while(reserved);
      // No reserved ZP
      int allocated = currentZp;
      currentZp += size;
      return allocated;
   }

   /**
    * Create a new register for a specific variable type.
    *
    * @param variable The variable to create a register for.
    * The register type created uses one or more zero page locations based on the variable type
    * @return The new zeropage register
    */
   private Registers.Register allocateNewRegisterZp(Variable variable) {
      SymbolType varType = variable.getType();
      if(SymbolType.isByte(varType)) {
         return new Registers.RegisterZpByte(allocateZp((1)));
      } else if(SymbolType.isSByte(varType)) {
         return new Registers.RegisterZpByte(allocateZp(1));
      } else if(SymbolType.isWord(varType)) {
         Registers.RegisterZpWord registerZpWord =
               new Registers.RegisterZpWord(allocateZp(2));
         return registerZpWord;
      } else if(SymbolType.isSWord(varType)) {
         Registers.RegisterZpWord registerZpWord =
               new Registers.RegisterZpWord(allocateZp(2));
         return registerZpWord;
      } else if(SymbolType.isDWord(varType)) {
         Registers.RegisterZpDWord registerZpDWord =
               new Registers.RegisterZpDWord(allocateZp(4));
         return registerZpDWord;
      } else if(SymbolType.isSDWord(varType)) {
         Registers.RegisterZpDWord registerZpDWord =
               new Registers.RegisterZpDWord(allocateZp(4));
         return registerZpDWord;
      } else if(varType.equals(SymbolType.BOOLEAN)) {
         return new Registers.RegisterZpBool(allocateZp(1));
      } else if(varType.equals(SymbolType.VOID)) {
         // No need to setRegister register for VOID value
         return null;
      } else if(varType instanceof SymbolTypePointer) {
         Registers.RegisterZpWord registerZpWord =
               new Registers.RegisterZpWord(allocateZp(2));
         return registerZpWord;
      } else {
         throw new RuntimeException("Unhandled variable type " + varType);
      }
   }


}

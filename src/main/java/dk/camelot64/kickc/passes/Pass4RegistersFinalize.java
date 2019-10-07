package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.symbols.ConstantVar;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;
import dk.camelot64.kickc.model.values.VariableRef;

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
   private List<Integer> reservedZp;

   public Pass4RegistersFinalize(Program program) {
      super(program);
      this.reservedZp = new ArrayList<>();
      // Add all ZP's declared as reserved
      this.reservedZp.addAll(program.getReservedZps());
      // Add all ZP's declared as reserved in a procedure
      for(Procedure procedure : getSymbols().getAllProcedures(true)) {
         List<Integer> procedureReservedZps = procedure.getReservedZps();
         if(procedureReservedZps!=null) {
            this.reservedZp.addAll(procedureReservedZps);
         }
      }
      // Add all ZP's declared hardcoded register for a live variable
      for(Variable variable : getSymbols().getAllVariables(true)) {
         if(variable.getDeclaredRegister() instanceof Registers.RegisterZpMem) {
            int zp = ((Registers.RegisterZpMem) variable.getDeclaredRegister()).getZp();
            int sizeBytes = variable.getType().getSizeBytes();
            for(int i=0;i<sizeBytes; i++) {
               if(!reservedZp.contains(zp+i))
                  this.reservedZp.add(zp+i);
            }
         }
      }
   }

   public void allocate(boolean reallocateZp) {
      LiveRangeEquivalenceClassSet liveRangeEquivalenceClassSet = getProgram().getLiveRangeEquivalenceClassSet();
      for(LiveRangeEquivalenceClass equivalenceClass : liveRangeEquivalenceClassSet.getEquivalenceClasses()) {
         for(VariableRef variableRef : equivalenceClass.getVariables()) {
            Variable variable = getProgram().getScope().getVariable(variableRef);
            Registers.Register declaredRegister = variable.getDeclaredRegister(); //TODO: Handle register/memory/storage strategy differently!
            Registers.Register register = declaredRegister;
            if(declaredRegister !=null) {
               if(declaredRegister instanceof Registers.RegisterZpMem) {
                  int zp = ((Registers.RegisterZpMem) declaredRegister).getZp();
                  int bytes = variable.getType().getSizeBytes();
                  register = new Registers.RegisterZpMem(zp, bytes, true);
               } else if(equivalenceClass.getRegister()!=null && !declaredRegister.equals(equivalenceClass.getRegister())) {
                  throw new CompileError("Equivalence class has variables with different declared registers \n" +
                        " - equivalence class: " + equivalenceClass.toString(true) + "\n" +
                        " - one register: " + equivalenceClass.getRegister().toString() + "\n" +
                        " - other register: " + declaredRegister.toString()
                  );
               }
               equivalenceClass.setRegister(register);
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
         boolean reallocate = true;
         if(register!=null) {
            if(!register.isZp()) {
               // Do not allocate non-ZP registers
               reallocate = false;
            } else if(register.isZp() && register.isNonRelocatable()) {
               // Do not allocate declared ZP registers
               reallocate = false;
            }
         }
         if(reallocate) {
            String before = register == null ? null : register.toString();
            VariableRef variableRef = equivalenceClass.getVariables().get(0);
            Variable variable = getProgram().getSymbolInfos().getVariable(variableRef);
            if(variable.isStorageMemory()) {
               register = new Registers.RegisterMainMem(variableRef, variable.getType().getSizeBytes());
            }  else {
               register = allocateNewRegisterZp(variable);
            }
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
            if(reservedZp.contains(new Integer(candidateZp+i))) {
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
      if(SymbolType.BYTE.equals(varType)) {
         return new Registers.RegisterZpMem(allocateZp(1), 1);
      } else if(SymbolType.SBYTE.equals(varType)) {
         return new Registers.RegisterZpMem(allocateZp(1),1);
      } else if(SymbolType.WORD.equals(varType)) {
         Registers.RegisterZpMem registerZpWord =
               new Registers.RegisterZpMem(allocateZp(2), 2);
         return registerZpWord;
      } else if(SymbolType.SWORD.equals(varType)) {
         Registers.RegisterZpMem registerZpWord =
               new Registers.RegisterZpMem(allocateZp(2), 2);
         return registerZpWord;
      } else if(SymbolType.DWORD.equals(varType)) {
         Registers.RegisterZpMem registerZpDWord =
               new Registers.RegisterZpMem(allocateZp(4), 4);
         return registerZpDWord;
      } else if(SymbolType.SDWORD.equals(varType)) {
         Registers.RegisterZpMem registerZpDWord =
               new Registers.RegisterZpMem(allocateZp(4), 4);
         return registerZpDWord;
      } else if(varType.equals(SymbolType.BOOLEAN)) {
         return new Registers.RegisterZpMem(allocateZp(1), 1);
      } else if(varType.equals(SymbolType.VOID)) {
         // No need to setRegister register for VOID value
         return null;
      } else if(varType instanceof SymbolTypePointer) {
         Registers.RegisterZpMem registerZpWord =
               new Registers.RegisterZpMem(allocateZp(2), 2);
         return registerZpWord;
      } else if(varType instanceof SymbolTypeStruct) {
         Registers.RegisterZpMem registerZpStruct =
               new Registers.RegisterZpMem(allocateZp(varType.getSizeBytes()), varType.getSizeBytes());
         return registerZpStruct;
      } else {
         throw new RuntimeException("Unhandled variable type " + varType);
      }
   }


}

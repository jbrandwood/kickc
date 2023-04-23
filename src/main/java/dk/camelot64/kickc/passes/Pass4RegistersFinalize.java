package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.symbols.*;
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
         if(variable.getRegister() instanceof Registers.RegisterZpMem) {
            int zp = ((Registers.RegisterZpMem) variable.getRegister()).getZp();
            int sizeBytes = variable.getType().getSizeBytes();
            for(int i=0;i<sizeBytes; i++) {
               if(!reservedZp.contains(zp+i))
                  this.reservedZp.add(zp+i);
            }
         }
      }
   }

   public void allocate(boolean reallocateZp, boolean overflowToMainMem) {
      LiveRangeEquivalenceClassSet liveRangeEquivalenceClassSet = getProgram().getLiveRangeEquivalenceClassSet();
      for(LiveRangeEquivalenceClass equivalenceClass : liveRangeEquivalenceClassSet.getEquivalenceClasses()) {
         for(VariableRef variableRef : equivalenceClass.getVariables()) {
            Variable variable = getProgram().getScope().getVariable(variableRef);
            Registers.Register declaredRegister = variable.getRegister(); //TODO: Handle register/memory/storage strategy differently!
            Registers.Register register = declaredRegister;
            if(declaredRegister !=null) {
               if(declaredRegister instanceof Registers.RegisterZpMem) {
                  int zp = ((Registers.RegisterZpMem) declaredRegister).getZp();
                  int bytes = variable.getType().getSizeBytes();
                  register = new Registers.RegisterZpMem(zp, bytes, true);
               } else if(declaredRegister instanceof Registers.RegisterMainMem) {
                  Long address = ((Registers.RegisterMainMem) declaredRegister).getAddress();
                  VariableRef varRef = ((Registers.RegisterMainMem) declaredRegister).getVariableRef();
                  int bytes = variable.getType().getSizeBytes();
                  register = new Registers.RegisterMainMem(varRef, bytes, address, true);
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
         reallocateMemRegisters(liveRangeEquivalenceClassSet, overflowToMainMem);
      }
      liveRangeEquivalenceClassSet.storeRegisterAllocation();
      if(reallocateZp) {
         shortenAsmNames();
      }
   }

   /**
    * Shorten ASM names for variables and constants
    */
   private void shortenAsmNames() {
      Collection<Scope> allScopes = getProgram().getScope().getAllScopes(true);
      allScopes.add(getProgram().getScope());
      for(Scope scope : allScopes) {
         // Create initial short names
         for(Variable variable : scope.getAllVariables(false)) {
            if(variable.getAllocation() != null && variable.getAllocation().isMem()) {
               variable.setAsmName(variable.getLocalName());
            } else {
               variable.setAsmName(null);
            }
         }
         for(Variable constantVar : scope.getAllConstants(false)) {
            constantVar.setAsmName(constantVar.getLocalName());
         }

         // Maps short name to the allocated register.
         Map<String, Registers.Register> shortNames = new LinkedHashMap<>();
         // Shorten variable and constant names
         for(Variable variable : scope.getAllVariables(false)) {
            Registers.Register allocation = variable.getAllocation();
            if(allocation != null && allocation.isMem()) {
               shortenAsmName(shortNames, variable, allocation);
            }
         }
         for(Variable constantVar : scope.getAllConstants(false)) {
            Registers.Register allocation = new Registers.RegisterConstant(constantVar.getInitValue());
            shortenAsmName(shortNames, constantVar, allocation);
         }
      }
   }

   /**
    * Shorten the ASM name for a single variable.
    *
    * @param shortNames Map of allocated short names. Maps short name to the allocated register.
    * @param variable The variable to shorten the name for
    * @param allocation The register allocation for the variable
    */
   private void shortenAsmName(Map<String, Registers.Register> shortNames, Variable variable, Registers.Register allocation) {
      String asmName = variable.getAsmName();
      String prefix = asmName;
      if(asmName.contains("#")) {
         prefix = asmName.substring(0, asmName.indexOf("#"));
      }
      int suffix = 0;
      boolean found = false;
      while(!found) {
         String shortName = prefix + ((suffix==0)?"":("_"+suffix));
         if(shortNames.get(shortName) == null || shortNames.get(shortName).equals(allocation)) {
            // Short name is usable!
            variable.setAsmName(shortName);
            shortNames.put(shortName, allocation);
            found=true;
         }
         suffix++;
      }
   }

   /**
    * Reallocate all memory registers. Minimizes zeropage usage.
    *
    * @param equivalenceClassSet The live range equivalence classes
    * @param overflowToMainMem If true zeropage variables overflow into main memory if they do not fit on zeropage.
    */
   private void reallocateMemRegisters(LiveRangeEquivalenceClassSet equivalenceClassSet, boolean overflowToMainMem) {

      List<LiveRangeEquivalenceClass> equivalenceClasses = new ArrayList<>(equivalenceClassSet.getEquivalenceClasses());
      final VariableRegisterWeights registerWeights = getProgram().getVariableRegisterWeights();
      Collections.sort(equivalenceClasses, (o1, o2) -> Double.compare(registerWeights.getTotalWeight(o2), registerWeights.getTotalWeight(o1)));

      for(LiveRangeEquivalenceClass equivalenceClass : equivalenceClasses) {
         Registers.Register register = equivalenceClass.getRegister();
         boolean reallocate = true;
         if(register!=null) {
            if(register.isHardware()) {
               // Do not allocate hardware registers
               reallocate = false;
            } else if(register.isAddressHardcoded()) {
               // Do not allocate registers with hardcoded address
               reallocate = false;
            }
         }
         if(reallocate) {
            String before = register == null ? null : register.toString();
            VariableRef variableRef = equivalenceClass.getVariables().get(0);
            Variable variable = getProgram().getSymbolInfos().getVariable(variableRef);
            if(variable.isMemoryAreaMain()) {
               register = new Registers.RegisterMainMem(variableRef, variable.getType().getSizeBytes(), null, false);
            }  else {
               register = allocateNewRegisterZp(variable);
               int zp = ((Registers.RegisterZpMem) register).getZp();
               int sizeBytes = variable.getType().getSizeBytes();
               if(overflowToMainMem) {
                  if (zp + sizeBytes > 0x100) {
                     // Zero-page exhausted - move to main memory instead (TODO: prioritize!)
                     register = new Registers.RegisterMainMem(variableRef, variable.getType().getSizeBytes(), null, false);
                     getLog().append("Zero-page exhausted. Moving allocation to main memory " + variable.toString());
                  }
               }
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
            if(reservedZp.contains(Integer.valueOf(candidateZp+i))) {
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

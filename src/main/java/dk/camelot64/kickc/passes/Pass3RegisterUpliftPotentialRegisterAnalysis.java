package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.asm.AsmFragment;
import dk.camelot64.kickc.asm.AsmProgram;
import dk.camelot64.kickc.asm.parser.AsmClobber;
import dk.camelot64.kickc.icl.*;

import java.util.*;

/*** Find potential registers for each equivalence class - based on clobbering of all register combinations in each statement.
 * <p>
 * If all possible register combinations in a statement clobbers a register then that register cannot be used for any variable alive
 * in the statement - except the variable assigned by the statement.
 *
 * */
public class Pass3RegisterUpliftPotentialRegisterAnalysis extends Pass2Base {

   public Pass3RegisterUpliftPotentialRegisterAnalysis(Program program) {
      super(program);
   }

   /***
    * For each statement - try out all potential register combinations and examine the clobber
    *
    * @return true if the potential registers of the program was changed. Menas that another call might refine them further
    */
   public boolean findPotentialRegisters() {

      boolean modified = false;
      LiveRangeEquivalenceClassSet liveRangeEquivalenceClassSet = getProgram().getLiveRangeEquivalenceClassSet();

      RegisterPotentials registerPotentials = getProgram().getRegisterPotentials();

      // Initialize potential registers for all live range equilavence classes
      if (registerPotentials == null) {
         modified = true;
         registerPotentials = new RegisterPotentials();
         for (LiveRangeEquivalenceClass equivalenceClass : liveRangeEquivalenceClassSet.getEquivalenceClasses()) {
            RegisterAllocation.Register defaultRegister = equivalenceClass.getRegister();
            RegisterAllocation.RegisterType registerType = defaultRegister.getType();
            if (registerType.equals(RegisterAllocation.RegisterType.ZP_BYTE)) {
               List<RegisterAllocation.Register> potentials = Arrays.asList(
                     defaultRegister,
                     RegisterAllocation.getRegisterA(),
                     RegisterAllocation.getRegisterX(),
                     RegisterAllocation.getRegisterY());
               registerPotentials.setPotentialRegisters(equivalenceClass, potentials);
            } else {
               registerPotentials.setPotentialRegisters(equivalenceClass, Arrays.asList(defaultRegister));
            }
         }
      }

      for (ControlFlowBlock block : getProgram().getGraph().getAllBlocks()) {
         for (Statement statement : block.getStatements()) {

            // Find all variables referenced/assigned in the statement
            Set<VariableRef> referencedVars = getReferencedVars(statement);
            Set<VariableRef> assignedVars = getAssignedVars(statement);

            // Find referenced/assigned live range equivalence classes
            Set<LiveRangeEquivalenceClass> assignedClasses = new LinkedHashSet<>();
            for (VariableRef var : assignedVars) {
               assignedClasses.add(liveRangeEquivalenceClassSet.getEquivalenceClass(var));
            }
            Set<LiveRangeEquivalenceClass> referencedClasses = new LinkedHashSet<>();
            for (VariableRef var : referencedVars) {
               referencedClasses.add(liveRangeEquivalenceClassSet.getEquivalenceClass(var));
            }

            // Generate all combinations of potential register allocations for the referenced equivalence classes
            // one statement has so few references that all combinations wont explode
            RegisterCombinationIterator combinationIterator = registerPotentials.getAllCombinations(referencedClasses);

            // For each combination generate the ASM and examine the clobber of all alive variables
            // Find the registers clobbered by all combinations!
            Set<RegisterAllocation.Register> alwaysClobbered = findAlwaysClobberedRegisters(block, statement, combinationIterator);
            if (alwaysClobbered.isEmpty()) {
               // No registers are always clobbered - move on to the next statement
               continue;
            } else {
               StringBuilder msg = new StringBuilder();
               msg.append("Statement ").append(statement.toString(getProgram()));
               msg.append(" always clobbers ");
               for (RegisterAllocation.Register register : alwaysClobbered) {
                  msg.append(register).append(" ");
               }
               getLog().append(msg.toString());
            }

            // For all non-assigned live variables: remove always clobbered registers from their potential allocation
            List<VariableRef> aliveVars = getProgram().getLiveRangeVariables().getAlive(statement);
            for (VariableRef aliveVar : aliveVars) {
               LiveRangeEquivalenceClass aliveClass = liveRangeEquivalenceClassSet.getEquivalenceClass(aliveVar);
               if (assignedClasses.contains(aliveClass)) {
                  // Assigned registers are allowed to be be clobbered
                  continue;
               }
               List<RegisterAllocation.Register> alivePotentialRegisters = registerPotentials.getPotentialRegisters(aliveClass);
               for (RegisterAllocation.Register clobberedRegister : alwaysClobbered) {
                  if (alivePotentialRegisters.contains(clobberedRegister)) {
                     registerPotentials.removePotentialRegister(aliveClass, clobberedRegister);
                     StringBuilder msg = new StringBuilder();
                     msg.append("Removing always clobbered register " + clobberedRegister + " as potential for " + aliveClass);
                     getLog().append(msg.toString());
                     modified = true;
                  }
               }
            }
         }
      }

      getProgram().setRegisterPotentials(registerPotentials);

      return modified;

   }

   /**
    * Find the registers clobbered by all register allocation combinations.
    * For each combination generate the ASM and examine the clobber of all alive variables.
    *
    * @param block        The block containins the statement
    * @param statement    The statement to examine
    * @param combinations The regsiter combinations to test
    * @return A set with registers that are clobbered by all different register assignments in the combination
    */
   private Set<RegisterAllocation.Register> findAlwaysClobberedRegisters(ControlFlowBlock block, Statement statement, RegisterCombinationIterator combinations) {

      // Initially assume all registers are always clobbered
      Set<RegisterAllocation.Register> alwaysClobbered = new LinkedHashSet<>();
      alwaysClobbered.add(RegisterAllocation.getRegisterA());
      alwaysClobbered.add(RegisterAllocation.getRegisterX());
      alwaysClobbered.add(RegisterAllocation.getRegisterY());

      Set<String> unknownFragments = new LinkedHashSet<>();

      while (combinations.hasNext()) {
         RegisterCombination combination = combinations.next();
         // Reset register allocation to original zero page allocation
         new Pass3RegistersFinalize(getProgram()).allocate(false);
         // Apply the combination
         combination.allocate(getProgram().getAllocation());
         // Generate ASM
         AsmProgram asm = new AsmProgram();
         asm.startSegment(statement.getIndex(), statement.toString(getProgram()));
         Pass3CodeGeneration.AsmCodegenAluState aluState = new Pass3CodeGeneration.AsmCodegenAluState();
         try {
            (new Pass3CodeGeneration(getProgram())).generateStatementAsm(asm, block, statement, aluState, false);
         } catch (AsmFragment.UnknownFragmentException e) {
            unknownFragments.add(e.getFragmentSignature());
            StringBuilder msg = new StringBuilder();
            msg.append("Potential register analysis " + statement );
            msg.append(" missing fragment " + e.getFragmentSignature());
            msg.append(" allocation: ").append(combination.toString());
            getLog().append(msg.toString());
            continue;
         }
         AsmClobber clobber = asm.getClobber();
         Collection<RegisterAllocation.Register> clobberRegisters = Pass3AssertNoCpuClobber.getClobberRegisters(clobber);
         Iterator<RegisterAllocation.Register> alwaysClobberIt = alwaysClobbered.iterator();
         while (alwaysClobberIt.hasNext()) {
            RegisterAllocation.Register alwaysClobberRegister = alwaysClobberIt.next();
            if (!clobberRegisters.contains(alwaysClobberRegister)) {
               alwaysClobberIt.remove();
            }
         }
         if (alwaysClobbered.isEmpty()) {
            // No register is always clobbered - abort combination search
            break;
         }
      }

      if (unknownFragments.size() > 0) {
         getLog().append("MISSING FRAGMENTS");
         for (String unknownFragment : unknownFragments) {
            getLog().append("  " + unknownFragment);
         }
         //throw new RuntimeException("Missing fragments!");
      }

      return alwaysClobbered;
   }


   /**
    * Get all variables referenced (or assigned) in a statement.
    *
    * @param statement The statement
    * @return All variables referenced (or assigned) in the statement
    */
   public static Set<VariableRef> getReferencedVars(Statement statement) {
      Set<VariableRef> referenced = new LinkedHashSet<>();
      if (statement instanceof StatementAssignment) {
         addReferenced(referenced, ((StatementAssignment) statement).getlValue());
         addReferenced(referenced, ((StatementAssignment) statement).getrValue1());
         addReferenced(referenced, ((StatementAssignment) statement).getrValue2());
      } else if (statement instanceof StatementPhiBlock) {
         for (StatementPhiBlock.PhiVariable phiVariable : ((StatementPhiBlock) statement).getPhiVariables()) {
            addReferenced(referenced, phiVariable.getVariable());
            for (StatementPhiBlock.PhiRValue phiRValue : phiVariable.getValues()) {
               addReferenced(referenced, phiRValue.getrValue());
            }
         }
      } else if (statement instanceof StatementConditionalJump) {
         addReferenced(referenced, ((StatementConditionalJump) statement).getrValue1());
         addReferenced(referenced, ((StatementConditionalJump) statement).getrValue2());
      }
      return referenced;
   }

   private static void addReferenced(Set<VariableRef> referenced, RValue rValue) {
      if (rValue instanceof VariableRef) {
         referenced.add((VariableRef) rValue);
      } else if (rValue instanceof PointerDereferenceSimple) {
         addReferenced(referenced, ((PointerDereferenceSimple) rValue).getPointer());
      } else if (rValue instanceof PointerDereferenceIndexed) {
         addReferenced(referenced, ((PointerDereferenceIndexed) rValue).getPointer());
         addReferenced(referenced, ((PointerDereferenceIndexed) rValue).getIndex());
      }
   }

   /**
    * Get all variables assigned a value in a statement
    *
    * @param statement The statement
    * @return The variables assigned a value in the statement
    */
   public static Set<VariableRef> getAssignedVars(Statement statement) {
      LinkedHashSet<VariableRef> variableRefs = new LinkedHashSet<>();
      if (statement instanceof StatementPhiBlock) {
         List<StatementPhiBlock.PhiVariable> phiVariables = ((StatementPhiBlock) statement).getPhiVariables();
         for (StatementPhiBlock.PhiVariable phiVariable : phiVariables) {
            variableRefs.add(phiVariable.getVariable());
         }
         return variableRefs;
      } else if (statement instanceof StatementAssignment) {
         LValue lValue = ((StatementAssignment) statement).getlValue();
         if (lValue instanceof VariableRef) {
            variableRefs.add((VariableRef) lValue);
         }
      }
      return variableRefs;
   }


}

package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.asm.AsmProgram;
import dk.camelot64.kickc.asm.AsmSegment;
import dk.camelot64.kickc.fragment.AsmFragmentInstance;
import dk.camelot64.kickc.fragment.AsmFragmentTemplateSynthesizer;
import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.values.ScopeRef;
import dk.camelot64.kickc.model.values.VariableRef;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.symbols.Variable;

import java.util.*;

/*** Attempt to uplift live range equivalence classes to registers (instead of ZP) in each scope */
public class Pass4RegisterUpliftCombinations extends Pass2Base {

   public Pass4RegisterUpliftCombinations(Program program) {
      super(program);
   }

   /**
    * Iterate combinations and choose the combination that provides the best ASM score.
    * Stores the best combination directly in the {@link LiveRangeEquivalenceClassSet}.
    *
    * @param combinationIterator The combination iterator used for supplying different register allocations to test
    * @param maxCombinations The maximal number of combinations to test. It the iterator has more combinations he rest is skipped (and a message logged)
    * @param unknownFragments Receives any unknown ASM fragments encountered during the combinsation search
    * @param scope The scope where the variables are being tested. (Only used for logging)
    * @param program The program to test (used for accessing global data structures)
    */
   static void chooseBestUpliftCombination(
         RegisterCombinationIterator combinationIterator, int maxCombinations,
         Set<String> unknownFragments,
         ScopeRef scope,
         Program program
   ) {
      int bestScore = Integer.MAX_VALUE;
      RegisterCombination bestCombination = null;
      int countCombinations = 0;
      while(combinationIterator.hasNext() && countCombinations < maxCombinations) {
         countCombinations++;
         if(countCombinations % 10000 == 0) {
            program.getLog().append("Uplift attempts [" + scope + "] " + countCombinations + "/" + combinationIterator.getNumIterations() + " (limiting to " + maxCombinations + ")");
         }
         RegisterCombination combination = combinationIterator.next();
         if(!generateCombinationAsm(combination, program, unknownFragments, scope)) {
            continue;
         }
         // If no clobber - Find value of the resulting allocation
         int combinationScore = getAsmScore(program);
         if(program.getLog().isVerboseUplift()) {
            StringBuilder msg = new StringBuilder();
            msg.append("Uplift attempt [" + scope + "] ");
            msg.append(combinationScore);
            msg.append(" allocation: ").append(combination.toString());
            program.getLog().append(msg.toString());
         }
         if(combinationScore < bestScore) {
            bestScore = combinationScore;
            bestCombination = combination;
         }
      }
      if(bestCombination != null) {
         // Save the best combination in the equivalence class
         bestCombination.store(program.getLiveRangeEquivalenceClassSet());
         program.getLog().append("Uplifting [" + scope + "] best " + bestScore + " combination " + bestCombination.toString());
      }
      if(combinationIterator.hasNext()) {
         program.getLog().append("Limited combination testing to " + countCombinations + " combinations of " + combinationIterator.getNumIterations() + " possible.");
      }
   }

   /**
    * Attempt generate ASM with a specific register combination.
    * The generation may result in failure if
    * <ul>
    * <li>The combination has assigned the same register to variables with overlapping live ranges</li>
    * <li>The register combination results in clobbering registers containing values that are still alive</li>
    * <li>some ASM fragments are missing </li>
    * <li>the ALU register is used in a non-applicable way</li>
    * </ul>
    *
    * @param combination The register allocation combination
    * @param unknownFragments Will receive any AsmFragments that can not be found during the ASM code generation
    * @param scope The scope where the combination is tested. (Only used for logging)
    * @return true if the generation was successful
    */
   public static boolean generateCombinationAsm(
         RegisterCombination combination,
         Program program,
         Set<String> unknownFragments,
         ScopeRef scope) {
      // Reset register allocation to original zero page allocation
      new Pass4RegistersFinalize(program).allocate(false);
      // Apply the uplift combination
      combination.allocate(program);
      // Check the register allocation for whether a is register being allocated to two variables with overlapping live ranges
      if(isAllocationOverlapping(program)) {
         if(program.getLog().isVerboseUplift()) {
            StringBuilder msg = new StringBuilder();
            msg.append("Uplift attempt [" + (scope == null ? "" : scope) + "] ");
            msg.append("overlapping");
            msg.append(" allocation: ").append(combination.toString());
            program.getLog().append(msg.toString());
         }

         return false;
      }
      // Generate ASM
      try {
         new Pass4CodeGeneration(program, false).generate();
      } catch(AsmFragmentTemplateSynthesizer.UnknownFragmentException e) {
         unknownFragments.add(e.getFragmentSignature());
         if(program.getLog().isVerboseUplift()) {
            StringBuilder msg = new StringBuilder();
            msg.append("Uplift attempt [" + (scope == null ? "" : scope) + "] ");
            msg.append("missing fragment " + e.getFragmentSignature());
            msg.append(" allocation: ").append(combination.toString());
            program.getLog().append(msg.toString());
         }
         return false;
      } catch(AsmFragmentInstance.AluNotApplicableException e) {
         if(program.getLog().isVerboseUplift()) {
            StringBuilder msg = new StringBuilder();
            msg.append("Uplift attempt [" + (scope == null ? "" : scope) + "] ");
            msg.append("alu not applicable");
            msg.append(" allocation: ").append(combination.toString());
            program.getLog().append(msg.toString());
         }
         return false;
      }
      boolean hasClobberProblem = new Pass4AssertNoCpuClobber(program).hasClobberProblem(false);
      if(hasClobberProblem) {
         if(program.getLog().isVerboseUplift()) {
            StringBuilder msg = new StringBuilder();
            msg.append("Uplift attempt [" + (scope == null ? "" : scope) + "] ");
            msg.append("clobber");
            msg.append(" allocation: ").append(combination.toString());
            program.getLog().append(msg.toString());
         }
         return false;
      }
      return true;
   }

   /**
    * Get the score for the generated ASM program.
    * Programs that take less cycles to execute have lower scores.
    * In practice the score is calculated by multiplying cycles of ASM instructions with
    * an estimate of the invocation count based on the loop depth of the instructions (10^depth).
    *
    * @param program The program containing the ASM to check
    * @return The score of the ASM
    */
   public static int getAsmScore(Program program) {
      int score = 0;
      AsmProgram asm = program.getAsm();
      NaturalLoopSet loopSet = program.getLoopSet();
      for(AsmSegment asmSegment : asm.getSegments()) {
         double asmSegmentCycles = asmSegment.getCycles();
         if(asmSegmentCycles > 0) {
            Integer statementIdx = asmSegment.getStatementIdx();
            int maxLoopDepth = 1;
            if(statementIdx != null) {
               ControlFlowBlock block = program.getStatementInfos().getBlock(statementIdx);
               maxLoopDepth = loopSet.getMaxLoopDepth(block.getLabel());
            }
            score += asmSegmentCycles * Math.pow(10, maxLoopDepth);
         }
      }
      return score;
   }

   /**
    * Check the register allocation for whether a is register being allocated to two variables with overlapping live ranges
    *
    * @param program The program
    * @return true if the register allocation contains an overlapping allocation. false otherwise.
    */
   public static boolean isAllocationOverlapping(Program program) {
      for(ControlFlowBlock block : program.getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(isStatementAllocationOverlapping(program, statement)) {
               return true;
            }
         }
      }
      return false;
   }

   /**
    * Determine if a statement has an overlapping register allocation
    *
    * @param program The program
    * @param statement The statement to check
    * @return true if there is an overlapping register allocation
    */
   private static boolean isStatementAllocationOverlapping(Program program, Statement statement) {
      ProgramScope programScope = program.getScope();
      LiveRangeVariablesEffective.AliveCombinations aliveCombinations = program.getLiveRangeVariablesEffective().getAliveCombinations(statement);
      for(LiveRangeVariablesEffective.CallPath callPath : aliveCombinations.getCallPaths().getCallPaths()) {
         LinkedHashMap<Registers.Register, LiveRangeEquivalenceClass> usedRegisters = new LinkedHashMap<>();
         Collection<VariableRef> alive = aliveCombinations.getEffectiveAliveAtStmt(callPath);
         Pass2AliasElimination.Aliases callPathAliases = aliveCombinations.getEffectiveAliasesAtStmt(callPath);
         for(VariableRef varRef : alive) {
            Variable var = program.getSymbolInfos().getVariable(varRef);
            Registers.Register allocation = var.getAllocation();
            LiveRangeEquivalenceClass allocationClass = usedRegisters.get(allocation);
            if(allocationClass != null && !allocationClass.contains(varRef)) {
               // Examine if the var is an alias of a var in the allocation class
               boolean overlap = true;
               Pass2AliasElimination.AliasSet aliasSet = callPathAliases.findAliasSet(varRef);
               if(aliasSet != null) {
                  for(VariableRef aliasVar : aliasSet.getVars()) {
                     if(allocationClass.contains(aliasVar)) {
                        overlap = false;
                     }
                  }
               }
               if(overlap) {
                  if(program.getLog().isVerboseUplift()) {
                     StringBuilder msg = new StringBuilder();
                     msg.append("Overlap register " + allocation + " in " + statement.toString(program, true));
                     program.getLog().append(msg.toString());
                  }
                  return true;
               }
            } else {
               LiveRangeEquivalenceClass varClass =
                     program.getLiveRangeEquivalenceClassSet().getEquivalenceClass(varRef);
               usedRegisters.put(allocation, varClass);
            }
         }
      }
      return false;
   }

   public void performUplift(int maxCombinations) {
      // Test uplift combinations to find the best one.
      Set<String> unknownFragments = new LinkedHashSet<>();
      List<RegisterUpliftScope> registerUpliftScopes = getProgram().getRegisterUpliftProgram().getRegisterUpliftScopes();
      for(RegisterUpliftScope upliftScope : registerUpliftScopes) {
         RegisterCombinationIterator combinationIterator = upliftScope.getCombinationIterator(getProgram().getRegisterPotentials());
         chooseBestUpliftCombination(
               combinationIterator,
               maxCombinations,
               unknownFragments,
               upliftScope.getScopeRef(),
               getProgram());
      }

      if(unknownFragments.size() > 0) {
         getLog().append("MISSING FRAGMENTS");
         for(String unknownFragment : unknownFragments) {
            getLog().append("  " + unknownFragment);
         }
      }
   }

}

package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.asm.AsmFragment;
import dk.camelot64.kickc.asm.AsmProgram;
import dk.camelot64.kickc.asm.AsmSegment;
import dk.camelot64.kickc.icl.*;

import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

/*** Find the variable equivalence classes to attempt to uplift in each scope */
public class Pass4RegisterUpliftCombinations extends Pass2Base {

   public Pass4RegisterUpliftCombinations(Program program) {
      super(program);
   }

   public void performUplift(int maxCombinations) {
      // Test uplift combinations to find the best one.
      Set<String> unknownFragments = new LinkedHashSet<>();
      List<RegisterUpliftScope> registerUpliftScopes = getProgram().getRegisterUpliftProgram().getRegisterUpliftScopes();
      for (RegisterUpliftScope upliftScope : registerUpliftScopes) {
         int bestScore = Integer.MAX_VALUE;
         RegisterCombination bestCombination = null;

         RegisterCombinationIterator combinationIterator = upliftScope.getCombinationIterator(getProgram().getRegisterPotentials());
         int countCombinations = 0;
         while (combinationIterator.hasNext() && countCombinations < maxCombinations) {
            countCombinations++;
            if (countCombinations % 10000 == 0) {
               getLog().append("Uplift attempts [" + upliftScope.getScopeRef() + "] " + countCombinations + "/" + combinationIterator.getNumIterations() + " (limiting to " + maxCombinations + ")");
            }
            RegisterCombination combination = combinationIterator.next();
            if (!generateAsm(combination, getProgram(), unknownFragments, upliftScope)) {
               continue;
            }
            // If no clobber - Find value of the resulting allocation
            int combinationScore = getAsmScore(getProgram());
            if (getLog().isVerboseUplift()) {
               StringBuilder msg = new StringBuilder();
               msg.append("Uplift attempt [" + upliftScope.getScopeRef() + "] ");
               msg.append(combinationScore);
               msg.append(" allocation: ").append(combination.toString());
               getLog().append(msg.toString());
            }
            if (combinationScore < bestScore) {
               bestScore = combinationScore;
               bestCombination = combination;
            }
         }
         if (bestCombination != null) {
            // Save the best combination in the equivalence class
            bestCombination.store(getProgram().getLiveRangeEquivalenceClassSet());
            getLog().append("Uplifting [" + upliftScope.getScopeRef() + "] best " + bestScore + " combination " + bestCombination.toString());
         }
         if (combinationIterator.hasNext()) {
            getLog().append("Limited combination testing to " + countCombinations + " combinations of " + combinationIterator.getNumIterations() + " possible.");
         }
      }

      if (unknownFragments.size() > 0) {
         getLog().append("MISSING FRAGMENTS");
         for (String unknownFragment : unknownFragments) {
            getLog().append("  " + unknownFragment);
         }
      }


   }

   /**
    * Attempt generate ASM with a specific register combination.
    * The generation may result in failure if
    * <ul>
    *    <li>some ASM fragments are missing </li>
    *    <li>the ALU register is used in a non-applicable way</li>
    *    <li>The register combination results in clobbering registers containing values that are still alive</li>
    * </ul>
    *
    * @param combination The register allocation combination
    * @param unknownFragments Will receive any AsmFragments that can not be found during the ASM code generation
    * @param scope The scope where the combination is tested. (Only used for logging)
    * @return true if the generation was successful
    */
   public static boolean generateAsm(
         RegisterCombination combination, Program program,
         Set<String> unknownFragments,
         RegisterUpliftScope scope) {
      // Reset register allocation to original zero page allocation
      new Pass4RegistersFinalize(program).allocate(false);
      // Apply the uplift combination
      combination.allocate(program.getScope());
      // Generate ASM
      try {
         new Pass4CodeGeneration(program).generate();
      } catch (AsmFragment.UnknownFragmentException e) {
         unknownFragments.add(e.getFragmentSignature());
         if (program.getLog().isVerboseUplift()) {
            StringBuilder msg = new StringBuilder();
            msg.append("Uplift attempt [" + (scope==null?"":scope.getScopeRef()) + "] ");
            msg.append("missing fragment " + e.getFragmentSignature());
            msg.append(" allocation: ").append(combination.toString());
            program.getLog().append(msg.toString());
         }
         return false;
      } catch (AsmFragment.AluNotApplicableException e) {
         if (program.getLog().isVerboseUplift()) {
            StringBuilder msg = new StringBuilder();
            msg.append("Uplift attempt [" + (scope==null?"":scope.getScopeRef()) + "] ");
            msg.append("alu not applicable");
            msg.append(" allocation: ").append(combination.toString());
            program.getLog().append(msg.toString());
         }
         return false;
      }
      boolean hasClobberProblem = new Pass4AssertNoCpuClobber(program).hasClobberProblem(false);
      if (hasClobberProblem) {
         if (program.getLog().isVerboseUplift()) {
            StringBuilder msg = new StringBuilder();
            msg.append("Uplift attempt [" + (scope==null?"":scope.getScopeRef()) + "] ");
            msg.append("clobber");
            msg.append(" allocation: ").append(combination.toString());
            program.getLog().append(msg.toString());
         }
         return false;
      }
      return true;
   }

   public static int getAsmScore(Program program) {
      int score = 0;
      AsmProgram asm = program.getAsm();
      ControlFlowGraph graph = program.getGraph();
      NaturalLoopSet loopSet = program.getLoopSet();
      for (AsmSegment asmSegment : asm.getSegments()) {
         double asmSegmentCycles = asmSegment.getCycles();
         if (asmSegmentCycles > 0) {
            Integer statementIdx = asmSegment.getStatementIdx();
            int maxLoopDepth = 1;
            if (statementIdx != null) {
               ControlFlowBlock block = graph.getBlockFromStatementIdx(statementIdx);
               maxLoopDepth = loopSet.getMaxLoopDepth(block.getLabel());
            }
            score += asmSegmentCycles * Math.pow(10, maxLoopDepth);
         }
      }
      return score;
   }

}

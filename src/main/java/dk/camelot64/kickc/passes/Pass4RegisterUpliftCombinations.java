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
         while (combinationIterator.hasNext() && countCombinations<maxCombinations) {
            countCombinations++;
            if(countCombinations%10000==0) {
               getLog().append("Uplift attempts ["+upliftScope.getScopeRef()+"] "+countCombinations+"/"+combinationIterator.getNumIterations()+" (limiting to "+maxCombinations+")");
            }
            RegisterCombination combination = combinationIterator.next();
            // Reset register allocation to original zero page allocation
            new Pass4RegistersFinalize(getProgram()).allocate(false);
            // Apply the uplift combination
            combination.allocate(getProgram().getScope());
            // Generate ASM
            try {
               new Pass4CodeGeneration(getProgram()).generate();
            } catch (AsmFragment.UnknownFragmentException e) {
               unknownFragments.add(e.getFragmentSignature());
               //StringBuilder msg = new StringBuilder();
               //msg.append("Uplift attempt [" + upliftScope.getScopeRef() + "] ");
               //msg.append("missing fragment " + e.getFragmentSignature());
               //msg.append(" allocation: ").append(combination.toString());
               //getLog().append(msg.toString());
               continue;
            } catch (AsmFragment.AluNotApplicableException e) {
               //StringBuilder msg = new StringBuilder();
               //msg.append("Uplift attempt [" + upliftScope.getScopeRef() + "] ");
               //msg.append("alu not applicable");
               //msg.append(" allocation: ").append(combination.toString());
               //getLog().append(msg.toString());
               continue;
            }
            // If no clobber - Find value of the resulting allocation
            boolean hasClobberProblem = new Pass4AssertNoCpuClobber(getProgram()).hasClobberProblem(false);
            int combinationScore = getAsmScore(getProgram());
            StringBuilder msg = new StringBuilder();
            //msg.append("Uplift attempt [" + upliftScope.getScopeRef() + "] ");
            //if (hasClobberProblem) {
            //   msg.append("clobber");
            //} else {
            //   msg.append(combinationScore);
            //}
            //msg.append(" allocation: ").append(combination.toString());
            //getLog().append(msg.toString());
            if (!hasClobberProblem) {
               if (combinationScore < bestScore) {
                  bestScore = combinationScore;
                  bestCombination = combination;
               }
            }
         }
         if(bestCombination!=null) {
            // Save the best combination in the equivalence class
            bestCombination.store(getProgram().getLiveRangeEquivalenceClassSet());
            getLog().append("Uplifting [" + upliftScope.getScopeRef() + "] best " + bestScore + " combination " + bestCombination.toString());
         }
         if(combinationIterator.hasNext()) {
            getLog().append("Limited combination testing to "+countCombinations+" combinations of "+combinationIterator.getNumIterations()+" possible.");
         }
      }

      if (unknownFragments.size() > 0) {
         getLog().append("MISSING FRAGMENTS");
         for (String unknownFragment : unknownFragments) {
            getLog().append("  " + unknownFragment);
         }
      }


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
            int maxLoopDepth=1;
            if(statementIdx!=null) {
               ControlFlowBlock block = graph.getBlockFromStatementIdx(statementIdx);
               maxLoopDepth = loopSet.getMaxLoopDepth(block.getLabel());
            }
            score += asmSegmentCycles * Math.pow(10, maxLoopDepth);
         }
      }
      return score;
   }

}

package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.values.ScopeRef;
import dk.camelot64.kickc.model.values.VariableRef;
import dk.camelot64.kickc.model.statements.Statement;

import java.util.*;

/**
 * Coalesces zero page registers where their live ranges do not overlap.
 * This step tries to coalesce lvalues with rvalues for all assignments - saving code cycles & bytes code if successful.
 */
public class Pass4ZeroPageCoalesceAssignment extends Pass2Base {

   public Pass4ZeroPageCoalesceAssignment(Program program) {
      super(program);
   }

   public void coalesce() {
      CoalesceVarScores coalesceVarScores = new CoalesceVarScores(getProgram());
      LinkedHashSet<String> unknownFragments = new LinkedHashSet<>();
      Collection<ScopeRef> threadHeads = Pass4ZeroPageCoalesce.getThreadHeads(getProgram());

      boolean change;
      do {
         change = false;
         CoalesceLiveRangeEquivalenceClassScores equivalenceClassScores =
               new CoalesceLiveRangeEquivalenceClassScores(getProgram(), coalesceVarScores);
         List<LiveRangeEquivalenceClassCoalesceCandidate> coalesceCandidates =
               equivalenceClassScores.getCoalesceCandidates();
         for(LiveRangeEquivalenceClassCoalesceCandidate candidate : coalesceCandidates) {
            change |= attemptCoalesce(candidate, threadHeads, unknownFragments);
         }
      } while(change);

      if(unknownFragments.size() > 0) {
         getLog().append("MISSING FRAGMENTS");
         for(String unknownFragment : unknownFragments) {
            getLog().append("  " + unknownFragment);
         }
      }
   }

   private boolean attemptCoalesce(LiveRangeEquivalenceClassCoalesceCandidate candidate, Collection<ScopeRef> threadHeads, LinkedHashSet<String> unknownFragments) {
      LiveRangeEquivalenceClassSet liveRangeEquivalenceClassSet = getProgram().getLiveRangeEquivalenceClassSet();
      List<LiveRangeEquivalenceClass> equivalenceClasses = liveRangeEquivalenceClassSet.getEquivalenceClasses();
      if(equivalenceClasses.contains(candidate.getEc1()) && equivalenceClasses.contains(candidate.getEc2())) {
         // Both equivalence classes still exist
         if(Pass4ZeroPageCoalesce.canCoalesce(candidate.getEc1(), candidate.getEc2(), threadHeads, unknownFragments, getProgram())) {
            getLog().append("Coalescing zero page register with common assignment [ " + candidate.getEc1() + " ] with [ " + candidate.getEc2()+ " ] - score: "+candidate.getScore());
            liveRangeEquivalenceClassSet.consolidate(candidate.getEc1(), candidate.getEc2());
            // Reset the program register allocation
            getProgram().getLiveRangeEquivalenceClassSet().storeRegisterAllocation();
            return true;
         }
      }
      return false;
   }

   /**
    * Scores for coalescing any pair of variables.
    * Scores are increased when one variable is an lvalue and the other an rvalue in an assignment.
    */
   private static class CoalesceVarScores {

      /** Maps var to scores for coalescing with other variables */
      private Map<VariableRef, Map<VariableRef, Integer>> scores;

      public CoalesceVarScores(Program program) {
         this.scores = new LinkedHashMap<>();
         VariableReferenceInfos variableReferenceInfos = program.getVariableReferenceInfos();
         for(ControlFlowBlock block : program.getGraph().getAllBlocks()) {
            for(Statement statement : block.getStatements()) {
               Collection<VariableRef> definedVars = variableReferenceInfos.getDefinedVars(statement);
               Collection<VariableRef> usedVars = variableReferenceInfos.getUsedVars(statement);
               if(definedVars != null && definedVars.size() > 0) {
                  for(VariableRef definedVar : definedVars) {
                     for(VariableRef usedVar : usedVars) {
                        incScore(definedVar, usedVar);
                     }
                  }
               }
            }
         }
      }

      private void incScore(VariableRef definedVar, VariableRef usedVar) {
         setScore(definedVar, usedVar, getScore(definedVar, usedVar) + 1);
         setScore(usedVar, definedVar, getScore(usedVar, definedVar) + 1);
      }

      private void setScore(VariableRef var1, VariableRef var2, Integer score) {
         scores.computeIfAbsent(var1, k -> new LinkedHashMap<>()).put(var2, score);
      }

      public Integer getScore(VariableRef var1, VariableRef var2) {
         Map<VariableRef, Integer> varScores = scores.get(var1);
         if(varScores == null) {
            return 0;
         }
         Integer score = varScores.get(var2);
         if(score == null) {
            return 0;
         }
         return score;
      }

   }

   /**
    * Scores for coalescing any pair of live range equivalence classes.
    * Scores are higher when a variable in one class is an lvalue and a variable in the other an rvalue in an assignment.
    */
   private static class CoalesceLiveRangeEquivalenceClassScores {

      /** Maps var to scores for coalescing with other LiveRangeEquivalenceClass */
      private Map<LiveRangeEquivalenceClass, Map<LiveRangeEquivalenceClass, Integer>> scores;

      public CoalesceLiveRangeEquivalenceClassScores(Program program, CoalesceVarScores varScores) {
         this.scores = new LinkedHashMap<>();
         LiveRangeEquivalenceClassSet liveRangeEquivalenceClassSet = program.getLiveRangeEquivalenceClassSet();
         for(LiveRangeEquivalenceClass thisEquivalenceClass : liveRangeEquivalenceClassSet.getEquivalenceClasses()) {
            for(LiveRangeEquivalenceClass otherEquivalenceClass : liveRangeEquivalenceClassSet.getEquivalenceClasses()) {
               if(!thisEquivalenceClass.equals(otherEquivalenceClass)) {
                  incScore(thisEquivalenceClass, otherEquivalenceClass, varScores);
               }
            }
         }
      }

      private void incScore(LiveRangeEquivalenceClass ec1, LiveRangeEquivalenceClass ec2, CoalesceVarScores varScores) {
         for(VariableRef var1 : ec1.getVariables()) {
            for(VariableRef var2 : ec2.getVariables()) {
               Integer varScore = varScores.getScore(var1, var2);
               if(varScore > 0) {
                  setScore(ec1, ec2, getScore(ec1, ec2) + varScore);
               }
            }
         }
      }

      private void setScore(LiveRangeEquivalenceClass ec1, LiveRangeEquivalenceClass ec2, Integer score) {
         scores.computeIfAbsent(ec1, k -> new LinkedHashMap<>()).put(ec2, score);
      }

      public Integer getScore(LiveRangeEquivalenceClass ec1, LiveRangeEquivalenceClass ec2) {
         Map<LiveRangeEquivalenceClass, Integer> varScores = scores.get(ec1);
         if(varScores == null) {
            return 0;
         }
         Integer score = varScores.get(ec2);
         if(score == null) {
            return 0;
         }
         return score;
      }

      /**
       * Get all candidate pairs of live range equivalence classes for coalescing with a positive score.
       * The returned list is sorted so the candidates with the highest score are first.
       *
       * @return candidate pairs of live range equivalence classes for coalescing with a positive score
       */
      public List<LiveRangeEquivalenceClassCoalesceCandidate> getCoalesceCandidates() {
         ArrayList<LiveRangeEquivalenceClassCoalesceCandidate> candidates = new ArrayList<>();
         for(LiveRangeEquivalenceClass ec1 : scores.keySet()) {
            Map<LiveRangeEquivalenceClass, Integer> ec1Scores = scores.get(ec1);
            for(LiveRangeEquivalenceClass ec2 : ec1Scores.keySet()) {
               Integer score = ec1Scores.get(ec2);
               LiveRangeEquivalenceClassCoalesceCandidate candidate =
                     new LiveRangeEquivalenceClassCoalesceCandidate(ec1, ec2, score);
               if(!candidates.contains(candidate)) {
                  candidates.add(candidate);
               }
            }
         }
         candidates.sort((o1, o2) -> (o2.getScore() - o1.getScore()));
         return candidates;
      }

   }

   /**
    * A pair of live range equivalence classes that are candidates for coalescing.
    * The pair is unordered - meaning it is equal to the pair with the same classes in opposite order.
    */
   private static class LiveRangeEquivalenceClassCoalesceCandidate {
      private LiveRangeEquivalenceClass ec1;
      private LiveRangeEquivalenceClass ec2;
      private Integer score;

      public LiveRangeEquivalenceClassCoalesceCandidate(LiveRangeEquivalenceClass ec1, LiveRangeEquivalenceClass ec2, Integer score) {
         this.ec1 = ec1;
         this.ec2 = ec2;
         this.score = score;
      }

      @Override
      public boolean equals(Object o) {
         if(this == o) return true;
         if(o == null || getClass() != o.getClass()) return false;
         LiveRangeEquivalenceClassCoalesceCandidate that = (LiveRangeEquivalenceClassCoalesceCandidate) o;
         if(ec1.equals(that.ec1) && ec2.equals(that.ec2)) return true;
         if(ec1.equals(that.ec2) && ec2.equals(that.ec1)) return true;
         return false;
      }

      @Override
      public int hashCode() {
         return ec1.hashCode() + ec2.hashCode();
      }

      public Integer getScore() {
         return score;
      }

      public LiveRangeEquivalenceClass getEc1() {
         return ec1;
      }

      public LiveRangeEquivalenceClass getEc2() {
         return ec2;
      }
   }

}

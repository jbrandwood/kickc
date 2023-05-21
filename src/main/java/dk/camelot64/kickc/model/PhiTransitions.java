package dk.camelot64.kickc.model;

import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementPhiBlock;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.values.RValue;
import dk.camelot64.kickc.model.values.VariableRef;

import java.util.*;

/**
 * Keeps track of the phi transitions into a single block during code generation.
 * Used to ensure that duplicate transitions are only code generated once.
 * Also used to ensure that the assignments of each transition is generated in the optimal sequence.
 */
public class PhiTransitions {

   /** The program used for accessing information. */
   private Program program;

   /** The destination block for the phi transitions */
   private Graph.Block toBlock;

   /** The phi-block of the to-block. */
   private StatementPhiBlock phiBlock;

   /** Maps from-block to the transition from the from-block to the to-block. */
   private Map<Graph.Block, PhiTransition> transitions;

   public PhiTransitions(Program program, Graph.Block toBlock) {
      this.program = program;
      this.toBlock = toBlock;
      this.transitions = new LinkedHashMap<>();
      if(toBlock.hasPhiBlock()) {
         this.phiBlock = toBlock.getPhiBlock();
         List<Graph.Block> predecessors = new ArrayList<>(program.getGraph().getPredecessors(toBlock));
         predecessors.sort(Comparator.comparing(o -> o.getLabel().getFullName()));
         for(Graph.Block predecessor : predecessors) {
            PhiTransition transition = findTransition(predecessor);
            transitions.put(predecessor, transition);
         }
      }
   }

   /**
    * Find the transition from a specific fromBlock.
    * If another transition already has the same assignments it is reused. If not a new transition is created.
    *
    * @param fromBlock The block where the transition starts
    * @return The transition into the passed block
    */
   private PhiTransition findTransition(Graph.Block fromBlock) {
      PhiTransition transition = new PhiTransition(fromBlock, toBlock, phiBlock, program);
      boolean isCallTransition = toBlock.getLabel().equals(fromBlock.getCallSuccessor());
      if(!isCallTransition) {
         // If the transition is not a call - then attempt to join with other equal transition(s)
         for(PhiTransition candidate : transitions.values()) {
            if(candidate.equalAssignments(transition)) {
               candidate.addFromBlock(fromBlock);
               return candidate;
            }
         }
      }
      return transition;
   }

   public Collection<Graph.Block> getFromBlocks() {
      return transitions.keySet();
   }

   /**
    * Get the transition into the to-block from a specific from-block
    *
    * @param fromBlock The from-block
    * @return The transition from the from-block into the to-block
    */
   public PhiTransition getTransition(Graph.Block fromBlock) {
      return transitions.get(fromBlock);
   }

   /**
    * Get a phi transition from it's phi transition ID.
    *
    * @param transitionId The ID to look for
    * @return The transition with the given ID, or nulll if not found.
    */
   public PhiTransition getTransition(String transitionId) {
      for(PhiTransition phiTransition : transitions.values()) {
         if(transitionId.equals(phiTransition.getTransitionId())) {
            return phiTransition;
         }
      }
      return null;
   }

   /**
    * A single transition into a to-block.
    * The transition contains the assignments necessary to enter the to-block from specific from-block(s).
    * The transition may be shared between multiple from-blocks, if the assignments are identical.
    */
   public static class PhiTransition {

      /** The program used for accessing information. */
      private Program program;

      /** The block we are entering into. */
      private Graph.Block toBlock;

      /** The phi statement of the to-block. */
      private StatementPhiBlock phiBlock;

      /** The block we are entering from. */
      private List<Graph.Block> fromBlocks;

      /** The assignments when transitioning between the two blocks. */
      private List<PhiTransition.PhiAssignment> assignments;

      private int nextIdx;

      PhiTransition(Graph.Block fromBlock, Graph.Block toBlock, StatementPhiBlock phiBlock, Program program) {
         this.program = program;
         this.toBlock = toBlock;
         this.phiBlock = phiBlock;
         this.fromBlocks = new ArrayList<>();
         this.fromBlocks.add(fromBlock);
         this.nextIdx = 0;
         initAssignments(fromBlock);
      }

      private void initAssignments(Graph.Block fromBlock) {
         this.assignments = new ArrayList<>();
         if(phiBlock != null) {
            List<StatementPhiBlock.PhiVariable> phiVariables = new ArrayList<>(phiBlock.getPhiVariables());
            Collections.reverse(phiVariables);
            for(StatementPhiBlock.PhiVariable phiVariable : phiVariables) {
               List<StatementPhiBlock.PhiRValue> phiRValues = new ArrayList<>(phiVariable.getValues());
               phiRValues.sort(Comparator.comparing(o -> o.getPredecessor().getFullName()));
               for(StatementPhiBlock.PhiRValue phiRValue : phiRValues) {
                  if(phiRValue.getPredecessor().equals(fromBlock.getLabel())) {
                     this.assignments.add(new PhiTransition.PhiAssignment(phiVariable, phiRValue, nextIdx++));
                  }
               }
            }
         }
      }

      /**
       * Get a string ID uniquely identifying the PHI transition within the program
       *
       * @return Transition ID
       */
      public String getTransitionId() {
         StringBuilder id = new StringBuilder();
         id.append("phi:");
         boolean first = true;
         for(Graph.Block fromBlock : fromBlocks) {
            if(!first) {
               id.append("/");
            }
            id.append(fromBlock.getLabel());
            first = false;
         }
         id.append("->").append(toBlock.getLabel());
         return id.toString();
      }

      public List<PhiTransition.PhiAssignment> getAssignments() {
         return assignments;
      }

      void addFromBlock(Graph.Block fromBlock) {
         fromBlocks.add(fromBlock);
      }

      /**
       * Determines if another transition has the exact same assignments as this block
       *
       * @param other The other transition to examine
       * @return true if the assignments are identical
       */
      boolean equalAssignments(PhiTransition other) {
         List<PhiTransition.PhiAssignment> otherAssignments = other.getAssignments();
         if(assignments.size() != otherAssignments.size()) {
            return false;
         }
         for(int i = 0; i < assignments.size(); i++) {
            PhiTransition.PhiAssignment assignment = assignments.get(i);
            PhiTransition.PhiAssignment otherAssignment = otherAssignments.get(i);
            if(assignment.getVariable() != null && otherAssignment.getVariable() != null) {
               Variable var = program.getSymbolInfos().getVariable(assignment.getVariable());
               Variable otherVar = program.getSymbolInfos().getVariable(otherAssignment.getVariable());
               if(!var.getAllocation().equals(otherVar.getAllocation())) {
                  return false;
               }
            } else if(!assignment.getVariable().equals(otherAssignment.getVariable())) {
               return false;
            }
            if(assignment.getrValue() instanceof VariableRef && otherAssignment.getrValue() instanceof VariableRef) {
               Variable var = program.getSymbolInfos().getVariable((VariableRef) assignment.getrValue());
               Variable otherVar = program.getSymbolInfos().getVariable((VariableRef) otherAssignment.getrValue());
               if(!var.getAllocation().equals(otherVar.getAllocation())) {
                  return false;
               }
            } else if(!assignment.getrValue().equals(otherAssignment.getrValue())) {
               return false;
            }
         }
         return true;
      }

      public List<Graph.Block> getFromBlocks() {
         return fromBlocks;
      }

      /**
       * Assignment of a single value during a phi transition
       */
      public class PhiAssignment {

         private StatementPhiBlock.PhiVariable phiVariable;

         private StatementPhiBlock.PhiRValue phiRValue;

         /** The index of the assignment within the transition. */
         private int idx;

         PhiAssignment(StatementPhiBlock.PhiVariable phiVariable, StatementPhiBlock.PhiRValue phiRValue, int idx) {
            this.phiVariable = phiVariable;
            this.phiRValue = phiRValue;
            this.idx = idx;
         }

         public VariableRef getVariable() {
            return phiVariable.getVariable();
         }

         public RValue getrValue() {
            return phiRValue.getrValue();
         }

         public Statement getPhiBlock() {
            return phiBlock;
         }

         public int getAssignmentIdx() {
            return idx;
         }

      }

      @Override
      public boolean equals(Object o) {
         if(this == o) return true;
         if(o == null || getClass() != o.getClass()) return false;
         PhiTransition that = (PhiTransition) o;
         return Objects.equals(toBlock, that.toBlock) &&
               Objects.equals(fromBlocks, that.fromBlocks);
      }

      @Override
      public int hashCode() {
         return Objects.hash(toBlock, fromBlocks);
      }
   }

}

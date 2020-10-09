package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.InternalError;
import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.values.LabelRef;
import dk.camelot64.kickc.model.values.PointerDereference;
import dk.camelot64.kickc.model.values.ScopeRef;
import dk.camelot64.kickc.model.values.VariableRef;

import java.util.*;
import java.util.concurrent.atomic.AtomicBoolean;

/**
 * Identifies loop invariant computations and hoists them out of the loop.
 * http://www.cs.toronto.edu/~pekhimenko/courses/cscd70-w18/docs/Lecture%205%20[LICM%20and%20Strength%20Reduction]%2002.08.2018.pdf
 */
public class Pass2LoopInvariantHoisting extends Pass2SsaOptimization {

   public Pass2LoopInvariantHoisting(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      final NaturalLoopSet loops = getProgram().getLoopSet();
      for(NaturalLoop loop : loops.getLoops()) {
         // Look for loop invariant computations
         List<Statement> hoistStatements = new ArrayList<>();
         for(LabelRef loopBlockRef : loop.getBlocks()) {
            final ControlFlowBlock loopBlock = getGraph().getBlock(loopBlockRef);
            for(Statement statement : loopBlock.getStatements()) {
               if(statement instanceof StatementAssignment) {
                  StatementAssignment assignment = (StatementAssignment) statement;
                  boolean canHoist = isLoopInvariantComputation(assignment, loop);
                  if(canHoist) {
                     hoistStatements.add(statement);
                  }
               }
               // TODO: Calls can also be hoisted under the right circumstances (if they have no other side-effects)
            }
         }

         // Hoist the statements identified
         if(hoistStatements.size() > 0) {
            final StatementInfos statementInfos = getProgram().getStatementInfos();
            // Find or create a loop pre-header block
            ControlFlowBlock preHeaderBlock = getPreHeaderBlock(loop);
            for(Statement hoistStatement : hoistStatements) {
               ControlFlowBlock stmtBlock = statementInfos.getBlock(hoistStatement);
               stmtBlock.getStatements().removeIf(statement -> statement.equals(hoistStatement));
               preHeaderBlock.addStatement(hoistStatement);
               getLog().append("Hoisting  loop invariant computation statement out of loop from: " + stmtBlock.getLabel().toString() + " to " + preHeaderBlock.getLabel().toString() + " " + hoistStatement.toString());
            }
         }
      }
      return false;
   }

   /**
    * Finds or creates pre-header block for a loop.
    * A pre-header is a block guaranteed to be executed exactly once just before entering the header of the loop.
    *
    * @param loop The loop in question
    * @return The existing or newly created pre-header block
    */
   private ControlFlowBlock getPreHeaderBlock(NaturalLoop loop) {
      ControlFlowBlock headBlock = getGraph().getBlock(loop.getHead());
      List<ControlFlowBlock> headPredecessors = getGraph().getPredecessors(headBlock);
      headPredecessors.removeIf(block -> loop.contains(block.getLabel()));
      if(headPredecessors.size() == 1) {
         ControlFlowBlock preHeaderCandidate = headPredecessors.get(0);
         List<ControlFlowBlock> preHeaderCandidatePredecessors = getGraph().getPredecessors(preHeaderCandidate);
         if(preHeaderCandidatePredecessors.size() <= 1)
            return preHeaderCandidate;
      }
      // No pre-header block was found - we create one
      throw new InternalError("No loop pre-header block found for " + loop.toString());
   }

   /**
    * Examine whether an assignment statement can be hoisted out of a loop
    *
    * @param assignment The assignment to examine
    * @param loop The loop containing the assignment
    * @return true if the assignment can be hoisted out of the loop
    */
   private boolean isLoopInvariantComputation(StatementAssignment assignment, NaturalLoop loop) {
      final VariableReferenceInfos variableReferenceInfos = getProgram().getVariableReferenceInfos();
      final StatementInfos statementInfos = getProgram().getStatementInfos();
      final DominatorsGraph dominators = getProgram().getDominators();

      if(statementHasDeref(assignment))
         return false;
      if(isDefinedVarVolatile(assignment, variableReferenceInfos))
         return false;
      if(isUsedVarVolatile(assignment, variableReferenceInfos))
         return false;
      if(isUsedVarDefinedInsideLoop(assignment, loop, variableReferenceInfos, statementInfos))
         return false;
      if(isUsedVarDefinedInOtherScope(assignment, loop, variableReferenceInfos, statementInfos))
         return false;

      if(isDefinedVarUsedOutsideLoop(assignment, loop, variableReferenceInfos, statementInfos))
         if(!statementGuaranteedExecutionInRunthrough(assignment, loop, statementInfos, dominators))
             return false;

      // TODO: Multi-assignment variables may slip through the cracks!

      // TODO: If the statement has side-effects (other than the assignment itself) it cannot be hoisted

      // The assignment is hoistable
      return true;
   }

   /**
    * Is the statement guaranteed to be executed at least once during a run-through of the loop
    * @param assignment The statement
    * @param loop The loop
    * @param statementInfos Statement Info
    * @return true if the statement is guaranteed to be executed at least once during a run-through of the loop
    */
   private boolean statementGuaranteedExecutionInRunthrough(StatementAssignment assignment, NaturalLoop loop, StatementInfos statementInfos, DominatorsGraph dominators) {
      // The statement is guaranteed to be executed at least once if it's block dominates all exits from the loop.
      // Definition: Block D dominates block I if all paths from entry to block I includes block D

      // Find all loop exits
      Collection<LabelRef> loopExits = new ArrayList<>();
      final Set<LabelRef> loopBlocks = loop.getBlocks();
      for(LabelRef loopBlockRef : loopBlocks) {
         final ControlFlowBlock loopBlock = getGraph().getBlock(loopBlockRef);
         final Collection<LabelRef> successorRefs = loopBlock.getSuccessors();
         for(LabelRef successorRef : successorRefs) {
            if(!loopBlocks.contains(successorRef)) {
                loopExits.add(loopBlockRef);
            }
         }
      }

      // Does the assignment dominate all loop exits
      final LabelRef assignmentBlock = statementInfos.getBlockRef(assignment);
      for(LabelRef loopExit : loopExits) {
         final DominatorsBlock loopExitDominators = dominators.getDominators(loopExit);
         if(!loopExitDominators.contains(assignmentBlock))
            return false;
      }

      return true;
   }

   /**
    * Is any variable used (not defined) in a statement defined in another scope?
    *
    * @param assignment The assignment
    * @param loop The loop
    * @param variableReferenceInfos Reference Infos
    * @param statementInfos Statement Infos
    * @return true if any variable used in the statement is defined (assigned) in another scope
    */
   private boolean isUsedVarDefinedInOtherScope(StatementAssignment assignment, NaturalLoop loop, VariableReferenceInfos variableReferenceInfos, StatementInfos statementInfos) {
      // Examine whether any variables used (not defined) are defined outside the loop
      final Collection<VariableRef> usedVars = variableReferenceInfos.getUsedVars(assignment);
      for(VariableRef usedVarRef : usedVars) {
         final Collection<Integer> defineStatements = variableReferenceInfos.getVarDefineStatements(usedVarRef);
         for(Integer defineStmtIdx : defineStatements) {
            final LabelRef defineBlockRef = statementInfos.getBlockRef(defineStmtIdx);
            // Is a used variable defined in another scope
            // TODO: Variables defined in other scopes may be OK - but could be changed inside function calls or have address-of applied to it (and thus be aliased)
            final ScopeRef defineScope = getGraph().getBlock(defineBlockRef).getScope();
            final ScopeRef loopScope = getGraph().getBlock(loop.getHead()).getScope();
            if(!defineScope.equals(loopScope))
               return true;
         }
      }
      return false;
   }

   /**
    * Is any variable used (not defined) in a statement defined elsewhere in the loop?
    *
    * @param assignment The assignment
    * @param loop The loop
    * @param variableReferenceInfos Reference Infos
    * @param statementInfos Statement Infos
    * @return true if any variable used in the statement is also defined (assigned) elsewhere in the loop.
    */
   private boolean isUsedVarDefinedInsideLoop(StatementAssignment assignment, NaturalLoop loop, VariableReferenceInfos variableReferenceInfos, StatementInfos statementInfos) {
      final Collection<VariableRef> usedVars = variableReferenceInfos.getUsedVars(assignment);
      for(VariableRef usedVarRef : usedVars) {
         final Collection<Integer> defineStatements = variableReferenceInfos.getVarDefineStatements(usedVarRef);
         for(Integer defineStmtIdx : defineStatements) {
            final LabelRef defineBlockRef = statementInfos.getBlockRef(defineStmtIdx);
            // Is a used variable defined inside the loop
            if(loop.getBlocks().contains(defineBlockRef))
               return true;
         }
      }
      return false;
   }

   /**
    * Is any variable used (not defined) in a statement volatile
    *
    * @param assignment The assignment
    * @param variableReferenceInfos Reference Infos
    * @return true if any used variable is volatile
    */
   private boolean isUsedVarVolatile(StatementAssignment assignment, VariableReferenceInfos variableReferenceInfos) {
      final Collection<VariableRef> usedVars = variableReferenceInfos.getUsedVars(assignment);
      // Examine whether any variables used (not defined) are defined outside the loop
      for(VariableRef usedVarRef : usedVars) {
         final Variable usedVar = getScope().getVar(usedVarRef);
         // Is a used variable volatile
         if(usedVar.isVolatile())
            return true;
      }
      return false;
   }

   /**
    * Is any variable defined (assigned) in a statement volatile
    *
    * @param assignment The assignment
    * @param variableReferenceInfos Reference Infos
    * @return true if any defined  variable is volatile
    */
   private boolean isDefinedVarVolatile(StatementAssignment assignment, VariableReferenceInfos variableReferenceInfos) {
      Collection<VariableRef> definedVars = variableReferenceInfos.getDefinedVars(assignment);
      for(VariableRef definedVarRef : definedVars) {
         Variable definedVar = getScope().getVar(definedVarRef);
         // Is the assigned variable volatile
         if(definedVar.isVolatile())
            return true;
      }
      return false;
   }

   /**
    * Does the statement have any pointer dereference
    *
    * @param assignment The assignment
    * @return true if there is any pointer dereference in the statement
    */
   private boolean statementHasDeref(StatementAssignment assignment) {
      if(Operators.DEREF.equals(assignment.getOperator()) || Operators.DEREF_IDX.equals(assignment.getOperator()))
         return true;
      AtomicBoolean hasDeref = new AtomicBoolean(false);
      // Look through the expression
      ProgramValueIterator.execute(assignment, (programValue, currentStmt, stmtIt, currentBlock) -> {
         if(programValue.get() instanceof PointerDereference) {
            // TODO: Some pointer derefs can be hoisted! Examine volatiles, assignment to pointers and maybe aliasing.
            hasDeref.set(true);
         }
      }, null, null);
      return hasDeref.get();
   }

   /**
    * Is the variable defined (assigned) used anywhere outside the loop
    *
    * @param assignment The assignment
    * @param loop The loop
    * @param variableReferenceInfos Reference Infos
    * @param statementInfos Statement Infos
    * @return true if the defined (assigned) variable is used anywhere outside the loop
    */
   private boolean isDefinedVarUsedOutsideLoop(StatementAssignment assignment, NaturalLoop loop, VariableReferenceInfos variableReferenceInfos, StatementInfos statementInfos) {
      Collection<VariableRef> definedVars = variableReferenceInfos.getDefinedVars(assignment);
      for(VariableRef definedVarRef : definedVars) {
         // Is the defined variable ever used outside the loop?
         final Collection<Integer> definedVarUsages = variableReferenceInfos.getVarUseStatements(definedVarRef);
         for(Integer definedVarUsage : definedVarUsages) {
            final LabelRef definedVarUsageBlockRef = statementInfos.getBlockRef(definedVarUsage);
            if(!loop.getBlocks().contains(definedVarUsageBlockRef))
               return true;
         }
      }
      return false;
   }

}

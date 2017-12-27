package dk.camelot64.kickc.passes;

/**
 * Identify the alive intervals for all variables. Add the intervals to the ProgramScope.
 */

import dk.camelot64.kickc.model.*;

import java.util.*;

public class Pass3LiveRangesAnalysis extends Pass2Base {

   public Pass3LiveRangesAnalysis(Program program) {
      super(program);
   }

   public void findLiveRanges() {
      LiveRangeVariables liveRanges = new LiveRangeVariables(getProgram());
      boolean propagating;
      do {
         propagating = calculateLiveRanges(liveRanges);
         getProgram().setLiveRangeVariables(liveRanges);
         getLog().append("Propagating live ranges...");
         if (getLog().isVerboseLiveRanges()) {
            getLog().append("CONTROL FLOW GRAPH - LIVE RANGES IN PROGRESS");
            getLog().append(getProgram().getGraph().toString(getProgram()));
         }
      } while (propagating);
   }

   /**
    * Runs through all statements propagating variable live ranges.
    * Variable live ranges of a statement is defined as all variables that are defined before or in the statement and used after the statement.
    * Variable live ranges are propagated through repeatedly executing the following for each statement:
    * <p>
    * <code>alive(stmt) = used(nextstmt) &cup; alive(nextstmt) &#x2216; defined(nextstmt)</code>
    * <p>
    *  where
    *  <ul>
    *     <li>alive(stmt) is the alive variables of the statement</li>
    *     <li>used(stmt) is the variables used in the statement</li>
    *     <li>defined(stmt) is the variables defined by the statement</li>
    *     <li>nextstmt is the statement following the statement stmt</li>
    *  </ul>
    *
    *  Special consideration is giving when handling statements at the end/start of blocks, as multiple blocks may jump to the same block resulting in multiple stmt/nextstmt pairs.
    *  Calls to methods are also given special consideration.
    *  Variables used inside the method must be propagated bak to all callers while variables not used inside the method must skip the method entirely back to the statement before the call.
    *
    * @param liveRanges The live ranges to propagate.
    * @return true if any live ranges was modified. false if no modification was performed (and the propagation is complete)
    */
   private boolean calculateLiveRanges(LiveRangeVariables liveRanges) {
      VariableReferenceInfos referenceInfo = getProgram().getVariableReferenceInfos();
      boolean modified = false;
      for (ControlFlowBlock block : getProgram().getGraph().getAllBlocks()) {
         for (Statement stmt : block.getStatements()) {
            List<VariableRef> aliveNextStmt = liveRanges.getAlive(stmt);
            Collection<VariableRef> definedNextStmt = referenceInfo.getDefinedVars(stmt);
            initLiveRange(liveRanges, definedNextStmt);
            Collection<PreviousStatement> previousStmts = getPreviousStatements(stmt);
            for (PreviousStatement previousStmt : previousStmts) {
               if (PreviousStatement.Type.NORMAL.equals(previousStmt.getType())) {
                  // Add all used variables to the previous statement (taking into account phi from blocks)
                  modified |= initUsedVars(liveRanges, stmt, previousStmt);
                  // Add all vars alive in the next statement
                  for (VariableRef aliveVar : aliveNextStmt) {
                     if (!definedNextStmt.contains(aliveVar)) {
                        boolean addAlive = liveRanges.addAlive(aliveVar, previousStmt.getStatement());
                        modified |= addAlive;
                        if (addAlive && getLog().isVerboseLiveRanges()) {
                           getLog().append("Propagated alive var " + aliveVar + " to " + previousStmt.getStatement());
                        }
                     }
                  }
               } else if (PreviousStatement.Type.LAST_IN_METHOD.equals(previousStmt.getType())) {
                  // Add all vars that are referenced in the method
                  StatementCall call = (StatementCall) stmt;
                  ProcedureRef procedure = call.getProcedure();
                  Collection<VariableRef> procUsed = referenceInfo.getReferencedVars(procedure.getLabelRef());
                  // The call statement has no used or defined by itself so only work with the alive vars
                  for (VariableRef aliveVar : aliveNextStmt) {
                     // Add all variables to previous that are not used inside the method
                     if (procUsed.contains(aliveVar)) {
                        boolean addUsedVar = liveRanges.addAlive(aliveVar, previousStmt.getStatement());
                        modified |= addUsedVar;
                        if (addUsedVar && getLog().isVerboseLiveRanges()) {
                           getLog().append("Propagated alive var used in method into method " + aliveVar + " to " + previousStmt.getStatement());
                        }
                     }
                  }
               } else if (PreviousStatement.Type.SKIP_METHOD.equals(previousStmt.getType())) {
                  // Add all vars that the method does not use
                  StatementCall call = (StatementCall) stmt;
                  ProcedureRef procedure = call.getProcedure();
                  Collection<VariableRef> procUsed = referenceInfo.getReferencedVars(procedure.getLabelRef());
                  // The call statement has no used or defined by itself so only work with the alive vars
                  for (VariableRef aliveVar : aliveNextStmt) {
                     // Add all variables to previous that are not used inside the method
                     if (!procUsed.contains(aliveVar)) {
                        boolean addSkipVar = liveRanges.addAlive(aliveVar, previousStmt.getStatement());
                        modified |= addSkipVar;
                        if (addSkipVar && getLog().isVerboseLiveRanges()) {
                           getLog().append("Propagated alive var unused in method by skipping call " + aliveVar + " to " + previousStmt.getStatement());
                        }
                     }
                  }
               } else if (PreviousStatement.Type.BEFORE_METHOD.equals(previousStmt.getType())) {
                  // Add all used variables to the previous statement (taking into account phi from blocks)
                  modified |= initUsedVars(liveRanges, stmt, previousStmt);
                  // Add all alive variables to previous that are used inside the method
                  ControlFlowBlock procBlock = getProgram().getStatementInfos().getBlock(stmt);
                  Procedure procedure = (Procedure) getProgram().getScope().getSymbol(procBlock.getLabel());
                  Collection<VariableRef> procUsed = referenceInfo.getUsedVars(procedure.getRef().getLabelRef());
                  // The call statement has no used or defined by itself so only work with the alive vars
                  for (VariableRef aliveVar : aliveNextStmt) {
                     // Add all variables to previous that are used inside the method
                     if (procUsed.contains(aliveVar)) {
                        if (!definedNextStmt.contains(aliveVar)) {
                           boolean usedVar = liveRanges.addAlive(aliveVar, previousStmt.getStatement());
                           modified |= usedVar;
                           if (usedVar && getLog().isVerboseLiveRanges()) {
                              getLog().append("Propagated alive used in method out of method " + aliveVar + " to " + previousStmt.getStatement());
                           }
                        }
                     } else {
                        // Do nothing
                        // getLog().append("Not propagating "+aliveVar.toString(getProgram()) +" in BEFORE_METHOD case from "+stmt.toString(getProgram(), false)+ " to "+previousStmt.getStatement().toString(getProgram(), false));
                     }
                  }
               }
            }
         }
      }
      return modified;
   }

   /**
    * Adds variables used in the next statement to the alive vars of the previous statement
    *
    * @param liveRanges The live ranges to be updated
    * @param stmt The next statement
    * @param previousStmt The previous statement
    * @return true if any live range modification was made
    */
   private boolean initUsedVars(
         LiveRangeVariables liveRanges,
         Statement stmt,
         PreviousStatement previousStmt) {
      boolean modified = false;
      VariableReferenceInfos referenceInfo = getProgram().getVariableReferenceInfos();
      Collection<VariableRef> usedNextStmt = referenceInfo.getUsedVars(stmt);
      if (stmt instanceof StatementPhiBlock) {
         // If current statement is a phi add the used variables to previous based on the phi entries
         StatementPhiBlock phi = (StatementPhiBlock) stmt;
         ControlFlowBlock previousBlock =
               getProgram().getStatementInfos().getBlock(previousStmt.getStatement());
         for (StatementPhiBlock.PhiVariable phiVariable : phi.getPhiVariables()) {
            for (StatementPhiBlock.PhiRValue phiRValue : phiVariable.getValues()) {
               if (phiRValue.getPredecessor().equals(previousBlock.getLabel())) {
                  if (phiRValue.getrValue() instanceof VariableRef) {
                     VariableRef usedVar = (VariableRef) phiRValue.getrValue();
                     boolean addUsed = liveRanges.addAlive(usedVar, previousStmt.getStatement());
                     modified |= addUsed;
                     if (addUsed && getLog().isVerboseLiveRanges()) {
                        getLog().append("Adding used phi var " + usedVar + " to " + previousStmt.getStatement());
                     }
                  }
               }
            }
         }
      } else {
         // Not a phi block - add used vars to all previous blocks
         for (VariableRef usedVar : usedNextStmt) {
            boolean addUsed = liveRanges.addAlive(usedVar, previousStmt.getStatement());
            modified |= addUsed;
            if (addUsed && getLog().isVerboseLiveRanges()) {
               getLog().append("Adding used var " + usedVar + " to " + previousStmt.getStatement());
            }
         }
      }
      return modified;
   }



   /** A statement just before the current statement. */
   private static class PreviousStatement {

      /** The statement */
      private Statement statement;

      /** The type. */
      private Type type;

      public enum Type {
         /** The previous statement is executed immediately before the current statement.
          * It may be in the same block as the current statement or a preceding block if the current statement is the first in a block. */
         NORMAL,
         /** The previous statement is the last in a method. The current statement is the call to the method. */
         LAST_IN_METHOD,
         /** The previous statement is the statement just before a method. The current statement is the first statement inside the method.
          * (Used for propagating variables used inside the method back to the calling context)*/
         BEFORE_METHOD,
         /** The previous statement is the statement before a call to a method, the current statement is the call
          * (used for propagating variables that are not not used by the called method to statements before the call)*/
         SKIP_METHOD
      }

      PreviousStatement(Statement statement, Type type) {
         this.statement = statement;
         this.type = type;
      }

      public Statement getStatement() {
         return statement;
      }

      public Type getType() {
         return type;
      }

   }

   /**
    * Find the statement(s) executed just before the passed statement.
    * There may be multiple previous statements if the current statement is the first in a block.
    * @param statement The statement to find previous for
    * @return statement(s) executed just before the passed statement
    */
   private Collection<PreviousStatement> getPreviousStatements(Statement statement) {
      ArrayList<PreviousStatement> previousStatements = new ArrayList<>();
      // Find the statement(s) just before the current statement (disregarding if the current statement is a call - this will be handled later)
      Collection<Statement> precedingStatements = getPrecedingStatement(statement);
      if (statement instanceof StatementCall) {
         // Add the statement(s) just before the call
         for (Statement precedingStatement : precedingStatements) {
            previousStatements.add(new PreviousStatement(precedingStatement, PreviousStatement.Type.SKIP_METHOD));
         }
         // Add the last statement of the called method
         StatementCall call = (StatementCall) statement;
         ProcedureRef procedure = call.getProcedure();
         LabelRef procedureReturnBlock = procedure.getReturnBlock();
         ControlFlowBlock returnBlock = getProgram().getGraph().getBlock(procedureReturnBlock);
         Collection<Statement> lastStatements = getLastInBlock(returnBlock);
         for (Statement lastStatement : lastStatements) {
            previousStatements.add(new PreviousStatement(lastStatement, PreviousStatement.Type.LAST_IN_METHOD));
         }
      } else if (precedingStatements.size() > 0) {
         // The normal situation where the preceding statements are just normal statements executed before the current statement
         for (Statement precedingStatement : precedingStatements) {
            previousStatements.add(new PreviousStatement(precedingStatement, PreviousStatement.Type.NORMAL));
         }
      } else {
         // No preceding statements. Examine if this is the first statement in a call.
         ControlFlowBlock block = getProgram().getStatementInfos().getBlock(statement);
         if (block.isProcedureEntry(getProgram())) {
            // Current is first statement of a call - add the statement preceding the call.
            Collection<CallGraph.CallBlock.Call> callers = getProgram().getCallGraph().getCallers(block.getLabel());
            for (CallGraph.CallBlock.Call call : callers) {
               Statement callStmt = getProgram().getStatementInfos().getStatement(call.getCallStatementIdx());
               Collection<Statement> precedingCallStmt = getPrecedingStatement(callStmt);
               for (Statement precedingCall : precedingCallStmt) {
                  previousStatements.add(new PreviousStatement(precedingCall, PreviousStatement.Type.BEFORE_METHOD));
               }
            }
         }
      }
      return previousStatements;
   }

   /**
    * Ensures that all defined vars have a non-zero live range
    * @param liveRanges The live ranges
    * @param defined The variables to init live ranges for
    */
   private void initLiveRange(LiveRangeVariables liveRanges, Collection<VariableRef> defined) {
      if (defined != null) {
         for (VariableRef variableRef : defined) {
            LiveRange lValLiveRange = liveRanges.getLiveRange(variableRef);
            if (lValLiveRange == null) {
               liveRanges.addEmptyAlive(variableRef);
               if(getProgram().getLog().isVerboseLiveRanges()) {
                  getProgram().getLog().append("Adding empty live range for unused variable " + variableRef);
               }
            }
         }
      }
   }


   /**
    * Gets all statements preceding a statement directly in the code.
    * This ignores calls and just returns the statement preceding the call.
    * @param statement The statement to look for a preceding statement for
    * @return The preceding statement(s).
    * Multiple statements are returned if the current statement is the first in a block with multiple predecessor blocks.
    * Zero statements are returned if the current statement is the first statement in the program or the first statement in a method.
    */
   private Collection<Statement> getPrecedingStatement(Statement statement) {
      Statement previousStmt = null;
      Statement prev = null;
      ControlFlowBlock block = getProgram().getStatementInfos().getBlock(statement);
      List<Statement> statements = block.getStatements();
      for (Statement stmt : statements) {
         if (statement.getIndex().equals(stmt.getIndex())) {
            previousStmt = prev;
            break;
         }
         prev = stmt;
      }
      Collection<Statement> previous;
      if (previousStmt != null) {
         previous = Arrays.asList(previousStmt);
      } else {
         // Current is first in a block - look in predecessor blocks
         previous = getLastInPredecessors(block);
      }
      return previous;
   }

   /**
    * Find the last statement(s) of a block. Can trace back through predecessor blocks - but not back through calls.
    * @param block The block
    * @return The last statement(s). May contain multiple statements if the block is empty and has multiple predecessors.
    * This method never traces back through calls, so the result may also be empty (if the block is an empty method).
    */
   private Collection<Statement> getLastInBlock(ControlFlowBlock block) {
      List<Statement> statements = block.getStatements();
      if (statements.size() > 0) {
         return Arrays.asList(statements.get(statements.size() - 1));
      } else {
         // Trace back through direct/conditional predecessors (not calls)
         return getLastInPredecessors(block);
      }
   }

   /**
    * Find the last statement(s) in the predecessors of a block. Can trace back through predecessor blocks - but not back through calls.
    * @param block The block
    * @return The last statement(s). May contain multiple statements if the block is empty and has multiple predecessors.
    * This method never traces back through calls, so the result may also be empty (if the block is an empty method).
    */
   private Collection<Statement> getLastInPredecessors(ControlFlowBlock block) {
      List<ControlFlowBlock> predecessors = getProgram().getGraph().getPredecessors(block);
      ArrayList<Statement> last = new ArrayList<>();
      for (ControlFlowBlock predecessor : predecessors) {
         if (block.getLabel().equals(predecessor.getDefaultSuccessor()) || block.getLabel().equals(predecessor.getConditionalSuccessor())) {
            last.addAll(getLastInBlock(predecessor));
         }
      }
      return last;
   }

}

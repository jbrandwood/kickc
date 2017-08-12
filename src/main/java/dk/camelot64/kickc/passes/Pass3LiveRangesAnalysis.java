package dk.camelot64.kickc.passes;

/**
 * Identify the alive intervals for all variables. Add the intervals to the ProgramScope.
 */

import dk.camelot64.kickc.icl.*;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class Pass3LiveRangesAnalysis extends Pass2Base {

   public Pass3LiveRangesAnalysis(Program program) {
      super(program);
   }

   public void findLiveRanges() {

      generateStatementIndexes();

      LiveRangeVariables liveRanges = initializeLiveRanges();
      getProgram().setLiveRangeVariables(liveRanges);
      //getLog().append("CONTROL FLOW GRAPH - LIVE RANGES");
      //getLog().append(getProgram().getGraph().toString(getProgram()));

      boolean propagating;
      do {
         propagating = propagateLiveRanges(liveRanges);
         getProgram().setLiveRangeVariables(liveRanges);
         getLog().append("Propagating live ranges...");
         //getLog().append("CONTROL FLOW GRAPH - LIVE RANGES");
         //getLog().append(getProgram().getGraph().toString(getProgram()));
      } while (propagating);

      getProgram().setLiveRangeVariables(liveRanges);
   }


   /**
    * Create index numbers for all statements in the control flow graph.
    */
   private void generateStatementIndexes() {
      int currentIdx = 0;
      for (ControlFlowBlock block : getProgram().getGraph().getAllBlocks()) {
         for (Statement statement : block.getStatements()) {
            statement.setIndex(currentIdx++);
         }
      }
   }

   /**
    * Create initial live ranges for all variables used in the program.
    * The initial live ranges include only the statements preceding a usage of a variable. The live ranges will be extended iteratively afterwards.
    *
    * @return The initial live ranges.
    */
   private LiveRangeVariables initializeLiveRanges() {
      LiveRangeInitializer liveRangeInitializer = new LiveRangeInitializer(getProgram());
      return liveRangeInitializer.initialize();
   }

   private static class LiveRangeInitializer extends ControlFlowGraphBaseVisitor<Void> {

      private final Program program;
      private LiveRangeVariables liveRanges;

      /**
       * Contains the previous statement through the iteration of each block. null if this statement is the first in the block.
       */
      private Statement previousStatement;
      /**
       * Contains the current block through the iteration. Used to find previous statement(s) when at the start of a block.
       */
      private ControlFlowBlock currentBlock;

      public LiveRangeInitializer(Program program) {
         this.program = program;
         this.liveRanges = new LiveRangeVariables();
      }

      public LiveRangeVariables initialize() {
         this.visitGraph(program.getGraph());
         return liveRanges;
      }

      @Override
      public Void visitBlock(ControlFlowBlock block) {
         this.currentBlock = block;
         this.previousStatement = null;
         return super.visitBlock(block);
      }

      @Override
      public Void visitStatement(Statement statement) {
         super.visitStatement(statement);
         this.previousStatement = statement;
         return null;
      }

      private void addInitialLiveRange(RValue rValue) {
         if (rValue == null) {
            return;
         } else if (rValue instanceof Constant) {
            return;
         } else if (rValue instanceof PointerDereferenceSimple) {
            addInitialLiveRange(((PointerDereferenceSimple) rValue).getPointer());
         } else if (rValue instanceof PointerDereferenceIndexed) {
            addInitialLiveRange(((PointerDereferenceIndexed) rValue).getPointer());
            addInitialLiveRange(((PointerDereferenceIndexed) rValue).getIndex());
         } else if (rValue instanceof VariableRef) {
            if (previousStatement != null) {
               // Inside a block - add live range to previous statement
               liveRanges.addAlive((VariableRef) rValue, previousStatement);
            } else {
               // At start of block without a phi block - add live range at end of all previous blocks
               List<ControlFlowBlock> predecessors = program.getGraph().getPredecessors(currentBlock);
               for (ControlFlowBlock predecessor : predecessors) {
                  List<Statement> predecessorStatements = predecessor.getStatements();
                  Statement predecessorLastStatement = predecessorStatements.get(predecessorStatements.size() - 1);
                  liveRanges.addAlive((VariableRef) rValue, predecessorLastStatement);
               }
            }
         } else {
            throw new RuntimeException("Unhandled RValue type " + rValue);
         }
      }

      @Override
      public Void visitPhiBlock(StatementPhiBlock phi) {
         for (StatementPhiBlock.PhiVariable phiVariable : phi.getPhiVariables()) {
            for (StatementPhiBlock.PhiRValue phiRValue : phiVariable.getValues()) {
               if (phiRValue.getrValue() instanceof Constant) {
                  continue;
               } else {
                  LabelRef predecessorRef = phiRValue.getPredecessor();
                  ControlFlowBlock predecessor = program.getGraph().getBlock(predecessorRef);
                  List<Statement> predecessorStatements = predecessor.getStatements();
                  // Is this block a procedure called from the predecessor?
                  if (currentBlock.getLabel().equals(predecessor.getCallSuccessor())) {
                     // Add to last statement before call in predecessor
                     StatementCall callStatement = (StatementCall) predecessorStatements.get(predecessorStatements.size() - 1);
                     if (predecessorStatements.size() > 1) {
                        Statement predecessorLastStatementBeforeCall = predecessorStatements.get(predecessorStatements.size() - 2);
                        liveRanges.addAlive((VariableRef) phiRValue.getrValue(), predecessorLastStatementBeforeCall);
                     }
                  } else {
                     // Add to last statement of predecessor
                     Statement predecessorLastStatement = predecessorStatements.get(predecessorStatements.size() - 1);
                     liveRanges.addAlive((VariableRef) phiRValue.getrValue(), predecessorLastStatement);
                  }
               }
            }
         }
         return null;
      }

      @Override
      public Void visitCall(StatementCall call) {
         if (call.getlValue() instanceof PointerDereferenceIndexed) {
            addInitialLiveRange(((PointerDereferenceIndexed) call.getlValue()).getPointer());
            addInitialLiveRange(((PointerDereferenceIndexed) call.getlValue()).getIndex());
         } else if (call.getlValue() instanceof PointerDereferenceSimple) {
            addInitialLiveRange(((PointerDereferenceSimple) call.getlValue()).getPointer());
         }
         if (call.getParameters() != null) {
            for (RValue parameter : call.getParameters()) {
               addInitialLiveRange(parameter);
            }
         }
         return null;
      }

      @Override
      public Void visitReturn(StatementReturn aReturn) {
         if (aReturn.getValue() != null) {
            addInitialLiveRange(aReturn.getValue());
         }
         return null;
      }

      @Override
      public Void visitAssignment(StatementAssignment assignment) {
         if (assignment.getlValue() instanceof PointerDereferenceIndexed) {
            addInitialLiveRange(((PointerDereferenceIndexed) assignment.getlValue()).getPointer());
            addInitialLiveRange(((PointerDereferenceIndexed) assignment.getlValue()).getIndex());
         } else if (assignment.getlValue() instanceof PointerDereferenceSimple) {
            addInitialLiveRange(((PointerDereferenceSimple) assignment.getlValue()).getPointer());
         }
         addInitialLiveRange(assignment.getrValue1());
         addInitialLiveRange(assignment.getrValue2());
         return null;
      }

      @Override
      public Void visitConditionalJump(StatementConditionalJump conditionalJump) {
         addInitialLiveRange(conditionalJump.getrValue1());
         addInitialLiveRange(conditionalJump.getrValue2());
         return null;
      }

   }

   /**
    * Propagate live ranges to previous statements until reaching the definition of the variable.
    *
    * @return true if any propagation was done. (and more propagation is necessary to complete the live ranges)
    */
   private boolean propagateLiveRanges(LiveRangeVariables liveRanges) {
      LiveRangePropagator liveRangePropagator = new LiveRangePropagator(getProgram(), liveRanges);
      return liveRangePropagator.propagate();
   }

   private static class LiveRangePropagator extends ControlFlowGraphBaseVisitor<Void> {

      /**
       * The program.
       */
      private Program program;

      /**
       * The variable live ranges being propagated.
       */
      private LiveRangeVariables liveRanges;

      /**
       * Has anything been modified.
       */
      private boolean modified;

      /**
       * Contains the previous statement through the iteration of each block. null if this statement is the first in the block.
       */
      private Statement previousStatement;

      /**
       * Contains the current block through the iteration. Used to find previous statement(s) when at the start of a block.
       */
      private ControlFlowBlock currentBlock;

      public LiveRangePropagator(Program program, LiveRangeVariables liveRanges) {
         this.program = program;
         this.liveRanges = liveRanges;
         this.modified = false;
      }

      public boolean propagate() {
         this.visitGraph(program.getGraph());
         return modified;
      }

      @Override
      public Void visitBlock(ControlFlowBlock block) {
         this.currentBlock = block;
         this.previousStatement = null;
         return super.visitBlock(block);
      }

      @Override
      public Void visitStatement(Statement statement) {
         super.visitStatement(statement);
         this.previousStatement = statement;
         return null;
      }

      /**
       * Propagate variable live ranges backward from a statement to a previous statement
       *
       * @param statement The current statement
       * @param previous  The previous statement
       * @param defined   The lValues assigned in the current statement (will not be propagated)
       */
      private void propagate(Statement statement, List<PreviousStatement> previous, List<? extends LValue> defined) {
         List<VariableRef> alive = getAliveNotDefined(statement, defined);

         // Add all non-defined alive vars to all previous statement
         for (VariableRef var : alive) {
            for (PreviousStatement prev : previous) {
               if(prev.isCaller()) {
                  // Special handling of propagation back to calls
                  // Only propagate vars also alive on the call itself
                  // And propagate them back to the statement prior to the call itself
                  StatementCall call = (StatementCall) prev.getStatement();
                  List<VariableRef> callAlive = liveRanges.getAlive(call);
                  if (callAlive.contains(var)) {
                     ControlFlowBlock callBlock = program.getGraph().getBlockFromStatementIdx(call.getIndex());
                     List<Statement> callBlockStatements = callBlock.getStatements();
                     Statement lastBeforeCall = callBlockStatements.get(callBlockStatements.size() - 2);
                     modified |= liveRanges.addAlive(var, lastBeforeCall);
                     program.getLog().append("Propagated " + var + " through call " + call);
                  }
               } else {
                  modified |= liveRanges.addAlive(var, prev.getStatement());
               }
            }
         }
         ensureDefined(defined);
      }

      /**
       * Propagate live ranges back from a pricedure to the statements previous to the call og the procedure.
       * <p>
       * Only variables also alive after the call are propagated further backward.
       *
       * @param procBlock The block starting the procedure
       * @param phi       The phi statement at the start of the current block
       * @param defined   The variables defined by the phi statement
       */
      private void propagateCall(ControlFlowBlock procBlock, StatementPhiBlock phi, List<VariableRef> defined) {
         List<VariableRef> alive = getAliveNotDefined(phi, defined);
         if (alive.size() > 0) {
            // Go back through each call
            for (ControlFlowBlock predecessor : program.getGraph().getPredecessors(procBlock)) {
               // If this block is a procedure called from the predecessor - the last statement is the one before the call
               if (procBlock.getLabel().equals(predecessor.getCallSuccessor())) {
                  List<Statement> predecessorStatements = predecessor.getStatements();
                  StatementCall call = (StatementCall) predecessorStatements.get(predecessorStatements.size() - 1);
                  if (predecessorStatements.size() > 1) {
                     Statement lastBeforeCall = predecessorStatements.get(predecessorStatements.size() - 2);

                     List<VariableRef> callAlive = liveRanges.getAlive(call);
                     // Add all non-defined alive vars to all previous statement
                     for (VariableRef var : alive) {
                        // Only add the variables that are alive on the actual call (and thereby used after the call)
                        if (callAlive.contains(var)) {
                           modified |= liveRanges.addAlive(var, lastBeforeCall);
                           program.getLog().append("Propagated " + var + " through call " + call);
                        }
                     }

                  }
               }
            }
         }
         ensureDefined(defined);
      }


      /**
       * Get the variables that are alive at a specific statemtn and not defined by the statement itself
       *
       * @param statement The statement
       * @param defined   The variables defined by the statement
       * @return
       */
      private List<VariableRef> getAliveNotDefined(Statement statement, List<? extends LValue> defined) {
         List<VariableRef> alive = liveRanges.getAlive(statement);
         if (defined != null) {
            for (LValue lValue : defined) {
               if (lValue instanceof VariableRef) {
                  // Remove the defined variable
                  alive.remove(lValue);
               }
            }
         }
         return alive;
      }


      /**
       * If any lValues do not have a live range (they are never used) - create an empty live range for them
       */
      private void ensureDefined(List<? extends LValue> defined) {
         if (defined != null) {
            for (LValue lValue : defined) {
               if (lValue instanceof VariableRef) {
                  LiveRange lValLiveRange = liveRanges.getLiveRange((VariableRef) lValue);
                  if (lValLiveRange == null) {
                     liveRanges.addEmptyAlive((VariableRef) lValue);
                     program.getLog().append("Adding empty live range for unused variable " + lValue);
                  }
               }

            }
         }
      }

      private static class PreviousStatement {
         /** The statement */
         private Statement statement;
         /** true if the statement is in a block that is a caller of the current block. false if the statement is a direct predecessor statement. */
         private boolean caller;

         public PreviousStatement(Statement statement, boolean caller) {
            this.statement = statement;
            this.caller = caller;
         }

         public Statement getStatement() {
            return statement;
         }

         public boolean isCaller() {
            return caller;
         }
      }


      private List<PreviousStatement> getPreviousStatements() {
         if (previousStatement != null) {
            // Inside a block
            return Arrays.asList(new PreviousStatement(previousStatement, false));
         } else {
            // At start of block - add last statement of all previous blocks
            return getPreviousStatements(this.currentBlock, false);
         }
      }

      /**
       * Get the statement executed just before entering a specific block
       *
       * @param block The block to find the previous statement for
       * @return The statement executed just before entering the block.
       * If there are several predecessor blocks multiple statements are returned.
       */
      private ArrayList<PreviousStatement> getPreviousStatements(ControlFlowBlock block, boolean isCaller) {
         ArrayList<PreviousStatement> statements = new ArrayList<>();
         List<ControlFlowBlock> predecessors = program.getGraph().getPredecessors(block);
         for (ControlFlowBlock predecessor : predecessors) {
            boolean isSubCaller = block.getLabel().equals(predecessor.getCallSuccessor());
            ArrayList<PreviousStatement> lastStatements = getLastStatements(predecessor, isCaller||isSubCaller);
            statements.addAll(lastStatements);
         }
         return statements;
      }

      /**
       * Get the last statement executed in a specific block.
       * If the block is empty the last statement of the previous block is returned.
       *
       * @param block The block to examine
       * @param  isCaller true if this block is a caller of the block we are finding previous statements for
       * @return The last statement of the block (or the last statement of previous blocks if the block is empty)
       */
      private ArrayList<PreviousStatement> getLastStatements(ControlFlowBlock block, boolean isCaller) {
         ArrayList<PreviousStatement> statements = new ArrayList<>();
         List<Statement> blockStatements = block.getStatements();
         if (blockStatements.size() == 0) {
            // Block has no statements - go further back!
            statements.addAll(getPreviousStatements(block, isCaller));
         } else {
            // Add last statement from block
            Statement predecessorLastStatement = blockStatements.get(blockStatements.size() - 1);
            statements.add(new PreviousStatement(predecessorLastStatement, isCaller));
         }
         return statements;
      }

      @Override
      public Void visitPhiBlock(StatementPhiBlock phi) {
         List<VariableRef> defined = new ArrayList<>();
         for (StatementPhiBlock.PhiVariable phiVariable : phi.getPhiVariables()) {
            defined.add(phiVariable.getVariable());
         }
         propagate(phi, getPreviousStatements(), defined);
         return null;
      }

      @Override
      public Void visitCall(StatementCall call) {
         // Do not propagate directly to previous statement
         //propagate(call, getPreviousStatements(), null);
         // Instead propagate back through all statements of the procedure
         ProcedureRef procedure = call.getProcedure();
         LabelRef procedureReturnBlock = procedure.getReturnBlock();
         ControlFlowBlock returnBlock = program.getGraph().getBlock(procedureReturnBlock);
         propagate(call, getLastStatements(returnBlock, false), null);
         return null;
      }

      @Override
      public Void visitAssignment(StatementAssignment assignment) {
         propagate(assignment, getPreviousStatements(), Arrays.asList(assignment.getlValue()));
         return null;
      }

      @Override
      public Void visitConditionalJump(StatementConditionalJump conditionalJump) {
         propagate(conditionalJump, getPreviousStatements(), null);
         return null;
      }

      @Override
      public Void visitJump(StatementJump jump) {
         propagate(jump, getPreviousStatements(), null);
         return null;
      }

      @Override
      public Void visitReturn(StatementReturn aReturn) {
         propagate(aReturn, getPreviousStatements(), null);
         return null;
      }

      @Override
      public Void visitProcedureBegin(StatementProcedureBegin procedureBegin) {
         throw new RuntimeException("Statement not supported during live range propagation. Should be eliminated in earlier phase. " + procedureBegin);
      }

      @Override
      public Void visitProcedureEnd(StatementProcedureEnd procedureEnd) {
         throw new RuntimeException("Statement not supported during live range propagation. Should be eliminated in earlier phase. " + procedureEnd);
      }

      @Override
      public Void visitJumpTarget(StatementLabel jumpTarget) {
         throw new RuntimeException("Statement not supported during live range propagation. Should be eliminated in earlier phase. " + jumpTarget);
      }
   }


}

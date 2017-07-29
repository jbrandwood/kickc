package dk.camelot64.kickc.passes;

/**
 * Identify the alive intervals for all variables. Add the intervals to the ProgramScope.
 */

import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.icl.*;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class Pass3LiveRangesAnalysis {

   private final Program program;
   private final CompileLog log;

   public Pass3LiveRangesAnalysis(Program program, CompileLog log) {
      this.program = program;
      this.log = log;
   }

   public void findLiveRanges() {
      generateStatementIndexes();
      LiveRangeVariables liveRanges = initializeLiveRanges();
      program.getScope().setLiveRangeVariables(liveRanges);
      //log.append("CONTROL FLOW GRAPH - LIVE RANGES");
      //log.append(program.getGraph().toString(program.getScope()));
      boolean propagating;
      do {
         propagating = propagateLiveRanges(liveRanges);
         program.getScope().setLiveRangeVariables(liveRanges);
         log.append("Propagating live ranges...");
         //log.append("CONTROL FLOW GRAPH - LIVE RANGES");
         //log.append(program.getGraph().toString(program.getScope()));
      } while (propagating);
      program.getScope().setLiveRangeVariables(liveRanges);
   }


   /**
    * Create index numbers for all statements in the control flow graph.
    */
   private void generateStatementIndexes() {
      int currentIdx = 0;
      for (ControlFlowBlock block : program.getGraph().getAllBlocks()) {
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
      LiveRangeInitializer liveRangeInitializer = new LiveRangeInitializer(program);
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
                  Statement predecessorLastStatement = predecessorStatements.get(predecessorStatements.size() - 1);
                  liveRanges.addAlive((VariableRef) phiRValue.getrValue(), predecessorLastStatement);
               }
            }
         }
         return null;
      }

      @Override
      public Void visitCall(StatementCall callLValue) {
         if (callLValue.getlValue() instanceof PointerDereferenceIndexed) {
            addInitialLiveRange(((PointerDereferenceIndexed) callLValue.getlValue()).getPointer());
            addInitialLiveRange(((PointerDereferenceIndexed) callLValue.getlValue()).getIndex());
         } else if (callLValue.getlValue() instanceof PointerDereferenceSimple) {
            addInitialLiveRange(((PointerDereferenceSimple) callLValue.getlValue()).getPointer());
         }
         if (callLValue.getParameters() != null) {
            for (RValue parameter : callLValue.getParameters()) {
               addInitialLiveRange(parameter);
            }
         }
         return null;
      }

      @Override
      public Void visitReturn(StatementReturn aReturn) {
         addInitialLiveRange(aReturn.getValue());
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
      LiveRangePropagator liveRangePropagator = new LiveRangePropagator(program, liveRanges);
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
      private void propagate(Statement statement, List<Statement> previous, List<? extends LValue> defined) {
         List<VariableRef> alive = liveRanges.getAlive(statement);
         if (defined != null) {
            for (LValue lValue : defined) {
               if (lValue instanceof VariableRef) {
                  // Remove the defined variable
                  alive.remove(lValue);
               }
            }
         }
         // Add all non-defined alive vars to all previous statement
         for (VariableRef var : alive) {
            for (Statement prev : previous) {
               modified |= liveRanges.addAlive(var, prev);
            }
         }
      }

      private List<Statement> getPreviousStatements() {
         if (previousStatement != null) {
            // Inside a block
            return Arrays.asList(previousStatement);
         } else {
            // At start of block - add last statement of all previous blocks
            return getPreviousStatements(this.currentBlock);
         }
      }

      private ArrayList<Statement> getPreviousStatements(ControlFlowBlock block) {
         ArrayList<Statement> statements = new ArrayList<>();
         List<ControlFlowBlock> predecessors = program.getGraph().getPredecessors(block);
         for (ControlFlowBlock predecessor : predecessors) {
            List<Statement> predecessorStatements = predecessor.getStatements();
            if (predecessorStatements.size() == 0) {
               // Predecessor has no statements - go further back!
               statements.addAll(getPreviousStatements(predecessor));
            } else {
               // Add last statement from predecessor
               Statement predecessorLastStatement = predecessorStatements.get(predecessorStatements.size() - 1);
               statements.add(predecessorLastStatement);
            }
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
      public Void visitCall(StatementCall callLValue) {
         if (callLValue.getlValue() != null) {
            propagate(callLValue, getPreviousStatements(), Arrays.asList(callLValue.getlValue()));
         }
         return null;
      }

      @Override
      public Void visitAssignment(StatementAssignment assignment) {
         if (assignment.getlValue() != null) {
            propagate(assignment, getPreviousStatements(), Arrays.asList(assignment.getlValue()));
         }
         return null;
      }

      @Override
      public Void visitConditionalJump(StatementConditionalJump conditionalJump) {
         propagate(conditionalJump, getPreviousStatements(), new ArrayList<LValue>());
         return null;
      }

      @Override
      public Void visitJump(StatementJump jump) {
         propagate(jump, getPreviousStatements(), new ArrayList<LValue>());
         return null;
      }

      @Override
      public Void visitReturn(StatementReturn aReturn) {
         propagate(aReturn, getPreviousStatements(), new ArrayList<LValue>());
         return null;
      }

      @Override
      public Void visitProcedureBegin(StatementProcedureBegin statement) {
         throw new RuntimeException("Statement not supported during live range propagation. Should be eliminated in earlier phase. " + statement);
      }

      @Override
      public Void visitProcedureEnd(StatementProcedureEnd statement) {
         throw new RuntimeException("Statement not supported during live range propagation. Should be eliminated in earlier phase. " + statement);
      }

      @Override
      public Void visitJumpTarget(StatementLabel jumpTarget) {
         throw new RuntimeException("Statement not supported during live range propagation. Should be eliminated in earlier phase. " + jumpTarget);
      }
   }


}

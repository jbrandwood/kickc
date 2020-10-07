package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.values.LabelRef;
import dk.camelot64.kickc.model.values.PointerDereference;
import dk.camelot64.kickc.model.values.ScopeRef;
import dk.camelot64.kickc.model.values.VariableRef;

import java.util.Collection;
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
         for(LabelRef loopBlockRef : loop.getBlocks()) {
            final ControlFlowBlock loopBlock = getGraph().getBlock(loopBlockRef);
            for(Statement statement : loopBlock.getStatements()) {
               if(statement instanceof StatementAssignment) {
                  StatementAssignment assignment = (StatementAssignment) statement;
                  boolean canHoist = isLoopInvariantComputation(assignment, loop);
                  if(canHoist)
                     getLog().append("Statement can be hoisted out of loop " + statement.toString());
               }
            }
         }
      }
      return false;
   }

   /**
    * Examine whether an assignment statement can be hoisted out of a loop
    *
    * @param assignment The assignment to examine
    * @param loop The loop containing the assigmnent
    * @return true if the assignment can be hoisted out of the loop
    */
   private boolean isLoopInvariantComputation(StatementAssignment assignment, NaturalLoop loop) {
      final VariableReferenceInfos variableReferenceInfos = getProgram().getVariableReferenceInfos();
      final StatementInfos statementInfos = getProgram().getStatementInfos();
      // We assume the statement is hoistable and try to find reasons not to
      AtomicBoolean canHoist = new AtomicBoolean(true);

      // Is there a pointer deref in the expression?
      ProgramValueIterator.execute(assignment, (programValue, currentStmt, stmtIt, currentBlock) -> {
         if(programValue.get() instanceof PointerDereference) {
            canHoist.set(false);
         }
      }, null, null);

      if(!canHoist.get())
         return false;
      // Examine whether any variables used (not defined) are defined outside the loop
      final Collection<VariableRef> usedVars = variableReferenceInfos.getUsedVars(assignment);
      for(VariableRef usedVarRef : usedVars) {
         final Variable usedVar = getScope().getVar(usedVarRef);
         // Is the variable volatile
         if(usedVar.isVolatile())
            return false;
         final Collection<Integer> defineStatements = variableReferenceInfos.getVarDefineStatements(usedVarRef);
         for(Integer defineStmtIdx : defineStatements) {
            final LabelRef defineBlockRef = statementInfos.getBlockRef(defineStmtIdx);
            // Is the variable defined inside the loop
            if(loop.getBlocks().contains(defineBlockRef))
               return false;
            // Is the variable defined in another scope
            final ScopeRef defineScope = getGraph().getBlock(defineBlockRef).getScope();
            final ScopeRef loopScope = getGraph().getBlock(loop.getHead()).getScope();
            if(!defineScope.equals(loopScope))
               return false;
         }
      }
      // The assignment is hoistable
      return true;
   }
}

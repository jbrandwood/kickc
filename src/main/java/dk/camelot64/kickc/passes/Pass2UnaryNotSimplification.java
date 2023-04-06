package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.VariableReferenceInfos;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.values.VariableRef;

import java.util.ArrayList;
import java.util.List;

/**
 * Compiler Pass simplifying unary not variables if they reference a comparison that can be inverted
 */
public class Pass2UnaryNotSimplification extends Pass2SsaOptimization {

   public Pass2UnaryNotSimplification(Program program) {
      super(program);
   }

   /**
    * Eliminate unary nots if they are the only usage of a reversible comparison
    */
   @Override
   public boolean step() {
      final List<VariableRef> unusedComparisons = optimizeUnaryNots();
      removeAssignments(getGraph(), unusedComparisons);
      deleteSymbols(getProgramScope(), unusedComparisons);
      return (unusedComparisons.size() > 0);
   }

   /**
    * Examine all unary nots. If they are the only usage of a reversible unary not replace the unary not with the reversed comparison - and eliminate the original variable.
    *
    * @param assignments Assignments to examine
    * @param usages All variable usages
    * @return Unused comparisons (because they have been replaced with reversed comparisons)
    */
   private List<VariableRef> optimizeUnaryNots() {
      final VariableReferenceInfos variableReferenceInfos = getProgram().getVariableReferenceInfos();
      final List<VariableRef> unused = new ArrayList<>();
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               if(assignment.getrValue1() == null
                     && assignment.getOperator() != null
                     && ("!".equals(assignment.getOperator().getOperator()) || "not".equals(assignment.getOperator().getOperator()))
                     && assignment.getrValue2() instanceof VariableRef
               ) {
                  VariableRef tempVar = (VariableRef) assignment.getrValue2();
                  final Integer tempVarDefineStmtIdx = variableReferenceInfos.getVarDefineStatement(tempVar);
                  if(tempVarDefineStmtIdx != null) {
                     final Statement tempVarDefineStmt = getGraph().getStatementByIndex(tempVarDefineStmtIdx);
                     if(tempVarDefineStmt instanceof StatementAssignment) {
                        StatementAssignment tempAssignment = (StatementAssignment) tempVarDefineStmt;
                        int tempVarUsages = variableReferenceInfos.getVarUseStatements(tempVar).size();
                        if(tempVarUsages == 1 && tempAssignment.getOperator() != null) {
                           switch(tempAssignment.getOperator().getOperator()) {
                              case "<":
                                 createInverse(">=", assignment, tempAssignment);
                                 unused.add(tempVar);
                                 break;
                              case ">":
                                 createInverse("<=", assignment, tempAssignment);
                                 unused.add(tempVar);
                                 break;
                              case "<=":
                              case "=<":
                                 createInverse(">", assignment, tempAssignment);
                                 unused.add(tempVar);
                                 break;
                              case ">=":
                              case "=>":
                                 createInverse("<", assignment, tempAssignment);
                                 unused.add(tempVar);
                                 break;
                              case "==":
                                 createInverse("!=", assignment, tempAssignment);
                                 unused.add(tempVar);
                                 break;
                              case "!=":
                              case "<>":
                                 createInverse("==", assignment, tempAssignment);
                                 unused.add(tempVar);
                                 break;
                              case "!":
                              case "not":
                                 createInverse(null, assignment, tempAssignment);
                                 unused.add(tempVar);
                                 break;
                           }
                        }
                     }
                  }
               }
            }
         }
      }
      return unused;
   }

   /**
    * Updates an assignment to be the inverse of the temp assignment.
    *
    * @param newOperator The new operator to use
    * @param assignment The assignment to update
    * @param tempAssignment The temp assignment to take rValues from.
    */
   private void createInverse(String newOperator, StatementAssignment assignment, StatementAssignment tempAssignment) {
      assignment.setrValue1(tempAssignment.getrValue1());
      assignment.setOperator(newOperator == null ? null : Operators.getBinary(newOperator));
      assignment.setrValue2(tempAssignment.getrValue2());
      getLog().append("Inversing boolean not " + assignment.toString(getProgram(), false) + " from " + tempAssignment.toString(getProgram(), false));
   }


}

package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.VariableReferenceInfos;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.statements.StatementConditionalJump;
import dk.camelot64.kickc.model.statements.StatementInfos;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.values.RValue;
import dk.camelot64.kickc.model.values.VariableRef;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Compiler Pass simplifying conditional jumps that are simple comparisons
 */
public class Pass2ConditionalJumpSimplification extends Pass2SsaOptimization {

   public Pass2ConditionalJumpSimplification(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      final List<VariableRef> simpleConditionVars = getSimpleConditions();
      removeAssignments(getGraph(), simpleConditionVars);
      deleteSymbols(getScope(), simpleConditionVars);
      return (simpleConditionVars.size() > 0);
   }

   private List<VariableRef> getSimpleConditions() {
      final VariableReferenceInfos variableReferenceInfos = getProgram().getVariableReferenceInfos();
      final List<VariableRef> simpleConditionVars = new ArrayList<>();
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementConditionalJump) {
               StatementConditionalJump conditionalJump = (StatementConditionalJump) statement;
               if(conditionalJump.getrValue1() == null && conditionalJump.getOperator() == null) {
                  RValue conditionRValue = conditionalJump.getrValue2();
                  if(conditionRValue instanceof VariableRef) {
                     VariableRef conditionVar = (VariableRef) conditionRValue;
                     final Collection<Integer> conditionRvalueUsages = variableReferenceInfos.getVarUseStatements(conditionVar);
                     final Integer conditionDefineStmtIdx = variableReferenceInfos.getVarDefineStatement(conditionVar);
                     if(conditionRvalueUsages.size() == 1 && conditionDefineStmtIdx != null) {
                        final Statement conditionDefineStmt = getGraph().getStatementByIndex(conditionDefineStmtIdx);
                        if(conditionDefineStmt instanceof StatementAssignment && ((StatementAssignment) conditionDefineStmt).getOperator() != null) {
                           StatementAssignment conditionAssignment = (StatementAssignment) conditionDefineStmt;
                           switch(conditionAssignment.getOperator().getOperator()) {
                              case "==":
                              case "<>":
                              case "!=":
                              case "<":
                              case ">":
                              case "<=":
                              case "=<":
                              case ">=":
                              case "=>":
                                 final Collection<Variable> referencedLoadStoreVariables = getReferencedLoadStoreVariables(conditionAssignment.getrValue1());
                                 referencedLoadStoreVariables.addAll(getReferencedLoadStoreVariables(conditionAssignment.getrValue2()));
                                 boolean isSimple = true;
                                 if(referencedLoadStoreVariables.size() > 0) {
                                    // Found referenced load/store variables
                                    // Examine all statements between the conditionAssignment and conditionalJump for modifications
                                    final StatementInfos statementInfos = getProgram().getStatementInfos();
                                    Collection<Statement> statementsBetween = getGraph().getStatementsBetween(conditionAssignment, conditionalJump, statementInfos);
                                    for(Statement statementBetween : statementsBetween) {
                                       for(Variable referencedLoadStoreVariable : referencedLoadStoreVariables) {
                                          if(variableReferenceInfos.getDefinedVars(statementBetween).contains(referencedLoadStoreVariable.getVariableRef())) {
                                             // A referenced load/store-variable is modified in a statement between the assignment and the condition!
                                             isSimple = false;
                                             getLog().append("Condition not simple " + conditionVar.toString(getProgram()) + " " + conditionalJump.toString(getProgram(), false));
                                             // TODO: Introduce intermediate variable copy of the load/store-variable and use that in the condition!

                                          }
                                       }
                                    }
                                 }

                                 if(isSimple) {
                                    conditionalJump.setrValue1(conditionAssignment.getrValue1());
                                    conditionalJump.setOperator(conditionAssignment.getOperator());
                                    conditionalJump.setrValue2(conditionAssignment.getrValue2());
                                    simpleConditionVars.add(conditionVar);
                                    getLog().append("Simple Condition " + conditionVar.toString(getProgram()) + " " + conditionalJump.toString(getProgram(), false));
                                    break;
                                 }
                              default:
                           }
                        }
                     }
                  }
               }
            }
         }
      }
      return simpleConditionVars;
   }

   /**
    * Get all referenced load/store variables in an RValue
    *
    * @param rValue The RValue
    * @return All referenced load/store variables
    */
   private Collection<Variable> getReferencedLoadStoreVariables(RValue rValue) {
      return VariableReferenceInfos.getReferencedVars(rValue)
            .stream()
            .map(variableRef -> getScope().getVariable(variableRef))
            .filter(Variable::isKindLoadStore)
            .collect(Collectors.toList());
   }

}

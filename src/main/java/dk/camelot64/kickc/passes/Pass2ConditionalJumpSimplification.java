package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.iterator.ProgramValue;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.operators.Operator;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.statements.StatementConditionalJump;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.RValue;
import dk.camelot64.kickc.model.values.ScopeRef;
import dk.camelot64.kickc.model.values.SymbolRef;
import dk.camelot64.kickc.model.values.VariableRef;
import dk.camelot64.kickc.passes.utils.AliasReplacer;

import java.util.ArrayList;
import java.util.Collection;
import java.util.LinkedHashMap;
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
      final List<VariableRef> simpleConditionVars = new ArrayList<>();
      List<SimpleCondition> simpleConditions = getSimpleConditionTodos();
      for(SimpleCondition simpleCondition : simpleConditions) {
         rewriteSimpleCondition(simpleCondition);
         simpleConditionVars.add(simpleCondition.conditionVar);
      }
      removeAssignments(getGraph(), simpleConditionVars);
      deleteSymbols(getProgramScope(), simpleConditionVars);
      return (simpleConditionVars.size() > 0);
   }

   /** An identified conditional jump with a one-variable condition that uses a comparison condition (less-than, greater-than, ...) and the assignment for that condition. */
   static class SimpleCondition {
      StatementConditionalJump conditionalJump;
      StatementAssignment conditionAssignment;
      VariableRef conditionVar;

      SimpleCondition(StatementConditionalJump conditionalJump, StatementAssignment conditionAssignment, VariableRef conditionVar) {
         this.conditionalJump = conditionalJump;
         this.conditionAssignment = conditionAssignment;
         this.conditionVar = conditionVar;
      }
   }

   /**
    * Find all simple conditions that can be rewritten.
    * Simple conditions are conditional jumps with a single variable as condition. The condition must be the result of an assignment with a comparison-operator.
    * @return The simple conditions to rewrite
    */
   private List<SimpleCondition> getSimpleConditionTodos() {
      final VariableReferenceInfos variableReferenceInfos = getProgram().getVariableReferenceInfos();
      List<SimpleCondition> todos = new ArrayList<>();
      for(var block : getGraph().getAllBlocks()) {
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
                                 todos.add(new SimpleCondition(conditionalJump, conditionAssignment, conditionVar));
                              default:
                           }
                        }
                     }
                  }
               }
            }
         }
      }
      return todos;
   }

   /**
    * Rewrite a simple condition - by inlining the comparison into the conditional jump.
    * If the condition uses any load/store-variables that are modified between the condition assignment and the jump the values of these is preserved in a new intermediate variable.
    *
    * @param simpleCondition The simple condition to rewrite
    */
   private void rewriteSimpleCondition(SimpleCondition simpleCondition) {
      final VariableReferenceInfos variableReferenceInfos = getProgram().getVariableReferenceInfos();
      // For each condition/assignment pair - do a rewrite to inline the condition if possible
      final Operator operator = simpleCondition.conditionAssignment.getOperator();
      RValue rValue1 = simpleCondition.conditionAssignment.getrValue1();
      RValue rValue2 = simpleCondition.conditionAssignment.getrValue2();
      final Collection<Variable> referencedLoadStoreVariables = getReferencedLoadStoreVariables(rValue1);
      referencedLoadStoreVariables.addAll(getReferencedLoadStoreVariables(rValue2));
      if(referencedLoadStoreVariables.size() > 0) {
         // Found referenced load/store variables
         // Examine all statements between the conditionAssignment and conditionalJump for modifications
         final StatementInfos statementInfos = getProgram().getStatementInfos();
         final Graph.Block conditionDefineBlock = statementInfos.getBlock(simpleCondition.conditionAssignment);
         Collection<Statement> statementsBetween = StatementsBetween.find(simpleCondition.conditionAssignment, conditionDefineBlock, simpleCondition.conditionalJump, getGraph());
         for(Statement statementBetween : statementsBetween) {
            for(Variable referencedLoadStoreVariable : referencedLoadStoreVariables) {
               if(variableReferenceInfos.getDefinedVars(statementBetween).contains(referencedLoadStoreVariable.getVariableRef())) {
                  // A referenced load/store-variable is modified in a statement between the assignment and the condition!
                  getLog().append("Condition not simple " + simpleCondition.conditionVar.toString(getProgram()) + " " + simpleCondition.conditionalJump.toString(getProgram(), false));
                  // Create an intermediate variable copy of the load/store-variable at the position of the condition-variable to preserve the value
                  final ScopeRef conditionDefineScopeRef = conditionDefineBlock.getScope();
                  final Scope conditionDefineScope = getProgramScope().getScope(conditionDefineScopeRef);
                  SymbolType typeQualified = referencedLoadStoreVariable.getType().getQualified(false, referencedLoadStoreVariable.getType().isNomodify());
                  final Variable intermediateLoadStoreVar = VariableBuilder.createIntermediate(conditionDefineScope, typeQualified, getProgram());
                  final StatementAssignment intermediateLoadStoreAssignment = new StatementAssignment(intermediateLoadStoreVar.getVariableRef(), referencedLoadStoreVariable.getRef(), true, simpleCondition.conditionAssignment.getSource(), Comment.NO_COMMENTS);
                  conditionDefineBlock.addStatementAfter(intermediateLoadStoreAssignment, simpleCondition.conditionAssignment);
                  // Replace all references to the load/store variable in the expressions with the new intermediate
                  final LinkedHashMap<SymbolRef, RValue> aliases = new LinkedHashMap<>();
                  aliases.put(referencedLoadStoreVariable.getRef(), intermediateLoadStoreVar.getRef());
                  {
                     final ProgramValue.GenericValue programValue1 = new ProgramValue.GenericValue(rValue1);
                     ProgramValueIterator.execute(programValue1, new AliasReplacer(aliases), null, null, null);
                     rValue1 = (RValue) programValue1.get();
                  }
                  {
                     final ProgramValue.GenericValue programValue2 = new ProgramValue.GenericValue(rValue2);
                     ProgramValueIterator.execute(programValue2, new AliasReplacer(aliases), null, null, null);
                     rValue2 = (RValue) programValue2.get();
                  }
                  getLog().append("Introduced intermediate condition variable " + intermediateLoadStoreAssignment.toString(getProgram(), false));
               }
            }
         }
      }
      // Perform the condition rewrite
      simpleCondition.conditionalJump.setrValue1(rValue1);
      simpleCondition.conditionalJump.setOperator(operator);
      simpleCondition.conditionalJump.setrValue2(rValue2);
      getLog().append("Simple Condition " + simpleCondition.conditionVar.toString(getProgram()) + " " + simpleCondition.conditionalJump.toString(getProgram(), false));
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
            .map(variableRef -> getProgramScope().getVariable(variableRef))
            .filter(Variable::isKindLoadStore)
            .collect(Collectors.toList());
   }

}

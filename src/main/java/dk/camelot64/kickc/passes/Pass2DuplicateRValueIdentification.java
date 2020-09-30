package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.DominatorsBlock;
import dk.camelot64.kickc.model.DominatorsGraph;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramValue;
import dk.camelot64.kickc.model.iterator.ProgramValueHandler;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.operators.Operator;
import dk.camelot64.kickc.model.operators.OperatorCast;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.values.*;

import java.util.*;
import java.util.concurrent.atomic.AtomicBoolean;

/**
 * Compiler Pass identifying R-values that are duplicates of each other - and consolidates them to a single RValue.
 */
public class Pass2DuplicateRValueIdentification extends Pass2SsaOptimization {

   public Pass2DuplicateRValueIdentification(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      boolean modified = false;

      // Dominators are used for determining if one statement is guaranteed to be executed before another statement
      DominatorsGraph dominators = getProgram().getDominators();

      // All RValues in the program
      Set<AssignmentWithRValue> rValues = new HashSet<>();

      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementAssignment) {
               StatementAssignment thisAssignment = (StatementAssignment) statement;
               AssignmentWithRValue thisRValue = new AssignmentWithRValue(thisAssignment, block);
               if(!thisRValue.isConstant() && !thisRValue.isTrivial() && !thisRValue.isVolatile() && !thisRValue.isLoadStore()) {
                  boolean duplicate = false;
                  for(AssignmentWithRValue otherRValue : rValues) {
                     if(otherRValue.isSameRValue(thisRValue)) {
                        // Check if any of the statements is guaranteed to be executed before the other statement
                        DominatorsBlock thisDominators = dominators.getDominators(thisRValue.block.getLabel());
                        DominatorsBlock otherDominators = dominators.getDominators(otherRValue.block.getLabel());
                        if(otherRValue.block.getLabel().equals(thisRValue.block.getLabel())) {
                           // The two assignments are in the same block
                           // Since we are visiting statements sequentially the other  other assignment is guaranteed to be executed before this assignment
                           duplicate |= deduplicateRValue(otherRValue, thisRValue);
                        } else if(thisDominators.contains(otherRValue.block.getLabel())) {
                           // The other assignment is guaranteed to be executed before this assignment
                           if(scopeMatch(thisRValue, otherRValue))
                              duplicate |= deduplicateRValue(otherRValue, thisRValue);
                        } else if(otherDominators.contains(thisRValue.block.getLabel())) {
                           // This assignment is guaranteed to be executed before the other assignment
                           if(scopeMatch(thisRValue, otherRValue))
                              duplicate |= deduplicateRValue(thisRValue, otherRValue);
                        }
                     }
                  }
                  // If not a duplicate itself - add it to the candidate pool
                  if(!duplicate)
                     rValues.add(thisRValue);
                  // Determine if anything is modified
                  modified |= duplicate;
               }
            }
         }
      }
      return modified;
   }

   /**
    * Check that the scopes match for all involved variables.
    *
    * @param thisRValue This RValue
    * @param otherRValue This duplicate RValue
    * @return true if all scopes match
    */
   private boolean scopeMatch(AssignmentWithRValue thisRValue, AssignmentWithRValue otherRValue) {
      if(!thisRValue.block.getScope().equals(otherRValue.block.getScope()))
         return false;
      ScopeRef scope = thisRValue.block.getScope();
      return
            scopeMatch(thisRValue.assignment.getlValue(), scope) &&
                  scopeMatch(otherRValue.assignment.getlValue(), scope) &&
                  scopeMatch(thisRValue.rValue1, scope) &&
                  scopeMatch(thisRValue.rValue2, scope);
   }

   /**
    * Check that the scope of the values inside an RValue matches the scope of a block.
    * We only know that a specific variable version has the same value if it is from the same scope as the block.
    * Otherwise it might be modified inside some called function.
    *
    * @param value The RValue to examine (may be null)
    * @param block The block to examine
    * @return true if the scope match
    */
   private boolean scopeMatch(Value value, ScopeRef scopeRef) {
      if(value == null)
         return true;
      List<SymbolVariableRef> varRefs = new ArrayList<>();
      ProgramValueIterator.execute(new ProgramValue.GenericValue(value),
            (programValue, currentStmt, stmtIt, currentBlock) -> {
               if(programValue.get() instanceof SymbolVariableRef) varRefs.add((SymbolVariableRef) programValue.get());
            }
            , null, null, null);
      for(SymbolVariableRef varRef : varRefs) {
         Variable var = getScope().getVariable(varRef);
         if(!var.getScope().getRef().equals(scopeRef))
            return false;
      }
      return true;
   }

   /**
    * De-duplicates the RValues of two assignments, where the first one is guaranteed to be called before the second one.
    * Modifies the second assignment to reference the result of the first.
    *
    * @param firstRValue The first assignment with the RValue - guaranteed to be called before the second assignment.
    * @param secondRValue A second assignment with a duplicated RValue.
    * @return true if the deduplication was successful.
    */
   private boolean deduplicateRValue(AssignmentWithRValue firstRValue, AssignmentWithRValue secondRValue) {
      if(firstRValue.assignment.getlValue() instanceof VariableRef) {
         StatementAssignment secondAssignment = secondRValue.assignment;
         getLog().append("Identified duplicate assignment right side " + secondAssignment.toString(getProgram(), false));
         secondAssignment.setrValue1(null);
         secondAssignment.setOperator(null);
         secondAssignment.setrValue2(firstRValue.assignment.getlValue());
         return true;
      } else {
         throw new InternalError("Complex lValue for duplicate rvalue " + firstRValue.assignment.toString(getProgram(), false));
      }
   }


   /**
    * Represents an RValue of an assignment.
    */
   private class AssignmentWithRValue {
      private ControlFlowBlock block;
      private StatementAssignment assignment;
      private RValue rValue1;
      private Operator operator;
      private RValue rValue2;

      public AssignmentWithRValue(StatementAssignment assignment, ControlFlowBlock block) {
         this.block = block;
         this.assignment = assignment;
         this.rValue1 = assignment.getrValue1();
         this.operator = assignment.getOperator();
         this.rValue2 = assignment.getrValue2();
      }

      private boolean isConstant() {
         if(rValue1 != null && !(rValue1 instanceof ConstantValue))
            return false;
         if(rValue2 != null && !(rValue2 instanceof ConstantValue))
            return false;
         return true;
      }

      private boolean isLoadStore() {
         AtomicBoolean isLoadStore = new AtomicBoolean(false);
         ProgramValueHandler loadStoreIdentificator = (programValue, currentStmt, stmtIt, currentBlock) -> {
            Value value = programValue.get();
            if(value instanceof VariableRef) {
               Variable var = getScope().getVar((VariableRef) value);
               if(var.isKindLoadStore())
                  isLoadStore.set(true);
            }
         };
         ProgramValueIterator.execute(new ProgramValue.GenericValue(rValue1), loadStoreIdentificator, assignment, null, block);
         ProgramValueIterator.execute(new ProgramValue.GenericValue(rValue2), loadStoreIdentificator, assignment, null, block);
         return isLoadStore.get();
      }

      private boolean isVolatile() {
         AtomicBoolean isVol = new AtomicBoolean(false);
         ProgramValueHandler identifyVolatiles = (programValue, currentStmt, stmtIt, currentBlock) -> {
            if(programValue.get() instanceof PointerDereference)
               isVol.set(true);
            if(programValue.get() instanceof VariableRef) {
               Variable variable = getScope().getVariable((VariableRef) programValue.get());
               if(variable.isVolatile())
                  isVol.set(true);
            }
         };
         ProgramValueIterator.execute(new ProgramValue.RValue1(assignment), identifyVolatiles, assignment, null, null);
         ProgramValueIterator.execute(new ProgramValue.RValue2(assignment), identifyVolatiles, assignment, null, null);
         if(Operators.DEREF.equals(operator) || Operators.DEREF_IDX.equals(operator))
            isVol.set(true);
         return isVol.get();
      }

      private boolean isTrivial() {
         if(operator == null) return true;
         if(operator instanceof OperatorCast) return true;
         if(operator.equals(Operators.LE)) return true;
         if(operator.equals(Operators.LT)) return true;
         if(operator.equals(Operators.GE)) return true;
         if(operator.equals(Operators.GT)) return true;
         if(operator.equals(Operators.EQ)) return true;
         if(operator.equals(Operators.NEQ)) return true;
         if(operator.equals(Operators.LOGIC_NOT)) return true;
         if(operator.equals(Operators.LOGIC_AND)) return true;
         if(operator.equals(Operators.LOGIC_OR)) return true;
         if(operator.equals(Operators.HIBYTE)) return true;
         if(operator.equals(Operators.LOWBYTE)) return true;
         if(operator.equals(Operators.PLUS) && rValue2 instanceof ConstantValue) return true;
         if(operator.equals(Operators.PLUS) && rValue1 instanceof ConstantValue) return true;
         return false;
      }


      /**
       * Determines if two assignment RValues are duplicates.
       *
       * @param that The other assignment
       * @return true if the RValues are duplicates
       */
      public boolean isSameRValue(AssignmentWithRValue that) {
         return Objects.equals(rValue1, that.rValue1) &&
               Objects.equals(operator, that.operator) &&
               Objects.equals(rValue2, that.rValue2);
      }

      @Override
      public boolean equals(Object o) {
         if(this == o) return true;
         if(o == null || getClass() != o.getClass()) return false;
         AssignmentWithRValue that = (AssignmentWithRValue) o;
         return block.equals(that.block) &&
               assignment.equals(that.assignment) &&
               Objects.equals(rValue1, that.rValue1) &&
               Objects.equals(operator, that.operator) &&
               Objects.equals(rValue2, that.rValue2);
      }

      @Override
      public int hashCode() {
         return Objects.hash(block, assignment, rValue1, operator, rValue2);
      }
   }
}

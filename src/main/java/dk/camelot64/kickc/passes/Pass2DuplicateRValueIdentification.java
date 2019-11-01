package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramValue;
import dk.camelot64.kickc.model.iterator.ProgramValueHandler;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.operators.Operator;
import dk.camelot64.kickc.model.operators.OperatorCast;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.symbols.SymbolVariable;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.values.ConstantValue;
import dk.camelot64.kickc.model.values.PointerDereference;
import dk.camelot64.kickc.model.values.RValue;
import dk.camelot64.kickc.model.values.VariableRef;

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

      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         Set<AssignmentRValue> rValues = new HashSet<>();
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               AssignmentRValue assignmentRValue = new AssignmentRValue(assignment, block);
               if(!assignmentRValue.isConstant() && !assignmentRValue.isTrivial() && !assignmentRValue.isVolatile()) {
                  if(rValues.contains(assignmentRValue)) {
                     AssignmentRValue firstAssignment = rValues.stream().filter(assignmentRValue1 -> assignmentRValue1.equals(assignmentRValue)).findFirst().get();
                     if(firstAssignment.assignment.getlValue() instanceof VariableRef) {
                        getLog().append("Identified duplicate assignment right side "+assignment.toString(getProgram(), false));
                        assignment.setrValue1(null);
                        assignment.setOperator(null);
                        assignment.setrValue2(firstAssignment.assignment.getlValue());
                        modified = true;
                     } else {
                        throw new InternalError("Complex lValue for duplicate rvalue "+firstAssignment.assignment.toString(getProgram(), false));
                     }
                  } else {
                     rValues.add(assignmentRValue);
                  }
               }
            }
         }
      }
      return modified;
   }


   /**
    * Represents an RValue of an assignment.
    * Implements equals() and hashcode() to allow identification of duplicate RValues
    */
   private class AssignmentRValue {
      private ControlFlowBlock block;
      private StatementAssignment assignment;
      private RValue rValue1;
      private Operator operator;
      private RValue rValue2;

      public AssignmentRValue(StatementAssignment assignment, ControlFlowBlock block) {
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

      private boolean isVolatile() {
         AtomicBoolean isVol = new AtomicBoolean(false);
         ProgramValueHandler identifyVolatiles = (programValue, currentStmt, stmtIt, currentBlock) -> {
            if(programValue.get() instanceof PointerDereference)
               isVol.set(true);
            if(programValue.get() instanceof VariableRef) {
               SymbolVariable variable = getScope().getVariable((VariableRef) programValue.get());
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
         if(operator.equals(Operators.PLUS)) return true;
         if(operator.equals(Operators.MINUS)) return true;
         if(operator.equals(Operators.LE)) return true;
         if(operator.equals(Operators.LT)) return true;
         if(operator.equals(Operators.GE)) return true;
         if(operator.equals(Operators.GT)) return true;
         if(operator.equals(Operators.EQ)) return true;
         if(operator.equals(Operators.NEQ)) return true;
         if(operator.equals(Operators.LOGIC_NOT)) return true;
         if(operator.equals(Operators.LOGIC_AND)) return true;
         if(operator.equals(Operators.LOGIC_OR)) return true;
         return false;
      }


      @Override
      public boolean equals(Object o) {
         if(this == o) return true;
         if(o == null || getClass() != o.getClass()) return false;
         AssignmentRValue that = (AssignmentRValue) o;
         return Objects.equals(rValue1, that.rValue1) &&
               Objects.equals(operator, that.operator) &&
               Objects.equals(rValue2, that.rValue2);
      }

      @Override
      public int hashCode() {
         return Objects.hash(rValue1, operator, rValue2);
      }

   }
}

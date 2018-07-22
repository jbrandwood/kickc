package dk.camelot64.kickc.model.iterator;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.values.*;
import dk.camelot64.kickc.model.statements.*;

import java.util.ArrayList;
import java.util.Collection;
import java.util.ListIterator;

/**
 * A replacer capable to alias all usages of a variable (or constant var) with a suitable replacement
 */
public class ValueReplacer {

   /**
    * Execute a replacer on all replaceable values in the program control flow graph
    *
    * @param graph The program control flow graph
    * @param replacer The replacer to execute
    */
   public static void executeAll(ControlFlowGraph graph, Replacer replacer) {
      for(ControlFlowBlock block : graph.getAllBlocks()) {
         executeAll(block, replacer);
      }
   }

   /**
    * Execute a replacer on all replaceable values in a block of the control flow graph
    *
    * @param block The control flow graph block
    * @param replacer The replacer to execute
    */
   public static void executeAll(ControlFlowBlock block, Replacer replacer) {
      ListIterator<Statement> statementsIt = block.getStatements().listIterator();
      while(statementsIt.hasNext()) {
         Statement statement = statementsIt.next();
         executeAll(statement, replacer, statementsIt, block);
      }
   }

   /**
    * Execute a replacer on all replaceable values in a statement
    *
    * @param statement The statement
    * @param replacer The replacer to execute
    */
   public static void executeAll(Statement statement, Replacer replacer, ListIterator<Statement> statementsIt, ControlFlowBlock block) {
      if(statement instanceof StatementAssignment) {
         // The sequence RValue1, RValue2, LValue is important - as it is essential for {@link dk.camelot64.kickc.passes.Pass1GenerateSingleStaticAssignmentForm} to create the correct SSA
         executeAll(new ReplaceableValue.RValue1((StatementAssignment) statement), replacer, statement, statementsIt, block);
         executeAll(new ReplaceableValue.RValue2((StatementAssignment) statement), replacer, statement, statementsIt, block);
         executeAll(new ReplaceableValue.LValue((StatementLValue) statement), replacer, statement, statementsIt, block);
      } else if(statement instanceof StatementCall) {
         StatementCall call = (StatementCall) statement;
         if(call.getParameters() != null) {
            int size = call.getParameters().size();
            for(int i = 0; i < size; i++) {
               executeAll(new ReplaceableValue.CallParameter(call, i), replacer, statement, statementsIt, block);
            }
         }
         executeAll(new ReplaceableValue.LValue((StatementLValue) statement), replacer, statement, statementsIt, block);
      } else if(statement instanceof StatementConditionalJump) {
         executeAll(new ReplaceableValue.CondRValue1((StatementConditionalJump) statement), replacer, statement, statementsIt, block);
         executeAll(new ReplaceableValue.CondRValue2((StatementConditionalJump) statement), replacer, statement, statementsIt, block);
      } else if(statement instanceof StatementReturn) {
         executeAll(new ReplaceableValue.Return((StatementReturn) statement), replacer, statement, statementsIt, block);
      } else if(statement instanceof StatementPhiBlock) {
         for(StatementPhiBlock.PhiVariable phiVariable : ((StatementPhiBlock) statement).getPhiVariables()) {
            int size = phiVariable.getValues().size();
            for(int i = 0; i < size; i++) {
               executeAll(new ReplaceableValue.PhiValue(phiVariable, i), replacer, statement, statementsIt, block);
            }
            executeAll(new ReplaceableValue.PhiVariable(phiVariable), replacer, statement, statementsIt, block);
         }
      }
   }

   /**
    * Execute the a replacer on a replaceable value and all sub-values of the value.
    *
    * @param replaceable The replaceable value
    * @param replacer The value replacer
    */
   public static void executeAll(ReplaceableValue replaceable, Replacer replacer, Statement currentStmt, ListIterator<Statement> stmtIt, ControlFlowBlock currentBlock) {
      replacer.execute(replaceable, currentStmt, stmtIt, currentBlock);
      for(ReplaceableValue subValue : getSubValues(replaceable.get())) {
         executeAll(subValue, replacer, currentStmt, stmtIt, currentBlock);
      }
   }

   /**
    * Get the sub values for an RValue.
    * @param value The RValue
    * @return The sub-values of the RValue (only one level down, recursion is needed to get all contained sub-values)
    */
   private static Collection<ReplaceableValue> getSubValues(RValue value) {
      ArrayList<ReplaceableValue> subValues = new ArrayList<>();
      if(value instanceof PointerDereferenceIndexed) {
         subValues.add(new ReplaceableValue.Pointer((PointerDereference) value));
         subValues.add(new ReplaceableValue.PointerIndex((PointerDereferenceIndexed) value));
      } else if(value instanceof PointerDereferenceSimple) {
         subValues.add(new ReplaceableValue.Pointer((PointerDereference) value));
      } else if(value instanceof ValueList) {
         ValueList valueList = (ValueList) value;
         int size = valueList.getList().size();
         for(int i = 0; i < size; i++) {
            subValues.add(new ReplaceableValue.ListElement(valueList, i));
         }
      } else if(value instanceof ConstantArrayList) {
         ConstantArrayList constantArrayList = (ConstantArrayList) value;
         int size = constantArrayList.getElements().size();
         for(int i=0;i<size;i++) {
            subValues.add(new ReplaceableValue.ConstantArrayElement(constantArrayList, i));
         }
      } else if(value instanceof CastValue) {
         subValues.add(new ReplaceableValue.CastValue((CastValue) value));
      } else if(value instanceof ConstantCastValue) {
         subValues.add(new ReplaceableValue.ConstantCastValue((ConstantCastValue) value));
      } else if(value instanceof ConstantVarPointer) {
         subValues.add(new ReplaceableValue.VarPointer((ConstantVarPointer) value));
      } else if(value instanceof RangeValue) {
         subValues.add(new ReplaceableValue.RangeFirst((RangeValue) value));
         subValues.add(new ReplaceableValue.RangeLast((RangeValue) value));
      } else if(value instanceof ConstantBinary) {
         subValues.add(new ReplaceableValue.ConstantBinaryLeft((ConstantBinary) value));
         subValues.add(new ReplaceableValue.ConstantBinaryRight((ConstantBinary) value));
      } else if(value instanceof ConstantUnary) {
         subValues.add(new ReplaceableValue.ConstantUnaryValue((ConstantUnary) value));
      } else if(value instanceof ArrayFilled) {
         subValues.add(new ReplaceableValue.ArrayFilledSize((ArrayFilled) value));
      } else if(value instanceof ConstantArrayFilled) {
         subValues.add(new ReplaceableValue.ConstantArrayFilledSize((ConstantArrayFilled) value));
      } else if( value == null ||
                  value instanceof VariableRef ||
                  value instanceof ConstantLiteral ||
                  value instanceof ConstantRef ||
                  value instanceof LvalueIntermediate
            ) {
         // No sub values
      } else {
         throw new RuntimeException("Unhandled value type " + value.getClass());
      }
      return subValues;
   }

}

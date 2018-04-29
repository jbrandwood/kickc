package dk.camelot64.kickc.passes;

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
         ListIterator<Statement> statementsIt = block.getStatements().listIterator();
         while(statementsIt.hasNext()) {
            Statement statement = statementsIt.next();
            if(statement instanceof StatementAssignment) {
               executeAll(new ReplaceableLValue((StatementLValue) statement), replacer, statement, statementsIt, block);
               executeAll(new ReplaceableRValue1((StatementAssignment) statement), replacer, statement, statementsIt, block);
               executeAll(new ReplaceableRValue2((StatementAssignment) statement), replacer, statement, statementsIt, block);
            } else if(statement instanceof StatementCall) {
               executeAll(new ReplaceableLValue((StatementLValue) statement), replacer, statement, statementsIt, block);
               StatementCall call = (StatementCall) statement;
               if(call.getParameters() != null) {
                  int size = call.getParameters().size();
                  for(int i = 0; i < size; i++) {
                     executeAll(new ReplaceableCallParameter(call, i), replacer, statement, statementsIt, block);
                  }
               }
            } else if(statement instanceof StatementConditionalJump) {
               executeAll(new ReplaceableCondRValue1((StatementConditionalJump) statement), replacer, statement, statementsIt, block);
               executeAll(new ReplaceableCondRValue2((StatementConditionalJump) statement), replacer, statement, statementsIt, block);
            } else if(statement instanceof StatementReturn) {
               executeAll(new ReplaceableReturn((StatementReturn) statement), replacer, statement, statementsIt, block);
            } else if(statement instanceof StatementPhiBlock) {
               for(StatementPhiBlock.PhiVariable phiVariable : ((StatementPhiBlock) statement).getPhiVariables()) {
                  executeAll(new ReplaceablePhiVariable(phiVariable), replacer, statement, statementsIt, block);
                  int size = phiVariable.getValues().size();
                  for(int i = 0; i < size; i++) {
                     executeAll(new ReplaceablePhiValue(phiVariable, i), replacer, statement, statementsIt, block);
                  }
               }
            }
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
      for(ReplaceableValue subValue : replaceable.getSubValues()) {
         executeAll(subValue, replacer, currentStmt, stmtIt, currentBlock);
      }
   }

   /** A replacer that receives a replaceable value and has the potential to replace the value or recurse into sub-values. */
   public interface Replacer {
      /**
       * Execute replacement of a replaceable value.
       *
       * @param replaceable The replaceable value
       * @param currentStmt The statement iterator - just past the current statement that the value is a part of. Current statment can be retrieved by calling
       * @param stmtIt The statement iterator - just past the current statement. Can be used for modifying the control flow block.
       * @param currentBlock The current block that the value is a part of
       */
      void execute(ReplaceableValue replaceable, Statement currentStmt, ListIterator<Statement> stmtIt, ControlFlowBlock currentBlock);
   }

   /**
    * Interface representing an RValue that can be replaced.
    * The value may have sub-values that can also be replaced.
    */
   public static abstract class ReplaceableValue {

      public abstract RValue get();

      public abstract void set(RValue value);

      public Collection<ReplaceableValue> getSubValues() {
         RValue value = get();
         ArrayList<ReplaceableValue> subValues = new ArrayList<>();
         if(value instanceof PointerDereferenceIndexed) {
            subValues.add(new ReplaceablePointer((PointerDereference) value));
            subValues.add(new ReplaceablePointerIndex((PointerDereferenceIndexed) value));
         } else if(value instanceof PointerDereferenceSimple) {
            subValues.add(new ReplaceablePointer((PointerDereference) value));
         } else if(value instanceof ValueList) {
            ValueList valueList = (ValueList) value;
            int size = valueList.getList().size();
            for(int i = 0; i < size; i++) {
               subValues.add(new ReplaceableListElement(valueList, i));
            }
         } else if(value instanceof CastValue) {
            subValues.add(new ReplaceableCastValue((CastValue) value));
         } else if(value instanceof ConstantCastValue) {
            subValues.add(new ReplaceableConstantCastValue((ConstantCastValue) value));
         } else if(value instanceof ConstantVarPointer) {
            subValues.add(new ReplaceableVarPointer((ConstantVarPointer) value));
         }
         return subValues;
      }

   }

   /**
    * Replaceable LValue as part of an assignment statement (or a call).
    */
   public static class ReplaceableLValue extends ReplaceableValue {
      private final StatementLValue statement;

      public ReplaceableLValue(StatementLValue statement) {
         this.statement = statement;
      }

      @Override
      public RValue get() {
         return statement.getlValue();
      }

      @Override
      public void set(RValue value) {
         statement.setlValue((LValue) value);
      }

   }

   /**
    * Replaceable pointer inside a pointer dererence value.
    */
   public static class ReplaceablePointer extends ReplaceableValue {
      private final PointerDereference pointer;

      ReplaceablePointer(PointerDereference pointer) {
         this.pointer = pointer;
      }

      @Override
      public RValue get() {
         return pointer.getPointer();
      }

      @Override
      public void set(RValue val) {
         pointer.setPointer(val);
      }

   }

   /**
    * Replaceable value inside a noop cast.
    */
   public static class ReplaceableCastValue extends ReplaceableValue {
      private final CastValue castValue;


      public ReplaceableCastValue(CastValue castValue) {
         this.castValue = castValue;
      }

      @Override
      public RValue get() {
         return castValue.getValue();
      }

      @Override
      public void set(RValue val) {
         castValue.setValue(val);
      }

   }

   /**
    * Replaceable value inside a constant noop cast.
    */
   public static class ReplaceableConstantCastValue extends ReplaceableValue {
      private final ConstantCastValue castValue;


      public ReplaceableConstantCastValue(ConstantCastValue castValue) {
         this.castValue = castValue;
      }

      @Override
      public RValue get() {
         return castValue.getValue();
      }

      @Override
      public void set(RValue val) {
         castValue.setValue((ConstantValue) val);
      }

   }

   /**
    * Replaceable pointer inside a variable pointer.
    */
   public static class ReplaceableVarPointer extends ReplaceableValue {
      private final ConstantVarPointer varPointer;


      public ReplaceableVarPointer(ConstantVarPointer varPointer) {
         this.varPointer = varPointer;
      }

      @Override
      public RValue get() {
         return varPointer.getToVar();
      }

      @Override
      public void set(RValue val) {
         varPointer.setToVar((VariableRef) val);
      }

   }

   public static class ReplaceableListElement extends ReplaceableValue {
      private ValueList list;
      private int idx;

      public ReplaceableListElement(ValueList list, int idx) {
         this.list = list;
         this.idx = idx;
      }

      @Override
      public RValue get() {
         return list.getList().get(idx);
      }

      @Override
      public void set(RValue value) {
         list.getList().set(idx, value);
      }

   }

   /**
    * Replaceable pointer index inside a indexed pointer dererence value.
    */
   public static class ReplaceablePointerIndex extends ReplaceableValue {
      private final PointerDereferenceIndexed pointer;

      ReplaceablePointerIndex(PointerDereferenceIndexed pointer) {
         this.pointer = pointer;
      }

      @Override
      public RValue get() {
         return pointer.getIndex();
      }

      @Override
      public void set(RValue val) {
         pointer.setIndex(val);
      }

   }

   public static class ReplaceableRValue1 extends ReplaceableValue {
      private final StatementAssignment statement;

      public ReplaceableRValue1(StatementAssignment statement) {
         this.statement = statement;
      }

      @Override
      public RValue get() {
         return statement.getrValue1();
      }

      @Override
      public void set(RValue value) {
         statement.setrValue1(value);
      }
   }

   public static class ReplaceableRValue2 extends ReplaceableValue {
      private final StatementAssignment statement;

      public ReplaceableRValue2(StatementAssignment statement) {
         this.statement = statement;
      }

      @Override
      public RValue get() {
         return statement.getrValue2();
      }

      @Override
      public void set(RValue value) {
         statement.setrValue2(value);
      }
   }

   public static class ReplaceableCallParameter extends ReplaceableValue {
      private final StatementCall call;
      private final int i;

      public ReplaceableCallParameter(StatementCall call, int i) {
         this.call = call;
         this.i = i;
      }

      @Override
      public RValue get() {
         return call.getParameters().get(i);
      }

      @Override
      public void set(RValue value) {
         call.getParameters().set(i, value);
      }
   }

   public static class ReplaceableCondRValue1 extends ReplaceableValue {
      private final StatementConditionalJump statement;

      public ReplaceableCondRValue1(StatementConditionalJump statement) {
         this.statement = statement;
      }

      @Override
      public RValue get() {
         return statement.getrValue1();
      }

      @Override
      public void set(RValue value) {
         statement.setrValue1(value);
      }
   }

   public static class ReplaceableCondRValue2 extends ReplaceableValue {
      private final StatementConditionalJump statement;

      public ReplaceableCondRValue2(StatementConditionalJump statement) {
         this.statement = statement;
      }

      @Override
      public RValue get() {
         return statement.getrValue2();
      }

      @Override
      public void set(RValue value) {
         statement.setrValue2(value);
      }
   }

   public static class ReplaceableReturn extends ReplaceableValue {
      private final StatementReturn statement;

      public ReplaceableReturn(StatementReturn statement) {
         this.statement = statement;
      }

      @Override
      public RValue get() {
         return statement.getValue();
      }

      @Override
      public void set(RValue value) {
         statement.setValue(value);
      }
   }

   public static class ReplaceablePhiValue extends ReplaceableValue {
      private final StatementPhiBlock.PhiVariable phiVariable;
      private final int i;

      public ReplaceablePhiValue(StatementPhiBlock.PhiVariable phiVariable, int i) {
         this.phiVariable = phiVariable;
         this.i = i;
      }

      @Override
      public RValue get() {
         return phiVariable.getValues().get(i).getrValue();
      }

      @Override
      public void set(RValue value) {
         phiVariable.getValues().get(i).setrValue(value);
      }
   }

   /**
    * Replaceable LValue as part of an assignment statement (or a call).
    */
   public static class ReplaceablePhiVariable extends ReplaceableValue {
      private final StatementPhiBlock.PhiVariable phiVariable;

      public ReplaceablePhiVariable(StatementPhiBlock.PhiVariable phiVariable) {
         this.phiVariable = phiVariable;
      }

      @Override
      public RValue get() {
         return phiVariable.getVariable();
      }

      @Override
      public void set(RValue value) {
         phiVariable.setVariable((VariableRef) value);
      }

   }
}

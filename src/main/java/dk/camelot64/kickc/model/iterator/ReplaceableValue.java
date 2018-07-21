package dk.camelot64.kickc.model.iterator;

import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.values.*;

import java.util.Collection;

/**
 * Interface representing an RValue that can be replaced.
 * The value may have sub-values that can also be replaced.
 */
public abstract class ReplaceableValue {

   public abstract RValue get();

   public abstract void set(RValue value);

   /** Replaceable value inside a array filled expression. */
   public static class ArrayFilledSize extends ReplaceableValue {
      private final ArrayFilled array;

      ArrayFilledSize(ArrayFilled array) {
         this.array = array;
      }

      @Override
      public RValue get() {
         return array.getSize();
      }

      @Override
      public void set(RValue val) {
         array.setSize(val);
      }

   }

   /** Replaceable value inside a constant array filled expression. */
   public static class ConstantArrayFilledSize extends ReplaceableValue {
      private final ConstantArrayFilled array;

      ConstantArrayFilledSize(ConstantArrayFilled array) {
         this.array = array;
      }

      @Override
      public RValue get() {
         return array.getSize();
      }

      @Override
      public void set(RValue val) {
         array.setSize((ConstantValue) val);
      }

   }

   /** Replaceable value inside a constant unary expression. */
   public static class ConstantUnaryValue extends ReplaceableValue {
      private final ConstantUnary unary;

      ConstantUnaryValue(ConstantUnary unary) {
         this.unary = unary;
      }

      @Override
      public RValue get() {
         return unary.getOperand();
      }

      @Override
      public void set(RValue val) {
         unary.setOperand((ConstantValue) val);
      }

   }

   /** Replaceable left value inside a constant binary expression. */
   public static class ConstantBinaryLeft extends ReplaceableValue {
      private final ConstantBinary binary;

      ConstantBinaryLeft(ConstantBinary binary) {
         this.binary = binary;
      }

      @Override
      public RValue get() {
         return binary.getLeft();
      }

      @Override
      public void set(RValue val) {
         binary.setLeft((ConstantValue) val);
      }

   }

   /** Replaceable right value inside a constant binary expression. */
   public static class ConstantBinaryRight extends ReplaceableValue {
      private final ConstantBinary binary;

      ConstantBinaryRight(ConstantBinary range) {
         this.binary = range;
      }

      @Override
      public RValue get() {
         return binary.getRight();
      }

      @Override
      public void set(RValue val) {
         binary.setRight((ConstantValue) val);
      }

   }

   /**
    * Replaceable first value inside a ranged comparison value.
    */
   public static class RangeFirst extends ReplaceableValue {
      private final RangeValue range;

      RangeFirst(RangeValue range) {
         this.range = range;
      }

      @Override
      public RValue get() {
         return range.getRangeFirst();
      }

      @Override
      public void set(RValue val) {
         range.setRangeFirst(val);
      }

   }

   /**
    * Replaceable last value inside inside a ranged comparison value.
    */
   public static class RangeLast extends ReplaceableValue {
      private final RangeValue range;

      RangeLast(RangeValue range) {
         this.range = range;
      }

      @Override
      public RValue get() {
         return range.getRangeLast();
      }

      @Override
      public void set(RValue val) {
         range.setRangeLast(val);
      }

   }

   /**
    * Replaceable LValue as part of an assignment statement (or a call).
    */
   public static class LValue extends ReplaceableValue {
      private final StatementLValue statement;

      public LValue(StatementLValue statement) {
         this.statement = statement;
      }

      @Override
      public RValue get() {
         return statement.getlValue();
      }

      @Override
      public void set(RValue value) {
         statement.setlValue((dk.camelot64.kickc.model.values.LValue) value);
      }

   }

   /**
    * Replaceable pointer inside a pointer dererence value.
    */
   public static class Pointer extends ReplaceableValue {
      private final PointerDereference pointer;

      Pointer(PointerDereference pointer) {
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
   public static class CastValue extends ReplaceableValue {
      private final dk.camelot64.kickc.model.values.CastValue castValue;


      public CastValue(dk.camelot64.kickc.model.values.CastValue castValue) {
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
   public static class ConstantCastValue extends ReplaceableValue {
      private final dk.camelot64.kickc.model.values.ConstantCastValue castValue;


      public ConstantCastValue(dk.camelot64.kickc.model.values.ConstantCastValue castValue) {
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
   public static class VarPointer extends ReplaceableValue {
      private final ConstantVarPointer varPointer;


      public VarPointer(ConstantVarPointer varPointer) {
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

   public static class ListElement extends ReplaceableValue {
      private ValueList list;
      private int idx;

      public ListElement(ValueList list, int idx) {
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
   public static class PointerIndex extends ReplaceableValue {
      private final PointerDereferenceIndexed pointer;

      PointerIndex(PointerDereferenceIndexed pointer) {
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

   public static class RValue1 extends ReplaceableValue {
      private final StatementAssignment statement;

      public RValue1(StatementAssignment statement) {
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

   public static class RValue2 extends ReplaceableValue {
      private final StatementAssignment statement;

      public RValue2(StatementAssignment statement) {
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

   public static class CallParameter extends ReplaceableValue {
      private final StatementCall call;
      private final int i;

      public CallParameter(StatementCall call, int i) {
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

   public static class CondRValue1 extends ReplaceableValue {
      private final StatementConditionalJump statement;

      public CondRValue1(StatementConditionalJump statement) {
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

   public static class CondRValue2 extends ReplaceableValue {
      private final StatementConditionalJump statement;

      public CondRValue2(StatementConditionalJump statement) {
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

   public static class Return extends ReplaceableValue {
      private final StatementReturn statement;

      public Return(StatementReturn statement) {
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

   public static class PhiValue extends ReplaceableValue {
      private final StatementPhiBlock.PhiVariable phiVariable;
      private final int i;

      public PhiValue(StatementPhiBlock.PhiVariable phiVariable, int i) {
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
   public static class PhiVariable extends ReplaceableValue {
      private final StatementPhiBlock.PhiVariable phiVariable;

      public PhiVariable(StatementPhiBlock.PhiVariable phiVariable) {
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

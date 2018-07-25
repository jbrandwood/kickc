package dk.camelot64.kickc.model.iterator;

import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.symbols.ConstantVar;
import dk.camelot64.kickc.model.types.SymbolTypeArray;
import dk.camelot64.kickc.model.values.*;

/**
 * An RValue in the program being iterated by {@link ProgramValueIterator}.
 *
 * The RValue can be inspected using get() and replaced inside the model using set(val).
 *
 * The context of the RValue can be determined from the sub-class containing it plus the parameters to the ProgramValueHandler.
 *
 */
public abstract class ProgramValue {

   public abstract RValue get();

   public abstract void set(RValue value);

   public static class ConstantVariableValue extends ProgramValue {
      private final ConstantVar constantVar;

      ConstantVariableValue(ConstantVar constantVar) {
         this.constantVar = constantVar;
      }

      @Override
      public RValue get() {
         return constantVar.getValue();
      }

      @Override
      public void set(RValue val) {
         constantVar.setValue((ConstantValue) val);
      }

   }

   /** Size inside a fixed size array. */
   public static class TypeArraySize extends ProgramValue {
      private final SymbolTypeArray array;

      TypeArraySize(SymbolTypeArray array) {
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

   /** Value inside a array filled expression. */
   public static class ArrayFilledSize extends ProgramValue {
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

   /** Value inside a constant array filled expression. */
   public static class ConstantArrayFilledSize extends ProgramValue {
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

   /** Value inside a constant unary expression. */
   public static class ConstantUnaryValue extends ProgramValue {
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

   /** Left value inside a constant binary expression. */
   public static class ConstantBinaryLeft extends ProgramValue {
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

   /** Right value inside a constant binary expression. */
   public static class ConstantBinaryRight extends ProgramValue {
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
    * First value inside a ranged comparison value.
    */
   public static class RangeFirst extends ProgramValue {
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
    * Last value inside inside a ranged comparison value.
    */
   public static class RangeLast extends ProgramValue {
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

   /** Location inside inline kickasm code. */
   public static class KickAsmLocation extends ProgramValue {

      private StatementKickAsm statementKickAsm;

      KickAsmLocation(StatementKickAsm statementKickAsm) {
         super();
         this.statementKickAsm = statementKickAsm;
      }

      @Override
      public RValue get() {
         return statementKickAsm.getLocation();
      }

      @Override
      public void set(RValue value) {
         statementKickAsm.setLocation(value);
      }

   }

   /**
    * LValue as part of an assignment statement (or a call).
    */
   public static class LValue extends ProgramValue {
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
    * Pointer inside a pointer dererence value.
    */
   public static class Pointer extends ProgramValue {
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
    * Value inside a noop cast.
    */
   public static class CastValue extends ProgramValue {
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
    * Value inside a constant noop cast.
    */
   public static class ConstantCastValue extends ProgramValue {
      private final dk.camelot64.kickc.model.values.ConstantCastValue castValue;


      ConstantCastValue(dk.camelot64.kickc.model.values.ConstantCastValue castValue) {
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
    * Pointer inside a variable pointer.
    */
   public static class VarPointer extends ProgramValue {
      private final ConstantVarPointer varPointer;


      VarPointer(ConstantVarPointer varPointer) {
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

   public static class ConstantArrayElement extends ProgramValue {
      private final ConstantArrayList arrayList;
      private final int idx;

      ConstantArrayElement(ConstantArrayList arrayList, int idx) {
         this.arrayList = arrayList;
         this.idx = idx;
      }

      @Override
      public RValue get() {
         return arrayList.getElements().get(idx);
      }

      @Override
      public void set(RValue value) {
         arrayList.getElements().set(idx, (ConstantValue) value);
      }
   }

   public static class ListElement extends ProgramValue {
      private ValueList list;
      private int idx;

      ListElement(ValueList list, int idx) {
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
    * Pointer index inside a indexed pointer dererence value.
    */
   public static class PointerIndex extends ProgramValue {
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

   public static class RValue1 extends ProgramValue {
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

   public static class RValue2 extends ProgramValue {
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

   public static class CallParameter extends ProgramValue {
      private final StatementCall call;
      private final int i;

      CallParameter(StatementCall call, int i) {
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

   public static class CondRValue1 extends ProgramValue {
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

   public static class CondRValue2 extends ProgramValue {
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

   public static class Return extends ProgramValue {
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

   public static class PhiValue extends ProgramValue {
      private final StatementPhiBlock.PhiVariable phiVariable;
      private final int i;

      PhiValue(StatementPhiBlock.PhiVariable phiVariable, int i) {
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
    * LValue as part of an assignment statement (or a call).
    */
   public static class PhiVariable extends ProgramValue {
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

   /** A generic Value. */
   public static class GenericValue extends ProgramValue {
      private RValue rValue;

      public GenericValue(RValue rValue) {
         this.rValue = rValue;
      }

      @Override
      public RValue get() {
         return rValue;
      }

      @Override
      public void set(RValue value) {
         this.rValue = value;
      }
   }

}

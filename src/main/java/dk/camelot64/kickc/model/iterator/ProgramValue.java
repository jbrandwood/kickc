package dk.camelot64.kickc.model.iterator;

import dk.camelot64.kickc.model.ControlFlowBlock;
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

   public abstract Value get();

   public abstract void set(Value value);

   public static class ConstantVariableValue extends ProgramValue {
      private final ConstantVar constantVar;

      ConstantVariableValue(ConstantVar constantVar) {
         this.constantVar = constantVar;
      }

      @Override
      public Value get() {
         return constantVar.getValue();
      }

      @Override
      public void set(Value val) {
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
      public Value get() {
         return array.getSize();
      }

      @Override
      public void set(Value val) {
         array.setSize((RValue) val);
      }

   }

   /** Value inside a array filled expression. */
   public static class ArrayFilledSize extends ProgramValue {
      private final ArrayFilled array;

      ArrayFilledSize(ArrayFilled array) {
         this.array = array;
      }

      @Override
      public Value get() {
         return array.getSize();
      }

      @Override
      public void set(Value val) {
         array.setSize((RValue) val);
      }

   }

   /** Value inside an intermediate LValue. */
   public static class LValueIntermediateVariable  extends ProgramValue {
      private final LvalueIntermediate intermediate;

      LValueIntermediateVariable(LvalueIntermediate intermediate) {
         this.intermediate = intermediate;
      }

      @Override
      public Value get() {
         return intermediate.getVariable();
      }

      @Override
      public void set(Value val) {
         intermediate.setVariable((VariableRef) val);
      }

   }

   /** Value inside a constant array filled expression. */
   public static class ConstantArrayFilledSize extends ProgramValue {
      private final ConstantArrayFilled array;

      ConstantArrayFilledSize(ConstantArrayFilled array) {
         this.array = array;
      }

      @Override
      public Value get() {
         return array.getSize();
      }

      @Override
      public void set(Value val) {
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
      public Value get() {
         return unary.getOperand();
      }

      @Override
      public void set(Value val) {
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
      public Value get() {
         return binary.getLeft();
      }

      @Override
      public void set(Value val) {
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
      public Value get() {
         return binary.getRight();
      }

      @Override
      public void set(Value val) {
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
      public Value get() {
         return range.getRangeFirst();
      }

      @Override
      public void set(Value val) {
         range.setRangeFirst((RValue) val);
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
      public Value get() {
         return range.getRangeLast();
      }

      @Override
      public void set(Value val) {
         range.setRangeLast((RValue) val);
      }

   }

   /** A variable/constant referenced inside inline ASM. */
   public static class AsmReferenced extends ProgramValue {
      private StatementAsm statementAsm;
      private String label;

      public AsmReferenced(StatementAsm statementAsm, String label) {
         this.statementAsm = statementAsm;
         this.label = label;
      }

      @Override
      public Value get() {
         return statementAsm.getReferenced().get(label);
      }

      @Override
      public void set(Value value) {
         statementAsm.getReferenced().put(label, (SymbolVariableRef) value);
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
      public Value get() {
         return statementKickAsm.getLocation();
      }

      @Override
      public void set(Value value) {
         statementKickAsm.setLocation((RValue) value);
      }

   }

   /** Bytes inside inline kickasm code. */
   public static class KickAsmBytes extends ProgramValue {

      private StatementKickAsm statementKickAsm;

      KickAsmBytes(StatementKickAsm statementKickAsm) {
         super();
         this.statementKickAsm = statementKickAsm;
      }

      @Override
      public Value get() {
         return statementKickAsm.getBytes();
      }

      @Override
      public void set(Value value) {
         statementKickAsm.setBytes((RValue) value);
      }

   }

   /** Cycles inside inline kickasm code. */
   public static class KickAsmCycles extends ProgramValue {

      private StatementKickAsm statementKickAsm;

      KickAsmCycles(StatementKickAsm statementKickAsm) {
         super();
         this.statementKickAsm = statementKickAsm;
      }

      @Override
      public Value get() {
         return statementKickAsm.getCycles();
      }

      @Override
      public void set(Value value) {
         statementKickAsm.setCycles((RValue) value);
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
      public Value get() {
         return statement.getlValue();
      }

      @Override
      public void set(Value value) {
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
      public Value get() {
         return pointer.getPointer();
      }

      @Override
      public void set(Value val) {
         pointer.setPointer((RValue) val);
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
      public Value get() {
         return castValue.getValue();
      }

      @Override
      public void set(Value val) {
         castValue.setValue((RValue) val);
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
      public Value get() {
         return castValue.getValue();
      }

      @Override
      public void set(Value val) {
         castValue.setValue((ConstantValue) val);
      }

   }

   /**
    * Pointer inside a variable pointer.
    */
   public static class ConstantSymbolPointerTo extends ProgramValue {
      private final ConstantSymbolPointer varPointer;


      ConstantSymbolPointerTo(ConstantSymbolPointer varPointer) {
         this.varPointer = varPointer;
      }

      @Override
      public Value get() {
         return (RValue) varPointer.getToSymbol();
      }

      @Override
      public void set(Value val) {
         varPointer.setToSymbol((VariableRef) val);
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
      public Value get() {
         return arrayList.getElements().get(idx);
      }

      @Override
      public void set(Value value) {
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
      public Value get() {
         return list.getList().get(idx);
      }

      @Override
      public void set(Value value) {
         list.getList().set(idx, (RValue) value);
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
      public Value get() {
         return pointer.getIndex();
      }

      @Override
      public void set(Value val) {
         pointer.setIndex((RValue) val);
      }

   }

   public static class RValue1 extends ProgramValue {
      private final StatementAssignment statement;

      public RValue1(StatementAssignment statement) {
         this.statement = statement;
      }

      @Override
      public Value get() {
         return statement.getrValue1();
      }

      @Override
      public void set(Value value) {
         statement.setrValue1((RValue) value);
      }
   }

   public static class RValue2 extends ProgramValue {
      private final StatementAssignment statement;

      public RValue2(StatementAssignment statement) {
         this.statement = statement;
      }

      @Override
      public Value get() {
         return statement.getrValue2();
      }

      @Override
      public void set(Value value) {
         statement.setrValue2((RValue) value);
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
      public Value get() {
         return call.getParameters().get(i);
      }

      @Override
      public void set(Value value) {
         call.getParameters().set(i, (RValue) value);
      }
   }

   public static class CondRValue1 extends ProgramValue {
      private final StatementConditionalJump statement;

      public CondRValue1(StatementConditionalJump statement) {
         this.statement = statement;
      }

      @Override
      public Value get() {
         return statement.getrValue1();
      }

      @Override
      public void set(Value value) {
         statement.setrValue1((RValue) value);
      }
   }

   public static class CondRValue2 extends ProgramValue {
      private final StatementConditionalJump statement;

      public CondRValue2(StatementConditionalJump statement) {
         this.statement = statement;
      }

      @Override
      public Value get() {
         return statement.getrValue2();
      }

      @Override
      public void set(Value value) {
         statement.setrValue2((RValue) value);
      }
   }

   public static class CondLabel extends ProgramValue {
      private final StatementConditionalJump statement;

      public CondLabel(StatementConditionalJump statement) {
         this.statement = statement;
      }

      @Override
      public Value get() {
         return statement.getDestination();
      }

      @Override
      public void set(Value value) {
         statement.setDestination((LabelRef) value);
      }
   }

   public static class Return extends ProgramValue {
      private final StatementReturn statement;

      public Return(StatementReturn statement) {
         this.statement = statement;
      }

      @Override
      public Value get() {
         return statement.getValue();
      }

      @Override
      public void set(Value value) {
         statement.setValue((RValue) value);
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
      public Value get() {
         return phiVariable.getValues().get(i).getrValue();
      }

      @Override
      public void set(Value value) {
         phiVariable.getValues().get(i).setrValue((RValue) value);
      }
   }

   public static class PhiValuePredecessor extends ProgramValue {
      private final StatementPhiBlock.PhiVariable phiVariable;
      private final int i;

      PhiValuePredecessor(StatementPhiBlock.PhiVariable phiVariable, int i) {
         this.phiVariable = phiVariable;
         this.i = i;
      }

      @Override
      public Value get() {
         return phiVariable.getValues().get(i).getPredecessor();
      }

      @Override
      public void set(Value value) {
         phiVariable.getValues().get(i).setPredecessor((LabelRef) value);
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
      public Value get() {
         return phiVariable.getVariable();
      }

      @Override
      public void set(Value value) {
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
      public Value get() {
         return rValue;
      }

      @Override
      public void set(Value value) {
         this.rValue = (RValue) value;
      }
   }

   /** A variable used by inline kickasm. */
   public static class KickAsmUses extends ProgramValue {
      private StatementKickAsm statementKickAsm;
      private int idx;

      public KickAsmUses(StatementKickAsm statementKickAsm, int idx) {
         this.statementKickAsm = statementKickAsm;
         this.idx = idx;
      }

      @Override
      public Value get() {
         return statementKickAsm.getUses().get(idx);
      }

      @Override
      public void set(Value value) {
         statementKickAsm.getUses().set(idx, (SymbolVariableRef) value);

      }

   }

   public static class BlockLabel extends ProgramValue {

      private final ControlFlowBlock block;

      BlockLabel(ControlFlowBlock block) {
         this.block = block;
      }

      @Override
      public Value get() {
         return block.getLabel();
      }

      @Override
      public void set(Value val) {
         block.setLabel((LabelRef) val);
      }

   }

   public static class BlockDefaultSuccessor extends ProgramValue {

      private final ControlFlowBlock block;

      BlockDefaultSuccessor(ControlFlowBlock block) {
         this.block = block;
      }

      @Override
      public Value get() {
         return block.getDefaultSuccessor();
      }

      @Override
      public void set(Value val) {
         block.setDefaultSuccessor((LabelRef) val);
      }

   }

   public static class BlockConditionalSuccessor extends ProgramValue {

      private final ControlFlowBlock block;

      BlockConditionalSuccessor(ControlFlowBlock block) {
         this.block = block;
      }

      @Override
      public Value get() {
         return block.getConditionalSuccessor();
      }

      @Override
      public void set(Value val) {
         block.setConditionalSuccessor((LabelRef) val);
      }

   }

   public static class BlockCallSuccessor extends ProgramValue {

      private final ControlFlowBlock block;

      BlockCallSuccessor(ControlFlowBlock block) {
         this.block = block;
      }

      @Override
      public Value get() {
         return block.getCallSuccessor();
      }

      @Override
      public void set(Value val) {
         block.setCallSuccessor((LabelRef) val);
      }

   }

}

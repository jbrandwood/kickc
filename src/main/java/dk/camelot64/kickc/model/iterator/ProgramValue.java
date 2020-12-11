package dk.camelot64.kickc.model.iterator;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.values.*;

/**
 * Any Value in the program being iterated by {@link ProgramValueIterator}.
 * <p>
 * The Value can be inspected using get() and replaced inside the model using set(val).
 * <p>
 * The context of the Value can be determined from the sub-class containing it plus the parameters to the ProgramValueHandler.
 */
public interface ProgramValue {

   Value get();

   void set(Value value);

   class RValue1 implements ProgramValue {
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

   class RValue2 implements ProgramValue {
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

   class CallPrepareParameter implements ProgramValue {
      private final StatementCallPrepare call;
      private final int i;

      CallPrepareParameter(StatementCallPrepare call, int i) {
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

   class CallParameter implements ProgramValue {
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

   class CallPointerProcedure implements ProgramValue {
      private final StatementCallPointer call;

      CallPointerProcedure(StatementCallPointer call) {
         this.call = call;
      }

      @Override
      public Value get() {
         return call.getProcedure();
      }

      @Override
      public void set(Value value) {
         call.setProcedure((RValue) value);
      }
   }

   class CallPointerParameter implements ProgramValue {
      private final StatementCallPointer call;
      private final int i;

      CallPointerParameter(StatementCallPointer call, int i) {
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

   class CondRValue1 implements ProgramValue {
      private final StatementConditionalJump statement;

      CondRValue1(StatementConditionalJump statement) {
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

   class CondRValue2 implements ProgramValue {
      private final StatementConditionalJump statement;

      CondRValue2(StatementConditionalJump statement) {
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

   class CondLabel implements ProgramValue {
      private final StatementConditionalJump statement;

      CondLabel(StatementConditionalJump statement) {
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

   class Return implements ProgramValue {
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

   class PhiValue implements ProgramValue {
      private final StatementPhiBlock.PhiVariable phiVariable;
      private final int i;

      public PhiValue(StatementPhiBlock.PhiVariable phiVariable, int i) {
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

      public LabelRef getPredecessor() {
         return phiVariable.getValues().get(i).getPredecessor();
      }

   }

   class PhiValuePredecessor implements ProgramValue {
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
   class PhiVariable implements ProgramValue {
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
   class GenericValue implements ProgramValue {
      private Value value;

      public GenericValue(Value value) {
         this.value = value;
      }

      @Override
      public Value get() {
         return value;
      }

      @Override
      public void set(Value value) {
         this.value = value;
      }
   }

   /** A variable used by inline kickasm. */
   class KickAsmUses implements ProgramValue {
      private StatementKickAsm statementKickAsm;
      private int idx;

      KickAsmUses(StatementKickAsm statementKickAsm, int idx) {
         this.statementKickAsm = statementKickAsm;
         this.idx = idx;
      }

      @Override
      public Value get() {
         return statementKickAsm.getUses().get(idx);
      }

      @Override
      public void set(Value value) {
         statementKickAsm.getUses().set(idx, (SymbolRef) value);
      }

   }

   /** Number of bytes constant used by stack pull . */
   class ExprSideEffect implements ProgramValue {

      private StatementExprSideEffect statementExprSideEffect;

      ExprSideEffect(StatementExprSideEffect statementExprSideEffect) {
         this.statementExprSideEffect = statementExprSideEffect;
      }

      @Override
      public Value get() {
         return statementExprSideEffect.getExpression();
      }

      @Override
       public void set(Value value) {
         statementExprSideEffect.setExpression((RValue) value);
      }

   }


   class BlockLabel implements ProgramValue {

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

   class BlockDefaultSuccessor implements ProgramValue {

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

   class BlockConditionalSuccessor implements ProgramValue {

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

   class BlockCallSuccessor implements ProgramValue {

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

   /** A variable/constant referenced inside inline ASM. */
   class ProgramValueAsmReferenced implements ProgramValue {
      private StatementAsm statementAsm;
      private String label;

      ProgramValueAsmReferenced(StatementAsm statementAsm, String label) {
         this.statementAsm = statementAsm;
         this.label = label;
      }

      @Override
      public Value get() {
         return statementAsm.getReferenced().get(label);
      }

      @Override
      public void set(Value value) {
         statementAsm.getReferenced().put(label, (SymbolRef) value);
      }
   }

   /**
    * Value inside a noop cast.
    */
   class ProgramValueCastValue implements ProgramValue {
      private final CastValue castValue;


      public ProgramValueCastValue(CastValue castValue) {
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

   /** Element in a constant array. */
   class ProgramValueConstantArrayElement implements ProgramValue {
      private final ConstantArrayList arrayList;
      private final int idx;

      ProgramValueConstantArrayElement(ConstantArrayList arrayList, int idx) {
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

   /** Member of a constant struct value. */
   class ProgramValueConstantStructMember implements ProgramValue {
      private final ConstantStructValue structValue;
      private final SymbolVariableRef memberRef;

      public ProgramValueConstantStructMember(ConstantStructValue structValue, SymbolVariableRef memberRef) {
         this.structValue = structValue;
         this.memberRef = memberRef;
      }

      @Override
      public Value get() {
         return structValue.getValue(memberRef);
      }

      @Override
      public void set(Value value) {
         structValue.setValue(memberRef, (ConstantValue) value);
      }

      public SymbolVariableRef getMemberRef() {
         return memberRef;
      }
   }

   /** Value inside a constant array filled expression. */
   class ProgramValueConstantArrayFilledSize implements ProgramValue {
      private final ConstantArrayFilled array;

      ProgramValueConstantArrayFilledSize(ConstantArrayFilled array) {
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

   /** Left value inside a constant binary expression. */
   class ProgramValueConstantBinaryLeft implements ProgramValue {
      private final ConstantBinary binary;

      ProgramValueConstantBinaryLeft(ConstantBinary binary) {
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
   class ProgramValueConstantBinaryRight implements ProgramValue {
      private final ConstantBinary binary;

      ProgramValueConstantBinaryRight(ConstantBinary range) {
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
    * Value inside a constant noop cast.
    */
   class ProgramValueConstantCastValue implements ProgramValue {
      private final ConstantCastValue castValue;


      ProgramValueConstantCastValue(ConstantCastValue castValue) {
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
   class ProgramValueConstantSymbolPointerTo implements ProgramValue {
      private final ConstantSymbolPointer varPointer;


      ProgramValueConstantSymbolPointerTo(ConstantSymbolPointer varPointer) {
         this.varPointer = varPointer;
      }

      @Override
      public Value get() {
         return varPointer.getToSymbol();
      }

      @Override
      public void set(Value val) {
         varPointer.setToSymbol((SymbolRef) val);
      }

   }

   /** Value inside a constant unary expression. */
   class ProgramValueConstantUnaryValue implements ProgramValue {
      private final ConstantUnary unary;

      ProgramValueConstantUnaryValue(ConstantUnary unary) {
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

   /** The initial value of a variable. */
   class ProgramValueInitValue implements ProgramValue {
      private final Variable constantVar;

      ProgramValueInitValue(Variable constantVar) {
         this.constantVar = constantVar;
      }

      @Override
      public Value get() {
         return constantVar.getInitValue();
      }

      @Override
      public void set(Value val) {
         constantVar.setInitValue((ConstantValue) val);
      }

   }

   /** The memory address of a variable. */
   class ProgramValueMemoryAddress implements ProgramValue {
      private final Variable constantVar;

      ProgramValueMemoryAddress(Variable constantVar) {
         this.constantVar = constantVar;
      }

      @Override
      public Value get() {
         return constantVar.getMemoryAddress();
      }

      @Override
      public void set(Value val) {
         constantVar.setMemoryAddress((ConstantValue) val);
      }

   }

   /** Bytes inside inline kickasm code. */
   class ProgramValueKickAsmBytes implements ProgramValue {

      private StatementKickAsm statementKickAsm;

      ProgramValueKickAsmBytes(StatementKickAsm statementKickAsm) {
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
   class ProgramValueKickAsmCycles implements ProgramValue {

      private StatementKickAsm statementKickAsm;

      ProgramValueKickAsmCycles(StatementKickAsm statementKickAsm) {
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

   class ProgramValueListElement implements ProgramValue {
      private ValueList list;
      private int idx;

      public ProgramValueListElement(ValueList list, int idx) {
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
    * LValue as part of an assignment statement (or a call).
    */
   class ProgramValueLValue implements ProgramValue {
      private final StatementLValue statement;

      public ProgramValueLValue(StatementLValue statement) {
         this.statement = statement;
      }

      @Override
      public Value get() {
         return statement.getlValue();
      }

      @Override
      public void set(Value value) {
         statement.setlValue((LValue) value);
      }

   }

   /** Value inside an intermediate LValue. */
   class ProgramValueLValueIntermediateVariable implements ProgramValue {
      private final LvalueIntermediate intermediate;

      ProgramValueLValueIntermediateVariable(LvalueIntermediate intermediate) {
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

   /** Value inside a parameter value . */
   class ProgramValueParamValue implements ProgramValue {
      private final ParamValue paramValue;

      ProgramValueParamValue(ParamValue paramValue) {
         this.paramValue = paramValue;
      }

      @Override
      public Value get() {
         return paramValue.getParameter();
      }

      @Override
      public void set(Value val) {
         paramValue.setParameter((VariableRef) val);
      }

   }

   /** Value inside a parameter stack value . */
   class ProgramValueStackIdxValue implements ProgramValue {
      private final StackIdxValue stackIdxValue;

      ProgramValueStackIdxValue(StackIdxValue stackIdxValue) {
         this.stackIdxValue = stackIdxValue;
      }

      @Override
      public Value get() {
         return stackIdxValue.getStackOffset();
      }

      @Override
      public void set(Value val) {
         stackIdxValue.setStackOffset((ConstantValue) val);
      }

   }

   /** Value inside a StackPullBytes . */
   class ProgramValueStackPullBytes implements ProgramValue {
      private final StackPullBytes stackPullBytes;

      ProgramValueStackPullBytes(StackPullBytes stackPullBytes) {
         this.stackPullBytes = stackPullBytes;
      }

      @Override
      public Value get() {
         return stackPullBytes.getBytes();
      }

      @Override
      public void set(Value val) {
         stackPullBytes.setBytes((ConstantValue) val);
      }

   }

   /** Value inside a StackPushBytes . */
   class ProgramValueStackPushBytes implements ProgramValue {
      private final StackPushBytes stackPushBytes;

      ProgramValueStackPushBytes(StackPushBytes stackPushBytes) {
         this.stackPushBytes = stackPushBytes;
      }

      @Override
      public Value get() {
         return stackPushBytes.getBytes();
      }

      @Override
      public void set(Value val) {
         stackPushBytes.setBytes((ConstantValue) val);
      }

   }

   /** Value inside a memset value . */
   class ProgramValueMemsetValue implements ProgramValue {
      private final MemsetValue memsetValue;

      ProgramValueMemsetValue(MemsetValue memsetValue) {
         this.memsetValue = memsetValue;
      }

      @Override
      public Value get() {
         return memsetValue.getSize();
      }

      @Override
      public void set(Value val) {
         memsetValue.setSize((ConstantRef) val);
      }

   }

   /** Size inside a memcpy value . */
   class ProgramValueMempySize implements ProgramValue {

      private final MemcpyValue memcpyValue;

      ProgramValueMempySize(MemcpyValue memcpyValue) {
         this.memcpyValue = memcpyValue;
      }

      @Override
      public Value get() {
         return memcpyValue.getSize();
      }

      @Override
      public void set(Value val) {
         memcpyValue.setSize((ConstantRef) val);
      }

   }

   /** Source inside a memcpy value . */
   class ProgramValueMempySource implements ProgramValue {

      private final MemcpyValue memcpyValue;

      ProgramValueMempySource(MemcpyValue memcpyValue) {
         this.memcpyValue = memcpyValue;
      }

      @Override
      public Value get() {
         return memcpyValue.getSource();
      }

      @Override
      public void set(Value val) {
         memcpyValue.setSource((RValue) val);
      }

   }


   /**
    * Pointer inside a pointer derefence value.
    */
   class ProgramValuePointer implements ProgramValue {
      private final PointerDereference pointer;

      ProgramValuePointer(PointerDereference pointer) {
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
    * Struct expression inside a struct member reference.
    */
   class ProgramValueStruct implements ProgramValue {
      private final StructMemberRef structMemberRef;

      public ProgramValueStruct(StructMemberRef structMemberRef) {
         this.structMemberRef = structMemberRef;
      }

      @Override
      public Value get() {
         return structMemberRef.getStruct();
      }

      @Override
      public void set(Value val) {
         structMemberRef.setStruct((RValue) val);
      }

   }

   class ProgramValueStructUnwoundPlaceholderMember implements ProgramValue {
      private StructUnwoundPlaceholder placeholder;
      private int idx;

      public ProgramValueStructUnwoundPlaceholderMember(StructUnwoundPlaceholder placeholder, int idx) {
         this.placeholder = placeholder;
         this.idx = idx;
      }

      @Override
      public Value get() {
         return placeholder.getUnwoundMembers().get(idx);
      }

      @Override
      public void set(Value value) {
         placeholder.getUnwoundMembers().set(idx, (RValue) value);
      }

   }


   /**
    * Pointer index inside a indexed pointer dererence value.
    */
   class ProgramValuePointerIndex implements ProgramValue {
      private final PointerDereferenceIndexed pointer;

      ProgramValuePointerIndex(PointerDereferenceIndexed pointer) {
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

   /**
    * First value inside a ranged comparison value.
    */
   class ProgramValueRangeFirst implements ProgramValue {
      private final RangeValue range;

      ProgramValueRangeFirst(RangeValue range) {
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
   class ProgramValueRangeLast implements ProgramValue {
      private final RangeValue range;

      ProgramValueRangeLast(RangeValue range) {
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

   /** Size inside a fixed size array. */
   class ProgramValueArraySize implements ProgramValue {
      private final Variable variable;

      ProgramValueArraySize(Variable variable) {
         this.variable = variable;
      }

      @Override
      public Value get() {
         return variable.getArraySize();
      }

      @Override
      public void set(Value val) {
         variable.getArraySpec().setArraySize((ConstantValue) val);
      }

   }

   /** Uses inside a constant array initialized using inline kickasm. */
   class ProgramValueConstantArrayKickAsmUses implements ProgramValue {
      private final ConstantArrayKickAsm constantArrayKickAsm;
      private final int idx;

      public ProgramValueConstantArrayKickAsmUses(ConstantArrayKickAsm constantArrayKickAsm, int idx) {
         this.constantArrayKickAsm = constantArrayKickAsm;
         this.idx = idx;
      }

      @Override
      public Value get() {
         return constantArrayKickAsm.getUses().get(idx);
      }

      @Override
      public void set(Value value) {
         constantArrayKickAsm.getUses().set(idx, (SymbolVariableRef) value);
      }
   }

   /** Reference to an constructor-procedure from a library-procedure. */
   class ProcedureConstructorRef implements ProgramValue {

      private final Procedure procedure;
      private final int idx;

      public ProcedureConstructorRef(Procedure procedure, int idx) {
         this.procedure = procedure;
         this.idx = idx;
      }

      @Override
      public Value get() {
         return procedure.getConstructorRefs().get(idx);
      }

      @Override
      public void set(Value value) {
         procedure.getConstructorRefs().set(idx, (ProcedureRef) value);
      }
   }

}

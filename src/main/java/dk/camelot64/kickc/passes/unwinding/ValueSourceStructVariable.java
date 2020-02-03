package dk.camelot64.kickc.passes.unwinding;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.operators.OperatorSizeOf;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.symbols.ArraySpec;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.symbols.StructDefinition;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;
import dk.camelot64.kickc.model.values.*;
import dk.camelot64.kickc.passes.PassNStructPointerRewriting;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.ListIterator;

/** Value Source for a variable */
public class ValueSourceStructVariable implements ValueSource {

   /** The variable. */
   private final Variable variable;

   public ValueSourceStructVariable(Variable variable) {
      this.variable = variable;
   }

   @Override
   public SymbolType getSymbolType() {
      return variable.getType();
   }

   @Override
   public ArraySpec getArraySpec() {
      return variable.getArraySpec();
   }

   @Override
   public boolean isSimple() {
      return getArraySpec() == null && !(getSymbolType() instanceof SymbolTypeStruct);
   }

   @Override
   public RValue getSimpleValue(ProgramScope programScope) {
      return new ConstantSymbolPointer(variable.getRef());
   }

   @Override
   public boolean isBulkCopyable() {
      return getArraySpec() != null || variable.isStructClassic();
   }

   @Override
   public LValue getBulkLValue(ProgramScope scope) {
      ConstantSymbolPointer pointer = new ConstantSymbolPointer(variable.getRef());
      return new PointerDereferenceSimple(pointer);
   }

   private ConstantValue getByteSize(ProgramScope scope) {
      return getArraySpec() != null ? getArraySpec().getArraySize() : OperatorSizeOf.getSizeOfConstantVar(scope, getSymbolType());
   }

   @Override
   public RValue getBulkRValue(ProgramScope scope) {
      ConstantSymbolPointer pointer = new ConstantSymbolPointer(variable.getRef());
      LValue pointerDeref = new PointerDereferenceSimple(pointer);
      return new MemcpyValue(pointerDeref, getByteSize(scope), getSymbolType());
   }

   @Override
   public boolean isUnwindable() {
      return getSymbolType() instanceof SymbolTypeStruct;
   }

   @Override
   public List<String> getMemberNames(ProgramScope scope) {
      if(getSymbolType() instanceof SymbolTypeStruct) {
         StructDefinition structDefinition = ((SymbolTypeStruct) getSymbolType()).getStructDefinition(scope);
         Collection<Variable> structMemberVars = structDefinition.getAllVars(false);
         ArrayList<String> memberNames = new ArrayList<>();
         for(Variable structMemberVar : structMemberVars) {
            memberNames.add(structMemberVar.getLocalName());
         }
         return memberNames;
      } else {
         return null;
      }
   }

   @Override
   public ValueSource getMemberUnwinding(String memberName, ProgramScope programScope, Statement currentStmt, ControlFlowBlock currentBlock, ListIterator<Statement> stmtIt) {
      if(getSymbolType() instanceof SymbolTypeStruct) {
         StructDefinition structDefinition = ((SymbolTypeStruct) getSymbolType()).getStructDefinition(programScope);
         final SymbolType memberType = structDefinition.getMember(memberName).getType();
         final ArraySpec memberArraySpec = structDefinition.getMember(memberName).getArraySpec();
         ConstantRef memberOffsetConstant = PassNStructPointerRewriting.getMemberOffsetConstant(programScope, structDefinition, memberName);
         // Simple member value - unwind to value of member *((type*)&struct + OFFSET_MEMBER)
         ConstantSymbolPointer structPointer = new ConstantSymbolPointer(variable.getRef());
         // Pointer to member type
         ConstantCastValue structTypedPointer = new ConstantCastValue(new SymbolTypePointer(memberType), structPointer);
         // Calculate member address  (type*)&struct + OFFSET_MEMBER
         ConstantBinary memberPointer = new ConstantBinary(structTypedPointer, Operators.PLUS, memberOffsetConstant);
         // Unwind to *((type*)&struct + OFFSET_MEMBER)
         PointerDereferenceSimple memberDeref = new PointerDereferenceSimple(memberPointer);
         return new ValueSourcePointerDereferenceSimple(memberDeref, memberType, memberArraySpec);
      } else {
         return null;
      }
   }

}
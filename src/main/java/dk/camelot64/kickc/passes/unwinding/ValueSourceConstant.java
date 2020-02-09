package dk.camelot64.kickc.passes.unwinding;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Initializers;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.symbols.*;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;
import dk.camelot64.kickc.model.values.*;

import java.util.ListIterator;

/** Unwinding a constant value. */
public class ValueSourceConstant extends ValueSourceBase {
   private final SymbolType symbolType;
   private final ArraySpec arraySpec;
   private final ConstantValue value;

   public ValueSourceConstant(SymbolType symbolType, ArraySpec arraySpec, ConstantValue value) {
      this.symbolType = symbolType;
      this.arraySpec = arraySpec;
      this.value = value;
   }

   @Override
   public SymbolType getSymbolType() {
      return symbolType;
   }

   @Override
   public ArraySpec getArraySpec() {
      return arraySpec;
   }

   @Override
   protected boolean isStructClassic() {
      return getSymbolType() instanceof SymbolTypeStruct;
   }

   @Override
   public RValue getSimpleValue(ProgramScope programScope) {
      return value;
   }

   @Override
   public ValueSource getMemberUnwinding(String memberName, Program program, ProgramScope programScope, Statement currentStmt, ListIterator<Statement> stmtIt, ControlFlowBlock currentBlock) {
      StructDefinition structDefinition = ((SymbolTypeStruct) getSymbolType()).getStructDefinition(programScope);
      if(value instanceof ConstantStructValue) {
         ConstantStructValue constantStructValue = (ConstantStructValue) value;
         final Variable member = structDefinition.getMember(memberName);
         final SymbolType type = member.getType();
         final ArraySpec arraySpec = member.getArraySpec();
         final ConstantValue memberValue = constantStructValue.getValue(member.getRef());
         return new ValueSourceConstant(type, arraySpec, memberValue);
      } else if(value instanceof StructZero) {
         final SymbolType memberType = structDefinition.getMember(memberName).getType();
         final ArraySpec memberArraySpec = structDefinition.getMember(memberName).getArraySpec();
         final ConstantValue memberZeroValue = Initializers.createZeroValue(new Initializers.ValueTypeSpec(memberType, memberArraySpec), currentStmt.getSource());
         return new ValueSourceConstant(memberType, memberArraySpec, memberZeroValue);
      }
      throw new InternalError("Not supported "+value);
   }

   @Override
   public LValue getBulkLValue(ProgramScope scope) {
      throw new InternalError("Not a valid LValue!");
   }

   @Override
   public RValue getBulkRValue(ProgramScope scope) {
      String constName = scope.allocateIntermediateVariableName();
      Variable constVar = Variable.createConstant(constName, symbolType, scope, getArraySpec(), value, Scope.SEGMENT_DATA_DEFAULT);
      scope.add(constVar);
      if(getArraySpec()!=null) {
         final SymbolType elementType = ((SymbolTypePointer) getSymbolType()).getElementType();
         return new MemcpyValue(new PointerDereferenceSimple(new ConstantSymbolPointer(constVar.getRef())), getByteSize(scope), elementType);
      }  else {
         return new MemcpyValue(new PointerDereferenceSimple(new ConstantSymbolPointer(constVar.getRef())), getByteSize(scope), getSymbolType());
      }
   }

}

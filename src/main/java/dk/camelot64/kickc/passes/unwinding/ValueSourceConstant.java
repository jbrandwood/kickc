package dk.camelot64.kickc.passes.unwinding;

import dk.camelot64.kickc.model.Graph;
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
   private final ConstantValue value;

   public ValueSourceConstant(SymbolType symbolType, ConstantValue value) {
      this.symbolType = symbolType;
      this.value = value;
   }

   @Override
   public SymbolType getSymbolType() {
      return symbolType;
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
   public ValueSource getMemberUnwinding(String memberName, Program program, ProgramScope programScope, Statement currentStmt, ListIterator<Statement> stmtIt, Graph.Block currentBlock) {
      StructDefinition structDefinition = ((SymbolTypeStruct) getSymbolType()).getStructDefinition(programScope);
      ConstantValue val = this.value;
      while(val instanceof ConstantCastValue)
         val = ((ConstantCastValue) val).getValue();
      if(val instanceof ConstantStructValue) {
         ConstantStructValue constantStructValue = (ConstantStructValue) val;
         final Variable member = structDefinition.getMember(memberName);
         final SymbolType type = member.getType();
         final ConstantValue memberValue = constantStructValue.getValue(member.getRef());
         return new ValueSourceConstant(type, memberValue);
      } else if(val instanceof StructZero) {
         final SymbolType memberType = structDefinition.getMember(memberName).getType();
         final ConstantValue memberZeroValue = Initializers.createZeroValue(new Initializers.ValueTypeSpec(memberType), currentStmt.getSource());
         return new ValueSourceConstant(memberType, memberZeroValue);
      }
      throw new InternalError("Not supported "+ val);
   }

   @Override
   public LValue getBulkLValue(ProgramScope scope) {
      throw new InternalError("Not a valid LValue!");
   }

   @Override
   public RValue getBulkRValue(ProgramScope scope) {
      String constName = scope.allocateIntermediateVariableName();
      Variable constVar = Variable.createConstant(constName, symbolType, scope, value, Scope.SEGMENT_DATA_DEFAULT);
      scope.add(constVar);
      if(getArraySpec()!=null) {
         final SymbolType elementType = ((SymbolTypePointer) getSymbolType()).getElementType();
         return new MemcpyValue(new PointerDereferenceSimple(new ConstantSymbolPointer(constVar.getRef())), getByteSize(scope), elementType);
      }  else {
         return new MemcpyValue(new PointerDereferenceSimple(new ConstantSymbolPointer(constVar.getRef())), getByteSize(scope), getSymbolType());
      }
   }

}

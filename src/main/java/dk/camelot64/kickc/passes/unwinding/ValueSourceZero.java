package dk.camelot64.kickc.passes.unwinding;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Initializers;
import dk.camelot64.kickc.model.InternalError;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.symbols.ArraySpec;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.symbols.StructDefinition;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;
import dk.camelot64.kickc.model.values.LValue;
import dk.camelot64.kickc.model.values.MemsetValue;
import dk.camelot64.kickc.model.values.RValue;

import java.util.ListIterator;

/** Value Source for a zero value. */
public class ValueSourceZero extends ValueSourceBase {

   private final SymbolType symbolType;
   private final ArraySpec arraySpec;

   public ValueSourceZero(SymbolType symbolType, ArraySpec arraySpec) {
      this.symbolType = symbolType;
      this.arraySpec = arraySpec;
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
      return Initializers.createZeroValue(new Initializers.ValueTypeSpec(getSymbolType(), getArraySpec()), null);
   }

   @Override
   public ValueSource getMemberUnwinding(String memberName, Program program, ProgramScope programScope, Statement currentStmt, ListIterator<Statement> stmtIt, ControlFlowBlock currentBlock) {
      StructDefinition structDefinition = ((SymbolTypeStruct) getSymbolType()).getStructDefinition(programScope);
      final SymbolType memberType = structDefinition.getMember(memberName).getType();
      final ArraySpec memberArraySpec = structDefinition.getMember(memberName).getArraySpec();
      return new ValueSourceZero(memberType, memberArraySpec);
   }

   @Override
   public LValue getBulkLValue(ProgramScope scope) {
      throw new InternalError("Not a legal LValue!");
   }

   @Override
   public RValue getBulkRValue(ProgramScope scope) {
      return new MemsetValue(getByteSize(scope), getSymbolType());
   }

}

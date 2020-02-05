package dk.camelot64.kickc.passes.unwinding;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.InternalError;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.symbols.ArraySpec;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.symbols.StructDefinition;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.LValue;
import dk.camelot64.kickc.model.values.RValue;
import dk.camelot64.kickc.model.values.ValueList;
import dk.camelot64.kickc.passes.Pass1UnwindStructValues;

import java.util.ListIterator;

/** A struct value list - typically an initializer <code>struct Point p = { x, y };</code>. */
public class ValueSourceStructValueList extends ValueSourceBase {

   private final StructDefinition structDefinition;
   private final ValueList valueList;

   public ValueSourceStructValueList(ValueList valueList, StructDefinition structDefinition) {
      this.valueList = valueList;
      this.structDefinition = structDefinition;
   }

   @Override
   public SymbolType getSymbolType() {
      return structDefinition.getType();
   }

   @Override
   public ArraySpec getArraySpec() {
      return null;
   }

   @Override
   protected boolean isStructClassic() {
      return false;
   }

   @Override
   public RValue getSimpleValue(ProgramScope programScope) {
      throw new InternalError("Not a simple value");
   }

   @Override
   public LValue getBulkLValue(ProgramScope scope) {
      throw new InternalError("Not a bulk value");
   }

   @Override
   public RValue getBulkRValue(ProgramScope scope) {
      throw new InternalError("Not a bulk value");
   }

   @Override
   public ValueSource getMemberUnwinding(String memberName, Program program, ProgramScope programScope, Statement currentStmt, ControlFlowBlock currentBlock, ListIterator<Statement> stmtIt) {
      int memberIndex = getMemberNames(programScope).indexOf(memberName);
      final RValue memberValue = valueList.getList().get(memberIndex);
      final ValueSource valueSource = Pass1UnwindStructValues.getValueSource(program, programScope, memberValue, currentStmt, stmtIt, currentBlock);
      return valueSource;
   }

}

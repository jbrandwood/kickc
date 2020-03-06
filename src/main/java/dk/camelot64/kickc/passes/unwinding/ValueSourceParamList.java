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
import dk.camelot64.kickc.model.values.ParamValue;
import dk.camelot64.kickc.model.values.RValue;

import java.util.ListIterator;

/** A parameter value list. */
public class ValueSourceParamList extends ValueSourceBase {

   private final StructDefinition structDefinition;
   private final ParamValue paramValue;

   public ValueSourceParamList(ParamValue paramValue, StructDefinition structDefinition) {
      this.paramValue = paramValue;
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
   public ValueSource getMemberUnwinding(String memberName, Program program, ProgramScope programScope, Statement currentStmt, ListIterator<Statement> stmtIt, ControlFlowBlock currentBlock) {
      final ValueSource paramValueSource = ValueSourceFactory.getValueSource(paramValue.getParameter(), program, programScope, currentStmt, stmtIt, currentBlock);
      final ValueSource memberUnwinding = paramValueSource.getMemberUnwinding(memberName, program, programScope, currentStmt, stmtIt, currentBlock);
      return new ValueSourceParamValue(memberUnwinding);
   }

}

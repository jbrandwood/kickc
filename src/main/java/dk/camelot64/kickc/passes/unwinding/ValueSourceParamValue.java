package dk.camelot64.kickc.passes.unwinding;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.InternalError;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.symbols.ArraySpec;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.LValue;
import dk.camelot64.kickc.model.values.ParamValue;
import dk.camelot64.kickc.model.values.RValue;
import dk.camelot64.kickc.model.values.VariableRef;

import java.util.ListIterator;

/** A parameter value list. */
public class ValueSourceParamValue extends ValueSourceBase {

   private final ValueSource valueSource;

   public ValueSourceParamValue(ValueSource valueSource) {
      this.valueSource = valueSource;
   }

   @Override
   public SymbolType getSymbolType() {
      return valueSource.getSymbolType();
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
      return new ParamValue((VariableRef) valueSource.getSimpleValue(programScope));
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
      final ValueSource memberUnwinding = valueSource.getMemberUnwinding(memberName, program, programScope, currentStmt, stmtIt, currentBlock);
      return new ValueSourceParamValue(memberUnwinding);
   }

}

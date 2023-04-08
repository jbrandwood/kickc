package dk.camelot64.kickc.passes.unwinding;

import dk.camelot64.kickc.model.Graph;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.symbols.ArraySpec;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;
import dk.camelot64.kickc.model.values.CastValue;
import dk.camelot64.kickc.model.values.LValue;
import dk.camelot64.kickc.model.values.RValue;

import java.util.ListIterator;

/**
 * A cast of a simple value
 */
public class ValueSourceCastValue extends ValueSourceBase {

   private final SymbolType toType;
   private final ValueSource subValueSource;

   public ValueSourceCastValue(SymbolType toType, ValueSource subValueSource) {
      this.toType = toType;
      this.subValueSource = subValueSource;
   }

   @Override
   public SymbolType getSymbolType() {
      return toType;
   }

   @Override
   public ArraySpec getArraySpec() {
      return null;
   }

   @Override
   protected boolean isStructClassic() {
      return getSymbolType() instanceof SymbolTypeStruct;
   }

   @Override
   public RValue getSimpleValue(ProgramScope programScope) {
      return new CastValue(toType, subValueSource.getSimpleValue(programScope));
   }

   @Override
   public LValue getBulkLValue(ProgramScope scope) {
      throw new InternalError("Not a valid LValue!");
   }

   @Override
   public RValue getBulkRValue(ProgramScope scope) {
      throw new InternalError("Not supported ");
   }

   @Override
   public ValueSource getMemberUnwinding(String memberName, Program program, ProgramScope programScope, Statement currentStmt, ListIterator<Statement> stmtIt, Graph.Block currentBlock) {
      throw new InternalError("Not supported ");
   }
}

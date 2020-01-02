package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.ConstantNotLiteral;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;

/**
 * An zero-filled struct.
 */
public class StructZero implements ConstantValue {

   private SymbolTypeStruct typeStruct;

   public StructZero(SymbolTypeStruct typeStruct) {
      this.typeStruct = typeStruct;
   }

   public SymbolTypeStruct getTypeStruct() {
      return typeStruct;
   }

   @Override
   public SymbolType getType(ProgramScope scope) {
      return typeStruct;
   }

   @Override
   public ConstantLiteral calculateLiteral(ProgramScope scope) {
      throw new ConstantNotLiteral("Cannot calculate literal struct.");
   }

   @Override
   public String toString(Program program) {
      return "{}";
   }
}

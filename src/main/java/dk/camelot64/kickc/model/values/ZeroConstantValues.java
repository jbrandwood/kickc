package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.InternalError;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.symbols.StructDefinition;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeIntegerFixed;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;

import java.util.LinkedHashMap;

/**
 * Factory usable for creating the default "zero" values for all types.
 */
public class ZeroConstantValues {

   public static ConstantValue zeroValue(SymbolType type, ProgramScope programScope) {
      if(type instanceof SymbolTypeStruct) {
         SymbolTypeStruct typeStruct = (SymbolTypeStruct) type;
         LinkedHashMap<SymbolVariableRef, ConstantValue> zeroValues = new LinkedHashMap<>();
         StructDefinition structDefinition = typeStruct.getStructDefinition(programScope);
         for(Variable memberVar : structDefinition.getAllVariables(false)) {
            zeroValues.put(memberVar.getRef(), zeroValue(memberVar.getType(), programScope));
         }
         return new ConstantStructValue(typeStruct, zeroValues);
      } else if(type.equals(SymbolType.BOOLEAN)) {
         return new ConstantBool(false);
      } else if(type instanceof SymbolTypeIntegerFixed) {
         return new ConstantInteger(0L, type);
      } else if(type instanceof SymbolTypePointer) {
         return new ConstantPointer(0L, ((SymbolTypePointer) type).getElementType());
      } else {
         throw new InternalError("Unhandled type " + type);
      }
   }

}

package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.symbols.StructDefinition;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;

import java.util.concurrent.atomic.AtomicBoolean;

/**
 * Fixes byte-size of all struct types. (which may be a bit off if struct types are referenced before being parsed completely)
 */
public class Pass1StructTypeSizeFix extends Pass2SsaOptimization {

   public Pass1StructTypeSizeFix(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      AtomicBoolean modified = new AtomicBoolean(false);
      for(Variable variable : getScope().getAllVars(true)) {
         modified.set(fixStructSize(variable.getType()));
      }
      return modified.get();
   }

   /**
    * Fix struct byte-sizes in the passed type (if any)
    * @param type The type to fix
    * @return true if anything was modified
    */
   private boolean fixStructSize(SymbolType type) {
      if(type instanceof SymbolTypeStruct) {
         SymbolTypeStruct typeStruct = (SymbolTypeStruct) type;
         StructDefinition structDefinition = typeStruct.getStructDefinition(getScope());
         int sizeBytes = typeStruct.calculateSizeBytes(structDefinition, getScope());
         if(sizeBytes!=typeStruct.getSizeBytes()) {
            getLog().append("Fixing struct type size "+type.getTypeName() + " to "+sizeBytes);
            typeStruct.setSizeBytes(sizeBytes);
            return true;
         }  else {
            return false;
         }
      } else if(type instanceof SymbolTypePointer) {
         return fixStructSize(((SymbolTypePointer) type).getElementType());
      } else {
         return false;
      }
   }
}

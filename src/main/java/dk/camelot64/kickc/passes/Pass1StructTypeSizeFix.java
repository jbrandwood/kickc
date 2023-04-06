package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.symbols.StructDefinition;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;
import dk.camelot64.kickc.model.values.ConstantStructValue;
import dk.camelot64.kickc.model.values.StructUnwoundPlaceholder;
import dk.camelot64.kickc.model.values.StructZero;
import dk.camelot64.kickc.passes.utils.SizeOfConstants;

/**
 * Fixes byte-size of all struct types. (which may be a bit off if struct types are referenced before being parsed completely)
 */
public class Pass1StructTypeSizeFix extends Pass2SsaOptimization {

   public Pass1StructTypeSizeFix(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      boolean modified = false;

      // Update all types in variables
      for(Variable variable : getProgramScope().getAllVars(true)) {
         modified |= fixStructSize(variable.getType());
      }

      // Update all types hidden inside values
      ProgramValueIterator.execute(getProgram(), (programValue, currentStmt, stmtIt, currentBlock) -> {
         if(programValue.get() instanceof StructZero) {
            final SymbolTypeStruct typeStruct = ((StructZero) programValue.get()).getTypeStruct();
            fixStructSize(typeStruct);
         } else if(programValue.get() instanceof ConstantStructValue) {
            final SymbolTypeStruct typeStruct = ((ConstantStructValue) programValue.get()).getStructType();
            fixStructSize(typeStruct);
         } else if(programValue.get() instanceof StructUnwoundPlaceholder) {
            final SymbolTypeStruct typeStruct = ((StructUnwoundPlaceholder) programValue.get()).getTypeStruct();
            fixStructSize(typeStruct);
         }
      });

      // Update all SIZEOF_XXX constants
      for(Scope subScope : getProgramScope().getAllScopes(false)) {
         if(subScope instanceof StructDefinition) {
            SymbolTypeStruct typeStruct = new SymbolTypeStruct((StructDefinition) subScope, false, false);
            StructDefinition structDefinition = typeStruct.getStructDefinition(getProgramScope());
            int sizeBytes = typeStruct.calculateSizeBytes(structDefinition, getProgramScope());
            if(sizeBytes != typeStruct.getSizeBytes()) {
               getLog().append("Fixing struct type SIZE_OF " + typeStruct.toCDecl() + " to " + sizeBytes);
               typeStruct.setSizeBytes(sizeBytes);
               SizeOfConstants.fixSizeOfConstantVar(getProgramScope(), typeStruct);
            }
         }
      }

      return modified;
   }

   /**
    * Fix struct byte-sizes in the passed type (if any)
    *
    * @param type The type to fix
    * @return true if anything was modified
    */
   private boolean fixStructSize(SymbolType type) {
      if(type instanceof SymbolTypeStruct) {
         SymbolTypeStruct typeStruct = (SymbolTypeStruct) type;
         StructDefinition structDefinition = typeStruct.getStructDefinition(getProgramScope());
         int sizeBytes = typeStruct.calculateSizeBytes(structDefinition, getProgramScope());
         if(sizeBytes != typeStruct.getSizeBytes()) {
            getLog().append("Fixing struct type size " + type.toCDecl() + " to " + sizeBytes);
            typeStruct.setSizeBytes(sizeBytes);
            return true;
         } else {
            return false;
         }
      } else if(type instanceof SymbolTypePointer) {
         return fixStructSize(((SymbolTypePointer) type).getElementType());
      } else {
         return false;
      }
   }
}

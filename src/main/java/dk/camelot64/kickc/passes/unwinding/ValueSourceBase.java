package dk.camelot64.kickc.passes.unwinding;

import dk.camelot64.kickc.model.symbols.ArraySpec;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.symbols.StructDefinition;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;
import dk.camelot64.kickc.model.values.ConstantValue;
import dk.camelot64.kickc.passes.utils.SizeOfConstants;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

/** Value Source for a variable */
public abstract class ValueSourceBase implements ValueSource {

   @Override
   public boolean isSimple() {
      return getArraySpec() == null && !(getSymbolType() instanceof SymbolTypeStruct);
   }

   /** It is a struct with C-classic memory layout
    *
    * @return true if the value is a struct with C-classic memory layout
    */
   protected abstract boolean isStructClassic();

   @Override
   public boolean isBulkCopyable() {
      return getArraySpec() != null || isStructClassic();
   }

   @Override
   public boolean isUnwindable() {
      return getSymbolType() instanceof SymbolTypeStruct;
   }

   protected ConstantValue getByteSize(ProgramScope scope) {
      return getArraySpec() != null ? getArraySpec().getArraySize() : SizeOfConstants.getSizeOfConstantVar(scope, getSymbolType());
   }

   @Override
   public ArraySpec getArraySpec() {
      if(getSymbolType() instanceof SymbolTypePointer)
         return  ((SymbolTypePointer) getSymbolType()).getArraySpec();
      else
         return  null;
   }

   @Override
   public List<String> getMemberNames(ProgramScope scope) {
      if(getSymbolType() instanceof SymbolTypeStruct) {
         StructDefinition structDefinition = ((SymbolTypeStruct) getSymbolType()).getStructDefinition(scope);
         Collection<Variable> structMemberVars = structDefinition.getAllVars(false);
         ArrayList<String> memberNames = new ArrayList<>();
         for(Variable structMemberVar : structMemberVars) {
            memberNames.add(structMemberVar.getLocalName());
         }
         return memberNames;
      } else {
         return null;
      }
   }

}
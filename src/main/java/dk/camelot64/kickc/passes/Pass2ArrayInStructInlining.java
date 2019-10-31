package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramValue;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.symbols.ConstantVar;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeArray;
import dk.camelot64.kickc.model.values.ConstantRef;
import dk.camelot64.kickc.model.values.ConstantValue;
import dk.camelot64.kickc.model.values.Value;
import dk.camelot64.kickc.model.values.VariableRef;

import java.util.HashMap;
import java.util.Map;

/**
 * Compiler Pass inlining arrays inside literal structs
 */
public class Pass2ArrayInStructInlining extends Pass2SsaOptimization {

   public Pass2ArrayInStructInlining(Program program) {
      super(program);
   }

   /**
    * Consolidate unnamed constants into other constants value
    *
    * @return true optimization was performed. false if no optimization was possible.
    */
   @Override
   public boolean step() {
      Map<ConstantRef, ConstantValue> inline = new HashMap<>();
      inline.putAll(findArrayInStruct());

      // Replace all usages of the constants in the control flow graph or symbol table
      replaceVariables(inline);
      // Remove from symbol table
      deleteSymbols(getScope(), inline.keySet());

      for(ConstantRef constantRef : inline.keySet()) {
         getLog().append("Constant array inlined into struct " + constantRef.toString() + " = " + inline.get(constantRef).toString(getProgram()));
      }

      return inline.size() > 0;

   }

   /**
    * Find constant fixed size arrays inside structs.
    *
    * @return Map from constant name to constant value
    */
   private Map<ConstantRef, ConstantValue> findArrayInStruct() {
      Map<ConstantRef, ConstantValue> inline = new HashMap<>();
      ProgramValueIterator.execute(getProgram(), (programValue, currentStmt, stmtIt, currentBlock) -> {
         Value value = programValue.get();
         if(programValue instanceof ProgramValue.ProgramValueConstantStructMember) {
            VariableRef memberRef = ((ProgramValue.ProgramValueConstantStructMember) programValue).getMemberRef();
            Variable structMemberVar = getScope().getVariable(memberRef);
            if(structMemberVar.getType() instanceof SymbolTypeArray) {
               if(((SymbolTypeArray) structMemberVar.getType()).getSize() != null) {
                  if(value instanceof ConstantValue) {
                     ConstantValue constantValue = (ConstantValue) value;
                     if(constantValue.getType(getProgram().getScope()).equals(SymbolType.STRING)) {
                        if(constantValue instanceof ConstantRef) {
                           ConstantVar constantStringVar = getScope().getConstant((ConstantRef) constantValue);
                           inline.put((ConstantRef) constantValue, constantStringVar.getConstantValue());
                        }
                     }
                  }
               }
            }
         }
      });
      return inline;
   }

}

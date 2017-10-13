package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.icl.ConstantRef;
import dk.camelot64.kickc.icl.ConstantValue;
import dk.camelot64.kickc.icl.ConstantVar;
import dk.camelot64.kickc.icl.Program;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

/** Compiler Pass consolidating unnamed constants into the place using them (instructions or the definition of another constant value) */
public class Pass2ConstantInlining extends Pass2SsaOptimization {

   public Pass2ConstantInlining(Program program) {
      super(program);
   }

   /**
    * Consolidate unnamed constants into other constants value
    * @return true optimization was performed. false if no optimization was possible.
    */
   @Override
   public boolean optimize() {
      Map<ConstantRef, ConstantValue> unnamedConstants = findUnnamedConstants();

      // Replace all usages of the unnamed constants
      replaceVariables(unnamedConstants);
      // Remove from symbol table
      deleteSymbols(unnamedConstants.keySet());

      for (ConstantRef constantRef : unnamedConstants.keySet()) {
         getLog().append("Constant inlined " + constantRef.toString()+" = "+unnamedConstants.get(constantRef).toString(getProgram()));
      }

      return unnamedConstants.size()>0;

   }

   private Map<ConstantRef, ConstantValue> findUnnamedConstants() {
      Map<ConstantRef, ConstantValue> unnamed = new HashMap<>();
      Collection<ConstantVar> allConstants = getProgram().getScope().getAllConstants(true);
      for (ConstantVar constant : allConstants) {
         if(constant.getRef().isIntermediate()) {
            unnamed.put(constant.getRef(), constant.getValue());
         }
      }
      return unnamed;
   }


}

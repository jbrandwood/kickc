package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.symbols.ConstantVar;
import dk.camelot64.kickc.model.values.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Compiler Pass finding and consolidating identical constant strings
 */
public class Pass2ConstantStringConsolidation extends Pass2SsaOptimization {

   public Pass2ConstantStringConsolidation(Program program) {
      super(program);
   }

   /**
    * Find identical constant strings and consolidate
    *
    * @return true optimization was performed. false if no optimization was possible.
    */
   @Override
   public boolean step() {
      boolean modified = false;
      // Build a map with all constant strings
      Map<String, List<ConstantVar>> constantStringMap = new HashMap<>();
      for(ConstantVar constVar : getScope().getAllConstants(true)) {
         ConstantValue constVal = constVar.getValue();
         if(constVal instanceof ConstantString) {
            String constString = ((ConstantString) constVal).getString();
            List<ConstantVar> constantVars = constantStringMap.get(constString);
            if(constantVars==null) {
               constantVars = new ArrayList<>();
               constantStringMap.put(constString, constantVars);
            }
            constantVars.add(constVar);
         }
      }
      // Handle all constant strings with duplicate definitions
      for(String str : constantStringMap.keySet()) {
         List<ConstantVar> constantVars = constantStringMap.get(str);
         if(constantVars.size()>1) {
            // Found duplicate constant strings
            modified |= handleDuplicateConstantString(constantVars);

         }
      }
      return modified;
   }

   /**
    * Handle duplicate constants strings with identical values
    * @param constantVars The constant strings with identical values
    * @return true if any optimization was performed
    */
   private boolean handleDuplicateConstantString(List<ConstantVar> constantVars) {
      boolean modified = false;
      // Look for a constant in the root scope
      ConstantVar rootConstant = null;
      for(ConstantVar constantVar : constantVars) {
         if(constantVar.getScope().getRef().equals(ScopeRef.ROOT)) {
            rootConstant = constantVar;
            break;
         }
      }
      if(rootConstant!=null) {
         // Modify all other constants to be references to the root constant
         for(ConstantVar constantVar : constantVars) {
            if(!constantVar.equals(rootConstant)) {
               constantVar.setValue(new ConstantRef(rootConstant));
               modified = true;
            }
         }
      }
      return modified;
   }

}

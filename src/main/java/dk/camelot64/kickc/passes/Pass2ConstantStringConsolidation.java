package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.symbols.ConstantVar;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.ConstantRef;
import dk.camelot64.kickc.model.values.ConstantString;
import dk.camelot64.kickc.model.values.ConstantValue;
import dk.camelot64.kickc.model.values.ScopeRef;

import java.util.*;

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
      Map<ConstantString, List<ConstantVar>> constantStringMap = new LinkedHashMap<>();
      for(ConstantVar constVar : getScope().getAllConstants(true)) {
         ConstantValue constVal = constVar.getValue();
         if(constVal instanceof ConstantString) {
            ConstantString constString = (ConstantString) constVal;
            List<ConstantVar> constantVars = constantStringMap.computeIfAbsent(constString, k -> new ArrayList<>());
            constantVars.add(constVar);
         }
      }
      // Handle all constant strings with duplicate definitions
      for(ConstantString constantString : constantStringMap.keySet()) {
         List<ConstantVar> constantVars = constantStringMap.get(constantString);
         if(constantVars.size() > 1) {
            // Found duplicate constant strings
            modified |= handleDuplicateConstantString(constantVars, constantString);

         }
      }
      return modified;
   }

   /**
    * Handle duplicate constants strings with identical values
    *
    * @param constantVars The constant strings with identical values
    * @return true if any optimization was performed
    */
   private boolean handleDuplicateConstantString(List<ConstantVar> constantVars, ConstantString constString) {
      boolean modified = false;
      // Look for a constant in the root scope - or check if they are all in the same scope
      ConstantVar rootConstant = null;
      boolean isCommonScope = true;
      ScopeRef commonScope = null;
      for(ConstantVar constantVar : constantVars) {
         ScopeRef constScope = constantVar.getScope().getRef();
         if(constScope.equals(ScopeRef.ROOT)) {
            rootConstant = constantVar;
            break;
         }
         if(commonScope == null) {
            commonScope = constScope;
         } else {
            if(!commonScope.equals(constScope)) {
               // Found two different scopes
               isCommonScope = false;
            }
         }
      }

      if(rootConstant == null) {
         if(isCommonScope) {
            // If all constants are in the same scope pick the first one as root
            rootConstant = constantVars.get(0);
         } else {
            // Create a new root - and roll around again
            ProgramScope rootScope = getScope();
            String localName = getRootName(constantVars);
            ConstantVar newRootConstant = new ConstantVar(localName, rootScope, SymbolType.STRING, constString);
            rootScope.add(newRootConstant);
            rootConstant = newRootConstant;
         }
      }
      // Modify all other constants to be references to the root constant
      for(ConstantVar constantVar : constantVars) {
         if(!constantVar.equals(rootConstant)) {
            constantVar.setValue(new ConstantRef(rootConstant));
            modified = true;
         }
      }
      if(getLog().isVerboseSSAOptimize()) {
         getLog().append("Consolidated constant strings into " + rootConstant);

      }
      return modified;
   }

   private String getRootName(List<ConstantVar> constantVars) {
      String constName = null;
      // Try all variables with non-intermediate names
      for(ConstantVar constantVar : constantVars) {
         if(!constantVar.getRef().isIntermediate()) {
            String candidateName = constantVar.getLocalName();
            if(getScope().getSymbol(candidateName) == null) {
               if(constName == null || constName.length() > candidateName.length()) {
                  constName = candidateName;
               }
            }
         }
      }
      if(constName != null) {
         return constName;
      }
      // Try string_nn until an unused name is found
      int i = 0;
      do {
         String candidateName = "string_" + i;
         if(getScope().getSymbol(candidateName) == null) {
            return candidateName;
         }
      } while(true);
   }

}

package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.symbols.ArraySpec;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.ConstantRef;
import dk.camelot64.kickc.model.values.ConstantString;
import dk.camelot64.kickc.model.values.ConstantValue;
import dk.camelot64.kickc.model.values.ScopeRef;

import java.util.ArrayList;
import java.util.LinkedHashMap;
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
      Map<ConstantString, List<Variable>> constantStringMap = new LinkedHashMap<>();
      for(Variable constVar : getScope().getAllConstants(true)) {
         ConstantValue constVal = constVar.getConstantValue();
         if(constVal instanceof ConstantString) {
            ConstantString constString = (ConstantString) constVal;
            List<Variable> constantVars = constantStringMap.computeIfAbsent(constString, k -> new ArrayList<>());
            constantVars.add(constVar);
         }
      }
      // Handle all constant strings with duplicate definitions
      for(ConstantString constantString : constantStringMap.keySet()) {
         List<Variable> constantVars = constantStringMap.get(constantString);
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
   private boolean handleDuplicateConstantString(List<Variable> constantVars, ConstantString constString) {
      boolean modified = false;
      // Look for a constant in the root scope - or check if they are all in the same scope
      Variable rootConstant = null;
      boolean isCommonScope = true;
      ScopeRef commonScope = null;
      String segmentData = null;
      for(Variable constantVar : constantVars) {
         ScopeRef constScope = constantVar.getScope().getRef();
         segmentData = constantVar.getDataSegment();
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
            Variable newRootConstant = new Variable(localName, SymbolType.STRING, new ArraySpec(), rootScope, segmentData, constString);
            rootScope.add(newRootConstant);
            rootConstant = newRootConstant;
         }
      }
      // Modify all other constants to be references to the root constant
      for(Variable constantVar : constantVars) {
         if(!constantVar.equals(rootConstant)) {
            constantVar.setConstantValue(new ConstantRef(rootConstant));
            modified = true;
         }
      }
      if(getLog().isVerboseSSAOptimize()) {
         getLog().append("Consolidated constant strings into " + rootConstant);

      }
      return modified;
   }

   private String getRootName(List<Variable> constantVars) {
      String constName = null;
      // Try all variables with non-intermediate names
      for(Variable constantVar : constantVars) {
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

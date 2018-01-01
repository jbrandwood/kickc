package dk.camelot64.kickc.model;

import java.util.Map;
import java.util.Set;

/**
 * Contains all variables modified inside procedures. Contain the unversioned VariableRefs.
 */
public class ProcedureModifiedVars {

   private Map<ProcedureRef, Set<VariableRef>> modified;

   public ProcedureModifiedVars(Map<ProcedureRef, Set<VariableRef>> modified) {
      this.modified = modified;
   }

   public Set<VariableRef> getModifiedVars(ProcedureRef procedure) {
      return modified.get(procedure);
   }


   public String toString(Program program) {
      StringBuilder out = new StringBuilder();
      for(ProcedureRef procedureRef : modified.keySet()) {
         for(VariableRef variableRef : getModifiedVars(procedureRef)) {
            out.append(procedureRef.getFullName()).append(" modifies " + variableRef.getFullName()).append("\n");
         }
      }
      return out.toString();
   }
}

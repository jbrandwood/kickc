package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;

import java.util.*;

/** Find all variables from an outer scope modified in an inner scope (ie. a procedure) */
public class Pass1ModifiedVarsAnalysis extends Pass1Base {

   public Pass1ModifiedVarsAnalysis(Program program) {
      super(program);
   }

   @Override
   boolean executeStep() {
      Map<ProcedureRef, Set<VariableRef>> modified = new LinkedHashMap<>();
      Collection<Procedure> allProcedures = getScope().getAllProcedures(true);
      for (Procedure procedure : allProcedures) {
         Set<VariableRef> modifiedVars = getModifiedVars(procedure);
         modified.put(procedure.getRef(), modifiedVars);
      }
      getProgram().setProcedureModifiedVars(new ProcedureModifiedVars(modified));
      return false;
   }

   /** Get all outside variables modified by a procedure (or any sub-procedure called by the procedure).
    *
    * @param procedure The procedure to examine
    * @return All variables declared outside the procedure modified inside the procedure.
    */
   public Set<VariableRef> getModifiedVars(Procedure procedure) {
      Set<VariableRef> modified = new LinkedHashSet<>();
      ScopeRef procScope = procedure.getRef();
      List<ControlFlowBlock> procBlocks = getProgram().getGraph().getScopeBlocks(procScope);
      for (ControlFlowBlock block : procBlocks) {
         for (Statement statement : block.getStatements()) {
            if(statement instanceof StatementLValue) {
               LValue lValue = ((StatementLValue) statement).getlValue();
               if(lValue instanceof VariableRef) {
                  VariableRef var = (VariableRef) lValue;
                  if(!var.getScopeNames().equals(procScope.getFullName())) {
                     modified.add(var);
                  }
               }
               if(statement instanceof StatementCall) {
                  ProcedureRef called = ((StatementCall) statement).getProcedure();
                  Procedure calledProc = getScope().getProcedure(called);
                  modified.addAll(getModifiedVars(calledProc));
               }
            }
         }
      }
      return modified;
   }


}

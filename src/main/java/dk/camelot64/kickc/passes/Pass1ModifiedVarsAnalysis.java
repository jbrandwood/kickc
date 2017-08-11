package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.icl.*;

import java.util.*;

/** Find all variables from an outer scope modified in an inner scope (ie. a procedure) */
public class Pass1ModifiedVarsAnalysis {

   private Program program;

   public Pass1ModifiedVarsAnalysis(Program program) {
      this.program = program;
   }

   public void findModifiedVars() {
      Map<ProcedureRef, Set<VariableRef>> modified = new LinkedHashMap<>();
      Collection<Procedure> allProcedures = program.getScope().getAllProcedures(true);
      for (Procedure procedure : allProcedures) {
         Set<VariableRef> modifiedVars = getModifiedVars(procedure);
         modified.put(procedure.getRef(), modifiedVars);
      }
      program.setProcedureModifiedVars(new ProcedureModifiedVars(modified));
   }

   /** Get all outside variables modified by a procedure (or any sub-procedure called by the procedure).
    *
    * @param procedure The procedure to examine
    * @return All variables declared outside the procedure modified inside the procedure.
    */
   public Set<VariableRef> getModifiedVars(Procedure procedure) {
      Set<VariableRef> modified = new LinkedHashSet<>();
      LabelRef procScope = procedure.getScopeLabelRef();
      List<ControlFlowBlock> procBlocks = program.getGraph().getScopeBlocks(procScope);
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
                  Procedure calledProc = program.getScope().getProcedure(called);
                  modified.addAll(getModifiedVars(calledProc));
               }
            }
         }
      }
      return modified;
   }


}

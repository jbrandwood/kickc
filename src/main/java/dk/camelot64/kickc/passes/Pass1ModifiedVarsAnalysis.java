package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Graph;
import dk.camelot64.kickc.model.ProcedureModifiedVars;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementCalling;
import dk.camelot64.kickc.model.statements.StatementLValue;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.values.LValue;
import dk.camelot64.kickc.model.values.ProcedureRef;
import dk.camelot64.kickc.model.values.ScopeRef;
import dk.camelot64.kickc.model.values.VariableRef;

import java.util.*;

/** Find all variables from an outer scope modified in an inner scope (ie. a procedure) */
public class Pass1ModifiedVarsAnalysis extends Pass1Base {

   public Pass1ModifiedVarsAnalysis(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      Map<ProcedureRef, Set<VariableRef>> modified = new LinkedHashMap<>();
      Collection<Procedure> allProcedures = getProgramScope().getAllProcedures(true);
      for(Procedure procedure : allProcedures) {
         Set<VariableRef> modifiedVars = getModifiedVars(procedure, new HashSet<>());
         modified.put(procedure.getRef(), modifiedVars);
      }
      getProgram().setProcedureModifiedVars(new ProcedureModifiedVars(modified));
      return false;
   }

   /**
    * Get all outside variables modified by a procedure (or any sub-procedure called by the procedure).
    *
    * @param procedure The procedure to examine
    * @return All variables declared outside the procedure modified inside the procedure.
    */
   private Set<VariableRef> getModifiedVars(Procedure procedure, Set<ProcedureRef> visited) {
      // Avoid recursion
      if(visited.contains(procedure.getRef()))
         return new LinkedHashSet<>();
      visited.add(procedure.getRef());

      Set<VariableRef> modified = new LinkedHashSet<>();
      ScopeRef procScope = procedure.getRef();
      List<Graph.Block> procBlocks = getProgram().getGraph().getScopeBlocks(procScope);
      for(var block : procBlocks) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementLValue) {
               LValue lValue = ((StatementLValue) statement).getlValue();
               if(lValue instanceof VariableRef) {
                  VariableRef var = (VariableRef) lValue;
                  if(!var.getScopeNames().equals(procScope.getFullName())) {
                     modified.add(var);
                  }
               }
               if(statement instanceof StatementCalling) {
                  ProcedureRef called = ((StatementCalling) statement).getProcedure();
                  Procedure calledProc = getProgramScope().getProcedure(called);
                  modified.addAll(getModifiedVars(calledProc, visited));
               }
            }
         }
      }
      return modified;
   }


}

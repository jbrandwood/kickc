package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.Graph;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementCalling;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.values.ProcedureRef;
import dk.camelot64.kickc.passes.utils.ProcedureUtils;

import java.util.Collection;
import java.util.LinkedHashSet;
import java.util.Set;

/** Eliminate uncalled methods */
public class Pass1EliminateUncalledProcedures extends Pass1Base {

   public Pass1EliminateUncalledProcedures(Program program) {
      super(program);
   }


   @Override
   public boolean step() {
      Set<ProcedureRef> calledProcedures = getAllCalledProcedures(getGraph());

      Set<ProcedureRef> unusedProcedures = new LinkedHashSet<>();
      Collection<Procedure> allProcedures = getProgram().getScope().getAllProcedures(true);
      for(Procedure procedure : allProcedures)
         if(!ProcedureUtils.isEntrypoint(procedure.getRef(), getProgram()))
            if(!calledProcedures.contains(procedure.getRef()))
               // The procedure is not used - mark for removal!
               unusedProcedures.add(procedure.getRef());

      for(ProcedureRef unusedProcedure : unusedProcedures) {
         removeProcedure(getProgram(), unusedProcedure);
      }

      return unusedProcedures.size() > 0;
   }

   /**
    * Get all called procedures in a control flow graph
    *
    * @return All called procedures
    */
   public static Set<ProcedureRef> getAllCalledProcedures(Graph graph) {
      Set<ProcedureRef> calledProcedures = new LinkedHashSet<>();
      for(var statement : graph.getAllStatements()) {
            if(statement instanceof StatementCalling call) {
               ProcedureRef procedureRef = call.getProcedure();
               calledProcedures.add(procedureRef);
            }
      }
      return calledProcedures;
   }

   /**
    * Removed a procedure from the program (the symbol in the symbol table and all blocks in the control flow graph)
    *
    * @param program The program
    * @param procedureRef The procedure to be removed
    */
   public static void removeProcedure(Program program, ProcedureRef procedureRef) {
      if(program.getLog().isVerbosePass1CreateSsa()) {
         program.getLog().append("Removing unused procedure " + procedureRef);
      }
      program.removeProcedure(procedureRef);
   }

}

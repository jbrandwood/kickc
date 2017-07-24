package dk.camelot64.kickc.icl;

/** Procedure declaration in SSA */
public class StatementProcedureEnd implements Statement {

   private ProcedureRef procedure;

   public StatementProcedureEnd(ProcedureRef procedure) {
      this.procedure = procedure;
   }

   public ProcedureRef getProcedure() {
      return procedure;
   }

   @Override
   public String toString() {
      return toString(null);
   }

   @Override
   public String toString(ProgramScope scope) {
      return "endproc // "+procedure.getFullName()+"()";
   }
}

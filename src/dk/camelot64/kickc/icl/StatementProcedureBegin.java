package dk.camelot64.kickc.icl;

/** Procedure declaration in SSA */
public class StatementProcedureBegin implements Statement {

   private Procedure procedure;

   public StatementProcedureBegin(Procedure procedure) {
      this.procedure = procedure;
   }

   public Procedure getProcedure() {
      return procedure;
   }

   @Override
   public String toString() {
      return "proc "+procedure.toString();
   }

}

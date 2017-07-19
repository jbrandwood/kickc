package dk.camelot64.kickc.icl;

/** Procedure declaration in SSA */
public class StatementProcedureEnd implements Statement {

   private Procedure procedure;

   public StatementProcedureEnd(Procedure procedure) {
      this.procedure = procedure;
   }

   public Procedure getProcedure() {
      return procedure;
   }

   @Override
   public String toString() {
      return getAsString();
   }

   @Override
   public String getAsTypedString(ProgramScope scope) {
      return getAsString();
   }

   @Override
   public String getAsString() {
      return "endproc // "+procedure.getFullName()+"()";   }
}

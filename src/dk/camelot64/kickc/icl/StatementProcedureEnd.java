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
      return "endproc // "+procedure.getLocalName()+"()";
   }

}

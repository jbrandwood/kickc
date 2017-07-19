package dk.camelot64.kickc.icl;

/** Procedure declaration in SSA */
public class StatementProcedureBegin implements Statement {

   private Procedure procedure;

   private Strategy strategy;

   public static enum Strategy {
      PASS_BY_REGISTER,
      INLINE
   }

   public StatementProcedureBegin(Procedure procedure) {
      this.procedure = procedure;
   }

   public Procedure getProcedure() {
      return procedure;
   }

   public Strategy getStrategy() {
      return strategy;
   }

   public void setStrategy(Strategy strategy) {
      this.strategy = strategy;
   }

   @Override
   public String toString() {
      return getAsString();
   }

   @Override
   public String getAsTypedString(ProgramScope scope) {
      return "proc " + procedure.getAsTypedString(scope);
   }

   @Override
   public String getAsString() {
      return "proc " + procedure.getAsString();
   }
}

package dk.camelot64.kickc.icl;

/** Procedure declaration in SSA */
public class StatementProcedureBegin extends StatementBase {

   private ProcedureRef procedure;

   private Strategy strategy;

   public static enum Strategy {
      PASS_BY_REGISTER,
      INLINE
   }

   public StatementProcedureBegin(ProcedureRef procedure) {
      super(null);
      this.procedure = procedure;
   }

   public ProcedureRef getProcedure() {
      return procedure;
   }

   public Strategy getStrategy() {
      return strategy;
   }

   public void setStrategy(Strategy strategy) {
      this.strategy = strategy;
   }

   @Override
   public String toString(ProgramScope scope) {
      return super.idxString() + "proc " + procedure.toString(scope) + super.aliveString(scope);
   }

}

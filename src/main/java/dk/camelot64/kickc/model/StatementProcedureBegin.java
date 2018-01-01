package dk.camelot64.kickc.model;

/** Procedure declaration in SSA */
public class StatementProcedureBegin extends StatementBase {

   private ProcedureRef procedure;

   private Strategy strategy;

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
   public String toString(Program program, boolean aliveInfo) {
      return super.idxString() + "proc " + procedure.toString(program) + (aliveInfo ? super.aliveString(program) : "");
   }

   public static enum Strategy {
      PASS_BY_REGISTER,
      INLINE
   }

}

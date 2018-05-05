package dk.camelot64.kickc.model.statements;

import dk.camelot64.kickc.model.values.ProcedureRef;
import dk.camelot64.kickc.model.Program;

/** Procedure declaration in SSA */
public class StatementProcedureBegin extends StatementBase {

   private ProcedureRef procedure;

   private Strategy strategy;

   public StatementProcedureBegin(ProcedureRef procedure,StatementSource source) {
      super(null, source);
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

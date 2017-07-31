package dk.camelot64.kickc.icl;

/**
 * Procedure declaration in SSA
 */
public class StatementProcedureEnd extends StatementBase {

   private ProcedureRef procedure;

   public StatementProcedureEnd(ProcedureRef procedure) {
      super(null);
      this.procedure = procedure;
   }

   public ProcedureRef getProcedure() {
      return procedure;
   }

   @Override
   public String toString(Program program) {
      return super.idxString() + "endproc // " + procedure.getFullName() + "()"+super.aliveString(program);
   }
}

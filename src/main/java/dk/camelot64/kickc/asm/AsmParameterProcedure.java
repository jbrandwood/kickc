package dk.camelot64.kickc.asm;

import dk.camelot64.kickc.model.values.ProcedureRef;

public class AsmParameterProcedure implements AsmParameter {

   private ProcedureRef procedure;

   public AsmParameterProcedure(ProcedureRef procedure) {
      this.procedure= procedure;
   }

   @Override
   public String getAsm() {
      return procedure.getFullName();
   }

}

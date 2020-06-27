package dk.camelot64.kickc.passes.utils;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.values.ProcedureRef;
import dk.camelot64.kickc.passes.Pass2ConstantIdentification;

public class ProcedureUtils {

   /**
    * Determines if a procedure is an entry point.
    * Entry points are:
    * - the starting procedure (typically main())
    * - interrupts
    * - any procedure where address-of is used in the code.
    * TODO: Should all stack call procedures be included (probably no!)
    * TODO: Also look at kickasm/asm uses! (Maybe also look at some directive like "export" )
    *
    * @param procedure The procedure to examine
    * @param program The program
    * @return true if the procedure is an entry point
    */
   public static boolean isEntrypoint(ProcedureRef procedureRef, Program program) {
      if(procedureRef.equals(program.getStartProcedure()))
         return true;
      final Procedure procedure = program.getScope().getProcedure(procedureRef);
      if(procedure.getInterruptType()!=null)
         return true;
      if(Pass2ConstantIdentification.isAddressOfUsed(procedureRef, program))
         return true;
      return false;
   }

}

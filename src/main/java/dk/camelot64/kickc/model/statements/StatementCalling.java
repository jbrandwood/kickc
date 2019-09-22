package dk.camelot64.kickc.model.statements;

import dk.camelot64.kickc.model.values.ProcedureRef;

/**
 * Statement performing a call to a procedure
 */
public interface StatementCalling extends Statement {

   /**
    * Get the procedure being called
    * @return The procedure reference
    */
   ProcedureRef getProcedure();


}

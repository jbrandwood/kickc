package dk.camelot64.kickc.model.statements;

import dk.camelot64.kickc.model.values.LValue;

/**
 * Single Static Assignment Form Statement with an LValuie - that is a statement assigning a value to a variable.
 */
public interface StatementLValue extends Statement {

   LValue getlValue();

   void setlValue(LValue lValue);

}

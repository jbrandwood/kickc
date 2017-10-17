package dk.camelot64.kickc.model;

/**
 * Single Static Assignment Form Statement with an LValuie - that is a statement assigning a value to a variable.
 */
public interface StatementLValue extends Statement {

   LValue getlValue();

   void setlValue(LValue lValue);

}

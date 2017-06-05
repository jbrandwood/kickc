package dk.camelot64.kickc.icl;

/**
 * Single Static Assignment Form Statement with an LValuie - that is a statement assigning a value to a variable.
 */
public interface StatementLValue extends  Statement {

   LValue getLValue();

   void setLValue(LValue lValue);

}

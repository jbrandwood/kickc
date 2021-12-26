package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.Program;


/** Any value (variable, constant, label) */
public interface Value {
   String toString(Program program);
}

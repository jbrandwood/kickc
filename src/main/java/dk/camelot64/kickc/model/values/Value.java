package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.Program;

import java.io.Serializable;

/** Any value (variable, constant, label) */
public interface Value extends Serializable {
   String toString(Program program);
}

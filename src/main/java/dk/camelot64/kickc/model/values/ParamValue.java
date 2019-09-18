package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.Program;

/** The value passed into a function for a specific parameter.
 * Used for procedures that does not use {@link dk.camelot64.kickc.model.symbols.Procedure.CallingConvension#PHI_CALL}
 * */
public class ParamValue implements RValue {

   /** The (unversioned) parameter variable. */
   VariableRef parameter;

   public ParamValue(VariableRef parameter) {
      this.parameter = parameter;
   }

   public VariableRef getParameter() {
      return parameter;
   }


   public void setParameter(VariableRef parameter) {
      this.parameter = parameter;
   }

   @Override
   public String toString(Program program) {
      return "param("+parameter.toString(program)+")";
   }

}

package dk.camelot64.kickc.model;

/**
 * LValue containing an intermediate variable during parsing. Must be resolved to a proper LValue in Pass 1 - or result in failure
 */
public class LvalueIntermediate implements LValue {

   private VariableRef variable;

   public LvalueIntermediate(VariableRef variable) {
      this.variable = variable;
   }

   public VariableRef getVariable() {
      return variable;
   }

   @Override
   public String toString(Program program) {
      return "lval" + "(" + variable.toString(program) + ")";
   }

   public void setVariable(VariableRef variable) {
      this.variable = variable;
   }

}

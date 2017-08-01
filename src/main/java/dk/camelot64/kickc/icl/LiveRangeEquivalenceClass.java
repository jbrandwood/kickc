package dk.camelot64.kickc.icl;

import java.util.ArrayList;
import java.util.List;

/**
 * A live range equivalence class contains a set of variables with non-overlapping live ranges.
 **/
public class LiveRangeEquivalenceClass {

   /** The containing program. */
   private Program program;

   /** The variables of the equivalence class. */
   private List<VariableRef> variables;

   /** The combined live range of the variables. */
   private LiveRange liveRange;

   /** A register allocated to hold all variables of the equivalence class. (null if no register is currently allocated) */
   private RegisterAllocation.Register register;

   public LiveRangeEquivalenceClass(Program program) {
      this.program = program;
      this.variables = new ArrayList<>();
      this.liveRange = new LiveRange();
      this.register = null;
   }

   public RegisterAllocation.Register getRegister() {
      return register;
   }

   public void setRegister(RegisterAllocation.Register register) {
      this.register = register;
   }

   /**
    * Add a variable to the equivalence class
    *
    * @param variable The variable to add
    */
   public void addVariable(VariableRef variable) {
      if(variables.contains(variable)) {
         return;
      }
      LiveRangeVariables liveRanges = program.getLiveRangeVariables();
      LiveRange varLiveRange = liveRanges.getLiveRange(variable);
      if (liveRange.overlaps(varLiveRange)) {
         throw new RuntimeException("Compilation error! Variable live range overlaps live range equivalence class live range. " + variable);
      }
      liveRange.add(varLiveRange);
      variables.add(variable);
   }

   /**
    * Determines if the phi equivalence class contains a variable
    *
    * @param variable The variable to look for
    * @return true if the equivalence class contains the variable
    */
   public boolean contains(VariableRef variable) {
      return variables.contains(variable);
   }

   public LiveRange getLiveRange() {
      return liveRange;
   }

   public void addAll(LiveRangeEquivalenceClass other) {
      variables.addAll(other.variables);
      liveRange.add(other.liveRange);
   }

   @Override
   public boolean equals(Object o) {
      if (this == o) return true;
      if (o == null || getClass() != o.getClass()) return false;

      LiveRangeEquivalenceClass that = (LiveRangeEquivalenceClass) o;

      return variables.equals(that.variables);
   }

   @Override
   public int hashCode() {
      return variables.hashCode();
   }

   @Override
   public String toString() {
      return toString(true);
   }

   public String toString(boolean includeRegister) {
      StringBuilder s = new StringBuilder();
      if(includeRegister && register!=null) {
         s.append(register.toString()).append(" ");
      }
      s.append("[ ");
      for (VariableRef variable : variables) {
         s.append(variable.toString());
         s.append(" ");
      }
      s.append("]");

      return s.toString();
   }

   public List<VariableRef> getVariables() {
      return variables;
   }
}

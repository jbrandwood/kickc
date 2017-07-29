package dk.camelot64.kickc.icl;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;

/** Live ranges for all variables.
 * Created by  * Created by {@link dk.camelot64.kickc.passes.Pass3CallGraphAnalysis}
 */
public class LiveRangeVariables {

   private LinkedHashMap<VariableRef, LiveRange> liveRanges;

   public LiveRangeVariables() {
      this.liveRanges = new LinkedHashMap<>();
   }

   /** Add a single statement to the live range of a variable.
    *
    * @param variable The variable
    * @param statement The statement to add
    * @return true if a live range was modified by the addition
    */
   public boolean addAlive(VariableRef variable, Statement statement) {
      LiveRange liveRange = liveRanges.get(variable);
      if (liveRange == null) {
         liveRange = new LiveRange();
         liveRanges.put(variable, liveRange);
      }
      return liveRange.add(statement);
   }

   /**
    * Add an empty alive range for a variable
    * @param variable The variable
    */
   public void addEmptyAlive(VariableRef variable) {
      LiveRange liveRange = liveRanges.get(variable);
      if (liveRange == null) {
         liveRange = new LiveRange();
         liveRanges.put(variable, liveRange);
      }
   }

   /**
    * Get all variables alive at a specific statement
    * @param statement The statement
    * @return List of all live variables.
    */
   public List<VariableRef> getAlive(Statement statement) {
      ArrayList<VariableRef> aliveVars = new ArrayList<>();
      for (VariableRef variable : liveRanges.keySet()) {
         LiveRange liveRange = liveRanges.get(variable);
         if(liveRange.contains(statement)) {
            aliveVars.add(variable);
         }
      }
      return aliveVars;
   }

   /**
    * Get the alive range of a variable
    * @param variable The variable reference
    * @return The alive range for the variable
    */
   public LiveRange getLiveRange(VariableRef variable) {
      return liveRanges.get(variable);
   }

}

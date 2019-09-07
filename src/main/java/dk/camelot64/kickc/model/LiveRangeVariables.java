package dk.camelot64.kickc.model;

import dk.camelot64.kickc.model.values.VariableRef;
import dk.camelot64.kickc.passes.calcs.PassNCalcLiveRangeVariables;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Live ranges for all variables.
 * Created by {@link PassNCalcLiveRangeVariables}
 */
public class LiveRangeVariables {

   private LinkedHashMap<VariableRef, LiveRange> liveRanges;

   private Program program;

   public LiveRangeVariables(Program program) {
      this.liveRanges = new LinkedHashMap<>();
      this.program = program;
   }

   /**
    * Add a single statement to the live range of a variable.
    *
    * @param variable The variable
    * @param statementIdx Index of the statement to add
    * @return true if a live range was modified by the addition
    */
   public boolean addAlive(VariableRef variable, int statementIdx) {
      LiveRange liveRange = liveRanges.get(variable);
      if(liveRange == null) {
         liveRange = new LiveRange();
         liveRanges.put(variable, liveRange);
      }
      return liveRange.add(statementIdx);
   }

   /**
    * Add an empty alive range for a variable
    *
    * @param variable The variable
    */
   public void addEmptyAlive(VariableRef variable) {
      LiveRange liveRange = liveRanges.get(variable);
      if(liveRange == null) {
         liveRange = new LiveRange();
         liveRanges.put(variable, liveRange);
      }
   }

   /**
    * Get all variables alive at a specific statement
    *
    * @param statementIdx Index of the statement
    * @return List of all live variables.
    */
   public List<VariableRef> getAlive(int statementIdx) {
      ArrayList<VariableRef> aliveVars = new ArrayList<>();
      for(Map.Entry<VariableRef,LiveRange> entry : liveRanges.entrySet()) {
         if(entry.getValue().contains(statementIdx)) {
            aliveVars.add(entry.getKey());
         }
      }
      return aliveVars;
   }

   /**
    * Get the alive range of a variable
    *
    * @param variable The variable reference
    * @return The alive range for the variable
    */
   public LiveRange getLiveRange(VariableRef variable) {
      return liveRanges.get(variable);
   }

   /**
    * Get the number of variable live ranges
    * @return The number of variable live ranges
    */
   public int size() {
      return liveRanges.size();
   }

   /**
    *  Get variable live ranges by statement index. Usable for quick access if you plan to iterate many statements.
    * @return variable live ranges by statement index
    */
   public LiveRangeVariablesByStatement getLiveRangeVariablesByStatement() {
      LiveRangeVariablesByStatement liveRangeVariablesByStatement = new LiveRangeVariablesByStatement();
      for(Map.Entry<VariableRef, LiveRange> variableRefLiveRangeEntry : liveRanges.entrySet()) {
         VariableRef variableRef = variableRefLiveRangeEntry.getKey();
         LiveRange liveRange = variableRefLiveRangeEntry.getValue();
         for(LiveRange.LiveInterval liveInterval : liveRange.getIntervals()) {
            for(int stmtIdx = liveInterval.getFirstStatementIdx(); stmtIdx<= liveInterval.getLastStatementIdx(); stmtIdx++) {
               liveRangeVariablesByStatement.addAlive(stmtIdx, variableRef);
            }
         }
      }
      return liveRangeVariablesByStatement;
   }

   /** Variable live ranges by statement index. Usable for quick access if you plan to iterate many statements. */
   public static class LiveRangeVariablesByStatement {

      private ArrayList<List<VariableRef>> aliveByStatementIdx;

      public LiveRangeVariablesByStatement() {
         this.aliveByStatementIdx = new ArrayList<>();
      }

      public void addAlive(int statementIdx, VariableRef variableRef) {
         while(statementIdx>=aliveByStatementIdx.size()) {
            aliveByStatementIdx.add(new ArrayList<>());
         }
         List<VariableRef> variableRefs = aliveByStatementIdx.get(statementIdx);
         variableRefs.add(variableRef);
      }


      public List<VariableRef> getAlive(int statementIdx) {
         if(statementIdx>=aliveByStatementIdx.size())
            return new ArrayList<>();
         return aliveByStatementIdx.get(statementIdx);
      }

   }


}

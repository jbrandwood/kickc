package dk.camelot64.kickc.model;

import java.util.Collection;
import java.util.List;

/** Statement base class implementing shared properties and logic  */
public abstract class StatementBase implements Statement {

   private Integer index;

   public StatementBase(Integer index) {
      this.index = index;
   }

   @Override
   public Integer getIndex() {
      return index;
   }

   @Override
   public void setIndex(Integer index) {
      this.index = index;
   }

   @Override
   public boolean equals(Object o) {
      if (this == o) return true;
      if (o == null || getClass() != o.getClass()) return false;
      StatementBase that = (StatementBase) o;
      return index != null ? index.equals(that.index) : that.index == null;
   }

   @Override
   public int hashCode() {
      return index != null ? index.hashCode() : 0;
   }

   public String idxString() {
      return index==null?"":("["+index+"] ");
   }

   @Override
   public String toString() {
      return toString(null);
   }

   public String aliveString(Program program) {
      if(program==null || program.getLiveRangeVariables()==null) {
         return "";
      }
      LiveRangeVariables liveRanges = program.getLiveRangeVariables();
      StringBuilder alive = new StringBuilder();
      alive.append(getAliveString(liveRanges.getAlive(this)));
      LiveRangeVariablesEffective liveRangeVariablesEffective = program.getLiveRangeVariablesEffective();
      if(liveRangeVariablesEffective!=null) {
         LiveRangeVariablesEffective.AliveCombinations aliveCombinations = liveRangeVariablesEffective.getAliveCombinations(this);
         alive.append(" ( ");
         for (LiveRangeVariablesEffective.AliveCombination aliveCombination : aliveCombinations.getCombinations()) {
            alive.append(getAliveString(aliveCombination.getAlive()));
            alive.append(" ");
         }
         alive.append(")");
      }
      return alive.toString();
   }

   private String getAliveString(Collection<VariableRef> alive) {
      StringBuilder str = new StringBuilder();
      str.append(" [ ");
      for (VariableRef variableRef : alive) {
         str.append(variableRef.getFullName());
         str.append(" ");
      }
      str.append("]");
      return str.toString();
   }

}

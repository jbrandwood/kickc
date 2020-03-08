package dk.camelot64.kickc.model.statements;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.values.VariableRef;

import java.util.Collection;
import java.util.List;
import java.util.Objects;

/** Statement base class implementing shared properties and logic */
public abstract class StatementBase implements Statement {

   private StatementSource source;

   private Integer index;

   /** Comments preceding the statement in the source code. */
   private List<Comment> comments;

   public StatementBase(StatementSource source, List<Comment> comments) {
      this.index = null;
      this.source = source;
      this.comments = comments;
   }

   @Override
   public StatementSource getSource() {
      return source;
   }

   @Override
   public void setSource(StatementSource source) {
      this.source = source;
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
   public List<Comment> getComments() {
      return comments;
   }

   @Override
   public void setComments(List<Comment> comments) {
      this.comments = comments;
   }

   @Override
   public boolean equals(Object o) {
      if(this == o) return true;
      if(o == null || getClass() != o.getClass()) return false;
      StatementBase that = (StatementBase) o;
      return Objects.equals(source, that.source) &&
            Objects.equals(index, that.index) &&
            Objects.equals(comments, that.comments);
   }

   @Override
   public int hashCode() {
      return Objects.hash(source, index, comments);
   }

   public String idxString() {
      return index == null ? "" : ("[" + index + "] ");
   }

   @Override
   public String toString() {
      return toString(null, false);
   }

   public String aliveString(Program program) {
      if(program == null || !program.hasLiveRangeVariables()) {
         return "";
      }
      LiveRangeVariables liveRanges = program.getLiveRangeVariables();
      StringBuilder alive = new StringBuilder();
      alive.append(getAliveString(liveRanges.getAlive(index)));
      if(program.hasLiveRangeVariablesEffective()) {
         LiveRangeVariablesEffective liveRangeVariablesEffective = program.getLiveRangeVariablesEffective();
         LiveRangeVariablesEffective.AliveCombinations aliveCombinations = liveRangeVariablesEffective.getAliveCombinations(this);
         alive.append(" ( ");
         for(LiveRangeVariablesEffective.AliveCombination aliveCombination : aliveCombinations.getAll()) {
            alive.append(aliveCombination.toString());
            alive.append(" ");
         }
         alive.append(")");
      }
      return alive.toString();
   }

   private String getAliveString(Collection<VariableRef> alive) {
      StringBuilder str = new StringBuilder();
      str.append(" [ ");
      for(VariableRef variableRef : alive) {
         str.append(variableRef.getFullName());
         str.append(" ");
      }
      str.append("]");
      return str.toString();
   }


}

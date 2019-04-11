package dk.camelot64.kickc.model.statements;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.values.VariableRef;

import java.util.Collection;
import java.util.List;

/** Statement base class implementing shared properties and logic */
public abstract class StatementBase implements Statement {

   private StatementSource source;

   private Integer index;

   /** Comments preceding the statement in the source code. */
   private List<Comment> comments;

   public StatementBase(Integer index, StatementSource source, List<Comment> comments) {
      this.index = index;
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
      return index != null ? index.equals(that.index) : that.index == null;
   }

   @Override
   public int hashCode() {
      return index != null ? index.hashCode() : 0;
   }

   public String idxString() {
      return index == null ? "" : ("[" + index + "] ");
   }

   @Override
   public String toString() {
      return toString(null, false);
   }

   public String aliveString(Program program) {
      if(program == null || program.getLiveRangeVariables() == null) {
         return "";
      }
      LiveRangeVariables liveRanges = program.getLiveRangeVariables();
      StringBuilder alive = new StringBuilder();
      alive.append(getAliveString(liveRanges.getAlive(index)));
      LiveRangeVariablesEffective liveRangeVariablesEffective = program.getLiveRangeVariablesEffective();
      if(liveRangeVariablesEffective != null) {
         LiveRangeVariablesEffective.AliveCombinations aliveCombinations = liveRangeVariablesEffective.getAliveCombinations(this);
         alive.append(" ( ");
         for(LiveRangeVariablesEffective.CallPath callPath : aliveCombinations.getCallPaths().getCallPaths()) {
            alive.append(getCallPathString(callPath.getPath()));
            alive.append(getAliveString(aliveCombinations.getEffectiveAliveAtStmt(callPath)));
            alive.append(" ");
         }
         alive.append(")");
      }
      return alive.toString();
   }

   private String getCallPathString(List<CallGraph.CallBlock.Call> path) {
      StringBuilder out = new StringBuilder();
      boolean first = true;
      for(CallGraph.CallBlock.Call call : path) {
         if(!first) {
            out.append("::");
         }
         first = false;
         out.append(call.toString());
      }
      return out.toString();
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

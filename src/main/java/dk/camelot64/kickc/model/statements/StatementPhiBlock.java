package dk.camelot64.kickc.model.statements;

import dk.camelot64.kickc.model.Comment;
import dk.camelot64.kickc.model.values.LabelRef;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.values.RValue;
import dk.camelot64.kickc.model.values.VariableRef;
import org.antlr.v4.runtime.RuleContext;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * The Phi Block initializing the necessary SSA-variables of a predecessor.
 * The phi predecessor initializes a number of variables with different values depending on which predecessor control flow enters from.
 */
public class StatementPhiBlock extends StatementBase {

   /**
    * Maps each phi-varible of the predecessor to a map from a predecessor predecessor to the rvalue of the variable.
    */
   private List<PhiVariable> phiVariables;

   public StatementPhiBlock(List<Comment> comments) {
      super(null, new StatementSource(RuleContext.EMPTY), comments);
      this.phiVariables = new ArrayList<>();
   }

   /**
    * Get the variables defined by the phi predecessor.
    *
    * @return The variables defined
    */
   public List<VariableRef> getVariables() {
      ArrayList<VariableRef> vars = new ArrayList<>();
      for(PhiVariable phiVariable : phiVariables) {
         vars.add(phiVariable.getVariable());
      }
      return vars;

   }

   public PhiVariable addPhiVariable(VariableRef variable) {
      PhiVariable phiVariable = new PhiVariable(variable);
      this.phiVariables.add(phiVariable);
      return phiVariable;
   }

   public List<PhiVariable> getPhiVariables() {
      return phiVariables;
   }

   public RValue getrValue(LabelRef predecessor, VariableRef variable) {
      return getPhiVariable(variable).getrValue(predecessor);
   }

   public PhiVariable getPhiVariable(VariableRef variable) {
      for(PhiVariable phiVariable : phiVariables) {
         if(phiVariable.getVariable().equals(variable)) {
            return phiVariable;
         }
      }
      return null;
   }

   @Override
   public String toString(Program program, boolean aliveInfo) {
      StringBuilder s = new StringBuilder();
      List<PhiVariable> variables = new ArrayList<>(phiVariables);
      Collections.reverse(variables);
      if(phiVariables.size() == 0) {
         s.append(super.idxString());
         s.append("phi()");
         if(aliveInfo) {
            s.append(super.aliveString(program));
         }
         s.append("\n  ");
      }
      for(PhiVariable phiVariable : variables) {
         s.append(super.idxString());
         s.append(phiVariable.getVariable().toString(program));
         s.append(" ← phi(");
         for(PhiRValue phiRValue : phiVariable.getValues()) {
            s.append(" ");
            s.append(phiRValue.getPredecessor().toString(null));
            s.append("/");
            RValue rValue = phiRValue.getrValue();
            s.append(rValue == null ? "null" : rValue.toString(program));
         }
         s.append(" )");
         if(aliveInfo) {
            s.append(super.aliveString(program));
         }
         s.append("\n  ");
      }
      if(s.length() > 0) {
         return s.toString().substring(0, s.length() - 3);
      } else {
         return s.toString();
      }
   }

   @Override
   public boolean equals(Object o) {
      if(this == o) return true;
      if(o == null || getClass() != o.getClass()) return false;
      if(!super.equals(o)) return false;

      StatementPhiBlock phiBlock = (StatementPhiBlock) o;

      return phiVariables.equals(phiBlock.phiVariables);
   }

   @Override
   public int hashCode() {
      int result = super.hashCode();
      result = 31 * result + phiVariables.hashCode();
      return result;
   }

   /**
    * A variable being defined as part of a phi predecessor.
    */
   public static class PhiVariable {

      /**
       * The variable being defined.
       */
      private VariableRef variable;

      /**
       * The Rvalues assigned to the variable when entering from different blocks.
       */
      private List<PhiRValue> values;

      public PhiVariable(VariableRef variable) {
         this.variable = variable;
         this.values = new ArrayList<>();
      }

      public PhiVariable(
            VariableRef variable,
            List<PhiRValue> values) {
         this.variable = variable;
         this.values = values;
      }

      public PhiVariable() {
      }

      public VariableRef getVariable() {
         return variable;
      }

      public void setVariable(VariableRef variable) {
         this.variable = variable;
      }

      public List<PhiRValue> getValues() {
         return values;
      }

      public RValue getrValue(LabelRef predecessor) {
         for(PhiRValue phiRValue : values) {
            if(phiRValue.getPredecessor().equals(predecessor)) {
               return phiRValue.getrValue();
            }
         }
         return null;
      }

      /**
       * Get the phi rvalue of the phi variable for a specific predecessor block.
       * Creates the phi-rValue if it does not already exist.
       *
       * @param predecessor The predecessor block
       * @return The rValue assigned to the phi variable when entering from the passed block.
       */
      PhiRValue getPhirValue(LabelRef predecessor) {
         for(PhiRValue phiRValue : values) {
            if(phiRValue.getPredecessor().equals(predecessor)) {
               return phiRValue;
            }
         }
         // Not found - create and return
         PhiRValue phirValue = new PhiRValue(predecessor);
         this.values.add(phirValue);
         return phirValue;
      }

      public void setrValue(LabelRef predecessor, RValue rValue) {
         getPhirValue(predecessor).setrValue(rValue);
      }

      public boolean isEmpty() {
         return this.values.isEmpty();
      }

      @Override
      public boolean equals(Object o) {
         if(this == o) return true;
         if(o == null || getClass() != o.getClass()) return false;

         PhiVariable that = (PhiVariable) o;

         if(!variable.equals(that.variable)) return false;
         return values.equals(that.values);
      }

      @Override
      public int hashCode() {
         int result = variable.hashCode();
         result = 31 * result + values.hashCode();
         return result;
      }
   }

   /**
    * The value assigned to a phi variable when entering the predecessor from a specific predecessor block.
    */
   public static class PhiRValue {

      /**
       * The predecessor predecessor
       */
      private LabelRef predecessor;

      /**
       * The value to assign to the phi-variable when entering from the predecessor block
       */
      private RValue rValue;

      public PhiRValue(LabelRef predecessor) {
         this.predecessor = predecessor;
      }

      public PhiRValue(
            LabelRef predecessor,
            RValue rValue) {
         this.predecessor = predecessor;
         this.rValue = rValue;
      }

      public LabelRef getPredecessor() {
         return predecessor;
      }

      public void setPredecessor(LabelRef predecessor) {
         this.predecessor = predecessor;
      }

      public RValue getrValue() {
         return rValue;
      }

      public void setrValue(RValue rValue) {
         this.rValue = rValue;
      }

      @Override
      public boolean equals(Object o) {
         if(this == o) return true;
         if(o == null || getClass() != o.getClass()) return false;

         PhiRValue phiRValue = (PhiRValue) o;

         if(!predecessor.equals(phiRValue.predecessor)) return false;
         return rValue != null ? rValue.equals(phiRValue.rValue) : phiRValue.rValue == null;
      }

      @Override
      public int hashCode() {
         int result = predecessor.hashCode();
         result = 31 * result + (rValue != null ? rValue.hashCode() : 0);
         return result;
      }
   }


}

package dk.camelot64.kickc.icl;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.*;

/**
 * The Phi Block initializing the necessary SSA-variables of a predecessor.
 * The phi predecessor initializes a number of variables with different values depending on which predecessor control flow enters from.
 */
public class StatementPhiBlock implements Statement {

   /**
    * Maps each phi-varible of the predecessor to a map from a predecessor predecessor to the rvalue of the variable.
    */
   private List<PhiVariable> phiVariables;

   @JsonCreator
   public StatementPhiBlock(
         @JsonProperty("phiVariables") List<PhiVariable> phiVariables) {
      this.phiVariables = phiVariables;
   }

   public StatementPhiBlock() {
      this.phiVariables = new ArrayList<>();
   }

   /**
    * Get the ordered predecessor blocks where control can enter the predecessor.
    *
    * @return the predecessor blocks
    */
   //public List<LabelRef> getPredecessors() {
   //   return predecessors;
   //}


   /**
    * Get the variables defined by the phi predecessor.
    *
    * @return The variables defined
    */
   @JsonIgnore
   public List<VariableRef> getVariables() {
      ArrayList<VariableRef> vars = new ArrayList<>();
      for (PhiVariable phiVariable : phiVariables) {
         vars.add(phiVariable.getVariable());
      }
      return vars;

   }

   public PhiVariable getPhiVariable(VariableRef variable) {
      for (PhiVariable phiVariable : phiVariables) {
         if (phiVariable.getVariable().equals(variable)) {
            return phiVariable;
         }
      }
      return null;
   }

   public RValue getrValue(LabelRef predecessor, VariableRef variable) {
      return getPhiVariable(variable).getrValue(predecessor);
   }

   public PhiRValue getPhirValue(LabelRef predecessor, VariableRef variable) {
      return getPhiVariable(variable).getPhirValue(predecessor);
   }

   @Override
   public String getAsTypedString(ProgramScope scope) {
      StringBuilder s = new StringBuilder();
      List<PhiVariable> variables = new ArrayList<>(phiVariables);
      Collections.reverse(variables);
      for (PhiVariable phiVariable : variables) {
         s.append(phiVariable.getVariable().getAsTypedString(scope));
         s.append(" ← phi(");
         for (PhiRValue phiRValue : phiVariable.getValues()) {
            s.append(" ");
            s.append(phiRValue.getPredecessor().getAsString());
            s.append("/");
            RValue rValue = phiRValue.getrValue();
            s.append(rValue==null?"null":rValue.getAsTypedString(scope));
         }
         s.append(" )\n  ");
      }
      if(s.length()>0) {
         return s.toString().substring(0, s.length() - 3);
      } else {
         return s.toString();
      }
   }

   @Override
   public String getAsString() {
      StringBuilder s = new StringBuilder();
      List<PhiVariable> variables = new ArrayList<>(phiVariables);
      Collections.reverse(variables);
      for (PhiVariable phiVariable : variables) {
         s.append(phiVariable.getVariable().getAsString());
         s.append(" ← phi(");
         for (PhiRValue phiRValue : phiVariable.getValues()) {
            s.append(" ");
            s.append(phiRValue.getPredecessor().getAsString());
            s.append("/");
            RValue rValue = phiRValue.getrValue();
            s.append(rValue==null?"null":rValue.getAsString());
         }
         s.append(" )\n  ");
      }
      if(s.length()>0) {
         return s.toString().substring(0, s.length() - 3);
      } else {
         return s.toString();
      }
   }

   public PhiVariable addPhiVariable(VariableRef variable) {
      PhiVariable phiVariable = new PhiVariable(variable);
      this.phiVariables.add(phiVariable);
      return phiVariable;
   }

   public List<PhiVariable> getPhiVariables() {
      return phiVariables;
   }


   @Override
   public boolean equals(Object o) {
      if (this == o) return true;
      if (o == null || getClass() != o.getClass()) return false;

      StatementPhiBlock phiBlock = (StatementPhiBlock) o;

      return phiVariables != null ? phiVariables.equals(phiBlock.phiVariables) : phiBlock.phiVariables == null;
   }

   @Override
   public int hashCode() {
      return phiVariables != null ? phiVariables.hashCode() : 0;
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

      @JsonCreator
      public PhiVariable(
            @JsonProperty("variable") VariableRef variable,
            @JsonProperty("values") List<PhiRValue> values) {
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

      public void setValues(List<PhiRValue> values) {
         this.values = values;
      }

      public List<PhiRValue> getValues() {
         return values;
      }


      public RValue getrValue(LabelRef predecessor) {
         for (PhiRValue phiRValue : values) {
            if (phiRValue.getPredecessor().equals(predecessor)) {
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
      public PhiRValue getPhirValue(LabelRef predecessor) {
         for (PhiRValue phiRValue : values) {
            if (phiRValue.getPredecessor().equals(predecessor)) {
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

      @JsonIgnore
      public boolean isEmpty() {
         return this.values.isEmpty();
      }

      @Override
      public boolean equals(Object o) {
         if (this == o) return true;
         if (o == null || getClass() != o.getClass()) return false;

         PhiVariable that = (PhiVariable) o;

         if (!variable.equals(that.variable)) return false;
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

      @JsonCreator
      public PhiRValue(
            @JsonProperty("predecessor") LabelRef predecessor,
            @JsonProperty("rValue") RValue rValue) {
         this.predecessor = predecessor;
         this.rValue = rValue;
      }

      public LabelRef getPredecessor() {
         return predecessor;
      }

      public RValue getrValue() {
         return rValue;
      }

      public void setrValue(RValue rValue) {
         this.rValue = rValue;
      }

      public void setPredecessor(LabelRef predecessor) {
         this.predecessor = predecessor;
      }

      @Override
      public boolean equals(Object o) {
         if (this == o) return true;
         if (o == null || getClass() != o.getClass()) return false;

         PhiRValue phiRValue = (PhiRValue) o;

         if (!predecessor.equals(phiRValue.predecessor)) return false;
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

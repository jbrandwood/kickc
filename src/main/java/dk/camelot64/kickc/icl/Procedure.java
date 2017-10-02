package dk.camelot64.kickc.icl;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/** Symbol describing a procedure/function */
public class Procedure extends Scope {

   private final SymbolType returnType;
   private List<String> parameterNames;

   public Procedure(String name, SymbolType returnType, Scope parentScope) {
      super(name, parentScope);
      this.returnType = returnType;
   }

   @JsonCreator
   private Procedure(
         @JsonProperty("name") String name,
         @JsonProperty("returntype") SymbolType returnType,
         @JsonProperty("parameterNames") List<String> parameterNames,
         @JsonProperty("symbols") HashMap<String, Symbol> symbols,
         @JsonProperty("intermediateVarCount") int intermediateVarCount,
         @JsonProperty("intermediateLabelCount") int intermediateLabelCount) {
      super(name, symbols, intermediateVarCount, intermediateLabelCount);
      this.returnType = returnType;
      this.parameterNames = parameterNames;
   }

   public List<String> getParameterNames() {
      return parameterNames;
   }

   public void setParameterNames(List<String> parameterNames) {
      this.parameterNames = parameterNames;
   }

   public void setParameters(List<Variable> parameters) {
      this.parameterNames = new ArrayList<>();
      for (Variable parameter : parameters) {
         add(parameter);
         parameterNames.add(parameter.getLocalName());
      }
   }

   @JsonIgnore
   public Label getLabel() {
      return new Label(getFullName(), getScope(), false);
   }

   public SymbolType getReturnType() {
      return returnType;
   }

   @JsonIgnore
   public List<Variable> getParameters() {
      ArrayList<Variable> parameters = new ArrayList<>();
      for (String name : parameterNames) {
         parameters.add(this.getVariable(name));
      }
      return parameters;
   }

   @Override
   public String getFullName() {
      return super.getFullName();
   }

   public String toString(Program program, Class symbolClass) {
      StringBuilder res = new StringBuilder();
      res.append(toString(program));
      res.append("\n");
      res.append(super.toString(program, symbolClass));
      return res.toString();
   }

   @Override
   public SymbolType getType() {
      return new SymbolTypeProcedure(returnType);
   }

   @Override
   public String toString() {
      return toString(null);
   }

   @Override
   public String toString(Program program) {
      StringBuilder res = new StringBuilder();
      res.append("("+getType().getTypeName() + ") ");
      res.append(getFullName());
      res.append("(");
      boolean first = true;
      if(parameterNames !=null) {
         for (Variable parameter : getParameters()) {
            if (!first) res.append(" , ");
            first = false;
            res.append(parameter.toString(program));
         }
      }
      res.append(")");
      return res.toString();
   }

   @JsonIgnore
   public ProcedureRef getRef() {
      return new ProcedureRef(this.getFullName());
   }

   @Override
   public boolean equals(Object o) {
      if (this == o) return true;
      if (o == null || getClass() != o.getClass()) return false;
      if (!super.equals(o)) return false;

      Procedure procedure = (Procedure) o;

      if (returnType != null ? !returnType.equals(procedure.returnType) : procedure.returnType != null) return false;
      return parameterNames != null ? parameterNames.equals(procedure.parameterNames) : procedure.parameterNames == null;
   }

   @Override
   public int hashCode() {
      int result = super.hashCode();
      result = 31 * result + (returnType != null ? returnType.hashCode() : 0);
      result = 31 * result + (parameterNames != null ? parameterNames.hashCode() : 0);
      return result;
   }
}

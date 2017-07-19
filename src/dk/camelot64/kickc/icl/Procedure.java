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
         parameters.add(getScope().getVariable(name));
      }
      return parameters;
   }

   @Override
   public String getFullName() {
      return super.getFullName();
   }

   @Override
   public String getTypedName() {
      StringBuilder res = new StringBuilder();
      res.append("("+getType().getTypeName() + ") ");
      res.append(getFullName());
      res.append("(");
      boolean first = true;
      if(parameterNames !=null) {
         for (Variable parameter : getParameters()) {
            if (!first) res.append(" , ");
            first = false;
            res.append(parameter.getTypedName());
         }
      }
      res.append(")");
      return res.toString();
   }

   public String getSymbolTableContents() {
      StringBuilder res = new StringBuilder();
      res.append(getTypedName());
      res.append("\n");
      res.append(super.getSymbolTableContents());
      return res.toString();
   }

   @Override
   public SymbolType getType() {
      return new SymbolTypeProcedure(returnType);
   }



   @Override
   RegisterAllocation getAllocation() {
      if(getScope()!=null) {
         return getScope().getAllocation();
      } else {
         return null;
      }
   }

   @Override
   public String toString() {
      return getTypedName();
   }

   @Override
   public String getAsTypedString(ProgramScope scope) {
      return getTypedName();
   }

   @Override
   public String getAsString() {
      return getTypedName();
   }
}

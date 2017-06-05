package dk.camelot64.kickc.icl;

import java.util.List;

/** Symbol describing a procedure/function */
public class Procedure extends Scope {

   private final SymbolType returnType;
   private List<Variable> parameters;

   public Procedure(String name, SymbolType returnType, Scope parentScope) {
      super(name, new SymbolTypeProcedure(returnType), parentScope);
      this.returnType = returnType;
   }

   public void setParameters(List<Variable> parameters) {
      this.parameters = parameters;
      for (Variable parameter : parameters) {
         add(parameter);
      }
   }

   public Label getLabel() {
      return new Label(getLocalName(), this, false);
   }

   public SymbolType getReturnType() {
      return returnType;
   }

   public List<Variable> getParameters() {
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
      if(parameters!=null) {
         for (Variable parameter : parameters) {
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
   public String toString() {
      return getTypedName();
   }

}

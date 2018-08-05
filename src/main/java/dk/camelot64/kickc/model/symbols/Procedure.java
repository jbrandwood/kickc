package dk.camelot64.kickc.model.symbols;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeProcedure;
import dk.camelot64.kickc.model.values.ProcedureRef;

import java.util.ArrayList;
import java.util.List;

/** Symbol describing a procedure/function */
public class Procedure extends Scope {

   public static final ProcedureRef ROOT = new ProcedureRef("");
   private final SymbolType returnType;
   private List<String> parameterNames;
   private boolean declaredInline;

   /** The type of interrupt that the procedure serves. Null for all procedures not serving an interrupt. */
   private InterruptType interruptType;

   public Procedure(String name, SymbolType returnType, Scope parentScope) {
      super(name, parentScope);
      this.returnType = returnType;
      this.declaredInline = false;
      this.interruptType = null;
   }

   public List<String> getParameterNames() {
      return parameterNames;
   }

   public Label getLabel() {
      return new Label(getFullName(), getScope(), false);
   }

   public SymbolType getReturnType() {
      return returnType;
   }

   public List<Variable> getParameters() {
      ArrayList<Variable> parameters = new ArrayList<>();
      for(String name : parameterNames) {
         parameters.add(this.getVariable(name));
      }
      return parameters;
   }

   public void setParameters(List<Variable> parameters) {
      this.parameterNames = new ArrayList<>();
      for(Variable parameter : parameters) {
         add(parameter);
         parameterNames.add(parameter.getLocalName());
      }
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

   public boolean isDeclaredInline() {
      return declaredInline;
   }

   public void setDeclaredInline(boolean declaredInline) {
      this.declaredInline = declaredInline;
   }

   public InterruptType getInterruptType() {
      return interruptType;
   }

   public void setInterruptType(InterruptType interruptType) {
      this.interruptType = interruptType;
   }

   /** The different types of supported interrupts. */
   public enum InterruptType {
      /** Interrupt served by the kernel called through $0314-5. Will exit through the kernel as well through $ea81. */
      KERNEL,
      /** Interrupt served directly from hardware through $fffe-f. Will exit through RTI and will save necessary registers based on clobber. */
      HARDWARE;

      public static InterruptType getType(String name) {
         switch(name) {
            case "kernel":
               return KERNEL;
            case "hardware":
               return HARDWARE;
            default:
               return null;
         }

      }
   }

   @Override
   public String toString() {
      return toString(null);
   }

   @Override
   public String toString(Program program) {
      StringBuilder res = new StringBuilder();
      if(declaredInline) {
         res.append("inline ");
      }
      if(interruptType !=null) {
         res.append("interrupt("+ interruptType +")");
      }
      res.append("(" + getType().getTypeName() + ") ");
      res.append(getFullName());
      res.append("(");
      boolean first = true;
      if(parameterNames != null) {
         for(Variable parameter : getParameters()) {
            if(!first) res.append(" , ");
            first = false;
            res.append(parameter.toString(program));
         }
      }
      res.append(")");
      return res.toString();
   }

   public ProcedureRef getRef() {
      return new ProcedureRef(this.getFullName());
   }

   @Override
   public boolean equals(Object o) {
      if(this == o) return true;
      if(o == null || getClass() != o.getClass()) return false;
      if(!super.equals(o)) return false;

      Procedure procedure = (Procedure) o;

      if(returnType != null ? !returnType.equals(procedure.returnType) : procedure.returnType != null) return false;
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

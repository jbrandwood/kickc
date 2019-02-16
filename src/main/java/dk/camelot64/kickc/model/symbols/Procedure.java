package dk.camelot64.kickc.model.symbols;

import dk.camelot64.kickc.model.Comment;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeProcedure;
import dk.camelot64.kickc.model.values.ProcedureRef;

import java.util.ArrayList;
import java.util.List;

/** Symbol describing a procedure/function */
public class Procedure extends Scope {

   /** The return type. {@link SymbolType#VOID} if the procedure does not return a value.  */
   private final SymbolType returnType;
   /** The names of the parameters of the procedure. */
   private List<String> parameterNames;
   /** true if the procedure is declared inline. */
   private boolean declaredInline;
   /** The type of interrupt that the procedure serves. Null for all procedures not serving an interrupt. */
   private InterruptType interruptType;
   /** Comments preceeding the procedure in the source code. */
   private List<Comment> comments;

   public Procedure(String name, SymbolType returnType, Scope parentScope) {
      super(name, parentScope);
      this.returnType = returnType;
      this.declaredInline = false;
      this.interruptType = null;
      this.comments = new ArrayList<>();
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


   public List<Comment> getComments() {
      return comments;
   }

   public void setComments(List<Comment> comments) {
      this.comments = comments;
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
      /** Interrupt served by the kernel called through $0314-5. Will exit through the kernel using $ea31. */
      KERNEL_KEYBOARD,
      /** Interrupt served by the kernel called through $0314-5. Will exit through the kernel using $ea81. */
      KERNEL_MIN,
      /** Interrupt served directly from hardware through $fffe-f. Will exit through RTI and will save NO registers. */
      HARDWARE_NONE,
      /** Interrupt served directly from hardware through $fffe-f. Will exit through RTI and will save ALL registers. */
      HARDWARE_ALL,
      /** Interrupt served directly from hardware through $fffe-f. Will exit through RTI and will save necessary registers based on clobber. */
      HARDWARE_CLOBBER
      ;

      /** The default interrupt type if none is explicitly declared (KERNEL_MIN). */
      public static InterruptType DEFAULT = InterruptType.KERNEL_MIN;

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

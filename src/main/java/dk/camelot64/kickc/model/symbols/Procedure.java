package dk.camelot64.kickc.model.symbols;

import dk.camelot64.kickc.model.Comment;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeProcedure;
import dk.camelot64.kickc.model.values.ProcedureRef;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

/** Symbol describing a procedure/function */
public class Procedure extends Scope {

   /** The return type. {@link SymbolType#VOID} if the procedure does not return a value. */
   private final SymbolType returnType;
   /** The names of the parameters of the procedure. */
   private List<String> parameterNames;
   /** true if the procedure is declared inline. */
   private boolean declaredInline;
   /** The type of interrupt that the procedure serves. Null for all procedures not serving an interrupt. */
   private InterruptType interruptType;
   /** Comments preceding the procedure in the source code. */
   private List<Comment> comments;
   /** Reserved zeropage addresses. */
   private List<Integer> reservedZps;
   /** The code segment to put the procedure into. */
   private String codeSegment;

   /** The method for passing parameters and return value to the procedure. */
   public enum CallingConvention {
      /** Parameters and return value handled through call PHI-transitions. */
      PHI_CALL("__phicall"),
      /** Parameters and return value over the stack. */
      STACK_CALL("__stackcall");

      private String name;

      CallingConvention(String name) {
         this.name = name;
      }

      public String getName() {
         return name;
      }

      /** Get a calling convention by name. */
      public static CallingConvention getCallingConvension(String name) {
         for(CallingConvention value : CallingConvention.values()) {
            if(value.getName().equalsIgnoreCase(name)) {
               return value;
            }
         }
         return null;
      }
   }

   /** The calling convention used for this procedure. */
   private CallingConvention callingConvention;

   public Procedure(String name, SymbolType returnType, Scope parentScope, String codeSegment, String dataSegment, CallingConvention callingConvention) {
      super(name, parentScope, dataSegment);
      this.returnType = returnType;
      this.declaredInline = false;
      this.interruptType = null;
      this.comments = new ArrayList<>();
      this.codeSegment = codeSegment;
      this.callingConvention = callingConvention;
   }

   public CallingConvention getCallingConvention() {
      return callingConvention;
   }

   public void setCallingConvention(CallingConvention callingConvention) {
      this.callingConvention = callingConvention;
   }

   public String getCodeSegment() {
      return codeSegment;
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
         parameters.add(this.getLocalVariable(name));
      }
      return parameters;
   }

   public void setParameters(List<Variable> parameters) {
      this.parameterNames = new ArrayList<>();
      for(Variable parameter : parameters) {
         parameterNames.add(parameter.getLocalName());
      }
   }

   public void setParameterNames(List<String> parameterNames) {
      this.parameterNames = parameterNames;
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

   public String toString(Program program, boolean onlyVars) {
      StringBuilder res = new StringBuilder();
      res.append(toString(program));
      res.append("\n");
      res.append(super.toString(program, onlyVars));
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

   /**
    * Sets any zero-page addresses reserved by the procedure. The KickC-compiler is not allowed to use these addresses.
    *
    * @return reserved addresses
    */
   public List<Integer> getReservedZps() {
      return reservedZps;
   }

   /**
    * Gets any reserved zero-page addresses that the compiler is not allowed to use.
    *
    * @param reservedZps reserved addresses
    */
   public void setReservedZps(List<Integer> reservedZps) {
      this.reservedZps = reservedZps;
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
      /** Interrupt served directly from hardware through $fffe-f. Will exit through RTI and will save ALL registers using the stack. */
      HARDWARE_STACK,
      /** Interrupt served directly from hardware through $fffe-f. Will exit through RTI and will save necessary registers based on clobber. */
      HARDWARE_CLOBBER;

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
      if(!callingConvention.equals(CallingConvention.PHI_CALL)) {
         res.append(getCallingConvention().getName()).append(" ");
      }
      if(interruptType != null) {
         res.append("interrupt(" + interruptType + ")");
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
      return declaredInline == procedure.declaredInline &&
            Objects.equals(returnType, procedure.returnType) &&
            Objects.equals(parameterNames, procedure.parameterNames) &&
            interruptType == procedure.interruptType &&
            Objects.equals(comments, procedure.comments) &&
            Objects.equals(reservedZps, procedure.reservedZps) &&
            Objects.equals(codeSegment, procedure.codeSegment) &&
            callingConvention == procedure.callingConvention;
   }

   @Override
   public int hashCode() {
      return Objects.hash(super.hashCode(), returnType, parameterNames, declaredInline, interruptType, comments, reservedZps, codeSegment, callingConvention);
   }
}

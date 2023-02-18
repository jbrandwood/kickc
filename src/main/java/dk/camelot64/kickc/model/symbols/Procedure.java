package dk.camelot64.kickc.model.symbols;

import dk.camelot64.kickc.model.Comment;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.StatementSource;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeProcedure;
import dk.camelot64.kickc.model.values.ProcedureRef;
import dk.camelot64.kickc.passes.Pass1ByteXIntrinsicRewrite;
import dk.camelot64.kickc.passes.Pass1PrintfIntrinsicRewrite;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Objects;

/** Symbol describing a procedure/function */
public class Procedure extends Scope {

   /** The return type. {@link SymbolType#VOID} if the procedure does not return a value. */
   private final SymbolTypeProcedure procedureType;
   /** The names of the parameters of the procedure. */
   private List<String> parameterNames;
   /** True if the parameter list ends with a variable length parameter list "..." */
   private boolean variableLengthParameterList;
   /** true if the procedure is declared inline. */
   private boolean declaredInline;
   /** True if the procedure is declared intrinsic. */
   private boolean declaredIntrinsic;
   /** The type of interrupt that the procedure serves. Null for all procedures not serving an interrupt. */
   private String interruptType;
   /** Comments preceding the procedure in the source code. */
   private List<Comment> comments;
   /** Reserved zeropage addresses. */
   private List<Integer> reservedZps;
   /** The code segment to put the procedure into. */
   private String codeSegment;
   /** The list of constructor procedures for this procedure. The constructor procedures are called during program initialization. */
   private final List<ProcedureRef> constructorRefs;
   /** Is this procedure declared as a constructor procedure. */
   private boolean isConstructor;
   /** The source of the procedure definition. */
   private StatementSource definitionSource;

   /** The names of all legal intrinsic procedures. */
   final public static List<String> INTRINSIC_PROCEDURES = Arrays.asList(
         Pass1PrintfIntrinsicRewrite.INTRINSIC_PRINTF_NAME,
         Pass1PrintfIntrinsicRewrite.INTRINSIC_SNPRINTF_NAME,
         Pass1PrintfIntrinsicRewrite.INTRINSIC_SPRINTF_NAME,
         Pass1ByteXIntrinsicRewrite.INTRINSIC_MAKELONG4
   );

   /** The method for passing parameters and return value to the procedure. */
   public enum CallingConvention {
      /** Parameters and return value handled through PHI-transitions. */
      PHI_CALL("__phicall"),
      /** Parameters and return value over the stack. */
      STACK_CALL("__stackcall"),
      /** Parameters and return value handled through shared variables. */
      VAR_CALL("__varcall"),
      /** Intrinsic calling. Will be converted to intrinsic ASM late in the compile. */
      INTRINSIC_CALL("__intrinsiccall");

      private final String name;

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

   public Procedure(String name, SymbolTypeProcedure procedureType, Scope parentScope, String codeSegment, String dataSegment, CallingConvention callingConvention) {
      super(name, parentScope, dataSegment);
      this.procedureType = procedureType;
      this.declaredInline = false;
      this.interruptType = null;
      this.comments = new ArrayList<>();
      this.codeSegment = codeSegment;
      this.callingConvention = callingConvention;
      this.constructorRefs = new ArrayList<>();
      this.isConstructor = false;
   }

   public StatementSource getDefinitionSource() {
      return definitionSource;
   }

   public void setDefinitionSource(StatementSource definitionSource) {
      this.definitionSource = definitionSource;
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

   public void setCodeSegment(String codeSegment) {
      this.codeSegment = codeSegment;
   }

   public List<String> getParameterNames() {
      return parameterNames;
   }

   public void setVariableLengthParameterList(boolean variableLengthParameterList) {
      this.variableLengthParameterList = variableLengthParameterList;
   }

   public boolean isVariableLengthParameterList() {
      return variableLengthParameterList;
   }

   public boolean isDeclaredIntrinsic() {
      return declaredIntrinsic;
   }

   public void setDeclaredIntrinsic(boolean declaredIntrinsic) {
      this.declaredIntrinsic = declaredIntrinsic;
   }

   public Label getLabel() {
      return new Label(getFullName(), getScope(), false);
   }

   public SymbolType getReturnType() {
      return procedureType.getReturnType();
   }

   public List<Variable> getParameters() {
      ArrayList<Variable> parameters = new ArrayList<>();
      for(String name : parameterNames) {
         parameters.add(this.getLocalVar(name));
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

   public String toStringVars(Program program, boolean onlyVars) {
      StringBuilder res = new StringBuilder();
      res.append(toString(program));
      res.append("\n");
      res.append(super.toStringVars(program, onlyVars));
      return res.toString();
   }

   @Override
   public SymbolTypeProcedure getType() {
      return procedureType;
   }

   public boolean isDeclaredInline() {
      return declaredInline;
   }

   public void setDeclaredInline(boolean declaredInline) {
      this.declaredInline = declaredInline;
   }

   public String getInterruptType() {
      return interruptType;
   }

   public void setInterruptType(String interruptType) {
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

   /**
    * Get references to all constructors needed for this procedure
    *
    * @return The references
    */
   public List<ProcedureRef> getConstructorRefs() {
      return constructorRefs;
   }

   public boolean isConstructor() {
      return isConstructor;
   }

   public void setConstructor(boolean constructor) {
      isConstructor = constructor;
   }

   @Override
   public String toString() {
      return toString(null, false);
   }

   public String toString(Program program) {
      return toString(program, false);
   }

   public String toString(Program program, boolean onlyTypes) {
      StringBuilder res = new StringBuilder();
      if(declaredInline) {
         res.append("inline ");
      }
      if(declaredIntrinsic) {
         res.append("__intrinsic ");
      }
      if(!callingConvention.equals(CallingConvention.PHI_CALL)) {
         res.append(getCallingConvention().getName()).append(" ");
      }
      if(interruptType != null) {
         res.append("__interrupt(").append(interruptType).append(") ");
      }
      if(onlyTypes) {
         res.append(getType().toCDecl());
      } else {
         res.append(getReturnType().toCDecl()).append(" ").append(getFullName()).append("(");
         boolean first = true;
         if(parameterNames != null) {
            for(Variable parameter : getParameters()) {
               if(!first) res.append(" , ");
               first = false;
               res.append(parameter.toCDecl());
            }
         }
         if(isVariableLengthParameterList()) {
            res.append(", ...");
         }
         res.append(")");
      }
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
      return variableLengthParameterList == procedure.variableLengthParameterList &&
            declaredInline == procedure.declaredInline &&
            declaredIntrinsic == procedure.declaredIntrinsic &&
            isConstructor == procedure.isConstructor &&
            Objects.equals(procedureType, procedure.procedureType) &&
            Objects.equals(parameterNames, procedure.parameterNames) &&
            Objects.equals(interruptType, procedure.interruptType) &&
            Objects.equals(comments, procedure.comments) &&
            Objects.equals(reservedZps, procedure.reservedZps) &&
            Objects.equals(codeSegment, procedure.codeSegment) &&
            Objects.equals(constructorRefs, procedure.constructorRefs) &&
            callingConvention == procedure.callingConvention;
   }

   @Override
   public int hashCode() {
      return Objects.hash(super.hashCode(), procedureType, parameterNames, variableLengthParameterList, declaredInline, declaredIntrinsic, interruptType, comments, reservedZps, codeSegment, constructorRefs, isConstructor, callingConvention);
   }
}

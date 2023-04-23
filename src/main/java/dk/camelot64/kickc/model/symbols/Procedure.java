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
   /** The data and code segment to put the procedure into. When null the procedure is not assigned to the code segment. */
   private String segmentCode;
   /** The list of constructor procedures for this procedure. The constructor procedures are called during program initialization. */
   private final List<ProcedureRef> constructorRefs;
   /** Is this procedure declared as a constructor procedure. */
   private boolean isConstructor;
   /** The source of the procedure definition. */
   private StatementSource definitionSource;
   /**
    * The bank that the procedure code is placed in.
    * Used to decide whether to produce near, close or far call when generating code.
    * If null, the procedure is in a common bank (always visible) and all calls will be near.
    */
   private Bank bank;


   /** The names of all legal intrinsic procedures. */
   final public static List<String> INTRINSIC_PROCEDURES = Arrays.asList(
         Pass1PrintfIntrinsicRewrite.INTRINSIC_PRINTF_NAME,
         Pass1PrintfIntrinsicRewrite.INTRINSIC_SNPRINTF_NAME,
         Pass1PrintfIntrinsicRewrite.INTRINSIC_SPRINTF_NAME,
         Pass1ByteXIntrinsicRewrite.INTRINSIC_MAKELONG4
   );

   public Bank getBank() {
      return bank;
   }

   public void setBank(Bank bank) {
      this.bank = bank;
   }

   public enum CallingProximity {
      NEAR("near"),
      CLOSE("close"),
      FAR("far");

      public String getProximity() {
         return proximity;
      }

      private final String proximity;

      CallingProximity(String proximity) {
         this.proximity = proximity;
      }
   }

   /** The method for expressing the call distance to implement banking
    *
    * The following variations exist related to banked calls:
    *    - #1 - unbanked to unbanked and no banking areas
    *    - #2 - unbanked to banked to any bank area
    *    - #3 - banked to unbanked from any bank area
    *    - #4 - banked to same bank in same bank area
    *    - #5 - banked to different bank in same bank area
    *    - #6 - banked to any bank between different bank areas
    *
    * This brings us to the call types:
    *    - CallingDistance.NEAR - case #1, #3, #4
    *    - CallingDistance.CLOSE - case #2, #6
    *    - CallingDistance.FAR - case #5
   */
   public static class CallingDistance {

      private CallingProximity proximity;
      private String bankArea;
      private Long bank;

      public CallingProximity getProximity() {
         return proximity;
      }

      public String getBankArea() {
         return bankArea;
      }

      public Long getBankNumber() {
         return bank;
      }


      public CallingDistance(Procedure from, Procedure to) {
         if (((!from.isBanked() && !to.isBanked())) ||
                 ((from.isBanked() && !to.isBanked())) ||
                 ((from.isBanked() && to.isBanked()) &&
                         (from.getBankNumber() == to.getBankNumber()) &&
                         (from.getBankArea().contentEquals(to.getBankArea()))
                 )
         ) {
            // near call - case #1, #3, #4
            this.proximity = CallingProximity.NEAR;
            this.bankArea = "";
            this.bank = 0L;
         } else {
            if ((!from.isBanked() && to.isBanked()) ||
                    ((from.isBanked() && to.isBanked()) && (!from.getBankArea().contentEquals(to.getBankArea())))
            ) {
               // close call - case #2, #6
               this.proximity = CallingProximity.CLOSE;
               this.bankArea = to.getBankArea();
               this.bank = to.getBankNumber();
            } else {
               // far call - case #5
               this.proximity = CallingProximity.FAR;
               this.bankArea = to.getBankArea();
               this.bank = to.getBankNumber();
            }
         }
      }

      public String getFragmentName() {
         return this.proximity.getProximity() + (this.bankArea.isEmpty() ? "" : "_" + this.bankArea);
      }
   }

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

   public Procedure(String name, SymbolTypeProcedure procedureType, Scope parentScope, String segmentCode, String segmentData, CallingConvention callingConvention, Bank bank) {
      super(name, parentScope, segmentData);
      this.procedureType = procedureType;
      this.declaredInline = false;
      this.bank = bank;
      this.interruptType = null;
      this.comments = new ArrayList<>();
      this.segmentCode = segmentCode;
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

   public String getSegmentCode() {
      return segmentCode;
   }

   public void setSegmentCode(String segmentCode) {
      this.segmentCode = segmentCode;
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

   public boolean isBanked() {
      return bank != null;
   }

   public Long getBankNumber() {
      if(bank != null)
         return bank.bankNumber();
      else
         return 0L;
   }

   public String getBankArea() {
      if(bank != null)
         return bank.bankArea();
      else
         return "";
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
      if(isBanked()) {
         res.append("__bank(").append(this.getBankArea()).append(", ").append(this.getBankNumber()).append(") ");
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
      return variableLengthParameterList == procedure.variableLengthParameterList && declaredInline == procedure.declaredInline && declaredIntrinsic == procedure.declaredIntrinsic && isConstructor == procedure.isConstructor && Objects.equals(procedureType, procedure.procedureType) && Objects.equals(parameterNames, procedure.parameterNames) && Objects.equals(interruptType, procedure.interruptType) && Objects.equals(comments, procedure.comments) && Objects.equals(reservedZps, procedure.reservedZps) && Objects.equals(segmentCode, procedure.segmentCode) && Objects.equals(constructorRefs, procedure.constructorRefs) && Objects.equals(definitionSource, procedure.definitionSource) && Objects.equals(bank, procedure.bank) && callingConvention == procedure.callingConvention;
   }

   @Override
   public int hashCode() {
      return Objects.hash(super.hashCode(), procedureType, parameterNames, variableLengthParameterList, declaredInline, declaredIntrinsic, interruptType, comments, reservedZps, segmentCode, constructorRefs, isConstructor, definitionSource, bank, callingConvention);
   }
}

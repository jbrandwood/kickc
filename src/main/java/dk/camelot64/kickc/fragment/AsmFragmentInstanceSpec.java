package dk.camelot64.kickc.fragment;

import dk.camelot64.kickc.model.*;

import java.util.LinkedHashMap;
import java.util.Map;

/**
 * A fragment specification generated from a {@link Statement} used to load/synthesize an {@link AsmFragmentInstance} for creating ASM code for the statement
 */
public class AsmFragmentInstanceSpec {

   /**
    * The symbol table.
    */
   private Program program;

   /**
    * The string signature/name of the fragment template.
    */
   private String signature;

   /**
    * Binding of named values in the fragment to values (constants, variables, ...) .
    */
   private Map<String, Value> bindings;

   /**
    * The scope containing the fragment. Used when referencing symbols defined in other scopes.
    */
   private ScopeRef codeScopeRef;
   /**
    * Zero page register name indexing.
    */
   private int nextZpByteIdx = 1;
   private int nextZpBoolIdx = 1;
   private int nextConstByteIdx = 1;
   private int nextLabelIdx = 1;

   public AsmFragmentInstanceSpec(
         StatementConditionalJump conditionalJump,
         ControlFlowBlock block,
         Program program,
         ControlFlowGraph graph) {
      this.codeScopeRef = program.getStatementInfos().getBlock(conditionalJump).getScope();
      this.bindings = new LinkedHashMap<>();
      this.program = program;
      String conditionalJumpSignature = conditionalJumpSignature(conditionalJump, block, graph);
      setSignature(conditionalJumpSignature);
   }

   public AsmFragmentInstanceSpec(StatementAssignment assignment, Program program) {
      this.codeScopeRef = program.getStatementInfos().getBlock(assignment).getScope();
      this.bindings = new LinkedHashMap<>();
      this.program = program;
      setSignature(assignmentSignature(
            assignment.getlValue(),
            assignment.getrValue1(),
            assignment.getOperator(),
            assignment.getrValue2()));
   }

   public AsmFragmentInstanceSpec(LValue lValue, RValue rValue, Program program, ScopeRef codeScopeRef) {
      this.codeScopeRef = codeScopeRef;
      this.bindings = new LinkedHashMap<>();
      this.program = program;
      setSignature(assignmentSignature(lValue, null, null, rValue));
   }

   public AsmFragmentInstanceSpec(StatementAssignment assignment, StatementAssignment assignmentAlu, Program program) {
      this.codeScopeRef = program.getStatementInfos().getBlock(assignment).getScope();
      this.bindings = new LinkedHashMap<>();
      this.program = program;
      setSignature(assignmentWithAluSignature(assignment, assignmentAlu));
   }

   private static String getOperatorFragmentName(Operator operator) {
      return operator.getAsmOperator();
   }

   private String assignmentWithAluSignature(StatementAssignment assignment, StatementAssignment assignmentAlu) {
      this.codeScopeRef = program.getStatementInfos().getBlock(assignment).getScope();
      if(!(assignment.getrValue2() instanceof VariableRef)) {
         throw new AsmFragmentInstance.AluNotApplicableException("Error! ALU register only allowed as rValue2. " + assignment);
      }
      VariableRef assignmentRValue2 = (VariableRef) assignment.getrValue2();
      Variable assignmentRValue2Var = program.getSymbolInfos().getVariable(assignmentRValue2);
      Registers.Register rVal2Register = assignmentRValue2Var.getAllocation();

      if(!rVal2Register.getType().equals(Registers.RegisterType.REG_ALU)) {
         throw new AsmFragmentInstance.AluNotApplicableException("Error! ALU register only allowed as rValue2. " + assignment);
      }
      StringBuilder signature = new StringBuilder();
      signature.append(bind(assignment.getlValue()));
      signature.append("=");
      if(assignment.getrValue1() != null) {
         signature.append(bind(assignment.getrValue1()));
      }
      if(assignment.getOperator() != null) {
         signature.append(getOperatorFragmentName(assignment.getOperator()));
      }
      signature.append(assignmentRightSideSignature(
            assignmentAlu.getrValue1(),
            assignmentAlu.getOperator(),
            assignmentAlu.getrValue2()));
      return signature.toString();
   }

   private String assignmentSignature(LValue lValue, RValue rValue1, Operator operator, RValue rValue2) {
      StringBuilder signature = new StringBuilder();
      signature.append(bind(lValue));
      signature.append("=");
      signature.append(assignmentRightSideSignature(rValue1, operator, rValue2));
      return signature.toString();
   }

   private String assignmentRightSideSignature(RValue rValue1, Operator operator, RValue rValue2) {
      StringBuilder signature = new StringBuilder();
      if(rValue1 != null) {
         signature.append(bind(rValue1));
      }
      if(operator != null) {
         signature.append(getOperatorFragmentName(operator));
      }
      if(
            rValue2 instanceof ConstantInteger &&
                  ((ConstantInteger) rValue2).getNumber() == 1 &&
                  operator != null &&
                  (operator.getOperator().equals("-") || operator.getOperator().equals("+"))) {
         signature.append("1");
      } else if(
            rValue2 instanceof ConstantInteger &&
                  ((ConstantInteger) rValue2).getNumber() <= 7 &&
                  operator != null &&
                  (operator.getOperator().equals(">>") || operator.getOperator().equals("<<"))) {
         signature.append(((ConstantInteger) rValue2).getNumber());
      } else if(
            rValue2 instanceof ConstantInteger &&
                  ((ConstantInteger) rValue2).getNumber() == 0 &&
                  operator != null &&
                  (operator.getOperator().equals("-") || operator.getOperator().equals("+"))) {
         signature.append("0");
      } else {
         signature.append(bind(rValue2));
      }
      return signature.toString();
   }

   private String conditionalJumpSignature(
         StatementConditionalJump conditionalJump,
         ControlFlowBlock block,
         ControlFlowGraph graph) {
      StringBuilder signature = new StringBuilder();
      if(conditionalJump.getrValue1() != null) {
         signature.append(bind(conditionalJump.getrValue1()));
      }
      if(conditionalJump.getOperator() != null) {
         signature.append(getOperatorFragmentName(conditionalJump.getOperator()));
      }
      if(conditionalJump.getrValue2() instanceof ConstantInteger && ((ConstantInteger) conditionalJump.getrValue2()).getNumber() == 0) {
         signature.append("0");
      } else if(conditionalJump.getrValue2() instanceof ConstantBool) {
         ConstantBool boolValue = (ConstantBool) conditionalJump.getrValue2();
         signature.append(boolValue.toString());
      } else {
         signature.append(bind(conditionalJump.getrValue2()));
      }
      signature.append("_then_");
      LabelRef destination = conditionalJump.getDestination();
      ControlFlowBlock destinationBlock = graph.getBlock(destination);
      String destinationLabel;
      if(destinationBlock.hasPhiBlock()) {
         destinationLabel =
               (destinationBlock.getLabel().getLocalName() +
                     "_from_" +
                     block.getLabel().getLocalName()).replace('@', 'b').replace(':', '_');
      } else {
         destinationLabel = destination.getLocalName();
      }
      Symbol destSymbol = program.getScope().getSymbol(destination);
      signature.append(bind(new Label(destinationLabel, destSymbol.getScope(), false)));
      return signature.toString();
   }

   public String getSignature() {
      return signature;
   }

   private void setSignature(String signature) {
      this.signature = signature;
   }


   /**
    * Add bindings of a value.
    *
    * @param value The value to bind.
    * @return The bound name of the value. If the value has already been bound the existing bound name is returned.
    */
   public String bind(Value value) {
      return bind(value, null);
   }

   /**
    * Add bindings of a value.
    *
    * @param value The value to bind.
    * @return The bound name of the value. If the value has already been bound the existing bound name is returned.
    */
   public String bind(Value value, SymbolType type) {

      if(value instanceof CastValue) {
         CastValue castVal = (CastValue) value;
         SymbolType toType = castVal.getToType();
         value = castVal.getValue();
         return bind(value, toType);
      } else if(value instanceof PointerDereference) {
         PointerDereference deref = (PointerDereference) value;
         SymbolType ptrType = null;
         if(type != null) {
            ptrType = new SymbolTypePointer(type);
         }
         if(value instanceof PointerDereferenceSimple) {
            return "_deref_" + bind(deref.getPointer(), ptrType);
         } else if(value instanceof PointerDereferenceIndexed) {
            PointerDereferenceIndexed derefIdx = (PointerDereferenceIndexed) value;
            return bind(derefIdx.getPointer(), ptrType) + "_derefidx_" + bind(derefIdx.getIndex());
         }
      } else if(value instanceof VariableRef) {
         Variable variable = program.getSymbolInfos().getVariable((VariableRef) value);
         if(type == null) {
            type = variable.getType();
         }
         Registers.Register register = variable.getAllocation();
         String name = getTypePrefix(type) + getRegisterName(register);
         bind(name, variable);
         return name;
      } else if(value instanceof ConstantValue) {
         if(type == null) {
            type = SymbolTypeInference.inferType(program.getScope(), (RValue) value);
         }
         String name = getTypePrefix(type) + getConstName(value);
         bind(name, value);
         return name;
      } else if(value instanceof Label) {
         String name = "la" + nextLabelIdx++;
         bind(name, value);
         return name;
      }
      throw new RuntimeException("Binding of value type not supported " + value);
   }

   /**
    * Add binding for a name/value pair if it is not already bound.
    *
    * @param name The name
    * @param value The value
    */
   private void bind(String name, Value value) {
      if(bindings.get(name) == null) {
         bindings.put(name, value);
      }
   }

   /**
    * Get the symbol type part of the binding name (eg. vbu/pws/...)
    *
    * @param type The type
    * @return The type name
    */
   private String getTypePrefix(SymbolType type) {
      if(SymbolType.isByte(type)) {
         return "vbu";
      } else if(SymbolType.isSByte(type)) {
         return "vbs";
      } else if(SymbolType.isWord(type)) {
         return "vwu";
      } else if(SymbolType.isSWord(type)) {
         return "vws";
      } else if(SymbolType.STRING.equals(type)) {
         return "pbu";
      } else if(type instanceof SymbolTypePointer) {
         SymbolType elementType = ((SymbolTypePointer) type).getElementType();
         if(SymbolType.isByte(elementType)) {
            return "pbu";
         } else if(SymbolType.isSByte(elementType)) {
            return "pbs";
         } else if(SymbolType.isWord(elementType)) {
            return "pwu";
         } else {
            throw new RuntimeException("Not implemented " + type);
         }
      } else {
         throw new RuntimeException("Not implemented " + type);
      }
   }

   /**
    * Get the register part of the binding name (eg. aa, z1, c2, ...).
    * Examines all previous bindings to reuse register index if the same register is bound multiple times.
    *
    * @param register The register
    * @return The register part of the binding name.
    */
   private String getRegisterName(Registers.Register register) {
      if(Registers.RegisterType.ZP_BYTE.equals(register.getType()) || Registers.RegisterType.ZP_WORD.equals(register.getType())) {
         // Examine if the ZP register is already bound
         Registers.RegisterZp registerZp = (Registers.RegisterZp) register;
         String zpNameIdx = null;
         for(String boundName : bindings.keySet()) {
            Value boundValue = bindings.get(boundName);
            if(boundValue instanceof Variable) {
               Registers.Register boundRegister = ((Variable) boundValue).getAllocation();
               if(boundRegister != null && boundRegister.isZp()) {
                  Registers.RegisterZp boundRegisterZp = (Registers.RegisterZp) boundRegister;
                  if(registerZp.getZp() == boundRegisterZp.getZp()) {
                     // Found other register with same ZP address!
                     zpNameIdx = boundName.substring(boundName.length() - 1);
                     break;
                  }
               }
            }
         }
         // If not create a new one
         if(zpNameIdx == null) {
            zpNameIdx = Integer.toString(nextZpByteIdx++);
         }
         return "z" + zpNameIdx;
      } else if(Registers.RegisterType.REG_A_BYTE.equals(register.getType())) {
         return "aa";
      } else if(Registers.RegisterType.REG_X_BYTE.equals(register.getType())) {
         return "xx";
      } else if(Registers.RegisterType.REG_Y_BYTE.equals(register.getType())) {
         return "yy";
      } else if(Registers.RegisterType.REG_ALU.equals(register.getType())) {
         throw new AsmFragmentInstance.AluNotApplicableException();
      } else {
         throw new RuntimeException("Not implemented " + register.getType());
      }
   }

   private String getConstName(Value constant) {
      // If the constant is already bound - reuse the index
      for(String boundName : bindings.keySet()) {
         Value boundValue = bindings.get(boundName);
         if(boundValue instanceof ConstantValue || boundValue instanceof ConstantVar) {
            if(boundValue.equals(constant)) {
               return "c" + boundName.substring(boundName.length() - 1);
            }
         }
      }
      // Otherwise use a new index
      return "c" + nextConstByteIdx++;
   }

   public Program getProgram() {
      return program;
   }

   public ScopeRef getCodeScope() {
      return codeScopeRef;
   }

   public Map<String, Value> getBindings() {
      return bindings;
   }

   @Override
   public String toString() {
      StringBuilder str = new StringBuilder();
      str.append(signature).append("(");
      str.append(codeScopeRef).append(":: ");
      for(String bound : bindings.keySet()) {
         str.append(bound).append("=").append(bindings.get(bound).toString(getProgram())).append(" ");
      }
      str.append(") ");
      return str.toString();
   }

   @Override
   public boolean equals(Object o) {
      if(this == o) return true;
      if(o == null || getClass() != o.getClass()) return false;

      AsmFragmentInstanceSpec that = (AsmFragmentInstanceSpec) o;

      if(signature != null ? !signature.equals(that.signature) : that.signature != null) return false;
      if(bindings != null ? !bindings.equals(that.bindings) : that.bindings != null) return false;
      return codeScopeRef != null ? codeScopeRef.equals(that.codeScopeRef) : that.codeScopeRef == null;
   }

   @Override
   public int hashCode() {
      int result = signature != null ? signature.hashCode() : 0;
      result = 31 * result + (bindings != null ? bindings.hashCode() : 0);
      result = 31 * result + (codeScopeRef != null ? codeScopeRef.hashCode() : 0);
      return result;
   }
}

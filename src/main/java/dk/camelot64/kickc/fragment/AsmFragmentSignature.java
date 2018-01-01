package dk.camelot64.kickc.fragment;

import dk.camelot64.kickc.model.*;

import java.util.LinkedHashMap;
import java.util.Map;

/**
 * A fragment signature generated from a {@link Statement} used to load/synthesize an AsmFragent for creating ASM code for the statement
 */
public class AsmFragmentSignature {

   /**
    * The symbol table.
    */
   private Program program;

   /**
    * The string signature/name of the fragment fragment.
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

   public AsmFragmentSignature(
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

   public AsmFragmentSignature(StatementAssignment assignment, Program program) {
      this.codeScopeRef = program.getStatementInfos().getBlock(assignment).getScope();
      this.bindings = new LinkedHashMap<>();
      this.program = program;
      setSignature(assignmentSignature(
            assignment.getlValue(),
            assignment.getrValue1(),
            assignment.getOperator(),
            assignment.getrValue2()));
   }

   public AsmFragmentSignature(LValue lValue, RValue rValue, Program program, ScopeRef codeScopeRef) {
      this.codeScopeRef = codeScopeRef;
      this.bindings = new LinkedHashMap<>();
      this.program = program;
      setSignature(assignmentSignature(lValue, null, null, rValue));
   }

   public AsmFragmentSignature(StatementAssignment assignment, StatementAssignment assignmentAlu, Program program) {
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
         throw new AsmFragment.AluNotApplicableException("Error! ALU register only allowed as rValue2. " + assignment);
      }
      VariableRef assignmentRValue2 = (VariableRef) assignment.getrValue2();
      Variable assignmentRValue2Var = program.getSymbolInfos().getVariable(assignmentRValue2);
      Registers.Register rVal2Register = assignmentRValue2Var.getAllocation();

      if(!rVal2Register.getType().equals(Registers.RegisterType.REG_ALU)) {
         throw new AsmFragment.AluNotApplicableException("Error! ALU register only allowed as rValue2. " + assignment);
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
      if(value instanceof PointerDereferenceSimple) {
         PointerDereferenceSimple deref = (PointerDereferenceSimple) value;
         return "_deref_" + bind(deref.getPointer());
      } else if(value instanceof PointerDereferenceIndexed) {
         PointerDereferenceIndexed deref = (PointerDereferenceIndexed) value;
         return bind(deref.getPointer()) + "_derefidx_" + bind(deref.getIndex());
      }

      if(value instanceof VariableRef) {
         value = program.getSymbolInfos().getVariable((VariableRef) value);
      }
      if(value instanceof ConstantRef) {
         value = program.getScope().getConstant((ConstantRef) value);
      }

      // Find value if it is already bound
      for(String name : bindings.keySet()) {
         Value bound = bindings.get(name);
         if(bound.equals(value)) {
            return name;
         }
      }

      if(value instanceof Variable) {
         Variable variable = (Variable) value;
         Registers.Register register = variable.getAllocation();
         // Find value if it is already bound
         for(String name : bindings.keySet()) {
            Value bound = bindings.get(name);
            if(bound instanceof Variable) {
               Registers.Register boundRegister = ((Variable) bound).getAllocation();
               if(boundRegister != null && boundRegister.equals(register)) {
                  if(SymbolTypeInference.typeMatch(((Variable) bound).getType(), variable.getType())) {
                     return name;
                  }
               }
            }
         }
         SymbolType varType = ((Variable) value).getType();
         String name = getTypePrefix(varType) + getRegisterName(register);
         bindings.put(name, value);
         return name;
      } else if(value instanceof ConstantVar || value instanceof ConstantValue) {
         SymbolType constType;
         if(value instanceof ConstantVar) {
            constType = ((ConstantVar) value).getType();
         } else {
            constType = SymbolTypeInference.inferType(program.getScope(), (ConstantValue) value);
         }
         String name = getTypePrefix(constType) + "c" + nextConstByteIdx++;
         bindings.put(name, value);
         return name;
      } else if(value instanceof Label) {
         String name = "la" + nextLabelIdx++;
         bindings.put(name, value);
         return name;
      }
      throw new RuntimeException("Binding of value type not supported " + value);
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
      if(Registers.RegisterType.ZP_BYTE.equals(register.getType())) {
         return "z" + getRegisterZpNameIdx((Registers.RegisterZp) register);
      } else if(Registers.RegisterType.ZP_WORD.equals(register.getType())) {
         return "z" + getRegisterZpNameIdx((Registers.RegisterZp) register);
      } else if(Registers.RegisterType.REG_A_BYTE.equals(register.getType())) {
         return "aa";
      } else if(Registers.RegisterType.REG_X_BYTE.equals(register.getType())) {
         return "xx";
      } else if(Registers.RegisterType.REG_Y_BYTE.equals(register.getType())) {
         return "yy";
      } else if(Registers.RegisterType.REG_ALU.equals(register.getType())) {
         throw new AsmFragment.AluNotApplicableException();
      } else {
         throw new RuntimeException("Not implemented " + register.getType());
      }
   }

   /**
    * Get the register ZP name index to use for a specific register.
    * Examines all previous bindings to reuse register index if the same register is bound multiple times.
    *
    * @param register The register to find an index for
    * @return The index. Either reused ot allocated from {@link #nextZpByteIdx}
    */
   private String getRegisterZpNameIdx(Registers.RegisterZp register) {
      for(String boundName : bindings.keySet()) {
         Value boundValue = bindings.get(boundName);
         if(boundValue instanceof Variable) {
            Registers.Register boundRegister = ((Variable) boundValue).getAllocation();
            if(boundRegister != null && boundRegister.isZp()) {
               Registers.RegisterZp boundRegisterZp = (Registers.RegisterZp) boundRegister;
               if(register.getZp() == boundRegisterZp.getZp()) {
                  // Found other register with same ZP address!
                  return boundName.substring(boundName.length() - 1);
               }
            }
         }
      }
      return Integer.toString(nextZpByteIdx++);
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
}

package dk.camelot64.kickc.fragment;

import dk.camelot64.kickc.asm.AsmFormat;
import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.operators.Operator;
import dk.camelot64.kickc.model.operators.OperatorUnary;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.symbols.Label;
import dk.camelot64.kickc.model.symbols.Symbol;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.*;
import dk.camelot64.kickc.model.values.*;

import java.lang.InternalError;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * A fragment specification generated from a {@link Statement} used to load/synthesize an {@link AsmFragmentInstance} for creating ASM code for the statement
 */
public class AsmFragmentInstanceSpecBuilder {

   /**
    * The symbol table.
    */
   private final Program program;

   /**
    * Binding of named values in the fragment to values (constants, variables, ...) .
    */
   private final Map<String, Value> bindings;

   /**
    * The created ASM fragment instance specification
    */
   private final AsmFragmentInstanceSpec asmFragmentInstanceSpec;

   /** Indexing for zeropages/constants/labels */
   private int nextMemIdx = 1;
   private int nextConstIdx = 1;
   private int nextLabelIdx = 1;

   /**
    * Create a fragment instance spec factory for an interrupt routine (entry or exit)
    *
    * @param interruptTypeComplete The interrupt routine handler name - including "isr_" and "_entry"/_exit"
    * @param program The program
    * @return the fragment instance spec factory
    */
   public static AsmFragmentInstanceSpecBuilder interrupt(String interruptTypeComplete, Program program) {
      Map<String, Value> bindings = new HashMap<>();
      String signature = interruptTypeComplete;
      ScopeRef codeScope = program.getScope().getRef();
      final AsmFragmentInstanceSpec fragmentInstanceSpec = new AsmFragmentInstanceSpec(program, signature, bindings, codeScope);
      return new AsmFragmentInstanceSpecBuilder(program, bindings, fragmentInstanceSpec);
   }

   /**
    * Create a fragment instance spec factory for an interrupt routine entry
    *
    * @param interruptType The interrupt routine handle name
    * @param program The program
    * @return the fragment instance spec factory
    */
   public static AsmFragmentInstanceSpecBuilder interruptEntry(String interruptType, Program program) {
      Map<String, Value> bindings = new HashMap<>();
      String signature = "isr_" + interruptType + "_entry";
      ScopeRef codeScope = program.getScope().getRef();
      final AsmFragmentInstanceSpec fragmentInstanceSpec = new AsmFragmentInstanceSpec(program, signature, bindings, codeScope);
      return new AsmFragmentInstanceSpecBuilder(program, bindings, fragmentInstanceSpec);
   }

   /**
    * Create a fragment instance spec factory for an interrupt routine exit
    *
    * @param interruptType The interrupt routine handle name
    * @param program The program
    * @return the fragment instance spec factory
    */
   public static AsmFragmentInstanceSpecBuilder interruptExit(String interruptType, Program program) {
      Map<String, Value> bindings = new HashMap<>();
      String signature = "isr_" + interruptType + "_exit";
      ScopeRef codeScope = program.getScope().getRef();
      final AsmFragmentInstanceSpec fragmentInstanceSpec = new AsmFragmentInstanceSpec(program, signature, bindings, codeScope);
      return new AsmFragmentInstanceSpecBuilder(program, bindings, fragmentInstanceSpec);
   }

   private AsmFragmentInstanceSpecBuilder(Program program, Map<String, Value> bindings, AsmFragmentInstanceSpec asmFragmentInstanceSpec) {
      this.program = program;
      this.bindings = bindings;
      this.asmFragmentInstanceSpec = asmFragmentInstanceSpec;
   }


   public static AsmFragmentInstanceSpecBuilder conditionalJump(StatementConditionalJump conditionalJump, ControlFlowBlock block, Program program) {
      return new AsmFragmentInstanceSpecBuilder(conditionalJump, block, program);
   }

   private AsmFragmentInstanceSpecBuilder(
         StatementConditionalJump conditionalJump,
         ControlFlowBlock block,
         Program program) {
      this.program = program;
      this.bindings = new LinkedHashMap<>();
      ScopeRef codeScope = program.getStatementInfos().getBlock(conditionalJump).getScope();
      String signature = conditionalJumpSignature(conditionalJump, block, program.getGraph());
      this.asmFragmentInstanceSpec = new AsmFragmentInstanceSpec(program, signature, bindings, codeScope);
   }

   public static AsmFragmentInstanceSpecBuilder exprSideEffect(StatementExprSideEffect exprSideEffect, Program program) {
      return new AsmFragmentInstanceSpecBuilder(exprSideEffect, program);
   }

   private AsmFragmentInstanceSpecBuilder(StatementExprSideEffect exprSideEffect, Program program) {
      this.program = program;
      this.bindings = new LinkedHashMap<>();
      ScopeRef codeScope = program.getStatementInfos().getBlock(exprSideEffect).getScope();
      String signature = bind(exprSideEffect.getExpression());
      this.asmFragmentInstanceSpec = new AsmFragmentInstanceSpec(program, signature, bindings, codeScope);
   }

   public static AsmFragmentInstanceSpecBuilder assignment(StatementAssignment assignment, Program program) {
      return new AsmFragmentInstanceSpecBuilder(assignment, program);
   }

   /**
    * MAKELONG4() creates a long form 4 bytes
    * @param call The intrinsic call
    * @param program The program
    * @return The ASM fragment instance
    */
   public static AsmFragmentInstanceSpecBuilder makelong4(StatementCall call, Program program) {
      return new AsmFragmentInstanceSpecBuilder(call, program);
   }

   private AsmFragmentInstanceSpecBuilder(StatementCall make4long, Program program) {
      this.program = program;
      this.bindings = new LinkedHashMap<>();
      StringBuilder signature = new StringBuilder();
      signature.append(bind(make4long.getlValue()));
      signature.append("=");
      signature.append("_makelong4_(");
      if(make4long.getParameters().size()!=4)
         throw new CompileError("MAKELONG4() needs 4 parameters.", make4long);
      signature.append(bind(make4long.getParameter(3)));
      signature.append(")_(");
      signature.append(bind(make4long.getParameter(2)));
      signature.append(")_(");
      signature.append(bind(make4long.getParameter(1)));
      signature.append(")_(");
      signature.append(bind(make4long.getParameter(0)));
      signature.append(")");
      ScopeRef codeScope = program.getScope().getRef();
      this.asmFragmentInstanceSpec = new AsmFragmentInstanceSpec(program, signature.toString(), bindings, codeScope);
   }

   private AsmFragmentInstanceSpecBuilder(StatementAssignment assignment, Program program) {
      this.program = program;
      this.bindings = new LinkedHashMap<>();
      ScopeRef codeScope = program.getStatementInfos().getBlock(assignment).getScope();
      String signature = assignmentSignature(
            assignment.getlValue(),
            assignment.getrValue1(),
            assignment.getOperator(),
            assignment.getrValue2());
      this.asmFragmentInstanceSpec = new AsmFragmentInstanceSpec(program, signature, bindings, codeScope);
   }

   public static AsmFragmentInstanceSpecBuilder assignment(LValue lValue, RValue rValue, Program program, ScopeRef codeScopeRef) {
      return new AsmFragmentInstanceSpecBuilder(lValue, rValue, program, codeScopeRef);
   }

   private AsmFragmentInstanceSpecBuilder(LValue lValue, RValue rValue, Program program, ScopeRef codeScopeRef) {
      this.program = program;
      this.bindings = new LinkedHashMap<>();
      String signature = assignmentSignature(lValue, null, null, rValue);
      this.asmFragmentInstanceSpec = new AsmFragmentInstanceSpec(program, signature, bindings, codeScopeRef);
   }

   public static AsmFragmentInstanceSpecBuilder assignmentAlu(StatementAssignment assignment, StatementAssignment assignmentAlu, Program program) {
      return new AsmFragmentInstanceSpecBuilder(assignment, assignmentAlu, program);
   }

   private AsmFragmentInstanceSpecBuilder(StatementAssignment assignment, StatementAssignment assignmentAlu, Program program) {
      this.program = program;
      this.bindings = new LinkedHashMap<>();
      ScopeRef codeScope = program.getStatementInfos().getBlock(assignment).getScope();
      String signature = assignmentWithAluSignature(assignment, assignmentAlu);
      this.asmFragmentInstanceSpec = new AsmFragmentInstanceSpec(program, signature, bindings, codeScope);
   }

   public Map<String, Value> getBindings() {
      return bindings;
   }

   /**
    * Get the created ASM fragment instance specification
    *
    * @return The ASM fragment instance specification
    */
   public AsmFragmentInstanceSpec getAsmFragmentInstanceSpec() {
      return asmFragmentInstanceSpec;
   }

   private static String getOperatorFragmentName(Operator operator) {
      return operator.getAsmOperator();
   }

   private String assignmentWithAluSignature(StatementAssignment assignment, StatementAssignment assignmentAlu) {
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

      final SymbolType rValue1Type = rValue1 == null ? null : SymbolTypeInference.inferType(program.getScope(), rValue1);

      StringBuilder signature = new StringBuilder();
      if(rValue1 != null) {
         signature.append(bind(rValue1));
      }
      if(operator != null) {
         signature.append(getOperatorFragmentName(operator));
      }
      if(
            rValue2 instanceof ConstantInteger &&
                  ((ConstantInteger) rValue2).getValue() == 1 &&
                  operator != null &&
                  (operator.getOperator().equals("-") || operator.getOperator().equals("+"))) {
         signature.append("1");
      } else if(
            rValue2 instanceof ConstantInteger &&
                  ((ConstantInteger) rValue2).getValue() == 2 &&
                  operator != null &&
                  (operator.getOperator().equals("-") || operator.getOperator().equals("+")) &&
                  (SymbolType.BYTE.equals(rValue1Type) || SymbolType.SBYTE.equals(rValue1Type))
      ) {
         signature.append("2");
      } else if(
            rValue2 instanceof ConstantInteger &&
                  ((ConstantInteger) rValue2).getValue() <= 9 &&
                  operator != null &&
                  (operator.getOperator().equals(">>") || operator.getOperator().equals("<<"))) {
         signature.append(((ConstantInteger) rValue2).getValue());
      } else if(
            rValue2 instanceof ConstantInteger &&
                  ((((ConstantInteger) rValue2).getValue()) % 8 == 0) &&
                  operator != null &&
                  (operator.getOperator().equals(">>") || operator.getOperator().equals("<<"))) {
         signature.append(((ConstantInteger) rValue2).getValue());
      } else if(
            rValue2 instanceof ConstantInteger &&
                  ((ConstantInteger) rValue2).getValue() == 0 &&
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
      if(conditionalJump.getrValue1() instanceof ConstantInteger && ((ConstantInteger) conditionalJump.getrValue1()).getValue() == 0) {
         signature.append("0");
      } else if(conditionalJump.getrValue1() instanceof ConstantBool) {
         ConstantBool boolValue = (ConstantBool) conditionalJump.getrValue1();
         signature.append(boolValue.toString());
      } else if(conditionalJump.getrValue1() != null) {
         signature.append(bind(conditionalJump.getrValue1()));
      }
      if(conditionalJump.getOperator() != null) {
         signature.append(getOperatorFragmentName(conditionalJump.getOperator()));
      }
      if(conditionalJump.getrValue2() instanceof ConstantInteger && ((ConstantInteger) conditionalJump.getrValue2()).getValue() == 0) {
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
               AsmFormat.asmFix(destinationBlock.getLabel().getLocalName() +
                     "_from_" +
                     block.getLabel().getLocalName());
      } else {
         destinationLabel = destination.getLocalName();
      }
      Symbol destSymbol = program.getScope().getSymbol(destination);
      signature.append(bind(new Label(destinationLabel, destSymbol.getScope(), false)));
      return signature.toString();
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
    * @param castType The type to bind the value as (used for casting). null if not casting, will use the actual type of the value.
    * @return The bound name of the value. If the value has already been bound the existing bound name is returned.
    */
   public String bind(Value value, SymbolType castType) {
      if(value instanceof CastValue) {
         CastValue cast = (CastValue) value;
         SymbolType toType = cast.getToType();
         RValue castValue = cast.getValue();
         SymbolType castValueType = SymbolTypeInference.inferType(this.program.getScope(), castValue);
         if(castValueType.getSizeBytes() == toType.getSizeBytes()) {
            if(castType != null) {
               if(castType.getSizeBytes() == toType.getSizeBytes()) {
                  return bind(castValue, castType);
               } else {
                  OperatorUnary castUnary = Operators.getCastUnary(castType);
                  return getOperatorFragmentName(castUnary) + bind(castValue, toType);
               }
            } else {
               return bind(castValue, toType);
            }
         } else {
            // Size of inner value and inner cast type mismatches - require explicit conversion
            if(castType != null) {
               OperatorUnary castUnaryInner = Operators.getCastUnary(toType);
               OperatorUnary castUnaryOuter = Operators.getCastUnary(castType);
               return getOperatorFragmentName(castUnaryOuter) + getOperatorFragmentName(castUnaryInner) + bind(castValue);
            } else {
               OperatorUnary castUnaryInner = Operators.getCastUnary(toType);
               return getOperatorFragmentName(castUnaryInner) + bind(castValue);
            }
         }
      } else if(value instanceof ConstantCastValue) {
         ConstantCastValue castVal = (ConstantCastValue) value;
         ConstantValue val = castVal.getValue();
         if(castType == null) {
            SymbolType toType = castVal.getToType();
            // If value literal not matching cast type then add expression code to transform it into the value space ( eg. value & 0xff )

            if(toType instanceof SymbolTypeIntegerFixed) {
               SymbolTypeIntegerFixed integerFixed = (SymbolTypeIntegerFixed) toType;
               ConstantLiteral constantLiteral;
               Long integerValue;
               try {
                  constantLiteral = val.calculateLiteral(program.getScope());
                  if(constantLiteral instanceof ConstantInteger) {
                     integerValue = ((ConstantInteger) constantLiteral).getValue();
                  } else if(constantLiteral instanceof ConstantPointer) {
                     integerValue = ((ConstantPointer) constantLiteral).getValue();
                  } else if(constantLiteral instanceof ConstantChar) {
                     integerValue = ((ConstantChar) constantLiteral).getInteger();
                  } else {
                     throw new InternalError("Not implemented " + constantLiteral);
                  }
               } catch(ConstantNotLiteral e) {
                  // Assume it is a word
                  integerValue = 0xffffL;
               }

               if(!integerFixed.contains(integerValue)) {
                  if(toType.getSizeBytes() == 1) {
                     val = new ConstantBinary(new ConstantInteger(0xffL, SymbolType.BYTE), Operators.BOOL_AND, val);
                  } else if(toType.getSizeBytes() == 2) {
                     val = new ConstantBinary(new ConstantInteger(0xffffL, SymbolType.WORD), Operators.BOOL_AND, val);
                  } else if(toType.getSizeBytes() == 4) {
                     val = new ConstantBinary(new ConstantInteger(0xffffffffL, SymbolType.DWORD), Operators.BOOL_AND, val);
                  } else {
                     throw new InternalError("Not implemented " + toType);
                  }
               }
            }

            return bind(val, toType);
         } else {
            return bind(val, castType);
         }
      } else if(value instanceof PointerDereference) {
         PointerDereference deref = (PointerDereference) value;
         SymbolType ptrType = null;
         if(castType != null) {
            ptrType = new SymbolTypePointer(castType);
         }
         if(value instanceof PointerDereferenceSimple) {
            String bindPointer = bind(deref.getPointer(), ptrType);
            if(bindPointer.contains("deref")) {
               // Special handling of nested derefs - add parenthesis!
               return "_deref_" + "(" + bindPointer + ")";
            } else {
               return "_deref_" + bindPointer;
            }
         } else if(value instanceof PointerDereferenceIndexed) {
            PointerDereferenceIndexed derefIdx = (PointerDereferenceIndexed) value;
            StringBuilder bindValue = new StringBuilder();
            String bindPointer = bind(derefIdx.getPointer(), ptrType);
            if(bindPointer.contains("deref")) {
               // Special handling of nested derefs - add parenthesis!
               bindValue.append("(").append(bindPointer).append(")");
            } else {
               bindValue.append(bindPointer);
            }
            bindValue.append("_derefidx_");
            String bindIndex = bind(derefIdx.getIndex());
            if(bindIndex.contains("deref")) {
               // Special handling of nested derefs - add parenthesis!
               bindValue.append("(").append(bindIndex).append(")");
            } else {
               bindValue.append(bindIndex);
            }
            return bindValue.toString();
         }
      } else if(value instanceof VariableRef) {
         Variable variable = program.getSymbolInfos().getVariable((VariableRef) value);
         if(castType == null) {
            castType = variable.getType();
         }
         Registers.Register register = variable.getAllocation();
         String name = getTypePrefix(castType) + getRegisterName(register);
         bind(name, variable);
         return name;
      } else if(value instanceof ConstantValue) {
         if(castType == null) {
            castType = SymbolTypeInference.inferType(program.getScope(), (ConstantValue) value);
         }
         String name = getTypePrefix(castType) + getConstName(value);
         bind(name, value);
         return name;
      } else if(value instanceof Label) {
         String name = "la" + nextLabelIdx++;
         bind(name, value);
         return name;
      } else if(value instanceof StackIdxValue) {
         StackIdxValue stackIdxValue = (StackIdxValue) value;
         SymbolType type = stackIdxValue.getValueType();
         String typeShortName = Operators.getCastUnary(type).getAsmOperator().replace("_", "");
         return "_stackidx" + typeShortName + "_" + bind(stackIdxValue.getStackOffset());
      } else if(value instanceof StackPushValue) {
         SymbolType type = ((StackPushValue) value).getType();
         String typeShortName = Operators.getCastUnary(type).getAsmOperator().replace("_", "");
         return "_stackpush" + typeShortName + "_";
      } else if(value instanceof StackPullValue) {
         SymbolType type = ((StackPullValue) value).getType();
         String typeShortName = Operators.getCastUnary(type).getAsmOperator().replace("_", "");
         return "_stackpull" + typeShortName + "_";
      } else if(value instanceof StackPullBytes) {
         final ConstantInteger bytes = (ConstantInteger) ((StackPullBytes) value).getBytes();
         return "_stackpullbyte_" + AsmFormat.getAsmNumber(bytes.getInteger());
      } else if(value instanceof StackPushBytes) {
         final ConstantInteger bytes = (ConstantInteger) ((StackPushBytes) value).getBytes();
         return "_stackpushbyte_" + AsmFormat.getAsmNumber(bytes.getInteger());
      } else if(value instanceof MemsetValue) {
         MemsetValue memsetValue = (MemsetValue) value;
         ConstantValue sizeConst = memsetValue.getSize();
         if(sizeConst.getType(program.getScope()).equals(SymbolType.NUMBER)) {
            SymbolType fixedIntegerType = SymbolTypeConversion.getSmallestUnsignedFixedIntegerType(sizeConst, program.getScope());
            sizeConst = new ConstantCastValue(fixedIntegerType, sizeConst);
         }
         return "_memset_" + bind(sizeConst);
      } else if(value instanceof MemcpyValue) {
         MemcpyValue memcpyValue = (MemcpyValue) value;
         ConstantValue sizeConst = memcpyValue.getSize();
         if(sizeConst.getType(program.getScope()).equals(SymbolType.NUMBER)) {
            SymbolType fixedIntegerType = SymbolTypeConversion.getSmallestUnsignedFixedIntegerType(sizeConst, program.getScope());
            sizeConst = new ConstantCastValue(fixedIntegerType, sizeConst);
         }
         return bind(memcpyValue.getSource()) + "_memcpy_" + bind(sizeConst);
      }
      throw new RuntimeException("Binding of value type not supported " + value.toString(program));
   }

   /**
    * Add binding for a name/value pair if it is not already bound.
    *
    * @param name The name
    * @param value The value
    */
   private void bind(String name, Value value) {
      bindings.putIfAbsent(name, value);
   }

   /**
    * Get the symbol type part of the binding name (eg. vbu/pws/...)
    *
    * @param type The type
    * @return The type name
    */
   static String getTypePrefix(SymbolType type) {
      if(type instanceof SymbolTypePointer) {
         SymbolType elmType = ((SymbolTypePointer) type).getElementType();
         if(elmType instanceof SymbolTypePointer) {
            SymbolType eml2Type = ((SymbolTypePointer) elmType).getElementType();
            if(eml2Type instanceof SymbolTypePointer) {
               throw new RuntimeException("Not implemented " + type);
            } else {
               return "q" + getBaseTypePrefix(eml2Type);
            }
         } else {
            return "p" + getBaseTypePrefix(elmType);
         }
      } else {
         return "v" + getBaseTypePrefix(type);
      }
   }

   /**
    * Get the base symbol type part of the binding name (eg. bu/ws/...).
    * This only handles basic types (not pointers)
    *
    * @param baseType The basic type
    * @return The 2-letter base type name (eg. bu/ws/...).
    */
   static String getBaseTypePrefix(SymbolType baseType) {
      if(SymbolType.BYTE.equals(baseType)) {
         return "bu";
      } else if(SymbolType.SBYTE.equals(baseType)) {
         return "bs";
      } else if(SymbolType.WORD.equals(baseType)) {
         return "wu";
      } else if(SymbolType.SWORD.equals(baseType)) {
         return "ws";
      } else if(SymbolType.DWORD.equals(baseType)) {
         return "du";
      } else if(SymbolType.SDWORD.equals(baseType)) {
         return "ds";
      } else if(SymbolType.VOID.equals(baseType)) {
         return "vo";
      } else if(SymbolType.BOOLEAN.equals(baseType)) {
         return "bo";
      } else if(baseType instanceof SymbolTypeStruct) {
         return "ss";
      } else if(baseType instanceof SymbolTypeProcedure) {
         return "pr";
      } else {
         throw new CompileError("Type not supported in fragments " + baseType);
      }
   }

   /**
    * Get the register part of the binding name (eg. aa, z1, z2, ...).
    * Examines all previous bindings to reuse register index if the same register is bound multiple times.
    *
    * @param register The register
    * @return The register part of the binding name.
    */
   private String getRegisterName(Registers.Register register) {
      if(Registers.RegisterType.ZP_MEM.equals(register.getType())) {
         // Examine if the ZP register is already bound
         Registers.RegisterZpMem registerZp = (Registers.RegisterZpMem) register;
         String memNameIdx = null;
         for(String boundName : bindings.keySet()) {
            Value boundValue = bindings.get(boundName);
            if(boundValue instanceof Variable && ((Variable) boundValue).isVariable()) {
               Variable boundVariable = (Variable) boundValue;
               Registers.Register boundRegister = boundVariable.getAllocation();
               if(boundRegister != null && Registers.RegisterType.ZP_MEM.equals(boundRegister.getType())) {
                  Registers.RegisterZpMem boundRegisterZp = (Registers.RegisterZpMem) boundRegister;
                  if(registerZp.getZp() == boundRegisterZp.getZp()) {
                     // Found other register with same ZP address!
                     memNameIdx = boundName.substring(boundName.length() - 1);
                     break;
                  }
               }
            }
         }
         // If not create a new one
         if(memNameIdx == null) {
            memNameIdx = Integer.toString(nextMemIdx++);
         }
         return "z" + memNameIdx;
      } else if(Registers.RegisterType.MAIN_MEM.equals(register.getType())) {
         String memNameIdx = null;
         for(String boundName : bindings.keySet()) {
            Value boundValue = bindings.get(boundName);
            if(boundValue instanceof Variable && ((Variable) boundValue).isVariable()) {
               Variable boundVariable = (Variable) boundValue;
               Registers.Register boundRegister = boundVariable.getAllocation();
               if(boundRegister instanceof Registers.RegisterMainMem) {
                  if(boundRegister.equals(register)) {
                     memNameIdx = boundName.substring(boundName.length() - 1);
                     break;
                  }
               }
            }
         }
         if(memNameIdx == null) {
            memNameIdx = Integer.toString(nextMemIdx++);
         }
         return "m" + memNameIdx;
      } else if(Registers.RegisterType.REG_A.equals(register.getType())) {
         return "aa";
      } else if(Registers.RegisterType.REG_X.equals(register.getType())) {
         return "xx";
      } else if(Registers.RegisterType.REG_Y.equals(register.getType())) {
         return "yy";
      } else if(Registers.RegisterType.REG_Z.equals(register.getType())) {
         return "zz";
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
         if(boundValue instanceof ConstantValue || (boundValue instanceof Variable && ((Variable) boundValue).isKindConstant())) {
            if(boundValue.equals(constant)) {
               return "c" + boundName.substring(boundName.length() - 1);
            }
         }
      }
      // Otherwise use a new index
      return "c" + nextConstIdx++;
   }

}
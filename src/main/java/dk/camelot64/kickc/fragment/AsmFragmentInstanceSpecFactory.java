package dk.camelot64.kickc.fragment;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.operators.Operator;
import dk.camelot64.kickc.model.operators.OperatorUnary;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.statements.StatementConditionalJump;
import dk.camelot64.kickc.model.symbols.ConstantVar;
import dk.camelot64.kickc.model.symbols.Label;
import dk.camelot64.kickc.model.symbols.Symbol;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.*;
import dk.camelot64.kickc.model.values.*;

import java.lang.InternalError;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * A fragment specification generated from a {@link Statement} used to load/synthesize an {@link AsmFragmentInstance} for creating ASM code for the statement
 */
public class AsmFragmentInstanceSpecFactory {

   /**
    * The symbol table.
    */
   private Program program;

   /**
    * Binding of named values in the fragment to values (constants, variables, ...) .
    */
   private Map<String, Value> bindings;

   /**
    * The created ASM fragment instance specification
    */
   private AsmFragmentInstanceSpec asmFragmentInstanceSpec;

   /** Indexing for zeropages/constants/labels */
   private int nextZpIdx = 1;
   private int nextConstIdx = 1;
   private int nextLabelIdx = 1;

   public AsmFragmentInstanceSpecFactory(
         StatementConditionalJump conditionalJump,
         ControlFlowBlock block,
         Program program,
         ControlFlowGraph graph) {
      this.program = program;
      this.bindings = new LinkedHashMap<>();
      ScopeRef codeScope = program.getStatementInfos().getBlock(conditionalJump).getScope();
      String signature = conditionalJumpSignature(conditionalJump, block, graph);
      this.asmFragmentInstanceSpec = new AsmFragmentInstanceSpec(program, signature, bindings, codeScope);
   }

   public AsmFragmentInstanceSpecFactory(StatementAssignment assignment, Program program) {
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

   public AsmFragmentInstanceSpecFactory(LValue lValue, RValue rValue, Program program, ScopeRef codeScopeRef) {
      this.program = program;
      this.bindings = new LinkedHashMap<>();
      String signature = assignmentSignature(lValue, null, null, rValue);
      this.asmFragmentInstanceSpec = new AsmFragmentInstanceSpec(program, signature, bindings, codeScopeRef);
   }

   public AsmFragmentInstanceSpecFactory(StatementAssignment assignment, StatementAssignment assignmentAlu, Program program) {
      this.program = program;
      this.bindings = new LinkedHashMap<>();
      ScopeRef codeScope = program.getStatementInfos().getBlock(assignment).getScope();
      String signature = assignmentWithAluSignature(assignment, assignmentAlu);
      this.asmFragmentInstanceSpec = new AsmFragmentInstanceSpec(program, signature, bindings, codeScope);
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
                  (operator.getOperator().equals("-") || operator.getOperator().equals("+"))) {
         signature.append("2");
      } else if(
            rValue2 instanceof ConstantInteger &&
                  ((ConstantInteger) rValue2).getValue() <= 7 &&
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
      if(conditionalJump.getrValue1() != null) {
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
         OperatorUnary castUnary = Operators.getCastUnary(toType);
         RValue castValue = cast.getValue();
         SymbolType castValueType = SymbolTypeInference.inferType(this.program.getScope(), castValue);
         if(castValueType.getSizeBytes() == toType.getSizeBytes()) {
            return bind(castValue, toType);
         } else {
            return getOperatorFragmentName(castUnary) + bind(castValue);
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
                  } else {
                     throw new InternalError("Not implemented "+constantLiteral);
                  }
               } catch (ConstantNotLiteral e) {
                  // Assume it is a word
                  integerValue = 0xffffL;
               }

               if(!integerFixed.contains(integerValue)) {
                  if(toType.getSizeBytes() == 1) {
                     val = new ConstantBinary(new ConstantInteger(0xffL, SymbolType.BYTE), Operators.BOOL_AND, val);
                  } else if(toType.getSizeBytes() == 2) {
                     val = new ConstantBinary(new ConstantInteger(0xffffL, SymbolType.WORD), Operators.BOOL_AND, val);
                  } else {
                     throw new InternalError("Not implemented "+toType);
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
            return "_deref_" + bind(deref.getPointer(), ptrType);
         } else if(value instanceof PointerDereferenceIndexed) {
            PointerDereferenceIndexed derefIdx = (PointerDereferenceIndexed) value;
            return bind(derefIdx.getPointer(), ptrType) + "_derefidx_" + bind(derefIdx.getIndex());
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
      bindings.putIfAbsent(name, value);
   }

   /**
    * Get the symbol type part of the binding name (eg. vbu/pws/...)
    *
    * @param type The type
    * @return The type name
    */
   static String getTypePrefix(SymbolType type) {
      if(SymbolType.BYTE.equals(type)) {
         return "vbu";
      } else if(SymbolType.SBYTE.equals(type)) {
         return "vbs";
      } else if(SymbolType.WORD.equals(type)) {
         return "vwu";
      } else if(SymbolType.SWORD.equals(type)) {
         return "vws";
      } else if(SymbolType.DWORD.equals(type)) {
         return "vdu";
      } else if(SymbolType.SDWORD.equals(type)) {
         return "vds";
      } else if(SymbolType.STRING.equals(type)) {
         return "pbu";
      } else if(SymbolType.BOOLEAN.equals(type)) {
         return "vbo";
      } else if(type instanceof SymbolTypePointer) {
         SymbolType elementType = ((SymbolTypePointer) type).getElementType();
         if(SymbolType.BYTE.equals(elementType)) {
            return "pbu";
         } else if(SymbolType.SBYTE.equals(elementType)) {
            return "pbs";
         } else if(SymbolType.WORD.equals(elementType)) {
            return "pwu";
         } else if(SymbolType.SWORD.equals(elementType)) {
            return "pws";
         } else if(SymbolType.DWORD.equals(elementType)) {
            return "pdu";
         } else if(SymbolType.SDWORD.equals(elementType)) {
            return "pds";
         } else if(SymbolType.BOOLEAN.equals(elementType)) {
            return "pbo";
         } else if(elementType instanceof SymbolTypeProcedure) {
            return "ppr";
         } else if(elementType instanceof SymbolTypePointer) {
            return "ppt";
         } else {
            throw new RuntimeException("Not implemented " + type);
         }
      } else {
         throw new RuntimeException("Not implemented " + type);
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
      if(
            Registers.RegisterType.ZP_BOOL.equals(register.getType()) ||
                  Registers.RegisterType.ZP_BYTE.equals(register.getType()) ||
                  Registers.RegisterType.ZP_WORD.equals(register.getType()) ||
                  Registers.RegisterType.ZP_DWORD.equals(register.getType())
      ) {
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
            zpNameIdx = Integer.toString(nextZpIdx++);
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
      return "c" + nextConstIdx++;
   }


}

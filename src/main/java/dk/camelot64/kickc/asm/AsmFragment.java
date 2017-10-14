package dk.camelot64.kickc.asm;

import dk.camelot64.kickc.NumberParser;
import dk.camelot64.kickc.asm.parser.Asm6502BaseVisitor;
import dk.camelot64.kickc.asm.parser.Asm6502Parser;
import dk.camelot64.kickc.icl.*;
import dk.camelot64.kickc.passes.Pass1TypeInference;
import dk.camelot64.kickc.passes.Pass4CodeGeneration;

import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Code Generation Fragment that can handle loading of fragment file and binding of values / registers
 */
public class AsmFragment {

   /**
    * The symbol table.
    */
   private Program program;

   /**
    * Binding of named values in the fragment to values (constants, variables, ...) .
    */
   private Map<String, Value> bindings;

   /**
    * The scope containing the fragment. Used when referenginv symbols defined in other scopes.
    */
   private ScopeRef scope;

   /**
    * The string signature/name of the fragment fragment.
    */
   private String signature;

   public AsmFragment(
         StatementConditionalJump conditionalJump,
         ControlFlowBlock block,
         Program program,
         ControlFlowGraph graph) {
      this.scope = program.getGraph().getBlockFromStatementIdx(conditionalJump.getIndex()).getScope();
      this.bindings = new LinkedHashMap<>();
      this.program = program;
      String conditionalJumpSignature = conditionalJumpSignature(conditionalJump, block, graph);
      setSignature(conditionalJumpSignature);
   }

   public AsmFragment(StatementAssignment assignment, Program program) {
      this.scope = program.getGraph().getBlockFromStatementIdx(assignment.getIndex()).getScope();
      this.bindings = new LinkedHashMap<>();
      this.program = program;
      setSignature(assignmentSignature(
            assignment.getlValue(),
            assignment.getrValue1(),
            assignment.getOperator(),
            assignment.getrValue2()));
   }

   public AsmFragment(LValue lValue, RValue rValue, Program program, ScopeRef scope) {
      this.scope = scope;
      this.bindings = new LinkedHashMap<>();
      this.program = program;
      setSignature(assignmentSignature(lValue, null, null, rValue));
   }

   public AsmFragment(StatementAssignment assignment, StatementAssignment assignmentAlu, Program program) {
      this.scope = program.getGraph().getBlockFromStatementIdx(assignment.getIndex()).getScope();
      this.bindings = new LinkedHashMap<>();
      this.program = program;
      setSignature(assignmentWithAluSignature(assignment, assignmentAlu));

   }

   private String assignmentWithAluSignature(StatementAssignment assignment, StatementAssignment assignmentAlu) {
      this.scope = program.getGraph().getBlockFromStatementIdx(assignment.getIndex()).getScope();
      if (!(assignment.getrValue2() instanceof VariableRef)) {
         throw new AluNotApplicableException("Error! ALU register only allowed as rValue2. " + assignment);
      }
      VariableRef assignmentRValue2 = (VariableRef) assignment.getrValue2();
      Variable assignmentRValue2Var = program.getScope().getVariable(assignmentRValue2);
      Registers.Register rVal2Register = assignmentRValue2Var.getAllocation();

      if (!rVal2Register.getType().equals(Registers.RegisterType.REG_ALU_BYTE)) {
         throw new AluNotApplicableException("Error! ALU register only allowed as rValue2. " + assignment);
      }
      StringBuilder signature = new StringBuilder();
      signature.append(bind(assignment.getlValue()));
      signature.append("=");
      if (assignment.getrValue1() != null) {
         signature.append(bind(assignment.getrValue1()));
      }
      if (assignment.getOperator() != null) {
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
      if (rValue1 != null) {
         signature.append(bind(rValue1));
      }
      if (operator != null) {
         signature.append(getOperatorFragmentName(operator));
      }
      if (
            rValue2 instanceof ConstantInteger &&
                  ((ConstantInteger) rValue2).getNumber() == 2 &&
                  operator != null &&
                  (operator.getOperator().equals(">>") || operator.getOperator().equals("<<"))) {
         signature.append("2");
      } else if (
            rValue2 instanceof ConstantInteger &&
                  ((ConstantInteger) rValue2).getNumber() == 1 &&
                  operator != null &&
                  (operator.getOperator().equals("-") || operator.getOperator().equals("+") || operator.getOperator().equals(
                        ">>") || operator.getOperator().equals("<<"))) {
         signature.append("1");
      } else if (
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
      if (conditionalJump.getrValue1() != null) {
         signature.append(bind(conditionalJump.getrValue1()));
      }
      if (conditionalJump.getOperator() != null) {
         signature.append(getOperatorFragmentName(conditionalJump.getOperator()));
      }
      if (conditionalJump.getrValue2() instanceof ConstantInteger && ((ConstantInteger) conditionalJump.getrValue2()).getNumber() == 0) {
         signature.append("0");
      } else if (conditionalJump.getrValue2() instanceof ConstantBool) {
         ConstantBool boolValue = (ConstantBool) conditionalJump.getrValue2();
         signature.append(boolValue.toString());
      } else {
         signature.append(bind(conditionalJump.getrValue2()));
      }
      signature.append("_then_");
      LabelRef destination = conditionalJump.getDestination();
      ControlFlowBlock destinationBlock = graph.getBlock(destination);
      String destinationLabel;
      if (destinationBlock.hasPhiBlock()) {
         destinationLabel = (destinationBlock.getLabel().getLocalName() + "_from_" + block.getLabel().getLocalName()).replace(
               '@',
               'b').replace(':', '_');
      } else {
         destinationLabel = destination.getLocalName();
      }
      Symbol destSymbol = program.getScope().getSymbol(destination);
      signature.append(bind(new Label(destinationLabel, destSymbol.getScope(), false)));
      return signature.toString();
   }

   private static String getOperatorFragmentName(Operator operator) {
      String op = operator.getOperator();
      switch (op) {
         case "*":
            return "_star_";
         case "*idx":
            return "_staridx_";
         case "+":
            return "_plus_";
         case "++":
            return "_inc_";
         case "--":
            return "_dec_";
         case "-":
            return "_minus_";
         case "==":
            return "_eq_";
         case "<>":
         case "!=":
            return "_neq_";
         case "<":
            return "_lt_";
         case ">":
            return "_gt_";
         case "<=":
         case "=<":
            return "_le_";
         case ">=":
         case "=>":
            return "_ge_";
         case ">>":
            return "_ror_";
         case "<<":
            return "_rol_";
         default:
            return op;
      }
   }

   public Value getBinding(String name) {
      return bindings.get(name);
   }

   public String getSignature() {
      return signature;
   }

   public void setSignature(String signature) {
      this.signature = signature;
   }

   /**
    * Zero page register name indexing.
    */
   private int nextZpByteIdx = 1;
   private int nextZpWordIdx = 1;
   private int nextZpBoolIdx = 1;
   private int nextZpPtrIdx = 1;
   private int nextConstByteIdx = 1;
   private int nextLabelIdx = 1;

   /**
    * Add bindings of a value.
    *
    * @param value The value to bind.
    * @return The bound name of the value. If the value has already been bound the existing bound name is returned.
    */
   public String bind(Value value) {
      if (value instanceof PointerDereferenceSimple) {
         PointerDereferenceSimple deref = (PointerDereferenceSimple) value;
         return "_star_" + bind(deref.getPointer());
      } else if (value instanceof PointerDereferenceIndexed) {
         PointerDereferenceIndexed deref = (PointerDereferenceIndexed) value;
         return bind(deref.getPointer()) + "_staridx_" + bind(deref.getIndex());
      }

      if (value instanceof VariableRef) {
         value = program.getScope().getVariable((VariableRef) value);
      }
      if (value instanceof ConstantRef) {
         value = program.getScope().getConstant((ConstantRef) value);
      }
      if (value instanceof Variable) {
         Variable variable = (Variable) value;
         Registers.Register register = variable.getAllocation();
         // Find value if it is already bound
         for (String name : bindings.keySet()) {
            Value bound = bindings.get(name);
            if (bound instanceof Variable) {
               Registers.Register boundRegister = ((Variable) bound).getAllocation();
               if (boundRegister != null && boundRegister.equals(register)) {
                  return name;
               }
            }
         }
         // Create a new suitable name
         if (Registers.RegisterType.ZP_BYTE.equals(register.getType())) {
            String name = "zpby" + nextZpByteIdx++;
            bindings.put(name, value);
            return name;
         } else if (Registers.RegisterType.ZP_WORD.equals(register.getType())) {
            String name = "zpwo" + nextZpWordIdx++;
            bindings.put(name, value);
            return name;
         } else if (Registers.RegisterType.ZP_BOOL.equals(register.getType())) {
            String name = "zpbo" + nextZpBoolIdx++;
            bindings.put(name, value);
            return name;
         } else if (Registers.RegisterType.REG_X_BYTE.equals(register.getType())) {
            String name = "xby";
            bindings.put(name, value);
            return name;
         } else if (Registers.RegisterType.REG_Y_BYTE.equals(register.getType())) {
            String name = "yby";
            bindings.put(name, value);
            return name;
         } else if (Registers.RegisterType.REG_A_BYTE.equals(register.getType())) {
            String name = "aby";
            bindings.put(name, value);
            return name;
         } else if (Registers.RegisterType.ZP_PTR_BYTE.equals(register.getType())) {
            String name = "zpptrby" + nextZpPtrIdx++;
            bindings.put(name, value);
            return name;
         } else if (Registers.RegisterType.REG_ALU_BYTE.equals(register.getType())) {
            throw new AluNotApplicableException();
         }
      } else if (value instanceof ConstantVar) {
         ConstantVar constantVar = (ConstantVar) value;
         SymbolType constType = constantVar.getType();
         if (SymbolTypeBasic.BYTE.equals(constType)) {
            String name = "coby" + nextConstByteIdx++;
            bindings.put(name, constantVar);
            return name;
         } else if (SymbolTypeBasic.WORD.equals(constType)) {
            String name = "cowo" + nextConstByteIdx++;
            bindings.put(name, constantVar);
            return name;
         } else if (constType instanceof SymbolTypePointer && SymbolTypeBasic.BYTE.equals(((SymbolTypePointer) constType).getElementType())) {
            String name = "cowo" + nextConstByteIdx++;
            bindings.put(name, constantVar);
            return name;
         } else {
            throw new RuntimeException("Unhandled constant type " + constType);
         }
      } else if (value instanceof ConstantInteger) {
         ConstantInteger intValue = (ConstantInteger) value;
         if (SymbolTypeBasic.BYTE.equals(intValue.getType(program.getScope()))) {
            String name = "coby" + nextConstByteIdx++;
            bindings.put(name, value);
            return name;
         } else if (SymbolTypeBasic.WORD.equals(intValue.getType(program.getScope()))) {
            String name = "cowo" + nextConstByteIdx++;
            bindings.put(name, value);
            return name;
         }
      } else if(value instanceof ConstantValue) {
         SymbolType type = Pass1TypeInference.inferType(program.getScope(), (ConstantValue) value);
         if (SymbolTypeBasic.BYTE.equals(type)) {
            String name = "coby" + nextConstByteIdx++;
            bindings.put(name, value);
            return name;
         } else if (SymbolTypeBasic.WORD.equals(type)) {
            String name = "cowo" + nextConstByteIdx++;
            bindings.put(name, value);
            return name;
         } else if (type instanceof SymbolTypePointer) {
            String name = "cowo" + nextConstByteIdx++;
            bindings.put(name, value);
            return name;
         } else {
            throw new RuntimeException("Unhandled constant type " + type);
         }
      } else if (value instanceof Label) {
         String name = "la" + nextLabelIdx++;
         bindings.put(name, value);
         return name;
      }
      throw new RuntimeException("Binding of value type not supported " + value);
   }

   /**
    * Get the value to getReplacement a bound name with from the fragment signature
    *
    * @param name The name of the bound value in the fragment
    * @return The bound value to use in the generated ASM code
    */
   public AsmParameter getBoundValue(String name) {
      Value boundValue = getBinding(name);
      if (boundValue == null) {
         throw new RuntimeException("Binding '" + name + "' not found in fragment " + signature + ".asm");
      }
      if (boundValue instanceof Variable) {
         Variable boundVar = (Variable) boundValue;
         Registers.Register register = boundVar.getAllocation();
         if (register != null && register instanceof Registers.RegisterZp) {
            return new AsmParameter(getAsmParameter(boundVar), true);
         } else {
            throw new RuntimeException("Register Type not implemented " + register);
         }
      } else if (boundValue instanceof PointerDereferenceSimple) {
         PointerDereferenceSimple deref = (PointerDereferenceSimple) boundValue;
         RValue pointer = deref.getPointer();
         if (pointer instanceof Constant) {
            Constant pointerConst = (Constant) pointer;
            if (pointerConst instanceof ConstantInteger) {
               ConstantInteger intPointer = (ConstantInteger) pointerConst;
               String param = String.format("$%x", intPointer.getNumber());
               return new AsmParameter(param, SymbolTypeBasic.BYTE.equals(intPointer.getType(program.getScope())));
            } else {
               throw new RuntimeException("Bound Value Type not implemented " + boundValue);
            }
         } else {
            throw new RuntimeException("Bound Value Type not implemented " + boundValue);
         }
      } else if (boundValue instanceof Constant) {
         Constant boundConst = (Constant) boundValue;
         return new AsmParameter(Pass4CodeGeneration.getConstantValueAsm(program, boundConst, false), SymbolTypeBasic.BYTE.equals(boundConst.getType(program.getScope())));
      } else if (boundValue instanceof Label) {
         String param = ((Label) boundValue).getLocalName().replace('@', 'b').replace(':', '_').replace("$", "_");
         return new AsmParameter(param, false);
      } else {
         throw new RuntimeException("Bound Value Type not implemented " + boundValue);
      }
   }

   /**
    * Get the ASM parameter for a specific bound variable
    * @param boundVar The variable
    * @return The ASM parameter to use in the ASM code
    */
   private String getAsmParameter(Variable boundVar) {
      Scope varScope = boundVar.getScope();
      String asmName = boundVar.getAsmName() == null ? boundVar.getLocalName() : boundVar.getAsmName();
      return getAsmParameter(varScope, asmName);
   }

   /**
    * Get the ASM parameter for a specific bound constant
    * @param boundVar The constant
    * @return The ASM parameter to use in the ASM code
    */
   private String getAsmParameter(ConstantVar boundVar) {
      Scope varScope = boundVar.getScope();
      String asmName = boundVar.getAsmName() == null ? boundVar.getLocalName() : boundVar.getAsmName();
      return getAsmParameter(varScope, asmName);
   }

   /**
    * Get the ASM parameter for a specific bound constant/ variable
    * @param varScope The scope containing the var/const
    * @param asmName The ASM name of the variable (local name or specific ASM name).
    * @return The ASM parameter to use in the ASM code
    */
   private String getAsmParameter(Scope varScope, String asmName) {
      if (!varScope.getRef().equals(scope) && varScope.getRef().getFullName().length() > 0) {
         String param = varScope.getFullName() + "." + asmName
               .replace('@', 'b')
               .replace(':', '_')
               .replace("#","_")
               .replace("$","_");
         //param = ""+((Registers.RegisterZp) register).getZp();
         return param;
      } else {
         String param = asmName.replace('@', 'b').replace(':', '_').replace("#", "_").replace("$", "_");
         //param = ""+((Registers.RegisterZp) register).getZp();
         return param;
      }
   }


   /** A parameter of an ASM instruction from a bound value. */
   public static class AsmParameter {

      private String param;
      private boolean zp;

      public AsmParameter(String param, boolean zp) {
         this.param = param;
         this.zp = zp;
      }

      public String getParam() {
         return param;
      }

      public boolean isZp() {
         return zp;
      }
   }


   /**
    * Generate assembler code for the assembler fragment.
    *
    * @param asm The assembler sequence to generate into.
    */
   public void generate(AsmProgram asm) {
      String signature = this.getSignature();
      Asm6502Parser.FileContext fragmentFile = AsmFragmentManager.getFragment(signature);
      AsmSequenceGenerator asmSequenceGenerator = new AsmSequenceGenerator(signature, this, asm);
      asmSequenceGenerator.generate(fragmentFile);
   }

   private static class AsmSequenceGenerator extends Asm6502BaseVisitor {

      private String signature;
      private AsmProgram program;
      private AsmFragment bindings;

      public AsmSequenceGenerator(String signature, AsmFragment bindings, AsmProgram program) {
         this.signature = signature;
         this.bindings = bindings;
         this.program = program;
      }

      public AsmProgram getProgram() {
         return program;
      }

      public void generate(Asm6502Parser.FileContext context) {
         this.visit(context);
      }

      @Override
      public Object visitLabel(Asm6502Parser.LabelContext ctx) {
         program.addLine(new AsmLabel(ctx.getChild(0).getText()));
         return null;
      }

      @Override
      public Object visitComment(Asm6502Parser.CommentContext ctx) {
         program.addLine(new AsmComment(ctx.getChild(1).getText()));
         return null;
      }


      @Override
      public Object visitInstruction(Asm6502Parser.InstructionContext ctx) {
         Asm6502Parser.ParamModeContext paramModeCtx = ctx.paramMode();
         AsmInstruction instruction;
         if (paramModeCtx == null) {
            AsmInstructionType type = AsmInstructionSet.getInstructionType(
                  ctx.MNEMONIC().getText(),
                  AsmAddressingMode.NON,
                  null,
                  false);
            instruction = new AsmInstruction(type, null);
         } else {
            instruction = (AsmInstruction) this.visit(paramModeCtx);
         }
         if (instruction != null) {
            program.addLine(instruction);
         } else {
            throw new RuntimeException("Error parsing ASM fragment line in dk/camelot64/kickc/asm/fragment/" + signature + ".asm\n - Line: " + ctx.getText());
         }
         return null;
      }

      @Override
      public Object visitModeAbs(Asm6502Parser.ModeAbsContext ctx) {
         return createAsmInstruction(ctx, ctx.expr(), AsmAddressingMode.ABS);
      }

      @Override
      public Object visitModeImm(Asm6502Parser.ModeImmContext ctx) {
         return createAsmInstruction(ctx, ctx.expr(), AsmAddressingMode.IMM);
      }

      @Override
      public Object visitModeAbsX(Asm6502Parser.ModeAbsXContext ctx) {
         return createAsmInstruction(ctx, ctx.expr(), AsmAddressingMode.ABX);
      }

      @Override
      public Object visitModeAbsY(Asm6502Parser.ModeAbsYContext ctx) {
         return createAsmInstruction(ctx, ctx.expr(), AsmAddressingMode.ABY);
      }

      @Override
      public Object visitModeIndY(Asm6502Parser.ModeIndYContext ctx) {
         return createAsmInstruction(ctx, ctx.expr(), AsmAddressingMode.IZY);
      }

      @Override
      public Object visitModeIndX(Asm6502Parser.ModeIndXContext ctx) {
         return createAsmInstruction(ctx, ctx.expr(), AsmAddressingMode.IZX);
      }

      @Override
      public Object visitModeInd(Asm6502Parser.ModeIndContext ctx) {
         return createAsmInstruction(ctx, ctx.expr(), AsmAddressingMode.IND);
      }

      private AsmInstruction createAsmInstruction(
            Asm6502Parser.ParamModeContext ctx,
            Asm6502Parser.ExprContext exprCtx,
            AsmAddressingMode addressingMode) {
         Asm6502Parser.InstructionContext instructionCtx = (Asm6502Parser.InstructionContext) ctx.getParent();
         String mnemonic = instructionCtx.MNEMONIC().getSymbol().getText();
         AsmParameter parameter = (AsmParameter) this.visit(exprCtx);
         AsmInstructionType type = AsmInstructionSet.getInstructionType(
               mnemonic,
               addressingMode,
               parameter.getParam(),
               parameter.isZp());
         if (type == null) {
            throw new RuntimeException("Error in " + signature + ".asm line " + ctx.getStart().getLine() + " - Instruction type unknown " + mnemonic + " " + addressingMode + " " + parameter);
         }
         return new AsmInstruction(type, parameter.getParam());
      }

      @Override
      public AsmParameter visitExprBinary(Asm6502Parser.ExprBinaryContext ctx) {
         AsmParameter left = (AsmParameter) this.visit(ctx.expr(0));
         AsmParameter right = (AsmParameter) this.visit(ctx.expr(1));
         String param = "" + left.getParam() + ctx.getChild(1).getText() + right.getParam();
         boolean zp = left.isZp() && right.isZp();
         return new AsmParameter(param, zp);
      }

      @Override
      public AsmParameter visitExprUnary(Asm6502Parser.ExprUnaryContext ctx) {
         AsmParameter sub = (AsmParameter) this.visit(ctx.expr());
         String param = ctx.getChild(0).getText() + sub.getParam();
         return new AsmParameter(param, sub.isZp());
      }

      @Override
      public AsmParameter visitExprInt(Asm6502Parser.ExprIntContext ctx) {
         Number number = NumberParser.parseLiteral(ctx.NUMINT().getText());
         ConstantInteger intVal = new ConstantInteger(number.intValue());
         boolean isZp = SymbolTypeBasic.BYTE.equals(intVal.getType());
         String param = String.format("$%x", number);
         return new AsmParameter(param, isZp);
      }

      @Override
      public AsmParameter visitExprLabel(Asm6502Parser.ExprLabelContext ctx) {
         String param = ctx.NAME().getSymbol().getText();
         return new AsmParameter(param, false);
      }

      @Override
      public AsmParameter visitExprReplace(Asm6502Parser.ExprReplaceContext ctx) {
         String replaceName = ctx.NAME().getSymbol().getText();
         return bindings.getBoundValue(replaceName);
      }
   }


   public static class UnknownFragmentException extends RuntimeException {

      private String fragmentSignature;

      public UnknownFragmentException(String signature) {
         super("Fragment not found " + signature + ".asm");
         this.fragmentSignature = signature;
      }

      public String getFragmentSignature() {
         return fragmentSignature;
      }
   }

   public static class AluNotApplicableException extends RuntimeException {

      public AluNotApplicableException() {
         super("ALU register not appicable.");
      }

      public AluNotApplicableException(String message) {
         super(message);
      }
   }

}

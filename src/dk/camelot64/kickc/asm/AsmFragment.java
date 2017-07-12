package dk.camelot64.kickc.asm;

import dk.camelot64.kickc.asm.parser.Asm6502BaseVisitor;
import dk.camelot64.kickc.asm.parser.Asm6502Lexer;
import dk.camelot64.kickc.asm.parser.Asm6502Parser;
import dk.camelot64.kickc.icl.*;
import org.antlr.v4.runtime.*;

import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

/**
 * Code Generation Fragment that can handle loading of fragment file and binding of values / registers
 */
public class AsmFragment {

   /**
    * The symbol table.
    */
   private Scope symbols;

   /**
    * Binding of named values in the fragment to values (constants, variables, ...) .
    */
   private Map<String, Value> bindings;

   /**
    * The string signature/name of the fragment fragment.
    */
   private String signature;

   public AsmFragment(StatementConditionalJump conditionalJump, ControlFlowBlock block, Scope symbols, ControlFlowGraph graph) {
      this.bindings = new HashMap<>();
      this.symbols = symbols;
      String conditionalJumpSignature = conditionalJumpSignature(conditionalJump, block, graph);
      setSignature(conditionalJumpSignature);
   }

   public AsmFragment(StatementAssignment assignment, Scope symbols) {
      this.bindings = new HashMap<>();
      this.symbols = symbols;
      setSignature(assignmentSignature(assignment.getLValue(), assignment.getRValue1(), assignment.getOperator(), assignment.getRValue2()));
   }

   public AsmFragment(LValue lValue, RValue rValue, Scope symbols) {
      this.bindings = new HashMap<>();
      this.symbols = symbols;
      setSignature(assignmentSignature(lValue, null, null, rValue));
   }

   public AsmFragment(StatementAssignment assignment, StatementAssignment assignmentAlu, Scope symbols) {
      this.bindings = new HashMap<>();
      this.symbols = symbols;
      setSignature(assignmentWithAluSignature(assignment, assignmentAlu));

   }

   private String assignmentWithAluSignature(StatementAssignment assignment, StatementAssignment assignmentAlu) {
      RValue assignmentRValue2 = assignment.getRValue2();
      RegisterAllocation.Register rVal2Register = symbols.getRegister((Variable) assignmentRValue2);
      if(!rVal2Register.getType().equals(RegisterAllocation.RegisterType.REG_ALU_BYTE)) {
         throw new RuntimeException("Error! ALU register only allowed as rValue2. "+assignment);
      }
      StringBuilder signature = new StringBuilder();
      signature.append(bind(assignment.getLValue()));
      signature.append("=");
      if (assignment.getRValue1() != null) {
         signature.append(bind(assignment.getRValue1()));
      }
      if (assignment.getOperator() != null) {
         signature.append(getOperatorFragmentName(assignment.getOperator()));
      }
      signature.append(assignmentRightSideSignature(assignmentAlu.getRValue1(), assignmentAlu.getOperator(), assignmentAlu.getRValue2()));
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
                  (operator.getOperator().equals(">>")|| operator.getOperator().equals("<<"))) {
         signature.append("2");
      } else if (
            rValue2 instanceof ConstantInteger &&
                  ((ConstantInteger) rValue2).getNumber() == 1 &&
                  operator != null &&
                  (operator.getOperator().equals("-") || operator.getOperator().equals("+")|| operator.getOperator().equals(">>")|| operator.getOperator().equals("<<"))) {
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

   private String conditionalJumpSignature(StatementConditionalJump conditionalJump, ControlFlowBlock block, ControlFlowGraph graph) {
      StringBuilder signature = new StringBuilder();
      if (conditionalJump.getRValue1() != null) {
         signature.append(bind(conditionalJump.getRValue1()));
      }
      if (conditionalJump.getOperator() != null) {
         signature.append(getOperatorFragmentName(conditionalJump.getOperator()));
      }
      if (conditionalJump.getRValue2() instanceof ConstantInteger && ((ConstantInteger) conditionalJump.getRValue2()).getNumber() == 0) {
         signature.append("0");
      } else if (conditionalJump.getRValue2() instanceof ConstantBool) {
         ConstantBool boolValue = (ConstantBool) conditionalJump.getRValue2();
         signature.append(boolValue.toString());
      } else{
         signature.append(bind(conditionalJump.getRValue2()));
      }
      signature.append("_then_");
      Label destination = conditionalJump.getDestination();
      ControlFlowBlock destinationBlock = graph.getBlock(destination);
      String destinationLabel = destination.getFullName();
      if (destinationBlock.hasPhiStatements()) {
         destinationLabel = (destinationBlock.getLabel().getLocalName() + "_from_" + block.getLabel().getLocalName()).replace('@', 'B').replace(':','_');
      }
      signature.append(bind(new Label(destinationLabel, destination.getScope(),false)));
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

   /** Zero page register name indexing. */
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
      if (value instanceof Variable) {
         value = symbols.getRegister((Variable) value);
      } else if (value instanceof PointerDereferenceSimple) {
         PointerDereferenceSimple deref = (PointerDereferenceSimple) value;
         RValue pointer = deref.getPointer();
         if(pointer instanceof Variable) {
            Variable pointerVar = (Variable) pointer;
            RegisterAllocation.Register register = symbols.getRegister(pointerVar);
            value = new PointerDereferenceRegisterZpByte((RegisterAllocation.RegisterZpPointerByte) register);
         }
      } else if (value instanceof PointerDereferenceIndexed) {
         PointerDereferenceIndexed deref = (PointerDereferenceIndexed) value;
         String compositeName =
               "ptr_"
               + bind(deref.getPointer())
               + "_"
               + bind(deref.getIndex());
         return compositeName;
      }

      // Find value if it is already bound
      for (String name : bindings.keySet()) {
         if (value.equals(bindings.get(name))) {
            return name;
         }
      }
      if (value instanceof RegisterAllocation.Register) {
         RegisterAllocation.Register register = (RegisterAllocation.Register) value;
         if (RegisterAllocation.RegisterType.ZP_BYTE.equals(register.getType())) {
            String name = "zpby" + nextZpByteIdx++;
            bindings.put(name, value);
            return name;
         } else if (RegisterAllocation.RegisterType.ZP_WORD.equals(register.getType())) {
               String name = "zpwo" + nextZpWordIdx++;
               bindings.put(name, value);
               return name;
         } else if (RegisterAllocation.RegisterType.ZP_BOOL.equals(register.getType())) {
            String name = "zpbo" + nextZpBoolIdx++;
            bindings.put(name, value);
            return name;
         } else if (RegisterAllocation.RegisterType.REG_X_BYTE.equals(register.getType())) {
            String name = "xby";
            bindings.put(name, value);
            return name;
         } else if (RegisterAllocation.RegisterType.REG_Y_BYTE.equals(register.getType())) {
            String name = "yby";
            bindings.put(name, value);
            return name;
         } else if (RegisterAllocation.RegisterType.REG_A_BYTE.equals(register.getType())) {
            String name = "aby";
            bindings.put(name, value);
            return name;
         } else if (RegisterAllocation.RegisterType.ZP_PTR_BYTE.equals(register.getType())) {
            String name = "zpptrby" + nextZpPtrIdx++;
            bindings.put(name, value);
            return name;
         }
      } else if (value instanceof PointerDereferenceRegisterZpByte) {
         RegisterAllocation.Register register = ((PointerDereferenceRegisterZpByte) value).getPointerRegister();
         if (RegisterAllocation.RegisterType.ZP_PTR_BYTE.equals(register.getType())) {
            String name = "zpiby" + nextZpPtrIdx++;
            bindings.put(name, value);
            return name;
         }
      } else if (value instanceof PointerDereferenceSimple) {
         PointerDereferenceSimple deref = (PointerDereferenceSimple) value;
         RValue pointer = deref.getPointer();
         if(pointer instanceof Constant) {
            Constant pointerConst = (Constant) pointer;
            if (pointerConst instanceof ConstantInteger) {
               String name = "coptr" + nextConstByteIdx++;
               bindings.put(name, value);
               return name;
            }
         }
      } else if (value instanceof ConstantInteger) {
         ConstantInteger intValue = (ConstantInteger) value;
         if (SymbolTypeBasic.BYTE.equals(intValue.getType())) {
            String name = "coby" + nextConstByteIdx++;
            bindings.put(name, value);
            return name;
         } else if (SymbolTypeBasic.WORD.equals(intValue.getType())) {
            String name = "cowo" + nextConstByteIdx++;
            bindings.put(name, value);
            return name;
         }
      } else if (value instanceof Label) {
         String name = "la" + nextLabelIdx++;
         bindings.put(name, value);
         return name;
      }
      throw new RuntimeException("Binding of value type not supported " + value);
   }

   /**
    * Get the value to replace a bound name with from the fragment signature
    *
    * @param name The name of the bound value in the fragment
    * @return The bound value to use in the generated ASM code
    */
   public String getBoundValue(String name) {
      Value boundValue = getBinding(name);
      if (boundValue == null) {
         throw new RuntimeException("Binding not found in fragment '" + name + "'");
      }
      String bound;
      if (boundValue instanceof RegisterAllocation.Register) {
         RegisterAllocation.Register register = (RegisterAllocation.Register) boundValue;
         if (register instanceof RegisterAllocation.RegisterZpByte) {
            bound = Integer.toString(((RegisterAllocation.RegisterZpByte) register).getZp());
         } else if (register instanceof RegisterAllocation.RegisterZpWord) {
            bound = Integer.toString(((RegisterAllocation.RegisterZpWord) register).getZp());
         } else if (register instanceof RegisterAllocation.RegisterZpBool) {
            bound = Integer.toString(((RegisterAllocation.RegisterZpBool) register).getZp());
         } else if (register instanceof RegisterAllocation.RegisterZpPointerByte) {
            bound = Integer.toString(((RegisterAllocation.RegisterZpPointerByte) register).getZp());
         } else {
            throw new RuntimeException("Register Type not implemented " + register);
         }
      } else if (boundValue instanceof PointerDereferenceRegisterZpByte) {
         PointerDereferenceRegisterZpByte deref = (PointerDereferenceRegisterZpByte) boundValue;
         RegisterAllocation.RegisterZpPointerByte register = deref.getPointerRegister();
         bound = Integer.toString(register.getZp());
      } else if (boundValue instanceof PointerDereferenceSimple) {
         PointerDereferenceSimple deref = (PointerDereferenceSimple) boundValue;
         RValue pointer = deref.getPointer();
         if(pointer instanceof Constant) {
            Constant pointerConst = (Constant) pointer;
            if (pointerConst instanceof ConstantInteger) {
               ConstantInteger intPointer = (ConstantInteger) pointerConst;
               bound = Integer.toString(intPointer.getNumber());
            } else {
               throw new RuntimeException("Bound Value Type not implemented " + boundValue);
            }
         } else {
            throw new RuntimeException("Bound Value Type not implemented " + boundValue);
         }
      } else if (boundValue instanceof ConstantInteger) {
         ConstantInteger boundInt = (ConstantInteger) boundValue;
         if (boundInt.getType().equals(SymbolTypeBasic.BYTE)) {
            bound = Integer.toString(boundInt.getNumber());
         } else {
            bound = Integer.toString(boundInt.getNumber());
         }
      } else if (boundValue instanceof Label) {
         bound = ((Label) boundValue).getFullName().replace('@', 'B').replace(':','_');
      } else {
         throw new RuntimeException("Bound Value Type not implemented " + boundValue);
      }
      return bound;
   }

   /**
    * Generate assembler code for the assembler fragment.
    *
    * @param asm The assembler sequence to generate into.
    */
   public void generate(AsmProgram asm) {
      String signature = this.getSignature();
      ClassLoader classLoader = this.getClass().getClassLoader();
      final URL fragmentResource = classLoader.getResource("dk/camelot64/kickc/asm/fragment/" + signature + ".asm");
      if (fragmentResource == null) {
         System.out.println("Fragment not found " + fragmentResource);
         asm.addComment("Fragment not found: " + signature);
         return;
      }

      try {
         InputStream fragmentStream = fragmentResource.openStream();
         Asm6502Lexer lexer = new Asm6502Lexer(CharStreams.fromStream(fragmentStream));
         Asm6502Parser parser = new Asm6502Parser(new CommonTokenStream(lexer));
         parser.addErrorListener(new BaseErrorListener() {
            @Override
            public void syntaxError(Recognizer<?, ?> recognizer, Object offendingSymbol, int line, int charPositionInLine, String msg, RecognitionException e) {
               throw new RuntimeException("Error parsing fragment file " + fragmentResource + "\n - Line: " + line + "\n - Message: " + msg);
            }
         });
         parser.setBuildParseTree(true);
         Asm6502Parser.FileContext file = parser.file();
         AsmSequenceGenerator asmSequenceGenerator = new AsmSequenceGenerator(fragmentResource, asm);
         asmSequenceGenerator.generate(file);
         fragmentStream.close();
      } catch (IOException e) {
         throw new RuntimeException("Error reading code fragment " + fragmentResource);
      }

   }

   private class AsmSequenceGenerator extends Asm6502BaseVisitor {

      private URL fragmentResource;
      private AsmProgram program;

      public AsmSequenceGenerator(URL fragmentResource, AsmProgram program) {
         this.fragmentResource = fragmentResource;
         this.program = program;
      }

      public AsmSequenceGenerator(URL fragmentResource) {
         this.fragmentResource = fragmentResource;
         this.program = new AsmProgram();
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
            AsmInstructionType type = AsmInstuctionSet.getInstructionType(ctx.MNEMONIC().getText(), AsmAddressingMode.NON, null);
            instruction = new AsmInstruction(type, null, 1);
         } else {
            instruction = (AsmInstruction) this.visit(paramModeCtx);
         }
         if (instruction != null) {
            program.addLine(instruction);
         } else {
            throw new RuntimeException("Error parsing ASM fragment line in " + fragmentResource.toString() + "\n - Line: " + ctx.getText());
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

      private AsmInstruction createAsmInstruction(Asm6502Parser.ParamModeContext ctx, Asm6502Parser.ExprContext exprCtx, AsmAddressingMode addressingMode) {
         Asm6502Parser.InstructionContext instructionCtx = (Asm6502Parser.InstructionContext) ctx.getParent();
         String mnemonic = instructionCtx.MNEMONIC().getSymbol().getText();
         String parameter = (String) this.visit(exprCtx);
         AsmInstructionType type = AsmInstuctionSet.getInstructionType(mnemonic, addressingMode, parameter);
         return new AsmInstruction(type, parameter, 1);
      }


      @Override
      public Object visitExprBinary(Asm6502Parser.ExprBinaryContext ctx) {
         Object left = this.visit(ctx.expr(0));
         Object right = this.visit(ctx.expr(1));
         return "" + left + ctx.getChild(1).getText() + right;
      }

      @Override
      public Object visitExprUnary(Asm6502Parser.ExprUnaryContext ctx) {
         Object sub = this.visit(ctx.expr());
         return ctx.getChild(0).getText() + sub;
      }

      @Override
      public Object visitExprInt(Asm6502Parser.ExprIntContext ctx) {
         return NumberParser.parseLiteral(ctx.NUMINT().getText()).toString();
      }

      @Override
      public Object visitExprLabel(Asm6502Parser.ExprLabelContext ctx) {
         return ctx.NAME().getSymbol().getText();
      }

      @Override
      public Object visitExprReplace(Asm6502Parser.ExprReplaceContext ctx) {
         String replaceName = ctx.NAME().getSymbol().getText();
         return AsmFragment.this.getBoundValue(replaceName);
      }
   }


}

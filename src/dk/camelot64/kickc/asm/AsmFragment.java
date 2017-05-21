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
   private SymbolTable symbols;

   /**
    * Binding of named values in the fragment to values (constants, variables, ...) .
    */
   private Map<String, Value> bindings;

   /**
    * The string signature/name of the fragment fragment.
    */
   private String signature;

   public AsmFragment(StatementConditionalJump conditionalJump, SymbolTable symbols, ControlFlowGraph graph, ControlFlowBlock block) {
      this.bindings = new HashMap<>();
      this.symbols = symbols;
      StringBuilder signature = new StringBuilder();
      if (conditionalJump.getRValue1() != null) {
         signature.append(bind(conditionalJump.getRValue1()));
      }
      if (conditionalJump.getOperator() != null) {
         signature.append(getOperatorFragmentName(conditionalJump.getOperator()));
      }
      if (conditionalJump.getRValue2() instanceof ConstantInteger && ((ConstantInteger) conditionalJump.getRValue2()).getNumber() == 0) {
         signature.append("0");
      } else {
         signature.append(bind(conditionalJump.getRValue2()));
      }
      signature.append("_then_");
      Label destination = conditionalJump.getDestination();
      ControlFlowBlock destinationBlock = graph.getBlock(destination);
      String destinationLabel = destination.getName();
      if(destinationBlock.hasPhiStatements()) {
         destinationLabel = destination.getName()+"_from_"+block.getLabel().getName();
      }
      signature.append(bind(new Label(destinationLabel, false)));
      setSignature(signature.toString());
   }

   public AsmFragment(StatementAssignment assignment, SymbolTable symbols) {
      this.bindings = new HashMap<>();
      this.symbols = symbols;
      setSignature(assignmentSignature(assignment.getLValue(), assignment.getRValue1(), assignment.getOperator(), assignment.getRValue2()));
   }

   public AsmFragment(LValue lValue, RValue rValue, SymbolTable symbols) {
      this.bindings = new HashMap<>();
      this.symbols = symbols;
      setSignature(assignmentSignature(lValue, null, null, rValue));
   }

   private String assignmentSignature(LValue lValue, RValue rValue1, Operator operator, RValue rValue2) {
      StringBuilder signature = new StringBuilder();
      signature.append(bind(lValue));
      signature.append("=");
      if (rValue1 != null) {
         signature.append(bind(rValue1));
      }
      if (operator != null) {
         signature.append(getOperatorFragmentName(operator));
      }
      if (
            rValue2 instanceof ConstantInteger &&
                  ((ConstantInteger) rValue2).getNumber() == 1 &&
                  operator != null &&
                  (operator.getOperator().equals("-") || operator.getOperator().equals("+"))) {
         signature.append("1");
      } else {
         signature.append(bind(rValue2));
      }
      return signature.toString();
   }

   private static String getOperatorFragmentName(Operator operator) {
      String op = operator.getOperator();
      switch (op) {
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
    * Zero page byte register name indexing.
    */
   private int nextZpByteIdx = 1;

   /**
    * Zero page bool register name indexing.
    */
   private int nextZpBoolIdx = 1;

   /**
    * Constant byte indexing.
    */
   private int nextConstByteIdx = 1;

   /**
    * Label indexing.
    */
   private int nextLabelIdx = 1;

   /**
    * Add bindings of a value.
    *
    * @param value The value to bind.
    * @return The bound name of the value. If the value has already been bound the existing bound name is returned.
    */
   public String bind(Value value) {
      // Find value if it is already bound
      for (String name : bindings.keySet()) {
         if (value.equals(bindings.get(name))) {
            return name;
         }
      }
      if (value instanceof Variable) {
         RegisterAllocation.Register register = symbols.getRegister((Variable) value);
         if (RegisterAllocation.RegisterType.ZP_BYTE.equals(register.getType())) {
            String name = "zpby" + nextZpByteIdx++;
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
         } else {
            throw new RuntimeException("Binding of register type not supported " + register.getType());
         }
      } else if (value instanceof ConstantInteger) {
         ConstantInteger intValue = (ConstantInteger) value;
         if (intValue.getType().equals(SymbolType.BYTE)) {
            String name = "coby" + nextConstByteIdx++;
            bindings.put(name, value);
            return name;
         } else {
            throw new RuntimeException("Binding of word integers not supported " + intValue);
         }
      } else if (value instanceof Label) {
         String name = "la" + nextLabelIdx++;
         bindings.put(name, value);
         return name;
      } else {
         throw new RuntimeException("Binding of value type not supported " + value);
      }
   }

   /**
    * Get the value to replace a bound name with from the fragment signature
    *
    * @param name The name of the bound value in the fragment
    * @return The bound value to use in the generated ASM code
    */
   public String getBoundValue(String name) {
      Value boundValue = getBinding(name);
      String bound;
      if (boundValue instanceof Variable) {
         RegisterAllocation.Register register = symbols.getRegister((Variable) boundValue);
         if (register instanceof RegisterAllocation.RegisterZpByte) {
            bound = Integer.toString(((RegisterAllocation.RegisterZpByte) register).getZp());
         } else if (register instanceof RegisterAllocation.RegisterZpBool) {
            bound = Integer.toString(((RegisterAllocation.RegisterZpBool) register).getZp());
         } else {
            throw new RuntimeException("Register Type not implemented " + register);
         }
      } else if (boundValue instanceof ConstantInteger) {
         ConstantInteger boundInt = (ConstantInteger) boundValue;
         if (boundInt.getType().equals(SymbolType.BYTE)) {
            bound = Integer.toString(boundInt.getNumber());
         } else {
            throw new RuntimeException("Bound Value Type not implemented " + boundValue);
         }
      } else if (boundValue instanceof Label) {
         bound = ((Label) boundValue).getName().replace('@', 'B');
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
               throw new RuntimeException("Error parsing fragment file "+fragmentResource+"\n - Line: "+line+"\n - Message: "+msg);
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
         if(paramModeCtx==null) {
            AsmInstructionType type = AsmInstuctionSet.getInstructionType(ctx.MNEMONIC().getText(), AsmAddressingMode.NON, null);
            instruction = new AsmInstruction(type, null, 1);
         } else {
            instruction = (AsmInstruction) this.visit(paramModeCtx);
         }
         if(instruction!=null) {
            program.addLine(instruction);
         } else {
            throw new RuntimeException("Error parsing ASM fragment line in "+fragmentResource.toString()+"\n - Line: "+ctx.getText());
         }
         return null;
      }

      @Override
      public Object visitModeAbs(Asm6502Parser.ModeAbsContext ctx) {
         return createAsmInstruction(ctx, ctx.param(), AsmAddressingMode.ABS);
      }

      @Override
      public Object visitModeImm(Asm6502Parser.ModeImmContext ctx) {
         return createAsmInstruction(ctx, ctx.param(), AsmAddressingMode.IMM);
      }

      @Override
      public Object visitModeAbsX(Asm6502Parser.ModeAbsXContext ctx) {
         return createAsmInstruction(ctx, ctx.param(), AsmAddressingMode.ABX);
      }

      @Override
      public Object visitModeAbsY(Asm6502Parser.ModeAbsYContext ctx) {
         return createAsmInstruction(ctx, ctx.param(), AsmAddressingMode.ABY);
      }

      @Override
      public Object visitModeIndY(Asm6502Parser.ModeIndYContext ctx) {
         return createAsmInstruction(ctx, ctx.param(), AsmAddressingMode.IZY);
      }

      @Override
      public Object visitModeIndX(Asm6502Parser.ModeIndXContext ctx) {
         return createAsmInstruction(ctx, ctx.param(), AsmAddressingMode.IZX);
      }

      @Override
      public Object visitModeInd(Asm6502Parser.ModeIndContext ctx) {
         return createAsmInstruction(ctx, ctx.param(), AsmAddressingMode.IND);
      }

      private AsmInstruction createAsmInstruction(Asm6502Parser.ParamModeContext ctx, Asm6502Parser.ParamContext paramCtx, AsmAddressingMode addressingMode) {
         Asm6502Parser.InstructionContext instructionCtx = (Asm6502Parser.InstructionContext) ctx.getParent();
         String mnemonic = instructionCtx.MNEMONIC().getSymbol().getText();
         String parameter = (String) this.visit(paramCtx);
         AsmInstructionType type = AsmInstuctionSet.getInstructionType(mnemonic, addressingMode, parameter);
         return new AsmInstruction(type, parameter, 1);
      }

      @Override
      public Object visitParamInt(Asm6502Parser.ParamIntContext ctx) {
         return NumberParser.parseLiteral(ctx.NUMINT().getText()).toString();
      }

      @Override
      public Object visitParamLabel(Asm6502Parser.ParamLabelContext ctx) {
         return ctx.NAME().getSymbol().getText();
      }

      @Override
      public Object visitParamReplace(Asm6502Parser.ParamReplaceContext ctx) {
         String replaceName = ctx.NAME().getSymbol().getText();
         return AsmFragment.this.getBoundValue(replaceName);
      }
   }


}

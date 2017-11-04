package dk.camelot64.kickc.fragment;

import dk.camelot64.kickc.NumberParser;
import dk.camelot64.kickc.asm.*;
import dk.camelot64.kickc.asm.parser.Asm6502BaseVisitor;
import dk.camelot64.kickc.asm.parser.Asm6502Parser;
import dk.camelot64.kickc.model.*;

import java.util.Map;

/**
 * Code Generation Fragment that can handle loading of fragment file and binding of values / registers
 */
public class AsmFragment {

   /** The symbol table. */
   private Program program;

   /** The name of the fragment used in error messages. */
   private String name;

   /** The fragment template ASM code. */
   private Asm6502Parser.FileContext fragmentFile;

   /** Binding of named values in the fragment to values (constants, variables, ...) . */
   private Map<String, Value> bindings;

   /** The scope containing the fragment. Used when referencing symbols defined in other scopes. */
   private ScopeRef codeScopeRef;

   public AsmFragment(
         Program program,
         String name,
         ScopeRef codeScopeRef,
         Asm6502Parser.FileContext fragmentFile,
         Map<String, Value> bindings) {
      this.program = program;
      this.name = name;
      this.fragmentFile = fragmentFile;
      this.bindings = bindings;
      this.codeScopeRef = codeScopeRef;
   }

   public Value getBinding(String name) {
      return bindings.get(name);
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
         throw new RuntimeException("Binding '" + name + "' not found in fragment " + name + ".asm");
      }
      if (boundValue instanceof Variable) {
         Variable boundVar = (Variable) boundValue;
         Registers.Register register = boundVar.getAllocation();
         if (register != null && register instanceof Registers.RegisterZp) {
            return new AsmParameter(getAsmParamName(boundVar), true);
         } else {
            throw new RuntimeException("Register Type not implemented " + register);
         }
      } else if (boundValue instanceof ConstantVar) {
         ConstantVar constantVar = (ConstantVar) boundValue;
         String constantValueAsm = getAsmConstant(program, constantVar.getRef(), 99, codeScopeRef);
         boolean constantValueZp = SymbolTypeBasic.BYTE.equals(constantVar.getType(program.getScope()));
         return new AsmParameter(constantValueAsm, constantValueZp);
      } else if (boundValue instanceof ConstantValue) {
         ConstantValue boundConst = (ConstantValue) boundValue;
         String constantValueAsm = getAsmConstant(program, boundConst, 99, codeScopeRef);
         boolean constantValueZp = SymbolTypeBasic.BYTE.equals(boundConst.getType(program.getScope()));
         return new AsmParameter(constantValueAsm, constantValueZp);
      } else if (boundValue instanceof Label) {
         String param = ((Label) boundValue).getLocalName().replace('@', 'b').replace(':', '_').replace("$", "_");
         return new AsmParameter(param, false);
      } else {
          throw new RuntimeException("Bound Value Type not implemented " + boundValue);
      }
   }

   /**
    * Get ASM code for a constant value
    *
    * @param value The constant value
    * @param precedence The precedence of the outer expression operator. Used to generate perenthesis when needed.
    * @param codeScope The scope containing the code being generated. Used for adding scope to the name when needed (eg. line.x1 when referencing x1 variable inside line scope from outside line scope).
    *
    * @return The ASM string representing the constant value
    */
   public static String getAsmConstant(Program program, ConstantValue value, int precedence, ScopeRef codeScope) {
      if (value instanceof ConstantRef) {
         ConstantVar constantVar = program.getScope().getConstant((ConstantRef) value);
         String asmName = constantVar.getAsmName() == null ? constantVar.getLocalName() : constantVar.getAsmName();
         return getAsmParamName(constantVar.getScope().getRef(), asmName, codeScope);
      } else if (value instanceof ConstantInteger) {
         return getAsmNumber(((ConstantInteger) value).getNumber());
      } else if (value instanceof ConstantChar) {
         return "'"+((ConstantChar) value).getValue()+"'";
      } else if (value instanceof ConstantString) {
         return "\""+((ConstantString) value).getValue()+"\"";
      } else if (value instanceof ConstantUnary) {
         ConstantUnary unary = (ConstantUnary) value;
         Operator operator = unary.getOperator();
         boolean parenthesis = operator.getPrecedence()>precedence;
         return
               (parenthesis ? "(" : "") +
                     operator.getOperator() +
                     getAsmConstant(program, unary.getOperand(), operator.getPrecedence(), codeScope) +
                     (parenthesis? ")" : "");
      } else if (value instanceof ConstantBinary) {
         ConstantBinary binary = (ConstantBinary) value;
         Operator operator = binary.getOperator();
         boolean parenthesis = operator.getPrecedence()>precedence;
         return
               (parenthesis? "(" : "") +
                     getAsmConstant(program, binary.getLeft(), operator.getPrecedence(), codeScope) +
                     operator.getOperator() +
                     getAsmConstant(program, binary.getRight(), operator.getPrecedence(), codeScope) +
                     (parenthesis? ")" : "");
      } else {
         throw new RuntimeException("Constant type not supported " + value);
      }
   }

   public static String getAsmNumber(Number number) {
      if(number instanceof Integer) {
         if(number.intValue()>=0 && number.intValue()<=9) {
            return String.format("%d", number.intValue());
         } else {
            return String.format("$%x", number);
         }
      }
      throw new RuntimeException("Unsupported number type "+number);
   }

   /**
    * Get the ASM parameter for a specific bound variable
    * @param boundVar The variable
    * @return The ASM parameter to use in the ASM code
    */
   private String getAsmParamName(Variable boundVar) {
      ScopeRef varScopeRef = boundVar.getScope().getRef();
      String asmName = boundVar.getAsmName() == null ? boundVar.getLocalName() : boundVar.getAsmName();
      return getAsmParamName(varScopeRef, asmName, codeScopeRef);
   }

   /**
    * Get the ASM parameter for a specific bound constant
    * @param boundVar The constant
    * @return The ASM parameter to use in the ASM code
    */
   private String getAsmParamName(ConstantVar boundVar) {
      ScopeRef varScopeRef = boundVar.getScope().getRef();
      String asmName = boundVar.getAsmName() == null ? boundVar.getLocalName() : boundVar.getAsmName();
      return getAsmParamName(varScopeRef, asmName, codeScopeRef);
   }

   /**
    * Get the ASM parameter for a specific bound constant/ variable
    * @param varScopeRef The scope containing the var/const
    * @param asmName The ASM name of the variable (local name or specific ASM name).
    * @param codeScopeRef The scope containing the code being generated. Used for adding scope to the name when needed (eg. line.x1 when referencing x1 variable inside line scope from outside line scope).
    * @return The ASM parameter to use in the ASM code
    */
   private static String getAsmParamName(ScopeRef varScopeRef, String asmName, ScopeRef codeScopeRef) {
      if (!varScopeRef.equals(codeScopeRef) && varScopeRef.getFullName().length() > 0) {
         String param = varScopeRef.getFullName() + "." + asmName
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

   public String getName() {
      return name;
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
      AsmSequenceGenerator asmSequenceGenerator = new AsmSequenceGenerator(name, this, asm);
      asmSequenceGenerator.generate(fragmentFile);
   }

   private static class AsmSequenceGenerator extends Asm6502BaseVisitor {

      private String name;
      private AsmProgram program;
      private AsmFragment bindings;

      public AsmSequenceGenerator(String name, AsmFragment bindings, AsmProgram program) {
         this.name = name;
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
            throw new RuntimeException("Error parsing ASM fragment line in dk/camelot64/kickc/fragment/asm/" + name + ".asm\n - Line: " + ctx.getText());
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
            throw new RuntimeException("Error in " + name + ".asm line " + ctx.getStart().getLine() + " - Instruction type unknown " + mnemonic + " " + addressingMode + " " + parameter);
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
         String param = getAsmNumber(number);
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

   public static class AluNotApplicableException extends RuntimeException {

      public AluNotApplicableException() {
         super("ALU register not appicable.");
      }

      public AluNotApplicableException(String message) {
         super(message);
      }
   }

}

package dk.camelot64.kickc.fragment;

import dk.camelot64.kickc.NumberParser;
import dk.camelot64.kickc.asm.*;
import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantValue;
import dk.camelot64.kickc.model.symbols.ConstantVar;
import dk.camelot64.kickc.model.symbols.Label;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.ScopeRef;
import dk.camelot64.kickc.model.values.Value;
import dk.camelot64.kickc.parser.KickCBaseVisitor;
import dk.camelot64.kickc.parser.KickCParser;

import java.util.ArrayList;
import java.util.Map;

/** ASM Code Fragment with register/variable bindings that can be used for generating ASM code for a specific statement . */
public class AsmFragmentInstance {

   /** The symbol table. */
   private Program program;

   /** The name of the fragment used in error messages. */
   private String name;

   /** The fragment template for the ASM code. */
   private AsmFragmentTemplate fragmentTemplate;

   /** Binding of named values in the fragment to values (constants, variables, ...) . */
   private Map<String, Value> bindings;

   /** The scope containing the fragment. Used when referencing symbols defined in other scopes. */
   private ScopeRef codeScopeRef;

   public AsmFragmentInstance(
         Program program,
         String name,
         ScopeRef codeScopeRef,
         AsmFragmentTemplate fragmentTemplate,
         Map<String, Value> bindings) {
      this.program = program;
      this.name = name;
      this.fragmentTemplate = fragmentTemplate;
      this.bindings = bindings;
      this.codeScopeRef = codeScopeRef;
   }

   public Value getBinding(String name) {
      return bindings.get(name);
   }

   /**
    * Get the value to replace a bound name with from the fragment signature
    *
    * @param name The name of the bound value in the fragment
    * @return The bound value to use in the generated ASM code
    */
   public AsmFragmentParameter getBoundValue(String name) {
      Value boundValue = null;
      if(name.length() == 2) {
         // Short name!
         for(String boundName : bindings.keySet()) {
            if(boundName.substring(boundName.length() - 2).equals(name)) {
               boundValue = getBinding(boundName);
               break;
            }
         }
      } else {
         // Long name
         boundValue = getBinding(name);
      }

      if(boundValue == null) {
         throw new RuntimeException("Binding '" + name + "' not found in fragment " + this.name );
      }
      if(boundValue instanceof Variable) {
         Variable boundVar = (Variable) boundValue;
         Registers.Register register = boundVar.getAllocation();
         if(register != null && register instanceof Registers.RegisterZp) {
            return new AsmFragmentParameter(AsmFormat.getAsmParamName(boundVar, codeScopeRef), true);
         } else {
            throw new RuntimeException("Register Type not implemented " + register);
         }
      } else if(boundValue instanceof ConstantVar) {
         ConstantVar constantVar = (ConstantVar) boundValue;
         String constantValueAsm = AsmFormat.getAsmConstant(program, constantVar.getRef(), 99, codeScopeRef);
         boolean constantValueZp = SymbolType.BYTE.equals(constantVar.getType());
         return new AsmFragmentParameter(constantValueAsm, constantValueZp);
      } else if(boundValue instanceof ConstantValue) {
         ConstantValue boundConst = (ConstantValue) boundValue;
         String constantValueAsm = AsmFormat.getAsmConstant(program, boundConst, 99, codeScopeRef);
         boolean constantValueZp = SymbolType.BYTE.equals(boundConst.getType(program.getScope()));
         return new AsmFragmentParameter(constantValueAsm, constantValueZp);
      } else if(boundValue instanceof Label) {
         String param = ((Label) boundValue).getLocalName().replace('@', 'b').replace(':', '_').replace("$", "_");
         return new AsmFragmentParameter(param, false);
      } else {
         throw new RuntimeException("Bound Value Type not implemented " + boundValue);
      }
   }

   public String getFragmentName() {
      return name;
   }

   /**
    * Generate assembler code for the assembler fragment.
    *
    * @param asm The assembler sequence to generate into.
    */
   public void generate(AsmProgram asm) {
      AsmSequenceGenerator asmSequenceGenerator = new AsmSequenceGenerator(name, this, asm);
      asmSequenceGenerator.generate(fragmentTemplate.getBodyAsm());
   }

   /**
    * A parameter of an ASM instruction from a bound value.
    */
   public static class AsmFragmentParameter {

      private String param;
      private boolean zp;

      public AsmFragmentParameter(String param, boolean zp) {
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

   private static class AsmSequenceGenerator extends KickCBaseVisitor {

      private String name;
      private AsmProgram program;
      private AsmFragmentInstance bindings;

      public AsmSequenceGenerator(String name, AsmFragmentInstance bindings, AsmProgram program) {
         this.name = name;
         this.bindings = bindings;
         this.program = program;
      }

      public AsmProgram getProgram() {
         return program;
      }

      public void generate(KickCParser.AsmLinesContext context) {
         this.visit(context);
      }

      @Override
      public Object visitAsmLabelName(KickCParser.AsmLabelNameContext ctx) {
         program.addLine(new AsmLabel(ctx.NAME().getText()));
         return null;
      }

      @Override
      public Object visitAsmLabelMulti(KickCParser.AsmLabelMultiContext ctx) {
         String label = "!";
         if(ctx.NAME()!=null) {
            label = label + ctx.NAME().getText();
         }
         program.addLine(new AsmLabel(label));
         return null;
      }

      @Override
      public Object visitAsmBytes(KickCParser.AsmBytesContext ctx) {
         ArrayList<String> values = new ArrayList<>();
         for(int i = 1; i < ctx.getChildCount(); i = i + 2) {
            values.add(ctx.getChild(i).getText());
         }
         program.addLine(new AsmDataNumeric(null, AsmDataNumeric.Type.BYTE, values));
         return null;
      }

      @Override
      public Object visitAsmInstruction(KickCParser.AsmInstructionContext ctx) {
         KickCParser.AsmParamModeContext paramModeCtx = ctx.asmParamMode();
         AsmInstruction instruction;
         if(paramModeCtx == null) {
            AsmInstructionType type = AsmInstructionSet.getInstructionType(
                  ctx.MNEMONIC().getText(),
                  AsmAddressingMode.NON,
                  false);
            instruction = new AsmInstruction(type, null);
         } else {
            instruction = (AsmInstruction) this.visit(paramModeCtx);
         }
         if(instruction != null) {
            program.addLine(instruction);
         } else {
            throw new RuntimeException("Error parsing ASM fragment line in dk/camelot64/kickc/fragment/asm/" + name + ".asm\n - Line: " + ctx.getText());
         }
         return null;
      }

      @Override
      public Object visitAsmModeAbs(KickCParser.AsmModeAbsContext ctx) {
         return createAsmInstruction(ctx, ctx.asmExpr(), AsmAddressingMode.ABS);
      }

      @Override
      public Object visitAsmModeImm(KickCParser.AsmModeImmContext ctx) {
         return createAsmInstruction(ctx, ctx.asmExpr(), AsmAddressingMode.IMM);
      }

      @Override
      public Object visitAsmModeAbsXY(KickCParser.AsmModeAbsXYContext ctx) {
         String xy = ctx.getChild(ctx.getChildCount() - 1).getText();
         if(xy.equals("x")) {
            return createAsmInstruction(ctx, ctx.asmExpr(), AsmAddressingMode.ABX);
         } else if(xy.equals("y")) {
            return createAsmInstruction(ctx, ctx.asmExpr(), AsmAddressingMode.ABY);
         } else {
            throw new RuntimeException("Unknown addressing mode " + ctx.getText());
         }
      }

      @Override
      public Object visitAsmModeIndIdxXY(KickCParser.AsmModeIndIdxXYContext ctx) {
         String xy = ctx.getChild(ctx.getChildCount() - 1).getText();
         if(xy.equals("y")) {
            return createAsmInstruction(ctx, ctx.asmExpr(), AsmAddressingMode.IZY);
         } else {
            throw new RuntimeException("Unknown addressing mode " + ctx.getText());
         }
      }

      @Override
      public Object visitAsmModeIdxIndXY(KickCParser.AsmModeIdxIndXYContext ctx) {
         String xy = ctx.getChild(ctx.getChildCount() - 1).getText();
         if(xy.equals("x")) {
            return createAsmInstruction(ctx, ctx.asmExpr(), AsmAddressingMode.IZX);
         } else {
            throw new RuntimeException("Unknown addressing mode " + ctx.getText());
         }
      }

      @Override
      public Object visitAsmModeInd(KickCParser.AsmModeIndContext ctx) {
         return createAsmInstruction(ctx, ctx.asmExpr(), AsmAddressingMode.IND);
      }

      private AsmInstruction createAsmInstruction(
            KickCParser.AsmParamModeContext ctx,
            KickCParser.AsmExprContext exprCtx,
            AsmAddressingMode addressingMode) {
         KickCParser.AsmInstructionContext instructionCtx = (KickCParser.AsmInstructionContext) ctx.getParent();
         String mnemonic = instructionCtx.MNEMONIC().getSymbol().getText();
         AsmFragmentParameter parameter = (AsmFragmentParameter) this.visit(exprCtx);
         AsmInstructionType type = AsmInstructionSet.getInstructionType(
               mnemonic,
               addressingMode,
               parameter.isZp());
         if(type == null) {
            throw new RuntimeException("Error in " + name + ".asm line " + ctx.getStart().getLine() + " - Instruction type unknown " + mnemonic + " " + addressingMode + " " + parameter);
         }
         return new AsmInstruction(type, parameter.getParam());
      }

      @Override
      public AsmFragmentParameter visitAsmExprBinary(KickCParser.AsmExprBinaryContext ctx) {
         AsmFragmentParameter left = (AsmFragmentParameter) this.visit(ctx.asmExpr(0));
         AsmFragmentParameter right = (AsmFragmentParameter) this.visit(ctx.asmExpr(1));
         String param = "" + left.getParam() + ctx.getChild(1).getText() + right.getParam();
         boolean zp = left.isZp() && right.isZp();
         return new AsmFragmentParameter(param, zp);
      }

      @Override
      public AsmFragmentParameter visitAsmExprUnary(KickCParser.AsmExprUnaryContext ctx) {
         AsmFragmentParameter sub = (AsmFragmentParameter) this.visit(ctx.asmExpr());
         String operator = ctx.getChild(0).getText();
         String param = operator + sub.getParam();
         boolean isZp = sub.isZp();
         if(operator.equals("<") || operator.equals(">")) {
            isZp = true;
         }
         return new AsmFragmentParameter(param, isZp);
      }

      @Override
      public Object visitAsmExprPar(KickCParser.AsmExprParContext ctx) {
         AsmFragmentParameter sub = (AsmFragmentParameter) this.visit(ctx.asmExpr());
         String param = "[" + sub.getParam() + "]";
         return new AsmFragmentParameter(param, sub.isZp());
      }

      @Override
      public AsmFragmentParameter visitAsmExprInt(KickCParser.AsmExprIntContext ctx) {
         Number number = NumberParser.parseLiteral(ctx.NUMBER().getText());
         ConstantInteger intVal = new ConstantInteger(number.longValue());
         boolean isZp = SymbolType.isByte(intVal.getType()) || SymbolType.isSByte(intVal.getType());
         String param = AsmFormat.getAsmNumber(number);
         return new AsmFragmentParameter(param, isZp);
      }

      @Override
      public Object visitAsmExprChar(KickCParser.AsmExprCharContext ctx) {
         return new AsmFragmentParameter(ctx.getText(), true);
      }

      @Override
      public AsmFragmentParameter visitAsmExprLabel(KickCParser.AsmExprLabelContext ctx) {
         String param = ctx.NAME().getSymbol().getText();
         return new AsmFragmentParameter(param, false);
      }

      @Override
      public Object visitAsmExprLabelRel(KickCParser.AsmExprLabelRelContext ctx) {
         String param = ctx.ASMREL().getSymbol().getText();
         return new AsmFragmentParameter(param, false);
      }

      @Override
      public AsmFragmentParameter visitAsmExprReplace(KickCParser.AsmExprReplaceContext ctx) {
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

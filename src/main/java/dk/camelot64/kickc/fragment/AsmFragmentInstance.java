package dk.camelot64.kickc.fragment;

import dk.camelot64.cpufamily6502.CpuAddressingMode;
import dk.camelot64.cpufamily6502.CpuOpcode;
import dk.camelot64.kickc.NumberParser;
import dk.camelot64.kickc.asm.*;
import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.InternalError;
import dk.camelot64.kickc.model.symbols.Label;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.*;
import dk.camelot64.kickc.parser.KickCParser;
import dk.camelot64.kickc.parser.KickCParserBaseVisitor;
import org.antlr.v4.runtime.tree.TerminalNode;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/** ASM Code Fragment with register/variable bindings that can be used for generating ASM code for a specific statement . */
public class AsmFragmentInstance {

   /** The symbol table. */
   private final Program program;

   /** The name of the fragment used in error messages. */
   private final String name;

   /** The fragment template for the ASM code. */
   private final AsmFragmentTemplate fragmentTemplate;

   /** Binding of named values in the fragment to values (constants, variables, ...) . */
   private final Map<String, Value> bindings;

   /** The scope containing the fragment. Used when referencing symbols defined in other scopes. */
   private final ScopeRef codeScopeRef;

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
   public AsmParameter getBoundValue(String name) {
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
         throw new RuntimeException("Binding '" + name + "' not found in fragment " + this.name);
      }
      if(boundValue instanceof Variable && ((Variable) boundValue).isVariable()) {
         Variable boundVar = (Variable) boundValue;
         Registers.Register register = boundVar.getAllocation();
         if(register instanceof Registers.RegisterZpMem) {
            return new AsmParameter(AsmFormat.getAsmSymbolName(program, boundVar, codeScopeRef), true);
         } else if(register instanceof Registers.RegisterMainMem) {
            return new AsmParameter(AsmFormat.getAsmSymbolName(program, boundVar, codeScopeRef), false);
         } else {
            throw new RuntimeException("Register Type not implemented " + register);
         }
      } else if(boundValue instanceof Variable && ((Variable) boundValue).isKindConstant()) {
         Variable constantVar = (Variable) boundValue;
         String constantValueAsm = AsmFormat.getAsmConstant(program, constantVar.getConstantRef(), 99, codeScopeRef);
         boolean constantValueZp = SymbolType.BYTE.equals(constantVar.getType());
         if(!constantValueZp) {
            constantValueZp = isConstantValueZp(constantVar.getInitValue());
         }
         return new AsmParameter(constantValueAsm, constantValueZp);
      } else if(boundValue instanceof ConstantValue) {
         ConstantValue boundConst = (ConstantValue) boundValue;
         String constantValueAsm = AsmFormat.getAsmConstant(program, boundConst, 99, codeScopeRef);
         boolean constantValueZp = isConstantValueZp(boundConst);
         return new AsmParameter(constantValueAsm, constantValueZp);
      } else if(boundValue instanceof Label) {
         String param = AsmFormat.asmFix(((Label) boundValue).getLocalName());
         return new AsmParameter(param, false);
      } else if(boundValue instanceof LabelRef) {
         String param = AsmFormat.asmFix(((LabelRef) boundValue).getLocalName());
         return new AsmParameter(param, false);
      } else if(boundValue instanceof ProcedureRef) {
         String param = AsmFormat.asmFix(((ProcedureRef) boundValue).getFullName());
         return new AsmParameter(param, false);
      } else {
         throw new InternalError("Bound Value Type not implemented " + boundValue);
      }
   }


   /**
    * Determine whether a constant value representing an address in memory is located on zeropage.
    *
    * @param boundConst The constant value
    * @return true if the address represented by the constant is 0<=val<=255
    */
   private boolean isConstantValueZp(ConstantValue boundConst) {
      SymbolType boundConstType = boundConst.getType(program.getScope());
      if(SymbolType.BYTE.equals(boundConstType))
         return true;
      try {
         ConstantLiteral literal = boundConst.calculateLiteral(program.getScope());
         if(literal instanceof ConstantInteger) {
            Long integer = ((ConstantInteger) literal).getInteger();
            return integer <= 255 && integer >= 0;
         }  else if (literal instanceof ConstantPointer) {
            final Long location = ((ConstantPointer) literal).getLocation();
            return location <= 255 && location >= 0;
         }
      } catch(ConstantNotLiteral e) {
         // ignore
      }
      if(boundConst instanceof ConstantRef) {
         Variable reffedConstant = program.getScope().getConstant((ConstantRef) boundConst);
         return isConstantValueZp(reffedConstant.getInitValue());
      }
      if(boundConst instanceof ConstantCastValue) {
         SymbolType toType = ((ConstantCastValue) boundConst).getToType();
         if(SymbolType.BYTE.equals(toType) || SymbolType.SBYTE.equals(toType))
            return true;
         else
            return isConstantValueZp(((ConstantCastValue) boundConst).getValue());
      }
      return false;
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
   public static class AsmParameter {

      private final String param;
      private final boolean zp;

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

   private static class AsmSequenceGenerator extends KickCParserBaseVisitor {

      private final String name;
      private final AsmProgram asmProgram;
      private final AsmFragmentInstance fragmentInstance;

      public AsmSequenceGenerator(String name, AsmFragmentInstance fragmentInstance, AsmProgram asmProgram) {
         this.name = name;
         this.fragmentInstance = fragmentInstance;
         this.asmProgram = asmProgram;
      }

      public AsmProgram getAsmProgram() {
         return asmProgram;
      }

      public void generate(KickCParser.AsmLinesContext context) {
         this.visit(context);
      }

      public void handleTags(AsmLine asmLine, List<TerminalNode> tags) {
         AsmLine line = addTags(asmLine, tags);
         if(line.getTags().has("outside_flow")) {
            // Outside the normal ASM flow - stash them in the program for later
            asmProgram.stashLine(line);
         } else {
            asmProgram.addLine(line);
         }
      }

      private static AsmLine addTags(AsmLine asmLine, List<TerminalNode> asmTags) {
         if(asmTags != null)
            for(TerminalNode asmTag : asmTags) {
               final String tagName = asmTag.getText().substring(1);
               asmLine.getTags().add(tagName);
            }
         return asmLine;
      }

      @Override
      public Object visitAsmLabelName(KickCParser.AsmLabelNameContext ctx) {
         AsmLabel label = new AsmLabel(ctx.ASM_NAME().getText());
         handleTags(label, ctx.ASM_TAG());
         return null;
      }

      @Override
      public Object visitAsmLabelMulti(KickCParser.AsmLabelMultiContext ctx) {
         AsmLabel label = new AsmLabel(ctx.ASM_MULTI_NAME().getText());
         handleTags(label, ctx.ASM_TAG());
         return null;
      }

      @Override
      public Object visitAsmLabelReplace(KickCParser.AsmLabelReplaceContext ctx) {
         String replaceName = ctx.ASM_NAME().getText();
         AsmParameter boundValue = fragmentInstance.getBoundValue(replaceName);
         handleTags(new AsmLabel(boundValue.getParam()), ctx.ASM_TAG());
         return null;
      }

      @Override
      public Object visitAsmBytes(KickCParser.AsmBytesContext ctx) {
         List<KickCParser.AsmExprContext> asmExpr = ctx.asmExpr();
         ArrayList<String> values = new ArrayList<>();
         for(int i = 0; i < asmExpr.size(); i++) {
            if(asmExpr.get(i) != null) {
               AsmParameter par = (AsmParameter)this.visit(asmExpr.get(i));
               values.add(par.getParam());
            }
         }
         AsmDataNumeric data = new AsmDataNumeric(null, AsmDataNumeric.Type.BYTE, values);
         handleTags(data, ctx.ASM_TAG());
         return null;
      }
      @Override
      public Object visitAsmInstruction(KickCParser.AsmInstructionContext ctx) {
         KickCParser.AsmParamModeContext paramModeCtx = ctx.asmParamMode();
         AsmInstruction instruction;
         if(paramModeCtx == null) {
            instruction = createAsmInstruction(ctx, null, null, null, CpuAddressingMode.NON);
         } else {
            instruction = (AsmInstruction) this.visit(paramModeCtx);
         }
         if(instruction != null) {
            handleTags(instruction, ctx.ASM_TAG());
         } else {
            throw new RuntimeException("Error parsing ASM fragment line " + name + ".asm\n - Line: " + ctx.getText());
         }
         return null;
      }

      @Override
      public Object visitAsmModeAbs(KickCParser.AsmModeAbsContext ctx) {
         return createAsmInstruction(ctx, ctx.asmExpr(), null, null, CpuAddressingMode.ABS);
      }

      @Override
      public Object visitAsmModeImm(KickCParser.AsmModeImmContext ctx) {
         return createAsmInstruction(ctx, ctx.asmExpr(), null, null, CpuAddressingMode.IMM);
      }

      @Override
      public Object visitAsmModeImmAndAbs(KickCParser.AsmModeImmAndAbsContext ctx) {
         return createAsmInstruction(ctx, ctx.asmExpr(0), ctx.asmExpr(1), null, CpuAddressingMode.IAB);
      }

      @Override
      public Object visitAsmModeImmAndAbsX(KickCParser.AsmModeImmAndAbsXContext ctx) {
         return createAsmInstruction(ctx, ctx.asmExpr(0), ctx.asmExpr(1), null, CpuAddressingMode.IABX);
      }

      @Override
      public Object visitAsmModeAbs2(KickCParser.AsmModeAbs2Context ctx) {
         final KickCParser.AsmExprContext indexCtx = ctx.asmExpr(1);
         if(indexCtx instanceof KickCParser.AsmExprLabelContext) {
            final String xy = ((KickCParser.AsmExprLabelContext) indexCtx).ASM_NAME().getText();
            if(xy.equals("x")) {
               return createAsmInstruction(ctx, ctx.asmExpr(0), null, null, CpuAddressingMode.ABX);
            } else if(xy.equals("y")) {
               return createAsmInstruction(ctx, ctx.asmExpr(0), null, null, CpuAddressingMode.ABY);
            }
         }
         // Test Relative Addressing Mode (2 parameters)
         return createAsmInstruction(ctx, ctx.asmExpr(0), ctx.asmExpr(1), null, CpuAddressingMode.REZ);
      }

      @Override
      public Object visitAsmModeAbs3(KickCParser.AsmModeAbs3Context ctx) {
         // Abs*3 Addressing Mode (3 parameters)
         return createAsmInstruction(ctx, ctx.asmExpr(0), ctx.asmExpr(1), ctx.asmExpr(2), CpuAddressingMode.ABS3);
      }

      @Override
      public Object visitAsmModeIndIdxXY(KickCParser.AsmModeIndIdxXYContext ctx) {
         String xy = ctx.ASM_NAME().getText();
         if(xy.equals("y")) {
            return createAsmInstruction(ctx, ctx.asmExpr(), null, null, CpuAddressingMode.IZY);
         } else if(xy.equals("z")) {
            return createAsmInstruction(ctx, ctx.asmExpr(), null, null, CpuAddressingMode.IZZ);
         } else {
            throw new RuntimeException("Unknown addressing mode " + ctx.getText());
         }
      }

      @Override
      public Object visitAsmModeIndLongIdxXY(KickCParser.AsmModeIndLongIdxXYContext ctx) {
         String xy = ctx.ASM_NAME().getText();
         if(xy.equals("z")) {
            return createAsmInstruction(ctx, ctx.asmExpr(), null, null, CpuAddressingMode.LIZ);
         } else {
            throw new RuntimeException("Unknown addressing mode " + ctx.getText());
         }
      }

      @Override
      public Object visitAsmModeIdxIndXY(KickCParser.AsmModeIdxIndXYContext ctx) {
         String xy = ctx.ASM_NAME().getText();
         if(xy.equals("x")) {
            return createAsmInstruction(ctx, ctx.asmExpr(), null, null, CpuAddressingMode.IAX);
         } else {
            throw new RuntimeException("Unknown addressing mode " + ctx.getText());
         }
      }

      @Override
      public Object visitAsmModeSPIndIdx(KickCParser.AsmModeSPIndIdxContext ctx) {
         String sp = ctx.ASM_NAME(0).getText();
         String y = ctx.ASM_NAME(1).getText();
         if(sp.equals("sp") && y.equals("y")) {
            return createAsmInstruction(ctx, ctx.asmExpr(), null, null, CpuAddressingMode.ISY);
         } else {
            throw new RuntimeException("Unknown addressing mode " + ctx.getText());
         }
      }

      @Override
      public Object visitAsmModeInd(KickCParser.AsmModeIndContext ctx) {
         return createAsmInstruction(ctx, ctx.asmExpr(), null, null, CpuAddressingMode.IND);
      }

      @Override
      public Object visitAsmModeIndLong(KickCParser.AsmModeIndLongContext ctx) {
         return createAsmInstruction(ctx, ctx.asmExpr(), null, null, CpuAddressingMode.LIN);
      }

      private AsmInstruction createAsmInstruction(
            KickCParser.AsmParamModeContext paramModeCtx,
            KickCParser.AsmExprContext operand1Ctx,
            KickCParser.AsmExprContext operand2Ctx,
            KickCParser.AsmExprContext operand3Ctx,
            CpuAddressingMode addressingMode) {
         return createAsmInstruction((KickCParser.AsmInstructionContext) paramModeCtx.getParent(), operand1Ctx, operand2Ctx, operand3Ctx, addressingMode);
      }

      private AsmInstruction createAsmInstruction(
            KickCParser.AsmInstructionContext instructionCtx,
            KickCParser.AsmExprContext operand1Ctx,
            KickCParser.AsmExprContext operand2Ctx,
            KickCParser.AsmExprContext operand3Ctx,
            CpuAddressingMode addressingMode) {
         String mnemonic = instructionCtx.ASM_MNEMONIC().getSymbol().getText();
         AsmParameter param1 = operand1Ctx == null ? null : (AsmParameter) this.visit(operand1Ctx);
         AsmParameter param2 = operand2Ctx == null ? null : (AsmParameter) this.visit(operand2Ctx);
         AsmParameter param3 = operand3Ctx == null ? null : (AsmParameter) this.visit(operand3Ctx);

         // Convert to ZP-addressing mode if possible

         boolean isZp = param1 != null && param1.isZp();

         if(CpuAddressingMode.IAB.equals(addressingMode) || CpuAddressingMode.IABX.equals(addressingMode)) {
            // For the HuC6280 CPU TST #imm,abs addressing mode it is param2 that can converted the instruction to ZP
            isZp = param2 != null && param2.isZp();
         }

         CpuOpcode cpuOpcode = this.getAsmProgram().getTargetCpu().getCpu65xx().getOpcode(mnemonic, addressingMode, isZp);
         if(!isZp && cpuOpcode==null) {
            // Fallback to ZP-addressing
            cpuOpcode = this.getAsmProgram().getTargetCpu().getCpu65xx().getOpcode(mnemonic, addressingMode, true);
         }

         String operand1 = param1 == null ? null : param1.getParam();
         String operand2 = param2 == null ? null : param2.getParam();
         String operand3 = param3 == null ? null : param3.getParam();
         if(cpuOpcode == null) {
            throw new CompileError("Error in " + name + ".asm line " + instructionCtx.getStart().getLine() + " - Instruction type not supported  " + addressingMode.getAsm(mnemonic, operand1, operand2, operand3) + " by CPU " + this.fragmentInstance.fragmentTemplate.getTargetCpu().getName());
         }


         return new AsmInstruction(cpuOpcode, operand1, operand2, operand3);
      }

      @Override
      public AsmParameter visitAsmExprBinary(KickCParser.AsmExprBinaryContext ctx) {
         AsmParameter left = (AsmParameter) this.visit(ctx.asmExpr(0));
         AsmParameter right = (AsmParameter) this.visit(ctx.asmExpr(1));
         StringBuilder param = new StringBuilder();
         param.append(left.getParam());
         if(ctx.asmExpr(0) instanceof KickCParser.AsmExprLabelRelContext) {
            // Add an extra space if we are doing a binary expression with a relative label as the left part
            param.append(" ");
         }
         param.append(ctx.getChild(1).getText());
         param.append(right.getParam());
         boolean zp = left.isZp() && right.isZp();
         return new AsmParameter(param.toString(), zp);
      }

      @Override
      public AsmParameter visitAsmExprUnary(KickCParser.AsmExprUnaryContext ctx) {
         AsmParameter sub = (AsmParameter) this.visit(ctx.asmExpr());
         String operator = ctx.getChild(0).getText();
         String param = operator + sub.getParam();
         boolean isZp = sub.isZp();
         if(operator.equals("<") || operator.equals(">")) {
            isZp = true;
         }
         return new AsmParameter(param, isZp);
      }

      @Override
      public Object visitAsmExprPar(KickCParser.AsmExprParContext ctx) {
         AsmParameter sub = (AsmParameter) this.visit(ctx.asmExpr());
         String param = "[" + sub.getParam() + "]";
         return new AsmParameter(param, sub.isZp());
      }

      @Override
      public AsmParameter visitAsmExprInt(KickCParser.AsmExprIntContext ctx) {
         Number number = NumberParser.parseLiteral(ctx.ASM_NUMBER().getText());
         boolean isZp = SymbolType.BYTE.contains(number.longValue()) || SymbolType.SBYTE.contains(number.longValue());
         String param = AsmFormat.getAsmNumber(number);
         return new AsmParameter(param, isZp);
      }

      @Override
      public Object visitAsmExprChar(KickCParser.AsmExprCharContext ctx) {
         return new AsmParameter(ctx.getText(), true);
      }

      @Override
      public AsmParameter visitAsmExprLabel(KickCParser.AsmExprLabelContext ctx) {
         String param = ctx.ASM_NAME().getSymbol().getText();
         return new AsmParameter(param, false);
      }

      @Override
      public Object visitAsmExprLabelRel(KickCParser.AsmExprLabelRelContext ctx) {
         String param = ctx.ASM_MULTI_REL().getSymbol().getText();
         return new AsmParameter(param, false);
      }

      @Override
      public AsmParameter visitAsmExprReplace(KickCParser.AsmExprReplaceContext ctx) {
         String replaceName = ctx.ASM_NAME().getSymbol().getText();
         return fragmentInstance.getBoundValue(replaceName);
      }
   }

}

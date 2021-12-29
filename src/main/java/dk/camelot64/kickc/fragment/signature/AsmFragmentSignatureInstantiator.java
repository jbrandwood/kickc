package dk.camelot64.kickc.fragment.signature;

import dk.camelot64.kickc.asm.fragment.signature.AsmFragmentSignatureBaseVisitor;
import dk.camelot64.kickc.asm.fragment.signature.AsmFragmentSignatureParser;
import dk.camelot64.kickc.model.operators.OperatorBinary;
import dk.camelot64.kickc.model.operators.OperatorUnary;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;
import dk.camelot64.kickc.model.values.ConstantInteger;
import org.antlr.v4.runtime.tree.ParseTree;

import java.util.List;
import java.util.stream.Collectors;

/** Creates a typed signature from the signature parser AST. */
class AsmFragmentSignatureInstantiator extends AsmFragmentSignatureBaseVisitor {

    /** Dummy struct type used for fragments. */
    private static final SymbolTypeStruct STRUCT_TYPE = new SymbolTypeStruct("Struct", false, 0, false, false);

    @Override
    public List<AsmFragmentSignature> visitSignatures(AsmFragmentSignatureParser.SignaturesContext ctx) {
        return null;
    }

    public AsmFragmentSignature visitSignature(AsmFragmentSignatureParser.SignatureContext ctx) {
        return (AsmFragmentSignature) visit(ctx);
    }

    @Override
    public AsmFragmentSignature visitAssignment(AsmFragmentSignatureParser.AssignmentContext ctx) {
        return new AsmFragmentSignature.Assignment(visitExpr(ctx.expr(0)), visitExpr(ctx.expr(1)));
    }

    @Override
    public AsmFragmentSignature visitConditionalJump(AsmFragmentSignatureParser.ConditionalJumpContext ctx) {
        final AsmFragmentSignatureExpr.Variable label =
                new AsmFragmentSignatureExpr.Variable(ctx.LABEL().getText(), SymbolType.LABEL);
        return new AsmFragmentSignature.ConditionalJump(visitExpr(ctx.expr()), label);
    }

    @Override
    public AsmFragmentSignature visitCall(AsmFragmentSignatureParser.CallContext ctx) {
        return new AsmFragmentSignature.Call(visitExpr(ctx.expr()));
    }

    @Override
    public AsmFragmentSignature visitIsrRoutine(AsmFragmentSignatureParser.IsrRoutineContext ctx) {
        final String type = ctx.NAME().stream().map(ParseTree::getText).collect(Collectors.joining("_"));
        final String entryExitText = ctx.getChild(ctx.getChildCount() - 1).getText();
        AsmFragmentSignature.Isr.EntryExit entryExit;
        switch (entryExitText) {
            case "entry":
                entryExit = AsmFragmentSignature.Isr.EntryExit.Entry;
                break;
            case "exit":
                entryExit = AsmFragmentSignature.Isr.EntryExit.Exit;
                break;
            default:
                throw new RuntimeException("Unknown ISR entry/exit type " + entryExitText);
        }
        return new AsmFragmentSignature.Isr(type, entryExit);
    }

    @Override
    public AsmFragmentSignature visitExprSideEffect(AsmFragmentSignatureParser.ExprSideEffectContext ctx) {
        return new AsmFragmentSignature.ExprSideEffect(visitExpr(ctx.expr()));
    }

    public AsmFragmentSignatureExpr visitExpr(AsmFragmentSignatureParser.ExprContext ctx) {
        return (AsmFragmentSignatureExpr) visit(ctx);
    }

    @Override
    public AsmFragmentSignatureExpr visitPar(AsmFragmentSignatureParser.ParContext ctx) {
        return this.visitExpr(ctx.expr());
    }

    @Override
    public AsmFragmentSignatureExpr visitVar(AsmFragmentSignatureParser.VarContext ctx) {
        final String varName = ctx.VAR().getText();
        // TODO: parse Type
        SymbolType varType = SymbolType.VOID;
        return new AsmFragmentSignatureExpr.Variable(varName, varType);
    }

    @Override
    public AsmFragmentSignatureExpr visitNum(AsmFragmentSignatureParser.NumContext ctx) {
        final ConstantInteger num = new ConstantInteger((long) Integer.parseInt(ctx.NUM().getText()));
        return new AsmFragmentSignatureExpr.Number(num);
    }

    @Override
    public AsmFragmentSignatureExpr visitBinary(AsmFragmentSignatureParser.BinaryContext ctx) {
        final String operatorText = ctx.getChild(1).getText();
        final OperatorBinary operator = Operators.getBinaryFromAsmName(operatorText);
        return new AsmFragmentSignatureExpr.Binary(operator, visitExpr(ctx.expr(0)), visitExpr(ctx.expr(1)));
    }

    @Override
    public Object visitDerefSimple(AsmFragmentSignatureParser.DerefSimpleContext ctx) {
        return new AsmFragmentSignatureExpr.DerefSimple(this.visitExpr(ctx.expr()));
    }

    @Override
    public Object visitDerefIdx(AsmFragmentSignatureParser.DerefIdxContext ctx) {
        return new AsmFragmentSignatureExpr.DerefIdx(this.visitExpr(ctx.expr(0)), this.visitExpr(ctx.expr(1)));
    }

    @Override
    public AsmFragmentSignatureExpr visitUnary(AsmFragmentSignatureParser.UnaryContext ctx) {
        final String operatorText = ctx.getChild(0).getText();
        final OperatorUnary operator = Operators.getUnaryFromAsmName(operatorText);
        return new AsmFragmentSignatureExpr.Unary(operator, visitExpr(ctx.expr()));
    }

    @Override
    public AsmFragmentSignatureExpr visitMemset(AsmFragmentSignatureParser.MemsetContext ctx) {
        return new AsmFragmentSignatureExpr.Memset(visitExpr(ctx.expr()));
    }

    @Override
    public AsmFragmentSignatureExpr visitMemcpy(AsmFragmentSignatureParser.MemcpyContext ctx) {
        return new AsmFragmentSignatureExpr.Memcpy(visitExpr(ctx.expr(0)), visitExpr(ctx.expr(1)));
    }

    @Override
    public AsmFragmentSignatureExpr visitStackPushPadding(AsmFragmentSignatureParser.StackPushPaddingContext ctx) {
        final ConstantInteger bytes = new ConstantInteger((long) Integer.parseInt(ctx.NUM().getText()));
        return new AsmFragmentSignatureExpr.StackPushPadding(bytes);
    }

    @Override
    public AsmFragmentSignatureExpr visitStackPullPadding(AsmFragmentSignatureParser.StackPullPaddingContext ctx) {
        final ConstantInteger bytes = new ConstantInteger((long) Integer.parseInt(ctx.NUM().getText()));
        return new AsmFragmentSignatureExpr.StackPullPadding(bytes);
    }

    private SymbolType parseSymbolType(String typeText) {
        switch (typeText) {
            case "ptr":
                return new SymbolTypePointer(SymbolType.VOID);
            case "byte":
                return SymbolType.BYTE;
            case "sbyte":
                return SymbolType.SBYTE;
            case "word":
                return SymbolType.WORD;
            case "sword":
                return SymbolType.SWORD;
            case "dword":
                return SymbolType.DWORD;
            case "sdword":
                return SymbolType.SDWORD;
            default:
                throw new RuntimeException("Unknown type " + typeText);
        }
    }

    @Override
    public AsmFragmentSignatureExpr visitStackIdx(AsmFragmentSignatureParser.StackIdxContext ctx) {
        final String typeText = ctx.getChild(0).getText().substring("stackidx".length());
        SymbolType type = parseSymbolType(typeText);
        return new AsmFragmentSignatureExpr.StackIdx(type, null, visitExpr(ctx.expr()));
    }

    @Override
    public AsmFragmentSignatureExpr visitStackIdxStruct(AsmFragmentSignatureParser.StackIdxStructContext ctx) {
        return new AsmFragmentSignatureExpr.StackIdx(STRUCT_TYPE, visitExpr(ctx.expr(0)), visitExpr(ctx.expr(1)));
    }

    @Override
    public AsmFragmentSignatureExpr visitStackPush(AsmFragmentSignatureParser.StackPushContext ctx) {
        final String typeText = ctx.getChild(0).getText().substring("stackpush".length());
        SymbolType type = parseSymbolType(typeText);
        return new AsmFragmentSignatureExpr.StackPush(type, null);
    }

    @Override
    public AsmFragmentSignatureExpr visitStackPushStruct(AsmFragmentSignatureParser.StackPushStructContext ctx) {
        return new AsmFragmentSignatureExpr.StackPush(STRUCT_TYPE, visitExpr(ctx.expr()));
    }

    @Override
    public AsmFragmentSignatureExpr visitStackPull(AsmFragmentSignatureParser.StackPullContext ctx) {
        final String typeText = ctx.getChild(0).getText().substring("stackpull".length());
        SymbolType type = parseSymbolType(typeText);
        return new AsmFragmentSignatureExpr.StackPull(type, null);
    }

    @Override
    public AsmFragmentSignatureExpr visitStackPullStruct(AsmFragmentSignatureParser.StackPullStructContext ctx) {
        return new AsmFragmentSignatureExpr.StackPull(STRUCT_TYPE, visitExpr(ctx.expr()));
    }

    @Override
    public AsmFragmentSignatureExpr visitMakelong4(AsmFragmentSignatureParser.Makelong4Context ctx) {
        return new AsmFragmentSignatureExpr.Makelong4(
                visitExpr(ctx.expr(0)),
                visitExpr(ctx.expr(1)),
                visitExpr(ctx.expr(2)),
                visitExpr(ctx.expr(3)));
    }
}

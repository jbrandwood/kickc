package dk.camelot64.kickc.fragment;

import dk.camelot64.kickc.asm.AsmFormat;
import dk.camelot64.kickc.fragment.signature.AsmFragmentBindings;
import dk.camelot64.kickc.fragment.signature.AsmFragmentSignature;
import dk.camelot64.kickc.fragment.signature.AsmFragmentSignatureExpr;
import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.ControlFlowGraph;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.operators.Operator;
import dk.camelot64.kickc.model.operators.OperatorBinary;
import dk.camelot64.kickc.model.operators.OperatorUnary;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.symbols.Bank;
import dk.camelot64.kickc.model.symbols.Label;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.symbols.Symbol;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeInference;
import dk.camelot64.kickc.model.values.*;

/**
 * Creates an ASM Fragment specification for a statement in the control flow graph.
 */
final public class AsmFragmentInstanceSpecBuilder {

    private AsmFragmentInstanceSpecBuilder() {
    }

    /**
     * Create a fragment instance spec factory for an indirect call.
     *
     * @return the fragment instance spec factory
     */
    public static AsmFragmentInstanceSpec call(StatementCallExecute call, int indirectCallId, Program program) {
        AsmFragmentBindings bindings = new AsmFragmentBindings(program);
        ScopeRef codeScope = program.getStatementInfos().getBlock(call).getScope();
        RValue procedureRVal = call.getProcedureRVal();
        AsmFragmentSignature signature = new AsmFragmentSignature.Call(bindings.bind(procedureRVal));
        bindings.bind("la1", new LabelRef(codeScope.getFullName() + "::" + "icall" + indirectCallId));
        return new AsmFragmentInstanceSpec(program, signature, bindings, codeScope);
    }

    /**
     * Create a fragment instance spec factory for a subroutine call
     *
     * @param callingDistance   The class expressing the distance of the call: "near", "close", "far" plus bankArea and bank information calculated from the from and to procedure.
     * @param callingConvention The string expressing the calling convention supported by the fragment.
     * @param procedureName     The full name of the procedure.
     * @param program           The program
     * @return the fragment instance spec factory
     */
    public static AsmFragmentInstanceSpec callBanked(String callingConvention, Procedure.CallingProximity proximity, Bank toBank, String procedureName, Program program) {
        AsmFragmentBindings bindings = new AsmFragmentBindings(program);
        AsmFragmentSignature signature = new AsmFragmentSignature.CallBanked(callingConvention, proximity, toBank);
        ScopeRef codeScope = program.getScope().getRef();
        bindings.bind("c1", new ConstantInteger(toBank.bankNumber()));
        bindings.bind("la1", new LabelRef(procedureName));
        return new AsmFragmentInstanceSpec(program, signature, bindings, codeScope);
    }

    /**
     * Create a fragment instance spec factory for an interrupt routine entry
     *
     * @param interruptType The interrupt routine handle name
     * @param program       The program
     * @return the fragment instance spec factory
     */
    public static AsmFragmentInstanceSpec interruptEntry(String interruptType, Program program) {
        AsmFragmentBindings bindings = new AsmFragmentBindings(program);
        AsmFragmentSignature signature = new AsmFragmentSignature.Isr(interruptType, AsmFragmentSignature.Isr.EntryExit.Entry);
        ScopeRef codeScope = program.getScope().getRef();
        return new AsmFragmentInstanceSpec(program, signature, bindings, codeScope);
    }

    /**
     * Create a fragment instance spec factory for an interrupt routine exit
     *
     * @param interruptType The interrupt routine handle name
     * @param program       The program
     * @return the fragment instance spec factory
     */
    public static AsmFragmentInstanceSpec interruptExit(String interruptType, Program program) {
        AsmFragmentBindings bindings = new AsmFragmentBindings(program);
        AsmFragmentSignature signature = new AsmFragmentSignature.Isr(interruptType, AsmFragmentSignature.Isr.EntryExit.Exit);
        ScopeRef codeScope = program.getScope().getRef();
        return new AsmFragmentInstanceSpec(program, signature, bindings, codeScope);
    }

    public static AsmFragmentInstanceSpec conditionalJump(StatementConditionalJump conditionalJump, ControlFlowBlock block, Program program) {
        AsmFragmentBindings bindings = new AsmFragmentBindings(program);
        ScopeRef codeScope = program.getStatementInfos().getBlock(conditionalJump).getScope();
        AsmFragmentSignature signature = conditionalJumpSignature(bindings, conditionalJump, block, program.getGraph());
        return new AsmFragmentInstanceSpec(program, signature, bindings, codeScope);
    }

    public static AsmFragmentInstanceSpec exprSideEffect(StatementExprSideEffect exprSideEffect, Program program) {
        AsmFragmentBindings bindings = new AsmFragmentBindings(program);
        ScopeRef codeScope = program.getStatementInfos().getBlock(exprSideEffect).getScope();
        AsmFragmentSignature signature = new AsmFragmentSignature.ExprSideEffect(bindings.bind(exprSideEffect.getExpression()));
        return new AsmFragmentInstanceSpec(program, signature, bindings, codeScope);
    }

    /**
     * MAKELONG4() creates a long from 4 bytes
     *
     * @param make4long The intrinsic call
     * @param program   The program
     * @return The ASM fragment instance
     */
    public static AsmFragmentInstanceSpec makelong4(StatementCall make4long, Program program) {
        AsmFragmentBindings bindings = new AsmFragmentBindings(program);
        if (make4long.getParameters().size() != 4)
            throw new CompileError("MAKELONG4() needs 4 parameters.", make4long);
        final AsmFragmentSignature.Assignment signature = new AsmFragmentSignature.Assignment(
                bindings.bind(make4long.getlValue()),
                new AsmFragmentSignatureExpr.Makelong4(
                        bindings.bind(make4long.getParameter(3)),
                        bindings.bind(make4long.getParameter(2)),
                        bindings.bind(make4long.getParameter(1)),
                        bindings.bind(make4long.getParameter(0))
                )
        );
        ScopeRef codeScope = program.getScope().getRef();
        return new AsmFragmentInstanceSpec(program, signature, bindings, codeScope);
    }

    public static AsmFragmentInstanceSpec assignment(StatementAssignment assignment, Program program) {
        AsmFragmentBindings bindings = new AsmFragmentBindings(program);
        ScopeRef codeScope = program.getStatementInfos().getBlock(assignment).getScope();
        final AsmFragmentSignatureExpr lValueExpr = bindings.bind(assignment.getlValue());
        final AsmFragmentSignatureExpr rValueExpr = assignmentRightSideSignature(bindings, assignment.getrValue1(), assignment.getOperator(), assignment.getrValue2());
        AsmFragmentSignature signature = new AsmFragmentSignature.Assignment(lValueExpr, rValueExpr);
        return new AsmFragmentInstanceSpec(program, signature, bindings, codeScope);
    }

    public static AsmFragmentInstanceSpec assignment(LValue lValue, RValue rValue, Program program, ScopeRef codeScopeRef) {
        AsmFragmentBindings bindings = new AsmFragmentBindings(program);
        final AsmFragmentSignatureExpr lValueExpr = bindings.bind(lValue);
        final AsmFragmentSignatureExpr rValueExpr = assignmentRightSideSignature(bindings, null, null, rValue);
        AsmFragmentSignature signature = new AsmFragmentSignature.Assignment(lValueExpr, rValueExpr);
        return new AsmFragmentInstanceSpec(program, signature, bindings, codeScopeRef);
    }

    private static AsmFragmentSignatureExpr assignmentRightSideSignature(AsmFragmentBindings bindings, RValue rValue1, Operator operator, RValue rValue2) {
        final SymbolType rValue1Type = rValue1 == null ? null : SymbolTypeInference.inferType(bindings.program.getScope(), rValue1);
        if (rValue1 == null && operator == null) {
            // Unmodified assignment
            return bindings.bind(rValue2);
        } else if (rValue1 == null) {
            // Unary expression
            return new AsmFragmentSignatureExpr.Unary((OperatorUnary) operator, bindings.bind(rValue2));
        } else {
            final AsmFragmentSignatureExpr rVal1SignatureExpr = bindings.bind(rValue1);
            // Binary expression
            AsmFragmentSignatureExpr rVal2SignatureExpr;
            final boolean isMinusOrPlus = Operators.MINUS.equals(operator) || Operators.PLUS.equals(operator);
            if (rValue2 instanceof ConstantInteger && ((ConstantInteger) rValue2).getValue() == 1 && isMinusOrPlus) {
                rVal2SignatureExpr = new AsmFragmentSignatureExpr.Number(new ConstantInteger(1L));
            } else if (rValue2 instanceof ConstantInteger && ((ConstantInteger) rValue2).getValue() == 2 &&
                    isMinusOrPlus && (SymbolType.BYTE.equals(rValue1Type) || SymbolType.SBYTE.equals(rValue1Type))
            ) {
                rVal2SignatureExpr = new AsmFragmentSignatureExpr.Number(new ConstantInteger(2L));
            } else {
                final boolean isShift = Operators.SHIFT_RIGHT.equals(operator) || Operators.SHIFT_LEFT.equals(operator);
                if (rValue2 instanceof ConstantInteger && ((ConstantInteger) rValue2).getValue() <= 9 && isShift) {
                    rVal2SignatureExpr = new AsmFragmentSignatureExpr.Number(new ConstantInteger(((ConstantInteger) rValue2).getInteger()));
                } else if (rValue2 instanceof ConstantInteger && ((((ConstantInteger) rValue2).getValue()) % 8 == 0) && isShift) {
                    rVal2SignatureExpr = new AsmFragmentSignatureExpr.Number(new ConstantInteger(((ConstantInteger) rValue2).getInteger()));
                } else if (rValue2 instanceof ConstantInteger && ((ConstantInteger) rValue2).getValue() == 0 && isMinusOrPlus) {
                    rVal2SignatureExpr = new AsmFragmentSignatureExpr.Number(new ConstantInteger(2L));
                } else {
                    rVal2SignatureExpr = bindings.bind(rValue2);
                }
            }
            return new AsmFragmentSignatureExpr.Binary((OperatorBinary) operator, rVal1SignatureExpr, rVal2SignatureExpr);
        }
    }

    private static AsmFragmentSignature conditionalJumpSignature(
            AsmFragmentBindings bindings,
            StatementConditionalJump conditionalJump,
            ControlFlowBlock block,
            ControlFlowGraph graph) {
        AsmFragmentSignatureExpr rVal1SignatureExpr = null;
        if (conditionalJump.getrValue1() instanceof ConstantInteger && ((ConstantInteger) conditionalJump.getrValue1()).getValue() == 0) {
            rVal1SignatureExpr = new AsmFragmentSignatureExpr.Number(new ConstantInteger(0L));
        } else if (conditionalJump.getrValue1() != null) {
            rVal1SignatureExpr = bindings.bind(conditionalJump.getrValue1());
        }

        AsmFragmentSignatureExpr rVal2SignatureExpr;
        if (conditionalJump.getrValue2() instanceof ConstantInteger && ((ConstantInteger) conditionalJump.getrValue2()).getValue() == 0) {
            rVal2SignatureExpr = new AsmFragmentSignatureExpr.Number(new ConstantInteger(0L));
        } else {
            rVal2SignatureExpr = bindings.bind(conditionalJump.getrValue2());
        }

        AsmFragmentSignatureExpr condition;
        if (conditionalJump.getOperator() == null) {
            condition = rVal2SignatureExpr;
        } else {
            condition = new AsmFragmentSignatureExpr.Binary(
                    (OperatorBinary) conditionalJump.getOperator(),
                    rVal1SignatureExpr,
                    rVal2SignatureExpr);
        }

        LabelRef destination = conditionalJump.getDestination();
        ControlFlowBlock destinationBlock = graph.getBlock(destination);
        String destinationLabel;
        if (destinationBlock.hasPhiBlock()) {
            destinationLabel =
                    AsmFormat.asmFix(destinationBlock.getLabel().getLocalName() +
                            "_from_" +
                            block.getLabel().getLocalName());
        } else {
            destinationLabel = destination.getLocalName();
        }
        Symbol destSymbol = bindings.program.getScope().getSymbol(destination);
        final AsmFragmentSignatureExpr labelExpr = bindings.bind(new Label(destinationLabel, destSymbol.getScope(), false));
        return new AsmFragmentSignature.ConditionalJump(condition, labelExpr);
    }

}
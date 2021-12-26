package dk.camelot64.kickc.fragment;

import dk.camelot64.kickc.asm.AsmFormat;
import dk.camelot64.kickc.fragment.signature.AsmFragmentSignature;
import dk.camelot64.kickc.fragment.signature.AsmFragmentSignatureExpr;
import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.operators.Operator;
import dk.camelot64.kickc.model.operators.OperatorBinary;
import dk.camelot64.kickc.model.operators.OperatorUnary;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.symbols.Label;
import dk.camelot64.kickc.model.symbols.Symbol;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.*;
import dk.camelot64.kickc.model.values.*;
import dk.camelot64.kickc.passes.utils.SizeOfConstants;

import java.lang.InternalError;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * A fragment specification generated from a {@link Statement} used to load/synthesize an {@link AsmFragmentInstance} for creating ASM code for the statement
 */
public class AsmFragmentInstanceSpecBuilder {

    /** The symbol table. */
    private final Program program;

    /** Binding of named values in the fragment to values (constants, variables, ...). */
    private final Map<String, Value> bindings;

    /** The created ASM fragment instance specification. */
    private final AsmFragmentInstanceSpec asmFragmentInstanceSpec;

   /** Indexing for zeropages/constants/labels. */
    private int nextMemIdx = 1;
    private int nextConstIdx = 1;
    private int nextLabelIdx = 1;

    /**
     * Create a fragment instance spec factory for an indirect call.
     *
     * @return the fragment instance spec factory
     */
    public static AsmFragmentInstanceSpec call(StatementCallExecute call, int indirectCallId, Program program) {
        return new AsmFragmentInstanceSpecBuilder(call, indirectCallId, program).getAsmFragmentInstanceSpec();
    }

    private AsmFragmentInstanceSpecBuilder(StatementCallExecute call, int indirectCallId, Program program) {
        this.program = program;
        this.bindings = new LinkedHashMap<>();
        ScopeRef codeScope = program.getStatementInfos().getBlock(call).getScope();
        RValue procRVal = call.getProcedureRVal();
        AsmFragmentSignature signature = new AsmFragmentSignature.Call(bind(procRVal));
        bind("la1", new LabelRef(codeScope.getFullName() + "::" + "icall" + indirectCallId));
        this.asmFragmentInstanceSpec = new AsmFragmentInstanceSpec(program, signature.getName(), bindings, codeScope);
    }

    /**
     * Create a fragment instance spec factory for an interrupt routine entry
     *
     * @param interruptType The interrupt routine handle name
     * @param program       The program
     * @return the fragment instance spec factory
     */
    public static AsmFragmentInstanceSpec interruptEntry(String interruptType, Program program) {
        Map<String, Value> bindings = new HashMap<>();
        String signature = "isr_" + interruptType + "_entry";
        ScopeRef codeScope = program.getScope().getRef();
        final AsmFragmentInstanceSpec fragmentInstanceSpec = new AsmFragmentInstanceSpec(program, signature, bindings, codeScope);
        return new AsmFragmentInstanceSpecBuilder(program, bindings, fragmentInstanceSpec).getAsmFragmentInstanceSpec();
    }

    /**
     * Create a fragment instance spec factory for an interrupt routine exit
     *
     * @param interruptType The interrupt routine handle name
     * @param program       The program
     * @return the fragment instance spec factory
     */
    public static AsmFragmentInstanceSpec interruptExit(String interruptType, Program program) {
        Map<String, Value> bindings = new HashMap<>();
        String signature = "isr_" + interruptType + "_exit";
        ScopeRef codeScope = program.getScope().getRef();
        final AsmFragmentInstanceSpec fragmentInstanceSpec = new AsmFragmentInstanceSpec(program, signature, bindings, codeScope);
        return new AsmFragmentInstanceSpecBuilder(program, bindings, fragmentInstanceSpec).getAsmFragmentInstanceSpec();
    }

    private AsmFragmentInstanceSpecBuilder(Program program, Map<String, Value> bindings, AsmFragmentInstanceSpec asmFragmentInstanceSpec) {
        this.program = program;
        this.bindings = bindings;
        this.asmFragmentInstanceSpec = asmFragmentInstanceSpec;
    }


    public static AsmFragmentInstanceSpec conditionalJump(StatementConditionalJump conditionalJump, ControlFlowBlock block, Program program) {
        return new AsmFragmentInstanceSpecBuilder(conditionalJump, block, program).getAsmFragmentInstanceSpec();
    }

    private AsmFragmentInstanceSpecBuilder(
            StatementConditionalJump conditionalJump,
            ControlFlowBlock block,
            Program program) {
        this.program = program;
        this.bindings = new LinkedHashMap<>();
        ScopeRef codeScope = program.getStatementInfos().getBlock(conditionalJump).getScope();
        String signature = conditionalJumpSignature(conditionalJump, block, program.getGraph()).getName();
        this.asmFragmentInstanceSpec = new AsmFragmentInstanceSpec(program, signature, bindings, codeScope);
    }

    public static AsmFragmentInstanceSpec exprSideEffect(StatementExprSideEffect exprSideEffect, Program program) {
        return new AsmFragmentInstanceSpecBuilder(exprSideEffect, program).getAsmFragmentInstanceSpec();
    }

    private AsmFragmentInstanceSpecBuilder(StatementExprSideEffect exprSideEffect, Program program) {
        this.program = program;
        this.bindings = new LinkedHashMap<>();
        ScopeRef codeScope = program.getStatementInfos().getBlock(exprSideEffect).getScope();
        String signature = (new AsmFragmentSignature.ExprSideEffect(bind(exprSideEffect.getExpression()))).getName();
        this.asmFragmentInstanceSpec = new AsmFragmentInstanceSpec(program, signature, bindings, codeScope);
    }

    public static AsmFragmentInstanceSpec assignment(StatementAssignment assignment, Program program) {
        return new AsmFragmentInstanceSpecBuilder(assignment, program).getAsmFragmentInstanceSpec();
    }

    /**
     * MAKELONG4() creates a long form 4 bytes
     *
     * @param call    The intrinsic call
     * @param program The program
     * @return The ASM fragment instance
     */
    public static AsmFragmentInstanceSpec makelong4(StatementCall call, Program program) {
        return new AsmFragmentInstanceSpecBuilder(call, program).getAsmFragmentInstanceSpec();
    }

    private AsmFragmentInstanceSpecBuilder(StatementCall make4long, Program program) {
        this.program = program;
        this.bindings = new LinkedHashMap<>();
        if (make4long.getParameters().size() != 4)
            throw new CompileError("MAKELONG4() needs 4 parameters.", make4long);
        final AsmFragmentSignature.Assignment signature = new AsmFragmentSignature.Assignment(
                bind(make4long.getlValue()),
                new AsmFragmentSignatureExpr.Makelong4(
                        bind(make4long.getParameter(3)),
                        bind(make4long.getParameter(2)),
                        bind(make4long.getParameter(1)),
                        bind(make4long.getParameter(0))
                )
        );
        ScopeRef codeScope = program.getScope().getRef();
        this.asmFragmentInstanceSpec = new AsmFragmentInstanceSpec(program, signature.getName(), bindings, codeScope);
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

    public static AsmFragmentInstanceSpec assignment(LValue lValue, RValue rValue, Program program, ScopeRef codeScopeRef) {
        return new AsmFragmentInstanceSpecBuilder(lValue, rValue, program, codeScopeRef).getAsmFragmentInstanceSpec();
    }

    private AsmFragmentInstanceSpecBuilder(LValue lValue, RValue rValue, Program program, ScopeRef codeScopeRef) {
        this.program = program;
        this.bindings = new LinkedHashMap<>();
        String signature = assignmentSignature(lValue, null, null, rValue);
        this.asmFragmentInstanceSpec = new AsmFragmentInstanceSpec(program, signature, bindings, codeScopeRef);
    }

    public static AsmFragmentInstanceSpec assignmentAlu(StatementAssignment assignment, StatementAssignment assignmentAlu, Program program) {
        return new AsmFragmentInstanceSpecBuilder(assignment, assignmentAlu, program).getAsmFragmentInstanceSpec();
    }

    private AsmFragmentInstanceSpecBuilder(StatementAssignment assignment, StatementAssignment assignmentAlu, Program program) {
        this.program = program;
        this.bindings = new LinkedHashMap<>();
        ScopeRef codeScope = program.getStatementInfos().getBlock(assignment).getScope();
        String signature = assignmentWithAluSignature(assignment, assignmentAlu).getName();
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

    private AsmFragmentSignature assignmentWithAluSignature(StatementAssignment assignment, StatementAssignment assignmentAlu) {
        if (!(assignment.getrValue2() instanceof VariableRef)) {
            throw new AsmFragmentInstance.AluNotApplicableException("Error! ALU register only allowed as rValue2. " + assignment);
        }
        VariableRef assignmentRValue2 = (VariableRef) assignment.getrValue2();
        Variable assignmentRValue2Var = program.getSymbolInfos().getVariable(assignmentRValue2);
        Registers.Register rVal2Register = assignmentRValue2Var.getAllocation();

        if (!rVal2Register.getType().equals(Registers.RegisterType.REG_ALU)) {
            throw new AsmFragmentInstance.AluNotApplicableException("Error! ALU register only allowed as rValue2. " + assignment);
        }
        final AsmFragmentSignatureExpr lValueFragmentExpr = bind(assignment.getlValue());

        AsmFragmentSignatureExpr rVal1FragmentExpr = null;
        if (assignment.getrValue1() != null) {
            rVal1FragmentExpr = bind(assignment.getrValue1());
        }

        final AsmFragmentSignatureExpr rVal2FragmentExpr = assignmentRightSideSignature(
                assignmentAlu.getrValue1(),
                assignmentAlu.getOperator(),
                assignmentAlu.getrValue2());

        if (rVal1FragmentExpr == null) {
            return new AsmFragmentSignature.Assignment(lValueFragmentExpr, rVal2FragmentExpr);
        } else {
            return new AsmFragmentSignature.Assignment(
                    lValueFragmentExpr,
                    new AsmFragmentSignatureExpr.Binary(
                            (OperatorBinary) assignment.getOperator(),
                            rVal1FragmentExpr,
                            rVal2FragmentExpr)
            );
        }
    }

    private String assignmentSignature(LValue lValue, RValue rValue1, Operator operator, RValue rValue2) {
        return (new AsmFragmentSignature.Assignment(
                bind(lValue),
                assignmentRightSideSignature(rValue1, operator, rValue2)
        )).getName();
    }

    private AsmFragmentSignatureExpr assignmentRightSideSignature(RValue rValue1, Operator operator, RValue rValue2) {

        final SymbolType rValue1Type = rValue1 == null ? null : SymbolTypeInference.inferType(program.getScope(), rValue1);

        if (rValue1 == null && operator == null) {
            // Unmodified assignment
            return bind(rValue2);
        } else if (rValue1 == null) {
            // Unary expression
            return new AsmFragmentSignatureExpr.Unary((OperatorUnary) operator, bind(rValue2));
        } else {
            final AsmFragmentSignatureExpr rVal1SignatureExpr = bind(rValue1);
            // Binary expression
            AsmFragmentSignatureExpr rVal2SignatureExpr;
            if (
                    rValue2 instanceof ConstantInteger &&
                            ((ConstantInteger) rValue2).getValue() == 1 &&
                            (Operators.MINUS.equals(operator) || Operators.PLUS.equals(operator))) {
                rVal2SignatureExpr = new AsmFragmentSignatureExpr.Number(new ConstantInteger(1L));
            } else if (
                    rValue2 instanceof ConstantInteger &&
                            ((ConstantInteger) rValue2).getValue() == 2 &&
                            (Operators.MINUS.equals(operator) || Operators.PLUS.equals(operator)) &&
                            (SymbolType.BYTE.equals(rValue1Type) || SymbolType.SBYTE.equals(rValue1Type))
            ) {
                rVal2SignatureExpr = new AsmFragmentSignatureExpr.Number(new ConstantInteger(2L));
            } else if (
                    rValue2 instanceof ConstantInteger &&
                            ((ConstantInteger) rValue2).getValue() <= 9 &&
                            (Operators.SHIFT_RIGHT.equals(operator) || Operators.SHIFT_LEFT.equals(operator))) {
                rVal2SignatureExpr = new AsmFragmentSignatureExpr.Number(new ConstantInteger(((ConstantInteger) rValue2).getInteger()));
            } else if (
                    rValue2 instanceof ConstantInteger &&
                            ((((ConstantInteger) rValue2).getValue()) % 8 == 0) &&
                            (Operators.SHIFT_RIGHT.equals(operator) || Operators.SHIFT_LEFT.equals(operator))) {
                rVal2SignatureExpr = new AsmFragmentSignatureExpr.Number(new ConstantInteger(((ConstantInteger) rValue2).getInteger()));
            } else if (
                    rValue2 instanceof ConstantInteger &&
                            ((ConstantInteger) rValue2).getValue() == 0 &&
                            (Operators.MINUS.equals(operator) || Operators.PLUS.equals(operator))) {
                rVal2SignatureExpr = new AsmFragmentSignatureExpr.Number(new ConstantInteger(2L));
            } else {
                rVal2SignatureExpr = bind(rValue2);
            }
            return new AsmFragmentSignatureExpr.Binary((OperatorBinary) operator, rVal1SignatureExpr, rVal2SignatureExpr);
        }
    }

    private AsmFragmentSignature conditionalJumpSignature(
            StatementConditionalJump conditionalJump,
            ControlFlowBlock block,
            ControlFlowGraph graph) {
        AsmFragmentSignatureExpr rVal1SignatureExpr = null;
        if (conditionalJump.getrValue1() instanceof ConstantInteger && ((ConstantInteger) conditionalJump.getrValue1()).getValue() == 0) {
            rVal1SignatureExpr = new AsmFragmentSignatureExpr.Number(new ConstantInteger(0L));
        } else if (conditionalJump.getrValue1() != null) {
            rVal1SignatureExpr = bind(conditionalJump.getrValue1());
        }

        AsmFragmentSignatureExpr rVal2SignatureExpr = null;
        if (conditionalJump.getrValue2() instanceof ConstantInteger && ((ConstantInteger) conditionalJump.getrValue2()).getValue() == 0) {
            rVal2SignatureExpr = new AsmFragmentSignatureExpr.Number(new ConstantInteger(0L));
        } else {
            rVal2SignatureExpr = bind(conditionalJump.getrValue2());
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
        Symbol destSymbol = program.getScope().getSymbol(destination);
        final AsmFragmentSignatureExpr labelExpr = bind(new Label(destinationLabel, destSymbol.getScope(), false));
        return new AsmFragmentSignature.ConditionalJump(condition, labelExpr);
    }

    /**
     * Add bindings of a value.
     *
     * @param value The value to bind.
     * @return The bound name of the value. If the value has already been bound the existing bound name is returned.
     */
    public AsmFragmentSignatureExpr bind(Value value) {
        return bind(value, null);
    }

    /**
     * Add bindings of a value.
     *
     * @param value    The value to bind.
     * @param castType The type to bind the value as (used for casting). null if not casting, will use the actual type of the value.
     * @return The bound name of the value. If the value has already been bound the existing bound name is returned.
     */
    public AsmFragmentSignatureExpr bind(Value value, SymbolType castType) {
        if (value instanceof CastValue) {
            CastValue cast = (CastValue) value;
            SymbolType toType = cast.getToType();
            RValue castValue = cast.getValue();
            SymbolType castValueType = SymbolTypeInference.inferType(this.program.getScope(), castValue);
            if (castValueType.getSizeBytes() == toType.getSizeBytes()) {
                if (castType != null) {
                    if (castType.getSizeBytes() == toType.getSizeBytes()) {
                        return bind(castValue, castType);
                    } else {
                        OperatorUnary castUnary = Operators.getCastUnary(castType);
                        return new AsmFragmentSignatureExpr.Unary(castUnary, bind(castValue, toType));
                    }
                } else {
                    return bind(castValue, toType);
                }
            } else {
                // Size of inner value and inner cast type mismatches - require explicit conversion
                if (castType != null) {
                    OperatorUnary castUnaryInner = Operators.getCastUnary(toType);
                    OperatorUnary castUnaryOuter = Operators.getCastUnary(castType);
                    return new AsmFragmentSignatureExpr.Unary(castUnaryOuter, new AsmFragmentSignatureExpr.Unary(castUnaryInner, bind(castValue)));
                } else {
                    OperatorUnary castUnaryInner = Operators.getCastUnary(toType);
                    return new AsmFragmentSignatureExpr.Unary(castUnaryInner, bind(castValue));
                }
            }
        } else if (value instanceof ConstantCastValue) {
            ConstantCastValue castVal = (ConstantCastValue) value;
            ConstantValue val = castVal.getValue();
            if (castType == null) {
                SymbolType toType = castVal.getToType();
                // If value literal not matching cast type then add expression code to transform it into the value space ( eg. value & 0xff )

                if (toType instanceof SymbolTypeIntegerFixed) {
                    SymbolTypeIntegerFixed integerFixed = (SymbolTypeIntegerFixed) toType;
                    ConstantLiteral constantLiteral;
                    Long integerValue;
                    try {
                        constantLiteral = val.calculateLiteral(program.getScope());
                        if (constantLiteral instanceof ConstantInteger) {
                            integerValue = ((ConstantInteger) constantLiteral).getValue();
                        } else if (constantLiteral instanceof ConstantPointer) {
                            integerValue = ((ConstantPointer) constantLiteral).getValue();
                        } else if (constantLiteral instanceof ConstantChar) {
                            integerValue = ((ConstantChar) constantLiteral).getInteger();
                        } else {
                            throw new InternalError("Not implemented " + constantLiteral);
                        }
                    } catch (ConstantNotLiteral e) {
                        // Assume it is a word
                        integerValue = 0xffffL;
                    }

                    if (!integerFixed.contains(integerValue)) {
                        if (toType.getSizeBytes() == 1) {
                            val = new ConstantBinary(new ConstantInteger(0xffL, SymbolType.BYTE), Operators.BOOL_AND, val);
                        } else if (toType.getSizeBytes() == 2) {
                            val = new ConstantBinary(new ConstantInteger(0xffffL, SymbolType.WORD), Operators.BOOL_AND, val);
                        } else if (toType.getSizeBytes() == 4) {
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
        } else if (value instanceof PointerDereference) {
            PointerDereference deref = (PointerDereference) value;
            SymbolType ptrType = null;
            if (castType != null) {
                ptrType = new SymbolTypePointer(castType);
            }
            if (value instanceof PointerDereferenceSimple) {
                final AsmFragmentSignatureExpr bindPointer = bind(deref.getPointer(), ptrType);
                return new AsmFragmentSignatureExpr.DerefSimple(bindPointer);
            } else if (value instanceof PointerDereferenceIndexed) {
                PointerDereferenceIndexed derefIdx = (PointerDereferenceIndexed) value;
                final AsmFragmentSignatureExpr bindPointer = bind(derefIdx.getPointer(), ptrType);
                final AsmFragmentSignatureExpr bindIndex = bind(derefIdx.getIndex());
                return new AsmFragmentSignatureExpr.DerefIdx(bindPointer, bindIndex);
            }
        } else if (value instanceof VariableRef) {
            Variable variable = program.getSymbolInfos().getVariable((VariableRef) value);
            if (castType == null) {
                castType = variable.getType();
            }
            Registers.Register register = variable.getAllocation();
            String name = getTypePrefix(castType) + getRegisterName(register);
            bind(name, variable);
            return new AsmFragmentSignatureExpr.Variable(name, castType);
        } else if (value instanceof ConstantValue) {
            if (castType == null) {
                castType = SymbolTypeInference.inferType(program.getScope(), (ConstantValue) value);
            }
            String name = getTypePrefix(castType) + getConstName(value);
            bind(name, value);
            return new AsmFragmentSignatureExpr.Variable(name, castType);
        } else if (value instanceof ProcedureRef) {
            if (castType == null) {
                castType = SymbolTypeInference.inferType(program.getScope(), (ProcedureRef) value);
            }
            String name = getTypePrefix(castType) + getConstName(value);
            bind(name, value);
            return new AsmFragmentSignatureExpr.Variable(name, castType);
        } else if (value instanceof Label) {
            String name = "la" + nextLabelIdx++;
            bind(name, value);
            return new AsmFragmentSignatureExpr.Variable(name, SymbolType.LABEL);
        } else if (value instanceof StackIdxValue) {
            StackIdxValue stackIdxValue = (StackIdxValue) value;
            return new AsmFragmentSignatureExpr.StackIdx(
                    stackIdxValue.getValueType(),
                    bindStructSize(stackIdxValue.getValueType()),
                    bind(stackIdxValue.getStackOffset()));
        } else if (value instanceof StackPushValue) {
            final StackPushValue stackPushValue = (StackPushValue) value;
            return new AsmFragmentSignatureExpr.StackPush(stackPushValue.getType(), bindStructSize(stackPushValue.getType()));
        } else if (value instanceof StackPullValue) {
            final StackPullValue stackPullValue = (StackPullValue) value;
            return new AsmFragmentSignatureExpr.StackPull(stackPullValue.getType(), bindStructSize(stackPullValue.getType()));
        } else if (value instanceof StackPullBytes) {
            final ConstantInteger bytes = (ConstantInteger) ((StackPullBytes) value).getBytes();
            return new AsmFragmentSignatureExpr.StackPullPadding(bytes);
        } else if (value instanceof StackPushBytes) {
            final ConstantInteger bytes = (ConstantInteger) ((StackPushBytes) value).getBytes();
            return new AsmFragmentSignatureExpr.StackPushPadding(bytes);
        } else if (value instanceof MemsetValue) {
            MemsetValue memsetValue = (MemsetValue) value;
            ConstantValue sizeConst = memsetValue.getSize();
            if (sizeConst.getType(program.getScope()).equals(SymbolType.NUMBER)) {
                SymbolType fixedIntegerType = SymbolTypeConversion.getSmallestUnsignedFixedIntegerType(sizeConst, program.getScope());
                sizeConst = new ConstantCastValue(fixedIntegerType, sizeConst);
            }
            return new AsmFragmentSignatureExpr.Memset(bind(sizeConst));
        } else if (value instanceof MemcpyValue) {
            MemcpyValue memcpyValue = (MemcpyValue) value;
            ConstantValue sizeConst = memcpyValue.getSize();
            if (sizeConst.getType(program.getScope()).equals(SymbolType.NUMBER)) {
                SymbolType fixedIntegerType = SymbolTypeConversion.getSmallestUnsignedFixedIntegerType(sizeConst, program.getScope());
                sizeConst = new ConstantCastValue(fixedIntegerType, sizeConst);
            }
            return new AsmFragmentSignatureExpr.Memcpy(bind(memcpyValue.getSource()), bind(sizeConst));
        }
        throw new RuntimeException("Binding of value type not supported " + value.toString(program));
    }

    /**
     * Binds the struct size (if the type is a struct.)
     *
     * @param type The type
     * @return The signature. null if the type is not a struct.
     */
    private AsmFragmentSignatureExpr bindStructSize(SymbolType type) {
        if (type instanceof SymbolTypeStruct) {
            ConstantRef sizeConst = SizeOfConstants.getSizeOfConstantVar(program.getScope(), type);
            ConstantLiteral literal = sizeConst.calculateLiteral(program.getScope());
            if (literal instanceof ConstantInteger && ((ConstantInteger) literal).getInteger() <= 4L)
                return new AsmFragmentSignatureExpr.Number((ConstantInteger) literal);
            else
                return bind(sizeConst);
        }
        return null;
    }

    /**
     * Add binding for a name/value pair if it is not already bound.
     *
     * @param name  The name
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
        if (type instanceof SymbolTypePointer) {
            SymbolType elmType = ((SymbolTypePointer) type).getElementType();
            if (elmType instanceof SymbolTypePointer) {
                SymbolType eml2Type = ((SymbolTypePointer) elmType).getElementType();
                if (eml2Type instanceof SymbolTypePointer) {
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
        if (SymbolType.BYTE.equals(baseType)) {
            return "bu";
        } else if (SymbolType.SBYTE.equals(baseType)) {
            return "bs";
        } else if (SymbolType.WORD.equals(baseType)) {
            return "wu";
        } else if (SymbolType.SWORD.equals(baseType)) {
            return "ws";
        } else if (SymbolType.DWORD.equals(baseType)) {
            return "du";
        } else if (SymbolType.SDWORD.equals(baseType)) {
            return "ds";
        } else if (SymbolType.VOID.equals(baseType)) {
            return "vo";
        } else if (SymbolType.BOOLEAN.equals(baseType)) {
            return "bo";
        } else if (baseType instanceof SymbolTypeStruct) {
            return "ss";
        } else if (baseType instanceof SymbolTypeProcedure) {
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
        if (Registers.RegisterType.ZP_MEM.equals(register.getType())) {
            // Examine if the ZP register is already bound
            Registers.RegisterZpMem registerZp = (Registers.RegisterZpMem) register;
            String memNameIdx = null;
            for (String boundName : bindings.keySet()) {
                Value boundValue = bindings.get(boundName);
                if (boundValue instanceof Variable && ((Variable) boundValue).isVariable()) {
                    Variable boundVariable = (Variable) boundValue;
                    Registers.Register boundRegister = boundVariable.getAllocation();
                    if (boundRegister != null && Registers.RegisterType.ZP_MEM.equals(boundRegister.getType())) {
                        Registers.RegisterZpMem boundRegisterZp = (Registers.RegisterZpMem) boundRegister;
                        if (registerZp.getZp() == boundRegisterZp.getZp()) {
                            // Found other register with same ZP address!
                            memNameIdx = boundName.substring(boundName.length() - 1);
                            break;
                        }
                    }
                }
            }
            // If not create a new one
            if (memNameIdx == null) {
                memNameIdx = Integer.toString(nextMemIdx++);
            }
            return "z" + memNameIdx;
        } else if (Registers.RegisterType.MAIN_MEM.equals(register.getType())) {
            String memNameIdx = null;
            for (String boundName : bindings.keySet()) {
                Value boundValue = bindings.get(boundName);
                if (boundValue instanceof Variable && ((Variable) boundValue).isVariable()) {
                    Variable boundVariable = (Variable) boundValue;
                    Registers.Register boundRegister = boundVariable.getAllocation();
                    if (boundRegister instanceof Registers.RegisterMainMem) {
                        if (boundRegister.equals(register)) {
                            memNameIdx = boundName.substring(boundName.length() - 1);
                            break;
                        }
                    }
                }
            }
            if (memNameIdx == null) {
                memNameIdx = Integer.toString(nextMemIdx++);
            }
            return "m" + memNameIdx;
        } else if (Registers.RegisterType.REG_A.equals(register.getType())) {
            return "aa";
        } else if (Registers.RegisterType.REG_X.equals(register.getType())) {
            return "xx";
        } else if (Registers.RegisterType.REG_Y.equals(register.getType())) {
            return "yy";
        } else if (Registers.RegisterType.REG_Z.equals(register.getType())) {
            return "zz";
        } else if (Registers.RegisterType.REG_ALU.equals(register.getType())) {
            throw new AsmFragmentInstance.AluNotApplicableException();
        } else {
            throw new RuntimeException("Not implemented " + register.getType());
        }
    }

    private String getConstName(Value constant) {
        // If the constant is already bound - reuse the index
        for (String boundName : bindings.keySet()) {
            Value boundValue = bindings.get(boundName);
            if (boundValue instanceof ConstantValue || (boundValue instanceof Variable && ((Variable) boundValue).isKindConstant())) {
                if (boundValue.equals(constant)) {
                    return "c" + boundName.substring(boundName.length() - 1);
                }
            }
        }
        // Otherwise use a new index
        return "c" + nextConstIdx++;
    }

}
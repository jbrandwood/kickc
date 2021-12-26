package dk.camelot64.kickc.fragment.signature;

import dk.camelot64.kickc.fragment.AsmFragmentInstance;
import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ConstantNotLiteral;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.Registers;
import dk.camelot64.kickc.model.operators.OperatorUnary;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.symbols.Label;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.*;
import dk.camelot64.kickc.model.values.*;
import dk.camelot64.kickc.passes.utils.SizeOfConstants;

import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Used to create variable bindings for ASM fragments.
 */
public class AsmFragmentBindings {

    public AsmFragmentBindings(Program program) {
        this.program = program;
        this.variables = new LinkedHashMap<>();
    }

    /**
     * The program.
     */
    public final Program program;

    /**
     * Binding of named values in the fragment to values (constants, variables, ...).
     */
    public final Map<String, Value> variables;

    /**
     * Indexing for zeropages/constants/labels.
     */
    private int nextMemIdx = 1;
    private int nextConstIdx = 1;
    private int nextLabelIdx = 1;

    /**
     * Get the symbol type part of the binding name (eg. vbu/pws/...)
     *
     * @param type The type
     * @return The type name
     */
    public static String getTypePrefix(SymbolType type) {
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
     * Add bindings of a value.
     *
     * @param value The value to bind.
     * @return The bound name of the value. If the value has already been bound the existing bound name is returned.
     */
    public AsmFragmentSignatureExpr bind(Value value) {
        return bind(value, null);
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
                return this.bind(sizeConst);
        }
        return null;
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
            for (String boundName : variables.keySet()) {
                Value boundValue = variables.get(boundName);
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
            for (String boundName : variables.keySet()) {
                Value boundValue = variables.get(boundName);
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
        for (String boundName : variables.keySet()) {
            Value boundValue = variables.get(boundName);
            if (boundValue instanceof ConstantValue || (boundValue instanceof Variable && ((Variable) boundValue).isKindConstant())) {
                if (boundValue.equals(constant)) {
                    return "c" + boundName.substring(boundName.length() - 1);
                }
            }
        }
        // Otherwise use a new index
        return "c" + nextConstIdx++;
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
            SymbolType castValueType = SymbolTypeInference.inferType(program.getScope(), castValue);
            if (castValueType.getSizeBytes() == toType.getSizeBytes()) {
                if (castType != null) {
                    if (castType.getSizeBytes() == toType.getSizeBytes()) {
                        return this.bind(castValue, castType);
                    } else {
                        OperatorUnary castUnary = Operators.getCastUnary(castType);
                        return new AsmFragmentSignatureExpr.Unary(castUnary, this.bind(castValue, toType));
                    }
                } else {
                    return this.bind(castValue, toType);
                }
            } else {
                // Size of inner value and inner cast type mismatches - require explicit conversion
                if (castType != null) {
                    OperatorUnary castUnaryInner = Operators.getCastUnary(toType);
                    OperatorUnary castUnaryOuter = Operators.getCastUnary(castType);
                    return new AsmFragmentSignatureExpr.Unary(castUnaryOuter, new AsmFragmentSignatureExpr.Unary(castUnaryInner, this.bind(castValue)));
                } else {
                    OperatorUnary castUnaryInner = Operators.getCastUnary(toType);
                    return new AsmFragmentSignatureExpr.Unary(castUnaryInner, this.bind(castValue));
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

                return this.bind(val, toType);
            } else {
                return this.bind(val, castType);
            }
        } else if (value instanceof PointerDereference) {
            PointerDereference deref = (PointerDereference) value;
            SymbolType ptrType = null;
            if (castType != null) {
                ptrType = new SymbolTypePointer(castType);
            }
            if (value instanceof PointerDereferenceSimple) {
                final AsmFragmentSignatureExpr bindPointer = this.bind(deref.getPointer(), ptrType);
                return new AsmFragmentSignatureExpr.DerefSimple(bindPointer);
            } else if (value instanceof PointerDereferenceIndexed) {
                PointerDereferenceIndexed derefIdx = (PointerDereferenceIndexed) value;
                final AsmFragmentSignatureExpr bindPointer = this.bind(derefIdx.getPointer(), ptrType);
                final AsmFragmentSignatureExpr bindIndex = this.bind(derefIdx.getIndex());
                return new AsmFragmentSignatureExpr.DerefIdx(bindPointer, bindIndex);
            }
        } else if (value instanceof VariableRef) {
            Variable variable = program.getSymbolInfos().getVariable((VariableRef) value);
            if (castType == null) {
                castType = variable.getType();
            }
            Registers.Register register = variable.getAllocation();
            String name = getTypePrefix(castType) + this.getRegisterName(register);
            bind(name, variable);
            return new AsmFragmentSignatureExpr.Variable(name, castType);
        } else if (value instanceof ConstantValue) {
            if (castType == null) {
                castType = SymbolTypeInference.inferType(program.getScope(), (ConstantValue) value);
            }
            String name = getTypePrefix(castType) + this.getConstName(value);
            bind(name, value);
            return new AsmFragmentSignatureExpr.Variable(name, castType);
        } else if (value instanceof ProcedureRef) {
            if (castType == null) {
                castType = SymbolTypeInference.inferType(program.getScope(), (ProcedureRef) value);
            }
            String name = getTypePrefix(castType) + this.getConstName(value);
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
                    this.bindStructSize(stackIdxValue.getValueType()),
                    this.bind(stackIdxValue.getStackOffset()));
        } else if (value instanceof StackPushValue) {
            final StackPushValue stackPushValue = (StackPushValue) value;
            return new AsmFragmentSignatureExpr.StackPush(stackPushValue.getType(), this.bindStructSize(stackPushValue.getType()));
        } else if (value instanceof StackPullValue) {
            final StackPullValue stackPullValue = (StackPullValue) value;
            return new AsmFragmentSignatureExpr.StackPull(stackPullValue.getType(), this.bindStructSize(stackPullValue.getType()));
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
            return new AsmFragmentSignatureExpr.Memset(this.bind(sizeConst));
        } else if (value instanceof MemcpyValue) {
            MemcpyValue memcpyValue = (MemcpyValue) value;
            ConstantValue sizeConst = memcpyValue.getSize();
            if (sizeConst.getType(program.getScope()).equals(SymbolType.NUMBER)) {
                SymbolType fixedIntegerType = SymbolTypeConversion.getSmallestUnsignedFixedIntegerType(sizeConst, program.getScope());
                sizeConst = new ConstantCastValue(fixedIntegerType, sizeConst);
            }
            return new AsmFragmentSignatureExpr.Memcpy(this.bind(memcpyValue.getSource()), this.bind(sizeConst));
        }
        throw new RuntimeException("Binding of value type not supported " + value.toString(program));
    }

    /**
     * Add binding for a name/value pair if it is not already bound.
     *
     * @param name  The name
     * @param value The value
     */
    public void bind(String name, Value value) {
        variables.putIfAbsent(name, value);
    }

}

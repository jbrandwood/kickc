package dk.camelot64.kickc.fragment.signature;

import dk.camelot64.kickc.model.operators.OperatorBinary;
import dk.camelot64.kickc.model.operators.OperatorUnary;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.ConstantInteger;

/**
 * An expression that is a part of an ASM fragment signature.
 */
public interface AsmFragmentSignatureExpr {

    /**
     * Get the signature expression name. Eg. <code>pbum2_derefidx_vbuyy</code>
     * Signature names are usable as file names.
     *
     * @return The signature name
     */
    String getName();

    /**
     * A binary expression that is part of an ASM fragment signature.
     */
    class Binary implements AsmFragmentSignatureExpr {

        final private OperatorBinary operator;
        final private AsmFragmentSignatureExpr left;
        final private AsmFragmentSignatureExpr right;

        public Binary(OperatorBinary operator, AsmFragmentSignatureExpr left, AsmFragmentSignatureExpr right) {
            this.operator = operator;
            this.left = left;
            this.right = right;
        }

        public AsmFragmentSignatureExpr getLeft() {
            return left;
        }

        public AsmFragmentSignatureExpr getRight() {
            return right;
        }

        @Override
        public String getName() {
            return left.getName() + operator.getAsmOperator() + right.getName();
        }
    }

    /**
     * A indexed pointer dereference <code>pointer[index]</code> expression that is part of an ASM fragment signature.
     */
    class DerefIdx implements AsmFragmentSignatureExpr {

        final private AsmFragmentSignatureExpr pointer;
        final private AsmFragmentSignatureExpr index;

        public DerefIdx(AsmFragmentSignatureExpr pointer, AsmFragmentSignatureExpr index) {
            this.pointer = pointer;
            this.index = index;
        }

        @Override
        public String getName() {
            final boolean pointerHasDeref = hasDeref(pointer);
            final boolean indexHasDeref = hasDeref(index);

            return
                    (pointerHasDeref ? "(" : "") + pointer.getName() + (pointerHasDeref ? ")" : "")
                            + "_derefidx_"
                            + (indexHasDeref ? "(" : "") + index.getName() + (indexHasDeref ? ")" : "");
        }
    }

    /**
     * A pointer dereference <code>*pointer</code> expression that is part of an ASM fragment signature.
     */
    class DerefSimple implements AsmFragmentSignatureExpr {

        final private AsmFragmentSignatureExpr pointer;

        public DerefSimple(AsmFragmentSignatureExpr pointer) {
            this.pointer = pointer;
        }

        public AsmFragmentSignatureExpr getPointer() {
            return pointer;
        }

        @Override
        public String getName() {
            if (hasDeref(pointer)) {
                return "_deref_" + "(" + pointer.getName() + ")";
            } else {
                return "_deref_" + pointer.getName();
            }
        }
    }

    /**
     * Make4long creates a 32bit integer from 4 bytes.
     */
    class Makelong4 implements AsmFragmentSignatureExpr {

        final private AsmFragmentSignatureExpr byte3;
        final private AsmFragmentSignatureExpr byte2;
        final private AsmFragmentSignatureExpr byte1;
        final private AsmFragmentSignatureExpr byte0;

        public Makelong4(AsmFragmentSignatureExpr byte3, AsmFragmentSignatureExpr byte2, AsmFragmentSignatureExpr byte1, AsmFragmentSignatureExpr byte0) {
            this.byte3 = byte3;
            this.byte2 = byte2;
            this.byte1 = byte1;
            this.byte0 = byte0;
        }

        @Override
        public String getName() {
            return "_makelong4_("
                    + byte3.getName() + ")_("
                    + byte2.getName() + ")_("
                    + byte1.getName() + ")_("
                    + byte0.getName() + ")";
        }
    }

    /**
     * Memcpy copies a number of bytes in memory
     */
    class Memcpy implements AsmFragmentSignatureExpr {

        final private AsmFragmentSignatureExpr source;
        final private AsmFragmentSignatureExpr size;

        public Memcpy(AsmFragmentSignatureExpr source, AsmFragmentSignatureExpr size) {
            this.source = source;
            this.size = size;
        }

        @Override
        public String getName() {
            return source.getName() + "_memcpy_" + size.getName();
        }
    }

    /**
     * Memset zero-fills a number of bytes in memory
     */
    class Memset implements AsmFragmentSignatureExpr {

        final private AsmFragmentSignatureExpr size;

        public Memset(AsmFragmentSignatureExpr size) {
            this.size = size;
        }

        @Override
        public String getName() {
            return "_memset_" + size.getName();
        }
    }

    /**
     * A very small constant number (eg. 0, 1, 2, ...).
     * USed for optimizing fragments for very small constant numbers.
     */
    class Number implements AsmFragmentSignatureExpr {

        /**
         * The number
         */
        final private ConstantInteger number;

        public Number(ConstantInteger number) {
            this.number = number;
        }

        @Override
        public String getName() {
            return number.toString();
        }
    }

    class StackIdx implements AsmFragmentSignatureExpr {

        /**
         * The type of value to access on the stack.
         */
        final private SymbolType type;
        /**
         * If the type is a struct this holds the size fo the struct. Otherwise null.
         */
        final private AsmFragmentSignatureExpr structTypeSize;
        /**
         * The byte offset on the stack where the value is placed.
         */
        final private AsmFragmentSignatureExpr offset;

        public StackIdx(SymbolType type, AsmFragmentSignatureExpr structTypeSize, AsmFragmentSignatureExpr offset) {
            this.type = type;
            this.structTypeSize = structTypeSize;
            this.offset = offset;
        }

        @Override
        public String getName() {
            String typeShortName = Operators.getCastUnary(type).getAsmOperator().replace("_", "");
            String structTypeSizeName = "";
            if (this.structTypeSize != null)
                structTypeSizeName = "_" + this.structTypeSize.getName();
            return "_stackidx" + typeShortName + structTypeSizeName + "_" + offset.getName();
        }
    }

    class StackPull implements AsmFragmentSignatureExpr {

        /**
         * The type of value to pull from the stack.
         */
        final private SymbolType type;
        /**
         * If the type is a struct this holds the size fo the struct. Otherwise null.
         */
        final private AsmFragmentSignatureExpr structTypeSize;

        public StackPull(SymbolType type, AsmFragmentSignatureExpr structTypeSize) {
            this.type = type;
            this.structTypeSize = structTypeSize;
        }

        @Override
        public String getName() {
            String typeShortName = Operators.getCastUnary(type).getAsmOperator().replace("_", "");
            String structTypeSizeName = "";
            if (this.structTypeSize != null)
                structTypeSizeName = this.structTypeSize.getName() + "_";
            return "_stackpull" + typeShortName + "_" + structTypeSizeName;
        }
    }

    class StackPullPadding implements AsmFragmentSignatureExpr {

        /**
         * The number of padding bytes to pull.
         */
        final private ConstantInteger bytes;

        public StackPullPadding(ConstantInteger bytes) {
            this.bytes = bytes;
        }

        @Override
        public String getName() {
            return "_stackpullbyte_" + bytes.toString();
        }
    }

    class StackPush implements AsmFragmentSignatureExpr {

        /**
         * The type of value to push onto the stack.
         */
        final private SymbolType type;
        /**
         * If the type is a struct this holds the size fo the struct. Otherwise null.
         */
        final private AsmFragmentSignatureExpr structTypeSize;

        public StackPush(SymbolType type, AsmFragmentSignatureExpr structTypeSize) {
            this.type = type;
            this.structTypeSize = structTypeSize;
        }

        @Override
        public String getName() {
            String typeShortName = Operators.getCastUnary(type).getAsmOperator().replace("_", "");
            String structTypeSizeName = "";
            if (this.structTypeSize != null)
                structTypeSizeName = this.structTypeSize.getName() + "_";
            return "_stackpush" + typeShortName + "_" + structTypeSizeName;
        }
    }

    class StackPushPadding implements AsmFragmentSignatureExpr {

        /**
         * The number of padding bytes to push.
         */
        final private ConstantInteger bytes;

        public StackPushPadding(ConstantInteger bytes) {
            this.bytes = bytes;
        }

        @Override
        public String getName() {
            return "_stackpushbyte_" + bytes.toString();
        }
    }

    /**
     * An unary expression that is part of an ASM fragment signature.
     */
    class Unary implements AsmFragmentSignatureExpr {

        final private OperatorUnary operator;
        final private AsmFragmentSignatureExpr operand;

        public Unary(OperatorUnary operator, AsmFragmentSignatureExpr operand) {
            this.operator = operator;
            this.operand = operand;
        }

        public AsmFragmentSignatureExpr getOperand() {
            return operand;
        }

        @Override
        public String getName() {
            return operator.getAsmOperator() + operand.getName();
        }
    }

    /**
     * An ASM fragment variable that is part of an ASM fragment signature.
     * The ASM fragment variable models the type and binding of a single parameter that is part of an ASM fragment.
     * <p>
     * For instance in the fragment <code>pbuz1=pbuz1+pbuc1[vbuxx]</code> the value <code>pbuz1</code> has the type
     * <code>uint8_t * __zp pbuz1;</code>
     */
    class Variable implements AsmFragmentSignatureExpr {

        /**
         * The name of the fragment value. Eg. <code>pbuz1</code>.
         */
        final private String name;
        /**
         * The type of the fragment value. Eg. <code>uint8_t * __zp</code>
         */
        final private SymbolType type;

        public Variable(String name, SymbolType type) {
            this.name = name;
            this.type = type;
        }

        public String getName() {
            return name;
        }

        public SymbolType getType() {
            return type;
        }
    }

    /**
     * Detect if an expression has a deref
     *
     * @param pointer The expression
     * @return true if the expression has a deref
     */
    static boolean hasDeref(AsmFragmentSignatureExpr pointer) {
        if (pointer instanceof DerefSimple)
            return true;
        else if (pointer instanceof DerefIdx)
            return true;
        else if (pointer instanceof Unary)
            return hasDeref(((Unary) pointer).getOperand());
        else if (pointer instanceof Binary) {
            return hasDeref(((Binary) pointer).getLeft()) || hasDeref(((Binary) pointer).getRight());
        } else
            return false;
    }


}
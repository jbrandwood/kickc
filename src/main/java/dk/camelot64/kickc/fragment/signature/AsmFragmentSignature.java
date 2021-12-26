package dk.camelot64.kickc.fragment.signature;

/**
 * A signature of an ASM fragment.
 * The signature captures the operation performed by the fragment and the types of the parameters.
 */
public interface AsmFragmentSignature {

    /**
     * Get the signature name. Eg. <code>vbum1=pbum2_derefidx_vbuyy</code>
     * Signature names are usable as file names.
     *
     * @return The signature name
     */
    String getName();

    /**
     * ASM fragment signature for an assignment <code>A=B</code>.
     */
    class Assignment implements AsmFragmentSignature {

        final private AsmFragmentSignatureExpr lValue;
        final private AsmFragmentSignatureExpr rValue;

        public Assignment(AsmFragmentSignatureExpr lValue, AsmFragmentSignatureExpr rValue) {
            this.lValue = lValue;
            this.rValue = rValue;
        }

        @Override
        public String getName() {
            return lValue.getName() + "=" + rValue.getName();
        }
    }

    /**
     * ASM fragment signature for a conditional jump <code>if(A) goto B</code>.
     */
    class Call implements AsmFragmentSignature {

        final private AsmFragmentSignatureExpr procedure;

        public Call(AsmFragmentSignatureExpr procedure) {
            this.procedure = procedure;
        }

        @Override
        public String getName() {
            return "call_" + procedure.getName();
        }
    }

    /**
     * ASM fragment signature for a conditional jump <code>if(A) goto B</code>.
     */
    class ConditionalJump implements AsmFragmentSignature {

        final private AsmFragmentSignatureExpr condition;
        final private AsmFragmentSignatureExpr label;

        public ConditionalJump(AsmFragmentSignatureExpr condition, AsmFragmentSignatureExpr label) {
            this.condition = condition;
            this.label = label;
        }

        @Override
        public String getName() {
            return condition.getName() + "_then_" + label.getName();
        }
    }

    /**
     * ASM fragment signature for a stand-alone expression with a side-effect.
     */
    class ExprSideEffect implements AsmFragmentSignature {

        final private AsmFragmentSignatureExpr expr;

        public ExprSideEffect(AsmFragmentSignatureExpr expr) {
            this.expr = expr;
        }

        @Override
        public String getName() {
            return expr.getName();
        }
    }

    /** Interrupt Service Routine Entry Code. */
    class IsrEntry implements AsmFragmentSignature {

        final private String interruptType;

        public IsrEntry(String interruptType) {
            this.interruptType = interruptType;
        }

        @Override
        public String getName() {
            return "isr_" + interruptType + "_entry";
        }
    }

    /** Interrupt Service Routine Exit Code. */
    class IsrExit implements AsmFragmentSignature {

        final private String interruptType;

        public IsrExit(String interruptType) {
            this.interruptType = interruptType;
        }

        @Override
        public String getName() {
            return "isr_" + interruptType + "_exit";
        }
    }
}

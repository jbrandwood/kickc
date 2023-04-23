package dk.camelot64.kickc.fragment.signature;

import dk.camelot64.kickc.asm.fragment.signature.AsmFragmentSignatureLexer;
import dk.camelot64.kickc.asm.fragment.signature.AsmFragmentSignatureParser;
import dk.camelot64.kickc.model.symbols.Bank;
import dk.camelot64.kickc.model.symbols.Procedure;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;

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
     * Parses a signature name to a typed signature.
     * @param sigName The signature name (created by signature.getName())
     * @return The signature
     */
    static AsmFragmentSignature parse(String sigName) {
        final CharStream sigCharStream = CharStreams.fromString(sigName);
        AsmFragmentSignatureLexer sigLexer = new AsmFragmentSignatureLexer(sigCharStream);
        AsmFragmentSignatureParser sigParser = new AsmFragmentSignatureParser(new CommonTokenStream(sigLexer));
        final AsmFragmentSignatureParser.SignatureContext sigCtx = sigParser.signature();
        final AsmFragmentSignatureInstantiator instantiator = new AsmFragmentSignatureInstantiator();
        return instantiator.visitSignature(sigCtx);
    }

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
     * ASM fragment signature for a call
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
     * ASM fragment signature for a banked call
     */
    class CallBanked implements AsmFragmentSignature {

        final private String callingConvention;

        final private Procedure.CallingProximity proximity;

        final private Bank toBank;

        public CallBanked(String callingConvention, Procedure.CallingProximity proximity, Bank toBank) {
            this.callingConvention = callingConvention;
            this.proximity = proximity;
            this.toBank = toBank;
        }

        @Override
        public String getName() {
            return "call_" + callingConvention.toLowerCase() + "_" + proximity.toString().toLowerCase() + (proximity.equals(Procedure.CallingProximity.NEAR)?"":("_"+toBank.bankArea()));
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

    /** Interrupt Service Routine Code. */
    class Isr implements AsmFragmentSignature {

        final private String interruptType;

        public enum EntryExit {
            Entry,
            Exit
        }

        final private EntryExit entryExit;

        public Isr(String interruptType, EntryExit entryExit) {
            this.interruptType = interruptType;
            this.entryExit = entryExit;
        }

        @Override
        public String getName() {
            return "isr_" + interruptType + "_" + entryExit.name().toLowerCase();
        }
    }

}

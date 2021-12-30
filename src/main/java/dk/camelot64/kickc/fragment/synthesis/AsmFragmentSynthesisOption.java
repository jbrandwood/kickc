package dk.camelot64.kickc.fragment.synthesis;

import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

/**
 * An option for synthesizing a fragment template from a sub-template using a specific synthesis rule. An edge in the synthesis graph.
 */
public class AsmFragmentSynthesisOption {

    /**
     * The signature of the fragment template being synthesized. The from-node in the graph.
     */
    private final String signature;

    /**
     * The signatures of the sub-fragment templates to synthesize from. The to-nodes in the graph.
     */
    private final List<String> subSignatures;

    /**
     * The synthesis rule capable of synthesizing this template from the sub-fragments.
     */
    private final AsmFragmentTemplateSynthesisRule rule;

    /**
     * Create a synthesis option
     *
     * @param signature the signature of the fragment template being synthesized.
     * @param rule      The synthesis rule capable of synthesizing this template from the sub-fragment.
     */
    AsmFragmentSynthesisOption(String signature, AsmFragmentTemplateSynthesisRule rule) {
        this.signature = signature.intern();
        this.rule = rule;
        this.subSignatures = rule.getSubSignatures(signature).stream().map(String::intern).collect(Collectors.toList());
    }

    public String getSignature() {
        return signature;
    }

    List<String> getSubSignatures() {
        return subSignatures;
    }

    AsmFragmentTemplateSynthesisRule getRule() {
        return rule;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        AsmFragmentSynthesisOption that = (AsmFragmentSynthesisOption) o;
        return Objects.equals(signature, that.signature) &&
                Objects.equals(subSignatures, that.subSignatures) &&
                Objects.equals(rule, that.rule);
    }

    @Override
    public int hashCode() {
        return Objects.hash(signature, subSignatures, rule);
    }
}

package dk.camelot64.kickc.fragment.synthesis;

import dk.camelot64.kickc.fragment.AsmFragmentTemplate;

import java.util.List;

/**
 * A synthesis rule can create new {@link AsmFragmentTemplate}s from other {@link AsmFragmentTemplate}s.
 */
public interface AsmFragmentTemplateSynthesisRule {

    /**
     * Is the rule match usable for synthesizing a fragment template
     *
     * @param signature The fragment template signature
     * @return true if the rule matches the signature
     */
    boolean matches(String signature);

    /**
     * The signatures of the sub-templates to synthesize the template from
     *
     * @param signature The signature to synthesize
     * @return Signatures of the sub-templates to synthesize the template from. null if the rule does not match the signature.
     */
    List<String> getSubSignatures(String signature);

    /**
     * Synthesize a fragment template from a sub fragment template.
     *
     * @param signature   The signature to synthesize
     * @param subTemplates The sub-templates that matches the sub-signatures
     * @return The synthesized ASM fragment template.
     * Null if the fragment cannot be synthesized (for instance due to clobber constraints).
     */
    AsmFragmentTemplate synthesize(String signature, List<AsmFragmentTemplate> subTemplates);
}

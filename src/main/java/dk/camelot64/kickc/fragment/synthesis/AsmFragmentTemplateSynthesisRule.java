package dk.camelot64.kickc.fragment.synthesis;

import dk.camelot64.kickc.fragment.AsmFragmentTemplate;

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
     * The signature of the sub-template to synthesize the template from
     *
     * @param signature The signature to synthesize
     * @return Signature of the sub-template to synthesize the template from. null if the rule does not match the signature.
     */
    String getSubSignature(String signature);

    /**
     * Synthesize a template from a sub template.
     *
     * @param signature   The signature to synthesize
     * @param subTemplate A sub-template that matches the sub-signature
     * @return The synthesized ASM fragment template
     */
    AsmFragmentTemplate synthesize(String signature, AsmFragmentTemplate subTemplate);

}

package dk.camelot64.kickc.fragment.synthesis;

import dk.camelot64.kickc.fragment.AsmFragmentClobber;

import java.util.*;

/**
 * The synthesis is capable of loading the fragment from disk or synthesizing it from other fragments using synthesis rules.
 * The synthesis caches the best fragments for each clobber profile (loaded or synthesized).
 * A node in the synthesis graph.
 */
public class AsmFragmentSynthesis {

    /**
     * The signature of the fragment template being synthesized.
     */
    private final String signature;

    /**
     * The best template loaded/synthesized so far for each clobber profile
     */
    private final Map<AsmFragmentClobber, AsmFragmentSynthesisResult> bestTemplates;

    /**
     * Options for synthesizing the template from sub-fragments using a specific synthesis rule. Forward edges in the synthesis graph.
     */
    private final List<AsmFragmentSynthesisOption> synthesisOptions;

    /**
     * Options for synthesizing the other templates from this template using a specific synthesis rule. Backward edges in the synthesis graph.
     */
    private final List<AsmFragmentSynthesisOption> parentOptions;

    /**
     * The templates loaded from a file. Empty if no file exists for the signature.
     */
    private final List<AsmFragmentSynthesisResult> fileTemplates;

    /**
     * Create a new synthesis
     *
     * @param signature The signature of the fragment template to load/synthesize
     */
    AsmFragmentSynthesis(String signature) {
        this.signature = signature.intern();
        this.bestTemplates = new LinkedHashMap<>();
        this.synthesisOptions = new ArrayList<>();
        this.parentOptions = new ArrayList<>();
        this.fileTemplates = new ArrayList<>();
    }

    /**
     * Add a synthesis option to the template synthesis.
     * The synthesis options can be used for synthesizing the template from sub-fragments using a specific synthesis rule.
     *
     * @param synthesisOption The option to add
     */
    void addSynthesisOption(AsmFragmentSynthesisOption synthesisOption) {
        this.synthesisOptions.add(synthesisOption);
    }

    /**
     * Get the options for synthesizing the template from sub-fragments using a specific synthesis rule. Forward edges in the synthesis graph.
     *
     * @return The options
     */
    Collection<AsmFragmentSynthesisOption> getSynthesisOptions() {
        return synthesisOptions;
    }

    /**
     * Add a parent. The parent is an option for synthesizing another fragment template from this one using a specific synthesis rule.
     *
     * @param synthesisOption Thew parent option to add
     */
    void addParentOption(AsmFragmentSynthesisOption synthesisOption) {
        this.parentOptions.add(synthesisOption);
    }

    void addFileTemplate(AsmFragmentSynthesisResult fileTemplate) {
        this.fileTemplates.add(fileTemplate);
    }

    List<AsmFragmentSynthesisResult> getFileTemplates() {
        return fileTemplates;
    }

    /**
     * Handle a candidate for best template.
     * If the candidate is better than the current best for its clobber profile update the best template
     *
     * @param candidate The template candidate to examine
     * @return true if the best template was updated
     */
    boolean bestTemplateCandidate(AsmFragmentSynthesisResult candidate) {
        AsmFragmentClobber candidateClobber = candidate.getClobber();
        double candidateCycles = candidate.getCycles();

        // Check if any current best templates are better
        Set<AsmFragmentClobber> bestClobbers = new LinkedHashSet<>(bestTemplates.keySet());
        for (AsmFragmentClobber bestClobber : bestClobbers) {
            AsmFragmentSynthesisResult bestTemplate = bestTemplates.get(bestClobber);
            double bestCycles = bestTemplate.getCycles();
            if (bestClobber.isTrueSubset(candidateClobber) && bestCycles <= candidateCycles) {
                // A better template already found - don't update
                return false;
            }
            if (bestClobber.isSubset(candidateClobber) && bestCycles < candidateCycles) {
                // A better template already found - don't update
                return false;
            }
            if (bestClobber.equals(candidateClobber) && bestCycles == candidateCycles && bestTemplate.getBody().compareTo(candidate.getBody()) <= 0) {
                // A better template already found - don't update
                return false;
            }

        }

        // The candidate is better than some of the current best!

        // Remove any current templates that are worse
        for (AsmFragmentClobber bestClobber : bestClobbers) {
            AsmFragmentSynthesisResult bestTemplate = bestTemplates.get(bestClobber);
            double bestCycles = bestTemplate.getCycles();

            if (candidateClobber.isTrueSubset(bestClobber) && candidateCycles <= bestCycles) {
                // The candidate is better - remove the current template
                bestTemplates.remove(bestClobber);
            }
            if (candidateClobber.isSubset(bestClobber) && candidateCycles < bestCycles) {
                // The candidate is better - remove the current template
                bestTemplates.remove(bestClobber);
            }
            if (candidateClobber.equals(bestClobber) && candidateCycles == bestCycles && candidate.getBody().compareTo(bestTemplate.getBody()) <= 0) {
                // The candidate is better - remove the current template
                bestTemplates.remove(bestClobber);
            }

        }
        // Update the current best
        bestTemplates.put(candidateClobber, candidate);
        return true;
    }

    /**
     * Get the parent options.
     * These are options for synthesizing other templates
     * from this template using a specific synthesis rule. Backward edges in the synthesis graph.
     *
     * @return The parent options.
     */
    List<AsmFragmentSynthesisOption> getParentOptions() {
        return parentOptions;
    }

    /**
     * Get the best fragment templates of the synthesis.
     * Multiple templates are returned if templates with different clobber profiles exist.
     *
     * @return The best templates of the synthesis.
     */
    public Collection<AsmFragmentSynthesisResult> getBestTemplates() {
        return bestTemplates.values();
    }

    public String getSignature() {
        return signature;
    }
}

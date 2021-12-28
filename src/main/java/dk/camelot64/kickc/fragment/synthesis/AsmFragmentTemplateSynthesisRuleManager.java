package dk.camelot64.kickc.fragment.synthesis;

import dk.camelot64.kickc.model.TargetCpu;

import java.util.*;

/**
 * Holds all synthesis rules
 */
public class AsmFragmentTemplateSynthesisRuleManager {

    /** All the synthesis rules available for each CPU. */
    private static Map<TargetCpu, List<AsmFragmentTemplateSynthesisRule>> synthesisRules = new LinkedHashMap<>();

    /**
     * Get the synthesis rules usable for a specific CPU.
     * @param targetCpu The target CPU
     * @return All rules usable for the CPU
     */
    static List<AsmFragmentTemplateSynthesisRule> getSynthesisRules(TargetCpu targetCpu) {
        if(synthesisRules.get(targetCpu) == null) {
            synthesisRules.put(targetCpu, AsmFragmentTemplateSynthesisRuleRegexManager.getFragmentSyntheses(targetCpu));
        }
        return synthesisRules.get(targetCpu);
    }

    /** Get all fragment synthesis rules for any CPU
     *
     * @return All rules
     */
    public static Collection<AsmFragmentTemplateSynthesisRule> getAllSynthesisRules() {
       final LinkedHashSet<AsmFragmentTemplateSynthesisRule> allRules = new LinkedHashSet<>();
       for(TargetCpu targetCpu : TargetCpu.values()) {
          allRules.addAll(getSynthesisRules(targetCpu));
       }
       return allRules;
    }
}

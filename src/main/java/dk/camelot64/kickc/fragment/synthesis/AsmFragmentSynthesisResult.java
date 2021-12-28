package dk.camelot64.kickc.fragment.synthesis;

import dk.camelot64.kickc.fragment.AsmFragmentClobber;
import dk.camelot64.kickc.fragment.AsmFragmentTemplate;

import java.util.List;

/**
 * A successfully synthesized or loaded fragment.
 */
public class AsmFragmentSynthesisResult {

    /**
     * The ASM fragment template.
     */
    final AsmFragmentTemplate fragment;

    /**
     * true if the fragment was loaded from disk.
     */
    private boolean file;
    /**
     * true if the fragment was loaded from the disk cache.
     */
    private boolean cache;

    /**
     * The synthesis that created the fragment. null if the fragment template was loaded.
     */
    private AsmFragmentTemplateSynthesisRule synthesis;
    /**
     * The sub fragment template that the synthesis used to create this.
     */
    private List<AsmFragmentSynthesisResult> subFragments;

    public AsmFragmentSynthesisResult(AsmFragmentTemplate fragment, boolean file, boolean cache, AsmFragmentTemplateSynthesisRule synthesis, List<AsmFragmentSynthesisResult> subFragments) {
        this.fragment = fragment;
        this.file = file;
        this.cache = cache;
        this.synthesis = synthesis;
        this.subFragments = subFragments;
    }

    public boolean isFile() {
        return file;
    }

    public boolean isCache() {
        return cache;
    }

    public AsmFragmentTemplateSynthesisRule getSynthesis() {
        return synthesis;
    }

    public AsmFragmentTemplate getFragment() {
        return fragment;
    }

    public List<AsmFragmentSynthesisResult> getSubFragments() {
        return subFragments;
    }

    public String getName() {
        StringBuilder name = new StringBuilder();
        name.append(fragment.getSignature());
        if (synthesis != null) {
            name.append(" < ");
            if (subFragments.size() == 1) {
                name.append(subFragments.get(0).getName());
            } else {
                for (AsmFragmentSynthesisResult subFragment : subFragments) {
                    name.append("(");
                    name.append(subFragment.getName());
                    name.append(")");
                }
            }
        }
        return name.toString();
    }


    public AsmFragmentClobber getClobber() {
        return fragment.getClobber();
    }

    public double getCycles() {
        return fragment.getCycles();
    }

    public String getBody() {
        return fragment.getBody();
    }

    public String getSignature() {
        return fragment.getSignature();
    }
}

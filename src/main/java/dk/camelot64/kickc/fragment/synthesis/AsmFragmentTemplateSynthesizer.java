package dk.camelot64.kickc.fragment.synthesis;

import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.fragment.*;
import dk.camelot64.kickc.model.TargetCpu;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Path;
import java.util.*;
import java.util.stream.Collectors;

/**
 * Provides fragment templates from their signature.
 * <p>
 * Fragment templates are created by either:
 * <ul>
 * <li>Loading a fragment file from the fragment-folder.</li>
 * <li>synthesising from another fragment using one of the  {@link AsmFragmentTemplateSynthesisRule}s.</li>
 * </ul>
 * <p>
 * The actual creation is handled by a full-graph
 */
public class AsmFragmentTemplateSynthesizer {

   /** Create synthesizer. */
    public AsmFragmentTemplateSynthesizer(TargetCpu targetCpu, Path baseFragmentFolder, boolean useFragmentCache, CompileLog log) {
        this.baseFragmentFolder = baseFragmentFolder;
        this.targetCpu = targetCpu;
        this.synthesisGraph = new LinkedHashMap<>();
        this.bestTemplateUpdate = new ArrayDeque<>();
        if (useFragmentCache)
            this.fragmentCache = AsmFragmentTemplateCache.load(targetCpu, baseFragmentFolder, log);
        else
            this.fragmentCache = AsmFragmentTemplateCache.memoryCache(targetCpu);
    }

   /** The folder containing fragment files. */
    private final Path baseFragmentFolder;

   /** The Target CPU - used for obtaining CPU-specific fragment files. */
    private final TargetCpu targetCpu;

   /** Cache for the best fragment templates. Maps signature to the best fragment template for the signature. */
    private final AsmFragmentTemplateCache fragmentCache;

    /**
     * Contains the synthesis for each fragment template signature.
     * The synthesis is capable of loading the fragment from disk or synthesizing it from other fragments using synthesis rules.
     * The synthesis caches the best fragments for each clobber profile (loaded or synthesized).
     * This map is effectively a full-graph where the nodes are synthesis for signatures and edges are the
     * synthesis rules capable of synthesizing one fragment temple from another.
     */
    private final Map<String, AsmFragmentSynthesis> synthesisGraph;

   /** Finalize the fragment template synthesizer. */
    void finalize(CompileLog log) {
        if (fragmentCache != null)
            fragmentCache.save(baseFragmentFolder, log);
    }

    /**
     * Get information about the size of the synthesizer data structures
     *
     * @return the size
     */
    public int getSize() {
        return synthesisGraph.size();
    }

    public AsmFragmentInstance getFragmentInstance(AsmFragmentInstanceSpec instanceSpec, CompileLog log) {
        String signature = instanceSpec.getSignature();
        AsmFragmentTemplate fragmentTemplate = getFragmentTemplate(signature, log);
        // Return the resulting fragment instance
        return new AsmFragmentInstance(
                instanceSpec.getProgram(),
                signature,
                instanceSpec.getCodeScope(),
                fragmentTemplate,
                instanceSpec.getBindings());
    }

    /**
     * Get the best fragment templates for a signature
     *
     * @param signature The signature
     * @param log       The log
     * @return The best templates (with different clobber profiles) for the signature
     */
    private AsmFragmentTemplate getFragmentTemplate(String signature, CompileLog log) {
        // Attempt to find in memory/disk cache
        AsmFragmentTemplate bestTemplate = fragmentCache.get(signature);
        if (bestTemplate == AsmFragmentTemplateCache.NO_SYNTHESIS) {
            if (log.isVerboseFragmentLog()) {
                log.append("Unknown fragment " + signature);
            }
            throw new UnknownFragmentException(signature);
        }
        if (bestTemplate != null) {
            AsmFragmentTemplateUsages.incUsage(new AsmFragmentSynthesisResult(bestTemplate, false, true, null, new ArrayList<>()));
            return bestTemplate;
        }

        AsmFragmentSynthesisResult bestResult = null;
        // Attempt to synthesize or load in main fragment folder
        Collection<AsmFragmentSynthesisResult> candidates = getBestTemplates(signature, log);
        if (candidates.size() == 0) {
            if (log.isVerboseFragmentLog()) {
                log.append("Unknown fragment " + signature);
            }
            fragmentCache.put(signature, AsmFragmentTemplateCache.NO_SYNTHESIS);
            throw new UnknownFragmentException(signature);
        }
        double minScore = Double.MAX_VALUE;
        for (AsmFragmentSynthesisResult candidateTemplate : candidates) {
            double score = candidateTemplate.getCycles();
            if (candidateTemplate.getClobber().isClobberZ()) score += 0.25;
            if (candidateTemplate.getClobber().isClobberA()) score += 0.5;
            if (candidateTemplate.getClobber().isClobberY()) score += 1.0;
            if (candidateTemplate.getClobber().isClobberX()) score += 1.5;
            if (score < minScore) {
                minScore = score;
                bestResult = candidateTemplate;
            }
        }
        if (log.isVerboseFragmentLog()) {
            log.append("Found best fragment  " + bestResult.getName() + " score: " + minScore);
        }
        fragmentCache.put(signature, bestResult.getFragment());
        AsmFragmentTemplateUsages.incUsage(bestResult);
        return bestResult.getFragment();
    }


    /**
     * Get the best fragment templates for a signature.
     * The templates are either loaded or synthesized from other templates.
     *
     * @param signature The signature of the fragment template to get
     * @param log       The compile log
     * @return The best templates for the passed signature
     */
    public Collection<AsmFragmentSynthesisResult> getBestTemplates(String signature, CompileLog log) {
        getOrCreateSynthesis(signature, log);
        updateBestTemplates(log);
        AsmFragmentSynthesis synthesis = getSynthesis(signature);
        if (synthesis == null) {
            throw new RuntimeException("Synthesis Graph Error! synthesis not found in graph " + signature);
        }
        return synthesis.getBestTemplates();
    }

    /**
     * Get the entire synthesis graph. Called by the usage statistics.
     *
     * @return The entire synthesis graph
     */
    public Map<String, AsmFragmentSynthesis> getSynthesisGraph() {
        return synthesisGraph;
    }

    /**
     * Get the synthesis used to synthesize a fragment template.
     * If the synthesis does not exist null is returned.
     *
     * @param signature The signature of the template to synthesize
     * @return The synthesis used to synthesize the fragment template.
     * null if the synthesis graph does not contain the synthesis.
     */
    private AsmFragmentSynthesis getSynthesis(String signature) {
        return synthesisGraph.get(signature);
    }

    /**
     * Get (or create) the synthesis used to synthesize a fragment template.
     * If the synthesis does not already exist in the synthesis graph it is created - along with any sub-synthesis recursively usable for creating it.
     * If any synthesis are created they are added to the {@link #bestTemplateUpdate} queue.
     *
     * @param signature The signature of the template to synthesize
     * @param log       The compile log
     * @return The synthesis that is used to load/synthesize the best template
     */
    public AsmFragmentSynthesis getOrCreateSynthesis(String signature, CompileLog log) {
        AsmFragmentSynthesis synthesis = getSynthesis(signature);
        if (synthesis != null) {
            return synthesis;
        }
        // Synthesis not found - create it
        if (log.isVerboseFragmentLog()) {
            log.append("New fragment synthesis " + signature);
        }
        synthesis = new AsmFragmentSynthesis(signature);
        synthesisGraph.put(signature, synthesis);
        queueUpdateBestTemplate(synthesis);
        // Load the template from file - if it exists
        List<AsmFragmentSynthesisResult> fileTemplates = loadFragmentTemplates(signature);
        for (AsmFragmentSynthesisResult fileTemplate : fileTemplates) {
            synthesis.addFileTemplate(fileTemplate);
            if (log.isVerboseFragmentLog()) {
                log.append("New fragment synthesis " + signature + " - Successfully loaded " + signature + ".asm");
            }
        }
        // Populate with synthesis options
        for (AsmFragmentTemplateSynthesisRule rule : AsmFragmentTemplateSynthesisRuleManager.getSynthesisRules(targetCpu)) {
            if (rule.matches(signature)) {
                AsmFragmentSynthesisOption synthesisOption = new AsmFragmentSynthesisOption(signature, rule);
                synthesis.addSynthesisOption(synthesisOption);
                if (log.isVerboseFragmentLog()) {
                    log.append("New fragment synthesis " + signature + " - sub-option " + String.join(",", synthesisOption.getSubSignatures()));
                }
            }
        }
        // Ensure that all sub-synthesis exist (recursively) -  and set their parent options
        for (AsmFragmentSynthesisOption synthesisOption : synthesis.getSynthesisOptions()) {
            for (String subSignature : synthesisOption.getSubSignatures()) {
                AsmFragmentSynthesis subSynthesis = getOrCreateSynthesis(subSignature, log);
                subSynthesis.addParentOption(synthesisOption);
            }
        }
        return synthesis;
    }

   /** Work queue with synthesis that need to be recalculated to find the best templates. */
    private final Deque<AsmFragmentSynthesis> bestTemplateUpdate;

    /**
     * Queue an update of the best templates for a synthesis to the work queue
     *
     * @param synthesis The synthesis to add to the work queue
     */
    private void queueUpdateBestTemplate(AsmFragmentSynthesis synthesis) {
        if (!bestTemplateUpdate.contains(synthesis)) {
            bestTemplateUpdate.push(synthesis);
        }
    }

    /**
     * Find the best fragment template for all synthesis in the work queue {@link #bestTemplateUpdate} queue.
     * During the update more items can be added to the work queue.
     * Returns when the work queue is empty.
     */
    private void updateBestTemplates(CompileLog log) {
        while (!bestTemplateUpdate.isEmpty()) {
            AsmFragmentSynthesis synthesis = bestTemplateUpdate.pop();
            boolean modified = false;
            // Check if the file template is best in class
            List<AsmFragmentSynthesisResult> fileTemplates = synthesis.getFileTemplates();
            for (AsmFragmentSynthesisResult fileTemplate : fileTemplates) {
                modified |= synthesis.bestTemplateCandidate(fileTemplate);
            }
            Collection<AsmFragmentSynthesisOption> synthesisOptions = synthesis.getSynthesisOptions();
            for (AsmFragmentSynthesisOption synthesisOption : synthesisOptions) {
                // for each sub-signature find the best templates
                List<Collection<AsmFragmentSynthesisResult>> subSignatureTemplates = new ArrayList<>();
                for (String subSignature : synthesisOption.getSubSignatures()) {
                    AsmFragmentSynthesis subSynthesis = getSynthesis(subSignature);
                    if (subSynthesis == null) {
                        throw new RuntimeException("Synthesis Graph Error! Sub-synthesis not found in graph " + subSignature);
                    }
                    Collection<AsmFragmentSynthesisResult> subTemplates = subSynthesis.getBestTemplates();
                    subSignatureTemplates.add(subTemplates);
                }
                AsmFragmentTemplateSynthesisRule rule = synthesisOption.getRule();
                // Create all combinations of the best sub-templates
                List<List<AsmFragmentSynthesisResult>> combinations = combinations(subSignatureTemplates);
                for (List<AsmFragmentSynthesisResult> subFragmentCombination : combinations) {
                    final List<AsmFragmentTemplate> subFragments = subFragmentCombination.stream().map(AsmFragmentSynthesisResult::getFragment).collect(Collectors.toList());
                    final AsmFragmentTemplate synthesize = rule.synthesize(synthesis.getSignature(), subFragments);
                    if (synthesize != null) {
                        if (log.isVerboseFragmentLog()) {
                            log.append("Fragment synthesis " + synthesis.getSignature() + " - Successfully synthesized from " + String.join(",", synthesisOption.getSubSignatures()));
                        }
                        AsmFragmentSynthesisResult synthesisResult = new AsmFragmentSynthesisResult(synthesize, false, false, rule, subFragmentCombination);
                        modified |= synthesis.bestTemplateCandidate(synthesisResult);
                    } else {
                        if (log.isVerboseFragmentLog()) {
                            log.append("Fragment synthesis " + synthesis.getSignature() + " - Sub clobber prevents synthesis from " + String.join(",", synthesisOption.getSubSignatures()));
                        }
                    }
                }
            }

            if (modified) {
                // The synthesis was modified - update all parents later
                for (AsmFragmentSynthesisOption parentOption : synthesis.getParentOptions()) {
                    String parentSignature = parentOption.getSignature();
                    AsmFragmentSynthesis parentSynthesis = getSynthesis(parentSignature);
                    if (parentSynthesis == null) {
                        throw new RuntimeException("Synthesis Graph Error! Parent synthesis not found in graph " + parentSignature);
                    }
                    queueUpdateBestTemplate(parentSynthesis);
                    if (log.isVerboseFragmentLog()) {
                        log.append("Fragment synthesis " + synthesis.getSignature() + " - New best, scheduling parent " + parentSignature);
                    }
                }
            }
            if (synthesis.getBestTemplates().isEmpty() && log.isVerboseFragmentLog()) {
                log.append("Fragment synthesis " + synthesis.getSignature() + " - No file or synthesis results!");
            }
        }
    }

    /**
     * Generate all possible combinations of a number of options.
     *
     * @param options A list of the options for each position.
     * @param <T>     The top of an option
     * @return A list with all combinations of the passed options on each position.
     */
    private static <T> List<List<T>> combinations(List<Collection<T>> options) {
        if (options.isEmpty()) {
            // the empty list has one single combination
            final ArrayList<List<T>> combinations = new ArrayList<>();
            combinations.add(new ArrayList<>());
            return combinations;
        } else {
            // Calculate recursively
            final List<Collection<T>> tail = options.subList(1, options.size());
            List<List<T>> tailCombinations = combinations(tail);
            final ArrayList<List<T>> combinations = new ArrayList<>();
            final Collection<T> head = options.get(0);
            for (T headOption : head) {
                for (List<T> tailCombination : tailCombinations) {
                    final ArrayList<T> combination = new ArrayList<>();
                    combination.add(headOption);
                    combination.addAll(tailCombination);
                    combinations.add(combination);
                }
            }
            return combinations;
        }
    }

    /**
     * Attempt to load a fragment template from disk. Also searches relevant fragment sub-folders specified by CPU and other options.
     *
     * @param signature The signature
     * @return The fragment template from a file. null if the template is not found as a file.
     */
    private List<AsmFragmentSynthesisResult> loadFragmentTemplates(String signature) {
        ArrayList<AsmFragmentSynthesisResult> fileTemplates = new ArrayList<>();
        List<TargetCpu.Feature> cpuFeatures = targetCpu.getFeatures();
        for (TargetCpu.Feature cpuFeature : cpuFeatures) {
            AsmFragmentSynthesisResult fileFragment = loadFragmentTemplate(signature, baseFragmentFolder.resolve(cpuFeature.getName()));
            if (fileFragment != null)
                fileTemplates.add(fileFragment);
        }
        return fileTemplates;
    }

    /**
     * Attempt to load a fragment template from a folder on disk
     *
     * @param signature      The signature to search for
     * @param fragmentFolder The folder to look in
     * @return any fragment with the given signature found in the folder. null if not found.
     */
    private AsmFragmentSynthesisResult loadFragmentTemplate(String signature, Path fragmentFolder) {
        try {
            File fragmentFile = fragmentFolder.resolve(signature + ".asm").toFile();
            if (!fragmentFile.exists()) {
                return null;
            }
            InputStream fragmentStream = new FileInputStream(fragmentFile);
            String body;
            if (fragmentStream.available() == 0) {
                body = "";
            } else {
                CharStream fragmentCharStream = CharStreams.fromStream(fragmentStream);
                body = fixNewlines(fragmentCharStream.toString());
            }
            final AsmFragmentTemplate fragment = new AsmFragmentTemplate(signature, body, targetCpu);
            return new AsmFragmentSynthesisResult(fragment, true, false, null, new ArrayList<>());
        } catch (IOException e) {
            throw new RuntimeException("Error loading fragment file " + signature, e);
        } catch (StringIndexOutOfBoundsException e) {
            throw new RuntimeException("Problem reading fragment file " + signature, e);
        }
    }

    /**
     * Fix all newlines in the body.
     * - Removes all '\r'
     * - Removes all trailing newlines
     *
     * @param body The body
     * @return The body with fixed newlines
     */
    public static String fixNewlines(String body) {
        body = body.replace("\r", "");
        while (body.length() > 0 && body.charAt(body.length() - 1) == '\n') {
            body = body.substring(0, body.length() - 1);
        }
        return body;
    }

    public File[] allFragmentFiles() {
        return baseFragmentFolder.toFile().listFiles((dir, name) -> name.endsWith(".asm"));

    }

    public static class UnknownFragmentException extends RuntimeException {

        private final String signature;

        public UnknownFragmentException(String signature) {
            super("Fragment not found " + signature);
            this.signature = signature;
        }

        public String getFragmentSignature() {
            return signature;
        }

    }

}

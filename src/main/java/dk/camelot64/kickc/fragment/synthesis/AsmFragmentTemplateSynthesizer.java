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
      if(useFragmentCache)
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
      if(fragmentCache != null)
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
    * @param log The log
    * @return The best templates (with different clobber profiles) for the signature
    */
   private AsmFragmentTemplate getFragmentTemplate(String signature, CompileLog log) {
      // Attempt to find in memory/disk cache
      AsmFragmentTemplate bestTemplate = fragmentCache.get(signature);
      if(bestTemplate == AsmFragmentTemplateCache.NO_SYNTHESIS) {
         if(log.isVerboseFragmentLog()) {
            log.append("Unknown fragment " + signature);
         }
         throw new UnknownFragmentException(signature);
      }
      if(bestTemplate == null) {
         // Attempt to synthesize or load in main fragment folder
         Collection<AsmFragmentTemplate> candidates = getBestTemplates(signature, log);
         if(candidates.size() == 0) {
            if(log.isVerboseFragmentLog()) {
               log.append("Unknown fragment " + signature);
            }
            fragmentCache.put(signature, AsmFragmentTemplateCache.NO_SYNTHESIS);
            throw new UnknownFragmentException(signature);
         }
         double minScore = Double.MAX_VALUE;
         for(AsmFragmentTemplate candidateTemplate : candidates) {
            double score = candidateTemplate.getCycles();
            if(candidateTemplate.getClobber().isClobberZ()) score += 0.25;
            if(candidateTemplate.getClobber().isClobberA()) score += 0.5;
            if(candidateTemplate.getClobber().isClobberY()) score += 1.0;
            if(candidateTemplate.getClobber().isClobberX()) score += 1.5;
            if(score < minScore) {
               minScore = score;
               bestTemplate = candidateTemplate;
            }
         }
         if(log.isVerboseFragmentLog()) {
            log.append("Found best fragment  " + bestTemplate.getName() + " score: " + minScore);
         }
         fragmentCache.put(signature, bestTemplate);
      }
      // Count usages
      AsmFragmentTemplateUsages.incUsage(bestTemplate);
      return bestTemplate;
   }


   /**
    * Get the best fragment templates for a signature.
    * The templates are either loaded or synthesized from other templates.
    *
    * @param signature The signature of the fragment template to get
    * @param log The compile log
    * @return The best templates for the passed signature
    */
   public Collection<AsmFragmentTemplate> getBestTemplates(String signature, CompileLog log) {
      getOrCreateSynthesis(signature, log);
      updateBestTemplates(log);
      AsmFragmentSynthesis synthesis = getSynthesis(signature);
      if(synthesis == null) {
         throw new RuntimeException("Synthesis Graph Error! synthesis not found in graph " + signature);
      }
      return synthesis.getBestTemplates();
   }

   /**
    * The synthesis is capable of loading the fragment from disk or synthesizing it from other fragments using synthesis rules.
    * The synthesis caches the best fragments for each clobber profile (loaded or synthesized).
    * A node in the synthesis graph.
    */
   public static class AsmFragmentSynthesis {

      /** The signature of the fragment template being synthesized. */
      private final String signature;

      /** The best template loaded/synthesized so far for each clobber profile */
      private final Map<AsmFragmentClobber, AsmFragmentTemplate> bestTemplates;

      /** Options for synthesizing the template from sub-fragments using a specific synthesis rule. Forward edges in the synthesis graph. */
      private final Set<AsmFragmentSynthesisOption> synthesisOptions;

      /** Options for synthesizing the other templates from this template using a specific synthesis rule. Backward edges in the synthesis graph. */
      private final Set<AsmFragmentSynthesisOption> parentOptions;

      /** The templates loaded from a file. Empty if no file exists for the signature. */
      private final List<AsmFragmentTemplate> fileTemplates;

      /**
       * Create a new synthesis
       *
       * @param signature The signature of the fragment template to load/synthesize
       */
      AsmFragmentSynthesis(String signature) {
         this.signature = signature;
         this.bestTemplates = new LinkedHashMap<>();
         this.synthesisOptions = new LinkedHashSet<>();
         this.parentOptions = new LinkedHashSet<>();
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

      void addFileTemplate(AsmFragmentTemplate fileTemplate) {
         this.fileTemplates.add(fileTemplate);
      }

      List<AsmFragmentTemplate> getFileTemplates() {
         return fileTemplates;
      }

      /**
       * Handle a candidate for best template.
       * If the candidate is better than the current best for its clobber profile update the best template
       *
       * @param candidate The template candidate to examine
       * @return true if the best template was updated
       */
      boolean bestTemplateCandidate(AsmFragmentTemplate candidate) {
         AsmFragmentClobber candidateClobber = candidate.getClobber();
         double candidateCycles = candidate.getCycles();

         // Check if any current best templates are better
         Set<AsmFragmentClobber> bestClobbers = new LinkedHashSet<>(bestTemplates.keySet());
         for(AsmFragmentClobber bestClobber : bestClobbers) {
            AsmFragmentTemplate bestTemplate = bestTemplates.get(bestClobber);
            double bestCycles = bestTemplate.getCycles();
            if(bestClobber.isTrueSubset(candidateClobber) && bestCycles <= candidateCycles) {
               // A better template already found - don't update
               return false;
            }
            if(bestClobber.isSubset(candidateClobber) && bestCycles < candidateCycles) {
               // A better template already found - don't update
               return false;
            }
            if(bestClobber.equals(candidateClobber) && bestCycles == candidateCycles && bestTemplate.getBody().compareTo(candidate.getBody()) <= 0) {
               // A better template already found - don't update
               return false;
            }

         }

         // The candidate is better than some of the current best!

         // Remove any current templates that are worse
         for(AsmFragmentClobber bestClobber : bestClobbers) {
            AsmFragmentTemplate bestTemplate = bestTemplates.get(bestClobber);
            double bestCycles = bestTemplate.getCycles();

            if(candidateClobber.isTrueSubset(bestClobber) && candidateCycles <= bestCycles) {
               // The candidate is better - remove the current template
               bestTemplates.remove(bestClobber);
            }
            if(candidateClobber.isSubset(bestClobber) && candidateCycles < bestCycles) {
               // The candidate is better - remove the current template
               bestTemplates.remove(bestClobber);
            }
            if(candidateClobber.equals(bestClobber) && candidateCycles == bestCycles && candidate.getBody().compareTo(bestTemplate.getBody()) < 0) {
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
      Set<AsmFragmentSynthesisOption> getParentOptions() {
         return parentOptions;
      }

      /**
       * Get the best fragment templates of the synthesis.
       * Multiple templates are returned if templates with different clobber profiles exist.
       *
       * @return The best templates of the synthesis.
       */
      public Collection<AsmFragmentTemplate> getBestTemplates() {
         return bestTemplates.values();
      }

      public String getSignature() {
         return signature;
      }
   }

   /** An option for synthesizing a fragment template from a sub-template using a specific synthesis rule. An edge in the synthesis graph. */
   public static class AsmFragmentSynthesisOption {

      /** The signature of the fragment template being synthesized. The from-node in the graph. */
      private final String signature;

      /** The signatures of the sub-fragment templates to synthesize from. The to-nodes in the graph. */
      private final List<String> subSignatures;

      /** The synthesis rule capable of synthesizing this template from the sub-fragments. */
      private final AsmFragmentTemplateSynthesisRule rule;

      /**
       * Create a synthesis option
       *
       * @param signature he signature of the fragment template being synthesized.
       * @param rule The synthesis rule capable of synthesizing this template from the sub-fragment.
       */
      AsmFragmentSynthesisOption(String signature, AsmFragmentTemplateSynthesisRule rule) {
         this.signature = signature;
         this.rule = rule;
         this.subSignatures = rule.getSubSignatures(signature);
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
         if(this == o) return true;
         if(o == null || getClass() != o.getClass()) return false;
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
    * @param log The compile log
    * @return The synthesis that is used to load/synthesize the best template
    */
   public AsmFragmentSynthesis getOrCreateSynthesis(String signature, CompileLog log) {
      AsmFragmentSynthesis synthesis = getSynthesis(signature);
      if(synthesis != null) {
         return synthesis;
      }
      // Synthesis not found - create it
      if(log.isVerboseFragmentLog()) {
         log.append("New fragment synthesis " + signature);
      }
      synthesis = new AsmFragmentSynthesis(signature);
      synthesisGraph.put(signature, synthesis);
      queueUpdateBestTemplate(synthesis);
      // Load the template from file - if it exists
      List<AsmFragmentTemplate> fileTemplates = loadFragmentTemplates(signature);
      for(AsmFragmentTemplate fileTemplate : fileTemplates) {
         synthesis.addFileTemplate(fileTemplate);
         if(log.isVerboseFragmentLog()) {
            log.append("New fragment synthesis " + signature + " - Successfully loaded " + signature + ".asm");
         }
      }
      // Populate with synthesis options
      for(AsmFragmentTemplateSynthesisRule rule : AsmFragmentTemplateSynthesisRuleManager.getSynthesisRules(targetCpu)) {
         if(rule.matches(signature)) {
            AsmFragmentSynthesisOption synthesisOption = new AsmFragmentSynthesisOption(signature, rule);
            synthesis.addSynthesisOption(synthesisOption);
            if(log.isVerboseFragmentLog()) {
               log.append("New fragment synthesis " + signature + " - sub-option " + String.join(",", synthesisOption.getSubSignatures()));
            }
         }
      }
      // Ensure that all sub-synthesis exist (recursively) -  and set their parent options
      for(AsmFragmentSynthesisOption synthesisOption : synthesis.getSynthesisOptions()) {
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
      if(!bestTemplateUpdate.contains(synthesis)) {
         bestTemplateUpdate.push(synthesis);
      }
   }

   /**
    * Find the best fragment template for all synthesis in the work queue {@link #bestTemplateUpdate} queue.
    * During the update more items can be added to the work queue.
    * Returns when the work queue is empty.
    */
   private void updateBestTemplates(CompileLog log) {
      while(!bestTemplateUpdate.isEmpty()) {
         AsmFragmentSynthesis synthesis = bestTemplateUpdate.pop();
         boolean modified = false;
         // Check if the file template is best in class
         List<AsmFragmentTemplate> fileTemplates = synthesis.getFileTemplates();
         for(AsmFragmentTemplate fileTemplate : fileTemplates) {
            modified |= synthesis.bestTemplateCandidate(fileTemplate);
         }
         Collection<AsmFragmentSynthesisOption> synthesisOptions = synthesis.getSynthesisOptions();
         for(AsmFragmentSynthesisOption synthesisOption : synthesisOptions) {
            // for each sub-signature find the best templates
            List<Collection<AsmFragmentTemplate>> subSignatureTemplates = new ArrayList<>();
            for (String subSignature : synthesisOption.getSubSignatures()) {
               AsmFragmentSynthesis subSynthesis = getSynthesis(subSignature);
               if (subSynthesis == null) {
                  throw new RuntimeException("Synthesis Graph Error! Sub-synthesis not found in graph " + subSignature);
               }
               Collection<AsmFragmentTemplate> subTemplates = subSynthesis.getBestTemplates();
               subSignatureTemplates.add(subTemplates);
            }
            AsmFragmentTemplateSynthesisRule rule = synthesisOption.getRule();
            // Create all combinations of the best sub-templates
            List<List<AsmFragmentTemplate>> combinations = combinations(subSignatureTemplates);
            for (List<AsmFragmentTemplate> subTemplateCombination : combinations) {
               AsmFragmentTemplate synthesized = rule.synthesize(synthesis.getSignature(), subTemplateCombination);
               if (synthesized != null) {
                  if (log.isVerboseFragmentLog()) {
                     log.append("Fragment synthesis " + synthesis.getSignature() + " - Successfully synthesized from " + String.join(",", synthesisOption.subSignatures));
                  }
                  modified |= synthesis.bestTemplateCandidate(synthesized);
               } else {
                  if (log.isVerboseFragmentLog()) {
                     log.append("Fragment synthesis " + synthesis.getSignature() + " - Sub clobber prevents synthesis from " + String.join(",", synthesisOption.subSignatures));
                  }
               }
            }
         }

         if(modified) {
            // The synthesis was modified - update all parents later
            for(AsmFragmentSynthesisOption parentOption : synthesis.getParentOptions()) {
               String parentSignature = parentOption.getSignature();
               AsmFragmentSynthesis parentSynthesis = getSynthesis(parentSignature);
               if(parentSynthesis == null) {
                  throw new RuntimeException("Synthesis Graph Error! Parent synthesis not found in graph " + parentSignature);
               }
               queueUpdateBestTemplate(parentSynthesis);
               if(log.isVerboseFragmentLog()) {
                  log.append("Fragment synthesis " + synthesis.getSignature() + " - New best, scheduling parent " + parentSignature);
               }
            }
         }
         if(synthesis.getBestTemplates().isEmpty() && log.isVerboseFragmentLog()) {
            log.append("Fragment synthesis " + synthesis.getSignature() + " - No file or synthesis results!");
         }
      }
   }

   /**
    * Generate all possible combinations of a number of options.
    * @param options A list of the options for each position.
    * @param <T> The top of an option
    * @return A list with all combinations of the passed options on each position.
    */
   private static <T> List<List<T>> combinations(List<Collection<T>> options) {
      if(options.isEmpty()) {
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
   private List<AsmFragmentTemplate> loadFragmentTemplates(String signature) {
      ArrayList<AsmFragmentTemplate> fileTemplates = new ArrayList<>();
      List<TargetCpu.Feature> cpuFeatures = targetCpu.getFeatures();
      for(TargetCpu.Feature cpuFeature : cpuFeatures) {
         AsmFragmentTemplate fileFragment = loadFragmentTemplate(signature, baseFragmentFolder.resolve(cpuFeature.getName()));
         if(fileFragment != null)
            fileTemplates.add(fileFragment);
      }
      return fileTemplates;
   }

   /**
    * Attempt to load a fragment template from a folder on disk
    *
    * @param signature The signature to search for
    * @param fragmentFolder The folder to look in
    * @return any fragment with the gicen signature found in the folder. null if not found.
    */
   private AsmFragmentTemplate loadFragmentTemplate(String signature, Path fragmentFolder) {
      try {
         File fragmentFile = fragmentFolder.resolve(signature + ".asm").toFile();
         if(!fragmentFile.exists()) {
            return null;
         }
         InputStream fragmentStream = new FileInputStream(fragmentFile);
         String body;
         if(fragmentStream.available() == 0) {
            body = "";
         } else {
            CharStream fragmentCharStream = CharStreams.fromStream(fragmentStream);
            body = fixNewlines(fragmentCharStream.toString());
         }
         return new AsmFragmentTemplate(signature, body, targetCpu, false);
      } catch(IOException e) {
         throw new RuntimeException("Error loading fragment file " + signature, e);
      } catch(StringIndexOutOfBoundsException e) {
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
      while(body.length() > 0 && body.charAt(body.length() - 1) == '\n') {
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

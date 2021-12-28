package dk.camelot64.kickc.fragment;

import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.fragment.synthesis.*;

import java.io.File;
import java.util.*;

/** Statistics for usage of the ASM fragments. Also contains a methods for identifying redundant/unused files. */
public class AsmFragmentTemplateUsages {

   /** Usage Statistics for fragment templates. */
   private static Map<AsmFragmentSynthesisResult, Integer> fragmentTemplateUsage = new HashMap<>();

   /**
    * Count one usage of ASM fragment templates - directly or through synthesis
    *
    * @param fragmentTemplate The template to increment usage of
    */
   public static void incUsage(AsmFragmentSynthesisResult fragmentTemplate) {
      Integer usage = fragmentTemplateUsage.get(fragmentTemplate);
      if(usage == null) {
         usage = 0;
      }
      fragmentTemplateUsage.put(fragmentTemplate, usage + 1);
      for (AsmFragmentSynthesisResult subFragment : fragmentTemplate.getSubFragments()) {
         if (subFragment != null) {
            incUsage(subFragment);
         }
      }
   }

   /**
    * Log the usage of all template fragemnts (both loaded and synthesized).
    *
    * @param log The compile log to add the output to
    */
   public static void logUsages(AsmFragmentTemplateSynthesizer synthesizer, CompileLog log, boolean logRedundantFiles, boolean logUnusedFiles, boolean logUnusedRules, boolean logFileDetails, boolean logAllDetails, boolean logDetailsBody) {

      Map<String, AsmFragmentSynthesis> synthesisGraph =
            synthesizer.getSynthesisGraph();
      ArrayList<String> signatures = new ArrayList<>(synthesisGraph.keySet());
      Collections.sort(signatures);
      File[] files = synthesizer.allFragmentFiles();

      if(logRedundantFiles) {
         log.append("\nREDUNDANT ASM FRAGMENT FILES ANALYSIS (if found consider removing them from disk)");
         Set<String> redundantSignatures = new LinkedHashSet<>();
         for(File file : files) {
            String fileName = file.getName();
            String signature = fileName.substring(0, fileName.length() - 4);
            // Synthesize the fragment - and check if the synthesis is as good as the file body
            Collection<AsmFragmentSynthesisResult> templates = synthesizer.getBestTemplates(signature, log);
            boolean isFile = false;
            for(AsmFragmentSynthesisResult template : templates) {
               isFile |= template.isFile();
            }
            if(!isFile) {
               StringBuilder templateNames = new StringBuilder();
               boolean first = true;
               for(AsmFragmentSynthesisResult template : templates) {
                  templateNames.append(template.getName());
                  if(first) {
                     first = false;
                  } else {
                     templateNames.append(" / ");
                  }
               }
               log.append("rm " + signature + ".asm #synthesized better ASM by " + templateNames);
               redundantSignatures.add(signature);
            }
         }
      }

      if(logUnusedFiles) {
         log.append("\nUNUSED ASM FRAGMENT FILES ANALYSIS (if found consider removing them from disk)");
         for(File file : files) {
            String fileName = file.getName();
            String signature = fileName.substring(0, fileName.length() - 4);
            AsmFragmentSynthesis asmFragmentSynthesis = synthesisGraph.get(signature);
            Collection<AsmFragmentSynthesisResult> templates = asmFragmentSynthesis.getBestTemplates();
            if(templates != null && templates.size() > 0) {
               // The template has been loaded / synthesized - is the usage count zero?
               boolean allZero = true;
               Integer fileUsage = null;
               for(AsmFragmentSynthesisResult template : templates) {
                  Integer usage = fragmentTemplateUsage.get(template);
                  if(usage == null) usage = 0;
                  if(usage > 0) {
                     allZero = false;
                  }
                  if(template.isFile()) {
                     fileUsage = usage;
                  }
               }
               if(fileUsage == null) {
                  log.append("Error! Template file never loaded according to usage stats " + fileName);
               }
               if(allZero) {
                  log.append("git mv " + fileName + " unused # Loaded but never used");
               }
            } else {
               // The template has never been loaded
               log.append("git mv " + fileName + " unused # Never loaded");
            }
         }
      }

      if(logUnusedRules) {
         log.append("\nUNUSED ASM FRAGMENT SYNTHESIS RULE ANALYSIS (if found consider removing them)");
         final Collection<AsmFragmentTemplateSynthesisRule> allRules = AsmFragmentTemplateSynthesisRuleManager.getAllSynthesisRules();

         for(String signature : signatures) {
            LinkedList<AsmFragmentSynthesisResult> templates = new LinkedList<>(synthesizer.getBestTemplates(signature, log));
            while(!templates.isEmpty()) {
               final AsmFragmentSynthesisResult template = templates.pop();
               allRules.remove(template.getSynthesis());
               templates.addAll(template.getSubFragments());
            }
         }

         for(AsmFragmentTemplateSynthesisRule rule : allRules) {
            log.append("Synthesis Rule Unused: - "+rule.toString());
         }
      }

      if(logFileDetails) {
         log.append("\nDETAILED ASM FILE USAGES");
         // Find all file templates
         List<AsmFragmentSynthesisResult> fileTemplates = new ArrayList<>();
         for(String signature : signatures) {
            Collection<AsmFragmentSynthesisResult> templates = synthesisGraph.get(signature).getBestTemplates();
            for(AsmFragmentSynthesisResult template : templates) {
               if(template.isFile()) {
                  fileTemplates.add(template);
               }
            }
         }
         logTemplatesByUsage(synthesizer, log, fileTemplates, logDetailsBody);

      }

      if(logAllDetails) {
         log.append("\nDETAILED ASM FRAGMENT USAGES");
         List<AsmFragmentSynthesisResult> allTemplates = new ArrayList<>();
         for(String signature : signatures) {
            Collection<AsmFragmentSynthesisResult> templates = synthesisGraph.get(signature).getBestTemplates();
            allTemplates.addAll(templates);
         }
         logTemplatesByUsage(synthesizer, log, allTemplates, logDetailsBody);
      }


   }

   private static void logTemplatesByUsage(AsmFragmentTemplateSynthesizer synthesizer, CompileLog log, List<AsmFragmentSynthesisResult> templates, boolean logBody) {
      // Sort by usage
      Collections.sort(templates, (o1, o2) -> {
               Integer u1 = fragmentTemplateUsage.get(o1);
               Integer u2 = fragmentTemplateUsage.get(o2);
               if(u1 == null) u1 = 0;
               if(u2 == null) u2 = 0;
               return u2 - u1;
            }
      );
      // Output
      for(AsmFragmentSynthesisResult template : templates) {
         Integer usage = fragmentTemplateUsage.get(template);
         if(usage == null) usage = 0;
         AsmFragmentSynthesis synthesis = synthesizer.getOrCreateSynthesis(template.getSignature(), log);
         Collection<AsmFragmentSynthesisResult> bestTemplates = synthesis.getBestTemplates();
         log.append(String.format("%8d", usage) + " " + template.getSignature()+" - templates: " + bestTemplates.size());
         if(logBody) {
            for(AsmFragmentSynthesisResult bestTemplate : bestTemplates) {
               logTemplate(log, bestTemplate, "      ");
            }

         }
      }
   }

   public static void logTemplate(CompileLog log, AsmFragmentSynthesisResult template, String indent) {
      String prefix;
      if(template.isCache()) {
         prefix = "cached ";
      } else if(template.isFile()) {
         prefix ="loaded ";
      } else {
         prefix ="synthesized ";
      }
      log.append(indent + prefix + template.getName() + " - clobber:" + template.getClobber().toString() + " cycles:" + template.getCycles());
      log.append(indent+ "  " + template.getBody().replace("\n", "\n"+indent+"  "));
   }


}

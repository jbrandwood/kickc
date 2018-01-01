package dk.camelot64.kickc.fragment;

import dk.camelot64.kickc.CompileLog;

import java.io.File;
import java.util.*;

/** Statistics for usage of the ASM fragments. Also contains a methos for identifying redundant/unused files. */
public class AsmFragmentUsages {

    /** Usage Statistics for fragment templates. */
    private static Map<AsmFragmentTemplate, Integer> fragmentTemplateUsage = new HashMap<>();

    /**
     * Count one usage of ASM fragment templates - directly or through synthesis
     *
     * @param fragmentTemplate The template to increment usage of
     */
    static void incUsage(AsmFragmentTemplate fragmentTemplate) {
        Integer usage = fragmentTemplateUsage.get(fragmentTemplate);
        if (usage == null) {
            usage = 0;
        }
        fragmentTemplateUsage.put(fragmentTemplate, usage + 1);
        AsmFragmentTemplate subFragment = fragmentTemplate.getSubFragment();
        if (subFragment != null) {
            incUsage(subFragment);
        }
    }

    /**
     * Log the usage of all template fragemnts (both loaded and synthesized).
     *
     * @param log The compile log to add the output to
     */
    public static void logUsages(CompileLog log, boolean logRedundantFiles, boolean logUnusedFiles, boolean logFileDetails, boolean logAllDetails) {

        Map<String, List<AsmFragmentTemplate>> fragmentTemplateCache = AsmFragmentManager.getFragmentTemplateCache();
        ArrayList<String> signatures = new ArrayList<>(fragmentTemplateCache.keySet());
        Collections.sort(signatures);
        File[] files = AsmFragmentManager.allFragmentFiles();

        if (logRedundantFiles) {
            // Find all file fragments that were bested by a synthesized fragment
            log.append("\nREDUNDANT ASM FRAGMENT FILE ANALYSIS (if found remove them from disk)");
            for (String signature : signatures) {
                List<AsmFragmentTemplate> templates = fragmentTemplateCache.get(signature);
                AsmFragmentTemplate fileTemplate = null;
                int fileUsage = 0;
                AsmFragmentTemplate maxTemplate = null;
                int maxUsage = 0;
                for (AsmFragmentTemplate template : templates) {
                    Integer usage = fragmentTemplateUsage.get(template);
                    if (usage == null) usage = 0;
                    if (template.isFile()) {
                        fileTemplate = template;
                        fileUsage = usage;
                    }
                    if (usage > maxUsage) {
                        maxUsage = usage;
                        maxTemplate = template;
                    }
                }
                if (fileTemplate != null && fileUsage == 0 && maxUsage > 0) {
                    log.append("rm " + fileTemplate.getName() + ".asm #synthesized by " + maxTemplate.getName() + " - usages: " + maxUsage);
                }
            }

            Set<String> redundantSignatures = new LinkedHashSet<>();
            for (File file : files) {
                String fileName = file.getName();
                String signature = fileName.substring(0, fileName.length() - 4);
                // Try to synthesize the fragment - and check if the synthesis is as good as the file body
                AsmFragmentManager.AsmFragmentTemplateSynthesizer synthesizer = new AsmFragmentManager.AsmFragmentTemplateSynthesizer(signature, log);
                List<AsmFragmentTemplate> templates = synthesizer.loadOrSynthesizeFragment(signature, new AsmFragmentManager.AsmSynthesisPath());
                AsmFragmentTemplate fileTemplate = null;
                for (AsmFragmentTemplate template : templates) {
                    if (template.isFile()) {
                        fileTemplate = template;
                    }
                }
                for (AsmFragmentTemplate template : templates) {
                    if (!template.isFile() && template.getBody().equals(fileTemplate.getBody())) {
                        // Check if the synthesis uses a file marked as redundant
                        AsmFragmentTemplate sourceFileTemplate = template;
                        while (!sourceFileTemplate.isFile()) {
                            sourceFileTemplate = sourceFileTemplate.getSubFragment();
                        }
                        if (redundantSignatures.contains(sourceFileTemplate.getSignature())) {
                            throw new RuntimeException("Problem in redundancy analysis! " + sourceFileTemplate.getSignature() + ".asm seems redundant but is needed for synthesis of " + signature);
                        }
                        log.append("rm " + fileTemplate.getName() + ".asm #synthesized same ASM by " + template.getName());
                        redundantSignatures.add(signature);
                        break;
                    }
                }
            }
        }

        if (logUnusedFiles) {
            log.append("\nUNUSED ASM FRAGMENT FILES ANALYSIS (if found consider removing them from disk)");
            for (File file : files) {
                String fileName = file.getName();
                String signature = fileName.substring(0, fileName.length() - 4);
                List<AsmFragmentTemplate> templates = fragmentTemplateCache.get(signature);
                if (templates != null && templates.size() > 0) {
                    // The template has been loaded / synthesized - is the usage count zero?
                    boolean allZero = true;
                    Integer fileUsage = null;
                    for (AsmFragmentTemplate template : templates) {
                        Integer usage = fragmentTemplateUsage.get(template);
                        if (usage == null) usage = 0;
                        if (usage > 0) {
                            allZero = false;
                        }
                        if (template.isFile()) {
                            fileUsage = usage;
                        }
                    }
                    if (fileUsage == null) {
                        throw new RuntimeException("Error! Template file never loaded according to usage stats " + fileName);
                    }
                    if (allZero) {
                        log.append("git mv " + fileName + " unused # Loaded but never used");
                    }
                } else {
                    // The template has never been loaded
                    log.append("git mv " + fileName + " unused # Never loaded");
                }
            }
        }

        if (logFileDetails) {
            log.append("\nDETAILED ASM FILE USAGES");
            // Find all file templates
            List<AsmFragmentTemplate> fileTemplates = new ArrayList<>();
            for (String signature : signatures) {
                List<AsmFragmentTemplate> templates = fragmentTemplateCache.get(signature);
                for (AsmFragmentTemplate template : templates) {
                    if (template.isFile()) {
                        fileTemplates.add(template);
                    }
                }
            }
            logTemplatesByUsage(log, fileTemplates);

        }

        if (logAllDetails) {
            log.append("\nDETAILED ASM FRAGMENT USAGES");
            List<AsmFragmentTemplate> allTemplates = new ArrayList<>();
            for (String signature : signatures) {
                List<AsmFragmentTemplate> templates = fragmentTemplateCache.get(signature);
                for (AsmFragmentTemplate template : templates) {
                    allTemplates.add(template);
                }
            }
            logTemplatesByUsage(log, allTemplates);
        }


    }

    private static void logTemplatesByUsage(CompileLog log, List<AsmFragmentTemplate> fileTemplates) {
        // Sort by usage
        Collections.sort(fileTemplates, (o1, o2) -> {
                    Integer u1 = fragmentTemplateUsage.get(o1);
                    Integer u2 = fragmentTemplateUsage.get(o2);
                    if (u1 == null) u1 = 0;
                    if (u2 == null) u2 = 0;
                    return u2 - u1;
                }
        );
        // Output
        for (AsmFragmentTemplate template : fileTemplates) {
            Integer usage = fragmentTemplateUsage.get(template);
            if (usage == null) usage = 0;
            log.append(String.format("%8d", usage) + "  " + (template.isFile()?"*":"")+template.getName());
        }
    }


}

package dk.camelot64.kickc.fragment;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/** AsmFragment synthesis mechanism based on matching fragment signature and reusing another fragment with added prefix/postfix and some bind-mappings */
class AsmFragmentSynthesis {

    private String sigMatch;
    private String sigAvoid;
    private String asmPrefix;
    private String sigReplace;
    private String asmPostfix;
    private Map<String, String> bindMappings;
    private boolean mapSignature;
    private String subSignature;

    AsmFragmentSynthesis(String sigMatch, String sigAvoid, String asmPrefix, String sigReplace, String asmPostfix, Map<String, String> bindMappings, boolean mapSignature) {
        this.sigMatch = sigMatch;
        this.sigAvoid = sigAvoid;
        this.asmPrefix = asmPrefix;
        this.sigReplace = sigReplace;
        this.asmPostfix = asmPostfix;
        this.bindMappings = bindMappings;
        this.mapSignature = mapSignature;
    }

    public AsmFragmentSynthesis(String sigMatch, String sigAvoid, String asmPrefix, String sigReplace, String asmPostfix, Map<String, String> bindMappings) {
        this(sigMatch, sigAvoid, asmPrefix, sigReplace, asmPostfix, bindMappings, true);
    }

    public String getName() {
        return sigMatch + (sigAvoid == null ? "" : ("/" + sigAvoid));
    }

    public List<AsmFragmentTemplate> synthesize(String signature, AsmFragmentManager.AsmSynthesisPath path, AsmFragmentManager.AsmFragmentTemplateSynthesizer synthesizer) {
        ArrayList<AsmFragmentTemplate> candidates = new ArrayList<>();
        if (signature.matches(sigMatch)) {
            if (sigAvoid == null || !signature.matches(sigAvoid)) {
                subSignature = regexpRewriteSignature(signature, sigMatch, sigReplace);
                if (mapSignature && bindMappings != null) {
                    // When mapping the signature we do the map replacement in the signature
                    for (String bound : bindMappings.keySet()) {
                        subSignature = subSignature.replace(bound, bindMappings.get(bound));
                    }
                }
                List<AsmFragmentTemplate> subFragmentTemplates = synthesizer.loadOrSynthesizeFragment(subSignature, path);
                for (AsmFragmentTemplate subFragmentTemplate : subFragmentTemplates) {
                    if (subFragmentTemplate != null) {
                        StringBuilder newFragment = new StringBuilder();
                        if (asmPrefix != null) {
                            newFragment.append(asmPrefix).append("\n");
                        }
                        String subFragment = subFragmentTemplate.getBody();
                        if (bindMappings != null) {
                            if (mapSignature) {
                                // When mapping the signature we do the reverse replacement in the ASM
                                List<String> reverse = new ArrayList<>(bindMappings.keySet());
                                Collections.reverse(reverse);
                                for (String bound : reverse) {
                                    subFragment = subFragment.replace("{" + bindMappings.get(bound) + "}", "{" + bound + "}");
                                }
                            } else {
                                // When not mapping the signature we do the replacement directly in the ASM
                                for (String bound : bindMappings.keySet()) {
                                    subFragment = subFragment.replace("{" + bound + "}", "{" + bindMappings.get(bound) + "}");
                                }
                            }
                        }
                        newFragment.append(subFragment);
                        if (asmPostfix != null) {
                            newFragment.append("\n");
                            newFragment.append(asmPostfix);
                        }
                        candidates.add(new AsmFragmentTemplate(signature, newFragment.toString(), this, subFragmentTemplate));
                    }
                }
            }
        }
        return candidates;
    }

    public String getSubSignature() {
        return subSignature;
    }

    static String regexpRewriteSignature(String signature, String match, String replace) {
        Pattern p = Pattern.compile(match);
        Matcher m = p.matcher(signature);
        String output = signature;
        if (m.find()) {
            // getReplacement first number with "number" and second number with the first
            output = m.replaceAll(replace);
        }
        return output;
    }


}

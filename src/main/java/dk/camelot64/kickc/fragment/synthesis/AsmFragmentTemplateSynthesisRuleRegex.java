package dk.camelot64.kickc.fragment.synthesis;

import dk.camelot64.kickc.fragment.AsmFragmentTemplate;

import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/** AsmFragment synthesis mechanism based on matching fragment signature and reusing another fragment with added prefix/postfix and some bind-mappings */
class AsmFragmentTemplateSynthesisRuleRegex implements AsmFragmentTemplateSynthesisRule {

   /**
    * Regular expression that matches the signature of fragments that the synthesis rule can handle.
    * Contains matching groups (parenthesis) that are used in sigReplace to build the signature of the sub-fragment to synthesize from.
    */
   final String sigMatch;

   /** Compiled regex for sigMatch */
   Pattern sigMatchPattern = null;

   /** Regular expression that limits which fragments the synthesize rule can handle. */
   final String sigAvoid;

   /** Compiled regex for sigAvoid */
   Pattern sigAvoidPattern = null;

   /** ASM code prefixed to the sub-fragment when synthesizing. */
   final private String asmPrefix;

   /** Signature of the sub-fragment to use for synthesizing the fragment. References the matching groups from sigMatch (via $1, $2, ...). */
   final String sigReplace;

   /** ASM code postfixed to the sub-fragment when synthesizing. */
   final private String asmPostfix;

   /** Bindings for mapping replacing parameter names in the signature & ASM of the sub-fragment. */
   final private Map<String, String> bindMappings;

   /** Indicates whether to map parameters in the signature. If false only the parameters in the ASM are mapped. */
   final private boolean mapSignature;

   /** Names of registers ("aa", "xx", "yy") that the sub-fragment is not allowed to clobber. Limits which sub-fragments the rule can use for creating the synthesis. */
   final String subDontClobber;

   AsmFragmentTemplateSynthesisRuleRegex(String sigMatch, String sigAvoid, String asmPrefix, String sigReplace, String asmPostfix, Map<String, String> bindMappings, boolean mapSignature, String subDontClobber) {
      this.sigMatch = sigMatch;
      this.sigAvoid = sigAvoid;
      this.asmPrefix = asmPrefix;
      this.sigReplace = sigReplace;
      this.asmPostfix = asmPostfix;
      this.bindMappings = bindMappings;
      this.mapSignature = mapSignature;
      this.subDontClobber = subDontClobber;
   }

   AsmFragmentTemplateSynthesisRuleRegex(String sigMatch, String sigAvoid, String asmPrefix, String sigReplace, String asmPostfix, Map<String, String> bindMappings) {
      this(sigMatch, sigAvoid, asmPrefix, sigReplace, asmPostfix, bindMappings, true, null);
   }

   AsmFragmentTemplateSynthesisRuleRegex(String sigMatch, String sigAvoid, String asmPrefix, String sigReplace, String asmPostfix, Map<String, String> bindMappings, boolean mapSignature) {
      this(sigMatch, sigAvoid, asmPrefix, sigReplace, asmPostfix, bindMappings, mapSignature, null);
   }

   AsmFragmentTemplateSynthesisRuleRegex(String sigMatch, String sigAvoid, String asmPrefix, String sigReplace, String asmPostfix, Map<String, String> bindMappings, String subDontClobber) {
      this(sigMatch, sigAvoid, asmPrefix, sigReplace, asmPostfix, bindMappings, true, subDontClobber);
   }

   /**
    * Is the rule match usable for synthesizing a fragment template
    *
    * @param signature The fragment template signature
    * @return true if the rule matches the signature
    */
   public boolean matches(String signature) {
      if(sigMatchPattern == null)
         sigMatchPattern = Pattern.compile(sigMatch);
      Matcher m = sigMatchPattern.matcher(signature);
      if(m.matches()) {
         if(sigAvoid == null)
            return true;
         else {
            if(sigAvoidPattern == null)
               sigAvoidPattern = Pattern.compile(sigAvoid);
            Matcher ma = sigAvoidPattern.matcher(signature);
            return !ma.matches();
         }
      }
      return false;
   }

   /**
    * The signature of the sub-template to synthesize the template from
    *
    * @param signature The signature to synthesize
    * @return Signature of the sub-template to synthesize the template from. null if the rule does not match the signature.
    */
   public String getSubSignature(String signature) {
      if(matches(signature)) {
         String subSignature = regexpRewriteSignature(signature, sigMatch, sigReplace);
         if(mapSignature && bindMappings != null) {
            // When mapping the signature we do the map replacement in the signature
            for(String bound : bindMappings.keySet()) {
               subSignature = subSignature.replace(bound, bindMappings.get(bound));
            }
         }
         return subSignature;
      } else {
         return null;
      }
   }

   public AsmFragmentTemplate synthesize(String signature, AsmFragmentTemplate subTemplate) {
//      if(!matches(signature)) {
//         throw new RuntimeException("Synthesis error! Attempting to synthesize on non-matching signature signature:"+signature+" match:"+sigMatch+" avoid:"+sigAvoid);
//      }
//      if(!subTemplate.getSignature().equals(getSubSignature(signature))) {
//         throw new RuntimeException("Synthesis error! Attempting to synthesize on non-matching sub template sub-signature:"+subTemplate.getSignature()+" expecting:"+getSubSignature(signature));
//      }
      if(subDontClobber != null) {
         if(subDontClobber.contains("aa") && subTemplate.getClobber().isClobberA()) return null;
         if(subDontClobber.contains("xx") && subTemplate.getClobber().isClobberX()) return null;
         if(subDontClobber.contains("yy") && subTemplate.getClobber().isClobberY()) return null;
         if(subDontClobber.contains("zz") && subTemplate.getClobber().isClobberZ()) return null;
      }

      StringBuilder newFragment = new StringBuilder();
      if(asmPrefix != null) {
         newFragment.append(asmPrefix).append("\n");
      }
      String subFragment = subTemplate.getBody();
      if(bindMappings != null) {
         if(mapSignature) {
            // When mapping the signature we do the reverse replacement in the ASM
            List<String> reverse = new ArrayList<>(bindMappings.keySet());
            Collections.reverse(reverse);
            for(String bound : reverse) {
               subFragment = subFragment.replace("{" + bindMappings.get(bound) + "}", "{" + bound + "}");
            }
         } else {
            // When not mapping the signature we do the replacement directly in the ASM
            for(String bound : bindMappings.keySet()) {
               subFragment = subFragment.replace("{" + bound + "}", "{" + bindMappings.get(bound) + "}");
            }
         }
      }
      newFragment.append(subFragment);
      if(asmPostfix != null) {
         if(newFragment.length() > 0 && !newFragment.substring(newFragment.length() - 1).equals("\n")) {
            newFragment.append("\n");
         }
         newFragment.append(asmPostfix);
      }
      if(newFragment.length() > 0 && newFragment.charAt(newFragment.length() - 1) == '\n') {
         newFragment = new StringBuilder(newFragment.substring(0, newFragment.length() - 1));
      }
      return new AsmFragmentTemplate(signature, newFragment.toString(), this, subTemplate);
   }

   static String regexpRewriteSignature(String signature, String match, String replace) {
      Pattern p = Pattern.compile(match);
      Matcher m = p.matcher(signature);
      String output = signature;
      if(m.find()) {
         output = m.replaceAll(replace);
      }
      return output;
   }

   @Override
   public boolean equals(Object o) {
      if(this == o) return true;
      if(o == null || getClass() != o.getClass()) return false;
      AsmFragmentTemplateSynthesisRuleRegex that = (AsmFragmentTemplateSynthesisRuleRegex) o;
      return mapSignature == that.mapSignature &&
            Objects.equals(sigMatch, that.sigMatch) &&
            Objects.equals(sigAvoid, that.sigAvoid) &&
            Objects.equals(asmPrefix, that.asmPrefix) &&
            Objects.equals(sigReplace, that.sigReplace) &&
            Objects.equals(asmPostfix, that.asmPostfix) &&
            Objects.equals(bindMappings, that.bindMappings) &&
            Objects.equals(subDontClobber, that.subDontClobber);
   }

   @Override
   public int hashCode() {
      return Objects.hash(sigMatch, sigAvoid, asmPrefix, sigReplace, asmPostfix, bindMappings, mapSignature, subDontClobber);
   }

   @Override
   public String toString() {
      return "match:" + sigMatch+ " avoid:"+sigAvoid+" replace:"+sigReplace;
   }
}

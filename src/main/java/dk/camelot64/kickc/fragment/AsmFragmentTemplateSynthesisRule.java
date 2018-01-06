package dk.camelot64.kickc.fragment;

import dk.camelot64.kickc.CompileLog;

import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/** AsmFragment synthesis mechanism based on matching fragment signature and reusing another fragment with added prefix/postfix and some bind-mappings */
class AsmFragmentTemplateSynthesisRule {

   /** Regular expression that matches the signature of fragments that the synthesis rule can handle.
    * Contains matching groups (parenthesis) that are used in sigReplace to build the signature of the sub-fragment to synthesize from. */
   final String sigMatch;

   /** Regular expression that limits which fragments the synthesize rule can handle. */
   final String sigAvoid;

   /** ASM code prefixed to the sub-fragment when synthesizing. */
   final private String asmPrefix;

   /** Signature of the sub-fragment to use for synthesizing the fragment. References the matching groups from sigMatch (via $1, $2, ...). */
   final String sigReplace;

   /** ASM code postfixed to the sub-fragment when synthesizing. */
   final private String asmPostfix;

   /** Bindings for mapping replacing parameter names in the signature & ASM of the sub-fragment. */
   final private Map<String, String> bindMappings;

   /** Indicates whether to map parameters in the signature. If false only the parameters in the ASM are mapped.*/
   final private boolean mapSignature;

   /** Names of registers ("aa", "xx", "yy") that the sub-fragment is not allowed to clobber. Limits which sub-fragments the rule can use for creating the synthesis. */
   final String subDontClobber;

   AsmFragmentTemplateSynthesisRule(String sigMatch, String sigAvoid, String asmPrefix, String sigReplace, String asmPostfix, Map<String, String> bindMappings, boolean mapSignature, String subDontClobber) {
      this.sigMatch = sigMatch;
      this.sigAvoid = sigAvoid;
      this.asmPrefix = asmPrefix;
      this.sigReplace = sigReplace;
      this.asmPostfix = asmPostfix;
      this.bindMappings = bindMappings;
      this.mapSignature = mapSignature;
      this.subDontClobber = subDontClobber;
   }

   AsmFragmentTemplateSynthesisRule(String sigMatch, String sigAvoid, String asmPrefix, String sigReplace, String asmPostfix, Map<String, String> bindMappings) {
      this(sigMatch, sigAvoid, asmPrefix, sigReplace, asmPostfix, bindMappings, true, null);
   }

   AsmFragmentTemplateSynthesisRule(String sigMatch, String sigAvoid, String asmPrefix, String sigReplace, String asmPostfix, Map<String, String> bindMappings, boolean mapSignature) {
      this(sigMatch, sigAvoid, asmPrefix, sigReplace, asmPostfix, bindMappings, mapSignature, null);
   }

   AsmFragmentTemplateSynthesisRule(String sigMatch, String sigAvoid, String asmPrefix, String sigReplace, String asmPostfix, Map<String, String> bindMappings, String subDontClobber) {
      this(sigMatch, sigAvoid, asmPrefix, sigReplace, asmPostfix, bindMappings, true, subDontClobber);
   }

   /**
    * Is the rule match usable for synthesizing a fragment template
    *
    * @param signature The fragment template signature
    * @return true if the rule matches the signature
    */
   public boolean matches(String signature) {
      return signature.matches(sigMatch) && (sigAvoid == null || !signature.matches(sigAvoid));
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
      if(!matches(signature)) {
         throw new RuntimeException("Synthesis error! Attempting to synthesize on non-matching signature signature:"+signature+" match:"+sigMatch+" avoid:"+sigAvoid);
      }
      if(!subTemplate.getSignature().equals(getSubSignature(signature))) {
         throw new RuntimeException("Synthesis error! Attempting to synthesize on non-matching sub template sub-signature:"+subTemplate.getSignature()+" expecting:"+getSubSignature(signature));
      }
      if(subDontClobber!=null) {
         if(subDontClobber.contains("aa") && subTemplate.getClobber().isClobberA()) return null;
         if(subDontClobber.contains("xx") && subTemplate.getClobber().isClobberX()) return null;
         if(subDontClobber.contains("yy") && subTemplate.getClobber().isClobberY()) return null;
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
         if(newFragment.length()>0 && !newFragment.substring(newFragment.length()-1).equals("\n")) {
            newFragment.append("\n");
         }
         newFragment.append(asmPostfix);
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

      AsmFragmentTemplateSynthesisRule that = (AsmFragmentTemplateSynthesisRule) o;

      if(mapSignature != that.mapSignature) return false;
      if(sigMatch != null ? !sigMatch.equals(that.sigMatch) : that.sigMatch != null) return false;
      if(sigAvoid != null ? !sigAvoid.equals(that.sigAvoid) : that.sigAvoid != null) return false;
      if(asmPrefix != null ? !asmPrefix.equals(that.asmPrefix) : that.asmPrefix != null) return false;
      if(sigReplace != null ? !sigReplace.equals(that.sigReplace) : that.sigReplace != null) return false;
      if(asmPostfix != null ? !asmPostfix.equals(that.asmPostfix) : that.asmPostfix != null) return false;
      return bindMappings != null ? bindMappings.equals(that.bindMappings) : that.bindMappings == null;
   }

   @Override
   public int hashCode() {
      int result = sigMatch != null ? sigMatch.hashCode() : 0;
      result = 31 * result + (sigAvoid != null ? sigAvoid.hashCode() : 0);
      result = 31 * result + (asmPrefix != null ? asmPrefix.hashCode() : 0);
      result = 31 * result + (sigReplace != null ? sigReplace.hashCode() : 0);
      result = 31 * result + (asmPostfix != null ? asmPostfix.hashCode() : 0);
      result = 31 * result + (bindMappings != null ? bindMappings.hashCode() : 0);
      result = 31 * result + (mapSignature ? 1 : 0);
      return result;
   }

   /** All the synthesize rules available. */
   private static List<AsmFragmentTemplateSynthesisRule> fragmentSyntheses;

   static List<AsmFragmentTemplateSynthesisRule> getSynthesisRules() {
      if(fragmentSyntheses == null) {
         fragmentSyntheses = initFragmentSyntheses();
      }
      return fragmentSyntheses;
   }

   private static List<AsmFragmentTemplateSynthesisRule> initFragmentSyntheses() {
      Map<String, String> mapZ = new LinkedHashMap<>();
      mapZ.put("z2", "z1");
      mapZ.put("z3", "z2");
      Map<String, String> mapZ2 = new LinkedHashMap<>();
      mapZ2.put("z3", "z1");
      Map<String, String> mapZ3 = new LinkedHashMap<>();
      mapZ3.put("z3", "z2");
      Map<String, String> mapZ4 = new LinkedHashMap<>();
      mapZ3.put("z4", "z3");
      Map<String, String> mapC = new LinkedHashMap<>();
      mapC.put("c2", "c1");
      mapC.put("c3", "c2");
      Map<String, String> mapC3 = new LinkedHashMap<>();
      mapC3.put("c3", "c2");
      Map<String, String> mapZC = new LinkedHashMap<>();
      mapZC.putAll(mapZ);
      mapZC.putAll(mapC);
      Map<String, String> mapSToU = new LinkedHashMap<>();
      mapSToU.put("vbsz1", "vbuz1");
      mapSToU.put("vbsz2", "vbuz2");
      mapSToU.put("vbsz3", "vbuz3");
      mapSToU.put("vbsc1", "vbuc1");
      mapSToU.put("vbsc2", "vbuc2");
      mapSToU.put("vbsc3", "vbuc3");
      mapSToU.put("vbsaa", "vbuaa");
      mapSToU.put("vbsxx", "vbuxx");
      mapSToU.put("vbsyy", "vbuyy");
      mapSToU.put("vwsz1", "vwuz1");
      mapSToU.put("vwsz2", "vwuz2");
      mapSToU.put("vwsz3", "vwuz3");
      mapSToU.put("vwsc1", "vwuc1");
      mapSToU.put("vwsc2", "vwuc2");
      mapSToU.put("vwsc3", "vwuc3");

      List<AsmFragmentTemplateSynthesisRule> synths = new ArrayList<>();

      // NEW STYLE REWRITES - Utilizes that all combinations are tried

      // Replace first AA with XX
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)aa(.*)", "...aa=.*|.*xx.*", "tax", "$1xx$2", null, null));
      // Replace two AAs with XX
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)aa(.*vb.)aa(.*)", "...aa=.*|.*xx.*", "tax", "$1xx$2xx$3", null, null));
      // Replace second (not first) AA with XX
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)aa(.*vb.)aa(.*)", "...aa=.*|.*xx.*", "tax", "$1aa$2xx$3", null, null));
      // Replace two AAs with XX (not assigned)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*vb.)aa(.*vb.)aa(.*)", ".*xx.*", "tax", "$1=$2xx$3xx$4", null, null));

      // Replace first AA with YY
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)aa(.*)", "...aa=.*|.*yy.*", "tay", "$1yy$2", null, null));
      // Replace second (not first) AA with YY
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)aa(.*vb.)aa(.*)", "...aa=.*|.*yy.*", "tay", "$1aa$2yy$3", null, null));
      // Replace two AAs with YY
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)aa(.*vb.)aa(.*)", "...aa=.*|.*yy.*", "tay", "$1yy$2yy$3", null, null));
      // Replace two AAs with YY (not assigned)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*vb.)aa(.*vb.)aa(.*)", ".*yy.*", "tay", "$1=$2yy$3yy$4", null, null));

      // Replace first XX with AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)xx(.*)", "...xx=.*|.*aa.*", "txa", "$1aa$2", null, null));
      // Replace two XXs with AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)xx(.*vb.)xx(.*)", "...xx=.*|.*aa.*", "txa", "$1aa$2aa$3", null, null));
      // Replace second (not first) XX with AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)xx(.*vb.)xx(.*)", "...xx=.*|.*aa.*", "txa", "$1xx$2aa$3", null, null));
      // Replace two XXs with AA (not assigned)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*vb.)xx(.*vb.)xx(.*)", ".*aa.*", "txa", "$1=$2aa$3aa$4", null, null));

      // Replace first YY with AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)yy(.*)", "...yy=.*|.*aa.*", "tya", "$1aa$2", null, null));
      // Replace two YYs with AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)yy(.*vb.)yy(.*)", "...yy=.*|.*aa.*", "tya", "$1aa$2aa$3", null, null));
      // Replace second (not first) YY with AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)yy(.*vb.)yy(.*)", "...yy=.*|.*aa.*", "tya", "$1yy$2aa$3", null, null));
      // Replace two YYs with AA (not assigned)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*vb.)yy(.*vb.)yy(.*)", ".*aa.*", "tya", "$1=$2aa$3aa$4", null, null));

      // Replace Z1 with AA (only one)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)z1(.*)", "...z1=.*|.*z1.*z1.*|.*aa.*", "lda {z1}", "$1aa$2", null, mapZ));
      // Replace two Z1s with AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)z1(.*vb.)z1(.*)", "...z1=.*|.*z1.*z1.*z1.*|.*aa.*", "lda {z1}", "$1aa$2aa$3", null, mapZ));
      // Replace first (not second) Z1 with AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)z1(.*)z1(.*)", "...z1=.*|.*aa.*", "lda {z1}", "$1aa$2z1$3", null, null));
      // Replace second (not first) Z1 with AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)z1(.*vb.)z1(.*)", "...z1=.*|.*aa.*", "lda {z1}", "$1z1$2aa$3", null, null));
      // Replace non-assigned Z1 with AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(...aa)=(.*vb.)z1(.*)", ".*z1.*z1.*|.*=.*aa.*", "lda {z1}", "$1=$2aa$3", null, mapZ));
      // Replace assigned Z1 with AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(vb.)z1=(.*)", ".*z1.*z1.*", null, "$1aa=$2", "sta {z1}", mapZ));

      // Replace Z1 with YY (only one)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)z1(.*)", "...z1=.*|.*z1.*z1.*|.*yy.*", "ldy {z1}", "$1yy$2", null, mapZ));
      // Replace two Z1s with YY
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)z1(.*vb.)z1(.*)", "...z1=.*|.*z1.*z1.*z1.*|.*yy.*", "ldy {z1}", "$1yy$2yy$3", null, mapZ));
      // Replace first (not second) Z1 with YY
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)z1(.*)z1(.*)", "...z1=.*|.*yy.*", "ldy {z1}", "$1yy$2z1$3", null, null));
      // Replace second (not first) Z1 with YY
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)z1(.*vb.)z1(.*)", "...z1=.*|.*yy.*", "ldy {z1}", "$1z1$2yy$3", null, null));
      // Replace non-assigned Z1 with YY
      synths.add(new AsmFragmentTemplateSynthesisRule("(...yy)=(.*vb.)z1(.*)", ".*z1.*z1.*|.*=.*yy.*", "ldy {z1}", "$1=$2yy$3", null, mapZ));
      // Replace assigned Z1 with YY
      synths.add(new AsmFragmentTemplateSynthesisRule("(vb.)z1=(.*)", ".*z1.*z1.*", null, "$1yy=$2", "sty {z1}", mapZ));

      // Replace Z1 with XX (only one)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)z1(.*)", "...z1=.*|.*z1.*z1.*|.*xx.*", "ldx {z1}", "$1xx$2", null, mapZ));
      // Replace two Z1s with XX
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)z1(.*vb.)z1(.*)", "...z1=.*|.*z1.*z1.*z1.*|.*xx.*", "ldx {z1}", "$1xx$2xx$3", null, mapZ));
      // Replace first (not second) Z1 with XX
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)z1(.*)z1(.*)", "...z1=.*|.*xx.*", "ldx {z1}", "$1xx$2z1$3", null, null));
      // Replace second (not first) Z1 with XX
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)z1(.*vb.)z1(.*)", "...z1=.*|.*xx.*", "ldx {z1}", "$1z1$2xx$3", null, null));
      // Replace non-assigned Z1 with XX
      synths.add(new AsmFragmentTemplateSynthesisRule("(...xx)=(.*vb.)z1(.*)", ".*z1.*z1.*|.*=.*xx.*", "ldx {z1}", "$1=$2xx$3", null, mapZ));
      // Replace assigned Z1 with XX
      synths.add(new AsmFragmentTemplateSynthesisRule("(vb.)z1=(.*)", ".*z1.*z1.*", null, "$1xx=$2", "stx {z1}", mapZ));

      // Replace Z2 with AA (only one)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)z2(.*)", "...z2=.*|.*z2.*z2.*|.*aa.*", "lda {z2}", "$1aa$2", null, mapZ3));
      // Replace two Z2s with AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)z2(.*vb.)z2(.*)", "...z2=.*|.*z2.*z2.*z2.*|.*aa.*", "lda {z2}", "$1aa$2aa$3", null, mapZ3));
      // Replace first (of 2) Z2 with AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)z2(.*)z2(.*)", "...z2=.*|.*aa.*", "lda {z2}", "$1aa$2z2$3", null, null));
      // Replace second (of 2) Z2 with AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)z2(.*vb.)z2(.*)", "...z2=.*|.*aa.*", "lda {z2}", "$1z2$2aa$3", null, null));

      // Replace Z2 with YY (only one)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)z2(.*)", "...z2=.*|.*z2.*z2.*|.*yy.*", "ldy {z2}", "$1yy$2", null, mapZ3));
      // Replace two Z2s with YY
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)z2(.*vb.)z2(.*)", "...z2=.*|.*z2.*z2.*z2.*|.*yy.*", "ldy {z2}", "$1yy$2yy$3", null, mapZ3));
      // Replace first (of 2) Z2 with YY
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)z2(.*)z2(.*)", "...z2=.*|.*yy.*", "ldy {z2}", "$1yy$2z2$3", null, null));
      // Replace second (of 2) Z2 with YY
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)z2(.*vb.)z2(.*)", "...z2=.*|.*yy.*", "ldy {z2}", "$1z2$2yy$3", null, null));

      // Replace Z2 with XX(only one)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)z2(.*)", "...z2=.*|.*z2.*z2.*|.*xx.*", "ldx {z2}", "$1xx$2", null, mapZ3));
      // Replace two Z2s with XX
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)z2(.*vb.)z2(.*)", "...z2=.*|.*z2.*z2.*z2.*|.*xx.*", "ldx {z2}", "$1xx$2xx$3", null, mapZ3));
      // Replace first (of 2) Z2 with XX
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)z2(.*)z2(.*)", "...z2=.*|.*xx.*", "ldx {z2}", "$1xx$2z2$3", null, null));
      // Replace second (of 2) Z2 with XX
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)z2(.*vb.)z2(.*)", "...z2=.*|.*xx.*", "ldx {z2}", "$1z2$2xx$3", null, null));

      // Replace Z3 with AA (only one)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)z3(.*)", "...z3=.*|.*z3.*z3.*|.*aa.*", "lda {z3}", "$1aa$2", null, mapZ4));
      // Replace Z3 with YY (only one)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)z3(.*)", "...z3=.*|.*z3.*z3.*|.*yy.*", "ldy {z3}", "$1yy$2", null, mapZ4));
      // Replace Z3 with XX (only one)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)z3(.*)", "...z3=.*|.*z3.*z3.*|.*xx.*", "ldx {z3}", "$1xx$2", null, mapZ4));


      // Rewrite comparisons < to >
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_gt_(.*)_then_(.*)", null, null, "$2_lt_$1_then_$3", null, null));
      // Rewrite comparisons > to <
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_lt_(.*)_then_(.*)", null, null, "$2_gt_$1_then_$3", null, null));
      // Rewrite comparisons <= to >=
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_le_(.*)_then_(.*)", null, null, "$2_ge_$1_then_$3", null, null));
      // Rewrite comparisons >= to <=
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_ge_(.*)_then_(.*)", null, null, "$2_le_$1_then_$3", null, null));
      // Rewrite comparisons swap ==
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_eq_(.*)_then_(.*)", null, null, "$2_eq_$1_then_$3", null, null));
      // Rewrite comparisons swap !=
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_neq_(.*)_then_(.*)", null, null, "$2_neq_$1_then_$3", null, null));

      // Swap parameters on commutative operators
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)_(band|bor|bxor|plus)_(.*)", null, null, "$1=$4_$3_$2", null, null));
      // Swap parameters on commutative comparators
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_(eq|neq)_(.*)_then_(.*)", null, null, "$3_$2_$1_then_$4", null, null));

      // Rewrite Assignments to X from A
      synths.add(new AsmFragmentTemplateSynthesisRule("vb(.)xx=(.*)", null, null, "vb$1aa=$2", "tax", null));
      // Rewrite Assignments to Y from A
      synths.add(new AsmFragmentTemplateSynthesisRule("vb(.)yy=(.*)", null, null, "vb$1aa=$2", "tay", null));
      // Rewrite Assignments to Z1 from A
      synths.add(new AsmFragmentTemplateSynthesisRule("vb(.)z1=(.*)", ".*z1.*z1.*", null, "vb$1aa=$2", "sta {z1}", mapZ));
      // Rewrite Assignments to Z1 from A
      synths.add(new AsmFragmentTemplateSynthesisRule("vb(.)z1=(.*z1.*)", null, null, "vb$1aa=$2", "sta {z1}", null));
      // Rewrite Assignments to *C1 from A
      synths.add(new AsmFragmentTemplateSynthesisRule("_deref_pb(.)c1=(.*)", ".*c1.*c1.*", null, "vb$1aa=$2", "sta {c1}", mapC));
      // Rewrite Assignments to *C1 from A
      synths.add(new AsmFragmentTemplateSynthesisRule("_deref_pb(.)c1=(.*c1.*)", null, null, "vb$1aa=$2", "sta {c1}", null));
      // Rewrite Assignments to *Z1 from A
      synths.add(new AsmFragmentTemplateSynthesisRule("_deref_pbuz1=(.*)", ".*z1.*z1.*", null, "vbuaa=$1", "ldy #0\n" + "sta ({z1}),y", mapZ));
      // Rewrite Assignments to *Z1 from A
      synths.add(new AsmFragmentTemplateSynthesisRule("_deref_pbuz1=(.*z1.*)", null, null, "vbuaa=$1", "ldy #0\n" + "sta ({z1}),y", null));

      // OLD STYLE REWRITES - written when only one rule could be taken

      //synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)_(band|bor|bxor|plus)_(vb.aa)", ".*=vb.aa_.*", null, "$1=$4_$3_$2", null, null));
      //synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)_(band|bor|bxor|plus)_(vb.xx)", ".*=vb.[ax][ax]_.*", null, "$1=$4_$3_$2", null, null));
      //synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)_(band|bor|bxor|plus)_(vb.yy)", ".*=vb.[axy][axy]_.*", null, "$1=$4_$3_$2", null, null));

      synths.add(new AsmFragmentTemplateSynthesisRule("vb(.)xx=(.*)", null, null, "vb$1aa=$2", "tax\n", null));
      synths.add(new AsmFragmentTemplateSynthesisRule("vb(.)yy=(.*)", null, null, "vb$1aa=$2", "tay\n", null));
      //synths.add(new AsmFragmentTemplateSynthesisRule("vbsyy=(.*)", null, null, "vbsaa=$1", "tay\n", null));
      //synths.add(new AsmFragmentTemplateSynthesisRule("vbsz1=(.*)", ".*=.*vb.z1.*", null, "vbsaa=$1", "sta {z1}\n", mapZ));

      synths.add(new AsmFragmentTemplateSynthesisRule("pb(.)c1_derefidx_vbuz1=(.*)", ".*z1.*z1.*|.*c1.*c1.*", null, "vb$1aa=$2", "ldx {z1}\n" + "sta {c1},x", mapZC));
      synths.add(new AsmFragmentTemplateSynthesisRule("pb(.)c1_derefidx_vbuyy=(.*)", ".*c1.*c1.*", null, "vb$1aa=$2", "sta {c1},y", mapC, "yy"));
      synths.add(new AsmFragmentTemplateSynthesisRule("pb(.)c1_derefidx_vbuxx=(.*)", ".*c1.*c1.*", null, "vb$1aa=$2", "sta {c1},x", mapC, "xx"));
      synths.add(new AsmFragmentTemplateSynthesisRule("pb(.)z1_derefidx_vbuz2=(.*)", ".*z1.*z1.*|.*z2.*z2.*", null, "vb$1aa=$2", "ldy {z2}\n" + "sta ({z1}),y", mapZ2));

      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=_deref_pb(.)c1(.*)", ".*=.*aa.*", "lda {c1}", "$1=vb$2aa$3", null, mapC));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=_deref_pb(.)z1(.*)", ".*z1.*z1.*|.*=.*aa.*|.*yy.*", "ldy #0\n" + "lda ({z1}),y", "$1=vb$2aa$3", null, mapZ));

      // Convert array indexing with A register to X/Y register by prefixing tax/tay (..._derefidx_vbuaa... -> ..._derefidx_vbuxx... /... _derefidx_vbuyy... )
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)_derefidx_vbuaa(.*)", ".*xx.*", "tax", "$1=$2_derefidx_vbuxx$3", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)_derefidx_vbuaa(.*)", ".*yy.*", "tay", "$1=$2_derefidx_vbuyy$3", null, null));
      // Convert array indexing with zero page to x/y register by prefixing ldx z1 / ldy z1 ( ..._derefidx_vbuzn... -> ..._derefidx_vbuxx... / ..._derefidx_vbuyy... )
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)_derefidx_vbuz1(.*)", ".*xx.*|.*z1.*z1.*", "ldx {z1}", "$1=$2_derefidx_vbuxx$3", null, mapZ));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)_derefidx_vbuz1(.*)", ".*yy.*|.*z1.*z1.*", "ldy {z1}", "$1=$2_derefidx_vbuyy$3", null, mapZ));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)_derefidx_vbuz2(.*)", ".*xx.*|.*z2.*z2.*", "ldx {z2}", "$1=$2_derefidx_vbuxx$3", null, mapZ3));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)_derefidx_vbuz2(.*)", ".*yy.*|.*z2.*z2.*", "ldy {z2}", "$1=$2_derefidx_vbuyy$3", null, mapZ3));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)_derefidx_vbuz3(.*)", ".*yy.*", "ldy {z3}", "$1=$2_derefidx_vbuyy$3", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)_derefidx_vbuz3(.*)", ".*xx.*", "ldx {z3}", "$1=$2_derefidx_vbuxx$3", null, null));
      // Convert array indexing twice with A/zp1/zp2 to X/Y register with a ldx/ldy prefix ( ..._derefidx_vbunn..._derefidx_vbunn... -> ..._derefidx_vbuxx..._derefidx_vbuxx... )
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_derefidx_vbuaa(.*)_derefidx_vbuaa(.*)", ".*aa.*aa.*aa.*|.*xx.*", null, "$1_derefidx_vbuxx$2_derefidx_vbuxx$3", "tax", null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_derefidx_vbuaa(.*)_derefidx_vbuaa(.*)", ".*aa.*aa.*aa.*|.*yy.*", null, "$1_derefidx_vbuyy$2_derefidx_vbuyy$3", "tay", null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_derefidx_vbuz1(.*)_derefidx_vbuz1(.*)", ".*z1.*z1.*z1.*|.*xx.*", null, "$1_derefidx_vbuxx$2_derefidx_vbuxx$3", "ldx {z1}", mapZ));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_derefidx_vbuz1(.*)_derefidx_vbuz1(.*)", ".*z1.*z1.*z1.*|.*yy.*", null, "$1_derefidx_vbuyy$2_derefidx_vbuyy$3", "ldy {z1}", mapZ));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_derefidx_vbuz2(.*)_derefidx_vbuz2(.*)", ".*z2.*z2.*z2.*|.*xx.*", null, "$1_derefidx_vbuxx$2_derefidx_vbuxx$3", "ldx {z2}", mapZ));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_derefidx_vbuz2(.*)_derefidx_vbuz2(.*)", ".*z2.*z2.*z2.*|.*yy.*", null, "$1_derefidx_vbuyy$2_derefidx_vbuyy$3", "ldy {z2}", mapZ));
      synths.add(new AsmFragmentTemplateSynthesisRule("pb(.)c1_derefidx_vbuz1=(.*c1.*)", ".*z1.*z1.*", null, "vb$1aa=$2", "ldx {z1}\n" + "sta {c1},x", mapZ));
      synths.add(new AsmFragmentTemplateSynthesisRule("pb(.)c1_derefidx_vbuz1=(.*z1.*)", ".*c1.*c1.*", null, "vb$1aa=$2", "ldx {z1}\n" + "sta {c1},x", mapC));

      // Convert X/Y-based array indexing of a constant pointer into A-register by prefixing lda cn,x / lda cn,y ( ...pb.c1_derefidx_vbuxx... / ...pb.c1_derefidx_vbuyy... -> ...vb.aa... )
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)pb(.)c1_derefidx_vbuxx(.*)", ".*=.*aa.*|.*c1.*c1.*", "lda {c1},x", "$1=$2vb$3aa$4", null, mapC));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*c1.*)pb(.)c1_derefidx_vbuxx(.*)", ".*=.*aa.*", "lda {c1},x", "$1=$2vb$3aa$4", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)pb(.)c1_derefidx_vbuxx(.*c1.*)", ".*=.*aa.*", "lda {c1},x", "$1=$2vb$3aa$4", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)pb(.)c1_derefidx_vbuyy(.*)", ".*=.*aa.*|.*c1.*c1.*", "lda {c1},y", "$1=$2vb$3aa$4", null, mapC));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*c1.*)pb(.)c1_derefidx_vbuyy(.*)", ".*=.*aa.*", "lda {c1},y", "$1=$2vb$3aa$4", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)pb(.)c1_derefidx_vbuyy(.*c1.*)", ".*=.*aa.*", "lda {c1},y", "$1=$2vb$3aa$4", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)pb(.)c2_derefidx_vbuxx(.*)", ".*=.*aa.*|.*c2.*c2.*", "lda {c2},x", "$1=$2vb$3aa$4", null, mapC3));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*c2.*)pb(.)c2_derefidx_vbuxx(.*)", ".*=.*aa.*", "lda {c2},x", "$1=$2vb$3aa$4", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)pb(.)c2_derefidx_vbuxx(.*c2.*)", ".*=.*aa.*", "lda {c2},x", "$1=$2vb$3aa$4", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)pb(.)c2_derefidx_vbuyy(.*)", ".*=.*aa.*|.*c2.*c2.*", "lda {c2},y", "$1=$2vb$3aa$4", null, mapC3));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*c2.*)pb(.)c2_derefidx_vbuyy(.*)", ".*=.*aa.*", "lda {c2},y", "$1=$2vb$3aa$4", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)pb(.)c2_derefidx_vbuyy(.*c2.*)", ".*=.*aa.*", "lda {c2},y", "$1=$2vb$3aa$4", null, null));

      // Convert zeropage/constants/X/Y in assignments to A-register using LDA/TXA/TYA prefix
      //synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)vbuz1(.*)", ".*z1.*=.*|.*=.*aa.*|.*z1.*z1.*", "lda {z1}", "$1=$2vbuaa$3", null, mapZ));
      //synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)vbsz1(.*)", ".*z1.*=.*|.*=.*aa.*|.*z1.*z1.*", "lda {z1}", "$1=$2vbsaa$3", null, mapZ));
      //synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)vbuz2(.*)", ".*z2.*=.*|.*=.*aa.*|.*z2.*z2.*|.*z3.*", "lda {z2}", "$1=$2vbuaa$3", null, null));
      //synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)vbsz2(.*)", ".*z2.*=.*|.*=.*aa.*|.*z2.*z2.*|.*z3.*", "lda {z2}", "$1=$2vbsaa$3", null, null));
      //synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)vbuz2(.*z3.*)", ".*z2.*=.*|.*=.*aa.*|.*z2.*z2.*|.*z3.*", "lda {z2}", "$1=$2vbuaa$3", null, mapZ3));
      //synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)vbsz2(.*z3.*)", ".*z2.*=.*|.*=.*aa.*|.*z2.*z2.*|.*z3.*", "lda {z2}", "$1=$2vbsaa$3", null, mapZ3));

      //synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)_vbuxx", ".*=.*[ax][ax].*xx|.*derefidx_vb.xx", "txa", "$1=$2_vbuaa", null, null));
      //synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)_vbsxx", ".*=.*[ax][ax].*xx|.*derefidx_vb.xx", "txa", "$1=$2_vbsaa", null, null));
      //synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)_vbuyy", ".*=.*[ay][ay].*yy|.*derefidx_vb.yy", "tya", "$1=$2_vbuaa", null, null));
      //synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)_vbsyy", ".*=-*[ay][ay].*yy|.*derefidx_vb.yy", "tya", "$1=$2_vbsaa", null, null));
      //synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)_vbuz1", ".*=.*aa.*|.*z1.*z1.*", "lda {z1}", "$1=$2_vbuaa", null, mapZ));
      //synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)_vbsz1", ".*=.*aa.*|.*z1.*z1.*", "lda {z1}", "$1=$2_vbsaa", null, mapZ));
      //synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)_vbuz2", ".*=.*aa.*|.*z2.*z2.*", "lda {z2}", "$1=$2_vbuaa", null, null));
      //synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)_vbuz3", ".*=.*aa.*|.*z3.*z3.*", "lda {z3}", "$1=$2_vbuaa", null, null));

      synths.add(new AsmFragmentTemplateSynthesisRule("vbuz1=vbuz1(.*)", ".*=.*vb.aa.*|.*z1.*z1.*z1.*", "lda {z1}", "vbuaa=vbuaa$1", "sta {z1}", mapZ));
      synths.add(new AsmFragmentTemplateSynthesisRule("vbsz1=vbsz1(.*)", ".*=.*vb.aa.*|.*z1.*z1.*z1.*", "lda {z1}", "vbsaa=vbsaa$1", "sta {z1}", mapZ));

      //synths.add(new AsmFragmentTemplateSynthesisRule("vbuz1_(lt|gt|le|ge|eq|neq)_(.*)", ".*vb.aa.*|.*z1.*z1.*", "lda {z1}", "vbuaa_$1_$2", null, mapZ));
      //synths.add(new AsmFragmentTemplateSynthesisRule("vbsz1_(lt|gt|le|ge|eq|neq)_(.*)", ".*vb.aa.*|.*z1.*z1.*", "lda {z1}", "vbsaa_$1_$2", null, mapZ));
      synths.add(new AsmFragmentTemplateSynthesisRule("_deref_pb(.)c1_(lt|gt|le|ge|eq|neq)_(.*)", ".*vb.aa.*", "lda {c1}", "vb$1aa_$2_$3", null, mapC));
      synths.add(new AsmFragmentTemplateSynthesisRule("_deref_pb(.)z1_(lt|gt|le|ge|eq|neq)_(.*)", ".*vb.aa.*|.*vb.yy.*|.*z1.*z1.*", "ldy #0\n" + "lda ({z1}),y", "vb$1aa_$2_$3", null, mapZ));

      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_derefidx_vbuz1_(.*)", ".*z1.*z1.*|.*.yy.*", "ldy {z1}", "$1_derefidx_vbuyy_$2", null, mapZ));

      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_derefidx_vbuz1_(lt|gt|le|ge|eq|neq)_(.*)", ".*z1.*z1.*|.*vb.xx.*", "ldx {z1}", "$1_derefidx_vbuxx_$2_$3", null, mapZ));
      synths.add(new AsmFragmentTemplateSynthesisRule("pb(.)c1_derefidx_vbuyy_(lt|gt|le|ge|eq|neq)_(.*)", ".*c1.*c1.*|.*aa.*", "lda {c1},y", "vb$1aa_$2_$3", null, mapC));
      synths.add(new AsmFragmentTemplateSynthesisRule("pb(.)c1_derefidx_vbuyy_(lt|gt|le|ge|eq|neq)_(.*c1.*)", ".*aa.*", "lda {c1},y", "vb$1aa_$2_$3", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("pb(.)c1_derefidx_vbuxx_(lt|gt|le|ge|eq|neq)_(.*)", ".*c1.*c1.*|.*aa.*", "lda {c1},x", "vb$1aa_$2_$3", null, mapC));
      synths.add(new AsmFragmentTemplateSynthesisRule("pb(.)c1_derefidx_vbuxx_(lt|gt|le|ge|eq|neq)_(.*c1.*)", ".*aa.*", "lda {c1},x", "vb$1aa_$2_$3", null, null));

      //synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_ge_(vb.aa)_then_(.*)", ".*vb.aa.*_ge.*", null, "$2_le_$1_then_$3", null, null));
      //synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_ge_(vb.xx)_then_(.*)", ".*vb.[ax][ax].*_ge.*", null, "$2_le_$1_then_$3", null, null));
      //synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_ge_(vb.yy)_then_(.*)", ".*vb.[axy][axy].*_ge.*", null, "$2_le_$1_then_$3", null, null));
      //synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_lt_(vb.aa)_then_(.*)", ".*vb.aa.*_lt.*", null, "$2_gt_$1_then_$3", null, null));
      //synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_lt_(vb.xx)_then_(.*)", ".*vb.[ax][ax].*_lt.*", null, "$2_gt_$1_then_$3", null, null));
      //synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_lt_(vb.yy)_then_(.*)", ".*vb.[axy][axy].*_lt.*", null, "$2_gt_$1_then_$3", null, null));
      //synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_gt_(vb.aa)_then_(.*)", ".*vb.aa.*_gt.*", null, "$2_lt_$1_then_$3", null, null));
      //synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_gt_(vb.xx)_then_(.*)", ".*vb.[ax][ax].*_gt.*", null, "$2_lt_$1_then_$3", null, null));
      //synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_gt_(vb.yy)_then_(.*)", ".*vb.[axy][axy].*_gt.*", null, "$2_lt_$1_then_$3", null, null));
      //synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_le_(vb.aa)_then_(.*)", ".*vb.aa.*_le.*", null, "$2_ge_$1_then_$3", null, null));
      //synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_le_(vb.xx)_then_(.*)", ".*vb.[ax][ax].*_le.*", null, "$2_ge_$1_then_$3", null, null));
      //synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_le_(vb.yy)_then_(.*)", ".*vb.[axy][axy].*_le.*", null, "$2_ge_$1_then_$3", null, null));
      //synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_neq_(vb.aa)_then_(.*)", ".*vb.aa.*_neq.*", null, "$2_neq_$1_then_$3", null, null));
      //synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_neq_(vb.xx)_then_(.*)", ".*vb.[ax][ax].*_neq.*", null, "$2_neq_$1_then_$3", null, null));
      //synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_neq_(vb.yy)_then_(.*)", ".*vb.[axy][axy].*_neq.*", null, "$2_neq_$1_then_$3", null, null));
      //synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_eq_(vb.aa)_then_(.*)", ".*vb.aa.*_eq.*", null, "$2_eq_$1_then_$3", null, null));
      //synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_eq_(vb.xx)_then_(.*)", ".*vb.[ax][ax].*_eq.*", null, "$2_eq_$1_then_$3", null, null));
      //synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_eq_(vb.yy)_then_(.*)", ".*vb.[axy][axy].*_eq.*", null, "$2_eq_$1_then_$3", null, null));

      // Use unsigned ASM to synthesize signed ASM ( ...vbs... -> ...vbu... )
      synths.add(new AsmFragmentTemplateSynthesisRule("(vbsz.|vbsc.|vbsaa|vbsxx|vbsyy)_(eq|neq)_(vbsz.|vbsc.|vbsaa|vbsxx|vbsyy)_then_(.*)", null, null, "$1_$2_$3_then_$4", null, mapSToU));
      synths.add(new AsmFragmentTemplateSynthesisRule("(vbsz.|vbsc.|vbsaa|vbsxx|vbsyy)=(vbsz.|vbsc.|vbsaa|vbsxx|vbsyy)", null, null, "$1=$2", null, mapSToU));
      synths.add(new AsmFragmentTemplateSynthesisRule("(vbsz.|vbsc.|vbsaa|vbsxx|vbsyy)=(vbsz.|vbsc.|vbsaa|vbsxx|vbsyy)_(plus|band|bxor|bor)_(vbsz.|csoby.|vbsaa|vbsxx|vbsyy)", null, null, "$1=$2_$3_$4", null, mapSToU));
      synths.add(new AsmFragmentTemplateSynthesisRule("(vbsz.|vbsc.|vbsaa|vbsxx|vbsyy)=_(inc|dec)_(vbsz.|vbsc.|vbsaa|vbsxx|vbsyy)", null, null, "$1=_$2_$3", null, mapSToU));
      synths.add(new AsmFragmentTemplateSynthesisRule("(vwsz.|vwsc.)_(eq|neq)_(vwsz.|vwsc.)_then_(.*)", null, null, "$1_$2_$3_then_$4", null, mapSToU));
      synths.add(new AsmFragmentTemplateSynthesisRule("(vwsz.)=(vwsz.|vwsc.)", null, null, "$1=$2", null, mapSToU));
      synths.add(new AsmFragmentTemplateSynthesisRule("(v.sz.)=(v.s..)_(band|bxor|bor)_(v.s..)", null, null, "$1=$2_$3_$4", null, mapSToU));
      synths.add(new AsmFragmentTemplateSynthesisRule("(vbuz.|vbuaa|vbuxx|vbuyy)=_(lo|hi)_vws(z.|c.)", null, null, "$1=_$2_vwu$3", null, mapSToU));

      // Use constant word ASM to synthesize unsigned constant byte ASM ( ...vb.c... -> vw.c... )
      synths.add(new AsmFragmentTemplateSynthesisRule("(vwuz.)=(vwuz.)_(plus|minus|band|bxor|bor)_vb.c(.)", null, null, "$1=$2_$3_vwuc$4", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(vwuz.)=vb.c(.)_(plus|minus|band|bxor|bor)_(vwuz.)", null, null, "$1=vwuc$2_$3_$4", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(vwsz.)=(vwsz.)_(plus|minus|band|bxor|bor)_vb.c(.)", null, null, "$1=$2_$3_vwsc$4", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(vwsz.)=vb.c(.)_(plus|minus|band|bxor|bor)_(vwsz.)", null, null, "$1=vwsc$2_$3_$4", null, null));

      // Move constant words to the end of the ASM signature for symmetric operators ( ...vw.c...vw.z... -> ...vw.z...vw.c... )
      //synths.add(new AsmFragmentTemplateSynthesisRule("(vwuz.)=(vwuc.)_(plus|band|bxor|bor)_(vwuz.)", null, null, "$1=$4_$3_$2", null, null));
      //synths.add(new AsmFragmentTemplateSynthesisRule("(vwsz.)=(vwsc.)_(plus|band|bxor|bor)_(vwsz.)", null, null, "$1=$4_$3_$2", null, null));

      // Use Z1/Z2 ASM to synthesize Z1-only code ( ...z1...z1... -> ...z1...z2... )
      synths.add(new AsmFragmentTemplateSynthesisRule("(v..)z1=(v..)z1_(plus|minus|band|bxor|bor)_(.*)", ".*z2.*", null, "$1z1=$2z2_$3_$4", null, mapZ, false));
      synths.add(new AsmFragmentTemplateSynthesisRule("(v..)z1=(.*)_(plus|minus|band|bxor|bor)_(v..)z1", ".*z2.*", null, "$1z1=$2_$3_$4z2", null, mapZ, false));
      synths.add(new AsmFragmentTemplateSynthesisRule("(v..)z1=_(neg|lo|hi)_(v..)z1", ".*z2.*", null, "$1z1=_$2_$3z2", null, mapZ, false));

      // Convert INC/DEC to +1/-1 ( ..._inc_xxx... -> ...xxx_plus_1_... / ..._dec_xxx... -> ...xxx_minus_1_... )
      synths.add(new AsmFragmentTemplateSynthesisRule("vb(.)aa=_inc_(.*)", null, null, "vb$1aa=$2_plus_1", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("vb(.)aa=_dec_(.*)", null, null, "vb$1aa=$2_minus_1", null, null));

      // Synthesize XX/YY using AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)vbuxx(.*)", ".*=.*aa.*|.*derefidx_vb.xx.*", "txa", "$1=$2vbuaa$3", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)vbsxx(.*)", ".*=.*aa.*|.*derefidx_vb.xx.*", "txa", "$1=$2vbsaa$3", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)vbuyy(.*)", ".*=.*aa.*|.*derefidx_vb.yy.*", "tya", "$1=$2vbuaa$3", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)vbsyy(.*)", ".*=.*aa.*|.*derefidx_vb.yy.*", "tya", "$1=$2vbsaa$3", null, null));

      // Synthesize constants using AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)vbuc1(.*)", ".*=.*aa.*|.*c1.*c1.*|.*c1_deref.*", "lda #{c1}", "$1=$2vbuaa$3", null, mapC));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)vbsc1(.*)", ".*=.*aa.*|.*c1.*c1.*|.*c1_deref.*", "lda #{c1}", "$1=$2vbsaa$3", null, mapC));

      // Synthesize some constant pointers as constant words
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_(lt|gt|le|ge|eq|neq)_p..([cz].)_then_(.*)", null, null, "$1_$2_vwu$3_then_$4", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("p..([cz].)_(lt|gt|le|ge|eq|neq)_(.*)", null, null, "vwu$1_$2_$3", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=p..([zc].)", null, null, "$1=vwu$2", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)_(plus|minus|bor|bxor)_p..([cz].)", null, null, "$1=$2_$3_vwu$4", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=p..([cz].)_(plus|minus|bor|bxor)_(.*)", null, null, "$1=vwu$2_$3_$4", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("p..([cz].)=(.*)_(sethi|setlo|plus|minus)_(.*)", null, null, "vwu$1=$2_$3_$4", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=p..([cz].)_(sethi|setlo|plus|minus)_(.*)", null, null, "$1=vwu$2_$3_$4", null, null));

      return synths;
   }

}

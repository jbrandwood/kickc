package dk.camelot64.kickc.fragment;

import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/** AsmFragment synthesis mechanism based on matching fragment signature and reusing another fragment with added prefix/postfix and some bind-mappings */
class AsmFragmentTemplateSynthesisRule {

   /** Regular expression that matches the signature of fragments that the synthesis rule can handle.
    * Contains matching groups (parenthesis) that are used in sigReplace to build the signature of the sub-fragment to synthesize from. */
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
      if (sigMatchPattern == null)
         sigMatchPattern = Pattern.compile(sigMatch);
      Matcher m = sigMatchPattern.matcher(signature);
      if (m.matches()) {
         if (sigAvoid == null)
            return true;
         else {
            if (sigAvoidPattern == null)
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
      if(newFragment.length()>0 && newFragment.charAt(newFragment.length()-1)=='\n') {
         newFragment = new StringBuilder(newFragment.substring(0, newFragment.length()-1));
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
      mapZ.put("z4", "z3");
      Map<String, String> mapZ2 = new LinkedHashMap<>();
      mapZ2.put("z3", "z1");
      Map<String, String> mapZ3 = new LinkedHashMap<>();
      mapZ3.put("z3", "z2");
      Map<String, String> mapZ4 = new LinkedHashMap<>();
      mapZ3.put("z4", "z3");
      Map<String, String> mapC = new LinkedHashMap<>();
      mapC.put("c2", "c1");
      mapC.put("c3", "c2");
      mapC.put("c4", "c3");
      Map<String, String> mapC3 = new LinkedHashMap<>();
      mapC3.put("c3", "c2");
      mapC3.put("c4", "c3");
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
      mapSToU.put("vdsz1", "vduz1");
      mapSToU.put("vdsz2", "vduz2");
      mapSToU.put("vdsz3", "vduz3");
      mapSToU.put("vdsc1", "vduc1");
      mapSToU.put("vdsc2", "vduc2");
      mapSToU.put("vdsc3", "vduc3");
      mapSToU.put("pbsz1", "pbuz1");
      mapSToU.put("pbsz2", "pbuz2");
      mapSToU.put("pbsz3", "pbuz3");
      mapSToU.put("pbsc1", "pbuc1");
      mapSToU.put("pbsc2", "pbuc2");
      mapSToU.put("pbsc3", "pbuc3");
      mapSToU.put("pwsz1", "pwuz1");
      mapSToU.put("pwsz2", "pwuz2");
      mapSToU.put("pwsz3", "pwuz3");
      mapSToU.put("pwsc1", "pwuc1");
      mapSToU.put("pwsc2", "pwuc2");
      mapSToU.put("pwsc3", "pwuc3");
      Map<String, String> mapZ2Swap = new LinkedHashMap<>();
      mapZ2Swap.put("z2", "zn");
      mapZ2Swap.put("z1", "z2");
      mapZ2Swap.put("zn", "z1");
      Map<String, String> mapZ3Swap = new LinkedHashMap<>();
      mapZ3Swap.put("z3", "zn");
      mapZ3Swap.put("z2", "z3");
      mapZ3Swap.put("zn", "z2");

      // AA/XX/YY/Z1 is an RValue
      String rvalAa = ".*=.*aa.*|.*_.*aa.*|...aa_(lt|gt|le|ge|eq|neq)_.*";
      String rvalXx = ".*=.*xx.*|.*_.*xx.*|...xx_(lt|gt|le|ge|eq|neq)_.*";
      String rvalYy = ".*=.*yy.*|.*_.*yy.*|...yy_(lt|gt|le|ge|eq|neq)_.*";
      String rvalZ1 = ".*=.*z1.*|.*_.*z1.*|...z1_(lt|gt|le|ge|eq|neq)_.*";
      String rvalZ2 = ".*=.*z2.*|.*_.*z2.*|...z2_(lt|gt|le|ge|eq|neq)_.*";
      String lvalC1 = ".*c1.*=.*";
      String lvalC2 = ".*c2.*=.*";
      String lvalDerefZ1 = ".*_deref_...z1=.*";
      String lvalDerefC1 = ".*_deref_...c1=.*";
      String lvalDerefIdxAa = ".*_derefidx_...aa=.*";
      String lvalDerefIdxZ1 = ".*_derefidx_...z1=.*";
      String lvalDerefIdxZ2 = ".*_derefidx_...z2=.*";
      // AA/XX/YY/Z1 is an LValue
      String lvalAa = "...aa=.*";
      String lvalXx = "...xx=.*";
      String lvalYy = "...yy=.*";
      String lvalZ1 = "...z1=.*";
      String lvalZ2 = "...z2=.*";
      String lvalZ3 = "...z3=.*";
      // Multiple occurences of Z1/...
      String twoZ1 = ".*z1.*z1.*";
      String twoZ2 = ".*z2.*z2.*";
      String twoZ3 = ".*z3.*z3.*";
      String twoC1 = ".*c1.*c1.*";
      String twoC2 = ".*c2.*c2.*";
      String threeZ1 = ".*z1.*z1.*z1.*";
      String threeZ2 = ".*z2.*z2.*z2.*";
      String threeAa = ".*aa.*aa.*aa.*";

      // Presence of unwanted single symbols
      String oneZ2 = ".*z2.*";
      String derefC1 = ".*c1_deref.*";

      List<AsmFragmentTemplateSynthesisRule> synths = new ArrayList<>();

      // NEW STYLE REWRITES - Utilizes that all combinations are tried

      // Replace first AA with XX
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)aa(.*)", lvalAa+"|"+rvalXx, "tax", "$1xx$2", null, null));
      // Replace two AAs with XX
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)aa(.*vb.)aa(.*)", lvalAa+"|"+rvalXx, "tax", "$1xx$2xx$3", null, null));
      // Replace second (not first) AA with XX
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)aa(.*vb.)aa(.*)", lvalAa+"|"+rvalXx, "tax", "$1aa$2xx$3", null, null));
      // Replace two AAs with XX (not assigned)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*vb.)aa(.*vb.)aa(.*)", rvalXx, "tax", "$1=$2xx$3xx$4", null, null));

      // Replace first AA with YY
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)aa(.*)", lvalAa+"|"+rvalYy, "tay", "$1yy$2", null, null));
      // Replace second (not first) AA with YY
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)aa(.*vb.)aa(.*)", lvalAa+"|"+rvalYy, "tay", "$1aa$2yy$3", null, null));
      // Replace two AAs with YY
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)aa(.*vb.)aa(.*)", lvalAa+"|"+rvalYy, "tay", "$1yy$2yy$3", null, null));
      // Replace two AAs with YY (not assigned)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*vb.)aa(.*vb.)aa(.*)", rvalYy, "tay", "$1=$2yy$3yy$4", null, null));

      // Replace first XX with AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)xx(.*)", lvalXx+"|"+rvalAa, "txa", "$1aa$2", null, null));
      // Replace two XXs with AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)xx(.*vb.)xx(.*)", lvalXx+"|"+rvalAa, "txa", "$1aa$2aa$3", null, null));
      // Replace second (not first) XX with AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)xx(.*vb.)xx(.*)", lvalXx+"|"+rvalAa, "txa", "$1xx$2aa$3", null, null));
      // Replace two XXs with AA (not assigned)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*vb.)xx(.*vb.)xx(.*)", rvalAa, "txa", "$1=$2aa$3aa$4", null, null));

      // Replace first YY with AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)yy(.*)", lvalYy+"|"+rvalAa, "tya", "$1aa$2", null, null));
      // Replace two YYs with AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)yy(.*vb.)yy(.*)", lvalYy+"|"+rvalAa, "tya", "$1aa$2aa$3", null, null));
      // Replace second (not first) YY with AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)yy(.*vb.)yy(.*)", lvalYy+"|"+rvalAa, "tya", "$1yy$2aa$3", null, null));
      // Replace two YYs with AA (not assigned)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*vb.)yy(.*vb.)yy(.*)", rvalAa, "tya", "$1=$2aa$3aa$4", null, null));

      // Replace Z1 with AA (only one)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)z1(.*)", lvalZ1+"|"+rvalAa+"|"+ twoZ1, "lda {z1}", "$1aa$2", null, mapZ));
      // Replace two Z1s with AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)z1(.*vb.)z1(.*)", lvalZ1+"|"+rvalAa+"|"+ threeZ1, "lda {z1}", "$1aa$2aa$3", null, mapZ));
      // Replace first (not second) Z1 with AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)z1(.*)z1(.*)", lvalZ1+"|"+rvalAa, "lda {z1}", "$1aa$2z1$3", null, null));
      // Replace second (not first) Z1 with AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)z1(.*vb.)z1(.*)", lvalZ1+"|"+rvalAa, "lda {z1}", "$1z1$2aa$3", null, null));
      // Replace non-assigned Z1 with AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(...aa)=(.*vb.)z1(.*)", rvalAa+"|"+ twoZ1, "lda {z1}", "$1=$2aa$3", null, mapZ));
      // Replace assigned Z1 with AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(vb.)z1=(.*)", twoZ1, null, "$1aa=$2", "sta {z1}", mapZ));

      // Replace Z1 with YY (only one)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)z1(.*)", lvalZ1+"|"+rvalYy+"|"+twoZ1, "ldy {z1}", "$1yy$2", null, mapZ));
      // Replace two Z1s with YY
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)z1(.*vb.)z1(.*)", lvalZ1+"|"+rvalYy+"|"+threeZ1, "ldy {z1}", "$1yy$2yy$3", null, mapZ));
      // Replace first (not second) Z1 with YY
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)z1(.*)z1(.*)", lvalZ1+"|"+rvalYy, "ldy {z1}", "$1yy$2z1$3", null, null));
      // Replace second (not first) Z1 with YY
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)z1(.*vb.)z1(.*)", lvalZ1+"|"+rvalYy, "ldy {z1}", "$1z1$2yy$3", null, null));
      // Replace non-assigned Z1 with YY
      synths.add(new AsmFragmentTemplateSynthesisRule("(...yy)=(.*vb.)z1(.*)", twoZ1+"|"+rvalYy, "ldy {z1}", "$1=$2yy$3", null, mapZ));
      // Replace assigned Z1 with YY
      synths.add(new AsmFragmentTemplateSynthesisRule("(vb.)z1=(.*)", twoZ1, null, "$1yy=$2", "sty {z1}", mapZ));

      // Replace Z1 with XX (only one)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)z1(.*)", lvalZ1+"|"+rvalXx+"|"+twoZ1, "ldx {z1}", "$1xx$2", null, mapZ));
      // Replace two Z1s with XX
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)z1(.*vb.)z1(.*)", lvalZ1+"|"+rvalXx+"|"+threeZ1, "ldx {z1}", "$1xx$2xx$3", null, mapZ));
      // Replace first (not second) Z1 with XX
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)z1(.*)z1(.*)", lvalZ1+"|"+rvalXx, "ldx {z1}", "$1xx$2z1$3", null, null));
      // Replace second (not first) Z1 with XX
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)z1(.*vb.)z1(.*)", lvalZ1+"|"+rvalXx, "ldx {z1}", "$1z1$2xx$3", null, null));
      // Replace non-assigned Z1 with XX
      synths.add(new AsmFragmentTemplateSynthesisRule("(...xx)=(.*vb.)z1(.*)", twoZ1+"|"+rvalXx, "ldx {z1}", "$1=$2xx$3", null, mapZ));
      // Replace assigned Z1 with XX
      synths.add(new AsmFragmentTemplateSynthesisRule("(vb.)z1=(.*)", twoZ1, null, "$1xx=$2", "stx {z1}", mapZ));

      // Replace Z2 with AA (only one)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)z2(.*)", lvalZ2+"|"+rvalAa+"|"+twoZ2, "lda {z2}", "$1aa$2", null, mapZ3));
      // Replace two Z2s with AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)z2(.*vb.)z2(.*)", lvalZ2+"|"+rvalAa+"|"+threeZ2, "lda {z2}", "$1aa$2aa$3", null, mapZ3));
      // Replace first (of 2) Z2 with AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)z2(.*)z2(.*)", lvalZ2+"|"+rvalAa, "lda {z2}", "$1aa$2z2$3", null, null));
      // Replace second (of 2) Z2 with AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)z2(.*vb.)z2(.*)", lvalZ2+"|"+rvalAa, "lda {z2}", "$1z2$2aa$3", null, null));

      // Replace Z2 with YY (only one)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)z2(.*)", lvalZ2+"|"+rvalYy+"|"+twoZ2, "ldy {z2}", "$1yy$2", null, mapZ3));
      // Replace two Z2s with YY
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)z2(.*vb.)z2(.*)", lvalZ2+"|"+rvalYy+"|"+threeZ2, "ldy {z2}", "$1yy$2yy$3", null, mapZ3));
      // Replace first (of 2) Z2 with YY
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)z2(.*)z2(.*)", lvalZ2+"|"+rvalYy, "ldy {z2}", "$1yy$2z2$3", null, null));
      // Replace second (of 2) Z2 with YY
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)z2(.*vb.)z2(.*)", lvalZ2+"|"+rvalYy, "ldy {z2}", "$1z2$2yy$3", null, null));

      // Replace Z2 with XX(only one)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)z2(.*)", lvalZ2+"|"+rvalXx+"|"+twoZ2, "ldx {z2}", "$1xx$2", null, mapZ3));
      // Replace two Z2s with XX
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)z2(.*vb.)z2(.*)", lvalZ2+"|"+rvalXx+"|"+threeZ2, "ldx {z2}", "$1xx$2xx$3", null, mapZ3));
      // Replace first (of 2) Z2 with XX
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)z2(.*)z2(.*)", lvalZ2+"|"+rvalXx, "ldx {z2}", "$1xx$2z2$3", null, null));
      // Replace second (of 2) Z2 with XX
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)z2(.*vb.)z2(.*)", lvalZ2+"|"+rvalXx, "ldx {z2}", "$1z2$2xx$3", null, null));

      // Replace Z3 with AA (only one)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)z3(.*)", lvalZ3+"|"+twoZ3+"|"+rvalAa, "lda {z3}", "$1aa$2", null, mapZ4));
      // Replace Z3 with YY (only one)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)z3(.*)", lvalZ3+"|"+twoZ3+"|"+rvalYy, "ldy {z3}", "$1yy$2", null, mapZ4));
      // Replace Z3 with XX (only one)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)z3(.*)", lvalZ3+"|"+twoZ3+"|"+rvalXx, "ldx {z3}", "$1xx$2", null, mapZ4));

      // Correct wrong ordered Z2/Z1
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)z2(.*)z1(.*)", twoZ1+"|"+twoZ2, null, "$1z1$2z2$3", null, mapZ2Swap, false));
      // Correct wrong ordered Z3/Z2
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)z3(.*)z2(.*)", twoZ2+"|"+twoZ3, null, "$1z2$2z3$3", null, mapZ3Swap, false));

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
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)_(band|bor|bxor|plus|and|or)_(.*)", null, null, "$1=$4_$3_$2", null, null));
      // Swap parameters on commutative comparators
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_(eq|neq)_(.*)_then_(.*)", null, null, "$3_$2_$1_then_$4", null, null));

      // Rewrite Assignments to X from A
      synths.add(new AsmFragmentTemplateSynthesisRule("vb(.)xx=(.*)", null, null, "vb$1aa=$2", "tax", null));
      // Rewrite Assignments to Y from A
      synths.add(new AsmFragmentTemplateSynthesisRule("vb(.)yy=(.*)", null, null, "vb$1aa=$2", "tay", null));
      // Rewrite Assignments to Z1 from A
      synths.add(new AsmFragmentTemplateSynthesisRule("vb(.)z1=(.*)", twoZ1, null, "vb$1aa=$2", "sta {z1}", mapZ));
      // Rewrite Assignments to Z1 from A
      synths.add(new AsmFragmentTemplateSynthesisRule("vb(.)z1=(.*z1.*)", null, null, "vb$1aa=$2", "sta {z1}", null));
      // Rewrite Assignments to *C1 from A
      synths.add(new AsmFragmentTemplateSynthesisRule("_deref_pb(.)c1=(.*)", null, null, "vb$1aa=$2", "sta {c1}", null));
      // Rewrite Assignments to *Z1 from A
      synths.add(new AsmFragmentTemplateSynthesisRule("_deref_pb(.)z1=(.*)", twoZ1, null, "vb$1aa=$2", "ldy #0\n" + "sta ({z1}),y", mapZ));
      // Rewrite Assignments to *Z1 from A
      synths.add(new AsmFragmentTemplateSynthesisRule("_deref_pb(.)z1=(.*z1.*)", null, null, "vb$1aa=$2", "ldy #0\n" + "sta ({z1}),y", null));

      // Rewrite _deref_pb.z1_ to _vb.aa_ (if no other Z1s)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_deref_pb(.)z1(.*)", twoZ1+"|"+rvalAa+"|"+rvalYy+"|"+ lvalDerefZ1, "ldy #0\n"+"lda ({z1}),y", "$1vb$2aa$3", null, mapZ));
      // Rewrite _deref_pb.z1_ to _vb.aa_ (if other Z1)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*z1.*)_deref_pb(.)z1(.*)", rvalAa+"|"+rvalYy+"|"+lvalDerefZ1, "ldy #0\n"+"lda ({z1}),y", "$1vb$2aa$3", null, null));
      // Rewrite _deref_pb.z1_ to _vb.aa_ (if other Z1)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_deref_pb(.)z1(.*z1.*)", rvalAa+"|"+rvalYy+"|"+ lvalDerefZ1, "ldy #0\n"+"lda ({z1}),y", "$1vb$2aa$3", null, null));

      // Replace VB*C1 with AA (only one)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)vb(.)c1(.*)", lvalC1+"|"+rvalAa, "lda #{c1}", "$1vb$2aa$3", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)vb(.)c1(.*)_then_(.*)", rvalAa, "lda #{c1}", "$1vb$2aa$3_then_$4", null, null));
      // Replace VB*C1 with XX (only one)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)vb(.)c1(.*)", lvalC1+"|"+rvalXx, "ldx #{c1}", "$1vb$2xx$3", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)vb(.)c1(.*)_then_(.*)", rvalXx, "ldx #{c1}", "$1vb$2xx$3_then_$4", null, null));
      // Replace VB*C1 with XX (only one)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)vb(.)c1(.*)", lvalC1+"|"+rvalYy, "ldy #{c1}", "$1vb$2yy$3", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)vb(.)c1(.*)_then_(.*)", rvalYy, "ldy #{c1}", "$1vb$2yy$3_then_$4", null, null));
      // Replace VB*C2 with AA (only one)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)vb(.)c2(.*)", lvalC2+"|"+rvalAa, "lda #{c2}", "$1vb$2aa$3", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)vb(.)c2(.*)_then_(.*)", rvalAa, "lda #{c2}", "$1vb$2aa$3_then_$4", null, null));
      // Replace VB*C2 with XX (only one)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)vb(.)c2(.*)", lvalC2+"|"+rvalXx, "ldx #{c2}", "$1vb$2xx$3", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)vb(.)c2(.*)_then_(.*)", rvalXx, "ldx #{c2}", "$1vb$2xx$3_then_$4", null, null));
      // Replace VB*C2 with YY (only one)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)vb(.)c2(.*)", lvalC2+"|"+rvalYy, "ldy #{c2}", "$1vb$2yy$3", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)vb(.)c2(.*)_then_(.*)", rvalYy, "ldy #{c2}", "$1vb$2yy$3_then_$4", null, null));

      // Rewrite *C1 to AA (if no other C1s)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_deref_pb(.)c1(.*)", rvalAa+"|"+lvalDerefC1, "lda {c1}", "$1vb$2aa$3", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_deref_pb(.)c1(.*)", rvalXx+"|"+lvalDerefC1, "ldx {c1}", "$1vb$2xx$3", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_deref_pb(.)c1(.*)", rvalYy+"|"+lvalDerefC1, "ldy {c1}", "$1vb$2yy$3", null, null));
      // Rewrite (Z1),y to AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)pb(.)z1_derefidx_vbuyy(.*)_then_(.*)", twoZ1+"|"+rvalAa, "lda ({z1}),y\n" , "$1vb$2aa$3_then_$4", null, mapZ));

      // Rewrite left-size C1,y to use AA and a STA C1,y
      synths.add(new AsmFragmentTemplateSynthesisRule("pb(.)c1_derefidx_vbuyy=(.*)", null, null, "vb$1aa=$2", "sta {c1},y", null, "yy"));
      // Rewrite C1,y to save and reload YY from $FF
      synths.add(new AsmFragmentTemplateSynthesisRule("pb(.)c1_derefidx_vbuyy=(.*)", null, "sty $ff\n" , "vb$1aa=$2", "ldy $ff\nsta {c1},y", null));
      // Rewrite (Z1),y to save and reload YY from $FF
      synths.add(new AsmFragmentTemplateSynthesisRule("pb(.)z1_derefidx_vbuyy=(.*)", twoZ1, "sty $ff\n" , "vb$1aa=$2", "ldy $ff\nsta ({z1}),y", mapZ));

      // Rewrite left-size C1,x to use AA and a STA C1,x
      synths.add(new AsmFragmentTemplateSynthesisRule("pb(.)c1_derefidx_vbuxx=(.*)", null, null, "vb$1aa=$2", "sta {c1},x", null, "xx"));
      // Rewrite C1,x to save and reload XX from $FF
      synths.add(new AsmFragmentTemplateSynthesisRule("pb(.)c1_derefidx_vbuxx=(.*)", null, "stx $ff\n" , "vb$1aa=$2", "ldx $ff\nsta {c1},x", null));
      // Rewrite (Z1),x to save Y to $FF and reload it into YY
      synths.add(new AsmFragmentTemplateSynthesisRule("pb(.)z1_derefidx_vbuxx=(.*)", twoZ1, "stx $ff" , "vb$1aa=$2", "ldy $ff\nsta ({z1}),y", mapZ));

      // Rewrite (Z1),a to use TAY prefix
      synths.add(new AsmFragmentTemplateSynthesisRule("pb(.)z1_derefidx_vbuaa=(.*)", twoZ1+"|"+rvalYy, "tay" , "vb$1aa=$2", "sta ({z1}),y", mapZ, "yy"));
      // Rewrite (Z1),a to save A to $FF and reload it into YY
      synths.add(new AsmFragmentTemplateSynthesisRule("pb(.)z1_derefidx_vbuaa=(.*)", twoZ1, "sta $ff" , "vb$1aa=$2", "ldy $ff\nsta ({z1}),y", mapZ));

      // Synthesize some constant pointers as constant words (remove when the above section can be included)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_(lt|gt|le|ge|eq|neq)_p..([cz].)_then_(.*)", null, null, "$1_$2_vwu$3_then_$4", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("p..([cz].)_(lt|gt|le|ge|eq|neq)_(.*)", null, null, "vwu$1_$2_$3", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=p..([zc].)", null, null, "$1=vwu$2", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)_(plus|minus|bor|bxor)_p..([cz].)", null, null, "$1=$2_$3_vwu$4", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=p..([cz].)_(plus|minus|bor|bxor)_(.*)", null, null, "$1=vwu$2_$3_$4", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("p..([cz].)=(.*)_(sethi|setlo|plus|minus)_(.*)", null, null, "vwu$1=$2_$3_$4", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=p..([cz].)_(sethi|setlo|plus|minus)_(.*)", null, null, "$1=vwu$2_$3_$4", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("p..([cz].)=_(inc|dec)_p..([cz].)", null, null, "vwu$1=_$2_vwu$3", null, null));

      // Synthesize constants using AA/XX/YY
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)vbuc1(.*)", rvalAa+"|"+"|"+ derefC1, "lda #{c1}", "$1=$2vbuaa$3", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)vbsc1(.*)", rvalAa+"|"+"|"+ derefC1, "lda #{c1}", "$1=$2vbsaa$3", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)vbuc1(.*)", rvalYy+"|"+"|"+ derefC1, "ldy #{c1}", "$1=$2vbuyy$3", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)vbsc1(.*)", rvalYy+"|"+"|"+ derefC1, "ldy #{c1}", "$1=$2vbsyy$3", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)vbuc1(.*)", rvalXx+"|"+"|"+ derefC1, "ldx #{c1}", "$1=$2vbuxx$3", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)vbsc1(.*)", rvalXx+"|"+"|"+ derefC1, "ldx #{c1}", "$1=$2vbsxx$3", null, null));

      // Rewrite any signed dereference (.*_derefidx_vbs.*) to unsigned (.*_derefidx_vbu.*)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_derefidx_vbs(.*)", null, null, "$1_derefidx_vbu$2", null, null));

      // If no C1 is present in the signature map other Cs down to take its place
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*c2.*)", ".*c1.*", null, "$1", null, mapC));
      // If no C2 is present in the signature map other Cs down to take its place
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*c3.*)", ".*c2.*", null, "$1", null, mapC3));

      // OLD STYLE REWRITES - written when only one rule could be taken

      synths.add(new AsmFragmentTemplateSynthesisRule("pb(.)c1_derefidx_vbuz1=(.*)", twoZ1+"|"+twoC1, null, "vb$1aa=$2", "ldx {z1}\n" + "sta {c1},x", mapZC));
      synths.add(new AsmFragmentTemplateSynthesisRule("pb(.)z1_derefidx_vbuz2=(.*)", twoZ1+"|"+twoZ2, null, "vb$1aa=$2", "ldy {z2}\n" + "sta ({z1}),y", mapZ2));

      // Convert array indexing with A register to X/Y register by prefixing tax/tay (..._derefidx_vbuaa... -> ..._derefidx_vbuxx... /... _derefidx_vbuyy... )
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)_derefidx_vbuaa(.*)", rvalXx, "tax", "$1=$2_derefidx_vbuxx$3", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)_derefidx_vbuaa(.*)", rvalYy, "tay", "$1=$2_derefidx_vbuyy$3", null, null));

      // Convert array indexing with zero page to x/y register by prefixing ldx z1 / ldy z1 ( ..._derefidx_vbuzn... -> ..._derefidx_vbuxx... / ..._derefidx_vbuyy... )
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)_derefidx_vbuz1(.*)", rvalXx+"|"+twoZ1, "ldx {z1}", "$1=$2_derefidx_vbuxx$3", null, mapZ));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)_derefidx_vbuz1(.*)", rvalYy+"|"+twoZ1, "ldy {z1}", "$1=$2_derefidx_vbuyy$3", null, mapZ));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)_derefidx_vbuz2(.*)", rvalXx+"|"+twoZ2, "ldx {z2}", "$1=$2_derefidx_vbuxx$3", null, mapZ3));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)_derefidx_vbuz2(.*)", rvalYy+"|"+twoZ2, "ldy {z2}", "$1=$2_derefidx_vbuyy$3", null, mapZ3));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)_derefidx_vbuz3(.*)", rvalYy, "ldy {z3}", "$1=$2_derefidx_vbuyy$3", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)_derefidx_vbuz3(.*)", rvalXx, "ldx {z3}", "$1=$2_derefidx_vbuxx$3", null, null));

      // Convert array indexing twice with A/zp1/zp2 to X/Y register with a ldx/ldy prefix ( ..._derefidx_vbunn..._derefidx_vbunn... -> ..._derefidx_vbuxx..._derefidx_vbuxx... )
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_derefidx_vbuaa(.*)_derefidx_vbuaa(.*)", threeAa+"|"+rvalXx+"|"+lvalDerefIdxAa, "tax", "$1_derefidx_vbuxx$2_derefidx_vbuxx$3", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_derefidx_vbuaa(.*)_derefidx_vbuaa(.*)", threeAa+"|"+rvalYy+"|"+lvalDerefIdxAa, "tay", "$1_derefidx_vbuyy$2_derefidx_vbuyy$3", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_derefidx_vbuz1(.*)_derefidx_vbuz1(.*)", threeZ1+"|"+rvalXx+"|"+lvalDerefIdxZ1, "ldx {z1}", "$1_derefidx_vbuxx$2_derefidx_vbuxx$3", null, mapZ));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_derefidx_vbuz1(.*)_derefidx_vbuz1(.*)", threeZ1+"|"+rvalYy+"|"+lvalDerefIdxZ1, "ldy {z1}", "$1_derefidx_vbuyy$2_derefidx_vbuyy$3", null, mapZ));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_derefidx_vbuz2(.*)_derefidx_vbuz2(.*)", threeZ2+"|"+rvalXx+"|"+lvalDerefIdxZ2, "ldx {z2}", "$1_derefidx_vbuxx$2_derefidx_vbuxx$3", null, mapZ));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_derefidx_vbuz2(.*)_derefidx_vbuz2(.*)", threeZ2+"|"+rvalYy+"|"+lvalDerefIdxZ2, "ldy {z2}", "$1_derefidx_vbuyy$2_derefidx_vbuyy$3", null, mapZ));
      
      synths.add(new AsmFragmentTemplateSynthesisRule("pb(.)c1_derefidx_vbuz1=(.*c1.*)", twoZ1, null, "vb$1aa=$2", "ldx {z1}\n" + "sta {c1},x", mapZ));
      synths.add(new AsmFragmentTemplateSynthesisRule("pb(.)c1_derefidx_vbuz1=(.*z1.*)", twoC1, null, "vb$1aa=$2", "ldx {z1}\n" + "sta {c1},x", mapC));

      // Convert X/Y-based array indexing of a constant pointer into A-register by prefixing lda cn,x / lda cn,y ( ...pb.c1_derefidx_vbuxx... / ...pb.c1_derefidx_vbuyy... -> ...vb.aa... )


      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)pb(.)c1_derefidx_vbuxx(.*)", rvalAa+"|"+twoC1, "lda {c1},x", "$1=$2vb$3aa$4", null, mapC));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)pb(.)c1_derefidx_vbuxx(.*)", rvalYy+"|"+twoC1, "ldy {c1},x", "$1=$2vb$3yy$4", null, mapC));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*c1.*)pb(.)c1_derefidx_vbuxx(.*)", rvalAa, "lda {c1},x", "$1=$2vb$3aa$4", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)pb(.)c1_derefidx_vbuxx(.*c1.*)", rvalAa, "lda {c1},x", "$1=$2vb$3aa$4", null, null));

      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)pb(.)c1_derefidx_vbuyy(.*)", rvalAa+"|"+twoC1, "lda {c1},y", "$1=$2vb$3aa$4", null, mapC));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)pb(.)c1_derefidx_vbuyy(.*)", rvalXx+"|"+twoC1, "ldx {c1},y", "$1=$2vb$3xx$4", null, mapC));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*c1.*)pb(.)c1_derefidx_vbuyy(.*)", rvalAa, "lda {c1},y", "$1=$2vb$3aa$4", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)pb(.)c1_derefidx_vbuyy(.*c1.*)", rvalAa, "lda {c1},y", "$1=$2vb$3aa$4", null, null));

      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)pb(.)c2_derefidx_vbuxx(.*)", rvalAa+"|"+twoC2, "lda {c2},x", "$1=$2vb$3aa$4", null, mapC3));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)pb(.)c2_derefidx_vbuxx(.*)", rvalYy+"|"+twoC2, "ldy {c2},x", "$1=$2vb$3yy$4", null, mapC3));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*c2.*)pb(.)c2_derefidx_vbuxx(.*)", rvalAa, "lda {c2},x", "$1=$2vb$3aa$4", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)pb(.)c2_derefidx_vbuxx(.*c2.*)", rvalAa, "lda {c2},x", "$1=$2vb$3aa$4", null, null));

      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)pb(.)c2_derefidx_vbuyy(.*)", rvalAa+"|"+twoC2, "lda {c2},y", "$1=$2vb$3aa$4", null, mapC3));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)pb(.)c2_derefidx_vbuyy(.*)", rvalXx+"|"+twoC2, "ldx {c2},y", "$1=$2vb$3xx$4", null, mapC3));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*c2.*)pb(.)c2_derefidx_vbuyy(.*)", rvalAa, "lda {c2},y", "$1=$2vb$3aa$4", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)pb(.)c2_derefidx_vbuyy(.*c2.*)", rvalAa, "lda {c2},y", "$1=$2vb$3aa$4", null, null));

      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_derefidx_vbuz1_(.*)", rvalYy+"|"+twoZ1, "ldy {z1}", "$1_derefidx_vbuyy_$2", null, mapZ));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_derefidx_vbuz1_(lt|gt|le|ge|eq|neq)_(.*)", rvalXx+"|"+twoZ1, "ldx {z1}", "$1_derefidx_vbuxx_$2_$3", null, mapZ));
      synths.add(new AsmFragmentTemplateSynthesisRule("pb(.)c1_derefidx_vbuyy_(lt|gt|le|ge|eq|neq)_(.*)", rvalAa+"|"+twoC1, "lda {c1},y", "vb$1aa_$2_$3", null, mapC));
      synths.add(new AsmFragmentTemplateSynthesisRule("pb(.)c1_derefidx_vbuyy_(lt|gt|le|ge|eq|neq)_(.*c1.*)", rvalAa, "lda {c1},y", "vb$1aa_$2_$3", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("pb(.)c1_derefidx_vbuxx_(lt|gt|le|ge|eq|neq)_(.*)", rvalAa+"|"+twoC1, "lda {c1},x", "vb$1aa_$2_$3", null, mapC));
      synths.add(new AsmFragmentTemplateSynthesisRule("pb(.)c1_derefidx_vbuxx_(lt|gt|le|ge|eq|neq)_(.*c1.*)", rvalAa, "lda {c1},x", "vb$1aa_$2_$3", null, null));

      // Use unsigned ASM to synthesize signed ASM ( ...vbs... -> ...vbu... )
      synths.add(new AsmFragmentTemplateSynthesisRule("(v.s..)_(eq|neq)_(v.s..)_then_(.*)", null, null, "$1_$2_$3_then_$4", null, mapSToU));
      synths.add(new AsmFragmentTemplateSynthesisRule("(v.s..)=(v.s..)", null, null, "$1=$2", null, mapSToU));
      synths.add(new AsmFragmentTemplateSynthesisRule("(v.s..)=(v.s..)_(band|bxor|bor)_(v.s..)", null, null, "$1=$2_$3_$4", null, mapSToU));
      synths.add(new AsmFragmentTemplateSynthesisRule("(v.s..)=(p.s..)_derefidx_(vbu..)", null, null, "$1=$2_derefidx_$3", null, mapSToU));
      synths.add(new AsmFragmentTemplateSynthesisRule("(v.s..)=_(inc|dec)_(v.s..)", null, null, "$1=_$2_$3", null, mapSToU));
      synths.add(new AsmFragmentTemplateSynthesisRule("(vbuz.|vbuaa|vbuxx|vbuyy)=_(lo|hi)_vws(z.|c.)", null, null, "$1=_$2_vwu$3", null, mapSToU));
      synths.add(new AsmFragmentTemplateSynthesisRule("(vbs..)=(vbs..)_(plus|minus)_(vbs..)", null, null, "$1=$2_$3_$4", null, mapSToU));
      synths.add(new AsmFragmentTemplateSynthesisRule("(vws..)=(vws..)_(plus|minus)_(vws..)", null, null, "$1=$2_$3_$4", null, mapSToU));
      synths.add(new AsmFragmentTemplateSynthesisRule("(vds..)=(vds..)_(plus|minus)_(vds..)", null, null, "$1=$2_$3_$4", null, mapSToU));

      // Use Z1/Z2 ASM to synthesize Z1-only code ( ...z1...z1... -> ...z1...z2... )
      synths.add(new AsmFragmentTemplateSynthesisRule("(v..)z1=(v..)z1_(plus|minus|band|bxor|bor)_(.*)", oneZ2, null, "$1z1=$2z2_$3_$4", null, mapZ, false));
      synths.add(new AsmFragmentTemplateSynthesisRule("(v..)z1=(.*)_(plus|minus|band|bxor|bor)_(v..)z1", oneZ2, null, "$1z1=$2_$3_$4z2", null, mapZ, false));
      synths.add(new AsmFragmentTemplateSynthesisRule("(v..)z1=_(neg|lo|hi)_(v..)z1", oneZ2, null, "$1z1=_$2_$3z2", null, mapZ, false));

      //synths.add(new AsmFragmentTemplateSynthesisRule("(v..)z1=(v..)z1_(plus|minus|band|bxor|bor)_(v..)z2", null, null, "$1z1=$2z2_$3_$4z3", null, mapZ, false));

      // Convert INC/DEC to +1/-1 ( ..._inc_xxx... -> ...xxx_plus_1_... / ..._dec_xxx... -> ...xxx_minus_1_... )
      synths.add(new AsmFragmentTemplateSynthesisRule("vb(.)aa=_inc_(.*)", null, null, "vb$1aa=$2_plus_1", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("vb(.)aa=_dec_(.*)", null, null, "vb$1aa=$2_minus_1", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("vw(.)z1=_inc_vw(.z.)", null, null, "vw$1z1=vw$2_plus_1", null, null));


      return synths;
   }

}

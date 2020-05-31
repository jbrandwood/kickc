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

   /** All the synthesize rules available. */
   private static List<AsmFragmentTemplateSynthesisRule> fragmentSyntheses;

   static List<AsmFragmentTemplateSynthesisRule> getSynthesisRules() {
      if(fragmentSyntheses == null) {
         fragmentSyntheses = initFragmentSyntheses();
      }
      return fragmentSyntheses;
   }

   private static List<AsmFragmentTemplateSynthesisRule> initFragmentSyntheses() {
      // Z1 is replaced by something non-ZP - all above are moved down
      Map<String, String> mapZM1 = new LinkedHashMap<>();
      mapZM1.put("z2", "z1");
      mapZM1.put("m2", "m1");
      mapZM1.put("z3", "z2");
      mapZM1.put("m3", "m2");
      mapZM1.put("z4", "z3");
      mapZM1.put("m4", "m3");
      mapZM1.put("z5", "z4");
      mapZM1.put("m5", "m4");
      mapZM1.put("z6", "z5");
      mapZM1.put("m6", "m5");
      // Z2 is replaced by something non-ZP - all above are moved down
      Map<String, String> mapZM2 = new LinkedHashMap<>();
      mapZM2.put("z3", "z2");
      mapZM2.put("m3", "m2");
      mapZM2.put("z4", "z3");
      mapZM2.put("m4", "m3");
      mapZM2.put("z5", "z4");
      mapZM2.put("m5", "m4");
      mapZM2.put("z6", "z5");
      mapZM2.put("m6", "m5");
      // Z3 is replaced by something non-ZP - all above are moved down
      Map<String, String> mapZM3 = new LinkedHashMap<>();
      mapZM3.put("z4", "z3");
      mapZM3.put("m4", "m3");
      mapZM3.put("z5", "z4");
      mapZM3.put("m5", "m4");
      mapZM3.put("z6", "z5");
      mapZM3.put("m6", "m5");
      // Z4 is replaced by something non-ZP - all above are moved down
      Map<String, String> mapZM4 = new LinkedHashMap<>();
      mapZM4.put("z5", "z4");
      mapZM4.put("m5", "m4");
      mapZM4.put("z6", "z5");
      mapZM4.put("m6", "m5");
      // M1 is replaced by something non-mem - all above are moved down
      Map<String, String> mapZ1M1 = new LinkedHashMap<>();
      mapZ1M1.put("z1", "m1");
      Map<String, String> mapZ2M2 = new LinkedHashMap<>();
      mapZ2M2.put("z2", "m2");
      Map<String, String> mapZ3M3 = new LinkedHashMap<>();
      mapZ3M3.put("z3", "m3");
      Map<String, String> mapZ4M4 = new LinkedHashMap<>();
      mapZ4M4.put("z4", "m4");

      // C1 is replaced by something non-C - all above are moved down
      Map<String, String> mapC1 = new LinkedHashMap<>();
      mapC1.put("c2", "c1");
      mapC1.put("c3", "c2");
      mapC1.put("c4", "c3");
      mapC1.put("c5", "c4");
      mapC1.put("c6", "c5");
      // C2 is replaced by something non-C - all above are moved down
      Map<String, String> mapC2 = new LinkedHashMap<>();
      mapC2.put("c3", "c2");
      mapC2.put("c4", "c3");
      mapC2.put("c5", "c4");
      mapC2.put("c6", "c5");
      // Z1 and Z2 are replaced by something non-ZP - all above are moved down
      Map<String, String> mapZM12 = new LinkedHashMap<>();
      mapZM12.put("z3", "z1");
      mapZM12.put("m3", "m1");
      mapZM12.put("z4", "z2");
      mapZM12.put("m4", "m2");
      mapZM12.put("z5", "z3");
      mapZM12.put("m5", "m3");
      mapZM12.put("z6", "z4");
      mapZM12.put("m6", "m4");
      // Z1 and C1 are replaced by something non-ZP - all above are moved down
      Map<String, String> mapZM1C1 = new LinkedHashMap<>();
      mapZM1C1.putAll(mapZM1);
      mapZM1C1.putAll(mapC1);
      // Use unsigned in place of a signed
      Map<String, String> mapSToU = new LinkedHashMap<>();
      mapSToU.put("vbsz1", "vbuz1");
      mapSToU.put("vbsz2", "vbuz2");
      mapSToU.put("vbsz3", "vbuz3");
      mapSToU.put("vbsm1", "vbum1");
      mapSToU.put("vbsm2", "vbum2");
      mapSToU.put("vbsm3", "vbum3");
      mapSToU.put("vbsc1", "vbuc1");
      mapSToU.put("vbsc2", "vbuc2");
      mapSToU.put("vbsc3", "vbuc3");
      mapSToU.put("vbsaa", "vbuaa");
      mapSToU.put("vbsxx", "vbuxx");
      mapSToU.put("vbsyy", "vbuyy");
      mapSToU.put("vwsz1", "vwuz1");
      mapSToU.put("vwsz2", "vwuz2");
      mapSToU.put("vwsz3", "vwuz3");
      mapSToU.put("vwsm1", "vwum1");
      mapSToU.put("vwsm2", "vwum2");
      mapSToU.put("vwsm3", "vwum3");
      mapSToU.put("vwsc1", "vwuc1");
      mapSToU.put("vwsc2", "vwuc2");
      mapSToU.put("vwsc3", "vwuc3");
      mapSToU.put("vdsz1", "vduz1");
      mapSToU.put("vdsz2", "vduz2");
      mapSToU.put("vdsz3", "vduz3");
      mapSToU.put("vdsm1", "vdum1");
      mapSToU.put("vdsm2", "vdum2");
      mapSToU.put("vdsm3", "vdum3");
      mapSToU.put("vdsc1", "vduc1");
      mapSToU.put("vdsc2", "vduc2");
      mapSToU.put("vdsc3", "vduc3");
      mapSToU.put("pbsz1", "pbuz1");
      mapSToU.put("pbsz2", "pbuz2");
      mapSToU.put("pbsz3", "pbuz3");
      mapSToU.put("pbsm1", "pbum1");
      mapSToU.put("pbsm2", "pbum2");
      mapSToU.put("pbsm3", "pbum3");
      mapSToU.put("pbsc1", "pbuc1");
      mapSToU.put("pbsc2", "pbuc2");
      mapSToU.put("pbsc3", "pbuc3");
      mapSToU.put("pwsz1", "pwuz1");
      mapSToU.put("pwsz2", "pwuz2");
      mapSToU.put("pwsz3", "pwuz3");
      mapSToU.put("pwsm1", "pwum1");
      mapSToU.put("pwsm2", "pwum2");
      mapSToU.put("pwsm3", "pwum3");
      mapSToU.put("pwsc1", "pwuc1");
      mapSToU.put("pwsc2", "pwuc2");
      mapSToU.put("pwsc3", "pwuc3");
      // Swap z1 and z2
      Map<String, String> mapZM2Swap = new LinkedHashMap<>();
      mapZM2Swap.put("z2", "zn");
      mapZM2Swap.put("m2", "mn");
      mapZM2Swap.put("z1", "z2");
      mapZM2Swap.put("m1", "m2");
      mapZM2Swap.put("zn", "z1");
      mapZM2Swap.put("mn", "m1");
      // Swap c1 and c2
      Map<String, String> mapC2Swap = new LinkedHashMap<>();
      mapC2Swap.put("c2", "cn");
      mapC2Swap.put("c1", "c2");
      mapC2Swap.put("cn", "c1");
      // Swap z2 and z3
      Map<String, String> mapZM3Swap = new LinkedHashMap<>();
      mapZM3Swap.put("z3", "zn");
      mapZM3Swap.put("m3", "mn");
      mapZM3Swap.put("z2", "z3");
      mapZM3Swap.put("m2", "m3");
      mapZM3Swap.put("zn", "z2");
      mapZM3Swap.put("mn", "m2");
      // Swap z3 and z4
      Map<String, String> mapZM4Swap = new LinkedHashMap<>();
      mapZM4Swap.put("z4", "zn");
      mapZM4Swap.put("m4", "mn");
      mapZM4Swap.put("z3", "z4");
      mapZM4Swap.put("m3", "m4");
      mapZM4Swap.put("zn", "z3");
      mapZM4Swap.put("mn", "m3");

      // AA/XX/YY/Z1 is an RValue
      String rvalAa = ".*=.*aa.*|.*_.*aa.*|...aa_(lt|gt|le|ge|eq|neq)_.*";
      String rvalXx = ".*=.*xx.*|.*_.*xx.*|...xx_(lt|gt|le|ge|eq|neq)_.*";
      String rvalYy = ".*=.*yy.*|.*_.*yy.*|...yy_(lt|gt|le|ge|eq|neq)_.*";
      String rvalZ1 = ".*=.*z1.*|.*_.*z1.*|...z1_(lt|gt|le|ge|eq|neq)_.*";
      String rvalZ2 = ".*=.*z2.*|.*_.*z2.*|...z2_(lt|gt|le|ge|eq|neq)_.*";
      String lvalC1 = ".*c1.*=.*";
      String lvalC2 = ".*c2.*=.*";
      String lvalDerefZM1 = ".*_deref_...[zm]1=.*";
      String lvalDerefZM2 = ".*_deref_...[zm]2=.*";
      String lvalDerefC1 = ".*_deref_...c1=.*";
      String lvalDerefC2 = ".*_deref_...c2=.*";
      String lvalDerefC3 = ".*_deref_...c3=.*";
      String lvalDerefIdxAa = ".*_derefidx_...aa=.*";
      String lvalDerefIdxZ1 = ".*_derefidx_...z1=.*";
      String lvalDerefIdxZ2 = ".*_derefidx_...z2=.*";
      String lvalDerefIdxZ3 = ".*_derefidx_...z3=.*";
      String lvalDerefIdxZ4 = ".*_derefidx_...z4=.*";
      // AA/XX/YY/Z1 is an LValue
      String lvalAa = "...aa=.*";
      String lvalXx = "...xx=.*";
      String lvalYy = "...yy=.*";
      String lvalZM1 = "...[zm]1=.*";
      String lvalZM2 = "...[zm]2=.*";
      String lvalZM3 = "...[zm]3=.*";
      String lvalZM4 = "...[zm]4=.*";
      // Multiple occurences of Z1/...
      String twoZM1 = ".*[zm]1.*[zm]1.*";
      String twoZM2 = ".*[zm]2.*[zm]2.*";
      String twoZM3 = ".*[zm]3.*[zm]3.*";
      String twoZM4 = ".*[zm]4.*[zm]4.*";
      String threeZM1 = ".*[zm]1.*[zm]1.*[zm]1.*";
      String threeZM2 = ".*[zm]2.*[zm]2.*[zm]2.*";
      String threeZM3 = ".*[zm]3.*[zm]3.*[zm]3.*";
      String threeZM4 = ".*[zm]4.*[zm]4.*[zm]4.*";
      String fourZM1 = ".*[zm]1.*[zm]1.*[zm]1.*[zm]1.*";
      String fourZM2 = ".*[zm]2.*[zm]2.*[zm]2.*[zm]2.*";
      String fourZM3 = ".*[zm]3.*[zm]3.*[zm]3.*[zm]3.*";
      String fourZM4 = ".*[zm]4.*[zm]4.*[zm]4.*[zm]4.*";
      String twoC1 = ".*c1.*c1.*";
      String twoC2 = ".*c2.*c2.*";
      String threeC1 = ".*c1.*c1.*c1.*";
      String threeAa = ".*aa.*aa.*aa.*";

      // Presence of unwanted single symbols
      String oneZM2 = ".*[zm]2.*";
      String derefC1 = ".*c1_deref.*";
      String derefC2 = ".*c2_deref.*";
      String derefC3 = ".*c3_deref.*";

      List<AsmFragmentTemplateSynthesisRule> synths = new ArrayList<>();

      // NEW STYLE REWRITES - Utilizes that all combinations are tried

      // Replace first AA with XX
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)aa(.*)", lvalAa+"|"+rvalXx, "tax", "$1xx$2", null, null));
      // Replace two AAs with XX
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)aa(.*vb.)aa(.*)", lvalAa+"|"+rvalXx, "tax", "$1xx$2xx$3", null, null));
      // Replace second (not first) AA with XX
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)aa(.*vb.)aa(.*)", lvalAa+"|"+rvalXx, "tax", "$1aa$2xx$3", null, null));
      // Replace AA with XX (not assigned)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)vb(.)aa(.*)", rvalXx, "tax", "$1=$2vb$3xx$4", null, null));
      // Replace two AAs with XX (not assigned)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*vb.)aa(.*vb.)aa(.*)", rvalXx, "tax", "$1=$2xx$3xx$4", null, null));

      // Replace first AA with YY
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)aa(.*)", lvalAa+"|"+rvalYy, "tay", "$1yy$2", null, null));
      // Replace second (not first) AA with YY
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)aa(.*vb.)aa(.*)", lvalAa+"|"+rvalYy, "tay", "$1aa$2yy$3", null, null));
      // Replace two AAs with YY
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)aa(.*vb.)aa(.*)", lvalAa+"|"+rvalYy, "tay", "$1yy$2yy$3", null, null));
      // Replace AA with YY (not assigned)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)vb(.)aa(.*)", rvalYy, "tay", "$1=$2vb$3yy$4", null, null));
      // Replace two AAs with YY (not assigned)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*vb.)aa(.*vb.)aa(.*)", rvalYy, "tay", "$1=$2yy$3yy$4", null, null));

      // Replace first XX with AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)xx(.*)", lvalXx+"|"+rvalAa, "txa", "$1aa$2", null, null));
      // Replace two XXs with AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)xx(.*vb.)xx(.*)", lvalXx+"|"+rvalAa, "txa", "$1aa$2aa$3", null, null));
      // Replace second (not first) XX with AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)xx(.*vb.)xx(.*)", lvalXx+"|"+rvalAa, "txa", "$1xx$2aa$3", null, null));
      // Replace XX with AA (not assigned)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)vb(.)xx(.*)", rvalAa, "txa", "$1=$2vb$3aa$4", null, null));
      // Replace two XXs with AA (not assigned)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*vb.)xx(.*vb.)xx(.*)", rvalAa, "txa", "$1=$2aa$3aa$4", null, null));

      // Replace first YY with AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)yy(.*)", lvalYy+"|"+rvalAa, "tya", "$1aa$2", null, null));
      // Replace two YYs with AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)yy(.*vb.)yy(.*)", lvalYy+"|"+rvalAa, "tya", "$1aa$2aa$3", null, null));
      // Replace second (not first) YY with AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)yy(.*vb.)yy(.*)", lvalYy+"|"+rvalAa, "tya", "$1yy$2aa$3", null, null));
      // Replace YY with AA (not assigned)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)vb(.)yy(.*)", rvalAa, "tya", "$1=$2vb$3aa$4", null, null));
      // Replace two YYs with AA (not assigned)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*vb.)yy(.*vb.)yy(.*)", rvalAa, "tya", "$1=$2aa$3aa$4", null, null));

      // Replace XX with YY
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)vb(.)xx(.*)", rvalYy, "stx $ff\nldy $ff", "$1=$2vb$3yy$4", null, null));

      // Replace YY with XX
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)vb(.)yy(.*)", rvalXx, "sty $ff\nldx $ff", "$1=$2vb$3xx$4", null, null));

      // Replace Z1 with M1
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)z1(.*)", twoZM1, null, "$1m1$2", null, mapZ1M1));
      // Replace two Z1 with M1
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)z1(.*)z1(.*)", threeZM1, null, "$1m1$2m1$3", null, mapZ1M1));
      // Replace three Z1 with M1
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)z1(.*)z1(.*)z1(.*)", fourZM1, null, "$1m1$2m1$3m1$4", null, mapZ1M1));

      // Replace Z2 with M2
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)z2(.*)", twoZM2, null, "$1m2$2", null, mapZ2M2));
      // Replace two Z2 with M2
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)z2(.*)z2(.*)", threeZM2, null, "$1m2$2m2$3", null, mapZ2M2));
      // Replace three Z2 with M2
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)z2(.*)z2(.*)z2(.*)", fourZM2, null, "$1m2$2m2$3m2$4", null, mapZ2M2));

      // Replace Z3 with M3
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)z3(.*)", twoZM3, null, "$1m3$2", null, mapZ3M3));
      // Replace two Z3 with M3
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)z3(.*)z3(.*)", threeZM3, null, "$1m3$2m3$3", null, mapZ3M3));
      // Replace three Z3 with M3
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)z3(.*)z3(.*)z3(.*)", fourZM3, null, "$1m3$2m3$3m3$4", null, mapZ3M3));

      // Replace Z4 with M4
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)z4(.*)", twoZM4, null, "$1m4$2", null, mapZ4M4));
      // Replace two Z4 with M4
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)z4(.*)z4(.*)", threeZM4, null, "$1m4$2m4$3", null, mapZ4M4));
      // Replace three Z4 with M4
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)z4(.*)z4(.*)z4(.*)", fourZM4, null, "$1m4$2m4$3m4$4", null, mapZ4M4));

      // Replace M1 with AA (only one)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)m1(.*)", lvalZM1+"|"+rvalAa+"|"+ twoZM1, "lda {m1}", "$1aa$2", null, mapZM1));
      // Replace two M1s with AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)m1(.*vb.)m1(.*)", lvalZM1+"|"+rvalAa+"|"+ threeZM1, "lda {m1}", "$1aa$2aa$3", null, mapZM1));
      // Replace first (not second) M1 with AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)m1(.*)m1(.*)", lvalZM1+"|"+rvalAa, "lda {m1}", "$1aa$2m1$3", null, null));
      // Replace second (not first) M1 with AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)m1(.*vb.)m1(.*)", lvalZM1+"|"+rvalAa, "lda {m1}", "$1m1$2aa$3", null, null));
      // Replace non-assigned M1 with AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(...aa)=(.*vb.)m1(.*)", rvalAa+"|"+ twoZM1, "lda {m1}", "$1=$2aa$3", null, mapZM1));
      // Replace assigned M1 with AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(vb.)m1=(.*)", twoZM1, null, "$1aa=$2", "sta {m1}", mapZM1));
      // Replace assigned M1 with AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(vb.)m1=(.*m1.*)", null, null, "$1aa=$2", "sta {m1}", null));

      // Replace M2 with AA (only one)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)m2(.*)", lvalZM2+"|"+rvalAa+"|"+twoZM2, "lda {m2}", "$1aa$2", null, mapZM2));
      // Replace two M2s with AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)m2(.*vb.)m2(.*)", lvalZM2+"|"+rvalAa+"|"+threeZM2, "lda {m2}", "$1aa$2aa$3", null, mapZM2));
      // Replace first (of 2) M2 with AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)m2(.*)m2(.*)", lvalZM2+"|"+rvalAa, "lda {m2}", "$1aa$2m2$3", null, null));
      // Replace second (of 2) M2 with AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)m2(.*vb.)m2(.*)", lvalZM2+"|"+rvalAa, "lda {m2}", "$1m2$2aa$3", null, null));

      // Replace M3 with AA (only one)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)m3(.*)", lvalZM3+"|"+rvalAa+"|"+twoZM3, "lda {m3}", "$1aa$2", null, mapZM3));
      // Replace two M3s with AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)m3(.*vb.)m3(.*)", lvalZM3+"|"+rvalAa+"|"+threeZM3, "lda {m3}", "$1aa$2aa$3", null, mapZM3));
      // Replace first (of 2) M3 with AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)m3(.*)m3(.*)", lvalZM3+"|"+rvalAa, "lda {m3}", "$1aa$2m3$3", null, null));
      // Replace second (of 2) M3 with AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)m3(.*vb.)m3(.*)", lvalZM3+"|"+rvalAa, "lda {m3}", "$1m3$2aa$3", null, null));

      // Replace M4 with AA (only one)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)m4(.*)", lvalZM4+"|"+rvalAa+"|"+twoZM4, "lda {m4}", "$1aa$2", null, mapZM4));
      // Replace two M4s with AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)m4(.*vb.)m4(.*)", lvalZM4+"|"+rvalAa+"|"+threeZM4, "lda {m4}", "$1aa$2aa$3", null, mapZM4));
      // Replace first (of 2) M4 with AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)m4(.*)m4(.*)", lvalZM4+"|"+rvalAa, "lda {m4}", "$1aa$2m4$3", null, null));
      // Replace second (of 2) M4 with AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)m4(.*vb.)m4(.*)", lvalZM4+"|"+rvalAa, "lda {m4}", "$1m4$2aa$3", null, null));

      // Replace M1 with YY (only one)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)m1(.*)", lvalZM1+"|"+rvalYy+"|"+ twoZM1, "ldy {m1}", "$1yy$2", null, mapZM1));
      // Replace two M1s with YY
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)m1(.*vb.)m1(.*)", lvalZM1+"|"+rvalYy+"|"+ threeZM1, "ldy {m1}", "$1yy$2yy$3", null, mapZM1));
      // Replace first (not second) M1 with YY
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)m1(.*)m1(.*)", lvalZM1+"|"+rvalYy, "ldy {m1}", "$1yy$2m1$3", null, null));
      // Replace second (not first) M1 with YY
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)m1(.*vb.)m1(.*)", lvalZM1+"|"+rvalYy, "ldy {m1}", "$1m1$2yy$3", null, null));
      // Replace non-assigned M1 with YY
      synths.add(new AsmFragmentTemplateSynthesisRule("(...yy)=(.*vb.)m1(.*)", rvalYy+"|"+ twoZM1, "ldy {m1}", "$1=$2yy$3", null, mapZM1));
      // Replace assigned M1 with YY
      synths.add(new AsmFragmentTemplateSynthesisRule("(vb.)m1=(.*)", twoZM1, null, "$1yy=$2", "sty {m1}", mapZM1));
      // Replace assigned M1 with YY
      synths.add(new AsmFragmentTemplateSynthesisRule("(vb.)m1=(.*m1.*)", null, null, "$1yy=$2", "sty {m1}", null));

      // Replace M2 with YY (only one)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)m2(.*)", lvalZM2+"|"+rvalYy+"|"+twoZM2, "ldy {m2}", "$1yy$2", null, mapZM2));
      // Replace two M2s with YY
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)m2(.*vb.)m2(.*)", lvalZM2+"|"+rvalYy+"|"+threeZM2, "ldy {m2}", "$1yy$2yy$3", null, mapZM2));
      // Replace first (of 2) M2 with YY
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)m2(.*)m2(.*)", lvalZM2+"|"+rvalYy, "ldy {m2}", "$1yy$2m2$3", null, null));
      // Replace second (of 2) M2 with YY
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)m2(.*vb.)m2(.*)", lvalZM2+"|"+rvalYy, "ldy {m2}", "$1m2$2yy$3", null, null));

      // Replace M3 with YY (only one)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)m3(.*)", lvalZM3+"|"+rvalYy+"|"+twoZM3, "ldy {m3}", "$1yy$2", null, mapZM3));
      // Replace two M3s with YY
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)m3(.*vb.)m3(.*)", lvalZM3+"|"+rvalYy+"|"+threeZM3, "ldy {m3}", "$1yy$2yy$3", null, mapZM3));
      // Replace first (of 2) M3 with YY
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)m3(.*)m3(.*)", lvalZM3+"|"+rvalYy, "ldy {m3}", "$1yy$2m3$3", null, null));
      // Replace second (of 2) M3 with YY
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)m3(.*vb.)m3(.*)", lvalZM3+"|"+rvalYy, "ldy {m3}", "$1m3$2yy$3", null, null));

      // Replace M4 with YY (only one)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)m4(.*)", lvalZM4+"|"+rvalYy+"|"+twoZM4, "ldy {m4}", "$1yy$2", null, mapZM4));
      // Replace two M4s with YY
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)m4(.*vb.)m4(.*)", lvalZM4+"|"+rvalYy+"|"+threeZM4, "ldy {m4}", "$1yy$2yy$3", null, mapZM4));
      // Replace first (of 2) M4 with YY
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)m4(.*)m4(.*)", lvalZM4+"|"+rvalYy, "ldy {m4}", "$1yy$2m4$3", null, null));
      // Replace second (of 2) M4 with YY
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)m4(.*vb.)m4(.*)", lvalZM4+"|"+rvalYy, "ldy {m4}", "$1m4$2yy$3", null, null));

      // Replace M1 with XX (only one)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)m1(.*)", lvalZM1+"|"+rvalXx+"|"+ twoZM1, "ldx {m1}", "$1xx$2", null, mapZM1));
      // Replace two M1s with XX
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)m1(.*vb.)m1(.*)", lvalZM1+"|"+rvalXx+"|"+ threeZM1, "ldx {m1}", "$1xx$2xx$3", null, mapZM1));
      // Replace first (not second) M1 with XX
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)m1(.*)m1(.*)", lvalZM1+"|"+rvalXx, "ldx {m1}", "$1xx$2m1$3", null, null));
      // Replace second (not first) M1 with XX
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)m1(.*vb.)m1(.*)", lvalZM1+"|"+rvalXx, "ldx {m1}", "$1m1$2xx$3", null, null));
      // Replace non-assigned M1 with XX
      synths.add(new AsmFragmentTemplateSynthesisRule("(...xx)=(.*vb.)m1(.*)", rvalXx+"|"+ twoZM1, "ldx {m1}", "$1=$2xx$3", null, mapZM1));
      // Replace assigned M1 with XX
      synths.add(new AsmFragmentTemplateSynthesisRule("(vb.)m1=(.*)", twoZM1, null, "$1xx=$2", "stx {m1}", mapZM1));
      // Replace assigned M1 with XX
      synths.add(new AsmFragmentTemplateSynthesisRule("(vb.)m1=(.*m1.*)", null, null, "$1xx=$2", "stx {m1}", null));

      // Replace M2 with XX (only one)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)m2(.*)", lvalZM2+"|"+rvalXx+"|"+twoZM2, "ldx {m2}", "$1xx$2", null, mapZM2));
      // Replace two M2s with XX
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)m2(.*vb.)m2(.*)", lvalZM2+"|"+rvalXx+"|"+threeZM2, "ldx {m2}", "$1xx$2xx$3", null, mapZM2));
      // Replace first (of 2) M2 with XX
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)m2(.*)m2(.*)", lvalZM2+"|"+rvalXx, "ldx {m2}", "$1xx$2m2$3", null, null));
      // Replace second (of 2) M2 with XX
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)m2(.*vb.)m2(.*)", lvalZM2+"|"+rvalXx, "ldx {m2}", "$1m2$2xx$3", null, null));

      // Replace M3 with XX (only one)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)m3(.*)", lvalZM3+"|"+rvalXx+"|"+twoZM3, "ldx {m3}", "$1xx$2", null, mapZM3));
      // Replace two M3s with XX
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)m3(.*vb.)m3(.*)", lvalZM3+"|"+rvalXx+"|"+threeZM3, "ldx {m3}", "$1xx$2xx$3", null, mapZM3));
      // Replace first (of 2) M3 with XX
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)m3(.*)m3(.*)", lvalZM3+"|"+rvalXx, "ldx {m3}", "$1xx$2m3$3", null, null));
      // Replace second (of 2) M3 with XX
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)m3(.*vb.)m3(.*)", lvalZM3+"|"+rvalXx, "ldx {m3}", "$1m3$2xx$3", null, null));

      // Replace M4 with XX (only one)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)m4(.*)", lvalZM4+"|"+rvalXx+"|"+twoZM4, "ldx {m4}", "$1xx$2", null, mapZM4));
      // Replace two M4s with XX
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)m4(.*vb.)m4(.*)", lvalZM4+"|"+rvalXx+"|"+threeZM4, "ldx {m4}", "$1xx$2xx$3", null, mapZM4));
      // Replace first (of 2) M4 with XX
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*vb.)m4(.*)m4(.*)", lvalZM4+"|"+rvalXx, "ldx {m4}", "$1xx$2m4$3", null, null));
      // Replace second (of 2) M4 with XX
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)m4(.*vb.)m4(.*)", lvalZM4+"|"+rvalXx, "ldx {m4}", "$1m4$2xx$3", null, null));

      // Correct wrong ordered Z2/Z1
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)m2(.*)m1(.*)", twoZM1+"|"+twoZM2, null, "$1m1$2m2$3", null, mapZM2Swap, false));
      // Correct wrong ordered Z3/Z2
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)m3(.*)m2(.*)", twoZM2+"|"+twoZM3, null, "$1m2$2m3$3", null, mapZM3Swap, false));
      // Correct wrong ordered Z4/Z3
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)m4(.*)m3(.*)", twoZM3+"|"+twoZM4, null, "$1m3$2m4$3", null, mapZM4Swap, false));
      // Correct wrong ordered C2/C1
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)c2(.*)c1(.*)", twoC1+"|"+twoC2, null, "$1c1$2c2$3", null, mapC2Swap, false));

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
      synths.add(new AsmFragmentTemplateSynthesisRule("vb(.)m1=(.*)", twoZM1, null, "vb$1aa=$2", "sta {m1}", mapZM1));
      // Rewrite Assignments to Z1 from A
      synths.add(new AsmFragmentTemplateSynthesisRule("vb(.)m1=(.*[mz]1.*)", null, null, "vb$1aa=$2", "sta {m1}", null));
      // Rewrite Assignments to *C1 from A
      synths.add(new AsmFragmentTemplateSynthesisRule("_deref_pb(.)c1=(.*)", null, null, "vb$1aa=$2", "sta {c1}", null));
      // Rewrite Assignments to *Z1 from A
      synths.add(new AsmFragmentTemplateSynthesisRule("_deref_pb(.)z1=(.*)", twoZM1, null, "vb$1aa=$2", "ldy #0\n" + "sta ({z1}),y", mapZM1));
      // Rewrite Assignments to *Z1 from A
      synths.add(new AsmFragmentTemplateSynthesisRule("_deref_pb(.)z1=(.*z1.*)", null, null, "vb$1aa=$2", "ldy #0\n" + "sta ({z1}),y", null));

      // Rewrite _deref_pb.z1_ to _vb.aa_ (if no other Z1s)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_deref_pb(.)z1(.*)", twoZM1+"|"+rvalAa+"|"+rvalYy+"|"+ lvalDerefZM1, "ldy #0\n"+"lda ({z1}),y", "$1vb$2aa$3", null, mapZM1));
      // Rewrite _deref_pb.z1_ to _vb.aa_ (if other Z1)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*z1.*)_deref_pb(.)z1(.*)", rvalAa+"|"+rvalYy+"|"+lvalDerefZM1, "ldy #0\n"+"lda ({z1}),y", "$1vb$2aa$3", null, null));
      // Rewrite _deref_pb.z1_ to _vb.aa_ (if other Z1)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_deref_pb(.)z1(.*[zm]1.*)", rvalAa+"|"+rvalYy+"|"+ lvalDerefZM1, "ldy #0\n"+"lda ({z1}),y", "$1vb$2aa$3", null, null));

      // Rewrite _deref_pb.m1_ to _vb.aa_ (if no other M1s)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_deref_pb(.)m1(.*)", twoZM1+"|"+rvalAa+"|"+rvalYy+"|"+lvalDerefZM1, "ldy {m1}\nsty $fe\nldy {m1}+1\nsty $ff\nldy #0\n"+"lda ($fe),y", "$1vb$2aa$3", null, mapZM1));
      // Rewrite _deref_pb.m2_ to _vb.aa_ (if no other M1s)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_deref_pb(.)m2(.*)", twoZM2+"|"+rvalAa+"|"+rvalYy+"|"+lvalDerefZM2, "ldy {m2}\nsty $fe\nldy {m2}+1\nsty $ff\nldy #0\n"+"lda ($fe),y", "$1vb$2aa$3", null, mapZM2));

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

      // Rewrite *C1 to AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_deref_pb(.)c1(.*)", rvalAa+"|"+lvalDerefC1, "lda {c1}", "$1vb$2aa$3", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_deref_pb(.)c1(.*)", rvalXx+"|"+lvalDerefC1, "ldx {c1}", "$1vb$2xx$3", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_deref_pb(.)c1(.*)", rvalYy+"|"+lvalDerefC1, "ldy {c1}", "$1vb$2yy$3", null, null));
      // Rewrite *C2 to AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_deref_pb(.)c2(.*)", rvalAa+"|"+lvalDerefC2, "lda {c2}", "$1vb$2aa$3", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_deref_pb(.)c2(.*)", rvalXx+"|"+lvalDerefC2, "ldx {c2}", "$1vb$2xx$3", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_deref_pb(.)c2(.*)", rvalYy+"|"+lvalDerefC2, "ldy {c2}", "$1vb$2yy$3", null, null));
      // Rewrite *C3 to AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_deref_pb(.)c3(.*)", rvalAa+"|"+lvalDerefC3, "lda {c3}", "$1vb$2aa$3", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_deref_pb(.)c3(.*)", rvalXx+"|"+lvalDerefC3, "ldx {c3}", "$1vb$2xx$3", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_deref_pb(.)c3(.*)", rvalYy+"|"+lvalDerefC3, "ldy {c3}", "$1vb$2yy$3", null, null));
      // Rewrite (Z1),y to AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)pb(.)z1_derefidx_vbuyy(.*)_then_(.*)", twoZM1+"|"+rvalAa, "lda ({z1}),y\n" , "$1vb$2aa$3_then_$4", null, mapZM1));

      // Rewrite left-size C1,y to use AA and a STA C1,y
      synths.add(new AsmFragmentTemplateSynthesisRule("pb(.)c1_derefidx_vbuyy=(.*)", null, null, "vb$1aa=$2", "sta {c1},y", null, "yy"));
      // Rewrite C1,y to save and reload YY from $FF
      synths.add(new AsmFragmentTemplateSynthesisRule("pb(.)c1_derefidx_vbuyy=(.*)", null, "sty $ff\n" , "vb$1aa=$2", "ldy $ff\nsta {c1},y", null));
      // Rewrite (Z1),y to save and reload YY from $FF
      synths.add(new AsmFragmentTemplateSynthesisRule("pb(.)z1_derefidx_vbuyy=(.*)", twoZM1, "sty $ff\n" , "vb$1aa=$2", "ldy $ff\nsta ({z1}),y", mapZM1));

      // Rewrite left-size C1,x to use AA and a STA C1,x
      synths.add(new AsmFragmentTemplateSynthesisRule("pb(.)c1_derefidx_vbuxx=(.*)", null, null, "vb$1aa=$2", "sta {c1},x", null, "xx"));
      // Rewrite C1,x to save and reload XX from $FF
      synths.add(new AsmFragmentTemplateSynthesisRule("pb(.)c1_derefidx_vbuxx=(.*)", null, "stx $ff\n" , "vb$1aa=$2", "ldx $ff\nsta {c1},x", null));
      // Rewrite (Z1),x to save Y to $FF and reload it into YY
      synths.add(new AsmFragmentTemplateSynthesisRule("pb(.)z1_derefidx_vbuxx=(.*)", twoZM1, "stx $ff" , "vb$1aa=$2", "ldy $ff\nsta ({z1}),y", mapZM1));

      // Rewrite (Z1),a to use TAY prefix
      synths.add(new AsmFragmentTemplateSynthesisRule("pb(.)z1_derefidx_vbuaa=(.*)", twoZM1+"|"+rvalYy, "tay" , "vb$1aa=$2", "sta ({z1}),y", mapZM1, "yy"));
      // Rewrite (Z1),a to save A to $FF and reload it into YY
      synths.add(new AsmFragmentTemplateSynthesisRule("pb(.)z1_derefidx_vbuaa=(.*)", twoZM1, "sta $ff" , "vb$1aa=$2", "ldy $ff\nsta ({z1}),y", mapZM1));

      // Synthesize typed pointer math using void pointers
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)p[^v][^o]([czm][1-9])(.*)", null, null, "$1pvo$2$3", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)p[^v][^o]([czm][1-9])(.*p.*)", null, null, "$1pvo$2$3", null, null));

      // Synthesize some constant pointers as constant words (remove when the above section can be included)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_(lt|gt|le|ge|eq|neq)_p..([czm].)_then_(.*)", null, null, "$1_$2_vwu$3_then_$4", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("p..([czm].)_(lt|gt|le|ge|eq|neq)_(.*)", null, null, "vwu$1_$2_$3", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=p..([czm].)", null, null, "$1=vwu$2", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)_(plus|minus|bor|bxor)_p..([czm].)", null, null, "$1=$2_$3_vwu$4", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=p..([czm].)_(plus|minus|bor|bxor)_(.*)", null, null, "$1=vwu$2_$3_$4", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("p..([czm].)=(.*)_(sethi|setlo|plus|minus)_(.*)", null, null, "vwu$1=$2_$3_$4", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=p..([czm].)_(sethi|setlo|plus|minus)_(.*)", null, null, "$1=vwu$2_$3_$4", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("p..([czm].)=_(inc|dec)_p..([czm].)", null, null, "vwu$1=_$2_vwu$3", null, null));

      // Synthesize constants using AA/XX/YY
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)vb(.)c1(.*)", rvalAa+"|"+ derefC1, "lda #{c1}", "$1vb$2aa$3", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)vb(.)c1(.*)", rvalYy+"|"+ derefC1, "ldy #{c1}", "$1vb$2yy$3", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)vb(.)c1(.*)", rvalXx+"|"+ derefC1, "ldx #{c1}", "$1vb$2xx$3", null, null));

      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)vb(.)c2(.*)", rvalAa+"|"+ derefC2, "lda #{c2}", "$1vb$2aa$3", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)vb(.)c2(.*)", rvalYy+"|"+ derefC2, "ldy #{c2}", "$1vb$2yy$3", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)vb(.)c2(.*)", rvalXx+"|"+ derefC2, "ldx #{c2}", "$1vb$2xx$3", null, null));

      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)vb(.)c3(.*)", rvalAa+"|"+ derefC3, "lda #{c3}", "$1vb$2aa$3", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)vb(.)c3(.*)", rvalYy+"|"+ derefC3, "ldy #{c3}", "$1vb$2yy$3", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)vb(.)c3(.*)", rvalXx+"|"+ derefC3, "ldx #{c3}", "$1vb$2xx$3", null, null));

      // Rewrite any signed dereference (.*_derefidx_vbs.*) to unsigned (.*_derefidx_vbu.*)
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_derefidx_vbs(.*)", null, null, "$1_derefidx_vbu$2", null, null));

      // If no C1 is present in the signature map other Cs down to take its place
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*c2.*)", ".*c1.*", null, "$1", null, mapC1));
      // If no C2 is present in the signature map other Cs down to take its place
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*c3.*)", ".*c2.*", null, "$1", null, mapC2));

      // Rewrite trailing right-size (Z1),y to use AA
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)pb(.)z1_derefidx_vbuyy", twoZM1+"|"+rvalAa, "lda ({z1}),y", "$1=$2vb$3aa", null, mapZM1, null));
      // Rewrite trailing right-size (Z1),y to use AA - when 2 Z1
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)z1(.*)pb(.)z1_derefidx_vbuyy", rvalAa, "lda ({z1}),y", "$1z1$2vb$3aa", null, null, null));

      // Rewrite wv.z1=(word)_ror_4 to wv.z1=(word)
      synths.add(new AsmFragmentTemplateSynthesisRule("vw(.*)m1=(.*)_ror_4", rvalAa, null, "vw$1m1=$2", "lsr {m1}+1\nror {m1}\nlsr {m1}+1\nror {m1}\nlsr {m1}+1\nror {m1}\nlsr {m1}+1\nror {m1}", null, null));

      // Rewrite vbuaa=(byte)_rol_N to wbuz1=(byte)
      synths.add(new AsmFragmentTemplateSynthesisRule("vbuaa=(.*)_rol_1", rvalAa, null, "vbuaa=$1", "asl", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("vbuaa=(.*)_rol_2", rvalAa, null, "vbuaa=$1", "asl\nasl", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("vbuaa=(.*)_rol_3", rvalAa, null, "vbuaa=$1", "asl\nasl\nasl", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("vbuaa=(.*)_rol_4", rvalAa, null, "vbuaa=$1", "asl\nasl\nasl\nasl", null, null));

      // Rewrite multiple _derefidx_vbuc1 to use YY
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_derefidx_vbuc1(.*)_derefidx_vbuc1(.*)", rvalYy+"|"+ threeC1, "ldy #{c1}", "$1_derefidx_vbuyy$2_derefidx_vbuyy$3", null, mapC1));

      synths.add(new AsmFragmentTemplateSynthesisRule("pb(.)c1_derefidx_vbum1=(.*)", twoZM1+"|"+twoC1, null, "vb$1aa=$2", "ldx {m1}\n" + "sta {c1},x", mapZM1C1));
      synths.add(new AsmFragmentTemplateSynthesisRule("pb(.)z1_derefidx_vbum2=(.*)", twoZM1+"|"+twoZM2, null, "vb$1aa=$2", "ldy {m2}\n" + "sta ({z1}),y", mapZM12));
      synths.add(new AsmFragmentTemplateSynthesisRule("pb(.)c1_derefidx_vbum1=(.*c1.*)", twoZM1, null, "vb$1aa=$2", "ldx {m1}\n" + "sta {c1},x", mapZM1));
      synths.add(new AsmFragmentTemplateSynthesisRule("pb(.)c1_derefidx_vbum1=(.*[mz]1.*)", twoC1, null, "vb$1aa=$2", "ldx {m1}\n" + "sta {c1},x", mapC1));

      // Convert X/Y-based array indexing of a constant pointer into A-register by prefixing lda cn,x / lda cn,y ( ...pb.c1_derefidx_vbuxx... / ...pb.c1_derefidx_vbuyy... -> ...vb.aa... )

      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)pb(.)c1_derefidx_vbuxx(.*)", rvalAa+"|"+twoC1, "lda {c1},x", "$1=$2vb$3aa$4", null, mapC1));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)pb(.)c1_derefidx_vbuxx(.*)", rvalYy+"|"+twoC1, "ldy {c1},x", "$1=$2vb$3yy$4", null, mapC1));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*c1.*)pb(.)c1_derefidx_vbuxx(.*)", rvalAa, "lda {c1},x", "$1=$2vb$3aa$4", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)pb(.)c1_derefidx_vbuxx(.*c1.*)", rvalAa, "lda {c1},x", "$1=$2vb$3aa$4", null, null));

      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)pb(.)c1_derefidx_vbuyy(.*)", rvalAa+"|"+twoC1, "lda {c1},y", "$1=$2vb$3aa$4", null, mapC1));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)pb(.)c1_derefidx_vbuyy(.*)", rvalXx+"|"+twoC1, "ldx {c1},y", "$1=$2vb$3xx$4", null, mapC1));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*c1.*)pb(.)c1_derefidx_vbuyy(.*)", rvalAa, "lda {c1},y", "$1=$2vb$3aa$4", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)pb(.)c1_derefidx_vbuyy(.*c1.*)", rvalAa, "lda {c1},y", "$1=$2vb$3aa$4", null, null));

      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)pb(.)c2_derefidx_vbuxx(.*)", rvalAa+"|"+twoC2, "lda {c2},x", "$1=$2vb$3aa$4", null, mapC2));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)pb(.)c2_derefidx_vbuxx(.*)", rvalYy+"|"+twoC2, "ldy {c2},x", "$1=$2vb$3yy$4", null, mapC2));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*c2.*)pb(.)c2_derefidx_vbuxx(.*)", rvalAa, "lda {c2},x", "$1=$2vb$3aa$4", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)pb(.)c2_derefidx_vbuxx(.*c2.*)", rvalAa, "lda {c2},x", "$1=$2vb$3aa$4", null, null));

      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)pb(.)c2_derefidx_vbuyy(.*)", rvalAa+"|"+twoC2, "lda {c2},y", "$1=$2vb$3aa$4", null, mapC2));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)pb(.)c2_derefidx_vbuyy(.*)", rvalXx+"|"+twoC2, "ldx {c2},y", "$1=$2vb$3xx$4", null, mapC2));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*c2.*)pb(.)c2_derefidx_vbuyy(.*)", rvalAa, "lda {c2},y", "$1=$2vb$3aa$4", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)=(.*)pb(.)c2_derefidx_vbuyy(.*c2.*)", rvalAa, "lda {c2},y", "$1=$2vb$3aa$4", null, null));

      // Remove any parenthesis ending up around values
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)\\(([vp][bwd][us][zcaxy][123456axy])\\)(.*)", null, null, "$1$2$3", null, null));

      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_derefidx_vbuz1_(.*)", rvalYy+"|"+twoZM1, "ldy {z1}", "$1_derefidx_vbuyy_$2", null, mapZM1));
      synths.add(new AsmFragmentTemplateSynthesisRule("(.*)_derefidx_vbuz1_(lt|gt|le|ge|eq|neq)_(.*)", rvalXx+"|"+twoZM1, "ldx {z1}", "$1_derefidx_vbuxx_$2_$3", null, mapZM1));
      synths.add(new AsmFragmentTemplateSynthesisRule("pb(.)c1_derefidx_vbuyy_(lt|gt|le|ge|eq|neq)_(.*)", rvalAa+"|"+twoC1, "lda {c1},y", "vb$1aa_$2_$3", null, mapC1));
      synths.add(new AsmFragmentTemplateSynthesisRule("pb(.)c1_derefidx_vbuyy_(lt|gt|le|ge|eq|neq)_(.*c1.*)", rvalAa, "lda {c1},y", "vb$1aa_$2_$3", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("pb(.)c1_derefidx_vbuxx_(lt|gt|le|ge|eq|neq)_(.*)", rvalAa+"|"+twoC1, "lda {c1},x", "vb$1aa_$2_$3", null, mapC1));
      synths.add(new AsmFragmentTemplateSynthesisRule("pb(.)c1_derefidx_vbuxx_(lt|gt|le|ge|eq|neq)_(.*c1.*)", rvalAa, "lda {c1},x", "vb$1aa_$2_$3", null, null));

      // Use unsigned ASM to synthesize signed ASM ( ...vbs... -> ...vbu... )
      synths.add(new AsmFragmentTemplateSynthesisRule("(v.s..)_(eq|neq)_(v.s..)_then_(.*)", null, null, "$1_$2_$3_then_$4", null, mapSToU));
      synths.add(new AsmFragmentTemplateSynthesisRule("(v.s..)=(v.s..)", null, null, "$1=$2", null, mapSToU));
      synths.add(new AsmFragmentTemplateSynthesisRule("(v.s..)=(v.s..)_(band|bxor|bor)_(v.s..)", null, null, "$1=$2_$3_$4", null, mapSToU));
      synths.add(new AsmFragmentTemplateSynthesisRule("(v.s..)=(p.s..)_derefidx_(vbu..)", null, null, "$1=$2_derefidx_$3", null, mapSToU));
      synths.add(new AsmFragmentTemplateSynthesisRule("(v.s..)=_(inc|dec)_(v.s..)", null, null, "$1=_$2_$3", null, mapSToU));
      synths.add(new AsmFragmentTemplateSynthesisRule("(vbuz.|vbuaa|vbuxx|vbuyy)=_(lo|hi)_vws(z.|c.|m.)", null, null, "$1=_$2_vwu$3", null, mapSToU));
      synths.add(new AsmFragmentTemplateSynthesisRule("(vb[su]..)=(vb[su]..)_(plus|minus)_(vb[su]..)", null, null, "$1=$2_$3_$4", null, mapSToU));
      synths.add(new AsmFragmentTemplateSynthesisRule("(vw[su]..)=(vw[su]..)_(plus|minus)_(vw[su]..)", null, null, "$1=$2_$3_$4", null, mapSToU));
      synths.add(new AsmFragmentTemplateSynthesisRule("(vd[su]..)=(vd[su]..)_(plus|minus)_(vd[su]..)", null, null, "$1=$2_$3_$4", null, mapSToU));

      // Use Z1/Z2 ASM to synthesize Z1-only code ( ...z1...z1... -> ...z1...z2... )
      synths.add(new AsmFragmentTemplateSynthesisRule("(v..[zm])1=(v..[zm])1_(plus|minus|band|bxor|bor)_(.*)", oneZM2, null, "$11=$22_$3_$4", null, mapZM1, false));
      synths.add(new AsmFragmentTemplateSynthesisRule("(v..[zm])1=(.*)_(plus|minus|band|bxor|bor)_(v..[zm])1", oneZM2, null, "$11=$2_$3_$42", null, mapZM1, false));
      synths.add(new AsmFragmentTemplateSynthesisRule("(v..[zm])1=_(neg|lo|hi)_(v..[zm])1", oneZM2, null, "$11=_$2_$32", null, mapZM1, false));

      //synths.add(new AsmFragmentTemplateSynthesisRule("(v..)z1=(v..)z1_(plus|minus|band|bxor|bor)_(v..)z2", null, null, "$1z1=$2z2_$3_$4z3", null, mapZ1, false));

      // Convert INC/DEC to +1/-1 ( ..._inc_xxx... -> ...xxx_plus_1_... / ..._dec_xxx... -> ...xxx_minus_1_... )
      synths.add(new AsmFragmentTemplateSynthesisRule("vb(.)aa=_inc_(.*)", null, null, "vb$1aa=$2_plus_1", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("vb(.)aa=_dec_(.*)", null, null, "vb$1aa=$2_minus_1", null, null));
      synths.add(new AsmFragmentTemplateSynthesisRule("(v..[zm].)=_inc_(v..[zm].)", null, null, "$1=$2_plus_1", null, null));

      return synths;
   }

}

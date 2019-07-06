package dk.camelot64.kickc.test;

import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.fragment.AsmFragmentTemplate;
import dk.camelot64.kickc.fragment.AsmFragmentTemplateSynthesizer;
import dk.camelot64.kickc.fragment.AsmFragmentTemplateUsages;
import dk.camelot64.kickc.model.operators.Operators;
import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Test;

import java.io.IOException;
import java.util.*;

import static junit.framework.TestCase.assertTrue;
import static junit.framework.TestCase.fail;

/** Test the ASM fragment sub-system by loading/synthesizing a lot of different fragments and comparing with reference fragments. */
public class TestFragments {

   @BeforeClass
   public static void setUp() {
      AsmFragmentTemplateSynthesizer.initialize("src/main/fragment/");
   }

   @AfterClass
   public static void tearDown() {
      CompileLog log = new CompileLog();
      log.setSysOut(true);
      AsmFragmentTemplateUsages.logUsages(log, false, false, false, false, false, false);
   }

   @Test
   public void testAssignmentsBu() throws IOException {
      testFragments("fragments-assignment-copy", assignmentsBu());
   }

   @Test
   public void testAssignmentsUnaryBu() throws IOException {
      testFragments("fragments-assignment-unary", assignmentsUnaryBu());
   }

   @Test
   public void testAssignmentsBinaryVbuaa() throws IOException {
      testAssignmentsBinary(new Value("vbuaa"));
   }

   @Test
   public void testAssignmentsBinaryVbuxx() throws IOException {
      testAssignmentsBinary(new Value("vbuxx"));
   }

   @Test
   public void testAssignmentsBinaryVbuyy() throws IOException {
      testAssignmentsBinary(new Value("vbuyy"));
   }

   @Test
   public void testAssignmentsBinaryVbuz1() throws IOException {
      testAssignmentsBinary(new Value("vbuz1"));
   }

   @Test
   public void testAssignmentsBinaryDerefVbuz1() throws IOException {
      testAssignmentsBinary(new Value("_deref_pbuz1"));
   }

   @Test
   public void testAssignmentsBinaryDerefVbuc1() throws IOException {
      testAssignmentsBinary(new Value("_deref_pbuc1"));
   }

   @Test
   public void testAssignmentsBinaryPbuz1DerefidxVbuaa() throws IOException {
      testAssignmentsBinary(new Value("pbuz1_derefidx_vbuaa"));
   }

   @Test
   public void testAssignmentsBinaryPbuz1DerefidxVbuxx() throws IOException {
      testAssignmentsBinary(new Value("pbuz1_derefidx_vbuxx"));
   }

   @Test
   public void testAssignmentsBinaryPbuz1DerefidxVbuyy() throws IOException {
      testAssignmentsBinary(new Value("pbuz1_derefidx_vbuyy"));
   }

   @Test
   public void testAssignmentsBinaryPbuz1DerefidxVbuz1() throws IOException {
      testAssignmentsBinary(new Value("pbuz1_derefidx_vbuz1"));
   }

   @Test
   public void testAssignmentsBinaryPbuz1DerefidxVbuz2() throws IOException {
      testAssignmentsBinary(new Value("pbuz1_derefidx_vbuz2"));
   }

   @Test
   public void testAssignmentsBinaryPbuz1DerefidxVbuc1() throws IOException {
      testAssignmentsBinary(new Value("pbuz1_derefidx_vbuc1"));
   }

   @Test
   public void testAssignmentsBinaryPbuc1DerefidxVbuaa() throws IOException {
      testAssignmentsBinary(new Value("pbuc1_derefidx_vbuaa"));
   }

   @Test
   public void testAssignmentsBinaryPbuc1DerefidxVbuxx() throws IOException {
      testAssignmentsBinary(new Value("pbuc1_derefidx_vbuxx"));
   }

   @Test
   public void testAssignmentsBinaryPbuc1DerefidxVbuyy() throws IOException {
      testAssignmentsBinary(new Value("pbuc1_derefidx_vbuyy"));
   }

   @Test
   public void testAssignmentsBinaryPbuc1DerefidxVbuz1() throws IOException {
      testAssignmentsBinary(new Value("pbuc1_derefidx_vbuz1"));
   }

   private void testAssignmentsBinary(Value lVal) throws IOException {
      testFragments("fragments-assignment-binary-" + lVal.getSignature(), assignmentsBinaryBu(lVal));
   }

   @Test
   public void testComplexFragments() throws IOException {
      List<String> signaturesComplex = Arrays.asList(
            "vbuz1=pbuz2_derefidx_vbuc1_band_pbuz3_derefidx_vbuc2",
            "pbuc1_derefidx_vbuz1=pbuz2_derefidx_vbuz1_band_pbuz3_derefidx_vbuc2",
            "vbuxx=pbuz1_derefidx_vbuc1_band_pbuz2_derefidx_vbuc2",
            "_deref_pbuz1=pbuz2_derefidx_vbuc1_band_pbuz3_derefidx_vbuc2",
            "pbuz1_derefidx_vbuaa=pbuz2_derefidx_vbuc1_band_pbuz3_derefidx_vbuc2",
            "pbuc1_derefidx_pbuz1_derefidx_vbuc2=pbuz1_derefidx_vbuc3");
      testFragments("fragments-complex", signaturesComplex);
   }

   @Test
   public void testFragmentsExist() {
      testFragmentExists("vbuaa=pbuc2_derefidx_vbuxx");
      testFragmentExists("pwsc1_derefidx_vbuxx=vwsc2");
      testFragmentExists("pwsc1_derefidx_vbuyy=vwsc2");
      testFragmentExists("pwsc1_derefidx_vbuxx=pwsc1_derefidx_vbuxx_minus_vwsc2");
      testFragmentExists("pwsc1_derefidx_vbuyy=pwsc1_derefidx_vbuyy_minus_vwsc2");
      testFragmentExists("pwsc1_derefidx_vbuxx=pwsc1_derefidx_vbuxx_minus_vbuz1");
      testFragmentExists("pwsc1_derefidx_vbuyy=pwsc1_derefidx_vbuyy_minus_vbuz1");
      testFragmentExists("pbuc1_derefidx_vbuxx=pbuc1_derefidx_vbuxx_plus_vbuaa");
      testFragmentExists("vbsaa=pbsc1_derefidx_vbsxx_minus_pbsc1_derefidx_vbsyy");
      testFragmentExists("vbsaa=pbsc1_derefidx_vbsxx_minus_pbsc2_derefidx_vbsxx");
      testFragmentExists("vbsaa=pbsc1_derefidx_vbsxx_minus_pbsc2_derefidx_vbsyy");
      testFragmentExists("vbsaa=pbsc1_derefidx_vbsxx_plus_pbsc1_derefidx_vbsxx");
      testFragmentExists("vbsaa=pbsc1_derefidx_vbsxx_plus_pbsc1_derefidx_vbsyy");
      testFragmentExists("vbsaa=pbsc1_derefidx_vbsxx_plus_pbsc2_derefidx_vbsyy");

      testFragmentExists("vbsaa=pbsc1_derefidx_vbsxx_plus_pbsc2_derefidx_vbsyy");
      testFragmentExists("vbsaa=pbsc1_derefidx_vbsyy_minus_pbsc1_derefidx_vbsyy");
      testFragmentExists("vbsaa=pbsc1_derefidx_vbsyy_minus_pbsc2_derefidx_vbsxx");
      testFragmentExists("vbsaa=pbsc1_derefidx_vbsyy_minus_pbsc2_derefidx_vbsyy");
      testFragmentExists("vbsaa=pbsc1_derefidx_vbsyy_plus_pbsc2_derefidx_vbsxx");
      testFragmentExists("vbsaa=pbsc1_derefidx_vbsyy_plus_pbsc2_derefidx_vbsyy");
      testFragmentExists("vbsaa=pbsc1_derefidx_vbsxx_minus_pbsc1_derefidx_vbsxx");
      testFragmentExists("vbsaa=vbsaa_minus_pbsc1_derefidx_vbsyy");
      testFragmentExists("vbsaa=vbsaa_plus_pbsc1_derefidx_vbsxx");

      testFragmentExists("vwuz1=pbuc1_derefidx_vbsxx_word_pbuc2_derefidx_vbsxx");
      testFragmentExists("vwuz1=pbuc1_derefidx_vbsyy_word_pbuc2_derefidx_vbsyy");

      testFragmentExists("vwuz1=pbuc1_derefidx_vbsyy_word_pbuc2_derefidx_vbsyy");

      testFragmentExists("vbsaa=pbsc1_derefidx_vbsz1_minus_pbsc1_derefidx_vbsz2");
      testFragmentExists("vbsaa=pbsc1_derefidx_vbsxx_minus_pbsc1_derefidx_vbsyy");
      testFragmentExists("vbuz1=pbuz2_derefidx_vbuz3_plus_pbuz4_derefidx_pbuz5_derefidx_vbuz3");
      testFragmentExists("vbuz1=pbuz2_derefidx_pbuz3_derefidx_vbuz4_plus_pbuz5_derefidx_pbuz6_derefidx_vbuz4");

   }

   /**
    * Test that a specific fragment can be succesfully loaded/synthesized
    *
    * @param signature The fragment signature
    */
   private void testFragmentExists(String signature) {
      AsmFragmentTemplateSynthesizer.initialize("src/main/fragment/");
      CompileLog log = new CompileLog();
      log.setSysOut(true);
      //log.setVerboseFragmentLog(true);
      List<AsmFragmentTemplate> templates =
            new ArrayList<>(AsmFragmentTemplateSynthesizer.getFragmentTemplates(signature, log));
      if(templates.size() > 0) {
         log.append("");
         for(AsmFragmentTemplate template : templates) {
            AsmFragmentTemplateUsages.logTemplate(log, template, "");
         }
         log.append("");
      }
      assertTrue("Fragment cannot be synthesized " + signature, templates.size() > 0);
   }


   private void testFragments(String fileName, Collection<String> signatures) throws IOException {
      AsmFragmentTemplateSynthesizer.initialize("src/main/fragment/");
      CompileLog log = new CompileLog();
      List<String> sigs = new ArrayList<>(signatures);

      // Always test max 1000 signatures
      for(int testStep = 0; testStep < 1000; testStep++) {

         // Calculate the index
         int testIdx = (sigs.size() * testStep) / 1000;
         if(testIdx < testStep) testIdx = testStep;
         if(testStep > sigs.size() - 1) break;

         if((testStep % 100) == 0)
            System.out.println("Testing " + testIdx + "/" + sigs.size());

         String signature = sigs.get(testIdx);

         List<AsmFragmentTemplate> templates =
               new ArrayList<>(AsmFragmentTemplateSynthesizer.getFragmentTemplates(signature, log));
         Collections.sort(templates, Comparator.comparing(AsmFragmentTemplate::getClobber));
         if(templates.size() == 0) {
            log.append("CANNOT SYNTHESIZE " + signature);
         }

         for(AsmFragmentTemplate template : templates) {
            log.append((template.isFile() ? "*" : "") + template.getName() + " - clobber:" + template.getClobber().toString() + " cycles:" + template.getCycles());
            log.append("  " + template.getBody().replace("\n", "\n  "));
         }
      }
      // Print some information about the testing to stdout
      System.gc();
      Runtime rt = Runtime.getRuntime();
      long usedMB = (rt.totalMemory() - rt.freeMemory()) / 1024 / 1024;
      System.out.println("Synthesizer Graph Size: " + AsmFragmentTemplateSynthesizer.getSize() + " mem: " + usedMB);

      ReferenceHelper helper = new ReferenceHelperFolder("src/test/ref/");
      boolean success = helper.testOutput(fileName, ".log", log.toString());
      if(!success) {
         fail("Output does not match reference!");
      }
   }


   private Collection<String> assignmentsBu() {
      ArrayList<String> signatures = new ArrayList<>();
      Collection<Value> lVals = lValuesBu(new ArrayList<>());
      for(Value lValue : lVals) {
         Collection<Value> rVals = rValuesBu(lValue.getAllValues());
         for(Value rValue : rVals) {
            signatures.add(lValue.getSignature() + "=" + rValue.getSignature());
         }
      }
      return signatures;
   }


   private Collection<String> assignmentsUnaryBu() {
      ArrayList<String> signatures = new ArrayList<>();
      Collection<Value> lVals = lValuesBu(new ArrayList<>());
      for(Value lValue : lVals) {
         Collection<Value> rVals = rValuesBu(lValue.getAllValues());
         for(Value rValue : rVals) {
            for(String unary : unaryBu()) {
               signatures.add(lValue.getSignature() + "=" + unary + rValue.getSignature());
            }
         }
      }
      return signatures;
   }

   private Collection<String> assignmentsBinaryBu(Value lValue) {
      ArrayList<String> signatures = new ArrayList<>();
      Collection<Value> rVal1s = rValuesBu(lValue.getAllValues());
      for(Value rVal1 : rVal1s) {
         ArrayList<Value> used = new ArrayList<>();
         used.addAll(lValue.getAllValues());
         used.addAll(rVal1.getAllValues());
         Collection<Value> rVal2s = rValuesBu(used);
         for(Value rVal2 : rVal2s) {
            for(String binary : binaryBu()) {
               signatures.add(lValue.getSignature() + "=" + rVal1.getSignature() + binary + rVal2.getSignature());
            }
         }
      }
      return signatures;
   }

   private Collection<String> unaryBu() {
      ArrayList<String> unaries = new ArrayList<>();
      unaries.add(Operators.BOOL_NOT.getAsmOperator());
      unaries.add(Operators.DECREMENT.getAsmOperator());
      unaries.add(Operators.INCREMENT.getAsmOperator());
      unaries.add(Operators.NEG.getAsmOperator());
      unaries.add(Operators.POS.getAsmOperator());
      return unaries;
   }

   private Collection<String> binaryBu() {
      ArrayList<String> unaries = new ArrayList<>();
      unaries.add(Operators.BOOL_AND.getAsmOperator());
      unaries.add(Operators.BOOL_OR.getAsmOperator());
      unaries.add(Operators.BOOL_XOR.getAsmOperator());
      unaries.add(Operators.MINUS.getAsmOperator());
      unaries.add(Operators.PLUS.getAsmOperator());
      return unaries;
   }


   private Collection<Value> lValuesBu(Collection<Value> usedValues) {
      ArrayList<Value> values = new ArrayList<>();
      values.addAll(lValuesVbu(usedValues));
      Collection<Value> pbus = rValuesPbu(usedValues);
      for(Value pbu : pbus) {
         values.add(new Value("_deref_" + pbu.getSignature(), pbu));
      }
      for(Value pbu : pbus) {
         Collection<Value> used = new ArrayList<>();
         used.addAll(usedValues);
         used.addAll(pbu.getAllValues());
         Collection<Value> idxs = rValuesVbu(used);
         for(Value idx : idxs) {
            values.add(new Value(pbu.getSignature() + "_derefidx_" + idx.getSignature(), Arrays.asList(pbu, idx)));
         }
      }
      return values;
   }

   private Collection<Value> rValuesBu(Collection<Value> usedValues) {
      ArrayList<Value> values = new ArrayList<>();
      values.addAll(lValuesBu(usedValues));
      values.add(new Value("vbuc1"));
      if(contains(usedValues, "c1")) {
         values.add(new Value("vbuc2"));
      }
      if(contains(usedValues, "c2")) {
         values.add(new Value("vbuc3"));
      }
      if(contains(usedValues, "c3")) {
         values.add(new Value("vbuc4"));
      }
      if(contains(usedValues, "c4")) {
         values.add(new Value("vbuc5"));
      }
      if(contains(usedValues, "c5")) {
         values.add(new Value("vbuc6"));
      }
      return values;
   }

   private Collection<Value> lValuesVbu(Collection<Value> usedValues) {
      ArrayList<Value> values = new ArrayList<>();
      values.add(new Value("vbuaa"));
      values.add(new Value("vbuxx"));
      values.add(new Value("vbuyy"));
      values.add(new Value("vbuz1"));
      if(contains(usedValues, "z1")) {
         values.add(new Value("vbuz2"));
      }
      if(contains(usedValues, "z2")) {
         values.add(new Value("vbuz3"));
      }
      if(contains(usedValues, "z3")) {
         values.add(new Value("vbuz4"));
      }
      if(contains(usedValues, "z4")) {
         values.add(new Value("vbuz5"));
      }
      if(contains(usedValues, "z5")) {
         values.add(new Value("vbuz6"));
      }
      return values;
   }

   private Collection<Value> rValuesVbu(Collection<Value> usedValues) {
      ArrayList<Value> values = new ArrayList<>();
      values.addAll(lValuesVbu(usedValues));
      values.add(new Value("vbuc1"));
      if(contains(usedValues, "c1")) {
         values.add(new Value("vbuc2"));
      }
      if(contains(usedValues, "c2")) {
         values.add(new Value("vbuc3"));
      }
      if(contains(usedValues, "c3")) {
         values.add(new Value("vbuc4"));
      }
      if(contains(usedValues, "c4")) {
         values.add(new Value("vbuc5"));
      }
      if(contains(usedValues, "c5")) {
         values.add(new Value("vbuc6"));
      }

      return values;
   }

   private Collection<Value> lValuesPbu(Collection<Value> usedValues) {
      ArrayList<Value> values = new ArrayList<>();
      values.add(new Value("pbuz1"));
      if(contains(usedValues, "z1")) {
         values.add(new Value("pbuz2"));
      }
      if(contains(usedValues, "z2")) {
         values.add(new Value("pbuz3"));
      }
      if(contains(usedValues, "z3")) {
         values.add(new Value("pbuz4"));
      }
      if(contains(usedValues, "z4")) {
         values.add(new Value("pbuz5"));
      }
      if(contains(usedValues, "z5")) {
         values.add(new Value("pbuz6"));
      }
      return values;
   }

   private Collection<Value> rValuesPbu(Collection<Value> usedValues) {
      ArrayList<Value> values = new ArrayList<>();
      values.addAll(lValuesPbu(usedValues));
      values.add(new Value("pbuc1"));
      if(contains(usedValues, "c1")) {
         values.add(new Value("pbuc2"));
      }
      if(contains(usedValues, "c2")) {
         values.add(new Value("pbuc3"));
      }
      if(contains(usedValues, "c3")) {
         values.add(new Value("pbuc4"));
      }
      if(contains(usedValues, "c4")) {
         values.add(new Value("pbuc5"));
      }
      if(contains(usedValues, "c5")) {
         values.add(new Value("pbuc6"));
      }
      return values;
   }

   private boolean contains(Collection<Value> usedValues, String subString) {
      for(Value usedValue : usedValues) {
         if(usedValue.getSignature().contains(subString)) {
            return true;
         }
      }
      return false;
   }

   /** A signature that is part of a fragment signature. The signature may have sub-values (eg. if. it is a _derefidx_ signature */
   public static class Value {

      private String signature;

      private Collection<Value> subValues;

      public Value(String signature) {
         this(signature, new ArrayList<Value>());
      }

      public Value(String signature, Collection<Value> subValues) {
         this.signature = signature;
         this.subValues = subValues;
      }

      public Value(String signature, Value subVal) {
         this(signature, Arrays.asList(subVal));
      }


      public String getSignature() {
         return signature;
      }

      public Collection<Value> getAllValues() {
         ArrayList<Value> values = new ArrayList<>();
         values.add(this);
         if(subValues != null) {
            values.addAll(subValues);
         }
         return values;
      }

   }

}

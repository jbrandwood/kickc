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
import java.net.URISyntaxException;
import java.util.*;

import static junit.framework.TestCase.fail;

/** Test the ASM fragment sub-system by loading/synthesizing a lot of different fragments and comparing with reference fragments. */
public class TestFragments {

   @BeforeClass
   public static void setUp() {
      AsmFragmentTemplateSynthesizer.clearCaches();
   }

   @AfterClass
   public static void tearDown() throws Exception {
      CompileLog log = new CompileLog();
      log.setSysOut(true);
      AsmFragmentTemplateUsages.logUsages(log, false, false,  false, false, false, false);
   }

   /*

   @Test
   public void testAssignmentsBu() throws IOException, URISyntaxException {
      testFragments("fragments-assignment-copy", assignmentsBu());
   }

   @Test
   public void testAssignmentsUnaryBu() throws IOException, URISyntaxException {
      testFragments("fragments-assignment-unary", assignmentsUnaryBu());
   }

   @Test
   public void testAssignmentsBinaryBu() throws IOException, URISyntaxException {
      testFragments("fragments-assignment-binary", assignmentsBinaryBu());
   }

   private void testFragments(String fileName, Collection<String> signatures) throws IOException, URISyntaxException {
      CompileLog log = new CompileLog();
      int cnt = 0;
      for(String signature : signatures) {
         if(++cnt % 1000 == 0) System.out.println(""+cnt+"/"+signatures.size());
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
      ReferenceHelper helper = new ReferenceHelper("dk/camelot64/kickc/test/ref/");
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

   private Collection<String> assignmentsBinaryBu() {
      ArrayList<String> signatures = new ArrayList<>();
      Collection<Value> lVals = lValuesBu(new ArrayList<>());
      for(Value lValue : lVals) {
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

   */

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

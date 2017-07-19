package dk.camelot64.kickc.test;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.ObjectReader;
import com.fasterxml.jackson.databind.ObjectWriter;
import dk.camelot64.kickc.icl.*;
import dk.camelot64.kickc.icl.jackson.IclJacksonFactory;
import junit.framework.TestCase;

import java.io.IOException;
import java.util.ArrayList;

/** Test JSON serialization of the KickC ICL  */
public class TestIclJson extends TestCase {

   public void testJsonVariable() throws IOException {
      VariableUnversioned v1 = new VariableUnversioned("v1", null, SymbolTypeBasic.BYTE);
      String json = "{\"@type\":\"variable_unversioned\",\"name\":\"v1\",\"type\":{\"@type\":\"basic\",\"typeName\":\"byte\"},\"nextVersionNumber\":0,\"inferredType\":false}";
      assertJsonSerialization(v1, json, Variable.class);
   }

   public void testJsonScopeSimple() throws IOException {
      Scope scope = new ProgramScope();
      VariableUnversioned v1 = scope.addVariable("v1", SymbolTypeBasic.BYTE);
      v1.createVersion();
      scope.addVariableIntermediate();
      scope.addVariable("v2", new SymbolTypePointer(SymbolTypeBasic.BYTE));
      scope.addVariable("v3", new SymbolTypeArray(SymbolTypeBasic.WORD, 4));
      scope.addLabel("main");
      scope.addLabelIntermediate();
      String json = "{\"@type\":\"program\",\"name\":\"\",\"symbols\":{\"v1\":{\"@type\":\"variable_unversioned\",\"name\":\"v1\",\"type\":{\"@type\":\"basic\",\"typeName\":\"byte\"},\"nextVersionNumber\":1,\"inferredType\":false},\"v1#0\":{\"@type\":\"variable_versioned\",\"name\":\"v1#0\",\"type\":{\"@type\":\"basic\",\"typeName\":\"byte\"},\"versionOfName\":\"v1\",\"inferredType\":false},\"$0\":{\"@type\":\"variable_intermediate\",\"name\":\"$0\",\"type\":{\"@type\":\"basic\",\"typeName\":\"var\"},\"inferredType\":false},\"v2\":{\"@type\":\"variable_unversioned\",\"name\":\"v2\",\"type\":{\"@type\":\"pointer\",\"elementType\":{\"@type\":\"basic\",\"typeName\":\"byte\"}},\"nextVersionNumber\":0,\"inferredType\":false},\"v3\":{\"@type\":\"variable_unversioned\",\"name\":\"v3\",\"type\":{\"@type\":\"array\",\"elementType\":{\"@type\":\"basic\",\"typeName\":\"word\"},\"size\":4},\"nextVersionNumber\":0,\"inferredType\":false},\"main\":{\"@type\":\"label\",\"name\":\"main\",\"intermediate\":false},\"@1\":{\"@type\":\"label\",\"name\":\"@1\",\"intermediate\":true}},\"intermediateVarCount\":1,\"intermediateLabelCount\":2,\"allocation\":null}";
      assertJsonSerialization(scope, json, Scope.class);
   }

   public void testJsonScopeProcedure() throws IOException {
      Scope scope = new ProgramScope();
      Procedure procedure = scope.addProcedure("main", SymbolTypeBasic.VOID);
      procedure.addVariable("v2", SymbolTypeBasic.BYTE);
      ArrayList<Variable> parameters = new ArrayList<>();
      parameters.add(new VariableUnversioned("p1", procedure, SymbolTypeBasic.BYTE));
      parameters.add(new VariableUnversioned("p2", procedure, SymbolTypeBasic.BOOLEAN));
      procedure.setParameters(parameters);
      String json = "{\"@type\":\"program\",\"name\":\"\",\"symbols\":{\"main\":{\"@type\":\"procedure\",\"name\":\"main\",\"parameterNames\":[\"p1\",\"p2\"],\"symbols\":{\"v2\":{\"@type\":\"variable_unversioned\",\"name\":\"v2\",\"type\":{\"@type\":\"basic\",\"typeName\":\"byte\"},\"nextVersionNumber\":0,\"inferredType\":false},\"p1\":{\"@type\":\"variable_unversioned\",\"name\":\"p1\",\"type\":{\"@type\":\"basic\",\"typeName\":\"byte\"},\"nextVersionNumber\":0,\"inferredType\":false},\"p2\":{\"@type\":\"variable_unversioned\",\"name\":\"p2\",\"type\":{\"@type\":\"basic\",\"typeName\":\"boolean\"},\"nextVersionNumber\":0,\"inferredType\":false}},\"intermediateVarCount\":0,\"intermediateLabelCount\":1,\"returnType\":{\"@type\":\"basic\",\"typeName\":\"void\"}}},\"intermediateVarCount\":0,\"intermediateLabelCount\":1,\"allocation\":null}";
      assertJsonSerialization(scope, json, Scope.class);
   }



   public static void assertJsonSerialization(
         Object object,
         String json,
         Class deserializeClass) throws IOException {
      ObjectMapper jsonMapper = IclJacksonFactory.getMapper();
      ObjectWriter jsonWriter = jsonMapper.writer();
      String serialized = jsonWriter.writeValueAsString(object);
      System.out.println(serialized);
      TestCase.assertEquals("Serialized Object and Reference Serialized", json, serialized);
      ObjectReader reader = jsonMapper.readerFor(deserializeClass);
      Object deserialized = reader.readValue(json);
      TestCase.assertEquals("Deserialized Object and Reference Object", object, deserialized);
      Object redeserialized = reader.readValue(serialized);
      TestCase.assertEquals("Re-serialized Object and Reference Object", object, redeserialized);
   }

}

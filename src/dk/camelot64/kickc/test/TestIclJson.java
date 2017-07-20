package dk.camelot64.kickc.test;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.ObjectReader;
import com.fasterxml.jackson.databind.ObjectWriter;
import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.Compiler;
import dk.camelot64.kickc.icl.*;
import dk.camelot64.kickc.icl.jackson.IclJacksonFactory;
import dk.camelot64.kickc.parser.KickCParser;
import junit.framework.TestCase;
import org.antlr.v4.runtime.ANTLRInputStream;

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

   public void testJsonStmtAssignment() throws IOException {
      VariableUnversioned v1 = new VariableUnversioned("v1", null, SymbolTypeBasic.BYTE);
      VariableUnversioned v2 = new VariableUnversioned("v2", null, SymbolTypeBasic.BYTE);
      VariableUnversioned v3 = new VariableUnversioned("v3", null, SymbolTypeBasic.BYTE);
      StatementAssignment statement = new StatementAssignment(v1.getRef(), v2.getRef(), new Operator("+"), v3.getRef());
      String json = "{\"@type\":\"assign\",\"lValue\":{\"@type\":\"varref\",\"fullName\":\"v1\"},\"rValue1\":{\"@type\":\"varref\",\"fullName\":\"v2\"},\"operator\":{\"operator\":\"+\"},\"rValue2\":{\"@type\":\"varref\",\"fullName\":\"v3\"}}";
      assertJsonSerialization(statement, json, Statement.class);
   }

   public void testJsonStmtPhi() throws IOException {
      VariableUnversioned v1 = new VariableUnversioned("v1", null, SymbolTypeBasic.BYTE);
      VariableUnversioned v2 = new VariableUnversioned("v2", null, SymbolTypeBasic.BYTE);
      VariableUnversioned v3 = new VariableUnversioned("v3", null, SymbolTypeBasic.BYTE);
      Label b1 = new Label("B1", false);
      Label b2 = new Label("B2", false);
      StatementPhi statement = new StatementPhi(v1.getRef());
      statement.addPreviousVersion(b1.getRef(), v2.getRef());
      statement.addPreviousVersion(b2.getRef(), v3.getRef());
      String json = "{\"@type\":\"phi\",\"lValue\":{\"@type\":\"varref\",\"fullName\":\"v1\"},\"previousVersions\":[{\"block\":{\"@type\":\"labelref\",\"fullName\":\"B1\"},\"rValue\":{\"@type\":\"varref\",\"fullName\":\"v2\"}},{\"block\":{\"@type\":\"labelref\",\"fullName\":\"B2\"},\"rValue\":{\"@type\":\"varref\",\"fullName\":\"v3\"}}]}";
      assertJsonSerialization(statement, json, Statement.class);
   }

   public void testJsonCode() throws IOException {
      String minProgram = "byte b=0;byte c=b;";
      Compiler compiler = new Compiler();
      CompileLog log = new CompileLog();
      KickCParser.FileContext file = compiler.pass0ParseInput(new ANTLRInputStream(minProgram), log);
      Program program = compiler.pass1GenerateSSA(file, log);
      String json = "{\"scope\":{\"@type\":\"program\",\"name\":\"\",\"symbols\":{\"b\":{\"@type\":\"variable_unversioned\",\"name\":\"b\",\"type\":{\"@type\":\"basic\",\"typeName\":\"byte\"},\"nextVersionNumber\":1,\"inferredType\":false},\"c\":{\"@type\":\"variable_unversioned\",\"name\":\"c\",\"type\":{\"@type\":\"basic\",\"typeName\":\"byte\"},\"nextVersionNumber\":1,\"inferredType\":false},\"@BEGIN\":{\"@type\":\"label\",\"name\":\"@BEGIN\",\"intermediate\":false},\"@END\":{\"@type\":\"label\",\"name\":\"@END\",\"intermediate\":false},\"b#0\":{\"@type\":\"variable_versioned\",\"name\":\"b#0\",\"type\":{\"@type\":\"basic\",\"typeName\":\"byte\"},\"versionOfName\":\"b\",\"inferredType\":false},\"c#0\":{\"@type\":\"variable_versioned\",\"name\":\"c#0\",\"type\":{\"@type\":\"basic\",\"typeName\":\"byte\"},\"versionOfName\":\"c\",\"inferredType\":false}},\"intermediateVarCount\":0,\"intermediateLabelCount\":1,\"allocation\":null},\"graph\":{\"blocks\":{\"@BEGIN\":{\"label\":{\"@type\":\"labelref\",\"fullName\":\"@BEGIN\"},\"statements\":[{\"@type\":\"assign\",\"lValue\":{\"@type\":\"varref\",\"fullName\":\"b#0\"},\"rValue1\":null,\"operator\":null,\"rValue2\":{\"@type\":\"integer\",\"number\":0}},{\"@type\":\"assign\",\"lValue\":{\"@type\":\"varref\",\"fullName\":\"c#0\"},\"rValue1\":null,\"operator\":null,\"rValue2\":{\"@type\":\"varref\",\"fullName\":\"b#0\"}}],\"defaultSuccessor\":{\"@type\":\"labelref\",\"fullName\":\"@END\"},\"conditionalSuccessor\":null,\"callSuccessor\":null},\"@END\":{\"label\":{\"@type\":\"labelref\",\"fullName\":\"@END\"},\"statements\":[],\"defaultSuccessor\":null,\"conditionalSuccessor\":null,\"callSuccessor\":null}},\"firstBlockRef\":{\"@type\":\"labelref\",\"fullName\":\"@BEGIN\"},\"sequence\":null}}";
      assertJsonSerialization(program, json, Program.class);
   }

   public void testJsonCodeFib() throws IOException {
      String minProgram = "byte n1 = 0; byte n2 = 1; byte i = 12; byte fib = 0; while(i>0) { fib = n1 + n2; n1 = n2; n2 = fib; i = i - 1; }";
      Compiler compiler = new Compiler();
      CompileLog log = new CompileLog();
      KickCParser.FileContext file = compiler.pass0ParseInput(new ANTLRInputStream(minProgram), log);
      Program program = compiler.pass1GenerateSSA(file, log);
      String json = "{\"scope\":{\"@type\":\"program\",\"name\":\"\",\"symbols\":{\"n1\":{\"@type\":\"variable_unversioned\",\"name\":\"n1\",\"type\":{\"@type\":\"basic\",\"typeName\":\"byte\"},\"nextVersionNumber\":5,\"inferredType\":false},\"n2\":{\"@type\":\"variable_unversioned\",\"name\":\"n2\",\"type\":{\"@type\":\"basic\",\"typeName\":\"byte\"},\"nextVersionNumber\":5,\"inferredType\":false},\"i\":{\"@type\":\"variable_unversioned\",\"name\":\"i\",\"type\":{\"@type\":\"basic\",\"typeName\":\"byte\"},\"nextVersionNumber\":5,\"inferredType\":false},\"fib\":{\"@type\":\"variable_unversioned\",\"name\":\"fib\",\"type\":{\"@type\":\"basic\",\"typeName\":\"byte\"},\"nextVersionNumber\":2,\"inferredType\":false},\"@1\":{\"@type\":\"label\",\"name\":\"@1\",\"intermediate\":true},\"@2\":{\"@type\":\"label\",\"name\":\"@2\",\"intermediate\":true},\"@3\":{\"@type\":\"label\",\"name\":\"@3\",\"intermediate\":true},\"$0\":{\"@type\":\"variable_intermediate\",\"name\":\"$0\",\"type\":{\"@type\":\"basic\",\"typeName\":\"boolean\"},\"inferredType\":true},\"$1\":{\"@type\":\"variable_intermediate\",\"name\":\"$1\",\"type\":{\"@type\":\"basic\",\"typeName\":\"byte\"},\"inferredType\":true},\"$2\":{\"@type\":\"variable_intermediate\",\"name\":\"$2\",\"type\":{\"@type\":\"basic\",\"typeName\":\"byte\"},\"inferredType\":true},\"@BEGIN\":{\"@type\":\"label\",\"name\":\"@BEGIN\",\"intermediate\":false},\"@END\":{\"@type\":\"label\",\"name\":\"@END\",\"intermediate\":false},\"@4\":{\"@type\":\"label\",\"name\":\"@4\",\"intermediate\":true},\"@5\":{\"@type\":\"label\",\"name\":\"@5\",\"intermediate\":true},\"@6\":{\"@type\":\"label\",\"name\":\"@6\",\"intermediate\":true},\"n1#0\":{\"@type\":\"variable_versioned\",\"name\":\"n1#0\",\"type\":{\"@type\":\"basic\",\"typeName\":\"byte\"},\"versionOfName\":\"n1\",\"inferredType\":false},\"n2#0\":{\"@type\":\"variable_versioned\",\"name\":\"n2#0\",\"type\":{\"@type\":\"basic\",\"typeName\":\"byte\"},\"versionOfName\":\"n2\",\"inferredType\":false},\"i#0\":{\"@type\":\"variable_versioned\",\"name\":\"i#0\",\"type\":{\"@type\":\"basic\",\"typeName\":\"byte\"},\"versionOfName\":\"i\",\"inferredType\":false},\"fib#0\":{\"@type\":\"variable_versioned\",\"name\":\"fib#0\",\"type\":{\"@type\":\"basic\",\"typeName\":\"byte\"},\"versionOfName\":\"fib\",\"inferredType\":false},\"fib#1\":{\"@type\":\"variable_versioned\",\"name\":\"fib#1\",\"type\":{\"@type\":\"basic\",\"typeName\":\"byte\"},\"versionOfName\":\"fib\",\"inferredType\":false},\"n1#1\":{\"@type\":\"variable_versioned\",\"name\":\"n1#1\",\"type\":{\"@type\":\"basic\",\"typeName\":\"byte\"},\"versionOfName\":\"n1\",\"inferredType\":false},\"n2#1\":{\"@type\":\"variable_versioned\",\"name\":\"n2#1\",\"type\":{\"@type\":\"basic\",\"typeName\":\"byte\"},\"versionOfName\":\"n2\",\"inferredType\":false},\"i#1\":{\"@type\":\"variable_versioned\",\"name\":\"i#1\",\"type\":{\"@type\":\"basic\",\"typeName\":\"byte\"},\"versionOfName\":\"i\",\"inferredType\":false},\"i#2\":{\"@type\":\"variable_versioned\",\"name\":\"i#2\",\"type\":{\"@type\":\"basic\",\"typeName\":\"byte\"},\"versionOfName\":\"i\",\"inferredType\":false},\"n1#2\":{\"@type\":\"variable_versioned\",\"name\":\"n1#2\",\"type\":{\"@type\":\"basic\",\"typeName\":\"byte\"},\"versionOfName\":\"n1\",\"inferredType\":false},\"n2#2\":{\"@type\":\"variable_versioned\",\"name\":\"n2#2\",\"type\":{\"@type\":\"basic\",\"typeName\":\"byte\"},\"versionOfName\":\"n2\",\"inferredType\":false},\"i#3\":{\"@type\":\"variable_versioned\",\"name\":\"i#3\",\"type\":{\"@type\":\"basic\",\"typeName\":\"byte\"},\"versionOfName\":\"i\",\"inferredType\":false},\"i#4\":{\"@type\":\"variable_versioned\",\"name\":\"i#4\",\"type\":{\"@type\":\"basic\",\"typeName\":\"byte\"},\"versionOfName\":\"i\",\"inferredType\":false},\"n2#3\":{\"@type\":\"variable_versioned\",\"name\":\"n2#3\",\"type\":{\"@type\":\"basic\",\"typeName\":\"byte\"},\"versionOfName\":\"n2\",\"inferredType\":false},\"n2#4\":{\"@type\":\"variable_versioned\",\"name\":\"n2#4\",\"type\":{\"@type\":\"basic\",\"typeName\":\"byte\"},\"versionOfName\":\"n2\",\"inferredType\":false},\"n1#3\":{\"@type\":\"variable_versioned\",\"name\":\"n1#3\",\"type\":{\"@type\":\"basic\",\"typeName\":\"byte\"},\"versionOfName\":\"n1\",\"inferredType\":false},\"n1#4\":{\"@type\":\"variable_versioned\",\"name\":\"n1#4\",\"type\":{\"@type\":\"basic\",\"typeName\":\"byte\"},\"versionOfName\":\"n1\",\"inferredType\":false}},\"intermediateVarCount\":3,\"intermediateLabelCount\":7,\"allocation\":null},\"graph\":{\"blocks\":{\"@BEGIN\":{\"label\":{\"@type\":\"labelref\",\"fullName\":\"@BEGIN\"},\"statements\":[{\"@type\":\"assign\",\"lValue\":{\"@type\":\"varref\",\"fullName\":\"n1#0\"},\"rValue1\":null,\"operator\":null,\"rValue2\":{\"@type\":\"integer\",\"number\":0}},{\"@type\":\"assign\",\"lValue\":{\"@type\":\"varref\",\"fullName\":\"n2#0\"},\"rValue1\":null,\"operator\":null,\"rValue2\":{\"@type\":\"integer\",\"number\":1}},{\"@type\":\"assign\",\"lValue\":{\"@type\":\"varref\",\"fullName\":\"i#0\"},\"rValue1\":null,\"operator\":null,\"rValue2\":{\"@type\":\"integer\",\"number\":12}},{\"@type\":\"assign\",\"lValue\":{\"@type\":\"varref\",\"fullName\":\"fib#0\"},\"rValue1\":null,\"operator\":null,\"rValue2\":{\"@type\":\"integer\",\"number\":0}}],\"defaultSuccessor\":{\"@type\":\"labelref\",\"fullName\":\"@1\"},\"conditionalSuccessor\":null,\"callSuccessor\":null},\"@1\":{\"label\":{\"@type\":\"labelref\",\"fullName\":\"@1\"},\"statements\":[{\"@type\":\"phi\",\"lValue\":{\"@type\":\"varref\",\"fullName\":\"n1#3\"},\"previousVersions\":[{\"block\":{\"@type\":\"labelref\",\"fullName\":\"@2\"},\"rValue\":{\"@type\":\"varref\",\"fullName\":\"n1#1\"}},{\"block\":{\"@type\":\"labelref\",\"fullName\":\"@BEGIN\"},\"rValue\":{\"@type\":\"varref\",\"fullName\":\"n1#0\"}}]},{\"@type\":\"phi\",\"lValue\":{\"@type\":\"varref\",\"fullName\":\"n2#3\"},\"previousVersions\":[{\"block\":{\"@type\":\"labelref\",\"fullName\":\"@2\"},\"rValue\":{\"@type\":\"varref\",\"fullName\":\"n2#1\"}},{\"block\":{\"@type\":\"labelref\",\"fullName\":\"@BEGIN\"},\"rValue\":{\"@type\":\"varref\",\"fullName\":\"n2#0\"}}]},{\"@type\":\"phi\",\"lValue\":{\"@type\":\"varref\",\"fullName\":\"i#2\"},\"previousVersions\":[{\"block\":{\"@type\":\"labelref\",\"fullName\":\"@2\"},\"rValue\":{\"@type\":\"varref\",\"fullName\":\"i#1\"}},{\"block\":{\"@type\":\"labelref\",\"fullName\":\"@BEGIN\"},\"rValue\":{\"@type\":\"varref\",\"fullName\":\"i#0\"}}]},{\"@type\":\"assign\",\"lValue\":{\"@type\":\"varref\",\"fullName\":\"$0\"},\"rValue1\":{\"@type\":\"varref\",\"fullName\":\"i#2\"},\"operator\":{\"operator\":\">\"},\"rValue2\":{\"@type\":\"integer\",\"number\":0}},{\"@type\":\"cond\",\"rValue1\":null,\"operator\":null,\"rValue2\":{\"@type\":\"varref\",\"fullName\":\"$0\"},\"destination\":{\"@type\":\"labelref\",\"fullName\":\"@2\"},\"rvalue1\":null,\"rvalue2\":{\"@type\":\"varref\",\"fullName\":\"$0\"}}],\"defaultSuccessor\":{\"@type\":\"labelref\",\"fullName\":\"@4\"},\"conditionalSuccessor\":{\"@type\":\"labelref\",\"fullName\":\"@2\"},\"callSuccessor\":null},\"@2\":{\"label\":{\"@type\":\"labelref\",\"fullName\":\"@2\"},\"statements\":[{\"@type\":\"phi\",\"lValue\":{\"@type\":\"varref\",\"fullName\":\"i#3\"},\"previousVersions\":[{\"block\":{\"@type\":\"labelref\",\"fullName\":\"@1\"},\"rValue\":{\"@type\":\"varref\",\"fullName\":\"i#2\"}},{\"block\":{\"@type\":\"labelref\",\"fullName\":\"@5\"},\"rValue\":{\"@type\":\"varref\",\"fullName\":\"i#4\"}}]},{\"@type\":\"phi\",\"lValue\":{\"@type\":\"varref\",\"fullName\":\"n2#2\"},\"previousVersions\":[{\"block\":{\"@type\":\"labelref\",\"fullName\":\"@1\"},\"rValue\":{\"@type\":\"varref\",\"fullName\":\"n2#3\"}},{\"block\":{\"@type\":\"labelref\",\"fullName\":\"@5\"},\"rValue\":{\"@type\":\"varref\",\"fullName\":\"n2#4\"}}]},{\"@type\":\"phi\",\"lValue\":{\"@type\":\"varref\",\"fullName\":\"n1#2\"},\"previousVersions\":[{\"block\":{\"@type\":\"labelref\",\"fullName\":\"@1\"},\"rValue\":{\"@type\":\"varref\",\"fullName\":\"n1#3\"}},{\"block\":{\"@type\":\"labelref\",\"fullName\":\"@5\"},\"rValue\":{\"@type\":\"varref\",\"fullName\":\"n1#4\"}}]},{\"@type\":\"assign\",\"lValue\":{\"@type\":\"varref\",\"fullName\":\"$1\"},\"rValue1\":{\"@type\":\"varref\",\"fullName\":\"n1#2\"},\"operator\":{\"operator\":\"+\"},\"rValue2\":{\"@type\":\"varref\",\"fullName\":\"n2#2\"}},{\"@type\":\"assign\",\"lValue\":{\"@type\":\"varref\",\"fullName\":\"fib#1\"},\"rValue1\":null,\"operator\":null,\"rValue2\":{\"@type\":\"varref\",\"fullName\":\"$1\"}},{\"@type\":\"assign\",\"lValue\":{\"@type\":\"varref\",\"fullName\":\"n1#1\"},\"rValue1\":null,\"operator\":null,\"rValue2\":{\"@type\":\"varref\",\"fullName\":\"n2#2\"}},{\"@type\":\"assign\",\"lValue\":{\"@type\":\"varref\",\"fullName\":\"n2#1\"},\"rValue1\":null,\"operator\":null,\"rValue2\":{\"@type\":\"varref\",\"fullName\":\"fib#1\"}},{\"@type\":\"assign\",\"lValue\":{\"@type\":\"varref\",\"fullName\":\"$2\"},\"rValue1\":{\"@type\":\"varref\",\"fullName\":\"i#3\"},\"operator\":{\"operator\":\"-\"},\"rValue2\":{\"@type\":\"integer\",\"number\":1}},{\"@type\":\"assign\",\"lValue\":{\"@type\":\"varref\",\"fullName\":\"i#1\"},\"rValue1\":null,\"operator\":null,\"rValue2\":{\"@type\":\"varref\",\"fullName\":\"$2\"}}],\"defaultSuccessor\":{\"@type\":\"labelref\",\"fullName\":\"@1\"},\"conditionalSuccessor\":null,\"callSuccessor\":null},\"@4\":{\"label\":{\"@type\":\"labelref\",\"fullName\":\"@4\"},\"statements\":[],\"defaultSuccessor\":{\"@type\":\"labelref\",\"fullName\":\"@3\"},\"conditionalSuccessor\":null,\"callSuccessor\":null},\"@3\":{\"label\":{\"@type\":\"labelref\",\"fullName\":\"@3\"},\"statements\":[],\"defaultSuccessor\":{\"@type\":\"labelref\",\"fullName\":\"@END\"},\"conditionalSuccessor\":null,\"callSuccessor\":null},\"@5\":{\"label\":{\"@type\":\"labelref\",\"fullName\":\"@5\"},\"statements\":[{\"@type\":\"phi\",\"lValue\":{\"@type\":\"varref\",\"fullName\":\"n1#4\"},\"previousVersions\":[]},{\"@type\":\"phi\",\"lValue\":{\"@type\":\"varref\",\"fullName\":\"n2#4\"},\"previousVersions\":[]},{\"@type\":\"phi\",\"lValue\":{\"@type\":\"varref\",\"fullName\":\"i#4\"},\"previousVersions\":[]}],\"defaultSuccessor\":{\"@type\":\"labelref\",\"fullName\":\"@2\"},\"conditionalSuccessor\":null,\"callSuccessor\":null},\"@6\":{\"label\":{\"@type\":\"labelref\",\"fullName\":\"@6\"},\"statements\":[],\"defaultSuccessor\":{\"@type\":\"labelref\",\"fullName\":\"@3\"},\"conditionalSuccessor\":null,\"callSuccessor\":null},\"@END\":{\"label\":{\"@type\":\"labelref\",\"fullName\":\"@END\"},\"statements\":[],\"defaultSuccessor\":null,\"conditionalSuccessor\":null,\"callSuccessor\":null}},\"firstBlockRef\":{\"@type\":\"labelref\",\"fullName\":\"@BEGIN\"},\"sequence\":null}}";
      assertJsonSerialization(program, json, Program.class);
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

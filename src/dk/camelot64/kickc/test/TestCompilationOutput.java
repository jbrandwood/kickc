package dk.camelot64.kickc.test;

import com.sun.org.apache.xpath.internal.SourceTree;
import com.sun.xml.internal.ws.policy.privateutil.PolicyUtils;
import dk.camelot64.kickc.Compiler;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;

import java.io.*;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

/** Compile a number of source files and compare the resulting assembler with expected output*/
public class TestCompilationOutput {

   private Path tempDir;
   private String testPath;
   private String refPath;

   public TestCompilationOutput() throws IOException {
      testPath = "src/dk/camelot64/kickc/test/";
      refPath = "dk/camelot64/kickc/test/ref/";
      tempDir = Files.createTempDirectory("kickc-output");
   }

   public static void main(String[] args) throws IOException, URISyntaxException {
      TestCompilationOutput tester = new TestCompilationOutput();
      tester.testFile("flipper-rex2");
   }

   private void testFile(String fileName) throws IOException, URISyntaxException {
      String inputPath = testPath + fileName + ".kc";
      System.out.println("Testing output for "+inputPath);
      CharStream input = CharStreams.fromFileName(inputPath);
      Compiler compiler = new Compiler();
      Compiler.CompilationResult output = compiler.compile(input);
      assertOutput(fileName, ".asm", output.getAsmProgram().toString());
      assertOutput(fileName, ".sym", output.getSymbols().getSymbolTableContents());
      assertOutput(fileName, ".cfg", output.getGraph().toString());
      assertOutput(fileName, ".log", output.getLog().toString());
   }

   private void assertOutput(
         String fileName,
         String extension,
         String outputString) throws IOException, URISyntaxException {
      // Read reference file
      List<String> refLines = null;
      try {
         refLines = loadReferenceLines(fileName, extension);
      } catch (Exception e) {
         writeOutputFile(fileName, extension, outputString);
         System.out.println("Error loading reference."+e.getMessage());
         return;
      }
      // Split output into outLines
      List<String> outLines = getOutLines(outputString);
      for (int i = 0; i < outLines.size(); i++) {
         String outLine = outLines.get(i);
         if(refLines.size()>i) {
            String refLine = refLines.get(i);
            if(!outLine.equals(refLine)) {
               System.out.println(
                     "Output does not match reference on line "+i+"\n"+
                           "Reference: "+refLine+"\n"+
                           "Output:    "+outLine
               );
               writeOutputFile(fileName, extension, outputString);
               System.out.println();
               return;
            }
         }
      }
   }

   private List<String> getOutLines(String outputString) throws IOException {
      BufferedReader rdr = new BufferedReader(new StringReader(outputString));
      List<String> outLines = new ArrayList<>();
      for (String line = rdr.readLine(); line != null; line = rdr.readLine()) {
         outLines.add(line);
      }
      rdr.close();
      return outLines;
   }

   private List<String> loadReferenceLines(String fileName, String extension) throws URISyntaxException, IOException {
      String refFile = refPath+fileName+extension;
      ClassLoader classLoader = this.getClass().getClassLoader();
      URL refResource = classLoader.getResource(refFile);
      URI refURI = refResource.toURI();
      return Files.readAllLines(Paths.get(refURI), Charset.defaultCharset());
   }

   private void writeOutputFile(String fileName, String extension, String outputString) throws IOException {
      // Write output file
      File file = new File(tempDir.toFile(), fileName + extension);
      FileOutputStream outputStream = new FileOutputStream(file);
      OutputStreamWriter writer = new OutputStreamWriter(outputStream);
      writer.write(outputString);
      writer.close();
      outputStream.close();
      System.out.println("Output written to " + file.getAbsolutePath());
   }

}
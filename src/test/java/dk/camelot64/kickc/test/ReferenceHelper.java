package dk.camelot64.kickc.test;

import java.io.*;
import java.net.URI;
import java.net.URISyntaxException;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.SQLOutput;
import java.util.ArrayList;
import java.util.List;

/** Helper for handling reference files and output files in tests. */
abstract class ReferenceHelper {

   private static Path tempDir;

   static {
      try {
         tempDir = Files.createTempDirectory("kickc-output");
      } catch (IOException e) {
         e.printStackTrace();
      }
   }

   static Path getTempDir() {
      return tempDir;
   }

   boolean testOutput(
         String fileName,
         String extension,
         String outputString) throws IOException {
      // Read reference file
      List<String> refLines;
      try {
         refLines = loadReferenceLines(fileName, extension);
      } catch (Exception e) {
         writeOutputFile(fileName, extension, outputString);
         System.out.println("Reference file not found "+fileName+extension);
         return false;
      }
      // Split output into outLines
      List<String> outLines = getOutLines(outputString);
      for (int i = 0; i < outLines.size(); i++) {
         String outLine = outLines.get(i);
         if(refLines.size()>i) {
            String refLine = refLines.get(i);
            if(!trimTrailing(outLine).equals(trimTrailing(refLine))) {
               writeOutputFile(fileName, extension, outputString);
               System.out.println(
                     "Output does not match reference on line "+i+"\n"+
                           "Reference: "+refLine+"\n"+
                           "Output:    "+outLine
               );
               return false;
            }
         } else {
            writeOutputFile(fileName, extension, outputString);
            System.out.println(
                  "Output does not match reference on line "+i+"\n"+
                        "Reference: <EOF>\n"+
                        "Output:    "+outLine
            );
            return false;
         }
      }
      return true;
   }

   /**
    * Trim trailing whitespace from a string
    * @param str The string
    * @return a copy of the string with any trailing whitespace removed.
    */
   public String trimTrailing(String str) {
      int len = str.length();
      int st = 0;
      char[] val = str.toCharArray();
      while ((st < len) && (val[len - 1] <= ' ')) {
         len--;
      }
      return str.substring(st, len);
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
      URI refURI = loadReferenceFile(fileName, extension);
      //System.out.println("Reference URI "+refURI.toString());
      Path path = Paths.get(refURI);
      //System.out.println("Reference URI path "+path.toString());
      List<String> allLines = Files.readAllLines(path);
      //System.out.println("Read ref lines "+allLines.size());
      return allLines;
   }

   abstract URI loadReferenceFile(String fileName, String extension) throws IOException, URISyntaxException ;

   File writeOutputFile(String fileName, String extension, String outputString) throws IOException {
      // Write output file
      File file = getTmpFile(fileName, extension);
      FileOutputStream outputStream = new FileOutputStream(file);
      OutputStreamWriter writer = new OutputStreamWriter(outputStream);
      writer.write(outputString);
      writer.close();
      outputStream.close();
      System.out.println("Output written to " + file.getAbsolutePath());
      return file;
   }

   File getTmpFile(String fileName, String extension) {
      File file = new File(tempDir.toFile(), fileName + extension);
      mkPath(file);
      return file;
   }

   /**
    * Ensures that the path to the passed file is created.
    * @param file The file to create a path for
    */
   private void mkPath(File file) {
      Path parent = file.toPath().getParent();
      File dir = parent.toFile();
      if(!dir.exists()) {
         mkPath(dir);
         dir.mkdir();
      }
   }


}

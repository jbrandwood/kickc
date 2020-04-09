package dk.camelot64.kickc;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.TargetPlatform;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;

/**
 * Responsible for loading source files from the relevant search folders.
 */
public class SourceLoader {

   public static File loadFile(String fileName, Path currentPath, Program program) {
      List<String> searchPaths = new ArrayList<>();
      if(currentPath != null)
         searchPaths.add(currentPath.toString());
      searchPaths.addAll(program.getImportPaths());
      for(String importPath : searchPaths) {
         if(!importPath.endsWith("/")) {
            importPath += "/";
         }
         String filePath = importPath + fileName;
         //System.out.println("Looking for file "+filePath);
         File file = new File(filePath);
         if(file.exists()) {
            //System.out.println("Found file "+file.getAbsolutePath()+" in import path "+importPath);
            return file;
         }
      }
      throw new CompileError("File  not found " + fileName);
   }

   public static void loadLinkScriptFile(String fileName, Path currentPath, Program program) {
      try {
         File file = loadFile(fileName, currentPath, program);
         Path filePath = file.toPath();
         String linkScript = new String(Files.readAllBytes(filePath));
         program.setLinkScript(filePath, linkScript);
         program.setTargetPlatform(TargetPlatform.CUSTOM);
      } catch(IOException e) {
         throw new CompileError("Error loading link script file " + fileName, e);
      }
   }

}

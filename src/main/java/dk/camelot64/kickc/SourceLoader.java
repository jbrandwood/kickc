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

   /**
    * Locate a file and load it. Looks through the current path and a set of search folder.
    * @param fileName The file to look for.
    * @param currentPath The current path. May be null.
    * @param searchPaths The search paths to look through if the file is not found in the current path.
    * @return The file if found. null if not.
    */
   public static File loadFile(String fileName, Path currentPath, List<String> searchPaths) {
      List<String> allSearchPaths = new ArrayList<>();
      if(currentPath != null)
         allSearchPaths.add(currentPath.toString());
      allSearchPaths.addAll(searchPaths);
      for(String searchPath : allSearchPaths) {
         if(!searchPath.endsWith("/")) {
            searchPath += "/";
         }
         String filePath = searchPath + fileName;
         //System.out.println("Looking for file "+filePath);
         File file = new File(filePath);
         if(file.exists()) {
            //System.out.println("Found file "+file.getAbsolutePath()+" in import path "+importPath);
            return file;
         }
      }
      // Not found
      return null;
   }

   public static void loadLinkScriptFile(String fileName, Path currentPath, Program program) {
      try {
         File file = loadFile(fileName, currentPath, program.getIncludePaths());
         if(file==null)
            throw new CompileError("File  not found " + fileName);
         Path filePath = file.toPath();
         String linkScript = new String(Files.readAllBytes(filePath));
         program.setLinkScript(filePath, linkScript);
         program.setTargetPlatform(TargetPlatform.CUSTOM);
      } catch(IOException e) {
         throw new CompileError("Error loading link script file " + fileName, e);
      }
   }

}

package dk.camelot64.kickc;

import java.io.File;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;

/**
 * Responsible for loading source files from the relevant search folders.
 */
public class SourceLoader {

   /**
    * Locate a file and load it. Looks through the current path and a set of search folder.
    *
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

   /**
    * Find all files with a specific extension
    *
    * @param currentPath The current folder
    * @param searchPaths The folders to search
    * @param extension The extension to look for (excluding the dot)
    * @return All files in the folders with the given extension.
    */
   public static List<File> listFiles(Path currentPath, List<String> searchPaths, String extension) {
      List<File> allFiles = new ArrayList<>();
      List<String> allSearchPaths = new ArrayList<>();
      if(currentPath != null)
         allSearchPaths.add(currentPath.toString());
      allSearchPaths.addAll(searchPaths);
      for(String searchPath : allSearchPaths) {
         if(!searchPath.endsWith("/")) {
            searchPath += "/";
         }
         final File searchFolder = new File(searchPath);
         if(searchFolder.exists() && searchFolder.isDirectory()) {
            final String[] files = searchFolder.list((dir, name) -> name.endsWith("." + extension));
            if(files != null)
               for(String file : files) {
                  allFiles.add(new File(file));
               }
         }
      }
      return allFiles;
   }

}

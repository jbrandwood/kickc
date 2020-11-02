package dk.camelot64.kickc;

import dk.camelot64.kickc.model.CompileError;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;

/**
 * Manages temporary folders with files.
 * KickAssembler holds open handles to compiled ASM files. Therefore they cannot be deleted immediately after compilation.
 * This manager
 * - supports creation of new temporary folders
 * - attempts deletion on exit
 * - if deletion is not successful the folder paths are saved to a file. The folders in this file is attempted deleted on the next invocation.
 */
public class TmpDirManager {

   /** Singleton manager. */
   public static TmpDirManager MANAGER;

   /**
    * Initialize the singleton manager
    *
    * @param baseFolder The base folder where the TXT file containing dirs to delete will be loaded/saved from.
    */
   public static void init(Path baseFolder) {
      MANAGER = new TmpDirManager(baseFolder);
   }

   /** The base folder where the TXT file containing dirs to delete will be loaded/saved from. */
   private Path baseFolder;

   /** Tmp folders that have been created and not deleted. */
   private List<Path> tmpDirs;

   private TmpDirManager(Path baseFolder) {
      this.baseFolder = baseFolder;
      this.tmpDirs = new ArrayList<>();
   }

   /**
    * Creates a new temporary directory
    *
    * @return The new temporary folder
    */
   public Path newTmpDir() {
      try {
         Path tmpDir = Files.createTempDirectory("kickc");
         this.tmpDirs.add(tmpDir);
         return tmpDir;
      } catch(IOException e) {
         throw new CompileError("Error creating temporary directory. ", e);
      }
   }

   /**
    * Deletes all temporary folders - including any files in the folders.
    * If deletion is not successful the absolute paths are saved to a txt-file to tried again later.
    * This also loads the txt-file with previous failed deletions and retries them
    */
   public void cleanup() {
      try {
         // Attempt deletion of all temporary folders - including all files in the folders
         List<Path> failedDirs = new ArrayList<>();
         for(Path tmpDir : tmpDirs) {
            boolean success = deleteTmpDir(tmpDir);
            if(!success) {
               failedDirs.add(tmpDir);
               //System.out.println("Cannot delete temporary folder, postponing " + tmpDir);
            } else {
               //System.out.println("Successfully deleted temporary folder " + tmpDir);
            }
         }
         // Read postponed file and delete any paths
         File todoFile = baseFolder.resolve(".tmpdirs").toFile();
         if(todoFile.exists()) {
            FileReader todoFileReader = new FileReader(todoFile);
            BufferedReader todoBufferedReader = new BufferedReader(todoFileReader);
            String todoPathAbs = todoBufferedReader.readLine();
            while(todoPathAbs != null) {
               Path todoPath = new File(todoPathAbs).toPath();
               boolean success = deleteTmpDir(todoPath);
               if(!success) {
                  failedDirs.add(todoPath);
                  //System.out.println("Cannot delete postponed temporary folder - postponing again " + todoPathAbs);
               } else {
                  //System.out.println("Successfully deleted postponed temporary folder " + todoPathAbs);
               }
               todoPathAbs = todoBufferedReader.readLine();
            }
            todoBufferedReader.close();
            todoFileReader.close();
         }
         // Delete the old postponed file
         if(todoFile.exists()) {
            if(!todoFile.delete())
               System.err.println("Warning! Cannot delete .tmpdir  file " + todoFile.getAbsolutePath());
            //System.out.println("Deleted old .tmpdir file " + todoFile.getAbsolutePath());
         }
         // Save any failed paths to new postponed file
         if(failedDirs.size() > 0) {
            PrintStream todoPrintStream = new PrintStream(todoFile);
            for(Path failedDir : failedDirs) {
               todoPrintStream.println(failedDir.toAbsolutePath());
            }
            todoPrintStream.close();
            //System.out.println("Saved .tmpdir file with " + failedDirs.size() + " postponed temporary folders " + todoFile.getAbsolutePath());
         }
      } catch(IOException e) {
         throw new CompileError("Error cleaning up temporary files", e);
      }
   }

   private boolean deleteTmpDir(Path tmpDir) {
      // Delete the temporary directory with folders
      boolean success = true;
      String[] entries = tmpDir.toFile().list();
      if(entries != null)
         for(String s : entries) {
            File currentFile = new File(tmpDir.toFile(), s);
            if(!currentFile.delete()) {
               //System.err.println("Warning! Cannot delete temporary file " + currentFile.getAbsolutePath());
               success = false;
               break;
            }
         }
      if(!tmpDir.toFile().delete()) {
         //System.err.println("Warning! Cannot delete temporary folder " + tmpDir.toAbsolutePath());
         success = false;
      }
      return success;
   }

}

package dk.camelot64.kickc.fragment;

import dk.camelot64.kickc.model.InternalError;
import dk.camelot64.kickc.model.TargetCpu;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

/**
 * Capable of creating a hash code that describes the total state of the ASM fragment system.
 * <p>
 * This hash is used to determine whether to use or discard the cache.
 */
public class AsmFragmentSystemHash {

   /** Hash of the fragment source files on any system where a newline is LF. */
   private Long hashLF;

   /** Hash of the fragment source files on any system where a newline is CRLF. */
   private Long hashCRLF;

   /** Last modified date for the fragment source files. */
   private long lastModified;

   public AsmFragmentSystemHash(Long hashLF, Long hashCRLF, long lastModified) {
      this.hashCRLF = hashCRLF;
      this.hashLF = hashLF;
      this.lastModified = lastModified;
   }

   /**
    * Run through the fragment folder and calculate the hash/modify time
    *
    * @param baseFragmentFolder The fragment folder
    * @param allSystems Should hash code be calculated for all systems (both LF and CRLF newlines).
    * If false hash is only calculated for the current system, which is fast.
    * If true calculate for all systems, which requires reading through all files to count newlines - so it is a lot slower.
    * @return The fragment system hash
    */
   public static AsmFragmentSystemHash calculate(Path baseFragmentFolder, boolean allSystems) {
      Long hashLF = 0L;
      Long hashCRLF = 0L;
      long lastModified = 0;
      final TargetCpu.Feature[] cpuFeatures = TargetCpu.Feature.values();
      for(TargetCpu.Feature cpuFeature : cpuFeatures) {
         hashCRLF += cpuFeature.getName().hashCode();
         hashLF += cpuFeature.getName().hashCode();
         final Path cpuFeatureFolder = baseFragmentFolder.resolve(cpuFeature.getName());
         final File cpuFeatureFolderFile = cpuFeatureFolder.toFile();
         if(cpuFeatureFolderFile.exists() && cpuFeatureFolderFile.isDirectory()) {
            final File[] files = cpuFeatureFolderFile.listFiles((dir, name) -> name.endsWith(".asm"));
            if(files != null)
               for(File file : files) {
                  long lengthLF;
                  long lengthCRLF;
                  if(allSystems) {
                     // Calculate length for all systems by reading the file (slow!)
                     int fileNewlines = getFileNewlineCount(file);
                     if(isSystemLF()) {
                        lengthLF = file.length();
                        lengthCRLF = file.length() + fileNewlines;
                     } else {
                        lengthLF = file.length() - fileNewlines;
                        lengthCRLF = file.length();
                     }
                  }  else {
                     // Use filesystem length for current system only - set other to zero (fast!)
                     if(isSystemLF()) {
                        lengthLF = file.length();
                        lengthCRLF = 0;
                     } else {
                        lengthLF = 0;
                        lengthCRLF = file.length();
                     }
                  }
                  hashCRLF += lengthCRLF;
                  hashLF += lengthLF;
                  hashCRLF += file.getName().hashCode();
                  hashLF += file.getName().hashCode();
                  if(file.lastModified() > lastModified)
                     lastModified = file.lastModified();
               }
         }
      }
      // Also hash in all synthesis rules for all CPU's
      for(AsmFragmentTemplateSynthesisRule synthesisRule : AsmFragmentTemplateSynthesisRule.getAllSynthesisRules()) {
         hashCRLF += synthesisRule.hashCode();
         hashLF += synthesisRule.hashCode();
      }
      if(!allSystems) {
         // If not all systems - null out other system hash since it is wrong
         if(isSystemLF())
            hashCRLF = null;
         else
            hashLF = null;
      }
      return new AsmFragmentSystemHash(hashLF, hashCRLF, lastModified);
   }

   /**
    * Get the number of newlines in a file
    * @param file The file to examine
    * @return The number of newline characters
    */
   private static int getFileNewlineCount(File file) {
      int fileNewlines = 0;
      final byte[] fileBytes;
      try {
         fileBytes = Files.readAllBytes(file.toPath());
      } catch(IOException e) {
         throw new InternalError("Error reading ASM fragment file "+file.getAbsolutePath(),e);
      }
      for(int i = 0; i < fileBytes.length; i++) {
         byte fileByte = fileBytes[i];
         if(fileByte=='\n') fileNewlines++;
      }
      return fileNewlines;
   }

   /**
    * Does the current system use LF as newline
    *
    * @return true if the line separator is LF
    */
   static boolean isSystemLF() {
      return System.lineSeparator().length() == 1;
   }

   public String getHashStringLF() {
      return hashLF==null?null:Long.toHexString(hashLF);
   }

   public String getHashStringCRLF() {
      return hashCRLF==null?null:Long.toHexString(hashCRLF);
   }

   /** Determines if this hash mathes the passed hash values.
    * Only examines the value relevant for the current system
    * @param hashLF Hash of the fragment source files on any system where a newline is LF
    * @param hashCRLF Hash of the fragment source files on any system where a newline is CRLF
    * @return true if the hash matches
    */
   public boolean matches(String hashLF, String hashCRLF) {
      if(isSystemLF()) {
         return getHashStringLF().equals(hashLF);
      } else {
         return getHashStringCRLF().equals(hashCRLF);
      }
   }

   public long getLastModified() {
      return lastModified;
   }


}

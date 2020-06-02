package dk.camelot64.kickc.fragment;

import dk.camelot64.kickc.model.TargetCpu;

import java.io.File;
import java.nio.file.Path;

/**
 * Capable of creating a hash code that describes the total state of the ASM fragment system.
 * <p>
 * This hash is used to determine whether to use or discard the cache.
 */
public class AsmFragmentSystemHash {

   /** Hash of the fragment source files. */
   private long hash;

   /** Last modified date for the fragment source files. */
   private long lastModified;


   AsmFragmentSystemHash(long hash, long lastModified) {
      this.lastModified = lastModified;
      this.hash = hash;
   }

   /**
    * Run through the fragment folder and calculate the hash/modify time
    * @param baseFragmentFolder The fragment folder
    * @return The fragment system hash
    */
   public static AsmFragmentSystemHash calculate(Path baseFragmentFolder) {
      long hash = 0;
      long lastModified = 0;
      final TargetCpu.Feature[] cpuFeatures = TargetCpu.Feature.values();
      for(TargetCpu.Feature cpuFeature : cpuFeatures) {
         hash += cpuFeature.getName().hashCode();
         final Path cpuFeatureFolder = baseFragmentFolder.resolve(cpuFeature.getName());
         final File cpuFeatureFolderFile = cpuFeatureFolder.toFile();
         if(cpuFeatureFolderFile.exists() && cpuFeatureFolderFile.isDirectory()) {
            final File[] files = cpuFeatureFolderFile.listFiles((dir, name) -> name.endsWith(".asm"));
            if(files != null)
               for(File file : files) {
                  hash += file.length();
                  hash += file.getName().hashCode();
                  if(file.lastModified() > lastModified)
                     lastModified = file.lastModified();

               }
         }
      }
      return new AsmFragmentSystemHash(hash, lastModified);
   }

   public long getHash() {
      return hash;
   }

   public String getHashString() {
      return Long.toHexString(hash);
   }

   public long getLastModified() {
      return lastModified;
   }
}

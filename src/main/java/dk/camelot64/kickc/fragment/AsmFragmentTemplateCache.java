package dk.camelot64.kickc.fragment;

import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.model.InternalError;
import dk.camelot64.kickc.model.TargetCpu;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;

import java.io.*;
import java.nio.file.Path;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.Map;

/** Cache for ASM fragments. The cache remembers all synthesized fragments allowing for faster access after the first synthesis. */
public class AsmFragmentTemplateCache {

   /** Hash and lastModify information for the fragment system. */
   private AsmFragmentSystemHash fragmentSystemHash;

   /** Name of the sub-folder holding the fragment cache. */
   public static final String CACHE_FOLDER_NAME = "cache";

   /** The folder containing cached fragment files. */
   private Path cacheFolder;

   /** The Target CPU (each CPU has it's own cache). */
   private TargetCpu cpu;

   /** Cache for the best fragment templates. Maps signature to the best fragment template for the signature. Maps to NO_SYNTHESIS if synthesis was unsuccessful. */
   private Map<String, AsmFragmentTemplate> cache;

   /** Detects any modification of the cache. */
   private boolean modified;

   /**
    * Creates a cache
    *
    * @param cpu The target CPU
    */
   private AsmFragmentTemplateCache(Path cacheFolder, TargetCpu cpu, AsmFragmentSystemHash fragmentSystemHash, Map<String, AsmFragmentTemplate> cache) {
      this.cacheFolder = cacheFolder;
      this.cpu = cpu;
      this.fragmentSystemHash = fragmentSystemHash;
      this.cache = cache;
      this.modified = false;
   }

   /** Special singleton representing that the fragment can not be synthesized or loaded. */
   public static AsmFragmentTemplate NO_SYNTHESIS = new AsmFragmentTemplate("NO_SYNTHESIS", "NO_SYNTHESIS", null, false);

   /** Prefix for the fragment hash file header. */
   public static final String HASH_HEADER = "//KICKC FRAGMENT CACHE ";

   /** The prefix for fragment header lines in the fragment cache file. */
   public static final String FRAGMENT_HEADER = "//FRAGMENT ";

   /**
    * Get a cached ASM fragment template
    *
    * @param signature The signature
    * @return The cached ASM fragment template. null if not in the cache. NO_SYNTHESIS if synthesis was unsuccessful.
    */
   public AsmFragmentTemplate get(String signature) {
      return cache.get(signature);
   }

   /**
    * Add an ASM fragment template to the cache
    *
    * @param signature The signature
    * @param asmFragmentTemplate The ASM fragment template.  NO_SYNTHESIS if synthesis was unsuccessful.
    */
   public void put(String signature, AsmFragmentTemplate asmFragmentTemplate) {
      this.cache.put(signature, asmFragmentTemplate);
      this.modified = true;
   }

   public TargetCpu getCpu() {
      return cpu;
   }

   private static String getCacheFileName(TargetCpu cpu) {
      return "fragment-cache-" + cpu.getName() + ".asm";
   }

   /**
    * Creates an empty memory-only fragment cache
    *
    * @param cpu The CPU to make a cache for
    * @return The new empty cache
    */
   public static AsmFragmentTemplateCache memoryCache(TargetCpu cpu) {
      return new AsmFragmentTemplateCache(null, cpu, new AsmFragmentSystemHash(0L, 0L, 0), new LinkedHashMap<>());
   }

   /**
    * Creates a disk fragment cache
    *
    * @param cpu The CPU to make a cache for
    * @return The new empty cache
    */
   public static AsmFragmentTemplateCache diskCache(Path cacheFolder, TargetCpu cpu, AsmFragmentSystemHash fragmentSystemHash, Map<String, AsmFragmentTemplate> cache) {
      return new AsmFragmentTemplateCache(cacheFolder, cpu, fragmentSystemHash, cache);
   }

   /**
    * Attempt to load a fragment cache containing all best synthesized fragments
    *
    * @param baseFragmentFolder Folder containing fragments. (The cache is localed in the sub-folder named "cache)
    * @param log The compile log
    * @return The map with all best fragments from the cache file. null if the cache file is not found.
    */
   public static AsmFragmentTemplateCache load(TargetCpu cpu, Path baseFragmentFolder, CompileLog log) {
      final AsmFragmentSystemHash fragmentSystemHash = AsmFragmentSystemHash.calculate(baseFragmentFolder, false);
      Path cacheFolder = baseFragmentFolder.resolve(CACHE_FOLDER_NAME);
      final Date before = new Date();
      if(!cacheFolder.toFile().exists()) {
         if(log.isVerboseFragmentLog())
            log.append("Creating fragment cache folder " + cacheFolder.toAbsolutePath().toString());
         cacheFolder.toFile().mkdir();
         return diskCache(cacheFolder, cpu, fragmentSystemHash, new LinkedHashMap<>());
      }
      try {
         File cacheFile = cacheFolder.resolve(getCacheFileName(cpu)).toFile();
         if(!cacheFile.exists()) {
            return diskCache(cacheFolder, cpu, fragmentSystemHash, new LinkedHashMap<>());
         }
         if(cacheFile.lastModified() < fragmentSystemHash.getLastModified()) {
            if(log.isVerboseFragmentLog())
               log.append("Deleting outdated fragment cache file " + cacheFile.getAbsolutePath());
            cacheFile.delete();
            return diskCache(cacheFolder, cpu, fragmentSystemHash, new LinkedHashMap<>());
         }
         LinkedHashMap<String, AsmFragmentTemplate> cache = new LinkedHashMap<>();
         BufferedReader fragmentCacheReader = new BufferedReader(new FileReader(cacheFile));
         String hashLine = fragmentCacheReader.readLine();
         final String hashPayload = hashLine.substring(HASH_HEADER.length());
         final String[] hashes = hashPayload.split(" ");
         final String hashLF = hashes[0];
         final String hashCRLF = (hashes.length > 1) ? hashes[1] : null;
         // Compare cache file hash with fragment system hash
         if(!fragmentSystemHash.matches(hashLF, hashCRLF)) {
            // Cache file hash does not match fragment system hash
            if(log.isVerboseFragmentLog())
               log.append("Deleting hash mismatch fragment cache file " + cacheFile.getAbsolutePath());
            cacheFile.delete();
            // And make a new cache to hold the fragments
            return diskCache(cacheFolder, cpu, fragmentSystemHash, new LinkedHashMap<>());
         }
         // Read the first "real" line
         String cacheLine = fragmentCacheReader.readLine();
         StringBuilder body = null;
         String signature = null;
         while(cacheLine != null) {
            // Determine if the line is a new fragment or the continuation of the current fragment body
            if(cacheLine.startsWith(FRAGMENT_HEADER)) {
               // New fragment - first put the current one into the cache
               if(signature != null)
                  addFragment(cache, signature, body, cpu);
               // Clear body and initialize signature
               body = new StringBuilder();
               signature = cacheLine.substring(FRAGMENT_HEADER.length());
            } else {
               // Continuation of body
               body.append(cacheLine).append("\n");
            }
            cacheLine = fragmentCacheReader.readLine();
         }
         // Put the last fragment into the cache
         if(signature != null)
            addFragment(cache, signature, body, cpu);
         final Date after = new Date();
         final long millis = after.getTime() - before.getTime();
         if(log.isVerboseFragmentLog())
            log.append("Loaded cached fragments " + cache.size() + " from " + cacheFile.getPath() + " in " + millis + "ms");
         return diskCache(cacheFolder, cpu, fragmentSystemHash, cache);
      } catch(IOException e) {
         throw new RuntimeException("Error loading fragment cache file " + cacheFolder, e);
      } catch(StringIndexOutOfBoundsException e) {
         throw new RuntimeException("Problem reading fragment file " + cacheFolder, e);
      }
   }

   private static void addFragment(LinkedHashMap<String, AsmFragmentTemplate> cache, String signature, StringBuilder body, TargetCpu targetCpu) {
      final String bodyString = body.toString();
      if(bodyString.startsWith(NO_SYNTHESIS.getBody())) {
         cache.put(signature, NO_SYNTHESIS);
      } else {
         CharStream fragmentCharStream = CharStreams.fromString(bodyString);
         AsmFragmentTemplate template = new AsmFragmentTemplate(signature, AsmFragmentTemplateSynthesizer.fixNewlines(fragmentCharStream.toString()), targetCpu, true);
         cache.put(signature, template);
      }
   }

   /**
    * Attempt to save fragment cache containing all best synthesized fragments
    *
    * @param log The compile log
    */
   public void save(Path baseFragmentFolder, CompileLog log) {
      if(!modified)
         return;
      if(this.cacheFolder == null)
         return;
      Date before = new Date();
      // Calculate a new hash which handles all systems
      final AsmFragmentSystemHash newFragmentSystemHash = AsmFragmentSystemHash.calculate(baseFragmentFolder, true);
      File cacheFile = this.cacheFolder.resolve(getCacheFileName(cpu)).toFile();
      try {
         PrintStream fragmentFilePrint = new PrintStream(cacheFile);
         if(newFragmentSystemHash.getHashStringLF() == null || newFragmentSystemHash.getHashStringCRLF() == null)
            throw new InternalError("Error saving ASM fragment cache file. Not calculated for all systems!");
         fragmentFilePrint.println(HASH_HEADER + newFragmentSystemHash.getHashStringLF() + " " + newFragmentSystemHash.getHashStringCRLF());
         for(String signature : this.cache.keySet()) {
            AsmFragmentTemplate fragmentTemplate = this.cache.get(signature);
            fragmentFilePrint.println(FRAGMENT_HEADER + signature);
            if(fragmentTemplate == NO_SYNTHESIS) {
               fragmentFilePrint.println(NO_SYNTHESIS.getBody());
            } else {
               if(fragmentTemplate.getBody() != null)
                  fragmentFilePrint.println(fragmentTemplate.getBody());
            }
         }
         fragmentFilePrint.close();
         final Date after = new Date();
         final long millis = after.getTime() - before.getTime();
         if(log.isVerboseFragmentLog())
            log.append("Saved cached fragments " + this.cache.size() + " to " + cacheFile.getPath() + " in " + millis + "ms");
      } catch(IOException e) {
         throw new RuntimeException("Error saving fragment cache file " + cacheFile, e);
      } catch(StringIndexOutOfBoundsException e) {
         throw new RuntimeException("Problem saving fragment file " + cacheFile, e);
      }
   }

}

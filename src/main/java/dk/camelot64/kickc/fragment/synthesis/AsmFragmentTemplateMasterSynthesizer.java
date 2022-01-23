package dk.camelot64.kickc.fragment.synthesis;

import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.model.TargetCpu;

import java.nio.file.Path;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * The master synthesizer handles the {@link AsmFragmentTemplateSynthesizer} for each used CPU
 */
public class AsmFragmentTemplateMasterSynthesizer {

   /** Fragment cache folder. Null if a memory cache is used. */
   private final Path cacheFragmentFolder;
   /** Fragment base folder. */
   private final Path baseFragmentFolder;
   /** Use the fragment synthesis cache */
   private boolean useFragmentCache;
   /** Compile Log. */
   private CompileLog log;

   /** Synthesizers for all (used) CPU's */
   private Map<TargetCpu, AsmFragmentTemplateSynthesizer> synthesizers;

   /** Create master synthesizer. */
   public AsmFragmentTemplateMasterSynthesizer(Path cacheFragmentFolder, Path baseFragmentFolder, CompileLog log) {
      this.cacheFragmentFolder = cacheFragmentFolder;
      this.baseFragmentFolder = baseFragmentFolder;
      this.log = log;
      this.synthesizers = new LinkedHashMap<>();
   }

   public AsmFragmentTemplateSynthesizer getSynthesizer(TargetCpu targetCpu) {
      AsmFragmentTemplateSynthesizer synthesizer = synthesizers.get(targetCpu);
      if(synthesizer==null) {
         synthesizer = new AsmFragmentTemplateSynthesizer(targetCpu, cacheFragmentFolder, baseFragmentFolder, log);
         synthesizers.put(targetCpu, synthesizer);
      }
      return synthesizer;
   }

   /** Finalize the master fragment template synthesizer. */
   public void finalize(CompileLog log) {
      for(AsmFragmentTemplateSynthesizer synthesizer : synthesizers.values()) {
         synthesizer.finalize(log);
      }
   }


}

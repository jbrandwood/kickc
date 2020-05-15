package dk.camelot64.kickc.parser;

import dk.camelot64.kickc.SourceLoader;
import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.TargetCpu;
import dk.camelot64.kickc.model.TargetPlatform;

import javax.json.Json;
import javax.json.JsonObject;
import javax.json.JsonReader;
import javax.json.JsonValue;
import javax.json.stream.JsonParsingException;
import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.nio.file.Path;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Set;

/**
 * Parser for target platform files xxx.tgt.
 * The file format is JSON.
 */
public class CTargetPlatformParser {

   /** The file extension used for target platform files. */
   public static final String FILE_EXTENSION = "tgt";


   public static TargetPlatform parseTargetPlatformFile(String platformName, File platformFile, Path currentFolder, List<String> platformSearchPaths) {
      try {
         final JsonReader jsonReader = Json.createReader(new BufferedInputStream(new FileInputStream(platformFile)));
         final JsonObject platformJson = jsonReader.readObject();
         TargetPlatform targetPlatform = new TargetPlatform(platformName);
         final String cpuName = platformJson.getString("cpu", null);
         if(cpuName != null)
            targetPlatform.setCpu(TargetCpu.getTargetCpu(cpuName, false));
         final String linkScriptName = platformJson.getString("link", null);
         if(linkScriptName != null)
            targetPlatform.setLinkScriptFile(SourceLoader.loadFile(linkScriptName, currentFolder, platformSearchPaths));
         final String emulatorCommand = platformJson.getString("emulator", null);
         if(emulatorCommand != null)
            targetPlatform.setEmulatorCommand(emulatorCommand);
         final JsonObject defines = platformJson.getJsonObject("defines");
         if(defines != null) {
            final Set<String> macroNames = defines.keySet();
            final LinkedHashMap<String, String> macros = new LinkedHashMap<>();
            for(String macroName : macroNames) {
               final JsonValue jsonValue = defines.get(macroName);
               final String macroBody = jsonValue.toString();
               macros.put(macroName, macroBody);
            }
            targetPlatform.setDefines(macros);
         }
         return targetPlatform;
      } catch(CompileError | IOException | JsonParsingException e) {
         throw new CompileError("Error parsing target platform file " + platformFile.getAbsolutePath() + "\n" + e.getMessage());
      }
   }


}

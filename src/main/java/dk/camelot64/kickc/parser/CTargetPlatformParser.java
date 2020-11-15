package dk.camelot64.kickc.parser;

import dk.camelot64.kickc.NumberParser;
import dk.camelot64.kickc.SourceLoader;
import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.TargetCpu;
import dk.camelot64.kickc.model.TargetPlatform;
import dk.camelot64.kickc.model.VariableBuilderConfig;
import dk.camelot64.kickc.model.statements.StatementSource;
import dk.camelot64.kickc.model.values.StringEncoding;

import javax.json.*;
import javax.json.stream.JsonParsingException;
import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.nio.file.Path;
import java.util.*;
import java.util.stream.Collectors;

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
         {
            final String cpuName = platformJson.getString("cpu", null);
            if(cpuName != null)
               targetPlatform.setCpu(TargetCpu.getTargetCpu(cpuName, false));
         }
         {
            final String linkScriptName = platformJson.getString("link", null);
            if(linkScriptName != null)
               targetPlatform.setLinkScriptFile(SourceLoader.loadFile(linkScriptName, currentFolder, platformSearchPaths));
         }
         {
            final String startAddress = platformJson.getString("start_address", null);
            if(startAddress != null) {
               final Number startAddressNumber = NumberParser.parseLiteral(startAddress);
               targetPlatform.setStartAddress(startAddressNumber.intValue());
            }
         }
         {
            final String emulatorCommand = platformJson.getString("emulator", null);
            if(emulatorCommand != null)
               targetPlatform.setEmulatorCommand(emulatorCommand);
         }
         {
            final String outExtension = platformJson.getString("extension", null);
            if(outExtension != null)
               targetPlatform.setOutFileExtension(outExtension);
         }
         {
            final String encoding = platformJson.getString("encoding", null);
            if(encoding != null)
               targetPlatform.setEncoding(StringEncoding.fromName(encoding.toUpperCase()));
         }
         {
            final JsonArray zpReserves = platformJson.getJsonArray("zp_reserve");
            if(zpReserves != null) {
               List<Integer> reservedZps = new ArrayList<>();
               for(JsonValue zpReserve : zpReserves) {
                  if(zpReserve instanceof JsonString) {
                     final String zpReserveStr = ((JsonString) zpReserve).getString();
                     if(!zpReserveStr.contains("..")) {
                        // A single zeropage address
                        final Number zpReserveNumber = NumberParser.parseLiteral(zpReserveStr);
                        reservedZps.add(zpReserveNumber.intValue());
                     } else {
                        // A range of zeropage addresses
                        final int split = zpReserveStr.indexOf("..");
                        final String startStr = zpReserveStr.substring(0, split);
                        final String endStr = zpReserveStr.substring(split + 2);
                        final Number startZp = NumberParser.parseLiteral(startStr);
                        final Number endZp = NumberParser.parseLiteral(endStr);
                        int zp = startZp.intValue();
                        while(zp <= endZp.intValue()) {
                           reservedZps.add(zp);
                           zp++;
                        }
                     }
                  } else if(zpReserve instanceof JsonNumber) {
                     reservedZps.add(((JsonNumber) zpReserve).intValue());
                  } else {
                     throw new CompileError("Cannot handle zp_reserve value " + zpReserve.toString());
                  }
               }
               targetPlatform.setReservedZps(reservedZps);
            }
         }
         {
            final String varModel = platformJson.getString("var_model", null);
            if(varModel != null) {
               List<String> settings = Arrays.asList(varModel.split(","));
               settings = settings.stream().map(String::trim).collect(Collectors.toList());
               VariableBuilderConfig config = VariableBuilderConfig.fromSettings(settings, StatementSource.NONE);
               targetPlatform.setVariableBuilderConfig(config);
            }
         }
         {
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
         }
         return targetPlatform;
      } catch(CompileError | IOException | JsonParsingException e) {
         throw new CompileError("Error parsing target platform file " + platformFile.getAbsolutePath() + "\n" + e.getMessage());
      }
   }


}

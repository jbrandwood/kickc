package dk.camelot64.kickc.model;

import dk.camelot64.kickc.SourceLoader;
import dk.camelot64.kickc.model.statements.StatementSource;

import javax.json.Json;
import javax.json.JsonObject;
import javax.json.JsonReader;
import javax.json.stream.JsonParsingException;
import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.nio.file.Path;
import java.util.List;
import java.util.Map;

/**
 * The target platform the compiler is creating a program for.
 * <p>
 * The target platform is represented by a .tgt-file in the target-folder, which typically sets up
 * link script, cpu, emulator and some platform #defines
 */
public class TargetPlatform {

   /** The name of the default target platform. */
   public static String DEFAULT_NAME = "c64basic";

   /** The file extension used for target platform files. */
   public static final String FILE_EXTENSION = "tgt";

   /** The platform name. */
   private String name;

   /** The target CPU. */
   private TargetCpu cpu;

   /** The link script file. */
   private File linkScriptFile;

   /** The command to use for starting an emulator. */
   private String emulatorCommand;

   /** A number of preprocessor macro defines. */
   private Map<String, String> defines = null;

   public TargetPlatform(String name) {
      this.name = name;
   }

   public String getName() {
      return name;
   }

   public void setName(String name) {
      this.name = name;
   }

   public TargetCpu getCpu() {
      return cpu;
   }

   public void setCpu(TargetCpu cpu) {
      this.cpu = cpu;
   }

   public File getLinkScriptFile() {
      return linkScriptFile;
   }

   public void setLinkScriptFile(File linkScriptFile) {
      this.linkScriptFile = linkScriptFile;
   }

   public String getEmulatorCommand() {
      return emulatorCommand;
   }

   public void setEmulatorCommand(String emulatorCommand) {
      this.emulatorCommand = emulatorCommand;
   }

   public Map<String, String> getDefines() {
      return defines;
   }

   public void setDefines(Map<String, String> defines) {
      this.defines = defines;
   }

   /**
    * Set the target platform from a platform name
    *
    * @param platformName The platform name
    * @param currentFolder The current folder (added to the search path)
    * @param program The program.
    * @param statementSource The source file & line used for errors
    */
   public static void setTargetPlatform(String platformName, Path currentFolder, Program program, StatementSource statementSource) {
      final File platformFile = SourceLoader.loadFile(platformName + "." + FILE_EXTENSION, currentFolder, program.getTargetPlatformPaths());
      if(platformFile != null) {
         // Set the target platform
         try {
            final JsonReader jsonReader = Json.createReader(new BufferedInputStream(new FileInputStream(platformFile)));
            final JsonObject platformJson = jsonReader.readObject();
            TargetPlatform targetPlatform = new TargetPlatform(platformName);
            final String cpuName = platformJson.getString("cpu", null);
            if(cpuName != null)
               targetPlatform.setCpu(TargetCpu.getTargetCpu(cpuName, false));
            final String linkScriptName = platformJson.getString("link", null);
            if(linkScriptName != null)
               targetPlatform.setLinkScriptFile(SourceLoader.loadFile(linkScriptName, currentFolder, program.getTargetPlatformPaths()));
            final String emulatorCommand = platformJson.getString("emulator", null);
            if(emulatorCommand != null)
               targetPlatform.setEmulatorCommand(emulatorCommand);
            program.setTargetPlatform(targetPlatform);
         } catch(CompileError | IOException | JsonParsingException e) {
            throw new CompileError("Error parsing target platform file " + platformFile.getAbsolutePath() + "\n"+e.getMessage(), statementSource);
         }
      } else {
         StringBuilder supported = new StringBuilder();
         final List<File> platformFiles = SourceLoader.listFiles(currentFolder, program.getTargetPlatformPaths(), FILE_EXTENSION);
         for(File file : platformFiles) {
            String name = file.getName();
            name = name.substring(0, name.length()- FILE_EXTENSION.length()-1);
            supported.append(name).append(" ");
         }
         throw new CompileError("Unknown target platform '"+platformName+"'. Supported: " + supported.toString(), statementSource);
      }
   }

}

package dk.camelot64.kickc.model;

import java.io.File;
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


}

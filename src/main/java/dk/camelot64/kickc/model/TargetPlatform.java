package dk.camelot64.kickc.model;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.util.ArrayList;
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

   /** The platform name. */
   private String name;

   /** The target CPU. */
   private TargetCpu cpu;

   /** The link script file. */
   private File linkScriptFile;

   /** The command to use for starting an emulator. */
   private String emulatorCommand;

   /** The output file extension. */
   private String outFileExtension;

   /** A number of preprocessor macro defines. */
   private Map<String, String> defines = null;

   /** Reserved zeropage addresses. */
   private List<Integer> reservedZps = new ArrayList<>();

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

   public String getLinkScriptBody() {
      final File linkScriptFile = getLinkScriptFile();
      if(linkScriptFile == null)
         throw new InternalError("No link script found! Cannot link program.");
      String linkScriptBody = null;
      try {
         linkScriptBody = new String(Files.readAllBytes(linkScriptFile.toPath()));
      } catch(IOException e) {
         throw new CompileError("Cannot read link script file " + linkScriptFile.getAbsolutePath(), e);
      }
      return linkScriptBody;
   }

   public String getEmulatorCommand() {
      return emulatorCommand;
   }

   public void setEmulatorCommand(String emulatorCommand) {
      this.emulatorCommand = emulatorCommand;
   }

   public String getOutFileExtension() {
      return outFileExtension;
   }

   public void setOutFileExtension(String outFileExtension) {
      this.outFileExtension = outFileExtension;
   }

   public Map<String, String> getDefines() {
      return defines;
   }

   public void setDefines(Map<String, String> defines) {
      this.defines = defines;
   }

   public void setReservedZps(List<Integer> reservedZps) {
      this.reservedZps = reservedZps;
   }

   public List<Integer> getReservedZps() {
      return reservedZps;
   }
}

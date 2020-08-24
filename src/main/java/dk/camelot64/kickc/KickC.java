package dk.camelot64.kickc;

import dk.camelot64.kickc.asm.AsmProgram;
import dk.camelot64.kickc.fragment.AsmFragmentTemplate;
import dk.camelot64.kickc.fragment.AsmFragmentTemplateMasterSynthesizer;
import dk.camelot64.kickc.fragment.AsmFragmentTemplateSynthesizer;
import dk.camelot64.kickc.fragment.AsmFragmentTemplateUsages;
import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.statements.StatementSource;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.parser.CTargetPlatformParser;
import kickass.KickAssembler65CE02;
import kickass.nonasm.c64.CharToPetsciiConverter;
import picocli.CommandLine;

import java.io.*;
import java.nio.file.FileAlreadyExistsException;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.*;
import java.util.concurrent.Callable;
import java.util.stream.Collectors;

/** KickC Commandline */
@CommandLine.Command(
      description = "Compiles C source files. " +
            "KickC is a C-compiler creating optimized and readable 6502 assembler code.%n%n" +
            "See https://gitlab.com/camelot/kickc for detailed information about KickC.",
      name = "kickc",
      mixinStandardHelpOptions = true,
      headerHeading = "Usage:%n%n",
      synopsisHeading = "  ",
      descriptionHeading = "%nDescription:%n%n",
      parameterListHeading = "%nParameters:%n",
      optionListHeading = "%nOptions:%n",
      version = "KickC 0.8.3 BETA"
)
public class KickC implements Callable<Integer> {

   @CommandLine.Parameters(index = "0", arity = "0..n", description = "The C source files to compile.")
   private List<Path> cFiles = null;

   @CommandLine.Option(names = {"-o", "-output"}, description = "Name of the output file. By default it is the same as the first input file with the proper extension.")
   private String outputFileName = null;

   @CommandLine.Option(names = {"-odir"}, description = "Path to the output folder, where the compiler places all generated files. By default the folder of the output file is used.")
   private Path outputDir = null;

   @CommandLine.Option(names = {"-oext"}, description = "Override the output file extension. The default is specified in the target platform / linker configuration.")
   private String outputExtension = null;

   @CommandLine.Option(names = {"-a"}, description = "Assemble the output file using KickAssembler. Produces a binary file.")
   private boolean assemble = false;

   @CommandLine.Option(names = {"-e"}, description = "Execute the assembled binary file using an appropriate emulator. The emulator chosen depends on the target platform.")
   private boolean execute = false;

   @CommandLine.Option(names = {"-emu"}, description = "Execute the assembled program file by passing it to the named emulator. Implicitly assembles the output.")
   private String emulator = null;

   @CommandLine.Option(names = {"-d"}, description = "Debug the assembled binary file using C64Debugger. Implicitly assembles the output.")
   private boolean debug = false;

   @CommandLine.Option(names = {"-D"}, parameterConsumer = DefineConsumer.class, description = "Define macro to value (1 if no value given).")
   private Map<String, String> defines = null;

   @CommandLine.Option(names = {"-E"}, description = "Only run the preprocessor. Output is sent to standard out.")
   private boolean preprocess = false;

   @CommandLine.Option(names = {"-I", "-includedir"}, description = "Path to an include folder, where the compiler looks for included files. This option can be repeated to add multiple include folders.")
   private List<Path> includeDir = null;

   @CommandLine.Option(names = {"-L", "-libdir"}, description = "Path to a library folder, where the compiler looks for library files. This option can be repeated to add multiple library folders.")
   private List<Path> libDir = null;

   @CommandLine.Option(names = {"-F", "-fragmentdir"}, description = "Path to the ASM fragment folder, where the compiler looks for ASM fragments.")
   private Path fragmentDir = null;

   @CommandLine.Option(names = {"-P", "-platformdir", "-targetdir"}, description = "Path to a target platform folder, where the compiler looks for target platform files. This option can be repeated to add multiple target platform folders.")
   private List<Path> targetPlatformDir = null;

   @CommandLine.Option(names = {"-Ouplift"}, description = "Optimization Option. Number of combinations to test when uplifting variables to registers in a scope. By default 100 combinations are tested.")
   private Integer optimizeUpliftCombinations = null;

   @CommandLine.Option(names = {"-Onouplift"}, description = "Optimization Option. Disable the register uplift allocation phase. This will be much faster but produce significantly slower ASM.")
   private boolean optimizeNoUplift = false;

   @CommandLine.Option(names = {"-Ocoalesce"}, description = "Optimization Option. Enables zero-page coalesce pass which limits zero-page usage significantly, but takes a lot of compile time.")
   private boolean optimizeZeroPageCoalesce = false;

   @CommandLine.Option(names = {"-Oloophead"}, description = "Optimization Option. Enabled experimental loop-head constant pass which identifies loops where the condition is constant on the first iteration.")
   private boolean optimizeLoopHeadConstant = false;

   @CommandLine.Option(names = {"-Onoloophead"}, description = "Optimization Option. Disabled experimental loop-head constant pass which identifies loops where the condition is constant on the first iteration.")
   private boolean optimizeNoLoopHeadConstant = false;

   @CommandLine.Option(names = {"-Onocache"}, description = "Optimization Option. Disables the fragment synthesis cache. The cache is enabled by default.")
   private boolean optimizeNoFragmentCache = false;

   @CommandLine.Option(names = {"-Oliverangecallpath"}, description = "Optimization Option. Enables live ranges per call path optimization, which limits memory usage and code, but takes a lot of compile time.")
   private boolean optimizeLiveRangeCallPath = false;

   @CommandLine.Option(names = {"-v"}, description = "Verbose output describing the compilation process")
   private boolean verbose = false;

   @CommandLine.Option(names = {"-vasmout"}, description = "Verbosity Option. Show KickAssembler standard output during compilation.")
   private boolean verboseAsmOut = false;

   @CommandLine.Option(names = {"-vparse"}, description = "Verbosity Option. File Parsing.")
   private boolean verboseParse = false;

   @CommandLine.Option(names = {"-vcreate"}, description = "Verbosity Option. Creation of the Single Static Assignment Control Flow Graph.")
   private boolean verboseCreateSsa = false;

   @CommandLine.Option(names = {"-voptimize"}, description = "Verbosity Option. Control Flow Graph Optimization.")
   private boolean verboseSSAOptimize = false;

   @CommandLine.Option(names = {"-vsizeinfo"}, description = "Verbosity Option. Compiler Data Structure Size Information.")
   private boolean verboseSizeInfo = false;

   @CommandLine.Option(names = {"-vnonoptimize"}, description = "Verbosity Option. Choices not to optimize.")
   private boolean verboseNonOptimization = false;

   @CommandLine.Option(names = {"-vsequence"}, description = "Verbosity Option. Sequence Plan.")
   private boolean verboseSequencePlan = false;

   @CommandLine.Option(names = {"-vloop"}, description = "Verbosity Option. Loop Analysis.")
   private boolean verboseLoopAnalysis = false;

   @CommandLine.Option(names = {"-vliverange"}, description = "Verbosity Option. Variable Live Range Analysis.")
   private boolean verboseLiveRanges = false;

   @CommandLine.Option(names = {"-vuplift"}, description = "Verbosity Option. Variable Register Uplift Combination Optimization.")
   private boolean verboseUplift = false;

   @CommandLine.Option(names = {"-vunroll"}, description = "Verbosity Option. Loop Unrolling.")
   private boolean verboseLoopUnroll = false;

   @CommandLine.Option(names = {"-vfragment"}, description = "Verbosity Option. Synthesis of Assembler fragments.")
   private boolean verboseFragments = false;

   @CommandLine.Option(names = {"-vasmoptimize"}, description = "Verbosity Option. Assembler optimization.")
   private boolean verboseAsmOptimize = false;

   @CommandLine.Option(names = {"-Wfragment"}, description = "Warning Option. Missing fragments produces a warning instead of an error.")
   private boolean warnFragmentMissing = false;

   @CommandLine.Option(names = {"-Warraytype"}, description = "Warning Option. Non-standard array syntax produces a warning instead of an error.")
   private boolean warnArrayType = false;

   @CommandLine.Option(names = {"-fragment"}, description = "Print the ASM code for a named fragment. The fragment is loaded/synthesized and the ASM variations are written to the output.")
   private String fragment = null;

   @CommandLine.Option(names = {"-S", "-Sc"}, description = "Interleave comments with C source code in the generated ASM.")
   private boolean interleaveSourceCode = false;

   @CommandLine.Option(names = {"-Sl"}, description = "Interleave comments with C source file name and line number in the generated ASM.")
   private boolean interleaveSourceFile = false;

   @CommandLine.Option(names = {"-Si"}, description = "Interleave comments with intermediate language code and ASM fragment names in the generated ASM.")
   private boolean interleaveIclFile = false;

   @CommandLine.Option(names = {"-p", "-t", "-target", "-platform"}, description = "The target platform. Default is C64 with BASIC upstart. See #pragma target")
   private String targetPlatform = TargetPlatform.DEFAULT_NAME;

   @CommandLine.Option(names = {"-cpu"}, description = "The target CPU. Default is 6502 with illegal opcodes. See #pragma cpu")
   private String cpu = null;

   @CommandLine.Option(names = {"-T", "-link"}, description = "Link using a linker script in KickAss segment format. See #pragma link")
   private String linkScript = null;

   @CommandLine.Option(names = {"-var_model"}, description = "Configure variable optimization/memory area. Default is ssa_zp. See #pragma var_model")
   private String varModel = null;

   @CommandLine.Option(names = {"-calling"}, description = "Configure calling convention. Default is __phicall. See #pragma calling")
   private String calling = null;

   /** Program Exit Code signaling a compile error. */
   public static final int COMPILE_ERROR = CommandLine.ExitCode.SOFTWARE;

   public static void main(String[] args) {
      final CommandLine commandLine = new CommandLine(new KickC());
      final int exitCode = commandLine.execute(args);
      System.exit(exitCode);
   }

   @Override
   public Integer call() throws Exception {
      System.out.println("//--------------------------------------------------");
      System.out.println("//   " + getVersion() + " by Jesper Gravgaard   ");
      System.out.println("//--------------------------------------------------");

      Compiler compiler = new Compiler();

      if(includeDir != null) {
         for(Path includePath : includeDir) {
            compiler.addIncludePath(includePath.toString());
         }
      }

      if(libDir != null) {
         for(Path libPath : libDir) {
            compiler.addLibraryPath(libPath.toString());
         }
      }

      if(targetPlatformDir != null) {
         for(Path platformPath : targetPlatformDir) {
            compiler.addTargetPlatformPath(platformPath.toString());
         }
      }

      if(fragmentDir == null) {
         fragmentDir = new File("fragment/").toPath();
      }
      compiler.setAsmFragmentBaseFolder(fragmentDir);

      configVerbosity(compiler);

      Program program = compiler.getProgram();

      // Initialize the master ASM fragment synthesizer
      program.initAsmFragmentMasterSynthesizer(!optimizeNoFragmentCache);

      Path currentPath = new File(".").toPath();

      // Set up Target Platform
      try {
         final File platformFile = SourceLoader.loadFile(targetPlatform + "." + CTargetPlatformParser.FILE_EXTENSION, currentPath, program.getTargetPlatformPaths());
         final TargetPlatform targetPlatform = CTargetPlatformParser.parseTargetPlatformFile(this.targetPlatform, platformFile, currentPath, program.getTargetPlatformPaths());
         program.setTargetPlatform(targetPlatform);
      } catch(CompileError e) {
         // Print the error and exit with compile error
         System.err.println(e.getMessage());
         return COMPILE_ERROR;
      }

      // Update link script
      if(linkScript != null) {
         program.getTargetPlatform().setLinkScriptFile(SourceLoader.loadFile(linkScript, currentPath, program.getTargetPlatformPaths()));
      }

      // Update output file extension
      if(outputExtension != null) {
         program.getTargetPlatform().setOutFileExtension(outputExtension);
      }

      // Update CPU
      if(cpu != null) {
         TargetCpu targetCpu = TargetCpu.getTargetCpu(cpu, false);
         program.getTargetPlatform().setCpu(targetCpu);
      }

      if(fragment != null) {
         if(verbose) {
            compiler.getLog().setVerboseFragmentLog(true);
         }
         compiler.getLog().setSysOut(true);
         final AsmFragmentTemplateMasterSynthesizer masterSynthesizer = compiler.getAsmFragmentMasterSynthesizer();
         final AsmFragmentTemplateSynthesizer cpuSynthesizer = masterSynthesizer.getSynthesizer(program.getTargetCpu());
         Collection<AsmFragmentTemplate> fragmentTemplates = cpuSynthesizer.getBestTemplates(fragment, compiler.getLog());
         for(AsmFragmentTemplate fragmentTemplate : fragmentTemplates) {
            AsmFragmentTemplateUsages.logTemplate(compiler.getLog(), fragmentTemplate, "");
         }
      }

      if(cFiles != null && !cFiles.isEmpty()) {

         final Path primaryCFile = cFiles.get(0);
         String primaryFileBaseName = getFileBaseName(primaryCFile);

         Path CFileDir = primaryCFile.getParent();
         if(CFileDir == null) {
            CFileDir = FileSystems.getDefault().getPath(".");
         }

         if(outputDir == null) {
            outputDir = CFileDir;
         }
         if(!Files.exists(outputDir)) {
            Files.createDirectory(outputDir);
         }

         String outputFileNameBase;
         if(outputFileName == null) {
            outputFileNameBase = primaryFileBaseName;
         } else {
            final int extensionIdx = outputFileName.lastIndexOf('.');
            if(extensionIdx > 0)
               outputFileNameBase = outputFileName.substring(0, extensionIdx);
            else
               outputFileNameBase = outputFileName;
         }

         if(optimizeNoUplift) {
            compiler.setDisableUplift(true);
         }

         if(optimizeUpliftCombinations != null) {
            compiler.setUpliftCombinations(optimizeUpliftCombinations);
         }

         if(optimizeZeroPageCoalesce) {
            compiler.enableZeroPageCoalesce();
         }

         if(optimizeLoopHeadConstant) {
            compiler.enableLoopHeadConstant();
         } else if(optimizeNoLoopHeadConstant) {
            compiler.disableLoopHeadConstant();
         }

         compiler.setEnableLiveRangeCallPath(optimizeLiveRangeCallPath);

         if(warnFragmentMissing) {
            compiler.setWarnFragmentMissing(true);
         }

         if(warnArrayType) {
            compiler.setWarnArrayType(true);
         }

         if(varModel != null) {
            List<String> settings = Arrays.asList(varModel.split(","));
            settings = settings.stream().map(String::trim).collect(Collectors.toList());
            try {
               VariableBuilderConfig config = VariableBuilderConfig.fromSettings(settings, StatementSource.NONE);
               program.getTargetPlatform().setVariableBuilderConfig(config);
            } catch(CompileError e) {
               System.err.println(e.getMessage());
               return COMPILE_ERROR;
            }
         }

         if(calling != null) {
            Procedure.CallingConvention callingConvention = Procedure.CallingConvention.getCallingConvension(calling);
            if(callingConvention == null) {
               System.err.println("Unknown calling convention " + calling);
               StringBuffer supported = new StringBuffer();
               supported.append("The supported calling conventions are: ");
               for(Procedure.CallingConvention value : Procedure.CallingConvention.values()) {
                  supported.append(value.getName()).append(" ");
               }
               System.err.println(supported);
               return COMPILE_ERROR;
            }
            compiler.setCallingConvention(callingConvention);
         }

         StringBuilder CFileNames = new StringBuilder();
         cFiles.stream().forEach(path -> CFileNames.append(path.toString()).append(" "));

         Map<String, String> effectiveDefines = new LinkedHashMap<>();
         if(defines != null)
            effectiveDefines.putAll(defines);
         if(program.getTargetPlatform().getDefines() != null)
            effectiveDefines.putAll(program.getTargetPlatform().getDefines());
         program.addReservedZps(program.getTargetPlatform().getReservedZps());

         if(preprocess) {
            System.out.println("Preprocessing " + CFileNames);
            try {
               compiler.preprocess(cFiles, effectiveDefines);
            } catch(CompileError e) {
               // Print the error and exit with compile error
               System.err.println(e.getMessage());
               return COMPILE_ERROR;
            }
            return null;
         }

         System.out.println("Compiling " + CFileNames);
         try {
            compiler.compile(cFiles, effectiveDefines);
         } catch(CompileError e) {
            // Print the error and exit with compile error
            System.err.println(e.getMessage());
            return COMPILE_ERROR;
         }

         String asmFileName = outputFileNameBase + ".asm";
         Path asmPath = outputDir.resolve(asmFileName);
         System.out.println("Writing asm file " + asmPath);
         FileOutputStream asmOutputStream = new FileOutputStream(asmPath.toFile());
         OutputStreamWriter asmWriter = new OutputStreamWriter(asmOutputStream);
         String asmCodeString = program.getAsm().toString(new AsmProgram.AsmPrintState(interleaveSourceFile, interleaveSourceCode, interleaveIclFile, false), program);
         asmWriter.write(asmCodeString);
         asmWriter.close();
         asmOutputStream.close();

         // Save the fragment synthesizer cache files
         program.getAsmFragmentMasterSynthesizer().finalize(compiler.getLog());

         // Copy Resource Files (if out-dir is different from in-dir)
         if(!CFileDir.toAbsolutePath().equals(outputDir.toAbsolutePath())) {
            for(Path resourcePath : program.getAsmResourceFiles()) {
               Path outResourcePath = outputDir.resolve(resourcePath.getFileName().toString());
               System.out.println("Copying resource " + outResourcePath);
               try {
                  Files.copy(resourcePath, outResourcePath);
               } catch(FileAlreadyExistsException e) {
                  // Ignore this
               }
            }
         }

         // Assemble the asm-file if instructed
         String outputBinaryFileName = outputFileNameBase + "." + program.getTargetPlatform().getOutFileExtension();
         Path outputBinaryFilePath = outputDir.resolve(outputBinaryFileName);

         // Find emulator - if set by #pragma
         if(emulator == null) {
            if(program.getTargetPlatform().getEmulatorCommand() != null && (debug || execute))
               emulator = program.getTargetPlatform().getEmulatorCommand();
            else if(debug)
               emulator = "C64Debugger";
            else if(execute)
               emulator = "x64sc";
         }

         if(assemble || emulator != null) {
            Path kasmLogPath = outputDir.resolve(outputFileNameBase + ".klog");
            System.out.println("Assembling to " + outputBinaryFilePath.toString());
            List<String> assembleCommand = new ArrayList<>();
            assembleCommand.add(asmPath.toString());
            assembleCommand.add("-log");
            assembleCommand.add(kasmLogPath.toString());
            final String linkScriptBody = program.getTargetPlatform().getLinkScriptBody();
            if(!linkScriptBody.contains(".file") && !linkScriptBody.contains(".disk")) {
               assembleCommand.add("-o");
               assembleCommand.add(outputBinaryFilePath.toString());
            }
            assembleCommand.add("-vicesymbols");
            assembleCommand.add("-showmem");
            assembleCommand.add("-debugdump");
            if(verbose) {
               System.out.print("Assembling command: java -jar KickAss.jar ");
               for(String cmd : assembleCommand) {
                  System.out.print(cmd + " ");
               }
               System.out.println();
            }
            ByteArrayOutputStream kasmLogOutputStream = new ByteArrayOutputStream();
            if(!verboseAsmOut) {
               System.setOut(new PrintStream(kasmLogOutputStream));
            }
            int kasmResult = -1;
            try {
               CharToPetsciiConverter.setCurrentEncoding("screencode_mixed");
               kasmResult = KickAssembler65CE02.main2(assembleCommand.toArray(new String[0]));
            } catch(Throwable e) {
               throw new CompileError("KickAssembling file failed! ", e);
            } finally {
               System.setOut(new PrintStream(new FileOutputStream(FileDescriptor.out)));
            }
            if(kasmResult != 0) {
               throw new CompileError("KickAssembling file failed! " + kasmLogOutputStream.toString());
            }
         }

         // Execute the binary file if instructed
         if(emulator != null) {

            // Find commandline options for the emulator
            String emuOptions = "";
            if(emulator.equals("C64Debugger")) {
               Path viceSymbolsPath = outputDir.resolve(outputFileNameBase + ".vs");
               emuOptions = "-symbols " + viceSymbolsPath + " -wait 2500" + " ";
            }
            // The program names used by VICE emulators
            List<String> viceEmus = Arrays.asList("x64", "x64sc", "x128", "x64dtv", "xcbm2", "xcbm5x0", "xpet", "xplus4", "xscpu64", "xvic");
            if(viceEmus.contains(emulator)) {
               Path viceSymbolsPath = outputDir.resolve(outputFileNameBase + ".vs");
               emuOptions = "-moncommands " + viceSymbolsPath.toAbsolutePath().toString() + " ";
            }

            System.out.println("Executing " + outputBinaryFilePath + " using " + emulator);
            String executeCommand = emulator + " " + emuOptions + outputBinaryFilePath.toAbsolutePath().toString();
            if(verbose) {
               System.out.println("Executing command:  " + executeCommand);
            }
            Process process = Runtime.getRuntime().exec(executeCommand);
            process.waitFor();
         }
      }

      return CommandLine.ExitCode.OK;
   }

   private void configVerbosity(Compiler compiler) {
      if(verbose) {
         compiler.getLog().setSysOut(true);
      }

      if(verboseParse) {
         compiler.getLog().setVerboseParse(true);
         compiler.getLog().setSysOut(true);
      }
      if(verboseCreateSsa) {
         compiler.getLog().setVerboseCreateSsa(true);
         compiler.getLog().setSysOut(true);
      }
      if(verboseSSAOptimize) {
         compiler.getLog().setVerboseSSAOptimize(true);
         compiler.getLog().setSysOut(true);
      }
      if(verboseSizeInfo) {
         compiler.getLog().setVerboseSizeInfo(true);
         compiler.getLog().setSysOut(true);
      }
      if(verboseNonOptimization) {
         compiler.getLog().setVerboseNonOptimization(true);
         compiler.getLog().setSysOut(true);
      }
      if(verboseSequencePlan) {
         compiler.getLog().setVerboseSequencePlan(true);
         compiler.getLog().setSysOut(true);
      }
      if(verboseLoopAnalysis) {
         compiler.getLog().setVerboseLoopAnalysis(true);
         compiler.getLog().setSysOut(true);
      }
      if(verboseLoopUnroll) {
         compiler.getLog().setVerboseLoopUnroll(true);
         compiler.getLog().setSysOut(true);
      }
      if(verboseLiveRanges) {
         compiler.getLog().setVerboseLiveRanges(true);
         compiler.getLog().setSysOut(true);
      }
      if(verboseUplift) {
         compiler.getLog().setVerboseUplift(true);
         compiler.getLog().setSysOut(true);
      }
      if(verboseFragments) {
         compiler.getLog().setVerboseFragmentLog(true);
         compiler.getLog().setSysOut(true);
      }
      if(verboseAsmOptimize) {
         compiler.getLog().setVerboseAsmOptimize(true);
         compiler.getLog().setSysOut(true);
      }
   }

   /**
    * Get the current version of KickC
    *
    * @return The name and version (eg "KickC 0.5")
    */
   private String getVersion() {
      return new CommandLine(new KickC()).getCommandSpec().version()[0];
   }

   static String getFileBaseName(Path file) {
      String name = file.getFileName().toString();
      int i = name.lastIndexOf('.');
      return i > 0 ? name.substring(0, i) : name;
   }

   String getFileExtension(Path file) {
      if(file == null) {
         return "";
      }
      String name = file.getFileName().toString();
      int i = name.lastIndexOf('.');
      return i > 0 ? name.substring(i + 1) : "";
   }

   /**
    * Picocli Parameter Consumer for -D defines that allow both -Dname and -Dname=Value
    */
   static class DefineConsumer implements CommandLine.IParameterConsumer {
      @Override
      public void consumeParameters(
            Stack<String> args,
            CommandLine.Model.ArgSpec argSpec,
            CommandLine.Model.CommandSpec commandSpec) {
         if(args.isEmpty()) {
            throw new CommandLine.ParameterException(commandSpec.commandLine(),
                  "Missing required parameter");
         }
         String parameter = args.pop();
         String[] keyValue = parameter.split("=", 2);
         String key = keyValue[0];
         String value = keyValue.length > 1
               ? keyValue[1]
               : "1";
         Map<String, String> map = argSpec.getValue();
         if(map == null) {
            map = new LinkedHashMap<>();
            argSpec.setValue(map);
         }
         map.put(key, value);
      }
   }

}

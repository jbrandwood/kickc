package dk.camelot64.kickc;

import dk.camelot64.kickc.asm.AsmProgram;
import dk.camelot64.kickc.fragment.AsmFragmentTemplate;
import dk.camelot64.kickc.fragment.AsmFragmentTemplateUsages;
import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.TargetCpu;
import dk.camelot64.kickc.model.TargetPlatform;
import kickass.KickAssembler;
import kickass.nonasm.c64.CharToPetsciiConverter;
import picocli.CommandLine;

import java.io.*;
import java.nio.file.FileAlreadyExistsException;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Collection;
import java.util.List;
import java.util.concurrent.Callable;

/** KickC Commandline */
@CommandLine.Command(
      description = "Compiles a KickC source file, creating a KickAssembler source file. " +
            "KickC is a C-compiler creating optimized and readable 6502 assembler code.%n%n" +
            "See https://gitlab.com/camelot/kickc for detailed information about KickC.",
      name = "kickc",
      mixinStandardHelpOptions = true,
      headerHeading = "Usage:%n%n",
      synopsisHeading = "  ",
      descriptionHeading = "%nDescription:%n%n",
      parameterListHeading = "%nParameters:%n",
      optionListHeading = "%nOptions:%n",
      version = "KickC 0.7.10 BETA (master)"
)
public class KickC implements Callable<Void> {

   @CommandLine.Parameters(index = "0", arity = "0..1", description = "The KickC source file to compile.")
   private Path kcFile = null;

   @CommandLine.Option(names = {"-I", "-libdir"}, description = "Path to a library folder, where the compiler looks for included files. This option can be repeated to add multiple library folders.")
   private List<Path> libDir = null;

   @CommandLine.Option(names = {"-F", "-fragmentdir"}, description = "Path to the ASM fragment folder, where the compiler looks for ASM fragments.")
   private Path fragmentDir = null;

   @CommandLine.Option(names = {"-o", "-output"}, description = "Name of the output assembler file. By default it is the same as the input file with extension .asm")
   private String asmFileName = null;

   @CommandLine.Option(names = {"-odir"}, description = "Path to the output folder, where the compiler places all generated files. By default the folder of the output file is used.")
   private Path outputDir = null;

   @CommandLine.Option(names = {"-a"}, description = "Assemble the output file using KickAssembler. Produces a .prg file.")
   private boolean assemble = false;

   @CommandLine.Option(names = {"-e"}, description = "Execute the assembled prg file using VICE. Implicitly assembles the output.")
   private boolean execute = false;

   @CommandLine.Option(names = {"-d"}, description = "Debug the assembled prg file using C64Debugger. Implicitly assembles the output.")
   private boolean debug = false;

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

   @CommandLine.Option(names = {"-Ocache"}, description = "Optimization Option. Enables a fragment cache file.")
   private boolean optimizeFragmentCache = false;

   @CommandLine.Option(names = {"-v"}, description = "Verbose output describing the compilation process")
   private boolean verbose = false;

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

   @CommandLine.Option(names = {"-fragment"}, description = "Print the ASM code for a named fragment. The fragment is loaded/synthesized and the ASM variations are written to the output.")
   private String fragment = null;

   @CommandLine.Option(names = {"-S", "-Sc"}, description = "Interleave comments with C source code in the generated ASM.")
   private boolean interleaveSourceCode = false;

   @CommandLine.Option(names = {"-Sl"}, description = "Interleave comments with C source file name and line number in the generated ASM.")
   private boolean interleaveSourceFile = false;

   @CommandLine.Option(names = {"-Si"}, description = "Interleave comments with intermediate language code and ASM fragment names in the generated ASM.")
   private boolean interleaveIclFile = false;

   @CommandLine.Option(names = {"-t", "-target"}, description = "The target system. Default is C64 with BASIC upstart. ")
   private String target = TargetPlatform.C64BASIC.getName();

   @CommandLine.Option(names = {"-cpu"}, description = "The target CPU. Default is 6502 with illegal opcodes. ")
   private String cpu = TargetCpu.MOS6502X.getName();

   @CommandLine.Option(names = {"-T", "-link"}, description = "Link using a linker script in KickAss segment format.")
   private String linkScript = null;

   /** Program Exit Code signaling a compile error. */
   public static final int COMPILE_ERROR = 1;

   public static void main(String[] args) {
      CommandLine.call(new KickC(), args);
   }

   @Override
   public Void call() throws Exception {
      System.out.println("//--------------------------------------------------");
      System.out.println("//   " + getVersion() + " by Jesper Gravgaard   ");
      System.out.println("//--------------------------------------------------");

      Compiler compiler = new Compiler();

      if(target!=null) {
         TargetPlatform targetPlatform = TargetPlatform.getTargetPlatform(target);
         if(targetPlatform==null) {
            System.err.println("Unknown target platform "+target);
            StringBuffer supported = new StringBuffer();
            supported.append("The supported target platforms are: ");
            for(TargetPlatform value : TargetPlatform.values()) {
               supported.append(value.getName()).append(" ");
            }
            System.err.println(supported);
            System.exit(COMPILE_ERROR);
         }
         compiler.setTargetPlatform(targetPlatform);
      }

      if(cpu!=null) {
         TargetCpu targetCpu = TargetCpu.getTargetCpu(cpu);
         if(targetCpu==null) {
            System.err.println("Unknown target CPU "+cpu);
            StringBuffer supported = new StringBuffer();
            supported.append("The supported target CPUs are: ");
            for(TargetCpu value : TargetCpu.values()) {
               supported.append(value.getName()).append(" ");
            }
            System.err.println(supported);
            System.exit(COMPILE_ERROR);
         }
         compiler.setTargetCpu(targetCpu);
      }

      if(libDir != null) {
         for(Path libPath : libDir) {
            compiler.addImportPath(libPath.toString());
         }
      }

      if(fragmentDir == null) {
         fragmentDir = new File("fragment/").toPath();
      }

      Path fragmentCacheDir = null;
      if(optimizeFragmentCache) {
         if(outputDir != null) {
            fragmentCacheDir = outputDir;
         } else {
            fragmentCacheDir = new File(".").toPath();
         }
      }

      configVerbosity(compiler);

      compiler.setAsmFragmentBaseFolder(fragmentDir);
      compiler.setAsmFragmentCacheFolder(fragmentCacheDir);
      compiler.initAsmFragmentSynthesizer();

      if(fragment != null) {
         if(verbose) {
            compiler.getLog().setVerboseFragmentLog(true);
         }
         compiler.getLog().setSysOut(true);
         Collection<AsmFragmentTemplate> fragmentTemplates = compiler.getAsmFragmentSynthesizer().getBestTemplates(fragment, compiler.getLog());
         for(AsmFragmentTemplate fragmentTemplate : fragmentTemplates) {
            AsmFragmentTemplateUsages.logTemplate(compiler.getLog(), fragmentTemplate, "");
         }
      }

      if(kcFile != null) {

         String fileBaseName = getFileBaseName(kcFile);

         Path kcFileDir = kcFile.getParent();
         if(kcFileDir == null) {
            kcFileDir = FileSystems.getDefault().getPath(".");
         }

         if(outputDir == null) {
            outputDir = kcFileDir;
         }
         if(!Files.exists(outputDir)) {
            Files.createDirectory(outputDir);
         }

         if(asmFileName == null) {
            asmFileName = fileBaseName + ".asm";
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

         if(warnFragmentMissing) {
            compiler.setWarnFragmentMissing(true);
         }

         if(linkScript!=null) {
            compiler.setLinkScriptFileName(linkScript);
         }

         System.out.println("Compiling " + kcFile);
         Program program = null;
         try {
            program = compiler.compile(kcFile.toString());
         } catch(CompileError e) {
            // Print the error and exit with compile error
            System.err.println(e.getMessage());
            System.exit(COMPILE_ERROR);
         }

         Path asmPath = outputDir.resolve(asmFileName);
         System.out.println("Writing asm file " + asmPath);
         FileOutputStream asmOutputStream = new FileOutputStream(asmPath.toFile());
         OutputStreamWriter asmWriter = new OutputStreamWriter(asmOutputStream);
         String asmCodeString = program.getAsm().toString(new AsmProgram.AsmPrintState(interleaveSourceFile, interleaveSourceCode, interleaveIclFile, false), program);
         asmWriter.write(asmCodeString);
         asmWriter.close();
         asmOutputStream.close();

         compiler.getAsmFragmentSynthesizer().finalize(compiler.getLog());

         // Copy Resource Files (if out-dir is different from in-dir)
         if(!kcFileDir.toAbsolutePath().equals(outputDir.toAbsolutePath())) {
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
         Path prgPath = outputDir.resolve(fileBaseName + ".prg");
         if(assemble || execute || debug) {
            Path kasmLogPath = outputDir.resolve(fileBaseName + ".klog");
            System.out.println("Assembling to " + prgPath.toString());
            ByteArrayOutputStream kasmLogOutputStream = new ByteArrayOutputStream();
            String[] assembleCommand = {asmPath.toString(), "-log", kasmLogPath.toString(), "-o", prgPath.toString(), "-vicesymbols", "-showmem", "-debugdump"};
            if(verbose) {
               System.out.print("Assembling command: java -jar kickassembler-5.9.jar ");
               for(String cmd : assembleCommand) {
                  System.out.print(cmd + " ");
               }
               System.out.println();
            }
            System.setOut(new PrintStream(kasmLogOutputStream));
            int kasmResult = -1;
            try {
               CharToPetsciiConverter.setCurrentEncoding("screencode_mixed");
               kasmResult = KickAssembler.main2(assembleCommand);
            } catch(Throwable e) {
               throw new CompileError("KickAssembling file failed! ", e);
            } finally {
               System.setOut(new PrintStream(new FileOutputStream(FileDescriptor.out)));
            }
            System.setOut(new PrintStream(new FileOutputStream(FileDescriptor.out)));
            if(kasmResult != 0) {
               throw new CompileError("KickAssembling file failed! " + kasmLogOutputStream.toString());
            }
         }

         // Debug the prg-file if instructed
         if(debug) {
            System.out.println("Debugging " + prgPath);
            Path viceSymbolsPath = outputDir.resolve(fileBaseName + ".vs");
            String debugCommand = "C64Debugger " + "-symbols " + viceSymbolsPath + " -wait 2500" + " -prg " + prgPath.toString();
            if(verbose) {
               System.out.println("Debugging command: " + debugCommand);
            }
            Process process = Runtime.getRuntime().exec(debugCommand);
            process.waitFor();
         }

         // Execute the prg-file if instructed
         if(execute) {
            System.out.println("Executing " + prgPath);
            Path viceSymbolsPath = outputDir.resolve(fileBaseName + ".vs");
            String executeCommand = "x64 " + "-moncommands " + viceSymbolsPath + " " + prgPath.toString();
            if(verbose) {
               System.out.println("Executing command:  " + executeCommand);
            }
            Process process = Runtime.getRuntime().exec(executeCommand);
            process.waitFor();
         }

      }



      return null;
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

   String getFileBaseName(Path file) {
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

}

package dk.camelot64.kickc;

import dk.camelot64.kickc.fragment.AsmFragmentTemplate;
import dk.camelot64.kickc.fragment.AsmFragmentTemplateSynthesizer;
import dk.camelot64.kickc.fragment.AsmFragmentTemplateUsages;
import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.Program;
import kickass.KickAssembler;
import picocli.CommandLine;

import java.io.*;
import java.nio.file.*;
import java.util.Collection;
import java.util.List;
import java.util.concurrent.Callable;

/** KickC Commandline */
@CommandLine.Command(
      description = "Compiles a KickC source file, creating a KickAssembler source file. " +
            "KickC is a compiler for a C-family language creating optimized and readable 6502 assembler code.%n%n" +
            "See https://gitlab.com/camelot/kickc for detailed information about KickC.",
      name = "kickc",
      mixinStandardHelpOptions = true,
      headerHeading = "Usage:%n%n",
      synopsisHeading = "  ",
      descriptionHeading = "%nDescription:%n%n",
      parameterListHeading = "%nParameters:%n",
      optionListHeading = "%nOptions:%n",
      version = "KickC 0.6.x BETA (master)"
)
public class KickC implements Callable<Void> {

   @CommandLine.Parameters(index = "0", arity="0..1", description = "The KickC source file to compile.")
   private Path kcFile = null;

   @CommandLine.Option(names = {"-I", "-libdir" }, description = "Path to a library folder, where the compiler looks for included files. This option can be repeated to add multiple library folders.")
   private List<Path> libDir = null;

   @CommandLine.Option(names = {"-F", "-fragmentdir" }, description = "Path to the ASM fragment folder, where the compiler looks for ASM fragments.")
   private Path fragmentDir = null;

   @CommandLine.Option(names = {"-o"}, description = "Name of the output assembler file. By default it is the same as the input file with extension .asm")
   private String asmFileName = null;

   @CommandLine.Option(names = {"-odir" }, description = "Path to the output folder, where the compiler places all generated files. By default the folder of the output file is used.")
   private Path outputDir = null;

   @CommandLine.Option(names = {"-a"}, description = "Assemble the output file using KickAssembler. Produces a .prg file.")
   private boolean assemble = false;

   @CommandLine.Option(names = {"-e"}, description = "Execute the assembled prg file using VICE. Implicitly assembles the output.")
   private boolean execute = false;

   @CommandLine.Option(names = {"-Ouplift" }, description = "Optimization Option. Number of combinations to test when uplifting variables to registers in a scope. By default 100 combinations are tested.")
   private Integer optimizeUpliftCombinations = null;

   @CommandLine.Option(names = {"-v" }, description = "Verbose output describing the compilation process")
   private boolean verbose= false;

   @CommandLine.Option(names = {"-vparse" }, description = "Verbosity Option. File Parsing.")
   private boolean verboseParse = false;

   @CommandLine.Option(names = {"-vcreate" }, description = "Verbosity Option. Creation of the Single Static Assignment Control Flow Graph.")
   private boolean verboseCreateSsa = false;

   @CommandLine.Option(names = {"-voptimize" }, description = "Verbosity Option. Control Flow Graph Optimization.")
   private boolean verboseSSAOptimize = false;

   @CommandLine.Option(names = {"-vnonoptimize" }, description = "Verbosity Option. Choices not to optimize.")
   private boolean verboseNonOptimization = false;

   @CommandLine.Option(names = {"-vsequence" }, description = "Verbosity Option. Sequence Plan.")
   private boolean verboseSequencePlan = false;

   @CommandLine.Option(names = {"-vloop" }, description = "Verbosity Option. Loop Analysis.")
   private boolean verboseLoopAnalysis = false;

   @CommandLine.Option(names = {"-vliverange" }, description = "Verbosity Option. Variable Live Range Analysis.")
   private boolean verboseLiveRanges = false;

   @CommandLine.Option(names = {"-vuplift" }, description = "Verbosity Option. Variable Register Uplift Combination Optimization.")
   private boolean verboseUplift = false;

   @CommandLine.Option(names = {"-vunroll" }, description = "Verbosity Option. Loop Unrolling.")
   private boolean verboseLoopUnroll = false;

   @CommandLine.Option(names = {"-vfragment" }, description = "Verbosity Option. Synthesis of Assembler fragments.")
   private boolean verboseFragments= false;

   @CommandLine.Option(names = {"-vasmoptimize" }, description = "Verbosity Option. Assembler optimization.")
   private boolean verboseAsmOptimize = false;

   @CommandLine.Option(names = {"-fragment" }, description = "Print the ASM code for a named fragment. The fragment is loaded/synthesized and the ASM variations are written to the output.")
   private String fragment = null;

   public static void main(String[] args) {
      CommandLine.call(new KickC(), args);
   }

   @Override
   public Void call() throws Exception {
      System.out.println("//-------------------------------------------");
      System.out.println("//   " + getVersion() + " by Jesper Gravgaard   ");
      System.out.println("//-------------------------------------------");

      Compiler compiler = new Compiler();

      if(libDir != null) {
         for(Path libPath : libDir) {
            compiler.addImportPath(libPath.toString());
         }
      }

      if(fragmentDir!= null) {
         AsmFragmentTemplateSynthesizer.initialize(fragmentDir.toString()+"/");
      } else {
         AsmFragmentTemplateSynthesizer.initialize("fragment/");
      }

      if(fragment!=null) {
         configVerbosity(compiler);
         if(verbose) {
            compiler.getLog().setVerboseFragmentLog(true);
         }
         compiler.getLog().setSysOut(true);
         Collection<AsmFragmentTemplate> fragmentTemplates = AsmFragmentTemplateSynthesizer.getFragmentTemplates(fragment, compiler.getLog());
         for(AsmFragmentTemplate fragmentTemplate : fragmentTemplates) {
            AsmFragmentTemplateUsages.logTemplate(compiler.getLog(), fragmentTemplate, "");
         }
      }

      if(kcFile!=null) {

         configVerbosity(compiler);

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

         if(optimizeUpliftCombinations != null) {
            compiler.setUpliftCombinations(optimizeUpliftCombinations);
         }

         System.out.println("Compiling " + kcFile);
         Program program = compiler.compile(kcFile.toString());

         Path asmPath = outputDir.resolve(asmFileName);
         System.out.println("Writing asm file " + asmPath);
         FileOutputStream asmOutputStream = new FileOutputStream(asmPath.toFile());
         OutputStreamWriter asmWriter = new OutputStreamWriter(asmOutputStream);
         String asmCodeString = program.getAsm().toString(false);
         asmWriter.write(asmCodeString);
         asmWriter.close();
         asmOutputStream.close();

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
         if(assemble || execute) {
            Path kasmLogPath = outputDir.resolve(fileBaseName + ".klog");
            System.out.println("Assembling to " + prgPath.toString());
            ByteArrayOutputStream kasmLogOutputStream = new ByteArrayOutputStream();
            System.setOut(new PrintStream(kasmLogOutputStream));
            int kasmResult = KickAssembler.main2(new String[]{asmPath.toString(), "-log", kasmLogPath.toString(), "-o", prgPath.toString(), "-vicesymbols", "-showmem"});
            System.setOut(new PrintStream(new FileOutputStream(FileDescriptor.out)));
            if(kasmResult != 0) {
               throw new CompileError("KickAssembling file failed! " + kasmLogOutputStream.toString());
            }
         }

         // Execute the prg-file if instructed
         if(execute) {
            System.out.println("Executing " + prgPath);
            Process process = Runtime.getRuntime().exec("x64 " + prgPath.toString());
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

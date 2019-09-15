package dk.camelot64.kickc;

/**
 * Log of actions & results during compile
 */
public class CompileLog {

   private StringBuilder log;

   /**
    * Should register uplift analysis be verbose.
    */
   private boolean verboseUplift = false;

   /**
    * Should live range analysis be verbose.
    */
   private boolean verboseLiveRanges = false;

   /**
    * Should fragment synthesis be verbose.
    */
   private boolean verboseFragmentLog = false;

   /**
    * Should ASM optimization be verbose.
    */
   private boolean verboseAsmOptimize = false;

   /**
    * Should SSA optimization be verbose.
    */
   private boolean verboseSSAOptimize = false;

   /**
    * Should Memory usage be verbose
    */
   private boolean verboseMemoryUsage = false;

   /**
    * Should loop unrolling be verbose.
    */
   private boolean verboseLoopUnroll = false;

   /**
    * Should loop analysis be verbose.
    */
   private boolean verboseLoopAnalysis = false;

   /**
    * Should choices not to optimize be verbose.
    */
   private boolean verboseNonOptimization = false;

   /**
    * Should sequence planning be verbose.
    */
   private boolean verboseSequencePlan = false;

   /**
    * Should the parsing be verbose.
    */
   private boolean verboseParse = false;

   /**
    * Should the creation of the SSA be verbose.
    */
   private boolean verboseCreateSsa = false;

   /** Should comments be output as part of the intermediate SSA prints. */
   private boolean verboseComments = false;

   /**
    * Should the statement sequence be verbose.
    */
   private boolean verboseStatementSequence = false;

   /**
    * Print the C-source code for each SSA statement when printing the control flow graph
    */
   private boolean verboseSsaSourceCode = false;

   /**
    * Should the log be output to System.out while being built
    */
   private boolean sysOut = false;

   public CompileLog() {
      this.log = new StringBuilder();
   }

   public void append(String msg) {
      log.append(msg);
      log.append("\n");
      if(sysOut) {
         System.out.append(msg + "\n");
      }
   }

   public StringBuilder getLog() {
      return log;
   }

   public CompileLog verboseMemoryUsage() {
      setVerboseMemoryUsage(true);
      return this;
   }

   public boolean isVerboseMemoryUsage() {
      return verboseMemoryUsage;
   }

   public void setVerboseMemoryUsage(boolean verboseMemoryUsage) {
      this.verboseMemoryUsage = verboseMemoryUsage;
   }

   public CompileLog verboseSsaSourceCode() {
      setVerboseSsaSourceCode(true);
      return this;
   }

   public boolean isVerboseSsaSourceCode() {
      return verboseSsaSourceCode;
   }

   public void setVerboseSsaSourceCode(boolean verboseSsaSourceCode) {
      this.verboseSsaSourceCode = verboseSsaSourceCode;
   }

   public boolean isVerboseCreateSsa() {
      return verboseCreateSsa;
   }

   public boolean isVerboseStatementSequence() {
      return verboseStatementSequence;
   }

   public void setVerboseStatementSequence(boolean verboseStatementSequence) {
      this.verboseStatementSequence = verboseStatementSequence;
   }

   public CompileLog verboseStatementSequence() {
      setVerboseStatementSequence(true);
      return this;
   }

   public void setVerboseComments(boolean verboseComments) {
      this.verboseComments = verboseComments;
   }

   public void setVerboseLoopUnroll(boolean verboseLoopUnroll) {
      this.verboseLoopUnroll = verboseLoopUnroll;
   }

   public CompileLog verboseLoopUnroll() {
      setVerboseLoopUnroll(true);
      return this;
   }

   public void setVerboseLoopAnalysis(boolean verboseLoopAnalysis) {
      this.verboseLoopAnalysis = verboseLoopAnalysis;
   }

   public CompileLog verboseLoopAnalysis() {
      setVerboseLoopAnalysis(true);
      return this;
   }

   public void setVerboseNonOptimization(boolean verboseNonOptimization) {
      this.verboseNonOptimization = verboseNonOptimization;
   }

   public void setVerboseSequencePlan(boolean verboseSequencePlan) {
      this.verboseSequencePlan = verboseSequencePlan;
   }

   public CompileLog verboseParse() {
      setVerboseParse(true);
      return this;
   }

   public void setVerboseParse(boolean verboseParse) {
      this.verboseParse = verboseParse;
   }

   public CompileLog verboseCreateSsa() {
      setVerboseCreateSsa(true);
      return this;
   }

   public void setVerboseCreateSsa(boolean verboseCreateSsa) {
      this.verboseCreateSsa = verboseCreateSsa;
   }

   public boolean isVerboseUplift() {
      return verboseUplift;
   }

   public CompileLog verboseUplift() {
      setVerboseUplift(true);
      return this;
   }

   public void setVerboseUplift(boolean verboseUplift) {
      this.verboseUplift = verboseUplift;
   }

   public boolean isVerboseLiveRanges() {
      return verboseLiveRanges;
   }

   public void setVerboseLiveRanges(boolean verboseLiveRanges) {
      this.verboseLiveRanges = verboseLiveRanges;
   }

   public CompileLog verboseLiveRanges() {
      setVerboseLiveRanges(true);
      return this;
   }

   public boolean isVerboseFragmentLog() {
      return verboseFragmentLog;
   }

   public void setVerboseFragmentLog(boolean verboseFragmentLog) {
      this.verboseFragmentLog = verboseFragmentLog;
   }

   public CompileLog verboseFragmentLog() {
      setVerboseFragmentLog(true);
      return this;
   }

   public boolean isVerboseAsmOptimize() {
      return verboseAsmOptimize;
   }

   public void setVerboseAsmOptimize(boolean verboseAsmOptimize) {
      this.verboseAsmOptimize = verboseAsmOptimize;
   }

   public boolean isVerboseSSAOptimize() {
      return verboseSSAOptimize;
   }

   public CompileLog verboseSSAOptimize() {
      setVerboseSSAOptimize(true);
      return this;
   }


   public void setVerboseSSAOptimize(boolean verboseSSAOptimize) {
      this.verboseSSAOptimize = verboseSSAOptimize;
   }

   public boolean isVerboseLoopUnroll() {
      return verboseLoopUnroll;
   }

   public boolean isVerboseLoopAnalysis() {
      return verboseLoopAnalysis;
   }

   public boolean isVerboseNonOptimization() {
      return verboseNonOptimization;
   }

   public boolean isVerboseSequencePlan() {
      return verboseSequencePlan;
   }

   public boolean isVerboseParse() {
      return verboseParse;
   }

   public boolean isVerbosePass1CreateSsa() {
      return verboseCreateSsa;
   }

   public boolean isSysOut() {
      return sysOut;
   }

   public void setSysOut(boolean sysOut) {
      this.sysOut = sysOut;
   }

   @Override
   public String toString() {
      return log.toString();
   }

   public boolean isVerboseComments() {
      return verboseComments;
   }
}

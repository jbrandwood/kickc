package dk.camelot64.kickc;

/**  Log of actions & results during compile*/
public class CompileLog {

   private StringBuilder log;

   /** Should register uplift analysis be verbose. */
   private boolean verboseUplift;

   /** Should live range analysis be verbose. */
   private boolean verboseLiveRanges;

   public CompileLog() {
      this.log = new StringBuilder();
   }

   public void append(String msg) {
      log.append(msg);
      log.append("\n");
      System.out.append(msg+"\n");
   }

   public StringBuilder getLog() {
      return log;
   }

   public boolean isVerboseUplift() {
      return verboseUplift;
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

   @Override
   public String toString() {
      return log.toString();
   }
}

package dk.camelot64.kickc;

/**  Log of actions & results during compile*/
public class CompileLog {

   private StringBuilder log;

   private boolean verboseUplift;

   public CompileLog() {
      this.log = new StringBuilder();
   }

   public void append(String msg) {
      log.append(msg);
      log.append("\n");
      System.out.printf(msg+"\n");
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

   @Override
   public String toString() {
      return log.toString();
   }
}

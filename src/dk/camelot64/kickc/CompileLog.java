package dk.camelot64.kickc;

/**  Log of actions & results during compile*/
public class CompileLog {

   StringBuilder log;

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

   @Override
   public String toString() {
      return log.toString();
   }
}

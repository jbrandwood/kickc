package dk.camelot64.kickc.icl;

/**
 * Return Statement inside procedure in Single Static Assignment Form.
 */
public class StatementReturn implements Statement {

   /** Return value. May be null if not returning a value. */
   private RValue value;

   public StatementReturn(RValue value) {
      this.value = value;
   }

   public RValue getValue() {
      return value;
   }

   public void setValue(RValue value) {
      this.value = value;
   }

   @Override
   public String toString() {
      return getAsString();
   }

   @Override
   public String getAsTypedString(ProgramScope scope) {
      return "return "+(value==null?"":value.getAsTypedString(scope));   }

   @Override
   public String getAsString() {
      return "return "+(value==null?"":value.getAsString());   }
}

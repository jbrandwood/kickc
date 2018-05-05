package dk.camelot64.kickc.model.statements;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.values.RValue;

/**
 * Return Statement inside procedure in Single Static Assignment Form.
 */
public class StatementReturn extends StatementBase {

   /**
    * Return value. May be null if not returning a value.
    */
   private RValue value;

   public StatementReturn(RValue value, StatementSource source) {
      super(null, source);
      this.value = value;
   }

   public RValue getValue() {
      return value;
   }

   public void setValue(RValue value) {
      this.value = value;
   }

   @Override
   public String toString(Program program, boolean aliveInfo) {
      return super.idxString() + "return " + (value == null ? "" : value.toString(program)) + (aliveInfo ? super.aliveString(program) : "");
   }

   @Override
   public boolean equals(Object o) {
      if(this == o) return true;
      if(o == null || getClass() != o.getClass()) return false;
      if(!super.equals(o)) return false;

      StatementReturn that = (StatementReturn) o;

      return value != null ? value.equals(that.value) : that.value == null;
   }

   @Override
   public int hashCode() {
      int result = super.hashCode();
      result = 31 * result + (value != null ? value.hashCode() : 0);
      return result;
   }
}

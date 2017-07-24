package dk.camelot64.kickc.icl;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * Return Statement inside procedure in Single Static Assignment Form.
 */
public class StatementReturn implements Statement {

   /** Return value. May be null if not returning a value. */
   private RValue value;

   @JsonCreator
   public StatementReturn( @JsonProperty("value") RValue value) {
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
      return toString(null);
   }

   @Override
   public String toString(ProgramScope scope) {
      return "return " + (value == null ? "" : value.toString(scope));
   }

   @Override
   public boolean equals(Object o) {
      if (this == o) return true;
      if (o == null || getClass() != o.getClass()) return false;

      StatementReturn that = (StatementReturn) o;

      return value != null ? value.equals(that.value) : that.value == null;
   }

   @Override
   public int hashCode() {
      return value != null ? value.hashCode() : 0;
   }
}

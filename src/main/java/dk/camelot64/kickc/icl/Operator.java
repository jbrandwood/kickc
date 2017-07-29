package dk.camelot64.kickc.icl;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;

/** An Operator. The operation performed on the rvalues in a Statement. */
public class Operator {

   private String operator;

   @JsonCreator
   public Operator(
         @JsonProperty("operator") String operator) {
      this.operator = operator;
   }

   public String getOperator() {
      return operator;
   }

   @Override
   public String toString() {
      return operator ;
   }

   @Override
   public boolean equals(Object o) {
      if (this == o) return true;
      if (o == null || getClass() != o.getClass()) return false;

      Operator operator1 = (Operator) o;

      return operator != null ? operator.equals(operator1.operator) : operator1.operator == null;
   }

   @Override
   public int hashCode() {
      return operator != null ? operator.hashCode() : 0;
   }
}

package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.Program;

/**
 * A union designator initializer.
 */
public class UnionDesignator implements RValue {

   private final String memberName;

   private final RValue rValue;

   public UnionDesignator(String memberName, RValue rValue) {
      this.memberName = memberName;
      this.rValue = rValue;
   }

   public String getMemberName() { return memberName; }

   public RValue getMemberValue() {
      return rValue;
   }

   @Override
   public String toString(Program program) {
      StringBuilder out = new StringBuilder();
      out.append("{ ");
      out.append(memberName);
      out.append("=");
      out.append(rValue.toString(program));
      out.append(" }");
      return out.toString();
   }

   @Override
   public String toString() {
      return toString(null);
   }
}

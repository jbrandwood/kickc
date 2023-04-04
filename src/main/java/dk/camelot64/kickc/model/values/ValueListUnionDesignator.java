package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.Program;

import java.util.ArrayList;
import java.util.List;

/**
 * A union designator initializer.
 * <p>
 * The init list will have length one.
 */
public class ValueListUnionDesignator extends ValueList {

   private String memberName;

   public ValueListUnionDesignator(String memberName, RValue rValue) {
      super(asList(rValue));
      this.memberName = memberName;
   }

   static List<RValue> asList(RValue rValue) {
      final ArrayList<RValue> list = new ArrayList<>();
      list.add(rValue);
      return list;
   }

   public String getMemberName() { return memberName; }

   public RValue getMemberValue() {
      return getList().get(0);
   }

   @Override
   public String toString(Program program) {
      StringBuilder out = new StringBuilder();
      out.append("{ ");
      out.append(memberName);
      out.append("=");
      out.append(getList().get(0).toString(program));
      out.append(" }");
      return out.toString();
   }

   @Override
   public String toString() {
      return toString(null);
   }
}

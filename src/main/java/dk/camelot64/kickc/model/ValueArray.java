package dk.camelot64.kickc.model;

import java.util.List;

/** An array of sub-values. Only used for variable initializers. Compilation execution will typically resolve it into a constant array before ASM-generation. */
public class ValueArray implements RValue {

   private List<RValue> list;

   public ValueArray(List<RValue> list) {
      this.list = list;
   }

   public List<RValue> getList() {
      return list;
   }

   @Override
   public String toString(Program program) {
      StringBuilder out = new StringBuilder();
      boolean first = true;
      out.append("{ ");
      for (RValue constantValue : list) {
         if (!first) {
            out.append(", ");
         }
         first = false;
         out.append(constantValue.toString(program));
      }
      out.append(" }");
      return out.toString();
   }

}

package dk.camelot64.kickc.model;

import java.util.List;

/** A list of sub-values. Used for array variable initializers and word from byte constructors
 * (in the future also usable for dword from byte, dword from double etc.).
 * Compilation execution will resolve into a constant array,
 * constant word or word constructor operator before ASM-generation. */
public class ValueList implements RValue {

   private List<RValue> list;

   public ValueList(List<RValue> list) {
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

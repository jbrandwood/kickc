package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.Program;

import java.util.List;

/**
 * A list of sub-values.
 * Used for array variable initializers, struct value initilizers, word/dword initializers.
 */
public class ValueList implements LValue {

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
      for(RValue constantValue : list) {
         if(!first) {
            out.append(", ");
         }
         first = false;
         out.append(constantValue.toString(program));
      }
      out.append(" }");
      return out.toString();
   }

   @Override
   public String toString() {
      return toString(null);
   }
}

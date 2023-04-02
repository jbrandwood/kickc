package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.Program;

import java.util.HashMap;
import java.util.List;

/**
 * A list of sub-values.
 * Used for struct value initializers.
 */
public class ValueStructList extends ValueList {

   private HashMap<RValue, String> members;

   public ValueStructList(HashMap<RValue, String> members, List<RValue> list) {
      super(list);
      this.members = members;
   }

   public HashMap<RValue, String> getMembers() {
      return members;
   }
   public String getMember(RValue init) { return members.get(init); }

   @Override
   public String toString(Program program) {
      StringBuilder out = new StringBuilder();
      boolean first = true;
      out.append("{ ");
      for(RValue constantValue : getList()) {
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

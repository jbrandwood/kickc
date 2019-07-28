package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.ConstantNotLiteral;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**  A constant struct value. */
public class ConstantStructValue implements ConstantValue {

   /** The type of the struct. */
   private SymbolTypeStruct structType;

   /** The values of the members. */
   private Map<VariableRef, ConstantValue> values;

   public ConstantStructValue(SymbolTypeStruct structType, Map<VariableRef, ConstantValue> values) {
      this.structType = structType;
      this.values = values;
   }

   @Override
   public SymbolType getType(ProgramScope scope) {
      return structType;
   }

   @Override
   public ConstantLiteral calculateLiteral(ProgramScope scope) {
      throw new ConstantNotLiteral("Cannot calculate literal struct.");
   }

   public SymbolTypeStruct getStructType() {
      return structType;
   }

   /**
    * Get the members of the struct
    * @return list of variable refs representing the members
    */
   public List<VariableRef> getMembers() {
      return new ArrayList<>(values.keySet());
   }

   /**
    * Get the value of a specific member
    * @param memberRef The variable ref of the member
    * @return The constant value of the member
    */
   public ConstantValue getValue(VariableRef memberRef) {
      return values.get(memberRef);
   }

   /**
    * Set the value of a specific member
    * @param memberRef The variable ref of the member
    * @param value The new constant value of the member
    */
   public void setValue(VariableRef memberRef, ConstantValue value) {
      values.put(memberRef, value);
   }

   @Override
   public String toString() {
      return toString(null);
   }

   @Override
   public String toString(Program program) {
      StringBuilder out = new StringBuilder();
      boolean first = true;
      out.append("{ ");
      for(VariableRef memberRef : getMembers()) {
         if(!first) {
            out.append(", ");
         }
         first = false;
         out.append(memberRef.getLocalName()+": "+getValue(memberRef).toString(program));
      }
      out.append(" }");
      return out.toString();
   }

}

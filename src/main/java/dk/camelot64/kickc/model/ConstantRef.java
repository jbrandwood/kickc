package dk.camelot64.kickc.model;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;

/** A reference to a named Constant (in the symbol table) */
public class ConstantRef extends SymbolRef implements ConstantValue {

   @JsonCreator
   public ConstantRef(
         @JsonProperty("fullName") String fullName) {
      super(fullName);
   }

   public ConstantRef(ConstantVar constantVar) {
      super(constantVar.getFullName());
   }

   @Override
   public SymbolType getType(ProgramScope scope) {
      ConstantVar constant = scope.getConstant(this);
      return constant.getType();
   }

}

package dk.camelot64.kickc.icl;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;

/**  A function returning another type */
public class SymbolTypeProcedure implements SymbolType {

   private SymbolType returnType;

   @JsonCreator
   public SymbolTypeProcedure(
         @JsonProperty("returnType") SymbolType returnType) {
      this.returnType = returnType;
   }

   public SymbolType getReturnType() {
      return returnType;
   }

   @Override
   @JsonIgnore
   public String getTypeName() {
      return returnType.getTypeName() + "()";
   }
}

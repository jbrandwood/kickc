package dk.camelot64.kickc.icl;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.HashMap;

/** The program scope containing the symbols of a program */
public class ProgramScope extends Scope {

   private RegisterAllocation allocation;

   public ProgramScope() {
      super("", null);
   }

   @JsonCreator
   private ProgramScope(
         @JsonProperty("name") String name,
         @JsonProperty("symbols") HashMap<String, Symbol> symbols,
         @JsonProperty("intermediateVarCount") int intermediateVarCount,
         @JsonProperty("intermediateLabelCount") int intermediateLabelCount,
         @JsonProperty("allocation") RegisterAllocation allocation) {
      super(name, symbols, intermediateVarCount, intermediateLabelCount);
      this.allocation = allocation;
   }

   @Override
   public SymbolType getType() {
      return new SymbolTypeProgram();
   }

   public void setAllocation(RegisterAllocation allocation) {
      this.allocation = allocation;
   }

   public RegisterAllocation.Register getRegister(Variable variable) {
      RegisterAllocation.Register register = null;
      if (allocation != null) {
         register = allocation.getRegister(variable);
      }
      return register;
   }

   @Override
   RegisterAllocation getAllocation() {
      return allocation;
   }

   @Override
   public boolean equals(Object o) {
      if (this == o) {
         return true;
      }
      if (o == null || getClass() != o.getClass()) {
         return false;
      }
      if (!super.equals(o)) {
         return false;
      }

      ProgramScope that = (ProgramScope) o;

      return allocation != null ? allocation.equals(that.allocation) : that.allocation == null;
   }

   @Override
   public int hashCode() {
      int result = super.hashCode();
      result = 31 * result + (allocation != null ? allocation.hashCode() : 0);
      return result;
   }

   @Override
   public String getAsTypedString(ProgramScope scope) {
      return getAsString();
   }

   @Override
   @JsonIgnore
   public String getAsString() {
      return "program";
   }

}

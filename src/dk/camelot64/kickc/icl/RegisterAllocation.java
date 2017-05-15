package dk.camelot64.kickc.icl;


import java.util.HashMap;
import java.util.Map;

/** Register Allocation for Variable Symbols  */
public class RegisterAllocation {

   private Map<Variable, Register> allocation;

   public RegisterAllocation() {
      this.allocation = new HashMap<>();
   }

   /**
    * Get the register allocated for a specific variable
    *
    * @param variable The variable
    * @return The allocated register.
    */
   public Register getRegister(Variable variable) {
      return allocation.get(variable);
   }

   public void allocate(Variable variable, Register register) {
      allocation.put(variable, register);
   }

   /** A register used for storing a single variable. */
   public interface Register {

      RegisterType getType();

   }

   /** The register type. */
   public enum RegisterType { ZP };

   /** A zero page address used as a register for a single byte variable. */
   public static class RegisterZp implements Register {

      private int zp;

      public RegisterZp(int zp) {
         this.zp = zp;
      }

      public int getZp() {
         return zp;
      }

      @Override
      public RegisterType getType() {
         return  RegisterType.ZP;
      }

      @Override
      public String toString() {
         return "zp:"+zp;
      }
   }

   @Override
   public String toString() {
      StringBuffer out = new StringBuffer();
      for (Variable variable : allocation.keySet()) {
         Register register = getRegister(variable);
         out.append(variable+" : "+register+"\n");
      }
      return out.toString();
   }
}

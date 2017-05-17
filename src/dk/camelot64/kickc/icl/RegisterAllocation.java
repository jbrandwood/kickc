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
   public enum RegisterType {
      ZP_BYTE, ZP_BOOL, REG_X_BYTE
   };

   /** A zero page address used as a register for a single byte variable. */
   public static class RegisterZpByte implements Register {

      private int zp;

      public RegisterZpByte(int zp) {
         this.zp = zp;
      }

      public int getZp() {
         return zp;
      }

      @Override
      public RegisterType getType() {
         return  RegisterType.ZP_BYTE;
      }

      @Override
      public String toString() {
         return "zp byte:"+zp;
      }
   }

   /** A zero page address used as a register for a boolean variable. */
   public static class RegisterZpBool implements Register {
      private int zp;

      public RegisterZpBool(int zp) {
         this.zp = zp;
      }

      public int getZp() {
         return zp;
      }

      @Override
      public RegisterType getType() {
         return  RegisterType.ZP_BOOL;
      }

      @Override
      public String toString() {
         return "zp bool:"+zp;
      }
   }

   /** The X register. */
   public static class RegisterXByte implements Register {
      @Override
      public RegisterType getType() {
         return RegisterType.REG_X_BYTE;
      }

      @Override
      public String toString() {
         return "reg byte x";
      }
   }

   public static Register getRegisterX() {
      return new RegisterXByte();
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

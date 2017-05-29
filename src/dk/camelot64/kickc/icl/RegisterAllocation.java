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
   public interface Register extends Value {

      RegisterType getType();

   }

   /** The register type. */
   public enum RegisterType {
      ZP_BYTE, ZP_BOOL, REG_Y_BYTE, REG_X_BYTE, ZP_PTR_BYTE, ZP_WORD
   }

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

      @Override
      public boolean equals(Object o) {
         if (this == o) return true;
         if (o == null || getClass() != o.getClass()) return false;
         RegisterZpByte that = (RegisterZpByte) o;
         return zp == that.zp;
      }

      @Override
      public int hashCode() {
         return zp;
      }
   }

   /** Two zero page addresses used as a register for a single word variable. */
   public static class RegisterZpWord implements Register {

      private int zp;

      public RegisterZpWord(int zp) {
         this.zp = zp;
      }

      public int getZp() {
         return zp;
      }

      @Override
      public RegisterType getType() {
         return  RegisterType.ZP_WORD;
      }

      @Override
      public String toString() {
         return "zp word :"+zp;
      }

      @Override
      public boolean equals(Object o) {
         if (this == o) return true;
         if (o == null || getClass() != o.getClass()) return false;
         RegisterZpWord that = (RegisterZpWord) o;
         return zp == that.zp;
      }

      @Override
      public int hashCode() {
         return zp;
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

      @Override
      public boolean equals(Object o) {
         if (this == o) return true;
         if (o == null || getClass() != o.getClass()) return false;
         RegisterZpBool that = (RegisterZpBool) o;
         return zp == that.zp;
      }

      @Override
      public int hashCode() {
         return zp;
      }
   }

   /** A zro page address pair used as a register containing a pointer to a byte. */
   public static class RegisterZpPointerByte implements Register {
      private int zp;

      public RegisterZpPointerByte(int zp) {
         this.zp = zp;
      }

      @Override
      public RegisterType getType() {
         return RegisterType.ZP_PTR_BYTE;
      }

      @Override
      public String toString() {
         return "zp ptr byte:"+zp;
      }

      @Override
      public boolean equals(Object o) {
         if (this == o) return true;
         if (o == null || getClass() != o.getClass()) return false;
         RegisterZpPointerByte that = (RegisterZpPointerByte) o;
         return zp == that.zp;
      }

      @Override
      public int hashCode() {
         return zp;
      }

      public int getZp() {
         return zp;
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

      @Override
      public boolean equals(Object obj) {
         if (this == obj) return true;
         if (obj == null || getClass() != obj.getClass()) return false;
         return true;
      }
   }

   /** The Y register. */
   public static class RegisterYByte implements Register {
      @Override
      public RegisterType getType() {
         return RegisterType.REG_Y_BYTE;
      }

      @Override
      public String toString() {
         return "reg byte y";
      }

      @Override
      public boolean equals(Object obj) {
         if (this == obj) return true;
         if (obj == null || getClass() != obj.getClass()) return false;
         return true;
      }
   }

   public static Register getRegisterX() {
      return new RegisterXByte();
   }

   public static Register getRegisterY() {
      return new RegisterYByte();
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

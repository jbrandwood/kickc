package dk.camelot64.kickc.icl;


import java.util.LinkedHashMap;
import java.util.Map;

/** Register Allocation for Variable Symbols  */
public class RegisterAllocation {

   private Map<VariableRef, Register> allocation;

   public RegisterAllocation() {
      this.allocation = new LinkedHashMap<>();
   }

   /**
    * Get the register allocated for a specific variable
    *
    * @param variable The variable
    * @return The allocated register.
    */
   public Register getRegister(VariableRef ref) {
      return allocation.get(ref);
   }


   public void setRegister(VariableRef variable, Register register) {
      if(variable!=null) {
         allocation.put(variable, register);
      }
   }

   /** A register used for storing a single variable. */
   public interface Register extends Value {

      RegisterType getType();

      boolean isZp();

   }

   /** The register type. */
   public enum RegisterType {
      ZP_BYTE, ZP_BOOL, REG_A_BYTE, REG_ALU_BYTE, REG_Y_BYTE, REG_X_BYTE, ZP_PTR_BYTE, ZP_WORD
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
      public boolean isZp() {
         return true;
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

      @Override
      public String toString(ProgramScope scope) {
         return toString();
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
      public boolean isZp() {
         return true;
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

      @Override
      public String toString(ProgramScope scope) {
         return toString();
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
      public boolean isZp() {
         return true;
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

      @Override
      public String toString(ProgramScope scope) {
         return toString();
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
      public boolean isZp() {
         return true;
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

      @Override
      public String toString(ProgramScope scope) {
         return toString();
      }

   }


   /** The X register. */
   public static class RegisterXByte implements Register {
      @Override
      public RegisterType getType() {
         return RegisterType.REG_X_BYTE;
      }

      @Override
      public boolean isZp() {
         return false;
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

      @Override
      public String toString(ProgramScope scope) {
         return toString();
      }

   }

   /** The Y register. */
   public static class RegisterYByte implements Register {
      @Override
      public RegisterType getType() {
         return RegisterType.REG_Y_BYTE;
      }

      @Override
      public boolean isZp() {
         return false;
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

      @Override
      public String toString(ProgramScope scope) {
         return toString();
      }

   }

   /** The A register. */
   public static class RegisterAByte implements Register {
      @Override
      public RegisterType getType() {
         return RegisterType.REG_A_BYTE;
      }

      @Override
      public boolean isZp() {
         return false;
      }

      @Override
      public String toString() {
         return "reg byte a";
      }

      @Override
      public boolean equals(Object obj) {
         if (this == obj) return true;
         if (obj == null || getClass() != obj.getClass()) return false;
         return true;
      }

      @Override
      public String toString(ProgramScope scope) {
         return toString();
      }

   }

   /** The special ALU register. */
   public static class RegisterALUByte implements Register {
      @Override
      public RegisterType getType() {
         return RegisterType.REG_ALU_BYTE;
      }

      @Override
      public boolean isZp() {
         return false;
      }

      @Override
      public String toString() {
         return "reg byte alu";
      }

      @Override
      public boolean equals(Object obj) {
         if (this == obj) return true;
         if (obj == null || getClass() != obj.getClass()) return false;
         return true;
      }

      @Override
      public String toString(ProgramScope scope) {
         return toString();
      }

   }

   public static Register getRegisterX() {
      return new RegisterXByte();
   }

   public static Register getRegisterY() {
      return new RegisterYByte();
   }

   public static Register getRegisterA() {
      return new RegisterAByte();
   }

   public static Register getRegisterALU() {
      return new RegisterALUByte();
   }

   @Override
   public String toString() {
      StringBuffer out = new StringBuffer();
      for (VariableRef var: allocation.keySet()) {
         Register register = getRegister(var);
         out.append(var.toString()+" : "+register.toString()+"\n");
      }
      return out.toString();
   }

}

package dk.camelot64.kickc.model;

/** The different registers available for a program */
public class Registers {


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

   /** The register type. */
   public enum RegisterType {
      REG_A_BYTE,
      REG_Y_BYTE,
      REG_X_BYTE,
      REG_ALU,
      ZP_BYTE,
      ZP_WORD,
      ZP_DWORD,
      ZP_BOOL,
      CONSTANT
   }

   /** A register used for storing a single variable. */
   public interface Register extends Value {

      RegisterType getType();

      boolean isZp();

   }

   public static abstract class RegisterZp implements Register {

      /** The ZP address used for the byte. */
      private int zp;

      public RegisterZp(int zp) {
         this.zp = zp;
      }

      public int getZp() {
         return zp;
      }

      @Override
      public boolean isZp() {
         return true;
      }

      @Override
      public String toString() {
         return "zp " + getType().toString() + ":" + zp;
      }

      @Override
      public String toString(Program program) {
         return toString();
      }

      @Override
      public boolean equals(Object o) {
         if(this == o) {
            return true;
         }
         if(o == null || getClass() != o.getClass()) {
            return false;
         }

         RegisterZp that = (RegisterZp) o;

         return zp == that.zp;
      }

      @Override
      public int hashCode() {
         return zp;
      }
   }


   /** A zero page address used as a register for a single unsigned byte variable. */
   public static class RegisterZpByte extends RegisterZp {

      public RegisterZpByte(int zp) {
         super(zp);
      }

      @Override
      public RegisterType getType() {
         return RegisterType.ZP_BYTE;
      }


   }

   /** Two zero page addresses used as a register for a single unsigned word variable. */
   public static class RegisterZpWord extends RegisterZp {

      public RegisterZpWord(int zp) {
         super(zp);
      }

      @Override
      public RegisterType getType() {
         return RegisterType.ZP_WORD;
      }

   }

   /** Four zero page addresses used as a register for a single unsigned word variable. */
   public static class RegisterZpDWord extends RegisterZp {

      public RegisterZpDWord(int zp) {
         super(zp);
      }

      @Override
      public RegisterType getType() {
         return RegisterType.ZP_DWORD;
      }

   }


   /** A zero page address used as a register for a boolean variable. */
   public static class RegisterZpBool extends RegisterZp {

      public RegisterZpBool(int zp) {
         super(zp);
      }

      @Override
      public RegisterType getType() {
         return RegisterType.ZP_BOOL;
      }


   }

   /** A CPU byte register. */
   public static abstract class RegisterCpuByte implements Register {
      @Override
      public abstract RegisterType getType();

      @Override
      public boolean isZp() {
         return false;
      }

      @Override
      public abstract String toString();

      @Override
      public boolean equals(Object obj) {
         if(this == obj) {
            return true;
         }
         if(obj == null || getClass() != obj.getClass()) {
            return false;
         }
         return true;
      }

      @Override
      public int hashCode() {
         return getType().hashCode();
      }

      @Override
      public String toString(Program program) {
         return toString();
      }

   }


   /** The X register. */
   public static class RegisterXByte extends RegisterCpuByte {
      @Override
      public RegisterType getType() {
         return RegisterType.REG_X_BYTE;
      }

      @Override
      public String toString() {
         return "reg byte x";
      }

   }

   /** The Y register. */
   public static class RegisterYByte extends RegisterCpuByte {
      @Override
      public RegisterType getType() {
         return RegisterType.REG_Y_BYTE;
      }

      @Override
      public String toString() {
         return "reg byte y";
      }

   }

   /** The A unsigned register. */
   public static class RegisterAByte extends RegisterCpuByte {
      @Override
      public RegisterType getType() {
         return RegisterType.REG_A_BYTE;
      }

      @Override
      public String toString() {
         return "reg byte a";
      }

   }

   /** The special ALU register. */
   public static class RegisterALUByte extends RegisterCpuByte {
      @Override
      public RegisterType getType() {
         return RegisterType.REG_ALU;
      }

      @Override
      public String toString() {
         return "reg byte alu";
      }

   }

   /** Special register used for constants. Has no corresponding CPU register. */
   public static class RegisterConstant implements Register {

      private ConstantValue constantValue;

      public RegisterConstant(ConstantValue constantValue) {
         this.constantValue = constantValue;
      }

      @Override
      public RegisterType getType() {
         return RegisterType.CONSTANT;
      }

      @Override
      public boolean isZp() {
         return false;
      }

      public ConstantValue getConstantValue() {
         return constantValue;
      }

      @Override
      public String toString(Program program) {
         return "const " + constantValue.toString(program);
      }

      @Override
      public int hashCode() {
         return constantValue != null ? constantValue.hashCode() : 0;
      }

      @Override
      public boolean equals(Object o) {
         if(this == o) return true;
         if(o == null || getClass() != o.getClass()) return false;
         RegisterConstant that = (RegisterConstant) o;
         return constantValue != null ? constantValue.equals(that.constantValue) : that.constantValue == null;
      }

   }

}

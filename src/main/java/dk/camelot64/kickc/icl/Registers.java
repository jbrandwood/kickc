package dk.camelot64.kickc.icl;

/** The different registers available for a program  */
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
      ZP_BYTE, ZP_BOOL, REG_A_BYTE, REG_ALU_BYTE, REG_Y_BYTE, REG_X_BYTE, ZP_PTR_BYTE, ZP_WORD
   }

   /** A register used for storing a single variable. */
   public interface Register extends Value {

      RegisterType getType();

      boolean isZp();

   }

   public static abstract class RegisterZp implements Register {

      /** The ZP address used for the byte. */
      private int zp;

      /** The name used as a label for the register in the ASM code. */
      private String name;

      /** The variable represented by the register. */
      private Variable variable;

      public RegisterZp(int zp, String name, Variable variable) {
         this.zp = zp;
         this.name = name;
         this.variable = variable;
      }

      public int getZp() {
         return zp;
      }

      public String getName() {
         return name;
      }

      public Variable getVariable() {
         return variable;
      }

      @Override
      public boolean isZp() {
         return true;
      }

      @Override
      public String toString() {
         return "zp "+getType().toString()+":"+zp+(name==null?"":(" "+name));
      }

      @Override
      public String toString(Program program) {
         return toString();
      }

      @Override
      public boolean equals(Object o) {
         if (this == o) return true;
         if (o == null || getClass() != o.getClass()) return false;
         RegisterZp that = (RegisterZp) o;
         if (zp != that.zp) return false;
         return name != null ? name.equals(that.name) : that.name == null;
      }

      @Override
      public int hashCode() {
         int result = zp;
         result = 31 * result + (name != null ? name.hashCode() : 0);
         return result;
      }

      public void setName(String name) {
         this.name = name;
      }
   }


   /** A zero page address used as a register for a single byte variable. */
   public static class RegisterZpByte extends RegisterZp {

      public RegisterZpByte(int zp, String name, Variable variable) {
         super(zp, name, variable);
      }

      @Override
      public RegisterType getType() {
         return  RegisterType.ZP_BYTE;
      }


   }

   /** Two zero page addresses used as a register for a single word variable. */
   public static class RegisterZpWord extends  RegisterZp {

      public RegisterZpWord(int zp, String name, Variable variable) {
         super(zp, name, variable);
      }

      @Override
      public RegisterType getType() {
         return  RegisterType.ZP_WORD;
      }

   }

   /** A zero page address used as a register for a boolean variable. */
   public static class RegisterZpBool extends  RegisterZp {

      public RegisterZpBool(int zp, String name, Variable variable) {
         super(zp, name, variable);
      }

      @Override
      public RegisterType getType() {
         return  RegisterType.ZP_BOOL;
      }


   }

   /** A zro page address pair used as a register containing a pointer to a byte. */
   public static class RegisterZpPointerByte extends  RegisterZp {

      public RegisterZpPointerByte(int zp, String name, Variable variable) {
         super(zp, name, variable);
      }

      @Override
      public RegisterType getType() {
         return RegisterType.ZP_PTR_BYTE;
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
      public String toString(Program program) {
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
      public String toString(Program program) {
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
      public String toString(Program program) {
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
      public String toString(Program program) {
         return toString();
      }

   }
}

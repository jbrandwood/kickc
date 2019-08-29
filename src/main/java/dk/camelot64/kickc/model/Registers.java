package dk.camelot64.kickc.model;

import dk.camelot64.kickc.model.values.ConstantValue;
import dk.camelot64.kickc.model.values.Value;

import java.util.Locale;
import java.util.Objects;

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

   public static Register getRegister(String name) {
      switch(name.toUpperCase(Locale.ENGLISH)) {
         case "A":
            return getRegisterA();
         case "X":
            return getRegisterX();
         case "Y":
            return getRegisterY();
         default:
            return null;
      }
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
      ZP_STRUCT,
      ZP_BOOL,
      ZP_VAR,
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
         return zp+31*getClass().hashCode();
      }

   }

   /** A zero page address used as a register for a declared register allocation. Size is initially unknown and will be resolved when performing allocation by setting the type. */
   public static class RegisterZpDeclared extends RegisterZp {

      private RegisterType type;

      public RegisterZpDeclared(int zp) {
         super(zp);
         this.type = RegisterType.ZP_VAR;
      }

      @Override
      public RegisterType getType() {
         return type;
      }

      public void setType(RegisterType type) {
         this.type = type;
      }

      @Override
      public boolean equals(Object o) {
         if(this == o) return true;
         if(o == null || getClass() != o.getClass()) return false;
         if(!super.equals(o)) return false;
         RegisterZpDeclared that = (RegisterZpDeclared) o;
         return type == that.type;
      }

      @Override
      public int hashCode() {
         return Objects.hash(super.hashCode(), type);
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

   /** Zero page addresses used as a register for a struct variable. */
   public static class RegisterZpStruct extends RegisterZp {

      public RegisterZpStruct(int zp) {
         super(zp);
      }

      public RegisterZpStructMember getMemberRegister(long memberByteOffset) {
         return new RegisterZpStructMember((int) (getZp()+memberByteOffset));
      }

      @Override
      public RegisterType getType() {
         return RegisterType.ZP_STRUCT;
      }

   }

   /** Zero page addresses used as a register for a struct member variable. */
   public static class RegisterZpStructMember extends RegisterZp {

      public RegisterZpStructMember(int zp) {
         super(zp);
      }

      @Override
      public RegisterType getType() {
         return RegisterType.ZP_STRUCT;
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

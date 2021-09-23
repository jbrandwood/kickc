package dk.camelot64.kickc.model;

import dk.camelot64.kickc.model.values.ConstantValue;
import dk.camelot64.kickc.model.values.Value;
import dk.camelot64.kickc.model.values.VariableRef;

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

   public static Register getRegisterZ() {
      return new RegisterZByte();
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
         case "Z":
            return getRegisterZ();
         default:
            return null;
      }
   }

   /** The register type. */
   public enum RegisterType {
      REG_A,
      REG_Y,
      REG_X,
      REG_Z,
      REG_ALU,
      ZP_MEM,
      MAIN_MEM,
      CONSTANT,
   }

   /** A register used for storing a single variable. */
   public interface Register extends Value {

      RegisterType getType();

      boolean isMem();

      int getBytes();

      boolean isNonRelocatable();

      boolean isHardware();
   }

   public static class RegisterMainMem implements Register {

      private VariableRef variableRef;

      private int bytes;

      /** If the address is hardcoded this contains it. */
      private Long address;

      /** True if the address of the register is declared in the code (non-relocatable) */
      private boolean nonRelocatable;

      public RegisterMainMem(VariableRef variableRef, int bytes, Long address, boolean nonRelocatable) {
         this.variableRef = variableRef;
         this.bytes = bytes;
         this.address = address;
         this.nonRelocatable = nonRelocatable;
      }

      public VariableRef getVariableRef() {
         return variableRef;
      }

      public void setVariableRef(VariableRef variableRef) {
         this.variableRef = variableRef;
      }

      @Override
      public RegisterType getType() {
         return RegisterType.MAIN_MEM;
      }

      public Long getAddress() {
         return address;
      }

      @Override
      public boolean isMem() {
         return true;
      }

      @Override
      public int getBytes() {
         return bytes;
      }

      @Override
      public boolean isNonRelocatable() {
         return nonRelocatable;
      }

      @Override
      public boolean isHardware() {
         return false;
      }

      @Override
      public String toString() {
         return "mem[" + getBytes() + "]" + ((address==null)?"":(":"+address));
      }

      @Override
      public String toString(Program program) {
         return toString();
      }

      @Override
      public boolean equals(Object o) {
         if(this == o) return true;
         if(o == null || getClass() != o.getClass()) return false;
         RegisterMainMem that = (RegisterMainMem) o;
         return bytes == that.bytes &&
               Objects.equals(variableRef, that.variableRef) &&
               Objects.equals(address, that.address);
      }

      @Override
      public int hashCode() {
         return Objects.hash(variableRef, bytes, address);
      }
   }

   /** Two zero page addresses used as a register for a single unsigned word variable. */
   public static class RegisterZpMem implements Register {

      /** The number of bytes that the register takes up */
      private int bytes;

      /** The ZP address used for the byte. */
      private int zp;

      /** True if the address of the register is declared in the code (non-relocatable) */
      private boolean nonRelocatable;

      public RegisterZpMem(int zp, int bytes, boolean nonRelocatable) {
         this.zp = zp;
         this.bytes = bytes;
         this.nonRelocatable = nonRelocatable;
      }

      public RegisterZpMem(int zp, int bytes) {
         this(zp, bytes, false);
      }

      public int getZp() {
         return zp;
      }

      @Override
      public boolean isMem() {
         return true;
      }

      @Override
      public RegisterType getType() {
         return RegisterType.ZP_MEM;
      }

      public int getBytes() {
         return bytes;
      }

      public boolean isNonRelocatable() {
         return nonRelocatable;
      }

      @Override
      public boolean isHardware() {
         return false;
      }

      @Override
      public String toString() {
         return "zp[" + getBytes() + "]:" + getZp();
      }

      @Override
      public String toString(Program program) {
         return toString();
      }

      @Override
      public boolean equals(Object o) {
         if(this == o) return true;
         if(o == null || getClass() != o.getClass()) return false;
         RegisterZpMem that = (RegisterZpMem) o;
         return zp == that.zp &&
               bytes == that.bytes &&
               nonRelocatable == that.nonRelocatable;
      }

      @Override
      public int hashCode() {
         return zp;
      }
   }

   /** A CPU byte register. */
   public static abstract class RegisterCpuByte implements Register {
      @Override
      public abstract RegisterType getType();

      @Override
      public boolean isMem() {
         return false;
      }

      @Override
      public int getBytes() {
         return 1;
      }

      @Override
      public boolean isNonRelocatable() {
         return true;
      }

      @Override
      public boolean isHardware() {
         return true;
      }

      @Override
      public abstract String toString();

      @Override
      public boolean equals(Object obj) {
         if(this == obj) {
            return true;
         }
         return obj != null && getClass() == obj.getClass();
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

   /** The Z register. */
   public static class RegisterZByte extends RegisterCpuByte {
      @Override
      public RegisterType getType() {
         return RegisterType.REG_Z;
      }

      @Override
      public String toString() {
         return "reg byte z";
      }

   }

   /** The X register. */
   public static class RegisterXByte extends RegisterCpuByte {
      @Override
      public RegisterType getType() {
         return RegisterType.REG_X;
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
         return RegisterType.REG_Y;
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
         return RegisterType.REG_A;
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
      public boolean isMem() {
         return false;
      }

      @Override
      public boolean isNonRelocatable() {
         return false;
      }

      @Override
      public boolean isHardware() {
         return false;
      }

      @Override
      public int getBytes() {
         return 0;
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
         return Objects.equals(constantValue, that.constantValue);
      }
   }

}

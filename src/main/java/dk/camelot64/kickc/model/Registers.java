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
      REG_A,
      REG_Y,
      REG_X,
      REG_ALU,
      ZP_VAR,
      ZP_MEM,
      CONSTANT,
      MEMORY
   }

   /** A register used for storing a single variable. */
   public interface Register extends Value {

      RegisterType getType();

      boolean isZp();

      int getBytes();

      boolean isNonRelocatable();

   }

   public static class RegisterMemory implements Register {

      private VariableRef variableRef;

      private int bytes;

      public RegisterMemory(VariableRef variableRef, int bytes ) {
         this.variableRef = variableRef;
         this.bytes = bytes;
      }

      public VariableRef getVariableRef() {
         return variableRef;
      }

      @Override
      public RegisterType getType() {
         return RegisterType.MEMORY;
      }

      @Override
      public boolean isZp() {
         return false;
      }

      @Override
      public int getBytes() {
         return bytes;
      }

      @Override
      public boolean isNonRelocatable() {
         return false;
      }

      @Override
      public String toString() {
         return "mem "+variableRef.toString();
      }

      @Override
      public String toString(Program program) {
         return toString();
      }

      @Override
      public boolean equals(Object o) {
         if(this == o) return true;
         if(o == null || getClass() != o.getClass()) return false;
         RegisterMemory that = (RegisterMemory) o;
         return Objects.equals(variableRef, that.variableRef);
      }

      @Override
      public int hashCode() {
         return Objects.hash(variableRef);
      }
   }

   public static abstract class RegisterZp implements Register {

      /** The ZP address used for the byte. */
      private int zp;

      RegisterZp(int zp) {
         this.zp = zp;
      }

      public int getZp() {
         return zp;
      }

      public abstract int getBytes();


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

   /** Two zero page addresses used as a register for a single unsigned word variable. */
   public static class RegisterZpMem extends RegisterZp {

      /** The number of bytes that the register takes up*/
      private int bytes;

      /** True if the address of the register is delcared in the code (non-relocatable)*/
      private boolean isNonRelocatable;


      public RegisterZpMem(int zp, int bytes, boolean isNonRelocatable) {
         super(zp);
         this.bytes = bytes;
         this.isNonRelocatable = isNonRelocatable;
      }

      public RegisterZpMem(int zp, int bytes) {
         this(zp, bytes, false);
      }


      @Override
      public RegisterType getType() {
         return RegisterType.ZP_MEM;
      }

      public int getBytes() {
         return bytes;
      }

      public boolean isNonRelocatable() {
         return isNonRelocatable;
      }

      @Override
      public String toString() {
         String typeString;
         if(getBytes()==1) {
            typeString = "ZP_BYTE";
         } else if(getBytes()==2) {
            typeString = "ZP_WORD";
         } else if(getBytes()==4) {
            typeString = "ZP_DWORD";
         } else {
            typeString = "ZP_MEM";
         }
         return "zp " + typeString + ":" + getZp();
      }

      @Override
      public boolean equals(Object o) {
         return super.equals(o);
      }

      @Override
      public int hashCode() {
         return super.hashCode();
      }
   }

   /** A zero page address used as a register for a declared register allocation. Size is initially unknown and will be resolved when performing allocation by setting the type. */
   public static class RegisterZpDeclared extends RegisterZp {

      private RegisterType type;

      private int bytes;

      public RegisterZpDeclared(int zp) {
         super(zp);
         this.type = RegisterType.ZP_VAR;
         this.bytes = -1;
      }

      @Override
      public RegisterType getType() {
         return type;
      }

      public void setType(RegisterType type) {
         this.type = type;
      }

      public void setBytes(int bytes) {
         this.bytes = bytes;
      }

      @Override
      public boolean isNonRelocatable() {
         return true;
      }

      @Override
      public int getBytes() {
         return bytes;
      }

      public RegisterZpMem getZpRegister(int bytes) {
         return new RegisterZpMem(getZp(), bytes, true);
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

   /** A CPU byte register. */
   public static abstract class RegisterCpuByte implements Register {
      @Override
      public abstract RegisterType getType();

      @Override
      public boolean isZp() {
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
      public boolean isZp() {
         return false;
      }

      @Override
      public boolean isNonRelocatable() {
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
         return constantValue != null ? constantValue.equals(that.constantValue) : that.constantValue == null;
      }

   }

}

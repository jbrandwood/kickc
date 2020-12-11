package dk.camelot64.kickc.model;

import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.values.ConstantValue;

import java.util.List;

/** A declaration directive. */
public class Directive {
   
   private String name;

   public Directive(String name) {
      this.name = name;
   }

   public String getName() {
      return name;
   }

   /** Variable declared const */
   public static class Const extends Directive {
      public Const() { super("const"); }
   }

   /** Variable declared volatile */
   public static class Volatile extends Directive {
      public Volatile() { super("volatile"); }
   }

   /** Variable declared register. */
   public static class Register extends Directive {
      public Register() { super("register"); }
   }

   /** Variable declared static. */
   public static class Static extends Directive {
      public Static() { super("static"); }
   }

   /** Function declared inline. */
   static public class Inline extends Directive {
      public Inline() { super("inline"); }
   }

   /** Function declared intrinsic. */
   public static class Intrinsic extends Directive {
      public Intrinsic() { super("intrinsic"); }
   }

   /** Variable declared as extern. */
   public static class Extern extends Directive {
      public Extern() { super("extern"); }
   }

   /** Variable declared as export. */
   public static class Export extends Directive {
      public Export() { super("export"); }
   }

   /** Variable declared as pointer to volatile ( volatile * )  */
   public static class ToVolatile extends Directive {
      public ToVolatile() { super("volatile*"); }
   }

   /** Variable declared as pointer to const ( const * )  */
   public static class ToConst extends Directive {
      public ToConst() { super("const*"); }
   }

   /** Variable __ssa */
   public static class FormSsa extends Directive {
      public FormSsa() { super("__ssa"); }

   }

   /** Variable __ma */
   public static class FormMa extends Directive {
      public FormMa() { super("__ma"); }
   }

   /** Variable __zp */
   public static class MemZp extends Directive {
      public MemZp() { super("__zp"); }
   }

   /** Variable __mem */
   public static class MemMain extends Directive {
      public MemMain() { super("__mem"); }
   }

   /** Function with specific declared calling convention. */
   public static class CallingConvention extends Directive {

      public Procedure.CallingConvention callingConvention;

      public CallingConvention(Procedure.CallingConvention callingConvention) {
         super(callingConvention.getName());
         this.callingConvention = callingConvention;
      }

   }

   /** Function declared interrupt. */
   public static class Interrupt extends Directive {
      public Procedure.InterruptType interruptType;

      public Interrupt(Procedure.InterruptType interruptType) {
         super(interruptType.name());
         this.interruptType = interruptType;
      }
   }

   /** Variable memory alignment. */
   public static class Align extends Directive {

      int alignment;

      public Align(int alignment) {
         super("__align");
         this.alignment = alignment;
      }

   }

   /** Variable hardcoded register directive. */
   public static class NamedRegister extends Directive {

      /** Name of register to use for the variable (if named) */
      public String name;

      public NamedRegister(String name) {
         super("__register");
         this.name = name;
      }

   }

   /** Variable hardcoded __address() directive */
   public static class Address extends Directive {

      /** Expression for calculating the address. */
      public ConstantValue addressValue;

      /** Optional hard-coded address to use for storing the variable. */
      public Long addressLiteral;

      public Address(ConstantValue addressValue, Long addressLiteral) {
         super("__address");
         this.addressValue = addressValue;
         this.addressLiteral = addressLiteral;
      }

   }

   /** Reservation of zero-page addresses */
   public static class ReserveZp extends Directive {
      public List<Integer> reservedZp;

      public ReserveZp(List<Integer> reservedZp) {
         super("__reserve_zp");
         this.reservedZp = reservedZp;
      }
   }


}

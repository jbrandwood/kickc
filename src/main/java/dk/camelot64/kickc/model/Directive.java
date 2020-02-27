package dk.camelot64.kickc.model;

import dk.camelot64.kickc.model.symbols.Procedure;

import java.util.List;

/** A declaration directive. */
public interface Directive {

   /** Variable declared const */
   class Const implements Directive {
   }

   /** Variable declared volatile */
   class Volatile implements Directive {
   }

   /** Variable declared register. */
   class Register implements Directive {
   }

   /** Variable declared static. */
   class Static implements Directive {
   }

   /** Function declared inline. */
   class Inline implements Directive {
   }

   /** Variable declared as extern. */
   class Extern implements Directive {
   }

   /** Variable declared as export. */
   class Export implements Directive {
   }

   /** Variable declared as pointer to volatile ( volatile * )  */
   class ToVolatile implements Directive {
   }

   /** Variable declared as pointer to const ( const * )  */
   class ToConst implements Directive {
   }

   /** Variable __ssa */
   class FormSsa implements Directive {
   }

   /** Variable __ma */
   class FormMa implements Directive {
   }

   /** Variable __zp */
   class MemZp implements Directive {
   }

   /** Variable __mem */
   class MemMain implements Directive {
   }

   /** Function with specific declared calling convention. */
   class CallingConvention implements Directive {

      public Procedure.CallingConvention callingConvention;

      public CallingConvention(Procedure.CallingConvention callingConvention) {
         this.callingConvention = callingConvention;
      }

   }

   /** Function declared interrupt. */
   class Interrupt implements Directive {
      public Procedure.InterruptType interruptType;

      public Interrupt(Procedure.InterruptType interruptType) {
         this.interruptType = interruptType;
      }
   }

   /** Variable memory alignment. */
   class Align implements Directive {

      int alignment;

      public Align(int alignment) {
         this.alignment = alignment;
      }

   }

   /** Variable hardcoded register directive. */
   class NamedRegister implements Directive {

      /** Name of register to use for the variable (if named) */
      public String name;

      public NamedRegister(String name) {
         this.name = name;
      }

   }

   /** Variable hardcoded __address() directive */
   class Address implements Directive {

      /** Optional hard-coded address to use for storing the variable. */
      public Long address;

      public Address(Long address) {
         this.address = address;
      }

   }

   /** Reservation of zero-page addresses */
   class ReserveZp implements Directive {
      public List<Integer> reservedZp;

      public ReserveZp(List<Integer> reservedZp) {
         this.reservedZp = reservedZp;
      }
   }


}

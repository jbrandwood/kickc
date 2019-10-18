package dk.camelot64.kickc.model;

import dk.camelot64.kickc.model.statements.StatementSource;
import dk.camelot64.kickc.model.symbols.*;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeArray;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;
import dk.camelot64.kickc.model.values.ScopeRef;

import java.util.*;

/** A declaration directive. */
public interface Directive {


   /** Variable declared constant. */
   class Const implements Directive {
   }

   /** Function with specific declared calling convention. */
   class CallingConvention implements Directive {

      public Procedure.CallingConvension callingConvension;

      public CallingConvention(Procedure.CallingConvension callingConvension) {
         this.callingConvension = callingConvension;
      }

   }

   /** Function declared inline. */
   class Inline implements Directive {
   }

   /** Variable declared volatile. */
   class Volatile implements Directive {
   }

   /** Variable declared as export. */
   class Export implements Directive {
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

   /** Variable register or __notregister directive . */
   class Register implements Directive {

      /** true if the directive is a register directive. false if it is a notregister directive. */
      boolean isRegister;

      /** Name of register to use for the variable (if named) */
      public String name;

      public Register(boolean isRegister, String name) {
         this.isRegister = isRegister;
         this.name = name;
      }

   }

   /** Variable memory area declaration. */
   class MemoryArea implements Directive {

      /** The memory area. */
      SymbolVariable.MemoryArea memoryArea;

      /** Optional hard-coded address to use for storing the variable. */
      public Long address;

      public MemoryArea(SymbolVariable.MemoryArea memoryArea, Long address) {
         this.memoryArea = memoryArea;
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

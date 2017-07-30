package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.icl.*;

/**
 * Register Allocation for variables
 */
public class Pass3CustomRegisters {


   private Program program;

   public Pass3CustomRegisters(Program program) {
      this.program = program;
   }

   public void allocate() {
      RegisterAllocation allocation = program.getScope().getAllocation();

      // Register allocation for loopnest.kc
      allocation.allocate(new VariableRef("nest2::j#2"), RegisterAllocation.getRegisterX());
      allocation.allocate(new VariableRef("nest2::j#1"), RegisterAllocation.getRegisterX());
      allocation.allocate(new VariableRef("nest2::i#2"), RegisterAllocation.getRegisterY());
      allocation.allocate(new VariableRef("nest2::i#1"), RegisterAllocation.getRegisterY());


      // Register allocation for fibmem.kc
      /*
      allocation.allocate(new VariableRef("i#1"), RegisterAllocation.getRegisterX());
      allocation.allocate(new VariableRef("i#2"), RegisterAllocation.getRegisterX());
      allocation.allocate(new VariableRef("$1"), new RegisterAllocation.RegisterAByte());
      allocation.allocate(new VariableRef("$3"), new RegisterAllocation.RegisterALUByte());
      allocation.allocate(new VariableRef("$4"), new RegisterAllocation.RegisterAByte());
      */

      // Registers for postinc.kc
      /*
      allocation.allocate(new VariableRef("c#0"), RegisterAllocation.getRegisterA());
      allocation.allocate(new VariableRef("c#1"), RegisterAllocation.getRegisterA());
      allocation.allocate(new VariableRef("c#2"), RegisterAllocation.getRegisterA());
      allocation.allocate(new VariableRef("b#0"), new RegisterAllocation.RegisterZpByte(102));
      allocation.allocate(new VariableRef("b#1"), new RegisterAllocation.RegisterZpByte(102));
      allocation.allocate(new VariableRef("b#2"), new RegisterAllocation.RegisterZpByte(102));
      allocation.allocate(new VariableRef("$1"), new RegisterAllocation.RegisterZpByte(101));
      allocation.allocate(new VariableRef("a#0"), new RegisterAllocation.RegisterZpByte(103));
      allocation.allocate(new VariableRef("a#1"), new RegisterAllocation.RegisterZpByte(103));
      allocation.allocate(new VariableRef("a#2"), new RegisterAllocation.RegisterZpByte(103));
      allocation.allocate(new VariableRef("$0"), RegisterAllocation.getRegisterA());
      allocation.allocate(new VariableRef("i#0"), RegisterAllocation.getRegisterX());
      allocation.allocate(new VariableRef("i#1"), RegisterAllocation.getRegisterX());
      allocation.allocate(new VariableRef("i#2"), RegisterAllocation.getRegisterX());
      */

      // Optimal Registers for flipper-rex2.kc
      /*
      allocation.allocate(new VariableRef("plot::i#0"), RegisterAllocation.getRegisterX());
      allocation.allocate(new VariableRef("plot::i#1"), RegisterAllocation.getRegisterX());
      allocation.allocate(new VariableRef("plot::i#2"), RegisterAllocation.getRegisterX());
      allocation.allocate(new VariableRef("plot::i#3"), RegisterAllocation.getRegisterX());
      allocation.allocate(new VariableRef("plot::i#4"), RegisterAllocation.getRegisterX());
      allocation.allocate(new VariableRef("plot::x#0"), RegisterAllocation.getRegisterY());
      allocation.allocate(new VariableRef("plot::x#1"), RegisterAllocation.getRegisterY());
      allocation.allocate(new VariableRef("plot::x#2"), RegisterAllocation.getRegisterY());
      allocation.allocate(new VariableRef("plot::y#0"), new RegisterAllocation.RegisterZpByte(100));
      allocation.allocate(new VariableRef("plot::y#1"), new RegisterAllocation.RegisterZpByte(100));
      allocation.allocate(new VariableRef("plot::y#2"), new RegisterAllocation.RegisterZpByte(100));
      allocation.allocate(new VariableRef("plot::y#3"), new RegisterAllocation.RegisterZpByte(100));
      allocation.allocate(new VariableRef("plot::y#4"), new RegisterAllocation.RegisterZpByte(100));
      allocation.allocate(new VariableRef("plot::line#0"), new RegisterAllocation.RegisterZpPointerByte(101));
      allocation.allocate(new VariableRef("plot::line#1"), new RegisterAllocation.RegisterZpPointerByte(101));
      allocation.allocate(new VariableRef("plot::line#2"), new RegisterAllocation.RegisterZpPointerByte(101));
      allocation.allocate(new VariableRef("plot::line#3"), new RegisterAllocation.RegisterZpPointerByte(101));
      allocation.allocate(new VariableRef("plot::line#4"), new RegisterAllocation.RegisterZpPointerByte(101));
      allocation.allocate(new VariableRef("plot::$3"), RegisterAllocation.getRegisterA());
      allocation.allocate(new VariableRef("prepare::i#0"), RegisterAllocation.getRegisterX());
      allocation.allocate(new VariableRef("prepare::i#1"), RegisterAllocation.getRegisterX());
      allocation.allocate(new VariableRef("prepare::i#2"), RegisterAllocation.getRegisterX());
      allocation.allocate(new VariableRef("flip::srcIdx#0"), RegisterAllocation.getRegisterX());
      allocation.allocate(new VariableRef("flip::srcIdx#0"), RegisterAllocation.getRegisterX());
      allocation.allocate(new VariableRef("flip::srcIdx#1"), RegisterAllocation.getRegisterX());
      allocation.allocate(new VariableRef("flip::srcIdx#2"), RegisterAllocation.getRegisterX());
      allocation.allocate(new VariableRef("flip::srcIdx#3"), RegisterAllocation.getRegisterX());
      allocation.allocate(new VariableRef("flip::srcIdx#4"), RegisterAllocation.getRegisterX());
      allocation.allocate(new VariableRef("flip::dstIdx#0"), RegisterAllocation.getRegisterY());
      allocation.allocate(new VariableRef("flip::dstIdx#1"), RegisterAllocation.getRegisterY());
      allocation.allocate(new VariableRef("flip::dstIdx#2"), RegisterAllocation.getRegisterY());
      allocation.allocate(new VariableRef("flip::dstIdx#3"), RegisterAllocation.getRegisterY());
      allocation.allocate(new VariableRef("flip::dstIdx#4"), RegisterAllocation.getRegisterY());
      allocation.allocate(new VariableRef("flip::dstIdx#5"), RegisterAllocation.getRegisterY());
      allocation.allocate(new VariableRef("flip::c#0"), new RegisterAllocation.RegisterZpByte(103));
      allocation.allocate(new VariableRef("flip::c#1"), new RegisterAllocation.RegisterZpByte(103));
      allocation.allocate(new VariableRef("flip::c#2"), new RegisterAllocation.RegisterZpByte(103));
      allocation.allocate(new VariableRef("flip::r#0"), new RegisterAllocation.RegisterZpByte(104));
      allocation.allocate(new VariableRef("flip::r#1"), new RegisterAllocation.RegisterZpByte(104));
      allocation.allocate(new VariableRef("flip::r#2"), new RegisterAllocation.RegisterZpByte(104));
      allocation.allocate(new VariableRef("flip::r#3"), new RegisterAllocation.RegisterZpByte(104));
      allocation.allocate(new VariableRef("flip::r#4"), new RegisterAllocation.RegisterZpByte(104));
      allocation.allocate(new VariableRef("flip::i#0"), RegisterAllocation.getRegisterX());
      allocation.allocate(new VariableRef("flip::i#1"), RegisterAllocation.getRegisterX());
      allocation.allocate(new VariableRef("flip::i#2"), RegisterAllocation.getRegisterX());
      allocation.allocate(new VariableRef("flip::$0"), RegisterAllocation.getRegisterA());
      allocation.allocate(new VariableRef("flip::$8"), RegisterAllocation.getRegisterA());
      allocation.allocate(new VariableRef("flip::$4"), RegisterAllocation.getRegisterA());
      allocation.allocate(new VariableRef("main::$1"), RegisterAllocation.getRegisterA());
      allocation.allocate(new VariableRef("main::$3"), RegisterAllocation.getRegisterA());
      allocation.allocate(new VariableRef("main::c#0"), RegisterAllocation.getRegisterX());
      allocation.allocate(new VariableRef("main::c#1"), RegisterAllocation.getRegisterX());
      allocation.allocate(new VariableRef("main::c#2"), RegisterAllocation.getRegisterX());
      allocation.allocate(new VariableRef("main::c#3"), RegisterAllocation.getRegisterX());
      allocation.allocate(new VariableRef("main::c#4"), RegisterAllocation.getRegisterX());
      */


   }

   int currentZp = 2;
   private void performAllocation(Scope scope, RegisterAllocation allocation) {
      for (Symbol symbol : scope.getAllSymbols()) {
         if (symbol instanceof Scope) {
            performAllocation((Scope) symbol, allocation);
         } else if (symbol instanceof VariableIntermediate || symbol instanceof VariableVersion) {
            Variable var = (Variable) symbol;
            if (symbol.getType().equals(SymbolTypeBasic.BYTE)) {
               allocation.allocate(var.getRef(), new RegisterAllocation.RegisterZpByte(currentZp++));
            } else if (symbol.getType().equals(SymbolTypeBasic.WORD)) {
               allocation.allocate(var.getRef(), new RegisterAllocation.RegisterZpWord(currentZp));
               currentZp = currentZp + 2;
            } else if (symbol.getType().equals(SymbolTypeBasic.BOOLEAN)) {
               allocation.allocate(var.getRef(), new RegisterAllocation.RegisterZpBool(currentZp++));
            } else if (symbol.getType().equals(SymbolTypeBasic.VOID)) {
               // No need to allocate register for VOID value
            } else if (symbol.getType() instanceof SymbolTypePointer) {
               allocation.allocate(var.getRef(), new RegisterAllocation.RegisterZpPointerByte(currentZp));
               currentZp = currentZp + 2;
            } else {
               throw new RuntimeException("Unhandled variable type " + symbol);
            }
         }
      }
   }

}

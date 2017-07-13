package dk.camelot64.kickc.icl;

/**
 * Register Allocation for variables
 */
public class Pass3RegisterAllocation {

   private ControlFlowGraph graph;
   private Scope symbols;
   int currentZp = 2;

   public Pass3RegisterAllocation(ControlFlowGraph graph, Scope symbols) {
      this.graph = graph;
      this.symbols = symbols;
   }

   public void allocate() {
      RegisterAllocation allocation = new RegisterAllocation();
      performAllocation(symbols, allocation);

      //allocation.allocate(symbols.getVariable("i#0"), RegisterAllocation.getRegisterX());
      //allocation.allocate(symbols.getVariable("i#1"), RegisterAllocation.getRegisterX());
      //allocation.allocate(symbols.getVariable("i#2"), RegisterAllocation.getRegisterX());
      //allocation.allocate(symbols.getVariable("i#3"), RegisterAllocation.getRegisterX());
      //allocation.allocate(symbols.getVariable("i#4"), RegisterAllocation.getRegisterX());
      //allocation.allocate(symbols.getVariable("i#5"), RegisterAllocation.getRegisterX());
      //allocation.allocate(symbols.getVariable("i#6"), RegisterAllocation.getRegisterX());
      //allocation.allocate(symbols.getVariable("i#7"), RegisterAllocation.getRegisterX());
      //allocation.allocate(symbols.getVariable("n1#1"), RegisterAllocation.getRegisterY());
      //allocation.allocate(symbols.getVariable("n1#2"), RegisterAllocation.getRegisterY());
      //allocation.allocate(symbols.getVariable("e#2"), new RegisterAllocation.RegisterZpByte(128));
      //allocation.allocate(symbols.getVariable("e#3"), new RegisterAllocation.RegisterZpByte(128));
      //allocation.allocate(symbols.getVariable("e#4"), new RegisterAllocation.RegisterZpByte(128));
      //allocation.allocate(symbols.getVariable("e#5"), new RegisterAllocation.RegisterZpByte(128));
      //allocation.allocate(symbols.getVariable("idx#2"), new RegisterAllocation.RegisterZpWord(129));
      //allocation.allocate(symbols.getVariable("idx#3"), new RegisterAllocation.RegisterZpWord(129));
      //allocation.allocate(symbols.getVariable("idx#4"), new RegisterAllocation.RegisterZpWord(129));
      //allocation.allocate(symbols.getVariable("idx#5"), new RegisterAllocation.RegisterZpWord(129));
      //allocation.allocate(symbols.getVariable("x#0"), new RegisterAllocation.RegisterYByte());
      //allocation.allocate(symbols.getVariable("x#1"), new RegisterAllocation.RegisterYByte());
      //allocation.allocate(symbols.getVariable("x#2"), new RegisterAllocation.RegisterYByte());
      //allocation.allocate(symbols.getVariable("x#5"), new RegisterAllocation.RegisterZpByte(131));
      //allocation.allocate(symbols.getVariable("y#0"), new RegisterAllocation.RegisterZpByte(132));
      //allocation.allocate(symbols.getVariable("y#1"), new RegisterAllocation.RegisterZpByte(132));
      //allocation.allocate(symbols.getVariable("y#2"), new RegisterAllocation.RegisterZpByte(132));
      //allocation.allocate(symbols.getVariable("y#5"), new RegisterAllocation.RegisterZpByte(132));
      //allocation.allocate(symbols.getVariable("cursor#2"), new RegisterAllocation.RegisterZpPointerByte(133));
      //allocation.allocate(symbols.getVariable("cursor#3"), new RegisterAllocation.RegisterZpPointerByte(133));
      //allocation.allocate(symbols.getVariable("cursor#4"), new RegisterAllocation.RegisterZpPointerByte(133));
      //allocation.allocate(symbols.getVariable("cursor#5"), new RegisterAllocation.RegisterZpPointerByte(133));
      //allocation.allocate(symbols.getVariable("ptr#1"), new RegisterAllocation.RegisterZpPointerByte(135));
      //allocation.allocate(symbols.getVariable("ptr#2"), new RegisterAllocation.RegisterZpPointerByte(135));
      //allocation.allocate(symbols.getVariable("ptr#3"), new RegisterAllocation.RegisterZpPointerByte(135));
      //allocation.allocate(symbols.getVariable("v#1"), new RegisterAllocation.RegisterAByte());
      //allocation.allocate(symbols.getVariable("v#2"), new RegisterAllocation.RegisterAByte());
      //allocation.allocate(symbols.getVariable("v#3"), new RegisterAllocation.RegisterAByte());
      //allocation.allocate(symbols.getVariable("v#4"), new RegisterAllocation.RegisterAByte());
      //allocation.allocate(symbols.getVariable("v#5"), new RegisterAllocation.RegisterAByte());
      //allocation.allocate(symbols.getVariable("$0"), new RegisterAllocation.RegisterAByte());
      //allocation.allocate(symbols.getVariable("$2"), new RegisterAllocation.RegisterAByte());
      //allocation.allocate(symbols.getVariable("$3"), new RegisterAllocation.RegisterAByte());
      //allocation.allocate(symbols.getVariable("$1"), new RegisterAllocation.RegisterAByte());
      //allocation.allocate(symbols.getVariable("$3"), new RegisterAllocation.RegisterALUByte());
      //allocation.allocate(symbols.getVariable("$4"), new RegisterAllocation.RegisterAByte());
      //allocation.allocate(symbols.getVariable("$5"), new RegisterAllocation.RegisterAByte());
      //allocation.allocate(symbols.getVariable("$6"), new RegisterAllocation.RegisterALUByte());
      //allocation.allocate(symbols.getVariable("$7"), new RegisterAllocation.RegisterAByte());
      //allocation.allocate(symbols.getVariable("inc::a#2"), new RegisterAllocation.RegisterAByte());
      //allocation.allocate(symbols.getVariable("bv#0"), new RegisterAllocation.RegisterAByte());
      //allocation.allocate(symbols.getVariable("sum::b#0"), new RegisterAllocation.RegisterAByte());
      //allocation.allocate(symbols.getVariable("inc::b#1"), new RegisterAllocation.RegisterAByte());
      //allocation.allocate(symbols.getVariable("a#1"), new RegisterAllocation.RegisterAByte());
      //allocation.allocate(symbols.getVariable("a#0"), new RegisterAllocation.RegisterAByte());

      allocation.allocate(symbols.getVariable("plot::i#0"), RegisterAllocation.getRegisterX());
      allocation.allocate(symbols.getVariable("plot::i#1"), RegisterAllocation.getRegisterX());
      allocation.allocate(symbols.getVariable("plot::i#2"), RegisterAllocation.getRegisterX());
      allocation.allocate(symbols.getVariable("plot::i#3"), RegisterAllocation.getRegisterX());
      allocation.allocate(symbols.getVariable("plot::i#4"), RegisterAllocation.getRegisterX());
      allocation.allocate(symbols.getVariable("plot::x#0"), RegisterAllocation.getRegisterY());
      allocation.allocate(symbols.getVariable("plot::x#1"), RegisterAllocation.getRegisterY());
      allocation.allocate(symbols.getVariable("plot::x#2"), RegisterAllocation.getRegisterY());
      allocation.allocate(symbols.getVariable("plot::y#0"), new RegisterAllocation.RegisterZpByte(100));
      allocation.allocate(symbols.getVariable("plot::y#1"), new RegisterAllocation.RegisterZpByte(100));
      allocation.allocate(symbols.getVariable("plot::y#2"), new RegisterAllocation.RegisterZpByte(100));
      allocation.allocate(symbols.getVariable("plot::y#3"), new RegisterAllocation.RegisterZpByte(100));
      allocation.allocate(symbols.getVariable("plot::y#4"), new RegisterAllocation.RegisterZpByte(100));
      allocation.allocate(symbols.getVariable("plot::line#0"), new RegisterAllocation.RegisterZpPointerByte(101));
      allocation.allocate(symbols.getVariable("plot::line#1"), new RegisterAllocation.RegisterZpPointerByte(101));
      allocation.allocate(symbols.getVariable("plot::line#2"), new RegisterAllocation.RegisterZpPointerByte(101));
      allocation.allocate(symbols.getVariable("plot::line#3"), new RegisterAllocation.RegisterZpPointerByte(101));
      allocation.allocate(symbols.getVariable("plot::line#4"), new RegisterAllocation.RegisterZpPointerByte(101));
      allocation.allocate(symbols.getVariable("plot::$3"), RegisterAllocation.getRegisterA());
      allocation.allocate(symbols.getVariable("prepare::i#0"), RegisterAllocation.getRegisterX());
      allocation.allocate(symbols.getVariable("prepare::i#1"), RegisterAllocation.getRegisterX());
      allocation.allocate(symbols.getVariable("prepare::i#2"), RegisterAllocation.getRegisterX());
      allocation.allocate(symbols.getVariable("flip::srcIdx#0"), RegisterAllocation.getRegisterX());
      allocation.allocate(symbols.getVariable("flip::srcIdx#0"), RegisterAllocation.getRegisterX());
      allocation.allocate(symbols.getVariable("flip::srcIdx#1"), RegisterAllocation.getRegisterX());
      allocation.allocate(symbols.getVariable("flip::srcIdx#2"), RegisterAllocation.getRegisterX());
      allocation.allocate(symbols.getVariable("flip::srcIdx#3"), RegisterAllocation.getRegisterX());
      allocation.allocate(symbols.getVariable("flip::srcIdx#4"), RegisterAllocation.getRegisterX());
      allocation.allocate(symbols.getVariable("flip::dstIdx#0"), RegisterAllocation.getRegisterY());
      allocation.allocate(symbols.getVariable("flip::dstIdx#1"), RegisterAllocation.getRegisterY());
      allocation.allocate(symbols.getVariable("flip::dstIdx#2"), RegisterAllocation.getRegisterY());
      allocation.allocate(symbols.getVariable("flip::dstIdx#3"), RegisterAllocation.getRegisterY());
      allocation.allocate(symbols.getVariable("flip::dstIdx#4"), RegisterAllocation.getRegisterY());
      allocation.allocate(symbols.getVariable("flip::dstIdx#5"), RegisterAllocation.getRegisterY());
      allocation.allocate(symbols.getVariable("flip::c#0"), new RegisterAllocation.RegisterZpByte(103));
      allocation.allocate(symbols.getVariable("flip::c#1"), new RegisterAllocation.RegisterZpByte(103));
      allocation.allocate(symbols.getVariable("flip::c#2"), new RegisterAllocation.RegisterZpByte(103));
      allocation.allocate(symbols.getVariable("flip::r#0"), new RegisterAllocation.RegisterZpByte(104));
      allocation.allocate(symbols.getVariable("flip::r#1"), new RegisterAllocation.RegisterZpByte(104));
      allocation.allocate(symbols.getVariable("flip::r#2"), new RegisterAllocation.RegisterZpByte(104));
      allocation.allocate(symbols.getVariable("flip::r#3"), new RegisterAllocation.RegisterZpByte(104));
      allocation.allocate(symbols.getVariable("flip::r#4"), new RegisterAllocation.RegisterZpByte(104));
      allocation.allocate(symbols.getVariable("flip::i#0"), RegisterAllocation.getRegisterX());
      allocation.allocate(symbols.getVariable("flip::i#1"), RegisterAllocation.getRegisterX());
      allocation.allocate(symbols.getVariable("flip::i#2"), RegisterAllocation.getRegisterX());
      allocation.allocate(symbols.getVariable("flip::$0"), RegisterAllocation.getRegisterA());
      allocation.allocate(symbols.getVariable("flip::$8"), RegisterAllocation.getRegisterA());
      allocation.allocate(symbols.getVariable("$1"), RegisterAllocation.getRegisterA());
      allocation.allocate(symbols.getVariable("$3"), RegisterAllocation.getRegisterA());
      allocation.allocate(symbols.getVariable("c#0"), RegisterAllocation.getRegisterX());
      allocation.allocate(symbols.getVariable("c#1"), RegisterAllocation.getRegisterX());
      allocation.allocate(symbols.getVariable("c#2"), RegisterAllocation.getRegisterX());
      allocation.allocate(symbols.getVariable("c#3"), RegisterAllocation.getRegisterX());
      allocation.allocate(symbols.getVariable("c#4"), RegisterAllocation.getRegisterX());

      symbols.setAllocation(allocation);

   }

   private void performAllocation(Scope scope, RegisterAllocation allocation) {
      for (Symbol symbol : scope.getSymbols()) {
         if (symbol instanceof Scope) {
            performAllocation((Scope) symbol, allocation);
         } else if (symbol instanceof VariableIntermediate || symbol instanceof VariableVersion) {
            Variable var = (Variable) symbol;
            if (symbol.getType().equals(SymbolTypeBasic.BYTE)) {
               allocation.allocate(var, new RegisterAllocation.RegisterZpByte(currentZp++));
            } else if (symbol.getType().equals(SymbolTypeBasic.WORD)) {
               allocation.allocate(var, new RegisterAllocation.RegisterZpWord(currentZp));
               currentZp = currentZp + 2;
            } else if (symbol.getType().equals(SymbolTypeBasic.BOOLEAN)) {
               allocation.allocate(var, new RegisterAllocation.RegisterZpBool(currentZp++));
            } else if (symbol.getType().equals(SymbolTypeBasic.VOID)) {
               // No need to allocate register for VOID value
            } else if (symbol.getType() instanceof SymbolTypePointer) {
               allocation.allocate(var, new RegisterAllocation.RegisterZpPointerByte(currentZp));
               currentZp = currentZp + 2;
            } else {
               throw new RuntimeException("Unhandled variable type " + symbol);
            }
         }
      }
   }

}

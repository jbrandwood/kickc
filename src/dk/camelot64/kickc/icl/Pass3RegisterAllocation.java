package dk.camelot64.kickc.icl;

/** Register Allocation for variables */
public class Pass3RegisterAllocation {

   private ControlFlowGraph graph;
   private SymbolTable symbols;

   public Pass3RegisterAllocation(ControlFlowGraph graph, SymbolTable symbols) {
      this.graph = graph;
      this.symbols = symbols;
   }

   public void allocate() {
      RegisterAllocation allocation = new RegisterAllocation();
      int currentZp = 2;
      for (Variable var : symbols.getAllVariables()) {
         if(var instanceof VariableIntermediate || var instanceof VariableVersion)
            if(var.getType().equals(SymbolTypeBasic.BYTE)) {
               allocation.allocate(var, new RegisterAllocation.RegisterZpByte(currentZp++));
            } else if(var.getType().equals(SymbolTypeBasic.WORD)) {
               allocation.allocate(var, new RegisterAllocation.RegisterZpWord(currentZp));
               currentZp = currentZp +2;
            } else if(var.getType().equals(SymbolTypeBasic.BOOLEAN))  {
               allocation.allocate(var, new RegisterAllocation.RegisterZpBool(currentZp++));
            } else if(var.getType() instanceof SymbolTypePointer) {
               allocation.allocate(var, new RegisterAllocation.RegisterZpPointerByte(currentZp));
               currentZp = currentZp +2;
            } else {
               throw new RuntimeException("Unhandled variable type "+var);
            }
      }
      allocation.allocate(symbols.getVariable("i#0"), RegisterAllocation.getRegisterX());
      allocation.allocate(symbols.getVariable("i#1"), RegisterAllocation.getRegisterX());
      allocation.allocate(symbols.getVariable("i#2"), RegisterAllocation.getRegisterX());
      allocation.allocate(symbols.getVariable("i#3"), RegisterAllocation.getRegisterX());
      allocation.allocate(symbols.getVariable("i#4"), RegisterAllocation.getRegisterX());
      allocation.allocate(symbols.getVariable("i#5"), RegisterAllocation.getRegisterX());
      allocation.allocate(symbols.getVariable("n1#1"), RegisterAllocation.getRegisterY());
      allocation.allocate(symbols.getVariable("n1#2"), RegisterAllocation.getRegisterY());
      allocation.allocate(symbols.getVariable("e#2"), new RegisterAllocation.RegisterZpByte(128));
      allocation.allocate(symbols.getVariable("e#3"), new RegisterAllocation.RegisterZpByte(128));
      allocation.allocate(symbols.getVariable("e#4"), new RegisterAllocation.RegisterZpByte(128));
      allocation.allocate(symbols.getVariable("e#5"), new RegisterAllocation.RegisterZpByte(128));
      allocation.allocate(symbols.getVariable("idx#2"), new RegisterAllocation.RegisterZpWord(129));
      allocation.allocate(symbols.getVariable("idx#3"), new RegisterAllocation.RegisterZpWord(129));
      allocation.allocate(symbols.getVariable("idx#4"), new RegisterAllocation.RegisterZpWord(129));
      allocation.allocate(symbols.getVariable("idx#5"), new RegisterAllocation.RegisterZpWord(129));
      allocation.allocate(symbols.getVariable("x#2"), new RegisterAllocation.RegisterZpByte(131));
      allocation.allocate(symbols.getVariable("x#5"), new RegisterAllocation.RegisterZpByte(131));
      allocation.allocate(symbols.getVariable("y#1"), new RegisterAllocation.RegisterZpByte(132));
      allocation.allocate(symbols.getVariable("y#2"), new RegisterAllocation.RegisterZpByte(132));
      allocation.allocate(symbols.getVariable("y#5"), new RegisterAllocation.RegisterZpByte(132));
      allocation.allocate(symbols.getVariable("cursor#2"), new RegisterAllocation.RegisterZpPointerByte(133));
      allocation.allocate(symbols.getVariable("cursor#3"), new RegisterAllocation.RegisterZpPointerByte(133));
      allocation.allocate(symbols.getVariable("cursor#4"), new RegisterAllocation.RegisterZpPointerByte(133));
      allocation.allocate(symbols.getVariable("cursor#5"), new RegisterAllocation.RegisterZpPointerByte(133));
      allocation.allocate(symbols.getVariable("ptr#1"), new RegisterAllocation.RegisterZpPointerByte(135));
      allocation.allocate(symbols.getVariable("ptr#2"), new RegisterAllocation.RegisterZpPointerByte(135));
      allocation.allocate(symbols.getVariable("ptr#3"), new RegisterAllocation.RegisterZpPointerByte(135));
      allocation.allocate(symbols.getVariable("v#1"), new RegisterAllocation.RegisterAByte());
      allocation.allocate(symbols.getVariable("v#2"), new RegisterAllocation.RegisterAByte());
      allocation.allocate(symbols.getVariable("v#3"), new RegisterAllocation.RegisterAByte());
      allocation.allocate(symbols.getVariable("v#4"), new RegisterAllocation.RegisterAByte());
      allocation.allocate(symbols.getVariable("v#5"), new RegisterAllocation.RegisterAByte());
      //allocation.allocate(symbols.getVariable("$0"), new RegisterAllocation.RegisterAByte());
      //allocation.allocate(symbols.getVariable("$1"), new RegisterAllocation.RegisterAByte());
      //allocation.allocate(symbols.getVariable("$2"), new RegisterAllocation.RegisterAByte());
      //allocation.allocate(symbols.getVariable("$3"), new RegisterAllocation.RegisterAByte());
      symbols.setAllocation(allocation);
   }

}

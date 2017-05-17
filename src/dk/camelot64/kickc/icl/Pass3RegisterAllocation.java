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
            if(var.getType().equals(SymbolType.BYTE)) {
               allocation.allocate(var, new RegisterAllocation.RegisterZpByte(currentZp++));
            } else if(var.getType().equals(SymbolType.BOOLEAN))  {
               allocation.allocate(var, new RegisterAllocation.RegisterZpBool(currentZp++));
            }
      }
      symbols.setAllocation(allocation);
   }

}

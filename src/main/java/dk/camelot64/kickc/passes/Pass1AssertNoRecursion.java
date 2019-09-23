package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CallGraph;
import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.values.ScopeRef;

import java.util.Collection;

/** Asserts that the program has no recursive calls */
public class Pass1AssertNoRecursion extends Pass1Base {

   public Pass1AssertNoRecursion(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      CallGraph callGraph = getProgram().getCallGraph();
      Collection<Procedure> procedures = getScope().getAllProcedures(true);
      for(Procedure procedure : procedures) {
         Collection<ScopeRef> recursiveCalls = callGraph.getRecursiveCalls(procedure.getRef());
         if(recursiveCalls.contains(procedure.getRef()) && !procedure.getCallingConvension().equals(Procedure.CallingConvension.STACK_CALL)) {
            throw new CompileError("ERROR! Recursion not allowed! Occurs in " + procedure.getRef());
         }
      }
      return false;
   }


}

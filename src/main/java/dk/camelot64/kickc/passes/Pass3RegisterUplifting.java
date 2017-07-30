package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.asm.AsmProgram;
import dk.camelot64.kickc.asm.parser.AsmClobber;
import dk.camelot64.kickc.icl.*;

import java.util.Collection;

/*** Uplift one variable into the A register - and check if the program still works */
public class Pass3RegisterUplifting {

   private Program program;
   private CompileLog log;

   public Pass3RegisterUplifting(Program program, CompileLog log) {
      this.program = program;
      this.log = log;
   }

   public Program getProgram() {
      return program;
   }

   public CompileLog getLog() {
      return log;
   }

   /**
    * Uplift one variable
    */
   public void uplift() {

      VariableRegisterWeights variableRegisterWeights = program.getScope().getVariableRegisterWeights();

      double maxWeight = 0.0;
      Variable maxVar = null;

      Collection<Variable> allVars = program.getScope().getAllVariables(true);
      RegisterAllocation allocation = program.getScope().getAllocation();

      for (Variable variable : allVars) {
         RegisterAllocation.Register currentRegister = allocation.getRegister(variable.getRef());
         if (currentRegister!=null && currentRegister.isZp()) {
            Double w = variableRegisterWeights.getWeight(variable.getRef());
            if (w != null && w > maxWeight) {
               maxWeight = w;
               maxVar = variable;
            }
         }
      }
      // Found max variable!
      if(maxVar!=null) {
         log.append("Uplifting of variable " + maxVar + " to A");
         allocation.allocate(maxVar.getRef(), new RegisterAllocation.RegisterAByte());
      }

   }


}

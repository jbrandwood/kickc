package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.VariableBuilder;
import dk.camelot64.kickc.model.VariableBuilderConfig;
import dk.camelot64.kickc.model.symbols.Variable;

/**
 * Fix the memory area for intermediate variables
 */
public class PassNFixIntermediateMemoryArea extends Pass2SsaOptimization {

   public PassNFixIntermediateMemoryArea(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      boolean modified = false;
      final VariableBuilderConfig variableBuilderConfig = getProgram().getTargetPlatform().getVariableBuilderConfig();
      for(Variable var : getScope().getAllVars(true)) {
         if(var.isKindIntermediate()) {
            final VariableBuilder builder = new VariableBuilder(var.getLocalName(), var.getScope(), false, true, var.getType(), null, var.getDataSegment(), variableBuilderConfig);
            final Variable.MemoryArea memoryArea = builder.getMemoryArea();
            if(!memoryArea.equals(var.getMemoryArea())) {
               // Update the variable memory area
               getLog().append("Updating intermediate variable memory area to "+memoryArea.name() + " " + var.toString());
               var.setMemoryArea(memoryArea);
               modified = true;
            }
         }

      }
      return modified;
   }
}

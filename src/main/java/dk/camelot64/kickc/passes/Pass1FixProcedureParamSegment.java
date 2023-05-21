package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.Registers;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.symbols.Variable;

import java.util.Collection;
import java.util.List;

/**
 * Ensure banked procedure parameters/return values in main memory are placed in the default data segment.
 * This is needed to support banking, since it is otherwise impossible to access them across bank boundaries during calls.
 */
public class Pass1FixProcedureParamSegment extends Pass2SsaOptimization {

   public Pass1FixProcedureParamSegment(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      final Collection<Variable> allVariables = getProgramScope().getAllVariables(true);
      for(Variable variable : allVariables) {
         if(variable.isKindLoadStore() || variable.isKindPhiMaster() || variable.isKindIntermediate()) {
            if(variable.getRegister() instanceof Registers.RegisterMainMem registerMainMem && registerMainMem.isAddressHardcoded())
               continue;
            if(variable.getDataSegment().equals(Scope.SEGMENT_DATA_DEFAULT))
               continue;
            
            final Scope scope = variable.getScope();
            if(scope instanceof Procedure procedure) {
               if(!procedure.getBank().isCommon()) {
                  List<Variable> parameters = procedure.getParameters();
                  if(parameters.contains(variable) || variable.getLocalName().equals("return")) {
                     variable.setDataSegment(Scope.SEGMENT_DATA_DEFAULT);
                     getLog().append("Fixing banked procedure parameter/return value to default segment " + variable.getFullName());
                  }
               }
            }
         }
      }
      return false;
   }
}

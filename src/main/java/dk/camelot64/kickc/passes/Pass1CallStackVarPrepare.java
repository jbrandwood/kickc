package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.VariableRef;

import java.util.Set;

/** Handle calling conventions {@link Procedure.CallingConvention#STACK_CALL} {@link Procedure.CallingConvention#VAR_CALL} by converting to call-prepare, call-execute, call-finalize */
public class Pass1CallStackVarPrepare extends Pass2SsaOptimization {

   public Pass1CallStackVarPrepare(Program program) {
      super(program);
   }

   @Override
   public boolean step() {

      // Set variables modified in STACK_CALL/VAR_CALL procedures to load/store
      for(Procedure procedure : getScope().getAllProcedures(true)) {
         if(Procedure.CallingConvention.STACK_CALL.equals(procedure.getCallingConvention()) || Procedure.CallingConvention.VAR_CALL.equals(procedure.getCallingConvention())) {
            Set<VariableRef> modifiedVars = getProgram().getProcedureModifiedVars().getModifiedVars(procedure.getRef());
            for(VariableRef modifiedVar : modifiedVars) {
               final Variable variable = getScope().getVariable(modifiedVar);
               if(variable.isKindPhiMaster()) {
                  getLog().append("Converting variable modified inside "+procedure.getCallingConvention().getName()+" procedure "+procedure.getFullName()+"() to load/store "+variable.toString(getProgram()));
                  variable.setKind(Variable.Kind.LOAD_STORE);
               }
            }
         }
      }

      // Set all parameter/return variables in VAR_CALL procedures to LOAD/STORE
      for(Procedure procedure : getScope().getAllProcedures(true)) {
         if(Procedure.CallingConvention.VAR_CALL.equals(procedure.getCallingConvention())) {
            for(Variable parameter : procedure.getParameters()) {
               parameter.setKind(Variable.Kind.LOAD_STORE);
               getLog().append("Converting parameter in "+procedure.getCallingConvention().getName()+" procedure to load/store "+parameter.toString(getProgram()));
            }
            if(!SymbolType.VOID.equals(procedure.getReturnType())) {
               Variable returnVar = procedure.getLocalVariable("return");
               returnVar.setKind(Variable.Kind.LOAD_STORE);
               getLog().append("Converting return in "+procedure.getCallingConvention().getName()+" procedure to load/store "+returnVar.toString(getProgram()));
            }
         }
      }

      return false;
   }


}

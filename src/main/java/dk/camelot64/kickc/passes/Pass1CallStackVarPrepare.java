package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.Comment;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.LValue;
import dk.camelot64.kickc.model.values.ParamValue;
import dk.camelot64.kickc.model.values.VariableRef;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Set;

/** Handle calling conventions {@link Procedure.CallingConvention#STACK_CALL} by converting parameters, return values and modified variables to load/store and  by adding parameter assignemtn statements to procedures*/
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

      // Add parameter assignments at start of procedure in STACK_CALL procedures
      for(Procedure procedure : getScope().getAllProcedures(true)) {
         if(procedure.isDeclaredIntrinsic()) continue;
         if(Procedure.CallingConvention.STACK_CALL.equals(procedure.getCallingConvention())) {
            final ControlFlowBlock procedureBlock = getGraph().getBlock(procedure.getLabel().getRef());
            final ArrayList<Variable> params = new ArrayList<>(procedure.getParameters());
            Collections.reverse(params);
            for(Variable param : params) {
               final StatementAssignment paramAssignment = new StatementAssignment((LValue) param.getRef(), new ParamValue((VariableRef) param.getRef()), true, null, Comment.NO_COMMENTS);
               procedureBlock.getStatements().add(0, paramAssignment);
               getLog().append("Adding parameter assignment in "+procedure.getCallingConvention().getName()+" procedure "+paramAssignment.toString(getProgram(), false));
            }
         }
      }

      return false;
   }


}

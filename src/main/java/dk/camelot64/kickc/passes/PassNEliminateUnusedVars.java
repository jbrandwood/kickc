package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.VariableReferenceInfos;
import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.symbols.EnumDefinition;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.symbols.StructDefinition;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.values.LValue;
import dk.camelot64.kickc.model.values.StructUnwoundPlaceholder;
import dk.camelot64.kickc.model.values.VariableRef;

import java.util.Collection;
import java.util.ListIterator;

/**
 * Eliminate unused variables or constants
 */
public class PassNEliminateUnusedVars extends Pass2SsaOptimization {

   private boolean pass2;

   public PassNEliminateUnusedVars(Program program, boolean pass2) {
      super(program);
      this.pass2 = pass2;
   }

   @Override
   public boolean step() {
      new PassNStatementIndices(getProgram()).execute();
      getProgram().clearVariableReferenceInfos();
      getProgram().clearControlFlowBlockSuccessorClosure();
      VariableReferenceInfos referenceInfos = getProgram().getVariableReferenceInfos();
      boolean modified = false;
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         ListIterator<Statement> stmtIt = block.getStatements().listIterator();
         while(stmtIt.hasNext()) {
            Statement statement = stmtIt.next();
            if(statement instanceof StatementAssignment) {
               LValue lValue = ((StatementAssignment) statement).getlValue();
               if(lValue instanceof VariableRef) {
                  Variable variable = getProgramScope().getVariable((VariableRef) lValue);
                  if(eliminate(variable, referenceInfos, statement)) {
                     if(pass2 || getLog().isVerbosePass1CreateSsa()) {
                        getLog().append("Eliminating unused variable " + lValue.toString(getProgram()) + " and assignment " + statement.toString(getProgram(), false));
                     }
                     stmtIt.remove();
                     if(variable != null) {
                        variable.getScope().remove(variable);
                     }
                     modified = true;
                  }
               }
            } else if(statement instanceof StatementCall) {
               LValue lValue = ((StatementCall) statement).getlValue();
               if(lValue instanceof VariableRef) {
                  Variable variable = getProgramScope().getVariable((VariableRef) lValue);
                  if(eliminate(variable, referenceInfos, statement)) {
                     if(pass2 || getLog().isVerbosePass1CreateSsa()) {
                        getLog().append("Eliminating unused variable - keeping the call " + lValue.toString(getProgram()));
                     }
                     if(variable != null) {
                        variable.getScope().remove(variable);
                     }
                     ((StatementCall) statement).setlValue(null);
                     modified = true;
                  }
               }
            } else if(statement instanceof StatementCallFinalize) {
               LValue lValue = ((StatementCallFinalize) statement).getlValue();
               if(lValue instanceof VariableRef) {
                  Variable variable = getProgramScope().getVariable((VariableRef) lValue);
                  if(eliminate(variable, referenceInfos, statement)) {
                     if(pass2 || getLog().isVerbosePass1CreateSsa()) {
                        getLog().append("Eliminating unused variable - keeping the call " + lValue.toString(getProgram()));
                     }
                     if(variable != null) {
                        variable.getScope().remove(variable);
                     }
                     ((StatementCallFinalize) statement).setlValue(null);
                     modified = true;
                  }
               }
            } else if(statement instanceof StatementCallPointer) {
               LValue lValue = ((StatementCallPointer) statement).getlValue();
               if(lValue instanceof VariableRef) {
                  Variable variable = getProgramScope().getVariable((VariableRef) lValue);
                  if(eliminate(variable, referenceInfos, statement)) {
                     if(pass2 || getLog().isVerbosePass1CreateSsa()) {
                        getLog().append("Eliminating unused variable - keeping the call " + lValue.toString(getProgram()));
                     }
                     if(variable != null) {
                        variable.getScope().remove(variable);
                     }
                     ((StatementCallPointer) statement).setlValue(null);
                     modified = true;
                  }
               }
            } else if(statement instanceof StatementPhiBlock) {
               StatementPhiBlock statementPhi = (StatementPhiBlock) statement;
               ListIterator<StatementPhiBlock.PhiVariable> phiVarIt = statementPhi.getPhiVariables().listIterator();
               while(phiVarIt.hasNext()) {
                  StatementPhiBlock.PhiVariable phiVariable = phiVarIt.next();
                  VariableRef variableRef = phiVariable.getVariable();
                  Variable variable = getProgramScope().getVariable(variableRef);
                  if(eliminate(variable, referenceInfos, statement)) {
                     if(pass2 || getLog().isVerbosePass1CreateSsa()) {
                        getLog().append("Eliminating unused variable - keeping the phi block " + variableRef.toString(getProgram()));
                     }
                     if(variable != null) {
                        variable.getScope().remove(variable);
                     }
                     phiVarIt.remove();
                     modified = true;
                  }
               }
            }
         }
      }

      for(Variable variable : getProgramScope().getAllVariables(true)) {
         if(eliminate(variable, referenceInfos, null) && !variable.isKindPhiMaster()) {
            getLog().append("Eliminating unused variable with no statement " + variable.getRef().toString(getProgram()));
            variable.getScope().remove(variable);
         }
      }

      Collection<Variable> allConstants = getProgramScope().getAllConstants(true);
      for(Variable constant : allConstants) {
         if(eliminate(constant, referenceInfos, null)) {
            if(pass2 || getLog().isVerbosePass1CreateSsa()) {
               getLog().append("Eliminating unused constant " + constant.toString(getProgram()));
            }
            constant.getScope().remove(constant);
            modified = true;
         }
      }

      getProgram().clearVariableReferenceInfos();
      getProgram().clearControlFlowBlockSuccessorClosure();
      getProgram().clearStatementIndices();
      return modified;
   }

   /**
    * Is the variable an unused variable that should be eliminated
    *
    * @param variable The variable
    * @param referenceInfos The reference info
    * @param statement The statement
    * @return true if the variable & statement should be eliminated
    */
   private boolean eliminate(Variable variable, VariableReferenceInfos referenceInfos, Statement statement) {
      if(variable == null)
         // Eliminate if already deleted
         return true;
      if(variable.getScope() instanceof EnumDefinition || variable.getScope() instanceof StructDefinition)
         // Do not eliminate inside enums or structs
         return false;
      if(!pass2 && isReturnValue(variable)) {
         // Do not eliminate return variables in pass 1
         return false;
      }
      if(variable.getScope() instanceof Procedure && ((Procedure) variable.getScope()).getParameters().contains(variable)) {
         // Do not eliminate parameters
         return false;
      }
      final boolean unused = referenceInfos.isUnused(variable.getRef());
      if(!unused)
         // Do not eliminate is not unused
         return false;
      if(!variable.isExport())
         // Eliminate if unused and not exported
         return true;
      if(variable.isStruct() && statement instanceof StatementAssignment) {
         StatementAssignment assignment = (StatementAssignment) statement;
         // Eliminate is a simple assignment of a struct-unwound-placeholder
         return assignment.getOperator() == null && assignment.getrValue2() instanceof StructUnwoundPlaceholder;
      }
      return false;
   }

   /**
    * Determines if a variable is the return value for a procedure
    *
    * @param variable The variable
    * @return true if this is the return variable for a function
    */
   private boolean isReturnValue(Variable variable) {
      if(variable == null) return false;
      return variable.getScope() instanceof Procedure && variable.getLocalName().equals("return");
   }


}

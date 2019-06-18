package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.StructUnwinding;
import dk.camelot64.kickc.model.VariableReferenceInfos;
import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.symbols.ConstantVar;
import dk.camelot64.kickc.model.symbols.EnumDefinition;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;
import dk.camelot64.kickc.model.values.LValue;
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
      new PassNVariableReferenceInfos(getProgram()).execute();
      VariableReferenceInfos referenceInfos = getProgram().getVariableReferenceInfos();
      boolean modified = false;
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         ListIterator<Statement> stmtIt = block.getStatements().listIterator();
         while(stmtIt.hasNext()) {
            Statement statement = stmtIt.next();
            if(statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               LValue lValue = assignment.getlValue();
               if(lValue instanceof VariableRef && referenceInfos.isUnused((VariableRef) lValue)) {
                  Variable variable = getScope().getVariable((VariableRef) lValue);
                  boolean eliminate = false;
                  if(variable == null) {
                     // Already deleted
                     eliminate = true;
                  } else if(!variable.isVolatile()) {
                     // Not volatile
                     eliminate = true;
                  } else if(variable.isVolatile() && variable.getType() instanceof SymbolTypeStruct) {
                     // If an unwound volatile struct - eliminate it
                     StructUnwinding.VariableUnwinding variableUnwinding = getProgram().getStructUnwinding().getVariableUnwinding(variable.getRef());
                     if(variableUnwinding != null) {
                        eliminate = true;
                     }
                  }
                  if(eliminate) {
                     if(!pass2 && isReturnValue(variable)) {
                        // Do not eliminate return variables in pass 1
                        continue;
                     }
                     if(pass2 || getLog().isVerbosePass1CreateSsa()) {
                        getLog().append("Eliminating unused variable " + lValue.toString(getProgram()) + " and assignment " + assignment.toString(getProgram(), false));
                     }
                     stmtIt.remove();
                     if(variable != null) {
                        variable.getScope().remove(variable);
                     }
                     modified = true;
                  }
               }
            } else if(statement instanceof StatementCall) {
               StatementCall call = (StatementCall) statement;
               LValue lValue = call.getlValue();
               if(lValue instanceof VariableRef && referenceInfos.isUnused((VariableRef) lValue)) {
                  Variable variable = getScope().getVariable((VariableRef) lValue);
                  if(!variable.isVolatile()) {
                     if(pass2 || getLog().isVerbosePass1CreateSsa()) {
                        getLog().append("Eliminating unused variable - keeping the call " + lValue.toString(getProgram()));
                     }
                     if(variable != null) {
                        variable.getScope().remove(variable);
                     }
                     call.setlValue(null);
                     modified = true;
                  }
               }
            } else if(statement instanceof StatementCallPointer) {
               StatementCallPointer call = (StatementCallPointer) statement;
               LValue lValue = call.getlValue();
               if(lValue instanceof VariableRef && referenceInfos.isUnused((VariableRef) lValue)) {
                  Variable variable = getScope().getVariable((VariableRef) lValue);
                  if(!variable.isVolatile()) {
                     if(pass2 || getLog().isVerbosePass1CreateSsa()) {
                        getLog().append("Eliminating unused variable - keeping the call " + lValue.toString(getProgram()));
                     }
                     if(variable != null) {
                        variable.getScope().remove(variable);
                     }
                     call.setlValue(null);
                     modified = true;
                  }
               }
            } else if(statement instanceof StatementPhiBlock) {
               StatementPhiBlock statementPhi = (StatementPhiBlock) statement;
               ListIterator<StatementPhiBlock.PhiVariable> phiVarIt = statementPhi.getPhiVariables().listIterator();
               while(phiVarIt.hasNext()) {
                  StatementPhiBlock.PhiVariable phiVariable = phiVarIt.next();
                  VariableRef variableRef = phiVariable.getVariable();
                  if(referenceInfos.isUnused(variableRef)) {
                     Variable variable = getScope().getVariable(variableRef);
                     if(!variable.isVolatile()) {
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
      }

      Collection<ConstantVar> allConstants = getScope().getAllConstants(true);
      for(ConstantVar constant : allConstants) {
         if(!(constant.getScope() instanceof EnumDefinition)) {
            if(referenceInfos.isUnused(constant.getRef())) {
               if(pass2 || getLog().isVerbosePass1CreateSsa()) {
                  getLog().append("Eliminating unused constant " + constant.toString(getProgram()));
               }
               constant.getScope().remove(constant);
               modified = true;
            }
         }
      }

      getProgram().setVariableReferenceInfos(null);
      new PassNStatementIndices(getProgram()).clearStatementIndices();
      return modified;
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

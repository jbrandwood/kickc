package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.statements.StatementPhiBlock;
import dk.camelot64.kickc.model.values.LValue;
import dk.camelot64.kickc.model.values.VariableRef;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.statements.StatementCall;
import dk.camelot64.kickc.model.symbols.ConstantVar;
import dk.camelot64.kickc.model.symbols.Variable;

import java.util.Collection;
import java.util.ListIterator;

/**
 * Eliminate unused variables or constants
 */
public class PassNEliminateUnusedVars extends Pass2SsaOptimization {

   public PassNEliminateUnusedVars(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      new PassNStatementIndices(getProgram()).generateStatementIndices();
      new PassNVariableReferenceInfos(getProgram()).generateVariableReferenceInfos();
      VariableReferenceInfos referenceInfos = getProgram().getVariableReferenceInfos();
      boolean modified = false;
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         ListIterator<Statement> stmtIt = block.getStatements().listIterator();
         while(stmtIt.hasNext()) {
            Statement statement = stmtIt.next();
            if(statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               LValue lValue = assignment.getlValue();
               if(lValue instanceof VariableRef && referenceInfos.isUnused((VariableRef) lValue) && !Pass2ConstantIdentification.isAddressOfUsed((VariableRef) lValue, getProgram())) {
                  getLog().append("Eliminating unused variable " + lValue.toString(getProgram()) + " and assignment " + assignment.toString(getProgram(), false));
                  stmtIt.remove();
                  Variable variable = getScope().getVariable((VariableRef) lValue);
                  variable.getScope().remove(variable);
                  modified = true;
               }
            } else if(statement instanceof StatementCall) {
               StatementCall call = (StatementCall) statement;
               LValue lValue = call.getlValue();
               if(lValue instanceof VariableRef && referenceInfos.isUnused((VariableRef) lValue) && !Pass2ConstantIdentification.isAddressOfUsed((VariableRef) lValue, getProgram())) {
                  getLog().append("Eliminating unused variable - keeping the call " + lValue.toString(getProgram()));
                  Variable variable = getScope().getVariable((VariableRef) lValue);
                  variable.getScope().remove(variable);
                  call.setlValue(null);
                  modified = true;
               }
            } else if(statement instanceof StatementPhiBlock) {
               StatementPhiBlock statementPhi = (StatementPhiBlock) statement;
               ListIterator<StatementPhiBlock.PhiVariable> phiVarIt = statementPhi.getPhiVariables().listIterator();
               while(phiVarIt.hasNext()) {
                  StatementPhiBlock.PhiVariable phiVariable = phiVarIt.next();
                  VariableRef variableRef = phiVariable.getVariable();
                  if(referenceInfos.isUnused(variableRef) && !Pass2ConstantIdentification.isAddressOfUsed(variableRef, getProgram())) {
                     getLog().append("Eliminating unused variable - keeping the phi block " + variableRef.toString(getProgram()));
                     Variable variable = getScope().getVariable(variableRef);
                     variable.getScope().remove(variable);
                     phiVarIt.remove();
                     modified = true;
                  }
               }
            }
         }
      }

      Collection<ConstantVar> allConstants = getScope().getAllConstants(true);
      for(ConstantVar constant : allConstants) {
         if(referenceInfos.isUnused(constant.getRef())) {
            getLog().append("Eliminating unused constant " + constant.toString(getProgram()));
            constant.getScope().remove(constant);
            modified = true;
         }
      }

      getProgram().setVariableReferenceInfos(null);
      new PassNStatementIndices(getProgram()).clearStatementIndices();
      return modified;
   }


}

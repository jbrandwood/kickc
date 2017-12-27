package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;

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
      for (ControlFlowBlock block : getGraph().getAllBlocks()) {
         ListIterator<Statement> stmtIt = block.getStatements().listIterator();
         while (stmtIt.hasNext()) {
            Statement statement = stmtIt.next();
            if (statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               LValue lValue = assignment.getlValue();
               if (lValue instanceof VariableRef && referenceInfos.isUnused((VariableRef) lValue)) {
                  getLog().append("Eliminating unused variable "+ lValue.toString(getProgram()) + " and assignment "+ assignment.toString(getProgram(), false));
                  stmtIt.remove();
                  Variable variable = getScope().getVariable((VariableRef) lValue);
                  variable.getScope().remove(variable);
                  modified = true;
               }
            } else if(statement instanceof StatementCall) {
               StatementCall call = (StatementCall) statement;
               LValue lValue = call.getlValue();
               if(lValue instanceof VariableRef && referenceInfos.isUnused((VariableRef) lValue)) {
                  getLog().append("Eliminating unused variable - keeping the call "+ lValue.toString(getProgram()));
                  Variable variable = getScope().getVariable((VariableRef) lValue);
                  variable.getScope().remove(variable);
                  call.setlValue(null);
                  modified = true;
               }
            }
         }
      }

      Collection<ConstantVar> allConstants = getScope().getAllConstants(true);
      for(ConstantVar constant : allConstants) {
         if(referenceInfos.isUnused(constant.getRef())) {
            getLog().append("Eliminating unused constant "+ constant.toString(getProgram()));
            constant.getScope().remove(constant);
            modified = true;
         }
      }

      getProgram().setVariableReferenceInfos(null);
      new PassNStatementIndices(getProgram()).clearStatementIndices();
      return modified;
   }


}

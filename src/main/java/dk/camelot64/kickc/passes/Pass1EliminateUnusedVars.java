package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;

import java.util.*;

/**
 * Eliminate unused variables
 */
public class Pass1EliminateUnusedVars extends Pass1Base {

   public Pass1EliminateUnusedVars(Program program) {
      super(program);
   }

   @Override
   public boolean executeStep() {
      new Pass3StatementIndices(getProgram()).generateStatementIndices();
      new Pass3VariableReferenceInfos(getProgram()).generateVariableReferenceInfos();

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

      getProgram().setVariableReferenceInfos(null);
      new Pass3StatementIndices(getProgram()).clearStatementIndices();

      return modified;
   }


}

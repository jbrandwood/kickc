package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.VariableReferenceInfos;
import dk.camelot64.kickc.model.iterator.ProgramExpressionBinary;
import dk.camelot64.kickc.model.iterator.ProgramExpressionIterator;
import dk.camelot64.kickc.model.iterator.ProgramValue;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.values.*;

import java.util.ArrayList;
import java.util.Collection;
import java.util.LinkedHashSet;

/**
 * Checks that no-modify variables are not assigned
 */
public class Pass1AssertNoModifyVars extends Pass1Base {

   public Pass1AssertNoModifyVars(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementLValue) {
               StatementLValue statementLValue = (StatementLValue) statement;
               if(!statementLValue.isInitialAssignment() && statementLValue.getlValue() instanceof VariableRef) {
                  Variable assignedVar = getScope().getVariable((VariableRef) statementLValue.getlValue());
                  if(assignedVar.isNoModify())
                     throw new CompileError("Error! const variable may not be modified! " + assignedVar.toString(), statement);
               }
            }
         }
      }
      return false;
   }
}

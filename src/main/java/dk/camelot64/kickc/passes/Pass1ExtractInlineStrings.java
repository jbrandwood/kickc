package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;

import java.util.*;

/**
 * Eliminate uncalled methods
 */
public class Pass1ExtractInlineStrings {

   private Program program;

   public Pass1ExtractInlineStrings(Program program) {
      this.program = program;
   }

   public void extract() {
      for (ControlFlowBlock block : program.getGraph().getAllBlocks()) {
         ListIterator<Statement> stmtIt = block.getStatements().listIterator();
         Scope blockScope = program.getScope().getScope(block.getScope());
         while (stmtIt.hasNext()) {
            Statement statement = stmtIt.next();
            if (statement instanceof StatementCall) {
               StatementCall call = (StatementCall) statement;
               ListIterator<RValue> parIt = call.getParameters().listIterator();
               int parNum = 0;
               while (parIt.hasNext()) {
                  RValue parameter = parIt.next();
                  if (parameter instanceof ConstantString) {
                     Procedure procedure = program.getScope().getProcedure(call.getProcedure());
                     String parameterName = procedure.getParameterNames().get(parNum);
                     ConstantVar strConst = createStringConstantVar(blockScope, (ConstantString) parameter, parameterName);
                     parIt.set(strConst.getRef());
                  }
                  parNum++;
               }
            } else if (statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               if(assignment.getrValue1() instanceof ConstantString && assignment.getrValue2() instanceof ConstantString) {
                  continue;
               }
               if (assignment.getrValue1() instanceof ConstantString) {
                  ConstantVar strConst = createStringConstantVar(blockScope, (ConstantString) assignment.getrValue1(), null);
                  assignment.setrValue1(strConst.getRef());
               }
               if (assignment.getrValue2() instanceof ConstantString && assignment.getOperator() != null) {
                  ConstantVar strConst = createStringConstantVar(blockScope, (ConstantString) assignment.getrValue2(), null);
                  assignment.setrValue2(strConst.getRef());
               }
            } else if (statement instanceof StatementReturn) {
               StatementReturn statementReturn = (StatementReturn) statement;
               if (statementReturn.getValue() instanceof ConstantString) {
                  ConstantVar strConst = createStringConstantVar(blockScope, (ConstantString) statementReturn.getValue(), null);
                  statementReturn.setValue(strConst.getRef());
               }
            }
         }
      }

   }

   private ConstantVar createStringConstantVar(Scope blockScope, ConstantString constantString, String nameHint) {
      String name;
      if (nameHint == null) {
         name = blockScope.allocateIntermediateVariableName();
      } else {
         int nameHintIdx = 1;
         name = nameHint;
         while (blockScope.getSymbol(name) != null) {
            name = nameHint + nameHintIdx++;
         }
      }
      ConstantVar strConst = new ConstantVar(name, blockScope, new SymbolTypeArray(SymbolType.BYTE), constantString);
      blockScope.add(strConst);
      program.getLog().append("Creating constant string variable for inline " + strConst.toString(program) + " \"" + constantString.getValue() + "\"");
      return strConst;
   }

}

package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;

import java.util.*;

/**
 * All inline strings in the code are extracted into constants.
 */
public class Pass1ExtractInlineStrings extends Pass1Base {

   public Pass1ExtractInlineStrings(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      ValueReplacer.executeAll(getGraph(), (replaceable, currentStmt, currentBlock) -> {
         String nameHint = null;
         if(currentStmt instanceof StatementCall) {
            StatementCall call = (StatementCall) currentStmt;
            List<RValue> parameters = call.getParameters();
            for (int i = 0; i < parameters.size(); i++) {
               RValue parameter = parameters.get(i);
               if(parameter.equals(replaceable.get())) {
                  // The replaceable value is the parameter - use the parameter name as name hint
                  Procedure procedure = getProgram().getScope().getProcedure(call.getProcedure());
                  nameHint = procedure.getParameterNames().get(i);
                  break;
               }
            }
         }
         Scope blockScope = getProgram().getScope().getScope(currentBlock.getScope());
         RValue value = replaceable.get();
         if(value instanceof ConstantString) {
            ConstantVar strConst = createStringConstantVar(blockScope, (ConstantString) replaceable.get(), nameHint);
            replaceable.set(strConst.getRef());
         }
      });

      /*
      for (ControlFlowBlock block : getProgram().getGraph().getAllBlocks()) {
         ListIterator<Statement> stmtIt = block.getStatements().listIterator();
         Scope blockScope = getProgram().getScope().getScope(block.getScope());
         while (stmtIt.hasNext()) {
            Statement statement = stmtIt.next();
            if (statement instanceof StatementCall) {
               StatementCall call = (StatementCall) statement;
               Procedure procedure = getProgram().getScope().getProcedure(call.getProcedure());
               List<RValue> parameters = call.getParameters();
               int size = parameters.size();
               for (int i = 0; i < size; i++) {
                  String parameterName = procedure.getParameterNames().get(i);
                  execute(new ValueReplacer.ReplaceableCallParameter(call, i), blockScope, parameterName);
               }
            } else if (statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               if(assignment.getrValue1()==null && assignment.getOperator()==null && assignment.getrValue2() instanceof ConstantString) {
                  // This will be picked up later as a constant - the temporary constant variable is not needed
                  continue;
               }
               if(assignment.getrValue1() instanceof ConstantString && assignment.getrValue2() instanceof ConstantString) {
                  // This will be picked up later as a constant - the temporary constant variable is not needed
                  continue;
               }
               execute(new ValueReplacer.ReplaceableRValue1(assignment), blockScope, null);
               execute(new ValueReplacer.ReplaceableRValue2(assignment), blockScope, null);
            } else if (statement instanceof StatementReturn) {
               execute(new ValueReplacer.ReplaceableReturn((StatementReturn) statement), blockScope, null);
            }
         }
      }
      */
      return false;
   }

   private void execute(ValueReplacer.ReplaceableValue replaceable, Scope blockScope, String nameHint) {
      RValue value = replaceable.get();
      if(value instanceof ConstantString) {
         ConstantVar strConst = createStringConstantVar(blockScope, (ConstantString) replaceable.get(), nameHint);
         replaceable.set(strConst.getRef());
      }
      for (ValueReplacer.ReplaceableValue subValue : replaceable.getSubValues()) {
         execute(subValue, blockScope, nameHint);
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
      ConstantVar strConst = new ConstantVar(name, blockScope, SymbolType.STRING, constantString);
      blockScope.add(strConst);
      getLog().append("Creating constant string variable for inline " + strConst.toString(getProgram()) + " \"" + constantString.getValue() + "\"");
      return strConst;
   }

}

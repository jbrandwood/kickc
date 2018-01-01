package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;

/**
 * Asserts that all arrays with lengths and initializers have matching lengths.
 */
public class Pass1AssertArrayLengths extends Pass1Base {

   public Pass1AssertArrayLengths(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               LValue lValue = assignment.getlValue();
               if(lValue instanceof VariableRef) {
                  Variable variable = getScope().getVariable((VariableRef) lValue);
                  if(variable.getType() instanceof SymbolTypeArray) {
                     Integer declaredSize = ((SymbolTypeArray) variable.getType()).getSize();
                     if(declaredSize != null) {
                        if(assignment.getrValue1() == null && assignment.getOperator() == null) {
                           RValue value = assignment.getrValue2();
                           if(value instanceof ValueList) {
                              if(((ValueList) value).getList().size() != declaredSize) {
                                 throw new CompileError("Error! Array length mismatch " + statement.toString(getProgram(), false));
                              }
                           } else if(value instanceof ConstantString) {
                              if(((ConstantString) value).getValue().length() != declaredSize) {
                                 throw new CompileError("Error! Array length mismatch " + statement.toString(getProgram(), false));
                              }
                           }
                        }
                     }
                  }
               }
            }
         }
      }
      return false;
   }

}

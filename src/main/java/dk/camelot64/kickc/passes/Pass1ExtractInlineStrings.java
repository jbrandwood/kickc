package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;

import java.util.List;

/**
 * All inline strings in the code are extracted into constants.
 */
public class Pass1ExtractInlineStrings extends Pass1Base {

   public Pass1ExtractInlineStrings(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      ValueReplacer.executeAll(getGraph(), (replaceable, currentStmt, stmtIt, currentBlock) -> {
         String nameHint = null;
         if(currentStmt instanceof StatementCall) {
            StatementCall call = (StatementCall) currentStmt;
            List<RValue> parameters = call.getParameters();
            for(int i = 0; i < parameters.size(); i++) {
               RValue parameter = parameters.get(i);
               if(parameter.equals(replaceable.get())) {
                  // The replaceable value is the parameter - use the parameter name as name hint
                  Procedure procedure = Pass1ExtractInlineStrings.this.getProgram().getScope().getProcedure(call.getProcedure());
                  nameHint = procedure.getParameterNames().get(i);
                  break;
               }
            }
         }
         Scope blockScope = Pass1ExtractInlineStrings.this.getProgram().getScope().getScope(currentBlock.getScope());
         RValue value = replaceable.get();
         if(value instanceof ConstantString) {
            ConstantVar strConst = Pass1ExtractInlineStrings.this.createStringConstantVar(blockScope, (ConstantString) replaceable.get(), nameHint);
            replaceable.set(strConst.getRef());
         }
      });
      return false;
   }

   private ConstantVar createStringConstantVar(Scope blockScope, ConstantString constantString, String nameHint) {
      String name;
      if(nameHint == null) {
         name = blockScope.allocateIntermediateVariableName();
      } else {
         int nameHintIdx = 1;
         name = nameHint;
         while(blockScope.getSymbol(name) != null) {
            name = nameHint + nameHintIdx++;
         }
      }
      ConstantVar strConst = new ConstantVar(name, blockScope, SymbolType.STRING, constantString);
      blockScope.add(strConst);
      getLog().append("Creating constant string variable for inline " + strConst.toString(getProgram()) + " \"" + constantString.getValue() + "\"");
      return strConst;
   }

}

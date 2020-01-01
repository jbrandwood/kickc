package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Initializers;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeInference;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;
import dk.camelot64.kickc.model.values.ConstantValue;
import dk.camelot64.kickc.model.values.RValue;

/**
 * Constantify all assignment RValues that are structs
 */
public class Pass1ConstantifyRValue extends Pass2SsaOptimization {

   public Pass1ConstantifyRValue(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               if(assignment.getOperator()==null) {
                  SymbolType lValueType = SymbolTypeInference.inferType(getProgram().getScope(), assignment.getlValue());
                  RValue rValue = assignment.getrValue2();
                  if(!(rValue instanceof ConstantValue) && lValueType instanceof SymbolTypeStruct) {
                     // TODO: Constantify all R-Values?
                     Initializers.ValueTypeSpec lValueTypeSpec = new Initializers.ValueTypeSpec(lValueType, null);
                     RValue rValueConstantified = Initializers.constantify(rValue, lValueTypeSpec, getProgram(), assignment.getSource());
                     if(!rValue.equals(rValueConstantified)) {
                        assignment.setrValue2(rValueConstantified);
                        getLog().append("Constantified RValue "+assignment.toString(getProgram(), false));
                     }
                  }

               }
            }
         }
      }
      return false;
   }


}

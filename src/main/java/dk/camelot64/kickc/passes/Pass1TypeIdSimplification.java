package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.InternalError;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.operators.OperatorTypeId;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeInference;
import dk.camelot64.kickc.model.types.SymbolTypeIntegerFixed;
import dk.camelot64.kickc.model.types.SymbolTypeNumberInference;
import dk.camelot64.kickc.model.values.ConstantLiteral;
import dk.camelot64.kickc.model.values.ConstantRef;
import dk.camelot64.kickc.model.values.ConstantValue;
import dk.camelot64.kickc.model.values.RValue;

import java.util.List;

/**
 * Converts typeid() operators to constants
 */
public class Pass1TypeIdSimplification extends Pass1Base {

   public Pass1TypeIdSimplification(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      boolean modified = false;
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               if(Operators.TYPEID.equals(assignment.getOperator())) {
                  RValue rValue = assignment.getrValue2();
                  SymbolType symbolType = SymbolTypeInference.inferType(getScope(), rValue);
                  if(SymbolType.NUMBER.equals(symbolType)) {
                     if(rValue instanceof ConstantValue) {
                        List<SymbolTypeIntegerFixed> fixedTypes = SymbolTypeNumberInference.inferTypes(getScope(), (ConstantLiteral) rValue);
                        throw new InternalError("TODO: Implement typeof(const)!");
                     }
                  } else {
                     getLog().append("Resolving typeid() " + assignment.toString(getProgram(), false));
                     ConstantRef typeIDConstantVar = OperatorTypeId.getTypeIdConstantVar(getScope(), symbolType);
                     assignment.setrValue2(typeIDConstantVar);
                     assignment.setOperator(null);
                     modified = true;
                  }
               }
            }
         }
      }
      return modified;
   }
}

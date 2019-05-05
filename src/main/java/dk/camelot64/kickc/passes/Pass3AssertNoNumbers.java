package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.InternalError;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.statements.StatementConditionalJump;
import dk.camelot64.kickc.model.statements.StatementPhiBlock;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeInference;
import dk.camelot64.kickc.model.values.RValue;

/**
 * Assert that all values with type number have been resolved to fixed size in pass 2.
 */
public class Pass3AssertNoNumbers extends Pass2SsaAssertion {

   public Pass3AssertNoNumbers(Program program) {
      super(program);
   }

   @Override
   public void check() throws AssertionFailed {
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementAssignment) {
               checkValue(((StatementAssignment) statement).getlValue(), statement);
               checkValue(((StatementAssignment) statement).getrValue1(), statement);
               checkValue(((StatementAssignment) statement).getrValue2(), statement);
            } else if(statement instanceof StatementPhiBlock) {
               for(StatementPhiBlock.PhiVariable phiVariable : ((StatementPhiBlock) statement).getPhiVariables()) {
                  for(StatementPhiBlock.PhiRValue value : phiVariable.getValues()) {
                     checkValue(value.getrValue(), statement);
                  }
               }
            } else if(statement instanceof StatementConditionalJump) {
               checkValue(((StatementConditionalJump) statement).getrValue1(), statement);
               checkValue(((StatementConditionalJump) statement).getrValue2(), statement);
            }
         }
      }
   }

   /**
    * Check a value to ensure it is does not have the {@link SymbolType#NUMBER}.
    *
    * @param rValue The value to check
    * @param statement The statement containing the value
    */
   public void checkValue(RValue rValue, Statement statement) {
      if(rValue == null) return;
      SymbolType symbolType = SymbolTypeInference.inferType(getScope(), rValue);
      if(SymbolType.NUMBER.equals(symbolType)) {
         throw new InternalError(
               "Error! Number integer type not resolved to fixed size integer type " +
                     "\n value: " + rValue.toString(getProgram()) +
                     "\n statement: " + statement.toString(getProgram(), false)
               , statement.getSource()
         );
      }
   }
}

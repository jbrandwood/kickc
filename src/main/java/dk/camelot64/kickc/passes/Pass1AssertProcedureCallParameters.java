package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementCall;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.symbols.SymbolVariable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeConversion;
import dk.camelot64.kickc.model.types.SymbolTypeInference;
import dk.camelot64.kickc.model.values.RValue;

import java.util.List;

/**
 * Asserts that all calls have parameters of the types that the procedure expects
 */
public class Pass1AssertProcedureCallParameters extends Pass1Base {

   public Pass1AssertProcedureCallParameters(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementCall) {
               StatementCall call = (StatementCall) statement;
               Procedure procedure = getScope().getProcedure(call.getProcedure());
               List<SymbolVariable> declParameters = procedure.getParameters();
               List<RValue> callParameters = call.getParameters();
               if(callParameters.size()!=declParameters.size()) {
                  throw new CompileError("Wrong number of parameters in call "+call.toString(getProgram(), false)+" expected "+procedure.toString(getProgram()), statement);
               }
               for(int i = 0; i < declParameters.size(); i++) {
                  SymbolVariable declParameter = declParameters.get(i);
                  RValue callParameter = callParameters.get(i);
                  SymbolType callParameterType = SymbolTypeInference.inferType(getScope(), callParameter);
                  SymbolType declParameterType = declParameter.getType();
                  if(!SymbolTypeConversion.assignmentTypeMatch(declParameterType, callParameterType)) {
                     throw new CompileError("Parameters type mismatch in call "+call.toString(getProgram(), false)+" expected "+procedure.toString(getProgram()), statement);
                  }
               }
            }
         }
      }

      return false;
   }


}

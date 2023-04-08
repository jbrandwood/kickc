package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Graph;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementCall;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeConversion;
import dk.camelot64.kickc.model.types.SymbolTypeInference;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.values.ConstantInteger;
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
      for(var block : getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementCall) {
               StatementCall call = (StatementCall) statement;
               Procedure procedure = getProgramScope().getProcedure(call.getProcedure());
               List<Variable> declParameters = procedure.getParameters();
               List<RValue> callParameters = call.getParameters();
               if(callParameters.size()!=declParameters.size()) {
                  throw new CompileError("Wrong number of parameters in call "+call.toString(getProgram(), false)+" expected "+procedure.toString(getProgram()), statement);
               }
               for(int i = 0; i < declParameters.size(); i++) {
                  Variable declParameter = declParameters.get(i);
                  RValue callParameter = callParameters.get(i);
                  SymbolType callParameterType = SymbolTypeInference.inferType(getProgramScope(), callParameter);
                  SymbolType declParameterType = declParameter.getType();

                  if(declParameterType instanceof SymbolTypePointer) {
                     if(callParameter instanceof ConstantInteger && ((ConstantInteger) callParameter).getInteger().equals(0L))
                        // A null-pointer assignment is OK!
                        continue;
                  }
                  if(!SymbolTypeConversion.assignmentTypeMatch(declParameterType, callParameterType)) {
                     throw new CompileError("Parameters type mismatch in call "+call.toString(getProgram(), true, false)+" expected "+procedure.toString(getProgram(), true), statement);
                  }
               }
            }
         }
      }

      return false;
   }


}

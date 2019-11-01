package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramValue;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.symbols.SymbolVariable;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.values.ForwardVariableRef;
import dk.camelot64.kickc.model.values.Value;
import dk.camelot64.kickc.model.values.VariableRef;

/** Asserts that the program does not contain any RValues that are forward-reference or unversioned */
public class Pass2AssertRValues extends Pass2SsaAssertion {

   public Pass2AssertRValues(Program program) {
      super(program);
   }

   @Override
   public void check() throws AssertionFailed {
      ProgramValueIterator.execute(getGraph(), (programValue, currentStmt, stmtIt, currentBlock) -> {
         Value rValue = programValue.get();
         if(rValue instanceof ForwardVariableRef) {
            throw new CompileError("No forward references allowed "+currentStmt.toString(getProgram(), false), currentStmt.getSource());
         }
         if(programValue instanceof ProgramValue.ProgramValueParamValue) {
            // ParamValues are allowed to be unversioned
            return;
         }
         if(rValue instanceof VariableRef) {
            VariableRef variableRef = (VariableRef) rValue;
            SymbolVariable variable = getScope().getVariable(variableRef);
            if(variable.isStoragePhiMaster()) {
               throw new CompileError("No unversioned variable references allowed "+currentStmt.toString(getProgram(), false), currentStmt.getSource());
            }
         }
      });
   }

}

package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.values.ForwardVariableRef;
import dk.camelot64.kickc.model.values.RValue;
import dk.camelot64.kickc.model.values.VariableRef;

/** Asserts that the program does not contain any RValues that are forward-reference or unversioned */
public class Pass2AssertRValues extends Pass2SsaAssertion {

   public Pass2AssertRValues(Program program) {
      super(program);
   }

   @Override
   public void check() throws AssertionFailed {
      ValueReplacer.executeAll(getGraph(), (replaceable, currentStmt, stmtIt, currentBlock) -> {
         RValue rValue = replaceable.get();
         if(rValue instanceof ForwardVariableRef) {
            throw new CompileError("No forward references allowed "+currentStmt.toString(getProgram(), false), currentStmt.getSource());
         }
         if(rValue instanceof VariableRef) {
            VariableRef variableRef = (VariableRef) rValue;
            if(!variableRef.isIntermediate() && !variableRef.isVersion()) {
               throw new CompileError("No unversioned variable references allowed "+currentStmt.toString(getProgram(), false), currentStmt.getSource());
            }
         }
      });
   }

}

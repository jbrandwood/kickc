package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ValueReplacer;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.values.ForwardVariableRef;
import dk.camelot64.kickc.model.values.RValue;

/** Pass that resolves all forward variable references - and fails if they cannot be resolved*/
public class Pass1ResolveForwardReferences extends Pass1Base {

   public Pass1ResolveForwardReferences(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      ValueReplacer.executeAll(getGraph(), (replaceable, currentStmt, stmtIt, currentBlock) -> {
         RValue rValue = replaceable.get();
         if(rValue instanceof ForwardVariableRef) {
            String varName = ((ForwardVariableRef) rValue).getName();
            Scope currentScope = getScope().getScope(currentBlock.getScope());
            Variable variable = currentScope.getVariable(varName);
            if(variable!=null) {
               getLog().append("Resolved forward reference " + varName+" to "+variable.toString(getProgram()));
               replaceable.set(variable.getRef());
            }  else {
               getLog().append("ERROR! Unknown variable " + varName);
               throw new CompileError("ERROR! Unknown variable " + varName, currentStmt.getSource());
            }
         }
      });
      return false;
   }

}

package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.symbols.Symbol;
import dk.camelot64.kickc.model.values.ForwardVariableRef;
import dk.camelot64.kickc.model.values.Value;

/** Pass that resolves all forward variable references - and fails if they cannot be resolved*/
public class Pass1ResolveForwardReferences extends Pass1Base {

   public Pass1ResolveForwardReferences(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      ProgramValueIterator.execute(getGraph(), (programValue, currentStmt, stmtIt, currentBlock) -> {
         Value rValue = programValue.get();
         if(rValue instanceof ForwardVariableRef) {
            String varName = ((ForwardVariableRef) rValue).getName();
            Scope currentScope = getProgramScope().getScope(currentBlock.getScope());
            Symbol symbol = currentScope.findSymbol(varName);
            if(symbol!=null) {
               getLog().append("Resolved forward reference " + varName+" to "+symbol.toString(getProgram()));
               programValue.set(symbol.getRef());
            }  else {
               getLog().append("ERROR! Unknown variable " + varName);
               throw new CompileError("Unknown variable " + varName, currentStmt.getSource());
            }
         }
      });
      return false;
   }

}

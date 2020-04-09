package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementCall;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.symbols.Scope;

/**
 * Updates procedure calls to point to the actual procedure called.
 */
public class Pass1Procedures extends Pass2SsaOptimization {

   public Pass1Procedures(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementCall) {
               StatementCall call = (StatementCall) statement;
               String procedureName = call.getProcedureName();
               Procedure procedure = getScope().getLocalProcedure(procedureName);
               if(procedure == null) {
                  throw new CompileError("Called procedure not found. " + call.toString(getProgram(), false), statement.getSource());
               }
               call.setProcedure(procedure.getRef());
               if(procedure.getParameters().size() != call.getParameters().size()) {
                  throw new CompileError("Wrong number of parameters in call. Expected " + procedure.getParameters().size() + ". " + statement.toString(), statement.getSource());
               }
            }

         }
      }
      return false;
   }

}

package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementCall;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.symbols.Symbol;

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
               Scope localScope = (Scope) getProgramScope().getSymbol(block.getScope());
               final Symbol procedureSymbol = localScope.findSymbol(procedureName);
               if(procedureSymbol == null)
                  throw new CompileError("Called procedure not found. " + procedureName, statement.getSource());
               if(!(procedureSymbol instanceof Procedure))
                  throw new CompileError("Called symbol is not a procedure. " + procedureSymbol.toString(), statement.getSource());
               Procedure procedure = (Procedure) procedureSymbol;
               call.setProcedure(procedure.getRef());
               if(procedure.isVariableLengthParameterList() && procedure.getParameters().size() > call.getParameters().size()) {
                  throw new CompileError("Wrong number of parameters in call. Expected " + procedure.getParameters().size() + " or more. " + statement.toString(), statement.getSource());
               } else if(!procedure.isVariableLengthParameterList() && procedure.getParameters().size() != call.getParameters().size()) {
                  throw new CompileError("Wrong number of parameters in call. Expected " + procedure.getParameters().size() + ". " + statement.toString(), statement.getSource());
               }
            }
         }
      }
      return false;
   }

}

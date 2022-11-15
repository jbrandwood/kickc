package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.InternalError;
import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.iterator.ProgramValue;
import dk.camelot64.kickc.model.iterator.ProgramValueHandler;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.symbols.*;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.*;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.ListIterator;

/** Pass that modifies a control flow graph to far call any procedures declared as far */
public class Pass1ProcedureFar extends Pass1Base {

   public Pass1ProcedureFar(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      List<ControlFlowBlock> allBlocks = getGraph().getAllBlocks();
      ListIterator<ControlFlowBlock> blocksIt = allBlocks.listIterator();
      while(blocksIt.hasNext()) {
         ControlFlowBlock block = blocksIt.next();
         List<Statement> blockStatements = block.getStatements();
         ListIterator<Statement> statementsIt = blockStatements.listIterator();
         while(statementsIt.hasNext()) {
            Statement statement = statementsIt.next();
            if(statement instanceof StatementCall) {
               StatementCall call = (StatementCall) statement;
               ProcedureRef procedureRef = call.getProcedure();
               Procedure procedure = getScope().getProcedure(procedureRef);
               if(procedure.isDeclaredFar()) {
                  if(procedure.getInterruptType()!=null) {
                     throw new CompileError("Error! Interrupts cannot be far called. "+procedure.getRef().toString());
                  }
                  farProcedureCall(call, procedure, statementsIt, block, blocksIt);
                  // Exit and restart
                  return false;
               }
            }
         }
      }
      return false;
   }

   /**
    * Inline a specific call to a procedure.
    *
    * @param call The call to the far procedure
    * @param procedure The procedure being called
    * @param statementsIt The statement iterator pointing to the call statement
    * @param block The block containing the call
    * @param blocksIt The block iterator pointing to the block containing the call
    */
   private void farProcedureCall(StatementCall call, Procedure procedure, ListIterator<Statement> statementsIt, ControlFlowBlock block, ListIterator<ControlFlowBlock> blocksIt) {
      Scope callScope = getScope().getScope(block.getScope());
      // Here we add to the call the properties to build a far call depending on the platform.
      // The all properties have been entered in the __far() directive in the source code.
      // These properties are then used in pass4 of the compiler, to build the platform dependent fragment to execute the far call.

      call.setBankFar(procedure.getBankFar());
      getLog().append("Far call " + call.toString(getProgram(), false));
   }
}

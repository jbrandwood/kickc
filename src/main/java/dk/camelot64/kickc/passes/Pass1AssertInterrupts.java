package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementCall;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.values.ProcedureRef;

/** Asserts that interrupts are never called and are not declared inline */
public class Pass1AssertInterrupts extends Pass1Base {

   public Pass1AssertInterrupts(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementCall) {
               ProcedureRef procedureRef = ((StatementCall) statement).getProcedure();
               Procedure procedure = getScope().getProcedure(procedureRef);
               if(procedure.isDeclaredInterrupt()) {
                  throw new CompileError("Error! Interrupts cannot be called.", statement.getSource());
               }
            }
         }
         for(Procedure procedure : getScope().getAllProcedures(true)) {
            if(procedure.isDeclaredInline() && procedure.isDeclaredInterrupt()) {
               throw new CompileError("Error! Interrupts cannot be inlined. " + procedure.toString());
            }
         }
      }
      return false;
   }


}

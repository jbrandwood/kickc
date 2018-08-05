package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementCall;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.types.SymbolType;
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
            if(procedure.isDeclaredInterrupt()) {
               if(procedure.isDeclaredInline()) {
                  throw new CompileError("Error! Interrupts cannot be inlined. " + procedure.toString());
               }
               if(procedure.getParameters().size()>0) {
                  throw new CompileError("Error! Interrupts cannot have parameters. " + procedure.toString());
               }
               if(!SymbolType.VOID.equals(procedure.getReturnType())) {
                  throw new CompileError("Error! Interrupts cannot return anything. " + procedure.toString());
               }
            }
         }
      }
      return false;
   }


}

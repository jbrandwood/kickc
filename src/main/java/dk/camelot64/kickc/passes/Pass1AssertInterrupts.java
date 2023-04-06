package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementCalling;
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
            if(statement instanceof StatementCalling) {
               ProcedureRef procedureRef = ((StatementCalling) statement).getProcedure();
               Procedure procedure = getProgramScope().getProcedure(procedureRef);
               if(procedure.getInterruptType()!=null) {
                  throw new CompileError("Interrupts cannot be called.", statement.getSource());
               }
            }
         }
         for(Procedure procedure : getProgramScope().getAllProcedures(true)) {
            if(procedure.getInterruptType()!=null) {
               if(procedure.isDeclaredInline()) {
                  throw new CompileError("Interrupts cannot be inlined. " + procedure.toString());
               }
               if(procedure.getParameters().size()>0) {
                  throw new CompileError("Interrupts cannot have parameters. " + procedure.toString());
               }
               if(!SymbolType.VOID.equals(procedure.getReturnType())) {
                  throw new CompileError("Interrupts cannot return anything. " + procedure.toString());
               }
            }
         }
      }
      return false;
   }


}

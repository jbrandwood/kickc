package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.symbols.*;
import dk.camelot64.kickc.model.values.LabelRef;
import dk.camelot64.kickc.model.values.ScopeRef;
import dk.camelot64.kickc.model.values.SymbolRef;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

/** Pass that generates a control flow graph for the program */
public class Pass1GenerateControlFlowGraph extends Pass1Base {


   public Pass1GenerateControlFlowGraph(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      ProgramScope programScope = getProgramScope();
      final Collection<Procedure> allProcedures = getProgram().getScope().getAllProcedures(true);
      for(Procedure procedure : allProcedures) {
         if(procedure.isDeclaredIntrinsic())
            continue;
         final ProcedureCompilation procedureCompilation = getProgram().getProcedureCompilation(procedure.getRef());
         final StatementSequence sequence = procedureCompilation.getStatementSequence();
         if(sequence.getStatements().size()==0)
            // Empty procedures should not produce any blocks
            continue;

         List<ControlFlowBlock> blocks =  new ArrayList<>();

         ControlFlowBlock currentBlock = null;
         ControlFlowBlock procBlock = getOrCreateBlock(procedure.getLabel().getRef(), procedure.getRef(), blocks);
         currentBlock = procBlock;
         for(Statement statement : sequence.getStatements()) {
            Symbol currentBlockLabel = getProgram().getScope().getSymbol(currentBlock.getLabel());
            Scope currentBlockScope;
            if(currentBlockLabel instanceof Procedure) {
               currentBlockScope = (Scope) currentBlockLabel;
            } else {
               currentBlockScope = currentBlockLabel.getScope();
            }
            if(statement instanceof StatementProcedureBegin) {
               // Do nothing
            } else if(statement instanceof StatementProcedureEnd) {
               // Procedure strategy implemented is currently variable-based transfer of parameters/return values
               currentBlock.setDefaultSuccessor(new Label(SymbolRef.PROCEXIT_BLOCK_NAME, programScope, false).getRef());
            } else if(statement instanceof StatementLabel) {
               StatementLabel statementLabel = (StatementLabel) statement;
               ControlFlowBlock nextBlock = getOrCreateBlock(statementLabel.getLabel(), currentBlock.getScope(), blocks);
               nextBlock.setComments(statementLabel.getComments());
               currentBlock.setDefaultSuccessor(nextBlock.getLabel());
               currentBlock = nextBlock;
            } else if(statement instanceof StatementJump) {
               StatementJump statementJump = (StatementJump) statement;
               ControlFlowBlock jmpBlock = getOrCreateBlock(statementJump.getDestination(), currentBlock.getScope(), blocks);
               currentBlock.setDefaultSuccessor(jmpBlock.getLabel());
               ControlFlowBlock nextBlock = getOrCreateBlock(currentBlockScope.addLabelIntermediate().getRef(), currentBlock.getScope(), blocks);
               currentBlock = nextBlock;
            } else if(statement instanceof StatementConditionalJump) {
               currentBlock.addStatement(statement);
               StatementConditionalJump statementConditionalJump = (StatementConditionalJump) statement;
               ControlFlowBlock jmpBlock = getOrCreateBlock(statementConditionalJump.getDestination(), currentBlock.getScope(), blocks);
               ControlFlowBlock nextBlock = getOrCreateBlock(currentBlockScope.addLabelIntermediate().getRef(), currentBlock.getScope(), blocks);
               currentBlock.setDefaultSuccessor(nextBlock.getLabel());
               currentBlock.setConditionalSuccessor(jmpBlock.getLabel());
               currentBlock = nextBlock;
            } else if(statement instanceof StatementReturn) {
               // Procedure strategy implemented is currently variable-based transfer of parameters/return values
               StatementReturn aReturn = (StatementReturn) statement;
               currentBlock.addStatement(aReturn);
            } else {
               currentBlock.addStatement(statement);
            }
         }
         ControlFlowGraph controlFlowGraph = new ControlFlowGraph(blocks);
         procedureCompilation.setGraph(controlFlowGraph);

      }
      return false;
   }

   private ControlFlowBlock getOrCreateBlock(LabelRef label, ScopeRef scope, List<ControlFlowBlock> blocks) {
      for(ControlFlowBlock block : blocks) {
         if(block.getLabel().equals(label)) {
            return block;
         }
      }
      ControlFlowBlock block = new ControlFlowBlock(label, scope);
      blocks.add(block);
      return block;
   }


}

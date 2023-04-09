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

         List<Graph.Block> blocks =  new ArrayList<>();

         Graph.Block currentBlock;
         Graph.Block procBlock = getOrCreateBlock(procedure.getLabel().getRef(), procedure.getRef(), blocks);
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
            } else if(statement instanceof StatementLabel statementLabel) {
               Graph.Block nextBlock = getOrCreateBlock(statementLabel.getLabel(), currentBlock.getScope(), blocks);
               nextBlock.setComments(statementLabel.getComments());
               currentBlock.setDefaultSuccessor(nextBlock.getLabel());
               currentBlock = nextBlock;
            } else if(statement instanceof StatementJump statementJump) {
               Graph.Block jmpBlock = getOrCreateBlock(statementJump.getDestination(), currentBlock.getScope(), blocks);
               currentBlock.setDefaultSuccessor(jmpBlock.getLabel());
               Graph.Block nextBlock = getOrCreateBlock(currentBlockScope.addLabelIntermediate().getRef(), currentBlock.getScope(), blocks);
               currentBlock = nextBlock;
            } else if(statement instanceof StatementConditionalJump statementConditionalJump) {
               currentBlock.addStatement(statement);
               Graph.Block jmpBlock = getOrCreateBlock(statementConditionalJump.getDestination(), currentBlock.getScope(), blocks);
               Graph.Block nextBlock = getOrCreateBlock(currentBlockScope.addLabelIntermediate().getRef(), currentBlock.getScope(), blocks);
               currentBlock.setDefaultSuccessor(nextBlock.getLabel());
               currentBlock.setConditionalSuccessor(jmpBlock.getLabel());
               currentBlock = nextBlock;
            } else if(statement instanceof StatementReturn aReturn) {
               // Procedure strategy implemented is currently variable-based transfer of parameters/return values
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

   private Graph.Block getOrCreateBlock(LabelRef label, ScopeRef scope, List<Graph.Block> blocks) {
      for(var block : blocks) {
         if(block.getLabel().equals(label)) {
            return block;
         }
      }
      Graph.Block block = new ControlFlowBlock(label, scope);
      blocks.add(block);
      return block;
   }


}

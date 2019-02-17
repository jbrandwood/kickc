package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.symbols.*;
import dk.camelot64.kickc.model.values.LabelRef;
import dk.camelot64.kickc.model.values.ProcedureRef;
import dk.camelot64.kickc.model.values.ScopeRef;
import dk.camelot64.kickc.model.values.SymbolRef;
import org.antlr.v4.runtime.RuleContext;

import java.util.ArrayList;
import java.util.List;
import java.util.Stack;

/** Pass that generates a control flow graph for the program */
public class Pass1GenerateControlFlowGraph extends Pass1Base {

   private List<ControlFlowBlock> blocks;

   public Pass1GenerateControlFlowGraph(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      this.blocks = new ArrayList<>();
      ProgramScope scope = getScope();
      StatementSequence sequence = getProgram().getStatementSequence();
      ControlFlowBlock firstBlock = getOrCreateBlock(scope.addLabel(SymbolRef.BEGIN_BLOCK_NAME).getRef(), ScopeRef.ROOT);
      Stack<ControlFlowBlock> blockStack = new Stack<>();
      blockStack.push(firstBlock);
      sequence.addStatement(new StatementLabel(scope.addLabel(SymbolRef.END_BLOCK_NAME).getRef(), new StatementSource(RuleContext.EMPTY), Comment.NO_COMMENTS));
      for(Statement statement : sequence.getStatements()) {
         ControlFlowBlock currentBlock = blockStack.peek();
         Symbol currentBlockLabel = scope.getSymbol(currentBlock.getLabel());
         Scope currentBlockScope;
         if(currentBlockLabel instanceof Procedure) {
            currentBlockScope = (Scope) currentBlockLabel;
         } else {
            currentBlockScope = currentBlockLabel.getScope();
         }
         if(statement instanceof StatementLabel) {
            StatementLabel statementLabel = (StatementLabel) statement;
            ControlFlowBlock nextBlock = getOrCreateBlock(statementLabel.getLabel(), currentBlock.getScope());
            nextBlock.setComments(statementLabel.getComments());
            currentBlock.setDefaultSuccessor(nextBlock.getLabel());
            blockStack.pop();
            blockStack.push(nextBlock);
         } else if(statement instanceof StatementJump) {
            StatementJump statementJump = (StatementJump) statement;
            ControlFlowBlock jmpBlock = getOrCreateBlock(statementJump.getDestination(), currentBlock.getScope());
            currentBlock.setDefaultSuccessor(jmpBlock.getLabel());
            ControlFlowBlock nextBlock = getOrCreateBlock(currentBlockScope.addLabelIntermediate().getRef(), currentBlock.getScope());
            blockStack.pop();
            blockStack.push(nextBlock);
         } else if(statement instanceof StatementConditionalJump) {
            currentBlock.addStatement(statement);
            StatementConditionalJump statementConditionalJump = (StatementConditionalJump) statement;
            ControlFlowBlock jmpBlock = getOrCreateBlock(statementConditionalJump.getDestination(), currentBlock.getScope());
            ControlFlowBlock nextBlock = getOrCreateBlock(currentBlockScope.addLabelIntermediate().getRef(), currentBlock.getScope());
            currentBlock.setDefaultSuccessor(nextBlock.getLabel());
            currentBlock.setConditionalSuccessor(jmpBlock.getLabel());
            blockStack.pop();
            blockStack.push(nextBlock);
         } else if(statement instanceof StatementProcedureBegin) {
            // Procedure strategy implemented is currently variable-based transfer of parameters/return values
            StatementProcedureBegin procedureBegin = (StatementProcedureBegin) statement;
            procedureBegin.setStrategy(StatementProcedureBegin.Strategy.PASS_BY_REGISTER);
            ProcedureRef procedureRef = procedureBegin.getProcedure();
            LabelRef procedureLabelRef = procedureRef.getLabelRef();
            ControlFlowBlock procBlock = getOrCreateBlock(procedureLabelRef, procedureRef);
            blockStack.push(procBlock);
         } else if(statement instanceof StatementProcedureEnd) {
            // Procedure strategy implemented is currently variable-based transfer of parameters/return values
            currentBlock.setDefaultSuccessor(new Label(SymbolRef.PROCEXIT_BLOCK_NAME, scope, false).getRef());
            ControlFlowBlock nextBlock = getOrCreateBlock(scope.addLabelIntermediate().getRef(), ScopeRef.ROOT);
            blockStack.pop();
            ControlFlowBlock prevBlock = blockStack.pop();
            prevBlock.setDefaultSuccessor(nextBlock.getLabel());
            blockStack.push(nextBlock);
         } else if(statement instanceof StatementReturn) {
            // Procedure strategy implemented is currently variable-based transfer of parameters/return values
            StatementReturn aReturn = (StatementReturn) statement;
            currentBlock.addStatement(aReturn);
            // TODO: Make all returns exit through the same exit-block!
         } else {
            currentBlock.addStatement(statement);
         }
      }
      ControlFlowGraph controlFlowGraph = new ControlFlowGraph(blocks, firstBlock.getLabel());
      getProgram().setGraph(controlFlowGraph);
      return false;
   }

   private ControlFlowBlock getOrCreateBlock(LabelRef label, ScopeRef scope) {
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

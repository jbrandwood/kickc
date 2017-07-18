package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.icl.*;

import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Stack;

/** Pass that generates a control flow graph for the program */
public class Pass1GenerateControlFlowGraph {

   public static final String BEGIN_BLOCK_NAME = "@BEGIN";
   public static final String END_BLOCK_NAME = "@END";
   private Scope scope;
   private Map<Symbol, ControlFlowBlock> blocks;
   private ControlFlowBlock firstBlock;

   public Pass1GenerateControlFlowGraph(Scope scope) {
      this.scope = scope;
      this.blocks = new LinkedHashMap<>();
   }

   public ControlFlowGraph generate(StatementSequence sequence) {
      this.firstBlock = getOrCreateBlock(scope.addLabel(BEGIN_BLOCK_NAME));
      Stack<ControlFlowBlock> blockStack = new Stack<>();
      blockStack.push(firstBlock);
      sequence.addStatement(new StatementLabel(scope.addLabel(END_BLOCK_NAME)));
      for (Statement statement : sequence.getStatements()) {
         ControlFlowBlock currentBlock = blockStack.peek();
         if(statement instanceof StatementLabel) {
            StatementLabel statementLabel = (StatementLabel) statement;
            ControlFlowBlock nextBlock = getOrCreateBlock(statementLabel.getLabel());
            currentBlock.setDefaultSuccessor(nextBlock.getLabel());
            blockStack.pop();
            blockStack.push(nextBlock);
         }  else if(statement instanceof StatementJump) {
            StatementJump statementJump = (StatementJump) statement;
            ControlFlowBlock jmpBlock = getOrCreateBlock(statementJump.getDestination());
            currentBlock.setDefaultSuccessor(jmpBlock.getLabel());
            ControlFlowBlock nextBlock = getOrCreateBlock(scope.addLabelIntermediate());
            blockStack.pop();
            blockStack.push(nextBlock);
         }  else if(statement instanceof StatementConditionalJump) {
            currentBlock.addStatement(statement);
            StatementConditionalJump statementConditionalJump = (StatementConditionalJump) statement;
            ControlFlowBlock jmpBlock = getOrCreateBlock(statementConditionalJump.getDestination());
            ControlFlowBlock nextBlock = getOrCreateBlock(scope.addLabelIntermediate());
            currentBlock.setDefaultSuccessor(nextBlock.getLabel());
            currentBlock.setConditionalSuccessor(jmpBlock.getLabel());
            blockStack.pop();
            blockStack.push(nextBlock);
         }  else if(statement instanceof StatementProcedureBegin) {
            // Procedure strategy implemented is currently variable-based transfer of parameters/return values
            StatementProcedureBegin procedureBegin = (StatementProcedureBegin) statement;
            procedureBegin.setStrategy(StatementProcedureBegin.Strategy.PASS_BY_REGISTER);
            Label procedureLabel = procedureBegin.getProcedure().getLabel();
            ControlFlowBlock procBlock = getOrCreateBlock(procedureLabel);
            blockStack.push(procBlock);
         }  else if(statement instanceof StatementProcedureEnd) {
            // Procedure strategy implemented is currently variable-based transfer of parameters/return values
            currentBlock.setDefaultSuccessor(new Label("@RETURN", scope, false));
            ControlFlowBlock nextBlock = getOrCreateBlock(scope.addLabelIntermediate());
            blockStack.pop();
            ControlFlowBlock prevBlock = blockStack.pop();
            prevBlock.setDefaultSuccessor(nextBlock.getLabel());
            blockStack.push(nextBlock);
         }  else if(statement instanceof StatementReturn) {
            // Procedure strategy implemented is currently variable-based transfer of parameters/return values
            StatementReturn aReturn = (StatementReturn) statement;
            currentBlock.addStatement(aReturn);
            // TODO: Make all returns exit through the same exit-block!
         } else {
            currentBlock.addStatement(statement);
         }
      }

      return new ControlFlowGraph(blocks, firstBlock);
   }

   private ControlFlowBlock getOrCreateBlock(Label label) {
      ControlFlowBlock block = blocks.get(label);
      if(block==null) {
         block = new ControlFlowBlock(label);
         blocks.put(block.getLabel(), block);
      }
      return block;
   }


}

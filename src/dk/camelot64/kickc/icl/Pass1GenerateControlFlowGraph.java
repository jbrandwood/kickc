package dk.camelot64.kickc.icl;

import java.util.LinkedHashMap;
import java.util.Map;

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
      ControlFlowBlock currentBlock = this.firstBlock;
      sequence.addStatement(new StatementLabel(scope.addLabel(END_BLOCK_NAME)));
      for (Statement statement : sequence.getStatements()) {
         if(statement instanceof StatementLabel) {
            StatementLabel statementLabel = (StatementLabel) statement;
            ControlFlowBlock nextBlock = getOrCreateBlock(statementLabel.getLabel());
            currentBlock.setDefaultSuccessor(nextBlock);
            nextBlock.addPredecessor(currentBlock);
            currentBlock = nextBlock;
         }  else if(statement instanceof StatementJump) {
            StatementJump statementJump = (StatementJump) statement;
            ControlFlowBlock jmpBlock = getOrCreateBlock(statementJump.getDestination());
            currentBlock.setDefaultSuccessor(jmpBlock);
            jmpBlock.addPredecessor(currentBlock);
            ControlFlowBlock nextBlock = getOrCreateBlock(scope.addLabelIntermediate());
            currentBlock = nextBlock;
         }  else if(statement instanceof StatementConditionalJump) {
            currentBlock.addStatement(statement);
            StatementConditionalJump statementConditionalJump = (StatementConditionalJump) statement;
            ControlFlowBlock jmpBlock = getOrCreateBlock(statementConditionalJump.getDestination());
            ControlFlowBlock nextBlock = getOrCreateBlock(scope.addLabelIntermediate());
            currentBlock.setDefaultSuccessor(nextBlock);
            currentBlock.setConditionalSuccessor(jmpBlock);
            nextBlock.addPredecessor(currentBlock);
            jmpBlock.addPredecessor(currentBlock);
            currentBlock = nextBlock;
         }  else {
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

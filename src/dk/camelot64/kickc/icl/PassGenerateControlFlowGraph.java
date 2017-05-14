package dk.camelot64.kickc.icl;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/** Pass that generates a control flow graph for the program */
public class PassGenerateControlFlowGraph {

   public static final String FIRST_BLOCK_NAME = "@0";
   private SymbolTable symbolTable;
   private Map<Symbol, ControlFlowBlock> blocks;
   private ControlFlowBlock firstBlock;

   public PassGenerateControlFlowGraph(SymbolTable symbolTable) {
      this.symbolTable = symbolTable;
      this.blocks = new LinkedHashMap<>();
   }

   public ControlFlowGraph generate(StatementSequence sequence) {
      this.firstBlock = getOrCreateBlock(symbolTable.newNamedJumpLabel(FIRST_BLOCK_NAME));
      ControlFlowBlock currentBlock = this.firstBlock;
      for (Statement statement : sequence.getStatements()) {
         if(statement instanceof StatementJumpTarget) {
            StatementJumpTarget statementJumpTarget = (StatementJumpTarget) statement;
            ControlFlowBlock nextBlock = getOrCreateBlock(statementJumpTarget.getLabel());
            currentBlock.setDefaultSuccessor(nextBlock);
            nextBlock.addPredecessor(currentBlock);
            currentBlock = nextBlock;
         }  else if(statement instanceof StatementJump) {
            StatementJump statementJump = (StatementJump) statement;
            ControlFlowBlock jmpBlock = getOrCreateBlock(statementJump.getDestination());
            currentBlock.setDefaultSuccessor(jmpBlock);
            jmpBlock.addPredecessor(currentBlock);
            ControlFlowBlock nextBlock = getOrCreateBlock(symbolTable.newIntermediateJumpLabel());
            currentBlock = nextBlock;
         }  else if(statement instanceof StatementConditionalJump) {
            currentBlock.addStatement(statement);
            StatementConditionalJump statementConditionalJump = (StatementConditionalJump) statement;
            ControlFlowBlock jmpBlock = getOrCreateBlock(statementConditionalJump.getDestination());
            ControlFlowBlock nextBlock = getOrCreateBlock(symbolTable.newIntermediateJumpLabel());
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

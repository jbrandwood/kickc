package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.ControlFlowGraph;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementCall;
import dk.camelot64.kickc.model.values.ProcedureRef;
import dk.camelot64.kickc.model.values.SymbolRef;

import java.util.Deque;
import java.util.Iterator;
import java.util.LinkedList;

/** Asserts that the program has no recursive calls */
public class Pass1AssertNoRecursion extends Pass1Base {

   public Pass1AssertNoRecursion(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      ControlFlowBlock firstBlock = getGraph().getFirstBlock();
      Deque<ControlFlowBlock> path = new LinkedList<>();
      assertNoRecursion(firstBlock, path);
      return false;
   }

   /**
    * Asserts that no methods perform recursive calls
    * @param block The block to check
    * @param path The call-path taken to the block
    */
   private void assertNoRecursion(ControlFlowBlock block, Deque<ControlFlowBlock> path) {
      // Detect recursion
      if(path.contains(block)) {
         StringBuffer msg = new StringBuffer();
         Iterator<ControlFlowBlock> pathIt = path.descendingIterator();
         while(pathIt.hasNext()) {
            ControlFlowBlock pathBlock = pathIt.next();
            msg.append(pathBlock.getLabel()).append(" > ");
         }
         msg.append(block.getLabel());
         throw new CompileError("ERROR! Recursion not allowed! "+msg);
      }
      path.push(block);
      // Follow all calls
      for(Statement statement : block.getStatements()) {
         if(statement instanceof StatementCall) {
            ProcedureRef procedureRef = ((StatementCall) statement).getProcedure();
            ControlFlowBlock procedureBlock = getGraph().getBlock(procedureRef.getLabelRef());
            assertNoRecursion(procedureBlock, path);
         }
      }
      // Follow successors
      if(block.getConditionalSuccessor()!=null && !block.getConditionalSuccessor().isProcExit()) {
         ControlFlowBlock conditionalSuccessor = getGraph().getConditionalSuccessor(block);
         if(!path.contains(conditionalSuccessor)) {
            assertNoRecursion(conditionalSuccessor, path);
         }
      }
      if(block.getDefaultSuccessor()!=null && !block.getDefaultSuccessor().isProcExit()) {
         ControlFlowBlock defaultSuccessor = getGraph().getDefaultSuccessor(block);
         if(!path.contains(defaultSuccessor)) {
            assertNoRecursion(defaultSuccessor, path);
         }
      }
      path.pop();
   }


}

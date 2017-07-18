package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.icl.ControlFlowBlock;
import dk.camelot64.kickc.icl.ControlFlowGraph;
import dk.camelot64.kickc.icl.Scope;

import java.util.ArrayList;
import java.util.List;
import java.util.Stack;

/** Plan the optimal sequence for the blocks of the control flow graph */
public class Pass3BlockSequencePlanner {

   private ControlFlowGraph controlFlowGraph;
   private Scope programScope;

   public Pass3BlockSequencePlanner(ControlFlowGraph controlFlowGraph, Scope programScope) {
      this.controlFlowGraph = controlFlowGraph;
      this.programScope = programScope;
   }

   public void plan() {
      Stack<ControlFlowBlock> todo = new Stack<>();
      ControlFlowBlock mainBlock = controlFlowGraph.getMainBlock();
      if (mainBlock != null) {
         todo.push(mainBlock);
      }
      todo.push(controlFlowGraph.getFirstBlock());
      List<ControlFlowBlock> sequence = new ArrayList<>();
      while(!todo.empty()){
         ControlFlowBlock block = todo.pop();
         if(block==null) {
            break;
         }
         if(sequence.contains(block)) {
            // already handled - move on
            continue;
         }
         sequence.add(block);
         if(block.getCallSuccessor()!=null) {
            todo.push(controlFlowGraph.getCallSuccessor(block));
         }
         if(block.getConditionalSuccessor()!=null) {
            todo.push(controlFlowGraph.getConditionalSuccessor(block));
         }
         if(controlFlowGraph.getDefaultSuccessor(block)!=null) {
            todo.push(controlFlowGraph.getDefaultSuccessor(block));
         }
      }
      controlFlowGraph.setBlockSequence(sequence);
   }
}

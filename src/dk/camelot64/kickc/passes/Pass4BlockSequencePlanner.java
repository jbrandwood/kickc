package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.icl.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Stack;

/** Plan the optimal sequence for the blocks of the control flow graph */
public class Pass4BlockSequencePlanner {

   private ControlFlowGraph graph;
   private ProgramScope scope;

   public Pass4BlockSequencePlanner(Program program) {
      this.graph = program.getGraph();
      this.scope = program.getScope();
   }

   public void plan() {
      Stack<ControlFlowBlock> todo = new Stack<>();
      ControlFlowBlock mainBlock = graph.getMainBlock();
      if (mainBlock != null) {
         todo.push(mainBlock);
      }
      todo.push(graph.getFirstBlock());
      List<LabelRef> sequence = new ArrayList<>();
      while(!todo.empty()){
         ControlFlowBlock block = todo.pop();
         if(block==null) {
            break;
         }
         if(sequence.contains(block.getLabel())) {
            // already handled - move on
            continue;
         }
         sequence.add(block.getLabel());
         if(block.getCallSuccessor()!=null) {
            todo.push(graph.getCallSuccessor(block));
         }
         if(block.getConditionalSuccessor()!=null) {
            todo.push(graph.getConditionalSuccessor(block));
         }
         if(graph.getDefaultSuccessor(block)!=null) {
            todo.push(graph.getDefaultSuccessor(block));
         }
      }
      graph.setSequence(sequence);
   }
}

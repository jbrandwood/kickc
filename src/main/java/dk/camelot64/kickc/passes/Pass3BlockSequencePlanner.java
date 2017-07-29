package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.icl.*;

import java.util.*;

/** Plan the optimal sequence for the blocks of the control flow graph */
public class Pass3BlockSequencePlanner {

   private ControlFlowGraph graph;
   private ProgramScope scope;
   private CompileLog log;

   public Pass3BlockSequencePlanner(Program program, CompileLog log) {
      this.graph = program.getGraph();
      this.scope = program.getScope();
      this.log = log;
   }

   public void plan() {
      ControlFlowBlock mainBlock = graph.getMainBlock();
      if (mainBlock != null) {
         pushTodo(mainBlock);
      }
      pushTodo(graph.getFirstBlock());
      List<LabelRef> sequence = new ArrayList<>();
      while(hasTodo()){
         ControlFlowBlock block = popTodo();
         if(block==null) {
            break;
         }
         if(sequence.contains(block.getLabel())) {
            // already handled - move on
            continue;
         }
         sequence.add(block.getLabel());
         if(block.getCallSuccessor()!=null) {
            pushTodo(graph.getCallSuccessor(block));
         }
         if(block.getConditionalSuccessor()!=null) {
            pushTodo(graph.getConditionalSuccessor(block));
         }
         if(graph.getDefaultSuccessor(block)!=null) {
            pushTodo(graph.getDefaultSuccessor(block));
         }

      }
      graph.setSequence(sequence);

      StringBuilder entry = new StringBuilder();
      entry.append("Block Sequence Planned ");
      for (LabelRef labelRef : sequence) {
         entry.append(labelRef.getFullName() + " ");

      }
      log.append(entry.toString());
   }


   Deque<ScopeTodo> todoScopes = new ArrayDeque<>();

   void pushTodo(ControlFlowBlock block) {
      LabelRef blockRef = block.getLabel();
      Scope blockScope = this.scope.getSymbol(blockRef).getScope();
      for (ScopeTodo todoScope : todoScopes) {
         if(todoScope.scope.equals(blockScope)) {
            todoScope.addTodo(block);
            return;
         }
      }
      ScopeTodo newScopeTodo = new ScopeTodo(blockScope);
      todoScopes.push(newScopeTodo);
      newScopeTodo.addTodo(block);
   }
   
   boolean hasTodo() {
      return !todoScopes.isEmpty();
   }

   ControlFlowBlock popTodo() {
      ScopeTodo scopeTodo = todoScopes.peek();
      ControlFlowBlock block = scopeTodo.todo.pop();
      if(scopeTodo.todo.isEmpty()) {
         todoScopes.pop();
      }
      return block;
   }

   private static class ScopeTodo {
      
      Scope scope;
      
      Stack<ControlFlowBlock> todo;

      public ScopeTodo(Scope scope) {
         this.scope = scope;
         this.todo = new Stack<>();
      }

      public void addTodo(ControlFlowBlock block) {
         todo.push(block);
      }
   }
   
   
}

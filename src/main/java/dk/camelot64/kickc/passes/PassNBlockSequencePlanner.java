package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.values.LabelRef;

import java.util.*;

/** Plan the optimal sequence for the blocks of the control flow graph */
public class PassNBlockSequencePlanner extends Pass2SsaOptimization {

   Deque<ScopeTodo> todoScopes = new ArrayDeque<>();

   public PassNBlockSequencePlanner(Program program) {
      super(program);
   }

   @Override
   public boolean step() {

      List<ControlFlowBlock> entryPointBlocks = getGraph().getEntryPointBlocks(getProgram());

      for(ControlFlowBlock entryPointBlock : entryPointBlocks) {
         pushTodo(entryPointBlock);
      }

      List<LabelRef> sequence = new ArrayList<>();
      while(hasTodo()) {
         ControlFlowBlock block = popTodo();
         if(block == null) {
            break;
         }
         if(sequence.contains(block.getLabel())) {
            // already handled - move on
            continue;
         }
         sequence.add(block.getLabel());
         if(block.getCallSuccessor() != null) {
            pushTodo(getGraph().getCallSuccessor(block));
         }
         if(block.getConditionalSuccessor() != null) {
            pushTodo(getGraph().getConditionalSuccessor(block));
         }
         if(getGraph().getDefaultSuccessor(block) != null) {
            pushTodo(getGraph().getDefaultSuccessor(block));
         }

      }
      getGraph().setSequence(sequence);

      if(getLog().isVerboseSequencePlan()) {
         StringBuilder entry = new StringBuilder();
         entry.append("Block Sequence Planned ");
         for(LabelRef labelRef : sequence) {
            entry.append(labelRef.getFullName() + " ");

         }
         getLog().append(entry.toString());
      }

      return false;

   }

   void pushTodo(ControlFlowBlock block) {
      LabelRef blockRef = block.getLabel();
      Scope blockScope = getScope().getSymbol(blockRef).getScope();
      for(ScopeTodo todoScope : todoScopes) {
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

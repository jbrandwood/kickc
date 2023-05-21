package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.symbols.Procedure;
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

      List<Graph.Block> entryPointBlocks = getProgram().getEntryPointBlocks();

      for(var entryPointBlock : entryPointBlocks) {
         pushTodo(entryPointBlock);
      }

      List<LabelRef> sequence = new ArrayList<>();
      while(hasTodo()) {
         Graph.Block block = popTodo();
         if(block == null) {
            break;
         }
         if(sequence.contains(block.getLabel())) {
            // already handled - move on
            continue;
         }
         sequence.add(block.getLabel());
         if(block.getCallSuccessor() != null) {
            pushCallTodo(getGraph().getCallSuccessor(block));
         }
         Graph.Block conditionalSuccessor = getGraph().getConditionalSuccessor(block);
         Graph.Block defaultSuccessor = getGraph().getDefaultSuccessor(block);
         if(conditionalSuccessor != null && defaultSuccessor != null) {
            // Both conditional and default successor
            if(conditionalSuccessor.getDefaultSuccessor().equals(defaultSuccessor.getLabel())) {
               // Best sequence is cond->default (resulting in better code locality)
               pushTodo(defaultSuccessor);
               pushTodo(getGraph().getConditionalSuccessor(block));
            } else {
               // Best sequence is default->cond
               pushTodo(getGraph().getConditionalSuccessor(block));
               pushTodo(defaultSuccessor);
            }
         } else if(conditionalSuccessor != null) {
            // Only a conditional successor
            pushTodo(getGraph().getConditionalSuccessor(block));
         } else if(defaultSuccessor != null) {
            // Only a default successor
            pushTodo(defaultSuccessor);
         }

      }
      setSequence(sequence);

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

   public void setSequence(List<LabelRef> sequence) {
      if(sequence.size() != getGraph().getAllBlocks().size()) {
         throw new CompileError("ERROR! Sequence does not contain all blocks from the program. Sequence: " + sequence.size() + " Blocks: " + getGraph().getAllBlocks().size());
      }

      // First re-order the procedureCompilations
      List<ProcedureCompilation> updatedProgramSequence = new ArrayList<>();
      for(LabelRef labelRef : sequence) {
         final Procedure procedure = getProgramScope().getSymbol(labelRef).getContainingProcedure();
         final ProcedureCompilation procedureCompilation = getProgram().getProcedureCompilation(procedure.getRef());
         if(!updatedProgramSequence.contains(procedureCompilation)) {
            updatedProgramSequence.add(procedureCompilation);
         }
      }
      getProgram().setProcedureCompilations(updatedProgramSequence);

      // Now re-order the blocks for each procedure
      for(var procedureCompilation : getProgram().getProcedureCompilations()) {
         final ControlFlowGraph procedureGraph = procedureCompilation.getGraph();
         final List<LabelRef> procedureLabels = procedureGraph.getAllBlocks().stream().map(Graph.Block::getLabel).toList();
         final List<Graph.Block> updatedProcedureSequence = sequence.stream().filter(procedureLabels::contains).map(procedureGraph::getBlock).toList();
         if(updatedProcedureSequence.size() != procedureGraph.getAllBlocks().size()) {
            throw new CompileError("ERROR! Sequence does not contain all blocks for "+procedureCompilation.getProcedureRef()+". Sequence: " + updatedProcedureSequence.size() + " Blocks: " + procedureGraph.getAllBlocks().size());
         }
         procedureCompilation.setGraph(new ControlFlowGraph(updatedProcedureSequence));
      }

   }

   void pushTodo(Graph.Block block) {
      LabelRef blockRef = block.getLabel();
      Scope blockScope = getProgramScope().getSymbol(blockRef).getScope();
      for(ScopeTodo todoScope : todoScopes) {
         if(todoScope.scope.equals(blockScope)) {
            todoScope.pushTodo(block);
            return;
         }
      }
      ScopeTodo newScopeTodo = new ScopeTodo(blockScope);
      todoScopes.push(newScopeTodo);
      newScopeTodo.pushTodo(block);
   }

   void pushCallTodo(Graph.Block block) {
      LabelRef blockRef = block.getLabel();
      Scope blockScope = getProgramScope().getSymbol(blockRef).getScope();
      for(ScopeTodo todoScope : todoScopes) {
         if(todoScope.scope.equals(blockScope)) {
            todoScope.addTodo(block);
            return;
         }
      }
      ScopeTodo newScopeTodo = new ScopeTodo(blockScope);
      ScopeTodo top = null;
      if(todoScopes.size() > 0)
         top = todoScopes.pop();
      todoScopes.push(newScopeTodo);
      newScopeTodo.pushTodo(block);
      if(top != null)
         todoScopes.push(top);
   }


   boolean hasTodo() {
      return !todoScopes.isEmpty();
   }

   Graph.Block popTodo() {
      ScopeTodo scopeTodo = todoScopes.peek();
      Graph.Block block = scopeTodo.todo.pop();
      if(scopeTodo.todo.isEmpty()) {
         todoScopes.pop();
      }
      return block;
   }

   private static class ScopeTodo {

      Scope scope;

      Deque<Graph.Block> todo;

      public ScopeTodo(Scope scope) {
         this.scope = scope;
         this.todo = new LinkedList<>();
      }

      public void pushTodo(Graph.Block block) {
         todo.addFirst(block);
      }

      public void addTodo(Graph.Block block) {
         todo.addLast(block);
      }

   }


}

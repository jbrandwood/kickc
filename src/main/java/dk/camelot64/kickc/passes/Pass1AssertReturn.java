package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;

import java.util.Collection;
import java.util.LinkedHashSet;

/**
 * Asserts that all control flow paths in a method with a defined return value ends at a return statement
 */
public class Pass1AssertReturn extends Pass1Base {

   public Pass1AssertReturn(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      Collection<Procedure> allProcedures = getProgram().getScope().getAllProcedures(true);
      for (Procedure procedure : allProcedures) {
         if (procedure.getReturnType() != null && !SymbolType.VOID.equals(procedure.getReturnType())) {
            LabelRef entryLabel = procedure.getRef().getLabelRef();
            ControlFlowBlock entryBlock = getProgram().getGraph().getBlock(entryLabel);
            assertReturn(entryBlock, new LinkedHashSet<>());
         }
      }
      return false;
   }

   /**
    * Assert that all control flows end at a return statement.
    * Follow the control flow of the graph recursively.
    *
    * @param block   The block to examine
    * @param visited Blocks already visited
    */
   public void assertReturn(ControlFlowBlock block, Collection<LabelRef> visited) {
      if (visited.contains(block.getLabel())) {
         return;
      }
      visited.add(block.getLabel());
      for (Statement statement : block.getStatements()) {
         if (statement instanceof StatementAssignment) {
            StatementAssignment assignment = (StatementAssignment) statement;
            if(assignment.getlValue() instanceof VariableRef && ((VariableRef) assignment.getlValue()).getLocalName().equals("return")) {
               // Happy days - return found!
               return;
            }
         } else if (statement instanceof StatementConditionalJump) {
            StatementConditionalJump cond = (StatementConditionalJump) statement;
            ControlFlowBlock jumpTo = getProgram().getGraph().getBlock(cond.getDestination());
            assertReturn(jumpTo, visited);
         }
      }
      ControlFlowBlock successor = getProgram().getGraph().getBlock(block.getDefaultSuccessor());
      if (successor == null || successor.getLabel().getLocalName().equals(SymbolRef.PROCEXIT_BLOCK_NAME)) {
         throw new CompileError("Error! Method must end with a return statement. "+block.getScope().toString(getProgram()));
      } else {
         assertReturn(successor, visited);
      }
   }

}

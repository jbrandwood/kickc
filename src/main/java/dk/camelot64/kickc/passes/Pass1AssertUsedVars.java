package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;

import java.util.Collection;
import java.util.LinkedHashSet;

/**
 * Checks that all used variables are assigned a value before their use
 */
public class Pass1AssertUsedVars extends Pass1Base {

   public Pass1AssertUsedVars(Program program) {
      super(program);
   }

   @Override
   public boolean executeStep() {

      new Pass3StatementIndices(getProgram()).generateStatementIndices();
      new Pass3VariableReferenceInfos(getProgram()).generateVariableReferenceInfos();
      VariableReferenceInfos referenceInfos = getProgram().getVariableReferenceInfos();

      ControlFlowBlock beginBlock = getProgram().getGraph().getBlock(new LabelRef(SymbolRef.BEGIN_BLOCK_NAME));
      assertUsedVars(beginBlock, referenceInfos, new LinkedHashSet<>(), new LinkedHashSet<>());
      getProgram().setVariableReferenceInfos(null);
      new Pass3StatementIndices(getProgram()).clearStatementIndices();

      return false;
   }


   /**
    * Assert that all used vars have been assigned values before the use.
    * Follow the control flow of the graph recursively.
    * @param block The block to examine
    * @param referenceInfos Information about assigned/used variables in statements
    * @param defined Variables already assigned a value at the point of the first execution of the block
    * @param visited Blocks already visited
    */
   public void assertUsedVars(ControlFlowBlock block, VariableReferenceInfos referenceInfos, Collection<VariableRef> defined, Collection<LabelRef> visited) {
      if(visited.contains(block.getLabel())) {
         return;
      }
      visited.add(block.getLabel());
      for (Statement statement : block.getStatements()) {
         Collection<VariableRef> used =  referenceInfos.getUsed(statement);
         for (VariableRef usedRef : used) {
            if(!defined.contains(usedRef)) {
               throw new CompileError("Error! Variable used before being defined "+usedRef.toString(getProgram())+" in "+statement.toString(getProgram(), false));
            }
         }
         Collection<VariableRef> defd = referenceInfos.getDefined(statement);
         for (VariableRef definedRef : defd) {
            defined.add(definedRef);
         }
         if(statement instanceof StatementCall) {
            StatementCall call = (StatementCall) statement;
            Procedure procedure = getProgram().getScope().getProcedure(call.getProcedure());
            for (String paramName : procedure.getParameterNames()) {
               defined.add(procedure.getVariable(paramName).getRef());
            }
            ControlFlowBlock procedureStart = getProgram().getGraph().getBlock(call.getProcedure().getLabelRef());

            assertUsedVars(procedureStart, referenceInfos, defined, visited);
         } else if(statement instanceof StatementConditionalJump) {
            StatementConditionalJump cond= (StatementConditionalJump) statement;
            ControlFlowBlock jumpTo  = getProgram().getGraph().getBlock(cond.getDestination());
            assertUsedVars(jumpTo, referenceInfos, defined, visited);
         }
      }
      ControlFlowBlock successor  = getProgram().getGraph().getBlock(block.getDefaultSuccessor());
      if(successor!=null) {
         assertUsedVars(successor, referenceInfos, defined, visited);
      }
   }

}

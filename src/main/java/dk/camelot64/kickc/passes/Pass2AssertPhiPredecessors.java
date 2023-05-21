package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Graph;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.StatementPhiBlock;
import dk.camelot64.kickc.model.values.LabelRef;

import java.util.List;
import java.util.stream.Collectors;

/** Asserts that the program does not contain any predecessors in Phi-blocks that are not true predecessors */
public class Pass2AssertPhiPredecessors extends Pass2SsaAssertion {

   public Pass2AssertPhiPredecessors(Program program) {
      super(program);
   }

   @Override
   public void check() throws AssertionFailed {
      for(var block : getGraph().getAllBlocks()) {
         if(block.hasPhiBlock()) {
            StatementPhiBlock phiBlock = block.getPhiBlock();
            List<Graph.Block> phiPredecessors = Pass1GenerateSingleStaticAssignmentForm.getPhiPredecessors(block, getProgram());
            List<LabelRef> predecessors =
                  phiPredecessors.stream().map(Graph.Block::getLabel).toList();
            for(StatementPhiBlock.PhiVariable phiVariable : phiBlock.getPhiVariables()) {
               for(StatementPhiBlock.PhiRValue phiRValue : phiVariable.getValues()) {
                  if(!predecessors.contains(phiRValue.getPredecessor())) {
                     throw new CompileError("INTERNAL ERROR! Block "+block.getLabel()+" phi references non-predecessor block "+phiRValue.getPredecessor()+
                           "\n  "+phiBlock.toString(getProgram(), false));
                  }
               }
            }
         }
      }
   }

}

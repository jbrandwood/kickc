package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.icl.*;

import java.util.Collection;
import java.util.List;

/**
 * Perform PhiLifting to greatly reduce overlapping of alive intervals for variables.
 * PhiLifting introduces a large number of new virtual variables (one for each rvalue in phi-functions).
 * Most of these are eliminated again by the PhiMemCoalesce pass.
 * <p>
 * See http://compilers.cs.ucla.edu/fernando/projects/soc/reports/short_tech.pdf
 */
public class Pass3PhiLifting {

   private final Program program;

   private final CompileLog log;

   public Pass3PhiLifting(Program program, CompileLog log) {
      this.program = program;
      this.log = log;
   }

   public void perform() {
      ControlFlowGraph graph = program.getGraph();
      ProgramScope programScope = program.getScope();
      Collection<ControlFlowBlock> blocks = graph.getAllBlocks();
      for (ControlFlowBlock block : blocks) {
         if (block.hasPhiBlock()) {
            StatementPhiBlock phiBlock = block.getPhiBlock();
            for (StatementPhiBlock.PhiVariable phiVariable : phiBlock.getPhiVariables()) {
               for (StatementPhiBlock.PhiRValue phiRValue : phiVariable.getValues()) {
                  if (!(phiRValue.getrValue() instanceof Constant)) {
                     LabelRef predecessorRef = phiRValue.getPredecessor();
                     ControlFlowBlock predecessorBlock = graph.getBlock(predecessorRef);
                     Symbol predecessorSymbol = programScope.getSymbol(predecessorRef);
                     VariableIntermediate newVar = predecessorSymbol.getScope().addVariableIntermediate();
                     Symbol phiLValue = programScope.getSymbol(phiVariable.getVariable());
                     newVar.setType(phiLValue.getType());
                     newVar.setInferredType(true);
                     List<Statement> predecessorStatements = predecessorBlock.getStatements();
                     Statement lastPredecessorStatement = predecessorStatements.get(predecessorStatements.size() - 1);
                     StatementAssignment newAssignment = new StatementAssignment(newVar, phiRValue.getrValue());
                     if (lastPredecessorStatement instanceof StatementConditionalJump ||  lastPredecessorStatement instanceof StatementCall) {
                        predecessorStatements.add(predecessorStatements.size() - 1, newAssignment);
                     } else {
                        predecessorBlock.addStatement(newAssignment);
                     }
                     phiRValue.setrValue(newVar.getRef());
                  }
               }
            }
         }
      }
   }

}

package dk.camelot64.kickc.icl;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;

/**
 * A visitor that copies a complete control flow graph. contains visitor-methods usable for modifying the copy at any point
 */
public class ControlFlowGraphCopyVisitor extends ControlFlowGraphBaseVisitor<Object> {

   /**
    * The origGraph graph.
    */
   private ControlFlowGraph origGraph;

   /**
    * The copied blocks.
    */
   private LinkedHashMap<Symbol, ControlFlowBlock> copyBlockMap;

   /**
    * The current block being copied.
    */
   private ControlFlowBlock origBlock;

   /**
    * The current block where statements are generated into.
    */
   private ControlFlowBlock copyBlock;

   @Override
   public ControlFlowGraph visitGraph(ControlFlowGraph origGraph) {
      this.origGraph = origGraph;
      // Copy all blocks
      this.copyBlockMap = new LinkedHashMap<>();
      for (ControlFlowBlock origBlock : origGraph.getAllBlocks()) {
         ControlFlowBlock copyBlock = visitBlock(origBlock);
         if (copyBlock != null) {
            copyBlockMap.put(copyBlock.getLabel(), copyBlock);
         }
      }
      ControlFlowBlock copyFirstBlock = copyBlockMap.get(origGraph.getFirstBlock().getLabel());
      ControlFlowGraph copyGraph = new ControlFlowGraph(copyBlockMap, copyFirstBlock);
      return copyGraph;
   }

   @Override
   public ControlFlowBlock visitBlock(ControlFlowBlock origBlock) {
      Label label = origBlock.getLabel();
      ControlFlowBlock copyBlock = new ControlFlowBlock(label);
      this.origBlock = origBlock;
      this.copyBlock = copyBlock;
      // Handle statements
      List<Statement> origBlockStatements = origBlock.getStatements();
      for (Statement origStatement : origBlockStatements) {
         Statement copyStatement = visitStatement(origStatement);
         if (copyStatement != null) {
            this.copyBlock.addStatement(copyStatement);
         }
      }
      // Handle successors
      if (origBlock.getDefaultSuccessor() != null) {
         this.copyBlock.setDefaultSuccessor(origBlock.getDefaultSuccessor());
      }
      if (origBlock.getConditionalSuccessor() != null) {
         this.copyBlock.setConditionalSuccessor(origBlock.getConditionalSuccessor());
      }
      if (origBlock.getCallSuccessor() != null) {
         this.copyBlock.setCallSuccessor(origBlock.getCallSuccessor());
      }
      ControlFlowBlock result = this.copyBlock;
      this.origBlock = null;
      this.copyBlock = null;
      return result;
   }

   /**
    * Adds an extra statement to the current block at the current generated position.
    * The new statement is added beofre the copy currently being generated.
    *
    * @param statement The statement to add
    */
   protected void addStatementToCurrentBlock(Statement statement) {
      this.copyBlock.addStatement(statement);
   }

   /**
    * Splits the current block into two blocks in the generated graph.
    * The new block will have the current block as predecessor and current the block will have the new block as default successor.
    *
    * @param label The label to use for the new block
    * @return The new block.
    */
   protected ControlFlowBlock splitCurrentBlock(Label label) {
      ControlFlowBlock newBlock = new ControlFlowBlock(label);
      this.copyBlock.setDefaultSuccessor(newBlock.getLabel());
      this.copyBlockMap.put(this.copyBlock.getLabel(), this.copyBlock);
      this.copyBlock = newBlock;
      return newBlock;
   }

   /**
    * Get the block currently being generated.
    *
    * @return The current block being generated into
    */
   public ControlFlowBlock getCurrentBlock() {
      return copyBlock;
   }

   @Override
   public Statement visitStatement(Statement statement) {
      return (Statement) super.visitStatement(statement);
   }

   @Override
   public StatementPhi visitPhi(StatementPhi phi) {
      VariableVersion lValue = phi.getLValue();
      StatementPhi copyPhi = new StatementPhi(lValue);
      for (StatementPhi.PreviousSymbol origPreviousVersion : phi.getPreviousVersions()) {
         RValue rValue = origPreviousVersion.getRValue();
         Label block = origPreviousVersion.getBlock();
         copyPhi.addPreviousVersion(block, rValue);
      }
      return copyPhi;
   }

   @Override
   public StatementAssignment visitAssignment(StatementAssignment origAssignment) {
      LValue lValue = origAssignment.getLValue();
      RValue rValue1 = origAssignment.getRValue1();
      Operator operator = origAssignment.getOperator();
      RValue rValue2 = origAssignment.getRValue2();
      return new StatementAssignment(lValue, rValue1, operator, rValue2);
   }

   @Override
   public StatementConditionalJump visitConditionalJump(StatementConditionalJump origConditionalJump) {
      RValue rValue1 = origConditionalJump.getRValue1();
      Operator operator = origConditionalJump.getOperator();
      RValue rValue2 = origConditionalJump.getRValue2();
      Label destination = origConditionalJump.getDestination();
      return new StatementConditionalJump(rValue1, operator, rValue2, destination);
   }

   @Override
   public StatementJump visitJump(StatementJump origJump) {
      Label destination = origJump.getDestination();
      return new StatementJump(destination);
   }

   @Override
   public StatementLabel visitJumpTarget(StatementLabel origJump) {
      Label label = origJump.getLabel();
      return new StatementLabel(label);
   }

   @Override
   public StatementCall visitCall(StatementCall callLValue) {
      LValue lValue = callLValue.getLValue();
      String procedureName = callLValue.getProcedureName();
      List<RValue> parameters = callLValue.getParameters();
      return new StatementCall(lValue, procedureName, parameters);
   }

   @Override
   public StatementProcedureBegin visitProcedureBegin(StatementProcedureBegin origProcedureBegin) {
      return new StatementProcedureBegin(origProcedureBegin.getProcedure());
   }

   @Override
   public StatementProcedureEnd visitProcedureEnd(StatementProcedureEnd origProcedureEnd) {
      return new StatementProcedureEnd(origProcedureEnd.getProcedure());
   }

   @Override
   public StatementReturn visitReturn(StatementReturn origReturn) {
      return new StatementReturn(origReturn.getValue());
   }
}

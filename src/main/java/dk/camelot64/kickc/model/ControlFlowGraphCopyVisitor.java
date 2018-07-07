package dk.camelot64.kickc.model;

import dk.camelot64.kickc.model.operators.Operator;
import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.values.LValue;
import dk.camelot64.kickc.model.values.LabelRef;
import dk.camelot64.kickc.model.values.RValue;
import dk.camelot64.kickc.model.values.VariableRef;

import java.util.ArrayList;
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
   private List<ControlFlowBlock> copyBlockList;

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
      this.copyBlockList = new ArrayList<>();
      for(ControlFlowBlock origBlock : origGraph.getAllBlocks()) {
         ControlFlowBlock copyBlock = visitBlock(origBlock);
         if(copyBlock != null) {
            copyBlockList.add(copyBlock);
         }
      }
      ControlFlowGraph copyGraph = new ControlFlowGraph(copyBlockList, origGraph.getFirstBlock().getLabel());
      return copyGraph;
   }

   @Override
   public ControlFlowBlock visitBlock(ControlFlowBlock origBlock) {
      LabelRef label = origBlock.getLabel();
      ControlFlowBlock copyBlock = new ControlFlowBlock(label, origBlock.getScope());
      this.origBlock = origBlock;
      this.copyBlock = copyBlock;
      // Handle statements
      List<Statement> origBlockStatements = origBlock.getStatements();
      for(Statement origStatement : origBlockStatements) {
         Statement copyStatement = visitStatement(origStatement);
         if(copyStatement != null) {
            this.copyBlock.addStatement(copyStatement);
         }
      }
      // Handle successors
      if(origBlock.getDefaultSuccessor() != null) {
         this.copyBlock.setDefaultSuccessor(origBlock.getDefaultSuccessor());
      }
      if(origBlock.getConditionalSuccessor() != null) {
         this.copyBlock.setConditionalSuccessor(origBlock.getConditionalSuccessor());
      }
      if(origBlock.getCallSuccessor() != null) {
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
   protected ControlFlowBlock splitCurrentBlock(LabelRef label) {
      ControlFlowBlock newBlock = new ControlFlowBlock(label, origBlock.getScope());
      this.copyBlock.setDefaultSuccessor(newBlock.getLabel());
      this.copyBlockList.add(this.copyBlock);
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

   public ControlFlowBlock getOrigBlock() {
      return origBlock;
   }

   @Override
   public Statement visitStatement(Statement statement) {
      return (Statement) super.visitStatement(statement);
   }

   @Override
   public StatementPhiBlock visitPhiBlock(StatementPhiBlock phi) {
      StatementPhiBlock copyPhi = new StatementPhiBlock();
      for(StatementPhiBlock.PhiVariable phiVariable : phi.getPhiVariables()) {
         VariableRef variable = phiVariable.getVariable();
         StatementPhiBlock.PhiVariable copyVar = copyPhi.addPhiVariable(variable);
         for(StatementPhiBlock.PhiRValue phiRValue : phiVariable.getValues()) {
            copyVar.setrValue(phiRValue.getPredecessor(), phiRValue.getrValue());
         }
      }
      return copyPhi;
   }

   @Override
   public StatementAssignment visitAssignment(StatementAssignment origAssignment) {
      LValue lValue = origAssignment.getlValue();
      RValue rValue1 = origAssignment.getrValue1();
      Operator operator = origAssignment.getOperator();
      RValue rValue2 = origAssignment.getrValue2();
      return new StatementAssignment(lValue, rValue1, operator, rValue2, origAssignment.getSource());
   }

   @Override
   public StatementConditionalJump visitConditionalJump(StatementConditionalJump origConditionalJump) {
      RValue rValue1 = origConditionalJump.getrValue1();
      Operator operator = origConditionalJump.getOperator();
      RValue rValue2 = origConditionalJump.getrValue2();
      LabelRef destination = origConditionalJump.getDestination();
      return new StatementConditionalJump(rValue1, operator, rValue2, destination, origConditionalJump.getSource());
   }

   @Override
   public StatementJump visitJump(StatementJump origJump) {
      LabelRef destination = origJump.getDestination();
      return new StatementJump(destination, origJump.getSource());
   }

   @Override
   public StatementLabel visitJumpTarget(StatementLabel origJump) {
      LabelRef label = origJump.getLabel();
      return new StatementLabel(label, origJump.getSource());
   }

   @Override
   public StatementCall visitCall(StatementCall origCall) {
      LValue lValue = origCall.getlValue();
      String procedureName = origCall.getProcedureName();
      List<RValue> parameters = origCall.getParameters();
      return new StatementCall(lValue, procedureName, parameters, origCall.getSource());
   }

   @Override
   public StatementProcedureBegin visitProcedureBegin(StatementProcedureBegin origProcedureBegin) {
      return new StatementProcedureBegin(origProcedureBegin.getProcedure(), origProcedureBegin.getSource());
   }

   @Override
   public StatementProcedureEnd visitProcedureEnd(StatementProcedureEnd origProcedureEnd) {
      return new StatementProcedureEnd(origProcedureEnd.getProcedure(), origProcedureEnd.getSource());
   }

   @Override
   public StatementReturn visitReturn(StatementReturn origReturn) {
      return new StatementReturn(origReturn.getValue(), origReturn.getSource());
   }

   @Override
   public Object visitAsm(StatementAsm asm) {
      return new StatementAsm(asm.getAsmLines(), asm.getSource());
   }

   @Override
   public Object visitKickAsm(StatementKickAsm kasm) {
      return new StatementKickAsm(kasm.getKickAsmCode(), kasm.getSource());
   }

}

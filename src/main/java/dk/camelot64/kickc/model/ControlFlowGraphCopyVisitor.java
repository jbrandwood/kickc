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
      copyBlock.setComments(origBlock.getComments());
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
   public StatementPhiBlock visitPhiBlock(StatementPhiBlock orig) {
      StatementPhiBlock copyPhi = new StatementPhiBlock(orig.getComments());
      for(StatementPhiBlock.PhiVariable phiVariable : orig.getPhiVariables()) {
         VariableRef variable = phiVariable.getVariable();
         StatementPhiBlock.PhiVariable copyVar = copyPhi.addPhiVariable(variable);
         for(StatementPhiBlock.PhiRValue phiRValue : phiVariable.getValues()) {
            copyVar.setrValue(phiRValue.getPredecessor(), phiRValue.getrValue());
         }
      }
      return copyPhi;
   }

   @Override
   public StatementAssignment visitAssignment(StatementAssignment orig) {
      return new StatementAssignment(orig.getlValue(), orig.getrValue1(), orig.getOperator(), orig.getrValue2(), orig.isInitialAssignment(), orig.getSource(), orig.getComments());
   }

   @Override
   public StatementConditionalJump visitConditionalJump(StatementConditionalJump orig) {
      RValue rValue1 = orig.getrValue1();
      Operator operator = orig.getOperator();
      RValue rValue2 = orig.getrValue2();
      LabelRef destination = orig.getDestination();
      StatementConditionalJump conditionalJump = new StatementConditionalJump(rValue1, operator, rValue2, destination, orig.getSource(), orig.getComments());
      conditionalJump.setDeclaredUnroll(orig.isDeclaredUnroll());
      return conditionalJump;
   }

   @Override
   public StatementJump visitJump(StatementJump orig) {
      LabelRef destination = orig.getDestination();
      return new StatementJump(destination, orig.getSource(), orig.getComments());
   }

   @Override
   public StatementLabel visitJumpTarget(StatementLabel orig) {
      LabelRef label = orig.getLabel();
      return new StatementLabel(label, orig.getSource(), orig.getComments());
   }

   @Override
   public StatementCall visitCall(StatementCall orig) {
      LValue lValue = orig.getlValue();
      String procedureName = orig.getProcedureName();
      List<RValue> parameters = orig.getParameters();
      return new StatementCall(lValue, procedureName, parameters, orig.getSource(), orig.getComments());
   }

   @Override
   public Object visitCallPointer(StatementCallPointer orig) {
      LValue lValue = orig.getlValue();
      RValue procedure = orig.getProcedure();
      List<RValue> parameters = orig.getParameters();
      return new StatementCallPointer(lValue, procedure, parameters, orig.getSource(), orig.getComments());
   }

   @Override
   public Object visitCallPrepare(StatementCallPrepare orig) {
      return new StatementCallPrepare(orig.getProcedure(), orig.getParameters(), orig.getSource(), orig.getComments());
   }

   @Override
   public Object visitCallExecute(StatementCallExecute orig) {
      return new StatementCallExecute(orig.getProcedure(), orig.getSource(), orig.getComments());
   }

   @Override
   public Object visitCallFinalize(StatementCallFinalize orig) {
      return new StatementCallFinalize(orig.getlValue(), orig.getProcedure(), orig.getSource(), orig.getComments());
   }

   @Override
   public StatementProcedureBegin visitProcedureBegin(StatementProcedureBegin orig) {
      return new StatementProcedureBegin(orig.getProcedure(), orig.getSource(), orig.getComments());
   }

   @Override
   public StatementProcedureEnd visitProcedureEnd(StatementProcedureEnd orig) {
      return new StatementProcedureEnd(orig.getProcedure(), orig.getSource(), orig.getComments());
   }

   @Override
   public StatementReturn visitReturn(StatementReturn orig) {
      return new StatementReturn(orig.getValue(), orig.getSource(), orig.getComments());
   }

   @Override
   public Object visitAsm(StatementAsm orig) {
      return new StatementAsm(orig.getAsmBody(), orig.getReferenced(), orig.getDeclaredClobber(), orig.getSource(), orig.getComments());
   }

   @Override
   public Object visitKickAsm(StatementKickAsm orig) {
      return new StatementKickAsm(orig.getKickAsmCode(), orig.getLocation(), orig.getBytes(), orig.getCycles(), orig.getUses(), orig.getDeclaredClobber(), orig.getSource(), orig.getComments());
   }

   @Override
   public Object visitStackPull(StatementStackPull orig) {
      return new StatementStackPull(orig.getPullBytes(), orig.getSource(), orig.getComments());
   }
}

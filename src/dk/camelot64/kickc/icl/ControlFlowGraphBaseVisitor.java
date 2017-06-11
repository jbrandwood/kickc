package dk.camelot64.kickc.icl;

import java.util.Collection;

/** Base visitor for iterating through a control flow graph */
public class ControlFlowGraphBaseVisitor<T> {

   public T visitGraph(ControlFlowGraph graph) {
      Collection<ControlFlowBlock> blocks = graph.getAllBlocks();
      for (ControlFlowBlock block : blocks) {
         this.visitBlock(block);
      }
      return null;
   }

   public T visitBlock(ControlFlowBlock block) {
      for (Statement statement : block.getStatements()) {
         this.visitStatement(statement);
      }
      return null;
   }

   public Object visitStatement(Statement statement) {
      if(statement instanceof StatementAssignment) {
         return visitAssignment((StatementAssignment) statement);
      } else if(statement instanceof StatementConditionalJump) {
         return visitConditionalJump((StatementConditionalJump) statement);
      } else if(statement instanceof StatementJump) {
         return visitJump((StatementJump) statement);
      } else if(statement instanceof StatementLabel) {
         return visitJumpTarget((StatementLabel) statement);
      } else if(statement instanceof StatementPhi) {
         return visitPhi((StatementPhi) statement);
      } else if(statement instanceof StatementCallLValue) {
         return visitCallLValue((StatementCallLValue) statement);
      } else if(statement instanceof StatementReturn) {
         return visitReturn((StatementReturn) statement);
      } else if(statement instanceof StatementProcedureBegin) {
         return visitProcedureBegin((StatementProcedureBegin) statement);
      } else if(statement instanceof StatementProcedureEnd) {
         return visitProcedureEnd((StatementProcedureEnd) statement);
      } else {
         throw new RuntimeException("Unhandled statement type "+statement);
      }
   }

   public T visitProcedureBegin(StatementProcedureBegin statement) {
      return null;
   }

   public T visitProcedureEnd(StatementProcedureEnd statement) {
      return null;
   }

   public T visitReturn(StatementReturn aReturn) {
      return null;
   }

   public T visitAssignment(StatementAssignment assignment) {
      return null;
   }

   public T visitConditionalJump(StatementConditionalJump conditionalJump) {
      return null;
   }

   public T visitJump(StatementJump jump) {
      return null;
   }

   public T visitJumpTarget(StatementLabel jumpTarget) {
      return null;
   }

   public T visitPhi(StatementPhi phi) {
      return null;
   }

   public T visitCallLValue(StatementCallLValue callLValue) {
      return null;
   }

}

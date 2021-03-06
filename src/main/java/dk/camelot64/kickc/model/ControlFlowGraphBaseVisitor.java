package dk.camelot64.kickc.model;

import dk.camelot64.kickc.model.statements.*;

import java.util.Collection;

/** Base visitor for iterating through a control flow graph */
public class ControlFlowGraphBaseVisitor<T> {

   public T visitGraph(ControlFlowGraph graph) {
      Collection<ControlFlowBlock> blocks = graph.getAllBlocks();
      for(ControlFlowBlock block : blocks) {
         this.visitBlock(block);
      }
      return null;
   }

   public T visitBlock(ControlFlowBlock block) {
      for(Statement statement : block.getStatements()) {
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
      } else if(statement instanceof StatementCall) {
         return visitCall((StatementCall) statement);
      } else if(statement instanceof StatementCallPointer) {
         return visitCallPointer((StatementCallPointer) statement);
      } else if(statement instanceof StatementCallPrepare) {
         return visitCallPrepare((StatementCallPrepare) statement);
      } else if(statement instanceof StatementCallExecute) {
         return visitCallExecute((StatementCallExecute) statement);
      } else if(statement instanceof StatementCallFinalize) {
         return visitCallFinalize((StatementCallFinalize) statement);
      } else if(statement instanceof StatementPhiBlock) {
         return visitPhiBlock((StatementPhiBlock) statement);
      } else if(statement instanceof StatementReturn) {
         return visitReturn((StatementReturn) statement);
      } else if(statement instanceof StatementProcedureBegin) {
         return visitProcedureBegin((StatementProcedureBegin) statement);
      } else if(statement instanceof StatementProcedureEnd) {
         return visitProcedureEnd((StatementProcedureEnd) statement);
      } else if(statement instanceof StatementAsm) {
         return visitAsm((StatementAsm) statement);
      } else if(statement instanceof StatementKickAsm) {
         return visitKickAsm((StatementKickAsm) statement);
      } else if(statement instanceof StatementExprSideEffect) {
         return visitStackPull((StatementExprSideEffect) statement);
      } else {
         throw new RuntimeException("Unhandled statement type " + statement);
      }
   }

   public T visitProcedureBegin(StatementProcedureBegin procedureBegin) {
      return null;
   }

   public T visitProcedureEnd(StatementProcedureEnd procedureEnd) {
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

   public T visitPhiBlock(StatementPhiBlock phi) {
      return null;
   }

   public T visitCall(StatementCall call) {
      return null;
   }

   public T visitCallPointer(StatementCallPointer call) {
      return null;
   }

   public T visitCallFinalize(StatementCallFinalize callFinalize) {
      return null;
   }

   public T visitCallExecute(StatementCallExecute callExecute) {
      return null;
   }

   public T visitCallPrepare(StatementCallPrepare callPrepare) {
      return null;
   }

   public T visitAsm(StatementAsm asm) {
      return null;
   }

   public T visitKickAsm(StatementKickAsm asm) {
      return null;
   }

   public T visitStackPull(StatementExprSideEffect stackPull) {
      return null;
   }
}

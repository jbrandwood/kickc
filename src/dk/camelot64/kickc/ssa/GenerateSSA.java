package dk.camelot64.kickc.ssa;

import dk.camelot64.kickc.parser.KickCBaseVisitor;
import dk.camelot64.kickc.parser.KickCParser;
import org.antlr.v4.runtime.tree.TerminalNode;

/** Generates program SSA form by visiting the ANTLR4 parse tree*/
public class GenerateSSA extends KickCBaseVisitor<SSARValue> {

   private SymbolManager symbolManager;
   private SSASequence sequence;

   public GenerateSSA() {
      this.symbolManager = new SymbolManager();
      this.sequence = new SSASequence();
   }

   @Override
   public SSARValue visitFile(KickCParser.FileContext ctx) {
      this.visit(ctx.stmtSeq());
      return null;
   }


   @Override
   public SSARValue visitStmtSeq(KickCParser.StmtSeqContext ctx) {
      for(int i=0; i<ctx.getChildCount(); i++) {
         this.visit(ctx.stmt(i));
      }
      return null;
   }

   @Override
   public SSARValue visitStmtBlock(KickCParser.StmtBlockContext ctx) {
      this.visit(ctx.stmtSeq());
      return null;
   }

   @Override
   public SSARValue visitStmtExpr(KickCParser.StmtExprContext ctx) {
      this.visit(ctx.expr());
      return null;
   }

   @Override
   public SSARValue visitStmtIfElse(KickCParser.StmtIfElseContext ctx) {
      SSARValue rValue = this.visit(ctx.expr());
      SSAJumpLabel ifJumpLabel = symbolManager.newIntermediateJumpLabel();
      SSAJumpLabel elseJumpLabel = symbolManager.newIntermediateJumpLabel();
      SSAStatement ifJmpStmt = new SSAStatementConditionalJump(rValue, ifJumpLabel);
      sequence.addStatement(ifJmpStmt);
      SSAStatement elseJmpStmt = new SSAStatementJump(elseJumpLabel);
      sequence.addStatement(elseJmpStmt);
      SSAStatementJumpTarget ifJumpTarget = new SSAStatementJumpTarget(ifJumpLabel);
      sequence.addStatement(ifJumpTarget);
      this.visit(ctx.stmt(0));
      KickCParser.StmtContext elseStmt = ctx.stmt(1);
      if(elseStmt!=null) {
         SSAJumpLabel endJumpLabel = symbolManager.newIntermediateJumpLabel();
         SSAStatement endJmpStmt = new SSAStatementJump(endJumpLabel);
         sequence.addStatement(endJmpStmt);
         SSAStatementJumpTarget elseJumpTarget = new SSAStatementJumpTarget(elseJumpLabel);
         sequence.addStatement(elseJumpTarget);
         this.visit(elseStmt);
         SSAStatementJumpTarget endJumpTarget = new SSAStatementJumpTarget(endJumpLabel);
         sequence.addStatement(endJumpTarget);
      }  else {
         SSAStatementJumpTarget elseJumpTarget = new SSAStatementJumpTarget(elseJumpLabel);
         sequence.addStatement(elseJumpTarget);
      }
      return null;
   }

   @Override
   public SSARValue visitStmtWhile(KickCParser.StmtWhileContext ctx) {
      SSAJumpLabel beginJumpLabel = symbolManager.newIntermediateJumpLabel();
      SSAJumpLabel doJumpLabel = symbolManager.newIntermediateJumpLabel();
      SSAJumpLabel endJumpLabel = symbolManager.newIntermediateJumpLabel();
      SSAStatementJumpTarget beginJumpTarget = new SSAStatementJumpTarget(beginJumpLabel);
      sequence.addStatement(beginJumpTarget);
      SSARValue rValue = this.visit(ctx.expr());
      SSAStatement doJmpStmt = new SSAStatementConditionalJump(rValue, doJumpLabel);
      sequence.addStatement(doJmpStmt);
      SSAStatement endJmpStmt = new SSAStatementJump(endJumpLabel);
      sequence.addStatement(endJmpStmt);
      SSAStatementJumpTarget doJumpTarget = new SSAStatementJumpTarget(doJumpLabel);
      sequence.addStatement(doJumpTarget);
      this.visit(ctx.stmt());
      SSAStatement beginJmpStmt = new SSAStatementJump(beginJumpLabel);
      sequence.addStatement(beginJmpStmt);
      SSAStatementJumpTarget endJumpTarget = new SSAStatementJumpTarget(endJumpLabel);
      sequence.addStatement(endJumpTarget);
      return null;
   }

   @Override
   public SSARValue visitStmtAssignment(KickCParser.StmtAssignmentContext ctx) {
      if(ctx.TYPE()!=null) {
         symbolManager.newVariableDeclaration(ctx.NAME().getText(), ctx.TYPE().getText());
      }
      if(ctx.expr()!=null) {
         SSARValue rValue = this.visit(ctx.expr());
         Symbol variable = symbolManager.newVariableAssignment(ctx.NAME().getText());
         SSAStatement stmt = new SSAStatementAssignment(variable, rValue);
         sequence.addStatement(stmt);
      }
      return null;
   }

   @Override
   public SSARValue visitExprNumber(KickCParser.ExprNumberContext ctx) {
      Number number = KickCNumberParser.parseLiteral(ctx.getText());
      if(number instanceof Integer)  {
         return new SSAConstantInteger((Integer) number);
      } else {
         return new SSAConstantDouble((Double) number);
      }
   }

   @Override
   public SSARValue visitExprString(KickCParser.ExprStringContext ctx) {
      return new SSAConstantString(ctx.getText());
   }

   @Override
   public SSARValue visitExprBool(KickCParser.ExprBoolContext ctx) {
      String bool = ctx.getText();
      return new SSAConstantBool(Boolean.valueOf(bool));
   }


   @Override
   public SSARValue visitExprBinary(KickCParser.ExprBinaryContext ctx) {
      SSARValue left = this.visit(ctx.expr(0));
      SSARValue right = this.visit(ctx.expr(1));
      String op = ((TerminalNode)ctx.getChild(1)).getSymbol().getText();
      SSAOperator operator = new SSAOperator(op);
      Symbol tmpVar = symbolManager.newIntermediateAssignment();
      SSAStatement stmt = new SSAStatementAssignment(tmpVar, left, operator, right);
      sequence.addStatement(stmt);
      return tmpVar;
   }

   @Override
   public SSARValue visitExprUnary(KickCParser.ExprUnaryContext ctx) {
      SSARValue child = this.visit(ctx.expr());
      String op = ((TerminalNode)ctx.getChild(0)).getSymbol().getText();
      SSAOperator operator = new SSAOperator(op);
      Symbol tmpVar = symbolManager.newIntermediateAssignment();
      SSAStatement stmt = new SSAStatementAssignment(tmpVar, operator, child);
      sequence.addStatement(stmt);
      return tmpVar;
   }

   @Override
   public SSARValue visitExprPar(KickCParser.ExprParContext ctx) {
      return this.visit(ctx.expr());
   }

   @Override
   public SSARValue visitExprId(KickCParser.ExprIdContext ctx) {
      return symbolManager.newVariableUsage(ctx.NAME().getText());
   }

   public SSASequence getSequence() {
      return sequence;
   }

   public SymbolManager getSymbols() {
      return this.symbolManager;
   }
}

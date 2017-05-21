package dk.camelot64.kickc.icl;

import dk.camelot64.kickc.parser.KickCBaseVisitor;
import dk.camelot64.kickc.parser.KickCParser;
import org.antlr.v4.runtime.tree.TerminalNode;

/** Generates program SSA form by visiting the ANTLR4 parse tree*/
public class Pass1GenerateStatementSequence extends KickCBaseVisitor<RValue> {

   private SymbolTable symbolTable;
   private StatementSequence sequence;

   public Pass1GenerateStatementSequence() {
      this.symbolTable = new SymbolTable();
      this.sequence = new StatementSequence();
   }

   public void generate(KickCParser.FileContext file) {
      this.visit(file);
   }

   @Override
   public RValue visitFile(KickCParser.FileContext ctx) {
      this.visit(ctx.stmtSeq());
      return null;
   }


   @Override
   public RValue visitStmtSeq(KickCParser.StmtSeqContext ctx) {
      for(int i=0; i<ctx.getChildCount(); i++) {
         this.visit(ctx.stmt(i));
      }
      return null;
   }

   @Override
   public RValue visitStmtBlock(KickCParser.StmtBlockContext ctx) {
      this.visit(ctx.stmtSeq());
      return null;
   }

   @Override
   public RValue visitStmtExpr(KickCParser.StmtExprContext ctx) {
      this.visit(ctx.expr());
      return null;
   }

   @Override
   public RValue visitStmtIfElse(KickCParser.StmtIfElseContext ctx) {
      RValue rValue = this.visit(ctx.expr());
      Label ifJumpLabel = symbolTable.newIntermediateJumpLabel();
      Label elseJumpLabel = symbolTable.newIntermediateJumpLabel();
      Statement ifJmpStmt = new StatementConditionalJump(rValue, ifJumpLabel);
      sequence.addStatement(ifJmpStmt);
      Statement elseJmpStmt = new StatementJump(elseJumpLabel);
      sequence.addStatement(elseJmpStmt);
      StatementJumpTarget ifJumpTarget = new StatementJumpTarget(ifJumpLabel);
      sequence.addStatement(ifJumpTarget);
      this.visit(ctx.stmt(0));
      KickCParser.StmtContext elseStmt = ctx.stmt(1);
      if(elseStmt!=null) {
         Label endJumpLabel = symbolTable.newIntermediateJumpLabel();
         Statement endJmpStmt = new StatementJump(endJumpLabel);
         sequence.addStatement(endJmpStmt);
         StatementJumpTarget elseJumpTarget = new StatementJumpTarget(elseJumpLabel);
         sequence.addStatement(elseJumpTarget);
         this.visit(elseStmt);
         StatementJumpTarget endJumpTarget = new StatementJumpTarget(endJumpLabel);
         sequence.addStatement(endJumpTarget);
      }  else {
         StatementJumpTarget elseJumpTarget = new StatementJumpTarget(elseJumpLabel);
         sequence.addStatement(elseJumpTarget);
      }
      return null;
   }

   @Override
   public RValue visitStmtWhile(KickCParser.StmtWhileContext ctx) {
      Label beginJumpLabel = symbolTable.newIntermediateJumpLabel();
      Label doJumpLabel = symbolTable.newIntermediateJumpLabel();
      Label endJumpLabel = symbolTable.newIntermediateJumpLabel();
      StatementJumpTarget beginJumpTarget = new StatementJumpTarget(beginJumpLabel);
      sequence.addStatement(beginJumpTarget);
      RValue rValue = this.visit(ctx.expr());
      Statement doJmpStmt = new StatementConditionalJump(rValue, doJumpLabel);
      sequence.addStatement(doJmpStmt);
      Statement endJmpStmt = new StatementJump(endJumpLabel);
      sequence.addStatement(endJmpStmt);
      StatementJumpTarget doJumpTarget = new StatementJumpTarget(doJumpLabel);
      sequence.addStatement(doJumpTarget);
      this.visit(ctx.stmt());
      Statement beginJmpStmt = new StatementJump(beginJumpLabel);
      sequence.addStatement(beginJmpStmt);
      StatementJumpTarget endJumpTarget = new StatementJumpTarget(endJumpLabel);
      sequence.addStatement(endJumpTarget);
      return null;
   }

   @Override
   public RValue visitStmtDoWhile(KickCParser.StmtDoWhileContext ctx) {
      Label beginJumpLabel = symbolTable.newIntermediateJumpLabel();
      StatementJumpTarget beginJumpTarget = new StatementJumpTarget(beginJumpLabel);
      sequence.addStatement(beginJumpTarget);
      this.visit(ctx.stmt());
      RValue rValue = this.visit(ctx.expr());
      Statement doJmpStmt = new StatementConditionalJump(rValue, beginJumpLabel);
      sequence.addStatement(doJmpStmt);
      return null;
   }

   @Override
   public RValue visitStmtAssignment(KickCParser.StmtAssignmentContext ctx) {
      if(ctx.TYPE()!=null) {
         symbolTable.newVariableDeclaration(ctx.NAME().getText(), ctx.TYPE().getText());
      }
      if(ctx.expr()!=null) {
         RValue rValue = this.visit(ctx.expr());
         VariableUnversioned variable = symbolTable.newVariableUsage(ctx.NAME().getText());
         Statement stmt = new StatementAssignment(variable, rValue);
         sequence.addStatement(stmt);
      }
      return null;
   }

   @Override
   public RValue visitExprNumber(KickCParser.ExprNumberContext ctx) {
      Number number = NumberParser.parseLiteral(ctx.getText());
      if(number instanceof Integer)  {
         return new ConstantInteger((Integer) number);
      } else {
         return new ConstantDouble((Double) number);
      }
   }

   @Override
   public RValue visitExprString(KickCParser.ExprStringContext ctx) {
      return new ConstantString(ctx.getText());
   }

   @Override
   public RValue visitExprBool(KickCParser.ExprBoolContext ctx) {
      String bool = ctx.getText();
      return new ConstantBool(Boolean.valueOf(bool));
   }


   @Override
   public RValue visitExprBinary(KickCParser.ExprBinaryContext ctx) {
      RValue left = this.visit(ctx.expr(0));
      RValue right = this.visit(ctx.expr(1));
      String op = ((TerminalNode)ctx.getChild(1)).getSymbol().getText();
      Operator operator = new Operator(op);
      VariableIntermediate tmpVar = symbolTable.newIntermediateAssignment();
      Statement stmt = new StatementAssignment(tmpVar, left, operator, right);
      sequence.addStatement(stmt);
      return tmpVar;
   }

   @Override
   public RValue visitExprUnary(KickCParser.ExprUnaryContext ctx) {
      RValue child = this.visit(ctx.expr());
      String op = ((TerminalNode)ctx.getChild(0)).getSymbol().getText();
      Operator operator = new Operator(op);
      VariableIntermediate tmpVar = symbolTable.newIntermediateAssignment();
      Statement stmt = new StatementAssignment(tmpVar, operator, child);
      sequence.addStatement(stmt);
      return tmpVar;
   }

   @Override
   public RValue visitExprPar(KickCParser.ExprParContext ctx) {
      return this.visit(ctx.expr());
   }

   @Override
   public RValue visitExprId(KickCParser.ExprIdContext ctx) {
      return symbolTable.newVariableUsage(ctx.NAME().getText());
   }

   public StatementSequence getSequence() {
      return sequence;
   }

   public SymbolTable getSymbols() {
      return this.symbolTable;
   }

}

package dk.camelot64.kickc.icl;

import dk.camelot64.kickc.parser.KickCBaseVisitor;
import dk.camelot64.kickc.parser.KickCParser;
import org.antlr.v4.runtime.tree.TerminalNode;

/** Generates program SSA form by visiting the ANTLR4 parse tree*/
public class Pass1GenerateStatementSequence extends KickCBaseVisitor<Object> {

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
   public Void visitFile(KickCParser.FileContext ctx) {
      this.visit(ctx.stmtSeq());
      return null;
   }

   @Override
   public Void visitStmtSeq(KickCParser.StmtSeqContext ctx) {
      for(int i=0; i<ctx.getChildCount(); i++) {
         this.visit(ctx.stmt(i));
      }
      return null;
   }

   @Override
   public Void visitStmtBlock(KickCParser.StmtBlockContext ctx) {
      this.visit(ctx.stmtSeq());
      return null;
   }

   @Override
   public Void visitStmtExpr(KickCParser.StmtExprContext ctx) {
      this.visit(ctx.expr());
      return null;
   }

   @Override
   public Void visitStmtIfElse(KickCParser.StmtIfElseContext ctx) {
      RValue rValue = (RValue) this.visit(ctx.expr());
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
   public Void visitStmtWhile(KickCParser.StmtWhileContext ctx) {
      Label beginJumpLabel = symbolTable.newIntermediateJumpLabel();
      Label doJumpLabel = symbolTable.newIntermediateJumpLabel();
      Label endJumpLabel = symbolTable.newIntermediateJumpLabel();
      StatementJumpTarget beginJumpTarget = new StatementJumpTarget(beginJumpLabel);
      sequence.addStatement(beginJumpTarget);
      RValue rValue = (RValue) this.visit(ctx.expr());
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
   public Void visitStmtDoWhile(KickCParser.StmtDoWhileContext ctx) {
      Label beginJumpLabel = symbolTable.newIntermediateJumpLabel();
      StatementJumpTarget beginJumpTarget = new StatementJumpTarget(beginJumpLabel);
      sequence.addStatement(beginJumpTarget);
      this.visit(ctx.stmt());
      RValue rValue = (RValue) this.visit(ctx.expr());
      Statement doJmpStmt = new StatementConditionalJump(rValue, beginJumpLabel);
      sequence.addStatement(doJmpStmt);
      return null;
   }

   @Override
   public Void visitStmtFunction(KickCParser.StmtFunctionContext ctx) {
      throw new RuntimeException("Not implemented");
   }

   @Override
   public Void visitStmtReturn(KickCParser.StmtReturnContext ctx) {
      throw new RuntimeException("Not implemented");
   }

   @Override
   public Void visitStmtDeclaration(KickCParser.StmtDeclarationContext ctx) {
      if(ctx.getChild(0).getText().equals("const")) {
         System.out.println("Const!"+ctx.getText());
      }
      SymbolType type = (SymbolType)visit(ctx.typeDecl());
      VariableUnversioned lValue = symbolTable.newVariableDeclaration(ctx.NAME().getText(), type);
      if(ctx.initializer()!=null) {
         RValue rValue = (RValue) visit(ctx.initializer());
         Statement stmt = new StatementAssignment(lValue, rValue);
         sequence.addStatement(stmt);
      }
      return null;
   }

   @Override
   public Void visitStmtAssignment(KickCParser.StmtAssignmentContext ctx) {
      LValue lValue = (LValue) visit(ctx.lvalue());
      RValue rValue = (RValue) this.visit(ctx.expr());
      Statement stmt = new StatementAssignment(lValue, rValue);
      sequence.addStatement(stmt);
      return null;
   }

   @Override
   public LValue visitLvalueName(KickCParser.LvalueNameContext ctx) {
      return symbolTable.newVariableUsage(ctx.NAME().getText());
   }

   @Override
   public LValue visitLvaluePar(KickCParser.LvalueParContext ctx) {
      return (LValue) visit(ctx.lvalue());
   }

   @Override
   public LValue visitLvaluePtr(KickCParser.LvaluePtrContext ctx) {
      LValue lval = (LValue) visit(ctx.lvalue());
      if(lval instanceof Variable) {
         return new PointerDereferenceSimple((Variable) lval);
      }  else {
         throw new RuntimeException("Not implemented");
      }
   }

   @Override
   public LValue visitLvalueArray(KickCParser.LvalueArrayContext ctx) {
      LValue lval = (LValue) visit(ctx.lvalue());
      RValue index = (RValue) visit(ctx.expr());
      return new PointerDereferenceIndexed((Variable) lval, (Variable)index);
   }

   @Override
   public RValue visitInitExpr(KickCParser.InitExprContext ctx) {
      return (RValue) visit(ctx.expr());
   }

   @Override
   public RValue visitInitList(KickCParser.InitListContext ctx) {
      throw new RuntimeException("Not implemented");
   }

   @Override
   public SymbolType visitTypeSimple(KickCParser.TypeSimpleContext ctx) {
      return SymbolTypeBasic.get(ctx.getText());
   }

   @Override
   public SymbolType visitTypePtr(KickCParser.TypePtrContext ctx) {
      SymbolType elementType = (SymbolType) visit(ctx.typeDecl());
      return new SymbolTypePointer(elementType);
   }

   @Override
   public SymbolType visitTypeArray(KickCParser.TypeArrayContext ctx) {
      SymbolType elementType = (SymbolType) visit(ctx.typeDecl());
      Constant size = ParseTreeConstantEvaluator.evaluate(ctx.expr());
      if(size instanceof ConstantInteger) {
         return new SymbolTypeArray(elementType, ((ConstantInteger) size).getNumber());
      } else {
         throw new RuntimeException("Array size not a constant integer "+ctx.getText());
      }
   }

   @Override
   public RValue visitExprCast(KickCParser.ExprCastContext ctx) {
      System.out.println("Cast type ignored!");
      return (RValue) visit(ctx.expr());
   }

   @Override
   public Object visitExprCall(KickCParser.ExprCallContext ctx) {
      throw new RuntimeException("Not implemented");
   }

   @Override
   public RValue visitExprArray(KickCParser.ExprArrayContext ctx) {
      RValue array = (LValue) visit(ctx.expr(0));
      RValue index = (RValue) visit(ctx.expr(1));
      Operator operator = new Operator("+");
      VariableIntermediate tmpVar = symbolTable.newIntermediateAssignment();
      Statement stmt = new StatementAssignment(tmpVar, array, operator, index);
      sequence.addStatement(stmt);
      VariableIntermediate tmpVar2 = symbolTable.newIntermediateAssignment();
      Statement stmt2 = new StatementAssignment(tmpVar2, null, new Operator("*"), tmpVar );
      sequence.addStatement(stmt2);
      return tmpVar2;
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
      RValue left = (RValue) this.visit(ctx.expr(0));
      RValue right = (RValue) this.visit(ctx.expr(1));
      String op = ((TerminalNode)ctx.getChild(1)).getSymbol().getText();
      Operator operator = new Operator(op);
      VariableIntermediate tmpVar = symbolTable.newIntermediateAssignment();
      Statement stmt = new StatementAssignment(tmpVar, left, operator, right);
      sequence.addStatement(stmt);
      return tmpVar;
   }

   @Override
   public RValue visitExprUnary(KickCParser.ExprUnaryContext ctx) {
      RValue child = (RValue) this.visit(ctx.expr());
      String op = ((TerminalNode)ctx.getChild(0)).getSymbol().getText();
      Operator operator = new Operator(op);
      VariableIntermediate tmpVar = symbolTable.newIntermediateAssignment();
      Statement stmt = new StatementAssignment(tmpVar, operator, child);
      sequence.addStatement(stmt);
      return tmpVar;
   }

   @Override
   public RValue visitExprPar(KickCParser.ExprParContext ctx) {
      return (RValue) this.visit(ctx.expr());
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

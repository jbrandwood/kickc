package dk.camelot64.kickc.icl;

import dk.camelot64.kickc.parser.KickCBaseVisitor;
import dk.camelot64.kickc.parser.KickCParser;
import org.antlr.v4.runtime.tree.TerminalNode;

import java.util.ArrayList;
import java.util.List;
import java.util.Stack;

/**
 * Generates program SSA form by visiting the ANTLR4 parse tree
 */
public class Pass1GenerateStatementSequence extends KickCBaseVisitor<Object> {

   private Scope programScope;
   private Stack<Scope> scopeStack;
   private StatementSequence sequence;

   public Pass1GenerateStatementSequence() {
      this.programScope = new Scope();
      this.scopeStack = new Stack<>();
      scopeStack.push(programScope);
      this.sequence = new StatementSequence();
   }

   public Scope getProgramScope() {
      return programScope;
   }

   private Scope getCurrentSymbols() {
      return scopeStack.peek();
   }

   private Procedure getCurrentProcedure() {
      for (Scope scope : scopeStack) {
         if (scope instanceof Procedure) {
            return (Procedure) scope;
         }
      }
      return null;
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
      for (int i = 0; i < ctx.getChildCount(); i++) {
         this.visit(ctx.stmt(i));
      }
      return null;
   }

   @Override
   public Void visitStmtBlock(KickCParser.StmtBlockContext ctx) {
      if(ctx.stmtSeq()!=null) {
         this.visit(ctx.stmtSeq());
      }
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
      Label ifJumpLabel = getCurrentSymbols().addLabelIntermediate();
      Label elseJumpLabel = getCurrentSymbols().addLabelIntermediate();
      Statement ifJmpStmt = new StatementConditionalJump(rValue, ifJumpLabel);
      sequence.addStatement(ifJmpStmt);
      Statement elseJmpStmt = new StatementJump(elseJumpLabel);
      sequence.addStatement(elseJmpStmt);
      StatementLabel ifJumpTarget = new StatementLabel(ifJumpLabel);
      sequence.addStatement(ifJumpTarget);
      this.visit(ctx.stmt(0));
      KickCParser.StmtContext elseStmt = ctx.stmt(1);
      if (elseStmt != null) {
         Label endJumpLabel = getCurrentSymbols().addLabelIntermediate();
         Statement endJmpStmt = new StatementJump(endJumpLabel);
         sequence.addStatement(endJmpStmt);
         StatementLabel elseJumpTarget = new StatementLabel(elseJumpLabel);
         sequence.addStatement(elseJumpTarget);
         this.visit(elseStmt);
         StatementLabel endJumpTarget = new StatementLabel(endJumpLabel);
         sequence.addStatement(endJumpTarget);
      } else {
         StatementLabel elseJumpTarget = new StatementLabel(elseJumpLabel);
         sequence.addStatement(elseJumpTarget);
      }
      return null;
   }

   @Override
   public Void visitStmtWhile(KickCParser.StmtWhileContext ctx) {
      Label beginJumpLabel = getCurrentSymbols().addLabelIntermediate();
      Label doJumpLabel = getCurrentSymbols().addLabelIntermediate();
      Label endJumpLabel = getCurrentSymbols().addLabelIntermediate();
      StatementLabel beginJumpTarget = new StatementLabel(beginJumpLabel);
      sequence.addStatement(beginJumpTarget);
      RValue rValue = (RValue) this.visit(ctx.expr());
      Statement doJmpStmt = new StatementConditionalJump(rValue, doJumpLabel);
      sequence.addStatement(doJmpStmt);
      Statement endJmpStmt = new StatementJump(endJumpLabel);
      sequence.addStatement(endJmpStmt);
      StatementLabel doJumpTarget = new StatementLabel(doJumpLabel);
      sequence.addStatement(doJumpTarget);
      this.visit(ctx.stmt());
      Statement beginJmpStmt = new StatementJump(beginJumpLabel);
      sequence.addStatement(beginJmpStmt);
      StatementLabel endJumpTarget = new StatementLabel(endJumpLabel);
      sequence.addStatement(endJumpTarget);
      return null;
   }

   @Override
   public Void visitStmtDoWhile(KickCParser.StmtDoWhileContext ctx) {
      Label beginJumpLabel = getCurrentSymbols().addLabelIntermediate();
      StatementLabel beginJumpTarget = new StatementLabel(beginJumpLabel);
      sequence.addStatement(beginJumpTarget);
      if(ctx.stmt()!=null) {
         this.visit(ctx.stmt());
      }
      RValue rValue = (RValue) this.visit(ctx.expr());
      Statement doJmpStmt = new StatementConditionalJump(rValue, beginJumpLabel);
      sequence.addStatement(doJmpStmt);
      return null;
   }

   @Override
   public Void visitStmtFunction(KickCParser.StmtFunctionContext ctx) {
      SymbolType type = (SymbolType) visit(ctx.typeDecl());
      String name = ctx.NAME().getText();
      Procedure procedure = getCurrentSymbols().addProcedure(name, type);
      scopeStack.push(procedure);
      Label procExit = procedure.addLabel("@return");
      VariableUnversioned returnVar = null;
      if (!SymbolTypeBasic.VOID.equals(type)) {
         returnVar = procedure.addVariable("return", type);
      }
      List<Variable> parameterList = new ArrayList<>();
      if (ctx.parameterListDecl() != null) {
         parameterList = (List<Variable>) this.visit(ctx.parameterListDecl());
      }
      procedure.setParameters(parameterList);
      sequence.addStatement(new StatementProcedureBegin(procedure));
      if(ctx.stmtSeq()!=null) {
         this.visit(ctx.stmtSeq());
      }
      sequence.addStatement(new StatementLabel(procExit));
      if(returnVar!=null) {
         sequence.addStatement(new StatementAssignment(returnVar, returnVar));
      }
      sequence.addStatement(new StatementReturn(returnVar));
      scopeStack.pop();
      sequence.addStatement(new StatementProcedureEnd(procedure));
      return null;
   }

   @Override
   public List<Variable> visitParameterListDecl(KickCParser.ParameterListDeclContext ctx) {
      ArrayList<Variable> parameterDecls = new ArrayList<>();
      for (KickCParser.ParameterDeclContext parameterDeclCtx : ctx.parameterDecl()) {
         Variable parameterDecl = (Variable) this.visit(parameterDeclCtx);
         parameterDecls.add(parameterDecl);
      }
      return parameterDecls;
   }

   @Override
   public Variable visitParameterDecl(KickCParser.ParameterDeclContext ctx) {
      SymbolType type = (SymbolType) this.visit(ctx.typeDecl());
      VariableUnversioned param = new VariableUnversioned(ctx.NAME().getText(), getCurrentSymbols(), type);
      return param;
   }

   @Override
   public Void visitStmtReturn(KickCParser.StmtReturnContext ctx) {
      Procedure procedure = getCurrentProcedure();
      KickCParser.ExprContext exprCtx = ctx.expr();
      RValue rValue = null;
      if (exprCtx != null) {
         rValue = (RValue) this.visit(exprCtx);
         Variable returnVar = procedure.getVariable("return");
         sequence.addStatement(new StatementAssignment(returnVar, rValue));
      }
      Label returnLabel = procedure.getLabel("@return");
      sequence.addStatement(new StatementJump(returnLabel));
      return null;
   }

   @Override
   public Void visitStmtDeclaration(KickCParser.StmtDeclarationContext ctx) {
      if (ctx.getChild(0).getText().equals("const")) {
         System.out.println("Const!" + ctx.getText());
      }
      SymbolType type = (SymbolType) visit(ctx.typeDecl());
      VariableUnversioned lValue = getCurrentSymbols().addVariable(ctx.NAME().getText(), type);
      if (ctx.initializer() != null) {
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
      return getCurrentSymbols().getVariable(ctx.NAME().getText());
   }

   @Override
   public LValue visitLvaluePar(KickCParser.LvalueParContext ctx) {
      return (LValue) visit(ctx.lvalue());
   }

   @Override
   public LValue visitLvaluePtr(KickCParser.LvaluePtrContext ctx) {
      LValue lval = (LValue) visit(ctx.lvalue());
      if (lval instanceof Variable) {
         return new PointerDereferenceSimple((Variable) lval);
      } else {
         throw new RuntimeException("Not implemented");
      }
   }

   @Override
   public LValue visitLvalueArray(KickCParser.LvalueArrayContext ctx) {
      LValue lval = (LValue) visit(ctx.lvalue());
      RValue index = (RValue) visit(ctx.expr());
      return new PointerDereferenceIndexed(lval, index);
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
      if (size instanceof ConstantInteger) {
         return new SymbolTypeArray(elementType, ((ConstantInteger) size).getNumber());
      } else {
         throw new RuntimeException("Array size not a constant integer " + ctx.getText());
      }
   }

   @Override
   public RValue visitExprCast(KickCParser.ExprCastContext ctx) {
      System.out.println("Cast type ignored!");
      return (RValue) visit(ctx.expr());
   }

   @Override
   public Object visitExprCall(KickCParser.ExprCallContext ctx) {
      List<RValue> parameters;
      KickCParser.ParameterListContext parameterList = ctx.parameterList();
      if(parameterList!=null) {
          parameters = (List<RValue>) this.visit(parameterList);
      } else {
         parameters = new ArrayList<>();
      }
      VariableIntermediate tmpVar = getCurrentSymbols().addVariableIntermediate();
      sequence.addStatement(new StatementCall(tmpVar, ctx.NAME().getText(), parameters));
      return tmpVar;
   }

   @Override
   public List<RValue> visitParameterList(KickCParser.ParameterListContext ctx) {
      List<RValue> parameters = new ArrayList<>();
      for (KickCParser.ExprContext exprContext : ctx.expr()) {
         RValue param = (RValue) this.visit(exprContext);
         parameters.add(param);
      }
      return parameters;
   }

   @Override
   public RValue visitExprArray(KickCParser.ExprArrayContext ctx) {
      RValue array = (LValue) visit(ctx.expr(0));
      RValue index = (RValue) visit(ctx.expr(1));
      Operator operator = new Operator("*idx");
      VariableIntermediate tmpVar = getCurrentSymbols().addVariableIntermediate();
      Statement stmt = new StatementAssignment(tmpVar, array, operator, index);
      sequence.addStatement(stmt);
      return tmpVar;
   }

   @Override
   public RValue visitExprNumber(KickCParser.ExprNumberContext ctx) {
      Number number = NumberParser.parseLiteral(ctx.getText());
      if (number instanceof Integer) {
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
      String op = ((TerminalNode) ctx.getChild(1)).getSymbol().getText();
      Operator operator = new Operator(op);
      VariableIntermediate tmpVar = getCurrentSymbols().addVariableIntermediate();
      Statement stmt = new StatementAssignment(tmpVar, left, operator, right);
      sequence.addStatement(stmt);
      return tmpVar;
   }

   @Override
   public RValue visitExprUnary(KickCParser.ExprUnaryContext ctx) {
      RValue child = (RValue) this.visit(ctx.expr());
      String op = ((TerminalNode) ctx.getChild(0)).getSymbol().getText();
      Operator operator = new Operator(op);
      VariableIntermediate tmpVar = getCurrentSymbols().addVariableIntermediate();
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
      return getCurrentSymbols().getVariable(ctx.NAME().getText());
   }

   public StatementSequence getSequence() {
      return sequence;
   }

}

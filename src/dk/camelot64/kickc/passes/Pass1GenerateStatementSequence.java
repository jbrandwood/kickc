package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.NumberParser;
import dk.camelot64.kickc.icl.*;
import dk.camelot64.kickc.parser.KickCBaseVisitor;
import dk.camelot64.kickc.parser.KickCParser;
import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.tree.TerminalNode;

import java.util.ArrayList;
import java.util.List;
import java.util.Stack;

/**
 * Generates program SSA form by visiting the ANTLR4 parse tree
 */
public class Pass1GenerateStatementSequence extends KickCBaseVisitor<Object> {

   private CompileLog log;
   private ProgramScope programScope;
   private Stack<Scope> scopeStack;
   private StatementSequence sequence;

   public Pass1GenerateStatementSequence(CompileLog log) {
      this.log = log;
      this.programScope = new ProgramScope();
      this.scopeStack = new Stack<>();
      scopeStack.push(programScope);
      this.sequence = new StatementSequence();
   }

   public ProgramScope getProgramScope() {
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
      if (ctx.stmtSeq() != null) {
         this.visit(ctx.stmtSeq());
      }
      return null;
   }

   @Override
   public Void visitStmtExpr(KickCParser.StmtExprContext ctx) {
      PrePostModifierHandler.addPreModifiers(this, ctx.expr());
      this.visit(ctx.expr());
      PrePostModifierHandler.addPostModifiers(this, ctx.expr());
      return null;
   }

   @Override
   public Void visitStmtIfElse(KickCParser.StmtIfElseContext ctx) {
      PrePostModifierHandler.addPreModifiers(this, ctx.expr());
      RValue rValue = (RValue) this.visit(ctx.expr());
      PrePostModifierHandler.addPostModifiers(this, ctx.expr());
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
      PrePostModifierHandler.addPreModifiers(this, ctx.expr());
      RValue rValue = (RValue) this.visit(ctx.expr());
      PrePostModifierHandler.addPostModifiers(this, ctx.expr());
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
      if (ctx.stmt() != null) {
         this.visit(ctx.stmt());
      }
      PrePostModifierHandler.addPreModifiers(this, ctx.expr());
      RValue rValue = (RValue) this.visit(ctx.expr());
      PrePostModifierHandler.addPostModifiers(this, ctx.expr());
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
      if (ctx.stmtSeq() != null) {
         this.visit(ctx.stmtSeq());
      }
      sequence.addStatement(new StatementLabel(procExit));
      if (returnVar != null) {
         sequence.addStatement(new StatementAssignment(returnVar, returnVar));
      }
      VariableRef returnVarRef = null;
      if(returnVar!=null) {new VariableRef(returnVar); }
      sequence.addStatement(new StatementReturn(returnVarRef));
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
         PrePostModifierHandler.addPreModifiers(this, exprCtx);
         rValue = (RValue) this.visit(exprCtx);
         Variable returnVar = procedure.getVariable("return");
         sequence.addStatement(new StatementAssignment(returnVar, rValue));
         PrePostModifierHandler.addPostModifiers(this, exprCtx);
      }
      Label returnLabel = procedure.getLabel("@return");
      sequence.addStatement(new StatementJump(returnLabel));
      return null;
   }

   @Override
   public Void visitStmtDeclaration(KickCParser.StmtDeclarationContext ctx) {
      if (ctx.getChild(0).getText().equals("const")) {
         log.append("Const!" + ctx.getText());
      }
      SymbolType type = (SymbolType) visit(ctx.typeDecl());
      VariableUnversioned lValue = getCurrentSymbols().addVariable(ctx.NAME().getText(), type);
      if (ctx.initializer() != null) {
         PrePostModifierHandler.addPreModifiers(this, ctx.initializer());
         RValue rValue = (RValue) visit(ctx.initializer());
         Statement stmt = new StatementAssignment(lValue, rValue);
         sequence.addStatement(stmt);
         PrePostModifierHandler.addPostModifiers(this, ctx.initializer());
      }
      return null;
   }

   @Override
   public Void visitStmtAssignment(KickCParser.StmtAssignmentContext ctx) {
      PrePostModifierHandler.addPreModifiers(this, ctx);
      LValue lValue = (LValue) visit(ctx.lvalue());
      RValue rValue = (RValue) this.visit(ctx.expr());
      Statement stmt = new StatementAssignment(lValue, rValue);
      sequence.addStatement(stmt);
      PrePostModifierHandler.addPostModifiers(this, ctx);
      return null;
   }

   @Override
   public LValue visitLvalueName(KickCParser.LvalueNameContext ctx) {
      Variable variable = getCurrentSymbols().getVariable(ctx.NAME().getText());
      return new VariableRef(variable);
   }

   @Override
   public LValue visitLvaluePar(KickCParser.LvalueParContext ctx) {
      return (LValue) visit(ctx.lvalue());
   }

   @Override
   public LValue visitLvaluePtr(KickCParser.LvaluePtrContext ctx) {
      LValue lval = (LValue) visit(ctx.lvalue());
      if (lval instanceof VariableRef) {
         return new PointerDereferenceSimple((VariableRef) lval);
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
      log.append("Cast type ignored!");
      return (RValue) visit(ctx.expr());
   }

   @Override
   public Object visitExprCall(KickCParser.ExprCallContext ctx) {
      List<RValue> parameters;
      KickCParser.ParameterListContext parameterList = ctx.parameterList();
      if (parameterList != null) {
         parameters = (List<RValue>) this.visit(parameterList);
      } else {
         parameters = new ArrayList<>();
      }
      VariableIntermediate tmpVar = getCurrentSymbols().addVariableIntermediate();
      sequence.addStatement(new StatementCall(new VariableRef(tmpVar), ctx.NAME().getText(), parameters));
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
      VariableRef tmpVarRef = new VariableRef(tmpVar);
      Statement stmt = new StatementAssignment(tmpVarRef, array, operator, index);
      sequence.addStatement(stmt);
      return tmpVarRef;
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
      VariableRef tmpVarRef = new VariableRef(tmpVar);
      Statement stmt = new StatementAssignment(tmpVarRef, left, operator, right);
      sequence.addStatement(stmt);
      return tmpVarRef;
   }

   @Override
   public RValue visitExprUnary(KickCParser.ExprUnaryContext ctx) {
      RValue child = (RValue) this.visit(ctx.expr());
      String op = ((TerminalNode) ctx.getChild(0)).getSymbol().getText();
      Operator operator = new Operator(op);
      VariableIntermediate tmpVar = getCurrentSymbols().addVariableIntermediate();
      VariableRef tmpVarRef = new VariableRef(tmpVar);
      Statement stmt = new StatementAssignment(tmpVarRef, operator, child);
      sequence.addStatement(stmt);
      return tmpVarRef;
   }

   @Override
   public Object visitExprPreMod(KickCParser.ExprPreModContext ctx) {
      RValue child = (RValue) this.visit(ctx.expr());
      return child;
   }

   @Override
   public Object visitExprPostMod(KickCParser.ExprPostModContext ctx) {
      RValue child = (RValue) this.visit(ctx.expr());
      return child;
   }

   @Override
   public RValue visitExprPar(KickCParser.ExprParContext ctx) {
      return (RValue) this.visit(ctx.expr());
   }

   @Override
   public RValue visitExprId(KickCParser.ExprIdContext ctx) {
      Variable variable = getCurrentSymbols().getVariable(ctx.NAME().getText());
      return new VariableRef(variable);
   }

   public StatementSequence getSequence() {
      return sequence;
   }

   private static class PrePostModifierHandler extends KickCBaseVisitor<Void> {

      private List<PrePostModifier> postMods;
      private List<PrePostModifier> preMods;
      private Pass1GenerateStatementSequence mainParser;

      public PrePostModifierHandler(Pass1GenerateStatementSequence mainParser) {
         this.mainParser = mainParser;
         preMods = new ArrayList<>();
         postMods = new ArrayList<>();
      }

      public List<PrePostModifier> getPreMods() {
         return preMods;
      }

      public List<PrePostModifier> getPostMods() {
         return postMods;
      }

      public static void addPostModifiers(Pass1GenerateStatementSequence parser, ParserRuleContext ctx) {
         PrePostModifierHandler prePostModifierHandler = new PrePostModifierHandler(parser);
         prePostModifierHandler.visit(ctx);
         List<PrePostModifier> modifiers = prePostModifierHandler.getPostMods();
         addModifierStatements(parser, modifiers);
      }

      public static void addPreModifiers(Pass1GenerateStatementSequence parser, ParserRuleContext ctx) {
         PrePostModifierHandler modifierHandler = new PrePostModifierHandler(parser);
         modifierHandler.visit(ctx);
         List<PrePostModifier> modifiers = modifierHandler.getPreMods();
         addModifierStatements(parser, modifiers);
      }

      private static void addModifierStatements(
            Pass1GenerateStatementSequence parser,
            List<PrePostModifier> modifiers) {
         for (PrePostModifier mod : modifiers) {
            Statement stmt = new StatementAssignment((LValue) mod.child, mod.operator, mod.child);
            parser.sequence.addStatement(stmt);
            parser.log.append("Adding pre/post-modifier "+stmt.getAsTypedString(parser.programScope));
         }
      }

      @Override
      public Void visitExprPostMod(KickCParser.ExprPostModContext ctx) {
         RValue child = (RValue) mainParser.visit(ctx.expr());
         String op = ((TerminalNode) ctx.getChild(1)).getSymbol().getText();
         Operator operator = new Operator(op);
         PrePostModifier modifier = new PrePostModifier(child, operator);
         postMods.add(modifier);
         return null;
      }

      @Override
      public Void visitExprPreMod(KickCParser.ExprPreModContext ctx) {
         RValue child = (RValue) mainParser.visit(ctx.expr());
         String op = ((TerminalNode) ctx.getChild(0)).getSymbol().getText();
         Operator operator = new Operator(op);
         PrePostModifier modifier = new PrePostModifier(child, operator);
         preMods.add(modifier);
         return null;
      }

      private static class PrePostModifier {
         public RValue child;
         public Operator operator;

         public PrePostModifier(RValue child, Operator operator) {
            this.child = child;
            this.operator = operator;
         }
      }

   }
}

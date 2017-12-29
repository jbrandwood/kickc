package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.Compiler;
import dk.camelot64.kickc.NumberParser;
import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.parser.KickCBaseVisitor;
import dk.camelot64.kickc.parser.KickCParser;
import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.tree.TerminalNode;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Stack;

/**
 * Generates program SSA form by visiting the ANTLR4 parse tree
 */
public class Pass0GenerateStatementSequence extends KickCBaseVisitor<Object> {

   private Program program;
   private Stack<Scope> scopeStack;
   private StatementSequence sequence;

   public Pass0GenerateStatementSequence(Program program) {
      this.program = program;
      this.scopeStack = new Stack<>();
      scopeStack.push(program.getScope());
      this.sequence = new StatementSequence();
   }

   private Scope getCurrentSymbols() {
      return scopeStack.peek();
   }

   private Procedure getCurrentProcedure() {
      for(Scope scope : scopeStack) {
         if(scope instanceof Procedure) {
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
      this.visit(ctx.importSeq());
      this.visit(ctx.declSeq());
      return null;
   }

   @Override
   public Object visitImportSeq(KickCParser.ImportSeqContext ctx) {
      for(KickCParser.ImportDeclContext importDeclContext : ctx.importDecl()) {
         this.visit(importDeclContext);
      }
      return null;
   }

   @Override
   public Object visitImportDecl(KickCParser.ImportDeclContext ctx) {
      String importName = ctx.STRING().getText();
      String importFileName = importName.substring(1, importName.length() - 1);
      program.getLog().append("Importing " + importFileName);
      Compiler.loadAndParseFile(importFileName, program, this);
      return null;
   }

   @Override
   public Object visitDeclSeq(KickCParser.DeclSeqContext ctx) {
      for(KickCParser.DeclContext declContext : ctx.decl()) {
         this.visit(declContext);
      }
      return null;
   }

   @Override
   public Object visitDeclMethod(KickCParser.DeclMethodContext ctx) {
      SymbolType type = (SymbolType) visit(ctx.typeDecl());
      String name = ctx.NAME().getText();
      Procedure procedure = getCurrentSymbols().addProcedure(name, type);
      scopeStack.push(procedure);
      Label procExit = procedure.addLabel(SymbolRef.PROCEXIT_BLOCK_NAME);
      VariableUnversioned returnVar = null;
      if(!SymbolType.VOID.equals(type)) {
         returnVar = procedure.addVariable("return", type);
      }
      List<Variable> parameterList = new ArrayList<>();
      if(ctx.parameterListDecl() != null) {
         parameterList = (List<Variable>) this.visit(ctx.parameterListDecl());
      }
      procedure.setParameters(parameterList);
      sequence.addStatement(new StatementProcedureBegin(procedure.getRef()));
      if(ctx.stmtSeq() != null) {
         this.visit(ctx.stmtSeq());
      }
      sequence.addStatement(new StatementLabel(procExit.getRef()));
      if(returnVar != null) {
         sequence.addStatement(new StatementAssignment(returnVar, returnVar));
      }
      VariableRef returnVarRef = null;
      if(returnVar != null) {
         returnVarRef = returnVar.getRef();
      }
      sequence.addStatement(new StatementReturn(returnVarRef));
      scopeStack.pop();
      sequence.addStatement(new StatementProcedureEnd(procedure.getRef()));
      return null;
   }

   @Override
   public List<Variable> visitParameterListDecl(KickCParser.ParameterListDeclContext ctx) {
      ArrayList<Variable> parameterDecls = new ArrayList<>();
      for(KickCParser.ParameterDeclContext parameterDeclCtx : ctx.parameterDecl()) {
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
   public Object visitDeclVariable(KickCParser.DeclVariableContext ctx) {
      this.visit(ctx.declVar());
      return null;
   }

   @Override
   public Object visitDeclVar(KickCParser.DeclVarContext ctx) {
      SymbolType type = (SymbolType) visit(ctx.typeDecl());
      String varName = ctx.NAME().getText();
      VariableUnversioned lValue = getCurrentSymbols().addVariable(varName, type);

      List<Directive> directives = new ArrayList<>();
      for(KickCParser.DirectivesContext directivesContext : ctx.directives()) {
         directives.addAll((Collection<? extends Directive>) this.visit(directivesContext));
      }
      for(Directive directive : directives) {
         if(directive instanceof DirectiveConst) {
            lValue.setDeclaredConstant(true);
         } else if(directive instanceof DirectiveAlign) {
            if(type instanceof SymbolTypeArray || type.equals(SymbolType.STRING)) {
               lValue.setDeclaredAlignment(((DirectiveAlign) directive).getAlignment());
            } else {
               throw new CompileError("Error! Cannot align variable that is not a string or an array " +lValue.toString(program));
            }
         } else {
            throw new CompileError("Unknown directive " + directive);
         }
      }
      // Array / String variables are implicitly constant
      if(type instanceof SymbolTypeArray || type.equals(SymbolType.STRING)) {
         lValue.setDeclaredConstant(true);
      }
      KickCParser.ExprContext initializer = ctx.expr();
      if(initializer != null) {
         addInitialAssignment(initializer, lValue);
      } else if(type instanceof SymbolTypeArray) {
         // Add an zero-array initializer
         SymbolTypeArray typeArray = (SymbolTypeArray) type;
         Integer size = typeArray.getSize();
         if(size == null) {
            throw new CompileError("Error! Cannot determine array size. " + lValue.toString(program));
         }
         Statement stmt = new StatementAssignment(lValue, new ConstantArrayFilled(typeArray.getElementType(), size));
         sequence.addStatement(stmt);
      }
      return null;
   }

   /** A declaration directive.*/
   private interface Directive {}

   @Override
   public List<Directive> visitDirectives(KickCParser.DirectivesContext ctx) {
      ArrayList<Directive> directives = new ArrayList<>();
      for(KickCParser.DirectiveContext directiveContext : ctx.directive()) {
         directives.add((Directive) this.visit(directiveContext));
      }
      return directives;
   }

   /** Variable declared constant. */
   private static class DirectiveConst implements Directive { }

   @Override
   public Directive visitDirectiveConst(KickCParser.DirectiveConstContext ctx) {
      return new DirectiveConst();
   }

   /** Variable memory alignment. */
   private static class DirectiveAlign implements Directive {
      private int alignment;

      public DirectiveAlign(int alignment) {
         this.alignment = alignment;
      }

      public int getAlignment() {
         return alignment;
      }
   }

   @Override
   public Directive visitDirectiveAlign(KickCParser.DirectiveAlignContext ctx) {
      Number alignment = NumberParser.parseLiteral(ctx.NUMBER().getText());
      return new DirectiveAlign(alignment.intValue());
   }

   @Override
   public Void visitStmtSeq(KickCParser.StmtSeqContext ctx) {
      for(int i = 0; i < ctx.getChildCount(); i++) {
         this.visit(ctx.stmt(i));
      }
      return null;
   }

   @Override
   public Void visitStmtBlock(KickCParser.StmtBlockContext ctx) {
      if(ctx.stmtSeq() != null) {
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
      VariableRef notExprVar = getCurrentSymbols().addVariableIntermediate().getRef();
      sequence.addStatement(new StatementAssignment(notExprVar, null, Operator.NOT, rValue));
      PrePostModifierHandler.addPostModifiers(this, ctx.expr());

      Label elseJumpLabel = getCurrentSymbols().addLabelIntermediate();
      Statement ifJmpStmt = new StatementConditionalJump(notExprVar, elseJumpLabel.getRef());
      sequence.addStatement(ifJmpStmt);
      this.visit(ctx.stmt(0));

      KickCParser.StmtContext elseStmt = ctx.stmt(1);
      if(elseStmt != null) {
         // There is an else statement - add the else part and any needed labels/jumps
         Label endJumpLabel = getCurrentSymbols().addLabelIntermediate();
         Statement endJmpStmt = new StatementJump(endJumpLabel.getRef());
         sequence.addStatement(endJmpStmt);
         StatementLabel elseJumpTarget = new StatementLabel(elseJumpLabel.getRef());
         sequence.addStatement(elseJumpTarget);
         this.visit(elseStmt);
         StatementLabel endJumpTarget = new StatementLabel(endJumpLabel.getRef());
         sequence.addStatement(endJumpTarget);
      } else {
         // No else statement - just add the label
         StatementLabel elseJumpTarget = new StatementLabel(elseJumpLabel.getRef());
         sequence.addStatement(elseJumpTarget);
      }
      return null;
   }

   @Override
   public Void visitStmtWhile(KickCParser.StmtWhileContext ctx) {
      Label beginJumpLabel = getCurrentSymbols().addLabelIntermediate();
      Label doJumpLabel = getCurrentSymbols().addLabelIntermediate();
      Label endJumpLabel = getCurrentSymbols().addLabelIntermediate();
      StatementLabel beginJumpTarget = new StatementLabel(beginJumpLabel.getRef());
      sequence.addStatement(beginJumpTarget);
      PrePostModifierHandler.addPreModifiers(this, ctx.expr());
      RValue rValue = (RValue) this.visit(ctx.expr());
      PrePostModifierHandler.addPostModifiers(this, ctx.expr());
      Statement doJmpStmt = new StatementConditionalJump(rValue, doJumpLabel.getRef());
      sequence.addStatement(doJmpStmt);
      Statement endJmpStmt = new StatementJump(endJumpLabel.getRef());
      sequence.addStatement(endJmpStmt);
      StatementLabel doJumpTarget = new StatementLabel(doJumpLabel.getRef());
      sequence.addStatement(doJumpTarget);
      this.visit(ctx.stmt());
      Statement beginJmpStmt = new StatementJump(beginJumpLabel.getRef());
      sequence.addStatement(beginJmpStmt);
      StatementLabel endJumpTarget = new StatementLabel(endJumpLabel.getRef());
      sequence.addStatement(endJumpTarget);
      return null;
   }

   @Override
   public Void visitStmtDoWhile(KickCParser.StmtDoWhileContext ctx) {
      Label beginJumpLabel = getCurrentSymbols().addLabelIntermediate();
      StatementLabel beginJumpTarget = new StatementLabel(beginJumpLabel.getRef());
      sequence.addStatement(beginJumpTarget);
      if(ctx.stmt() != null) {
         this.visit(ctx.stmt());
      }
      PrePostModifierHandler.addPreModifiers(this, ctx.expr());
      RValue rValue = (RValue) this.visit(ctx.expr());
      PrePostModifierHandler.addPostModifiers(this, ctx.expr());
      Statement doJmpStmt = new StatementConditionalJump(rValue, beginJumpLabel.getRef());
      sequence.addStatement(doJmpStmt);
      return null;
   }

   @Override
   public Object visitStmtFor(KickCParser.StmtForContext ctx) {
      this.visit(ctx.forIteration());
      return null;
   }

   @Override
   public Object visitForDecl(KickCParser.ForDeclContext ctx) {
      return super.visitForDecl(ctx);
   }

   @Override
   public Object visitForClassic(KickCParser.ForClassicContext ctx) {
      KickCParser.StmtForContext stmtForCtx = (KickCParser.StmtForContext) ctx.getParent();
      KickCParser.ForDeclContext forDeclCtx = (KickCParser.ForDeclContext) stmtForCtx.forDeclaration();
      // Create and assign declared loop variable
      String varName = forDeclCtx.NAME().getText();
      Variable lValue;
      if(forDeclCtx.typeDecl() != null) {
         SymbolType type = (SymbolType) visit(forDeclCtx.typeDecl());
         lValue = getCurrentSymbols().addVariable(varName, type);
      } else {
         lValue = getCurrentSymbols().getVariable(varName);
      }
      KickCParser.ExprContext initializer = forDeclCtx.expr();
      if(initializer != null) {
         addInitialAssignment(initializer, lValue);
      }
      // Add label
      Label repeatLabel = getCurrentSymbols().addLabelIntermediate();
      StatementLabel repeatTarget = new StatementLabel(repeatLabel.getRef());
      sequence.addStatement(repeatTarget);
      // Add body
      if(stmtForCtx.stmt() != null) {
         this.visit(stmtForCtx.stmt());
      }
      // Add increment
      if(ctx.expr(1) != null) {
         PrePostModifierHandler.addPreModifiers(this, ctx.expr(1));
         this.visit(ctx.expr(1));
         PrePostModifierHandler.addPostModifiers(this, ctx.expr(1));
      }
      // Add condition
      PrePostModifierHandler.addPreModifiers(this, ctx.expr(0));
      RValue rValue = (RValue) this.visit(ctx.expr(0));
      PrePostModifierHandler.addPostModifiers(this, ctx.expr(0));
      // Add jump if condition was met
      Statement doJmpStmt = new StatementConditionalJump(rValue, repeatLabel.getRef());
      sequence.addStatement(doJmpStmt);
      return null;
   }

   @Override
   public Object visitForRange(KickCParser.ForRangeContext ctx) {
      KickCParser.StmtForContext stmtForCtx = (KickCParser.StmtForContext) ctx.getParent();
      KickCParser.ForDeclContext forDeclCtx = (KickCParser.ForDeclContext) stmtForCtx.forDeclaration();
      // Create declared loop variable
      String varName = forDeclCtx.NAME().getText();
      Variable lValue;
      if(forDeclCtx.typeDecl() != null) {
         SymbolType type = (SymbolType) visit(forDeclCtx.typeDecl());
         lValue = getCurrentSymbols().addVariable(varName, type);
      } else {
         lValue = getCurrentSymbols().getVariable(varName);
      }
      KickCParser.ExprContext rangeFirstCtx = ctx.expr(0);
      KickCParser.ExprContext rangeLastCtx = ctx.expr(1);
      // Find the iteration first/last & direction by evaluating first/last as constants
      ConstantInteger rangeFirst = (ConstantInteger) ParseTreeConstantEvaluator.evaluate(rangeFirstCtx);
      ConstantInteger rangeLast = (ConstantInteger) ParseTreeConstantEvaluator.evaluate(rangeLastCtx);
      // Assign loop variable with first value
      RValue rValue = (RValue) visit(rangeFirstCtx);
      Statement stmtInit = new StatementAssignment(lValue, rValue);
      sequence.addStatement(stmtInit);
      // Add label
      Label repeatLabel = getCurrentSymbols().addLabelIntermediate();
      StatementLabel repeatTarget = new StatementLabel(repeatLabel.getRef());
      sequence.addStatement(repeatTarget);
      // Add body
      if(stmtForCtx.stmt() != null) {
         this.visit(stmtForCtx.stmt());
      }
      // Add increment
      ConstantInteger beyondLastVal;
      if(rangeFirst.getNumber() > rangeLast.getNumber()) {
         Statement stmtInc = new StatementAssignment(lValue.getRef(), Operator.DECREMENT, lValue.getRef());
         sequence.addStatement(stmtInc);
         if(rangeLast.getNumber() == 0) {
            beyondLastVal = new ConstantInteger(255);
         } else {
            beyondLastVal = new ConstantInteger(rangeLast.getNumber() - 1);
         }
      } else {
         Statement stmtInc = new StatementAssignment(lValue.getRef(), Operator.INCREMENT, lValue.getRef());
         sequence.addStatement(stmtInc);
         if(rangeLast.getNumber() == 255) {
            beyondLastVal = new ConstantInteger(0);
         } else {
            beyondLastVal = new ConstantInteger(rangeLast.getNumber() + 1);
         }
      }

      // Add condition i<last+1 or i<last-1
      VariableIntermediate tmpVar = getCurrentSymbols().addVariableIntermediate();
      VariableRef tmpVarRef = tmpVar.getRef();
      Statement stmtTmpVar = new StatementAssignment(tmpVarRef, lValue.getRef(), Operator.NEQ, beyondLastVal);
      sequence.addStatement(stmtTmpVar);
      // Add jump if condition was met
      Statement doJmpStmt = new StatementConditionalJump(tmpVarRef, repeatLabel.getRef());
      sequence.addStatement(doJmpStmt);
      return null;
   }


   @Override
   public Object visitStmtAsm(KickCParser.StmtAsmContext ctx) {
      sequence.addStatement(new StatementAsm(ctx.asmLines()));
      return null;
   }

   @Override
   public Void visitStmtReturn(KickCParser.StmtReturnContext ctx) {
      Procedure procedure = getCurrentProcedure();
      KickCParser.ExprContext exprCtx = ctx.expr();
      RValue rValue;
      if(exprCtx != null) {
         PrePostModifierHandler.addPreModifiers(this, exprCtx);
         rValue = (RValue) this.visit(exprCtx);
         Variable returnVar = procedure.getVariable("return");
         sequence.addStatement(new StatementAssignment(returnVar, rValue));
         PrePostModifierHandler.addPostModifiers(this, exprCtx);
      }
      Label returnLabel = procedure.getLabel(SymbolRef.PROCEXIT_BLOCK_NAME);
      sequence.addStatement(new StatementJump(returnLabel.getRef()));
      return null;
   }

   @Override
   public Object visitStmtDeclVar(KickCParser.StmtDeclVarContext ctx) {
      this.visit(ctx.declVar());
      return null;
   }

   private void addInitialAssignment(KickCParser.ExprContext initializer, Variable lValue) {
      PrePostModifierHandler.addPreModifiers(this, initializer);
      RValue rValue = (RValue) visit(initializer);
      Statement stmt = new StatementAssignment(lValue, rValue);
      sequence.addStatement(stmt);
      PrePostModifierHandler.addPostModifiers(this, initializer);
   }

   @Override
   public RValue visitInitList(KickCParser.InitListContext ctx) {
      List<RValue> initValues = new ArrayList<>();
      for(KickCParser.ExprContext initializer : ctx.expr()) {
         RValue rValue = (RValue) visit(initializer);
         initValues.add(rValue);
      }
      return new ValueList(initValues);
   }

   @Override
   public SymbolType visitTypeSimple(KickCParser.TypeSimpleContext ctx) {
      return SymbolType.get(ctx.getText());
   }

   @Override
   public SymbolType visitTypeSignedSimple(KickCParser.TypeSignedSimpleContext ctx) {
      return SymbolType.get("signed " + ctx.SIMPLETYPE().getText());
   }

   @Override
   public SymbolType visitTypePtr(KickCParser.TypePtrContext ctx) {
      SymbolType elementType = (SymbolType) visit(ctx.typeDecl());
      return new SymbolTypePointer(elementType);
   }

   @Override
   public SymbolType visitTypeArray(KickCParser.TypeArrayContext ctx) {
      SymbolType elementType = (SymbolType) visit(ctx.typeDecl());
      if(ctx.expr() != null) {
         ConstantValue size = ParseTreeConstantEvaluator.evaluate(ctx.expr());
         if(size instanceof ConstantInteger) {
            return new SymbolTypeArray(elementType, ((ConstantInteger) size).getNumber());
         } else {
            throw new RuntimeException("Array size not a constant integer " + ctx.getText());
         }
      } else {
         return new SymbolTypeArray(elementType);
      }
   }

   @Override
   public Object visitExprAssignment(KickCParser.ExprAssignmentContext ctx) {
      LValue lValue = (LValue) visit(ctx.expr(0));
      if(lValue instanceof VariableRef && ((VariableRef) lValue).isIntermediate()) {
         // Encountered an intermediate variable. This must be turned into a proper LValue later. Put it into a marker to signify that
         lValue = new LvalueIntermediate((VariableRef) lValue);
      }
      RValue rValue = (RValue) this.visit(ctx.expr(1));
      Statement stmt = new StatementAssignment(lValue, rValue);
      sequence.addStatement(stmt);
      return lValue;
   }

   @Override
   public RValue visitExprCast(KickCParser.ExprCastContext ctx) {
      RValue child = (RValue) this.visit(ctx.expr());
      SymbolType castType = (SymbolType) this.visit(ctx.typeDecl());
      Operator operator = Operator.getCastUnary(castType);
      VariableIntermediate tmpVar = getCurrentSymbols().addVariableIntermediate();
      VariableRef tmpVarRef = tmpVar.getRef();
      Statement stmt = new StatementAssignment(tmpVarRef, operator, child);
      sequence.addStatement(stmt);
      return tmpVarRef;
   }

   @Override
   public Object visitExprCall(KickCParser.ExprCallContext ctx) {
      List<RValue> parameters;
      KickCParser.ParameterListContext parameterList = ctx.parameterList();
      if(parameterList != null) {
         parameters = (List<RValue>) this.visit(parameterList);
      } else {
         parameters = new ArrayList<>();
      }
      VariableIntermediate tmpVar = getCurrentSymbols().addVariableIntermediate();
      VariableRef tmpVarRef = tmpVar.getRef();
      sequence.addStatement(new StatementCall(tmpVarRef, ctx.NAME().getText(), parameters));
      return tmpVarRef;
   }

   @Override
   public List<RValue> visitParameterList(KickCParser.ParameterListContext ctx) {
      List<RValue> parameters = new ArrayList<>();
      for(KickCParser.ExprContext exprContext : ctx.expr()) {
         RValue param = (RValue) this.visit(exprContext);
         parameters.add(param);
      }
      return parameters;
   }

   @Override
   public RValue visitExprArray(KickCParser.ExprArrayContext ctx) {
      RValue array = (LValue) visit(ctx.expr(0));
      RValue index = (RValue) visit(ctx.expr(1));
      return new PointerDereferenceIndexed(array, index);
   }

   @Override
   public RValue visitExprNumber(KickCParser.ExprNumberContext ctx) {
      Number number = NumberParser.parseLiteral(ctx.getText());
      if(number instanceof Integer) {
         return new ConstantInteger((Integer) number);
      } else {
         return new ConstantDouble((Double) number);
      }
   }

   @Override
   public RValue visitExprString(KickCParser.ExprStringContext ctx) {
      String text = ctx.getText();
      return new ConstantString(text.substring(1, text.length() - 1));
   }

   @Override
   public RValue visitExprBool(KickCParser.ExprBoolContext ctx) {
      String bool = ctx.getText();
      return new ConstantBool(Boolean.valueOf(bool));
   }

   @Override
   public Object visitExprChar(KickCParser.ExprCharContext ctx) {
      return new ConstantChar(ctx.getText().charAt(1));
   }

   @Override
   public RValue visitExprBinary(KickCParser.ExprBinaryContext ctx) {
      RValue left = (RValue) this.visit(ctx.expr(0));
      RValue right = (RValue) this.visit(ctx.expr(1));
      String op = ((TerminalNode) ctx.getChild(1)).getSymbol().getText();
      Operator operator = Operator.getBinary(op);
      VariableIntermediate tmpVar = getCurrentSymbols().addVariableIntermediate();
      VariableRef tmpVarRef = tmpVar.getRef();
      Statement stmt = new StatementAssignment(tmpVarRef, left, operator, right);
      sequence.addStatement(stmt);
      return tmpVarRef;
   }

   @Override
   public Object visitExprPtr(KickCParser.ExprPtrContext ctx) {
      RValue child = (RValue) this.visit(ctx.expr());
      return new PointerDereferenceSimple(child);
   }

   @Override
   public RValue visitExprUnary(KickCParser.ExprUnaryContext ctx) {
      RValue child = (RValue) this.visit(ctx.expr());
      String op = ((TerminalNode) ctx.getChild(0)).getSymbol().getText();
      Operator operator = Operator.getUnary(op);
      VariableIntermediate tmpVar = getCurrentSymbols().addVariableIntermediate();
      VariableRef tmpVarRef = tmpVar.getRef();
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
      if(variable == null) {
         program.getLog().append("ERROR! Line " + ctx.getStart().getLine() + ". Unknown variable " + ctx.NAME().getText());
         throw new CompileError("ERROR! Line " + ctx.getStart().getLine() + ". Unknown variable " + ctx.NAME().getText());
      }
      return variable.getRef();
   }

   public StatementSequence getSequence() {
      return sequence;
   }

   private static class PrePostModifierHandler extends KickCBaseVisitor<Void> {

      private List<PrePostModifier> postMods;
      private List<PrePostModifier> preMods;
      private Pass0GenerateStatementSequence mainParser;

      public PrePostModifierHandler(Pass0GenerateStatementSequence mainParser) {
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

      public static void addPostModifiers(Pass0GenerateStatementSequence parser, ParserRuleContext ctx) {
         PrePostModifierHandler prePostModifierHandler = new PrePostModifierHandler(parser);
         prePostModifierHandler.visit(ctx);
         List<PrePostModifier> modifiers = prePostModifierHandler.getPostMods();
         addModifierStatements(parser, modifiers);
      }

      public static void addPreModifiers(Pass0GenerateStatementSequence parser, ParserRuleContext ctx) {
         PrePostModifierHandler modifierHandler = new PrePostModifierHandler(parser);
         modifierHandler.visit(ctx);
         List<PrePostModifier> modifiers = modifierHandler.getPreMods();
         addModifierStatements(parser, modifiers);
      }

      private static void addModifierStatements(
            Pass0GenerateStatementSequence parser,
            List<PrePostModifier> modifiers) {
         for(PrePostModifier mod : modifiers) {
            Statement stmt = new StatementAssignment((LValue) mod.child, mod.operator, mod.child);
            parser.sequence.addStatement(stmt);
            parser.program.getLog().append("Adding pre/post-modifier " + stmt.toString(parser.program, true));
         }
      }

      @Override
      public Void visitExprPostMod(KickCParser.ExprPostModContext ctx) {
         RValue child = (RValue) mainParser.visit(ctx.expr());
         String op = ((TerminalNode) ctx.getChild(1)).getSymbol().getText();
         Operator operator = Operator.getUnary(op);
         PrePostModifier modifier = new PrePostModifier(child, operator);
         postMods.add(modifier);
         return null;
      }

      @Override
      public Void visitExprPreMod(KickCParser.ExprPreModContext ctx) {
         RValue child = (RValue) mainParser.visit(ctx.expr());
         String op = ((TerminalNode) ctx.getChild(0)).getSymbol().getText();
         Operator operator = Operator.getUnary(op);
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

package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.Compiler;
import dk.camelot64.kickc.NumberParser;
import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.operators.Operator;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.symbols.*;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeArray;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.types.SymbolTypeProcedure;
import dk.camelot64.kickc.model.values.*;
import dk.camelot64.kickc.parser.KickCBaseVisitor;
import dk.camelot64.kickc.parser.KickCParser;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.tree.TerminalNode;

import java.io.File;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Stack;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Generates program SSA form by visiting the ANTLR4 parse tree
 */
public class Pass0GenerateStatementSequence extends KickCBaseVisitor<Object> {

   /** The source file currently being parsed. */
   private File file;
   /** The source ANTLR parse tree of the source file. */
   private KickCParser.FileContext fileCtx;
   /** The source ANTLR Token Stream (used for finding comments in the lexer input.) */
   private CommonTokenStream tokenStream;

   /** The program containing all compile structures. */
   private Program program;
   /** Used to build the statements of the source file. */
   private StatementSequence sequence;
   /** Used to build the scopes of the source file. */
   private Stack<Scope> scopeStack;

   public Pass0GenerateStatementSequence(File file, CommonTokenStream tokenStream, KickCParser.FileContext fileCtx, Program program) {
      this.file = file;
      this.tokenStream = tokenStream;
      this.fileCtx = fileCtx;
      this.program = program;
      this.sequence = program.getStatementSequence();
      this.scopeStack = new Stack<>();
      scopeStack.push(program.getScope());
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

   public void generate() {
      this.visit(fileCtx);
   }

   @Override
   public Void visitFile(KickCParser.FileContext ctx) {
      if(program.getFileComments()==null) {
         // Only set program file level comments for the first file.
         program.setFileComments(ensureUnusedComments(getCommentsFile(ctx)));
      }
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
      if(program.getLog().isVerboseParse()) {
         program.getLog().append("Importing " + importFileName);
      }
      Path currentPath = file.toPath().getParent();
      Compiler.loadAndParseFile(importFileName, program, currentPath);
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
   public Object visitDeclFunction(KickCParser.DeclFunctionContext ctx) {
      SymbolType type = (SymbolType) visit(ctx.typeDecl());
      String name = ctx.NAME().getText();
      Procedure procedure = getCurrentSymbols().addProcedure(name, type);
      addDirectives(procedure, ctx.directive());
      procedure.setComments(ensureUnusedComments(getCommentsSymbol(ctx)));
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
      sequence.addStatement(new StatementProcedureBegin(procedure.getRef(), new StatementSource(ctx), Comment.NO_COMMENTS));
      if(ctx.stmtSeq() != null) {
         this.visit(ctx.stmtSeq());
      }
      sequence.addStatement(new StatementLabel(procExit.getRef(), new StatementSource(ctx), Comment.NO_COMMENTS));
      if(returnVar != null) {
         sequence.addStatement(new StatementAssignment(returnVar.getRef(), returnVar.getRef(), new StatementSource(ctx), Comment.NO_COMMENTS));
      }
      VariableRef returnVarRef = null;
      if(returnVar != null) {
         returnVarRef = returnVar.getRef();
      }
      sequence.addStatement(new StatementReturn(returnVarRef, new StatementSource(ctx), Comment.NO_COMMENTS));
      scopeStack.pop();
      sequence.addStatement(new StatementProcedureEnd(procedure.getRef(), new StatementSource(ctx), Comment.NO_COMMENTS));
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
      // Add directives
      addDirectives(type, param, ctx.directive());
      return param;
   }

   @Override
   public Object visitDeclKasm(KickCParser.DeclKasmContext ctx) {
      String kasm = ctx.KICKASM().getText();
      Pattern p = Pattern.compile("\\{\\{[\\s]*(.*)[\\s]*\\}\\}", Pattern.DOTALL);
      Matcher m = p.matcher(kasm);
      if(m.find()) {
         String kickAsmCode = m.group(1).replaceAll("\r", "");
         StatementKickAsm statementKickAsm = new StatementKickAsm(kickAsmCode, new StatementSource(ctx), ensureUnusedComments(getCommentsSymbol(ctx)));
         if(ctx.kasmDirectives() != null) {
            List<KasmDirective> kasmDirectives = this.visitKasmDirectives(ctx.kasmDirectives());
            for(KasmDirective kasmDirective : kasmDirectives) {
               if(kasmDirective instanceof KasmDirectiveLocation) {
                  statementKickAsm.setLocation(((KasmDirectiveLocation) kasmDirective).getAddress());
               } else if(kasmDirective instanceof KasmDirectiveBytes) {
                  statementKickAsm.setBytes(((KasmDirectiveBytes) kasmDirective).getBytes());
               } else if(kasmDirective instanceof KasmDirectiveCycles) {
                  statementKickAsm.setCycles(((KasmDirectiveCycles) kasmDirective).getCycles());
               }
            }
         }
         sequence.addStatement(statementKickAsm);
      }
      return null;
   }

   private interface KasmDirective {
   }

   @Override
   public List<KasmDirective> visitKasmDirectives(KickCParser.KasmDirectivesContext ctx) {
      ArrayList<KasmDirective> kasmDirectives = new ArrayList<>();
      List<KickCParser.KasmDirectiveContext> params = ctx.kasmDirective();
      for(KickCParser.KasmDirectiveContext param : params) {
         KasmDirective directive = (KasmDirective) visit(param);
         if(directive != null) {
            kasmDirectives.add(directive);
         }
      }
      return kasmDirectives;
   }

   /** KickAssembler directive specifying an absolute address for the generated code/data. */
   public static class KasmDirectiveLocation implements KasmDirective {
      /** will contain the address to generate the KickAssembler-code to. */
      private RValue address;

      public KasmDirectiveLocation(RValue address) {
         this.address = address;
      }

      public RValue getAddress() {
         return address;
      }

   }

   @Override
   public Object visitKasmDirectiveAddress(KickCParser.KasmDirectiveAddressContext ctx) {
      if(ctx.expr() != null) {
         RValue expr = (RValue) visit(ctx.expr());
         return new KasmDirectiveLocation(expr);
      } else {
         // PLace inline
         return null;
      }
   }

   /** KickAssembler directive specifying the number of bytes for generated code/data. */
   public static class KasmDirectiveBytes implements KasmDirective {
      /** bytes for the KickAssembler-code. */
      private RValue bytes;

      public KasmDirectiveBytes(RValue bytes) {
         this.bytes = bytes;
      }

      public RValue getBytes() {
         return bytes;
      }
   }

   @Override
   public KasmDirective visitKasmDirectiveBytes(KickCParser.KasmDirectiveBytesContext ctx) {
      if(ctx.expr() != null) {
         RValue bytes = (RValue) this.visit(ctx.expr());
         return new KasmDirectiveBytes(bytes);
      } else {
         return null;
      }
   }

   /** KickAssembler directive specifying the number of cycles for generated code/data. */
   public static class KasmDirectiveCycles implements KasmDirective {
      /** cycles for the KickAssembler-code. */
      private RValue cycles;

      public KasmDirectiveCycles(RValue cycles) {
         this.cycles = cycles;
      }

      public RValue getCycles() {
         return cycles;
      }
   }

   @Override
   public KasmDirective visitKasmDirectiveCycles(KickCParser.KasmDirectiveCyclesContext ctx) {
      if(ctx.expr() != null) {
         RValue cycles = (RValue) this.visit(ctx.expr());
         return new KasmDirectiveCycles(cycles);
      } else {
         return null;
      }
   }

   @Override
   public Object visitKasmDirectiveResource(KickCParser.KasmDirectiveResourceContext ctx) {
      TerminalNode resource = ctx.STRING();
      String resourceName = resource.getText();
      resourceName = resourceName.substring(1, resourceName.length() - 1);
      Path currentPath = file.toPath().getParent();
      File resourceFile = Compiler.loadFile(resourceName, currentPath, program);
      program.addAsmResourceFile(resourceFile.toPath());
      if(program.getLog().isVerboseParse()) {
         program.getLog().append("Added resource " + resourceFile.getPath().replace('\\', '/'));
      }
      return null;
   }

   @Override
   public Object visitDeclVariable(KickCParser.DeclVariableContext ctx) {
      SymbolType type = (SymbolType) visit(ctx.typeDecl());
      String varName = ctx.NAME().getText();
      VariableUnversioned lValue = getCurrentSymbols().addVariable(varName, type);
      // Add directives
      addDirectives(type, lValue, ctx.directive());
      // Array / String variables are implicitly constant
      if(type instanceof SymbolTypeArray || type.equals(SymbolType.STRING)) {
         lValue.setDeclaredConstant(true);
      }
      List<Comment> comments = getCommentsSymbol(ctx);
      if(lValue.isDeclaredConstant()) {
         // Add comments to constant
         lValue.setComments(ensureUnusedComments(comments));
      }
      KickCParser.ExprContext initializer = ctx.expr();
      if(initializer != null) {
         addInitialAssignment(initializer, lValue, comments);
      } else if(type instanceof SymbolTypeArray) {
         // Add an zero-array initializer
         SymbolTypeArray typeArray = (SymbolTypeArray) type;
         RValue size = typeArray.getSize();
         if(size == null) {
            throw new CompileError("Error! Array has no declared size. " + lValue.toString(program), new StatementSource(ctx));
         }
         Statement stmt = new StatementAssignment(lValue.getRef(), new ArrayFilled(typeArray.getElementType(), size), new StatementSource(ctx), ensureUnusedComments(comments));
         sequence.addStatement(stmt);
      }
      return null;
   }

   /**
    * Add declared directives to an lValue (typically a variable).
    *
    * @param type The type of the lValue
    * @param lValue The lValue
    * @param directivesCtx The directives to add
    */
   private void addDirectives(SymbolType type, SymbolVariable lValue, List<KickCParser.DirectiveContext> directivesCtx) {
      List<Directive> directives = new ArrayList<>();
      for(KickCParser.DirectiveContext directiveContext : directivesCtx) {
         directives.add((Directive) this.visit(directiveContext));
      }
      for(Directive directive : directives) {
         StatementSource source = new StatementSource(directivesCtx.get(0));
         if(directive instanceof DirectiveConst) {
            lValue.setDeclaredConstant(true);
         } else if(directive instanceof DirectiveVolatile) {
            lValue.setDeclaredVolatile(true);
         } else if(directive instanceof DirectiveAlign) {
            if(type instanceof SymbolTypeArray || type.equals(SymbolType.STRING)) {
               lValue.setDeclaredAlignment(((DirectiveAlign) directive).getAlignment());
            } else {
               throw new CompileError("Error! Cannot align variable that is not a string or an array " + lValue.toString(program), source);
            }
         } else if(directive instanceof DirectiveRegister) {
            DirectiveRegister directiveRegister = (DirectiveRegister) directive;
            Registers.Register register = Registers.getRegister(directiveRegister.getName());
            if(register == null) {
               throw new CompileError("Error! Unknown register " + directiveRegister.getName(), source);
            }
            lValue.setDeclaredRegister(register);
         } else {
            throw new CompileError("Unsupported variable directive " + directive, source);
         }
      }
   }

   /**
    * Add declared directives to a procedure.
    *
    * @param procedure The procedure
    * @param directivesCtx The directives to add
    */
   private void addDirectives(Procedure procedure, List<KickCParser.DirectiveContext> directivesCtx) {
      List<Directive> directives = new ArrayList<>();
      for(KickCParser.DirectiveContext directiveContext : directivesCtx) {
         directives.add((Directive) this.visit(directiveContext));
      }
      for(Directive directive : directives) {
         StatementSource source = new StatementSource(directivesCtx.get(0));
         if(directive instanceof DirectiveInline) {
            procedure.setDeclaredInline(true);
         } else if(directive instanceof DirectiveInterrupt) {
            procedure.setInterruptType(((DirectiveInterrupt) directive).interruptType);
         } else {
            throw new CompileError("Unsupported function directive " + directive, source);
         }
      }
   }

   /**
    * Add declared directives to a conditional jump (as part of a loop).
    *
    * @param conditional The loop conditional
    * @param directivesCtx The directives to add
    */
   private void addDirectives(StatementConditionalJump conditional, List<KickCParser.DirectiveContext> directivesCtx) {
      List<Directive> directives = new ArrayList<>();
      for(KickCParser.DirectiveContext directiveContext : directivesCtx) {
         directives.add((Directive) this.visit(directiveContext));
      }
      for(Directive directive : directives) {
         StatementSource source = new StatementSource(directivesCtx.get(0));
         if(directive instanceof DirectiveInline) {
            conditional.setDeclaredUnroll(true);
         } else {
            throw new CompileError("Unsupported loop directive " + directive, source);
         }
      }
   }


   @Override
   public Directive visitDirectiveConst(KickCParser.DirectiveConstContext ctx) {
      return new DirectiveConst();
   }

   @Override
   public Object visitDirectiveInline(KickCParser.DirectiveInlineContext ctx) {
      return new DirectiveInline();
   }

   @Override
   public Object visitDirectiveInterrupt(KickCParser.DirectiveInterruptContext ctx) {
      String interruptType;
      if(ctx.getChildCount() > 1) {
         interruptType = ctx.getChild(2).getText().toUpperCase();
      } else {
         // The default interrupt type
         interruptType = Procedure.InterruptType.DEFAULT.name();
      }
      Procedure.InterruptType type = Procedure.InterruptType.valueOf(interruptType);
      return new DirectiveInterrupt(type);
   }

   @Override
   public Directive visitDirectiveAlign(KickCParser.DirectiveAlignContext ctx) {
      Number alignment = NumberParser.parseLiteral(ctx.NUMBER().getText());
      return new DirectiveAlign(alignment.intValue());
   }

   @Override
   public Directive visitDirectiveRegister(KickCParser.DirectiveRegisterContext ctx) {
      String name = ctx.NAME().getText();
      return new DirectiveRegister(name);
   }

   @Override
   public Directive visitDirectiveVolatile(KickCParser.DirectiveVolatileContext ctx) {
      return new DirectiveVolatile();
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
      KickCParser.StmtContext ifStmt = ctx.stmt(0);
      KickCParser.StmtContext elseStmt = ctx.stmt(1);

      PrePostModifierHandler.addPreModifiers(this, ctx.expr());
      RValue rValue = (RValue) this.visit(ctx.expr());

      List<Comment> comments = ensureUnusedComments(getCommentsSymbol(ctx));

      if(elseStmt == null) {
         // If without else - skip the entire section if condition not met
         VariableRef notExprVar = getCurrentSymbols().addVariableIntermediate().getRef();
         sequence.addStatement(new StatementAssignment(notExprVar, null, Operators.LOGIC_NOT, rValue, new StatementSource(ctx), comments));
         PrePostModifierHandler.addPostModifiers(this, ctx.expr());
         Label endJumpLabel = getCurrentSymbols().addLabelIntermediate();
         sequence.addStatement(new StatementConditionalJump(notExprVar, endJumpLabel.getRef(), new StatementSource(ctx), Comment.NO_COMMENTS));
         this.visit(ifStmt);
         // No else statement - just add the label
         sequence.addStatement(new StatementLabel(endJumpLabel.getRef(), new StatementSource(ctx), Comment.NO_COMMENTS));
      } else {
         // If with else - jump to if section if condition met - fall into else otherwise.
         PrePostModifierHandler.addPostModifiers(this, ctx.expr());
         Label ifJumpLabel = getCurrentSymbols().addLabelIntermediate();
         sequence.addStatement(new StatementConditionalJump(rValue, ifJumpLabel.getRef(), new StatementSource(ctx), comments));
         // Add else body
         this.visit(elseStmt);
         // There is an else statement - add the if part and any needed labels/jumps
         Label endJumpLabel = getCurrentSymbols().addLabelIntermediate();
         sequence.addStatement(new StatementJump(endJumpLabel.getRef(), new StatementSource(ctx), Comment.NO_COMMENTS));
         sequence.addStatement(new StatementLabel(ifJumpLabel.getRef(), new StatementSource(ctx), Comment.NO_COMMENTS));
         this.visit(ifStmt);
         StatementLabel endJumpTarget = new StatementLabel(endJumpLabel.getRef(), new StatementSource(ctx), Comment.NO_COMMENTS);
         sequence.addStatement(endJumpTarget);
      }
      return null;
   }

   @Override
   public Void visitStmtWhile(KickCParser.StmtWhileContext ctx) {
      Label beginJumpLabel = getCurrentSymbols().addLabelIntermediate();
      Label doJumpLabel = getCurrentSymbols().addLabelIntermediate();
      Label endJumpLabel = getCurrentSymbols().addLabelIntermediate();
      List<Comment> comments = ensureUnusedComments(getCommentsSymbol(ctx));
      StatementLabel beginJumpTarget = new StatementLabel(beginJumpLabel.getRef(), new StatementSource(ctx),comments);
      sequence.addStatement(beginJumpTarget);
      PrePostModifierHandler.addPreModifiers(this, ctx.expr());
      RValue rValue = (RValue) this.visit(ctx.expr());
      PrePostModifierHandler.addPostModifiers(this, ctx.expr());
      StatementConditionalJump doJmpStmt = new StatementConditionalJump(rValue, doJumpLabel.getRef(), new StatementSource(ctx), Comment.NO_COMMENTS);
      sequence.addStatement(doJmpStmt);
      Statement endJmpStmt = new StatementJump(endJumpLabel.getRef(), new StatementSource(ctx), Comment.NO_COMMENTS);
      sequence.addStatement(endJmpStmt);
      StatementLabel doJumpTarget = new StatementLabel(doJumpLabel.getRef(), new StatementSource(ctx), Comment.NO_COMMENTS);
      sequence.addStatement(doJumpTarget);
      this.visit(ctx.stmt());
      Statement beginJmpStmt = new StatementJump(beginJumpLabel.getRef(), new StatementSource(ctx), Comment.NO_COMMENTS);
      sequence.addStatement(beginJmpStmt);
      StatementLabel endJumpTarget = new StatementLabel(endJumpLabel.getRef(), new StatementSource(ctx), Comment.NO_COMMENTS);
      sequence.addStatement(endJumpTarget);

      // Add directives
      addDirectives(doJmpStmt, ctx.directive());
      return null;
   }

   @Override
   public Void visitStmtDoWhile(KickCParser.StmtDoWhileContext ctx) {
      List<Comment> comments = ensureUnusedComments(getCommentsSymbol(ctx));
      Label beginJumpLabel = getCurrentSymbols().addLabelIntermediate();
      StatementLabel beginJumpTarget = new StatementLabel(beginJumpLabel.getRef(), new StatementSource(ctx), comments);
      sequence.addStatement(beginJumpTarget);
      if(ctx.stmt() != null) {
         this.visit(ctx.stmt());
      }
      PrePostModifierHandler.addPreModifiers(this, ctx.expr());
      RValue rValue = (RValue) this.visit(ctx.expr());
      PrePostModifierHandler.addPostModifiers(this, ctx.expr());
      StatementConditionalJump doJmpStmt = new StatementConditionalJump(rValue, beginJumpLabel.getRef(), new StatementSource(ctx), Comment.NO_COMMENTS);
      sequence.addStatement(doJmpStmt);
      addDirectives(doJmpStmt, ctx.directive());
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
      Variable lValue = getForVariable(forDeclCtx);
      KickCParser.ExprContext initializer = forDeclCtx.expr();
      if(initializer != null) {
         addInitialAssignment(initializer, lValue, Comment.NO_COMMENTS);
      }
      // Add label
      Label repeatLabel = getCurrentSymbols().addLabelIntermediate();
      List<Comment> comments = getCommentsSymbol(stmtForCtx);
      StatementLabel repeatTarget = new StatementLabel(repeatLabel.getRef(), new StatementSource(ctx), comments);
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
      StatementConditionalJump doJmpStmt = new StatementConditionalJump(rValue, repeatLabel.getRef(), new StatementSource(ctx), Comment.NO_COMMENTS);
      sequence.addStatement(doJmpStmt);
      addDirectives(doJmpStmt, stmtForCtx.directive());
      return null;
   }

   @Override
   public Object visitForRange(KickCParser.ForRangeContext ctx) {
      KickCParser.StmtForContext stmtForCtx = (KickCParser.StmtForContext) ctx.getParent();
      KickCParser.ForDeclContext forDeclCtx = (KickCParser.ForDeclContext) stmtForCtx.forDeclaration();
      // Create declared loop variable
      Variable lValue = getForVariable(forDeclCtx);
      KickCParser.ExprContext rangeFirstCtx = ctx.expr(0);
      KickCParser.ExprContext rangeLastCtx = ctx.expr(1);
      // Assign loop variable with first value
      RValue rangeLastValue = (RValue) visit(rangeLastCtx);
      RValue rangeFirstValue = (RValue) visit(rangeFirstCtx);
      Statement stmtInit = new StatementAssignment(lValue.getRef(), rangeFirstValue, new StatementSource(ctx), Comment.NO_COMMENTS);
      sequence.addStatement(stmtInit);
      // Add label
      List<Comment> comments = ensureUnusedComments(getCommentsSymbol(stmtForCtx));
      Label repeatLabel = getCurrentSymbols().addLabelIntermediate();
      StatementLabel repeatTarget = new StatementLabel(repeatLabel.getRef(), new StatementSource(ctx), comments);
      sequence.addStatement(repeatTarget);
      // Add body
      if(stmtForCtx.stmt() != null) {
         this.visit(stmtForCtx.stmt());
      }
      // Add increment
      Statement stmtNxt = new StatementAssignment(lValue.getRef(), lValue.getRef(), Operators.PLUS, new RangeNext(rangeFirstValue, rangeLastValue), new StatementSource(ctx), Comment.NO_COMMENTS);
      sequence.addStatement(stmtNxt);
      // Add condition i!=last+1 or i!=last-1
      RValue beyondLastVal = new RangeComparison(rangeFirstValue, rangeLastValue, lValue.getType());
      VariableIntermediate tmpVar = getCurrentSymbols().addVariableIntermediate();
      VariableRef tmpVarRef = tmpVar.getRef();
      Statement stmtTmpVar = new StatementAssignment(tmpVarRef, lValue.getRef(), Operators.NEQ, beyondLastVal, new StatementSource(ctx), Comment.NO_COMMENTS);
      sequence.addStatement(stmtTmpVar);
      // Add jump if condition was met
      StatementConditionalJump doJmpStmt = new StatementConditionalJump(tmpVarRef, repeatLabel.getRef(), new StatementSource(ctx), Comment.NO_COMMENTS);
      sequence.addStatement(doJmpStmt);
      addDirectives(doJmpStmt, stmtForCtx.directive());
      return null;
   }

   /**
    * Get the variable of a for-loop.
    *
    * @param forDeclCtx The variable declaration
    * @return The variable of the for loop
    */
   private Variable getForVariable(KickCParser.ForDeclContext forDeclCtx) {
      String varName = forDeclCtx.NAME().getText();
      Variable lValue;
      if(forDeclCtx.typeDecl() != null) {
         SymbolType type = (SymbolType) visit(forDeclCtx.typeDecl());
         lValue = getCurrentSymbols().addVariable(varName, type);
         // Add directives
         addDirectives(type, lValue, forDeclCtx.directive());
      } else {
         lValue = getCurrentSymbols().getVariable(varName);
      }
      if(lValue == null) {
         throw new CompileError("Unknown variable! " + varName, new StatementSource(forDeclCtx));
      }
      return lValue;
   }


   @Override
   public Object visitStmtAsm(KickCParser.StmtAsmContext ctx) {
      List<Comment> comments = ensureUnusedComments(getCommentsSymbol(ctx));
      sequence.addStatement(new StatementAsm(ctx.asmLines(), new StatementSource(ctx), comments));
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
         sequence.addStatement(new StatementAssignment(returnVar.getRef(), rValue, new StatementSource(ctx), ensureUnusedComments(getCommentsSymbol(ctx))));
         PrePostModifierHandler.addPostModifiers(this, exprCtx);
      }
      Label returnLabel = procedure.getLabel(SymbolRef.PROCEXIT_BLOCK_NAME);
      sequence.addStatement(new StatementJump(returnLabel.getRef(), new StatementSource(ctx), ensureUnusedComments(getCommentsSymbol(ctx))));
      return null;
   }

   private void addInitialAssignment(KickCParser.ExprContext initializer, Variable lValue, List<Comment> comments) {
      PrePostModifierHandler.addPreModifiers(this, initializer);
      RValue rValue = (RValue) visit(initializer);
      Statement stmt = new StatementAssignment(lValue.getRef(), rValue, new StatementSource(initializer), ensureUnusedComments(comments));
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
   public SymbolType visitTypePar(KickCParser.TypeParContext ctx) {
      return (SymbolType) visit(ctx.typeDecl());
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
         RValue sizeVal = (RValue) visit(ctx.expr());
         return new SymbolTypeArray(elementType, sizeVal);
      } else {
         return new SymbolTypeArray(elementType);
      }
   }

   @Override
   public Object visitTypeProcedure(KickCParser.TypeProcedureContext ctx) {
      SymbolType returnType = (SymbolType) visit(ctx.typeDecl());
      return new SymbolTypeProcedure(returnType);
   }

   @Override
   public Object visitExprAssignment(KickCParser.ExprAssignmentContext ctx) {
      Object val = visit(ctx.expr(0));
      LValue lValue = (LValue) val;
      if(lValue instanceof VariableRef && ((VariableRef) lValue).isIntermediate()) {
         // Encountered an intermediate variable. This must be turned into a proper LValue later. Put it into a marker to signify that
         lValue = new LvalueIntermediate((VariableRef) lValue);
      }
      RValue rValue = (RValue) this.visit(ctx.expr(1));
      Statement stmt = new StatementAssignment(lValue, rValue, new StatementSource(ctx), ensureUnusedComments(getCommentsSymbol(ctx)));
      sequence.addStatement(stmt);
      return lValue;
   }

   @Override
   public Object visitExprAssignmentCompound(KickCParser.ExprAssignmentCompoundContext ctx) {
      // Assignment (rValue/lValue)
      Object value = visit(ctx.expr(0));
      if(!(value instanceof LValue)) {
         throw new CompileError("Error! Illegal assignment Lvalue " + value.toString(), new StatementSource(ctx));
      }
      LValue lValue = (LValue) value;
      if(lValue instanceof VariableRef && ((VariableRef) lValue).isIntermediate()) {
         // Encountered an intermediate variable. This must be turned into a proper LValue later. Put it into a marker to signify that
         lValue = new LvalueIntermediate((VariableRef) lValue);
      }
      RValue rValue = (RValue) this.visit(ctx.expr(1));
      // Binary Operator
      String op = ((TerminalNode) ctx.getChild(1)).getSymbol().getText();
      Operator operator = Operators.getBinaryCompound(op);
      // Assignment with operator
      Statement stmt = new StatementAssignment(lValue, lValue, operator, rValue, new StatementSource(ctx), ensureUnusedComments(getCommentsSymbol(ctx)));
      sequence.addStatement(stmt);
      return lValue;
   }

   @Override
   public RValue visitExprCast(KickCParser.ExprCastContext ctx) {
      RValue child = (RValue) this.visit(ctx.expr());
      SymbolType castType = (SymbolType) this.visit(ctx.typeDecl());
      Operator operator = Operators.getCastUnary(castType);
      VariableIntermediate tmpVar = getCurrentSymbols().addVariableIntermediate();
      VariableRef tmpVarRef = tmpVar.getRef();
      Statement stmt = new StatementAssignment(tmpVarRef, operator, child, new StatementSource(ctx), ensureUnusedComments(getCommentsSymbol(ctx)));
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
      sequence.addStatement(new StatementCall(tmpVarRef, ctx.NAME().getText(), parameters, new StatementSource(ctx), ensureUnusedComments(getCommentsSymbol(ctx))));
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
      RValue array = (RValue) visit(ctx.expr(0));
      RValue index = (RValue) visit(ctx.expr(1));
      return new PointerDereferenceIndexed(array, index);
   }

   @Override
   public RValue visitExprNumber(KickCParser.ExprNumberContext ctx) {
      Number number = NumberParser.parseLiteral(ctx.getText());
      if(number instanceof Long) {
         return new ConstantInteger((Long) number);
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
      Operator operator = Operators.getBinary(op);
      VariableIntermediate tmpVar = getCurrentSymbols().addVariableIntermediate();
      VariableRef tmpVarRef = tmpVar.getRef();
      Statement stmt = new StatementAssignment(tmpVarRef, left, operator, right, new StatementSource(ctx), ensureUnusedComments(getCommentsSymbol(ctx)));
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
      Operator operator = Operators.getUnary(op);
      VariableIntermediate tmpVar = getCurrentSymbols().addVariableIntermediate();
      VariableRef tmpVarRef = tmpVar.getRef();
      Statement stmt = new StatementAssignment(tmpVarRef, operator, child, new StatementSource(ctx), ensureUnusedComments(getCommentsSymbol(ctx)));
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
      Symbol symbol = getCurrentSymbols().getSymbol(ctx.NAME().getText());
      if(symbol instanceof Variable) {
         Variable variable = (Variable) symbol;
         return variable.getRef();
      } else if(symbol instanceof Procedure) {
         Procedure procedure = (Procedure) symbol;
         return procedure.getRef();
      } else if(symbol == null) {
         // Either forward reference or a non-existing variable. Create a forward reference for later resolving.
         return new ForwardVariableRef(ctx.NAME().getText());
      }
      throw new CompileError("Error! Unhandled symbol " + symbol.toString(program));
   }

   /** The hidden lexer channel containing whitespace. */
   private static final int CHANNEL_WHITESPACE = 1;
   /** The hidden lexer channel containing comments. */
   private static final int CHANNEL_COMMENTS = 2;

   /**
    * Find all comments preceding the passed context.
    * Group the comments into blocks each time an empty line (double newline) is encountered
    *
    * @param ctx The parse context to examine
    * @return The comment blocks preceding the context
    */
   private List<List<Comment>> getCommentBlocks(ParserRuleContext ctx) {
      List<List<Comment>> commentBlocks = new ArrayList<>();
      List<Comment> comments = new ArrayList<>();
      List<Token> hiddenTokens = tokenStream.getHiddenTokensToLeft(ctx.start.getTokenIndex());
      if(hiddenTokens != null) {
         for(Token hiddenToken : hiddenTokens) {
            if(hiddenToken.getChannel() == CHANNEL_WHITESPACE) {
               String text = hiddenToken.getText();
               long newlineCount = text.chars().filter(ch -> ch == '\n').count();
               if(newlineCount > 1 && comments.size()>0) {
                  // Create new comment block
                  commentBlocks.add(comments);
                  comments = new ArrayList<>();
               }
            } else if(hiddenToken.getChannel() == CHANNEL_COMMENTS) {
               boolean isBlock = false;
               String text = hiddenToken.getText();
               if(text.startsWith("//")) {
                  text = text.substring(2);
               }
               if(text.startsWith("/*")) {
                  text = text.substring(2, text.length()-2);
                  isBlock = true;
               }
               Comment comment = new Comment(text);
               comment.setBlock(isBlock);
               comment.setTokenIndex(hiddenToken.getTokenIndex());
               comments.add( comment);
            }
         }
      }
      if(comments.size()>0) {
         commentBlocks.add(comments);
      }
      return commentBlocks;
   }

   /** Set containing the token index of all comment blocks that have already been used. */
   HashSet<Integer> usedCommentTokenIndices = new HashSet<>();

   /**
    * Ensures that the comments have not already been "used" in another context.
    *
    * @param candidate The comments to examine
    * @return The comments if they are unused. An empty comment if they had already been used.
    */
   private List<Comment> ensureUnusedComments(List<Comment> candidate) {
      if(candidate.size()==0) {
         return candidate;
      }
      int tokenIndex = candidate.get(0).getTokenIndex();
      if(usedCommentTokenIndices.contains(tokenIndex)) {
         // Comment was already used - Return an empty list
         return new ArrayList<>();
      } else {
         // Comment unused - Mark as used and return it
         usedCommentTokenIndices.add(tokenIndex);
         return candidate;
      }
   }

   /**
    * Find the first comments preceding the passed context (search from start until meeting a double newline).
    * Only returns comments if they have not already been "used" by another call.
    *
    * @param ctx The parse context to examine
    * @return The first comments preceding the context
    */
   private List<Comment> getCommentsFile(ParserRuleContext ctx) {
      List<List<Comment>> commentBlocks = getCommentBlocks(ctx);
      if(commentBlocks.size()==0) {
         return new ArrayList<>();
      }
      return commentBlocks.get(0);
   }

   /**
    * Find comments immediately preceding the passed context (search from end until meeting a double newline)
    * Only returns comments if they have not already been "used" by another call.
    *
    * @param ctx The parse context to examine
    * @return The comments immediately preceding the context
    */
   private List<Comment> getCommentsSymbol(ParserRuleContext ctx) {
      List<List<Comment>> commentBlocks = getCommentBlocks(ctx);
      if(commentBlocks.size()==0) {
         return new ArrayList<>();
      }
      return commentBlocks.get(commentBlocks.size() - 1);
   }

   /** A declaration directive. */
   private interface Directive {
   }

   /** Variable declared constant. */
   private static class DirectiveConst implements Directive {
   }

   /** Function declared inline. */
   private static class DirectiveInline implements Directive {
   }

   /** Variable declared volatile. */
   private static class DirectiveVolatile implements Directive {
   }

   /** Function declared interrupt. */
   private static class DirectiveInterrupt implements Directive {
      public Procedure.InterruptType interruptType;

      public DirectiveInterrupt(Procedure.InterruptType interruptType) {
         this.interruptType = interruptType;
      }
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

   /** Variable memory alignment. */
   private static class DirectiveRegister implements Directive {
      private String name;

      public DirectiveRegister(String name) {
         this.name = name;
      }

      public String getName() {
         return name;
      }

      public void setName(String name) {
         this.name = name;
      }
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

      public static void addPostModifiers(Pass0GenerateStatementSequence parser, ParserRuleContext ctx) {
         PrePostModifierHandler prePostModifierHandler = new PrePostModifierHandler(parser);
         prePostModifierHandler.visit(ctx);
         List<PrePostModifier> modifiers = prePostModifierHandler.getPostMods();
         addModifierStatements(parser, modifiers, new StatementSource(ctx));
      }

      public static void addPreModifiers(Pass0GenerateStatementSequence parser, ParserRuleContext ctx) {
         PrePostModifierHandler modifierHandler = new PrePostModifierHandler(parser);
         modifierHandler.visit(ctx);
         List<PrePostModifier> modifiers = modifierHandler.getPreMods();
         addModifierStatements(parser, modifiers, new StatementSource(ctx));
      }

      private static void addModifierStatements(
            Pass0GenerateStatementSequence parser,
            List<PrePostModifier> modifiers,
            StatementSource source) {
         for(PrePostModifier mod : modifiers) {
            Statement stmt = new StatementAssignment((LValue) mod.child, mod.operator, mod.child, source, Comment.NO_COMMENTS);
            parser.sequence.addStatement(stmt);
            if(parser.program.getLog().isVerboseParse()) {
               parser.program.getLog().append("Adding pre/post-modifier " + stmt.toString(parser.program, false));
            }
         }
      }

      List<PrePostModifier> getPreMods() {
         return preMods;
      }

      List<PrePostModifier> getPostMods() {
         return postMods;
      }

      @Override
      public Void visitExprPostMod(KickCParser.ExprPostModContext ctx) {
         RValue child = (RValue) mainParser.visit(ctx.expr());
         String op = ((TerminalNode) ctx.getChild(1)).getSymbol().getText();
         Operator operator = Operators.getUnary(op);
         PrePostModifier modifier = new PrePostModifier(child, operator);
         postMods.add(modifier);
         return null;
      }

      @Override
      public Void visitExprPreMod(KickCParser.ExprPreModContext ctx) {
         RValue child = (RValue) mainParser.visit(ctx.expr());
         String op = ((TerminalNode) ctx.getChild(0)).getSymbol().getText();
         Operator operator = Operators.getUnary(op);
         PrePostModifier modifier = new PrePostModifier(child, operator);
         preMods.add(modifier);
         return null;
      }

      private static class PrePostModifier {
         RValue child;
         public Operator operator;

         PrePostModifier(RValue child, Operator operator) {
            this.child = child;
            this.operator = operator;
         }
      }

   }
}

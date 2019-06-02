package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.Compiler;
import dk.camelot64.kickc.NumberParser;
import dk.camelot64.kickc.asm.AsmClobber;
import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.operators.Operator;
import dk.camelot64.kickc.model.operators.OperatorSizeOf;
import dk.camelot64.kickc.model.operators.OperatorTypeId;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.symbols.*;
import dk.camelot64.kickc.model.types.*;
import dk.camelot64.kickc.model.values.*;
import dk.camelot64.kickc.parser.KickCBaseVisitor;
import dk.camelot64.kickc.parser.KickCParser;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.tree.ParseTree;
import org.antlr.v4.runtime.tree.TerminalNode;

import java.io.File;
import java.nio.file.Path;
import java.util.*;
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

   private Scope getCurrentScope() {
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
      if(program.getFileComments() == null) {
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
   public Object visitGlobalDirectiveReserve(KickCParser.GlobalDirectiveReserveContext ctx) {
      DirectiveReserveZp reserveDirective = (DirectiveReserveZp) this.visit(ctx.directiveReserve());
      if(reserveDirective != null) {
         program.addReservedZps(reserveDirective.getReservedZp());
      }
      return null;
   }

   @Override
   public Object visitGlobalDirectiveEncoding(KickCParser.GlobalDirectiveEncodingContext ctx) {
      try {
         ConstantString.Encoding encoding = ConstantString.Encoding.valueOf(ctx.NAME().getText().toUpperCase());
         this.currentEncoding = encoding;
      } catch( IllegalArgumentException  e) {
         throw new CompileError("Unknown string encoding "+ctx.NAME().getText(), new StatementSource(ctx));
      }
      return null;
   }

   @Override
   public Object visitGlobalDirectivePc(KickCParser.GlobalDirectivePcContext ctx) {
      Number programPc = NumberParser.parseLiteral(ctx.NUMBER().getText());
      if(programPc != null) {
         program.setProgramPc(programPc);
      }
      return null;
   }

   @Override
   public Object visitDeclFunction(KickCParser.DeclFunctionContext ctx) {
      this.visitDeclTypes(ctx.declTypes());
      SymbolType type = declVarType;
      List<Directive> directives = declVarDirectives;

      String name = ctx.NAME().getText();
      Procedure procedure = getCurrentScope().addProcedure(name, type);
      addDirectives(procedure, directives, new StatementSource(ctx));
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
      exitDeclTypes();
      return null;
   }


   @Override
   public List<Variable> visitParameterListDecl(KickCParser.ParameterListDeclContext ctx) {
      ArrayList<Variable> parameterDecls = new ArrayList<>();
      for(KickCParser.ParameterDeclContext parameterDeclCtx : ctx.parameterDecl()) {
         Object parameterDecl = this.visit(parameterDeclCtx);
         if(parameterDecl.equals(SymbolType.VOID)) {
            if(ctx.parameterDecl().size() == 1) {
               // A single void parameter decl - equals zero parameters
               return new ArrayList<>();
            } else {
               throw new CompileError("Illegal void parameter.", new StatementSource(ctx));
            }
         } else if(parameterDecl instanceof Variable) {
            parameterDecls.add((Variable) parameterDecl);
         } else {
            throw new CompileError("Unknown parameter " + ctx.getText(), new StatementSource(ctx));
         }
      }
      return parameterDecls;
   }

   @Override
   public Object visitParameterDeclType(KickCParser.ParameterDeclTypeContext ctx) {
      this.visitDeclTypes(ctx.declTypes());
      SymbolType type = declVarType;
      List<Directive> directives = declVarDirectives;
      VariableUnversioned param = new VariableUnversioned(ctx.NAME().getText(), getCurrentScope(), type);
      // Add directives
      addDirectives(param, type, directives, new StatementSource(ctx));
      exitDeclTypes();
      return param;
   }

   @Override
   public Object visitParameterDeclVoid(KickCParser.ParameterDeclVoidContext ctx) {
      if(!SymbolType.VOID.getTypeName().equals(ctx.SIMPLETYPE().getText())) {
         throw new CompileError("Illegal unnamed parameter " + ctx.SIMPLETYPE().getText(), new StatementSource(ctx));
      }
      return SymbolType.VOID;
   }

   @Override
   public Object visitDeclKasm(KickCParser.DeclKasmContext ctx) {
      String kasm = ctx.KICKASM().getText();
      Pattern p = Pattern.compile("\\{\\{[\\s]*(.*)[\\s]*\\}\\}", Pattern.DOTALL);
      Matcher m = p.matcher(kasm);
      if(m.find()) {
         String kickAsmCode = m.group(1).replaceAll("\r", "");
         StatementKickAsm statementKickAsm = new StatementKickAsm(kickAsmCode, new StatementSource(ctx), ensureUnusedComments(getCommentsSymbol(ctx)));
         if(ctx.asmDirectives() != null) {
            List<AsmDirective> asmDirectives = this.visitAsmDirectives(ctx.asmDirectives());
            for(AsmDirective asmDirective : asmDirectives) {
               if(asmDirective instanceof AsmDirectiveLocation) {
                  statementKickAsm.setLocation(((AsmDirectiveLocation) asmDirective).getAddress());
               } else if(asmDirective instanceof AsmDirectiveBytes) {
                  statementKickAsm.setBytes(((AsmDirectiveBytes) asmDirective).getBytes());
               } else if(asmDirective instanceof AsmDirectiveCycles) {
                  statementKickAsm.setCycles(((AsmDirectiveCycles) asmDirective).getCycles());
               } else if(asmDirective instanceof AsmDirectiveUses) {
                  statementKickAsm.addUses(((AsmDirectiveUses) asmDirective).getUses());
               } else if(asmDirective instanceof AsmDirectiveClobber) {
                  statementKickAsm.setDeclaredClobber(((AsmDirectiveClobber) asmDirective).getClobber());
               } else {
                  throw new CompileError("kickasm does not support directive " + asmDirective, statementKickAsm);
               }
            }
         }
         sequence.addStatement(statementKickAsm);
      }
      return null;
   }

   private interface AsmDirective {
   }

   @Override
   public List<AsmDirective> visitAsmDirectives(KickCParser.AsmDirectivesContext ctx) {
      ArrayList<AsmDirective> asmDirectives = new ArrayList<>();
      List<KickCParser.AsmDirectiveContext> params = ctx.asmDirective();
      for(KickCParser.AsmDirectiveContext param : params) {
         AsmDirective directive = (AsmDirective) visit(param);
         if(directive != null) {
            asmDirectives.add(directive);
         }
      }
      return asmDirectives;
   }

   /** KickAssembler directive specifying an absolute address for the generated code/data. */
   public static class AsmDirectiveLocation implements AsmDirective {
      /** will contain the address to generate the KickAssembler-code to. */
      private RValue address;

      AsmDirectiveLocation(RValue address) {
         this.address = address;
      }

      public RValue getAddress() {
         return address;
      }

      @Override
      public String toString() {
         return "pc";
      }
   }

   @Override
   public Object visitAsmDirectiveAddress(KickCParser.AsmDirectiveAddressContext ctx) {
      if(ctx.expr() != null) {
         RValue expr = (RValue) visit(ctx.expr());
         return new AsmDirectiveLocation(expr);
      } else {
         // PLace inline
         return null;
      }
   }

   /** KickAssembler directive specifying the number of bytes for generated code/data. */
   public static class AsmDirectiveBytes implements AsmDirective {
      /** bytes for the KickAssembler-code. */
      private RValue bytes;

      AsmDirectiveBytes(RValue bytes) {
         this.bytes = bytes;
      }

      public RValue getBytes() {
         return bytes;
      }

      @Override
      public String toString() {
         return "bytes";
      }
   }

   @Override
   public AsmDirective visitAsmDirectiveBytes(KickCParser.AsmDirectiveBytesContext ctx) {
      if(ctx.expr() != null) {
         RValue bytes = (RValue) this.visit(ctx.expr());
         return new AsmDirectiveBytes(bytes);
      } else {
         return null;
      }
   }

   /** KickAssembler directive specifying a constant used by the kickasm code. */
   public static class AsmDirectiveUses implements AsmDirective {
      /** constant/variable used by the KickAssembler-code. */
      private SymbolVariableRef uses;

      public SymbolVariableRef getUses() {
         return uses;
      }

      AsmDirectiveUses(SymbolVariableRef uses) {
         this.uses = uses;
      }

      public void setUses(SymbolVariableRef uses) {
         this.uses = uses;
      }

      @Override
      public String toString() {
         return "uses";
      }

   }

   @Override
   public Object visitAsmDirectiveUses(KickCParser.AsmDirectiveUsesContext ctx) {
      String varName = ctx.NAME().getText();
      SymbolVariableRef variableRef;
      Symbol symbol = getCurrentScope().getSymbol(varName);
      if(symbol instanceof Variable) {
         //Found an existing variable
         Variable variable = (Variable) symbol;
         variableRef = variable.getRef();
      } else {
         // Either forward reference or a non-existing variable. Create a forward reference for later resolving.
         variableRef = new ForwardVariableRef(varName);
      }
      return new AsmDirectiveUses(variableRef);
   }

   /** KickAssembler directive specifying the number of cycles for generated code/data. */
   public static class AsmDirectiveCycles implements AsmDirective {
      /** cycles for the KickAssembler-code. */
      private RValue cycles;

      AsmDirectiveCycles(RValue cycles) {
         this.cycles = cycles;
      }

      public RValue getCycles() {
         return cycles;
      }

      @Override
      public String toString() {
         return "cycles";
      }

   }

   @Override
   public AsmDirective visitAsmDirectiveCycles(KickCParser.AsmDirectiveCyclesContext ctx) {
      if(ctx.expr() != null) {
         RValue cycles = (RValue) this.visit(ctx.expr());
         return new AsmDirectiveCycles(cycles);
      } else {
         return null;
      }
   }

   @Override
   public Object visitAsmDirectiveResource(KickCParser.AsmDirectiveResourceContext ctx) {
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

   /** ASM Directive specifying clobber registers. */
   private class AsmDirectiveClobber implements AsmDirective {
      private AsmClobber clobber;

      AsmDirectiveClobber(AsmClobber clobber) {
         this.clobber = clobber;
      }

      public AsmClobber getClobber() {
         return clobber;
      }

      @Override
      public String toString() {
         return "clobbers";
      }

   }

   @Override
   public AsmDirectiveClobber visitAsmDirectiveClobber(KickCParser.AsmDirectiveClobberContext ctx) {
      String clobberString = ctx.STRING().getText().toUpperCase();
      clobberString = clobberString.substring(1, clobberString.length() - 1);
      if(!clobberString.matches("[AXY]*")) {
         throw new CompileError("Error! Illegal clobber value " + clobberString, new StatementSource(ctx));
      }
      AsmClobber clobber = new AsmClobber();
      clobber.setClobberA(clobberString.contains("A"));
      clobber.setClobberX(clobberString.contains("X"));
      clobber.setClobberY(clobberString.contains("Y"));
      return new AsmDirectiveClobber(clobber);
   }

   /** Holds the declared type when descending into a Variable Declaration. */
   private SymbolType declVarType = null;
   /** Holds the declared directives when descending into a Variable Declaration. */
   private List<Directive> declVarDirectives = null;
   /** Holds the declared comments when descending into a Variable Declaration. */
   private List<Comment> declVarComments = null;
   /** State specifying that we are currently populating struct members. */
   private boolean declVarStructMember = false;

   /**
    * Visit the type/directive part of a declaration. Setup the local decl-variables
    *
    * @param ctx The declaration type & directives
    * @return null
    */
   @Override
   public Object visitDeclTypes(KickCParser.DeclTypesContext ctx) {
      List<KickCParser.DirectiveContext> directive = ctx.directive();
      this.declVarType = (SymbolType) visit(ctx.typeDecl());
      this.declVarDirectives = getDirectives(directive);
      this.declVarComments = getCommentsSymbol(ctx.getParent());
      return null;
   }

   /**
    * Clear the local decl-variables
    */
   private void exitDeclTypes() {
      this.declVarType = null;
      this.declVarDirectives = null;
      this.declVarComments = null;
   }

   @Override
   public Object visitDeclVariables(KickCParser.DeclVariablesContext ctx) {
      this.visit(ctx.declTypes());
      this.visit(ctx.declVariableList());
      exitDeclTypes();
      return null;
   }

   @Override
   public Object visitDeclVariableList(KickCParser.DeclVariableListContext ctx) {
      if(ctx.declVariableList() != null) {
         this.visit(ctx.declVariableList());
      }
      this.visit(ctx.declVariableInit());
      return null;
   }

   @Override
   public Object visitDeclVariableInit(KickCParser.DeclVariableInitContext ctx) {
      List<Directive> directives = declVarDirectives;
      SymbolType type = declVarType;
      List<Comment> comments = declVarComments;

      String varName = ctx.NAME().getText();
      VariableUnversioned lValue;
      try {
         lValue = getCurrentScope().addVariable(varName, type);
      } catch(CompileError e) {
         throw new CompileError(e.getMessage(), new StatementSource(ctx));
      }
      // Add directives
      addDirectives(lValue, type, directives, new StatementSource(ctx));
      // Array / String variables are implicitly constant
      if(type instanceof SymbolTypeArray || type.equals(SymbolType.STRING)) {
         lValue.setDeclaredConstant(true);
      }
      if(lValue.isDeclaredConstant()) {
         // Add comments to constant
         lValue.setComments(ensureUnusedComments(comments));
      }
      if(type instanceof SymbolTypeStruct) {
         lValue.setDeclaredVolatile(true);
      }
      KickCParser.ExprContext initializer = ctx.expr();
      if(declVarStructMember) {
         if(initializer != null) {
            throw new CompileError("Initializers not supported inside structs " + type.getTypeName(), new StatementSource(ctx));
         }
      } else {
         if(initializer != null) {
            addInitialAssignment(initializer, lValue, comments);
         } else {
            if(type instanceof SymbolTypeIntegerFixed) {
               // Add an zero value initializer
               ConstantInteger zero = new ConstantInteger(0L, type);
               Statement stmt = new StatementAssignment(lValue.getRef(), zero, new StatementSource(ctx), ensureUnusedComments(comments));
               sequence.addStatement(stmt);
            } else if(type instanceof SymbolTypeArray) {
               // Add an zero-array initializer
               SymbolTypeArray typeArray = (SymbolTypeArray) type;
               RValue size = typeArray.getSize();
               if(size == null) {
                  throw new CompileError("Error! Array has no declared size. " + lValue.toString(program), new StatementSource(ctx));
               }
               Statement stmt = new StatementAssignment(lValue.getRef(), new ArrayFilled(typeArray.getElementType(), size), new StatementSource(ctx), ensureUnusedComments(comments));
               sequence.addStatement(stmt);
            } else if(type instanceof SymbolTypePointer) {
               // Add an zero value initializer
               SymbolTypePointer typePointer = (SymbolTypePointer) type;
               ConstantValue zero = new ConstantPointer(0L, typePointer.getElementType());
               Statement stmt = new StatementAssignment(lValue.getRef(), zero, new StatementSource(ctx), ensureUnusedComments(comments));
               sequence.addStatement(stmt);
            } else if(type instanceof SymbolTypeStruct) {
               // Add an zero-struct initializer
               SymbolTypeStruct typeStruct = (SymbolTypeStruct) type;
               Statement stmt = new StatementAssignment(lValue.getRef(), new StructZero(typeStruct), new StatementSource(ctx), ensureUnusedComments(comments));
               sequence.addStatement(stmt);
            } else {
               throw new CompileError("Default initializer not implemented for type " + type.getTypeName(), new StatementSource(ctx));
            }
         }

      }
      return null;
   }

   /**
    * Add declared directives to an lValue (typically a variable).
    *
    * @param lValue The lValue
    * @param type The type of the lValue
    * @param directives The directives to add
    */
   private void addDirectives(SymbolVariable lValue, SymbolType type, List<Directive> directives, StatementSource source) {
      for(Directive directive : directives) {
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
    * Find the directives in the parse tree
    *
    * @param directivesCtx The directives in the parse tree to examine
    * @return Objects representing the found directives
    */
   private List<Directive> getDirectives(List<KickCParser.DirectiveContext> directivesCtx) {
      List<Directive> directives = new ArrayList<>();
      for(KickCParser.DirectiveContext directiveContext : directivesCtx) {
         directives.add((Directive) this.visit(directiveContext));
      }
      return directives;
   }

   /**
    * Add declared directives to a procedure.
    *
    * @param procedure The procedure
    * @param directives The directives to add
    */
   private void addDirectives(Procedure procedure, List<Directive> directives, StatementSource source) {
      for(Directive directive : directives) {
         if(directive instanceof DirectiveInline) {
            procedure.setDeclaredInline(true);
         } else if(directive instanceof DirectiveInterrupt) {
            procedure.setInterruptType(((DirectiveInterrupt) directive).interruptType);
         } else if(directive instanceof DirectiveReserveZp) {
            procedure.setReservedZps(((DirectiveReserveZp) directive).getReservedZp());
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
      List<Directive> directives = getDirectives(directivesCtx);
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
   public Object visitDirectiveReserve(KickCParser.DirectiveReserveContext ctx) {
      List<Number> reservedZps = new ArrayList<>();
      for(TerminalNode reservedNum : ctx.NUMBER()) {
         Number reservedZp = NumberParser.parseLiteral(reservedNum.getText());
         reservedZps.add(reservedZp);
      }
      return new DirectiveReserveZp(reservedZps);
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
         BlockScope blockScope = getCurrentScope().addBlockScope();
         scopeStack.push(blockScope);
         this.visit(ctx.stmtSeq());
         scopeStack.pop();
      }
      return null;
   }

   @Override
   public Void visitStmtExpr(KickCParser.StmtExprContext ctx) {
      PrePostModifierHandler.addPreModifiers(this, ctx.commaExpr());
      this.visit(ctx.commaExpr());
      PrePostModifierHandler.addPostModifiers(this, ctx.commaExpr());
      return null;
   }

   @Override
   public Void visitStmtIfElse(KickCParser.StmtIfElseContext ctx) {
      KickCParser.StmtContext ifStmt = ctx.stmt(0);
      KickCParser.StmtContext elseStmt = ctx.stmt(1);
      PrePostModifierHandler.addPreModifiers(this, ctx.commaExpr());
      RValue rValue = (RValue) this.visit(ctx.commaExpr());
      List<Comment> comments = ensureUnusedComments(getCommentsSymbol(ctx));

      if(elseStmt == null) {
         // If without else - skip the entire section if condition not met
         VariableRef notExprVar = getCurrentScope().addVariableIntermediate().getRef();
         sequence.addStatement(new StatementAssignment(notExprVar, null, Operators.LOGIC_NOT, rValue, new StatementSource(ctx), comments));
         PrePostModifierHandler.addPostModifiers(this, ctx.commaExpr());
         Label endJumpLabel = getCurrentScope().addLabelIntermediate();
         sequence.addStatement(new StatementConditionalJump(notExprVar, endJumpLabel.getRef(), new StatementSource(ctx), Comment.NO_COMMENTS));
         this.visit(ifStmt);
         // No else statement - just add the label
         sequence.addStatement(new StatementLabel(endJumpLabel.getRef(), new StatementSource(ctx), Comment.NO_COMMENTS));
      } else {
         // If with else - jump to if section if condition met - fall into else otherwise.
         PrePostModifierHandler.addPostModifiers(this, ctx.commaExpr());
         Label ifJumpLabel = getCurrentScope().addLabelIntermediate();
         sequence.addStatement(new StatementConditionalJump(rValue, ifJumpLabel.getRef(), new StatementSource(ctx), comments));
         // Add else body
         this.visit(elseStmt);
         // There is an else statement - add the if part and any needed labels/jumps
         Label endJumpLabel = getCurrentScope().addLabelIntermediate();
         sequence.addStatement(new StatementJump(endJumpLabel.getRef(), new StatementSource(ctx), Comment.NO_COMMENTS));
         sequence.addStatement(new StatementLabel(ifJumpLabel.getRef(), new StatementSource(ctx), Comment.NO_COMMENTS));
         this.visit(ifStmt);
         StatementLabel endJumpTarget = new StatementLabel(endJumpLabel.getRef(), new StatementSource(ctx), Comment.NO_COMMENTS);
         sequence.addStatement(endJumpTarget);
      }
      return null;
   }

   /** A loop being generated. */
   static class Loop {

      /** The scope of the loop. */
      Scope loopScope;

      /** The label after the loop that a break will jump to. Null if no break has been encountered. */
      Label breakLabel;

      /** The label that a continue will jump to. Null if no continue has been encountered. */
      Label continueLabel;

      public Loop(Scope loopScope) {
         this.loopScope = loopScope;
      }

      Label getBreakLabel() {
         return breakLabel;
      }

      Label getOrCreateBreakLabel() {
         if(breakLabel == null) {
            breakLabel = loopScope.addLabelIntermediate();
         }
         return breakLabel;
      }

      Label getContinueLabel() {
         return continueLabel;
      }

      void setContinueLabel(Label continueLabel) {
         this.continueLabel = continueLabel;
      }

      Label getOrCreateContinueLabel() {
         if(continueLabel == null) {
            continueLabel = loopScope.addLabelIntermediate();
         }
         return continueLabel;
      }

   }

   /** The loops being generated. */
   private Stack<Loop> loopStack = new Stack<>();

   @Override
   public Void visitStmtWhile(KickCParser.StmtWhileContext ctx) {
      // Create the block scope early - to keep all statements of the loop inside it
      BlockScope blockScope = getCurrentScope().addBlockScope();
      scopeStack.push(blockScope);
      loopStack.push(new Loop(blockScope));
      Label beginJumpLabel = getCurrentScope().addLabelIntermediate();
      Label doJumpLabel = getCurrentScope().addLabelIntermediate();
      Label endJumpLabel = getCurrentScope().addLabelIntermediate();
      List<Comment> comments = ensureUnusedComments(getCommentsSymbol(ctx));
      StatementLabel beginJumpTarget = new StatementLabel(beginJumpLabel.getRef(), new StatementSource(ctx), comments);
      sequence.addStatement(beginJumpTarget);
      PrePostModifierHandler.addPreModifiers(this, ctx.commaExpr());
      RValue rValue = (RValue) this.visit(ctx.commaExpr());
      PrePostModifierHandler.addPostModifiers(this, ctx.commaExpr());
      StatementConditionalJump doJmpStmt = new StatementConditionalJump(rValue, doJumpLabel.getRef(), new StatementSource(ctx), Comment.NO_COMMENTS);
      sequence.addStatement(doJmpStmt);
      Statement endJmpStmt = new StatementJump(endJumpLabel.getRef(), new StatementSource(ctx), Comment.NO_COMMENTS);
      sequence.addStatement(endJmpStmt);
      StatementLabel doJumpTarget = new StatementLabel(doJumpLabel.getRef(), new StatementSource(ctx), Comment.NO_COMMENTS);
      sequence.addStatement(doJumpTarget);
      // Reuse the begin jump target for continue.
      loopStack.peek().setContinueLabel(beginJumpLabel);
      addLoopBody(ctx.stmt());
      Statement beginJmpStmt = new StatementJump(beginJumpLabel.getRef(), new StatementSource(ctx), Comment.NO_COMMENTS);
      sequence.addStatement(beginJmpStmt);
      StatementLabel endJumpTarget = new StatementLabel(endJumpLabel.getRef(), new StatementSource(ctx), Comment.NO_COMMENTS);
      sequence.addStatement(endJumpTarget);
      // Add directives
      addDirectives(doJmpStmt, ctx.directive());
      addLoopBreakLabel(loopStack.pop(), ctx);
      scopeStack.pop();
      return null;
   }

   @Override
   public Void visitStmtDoWhile(KickCParser.StmtDoWhileContext ctx) {
      // Create the block scope early - to keep all statements of the loop inside it
      BlockScope blockScope = getCurrentScope().addBlockScope();
      scopeStack.push(blockScope);
      loopStack.push(new Loop(blockScope));
      List<Comment> comments = ensureUnusedComments(getCommentsSymbol(ctx));
      Label beginJumpLabel = getCurrentScope().addLabelIntermediate();
      StatementLabel beginJumpTarget = new StatementLabel(beginJumpLabel.getRef(), new StatementSource(ctx), comments);
      sequence.addStatement(beginJumpTarget);
      addLoopBody(ctx.stmt());
      addLoopContinueLabel(loopStack.peek(), ctx);
      PrePostModifierHandler.addPreModifiers(this, ctx.commaExpr());
      RValue rValue = (RValue) this.visit(ctx.commaExpr());
      PrePostModifierHandler.addPostModifiers(this, ctx.commaExpr());
      StatementConditionalJump doJmpStmt = new StatementConditionalJump(rValue, beginJumpLabel.getRef(), new StatementSource(ctx), Comment.NO_COMMENTS);
      sequence.addStatement(doJmpStmt);
      addDirectives(doJmpStmt, ctx.directive());
      addLoopBreakLabel(loopStack.pop(), ctx);
      scopeStack.pop();
      return null;
   }

   @Override
   public Object visitStmtFor(KickCParser.StmtForContext ctx) {
      this.visit(ctx.forLoop());
      return null;
   }

   @Override
   public Object visitForClassic(KickCParser.ForClassicContext ctx) {
      BlockScope blockScope = getCurrentScope().addBlockScope();
      scopeStack.push(blockScope);
      loopStack.push(new Loop(blockScope));
      this.visit(ctx.forClassicInit());
      KickCParser.StmtForContext stmtForCtx = (KickCParser.StmtForContext) ctx.getParent();
      // Add label
      Label repeatLabel = getCurrentScope().addLabelIntermediate();
      List<Comment> comments = getCommentsSymbol(stmtForCtx);
      StatementLabel repeatTarget = new StatementLabel(repeatLabel.getRef(), new StatementSource(ctx), comments);
      sequence.addStatement(repeatTarget);
      // Add body
      addLoopBody(stmtForCtx.stmt());
      addLoopContinueLabel(loopStack.peek(), ctx);
      // Add increment
      if(ctx.commaExpr(1) != null) {
         PrePostModifierHandler.addPreModifiers(this, ctx.commaExpr(1));
         this.visit(ctx.commaExpr(1));
         PrePostModifierHandler.addPostModifiers(this, ctx.commaExpr(1));
      }
      // Add condition
      PrePostModifierHandler.addPreModifiers(this, ctx.commaExpr(0));
      RValue rValue = (RValue) this.visit(ctx.commaExpr(0));
      PrePostModifierHandler.addPostModifiers(this, ctx.commaExpr(0));
      // Add jump if condition was met
      StatementConditionalJump doJmpStmt = new StatementConditionalJump(rValue, repeatLabel.getRef(), new StatementSource(ctx), Comment.NO_COMMENTS);
      sequence.addStatement(doJmpStmt);
      addDirectives(doJmpStmt, stmtForCtx.directive());
      addLoopBreakLabel(loopStack.pop(), ctx);
      scopeStack.pop();
      return null;
   }

   @Override
   public Object visitForClassicInitDecl(KickCParser.ForClassicInitDeclContext ctx) {
      if(ctx.declVariables() != null) {
         this.visit(ctx.declVariables());
      }
      return null;
   }

   @Override
   public Object visitForRange(KickCParser.ForRangeContext ctx) {
      BlockScope blockScope = getCurrentScope().addBlockScope();
      scopeStack.push(blockScope);
      loopStack.push(new Loop(blockScope));

      // Create / find declared loop variable
      if(ctx.declTypes() != null) {
         this.visitDeclTypes(ctx.declTypes());
      }
      SymbolType varType = declVarType;
      List<Directive> varDirectives = declVarDirectives;
      String varName = ctx.NAME().getText();
      Variable lValue;
      if(varType != null) {
         try {
            lValue = getCurrentScope().addVariable(varName, varType);
         } catch(CompileError e) {
            throw new CompileError(e.getMessage(), new StatementSource(ctx));
         }
         // Add directives
         addDirectives(lValue, varType, varDirectives, new StatementSource(ctx));
      } else {
         lValue = getCurrentScope().getVariable(varName);
      }
      exitDeclTypes();
      KickCParser.StmtForContext stmtForCtx = (KickCParser.StmtForContext) ctx.getParent();
      KickCParser.ExprContext rangeFirstCtx = ctx.expr(0);
      KickCParser.ExprContext rangeLastCtx = ctx.expr(1);
      // Assign loop variable with first value
      RValue rangeLastValue = (RValue) visit(rangeLastCtx);
      RValue rangeFirstValue = (RValue) visit(rangeFirstCtx);
      if(varType != null) {
         if(rangeFirstValue instanceof ConstantInteger) ((ConstantInteger) rangeFirstValue).setType(varType);
         if(rangeLastValue instanceof ConstantInteger) ((ConstantInteger) rangeLastValue).setType(varType);
      }
      Statement stmtInit = new StatementAssignment(lValue.getRef(), rangeFirstValue, new StatementSource(ctx), Comment.NO_COMMENTS);
      sequence.addStatement(stmtInit);
      // Add label
      List<Comment> comments = ensureUnusedComments(getCommentsSymbol(stmtForCtx));
      Label repeatLabel = getCurrentScope().addLabelIntermediate();
      StatementLabel repeatTarget = new StatementLabel(repeatLabel.getRef(), new StatementSource(ctx), comments);
      sequence.addStatement(repeatTarget);
      // Add body
      addLoopBody(stmtForCtx.stmt());
      addLoopContinueLabel(loopStack.peek(), ctx);
      // Add increment
      Statement stmtNxt = new StatementAssignment(lValue.getRef(), lValue.getRef(), Operators.PLUS, new RangeNext(rangeFirstValue, rangeLastValue), new StatementSource(ctx), Comment.NO_COMMENTS);
      sequence.addStatement(stmtNxt);
      // Add condition i!=last+1 or i!=last-1
      RValue beyondLastVal = new RangeComparison(rangeFirstValue, rangeLastValue, lValue.getType());
      VariableIntermediate tmpVar = getCurrentScope().addVariableIntermediate();
      VariableRef tmpVarRef = tmpVar.getRef();
      Statement stmtTmpVar = new StatementAssignment(tmpVarRef, lValue.getRef(), Operators.NEQ, beyondLastVal, new StatementSource(ctx), Comment.NO_COMMENTS);
      sequence.addStatement(stmtTmpVar);
      // Add jump if condition was met
      StatementConditionalJump doJmpStmt = new StatementConditionalJump(tmpVarRef, repeatLabel.getRef(), new StatementSource(ctx), Comment.NO_COMMENTS);
      sequence.addStatement(doJmpStmt);
      addDirectives(doJmpStmt, stmtForCtx.directive());
      addLoopBreakLabel(loopStack.pop(), ctx);
      scopeStack.pop();
      return null;
   }

   private void addLoopBreakLabel(Loop loop, ParserRuleContext ctx) {
      if(loop.getBreakLabel() != null) {
         StatementLabel breakTarget = new StatementLabel(loop.getBreakLabel().getRef(), new StatementSource(ctx), Comment.NO_COMMENTS);
         sequence.addStatement(breakTarget);
      }
   }

   private void addLoopContinueLabel(Loop loop, ParserRuleContext ctx) {
      if(loop.getContinueLabel() != null) {
         StatementLabel continueTarget = new StatementLabel(loop.getContinueLabel().getRef(), new StatementSource(ctx), Comment.NO_COMMENTS);
         sequence.addStatement(continueTarget);
      }
   }

   private void addLoopBody(KickCParser.StmtContext stmt) {
      if(stmt != null) {
         if(stmt instanceof KickCParser.StmtBlockContext) {
            // Skip the block context and reuse the one created by the for() itself
            KickCParser.StmtBlockContext stmtBlockContext = (KickCParser.StmtBlockContext) stmt;
            if(stmtBlockContext.stmtSeq() != null) {
               this.visit(stmtBlockContext.stmtSeq());
            }
         } else {
            this.visit(stmt);
         }
      }
   }

   @Override
   public Object visitStmtBreak(KickCParser.StmtBreakContext ctx) {
      if(loopStack.isEmpty()) {
         throw new CompileError("Break not inside a loop! ", new StatementSource(ctx));
      }
      Loop currentLoop = loopStack.peek();
      Label breakLabel = currentLoop.getOrCreateBreakLabel();
      Statement breakJmpStmt = new StatementJump(breakLabel.getRef(), new StatementSource(ctx), Comment.NO_COMMENTS);
      sequence.addStatement(breakJmpStmt);
      return null;
   }

   @Override
   public Object visitStmtContinue(KickCParser.StmtContinueContext ctx) {
      if(loopStack.isEmpty()) {
         throw new CompileError("Continue not inside a loop! ", new StatementSource(ctx));
      }
      Loop currentLoop = loopStack.peek();
      Label continueLabel = currentLoop.getOrCreateContinueLabel();
      Statement continueJmpStmt = new StatementJump(continueLabel.getRef(), new StatementSource(ctx), Comment.NO_COMMENTS);
      sequence.addStatement(continueJmpStmt);
      return null;
   }

   @Override
   public Object visitStmtAsm(KickCParser.StmtAsmContext ctx) {
      // Find all defined labels in the ASM
      List<String> definedLabels = getAsmDefinedLabels(ctx);
      // Find all referenced symbols in the ASM
      Map<String, SymbolVariableRef> referenced = getAsmReferencedSymbolVariables(ctx, definedLabels);
      List<Comment> comments = ensureUnusedComments(getCommentsSymbol(ctx));

      AsmClobber declaredClobber = null;
      if(ctx.asmDirectives() != null) {
         List<AsmDirective> asmDirectives = this.visitAsmDirectives(ctx.asmDirectives());
         for(AsmDirective asmDirective : asmDirectives) {
            if(asmDirective instanceof AsmDirectiveClobber) {
               declaredClobber = ((AsmDirectiveClobber) asmDirective).getClobber();
            } else {
               throw new CompileError("inline ASM does not support directive " + asmDirective, new StatementSource(ctx));
            }
         }
      }
      StatementAsm statementAsm = new StatementAsm(ctx.asmLines(), referenced, declaredClobber, new StatementSource(ctx), comments);
      sequence.addStatement(statementAsm);
      return null;
   }

   /**
    * Find all referenced symbol variables
    *
    * @param ctx An ASM statement
    * @param definedLabels All labels defined in the ASM
    * @return All variables/constants referenced in the ASM. Some may be ForwardVariableRefs to be resolved later.
    */
   private Map<String, SymbolVariableRef> getAsmReferencedSymbolVariables(KickCParser.StmtAsmContext ctx, List<String> definedLabels) {
      Map<String, SymbolVariableRef> referenced = new LinkedHashMap<>();
      KickCBaseVisitor<Void> findReferenced = new KickCBaseVisitor<Void>() {

         @Override
         public Void visitAsmExprBinary(KickCParser.AsmExprBinaryContext ctx) {
            ParseTree operator = ctx.getChild(1);
            if(operator.getText().equals(".")) {
               // Skip any . operator for now as it accesses data in another scope.
               // TODO Implement checking of labels/constants in other scopes
               return null;
            } else {
               return super.visitAsmExprBinary(ctx);
            }
         }

         @Override
         public Void visitAsmExprLabel(KickCParser.AsmExprLabelContext ctxLabel) {
            String label = ctxLabel.NAME().toString();
            if(!definedLabels.contains(label)) {
               // Look for the symbol
               Symbol symbol = getCurrentScope().getSymbol(ctxLabel.NAME().getText());
               if(symbol instanceof Variable) {
                  Variable variable = (Variable) symbol;
                  referenced.put(label, variable.getRef());
               } else {
                  // Either forward reference or a non-existing variable. Create a forward reference for later resolving.
                  referenced.put(label, new ForwardVariableRef(ctxLabel.NAME().getText()));
               }
            }
            return super.visitAsmExprLabel(ctxLabel);
         }
      };
      findReferenced.visit(ctx.asmLines());
      return referenced;
   }

   /**
    * Find all labels defined in the ASM (not multilabels).
    *
    * @param ctx An ASM statement
    * @return All labels defined in the ASM.
    */
   private List<String> getAsmDefinedLabels(KickCParser.StmtAsmContext ctx) {
      List<String> definedLabels = new ArrayList<>();
      KickCBaseVisitor<Void> findDefinedLabels = new KickCBaseVisitor<Void>() {
         @Override
         public Void visitAsmLabelName(KickCParser.AsmLabelNameContext ctx) {
            String label = ctx.NAME().getText();
            definedLabels.add(label);
            return super.visitAsmLabelName(ctx);
         }
      };
      findDefinedLabels.visit(ctx.asmLines());
      return definedLabels;
   }

   @Override
   public Void visitStmtReturn(KickCParser.StmtReturnContext ctx) {
      Procedure procedure = getCurrentProcedure();
      KickCParser.CommaExprContext exprCtx = ctx.commaExpr();
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
   public Object visitStructDef(KickCParser.StructDefContext ctx) {
      String structDefName;
      if(ctx.NAME() != null) {
         structDefName = ctx.NAME().getText();
      } else {
         structDefName = getCurrentScope().allocateIntermediateVariableName();
      }
      StructDefinition structDefinition = getCurrentScope().addStructDefinition(structDefName);
      scopeStack.push(structDefinition);
      declVarStructMember = true;
      for(KickCParser.StructMembersContext memberCtx : ctx.structMembers()) {
         visit(memberCtx);
      }
      declVarStructMember = false;
      scopeStack.pop();
      return structDefinition.getType();
   }

   @Override
   public Object visitStructRef(KickCParser.StructRefContext ctx) {
      String structDefName = ctx.NAME().getText();
      StructDefinition structDefinition = getCurrentScope().getStructDefinition(structDefName);
      return structDefinition.getType();
   }

   @Override
   public SymbolType visitTypeSignedSimple(KickCParser.TypeSignedSimpleContext ctx) {
      String signedness = ctx.getChild(0).getText();

      String simpleTypeName;
      if(ctx.SIMPLETYPE() != null) {
         simpleTypeName = ctx.SIMPLETYPE().getText();
      } else {
         simpleTypeName = "int";
      }
      return SymbolType.get(signedness + " " + simpleTypeName);
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
      if(!(val instanceof LValue)) {
         throw new CompileError("Error! Illegal assignment Lvalue " + val.toString(), new StatementSource(ctx));
      }
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
      LValue rValue1 = copyLValue(lValue);
      Statement stmt = new StatementAssignment(lValue, rValue1, operator, rValue, new StatementSource(ctx), ensureUnusedComments(getCommentsSymbol(ctx)));
      sequence.addStatement(stmt);
      return lValue;
   }

   private LValue copyLValue(LValue lValue) {
      if(lValue instanceof VariableRef) {
         return new VariableRef(((VariableRef) lValue).getFullName());
      } else if(lValue instanceof LvalueIntermediate) {
         return new LvalueIntermediate((VariableRef) copyLValue(((LvalueIntermediate) lValue).getVariable()));
      } else if(lValue instanceof PointerDereferenceSimple) {
         return new PointerDereferenceSimple(((PointerDereferenceSimple) lValue).getPointer());
      } else if(lValue instanceof PointerDereferenceIndexed) {
         return new PointerDereferenceIndexed(((PointerDereferenceIndexed) lValue).getPointer(), ((PointerDereferenceIndexed) lValue).getIndex());
      } else {
         throw new CompileError("Unknown LValue type " + lValue);
      }
   }

   @Override
   public Object visitExprDot(KickCParser.ExprDotContext ctx) {
      RValue structExpr = (RValue) visit(ctx.expr());
      String name = ctx.NAME().getText();
      return new StructMemberRef(structExpr, name);
   }

   @Override
   public RValue visitExprCast(KickCParser.ExprCastContext ctx) {
      RValue child = (RValue) this.visit(ctx.expr());
      SymbolType castType = (SymbolType) this.visit(ctx.typeDecl());
      Operator operator = Operators.getCastUnary(castType);
      VariableIntermediate tmpVar = getCurrentScope().addVariableIntermediate();
      VariableRef tmpVarRef = tmpVar.getRef();
      Statement stmt = new StatementAssignment(tmpVarRef, operator, child, new StatementSource(ctx), ensureUnusedComments(getCommentsSymbol(ctx)));
      sequence.addStatement(stmt);
      return tmpVarRef;
   }

   @Override
   public Object visitExprSizeOf(KickCParser.ExprSizeOfContext ctx) {
      if(ctx.typeDecl() != null) {
         // sizeof(type) - add directly
         SymbolType type = (SymbolType) this.visit(ctx.typeDecl());
         return OperatorSizeOf.getSizeOfConstantVar(program.getScope(), type);
      } else {
         // sizeof(expression) - add a unary expression to be resolved later
         RValue child = (RValue) this.visit(ctx.expr());
         VariableIntermediate tmpVar = getCurrentScope().addVariableIntermediate();
         VariableRef tmpVarRef = tmpVar.getRef();
         Statement stmt = new StatementAssignment(tmpVarRef, Operators.SIZEOF, child, new StatementSource(ctx), ensureUnusedComments(getCommentsSymbol(ctx)));
         sequence.addStatement(stmt);
         return tmpVarRef;
      }
   }

   @Override
   public Object visitExprTypeId(KickCParser.ExprTypeIdContext ctx) {
      if(ctx.typeDecl() != null) {
         // typeid(type) - add directly
         SymbolType type = (SymbolType) this.visit(ctx.typeDecl());
         return OperatorTypeId.getTypeIdConstantVar(program.getScope(), type);
      } else {
         // typeid(expression) - add a unary expression to be resolved later
         RValue child = (RValue) this.visit(ctx.expr());
         VariableIntermediate tmpVar = getCurrentScope().addVariableIntermediate();
         VariableRef tmpVarRef = tmpVar.getRef();
         Statement stmt = new StatementAssignment(tmpVarRef, Operators.TYPEID, child, new StatementSource(ctx), ensureUnusedComments(getCommentsSymbol(ctx)));
         sequence.addStatement(stmt);
         return tmpVarRef;
      }
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
      VariableIntermediate tmpVar = getCurrentScope().addVariableIntermediate();
      VariableRef tmpVarRef = tmpVar.getRef();

      String procedureName;
      if(ctx.expr() instanceof KickCParser.ExprIdContext) {
         procedureName = ctx.expr().getText();
         sequence.addStatement(new StatementCall(tmpVarRef, procedureName, parameters, new StatementSource(ctx), ensureUnusedComments(getCommentsSymbol(ctx))));
      } else {
         RValue procedurePointer = (RValue) this.visit(ctx.expr());
         sequence.addStatement(new StatementCallPointer(tmpVarRef, procedurePointer, parameters, new StatementSource(ctx), ensureUnusedComments(getCommentsSymbol(ctx))));
      }
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
      RValue array = (RValue) visit(ctx.expr());
      RValue index = (RValue) visit(ctx.commaExpr());
      return new PointerDereferenceIndexed(array, index);
   }

   @Override
   public RValue visitExprNumber(KickCParser.ExprNumberContext ctx) {
      return NumberParser.parseIntegerLiteral(ctx.getText());
   }

   /** The current string encoding used if no explicit encoding is specified. */
   ConstantString.Encoding currentEncoding = ConstantString.Encoding.SCREENCODE_MIXED;

   @Override
   public RValue visitExprString(KickCParser.ExprStringContext ctx) {
      String stringValue = "";
      String subText = "";
      String lastSuffix = "";
      ConstantString.Encoding encoding = null;
      for(TerminalNode stringNode : ctx.STRING()) {
         subText = stringNode.getText();
         String suffix = subText.substring(subText.lastIndexOf('"') + 1);

         if(suffix.contains("pm")) {
            if(encoding != null && !encoding.equals(ConstantString.Encoding.PETSCII_MIXED))
               throw new CompileError("Cannot mix encodings in concatenated strings " + ctx.getText(), new StatementSource(ctx));
            encoding = ConstantString.Encoding.PETSCII_MIXED;
         } else if(suffix.contains("pu")) {
            if(encoding != null && !encoding.equals(ConstantString.Encoding.PETSCII_UPPER))
               throw new CompileError("Cannot mix encodings in concatenated strings " + ctx.getText(), new StatementSource(ctx));
            encoding = ConstantString.Encoding.PETSCII_UPPER;
         } else if(suffix.contains("p")) {
            if(encoding != null && !encoding.equals(ConstantString.Encoding.PETSCII_MIXED))
               throw new CompileError("Cannot mix encodings in concatenated strings " + ctx.getText(), new StatementSource(ctx));
            encoding = ConstantString.Encoding.PETSCII_MIXED;
         } else if(suffix.contains("sm")) {
            if(encoding != null && !encoding.equals(ConstantString.Encoding.SCREENCODE_MIXED))
               throw new CompileError("Cannot mix encodings in concatenated strings " + ctx.getText(), new StatementSource(ctx));
            encoding = ConstantString.Encoding.SCREENCODE_MIXED;
         } else if(suffix.contains("su")) {
            if(encoding != null && !encoding.equals(ConstantString.Encoding.SCREENCODE_UPPER))
               throw new CompileError("Cannot mix encodings in concatenated strings " + ctx.getText(), new StatementSource(ctx));
            encoding = ConstantString.Encoding.SCREENCODE_UPPER;
         } else if(suffix.contains("s")) {
            if(encoding != null && !encoding.equals(ConstantString.Encoding.SCREENCODE_MIXED))
               throw new CompileError("Cannot mix encodings in concatenated strings " + ctx.getText(), new StatementSource(ctx));
            encoding = ConstantString.Encoding.SCREENCODE_MIXED;
         }

         lastSuffix = suffix;
         stringValue += subText.substring(1, subText.lastIndexOf('"'));
      }
      if(!lastSuffix.contains("z")) {
         stringValue += "@";
      }
      if(encoding == null) encoding = currentEncoding;
      return new ConstantString(stringValue, encoding);
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
      VariableIntermediate tmpVar = getCurrentScope().addVariableIntermediate();
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
      // Special handling of negative literal number
      if(child instanceof ConstantInteger && operator.equals(Operators.NEG)) {
         return new ConstantInteger(-((ConstantInteger) child).getInteger(), ((ConstantInteger) child).getType());
      } else {
         VariableIntermediate tmpVar = getCurrentScope().addVariableIntermediate();
         VariableRef tmpVarRef = tmpVar.getRef();
         Statement stmt = new StatementAssignment(tmpVarRef, operator, child, new StatementSource(ctx), ensureUnusedComments(getCommentsSymbol(ctx)));
         sequence.addStatement(stmt);
         return tmpVarRef;
      }
   }

   @Override
   public RValue visitExprTernary(KickCParser.ExprTernaryContext ctx) {
      RValue condValue = (RValue) this.visit(ctx.expr(0));
      Label trueLabel = getCurrentScope().addLabelIntermediate();
      Label falseLabel = getCurrentScope().addLabelIntermediate();
      Label endJumpLabel = getCurrentScope().addLabelIntermediate();
      sequence.addStatement(new StatementConditionalJump(condValue, trueLabel.getRef(), new StatementSource(ctx), Comment.NO_COMMENTS));
      sequence.addStatement(new StatementLabel(falseLabel.getRef(), new StatementSource(ctx), Comment.NO_COMMENTS));
      RValue falseValue = (RValue) this.visit(ctx.expr(2));
      VariableRef falseVar = getCurrentScope().addVariableIntermediate().getRef();
      sequence.addStatement(new StatementAssignment(falseVar, null, null, falseValue, new StatementSource(ctx), Comment.NO_COMMENTS));
      LabelRef falseExitLabel = sequence.getCurrentBlockLabel();
      sequence.addStatement(new StatementJump(endJumpLabel.getRef(), new StatementSource(ctx), Comment.NO_COMMENTS));
      sequence.addStatement(new StatementLabel(trueLabel.getRef(), new StatementSource(ctx), Comment.NO_COMMENTS));
      RValue trueValue = (RValue) this.visit(ctx.expr(1));
      VariableRef trueVar = getCurrentScope().addVariableIntermediate().getRef();
      sequence.addStatement(new StatementAssignment(trueVar, null, null, trueValue, new StatementSource(ctx), Comment.NO_COMMENTS));
      LabelRef trueExitLabel = sequence.getCurrentBlockLabel();
      sequence.addStatement(new StatementLabel(endJumpLabel.getRef(), new StatementSource(ctx), Comment.NO_COMMENTS));
      StatementPhiBlock phiBlock = new StatementPhiBlock(Comment.NO_COMMENTS);
      phiBlock.setSource(new StatementSource(ctx));
      VariableRef finalVar = getCurrentScope().addVariableIntermediate().getRef();
      StatementPhiBlock.PhiVariable phiVariable = phiBlock.addPhiVariable(finalVar);
      phiVariable.setrValue(trueExitLabel, trueVar);
      phiVariable.setrValue(falseExitLabel, falseVar);
      sequence.addStatement(phiBlock);
      return finalVar;
   }

   @Override
   public Object visitCommaNone(KickCParser.CommaNoneContext ctx) {
      return this.visit(ctx.expr());
   }

   @Override
   public Object visitCommaSimple(KickCParser.CommaSimpleContext ctx) {
      this.visit(ctx.commaExpr());
      return this.visit(ctx.expr());
   }

   @Override
   public Object visitExprPreMod(KickCParser.ExprPreModContext ctx) {
      return this.visit(ctx.expr());
   }

   @Override
   public Object visitExprPostMod(KickCParser.ExprPostModContext ctx) {
      return this.visit(ctx.expr());
   }

   @Override
   public RValue visitExprPar(KickCParser.ExprParContext ctx) {
      return (RValue) this.visit(ctx.commaExpr());
   }

   @Override
   public RValue visitExprId(KickCParser.ExprIdContext ctx) {
      Symbol symbol = getCurrentScope().getSymbol(ctx.NAME().getText());
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
               if(newlineCount > 1 && comments.size() > 0) {
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
                  text = text.substring(2, text.length() - 2);
                  isBlock = true;
               }
               Comment comment = new Comment(text);
               comment.setBlock(isBlock);
               comment.setTokenIndex(hiddenToken.getTokenIndex());
               comments.add(comment);
            }
         }
      }
      if(comments.size() > 0) {
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
      if(candidate.size() == 0) {
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
      if(commentBlocks.size() == 0) {
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
      if(commentBlocks.size() == 0) {
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

   /** Reservation of zero-page addresses */
   private static class DirectiveReserveZp implements Directive {
      List<Number> reservedZp;

      public DirectiveReserveZp(List<Number> reservedZp) {
         this.reservedZp = reservedZp;
      }

      public List<Number> getReservedZp() {
         return reservedZp;
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

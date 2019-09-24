package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.NumberParser;
import dk.camelot64.kickc.SourceLoader;
import dk.camelot64.kickc.asm.AsmClobber;
import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.operators.*;
import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.symbols.*;
import dk.camelot64.kickc.model.types.*;
import dk.camelot64.kickc.model.values.*;
import dk.camelot64.kickc.parser.CParser;
import dk.camelot64.kickc.parser.KickCParser;
import dk.camelot64.kickc.parser.KickCParserBaseVisitor;
import org.antlr.v4.runtime.BufferedTokenStream;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.misc.Interval;
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
public class Pass0GenerateStatementSequence extends KickCParserBaseVisitor<Object> {

   /** The C parser keeping track of C-files and lexers */
   private CParser cParser;

   /** The source ANTLR parse tree of the source file. */
   private KickCParser.FileContext fileCtx;

   /** The program containing all compile structures. */
   private Program program;
   /** Used to build the statements of the source file. */
   private StatementSequence sequence;
   /** Used to build the scopes of the source file. */
   private Stack<Scope> scopeStack;

   public Pass0GenerateStatementSequence(CParser cParser, KickCParser.FileContext fileCtx, Program program) {
      this.cParser = cParser;
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
      this.visit(ctx.declSeq());
      return null;
   }

   @Override
   public Object visitImportDecl(KickCParser.ImportDeclContext ctx) {
      String importName = ctx.STRING().getText();
      String importFileName = importName.substring(1, importName.length() - 1);
      if(program.getLog().isVerboseParse()) {
         program.getLog().append("Importing " + importFileName);
      }
      // The Parser / Lexer will automatically add the import file content here in the token stream
      //Path currentPath = file.toPath().getParent();
      //SourceLoader.loadAndParseFile(importFileName, currentPath, program);
      return null;
   }

   @Override
   public Object visitGlobalDirectiveLinkScript(KickCParser.GlobalDirectiveLinkScriptContext ctx) {
      String linkName = ctx.STRING().getText();
      String linkFileName = linkName.substring(1, linkName.length() - 1);
      program.getLog().append("Loading link script " + linkName);
      Path currentPath = cParser.getSourceFolderPath(ctx);
      SourceLoader.loadLinkScriptFile(linkFileName, currentPath, program);
      return null;
   }

   @Override
   public Object visitGlobalDirectiveReserve(KickCParser.GlobalDirectiveReserveContext ctx) {
      List<Integer> reservedZps = new ArrayList<>();
      for(TerminalNode reservedNum : ctx.NUMBER()) {
         Number reservedZp = NumberParser.parseLiteral(reservedNum.getText());
         reservedZps.add(reservedZp.intValue());
      }
      program.addReservedZps(reservedZps);
      return null;
   }

   @Override
   public Object visitGlobalDirectiveEncoding(KickCParser.GlobalDirectiveEncodingContext ctx) {
      try {
         this.currentEncoding = ConstantString.Encoding.valueOf(ctx.NAME().getText().toUpperCase(Locale.ENGLISH));
      } catch(IllegalArgumentException e) {
         throw new CompileError("Unknown string encoding " + ctx.NAME().getText(), new StatementSource(ctx));
      }
      return null;
   }

   @Override
   public Object visitGlobalDirectivePc(KickCParser.GlobalDirectivePcContext ctx) {
      Number programPc = NumberParser.parseLiteral(ctx.NUMBER().getText());
      if(programPc != null) {
         program.setProgramPc(programPc);
      } else {
         throw new CompileError("Cannot parse #pc directive", new StatementSource(ctx));
      }
      return null;
   }

   @Override
   public Object visitGlobalDirectivePlatform(KickCParser.GlobalDirectivePlatformContext ctx) {
      TargetPlatform platform = TargetPlatform.getTargetPlatform(ctx.NAME().getText());
      if(platform != null) {
         program.setTargetPlatform(platform);
      } else {
         throw new CompileError("Unknown target platform in #pragma platform directive", new StatementSource(ctx));
      }
      return null;
   }

   @Override
   public Object visitGlobalDirectiveCpu(KickCParser.GlobalDirectiveCpuContext ctx) {
      TargetCpu cpu = TargetCpu.getTargetCpu(ctx.NAME().getText());
      if(cpu != null) {
         program.setTargetCpu(cpu);
         program.initAsmFragmentSynthesizer();
      } else {
         throw new CompileError("Unknown target CPU in #pragma cpu directive", new StatementSource(ctx));
      }
      return null;
   }

   /** The current calling convention for procedures. */
   Procedure.CallingConvension currentCallingConvention = Procedure.CallingConvension.PHI_CALL;

   @Override
   public Object visitGlobalDirectiveCalling(KickCParser.GlobalDirectiveCallingContext ctx) {
      Procedure.CallingConvension callingConvension = Procedure.CallingConvension.getCallingConvension(ctx.CALLINGCONVENTION().getText());
      if(callingConvension!=null) {
         currentCallingConvention = callingConvension;
      }
      return null;
   }

   /** The current code segment - if null the default segment is used. */
   String currentCodeSegment = Scope.SEGMENT_CODE_DEFAULT;

   @Override
   public Object visitGlobalDirectiveCodeSeg(KickCParser.GlobalDirectiveCodeSegContext ctx) {
      this.currentCodeSegment = ctx.NAME().getText();
      return null;
   }

   /** The current data segment - if null the default segment is used. */
   String currentDataSegment = Scope.SEGMENT_DATA_DEFAULT;

   @Override
   public Object visitGlobalDirectiveDataSeg(KickCParser.GlobalDirectiveDataSegContext ctx) {
      this.currentDataSegment = ctx.NAME().getText();
      return null;
   }

   @Override
   public Object visitDeclFunction(KickCParser.DeclFunctionContext ctx) {
      this.visitDeclTypes(ctx.declTypes());
      SymbolType type = declVarType;
      List<Directive> directives = declVarDirectives;
      String name = ctx.NAME().getText();
      Procedure procedure = getCurrentScope().addProcedure(name, type, currentCodeSegment, currentDataSegment, currentCallingConvention);
      addDirectives(procedure, directives, StatementSource.procedureBegin(ctx));
      procedure.setComments(ensureUnusedComments(getCommentsSymbol(ctx)));
      scopeStack.push(procedure);
      Label procExit = procedure.addLabel(SymbolRef.PROCEXIT_BLOCK_NAME);
      VariableUnversioned returnVar = null;
      if(!SymbolType.VOID.equals(type)) {
         returnVar = procedure.addVariable("return", type, procedure.getSegmentData());
      }
      List<Variable> parameterList = new ArrayList<>();
      if(ctx.parameterListDecl() != null) {
         parameterList = (List<Variable>) this.visit(ctx.parameterListDecl());
      }
      procedure.setParameters(parameterList);
      sequence.addStatement(new StatementProcedureBegin(procedure.getRef(), StatementSource.procedureBegin(ctx), Comment.NO_COMMENTS));
      // Add parameter assignments
      if(Procedure.CallingConvension.STACK_CALL.equals(procedure.getCallingConvension())) {
         for(Variable param : parameterList) {
            sequence.addStatement(new StatementAssignment(param.getRef(), new ParamValue(param.getRef()), StatementSource.procedureEnd(ctx), Comment.NO_COMMENTS));
         }
      }
      if(ctx.stmtSeq() != null) {
         this.visit(ctx.stmtSeq());
      }
      sequence.addStatement(new StatementLabel(procExit.getRef(), StatementSource.procedureEnd(ctx), Comment.NO_COMMENTS));
      if(Procedure.CallingConvension.PHI_CALL.equals(procedure.getCallingConvension()) && returnVar != null) {
         sequence.addStatement(new StatementAssignment(returnVar.getRef(), returnVar.getRef(), StatementSource.procedureEnd(ctx), Comment.NO_COMMENTS));
      }
      VariableRef returnVarRef = null;
      if(returnVar != null) {
         returnVarRef = returnVar.getRef();
      }
      sequence.addStatement(new StatementReturn(returnVarRef, StatementSource.procedureEnd(ctx), Comment.NO_COMMENTS));
      scopeStack.pop();
      sequence.addStatement(new StatementProcedureEnd(procedure.getRef(), StatementSource.procedureEnd(ctx), Comment.NO_COMMENTS));
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
      VariableUnversioned param = new VariableUnversioned(ctx.NAME().getText(), getCurrentScope(), type, currentDataSegment);
      // Set initial storage strategy
      param.setStorageStrategy(SymbolVariable.StorageStrategy.REGISTER);
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
      String kasm = ctx.KICKASM_BODY().getText();
      Pattern p = Pattern.compile("\\{\\{[\\s]*(.*)[\\s]*\\}\\}", Pattern.DOTALL);
      Matcher m = p.matcher(kasm);
      if(m.find()) {
         String kickAsmCode = m.group(1).replaceAll("\r", "");
         StatementKickAsm statementKickAsm = new StatementKickAsm(kickAsmCode, StatementSource.kickAsm(ctx), ensureUnusedComments(getCommentsSymbol(ctx)));
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
         return statementKickAsm;
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
      private SymbolRef uses;

      public SymbolRef getUses() {
         return uses;
      }

      AsmDirectiveUses(SymbolRef uses) {
         this.uses = uses;
      }

      public void setUses(SymbolRef uses) {
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
      SymbolRef variableRef;
      Symbol symbol = getCurrentScope().getSymbol(varName);
      if(symbol != null) {
         //Found an existing variable
         variableRef = symbol.getRef();
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
      Path currentPath = cParser.getSourceFolderPath(ctx);
      File resourceFile = SourceLoader.loadFile(resourceName, currentPath, program);
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
      String clobberString = ctx.STRING().getText().toUpperCase(Locale.ENGLISH);
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
      SymbolType varType = (SymbolType) visit(ctx.typeDecl());
      this.declVarType = varType;
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
   public Object visitDeclVariableInitExpr(KickCParser.DeclVariableInitExprContext ctx) {
      String varName = ctx.NAME().getText();
      VariableUnversioned lValue = visitDeclVariableInit(varName, ctx);
      SymbolType type = declVarType;
      List<Comment> comments = declVarComments;
      KickCParser.ExprContext initializer = ctx.expr();
      if(declVarStructMember) {
         if(initializer != null) {
            throw new CompileError("Initializers not supported inside structs " + type.getTypeName(), new StatementSource(ctx));
         }
      } else {
         if(initializer != null) {
            addInitialAssignment(initializer, lValue, comments, new StatementSource(ctx));
         } else {
            Statement initStmt;
            StatementSource statementSource = new StatementSource(ctx);
            initStmt = createDefaultInitializationStatement(lValue.getRef(), type, statementSource, ensureUnusedComments(comments));
            sequence.addStatement(initStmt);
         }

      }
      return null;
   }

   @Override
   public Object visitDeclVariableInitKasm(KickCParser.DeclVariableInitKasmContext ctx) {
      String varName = ctx.NAME().getText();
      VariableUnversioned lValue = visitDeclVariableInit(varName, ctx);
      SymbolType type = this.declVarType;
      List<Comment> comments = this.declVarComments;
      if(!(type instanceof SymbolTypeArray)) {
         throw new CompileError("KickAsm initializers only supported for arrays " + type.getTypeName(), new StatementSource(ctx));
      }
      // Add KickAsm statement
      StatementKickAsm kasm = (StatementKickAsm) this.visit(ctx.declKasm());
      if(kasm.getLocation() != null) {
         throw new CompileError("KickAsm initializers does not support 'location' directive.", new StatementSource(ctx));
      }
      if(kasm.getCycles() != null) {
         throw new CompileError("KickAsm initializers does not support 'cycles' directive.", new StatementSource(ctx));
      }
      if(kasm.getBytes() != null) {
         throw new CompileError("KickAsm initializers does not support 'bytes' directive.", new StatementSource(ctx));
      }
      if(kasm.getDeclaredClobber() != null) {
         throw new CompileError("KickAsm initializers does not support 'clobbers' directive.", new StatementSource(ctx));
      }
      ConstantArrayKickAsm constantArrayKickAsm = new ConstantArrayKickAsm(((SymbolTypeArray) type).getElementType(), kasm.getKickAsmCode(), kasm.getUses());
      // Remove the KickAsm statement
      sequence.getStatements().remove(sequence.getStatements().size() - 1);
      // Add an initializer statement instead
      Statement stmt = new StatementAssignment(lValue.getRef(), constantArrayKickAsm, new StatementSource(ctx), ensureUnusedComments(comments));
      sequence.addStatement(stmt);
      return null;
   }

   private VariableUnversioned visitDeclVariableInit(String varName, KickCParser.DeclVariableInitContext ctx) {
      List<Directive> directives = declVarDirectives;
      SymbolType type = declVarType;
      List<Comment> comments = declVarComments;

      VariableUnversioned lValue;
      try {
         lValue = getCurrentScope().addVariable(varName, type, currentDataSegment);
      } catch(CompileError e) {
         throw new CompileError(e.getMessage(), new StatementSource(ctx));
      }
      // Set initial storage strategy
      lValue.setStorageStrategy(SymbolVariable.StorageStrategy.REGISTER);
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
      return lValue;
   }

   /**
    * Create a statement that initializes a variable with the default (zero) value. The statement has to be added to the program by the caller.
    *
    * @param varRef The variable to initialize
    * @param type The type of the variable
    * @param statementSource The source line
    * @param comments Any comments to add to the output
    * @return The new statement
    */
   static Statement createDefaultInitializationStatement(VariableRef varRef, SymbolType type, StatementSource statementSource, List<Comment> comments) {
      Statement initStmt;
      if(type instanceof SymbolTypeIntegerFixed) {
         // Add an zero value initializer
         ConstantInteger zero = new ConstantInteger(0L, type);
         initStmt = new StatementAssignment(varRef, zero, statementSource, comments);
      } else if(type instanceof SymbolTypeArray) {
         // Add an zero-array initializer
         SymbolTypeArray typeArray = (SymbolTypeArray) type;
         RValue size = typeArray.getSize();
         if(size == null) {
            throw new CompileError("Error! Array has no declared size. " + varRef.toString(), statementSource);
         }
         initStmt = new StatementAssignment(varRef, new ArrayFilled(typeArray.getElementType(), size), statementSource, comments);
      } else if(type instanceof SymbolTypePointer) {
         // Add an zero value initializer
         SymbolTypePointer typePointer = (SymbolTypePointer) type;
         ConstantValue zero = new ConstantPointer(0L, typePointer.getElementType());
         initStmt = new StatementAssignment(varRef, zero, statementSource, comments);
      } else if(type instanceof SymbolTypeStruct) {
         // Add an zero-struct initializer
         SymbolTypeStruct typeStruct = (SymbolTypeStruct) type;
         initStmt = new StatementAssignment(varRef, new StructZero(typeStruct), statementSource, comments);
      } else {
         throw new CompileError("Default initializer not implemented for type " + type.getTypeName(), statementSource);
      }
      return initStmt;
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
            lValue.setStorageStrategy(SymbolVariable.StorageStrategy.CONSTANT);
         } else if(directive instanceof DirectiveVolatile) {
            lValue.setDeclaredVolatile(true);
         } else if(directive instanceof DirectiveExport) {
            lValue.setDeclaredExport(true);
         } else if(directive instanceof DirectiveAlign) {
            if(type instanceof SymbolTypeArray || type.equals(SymbolType.STRING)) {
               lValue.setDeclaredAlignment(((DirectiveAlign) directive).alignment);
            } else {
               throw new CompileError("Error! Cannot align variable that is not a string or an array " + lValue.toString(program), source);
            }
         } else if(directive instanceof DirectiveMemory) {
            DirectiveMemory directiveMemory = (DirectiveMemory) directive;
            lValue.setDeclaredAsMemory(true);
            lValue.setStorageStrategy(SymbolVariable.StorageStrategy.MEMORY);
            if(directiveMemory.address!=null) {
               lValue.setDeclaredMemoryAddress(directiveMemory.address);
            }
         } else if(directive instanceof DirectiveRegister) {
            DirectiveRegister directiveRegister = (DirectiveRegister) directive;
            lValue.setDeclaredAsRegister(true);
            lValue.setStorageStrategy(SymbolVariable.StorageStrategy.REGISTER);
            if(directiveRegister.name != null) {
               // Ignore register directive without parameter (all variables are placed on ZP and attempted register uplift anyways)
               Registers.Register register = Registers.getRegister(directiveRegister.name);
               if(register == null) {
                  throw new CompileError("Error! Unknown register " + directiveRegister.name, source);
               }
               lValue.setDeclaredRegister(register);
            } else if(directiveRegister.address != null) {
               // Allocate to specific address
               Long address = ((DirectiveRegister) directive).address;
               if(address>255) {
                  throw new CompileError("Error! Register not on zeropage " + directiveRegister.address, source);
               }
               Registers.Register register = new Registers.RegisterZpDeclared(address.intValue());
               lValue.setDeclaredRegister(register);
            }
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
         } else if(directive instanceof DirectiveCallingConvention) {
            procedure.setCallingConvension(((DirectiveCallingConvention) directive).callingConvension);
         } else if(directive instanceof DirectiveInterrupt) {
            procedure.setInterruptType(((DirectiveInterrupt) directive).interruptType);
         } else if(directive instanceof DirectiveReserveZp) {
            procedure.setReservedZps(((DirectiveReserveZp) directive).reservedZp);
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
         interruptType = ctx.getChild(2).getText().toUpperCase(Locale.ENGLISH);
      } else {
         // The default interrupt type
         interruptType = Procedure.InterruptType.DEFAULT.name();
      }
      Procedure.InterruptType type = Procedure.InterruptType.valueOf(interruptType);
      return new DirectiveInterrupt(type);
   }

   @Override
   public Directive visitDirectiveCallingConvention(KickCParser.DirectiveCallingConventionContext ctx) {
      Procedure.CallingConvension callingConvension = Procedure.CallingConvension.getCallingConvension(ctx.getText());
      return new DirectiveCallingConvention(callingConvension);
   }

   @Override
   public Directive visitDirectiveAlign(KickCParser.DirectiveAlignContext ctx) {
      Number alignment = NumberParser.parseLiteral(ctx.NUMBER().getText());
      return new DirectiveAlign(alignment.intValue());
   }

   @Override
   public Directive visitDirectiveRegister(KickCParser.DirectiveRegisterContext ctx) {
      if(ctx.NAME() != null) {
         return new DirectiveRegister(ctx.NAME().getText());
      } else if(ctx.NUMBER() != null) {
         try {
            ConstantInteger registerAddress = NumberParser.parseIntegerLiteral(ctx.NUMBER().getText());
            return new DirectiveRegister(registerAddress.getInteger());
         } catch(NumberFormatException e) {
            throw new CompileError(e.getMessage(), new StatementSource(ctx));
         }
      } else {
         return new DirectiveRegister(null);
      }
   }

   @Override
   public Object visitDirectiveMemory(KickCParser.DirectiveMemoryContext ctx) {
      if(ctx.NUMBER() != null) {
         try {
            ConstantInteger memoryAddress = NumberParser.parseIntegerLiteral(ctx.NUMBER().getText());
            return new DirectiveRegister(memoryAddress.getInteger());
         } catch(NumberFormatException e) {
            throw new CompileError(e.getMessage(), new StatementSource(ctx));
         }
      } else {
         return new DirectiveRegister(null);
      }
   }

   @Override
   public Directive visitDirectiveVolatile(KickCParser.DirectiveVolatileContext ctx) {
      return new DirectiveVolatile();
   }

   @Override
   public Object visitDirectiveExport(KickCParser.DirectiveExportContext ctx) {
      return new DirectiveExport();
   }

   @Override
   public Directive visitDirectiveReserveZp(KickCParser.DirectiveReserveZpContext ctx) {
      List<Integer> reservedZps = new ArrayList<>();
      for(TerminalNode reservedNum : ctx.NUMBER()) {
         int reservedZp = NumberParser.parseLiteral(reservedNum.getText()).intValue();
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
      PrePostModifierHandler.addPreModifiers(this, ctx.commaExpr(), new StatementSource(ctx));
      beginNotConsumedTracking();
      RValue exprVal = (RValue) this.visit(ctx.commaExpr());
      if(notConsumed(exprVal)) {
         // Make a tmpVar to create the statement
         VariableIntermediate tmpVar = getCurrentScope().addVariableIntermediate();
         List<Comment> comments = ensureUnusedComments(getCommentsSymbol(ctx));
         RValue rVal = exprVal;
         if(exprVal instanceof LValue) {
            rVal = copyLValue((LValue) exprVal);
         }
         sequence.addStatement(new StatementAssignment(tmpVar.getRef(), rVal, new StatementSource(ctx), comments));
      }
      endNotConsumedTracking();
      PrePostModifierHandler.addPostModifiers(this, ctx.commaExpr(), new StatementSource(ctx));
      return null;
   }

   @Override
   public Void visitStmtIfElse(KickCParser.StmtIfElseContext ctx) {
      KickCParser.StmtContext ifStmt = ctx.stmt(0);
      KickCParser.StmtContext elseStmt = ctx.stmt(1);
      PrePostModifierHandler.addPreModifiers(this, ctx.commaExpr(), StatementSource.ifThen(ctx));
      RValue rValue = (RValue) this.visit(ctx.commaExpr());
      List<Comment> comments = ensureUnusedComments(getCommentsSymbol(ctx));

      if(elseStmt == null) {
         // If without else - skip the entire section if condition not met
         VariableRef notExprVar = getCurrentScope().addVariableIntermediate().getRef();
         sequence.addStatement(new StatementAssignment(notExprVar, null, Operators.LOGIC_NOT, rValue, StatementSource.ifThen(ctx), comments));
         PrePostModifierHandler.addPostModifiers(this, ctx.commaExpr(), StatementSource.ifThen(ctx));
         Label endJumpLabel = getCurrentScope().addLabelIntermediate();
         sequence.addStatement(new StatementConditionalJump(notExprVar, endJumpLabel.getRef(), StatementSource.ifThen(ctx), Comment.NO_COMMENTS));
         this.visit(ifStmt);
         // No else statement - just add the label
         sequence.addStatement(new StatementLabel(endJumpLabel.getRef(), StatementSource.ifThen(ctx), Comment.NO_COMMENTS));
      } else {
         // If with else - jump to if section if condition met - fall into else otherwise.
         PrePostModifierHandler.addPostModifiers(this, ctx.commaExpr(), StatementSource.ifThen(ctx));
         Label ifJumpLabel = getCurrentScope().addLabelIntermediate();
         sequence.addStatement(new StatementConditionalJump(rValue, ifJumpLabel.getRef(), StatementSource.ifThen(ctx), comments));
         // Add else body
         this.visit(elseStmt);
         // There is an else statement - add the if part and any needed labels/jumps
         Label endJumpLabel = getCurrentScope().addLabelIntermediate();
         sequence.addStatement(new StatementJump(endJumpLabel.getRef(), StatementSource.ifElse(ctx), Comment.NO_COMMENTS));
         sequence.addStatement(new StatementLabel(ifJumpLabel.getRef(), StatementSource.ifThen(ctx), Comment.NO_COMMENTS));
         this.visit(ifStmt);
         StatementLabel endJumpTarget = new StatementLabel(endJumpLabel.getRef(), StatementSource.ifThen(ctx), Comment.NO_COMMENTS);
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

      /** true if the loop is a switch-statement. */
      boolean isSwitch;

      public Loop(Scope loopScope, boolean isSwitch) {
         this.loopScope = loopScope;
         this.isSwitch = isSwitch;
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
      loopStack.push(new Loop(blockScope, false));
      Label beginJumpLabel = getCurrentScope().addLabelIntermediate();
      Label doJumpLabel = getCurrentScope().addLabelIntermediate();
      Label endJumpLabel = getCurrentScope().addLabelIntermediate();
      List<Comment> comments = ensureUnusedComments(getCommentsSymbol(ctx));
      StatementLabel beginJumpTarget = new StatementLabel(beginJumpLabel.getRef(), StatementSource.whileDo(ctx), comments);
      sequence.addStatement(beginJumpTarget);
      PrePostModifierHandler.addPreModifiers(this, ctx.commaExpr(), StatementSource.whileDo(ctx));
      RValue rValue = (RValue) this.visit(ctx.commaExpr());
      PrePostModifierHandler.addPostModifiers(this, ctx.commaExpr(), StatementSource.whileDo(ctx));
      StatementConditionalJump doJmpStmt = new StatementConditionalJump(rValue, doJumpLabel.getRef(), StatementSource.whileDo(ctx), Comment.NO_COMMENTS);
      sequence.addStatement(doJmpStmt);
      Statement endJmpStmt = new StatementJump(endJumpLabel.getRef(), StatementSource.whileDo(ctx), Comment.NO_COMMENTS);
      sequence.addStatement(endJmpStmt);
      StatementLabel doJumpTarget = new StatementLabel(doJumpLabel.getRef(), StatementSource.whileDo(ctx), Comment.NO_COMMENTS);
      sequence.addStatement(doJumpTarget);
      // Reuse the begin jump target for continue.
      loopStack.peek().setContinueLabel(beginJumpLabel);
      addLoopBody(ctx.stmt());
      Statement beginJmpStmt = new StatementJump(beginJumpLabel.getRef(), StatementSource.whileDo(ctx), Comment.NO_COMMENTS);
      sequence.addStatement(beginJmpStmt);
      StatementLabel endJumpTarget = new StatementLabel(endJumpLabel.getRef(), StatementSource.whileDo(ctx), Comment.NO_COMMENTS);
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
      loopStack.push(new Loop(blockScope, false));
      List<Comment> comments = ensureUnusedComments(getCommentsSymbol(ctx));
      Label beginJumpLabel = getCurrentScope().addLabelIntermediate();
      StatementLabel beginJumpTarget = new StatementLabel(beginJumpLabel.getRef(), StatementSource.doWhile(ctx), comments);
      sequence.addStatement(beginJumpTarget);
      addLoopBody(ctx.stmt());
      addLoopContinueLabel(loopStack.peek(), ctx);
      PrePostModifierHandler.addPreModifiers(this, ctx.commaExpr(), StatementSource.doWhile(ctx));
      RValue rValue = (RValue) this.visit(ctx.commaExpr());
      PrePostModifierHandler.addPostModifiers(this, ctx.commaExpr(), StatementSource.doWhile(ctx));
      StatementConditionalJump doJmpStmt = new StatementConditionalJump(rValue, beginJumpLabel.getRef(), StatementSource.doWhile(ctx), Comment.NO_COMMENTS);
      sequence.addStatement(doJmpStmt);
      addDirectives(doJmpStmt, ctx.directive());
      addLoopBreakLabel(loopStack.pop(), ctx);
      scopeStack.pop();
      return null;
   }

   @Override
   public Object visitStmtSwitch(KickCParser.StmtSwitchContext ctx) {
      Loop containingLoop = null;
      if(!loopStack.isEmpty()) {
         containingLoop = loopStack.peek();
      }
      // Create a block scope - to keep all statements of the loop inside it
      BlockScope blockScope = getCurrentScope().addBlockScope();
      scopeStack.push(blockScope);
      Loop switchLoop = new Loop(blockScope, true);
      if(containingLoop != null) {
         switchLoop.setContinueLabel(containingLoop.getOrCreateContinueLabel());
      }
      loopStack.push(switchLoop);
      List<Comment> comments = ensureUnusedComments(getCommentsSymbol(ctx));
      // TODO: Add comments to next stmt
      // Evaluate the switch-expression
      PrePostModifierHandler.addPreModifiers(this, ctx.commaExpr(), StatementSource.switchExpr(ctx));
      RValue eValue = (RValue) this.visit(ctx.commaExpr());
      PrePostModifierHandler.addPostModifiers(this, ctx.commaExpr(), StatementSource.switchExpr(ctx));
      // Add case conditional jumps
      List<SwitchCaseBody> caseBodies = new ArrayList<>();
      for(KickCParser.SwitchCaseContext caseContext : ctx.switchCases().switchCase()) {
         List<Comment> caseComments = ensureUnusedComments(getCommentsSymbol(caseContext));
         RValue cValue = (RValue) this.visit(caseContext.expr());
         Label cJumpLabel = getCurrentScope().addLabelIntermediate();
         caseBodies.add(new SwitchCaseBody(cJumpLabel, caseContext.stmtSeq(), StatementSource.switchCase(caseContext)));
         StatementConditionalJump cJmpStmt = new StatementConditionalJump(eValue, Operators.EQ, cValue, cJumpLabel.getRef(), StatementSource.switchCase(caseContext), caseComments);
         sequence.addStatement(cJmpStmt);
      }
      // Add default ending jump
      Label dJumpLabel = getCurrentScope().addLabelIntermediate();
      StatementJump dJmpStmt = new StatementJump(dJumpLabel.getRef(), StatementSource.switchDefault(ctx.switchCases()), Comment.NO_COMMENTS);
      sequence.addStatement(dJmpStmt);
      // Add case labels & bodies
      for(SwitchCaseBody caseBody : caseBodies) {
         StatementLabel cJumpTarget = new StatementLabel(caseBody.cJumpLabel.getRef(), caseBody.statementSource, Comment.NO_COMMENTS);
         sequence.addStatement(cJumpTarget);
         if(caseBody.stmtSequence != null) {
            this.visit(caseBody.stmtSequence);
         }
      }
      // Add default label
      StatementLabel dJumpTarget = new StatementLabel(dJumpLabel.getRef(), StatementSource.switchDefault(ctx.switchCases()), Comment.NO_COMMENTS);
      sequence.addStatement(dJumpTarget);
      if(ctx.switchCases().stmtSeq() != null) {
         this.visit(ctx.switchCases().stmtSeq());
      }
      addLoopBreakLabel(loopStack.pop(), ctx);
      scopeStack.pop();
      return null;
   }

   /** Holds the body of a switch() case. */
   public static class SwitchCaseBody {
      /** Label for the statments of the case. */
      Label cJumpLabel;

      /** Statments of the case. */
      KickCParser.StmtSeqContext stmtSequence;

      /** Source of the case. */
      StatementSource statementSource;

      SwitchCaseBody(Label cJumpLabel, KickCParser.StmtSeqContext stmtSequence, StatementSource statementSource) {
         this.cJumpLabel = cJumpLabel;
         this.stmtSequence = stmtSequence;
         this.statementSource = statementSource;
      }
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
      loopStack.push(new Loop(blockScope, false));
      // Add initialization
      this.visit(ctx.forClassicInit());
      KickCParser.StmtForContext stmtForCtx = (KickCParser.StmtForContext) ctx.getParent();
      // Add label
      Label beginJumpLabel = getCurrentScope().addLabelIntermediate();
      Label doJumpLabel = getCurrentScope().addLabelIntermediate();
      Label endJumpLabel = getCurrentScope().addLabelIntermediate();
      List<Comment> comments = getCommentsSymbol(stmtForCtx);
      StatementLabel repeatTarget = new StatementLabel(beginJumpLabel.getRef(), StatementSource.forClassic(ctx), comments);
      sequence.addStatement(repeatTarget);
      // Add condition
      KickCParser.CommaExprContext conditionCtx = ctx.commaExpr(0);
      PrePostModifierHandler.addPreModifiers(this, conditionCtx, StatementSource.forClassic(ctx));
      RValue rValue = (RValue) this.visit(conditionCtx);
      PrePostModifierHandler.addPostModifiers(this, conditionCtx, StatementSource.forClassic(ctx));
      // Add jump if condition was met
      StatementConditionalJump doJmpStmt = new StatementConditionalJump(rValue, doJumpLabel.getRef(), StatementSource.forClassic(ctx), Comment.NO_COMMENTS);
      sequence.addStatement(doJmpStmt);
      Statement endJmpStmt = new StatementJump(endJumpLabel.getRef(), StatementSource.forClassic(ctx), Comment.NO_COMMENTS);
      sequence.addStatement(endJmpStmt);
      StatementLabel doJumpTarget = new StatementLabel(doJumpLabel.getRef(), StatementSource.forClassic(ctx), Comment.NO_COMMENTS);
      sequence.addStatement(doJumpTarget);
      // Add body
      addLoopBody(stmtForCtx.stmt());
      // Add increment
      addLoopContinueLabel(loopStack.peek(), ctx);
      KickCParser.CommaExprContext incrementCtx = ctx.commaExpr(1);
      if(incrementCtx != null) {
         PrePostModifierHandler.addPreModifiers(this, incrementCtx, StatementSource.forClassic(ctx));
         this.visit(incrementCtx);
         PrePostModifierHandler.addPostModifiers(this, incrementCtx, StatementSource.forClassic(ctx));
      }
      // Jump back to beginning
      Statement beginJmpStmt = new StatementJump(beginJumpLabel.getRef(), StatementSource.forClassic(ctx), Comment.NO_COMMENTS);
      sequence.addStatement(beginJmpStmt);
      StatementLabel endJumpTarget = new StatementLabel(endJumpLabel.getRef(), StatementSource.forClassic(ctx), Comment.NO_COMMENTS);
      sequence.addStatement(endJumpTarget);
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
      loopStack.push(new Loop(blockScope, false));

      StatementSource statementSource = StatementSource.forRanged(ctx);

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
            lValue = getCurrentScope().addVariable(varName, varType, currentDataSegment);
         } catch(CompileError e) {
            throw new CompileError(e.getMessage(), statementSource);
         }
         // Set initial storage strategy
         lValue.setStorageStrategy(SymbolVariable.StorageStrategy.REGISTER);
         // Add directives
         addDirectives(lValue, varType, varDirectives, statementSource);
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
      Statement stmtInit = new StatementAssignment(lValue.getRef(), rangeFirstValue, statementSource, Comment.NO_COMMENTS);
      sequence.addStatement(stmtInit);
      // Add label
      List<Comment> comments = ensureUnusedComments(getCommentsSymbol(stmtForCtx));
      Label repeatLabel = getCurrentScope().addLabelIntermediate();
      StatementLabel repeatTarget = new StatementLabel(repeatLabel.getRef(), statementSource, comments);
      sequence.addStatement(repeatTarget);
      // Add body
      addLoopBody(stmtForCtx.stmt());
      addLoopContinueLabel(loopStack.peek(), ctx);
      // Add increment
      Statement stmtNxt = new StatementAssignment(lValue.getRef(), lValue.getRef(), Operators.PLUS, new RangeNext(rangeFirstValue, rangeLastValue), statementSource, Comment.NO_COMMENTS);
      sequence.addStatement(stmtNxt);
      // Add condition i!=last+1 or i!=last-1
      RValue beyondLastVal = new RangeComparison(rangeFirstValue, rangeLastValue, lValue.getType());
      VariableIntermediate tmpVar = getCurrentScope().addVariableIntermediate();
      VariableRef tmpVarRef = tmpVar.getRef();
      Statement stmtTmpVar = new StatementAssignment(tmpVarRef, lValue.getRef(), Operators.NEQ, beyondLastVal, statementSource, Comment.NO_COMMENTS);
      sequence.addStatement(stmtTmpVar);
      // Add jump if condition was met
      StatementConditionalJump doJmpStmt = new StatementConditionalJump(tmpVarRef, repeatLabel.getRef(), statementSource, Comment.NO_COMMENTS);
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
      Label continueLabel;
      if(currentLoop.isSwitch) {
         continueLabel = currentLoop.getContinueLabel();
         if(continueLabel == null) {
            throw new CompileError("Continue not inside a loop! ", new StatementSource(ctx));
         }
      } else {
         continueLabel = currentLoop.getOrCreateContinueLabel();
      }
      Statement continueJmpStmt = new StatementJump(continueLabel.getRef(), new StatementSource(ctx), Comment.NO_COMMENTS);
      sequence.addStatement(continueJmpStmt);
      return null;
   }

   @Override
   public Object visitStmtAsm(KickCParser.StmtAsmContext ctx) {
      // Find all defined labels in the ASM
      List<String> definedLabels = getAsmDefinedLabels(ctx);
      // Find all referenced symbols in the ASM
      Map<String, SymbolRef> referenced = getAsmReferencedSymbolVariables(ctx, definedLabels);
      List<Comment> comments = ensureUnusedComments(getCommentsSymbol(ctx));

      AsmClobber declaredClobber = null;
      if(ctx.asmDirectives() != null) {
         List<AsmDirective> asmDirectives = this.visitAsmDirectives(ctx.asmDirectives());
         for(AsmDirective asmDirective : asmDirectives) {
            if(asmDirective instanceof AsmDirectiveClobber) {
               declaredClobber = ((AsmDirectiveClobber) asmDirective).getClobber();
            } else {
               throw new CompileError("inline ASM does not support directive " + asmDirective, StatementSource.asm(ctx));
            }
         }
      }
      StatementAsm statementAsm = new StatementAsm(getSourceBody(ctx.asmLines()), referenced, declaredClobber, StatementSource.asm(ctx), comments);
      sequence.addStatement(statementAsm);
      return null;
   }

   /**
    * Extract the string source body representing a part of the parse tree
    *
    * @param sourceContext The parse tree context
    * @return The string source code.
    */
   private static String getSourceBody(ParserRuleContext sourceContext) {
      Token tokenStart = StatementSource.getToken(sourceContext, true);
      Token tokenStop = StatementSource.getToken(sourceContext, false);
      CharStream stream = tokenStart.getInputStream();
      int startIndex = tokenStart.getStartIndex();
      int stopIndex = tokenStop.getStopIndex();
      Interval interval = new Interval(startIndex, stopIndex);
      return stream.getText(interval);
   }

   /**
    * Find all referenced symbol variables
    *
    * @param ctx An ASM statement
    * @param definedLabels All labels defined in the ASM
    * @return All variables/constants referenced in the ASM. Some may be ForwardVariableRefs to be resolved later.
    */
   private Map<String, SymbolRef> getAsmReferencedSymbolVariables(KickCParser.StmtAsmContext ctx, List<String> definedLabels) {
      Map<String, SymbolRef> referenced = new LinkedHashMap<>();
      KickCParserBaseVisitor<Void> findReferenced = new KickCParserBaseVisitor<Void>() {

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
            String label = ctxLabel.ASM_NAME().toString();
            if(!definedLabels.contains(label)) {
               // Look for the symbol
               Symbol symbol = getCurrentScope().getSymbol(ctxLabel.ASM_NAME().getText());
               if(symbol != null) {
                  referenced.put(label, symbol.getRef());
               } else {
                  // Either forward reference or a non-existing variable. Create a forward reference for later resolving.
                  referenced.put(label, new ForwardVariableRef(ctxLabel.ASM_NAME().getText()));
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
      KickCParserBaseVisitor<Void> findDefinedLabels = new KickCParserBaseVisitor<Void>() {
         @Override
         public Void visitAsmLabelName(KickCParser.AsmLabelNameContext ctx) {
            String label = ctx.ASM_NAME().getText();
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
         PrePostModifierHandler.addPreModifiers(this, exprCtx, new StatementSource(ctx));
         rValue = (RValue) this.visit(exprCtx);
         Variable returnVar = procedure.getVariable("return");
         sequence.addStatement(new StatementAssignment(returnVar.getRef(), rValue, new StatementSource(ctx), ensureUnusedComments(getCommentsSymbol(ctx))));
         PrePostModifierHandler.addPostModifiers(this, exprCtx, new StatementSource(ctx));
      }
      Label returnLabel = procedure.getLabel(SymbolRef.PROCEXIT_BLOCK_NAME);
      sequence.addStatement(new StatementJump(returnLabel.getRef(), new StatementSource(ctx), ensureUnusedComments(getCommentsSymbol(ctx))));
      return null;
   }

   private void addInitialAssignment(KickCParser.ExprContext initializer, Variable lValue, List<Comment> comments, StatementSource statementSource) {
      PrePostModifierHandler.addPreModifiers(this, initializer, statementSource);
      RValue rValue = (RValue) visit(initializer);
      Statement stmt = new StatementAssignment(lValue.getRef(), rValue, statementSource, ensureUnusedComments(comments));
      sequence.addStatement(stmt);
      PrePostModifierHandler.addPostModifiers(this, initializer, statementSource);
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
      StructDefinition structDefinition = program.getScope().addStructDefinition(structDefName);
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
      if(structDefinition == null) {
         throw new CompileError("Unknown struct type " + structDefName, new StatementSource(ctx));
      }
      return structDefinition.getType();
   }

   @Override
   public Object visitTypeEnumDef(KickCParser.TypeEnumDefContext ctx) {
      return visit(ctx.enumDef());
   }

   private EnumDefinition currentEnum = null;

   @Override
   public Object visitEnumDef(KickCParser.EnumDefContext ctx) {
      try {
         String enumDefName;
         if(ctx.NAME() != null) {
            enumDefName = ctx.NAME().getText();
         } else {
            enumDefName = getCurrentScope().allocateIntermediateVariableName();
         }
         EnumDefinition enumDefinition = new EnumDefinition(enumDefName, getCurrentScope());
         getCurrentScope().add(enumDefinition);
         this.currentEnum = enumDefinition;
         scopeStack.push(currentEnum);
         visit(ctx.enumMemberList());
         scopeStack.pop();
         this.currentEnum = null;
         // Copy all members to upper-level scope
         Scope parentScope = getCurrentScope();
         while(parentScope instanceof StructDefinition) parentScope = parentScope.getScope();
         for(ConstantVar member : enumDefinition.getAllConstants(false)) {
            parentScope.add(new ConstantVar(member.getLocalName(), parentScope, SymbolType.BYTE, member.getValue(), currentDataSegment));
         }
         return SymbolType.BYTE;
      } catch(CompileError e) {
         throw new CompileError(e.getMessage(), new StatementSource(ctx));
      }
   }

   @Override
   public Object visitEnumMember(KickCParser.EnumMemberContext ctx) {
      String memberName = ctx.NAME().getText();
      ConstantValue enumValue;
      if(ctx.expr() != null) {
         RValue exprVal = (RValue) visit(ctx.expr());
         if(!(exprVal instanceof ConstantValue)) {
            throw new CompileError("Enum value not constant " + memberName, new StatementSource(ctx));
         }
         enumValue = (ConstantValue) exprVal;
      } else {
         // No specific value - find previous value
         List<ConstantVar> values = new ArrayList<>(currentEnum.getAllConstants(false));
         if(values.isEmpty()) {
            enumValue = new ConstantInteger(0L, SymbolType.BYTE);
         } else {
            ConstantVar prevEnumMember = values.get(values.size() - 1);
            ConstantValue prevValue = prevEnumMember.getValue();
            if(prevValue instanceof ConstantInteger) {
               enumValue = new ConstantInteger(((ConstantInteger) prevValue).getInteger() + 1, SymbolType.BYTE);
            } else {
               enumValue = new ConstantBinary(prevValue, Operators.PLUS, new ConstantInteger(1L, SymbolType.BYTE));

            }
         }
      }
      currentEnum.add(new ConstantVar(memberName, getCurrentScope(), SymbolType.BYTE, enumValue, currentDataSegment));
      return null;
   }

   @Override
   public Object visitTypeEnumRef(KickCParser.TypeEnumRefContext ctx) {
      return visit(ctx.enumRef());
   }

   @Override
   public Object visitEnumRef(KickCParser.EnumRefContext ctx) {
      String enumDefName = ctx.NAME().getText();
      EnumDefinition enumDefinition = getCurrentScope().getEnumDefinition(enumDefName);
      if(enumDefinition == null) {
         throw new CompileError("Unknown enum " + enumDefName, new StatementSource(ctx));
      }
      return SymbolType.BYTE;
   }

   @Override
   public Object visitTypeNamedRef(KickCParser.TypeNamedRefContext ctx) {
      Scope typeDefScope = program.getScope().getTypeDefScope();
      Variable typeDefVariable = typeDefScope.getVariable(ctx.getText());
      if(typeDefVariable != null) {
         return typeDefVariable.getType();
      }
      throw new CompileError("Unknown type " + ctx.getText(), new StatementSource(ctx));
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
      String fullName = signedness + " " + simpleTypeName;
      SymbolType symbolType = SymbolType.get(fullName);
      if(symbolType == null) {
         throw new CompileError("Unknown type " + fullName, new StatementSource(ctx));
      }
      return symbolType;
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
   public Object visitTypeDef(KickCParser.TypeDefContext ctx) {
      Scope typedefScope = program.getScope().getTypeDefScope();
      scopeStack.push(typedefScope);
      SymbolType type = (SymbolType) this.visit(ctx.typeDecl());
      String typedefName = ctx.NAME().getText();
      typedefScope.addVariable(typedefName, type, currentDataSegment);
      scopeStack.pop();
      return null;
   }


   /**
    * RValues that have not yet been output as part of a statement.
    * The expression visitor methods updates this so that the surrounding
    * statement can make sure to output any rValue that has not been output.
    * Null if we are not currently monitoring this.
    */
   public Set<RValue> exprNotConsumed = null;

   /**
    * Begins monitoring list of expressions not consumed.
    */
   void beginNotConsumedTracking() {
      exprNotConsumed = new LinkedHashSet<>();
   }

   /**
    * Ends monitoring list of expressions not consumed.
    */
   void endNotConsumedTracking() {
      exprNotConsumed = null;
   }

   /**
    * Consumes an RValue by outputting it as part of a statement.
    * This helps ensure that all expression RValues are output in statements
    *
    * @param rValue The RValue being consume
    */
   void consumeExpr(RValue rValue) {
      if(exprNotConsumed != null)
         exprNotConsumed.remove(rValue);
   }

   /**
    * Marks an expression that has been produced which has not been output as part of a statement.
    * When the RValue is output in a statement it will be consumed using {@link #consumeExpr(RValue)}.
    *
    * @param rValue The RValue that has been produced but not consumed
    */
   void addExprToConsume(RValue rValue) {
      if(exprNotConsumed != null)
         exprNotConsumed.add(rValue);
   }

   /**
    * Examines whether an RValue is in the list of non-consumed RValues.
    *
    * @return true if the RValue is in the list
    */
   boolean notConsumed(RValue rValue) {
      return exprNotConsumed.contains(rValue);
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
      consumeExpr(lValue);
      consumeExpr(rValue);
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
      consumeExpr(lValue);
      consumeExpr(rValue);
      return lValue;
   }

   private static LValue copyLValue(LValue lValue) {
      if(lValue instanceof VariableRef) {
         return new VariableRef(((VariableRef) lValue).getFullName());
      } else if(lValue instanceof LvalueIntermediate) {
         return new LvalueIntermediate((VariableRef) copyLValue(((LvalueIntermediate) lValue).getVariable()));
      } else if(lValue instanceof PointerDereferenceSimple) {
         RValue pointer = ((PointerDereferenceSimple) lValue).getPointer();
         if(pointer instanceof LValue) {
            pointer = copyLValue((LValue) pointer);
         }
         return new PointerDereferenceSimple(pointer);
      } else if(lValue instanceof PointerDereferenceIndexed) {
         RValue pointer = ((PointerDereferenceIndexed) lValue).getPointer();
         if(pointer instanceof LValue) {
            pointer = copyLValue((LValue) pointer);
         }
         RValue index = ((PointerDereferenceIndexed) lValue).getIndex();
         if(index instanceof LValue) {
            index = copyLValue((LValue) index);
         }
         return new PointerDereferenceIndexed(pointer, index);
      } else if(lValue instanceof StructMemberRef) {
         return new StructMemberRef(copyLValue((LValue) ((StructMemberRef) lValue).getStruct()), ((StructMemberRef) lValue).getMemberName());
      } else if(lValue instanceof ForwardVariableRef) {
         return new ForwardVariableRef(((ForwardVariableRef) lValue).getName());
      } else {
         throw new CompileError("Unknown LValue type " + lValue);
      }
   }

   @Override
   public Object visitExprDot(KickCParser.ExprDotContext ctx) {
      RValue structExpr = (RValue) visit(ctx.expr());
      String name = ctx.NAME().getText();
      StructMemberRef structMemberRef = new StructMemberRef(structExpr, name);
      addExprToConsume(structMemberRef);
      return structMemberRef;
   }

   @Override
   public Object visitExprArrow(KickCParser.ExprArrowContext ctx) {
      RValue structPtrExpr = (RValue) visit(ctx.expr());
      String name = ctx.NAME().getText();
      StructMemberRef structMemberRef = new StructMemberRef(new PointerDereferenceSimple(structPtrExpr), name);
      addExprToConsume(structMemberRef);
      return structMemberRef;
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
      consumeExpr(child);
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
         consumeExpr(child);
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
         consumeExpr(child);
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
         consumeExpr(procedurePointer);
      }
      for(RValue parameter : parameters) {
         consumeExpr(parameter);
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
      PointerDereferenceIndexed pointerDereferenceIndexed = new PointerDereferenceIndexed(array, index);
      addExprToConsume(pointerDereferenceIndexed);
      return pointerDereferenceIndexed;
   }

   @Override
   public RValue visitExprNumber(KickCParser.ExprNumberContext ctx) {
      try {
         return NumberParser.parseIntegerLiteral(ctx.getText());
      } catch(NumberFormatException e) {
         throw new CompileError(e.getMessage(), new StatementSource(ctx));
      }
   }

   /** The current string encoding used if no explicit encoding is specified. */
   private ConstantString.Encoding currentEncoding = ConstantString.Encoding.SCREENCODE_MIXED;

   @Override
   public RValue visitExprString(KickCParser.ExprStringContext ctx) {
      StringBuilder stringValue = new StringBuilder();
      String subText;
      String lastSuffix = "";
      ConstantString.Encoding encoding = null;
      for(TerminalNode stringNode : ctx.STRING()) {
         subText = stringNode.getText();
         String suffix = subText.substring(subText.lastIndexOf('"') + 1);
         ConstantString.Encoding suffixEncoding = getEncodingFromSuffix(suffix);
         if(suffixEncoding != null) {
            if(encoding != null && !encoding.equals(suffixEncoding)) {
               throw new CompileError("Cannot mix encodings in concatenated strings " + ctx.getText(), new StatementSource(ctx));
            }
            encoding = suffixEncoding;
         }
         lastSuffix = suffix;
         stringValue.append(subText, 1, subText.lastIndexOf('"'));
      }
      boolean zeroTerminated = !lastSuffix.contains("z");
      try {
         return new ConstantString(ConstantString.stringEscapeToAscii(stringValue.toString()), encoding, zeroTerminated);
      } catch(CompileError e) {
         // Rethrow - adding statement context!
         throw new CompileError(e.getMessage(), new StatementSource(ctx));
      }
   }

   /**
    * Examine a string suffix, and find any encoding information inside it.
    *
    * @param suffix The string suffix
    * @return The encoding specified by the suffix. If not the current source encoding is returned.
    */
   private ConstantString.Encoding getEncodingFromSuffix(String suffix) {
      if(suffix.contains("pm")) {
         return ConstantString.Encoding.PETSCII_MIXED;
      } else if(suffix.contains("pu")) {
         return ConstantString.Encoding.PETSCII_UPPER;
      } else if(suffix.contains("p")) {
         return ConstantString.Encoding.PETSCII_MIXED;
      } else if(suffix.contains("sm")) {
         return ConstantString.Encoding.SCREENCODE_MIXED;
      } else if(suffix.contains("su")) {
         return ConstantString.Encoding.SCREENCODE_UPPER;
      } else if(suffix.contains("s")) {
         return ConstantString.Encoding.SCREENCODE_MIXED;
      } else {
         return currentEncoding;
      }
   }

   @Override
   public RValue visitExprBool(KickCParser.ExprBoolContext ctx) {
      String bool = ctx.getText();
      return new ConstantBool(Boolean.valueOf(bool));
   }

   @Override
   public Object visitExprChar(KickCParser.ExprCharContext ctx) {
      try {
         String charText = ctx.getText();
         charText = charText.substring(1, charText.length() - 1);
         char constChar = ConstantChar.charEscapeToAscii(charText);
         return new ConstantChar(constChar, currentEncoding);
      } catch(CompileError e) {
         // Rethrow adding source location
         throw new CompileError(e.getMessage(), new StatementSource(ctx));
      }
   }

   @Override
   public RValue visitExprBinary(KickCParser.ExprBinaryContext ctx) {
      RValue left = (RValue) this.visit(ctx.expr(0));
      RValue right = (RValue) this.visit(ctx.expr(1));
      String op = ((TerminalNode) ctx.getChild(1)).getSymbol().getText();
      Operator operator = Operators.getBinary(op);
      if(left instanceof ConstantValue && right instanceof ConstantValue) {
         return new ConstantBinary((ConstantValue) left, (OperatorBinary) operator, (ConstantValue) right);
      } else {
         VariableIntermediate tmpVar = getCurrentScope().addVariableIntermediate();
         VariableRef tmpVarRef = tmpVar.getRef();
         Statement stmt = new StatementAssignment(tmpVarRef, left, operator, right, new StatementSource(ctx), ensureUnusedComments(getCommentsSymbol(ctx)));
         sequence.addStatement(stmt);
         consumeExpr(left);
         consumeExpr(right);
         return tmpVarRef;
      }
   }

   @Override
   public Object visitExprPtr(KickCParser.ExprPtrContext ctx) {
      RValue child = (RValue) this.visit(ctx.expr());
      PointerDereferenceSimple pointerDereferenceSimple = new PointerDereferenceSimple(child);
      addExprToConsume(pointerDereferenceSimple);
      return pointerDereferenceSimple;
   }

   @Override
   public RValue visitExprUnary(KickCParser.ExprUnaryContext ctx) {
      RValue child = (RValue) this.visit(ctx.expr());
      String op = ((TerminalNode) ctx.getChild(0)).getSymbol().getText();
      Operator operator = Operators.getUnary(op);
      // Special handling of negative literal number
      if(child instanceof ConstantInteger && operator.equals(Operators.NEG)) {
         return new ConstantInteger(-((ConstantInteger) child).getInteger(), ((ConstantInteger) child).getType());
      } else if(child instanceof ConstantValue) {
         return new ConstantUnary((OperatorUnary) operator, (ConstantValue) child);
      } else {
         VariableIntermediate tmpVar = getCurrentScope().addVariableIntermediate();
         VariableRef tmpVarRef = tmpVar.getRef();
         Statement stmt = new StatementAssignment(tmpVarRef, operator, child, new StatementSource(ctx), ensureUnusedComments(getCommentsSymbol(ctx)));
         sequence.addStatement(stmt);
         consumeExpr(child);
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
      consumeExpr(condValue);
      consumeExpr(falseValue);
      consumeExpr(trueValue);
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
      } else if(symbol instanceof ConstantVar) {
         return ((ConstantVar) symbol).getRef();
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
      BufferedTokenStream tokenStream = cParser.getTokenStream();
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

   /** Function with specific declared calling convention. */
   private static class DirectiveCallingConvention implements Directive {
      Procedure.CallingConvension callingConvension;

      public DirectiveCallingConvention(Procedure.CallingConvension callingConvension) {
         this.callingConvension = callingConvension;
      }

   }

   /** Function declared inline. */
   private static class DirectiveInline implements Directive {
   }

   /** Variable declared volatile. */
   private static class DirectiveVolatile implements Directive {
   }

   /** Variable declared as export. */
   private static class DirectiveExport implements Directive {
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

   }

   /** Variable register allocation. */
   private static class DirectiveRegister implements Directive {
      /** Name of register to use for the variable */
      private String name;
      /** Address to use as register for the variable */
      private Long address;

      public DirectiveRegister(String name) {
         this.name = name;
      }

      public DirectiveRegister(long address) {
         this.address = address;
      }

   }

   /** Variable memory allocation. */
   private static class DirectiveMemory implements Directive {

      /** Optional hard-coded address to use for storing the variable. */
      private Long address;

      public DirectiveMemory() {
         this.address = null;
      }

      public DirectiveMemory(long address) {
         this.address = address;
      }

   }


   /** Reservation of zero-page addresses */
   private static class DirectiveReserveZp implements Directive {
      List<Integer> reservedZp;

      public DirectiveReserveZp(List<Integer> reservedZp) {
         this.reservedZp = reservedZp;
      }

   }


   private static class PrePostModifierHandler extends KickCParserBaseVisitor<Void> {

      private List<PrePostModifier> postMods;
      private List<PrePostModifier> preMods;
      private Pass0GenerateStatementSequence mainParser;

      public PrePostModifierHandler(Pass0GenerateStatementSequence mainParser) {
         this.mainParser = mainParser;
         preMods = new ArrayList<>();
         postMods = new ArrayList<>();
      }

      public static void addPostModifiers(Pass0GenerateStatementSequence parser, ParserRuleContext ctx, StatementSource statementSource) {
         PrePostModifierHandler prePostModifierHandler = new PrePostModifierHandler(parser);
         prePostModifierHandler.visit(ctx);
         List<PrePostModifier> modifiers = prePostModifierHandler.getPostMods();
         addModifierStatements(parser, modifiers, statementSource);
      }

      public static void addPreModifiers(Pass0GenerateStatementSequence parser, ParserRuleContext ctx, StatementSource statementSource) {
         PrePostModifierHandler modifierHandler = new PrePostModifierHandler(parser);
         modifierHandler.visit(ctx);
         List<PrePostModifier> modifiers = modifierHandler.getPreMods();
         addModifierStatements(parser, modifiers, statementSource);
      }

      private static void addModifierStatements(
            Pass0GenerateStatementSequence parser,
            List<PrePostModifier> modifiers,
            StatementSource source) {
         for(PrePostModifier mod : modifiers) {
            Statement stmt = new StatementAssignment((LValue) mod.child, mod.operator, copyLValue((LValue) mod.child), source, Comment.NO_COMMENTS);
            parser.sequence.addStatement(stmt);
            parser.consumeExpr(mod.child);
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
         // First handle the ++/-- modifier
         RValue child = (RValue) mainParser.visit(ctx.expr());
         String op = ((TerminalNode) ctx.getChild(1)).getSymbol().getText();
         Operator operator = Operators.getUnary(op);
         PrePostModifier modifier = new PrePostModifier(child, operator);
         postMods.add(modifier);
         // First visit sub-expressions in case they have ++/-- themselves
         this.visit(ctx.expr());
         return null;
      }

      @Override
      public Void visitExprPreMod(KickCParser.ExprPreModContext ctx) {
         // First handle the ++/-- modifier
         RValue child = (RValue) mainParser.visit(ctx.expr());
         String op = ((TerminalNode) ctx.getChild(0)).getSymbol().getText();
         Operator operator = Operators.getUnary(op);
         PrePostModifier modifier = new PrePostModifier(child, operator);
         preMods.add(modifier);
         // Then visit sub-expressions in case they have ++/--
         this.visit(ctx.expr());
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

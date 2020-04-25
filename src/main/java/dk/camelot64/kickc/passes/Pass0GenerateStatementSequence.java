package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.NumberParser;
import dk.camelot64.kickc.SourceLoader;
import dk.camelot64.kickc.asm.AsmClobber;
import dk.camelot64.kickc.model.InternalError;
import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.operators.*;
import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.symbols.*;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeConversion;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.types.SymbolTypeProcedure;
import dk.camelot64.kickc.model.values.*;
import dk.camelot64.kickc.parser.CParser;
import dk.camelot64.kickc.parser.KickCParser;
import dk.camelot64.kickc.parser.KickCParserBaseVisitor;
import dk.camelot64.kickc.passes.utils.SizeOfConstants;
import org.antlr.v4.runtime.BufferedTokenStream;
import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.tree.ParseTree;
import org.antlr.v4.runtime.tree.TerminalNode;

import java.io.File;
import java.nio.file.Path;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

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
   /** The memory area used by default for variables. */
   private Variable.MemoryArea defaultMemoryArea;
   /** Configuration for the variable builder. */
   private VariableBuilderConfig variableBuilderConfig;

   public Pass0GenerateStatementSequence(CParser cParser, KickCParser.FileContext fileCtx, Program program, VariableBuilderConfig variableBuilderConfig, Procedure.CallingConvention initialCallingConvention) {
      this.cParser = cParser;
      this.fileCtx = fileCtx;
      this.program = program;
      this.sequence = program.getStatementSequence();
      this.scopeStack = new Stack<>();
      this.defaultMemoryArea = Variable.MemoryArea.ZEROPAGE_MEMORY;
      this.variableBuilderConfig = variableBuilderConfig;
      this.currentCallingConvention = initialCallingConvention;
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
   public Object visitImportFile(KickCParser.ImportFileContext ctx) {
      String importName = ctx.IMPORT_LOCALFILE().getText();
      String importFileName = importName.substring(1, importName.length() - 1);
      if(program.getLog().isVerboseParse()) {
         program.getLog().append("Importing " + importFileName);
      }
      return null;
   }

   @Override
   public Object visitIncludeFile(KickCParser.IncludeFileContext ctx) {
      String includeName = ctx.IMPORT_LOCALFILE().getText();
      String includeFileName = includeName.substring(1, includeName.length() - 1);
      if(program.getLog().isVerboseParse()) {
         program.getLog().append("Including " + includeFileName);
      }
      return null;
   }

   @Override
   public Object visitIncludeSystem(KickCParser.IncludeSystemContext ctx) {
      String includeName = ctx.IMPORT_SYSTEMFILE().getText();
      String includeFileName = includeName.substring(1, includeName.length() - 1);
      if(program.getLog().isVerboseParse()) {
         program.getLog().append("Including system" + includeFileName);
      }
      return null;
   }

   @Override
   public Object visitGlobalDirectiveVarModel(KickCParser.GlobalDirectiveVarModelContext ctx) {
      List<TerminalNode> settingNodes = new ArrayList<>(ctx.NAME());
      List<String> settings = settingNodes.stream().map(ParseTree::getText).collect(Collectors.toList());
      this.variableBuilderConfig = VariableBuilderConfig.fromSettings(settings, new StatementSource(ctx), program.getLog());
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
         this.currentEncoding = StringEncoding.fromName(ctx.NAME().getText().toUpperCase(Locale.ENGLISH));
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
   private Procedure.CallingConvention currentCallingConvention;

   @Override
   public Object visitGlobalDirectiveCalling(KickCParser.GlobalDirectiveCallingContext ctx) {
      Procedure.CallingConvention callingConvention = Procedure.CallingConvention.getCallingConvension(ctx.CALLINGCONVENTION().getText());
      if(callingConvention != null) {
         currentCallingConvention = callingConvention;
      }
      return null;
   }

   /** The current code segment - if null the default segment is used. */
   private String currentCodeSegment = Scope.SEGMENT_CODE_DEFAULT;

   @Override
   public Object visitGlobalDirectiveCodeSeg(KickCParser.GlobalDirectiveCodeSegContext ctx) {
      this.currentCodeSegment = ctx.NAME().getText();
      return null;
   }

   /** The current data segment - if null the default segment is used. */
   private String currentDataSegment = Scope.SEGMENT_DATA_DEFAULT;

   @Override
   public Object visitGlobalDirectiveDataSeg(KickCParser.GlobalDirectiveDataSegContext ctx) {
      this.currentDataSegment = ctx.NAME().getText();
      return null;
   }

   @Override
   public Object visitDeclFunction(KickCParser.DeclFunctionContext ctx) {
      this.visit(ctx.declType());
      for(KickCParser.DeclPointerContext declPointerContext : ctx.declPointer()) {
         this.visit(declPointerContext);
      }
      SymbolType type = varDecl.getEffectiveType();
      List<Directive> directives = varDecl.getEffectiveDirectives();
      String name = ctx.NAME().getText();
      Procedure procedure = new Procedure(name, type, program.getScope(), currentCodeSegment, currentDataSegment, currentCallingConvention);
      addDirectives(procedure, directives, StatementSource.procedureDecl(ctx));
      procedure.setComments(ensureUnusedComments(getCommentsSymbol(ctx)));
      varDecl.exitType();

      scopeStack.push(procedure);
      Variable returnVar = null;
      if(!SymbolType.VOID.equals(type)) {
         returnVar = procedure.add(Variable.createPhiMaster("return", type, procedure, defaultMemoryArea, procedure.getSegmentData()));
      }
      List<Variable> parameterList = new ArrayList<>();
      if(ctx.parameterListDecl() != null) {
         parameterList = (List<Variable>) this.visit(ctx.parameterListDecl());
      }
      procedure.setParameters(parameterList);
      scopeStack.pop();

      // Check that the declaration matches any existing declaration!
      final Symbol existingSymbol = program.getScope().getSymbol(procedure.getRef());
      if(existingSymbol != null) {
         // Already declared  - check equality
         if(!(existingSymbol instanceof Procedure) || !SymbolTypeConversion.procedureDeclarationMatch((Procedure) existingSymbol, procedure))
            throw new CompileError("Error! Conflicting declarations for: " + procedure.getFullName(), new StatementSource(ctx));
      } else {
         // Not declared before - add it
         program.getScope().add(procedure);
      }

      if(ctx.declFunctionBody() != null || VariableBuilder.hasDirective(Directive.Intrinsic.class, directives)) {
         // Make sure directives and more are taken from the procedure with the body / intrinsic declaration!
         if(existingSymbol != null) {
            program.getScope().remove(existingSymbol);
            program.getScope().add(procedure);
         }
      }

      if(ctx.declFunctionBody() != null) {

         // Check that the body has not already been added
         for(Statement statement : sequence.getStatements())
            if(statement instanceof StatementProcedureBegin && ((StatementProcedureBegin) statement).getProcedure().equals(procedure.getRef()))
               throw new CompileError("Error! Redefinition of function: " + procedure.getFullName(), StatementSource.procedureBegin(ctx));
         // Add the body
         scopeStack.push(procedure);
         sequence.addStatement(new StatementProcedureBegin(procedure.getRef(), StatementSource.procedureBegin(ctx), Comment.NO_COMMENTS));
         // Add parameter assignments
         if(Procedure.CallingConvention.STACK_CALL.equals(procedure.getCallingConvention())) {
            for(Variable param : parameterList) {
               sequence.addStatement(new StatementAssignment((LValue) param.getRef(), new ParamValue((VariableRef) param.getRef()), true, StatementSource.procedureEnd(ctx), Comment.NO_COMMENTS));
            }
         }
         Label procExit = procedure.addLabel(SymbolRef.PROCEXIT_BLOCK_NAME);
         if(ctx.declFunctionBody().stmtSeq() != null) {
            this.visit(ctx.declFunctionBody().stmtSeq());
         }
         sequence.addStatement(new StatementLabel(procExit.getRef(), StatementSource.procedureEnd(ctx), Comment.NO_COMMENTS));
         if(Procedure.CallingConvention.PHI_CALL.equals(procedure.getCallingConvention()) && returnVar != null) {
            sequence.addStatement(new StatementAssignment(returnVar.getVariableRef(), returnVar.getRef(), false, StatementSource.procedureEnd(ctx), Comment.NO_COMMENTS));
         }
         SymbolVariableRef returnVarRef = null;
         if(returnVar != null) {
            returnVarRef = returnVar.getRef();
         }
         sequence.addStatement(new StatementReturn(returnVarRef, StatementSource.procedureEnd(ctx), Comment.NO_COMMENTS));
         scopeStack.pop();
         sequence.addStatement(new StatementProcedureEnd(procedure.getRef(), StatementSource.procedureEnd(ctx), Comment.NO_COMMENTS));
      }


      return null;
   }

   @Override
   public List<Variable> visitParameterListDecl(KickCParser.ParameterListDeclContext ctx) {
      ArrayList<Variable> parameterDecls = new ArrayList<>();
      boolean encounteredVariableLengthParamList = false;
      for(KickCParser.ParameterDeclContext parameterDeclCtx : ctx.parameterDecl()) {
         if(encounteredVariableLengthParamList) {
            throw new CompileError("Variable length parameter list is only legal as the last parameter.", new StatementSource(ctx));
         }
         Object parameterDecl = this.visit(parameterDeclCtx);
         if(parameterDecl.equals(SymbolType.VOID)) {
            if(ctx.parameterDecl().size() == 1) {
               // A single void parameter decl - equals zero parameters
               return new ArrayList<>();
            } else {
               throw new CompileError("Illegal void parameter.", new StatementSource(ctx));
            }
         } else if(parameterDecl == PARAM_LIST) {
            // A "..." parameter list. Update the procedure.
            final Procedure procedure = (Procedure) getCurrentScope();
            procedure.setVariableLengthParameterList(true);
            encounteredVariableLengthParamList = true;
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
      this.visit(ctx.declType());
      for(KickCParser.DeclPointerContext declPointerContext : ctx.declPointer()) {
         this.visit(declPointerContext);
      }
      String varName = ctx.NAME().getText();
      VariableBuilder varBuilder = new VariableBuilder(varName, getCurrentScope(), true, varDecl.getEffectiveType(), null, varDecl.getEffectiveDirectives(), currentDataSegment, variableBuilderConfig);
      Variable param = varBuilder.build();
      varDecl.exitType();
      return param;
   }

   @Override
   public Object visitParameterDeclVoid(KickCParser.ParameterDeclVoidContext ctx) {
      if(!SymbolType.VOID.getTypeName().equals(ctx.SIMPLETYPE().getText())) {
         throw new CompileError("Illegal unnamed parameter " + ctx.SIMPLETYPE().getText(), new StatementSource(ctx));
      }
      return SymbolType.VOID;
   }

   /** Singleton signalling a "..." parameter list. */
   public static Object PARAM_LIST = new Object();

   @Override
   public Object visitParameterDeclList(KickCParser.ParameterDeclListContext ctx) {
      return PARAM_LIST;
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
      Symbol symbol = getCurrentScope().findSymbol(varName);
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
      File resourceFile = SourceLoader.loadFile(resourceName, currentPath, new ArrayList<>());
      if(resourceFile == null)
         throw new CompileError("File  not found " + resourceName);
      program.addAsmResourceFile(resourceFile.toPath());
      if(program.getLog().isVerboseParse()) {
         program.getLog().append("Added resource " + resourceFile.getPath().replace('\\', '/'));
      }
      return null;
   }

   /** ASM Directive specifying clobber registers. */
   private static class AsmDirectiveClobber implements AsmDirective {
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

   /**
    * Holds type, arrayness, directives, comments etc. while parsing a variable declaration.
    * Has three levels of information pushed on top of each other:
    * <ol>
    *    <li>Struct Member Declaration (true while inside inside a struct declaration)</li>
    *    <li>Type information and directives (the type)</li>
    *    <li>Variable information and declarations (arrayness, pointerness, variable level directives)</li>
    * </ol>
    * <p>
    * When parsing a declaration such as <code>volatile char a, * const b, c[]</code> the type level holds <code>volatile char</code>
    * and the variable level holds the pointer/array-information and the const-declaration for b.
    */
   static class VariableDeclaration {

      /** State specifying that we are currently populating struct members. */
      private boolean structMember = false;

      /** Holds directives that are not part of the type-spec (all other than const & volatile) when descending into a Variable Declaration. (type level) */
      private List<Directive> declDirectives = null;
      /** Holds the declared comments when descending into a Variable Declaration. (type level) */
      private List<Comment> declComments = null;
      /** The declared type (type level) */
      private VariableDeclType declType;
      /** The declared type (variable level) */
      private VariableDeclType varDeclType;

      public VariableDeclaration() {
         this.declType = new VariableDeclType();
      }

      /**
       * Exits the type layer (clears everything except struct information)
       */
      void exitType() {
         this.declDirectives = null;
         this.declComments = null;
         this.declType = new VariableDeclType();
         this.varDeclType = null;
      }

      /**
       * Exits the variable layer (clears variable information)
       */
      void exitVar() {
         this.varDeclType = null;
      }

      /** The declared type of a variable. Combines SymbolType, type directives (const, volatile) and ArraySpec. It holds advanced type information like <p><code>char volatile * const * [42]</code> */
      static class VariableDeclType {
         /** The type. */
         SymbolType type;
         /** The array specification (non-null if it is an array, also holds size) */
         ArraySpec arraySpec;
         /** Const / Volatile Directives if applied to the type */
         List<Directive> typeDirectives;
         /** If the type is SymbolTypePointer this holds the declaration type of the elements. */
         VariableDeclType elementDeclType;

         public VariableDeclType() {
            this.typeDirectives = new ArrayList<>();
         }

         public void setType(SymbolType type) {
            this.type = type;
         }

         public SymbolType getType() {
            return type;
         }

         public ArraySpec getArraySpec() {
            return arraySpec;
         }

         public List<Directive> getTypeDirectives() {
            return typeDirectives;
         }

         public void setTypeDirectives(List<Directive> directives) {
            this.typeDirectives = directives;
         }

         public void setElementDeclType(VariableDeclType elementDeclType) {
            this.elementDeclType = elementDeclType;
         }

         public void setArraySpec(ArraySpec arraySpec) {
            this.arraySpec = arraySpec;
         }

         public VariableDeclType getElementDeclType() {
            return elementDeclType;
         }
      }

      VariableDeclType getEffectiveDeclType() {
         return varDeclType != null ? varDeclType : declType;
      }

      SymbolType getEffectiveType() {
         if(varDeclType != null)
            return varDeclType.getType();
         if(declType != null)
            return declType.getType();
         return null;
      }

      ArraySpec getEffectiveArraySpec() {
         return varDeclType != null ? varDeclType.getArraySpec() : declType.getArraySpec();
      }

      /**
       * Set type-level directives. Splits directives into type-directives (const, volatile) and general directives (all other).
       *
       * @param directives The directives
       */
      void setDeclDirectives(List<Directive> directives) {
         this.declDirectives = new ArrayList<>();
         for(Directive directive : directives) {
            if(directive instanceof Directive.Const || directive instanceof Directive.Volatile) {
               // Type directive
               if(!this.declType.getTypeDirectives().contains(directive))
                  this.declType.getTypeDirectives().add(directive);
            } else {
               // general directive
               if(!this.declDirectives.contains(directive))
                  this.declDirectives.add(directive);
            }
         }
      }

      List<Directive> getEffectiveDirectives() {
         final ArrayList<Directive> dirs = new ArrayList<>();
         // Add all general directives
         dirs.addAll(declDirectives);
         // Add type-directives
         final VariableDeclType effectiveDeclType = getEffectiveDeclType();
         dirs.addAll(effectiveDeclType.getTypeDirectives());
         // Convert element directives
         final VariableDeclType elementDeclType = effectiveDeclType.getElementDeclType();
         if(elementDeclType != null) {
            for(Directive elementTypeDirective : elementDeclType.getTypeDirectives()) {
               if(elementTypeDirective instanceof Directive.Const) {
                  dirs.add(new Directive.ToConst());
               } else if(elementTypeDirective instanceof Directive.Volatile) {
                  dirs.add(new Directive.ToVolatile());
               }
            }
            // Produce error on any deeper directives
            VariableDeclType deepDeclType = elementDeclType.getElementDeclType();
            while(deepDeclType != null) {
               if(!deepDeclType.getTypeDirectives().isEmpty()) {
                  throw new CompileError("Deep const/volatile not supported.");
               }
               deepDeclType = deepDeclType.getElementDeclType();
            }
         }
         return dirs;
      }

      public List<Comment> getDeclComments() {
         return declComments;
      }

      boolean isStructMember() {
         return structMember;
      }

      public VariableDeclType getDeclType() {
         return declType;
      }

      public void setDeclType(SymbolType type) {
         this.declType.setType(type);
      }

      public void setVarDeclType(VariableDeclType varDeclType) {
         this.varDeclType = varDeclType;
      }

      public VariableDeclType getVarDeclType() {
         return varDeclType;
      }

      public void setDeclComments(List<Comment> declComments) {
         this.declComments = declComments;
      }

      void setStructMember(boolean structMember) {
         this.structMember = structMember;
      }

   }

   /** The current variable declaration. This is not on the stack. */
   private VariableDeclaration varDecl = new VariableDeclaration();

   /** The stack of variable type / directive declarataions being handled. Pushed/popped when entering into a nested type declaration (eg. struct member or a cast inside an initializer) */
   private Deque<VariableDeclaration> varDeclStack = new LinkedList<>();

   /**
    * Push the current type declaration handler onto the stack and initialize a new empty current type declaration handler.
    */
   void varDeclPush() {
      varDeclStack.push(varDecl);
      varDecl = new VariableDeclaration();
   }

   /**
    * Discard the current type declaration handler and pop the last one fron the stack.
    */
   void varDeclPop() {
      this.varDecl = varDeclStack.pop();
   }

   @Override
   public Object visitDeclPointer(KickCParser.DeclPointerContext ctx) {
      // Detect char * const * x;
      //if(varDecl.getDeclDirectives()!=null && !varDecl.getDeclDirectives().isEmpty()) {
      //   throw new CompileError("Pointer directives (const/volatile) not supported between pointers.", new StatementSource(ctx.getParent().getParent()));
      //};
      // Create a var-level declaration type
      final VariableDeclaration.VariableDeclType elementDeclType = varDecl.getEffectiveDeclType();
      VariableDeclaration.VariableDeclType pointerDeclType = new VariableDeclaration.VariableDeclType();
      pointerDeclType.setType(new SymbolTypePointer(elementDeclType.getType()));
      pointerDeclType.setElementDeclType(elementDeclType);
      final List<Directive> typeDirectives = getDirectives(ctx.directive());
      pointerDeclType.setTypeDirectives(typeDirectives);
      varDecl.setVarDeclType(pointerDeclType);
      return null;
   }

   @Override
   public Object visitDeclArray(KickCParser.DeclArrayContext ctx) {
      // Handle array type declaration by updating the declared type and the array spec
      ArraySpec arraySpec;
      if(ctx.expr() != null) {
         varDeclPush();
         RValue sizeVal = (RValue) visit(ctx.expr());
         varDeclPop();
         arraySpec = new ArraySpec((ConstantValue) sizeVal);
      } else {
         arraySpec = new ArraySpec();
      }
      final VariableDeclaration.VariableDeclType elementDeclType = varDecl.getEffectiveDeclType();
      VariableDeclaration.VariableDeclType arrayDeclType = new VariableDeclaration.VariableDeclType();
      arrayDeclType.setType(new SymbolTypePointer(elementDeclType.getType()));
      arrayDeclType.setElementDeclType(elementDeclType);
      arrayDeclType.setArraySpec(arraySpec);
      varDecl.setVarDeclType(arrayDeclType);
      return null;
   }

   /**
    * Visit the type/directive part of a declaration. Setup the local decl-variables
    *
    * @param ctx The declaration type & directives
    * @return null
    */
   @Override
   public Object visitDeclType(KickCParser.DeclTypeContext ctx) {
      varDecl.exitType();
      visit(ctx.type());
      varDecl.setDeclDirectives(getDirectives(ctx.directive()));
      varDecl.setDeclComments(getCommentsSymbol(ctx.getParent()));
      return null;
   }

   @Override
   public Object visitDeclVariables(KickCParser.DeclVariablesContext ctx) {
      this.visit(ctx.declType());
      this.visit(ctx.declVariableList());
      varDecl.exitType();
      return null;
   }

   @Override
   public Object visitDeclVariableList(KickCParser.DeclVariableListContext ctx) {
      if(ctx.declVariableList() != null) {
         this.visit(ctx.declVariableList());
      }
      for(KickCParser.DeclPointerContext declPointerContext : ctx.declPointer()) {
         this.visit(declPointerContext);
      }
      this.visit(ctx.declVariableInit());
      varDecl.exitVar();
      return null;
   }

   @Override
   public Object visitDeclVariableInitExpr(KickCParser.DeclVariableInitExprContext ctx) {
      for(KickCParser.DeclArrayContext declArrayContext : ctx.declArray()) {
         this.visit(declArrayContext);
      }
      String varName = ctx.NAME().getText();
      KickCParser.ExprContext initializer = ctx.expr();
      StatementSource statementSource = new StatementSource(ctx);
      StatementSource declSource = new StatementSource((ParserRuleContext) ctx.parent.parent);
      try {
         final boolean isStructMember = varDecl.isStructMember();
         final SymbolType effectiveType = varDecl.getEffectiveType();
         final ArraySpec effectiveArraySpec = varDecl.getEffectiveArraySpec();
         final List<Directive> effectiveDirectives = varDecl.getEffectiveDirectives();
         final List<Comment> declComments = varDecl.getDeclComments();
         varDecl.exitVar();
         VariableBuilder varBuilder = new VariableBuilder(varName, getCurrentScope(), false, effectiveType, effectiveArraySpec, effectiveDirectives, currentDataSegment, variableBuilderConfig);
         Variable variable = varBuilder.build();
         if(isStructMember && (initializer != null))
            throw new CompileError("Initializer not supported inside structs " + effectiveType.getTypeName(), statementSource);
         if(variable.isDeclarationOnly()) {
            if(initializer != null) {
               throw new CompileError("Initializer not allowed for extern variables " + varName, statementSource);
            }
         } else {
            // Create a proper initializer
            if(initializer != null)
               PrePostModifierHandler.addPreModifiers(this, initializer, statementSource);
            RValue initValue = (initializer == null) ? null : (RValue) visit(initializer);
            initValue = Initializers.constantify(initValue, new Initializers.ValueTypeSpec(effectiveType, effectiveArraySpec), program, statementSource);
            boolean isPermanent = ScopeRef.ROOT.equals(variable.getScope().getRef()) || variable.isPermanent();
            if(variable.isKindConstant() || (isPermanent && variable.isKindLoadStore() && Variable.MemoryArea.MAIN_MEMORY.equals(variable.getMemoryArea()) && initValue instanceof ConstantValue && !isStructMember && variable.getRegister() == null)) {
               // Set initial value
               ConstantValue constInitValue = getConstInitValue(initValue, initializer, statementSource);
               variable.setInitValue(constInitValue);
               // Add comments to constant
               variable.setComments(ensureUnusedComments(declComments));
            } else if(!variable.isKindConstant() && !isStructMember) {
               Statement initStmt = new StatementAssignment(variable.getVariableRef(), initValue, true, statementSource, ensureUnusedComments(declComments));
               sequence.addStatement(initStmt);
            }
            if(initializer != null)
               PrePostModifierHandler.addPostModifiers(this, initializer, statementSource);
         }
      } catch(CompileError e) {
         throw new CompileError(e.getMessage(), declSource);
      }
      return null;
   }

   /**
    * Ensure that the initializer value is a constant. Fail if it is not
    *
    * @param initValue The initializer value (result from {@link Initializers#constantify(RValue, Initializers.ValueTypeSpec, Program, StatementSource)}
    * @param initializer The initializer
    * @param statementSource The source line
    * @return The constant initializer value
    */
   private ConstantValue getConstInitValue(RValue initValue, KickCParser.ExprContext initializer, StatementSource statementSource) {
      if(initializer != null && PrePostModifierHandler.hasPrePostModifiers(this, initializer, statementSource)) {
         throw new CompileError("Constant value contains a pre/post-modifier.", statementSource);
      }
      if(initValue instanceof ForwardVariableRef) {
         throw new CompileError("Variable used before being defined " + initValue.toString(), statementSource);
      }
      if(!(initValue instanceof ConstantValue))
         throw new CompileError("Initializer is not a constant value " + initValue.toString(), statementSource);
      return (ConstantValue) initValue;
   }

   @Override
   public Object visitDeclVariableInitKasm(KickCParser.DeclVariableInitKasmContext ctx) {
      for(KickCParser.DeclArrayContext declArrayContext : ctx.declArray()) {
         this.visit(declArrayContext);
      }
      String varName = ctx.NAME().getText();
      StatementSource statementSource = new StatementSource(ctx);
      if(!(this.varDecl.getEffectiveType() instanceof SymbolTypePointer) || varDecl.getEffectiveArraySpec() == null) {
         throw new CompileError("KickAsm initializers only supported for arrays " + varDecl.getEffectiveType().getTypeName(), statementSource);
      }
      // Add KickAsm statement
      StatementKickAsm kasm = (StatementKickAsm) this.visit(ctx.declKasm());
      if(kasm.getLocation() != null) {
         throw new CompileError("KickAsm initializers does not support 'location' directive.", statementSource);
      }
      if(kasm.getCycles() != null) {
         throw new CompileError("KickAsm initializers does not support 'cycles' directive.", statementSource);
      }
      if(kasm.getBytes() != null) {
         throw new CompileError("KickAsm initializers does not support 'bytes' directive.", statementSource);
      }
      if(kasm.getDeclaredClobber() != null) {
         throw new CompileError("KickAsm initializers does not support 'clobbers' directive.", statementSource);
      }
      ConstantArrayKickAsm constantArrayKickAsm = new ConstantArrayKickAsm(((SymbolTypePointer) varDecl.getEffectiveType()).getElementType(), kasm.getKickAsmCode(), kasm.getUses(), varDecl.getEffectiveArraySpec().getArraySize());
      // Remove the KickAsm statement
      sequence.getStatements().remove(sequence.getStatements().size() - 1);
      // Add a constant variable
      Scope scope = getCurrentScope();
      VariableBuilder varBuilder = new VariableBuilder(varName, scope, false, varDecl.getEffectiveType(), varDecl.getEffectiveArraySpec(), varDecl.getEffectiveDirectives(), currentDataSegment, variableBuilderConfig);
      Variable variable = varBuilder.build();
      // Set constant value
      variable.setInitValue(getConstInitValue(constantArrayKickAsm, null, statementSource));
      // Add comments to constant
      variable.setComments(ensureUnusedComments(varDecl.getDeclComments()));
      varDecl.exitVar();
      return null;
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
         if(directive instanceof Directive.Inline) {
            procedure.setDeclaredInline(true);
            procedure.setCallingConvention(Procedure.CallingConvention.PHI_CALL);
         } else if(directive instanceof Directive.CallingConvention) {
            procedure.setCallingConvention(((Directive.CallingConvention) directive).callingConvention);
         } else if(directive instanceof Directive.Interrupt) {
            procedure.setInterruptType(((Directive.Interrupt) directive).interruptType);
         } else if(directive instanceof Directive.ReserveZp) {
            procedure.setReservedZps(((Directive.ReserveZp) directive).reservedZp);
         } else if(directive instanceof Directive.Intrinsic) {
            procedure.setDeclaredIntrinsic(true);
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
   private void addDirectives(StatementConditionalJump
                                    conditional, List<KickCParser.DirectiveContext> directivesCtx) {
      List<Directive> directives = getDirectives(directivesCtx);
      for(Directive directive : directives) {
         StatementSource source = new StatementSource(directivesCtx.get(0));
         if(directive instanceof Directive.Inline) {
            conditional.setDeclaredUnroll(true);
         } else {
            throw new CompileError("Unsupported loop directive " + directive, source);
         }
      }
   }

   @Override
   public Directive visitDirectiveConst(KickCParser.DirectiveConstContext ctx) {
      return new Directive.Const();
   }

   @Override
   public Object visitDirectiveInline(KickCParser.DirectiveInlineContext ctx) {
      return new Directive.Inline();
   }

   @Override
   public Object visitDirectiveIntrinsic(KickCParser.DirectiveIntrinsicContext ctx) {
      return new Directive.Intrinsic();
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
      return new Directive.Interrupt(type);
   }

   @Override
   public Directive visitDirectiveCallingConvention(KickCParser.DirectiveCallingConventionContext ctx) {
      Procedure.CallingConvention callingConvention = Procedure.CallingConvention.getCallingConvension(ctx.getText());
      return new Directive.CallingConvention(callingConvention);
   }

   @Override
   public Directive visitDirectiveAlign(KickCParser.DirectiveAlignContext ctx) {
      Number alignment = NumberParser.parseLiteral(ctx.NUMBER().getText());
      return new Directive.Align(alignment.intValue());
   }

   @Override
   public Directive visitDirectiveRegister(KickCParser.DirectiveRegisterContext ctx) {
      String name = null;
      if(ctx.NAME() != null) {
         name = ctx.NAME().getText();
      }
      if(name != null)
         return new Directive.NamedRegister(name);
      else
         return new Directive.Register();
   }

   @Override
   public Directive visitDirectiveMemoryAreaZp(KickCParser.DirectiveMemoryAreaZpContext ctx) {
      return new Directive.MemZp();
   }

   @Override
   public Directive visitDirectiveMemoryAreaMain(KickCParser.DirectiveMemoryAreaMainContext ctx) {
      return new Directive.MemMain();
   }

   @Override
   public Directive visitDirectiveMemoryAreaAddress(KickCParser.DirectiveMemoryAreaAddressContext ctx) {
      try {
         ConstantInteger memoryAddress = NumberParser.parseIntegerLiteral(ctx.NUMBER().getText());
         Long address = memoryAddress.getInteger();
         return new Directive.Address(address);
      } catch(NumberFormatException e) {
         throw new CompileError(e.getMessage(), new StatementSource(ctx));
      }
   }

   @Override
   public Directive visitDirectiveFormSsa(KickCParser.DirectiveFormSsaContext ctx) {
      return new Directive.FormSsa();
   }

   @Override
   public Directive visitDirectiveFormMa(KickCParser.DirectiveFormMaContext ctx) {
      return new Directive.FormMa();
   }

   @Override
   public Directive visitDirectiveVolatile(KickCParser.DirectiveVolatileContext ctx) {
      return new Directive.Volatile();
   }

   @Override
   public Object visitDirectiveStatic(KickCParser.DirectiveStaticContext ctx) {
      return new Directive.Static();
   }

   @Override
   public Object visitDirectiveExtern(KickCParser.DirectiveExternContext ctx) {
      return new Directive.Extern();
   }

   @Override
   public Directive visitDirectiveExport(KickCParser.DirectiveExportContext ctx) {
      return new Directive.Export();
   }

   @Override
   public Directive visitDirectiveReserveZp(KickCParser.DirectiveReserveZpContext ctx) {
      List<Integer> reservedZps = new ArrayList<>();
      for(TerminalNode reservedNum : ctx.NUMBER()) {
         int reservedZp = NumberParser.parseLiteral(reservedNum.getText()).intValue();
         reservedZps.add(reservedZp);
      }
      return new Directive.ReserveZp(reservedZps);
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
         Variable tmpVar = getCurrentScope().addVariableIntermediate();
         List<Comment> comments = ensureUnusedComments(getCommentsSymbol(ctx));
         RValue rVal = exprVal;
         if(exprVal instanceof LValue) {
            rVal = copyLValue((LValue) exprVal);
         }
         sequence.addStatement(new StatementAssignment((LValue) tmpVar.getRef(), rVal, true, new StatementSource(ctx), comments));
      }
      endNotConsumedTracking();
      PrePostModifierHandler.addPostModifiers(this, ctx.commaExpr(), new StatementSource(ctx));
      return null;
   }

   @Override
   public Void visitStmtIfElse(KickCParser.StmtIfElseContext ctx) {
      KickCParser.StmtContext ifStmt = ctx.stmt(0);
      KickCParser.StmtContext elseStmt = ctx.stmt(1);
      RValue rValue = addCondition(ctx.commaExpr(), StatementSource.ifThen(ctx));
      List<Comment> comments = ensureUnusedComments(getCommentsSymbol(ctx));
      if(elseStmt == null) {
         // If without else - skip the entire section if condition not met
         SymbolVariableRef notExprVar = getCurrentScope().addVariableIntermediate().getRef();
         sequence.addStatement(new StatementAssignment((LValue) notExprVar, null, Operators.LOGIC_NOT, rValue, true, StatementSource.ifThen(ctx), comments));
         Label endJumpLabel = getCurrentScope().addLabelIntermediate();
         sequence.addStatement(new StatementConditionalJump(notExprVar, endJumpLabel.getRef(), StatementSource.ifThen(ctx), Comment.NO_COMMENTS));
         this.visit(ifStmt);
         // No else statement - just add the label
         sequence.addStatement(new StatementLabel(endJumpLabel.getRef(), StatementSource.ifThen(ctx), Comment.NO_COMMENTS));
      } else {
         // If with else - jump to if section if condition met - fall into else otherwise.
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

      Loop(Scope loopScope, boolean isSwitch) {
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
      RValue rValue = addCondition(ctx.commaExpr(), StatementSource.whileDo(ctx));
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

   /**
    * Add code to evaluate a comma-expr condition (used in while/for/...).
    *
    * @param conditionCtx The comma-expr condition to evaluate
    * @param statementSource The statement source used for errors
    * @return The RValue of the condition
    */
   private RValue addCondition(KickCParser.CommaExprContext conditionCtx, StatementSource statementSource) {
      // Add any pre-modifiers
      PrePostModifierHandler.addPreModifiers(this, conditionCtx, statementSource);
      RValue rValue = (RValue) this.visit(conditionCtx);
      // Add any post-modifiers
      if(PrePostModifierHandler.hasPrePostModifiers(this, conditionCtx, statementSource)) {
         // If modifiers are present the RValue must be assigned before the post-modifier is executed
         if(!(rValue instanceof VariableRef)) {
            // Make a new temporary variable and assign that
            Variable tmpVar = getCurrentScope().addVariableIntermediate();
            Statement stmtExpr = new StatementAssignment(tmpVar.getVariableRef(), rValue, true, statementSource, Comment.NO_COMMENTS);
            sequence.addStatement(stmtExpr);
            rValue = tmpVar.getRef();
         }
         PrePostModifierHandler.addPostModifiers(this, conditionCtx, statementSource);
      }
      return rValue;
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
      RValue rValue = addCondition(ctx.commaExpr(), StatementSource.doWhile(ctx));
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
      RValue eValue = addCondition(ctx.commaExpr(), StatementSource.switchExpr(ctx));
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
      RValue rValue = addCondition(ctx.commaExpr(0), StatementSource.forClassic(ctx));
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
         addCondition(incrementCtx, StatementSource.forClassic(ctx));
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
      if(ctx.declType() != null) {
         this.visit(ctx.declType());
         for(KickCParser.DeclPointerContext declPointerContext : ctx.declPointer()) {
            this.visit(declPointerContext);
         }
      }
      SymbolType varType = varDecl.getEffectiveType();
      String varName = ctx.NAME().getText();
      Variable lValue;
      if(varType != null) {
         VariableBuilder varBuilder = new VariableBuilder(varName, blockScope, false, varType, null, varDecl.getEffectiveDirectives(), currentDataSegment, variableBuilderConfig);
         lValue = varBuilder.build();
      } else {
         lValue = getCurrentScope().findVariable(varName);
         if(lValue == null) {
            throw new CompileError("Error! Loop variable not declared " + varName, statementSource);
         }
      }
      boolean initialAssignment = (varDecl.getEffectiveType() != null);
      varDecl.exitType();
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
      Statement stmtInit = new StatementAssignment((LValue) lValue.getRef(), rangeFirstValue, initialAssignment, statementSource, Comment.NO_COMMENTS);
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
      Statement stmtNxt = new StatementAssignment((LValue) lValue.getRef(), lValue.getRef(), Operators.PLUS, new RangeNext(rangeFirstValue, rangeLastValue), false, statementSource, Comment.NO_COMMENTS);
      sequence.addStatement(stmtNxt);
      // Add condition i!=last+1 or i!=last-1
      RValue beyondLastVal = new RangeComparison(rangeFirstValue, rangeLastValue, lValue.getType());
      Variable tmpVar = getCurrentScope().addVariableIntermediate();
      SymbolVariableRef tmpVarRef = tmpVar.getRef();
      Statement stmtTmpVar = new StatementAssignment((LValue) tmpVarRef, lValue.getRef(), Operators.NEQ, beyondLastVal, true, statementSource, Comment.NO_COMMENTS);
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
      StatementAsm statementAsm = new StatementAsm(ctx.asmLines(), referenced, declaredClobber, StatementSource.asm(ctx), comments);
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
   private Map<String, SymbolRef> getAsmReferencedSymbolVariables(KickCParser.StmtAsmContext
                                                                        ctx, List<String> definedLabels) {
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
               Symbol symbol = getCurrentScope().findSymbol(ctxLabel.ASM_NAME().getText());
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
         if(SymbolType.VOID.equals(procedure.getReturnType())) {
            throw new CompileError("Error! Return value from void function " + procedure.getFullName(), new StatementSource(ctx));
         }
         PrePostModifierHandler.addPreModifiers(this, exprCtx, new StatementSource(ctx));
         rValue = (RValue) this.visit(exprCtx);
         Variable returnVar = procedure.getLocalVariable("return");
         sequence.addStatement(new StatementAssignment((LValue) returnVar.getRef(), rValue, false, new StatementSource(ctx), ensureUnusedComments(getCommentsSymbol(ctx))));
         PrePostModifierHandler.addPostModifiers(this, exprCtx, new StatementSource(ctx));
      }
      Label returnLabel = procedure.getLocalLabel(SymbolRef.PROCEXIT_BLOCK_NAME);
      sequence.addStatement(new StatementJump(returnLabel.getRef(), new StatementSource(ctx), ensureUnusedComments(getCommentsSymbol(ctx))));
      return null;
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
   public Object visitTypeSimple(KickCParser.TypeSimpleContext ctx) {
      final SymbolType typeSimple = SymbolType.get(ctx.getText());
      varDecl.setDeclType(typeSimple);
      return null;
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
      for(KickCParser.StructMembersContext memberCtx : ctx.structMembers()) {
         varDeclPush();
         varDecl.setStructMember(true);
         visit(memberCtx);
         varDecl.setStructMember(false);
         varDeclPop();
      }
      scopeStack.pop();
      varDecl.setDeclType(structDefinition.getType());
      return null;
   }

   @Override
   public Object visitStructRef(KickCParser.StructRefContext ctx) {
      String structDefName = ctx.NAME().getText();
      StructDefinition structDefinition = program.getScope().getLocalStructDefinition(structDefName);
      if(structDefinition == null) {
         throw new CompileError("Unknown struct type " + structDefName, new StatementSource(ctx));
      }
      varDecl.setDeclType(structDefinition.getType());
      return null;
   }

   @Override
   public Object visitTypeEnumDef(KickCParser.TypeEnumDefContext ctx) {
      visit(ctx.enumDef());
      return null;
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
         for(Variable member : enumDefinition.getAllConstants(false)) {
            parentScope.add(Variable.createConstant(member.getLocalName(), SymbolType.BYTE, parentScope, null, member.getInitValue(), currentDataSegment));
         }
         varDecl.setDeclType(SymbolType.BYTE);
         return null;
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
         List<Variable> values = new ArrayList<>(currentEnum.getAllConstants(false));
         if(values.isEmpty()) {
            enumValue = new ConstantInteger(0L, SymbolType.BYTE);
         } else {
            Variable prevEnumMember = values.get(values.size() - 1);
            ConstantValue prevValue = prevEnumMember.getInitValue();
            if(prevValue instanceof ConstantInteger) {
               enumValue = new ConstantInteger(((ConstantInteger) prevValue).getInteger() + 1, SymbolType.BYTE);
            } else {
               enumValue = new ConstantBinary(prevValue, Operators.PLUS, new ConstantInteger(1L, SymbolType.BYTE));

            }
         }
      }
      currentEnum.add(Variable.createConstant(memberName, SymbolType.BYTE, getCurrentScope(), null, enumValue, currentDataSegment));
      return null;
   }

   @Override
   public Object visitTypeEnumRef(KickCParser.TypeEnumRefContext ctx) {
      visit(ctx.enumRef());
      return null;
   }

   @Override
   public Object visitEnumRef(KickCParser.EnumRefContext ctx) {
      String enumDefName = ctx.NAME().getText();
      EnumDefinition enumDefinition = program.getScope().getLocalEnumDefinition(enumDefName);
      if(enumDefinition == null) {
         throw new CompileError("Unknown enum " + enumDefName, new StatementSource(ctx));
      }
      varDecl.setDeclType(SymbolType.BYTE);
      return null;
   }

   @Override
   public Object visitTypeNamedRef(KickCParser.TypeNamedRefContext ctx) {
      Scope typeDefScope = program.getScope().getTypeDefScope();
      Variable typeDefVariable = typeDefScope.getLocalVar(ctx.getText());
      if(typeDefVariable != null) {
         varDecl.setDeclType(typeDefVariable.getType());

         // Handle pointer types by creating sub-decltypes
         VariableDeclaration.VariableDeclType declType = varDecl.getDeclType();
         SymbolType type = typeDefVariable.getType();
         while(type instanceof SymbolTypePointer) {
            VariableDeclaration.VariableDeclType elementDeclType = new VariableDeclaration.VariableDeclType();
            SymbolType elementType = ((SymbolTypePointer) type).getElementType();
            elementDeclType.setType(elementType);
            declType.setElementDeclType(elementDeclType);
            type = elementType;
            declType = elementDeclType;
         }

         if(typeDefVariable.getArraySpec() != null)
            varDecl.getDeclType().setArraySpec(typeDefVariable.getArraySpec());
         if(typeDefVariable.isNoModify())
            varDecl.getDeclType().getTypeDirectives().add(new Directive.Const());
         if(typeDefVariable.isVolatile())
            varDecl.getDeclType().getTypeDirectives().add(new Directive.Volatile());
         if(typeDefVariable.isToNoModify()) {
            // Find sub-type and add const
            varDecl.getDeclType().getElementDeclType().getTypeDirectives().add(new Directive.Const());
         }
         if(typeDefVariable.isToVolatile()) {
            // Find sub-type and add volatile
            varDecl.getDeclType().getElementDeclType().getTypeDirectives().add(new Directive.Volatile());
         }
         return null;
      }
      throw new CompileError("Unknown type " + ctx.getText(), new StatementSource(ctx));
   }

   @Override
   public Object visitTypeSignedSimple(KickCParser.TypeSignedSimpleContext ctx) {
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
      varDecl.setDeclType(symbolType);
      return null;
   }

   @Override
   public Object visitTypePar(KickCParser.TypeParContext ctx) {
      visit(ctx.type());
      return null;
   }

   @Override
   public Object visitTypeArray(KickCParser.TypeArrayContext ctx) {
      if(program.isWarnArrayType()) {
         program.getLog().append("Non-standard array declaration.\n" + new StatementSource(ctx).toString());
         visit(ctx.type());
         final VariableDeclaration.VariableDeclType elementDeclType = varDecl.getEffectiveDeclType();
         final VariableDeclaration.VariableDeclType arrayDeclType = new VariableDeclaration.VariableDeclType();
         arrayDeclType.setType(new SymbolTypePointer(elementDeclType.getType()));
         arrayDeclType.setElementDeclType(elementDeclType);
         if(ctx.expr() != null) {
            RValue sizeVal = (RValue) visit(ctx.expr());
            arrayDeclType.setArraySpec(new ArraySpec((ConstantValue) sizeVal));
         } else {
            arrayDeclType.setArraySpec(new ArraySpec());
         }
         varDecl.setVarDeclType(arrayDeclType);
         return null;
      } else {
         throw new CompileError("ERROR! Non-standard array declaration. Allow using commandline option -Warraytype", new StatementSource(ctx));
      }
   }

   @Override
   public Object visitTypeProcedure(KickCParser.TypeProcedureContext ctx) {
      visit(ctx.type());
      SymbolType returnType = varDecl.getEffectiveType();
      varDecl.setDeclType(new SymbolTypeProcedure(returnType));
      return null;
   }

   @Override
   public Object visitTypeDef(KickCParser.TypeDefContext ctx) {
      Scope typedefScope = program.getScope().getTypeDefScope();
      scopeStack.push(typedefScope);
      this.visit(ctx.declType());
      for(KickCParser.DeclPointerContext declPointerContext : ctx.declPointer()) {
         this.visit(declPointerContext);
      }
      for(KickCParser.DeclArrayContext declArrayContext : ctx.declArray()) {
         this.visit(declArrayContext);
      }
      String typedefName = ctx.NAME().getText();
      VariableBuilder varBuilder = new VariableBuilder(typedefName, getCurrentScope(), false, varDecl.getEffectiveType(), varDecl.getEffectiveArraySpec(), varDecl.getEffectiveDirectives(), currentDataSegment, variableBuilderConfig);
      final Variable typeDefVar = varBuilder.build();
      scopeStack.pop();
      varDecl.exitType();
      return null;
   }

   /**
    * RValues that have not yet been output as part of a statement.
    * The expression visitor methods updates this so that the surrounding
    * statement can make sure to output any rValue that has not been output.
    * Null if we are not currently monitoring this.
    */
   private Set<RValue> exprNotConsumed = null;

   /**
    * Begins monitoring list of expressions not consumed.
    */
   private void beginNotConsumedTracking() {
      exprNotConsumed = new LinkedHashSet<>();
   }

   /**
    * Ends monitoring list of expressions not consumed.
    */
   private void endNotConsumedTracking() {
      exprNotConsumed = null;
   }

   /**
    * Consumes an RValue by outputting it as part of a statement.
    * This helps ensure that all expression RValues are output in statements
    *
    * @param rValue The RValue being consume
    */
   private void consumeExpr(RValue rValue) {
      if(exprNotConsumed != null)
         exprNotConsumed.remove(rValue);
   }

   /**
    * Marks an expression that has been produced which has not been output as part of a statement.
    * When the RValue is output in a statement it will be consumed using {@link #consumeExpr(RValue)}.
    *
    * @param rValue The RValue that has been produced but not consumed
    */
   private void addExprToConsume(RValue rValue) {
      if(exprNotConsumed != null)
         exprNotConsumed.add(rValue);
   }

   /**
    * Examines whether an RValue is in the list of non-consumed RValues.
    *
    * @return true if the RValue is in the list
    */
   private boolean notConsumed(RValue rValue) {
      return exprNotConsumed.contains(rValue);
   }

   @Override
   public Object visitExprAssignment(KickCParser.ExprAssignmentContext ctx) {
      Object val = visit(ctx.expr(0));
      if(val instanceof ConstantRef) {
         throw new CompileError("const variable may not be modified " + val.toString(), new StatementSource(ctx));
      }
      if(!(val instanceof LValue)) {
         throw new CompileError("Error! Illegal assignment Lvalue " + val.toString(), new StatementSource(ctx));
      }
      LValue lValue = (LValue) val;
      if(lValue instanceof VariableRef && ((VariableRef) lValue).isIntermediate()) {
         // Encountered an intermediate variable. This must be turned into a proper LValue later. Put it into a marker to signify that
         lValue = new LvalueIntermediate((VariableRef) lValue);
      }
      RValue rValue = (RValue) this.visit(ctx.expr(1));
      Statement stmt = new StatementAssignment(lValue, rValue, false, new StatementSource(ctx), ensureUnusedComments(getCommentsSymbol(ctx)));
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
      Statement stmt = new StatementAssignment(lValue, rValue1, operator, rValue, false, new StatementSource(ctx), ensureUnusedComments(getCommentsSymbol(ctx)));
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
   public SymbolType visitTypeSpecifierSimple(KickCParser.TypeSpecifierSimpleContext ctx) {
      varDeclPush();
      this.visit(ctx.type());
      final SymbolType type = varDecl.getEffectiveType();
      varDeclPop();
      return type;
   }

   @Override
   public SymbolType visitTypeSpecifierPointer(KickCParser.TypeSpecifierPointerContext ctx) {
      return new SymbolTypePointer((SymbolType) this.visit(ctx.typeSpecifier()));
   }

   @Override
   public SymbolType visitTypeSpecifierArray(KickCParser.TypeSpecifierArrayContext ctx) {
      SymbolType elementType = (SymbolType) visit(ctx.typeSpecifier());
      if(ctx.expr() != null)
         throw new InternalError("Not implemented!");
      return new SymbolTypePointer(elementType);
   }

   @Override
   public RValue visitExprCast(KickCParser.ExprCastContext ctx) {
      RValue child = (RValue) this.visit(ctx.expr());
      SymbolType castType = (SymbolType) this.visit(ctx.typeSpecifier());
      Operator operator = Operators.getCastUnary(castType);
      if(child instanceof ConstantValue) {
         consumeExpr(child);
         return new ConstantCastValue(castType, (ConstantValue) child);
      } else {
         return new CastValue(castType, child);
      }
   }

   @Override
   public Object visitExprSizeOf(KickCParser.ExprSizeOfContext ctx) {
      if(ctx.typeSpecifier() != null) {
         // sizeof(type) - add directly
         SymbolType type = (SymbolType) this.visit(ctx.typeSpecifier());
         return SizeOfConstants.getSizeOfConstantVar(program.getScope(), type);
      } else {
         // sizeof(expression) - add a unary expression to be resolved later
         RValue child = (RValue) this.visit(ctx.expr());
         Variable tmpVar = getCurrentScope().addVariableIntermediate();
         SymbolVariableRef tmpVarRef = tmpVar.getRef();
         Statement stmt = new StatementAssignment((LValue) tmpVarRef, Operators.SIZEOF, child, true, new StatementSource(ctx), ensureUnusedComments(getCommentsSymbol(ctx)));
         sequence.addStatement(stmt);
         consumeExpr(child);
         return tmpVarRef;
      }
   }

   @Override
   public Object visitExprTypeId(KickCParser.ExprTypeIdContext ctx) {
      if(ctx.typeSpecifier() != null) {
         // typeid(type) - add directly
         SymbolType type = (SymbolType) this.visit(ctx.typeSpecifier());
         return OperatorTypeId.getTypeIdConstantVar(program.getScope(), type);
      } else {
         // typeid(expression) - add a unary expression to be resolved later
         RValue child = (RValue) this.visit(ctx.expr());
         Variable tmpVar = getCurrentScope().addVariableIntermediate();
         SymbolVariableRef tmpVarRef = tmpVar.getRef();
         Statement stmt = new StatementAssignment((LValue) tmpVarRef, Operators.TYPEID, child, true, new StatementSource(ctx), ensureUnusedComments(getCommentsSymbol(ctx)));
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
      Variable tmpVar = getCurrentScope().addVariableIntermediate();
      SymbolVariableRef tmpVarRef = tmpVar.getRef();

      String procedureName;
      if(ctx.expr() instanceof KickCParser.ExprIdContext) {
         procedureName = ctx.expr().getText();
         sequence.addStatement(new StatementCall((LValue) tmpVarRef, procedureName, parameters, new StatementSource(ctx), ensureUnusedComments(getCommentsSymbol(ctx))));
      } else {
         RValue procedurePointer = (RValue) this.visit(ctx.expr());
         sequence.addStatement(new StatementCallPointer((LValue) tmpVarRef, procedurePointer, parameters, new StatementSource(ctx), ensureUnusedComments(getCommentsSymbol(ctx))));
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
   private StringEncoding currentEncoding = StringEncoding.SCREENCODE_MIXED;

   @Override
   public RValue visitExprString(KickCParser.ExprStringContext ctx) {
      StringBuilder stringValue = new StringBuilder();
      String subText;
      String lastSuffix = "";
      StringEncoding encoding = null;
      for(TerminalNode stringNode : ctx.STRING()) {
         subText = stringNode.getText();
         String suffix = subText.substring(subText.lastIndexOf('"') + 1);
         StringEncoding suffixEncoding = StringEncoding.fromSuffix(suffix, currentEncoding);
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
         return new ConstantString(encoding.escapeToAscii(stringValue.toString()), encoding, zeroTerminated);
      } catch(CompileError e) {
         // Rethrow - adding statement context!
         throw new CompileError(e.getMessage(), new StatementSource(ctx));
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
         char constChar = currentEncoding.escapeToAscii(charText).charAt(0);
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
         Variable tmpVar = getCurrentScope().addVariableIntermediate();
         SymbolVariableRef tmpVarRef = tmpVar.getRef();
         Statement stmt = new StatementAssignment((LValue) tmpVarRef, left, operator, right, true, new StatementSource(ctx), ensureUnusedComments(getCommentsSymbol(ctx)));
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
      } else if(operator.equals(Operators.ADDRESS_OF) && child instanceof SymbolRef) {
         return new ConstantSymbolPointer((SymbolRef) child);
      } else if(operator.equals(Operators.ADDRESS_OF) && child instanceof PointerDereferenceIndexed && ((PointerDereferenceIndexed) child).getPointer() instanceof ConstantValue && ((PointerDereferenceIndexed) child).getIndex() instanceof ConstantValue) {
         PointerDereferenceIndexed pointerDeref = (PointerDereferenceIndexed) child;
         return new ConstantBinary((ConstantValue) pointerDeref.getPointer(), Operators.PLUS, (ConstantValue) pointerDeref.getIndex());
      } else if(child instanceof ConstantValue) {
         return new ConstantUnary((OperatorUnary) operator, (ConstantValue) child);
      } else {
         Variable tmpVar = getCurrentScope().addVariableIntermediate();
         SymbolVariableRef tmpVarRef = tmpVar.getRef();
         Statement stmt = new StatementAssignment((LValue) tmpVarRef, operator, child, true, new StatementSource(ctx), ensureUnusedComments(getCommentsSymbol(ctx)));
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
      SymbolVariableRef falseVar = getCurrentScope().addVariableIntermediate().getRef();
      sequence.addStatement(new StatementAssignment((LValue) falseVar, falseValue, true, new StatementSource(ctx), Comment.NO_COMMENTS));
      LabelRef falseExitLabel = sequence.getCurrentBlockLabel();
      sequence.addStatement(new StatementJump(endJumpLabel.getRef(), new StatementSource(ctx), Comment.NO_COMMENTS));
      sequence.addStatement(new StatementLabel(trueLabel.getRef(), new StatementSource(ctx), Comment.NO_COMMENTS));
      RValue trueValue = (RValue) this.visit(ctx.expr(1));
      SymbolVariableRef trueVar = getCurrentScope().addVariableIntermediate().getRef();
      sequence.addStatement(new StatementAssignment((LValue) trueVar, trueValue, true, new StatementSource(ctx), Comment.NO_COMMENTS));
      LabelRef trueExitLabel = sequence.getCurrentBlockLabel();
      sequence.addStatement(new StatementLabel(endJumpLabel.getRef(), new StatementSource(ctx), Comment.NO_COMMENTS));
      StatementPhiBlock phiBlock = new StatementPhiBlock(Comment.NO_COMMENTS);
      phiBlock.setSource(new StatementSource(ctx));
      SymbolVariableRef finalVar = getCurrentScope().addVariableIntermediate().getRef();
      StatementPhiBlock.PhiVariable phiVariable = phiBlock.addPhiVariable((VariableRef) finalVar);
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
      Symbol symbol = getCurrentScope().findSymbol(ctx.NAME().getText());
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
      BufferedTokenStream preprocessedTokenStream = cParser.getPreprocessedTokenStream();
      final int startTokenIndex = ctx.start.getTokenIndex();
      if(startTokenIndex < 0)
         return commentBlocks;
      List<Token> hiddenTokens = preprocessedTokenStream.getHiddenTokensToLeft(startTokenIndex);
      if(hiddenTokens != null) {
         for(Token hiddenToken : hiddenTokens) {
            if(hiddenToken.getChannel() == CParser.CHANNEL_WHITESPACE) {
               String text = hiddenToken.getText();
               long newlineCount = text.chars().filter(ch -> ch == '\n').count();
               if(newlineCount > 1 && comments.size() > 0) {
                  // Create new comment block
                  commentBlocks.add(comments);
                  comments = new ArrayList<>();
               }
            } else if(hiddenToken.getChannel() == CParser.CHANNEL_COMMENTS) {
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
   private HashSet<Integer> usedCommentTokenIndices = new HashSet<>();

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


   private static class PrePostModifierHandler extends KickCParserBaseVisitor<Void> {

      private List<PrePostModifier> postMods;
      private List<PrePostModifier> preMods;
      private Pass0GenerateStatementSequence mainParser;

      PrePostModifierHandler(Pass0GenerateStatementSequence mainParser) {
         this.mainParser = mainParser;
         preMods = new ArrayList<>();
         postMods = new ArrayList<>();
      }

      static void addPostModifiers(Pass0GenerateStatementSequence parser, ParserRuleContext ctx, StatementSource statementSource) {
         PrePostModifierHandler prePostModifierHandler = new PrePostModifierHandler(parser);
         prePostModifierHandler.visit(ctx);
         List<PrePostModifier> modifiers = prePostModifierHandler.getPostMods();
         addModifierStatements(parser, modifiers, statementSource);
      }

      static void addPreModifiers(Pass0GenerateStatementSequence parser, ParserRuleContext ctx, StatementSource statementSource) {
         PrePostModifierHandler modifierHandler = new PrePostModifierHandler(parser);
         modifierHandler.visit(ctx);
         List<PrePostModifier> modifiers = modifierHandler.getPreMods();
         addModifierStatements(parser, modifiers, statementSource);
      }

      static boolean hasPrePostModifiers(Pass0GenerateStatementSequence parser, ParserRuleContext ctx, StatementSource statementSource) {
         PrePostModifierHandler modifierHandler = new PrePostModifierHandler(parser);
         modifierHandler.visit(ctx);
         return modifierHandler.getPreMods().size() > 0 || (modifierHandler.getPostMods().size() > 0);
      }


      private static void addModifierStatements(
            Pass0GenerateStatementSequence parser,
            List<PrePostModifier> modifiers,
            StatementSource source) {
         for(PrePostModifier mod : modifiers) {
            if(mod.child instanceof ConstantRef) {
               throw new CompileError("Constants can not be modified " + mod.child.toString(), source);
            }
            Statement stmt = new StatementAssignment((LValue) mod.child, mod.operator, copyLValue((LValue) mod.child), false, source, Comment.NO_COMMENTS);
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

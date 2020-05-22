// Generated from /Users/jespergravgaard/c64/kickc/src/main/java/dk/camelot64/kickc/parser/KickCParser.g4 by ANTLR 4.7.2
package dk.camelot64.kickc.parser;


import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.misc.*;
import org.antlr.v4.runtime.tree.*;
import java.util.List;
import java.util.Iterator;
import java.util.ArrayList;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast"})
public class KickCParser extends Parser {
	static { RuntimeMetaData.checkVersion("4.7.2", RuntimeMetaData.VERSION); }

	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		TYPEDEFNAME=1, CURLY_BEGIN=2, CURLY_END=3, BRACKET_BEGIN=4, BRACKET_END=5, 
		PAR_BEGIN=6, PAR_END=7, SEMICOLON=8, COLON=9, COMMA=10, RANGE=11, PARAM_LIST=12, 
		CONDITION=13, DOT=14, ARROW=15, PLUS=16, MINUS=17, ASTERISK=18, DIVIDE=19, 
		MODULO=20, INC=21, DEC=22, AND=23, BIT_NOT=24, BIT_XOR=25, BIT_OR=26, 
		SHIFT_LEFT=27, SHIFT_RIGHT=28, EQUAL=29, NOT_EQUAL=30, LESS_THAN=31, LESS_THAN_EQUAL=32, 
		GREATER_THAN_EQUAL=33, GREATER_THAN=34, LOGIC_AND=35, LOGIC_OR=36, ASSIGN=37, 
		ASSIGN_COMPOUND=38, TYPEDEF=39, RESERVE=40, PC=41, TARGET=42, LINK=43, 
		EXTENSION=44, EMULATOR=45, CPU=46, CODESEG=47, DATASEG=48, ENCODING=49, 
		CONST=50, EXTERN=51, EXPORT=52, ALIGN=53, INLINE=54, VOLATILE=55, STATIC=56, 
		INTERRUPT=57, REGISTER=58, LOCAL_RESERVE=59, ADDRESS=60, ADDRESS_ZEROPAGE=61, 
		ADDRESS_MAINMEM=62, FORM_SSA=63, FORM_MA=64, INTRINSIC=65, CALLING=66, 
		CALLINGCONVENTION=67, VARMODEL=68, IF=69, ELSE=70, WHILE=71, DO=72, FOR=73, 
		SWITCH=74, RETURN=75, BREAK=76, CONTINUE=77, ASM=78, DEFAULT=79, CASE=80, 
		STRUCT=81, ENUM=82, SIZEOF=83, TYPEID=84, DEFINED=85, KICKASM=86, RESOURCE=87, 
		USES=88, CLOBBERS=89, BYTES=90, CYCLES=91, LOGIC_NOT=92, SIGNEDNESS=93, 
		SIMPLETYPE=94, BOOLEAN=95, KICKASM_BODY=96, IMPORT=97, INCLUDE=98, PRAGMA=99, 
		DEFINE=100, DEFINE_CONTINUE=101, UNDEF=102, IFDEF=103, IFNDEF=104, IFIF=105, 
		ELIF=106, IFELSE=107, ENDIF=108, NUMBER=109, NUMFLOAT=110, BINFLOAT=111, 
		DECFLOAT=112, HEXFLOAT=113, NUMINT=114, BININTEGER=115, DECINTEGER=116, 
		HEXINTEGER=117, NAME=118, STRING=119, CHAR=120, WS=121, COMMENT_LINE=122, 
		COMMENT_BLOCK=123, ASM_BYTE=124, ASM_MNEMONIC=125, ASM_IMM=126, ASM_COLON=127, 
		ASM_COMMA=128, ASM_PAR_BEGIN=129, ASM_PAR_END=130, ASM_BRACKET_BEGIN=131, 
		ASM_BRACKET_END=132, ASM_DOT=133, ASM_SHIFT_LEFT=134, ASM_SHIFT_RIGHT=135, 
		ASM_PLUS=136, ASM_MINUS=137, ASM_LESS_THAN=138, ASM_GREATER_THAN=139, 
		ASM_MULTIPLY=140, ASM_DIVIDE=141, ASM_CURLY_BEGIN=142, ASM_CURLY_END=143, 
		ASM_NUMBER=144, ASM_NUMFLOAT=145, ASM_BINFLOAT=146, ASM_DECFLOAT=147, 
		ASM_HEXFLOAT=148, ASM_NUMINT=149, ASM_BININTEGER=150, ASM_DECINTEGER=151, 
		ASM_HEXINTEGER=152, ASM_CHAR=153, ASM_MULTI_REL=154, ASM_MULTI_NAME=155, 
		ASM_NAME=156, ASM_WS=157, ASM_COMMENT_LINE=158, ASM_COMMENT_BLOCK=159, 
		IMPORT_SYSTEMFILE=160, IMPORT_LOCALFILE=161, IMPORT_WS=162, IMPORT_COMMENT_LINE=163, 
		IMPORT_COMMENT_BLOCK=164;
	public static final int
		RULE_file = 0, RULE_asmFile = 1, RULE_declSeq = 2, RULE_declOrImport = 3, 
		RULE_importDecl = 4, RULE_decl = 5, RULE_declVariables = 6, RULE_declVariableList = 7, 
		RULE_typeDef = 8, RULE_declVariableInit = 9, RULE_declType = 10, RULE_declPointer = 11, 
		RULE_declArray = 12, RULE_typeSpecifier = 13, RULE_type = 14, RULE_structRef = 15, 
		RULE_structDef = 16, RULE_structMembers = 17, RULE_enumRef = 18, RULE_enumDef = 19, 
		RULE_enumMemberList = 20, RULE_enumMember = 21, RULE_declFunction = 22, 
		RULE_declFunctionBody = 23, RULE_parameterListDecl = 24, RULE_parameterDecl = 25, 
		RULE_globalDirective = 26, RULE_directiveReserveParam = 27, RULE_directive = 28, 
		RULE_stmtSeq = 29, RULE_stmt = 30, RULE_switchCases = 31, RULE_switchCase = 32, 
		RULE_forLoop = 33, RULE_forClassicInit = 34, RULE_commaExpr = 35, RULE_expr = 36, 
		RULE_parameterList = 37, RULE_declKasm = 38, RULE_asmDirectives = 39, 
		RULE_asmDirective = 40, RULE_asmLines = 41, RULE_asmLine = 42, RULE_asmLabel = 43, 
		RULE_asmInstruction = 44, RULE_asmBytes = 45, RULE_asmParamMode = 46, 
		RULE_asmExpr = 47;
	private static String[] makeRuleNames() {
		return new String[] {
			"file", "asmFile", "declSeq", "declOrImport", "importDecl", "decl", "declVariables", 
			"declVariableList", "typeDef", "declVariableInit", "declType", "declPointer", 
			"declArray", "typeSpecifier", "type", "structRef", "structDef", "structMembers", 
			"enumRef", "enumDef", "enumMemberList", "enumMember", "declFunction", 
			"declFunctionBody", "parameterListDecl", "parameterDecl", "globalDirective", 
			"directiveReserveParam", "directive", "stmtSeq", "stmt", "switchCases", 
			"switchCase", "forLoop", "forClassicInit", "commaExpr", "expr", "parameterList", 
			"declKasm", "asmDirectives", "asmDirective", "asmLines", "asmLine", "asmLabel", 
			"asmInstruction", "asmBytes", "asmParamMode", "asmExpr"
		};
	}
	public static final String[] ruleNames = makeRuleNames();

	private static String[] makeLiteralNames() {
		return new String[] {
			null, null, null, null, null, null, null, null, "';'", null, null, "'..'", 
			"'...'", "'?'", null, "'->'", null, null, null, null, "'%'", "'++'", 
			"'--'", "'&'", "'~'", "'^'", "'|'", null, null, "'=='", "'!='", null, 
			"'<='", "'>='", null, "'&&'", "'||'", "'='", null, "'typedef'", "'zp_reserve'", 
			"'pc'", "'target'", "'link'", "'extension'", "'emulator'", "'cpu'", "'code_seg'", 
			"'data_seg'", "'encoding'", "'const'", "'extern'", "'export'", "'align'", 
			"'inline'", "'volatile'", "'static'", "'interrupt'", "'register'", "'__zp_reserve'", 
			"'__address'", "'__zp'", "'__mem'", "'__ssa'", "'__ma'", "'__intrinsic'", 
			"'calling'", null, "'var_model'", "'if'", "'else'", "'while'", "'do'", 
			"'for'", "'switch'", "'return'", "'break'", "'continue'", "'asm'", "'default'", 
			"'case'", "'struct'", "'enum'", "'sizeof'", "'typeid'", "'defined'", 
			"'kickasm'", "'resource'", "'uses'", "'clobbers'", "'bytes'", "'cycles'", 
			"'!'", null, null, null, null, "'#import'", "'#include'", "'#pragma'", 
			"'#define'", null, "'#undef'", "'#ifdef'", "'#ifndef'", "'#if'", "'#elif'", 
			"'#else'", "'#endif'", null, null, null, null, null, null, null, null, 
			null, null, null, null, null, null, null, "'.byte'", null, "'#'"
		};
	}
	private static final String[] _LITERAL_NAMES = makeLiteralNames();
	private static String[] makeSymbolicNames() {
		return new String[] {
			null, "TYPEDEFNAME", "CURLY_BEGIN", "CURLY_END", "BRACKET_BEGIN", "BRACKET_END", 
			"PAR_BEGIN", "PAR_END", "SEMICOLON", "COLON", "COMMA", "RANGE", "PARAM_LIST", 
			"CONDITION", "DOT", "ARROW", "PLUS", "MINUS", "ASTERISK", "DIVIDE", "MODULO", 
			"INC", "DEC", "AND", "BIT_NOT", "BIT_XOR", "BIT_OR", "SHIFT_LEFT", "SHIFT_RIGHT", 
			"EQUAL", "NOT_EQUAL", "LESS_THAN", "LESS_THAN_EQUAL", "GREATER_THAN_EQUAL", 
			"GREATER_THAN", "LOGIC_AND", "LOGIC_OR", "ASSIGN", "ASSIGN_COMPOUND", 
			"TYPEDEF", "RESERVE", "PC", "TARGET", "LINK", "EXTENSION", "EMULATOR", 
			"CPU", "CODESEG", "DATASEG", "ENCODING", "CONST", "EXTERN", "EXPORT", 
			"ALIGN", "INLINE", "VOLATILE", "STATIC", "INTERRUPT", "REGISTER", "LOCAL_RESERVE", 
			"ADDRESS", "ADDRESS_ZEROPAGE", "ADDRESS_MAINMEM", "FORM_SSA", "FORM_MA", 
			"INTRINSIC", "CALLING", "CALLINGCONVENTION", "VARMODEL", "IF", "ELSE", 
			"WHILE", "DO", "FOR", "SWITCH", "RETURN", "BREAK", "CONTINUE", "ASM", 
			"DEFAULT", "CASE", "STRUCT", "ENUM", "SIZEOF", "TYPEID", "DEFINED", "KICKASM", 
			"RESOURCE", "USES", "CLOBBERS", "BYTES", "CYCLES", "LOGIC_NOT", "SIGNEDNESS", 
			"SIMPLETYPE", "BOOLEAN", "KICKASM_BODY", "IMPORT", "INCLUDE", "PRAGMA", 
			"DEFINE", "DEFINE_CONTINUE", "UNDEF", "IFDEF", "IFNDEF", "IFIF", "ELIF", 
			"IFELSE", "ENDIF", "NUMBER", "NUMFLOAT", "BINFLOAT", "DECFLOAT", "HEXFLOAT", 
			"NUMINT", "BININTEGER", "DECINTEGER", "HEXINTEGER", "NAME", "STRING", 
			"CHAR", "WS", "COMMENT_LINE", "COMMENT_BLOCK", "ASM_BYTE", "ASM_MNEMONIC", 
			"ASM_IMM", "ASM_COLON", "ASM_COMMA", "ASM_PAR_BEGIN", "ASM_PAR_END", 
			"ASM_BRACKET_BEGIN", "ASM_BRACKET_END", "ASM_DOT", "ASM_SHIFT_LEFT", 
			"ASM_SHIFT_RIGHT", "ASM_PLUS", "ASM_MINUS", "ASM_LESS_THAN", "ASM_GREATER_THAN", 
			"ASM_MULTIPLY", "ASM_DIVIDE", "ASM_CURLY_BEGIN", "ASM_CURLY_END", "ASM_NUMBER", 
			"ASM_NUMFLOAT", "ASM_BINFLOAT", "ASM_DECFLOAT", "ASM_HEXFLOAT", "ASM_NUMINT", 
			"ASM_BININTEGER", "ASM_DECINTEGER", "ASM_HEXINTEGER", "ASM_CHAR", "ASM_MULTI_REL", 
			"ASM_MULTI_NAME", "ASM_NAME", "ASM_WS", "ASM_COMMENT_LINE", "ASM_COMMENT_BLOCK", 
			"IMPORT_SYSTEMFILE", "IMPORT_LOCALFILE", "IMPORT_WS", "IMPORT_COMMENT_LINE", 
			"IMPORT_COMMENT_BLOCK"
		};
	}
	private static final String[] _SYMBOLIC_NAMES = makeSymbolicNames();
	public static final Vocabulary VOCABULARY = new VocabularyImpl(_LITERAL_NAMES, _SYMBOLIC_NAMES);

	/**
	 * @deprecated Use {@link #VOCABULARY} instead.
	 */
	@Deprecated
	public static final String[] tokenNames;
	static {
		tokenNames = new String[_SYMBOLIC_NAMES.length];
		for (int i = 0; i < tokenNames.length; i++) {
			tokenNames[i] = VOCABULARY.getLiteralName(i);
			if (tokenNames[i] == null) {
				tokenNames[i] = VOCABULARY.getSymbolicName(i);
			}

			if (tokenNames[i] == null) {
				tokenNames[i] = "<INVALID>";
			}
		}
	}

	@Override
	@Deprecated
	public String[] getTokenNames() {
		return tokenNames;
	}

	@Override

	public Vocabulary getVocabulary() {
		return VOCABULARY;
	}

	@Override
	public String getGrammarFileName() { return "KickCParser.g4"; }

	@Override
	public String[] getRuleNames() { return ruleNames; }

	@Override
	public String getSerializedATN() { return _serializedATN; }

	@Override
	public ATN getATN() { return _ATN; }


	    CParser cParser;

		public KickCParser(TokenStream input, CParser cParser) {
			this(input);
			this.cParser = cParser;
		}


	public KickCParser(TokenStream input) {
		super(input);
		_interp = new ParserATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}

	public static class FileContext extends ParserRuleContext {
		public DeclSeqContext declSeq() {
			return getRuleContext(DeclSeqContext.class,0);
		}
		public TerminalNode EOF() { return getToken(KickCParser.EOF, 0); }
		public FileContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_file; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterFile(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitFile(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitFile(this);
			else return visitor.visitChildren(this);
		}
	}

	public final FileContext file() throws RecognitionException {
		FileContext _localctx = new FileContext(_ctx, getState());
		enterRule(_localctx, 0, RULE_file);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(96);
			declSeq();
			setState(97);
			match(EOF);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class AsmFileContext extends ParserRuleContext {
		public AsmLinesContext asmLines() {
			return getRuleContext(AsmLinesContext.class,0);
		}
		public TerminalNode EOF() { return getToken(KickCParser.EOF, 0); }
		public AsmFileContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_asmFile; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterAsmFile(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitAsmFile(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitAsmFile(this);
			else return visitor.visitChildren(this);
		}
	}

	public final AsmFileContext asmFile() throws RecognitionException {
		AsmFileContext _localctx = new AsmFileContext(_ctx, getState());
		enterRule(_localctx, 2, RULE_asmFile);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(99);
			asmLines();
			setState(100);
			match(EOF);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class DeclSeqContext extends ParserRuleContext {
		public List<DeclOrImportContext> declOrImport() {
			return getRuleContexts(DeclOrImportContext.class);
		}
		public DeclOrImportContext declOrImport(int i) {
			return getRuleContext(DeclOrImportContext.class,i);
		}
		public DeclSeqContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_declSeq; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterDeclSeq(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitDeclSeq(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitDeclSeq(this);
			else return visitor.visitChildren(this);
		}
	}

	public final DeclSeqContext declSeq() throws RecognitionException {
		DeclSeqContext _localctx = new DeclSeqContext(_ctx, getState());
		enterRule(_localctx, 4, RULE_declSeq);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(105);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << TYPEDEFNAME) | (1L << PAR_BEGIN) | (1L << TYPEDEF) | (1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << INLINE) | (1L << VOLATILE) | (1L << STATIC) | (1L << INTERRUPT) | (1L << REGISTER) | (1L << LOCAL_RESERVE) | (1L << ADDRESS) | (1L << ADDRESS_ZEROPAGE) | (1L << ADDRESS_MAINMEM) | (1L << FORM_SSA))) != 0) || ((((_la - 64)) & ~0x3f) == 0 && ((1L << (_la - 64)) & ((1L << (FORM_MA - 64)) | (1L << (INTRINSIC - 64)) | (1L << (CALLINGCONVENTION - 64)) | (1L << (STRUCT - 64)) | (1L << (ENUM - 64)) | (1L << (KICKASM - 64)) | (1L << (SIGNEDNESS - 64)) | (1L << (SIMPLETYPE - 64)) | (1L << (IMPORT - 64)) | (1L << (INCLUDE - 64)) | (1L << (PRAGMA - 64)))) != 0)) {
				{
				{
				setState(102);
				declOrImport();
				}
				}
				setState(107);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class DeclOrImportContext extends ParserRuleContext {
		public DeclContext decl() {
			return getRuleContext(DeclContext.class,0);
		}
		public ImportDeclContext importDecl() {
			return getRuleContext(ImportDeclContext.class,0);
		}
		public DeclOrImportContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_declOrImport; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterDeclOrImport(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitDeclOrImport(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitDeclOrImport(this);
			else return visitor.visitChildren(this);
		}
	}

	public final DeclOrImportContext declOrImport() throws RecognitionException {
		DeclOrImportContext _localctx = new DeclOrImportContext(_ctx, getState());
		enterRule(_localctx, 6, RULE_declOrImport);
		try {
			setState(110);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case TYPEDEFNAME:
			case PAR_BEGIN:
			case TYPEDEF:
			case CONST:
			case EXTERN:
			case EXPORT:
			case ALIGN:
			case INLINE:
			case VOLATILE:
			case STATIC:
			case INTERRUPT:
			case REGISTER:
			case LOCAL_RESERVE:
			case ADDRESS:
			case ADDRESS_ZEROPAGE:
			case ADDRESS_MAINMEM:
			case FORM_SSA:
			case FORM_MA:
			case INTRINSIC:
			case CALLINGCONVENTION:
			case STRUCT:
			case ENUM:
			case KICKASM:
			case SIGNEDNESS:
			case SIMPLETYPE:
			case PRAGMA:
				enterOuterAlt(_localctx, 1);
				{
				setState(108);
				decl();
				}
				break;
			case IMPORT:
			case INCLUDE:
				enterOuterAlt(_localctx, 2);
				{
				setState(109);
				importDecl();
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ImportDeclContext extends ParserRuleContext {
		public ImportDeclContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_importDecl; }
	 
		public ImportDeclContext() { }
		public void copyFrom(ImportDeclContext ctx) {
			super.copyFrom(ctx);
		}
	}
	public static class IncludeFileContext extends ImportDeclContext {
		public TerminalNode INCLUDE() { return getToken(KickCParser.INCLUDE, 0); }
		public TerminalNode IMPORT_LOCALFILE() { return getToken(KickCParser.IMPORT_LOCALFILE, 0); }
		public IncludeFileContext(ImportDeclContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterIncludeFile(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitIncludeFile(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitIncludeFile(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class IncludeSystemContext extends ImportDeclContext {
		public TerminalNode INCLUDE() { return getToken(KickCParser.INCLUDE, 0); }
		public TerminalNode IMPORT_SYSTEMFILE() { return getToken(KickCParser.IMPORT_SYSTEMFILE, 0); }
		public IncludeSystemContext(ImportDeclContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterIncludeSystem(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitIncludeSystem(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitIncludeSystem(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class ImportFileContext extends ImportDeclContext {
		public TerminalNode IMPORT() { return getToken(KickCParser.IMPORT, 0); }
		public TerminalNode IMPORT_LOCALFILE() { return getToken(KickCParser.IMPORT_LOCALFILE, 0); }
		public ImportFileContext(ImportDeclContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterImportFile(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitImportFile(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitImportFile(this);
			else return visitor.visitChildren(this);
		}
	}

	public final ImportDeclContext importDecl() throws RecognitionException {
		ImportDeclContext _localctx = new ImportDeclContext(_ctx, getState());
		enterRule(_localctx, 8, RULE_importDecl);
		try {
			setState(118);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,2,_ctx) ) {
			case 1:
				_localctx = new ImportFileContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(112);
				match(IMPORT);
				setState(113);
				match(IMPORT_LOCALFILE);
				}
				break;
			case 2:
				_localctx = new IncludeFileContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(114);
				match(INCLUDE);
				setState(115);
				match(IMPORT_LOCALFILE);
				}
				break;
			case 3:
				_localctx = new IncludeSystemContext(_localctx);
				enterOuterAlt(_localctx, 3);
				{
				setState(116);
				match(INCLUDE);
				setState(117);
				match(IMPORT_SYSTEMFILE);
				}
				break;
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class DeclContext extends ParserRuleContext {
		public DeclVariablesContext declVariables() {
			return getRuleContext(DeclVariablesContext.class,0);
		}
		public TerminalNode SEMICOLON() { return getToken(KickCParser.SEMICOLON, 0); }
		public StructDefContext structDef() {
			return getRuleContext(StructDefContext.class,0);
		}
		public EnumDefContext enumDef() {
			return getRuleContext(EnumDefContext.class,0);
		}
		public DeclFunctionContext declFunction() {
			return getRuleContext(DeclFunctionContext.class,0);
		}
		public DeclKasmContext declKasm() {
			return getRuleContext(DeclKasmContext.class,0);
		}
		public GlobalDirectiveContext globalDirective() {
			return getRuleContext(GlobalDirectiveContext.class,0);
		}
		public TypeDefContext typeDef() {
			return getRuleContext(TypeDefContext.class,0);
		}
		public DeclContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_decl; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterDecl(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitDecl(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitDecl(this);
			else return visitor.visitChildren(this);
		}
	}

	public final DeclContext decl() throws RecognitionException {
		DeclContext _localctx = new DeclContext(_ctx, getState());
		enterRule(_localctx, 10, RULE_decl);
		try {
			setState(135);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,3,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				setState(120);
				declVariables();
				setState(121);
				match(SEMICOLON);
				}
				break;
			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(123);
				structDef();
				setState(124);
				match(SEMICOLON);
				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(126);
				enumDef();
				setState(127);
				match(SEMICOLON);
				}
				break;
			case 4:
				enterOuterAlt(_localctx, 4);
				{
				setState(129);
				declFunction();
				}
				break;
			case 5:
				enterOuterAlt(_localctx, 5);
				{
				setState(130);
				declKasm();
				}
				break;
			case 6:
				enterOuterAlt(_localctx, 6);
				{
				setState(131);
				globalDirective();
				}
				break;
			case 7:
				enterOuterAlt(_localctx, 7);
				{
				setState(132);
				typeDef();
				setState(133);
				match(SEMICOLON);
				}
				break;
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class DeclVariablesContext extends ParserRuleContext {
		public DeclTypeContext declType() {
			return getRuleContext(DeclTypeContext.class,0);
		}
		public DeclVariableListContext declVariableList() {
			return getRuleContext(DeclVariableListContext.class,0);
		}
		public DeclVariablesContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_declVariables; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterDeclVariables(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitDeclVariables(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitDeclVariables(this);
			else return visitor.visitChildren(this);
		}
	}

	public final DeclVariablesContext declVariables() throws RecognitionException {
		DeclVariablesContext _localctx = new DeclVariablesContext(_ctx, getState());
		enterRule(_localctx, 12, RULE_declVariables);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(137);
			declType();
			setState(138);
			declVariableList(0);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class DeclVariableListContext extends ParserRuleContext {
		public DeclVariableInitContext declVariableInit() {
			return getRuleContext(DeclVariableInitContext.class,0);
		}
		public List<DeclPointerContext> declPointer() {
			return getRuleContexts(DeclPointerContext.class);
		}
		public DeclPointerContext declPointer(int i) {
			return getRuleContext(DeclPointerContext.class,i);
		}
		public DeclVariableListContext declVariableList() {
			return getRuleContext(DeclVariableListContext.class,0);
		}
		public TerminalNode COMMA() { return getToken(KickCParser.COMMA, 0); }
		public DeclVariableListContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_declVariableList; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterDeclVariableList(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitDeclVariableList(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitDeclVariableList(this);
			else return visitor.visitChildren(this);
		}
	}

	public final DeclVariableListContext declVariableList() throws RecognitionException {
		return declVariableList(0);
	}

	private DeclVariableListContext declVariableList(int _p) throws RecognitionException {
		ParserRuleContext _parentctx = _ctx;
		int _parentState = getState();
		DeclVariableListContext _localctx = new DeclVariableListContext(_ctx, _parentState);
		DeclVariableListContext _prevctx = _localctx;
		int _startState = 14;
		enterRecursionRule(_localctx, 14, RULE_declVariableList, _p);
		int _la;
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			{
			setState(144);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==ASTERISK) {
				{
				{
				setState(141);
				declPointer();
				}
				}
				setState(146);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(147);
			declVariableInit();
			}
			_ctx.stop = _input.LT(-1);
			setState(160);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,6,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					{
					_localctx = new DeclVariableListContext(_parentctx, _parentState);
					pushNewRecursionContext(_localctx, _startState, RULE_declVariableList);
					setState(149);
					if (!(precpred(_ctx, 1))) throw new FailedPredicateException(this, "precpred(_ctx, 1)");
					setState(150);
					match(COMMA);
					setState(154);
					_errHandler.sync(this);
					_la = _input.LA(1);
					while (_la==ASTERISK) {
						{
						{
						setState(151);
						declPointer();
						}
						}
						setState(156);
						_errHandler.sync(this);
						_la = _input.LA(1);
					}
					setState(157);
					declVariableInit();
					}
					} 
				}
				setState(162);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,6,_ctx);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			unrollRecursionContexts(_parentctx);
		}
		return _localctx;
	}

	public static class TypeDefContext extends ParserRuleContext {
		public Token NAME;
		public TerminalNode TYPEDEF() { return getToken(KickCParser.TYPEDEF, 0); }
		public DeclTypeContext declType() {
			return getRuleContext(DeclTypeContext.class,0);
		}
		public TerminalNode NAME() { return getToken(KickCParser.NAME, 0); }
		public List<DeclPointerContext> declPointer() {
			return getRuleContexts(DeclPointerContext.class);
		}
		public DeclPointerContext declPointer(int i) {
			return getRuleContext(DeclPointerContext.class,i);
		}
		public List<DeclArrayContext> declArray() {
			return getRuleContexts(DeclArrayContext.class);
		}
		public DeclArrayContext declArray(int i) {
			return getRuleContext(DeclArrayContext.class,i);
		}
		public TypeDefContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_typeDef; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterTypeDef(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitTypeDef(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitTypeDef(this);
			else return visitor.visitChildren(this);
		}
	}

	public final TypeDefContext typeDef() throws RecognitionException {
		TypeDefContext _localctx = new TypeDefContext(_ctx, getState());
		enterRule(_localctx, 16, RULE_typeDef);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(163);
			match(TYPEDEF);
			setState(164);
			declType();
			setState(168);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==ASTERISK) {
				{
				{
				setState(165);
				declPointer();
				}
				}
				setState(170);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(171);
			((TypeDefContext)_localctx).NAME = match(NAME);
			setState(175);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==BRACKET_BEGIN) {
				{
				{
				setState(172);
				declArray();
				}
				}
				setState(177);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			cParser.addTypedef((((TypeDefContext)_localctx).NAME!=null?((TypeDefContext)_localctx).NAME.getText():null));
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class DeclVariableInitContext extends ParserRuleContext {
		public DeclVariableInitContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_declVariableInit; }
	 
		public DeclVariableInitContext() { }
		public void copyFrom(DeclVariableInitContext ctx) {
			super.copyFrom(ctx);
		}
	}
	public static class DeclVariableInitKasmContext extends DeclVariableInitContext {
		public TerminalNode NAME() { return getToken(KickCParser.NAME, 0); }
		public TerminalNode ASSIGN() { return getToken(KickCParser.ASSIGN, 0); }
		public DeclKasmContext declKasm() {
			return getRuleContext(DeclKasmContext.class,0);
		}
		public List<DeclArrayContext> declArray() {
			return getRuleContexts(DeclArrayContext.class);
		}
		public DeclArrayContext declArray(int i) {
			return getRuleContext(DeclArrayContext.class,i);
		}
		public DeclVariableInitKasmContext(DeclVariableInitContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterDeclVariableInitKasm(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitDeclVariableInitKasm(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitDeclVariableInitKasm(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class DeclVariableInitExprContext extends DeclVariableInitContext {
		public TerminalNode NAME() { return getToken(KickCParser.NAME, 0); }
		public List<DeclArrayContext> declArray() {
			return getRuleContexts(DeclArrayContext.class);
		}
		public DeclArrayContext declArray(int i) {
			return getRuleContext(DeclArrayContext.class,i);
		}
		public TerminalNode ASSIGN() { return getToken(KickCParser.ASSIGN, 0); }
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public DeclVariableInitExprContext(DeclVariableInitContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterDeclVariableInitExpr(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitDeclVariableInitExpr(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitDeclVariableInitExpr(this);
			else return visitor.visitChildren(this);
		}
	}

	public final DeclVariableInitContext declVariableInit() throws RecognitionException {
		DeclVariableInitContext _localctx = new DeclVariableInitContext(_ctx, getState());
		enterRule(_localctx, 18, RULE_declVariableInit);
		int _la;
		try {
			int _alt;
			setState(200);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,12,_ctx) ) {
			case 1:
				_localctx = new DeclVariableInitExprContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(180);
				match(NAME);
				setState(184);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,9,_ctx);
				while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
					if ( _alt==1 ) {
						{
						{
						setState(181);
						declArray();
						}
						} 
					}
					setState(186);
					_errHandler.sync(this);
					_alt = getInterpreter().adaptivePredict(_input,9,_ctx);
				}
				setState(189);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,10,_ctx) ) {
				case 1:
					{
					setState(187);
					match(ASSIGN);
					setState(188);
					expr(0);
					}
					break;
				}
				}
				break;
			case 2:
				_localctx = new DeclVariableInitKasmContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(191);
				match(NAME);
				setState(195);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (_la==BRACKET_BEGIN) {
					{
					{
					setState(192);
					declArray();
					}
					}
					setState(197);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				setState(198);
				match(ASSIGN);
				setState(199);
				declKasm();
				}
				break;
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class DeclTypeContext extends ParserRuleContext {
		public TypeContext type() {
			return getRuleContext(TypeContext.class,0);
		}
		public List<DirectiveContext> directive() {
			return getRuleContexts(DirectiveContext.class);
		}
		public DirectiveContext directive(int i) {
			return getRuleContext(DirectiveContext.class,i);
		}
		public DeclTypeContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_declType; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterDeclType(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitDeclType(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitDeclType(this);
			else return visitor.visitChildren(this);
		}
	}

	public final DeclTypeContext declType() throws RecognitionException {
		DeclTypeContext _localctx = new DeclTypeContext(_ctx, getState());
		enterRule(_localctx, 20, RULE_declType);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(205);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (((((_la - 50)) & ~0x3f) == 0 && ((1L << (_la - 50)) & ((1L << (CONST - 50)) | (1L << (EXTERN - 50)) | (1L << (EXPORT - 50)) | (1L << (ALIGN - 50)) | (1L << (INLINE - 50)) | (1L << (VOLATILE - 50)) | (1L << (STATIC - 50)) | (1L << (INTERRUPT - 50)) | (1L << (REGISTER - 50)) | (1L << (LOCAL_RESERVE - 50)) | (1L << (ADDRESS - 50)) | (1L << (ADDRESS_ZEROPAGE - 50)) | (1L << (ADDRESS_MAINMEM - 50)) | (1L << (FORM_SSA - 50)) | (1L << (FORM_MA - 50)) | (1L << (INTRINSIC - 50)) | (1L << (CALLINGCONVENTION - 50)))) != 0)) {
				{
				{
				setState(202);
				directive();
				}
				}
				setState(207);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(208);
			type(0);
			setState(212);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (((((_la - 50)) & ~0x3f) == 0 && ((1L << (_la - 50)) & ((1L << (CONST - 50)) | (1L << (EXTERN - 50)) | (1L << (EXPORT - 50)) | (1L << (ALIGN - 50)) | (1L << (INLINE - 50)) | (1L << (VOLATILE - 50)) | (1L << (STATIC - 50)) | (1L << (INTERRUPT - 50)) | (1L << (REGISTER - 50)) | (1L << (LOCAL_RESERVE - 50)) | (1L << (ADDRESS - 50)) | (1L << (ADDRESS_ZEROPAGE - 50)) | (1L << (ADDRESS_MAINMEM - 50)) | (1L << (FORM_SSA - 50)) | (1L << (FORM_MA - 50)) | (1L << (INTRINSIC - 50)) | (1L << (CALLINGCONVENTION - 50)))) != 0)) {
				{
				{
				setState(209);
				directive();
				}
				}
				setState(214);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class DeclPointerContext extends ParserRuleContext {
		public TerminalNode ASTERISK() { return getToken(KickCParser.ASTERISK, 0); }
		public List<DirectiveContext> directive() {
			return getRuleContexts(DirectiveContext.class);
		}
		public DirectiveContext directive(int i) {
			return getRuleContext(DirectiveContext.class,i);
		}
		public DeclPointerContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_declPointer; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterDeclPointer(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitDeclPointer(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitDeclPointer(this);
			else return visitor.visitChildren(this);
		}
	}

	public final DeclPointerContext declPointer() throws RecognitionException {
		DeclPointerContext _localctx = new DeclPointerContext(_ctx, getState());
		enterRule(_localctx, 22, RULE_declPointer);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(215);
			match(ASTERISK);
			setState(219);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (((((_la - 50)) & ~0x3f) == 0 && ((1L << (_la - 50)) & ((1L << (CONST - 50)) | (1L << (EXTERN - 50)) | (1L << (EXPORT - 50)) | (1L << (ALIGN - 50)) | (1L << (INLINE - 50)) | (1L << (VOLATILE - 50)) | (1L << (STATIC - 50)) | (1L << (INTERRUPT - 50)) | (1L << (REGISTER - 50)) | (1L << (LOCAL_RESERVE - 50)) | (1L << (ADDRESS - 50)) | (1L << (ADDRESS_ZEROPAGE - 50)) | (1L << (ADDRESS_MAINMEM - 50)) | (1L << (FORM_SSA - 50)) | (1L << (FORM_MA - 50)) | (1L << (INTRINSIC - 50)) | (1L << (CALLINGCONVENTION - 50)))) != 0)) {
				{
				{
				setState(216);
				directive();
				}
				}
				setState(221);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class DeclArrayContext extends ParserRuleContext {
		public TerminalNode BRACKET_BEGIN() { return getToken(KickCParser.BRACKET_BEGIN, 0); }
		public TerminalNode BRACKET_END() { return getToken(KickCParser.BRACKET_END, 0); }
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public DeclArrayContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_declArray; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterDeclArray(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitDeclArray(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitDeclArray(this);
			else return visitor.visitChildren(this);
		}
	}

	public final DeclArrayContext declArray() throws RecognitionException {
		DeclArrayContext _localctx = new DeclArrayContext(_ctx, getState());
		enterRule(_localctx, 24, RULE_declArray);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(222);
			match(BRACKET_BEGIN);
			setState(224);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << CURLY_BEGIN) | (1L << PAR_BEGIN) | (1L << PLUS) | (1L << MINUS) | (1L << ASTERISK) | (1L << INC) | (1L << DEC) | (1L << AND) | (1L << BIT_NOT) | (1L << LESS_THAN) | (1L << GREATER_THAN))) != 0) || ((((_la - 83)) & ~0x3f) == 0 && ((1L << (_la - 83)) & ((1L << (SIZEOF - 83)) | (1L << (TYPEID - 83)) | (1L << (DEFINED - 83)) | (1L << (LOGIC_NOT - 83)) | (1L << (BOOLEAN - 83)) | (1L << (NUMBER - 83)) | (1L << (NAME - 83)) | (1L << (STRING - 83)) | (1L << (CHAR - 83)))) != 0)) {
				{
				setState(223);
				expr(0);
				}
			}

			setState(226);
			match(BRACKET_END);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class TypeSpecifierContext extends ParserRuleContext {
		public TypeSpecifierContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_typeSpecifier; }
	 
		public TypeSpecifierContext() { }
		public void copyFrom(TypeSpecifierContext ctx) {
			super.copyFrom(ctx);
		}
	}
	public static class TypeSpecifierSimpleContext extends TypeSpecifierContext {
		public TypeContext type() {
			return getRuleContext(TypeContext.class,0);
		}
		public TypeSpecifierSimpleContext(TypeSpecifierContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterTypeSpecifierSimple(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitTypeSpecifierSimple(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitTypeSpecifierSimple(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class TypeSpecifierPointerContext extends TypeSpecifierContext {
		public TypeSpecifierContext typeSpecifier() {
			return getRuleContext(TypeSpecifierContext.class,0);
		}
		public TerminalNode ASTERISK() { return getToken(KickCParser.ASTERISK, 0); }
		public TypeSpecifierPointerContext(TypeSpecifierContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterTypeSpecifierPointer(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitTypeSpecifierPointer(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitTypeSpecifierPointer(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class TypeSpecifierArrayContext extends TypeSpecifierContext {
		public TypeSpecifierContext typeSpecifier() {
			return getRuleContext(TypeSpecifierContext.class,0);
		}
		public TerminalNode BRACKET_BEGIN() { return getToken(KickCParser.BRACKET_BEGIN, 0); }
		public TerminalNode BRACKET_END() { return getToken(KickCParser.BRACKET_END, 0); }
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public TypeSpecifierArrayContext(TypeSpecifierContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterTypeSpecifierArray(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitTypeSpecifierArray(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitTypeSpecifierArray(this);
			else return visitor.visitChildren(this);
		}
	}

	public final TypeSpecifierContext typeSpecifier() throws RecognitionException {
		return typeSpecifier(0);
	}

	private TypeSpecifierContext typeSpecifier(int _p) throws RecognitionException {
		ParserRuleContext _parentctx = _ctx;
		int _parentState = getState();
		TypeSpecifierContext _localctx = new TypeSpecifierContext(_ctx, _parentState);
		TypeSpecifierContext _prevctx = _localctx;
		int _startState = 26;
		enterRecursionRule(_localctx, 26, RULE_typeSpecifier, _p);
		int _la;
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			{
			_localctx = new TypeSpecifierSimpleContext(_localctx);
			_ctx = _localctx;
			_prevctx = _localctx;

			setState(229);
			type(0);
			}
			_ctx.stop = _input.LT(-1);
			setState(241);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,19,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					setState(239);
					_errHandler.sync(this);
					switch ( getInterpreter().adaptivePredict(_input,18,_ctx) ) {
					case 1:
						{
						_localctx = new TypeSpecifierPointerContext(new TypeSpecifierContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_typeSpecifier);
						setState(231);
						if (!(precpred(_ctx, 2))) throw new FailedPredicateException(this, "precpred(_ctx, 2)");
						setState(232);
						match(ASTERISK);
						}
						break;
					case 2:
						{
						_localctx = new TypeSpecifierArrayContext(new TypeSpecifierContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_typeSpecifier);
						setState(233);
						if (!(precpred(_ctx, 1))) throw new FailedPredicateException(this, "precpred(_ctx, 1)");
						setState(234);
						match(BRACKET_BEGIN);
						setState(236);
						_errHandler.sync(this);
						_la = _input.LA(1);
						if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << CURLY_BEGIN) | (1L << PAR_BEGIN) | (1L << PLUS) | (1L << MINUS) | (1L << ASTERISK) | (1L << INC) | (1L << DEC) | (1L << AND) | (1L << BIT_NOT) | (1L << LESS_THAN) | (1L << GREATER_THAN))) != 0) || ((((_la - 83)) & ~0x3f) == 0 && ((1L << (_la - 83)) & ((1L << (SIZEOF - 83)) | (1L << (TYPEID - 83)) | (1L << (DEFINED - 83)) | (1L << (LOGIC_NOT - 83)) | (1L << (BOOLEAN - 83)) | (1L << (NUMBER - 83)) | (1L << (NAME - 83)) | (1L << (STRING - 83)) | (1L << (CHAR - 83)))) != 0)) {
							{
							setState(235);
							expr(0);
							}
						}

						setState(238);
						match(BRACKET_END);
						}
						break;
					}
					} 
				}
				setState(243);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,19,_ctx);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			unrollRecursionContexts(_parentctx);
		}
		return _localctx;
	}

	public static class TypeContext extends ParserRuleContext {
		public TypeContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_type; }
	 
		public TypeContext() { }
		public void copyFrom(TypeContext ctx) {
			super.copyFrom(ctx);
		}
	}
	public static class TypeParContext extends TypeContext {
		public TerminalNode PAR_BEGIN() { return getToken(KickCParser.PAR_BEGIN, 0); }
		public TypeContext type() {
			return getRuleContext(TypeContext.class,0);
		}
		public TerminalNode PAR_END() { return getToken(KickCParser.PAR_END, 0); }
		public TypeParContext(TypeContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterTypePar(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitTypePar(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitTypePar(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class TypeProcedureContext extends TypeContext {
		public TypeContext type() {
			return getRuleContext(TypeContext.class,0);
		}
		public TerminalNode PAR_BEGIN() { return getToken(KickCParser.PAR_BEGIN, 0); }
		public TerminalNode PAR_END() { return getToken(KickCParser.PAR_END, 0); }
		public TypeProcedureContext(TypeContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterTypeProcedure(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitTypeProcedure(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitTypeProcedure(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class TypeArrayContext extends TypeContext {
		public TypeContext type() {
			return getRuleContext(TypeContext.class,0);
		}
		public TerminalNode BRACKET_BEGIN() { return getToken(KickCParser.BRACKET_BEGIN, 0); }
		public TerminalNode BRACKET_END() { return getToken(KickCParser.BRACKET_END, 0); }
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public TypeArrayContext(TypeContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterTypeArray(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitTypeArray(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitTypeArray(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class TypeStructRefContext extends TypeContext {
		public StructRefContext structRef() {
			return getRuleContext(StructRefContext.class,0);
		}
		public TypeStructRefContext(TypeContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterTypeStructRef(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitTypeStructRef(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitTypeStructRef(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class TypeSimpleContext extends TypeContext {
		public TerminalNode SIMPLETYPE() { return getToken(KickCParser.SIMPLETYPE, 0); }
		public TypeSimpleContext(TypeContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterTypeSimple(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitTypeSimple(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitTypeSimple(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class TypeStructDefContext extends TypeContext {
		public StructDefContext structDef() {
			return getRuleContext(StructDefContext.class,0);
		}
		public TypeStructDefContext(TypeContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterTypeStructDef(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitTypeStructDef(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitTypeStructDef(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class TypeNamedRefContext extends TypeContext {
		public TerminalNode TYPEDEFNAME() { return getToken(KickCParser.TYPEDEFNAME, 0); }
		public TypeNamedRefContext(TypeContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterTypeNamedRef(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitTypeNamedRef(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitTypeNamedRef(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class TypeSignedSimpleContext extends TypeContext {
		public TerminalNode SIGNEDNESS() { return getToken(KickCParser.SIGNEDNESS, 0); }
		public TerminalNode SIMPLETYPE() { return getToken(KickCParser.SIMPLETYPE, 0); }
		public TypeSignedSimpleContext(TypeContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterTypeSignedSimple(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitTypeSignedSimple(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitTypeSignedSimple(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class TypeEnumRefContext extends TypeContext {
		public EnumRefContext enumRef() {
			return getRuleContext(EnumRefContext.class,0);
		}
		public TypeEnumRefContext(TypeContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterTypeEnumRef(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitTypeEnumRef(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitTypeEnumRef(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class TypeEnumDefContext extends TypeContext {
		public EnumDefContext enumDef() {
			return getRuleContext(EnumDefContext.class,0);
		}
		public TypeEnumDefContext(TypeContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterTypeEnumDef(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitTypeEnumDef(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitTypeEnumDef(this);
			else return visitor.visitChildren(this);
		}
	}

	public final TypeContext type() throws RecognitionException {
		return type(0);
	}

	private TypeContext type(int _p) throws RecognitionException {
		ParserRuleContext _parentctx = _ctx;
		int _parentState = getState();
		TypeContext _localctx = new TypeContext(_ctx, _parentState);
		TypeContext _prevctx = _localctx;
		int _startState = 28;
		enterRecursionRule(_localctx, 28, RULE_type, _p);
		int _la;
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(259);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,21,_ctx) ) {
			case 1:
				{
				_localctx = new TypeParContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;

				setState(245);
				match(PAR_BEGIN);
				setState(246);
				type(0);
				setState(247);
				match(PAR_END);
				}
				break;
			case 2:
				{
				_localctx = new TypeSimpleContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(249);
				match(SIMPLETYPE);
				}
				break;
			case 3:
				{
				_localctx = new TypeSignedSimpleContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(250);
				match(SIGNEDNESS);
				setState(252);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,20,_ctx) ) {
				case 1:
					{
					setState(251);
					match(SIMPLETYPE);
					}
					break;
				}
				}
				break;
			case 4:
				{
				_localctx = new TypeStructDefContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(254);
				structDef();
				}
				break;
			case 5:
				{
				_localctx = new TypeStructRefContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(255);
				structRef();
				}
				break;
			case 6:
				{
				_localctx = new TypeEnumDefContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(256);
				enumDef();
				}
				break;
			case 7:
				{
				_localctx = new TypeEnumRefContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(257);
				enumRef();
				}
				break;
			case 8:
				{
				_localctx = new TypeNamedRefContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(258);
				match(TYPEDEFNAME);
				}
				break;
			}
			_ctx.stop = _input.LT(-1);
			setState(272);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,24,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					setState(270);
					_errHandler.sync(this);
					switch ( getInterpreter().adaptivePredict(_input,23,_ctx) ) {
					case 1:
						{
						_localctx = new TypeArrayContext(new TypeContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_type);
						setState(261);
						if (!(precpred(_ctx, 7))) throw new FailedPredicateException(this, "precpred(_ctx, 7)");
						setState(262);
						match(BRACKET_BEGIN);
						setState(264);
						_errHandler.sync(this);
						_la = _input.LA(1);
						if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << CURLY_BEGIN) | (1L << PAR_BEGIN) | (1L << PLUS) | (1L << MINUS) | (1L << ASTERISK) | (1L << INC) | (1L << DEC) | (1L << AND) | (1L << BIT_NOT) | (1L << LESS_THAN) | (1L << GREATER_THAN))) != 0) || ((((_la - 83)) & ~0x3f) == 0 && ((1L << (_la - 83)) & ((1L << (SIZEOF - 83)) | (1L << (TYPEID - 83)) | (1L << (DEFINED - 83)) | (1L << (LOGIC_NOT - 83)) | (1L << (BOOLEAN - 83)) | (1L << (NUMBER - 83)) | (1L << (NAME - 83)) | (1L << (STRING - 83)) | (1L << (CHAR - 83)))) != 0)) {
							{
							setState(263);
							expr(0);
							}
						}

						setState(266);
						match(BRACKET_END);
						}
						break;
					case 2:
						{
						_localctx = new TypeProcedureContext(new TypeContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_type);
						setState(267);
						if (!(precpred(_ctx, 6))) throw new FailedPredicateException(this, "precpred(_ctx, 6)");
						setState(268);
						match(PAR_BEGIN);
						setState(269);
						match(PAR_END);
						}
						break;
					}
					} 
				}
				setState(274);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,24,_ctx);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			unrollRecursionContexts(_parentctx);
		}
		return _localctx;
	}

	public static class StructRefContext extends ParserRuleContext {
		public TerminalNode STRUCT() { return getToken(KickCParser.STRUCT, 0); }
		public TerminalNode NAME() { return getToken(KickCParser.NAME, 0); }
		public StructRefContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_structRef; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterStructRef(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitStructRef(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitStructRef(this);
			else return visitor.visitChildren(this);
		}
	}

	public final StructRefContext structRef() throws RecognitionException {
		StructRefContext _localctx = new StructRefContext(_ctx, getState());
		enterRule(_localctx, 30, RULE_structRef);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(275);
			match(STRUCT);
			setState(276);
			match(NAME);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class StructDefContext extends ParserRuleContext {
		public TerminalNode STRUCT() { return getToken(KickCParser.STRUCT, 0); }
		public TerminalNode CURLY_BEGIN() { return getToken(KickCParser.CURLY_BEGIN, 0); }
		public TerminalNode CURLY_END() { return getToken(KickCParser.CURLY_END, 0); }
		public TerminalNode NAME() { return getToken(KickCParser.NAME, 0); }
		public List<StructMembersContext> structMembers() {
			return getRuleContexts(StructMembersContext.class);
		}
		public StructMembersContext structMembers(int i) {
			return getRuleContext(StructMembersContext.class,i);
		}
		public StructDefContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_structDef; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterStructDef(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitStructDef(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitStructDef(this);
			else return visitor.visitChildren(this);
		}
	}

	public final StructDefContext structDef() throws RecognitionException {
		StructDefContext _localctx = new StructDefContext(_ctx, getState());
		enterRule(_localctx, 32, RULE_structDef);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(278);
			match(STRUCT);
			setState(280);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==NAME) {
				{
				setState(279);
				match(NAME);
				}
			}

			setState(282);
			match(CURLY_BEGIN);
			setState(284); 
			_errHandler.sync(this);
			_la = _input.LA(1);
			do {
				{
				{
				setState(283);
				structMembers();
				}
				}
				setState(286); 
				_errHandler.sync(this);
				_la = _input.LA(1);
			} while ( (((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << TYPEDEFNAME) | (1L << PAR_BEGIN) | (1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << INLINE) | (1L << VOLATILE) | (1L << STATIC) | (1L << INTERRUPT) | (1L << REGISTER) | (1L << LOCAL_RESERVE) | (1L << ADDRESS) | (1L << ADDRESS_ZEROPAGE) | (1L << ADDRESS_MAINMEM) | (1L << FORM_SSA))) != 0) || ((((_la - 64)) & ~0x3f) == 0 && ((1L << (_la - 64)) & ((1L << (FORM_MA - 64)) | (1L << (INTRINSIC - 64)) | (1L << (CALLINGCONVENTION - 64)) | (1L << (STRUCT - 64)) | (1L << (ENUM - 64)) | (1L << (SIGNEDNESS - 64)) | (1L << (SIMPLETYPE - 64)))) != 0) );
			setState(288);
			match(CURLY_END);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class StructMembersContext extends ParserRuleContext {
		public DeclVariablesContext declVariables() {
			return getRuleContext(DeclVariablesContext.class,0);
		}
		public TerminalNode SEMICOLON() { return getToken(KickCParser.SEMICOLON, 0); }
		public StructMembersContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_structMembers; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterStructMembers(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitStructMembers(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitStructMembers(this);
			else return visitor.visitChildren(this);
		}
	}

	public final StructMembersContext structMembers() throws RecognitionException {
		StructMembersContext _localctx = new StructMembersContext(_ctx, getState());
		enterRule(_localctx, 34, RULE_structMembers);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(290);
			declVariables();
			setState(291);
			match(SEMICOLON);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class EnumRefContext extends ParserRuleContext {
		public TerminalNode ENUM() { return getToken(KickCParser.ENUM, 0); }
		public TerminalNode NAME() { return getToken(KickCParser.NAME, 0); }
		public EnumRefContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_enumRef; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterEnumRef(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitEnumRef(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitEnumRef(this);
			else return visitor.visitChildren(this);
		}
	}

	public final EnumRefContext enumRef() throws RecognitionException {
		EnumRefContext _localctx = new EnumRefContext(_ctx, getState());
		enterRule(_localctx, 36, RULE_enumRef);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(293);
			match(ENUM);
			setState(294);
			match(NAME);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class EnumDefContext extends ParserRuleContext {
		public TerminalNode ENUM() { return getToken(KickCParser.ENUM, 0); }
		public TerminalNode CURLY_BEGIN() { return getToken(KickCParser.CURLY_BEGIN, 0); }
		public EnumMemberListContext enumMemberList() {
			return getRuleContext(EnumMemberListContext.class,0);
		}
		public TerminalNode CURLY_END() { return getToken(KickCParser.CURLY_END, 0); }
		public TerminalNode NAME() { return getToken(KickCParser.NAME, 0); }
		public EnumDefContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_enumDef; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterEnumDef(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitEnumDef(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitEnumDef(this);
			else return visitor.visitChildren(this);
		}
	}

	public final EnumDefContext enumDef() throws RecognitionException {
		EnumDefContext _localctx = new EnumDefContext(_ctx, getState());
		enterRule(_localctx, 38, RULE_enumDef);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(296);
			match(ENUM);
			setState(298);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==NAME) {
				{
				setState(297);
				match(NAME);
				}
			}

			setState(300);
			match(CURLY_BEGIN);
			setState(301);
			enumMemberList(0);
			setState(302);
			match(CURLY_END);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class EnumMemberListContext extends ParserRuleContext {
		public EnumMemberContext enumMember() {
			return getRuleContext(EnumMemberContext.class,0);
		}
		public EnumMemberListContext enumMemberList() {
			return getRuleContext(EnumMemberListContext.class,0);
		}
		public TerminalNode COMMA() { return getToken(KickCParser.COMMA, 0); }
		public EnumMemberListContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_enumMemberList; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterEnumMemberList(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitEnumMemberList(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitEnumMemberList(this);
			else return visitor.visitChildren(this);
		}
	}

	public final EnumMemberListContext enumMemberList() throws RecognitionException {
		return enumMemberList(0);
	}

	private EnumMemberListContext enumMemberList(int _p) throws RecognitionException {
		ParserRuleContext _parentctx = _ctx;
		int _parentState = getState();
		EnumMemberListContext _localctx = new EnumMemberListContext(_ctx, _parentState);
		EnumMemberListContext _prevctx = _localctx;
		int _startState = 40;
		enterRecursionRule(_localctx, 40, RULE_enumMemberList, _p);
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			{
			setState(305);
			enumMember();
			}
			_ctx.stop = _input.LT(-1);
			setState(312);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,28,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					{
					_localctx = new EnumMemberListContext(_parentctx, _parentState);
					pushNewRecursionContext(_localctx, _startState, RULE_enumMemberList);
					setState(307);
					if (!(precpred(_ctx, 1))) throw new FailedPredicateException(this, "precpred(_ctx, 1)");
					setState(308);
					match(COMMA);
					setState(309);
					enumMember();
					}
					} 
				}
				setState(314);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,28,_ctx);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			unrollRecursionContexts(_parentctx);
		}
		return _localctx;
	}

	public static class EnumMemberContext extends ParserRuleContext {
		public TerminalNode NAME() { return getToken(KickCParser.NAME, 0); }
		public TerminalNode ASSIGN() { return getToken(KickCParser.ASSIGN, 0); }
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public EnumMemberContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_enumMember; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterEnumMember(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitEnumMember(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitEnumMember(this);
			else return visitor.visitChildren(this);
		}
	}

	public final EnumMemberContext enumMember() throws RecognitionException {
		EnumMemberContext _localctx = new EnumMemberContext(_ctx, getState());
		enterRule(_localctx, 42, RULE_enumMember);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(315);
			match(NAME);
			setState(318);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,29,_ctx) ) {
			case 1:
				{
				setState(316);
				match(ASSIGN);
				setState(317);
				expr(0);
				}
				break;
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class DeclFunctionContext extends ParserRuleContext {
		public DeclTypeContext declType() {
			return getRuleContext(DeclTypeContext.class,0);
		}
		public TerminalNode NAME() { return getToken(KickCParser.NAME, 0); }
		public TerminalNode PAR_BEGIN() { return getToken(KickCParser.PAR_BEGIN, 0); }
		public TerminalNode PAR_END() { return getToken(KickCParser.PAR_END, 0); }
		public DeclFunctionBodyContext declFunctionBody() {
			return getRuleContext(DeclFunctionBodyContext.class,0);
		}
		public TerminalNode SEMICOLON() { return getToken(KickCParser.SEMICOLON, 0); }
		public List<DeclPointerContext> declPointer() {
			return getRuleContexts(DeclPointerContext.class);
		}
		public DeclPointerContext declPointer(int i) {
			return getRuleContext(DeclPointerContext.class,i);
		}
		public ParameterListDeclContext parameterListDecl() {
			return getRuleContext(ParameterListDeclContext.class,0);
		}
		public DeclFunctionContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_declFunction; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterDeclFunction(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitDeclFunction(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitDeclFunction(this);
			else return visitor.visitChildren(this);
		}
	}

	public final DeclFunctionContext declFunction() throws RecognitionException {
		DeclFunctionContext _localctx = new DeclFunctionContext(_ctx, getState());
		enterRule(_localctx, 44, RULE_declFunction);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(320);
			declType();
			setState(324);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==ASTERISK) {
				{
				{
				setState(321);
				declPointer();
				}
				}
				setState(326);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(327);
			match(NAME);
			setState(328);
			match(PAR_BEGIN);
			setState(330);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << TYPEDEFNAME) | (1L << PAR_BEGIN) | (1L << PARAM_LIST) | (1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << INLINE) | (1L << VOLATILE) | (1L << STATIC) | (1L << INTERRUPT) | (1L << REGISTER) | (1L << LOCAL_RESERVE) | (1L << ADDRESS) | (1L << ADDRESS_ZEROPAGE) | (1L << ADDRESS_MAINMEM) | (1L << FORM_SSA))) != 0) || ((((_la - 64)) & ~0x3f) == 0 && ((1L << (_la - 64)) & ((1L << (FORM_MA - 64)) | (1L << (INTRINSIC - 64)) | (1L << (CALLINGCONVENTION - 64)) | (1L << (STRUCT - 64)) | (1L << (ENUM - 64)) | (1L << (SIGNEDNESS - 64)) | (1L << (SIMPLETYPE - 64)))) != 0)) {
				{
				setState(329);
				parameterListDecl();
				}
			}

			setState(332);
			match(PAR_END);
			setState(335);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case CURLY_BEGIN:
				{
				setState(333);
				declFunctionBody();
				}
				break;
			case SEMICOLON:
				{
				setState(334);
				match(SEMICOLON);
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class DeclFunctionBodyContext extends ParserRuleContext {
		public TerminalNode CURLY_BEGIN() { return getToken(KickCParser.CURLY_BEGIN, 0); }
		public TerminalNode CURLY_END() { return getToken(KickCParser.CURLY_END, 0); }
		public StmtSeqContext stmtSeq() {
			return getRuleContext(StmtSeqContext.class,0);
		}
		public DeclFunctionBodyContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_declFunctionBody; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterDeclFunctionBody(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitDeclFunctionBody(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitDeclFunctionBody(this);
			else return visitor.visitChildren(this);
		}
	}

	public final DeclFunctionBodyContext declFunctionBody() throws RecognitionException {
		DeclFunctionBodyContext _localctx = new DeclFunctionBodyContext(_ctx, getState());
		enterRule(_localctx, 46, RULE_declFunctionBody);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(337);
			match(CURLY_BEGIN);
			setState(339);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << TYPEDEFNAME) | (1L << CURLY_BEGIN) | (1L << PAR_BEGIN) | (1L << PLUS) | (1L << MINUS) | (1L << ASTERISK) | (1L << INC) | (1L << DEC) | (1L << AND) | (1L << BIT_NOT) | (1L << LESS_THAN) | (1L << GREATER_THAN) | (1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << INLINE) | (1L << VOLATILE) | (1L << STATIC) | (1L << INTERRUPT) | (1L << REGISTER) | (1L << LOCAL_RESERVE) | (1L << ADDRESS) | (1L << ADDRESS_ZEROPAGE) | (1L << ADDRESS_MAINMEM) | (1L << FORM_SSA))) != 0) || ((((_la - 64)) & ~0x3f) == 0 && ((1L << (_la - 64)) & ((1L << (FORM_MA - 64)) | (1L << (INTRINSIC - 64)) | (1L << (CALLINGCONVENTION - 64)) | (1L << (IF - 64)) | (1L << (WHILE - 64)) | (1L << (DO - 64)) | (1L << (FOR - 64)) | (1L << (SWITCH - 64)) | (1L << (RETURN - 64)) | (1L << (BREAK - 64)) | (1L << (CONTINUE - 64)) | (1L << (ASM - 64)) | (1L << (STRUCT - 64)) | (1L << (ENUM - 64)) | (1L << (SIZEOF - 64)) | (1L << (TYPEID - 64)) | (1L << (DEFINED - 64)) | (1L << (KICKASM - 64)) | (1L << (LOGIC_NOT - 64)) | (1L << (SIGNEDNESS - 64)) | (1L << (SIMPLETYPE - 64)) | (1L << (BOOLEAN - 64)) | (1L << (NUMBER - 64)) | (1L << (NAME - 64)) | (1L << (STRING - 64)) | (1L << (CHAR - 64)))) != 0)) {
				{
				setState(338);
				stmtSeq();
				}
			}

			setState(341);
			match(CURLY_END);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ParameterListDeclContext extends ParserRuleContext {
		public List<ParameterDeclContext> parameterDecl() {
			return getRuleContexts(ParameterDeclContext.class);
		}
		public ParameterDeclContext parameterDecl(int i) {
			return getRuleContext(ParameterDeclContext.class,i);
		}
		public List<TerminalNode> COMMA() { return getTokens(KickCParser.COMMA); }
		public TerminalNode COMMA(int i) {
			return getToken(KickCParser.COMMA, i);
		}
		public ParameterListDeclContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_parameterListDecl; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterParameterListDecl(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitParameterListDecl(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitParameterListDecl(this);
			else return visitor.visitChildren(this);
		}
	}

	public final ParameterListDeclContext parameterListDecl() throws RecognitionException {
		ParameterListDeclContext _localctx = new ParameterListDeclContext(_ctx, getState());
		enterRule(_localctx, 48, RULE_parameterListDecl);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(343);
			parameterDecl();
			setState(348);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==COMMA) {
				{
				{
				setState(344);
				match(COMMA);
				setState(345);
				parameterDecl();
				}
				}
				setState(350);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ParameterDeclContext extends ParserRuleContext {
		public ParameterDeclContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_parameterDecl; }
	 
		public ParameterDeclContext() { }
		public void copyFrom(ParameterDeclContext ctx) {
			super.copyFrom(ctx);
		}
	}
	public static class ParameterDeclListContext extends ParameterDeclContext {
		public TerminalNode PARAM_LIST() { return getToken(KickCParser.PARAM_LIST, 0); }
		public ParameterDeclListContext(ParameterDeclContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterParameterDeclList(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitParameterDeclList(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitParameterDeclList(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class ParameterDeclTypeContext extends ParameterDeclContext {
		public DeclTypeContext declType() {
			return getRuleContext(DeclTypeContext.class,0);
		}
		public TerminalNode NAME() { return getToken(KickCParser.NAME, 0); }
		public List<DeclPointerContext> declPointer() {
			return getRuleContexts(DeclPointerContext.class);
		}
		public DeclPointerContext declPointer(int i) {
			return getRuleContext(DeclPointerContext.class,i);
		}
		public ParameterDeclTypeContext(ParameterDeclContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterParameterDeclType(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitParameterDeclType(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitParameterDeclType(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class ParameterDeclVoidContext extends ParameterDeclContext {
		public TerminalNode SIMPLETYPE() { return getToken(KickCParser.SIMPLETYPE, 0); }
		public ParameterDeclVoidContext(ParameterDeclContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterParameterDeclVoid(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitParameterDeclVoid(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitParameterDeclVoid(this);
			else return visitor.visitChildren(this);
		}
	}

	public final ParameterDeclContext parameterDecl() throws RecognitionException {
		ParameterDeclContext _localctx = new ParameterDeclContext(_ctx, getState());
		enterRule(_localctx, 50, RULE_parameterDecl);
		int _la;
		try {
			setState(362);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,36,_ctx) ) {
			case 1:
				_localctx = new ParameterDeclTypeContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(351);
				declType();
				setState(355);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (_la==ASTERISK) {
					{
					{
					setState(352);
					declPointer();
					}
					}
					setState(357);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				setState(358);
				match(NAME);
				}
				break;
			case 2:
				_localctx = new ParameterDeclVoidContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(360);
				match(SIMPLETYPE);
				}
				break;
			case 3:
				_localctx = new ParameterDeclListContext(_localctx);
				enterOuterAlt(_localctx, 3);
				{
				setState(361);
				match(PARAM_LIST);
				}
				break;
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class GlobalDirectiveContext extends ParserRuleContext {
		public GlobalDirectiveContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_globalDirective; }
	 
		public GlobalDirectiveContext() { }
		public void copyFrom(GlobalDirectiveContext ctx) {
			super.copyFrom(ctx);
		}
	}
	public static class GlobalDirectiveCpuContext extends GlobalDirectiveContext {
		public TerminalNode PAR_BEGIN() { return getToken(KickCParser.PAR_BEGIN, 0); }
		public TerminalNode NAME() { return getToken(KickCParser.NAME, 0); }
		public TerminalNode PAR_END() { return getToken(KickCParser.PAR_END, 0); }
		public TerminalNode PRAGMA() { return getToken(KickCParser.PRAGMA, 0); }
		public TerminalNode CPU() { return getToken(KickCParser.CPU, 0); }
		public GlobalDirectiveCpuContext(GlobalDirectiveContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterGlobalDirectiveCpu(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitGlobalDirectiveCpu(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitGlobalDirectiveCpu(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class GlobalDirectiveReserveContext extends GlobalDirectiveContext {
		public TerminalNode PAR_BEGIN() { return getToken(KickCParser.PAR_BEGIN, 0); }
		public List<DirectiveReserveParamContext> directiveReserveParam() {
			return getRuleContexts(DirectiveReserveParamContext.class);
		}
		public DirectiveReserveParamContext directiveReserveParam(int i) {
			return getRuleContext(DirectiveReserveParamContext.class,i);
		}
		public TerminalNode PAR_END() { return getToken(KickCParser.PAR_END, 0); }
		public TerminalNode PRAGMA() { return getToken(KickCParser.PRAGMA, 0); }
		public TerminalNode RESERVE() { return getToken(KickCParser.RESERVE, 0); }
		public List<TerminalNode> COMMA() { return getTokens(KickCParser.COMMA); }
		public TerminalNode COMMA(int i) {
			return getToken(KickCParser.COMMA, i);
		}
		public GlobalDirectiveReserveContext(GlobalDirectiveContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterGlobalDirectiveReserve(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitGlobalDirectiveReserve(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitGlobalDirectiveReserve(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class GlobalDirectiveExtensionContext extends GlobalDirectiveContext {
		public TerminalNode PAR_BEGIN() { return getToken(KickCParser.PAR_BEGIN, 0); }
		public TerminalNode STRING() { return getToken(KickCParser.STRING, 0); }
		public TerminalNode PAR_END() { return getToken(KickCParser.PAR_END, 0); }
		public TerminalNode PRAGMA() { return getToken(KickCParser.PRAGMA, 0); }
		public TerminalNode EXTENSION() { return getToken(KickCParser.EXTENSION, 0); }
		public GlobalDirectiveExtensionContext(GlobalDirectiveContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterGlobalDirectiveExtension(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitGlobalDirectiveExtension(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitGlobalDirectiveExtension(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class GlobalDirectivePcContext extends GlobalDirectiveContext {
		public TerminalNode PAR_BEGIN() { return getToken(KickCParser.PAR_BEGIN, 0); }
		public TerminalNode NUMBER() { return getToken(KickCParser.NUMBER, 0); }
		public TerminalNode PAR_END() { return getToken(KickCParser.PAR_END, 0); }
		public TerminalNode PRAGMA() { return getToken(KickCParser.PRAGMA, 0); }
		public TerminalNode PC() { return getToken(KickCParser.PC, 0); }
		public GlobalDirectivePcContext(GlobalDirectiveContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterGlobalDirectivePc(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitGlobalDirectivePc(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitGlobalDirectivePc(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class GlobalDirectiveCodeSegContext extends GlobalDirectiveContext {
		public TerminalNode PAR_BEGIN() { return getToken(KickCParser.PAR_BEGIN, 0); }
		public TerminalNode NAME() { return getToken(KickCParser.NAME, 0); }
		public TerminalNode PAR_END() { return getToken(KickCParser.PAR_END, 0); }
		public TerminalNode PRAGMA() { return getToken(KickCParser.PRAGMA, 0); }
		public TerminalNode CODESEG() { return getToken(KickCParser.CODESEG, 0); }
		public GlobalDirectiveCodeSegContext(GlobalDirectiveContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterGlobalDirectiveCodeSeg(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitGlobalDirectiveCodeSeg(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitGlobalDirectiveCodeSeg(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class GlobalDirectiveCallingContext extends GlobalDirectiveContext {
		public TerminalNode PAR_BEGIN() { return getToken(KickCParser.PAR_BEGIN, 0); }
		public TerminalNode CALLINGCONVENTION() { return getToken(KickCParser.CALLINGCONVENTION, 0); }
		public TerminalNode PAR_END() { return getToken(KickCParser.PAR_END, 0); }
		public TerminalNode PRAGMA() { return getToken(KickCParser.PRAGMA, 0); }
		public TerminalNode CALLING() { return getToken(KickCParser.CALLING, 0); }
		public GlobalDirectiveCallingContext(GlobalDirectiveContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterGlobalDirectiveCalling(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitGlobalDirectiveCalling(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitGlobalDirectiveCalling(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class GlobalDirectiveEmulatorContext extends GlobalDirectiveContext {
		public TerminalNode PAR_BEGIN() { return getToken(KickCParser.PAR_BEGIN, 0); }
		public TerminalNode STRING() { return getToken(KickCParser.STRING, 0); }
		public TerminalNode PAR_END() { return getToken(KickCParser.PAR_END, 0); }
		public TerminalNode PRAGMA() { return getToken(KickCParser.PRAGMA, 0); }
		public TerminalNode EMULATOR() { return getToken(KickCParser.EMULATOR, 0); }
		public GlobalDirectiveEmulatorContext(GlobalDirectiveContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterGlobalDirectiveEmulator(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitGlobalDirectiveEmulator(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitGlobalDirectiveEmulator(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class GlobalDirectiveLinkScriptContext extends GlobalDirectiveContext {
		public TerminalNode PAR_BEGIN() { return getToken(KickCParser.PAR_BEGIN, 0); }
		public TerminalNode STRING() { return getToken(KickCParser.STRING, 0); }
		public TerminalNode PAR_END() { return getToken(KickCParser.PAR_END, 0); }
		public TerminalNode PRAGMA() { return getToken(KickCParser.PRAGMA, 0); }
		public TerminalNode LINK() { return getToken(KickCParser.LINK, 0); }
		public GlobalDirectiveLinkScriptContext(GlobalDirectiveContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterGlobalDirectiveLinkScript(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitGlobalDirectiveLinkScript(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitGlobalDirectiveLinkScript(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class GlobalDirectiveEncodingContext extends GlobalDirectiveContext {
		public TerminalNode PAR_BEGIN() { return getToken(KickCParser.PAR_BEGIN, 0); }
		public TerminalNode NAME() { return getToken(KickCParser.NAME, 0); }
		public TerminalNode PAR_END() { return getToken(KickCParser.PAR_END, 0); }
		public TerminalNode PRAGMA() { return getToken(KickCParser.PRAGMA, 0); }
		public TerminalNode ENCODING() { return getToken(KickCParser.ENCODING, 0); }
		public GlobalDirectiveEncodingContext(GlobalDirectiveContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterGlobalDirectiveEncoding(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitGlobalDirectiveEncoding(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitGlobalDirectiveEncoding(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class GlobalDirectiveVarModelContext extends GlobalDirectiveContext {
		public TerminalNode PAR_BEGIN() { return getToken(KickCParser.PAR_BEGIN, 0); }
		public List<TerminalNode> NAME() { return getTokens(KickCParser.NAME); }
		public TerminalNode NAME(int i) {
			return getToken(KickCParser.NAME, i);
		}
		public TerminalNode PAR_END() { return getToken(KickCParser.PAR_END, 0); }
		public TerminalNode PRAGMA() { return getToken(KickCParser.PRAGMA, 0); }
		public TerminalNode VARMODEL() { return getToken(KickCParser.VARMODEL, 0); }
		public List<TerminalNode> COMMA() { return getTokens(KickCParser.COMMA); }
		public TerminalNode COMMA(int i) {
			return getToken(KickCParser.COMMA, i);
		}
		public GlobalDirectiveVarModelContext(GlobalDirectiveContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterGlobalDirectiveVarModel(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitGlobalDirectiveVarModel(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitGlobalDirectiveVarModel(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class GlobalDirectivePlatformContext extends GlobalDirectiveContext {
		public TerminalNode PAR_BEGIN() { return getToken(KickCParser.PAR_BEGIN, 0); }
		public TerminalNode NAME() { return getToken(KickCParser.NAME, 0); }
		public TerminalNode PAR_END() { return getToken(KickCParser.PAR_END, 0); }
		public TerminalNode PRAGMA() { return getToken(KickCParser.PRAGMA, 0); }
		public TerminalNode TARGET() { return getToken(KickCParser.TARGET, 0); }
		public GlobalDirectivePlatformContext(GlobalDirectiveContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterGlobalDirectivePlatform(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitGlobalDirectivePlatform(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitGlobalDirectivePlatform(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class GlobalDirectiveDataSegContext extends GlobalDirectiveContext {
		public TerminalNode PAR_BEGIN() { return getToken(KickCParser.PAR_BEGIN, 0); }
		public TerminalNode NAME() { return getToken(KickCParser.NAME, 0); }
		public TerminalNode PAR_END() { return getToken(KickCParser.PAR_END, 0); }
		public TerminalNode PRAGMA() { return getToken(KickCParser.PRAGMA, 0); }
		public TerminalNode DATASEG() { return getToken(KickCParser.DATASEG, 0); }
		public GlobalDirectiveDataSegContext(GlobalDirectiveContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterGlobalDirectiveDataSeg(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitGlobalDirectiveDataSeg(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitGlobalDirectiveDataSeg(this);
			else return visitor.visitChildren(this);
		}
	}

	public final GlobalDirectiveContext globalDirective() throws RecognitionException {
		GlobalDirectiveContext _localctx = new GlobalDirectiveContext(_ctx, getState());
		enterRule(_localctx, 52, RULE_globalDirective);
		int _la;
		try {
			setState(451);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,39,_ctx) ) {
			case 1:
				_localctx = new GlobalDirectivePlatformContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				{
				setState(364);
				match(PRAGMA);
				setState(365);
				match(TARGET);
				}
				setState(367);
				match(PAR_BEGIN);
				setState(368);
				match(NAME);
				setState(369);
				match(PAR_END);
				}
				break;
			case 2:
				_localctx = new GlobalDirectiveCpuContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				{
				setState(370);
				match(PRAGMA);
				setState(371);
				match(CPU);
				}
				setState(373);
				match(PAR_BEGIN);
				setState(374);
				match(NAME);
				setState(375);
				match(PAR_END);
				}
				break;
			case 3:
				_localctx = new GlobalDirectiveLinkScriptContext(_localctx);
				enterOuterAlt(_localctx, 3);
				{
				{
				setState(376);
				match(PRAGMA);
				setState(377);
				match(LINK);
				}
				setState(379);
				match(PAR_BEGIN);
				setState(380);
				match(STRING);
				setState(381);
				match(PAR_END);
				}
				break;
			case 4:
				_localctx = new GlobalDirectiveExtensionContext(_localctx);
				enterOuterAlt(_localctx, 4);
				{
				{
				setState(382);
				match(PRAGMA);
				setState(383);
				match(EXTENSION);
				}
				setState(385);
				match(PAR_BEGIN);
				setState(386);
				match(STRING);
				setState(387);
				match(PAR_END);
				}
				break;
			case 5:
				_localctx = new GlobalDirectiveEmulatorContext(_localctx);
				enterOuterAlt(_localctx, 5);
				{
				{
				setState(388);
				match(PRAGMA);
				setState(389);
				match(EMULATOR);
				}
				setState(391);
				match(PAR_BEGIN);
				setState(392);
				match(STRING);
				setState(393);
				match(PAR_END);
				}
				break;
			case 6:
				_localctx = new GlobalDirectiveReserveContext(_localctx);
				enterOuterAlt(_localctx, 6);
				{
				{
				setState(394);
				match(PRAGMA);
				setState(395);
				match(RESERVE);
				}
				setState(397);
				match(PAR_BEGIN);
				setState(398);
				directiveReserveParam();
				setState(403);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (_la==COMMA) {
					{
					{
					setState(399);
					match(COMMA);
					setState(400);
					directiveReserveParam();
					}
					}
					setState(405);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				setState(406);
				match(PAR_END);
				}
				break;
			case 7:
				_localctx = new GlobalDirectivePcContext(_localctx);
				enterOuterAlt(_localctx, 7);
				{
				{
				setState(408);
				match(PRAGMA);
				setState(409);
				match(PC);
				}
				setState(411);
				match(PAR_BEGIN);
				setState(412);
				match(NUMBER);
				setState(413);
				match(PAR_END);
				}
				break;
			case 8:
				_localctx = new GlobalDirectiveCodeSegContext(_localctx);
				enterOuterAlt(_localctx, 8);
				{
				{
				setState(414);
				match(PRAGMA);
				setState(415);
				match(CODESEG);
				}
				setState(417);
				match(PAR_BEGIN);
				setState(418);
				match(NAME);
				setState(419);
				match(PAR_END);
				}
				break;
			case 9:
				_localctx = new GlobalDirectiveDataSegContext(_localctx);
				enterOuterAlt(_localctx, 9);
				{
				{
				setState(420);
				match(PRAGMA);
				setState(421);
				match(DATASEG);
				}
				setState(423);
				match(PAR_BEGIN);
				setState(424);
				match(NAME);
				setState(425);
				match(PAR_END);
				}
				break;
			case 10:
				_localctx = new GlobalDirectiveEncodingContext(_localctx);
				enterOuterAlt(_localctx, 10);
				{
				{
				setState(426);
				match(PRAGMA);
				setState(427);
				match(ENCODING);
				}
				setState(429);
				match(PAR_BEGIN);
				setState(430);
				match(NAME);
				setState(431);
				match(PAR_END);
				}
				break;
			case 11:
				_localctx = new GlobalDirectiveCallingContext(_localctx);
				enterOuterAlt(_localctx, 11);
				{
				{
				setState(432);
				match(PRAGMA);
				setState(433);
				match(CALLING);
				}
				setState(435);
				match(PAR_BEGIN);
				setState(436);
				match(CALLINGCONVENTION);
				setState(437);
				match(PAR_END);
				}
				break;
			case 12:
				_localctx = new GlobalDirectiveVarModelContext(_localctx);
				enterOuterAlt(_localctx, 12);
				{
				{
				setState(438);
				match(PRAGMA);
				setState(439);
				match(VARMODEL);
				}
				setState(441);
				match(PAR_BEGIN);
				setState(442);
				match(NAME);
				setState(447);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (_la==COMMA) {
					{
					{
					setState(443);
					match(COMMA);
					setState(444);
					match(NAME);
					}
					}
					setState(449);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				setState(450);
				match(PAR_END);
				}
				break;
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class DirectiveReserveParamContext extends ParserRuleContext {
		public List<TerminalNode> NUMBER() { return getTokens(KickCParser.NUMBER); }
		public TerminalNode NUMBER(int i) {
			return getToken(KickCParser.NUMBER, i);
		}
		public TerminalNode RANGE() { return getToken(KickCParser.RANGE, 0); }
		public DirectiveReserveParamContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_directiveReserveParam; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterDirectiveReserveParam(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitDirectiveReserveParam(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitDirectiveReserveParam(this);
			else return visitor.visitChildren(this);
		}
	}

	public final DirectiveReserveParamContext directiveReserveParam() throws RecognitionException {
		DirectiveReserveParamContext _localctx = new DirectiveReserveParamContext(_ctx, getState());
		enterRule(_localctx, 54, RULE_directiveReserveParam);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(453);
			match(NUMBER);
			setState(456);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==RANGE) {
				{
				setState(454);
				match(RANGE);
				setState(455);
				match(NUMBER);
				}
			}

			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class DirectiveContext extends ParserRuleContext {
		public DirectiveContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_directive; }
	 
		public DirectiveContext() { }
		public void copyFrom(DirectiveContext ctx) {
			super.copyFrom(ctx);
		}
	}
	public static class DirectiveStaticContext extends DirectiveContext {
		public TerminalNode STATIC() { return getToken(KickCParser.STATIC, 0); }
		public DirectiveStaticContext(DirectiveContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterDirectiveStatic(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitDirectiveStatic(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitDirectiveStatic(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class DirectiveMemoryAreaZpContext extends DirectiveContext {
		public TerminalNode ADDRESS_ZEROPAGE() { return getToken(KickCParser.ADDRESS_ZEROPAGE, 0); }
		public DirectiveMemoryAreaZpContext(DirectiveContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterDirectiveMemoryAreaZp(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitDirectiveMemoryAreaZp(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitDirectiveMemoryAreaZp(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class DirectiveMemoryAreaMainContext extends DirectiveContext {
		public TerminalNode ADDRESS_MAINMEM() { return getToken(KickCParser.ADDRESS_MAINMEM, 0); }
		public DirectiveMemoryAreaMainContext(DirectiveContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterDirectiveMemoryAreaMain(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitDirectiveMemoryAreaMain(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitDirectiveMemoryAreaMain(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class DirectiveConstContext extends DirectiveContext {
		public TerminalNode CONST() { return getToken(KickCParser.CONST, 0); }
		public DirectiveConstContext(DirectiveContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterDirectiveConst(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitDirectiveConst(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitDirectiveConst(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class DirectiveAlignContext extends DirectiveContext {
		public TerminalNode ALIGN() { return getToken(KickCParser.ALIGN, 0); }
		public TerminalNode PAR_BEGIN() { return getToken(KickCParser.PAR_BEGIN, 0); }
		public TerminalNode NUMBER() { return getToken(KickCParser.NUMBER, 0); }
		public TerminalNode PAR_END() { return getToken(KickCParser.PAR_END, 0); }
		public DirectiveAlignContext(DirectiveContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterDirectiveAlign(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitDirectiveAlign(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitDirectiveAlign(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class DirectiveVolatileContext extends DirectiveContext {
		public TerminalNode VOLATILE() { return getToken(KickCParser.VOLATILE, 0); }
		public DirectiveVolatileContext(DirectiveContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterDirectiveVolatile(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitDirectiveVolatile(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitDirectiveVolatile(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class DirectiveFormMaContext extends DirectiveContext {
		public TerminalNode FORM_MA() { return getToken(KickCParser.FORM_MA, 0); }
		public DirectiveFormMaContext(DirectiveContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterDirectiveFormMa(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitDirectiveFormMa(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitDirectiveFormMa(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class DirectiveCallingConventionContext extends DirectiveContext {
		public TerminalNode CALLINGCONVENTION() { return getToken(KickCParser.CALLINGCONVENTION, 0); }
		public DirectiveCallingConventionContext(DirectiveContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterDirectiveCallingConvention(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitDirectiveCallingConvention(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitDirectiveCallingConvention(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class DirectiveInlineContext extends DirectiveContext {
		public TerminalNode INLINE() { return getToken(KickCParser.INLINE, 0); }
		public DirectiveInlineContext(DirectiveContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterDirectiveInline(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitDirectiveInline(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitDirectiveInline(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class DirectiveInterruptContext extends DirectiveContext {
		public TerminalNode INTERRUPT() { return getToken(KickCParser.INTERRUPT, 0); }
		public TerminalNode PAR_BEGIN() { return getToken(KickCParser.PAR_BEGIN, 0); }
		public TerminalNode NAME() { return getToken(KickCParser.NAME, 0); }
		public TerminalNode PAR_END() { return getToken(KickCParser.PAR_END, 0); }
		public DirectiveInterruptContext(DirectiveContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterDirectiveInterrupt(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitDirectiveInterrupt(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitDirectiveInterrupt(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class DirectiveFormSsaContext extends DirectiveContext {
		public TerminalNode FORM_SSA() { return getToken(KickCParser.FORM_SSA, 0); }
		public DirectiveFormSsaContext(DirectiveContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterDirectiveFormSsa(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitDirectiveFormSsa(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitDirectiveFormSsa(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class DirectiveExportContext extends DirectiveContext {
		public TerminalNode EXPORT() { return getToken(KickCParser.EXPORT, 0); }
		public DirectiveExportContext(DirectiveContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterDirectiveExport(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitDirectiveExport(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitDirectiveExport(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class DirectiveIntrinsicContext extends DirectiveContext {
		public TerminalNode INTRINSIC() { return getToken(KickCParser.INTRINSIC, 0); }
		public DirectiveIntrinsicContext(DirectiveContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterDirectiveIntrinsic(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitDirectiveIntrinsic(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitDirectiveIntrinsic(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class DirectiveExternContext extends DirectiveContext {
		public TerminalNode EXTERN() { return getToken(KickCParser.EXTERN, 0); }
		public DirectiveExternContext(DirectiveContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterDirectiveExtern(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitDirectiveExtern(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitDirectiveExtern(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class DirectiveReserveZpContext extends DirectiveContext {
		public TerminalNode LOCAL_RESERVE() { return getToken(KickCParser.LOCAL_RESERVE, 0); }
		public TerminalNode PAR_BEGIN() { return getToken(KickCParser.PAR_BEGIN, 0); }
		public List<DirectiveReserveParamContext> directiveReserveParam() {
			return getRuleContexts(DirectiveReserveParamContext.class);
		}
		public DirectiveReserveParamContext directiveReserveParam(int i) {
			return getRuleContext(DirectiveReserveParamContext.class,i);
		}
		public TerminalNode PAR_END() { return getToken(KickCParser.PAR_END, 0); }
		public List<TerminalNode> COMMA() { return getTokens(KickCParser.COMMA); }
		public TerminalNode COMMA(int i) {
			return getToken(KickCParser.COMMA, i);
		}
		public DirectiveReserveZpContext(DirectiveContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterDirectiveReserveZp(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitDirectiveReserveZp(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitDirectiveReserveZp(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class DirectiveRegisterContext extends DirectiveContext {
		public TerminalNode REGISTER() { return getToken(KickCParser.REGISTER, 0); }
		public TerminalNode PAR_BEGIN() { return getToken(KickCParser.PAR_BEGIN, 0); }
		public TerminalNode PAR_END() { return getToken(KickCParser.PAR_END, 0); }
		public TerminalNode NAME() { return getToken(KickCParser.NAME, 0); }
		public DirectiveRegisterContext(DirectiveContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterDirectiveRegister(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitDirectiveRegister(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitDirectiveRegister(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class DirectiveMemoryAreaAddressContext extends DirectiveContext {
		public TerminalNode ADDRESS() { return getToken(KickCParser.ADDRESS, 0); }
		public TerminalNode PAR_BEGIN() { return getToken(KickCParser.PAR_BEGIN, 0); }
		public TerminalNode PAR_END() { return getToken(KickCParser.PAR_END, 0); }
		public TerminalNode NUMBER() { return getToken(KickCParser.NUMBER, 0); }
		public DirectiveMemoryAreaAddressContext(DirectiveContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterDirectiveMemoryAreaAddress(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitDirectiveMemoryAreaAddress(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitDirectiveMemoryAreaAddress(this);
			else return visitor.visitChildren(this);
		}
	}

	public final DirectiveContext directive() throws RecognitionException {
		DirectiveContext _localctx = new DirectiveContext(_ctx, getState());
		enterRule(_localctx, 56, RULE_directive);
		int _la;
		try {
			setState(502);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case CONST:
				_localctx = new DirectiveConstContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(458);
				match(CONST);
				}
				break;
			case ALIGN:
				_localctx = new DirectiveAlignContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(459);
				match(ALIGN);
				setState(460);
				match(PAR_BEGIN);
				setState(461);
				match(NUMBER);
				setState(462);
				match(PAR_END);
				}
				break;
			case REGISTER:
				_localctx = new DirectiveRegisterContext(_localctx);
				enterOuterAlt(_localctx, 3);
				{
				setState(463);
				match(REGISTER);
				setState(467);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,41,_ctx) ) {
				case 1:
					{
					setState(464);
					match(PAR_BEGIN);
					{
					setState(465);
					match(NAME);
					}
					setState(466);
					match(PAR_END);
					}
					break;
				}
				}
				break;
			case ADDRESS_ZEROPAGE:
				_localctx = new DirectiveMemoryAreaZpContext(_localctx);
				enterOuterAlt(_localctx, 4);
				{
				setState(469);
				match(ADDRESS_ZEROPAGE);
				}
				break;
			case ADDRESS_MAINMEM:
				_localctx = new DirectiveMemoryAreaMainContext(_localctx);
				enterOuterAlt(_localctx, 5);
				{
				setState(470);
				match(ADDRESS_MAINMEM);
				}
				break;
			case ADDRESS:
				_localctx = new DirectiveMemoryAreaAddressContext(_localctx);
				enterOuterAlt(_localctx, 6);
				{
				setState(471);
				match(ADDRESS);
				setState(472);
				match(PAR_BEGIN);
				{
				setState(473);
				match(NUMBER);
				}
				setState(474);
				match(PAR_END);
				}
				break;
			case VOLATILE:
				_localctx = new DirectiveVolatileContext(_localctx);
				enterOuterAlt(_localctx, 7);
				{
				setState(475);
				match(VOLATILE);
				}
				break;
			case STATIC:
				_localctx = new DirectiveStaticContext(_localctx);
				enterOuterAlt(_localctx, 8);
				{
				setState(476);
				match(STATIC);
				}
				break;
			case FORM_SSA:
				_localctx = new DirectiveFormSsaContext(_localctx);
				enterOuterAlt(_localctx, 9);
				{
				setState(477);
				match(FORM_SSA);
				}
				break;
			case FORM_MA:
				_localctx = new DirectiveFormMaContext(_localctx);
				enterOuterAlt(_localctx, 10);
				{
				setState(478);
				match(FORM_MA);
				}
				break;
			case EXTERN:
				_localctx = new DirectiveExternContext(_localctx);
				enterOuterAlt(_localctx, 11);
				{
				setState(479);
				match(EXTERN);
				}
				break;
			case EXPORT:
				_localctx = new DirectiveExportContext(_localctx);
				enterOuterAlt(_localctx, 12);
				{
				setState(480);
				match(EXPORT);
				}
				break;
			case INLINE:
				_localctx = new DirectiveInlineContext(_localctx);
				enterOuterAlt(_localctx, 13);
				{
				setState(481);
				match(INLINE);
				}
				break;
			case INTRINSIC:
				_localctx = new DirectiveIntrinsicContext(_localctx);
				enterOuterAlt(_localctx, 14);
				{
				setState(482);
				match(INTRINSIC);
				}
				break;
			case INTERRUPT:
				_localctx = new DirectiveInterruptContext(_localctx);
				enterOuterAlt(_localctx, 15);
				{
				setState(483);
				match(INTERRUPT);
				setState(487);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,42,_ctx) ) {
				case 1:
					{
					setState(484);
					match(PAR_BEGIN);
					setState(485);
					match(NAME);
					setState(486);
					match(PAR_END);
					}
					break;
				}
				}
				break;
			case LOCAL_RESERVE:
				_localctx = new DirectiveReserveZpContext(_localctx);
				enterOuterAlt(_localctx, 16);
				{
				setState(489);
				match(LOCAL_RESERVE);
				setState(490);
				match(PAR_BEGIN);
				setState(491);
				directiveReserveParam();
				setState(496);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (_la==COMMA) {
					{
					{
					setState(492);
					match(COMMA);
					setState(493);
					directiveReserveParam();
					}
					}
					setState(498);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				setState(499);
				match(PAR_END);
				}
				break;
			case CALLINGCONVENTION:
				_localctx = new DirectiveCallingConventionContext(_localctx);
				enterOuterAlt(_localctx, 17);
				{
				setState(501);
				match(CALLINGCONVENTION);
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class StmtSeqContext extends ParserRuleContext {
		public List<StmtContext> stmt() {
			return getRuleContexts(StmtContext.class);
		}
		public StmtContext stmt(int i) {
			return getRuleContext(StmtContext.class,i);
		}
		public StmtSeqContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_stmtSeq; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterStmtSeq(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitStmtSeq(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitStmtSeq(this);
			else return visitor.visitChildren(this);
		}
	}

	public final StmtSeqContext stmtSeq() throws RecognitionException {
		StmtSeqContext _localctx = new StmtSeqContext(_ctx, getState());
		enterRule(_localctx, 58, RULE_stmtSeq);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(505); 
			_errHandler.sync(this);
			_la = _input.LA(1);
			do {
				{
				{
				setState(504);
				stmt();
				}
				}
				setState(507); 
				_errHandler.sync(this);
				_la = _input.LA(1);
			} while ( (((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << TYPEDEFNAME) | (1L << CURLY_BEGIN) | (1L << PAR_BEGIN) | (1L << PLUS) | (1L << MINUS) | (1L << ASTERISK) | (1L << INC) | (1L << DEC) | (1L << AND) | (1L << BIT_NOT) | (1L << LESS_THAN) | (1L << GREATER_THAN) | (1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << INLINE) | (1L << VOLATILE) | (1L << STATIC) | (1L << INTERRUPT) | (1L << REGISTER) | (1L << LOCAL_RESERVE) | (1L << ADDRESS) | (1L << ADDRESS_ZEROPAGE) | (1L << ADDRESS_MAINMEM) | (1L << FORM_SSA))) != 0) || ((((_la - 64)) & ~0x3f) == 0 && ((1L << (_la - 64)) & ((1L << (FORM_MA - 64)) | (1L << (INTRINSIC - 64)) | (1L << (CALLINGCONVENTION - 64)) | (1L << (IF - 64)) | (1L << (WHILE - 64)) | (1L << (DO - 64)) | (1L << (FOR - 64)) | (1L << (SWITCH - 64)) | (1L << (RETURN - 64)) | (1L << (BREAK - 64)) | (1L << (CONTINUE - 64)) | (1L << (ASM - 64)) | (1L << (STRUCT - 64)) | (1L << (ENUM - 64)) | (1L << (SIZEOF - 64)) | (1L << (TYPEID - 64)) | (1L << (DEFINED - 64)) | (1L << (KICKASM - 64)) | (1L << (LOGIC_NOT - 64)) | (1L << (SIGNEDNESS - 64)) | (1L << (SIMPLETYPE - 64)) | (1L << (BOOLEAN - 64)) | (1L << (NUMBER - 64)) | (1L << (NAME - 64)) | (1L << (STRING - 64)) | (1L << (CHAR - 64)))) != 0) );
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class StmtContext extends ParserRuleContext {
		public StmtContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_stmt; }
	 
		public StmtContext() { }
		public void copyFrom(StmtContext ctx) {
			super.copyFrom(ctx);
		}
	}
	public static class StmtDeclVarContext extends StmtContext {
		public DeclVariablesContext declVariables() {
			return getRuleContext(DeclVariablesContext.class,0);
		}
		public TerminalNode SEMICOLON() { return getToken(KickCParser.SEMICOLON, 0); }
		public StmtDeclVarContext(StmtContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterStmtDeclVar(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitStmtDeclVar(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitStmtDeclVar(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class StmtBreakContext extends StmtContext {
		public TerminalNode BREAK() { return getToken(KickCParser.BREAK, 0); }
		public TerminalNode SEMICOLON() { return getToken(KickCParser.SEMICOLON, 0); }
		public StmtBreakContext(StmtContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterStmtBreak(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitStmtBreak(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitStmtBreak(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class StmtDeclKasmContext extends StmtContext {
		public DeclKasmContext declKasm() {
			return getRuleContext(DeclKasmContext.class,0);
		}
		public StmtDeclKasmContext(StmtContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterStmtDeclKasm(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitStmtDeclKasm(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitStmtDeclKasm(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class StmtExprContext extends StmtContext {
		public CommaExprContext commaExpr() {
			return getRuleContext(CommaExprContext.class,0);
		}
		public TerminalNode SEMICOLON() { return getToken(KickCParser.SEMICOLON, 0); }
		public StmtExprContext(StmtContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterStmtExpr(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitStmtExpr(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitStmtExpr(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class StmtDoWhileContext extends StmtContext {
		public TerminalNode DO() { return getToken(KickCParser.DO, 0); }
		public StmtContext stmt() {
			return getRuleContext(StmtContext.class,0);
		}
		public TerminalNode WHILE() { return getToken(KickCParser.WHILE, 0); }
		public TerminalNode PAR_BEGIN() { return getToken(KickCParser.PAR_BEGIN, 0); }
		public CommaExprContext commaExpr() {
			return getRuleContext(CommaExprContext.class,0);
		}
		public TerminalNode PAR_END() { return getToken(KickCParser.PAR_END, 0); }
		public TerminalNode SEMICOLON() { return getToken(KickCParser.SEMICOLON, 0); }
		public List<DirectiveContext> directive() {
			return getRuleContexts(DirectiveContext.class);
		}
		public DirectiveContext directive(int i) {
			return getRuleContext(DirectiveContext.class,i);
		}
		public StmtDoWhileContext(StmtContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterStmtDoWhile(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitStmtDoWhile(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitStmtDoWhile(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class StmtAsmContext extends StmtContext {
		public TerminalNode ASM() { return getToken(KickCParser.ASM, 0); }
		public TerminalNode CURLY_BEGIN() { return getToken(KickCParser.CURLY_BEGIN, 0); }
		public AsmLinesContext asmLines() {
			return getRuleContext(AsmLinesContext.class,0);
		}
		public TerminalNode ASM_CURLY_END() { return getToken(KickCParser.ASM_CURLY_END, 0); }
		public AsmDirectivesContext asmDirectives() {
			return getRuleContext(AsmDirectivesContext.class,0);
		}
		public StmtAsmContext(StmtContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterStmtAsm(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitStmtAsm(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitStmtAsm(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class StmtContinueContext extends StmtContext {
		public TerminalNode CONTINUE() { return getToken(KickCParser.CONTINUE, 0); }
		public TerminalNode SEMICOLON() { return getToken(KickCParser.SEMICOLON, 0); }
		public StmtContinueContext(StmtContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterStmtContinue(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitStmtContinue(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitStmtContinue(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class StmtSwitchContext extends StmtContext {
		public TerminalNode SWITCH() { return getToken(KickCParser.SWITCH, 0); }
		public TerminalNode PAR_BEGIN() { return getToken(KickCParser.PAR_BEGIN, 0); }
		public CommaExprContext commaExpr() {
			return getRuleContext(CommaExprContext.class,0);
		}
		public TerminalNode PAR_END() { return getToken(KickCParser.PAR_END, 0); }
		public TerminalNode CURLY_BEGIN() { return getToken(KickCParser.CURLY_BEGIN, 0); }
		public SwitchCasesContext switchCases() {
			return getRuleContext(SwitchCasesContext.class,0);
		}
		public TerminalNode CURLY_END() { return getToken(KickCParser.CURLY_END, 0); }
		public StmtSwitchContext(StmtContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterStmtSwitch(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitStmtSwitch(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitStmtSwitch(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class StmtBlockContext extends StmtContext {
		public TerminalNode CURLY_BEGIN() { return getToken(KickCParser.CURLY_BEGIN, 0); }
		public TerminalNode CURLY_END() { return getToken(KickCParser.CURLY_END, 0); }
		public StmtSeqContext stmtSeq() {
			return getRuleContext(StmtSeqContext.class,0);
		}
		public StmtBlockContext(StmtContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterStmtBlock(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitStmtBlock(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitStmtBlock(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class StmtWhileContext extends StmtContext {
		public TerminalNode WHILE() { return getToken(KickCParser.WHILE, 0); }
		public TerminalNode PAR_BEGIN() { return getToken(KickCParser.PAR_BEGIN, 0); }
		public CommaExprContext commaExpr() {
			return getRuleContext(CommaExprContext.class,0);
		}
		public TerminalNode PAR_END() { return getToken(KickCParser.PAR_END, 0); }
		public StmtContext stmt() {
			return getRuleContext(StmtContext.class,0);
		}
		public List<DirectiveContext> directive() {
			return getRuleContexts(DirectiveContext.class);
		}
		public DirectiveContext directive(int i) {
			return getRuleContext(DirectiveContext.class,i);
		}
		public StmtWhileContext(StmtContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterStmtWhile(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitStmtWhile(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitStmtWhile(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class StmtForContext extends StmtContext {
		public TerminalNode FOR() { return getToken(KickCParser.FOR, 0); }
		public TerminalNode PAR_BEGIN() { return getToken(KickCParser.PAR_BEGIN, 0); }
		public ForLoopContext forLoop() {
			return getRuleContext(ForLoopContext.class,0);
		}
		public TerminalNode PAR_END() { return getToken(KickCParser.PAR_END, 0); }
		public StmtContext stmt() {
			return getRuleContext(StmtContext.class,0);
		}
		public List<DirectiveContext> directive() {
			return getRuleContexts(DirectiveContext.class);
		}
		public DirectiveContext directive(int i) {
			return getRuleContext(DirectiveContext.class,i);
		}
		public StmtForContext(StmtContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterStmtFor(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitStmtFor(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitStmtFor(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class StmtIfElseContext extends StmtContext {
		public TerminalNode IF() { return getToken(KickCParser.IF, 0); }
		public TerminalNode PAR_BEGIN() { return getToken(KickCParser.PAR_BEGIN, 0); }
		public CommaExprContext commaExpr() {
			return getRuleContext(CommaExprContext.class,0);
		}
		public TerminalNode PAR_END() { return getToken(KickCParser.PAR_END, 0); }
		public List<StmtContext> stmt() {
			return getRuleContexts(StmtContext.class);
		}
		public StmtContext stmt(int i) {
			return getRuleContext(StmtContext.class,i);
		}
		public TerminalNode ELSE() { return getToken(KickCParser.ELSE, 0); }
		public StmtIfElseContext(StmtContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterStmtIfElse(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitStmtIfElse(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitStmtIfElse(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class StmtReturnContext extends StmtContext {
		public TerminalNode RETURN() { return getToken(KickCParser.RETURN, 0); }
		public TerminalNode SEMICOLON() { return getToken(KickCParser.SEMICOLON, 0); }
		public CommaExprContext commaExpr() {
			return getRuleContext(CommaExprContext.class,0);
		}
		public StmtReturnContext(StmtContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterStmtReturn(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitStmtReturn(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitStmtReturn(this);
			else return visitor.visitChildren(this);
		}
	}

	public final StmtContext stmt() throws RecognitionException {
		StmtContext _localctx = new StmtContext(_ctx, getState());
		enterRule(_localctx, 60, RULE_stmt);
		int _la;
		try {
			setState(593);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,53,_ctx) ) {
			case 1:
				_localctx = new StmtDeclVarContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(509);
				declVariables();
				setState(510);
				match(SEMICOLON);
				}
				break;
			case 2:
				_localctx = new StmtBlockContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(512);
				match(CURLY_BEGIN);
				setState(514);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << TYPEDEFNAME) | (1L << CURLY_BEGIN) | (1L << PAR_BEGIN) | (1L << PLUS) | (1L << MINUS) | (1L << ASTERISK) | (1L << INC) | (1L << DEC) | (1L << AND) | (1L << BIT_NOT) | (1L << LESS_THAN) | (1L << GREATER_THAN) | (1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << INLINE) | (1L << VOLATILE) | (1L << STATIC) | (1L << INTERRUPT) | (1L << REGISTER) | (1L << LOCAL_RESERVE) | (1L << ADDRESS) | (1L << ADDRESS_ZEROPAGE) | (1L << ADDRESS_MAINMEM) | (1L << FORM_SSA))) != 0) || ((((_la - 64)) & ~0x3f) == 0 && ((1L << (_la - 64)) & ((1L << (FORM_MA - 64)) | (1L << (INTRINSIC - 64)) | (1L << (CALLINGCONVENTION - 64)) | (1L << (IF - 64)) | (1L << (WHILE - 64)) | (1L << (DO - 64)) | (1L << (FOR - 64)) | (1L << (SWITCH - 64)) | (1L << (RETURN - 64)) | (1L << (BREAK - 64)) | (1L << (CONTINUE - 64)) | (1L << (ASM - 64)) | (1L << (STRUCT - 64)) | (1L << (ENUM - 64)) | (1L << (SIZEOF - 64)) | (1L << (TYPEID - 64)) | (1L << (DEFINED - 64)) | (1L << (KICKASM - 64)) | (1L << (LOGIC_NOT - 64)) | (1L << (SIGNEDNESS - 64)) | (1L << (SIMPLETYPE - 64)) | (1L << (BOOLEAN - 64)) | (1L << (NUMBER - 64)) | (1L << (NAME - 64)) | (1L << (STRING - 64)) | (1L << (CHAR - 64)))) != 0)) {
					{
					setState(513);
					stmtSeq();
					}
				}

				setState(516);
				match(CURLY_END);
				}
				break;
			case 3:
				_localctx = new StmtExprContext(_localctx);
				enterOuterAlt(_localctx, 3);
				{
				setState(517);
				commaExpr(0);
				setState(518);
				match(SEMICOLON);
				}
				break;
			case 4:
				_localctx = new StmtIfElseContext(_localctx);
				enterOuterAlt(_localctx, 4);
				{
				setState(520);
				match(IF);
				setState(521);
				match(PAR_BEGIN);
				setState(522);
				commaExpr(0);
				setState(523);
				match(PAR_END);
				setState(524);
				stmt();
				setState(527);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,47,_ctx) ) {
				case 1:
					{
					setState(525);
					match(ELSE);
					setState(526);
					stmt();
					}
					break;
				}
				}
				break;
			case 5:
				_localctx = new StmtWhileContext(_localctx);
				enterOuterAlt(_localctx, 5);
				{
				setState(532);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (((((_la - 50)) & ~0x3f) == 0 && ((1L << (_la - 50)) & ((1L << (CONST - 50)) | (1L << (EXTERN - 50)) | (1L << (EXPORT - 50)) | (1L << (ALIGN - 50)) | (1L << (INLINE - 50)) | (1L << (VOLATILE - 50)) | (1L << (STATIC - 50)) | (1L << (INTERRUPT - 50)) | (1L << (REGISTER - 50)) | (1L << (LOCAL_RESERVE - 50)) | (1L << (ADDRESS - 50)) | (1L << (ADDRESS_ZEROPAGE - 50)) | (1L << (ADDRESS_MAINMEM - 50)) | (1L << (FORM_SSA - 50)) | (1L << (FORM_MA - 50)) | (1L << (INTRINSIC - 50)) | (1L << (CALLINGCONVENTION - 50)))) != 0)) {
					{
					{
					setState(529);
					directive();
					}
					}
					setState(534);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				setState(535);
				match(WHILE);
				setState(536);
				match(PAR_BEGIN);
				setState(537);
				commaExpr(0);
				setState(538);
				match(PAR_END);
				setState(539);
				stmt();
				}
				break;
			case 6:
				_localctx = new StmtDoWhileContext(_localctx);
				enterOuterAlt(_localctx, 6);
				{
				setState(544);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (((((_la - 50)) & ~0x3f) == 0 && ((1L << (_la - 50)) & ((1L << (CONST - 50)) | (1L << (EXTERN - 50)) | (1L << (EXPORT - 50)) | (1L << (ALIGN - 50)) | (1L << (INLINE - 50)) | (1L << (VOLATILE - 50)) | (1L << (STATIC - 50)) | (1L << (INTERRUPT - 50)) | (1L << (REGISTER - 50)) | (1L << (LOCAL_RESERVE - 50)) | (1L << (ADDRESS - 50)) | (1L << (ADDRESS_ZEROPAGE - 50)) | (1L << (ADDRESS_MAINMEM - 50)) | (1L << (FORM_SSA - 50)) | (1L << (FORM_MA - 50)) | (1L << (INTRINSIC - 50)) | (1L << (CALLINGCONVENTION - 50)))) != 0)) {
					{
					{
					setState(541);
					directive();
					}
					}
					setState(546);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				setState(547);
				match(DO);
				setState(548);
				stmt();
				setState(549);
				match(WHILE);
				setState(550);
				match(PAR_BEGIN);
				setState(551);
				commaExpr(0);
				setState(552);
				match(PAR_END);
				setState(553);
				match(SEMICOLON);
				}
				break;
			case 7:
				_localctx = new StmtForContext(_localctx);
				enterOuterAlt(_localctx, 7);
				{
				setState(558);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (((((_la - 50)) & ~0x3f) == 0 && ((1L << (_la - 50)) & ((1L << (CONST - 50)) | (1L << (EXTERN - 50)) | (1L << (EXPORT - 50)) | (1L << (ALIGN - 50)) | (1L << (INLINE - 50)) | (1L << (VOLATILE - 50)) | (1L << (STATIC - 50)) | (1L << (INTERRUPT - 50)) | (1L << (REGISTER - 50)) | (1L << (LOCAL_RESERVE - 50)) | (1L << (ADDRESS - 50)) | (1L << (ADDRESS_ZEROPAGE - 50)) | (1L << (ADDRESS_MAINMEM - 50)) | (1L << (FORM_SSA - 50)) | (1L << (FORM_MA - 50)) | (1L << (INTRINSIC - 50)) | (1L << (CALLINGCONVENTION - 50)))) != 0)) {
					{
					{
					setState(555);
					directive();
					}
					}
					setState(560);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				setState(561);
				match(FOR);
				setState(562);
				match(PAR_BEGIN);
				setState(563);
				forLoop();
				setState(564);
				match(PAR_END);
				setState(565);
				stmt();
				}
				break;
			case 8:
				_localctx = new StmtSwitchContext(_localctx);
				enterOuterAlt(_localctx, 8);
				{
				setState(567);
				match(SWITCH);
				setState(568);
				match(PAR_BEGIN);
				setState(569);
				commaExpr(0);
				setState(570);
				match(PAR_END);
				setState(571);
				match(CURLY_BEGIN);
				setState(572);
				switchCases();
				setState(573);
				match(CURLY_END);
				}
				break;
			case 9:
				_localctx = new StmtReturnContext(_localctx);
				enterOuterAlt(_localctx, 9);
				{
				setState(575);
				match(RETURN);
				setState(577);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << CURLY_BEGIN) | (1L << PAR_BEGIN) | (1L << PLUS) | (1L << MINUS) | (1L << ASTERISK) | (1L << INC) | (1L << DEC) | (1L << AND) | (1L << BIT_NOT) | (1L << LESS_THAN) | (1L << GREATER_THAN))) != 0) || ((((_la - 83)) & ~0x3f) == 0 && ((1L << (_la - 83)) & ((1L << (SIZEOF - 83)) | (1L << (TYPEID - 83)) | (1L << (DEFINED - 83)) | (1L << (LOGIC_NOT - 83)) | (1L << (BOOLEAN - 83)) | (1L << (NUMBER - 83)) | (1L << (NAME - 83)) | (1L << (STRING - 83)) | (1L << (CHAR - 83)))) != 0)) {
					{
					setState(576);
					commaExpr(0);
					}
				}

				setState(579);
				match(SEMICOLON);
				}
				break;
			case 10:
				_localctx = new StmtBreakContext(_localctx);
				enterOuterAlt(_localctx, 10);
				{
				setState(580);
				match(BREAK);
				setState(581);
				match(SEMICOLON);
				}
				break;
			case 11:
				_localctx = new StmtContinueContext(_localctx);
				enterOuterAlt(_localctx, 11);
				{
				setState(582);
				match(CONTINUE);
				setState(583);
				match(SEMICOLON);
				}
				break;
			case 12:
				_localctx = new StmtAsmContext(_localctx);
				enterOuterAlt(_localctx, 12);
				{
				setState(584);
				match(ASM);
				setState(586);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if (_la==PAR_BEGIN) {
					{
					setState(585);
					asmDirectives();
					}
				}

				setState(588);
				match(CURLY_BEGIN);
				setState(589);
				asmLines();
				setState(590);
				match(ASM_CURLY_END);
				}
				break;
			case 13:
				_localctx = new StmtDeclKasmContext(_localctx);
				enterOuterAlt(_localctx, 13);
				{
				setState(592);
				declKasm();
				}
				break;
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class SwitchCasesContext extends ParserRuleContext {
		public List<SwitchCaseContext> switchCase() {
			return getRuleContexts(SwitchCaseContext.class);
		}
		public SwitchCaseContext switchCase(int i) {
			return getRuleContext(SwitchCaseContext.class,i);
		}
		public TerminalNode DEFAULT() { return getToken(KickCParser.DEFAULT, 0); }
		public TerminalNode COLON() { return getToken(KickCParser.COLON, 0); }
		public StmtSeqContext stmtSeq() {
			return getRuleContext(StmtSeqContext.class,0);
		}
		public SwitchCasesContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_switchCases; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterSwitchCases(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitSwitchCases(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitSwitchCases(this);
			else return visitor.visitChildren(this);
		}
	}

	public final SwitchCasesContext switchCases() throws RecognitionException {
		SwitchCasesContext _localctx = new SwitchCasesContext(_ctx, getState());
		enterRule(_localctx, 62, RULE_switchCases);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(596); 
			_errHandler.sync(this);
			_la = _input.LA(1);
			do {
				{
				{
				setState(595);
				switchCase();
				}
				}
				setState(598); 
				_errHandler.sync(this);
				_la = _input.LA(1);
			} while ( _la==CASE );
			setState(605);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==DEFAULT) {
				{
				setState(600);
				match(DEFAULT);
				setState(601);
				match(COLON);
				setState(603);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << TYPEDEFNAME) | (1L << CURLY_BEGIN) | (1L << PAR_BEGIN) | (1L << PLUS) | (1L << MINUS) | (1L << ASTERISK) | (1L << INC) | (1L << DEC) | (1L << AND) | (1L << BIT_NOT) | (1L << LESS_THAN) | (1L << GREATER_THAN) | (1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << INLINE) | (1L << VOLATILE) | (1L << STATIC) | (1L << INTERRUPT) | (1L << REGISTER) | (1L << LOCAL_RESERVE) | (1L << ADDRESS) | (1L << ADDRESS_ZEROPAGE) | (1L << ADDRESS_MAINMEM) | (1L << FORM_SSA))) != 0) || ((((_la - 64)) & ~0x3f) == 0 && ((1L << (_la - 64)) & ((1L << (FORM_MA - 64)) | (1L << (INTRINSIC - 64)) | (1L << (CALLINGCONVENTION - 64)) | (1L << (IF - 64)) | (1L << (WHILE - 64)) | (1L << (DO - 64)) | (1L << (FOR - 64)) | (1L << (SWITCH - 64)) | (1L << (RETURN - 64)) | (1L << (BREAK - 64)) | (1L << (CONTINUE - 64)) | (1L << (ASM - 64)) | (1L << (STRUCT - 64)) | (1L << (ENUM - 64)) | (1L << (SIZEOF - 64)) | (1L << (TYPEID - 64)) | (1L << (DEFINED - 64)) | (1L << (KICKASM - 64)) | (1L << (LOGIC_NOT - 64)) | (1L << (SIGNEDNESS - 64)) | (1L << (SIMPLETYPE - 64)) | (1L << (BOOLEAN - 64)) | (1L << (NUMBER - 64)) | (1L << (NAME - 64)) | (1L << (STRING - 64)) | (1L << (CHAR - 64)))) != 0)) {
					{
					setState(602);
					stmtSeq();
					}
				}

				}
			}

			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class SwitchCaseContext extends ParserRuleContext {
		public TerminalNode CASE() { return getToken(KickCParser.CASE, 0); }
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public TerminalNode COLON() { return getToken(KickCParser.COLON, 0); }
		public StmtSeqContext stmtSeq() {
			return getRuleContext(StmtSeqContext.class,0);
		}
		public SwitchCaseContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_switchCase; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterSwitchCase(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitSwitchCase(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitSwitchCase(this);
			else return visitor.visitChildren(this);
		}
	}

	public final SwitchCaseContext switchCase() throws RecognitionException {
		SwitchCaseContext _localctx = new SwitchCaseContext(_ctx, getState());
		enterRule(_localctx, 64, RULE_switchCase);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(607);
			match(CASE);
			setState(608);
			expr(0);
			setState(609);
			match(COLON);
			setState(611);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << TYPEDEFNAME) | (1L << CURLY_BEGIN) | (1L << PAR_BEGIN) | (1L << PLUS) | (1L << MINUS) | (1L << ASTERISK) | (1L << INC) | (1L << DEC) | (1L << AND) | (1L << BIT_NOT) | (1L << LESS_THAN) | (1L << GREATER_THAN) | (1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << INLINE) | (1L << VOLATILE) | (1L << STATIC) | (1L << INTERRUPT) | (1L << REGISTER) | (1L << LOCAL_RESERVE) | (1L << ADDRESS) | (1L << ADDRESS_ZEROPAGE) | (1L << ADDRESS_MAINMEM) | (1L << FORM_SSA))) != 0) || ((((_la - 64)) & ~0x3f) == 0 && ((1L << (_la - 64)) & ((1L << (FORM_MA - 64)) | (1L << (INTRINSIC - 64)) | (1L << (CALLINGCONVENTION - 64)) | (1L << (IF - 64)) | (1L << (WHILE - 64)) | (1L << (DO - 64)) | (1L << (FOR - 64)) | (1L << (SWITCH - 64)) | (1L << (RETURN - 64)) | (1L << (BREAK - 64)) | (1L << (CONTINUE - 64)) | (1L << (ASM - 64)) | (1L << (STRUCT - 64)) | (1L << (ENUM - 64)) | (1L << (SIZEOF - 64)) | (1L << (TYPEID - 64)) | (1L << (DEFINED - 64)) | (1L << (KICKASM - 64)) | (1L << (LOGIC_NOT - 64)) | (1L << (SIGNEDNESS - 64)) | (1L << (SIMPLETYPE - 64)) | (1L << (BOOLEAN - 64)) | (1L << (NUMBER - 64)) | (1L << (NAME - 64)) | (1L << (STRING - 64)) | (1L << (CHAR - 64)))) != 0)) {
				{
				setState(610);
				stmtSeq();
				}
			}

			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ForLoopContext extends ParserRuleContext {
		public ForLoopContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_forLoop; }
	 
		public ForLoopContext() { }
		public void copyFrom(ForLoopContext ctx) {
			super.copyFrom(ctx);
		}
	}
	public static class ForRangeContext extends ForLoopContext {
		public TerminalNode NAME() { return getToken(KickCParser.NAME, 0); }
		public TerminalNode COLON() { return getToken(KickCParser.COLON, 0); }
		public List<ExprContext> expr() {
			return getRuleContexts(ExprContext.class);
		}
		public ExprContext expr(int i) {
			return getRuleContext(ExprContext.class,i);
		}
		public TerminalNode RANGE() { return getToken(KickCParser.RANGE, 0); }
		public DeclTypeContext declType() {
			return getRuleContext(DeclTypeContext.class,0);
		}
		public List<DeclPointerContext> declPointer() {
			return getRuleContexts(DeclPointerContext.class);
		}
		public DeclPointerContext declPointer(int i) {
			return getRuleContext(DeclPointerContext.class,i);
		}
		public ForRangeContext(ForLoopContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterForRange(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitForRange(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitForRange(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class ForClassicContext extends ForLoopContext {
		public ForClassicInitContext forClassicInit() {
			return getRuleContext(ForClassicInitContext.class,0);
		}
		public List<TerminalNode> SEMICOLON() { return getTokens(KickCParser.SEMICOLON); }
		public TerminalNode SEMICOLON(int i) {
			return getToken(KickCParser.SEMICOLON, i);
		}
		public List<CommaExprContext> commaExpr() {
			return getRuleContexts(CommaExprContext.class);
		}
		public CommaExprContext commaExpr(int i) {
			return getRuleContext(CommaExprContext.class,i);
		}
		public ForClassicContext(ForLoopContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterForClassic(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitForClassic(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitForClassic(this);
			else return visitor.visitChildren(this);
		}
	}

	public final ForLoopContext forLoop() throws RecognitionException {
		ForLoopContext _localctx = new ForLoopContext(_ctx, getState());
		enterRule(_localctx, 66, RULE_forLoop);
		int _la;
		try {
			setState(635);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,61,_ctx) ) {
			case 1:
				_localctx = new ForClassicContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(613);
				forClassicInit();
				setState(614);
				match(SEMICOLON);
				setState(615);
				commaExpr(0);
				setState(616);
				match(SEMICOLON);
				setState(618);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << CURLY_BEGIN) | (1L << PAR_BEGIN) | (1L << PLUS) | (1L << MINUS) | (1L << ASTERISK) | (1L << INC) | (1L << DEC) | (1L << AND) | (1L << BIT_NOT) | (1L << LESS_THAN) | (1L << GREATER_THAN))) != 0) || ((((_la - 83)) & ~0x3f) == 0 && ((1L << (_la - 83)) & ((1L << (SIZEOF - 83)) | (1L << (TYPEID - 83)) | (1L << (DEFINED - 83)) | (1L << (LOGIC_NOT - 83)) | (1L << (BOOLEAN - 83)) | (1L << (NUMBER - 83)) | (1L << (NAME - 83)) | (1L << (STRING - 83)) | (1L << (CHAR - 83)))) != 0)) {
					{
					setState(617);
					commaExpr(0);
					}
				}

				}
				break;
			case 2:
				_localctx = new ForRangeContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(627);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << TYPEDEFNAME) | (1L << PAR_BEGIN) | (1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << INLINE) | (1L << VOLATILE) | (1L << STATIC) | (1L << INTERRUPT) | (1L << REGISTER) | (1L << LOCAL_RESERVE) | (1L << ADDRESS) | (1L << ADDRESS_ZEROPAGE) | (1L << ADDRESS_MAINMEM) | (1L << FORM_SSA))) != 0) || ((((_la - 64)) & ~0x3f) == 0 && ((1L << (_la - 64)) & ((1L << (FORM_MA - 64)) | (1L << (INTRINSIC - 64)) | (1L << (CALLINGCONVENTION - 64)) | (1L << (STRUCT - 64)) | (1L << (ENUM - 64)) | (1L << (SIGNEDNESS - 64)) | (1L << (SIMPLETYPE - 64)))) != 0)) {
					{
					setState(620);
					declType();
					setState(624);
					_errHandler.sync(this);
					_la = _input.LA(1);
					while (_la==ASTERISK) {
						{
						{
						setState(621);
						declPointer();
						}
						}
						setState(626);
						_errHandler.sync(this);
						_la = _input.LA(1);
					}
					}
				}

				setState(629);
				match(NAME);
				setState(630);
				match(COLON);
				setState(631);
				expr(0);
				setState(632);
				match(RANGE);
				setState(633);
				expr(0);
				}
				break;
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ForClassicInitContext extends ParserRuleContext {
		public ForClassicInitContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_forClassicInit; }
	 
		public ForClassicInitContext() { }
		public void copyFrom(ForClassicInitContext ctx) {
			super.copyFrom(ctx);
		}
	}
	public static class ForClassicInitDeclContext extends ForClassicInitContext {
		public DeclVariablesContext declVariables() {
			return getRuleContext(DeclVariablesContext.class,0);
		}
		public ForClassicInitDeclContext(ForClassicInitContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterForClassicInitDecl(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitForClassicInitDecl(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitForClassicInitDecl(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class ForClassicInitExprContext extends ForClassicInitContext {
		public CommaExprContext commaExpr() {
			return getRuleContext(CommaExprContext.class,0);
		}
		public ForClassicInitExprContext(ForClassicInitContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterForClassicInitExpr(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitForClassicInitExpr(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitForClassicInitExpr(this);
			else return visitor.visitChildren(this);
		}
	}

	public final ForClassicInitContext forClassicInit() throws RecognitionException {
		ForClassicInitContext _localctx = new ForClassicInitContext(_ctx, getState());
		enterRule(_localctx, 68, RULE_forClassicInit);
		int _la;
		try {
			setState(641);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,63,_ctx) ) {
			case 1:
				_localctx = new ForClassicInitDeclContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(638);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << TYPEDEFNAME) | (1L << PAR_BEGIN) | (1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << INLINE) | (1L << VOLATILE) | (1L << STATIC) | (1L << INTERRUPT) | (1L << REGISTER) | (1L << LOCAL_RESERVE) | (1L << ADDRESS) | (1L << ADDRESS_ZEROPAGE) | (1L << ADDRESS_MAINMEM) | (1L << FORM_SSA))) != 0) || ((((_la - 64)) & ~0x3f) == 0 && ((1L << (_la - 64)) & ((1L << (FORM_MA - 64)) | (1L << (INTRINSIC - 64)) | (1L << (CALLINGCONVENTION - 64)) | (1L << (STRUCT - 64)) | (1L << (ENUM - 64)) | (1L << (SIGNEDNESS - 64)) | (1L << (SIMPLETYPE - 64)))) != 0)) {
					{
					setState(637);
					declVariables();
					}
				}

				}
				break;
			case 2:
				_localctx = new ForClassicInitExprContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(640);
				commaExpr(0);
				}
				break;
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class CommaExprContext extends ParserRuleContext {
		public CommaExprContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_commaExpr; }
	 
		public CommaExprContext() { }
		public void copyFrom(CommaExprContext ctx) {
			super.copyFrom(ctx);
		}
	}
	public static class CommaNoneContext extends CommaExprContext {
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public CommaNoneContext(CommaExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterCommaNone(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitCommaNone(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitCommaNone(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class CommaSimpleContext extends CommaExprContext {
		public CommaExprContext commaExpr() {
			return getRuleContext(CommaExprContext.class,0);
		}
		public TerminalNode COMMA() { return getToken(KickCParser.COMMA, 0); }
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public CommaSimpleContext(CommaExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterCommaSimple(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitCommaSimple(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitCommaSimple(this);
			else return visitor.visitChildren(this);
		}
	}

	public final CommaExprContext commaExpr() throws RecognitionException {
		return commaExpr(0);
	}

	private CommaExprContext commaExpr(int _p) throws RecognitionException {
		ParserRuleContext _parentctx = _ctx;
		int _parentState = getState();
		CommaExprContext _localctx = new CommaExprContext(_ctx, _parentState);
		CommaExprContext _prevctx = _localctx;
		int _startState = 70;
		enterRecursionRule(_localctx, 70, RULE_commaExpr, _p);
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			{
			_localctx = new CommaNoneContext(_localctx);
			_ctx = _localctx;
			_prevctx = _localctx;

			setState(644);
			expr(0);
			}
			_ctx.stop = _input.LT(-1);
			setState(651);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,64,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					{
					_localctx = new CommaSimpleContext(new CommaExprContext(_parentctx, _parentState));
					pushNewRecursionContext(_localctx, _startState, RULE_commaExpr);
					setState(646);
					if (!(precpred(_ctx, 1))) throw new FailedPredicateException(this, "precpred(_ctx, 1)");
					setState(647);
					match(COMMA);
					setState(648);
					expr(0);
					}
					} 
				}
				setState(653);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,64,_ctx);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			unrollRecursionContexts(_parentctx);
		}
		return _localctx;
	}

	public static class ExprContext extends ParserRuleContext {
		public ExprContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_expr; }
	 
		public ExprContext() { }
		public void copyFrom(ExprContext ctx) {
			super.copyFrom(ctx);
		}
	}
	public static class ExprPtrContext extends ExprContext {
		public TerminalNode ASTERISK() { return getToken(KickCParser.ASTERISK, 0); }
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public ExprPtrContext(ExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterExprPtr(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitExprPtr(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitExprPtr(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class ExprPreModContext extends ExprContext {
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public TerminalNode DEC() { return getToken(KickCParser.DEC, 0); }
		public TerminalNode INC() { return getToken(KickCParser.INC, 0); }
		public ExprPreModContext(ExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterExprPreMod(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitExprPreMod(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitExprPreMod(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class ExprBinaryContext extends ExprContext {
		public List<ExprContext> expr() {
			return getRuleContexts(ExprContext.class);
		}
		public ExprContext expr(int i) {
			return getRuleContext(ExprContext.class,i);
		}
		public TerminalNode SHIFT_LEFT() { return getToken(KickCParser.SHIFT_LEFT, 0); }
		public TerminalNode SHIFT_RIGHT() { return getToken(KickCParser.SHIFT_RIGHT, 0); }
		public TerminalNode ASTERISK() { return getToken(KickCParser.ASTERISK, 0); }
		public TerminalNode DIVIDE() { return getToken(KickCParser.DIVIDE, 0); }
		public TerminalNode MODULO() { return getToken(KickCParser.MODULO, 0); }
		public TerminalNode PLUS() { return getToken(KickCParser.PLUS, 0); }
		public TerminalNode MINUS() { return getToken(KickCParser.MINUS, 0); }
		public TerminalNode EQUAL() { return getToken(KickCParser.EQUAL, 0); }
		public TerminalNode NOT_EQUAL() { return getToken(KickCParser.NOT_EQUAL, 0); }
		public TerminalNode LESS_THAN() { return getToken(KickCParser.LESS_THAN, 0); }
		public TerminalNode LESS_THAN_EQUAL() { return getToken(KickCParser.LESS_THAN_EQUAL, 0); }
		public TerminalNode GREATER_THAN_EQUAL() { return getToken(KickCParser.GREATER_THAN_EQUAL, 0); }
		public TerminalNode GREATER_THAN() { return getToken(KickCParser.GREATER_THAN, 0); }
		public TerminalNode AND() { return getToken(KickCParser.AND, 0); }
		public TerminalNode BIT_XOR() { return getToken(KickCParser.BIT_XOR, 0); }
		public TerminalNode BIT_OR() { return getToken(KickCParser.BIT_OR, 0); }
		public TerminalNode LOGIC_AND() { return getToken(KickCParser.LOGIC_AND, 0); }
		public TerminalNode LOGIC_OR() { return getToken(KickCParser.LOGIC_OR, 0); }
		public ExprBinaryContext(ExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterExprBinary(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitExprBinary(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitExprBinary(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class ExprTypeIdContext extends ExprContext {
		public TerminalNode TYPEID() { return getToken(KickCParser.TYPEID, 0); }
		public TerminalNode PAR_BEGIN() { return getToken(KickCParser.PAR_BEGIN, 0); }
		public TerminalNode PAR_END() { return getToken(KickCParser.PAR_END, 0); }
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public TypeSpecifierContext typeSpecifier() {
			return getRuleContext(TypeSpecifierContext.class,0);
		}
		public ExprTypeIdContext(ExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterExprTypeId(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitExprTypeId(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitExprTypeId(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class ExprPostModContext extends ExprContext {
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public TerminalNode DEC() { return getToken(KickCParser.DEC, 0); }
		public TerminalNode INC() { return getToken(KickCParser.INC, 0); }
		public ExprPostModContext(ExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterExprPostMod(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitExprPostMod(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitExprPostMod(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class ExprUnaryContext extends ExprContext {
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public TerminalNode PLUS() { return getToken(KickCParser.PLUS, 0); }
		public TerminalNode MINUS() { return getToken(KickCParser.MINUS, 0); }
		public TerminalNode LOGIC_NOT() { return getToken(KickCParser.LOGIC_NOT, 0); }
		public TerminalNode AND() { return getToken(KickCParser.AND, 0); }
		public TerminalNode BIT_NOT() { return getToken(KickCParser.BIT_NOT, 0); }
		public TerminalNode LESS_THAN() { return getToken(KickCParser.LESS_THAN, 0); }
		public TerminalNode GREATER_THAN() { return getToken(KickCParser.GREATER_THAN, 0); }
		public ExprUnaryContext(ExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterExprUnary(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitExprUnary(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitExprUnary(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class ExprNumberContext extends ExprContext {
		public TerminalNode NUMBER() { return getToken(KickCParser.NUMBER, 0); }
		public ExprNumberContext(ExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterExprNumber(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitExprNumber(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitExprNumber(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class ExprCharContext extends ExprContext {
		public TerminalNode CHAR() { return getToken(KickCParser.CHAR, 0); }
		public ExprCharContext(ExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterExprChar(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitExprChar(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitExprChar(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class ExprArrowContext extends ExprContext {
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public TerminalNode ARROW() { return getToken(KickCParser.ARROW, 0); }
		public TerminalNode NAME() { return getToken(KickCParser.NAME, 0); }
		public ExprArrowContext(ExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterExprArrow(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitExprArrow(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitExprArrow(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class ExprDotContext extends ExprContext {
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public TerminalNode DOT() { return getToken(KickCParser.DOT, 0); }
		public TerminalNode NAME() { return getToken(KickCParser.NAME, 0); }
		public ExprDotContext(ExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterExprDot(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitExprDot(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitExprDot(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class InitListContext extends ExprContext {
		public TerminalNode CURLY_BEGIN() { return getToken(KickCParser.CURLY_BEGIN, 0); }
		public List<ExprContext> expr() {
			return getRuleContexts(ExprContext.class);
		}
		public ExprContext expr(int i) {
			return getRuleContext(ExprContext.class,i);
		}
		public TerminalNode CURLY_END() { return getToken(KickCParser.CURLY_END, 0); }
		public List<TerminalNode> COMMA() { return getTokens(KickCParser.COMMA); }
		public TerminalNode COMMA(int i) {
			return getToken(KickCParser.COMMA, i);
		}
		public InitListContext(ExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterInitList(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitInitList(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitInitList(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class ExprCastContext extends ExprContext {
		public TerminalNode PAR_BEGIN() { return getToken(KickCParser.PAR_BEGIN, 0); }
		public TypeSpecifierContext typeSpecifier() {
			return getRuleContext(TypeSpecifierContext.class,0);
		}
		public TerminalNode PAR_END() { return getToken(KickCParser.PAR_END, 0); }
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public ExprCastContext(ExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterExprCast(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitExprCast(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitExprCast(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class ExprCallContext extends ExprContext {
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public TerminalNode PAR_BEGIN() { return getToken(KickCParser.PAR_BEGIN, 0); }
		public TerminalNode PAR_END() { return getToken(KickCParser.PAR_END, 0); }
		public ParameterListContext parameterList() {
			return getRuleContext(ParameterListContext.class,0);
		}
		public ExprCallContext(ExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterExprCall(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitExprCall(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitExprCall(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class ExprParContext extends ExprContext {
		public TerminalNode PAR_BEGIN() { return getToken(KickCParser.PAR_BEGIN, 0); }
		public CommaExprContext commaExpr() {
			return getRuleContext(CommaExprContext.class,0);
		}
		public TerminalNode PAR_END() { return getToken(KickCParser.PAR_END, 0); }
		public ExprParContext(ExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterExprPar(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitExprPar(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitExprPar(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class ExprSizeOfContext extends ExprContext {
		public TerminalNode SIZEOF() { return getToken(KickCParser.SIZEOF, 0); }
		public TerminalNode PAR_BEGIN() { return getToken(KickCParser.PAR_BEGIN, 0); }
		public TerminalNode PAR_END() { return getToken(KickCParser.PAR_END, 0); }
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public TypeSpecifierContext typeSpecifier() {
			return getRuleContext(TypeSpecifierContext.class,0);
		}
		public ExprSizeOfContext(ExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterExprSizeOf(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitExprSizeOf(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitExprSizeOf(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class ExprStringContext extends ExprContext {
		public List<TerminalNode> STRING() { return getTokens(KickCParser.STRING); }
		public TerminalNode STRING(int i) {
			return getToken(KickCParser.STRING, i);
		}
		public ExprStringContext(ExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterExprString(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitExprString(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitExprString(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class ExprAssignmentCompoundContext extends ExprContext {
		public List<ExprContext> expr() {
			return getRuleContexts(ExprContext.class);
		}
		public ExprContext expr(int i) {
			return getRuleContext(ExprContext.class,i);
		}
		public TerminalNode ASSIGN_COMPOUND() { return getToken(KickCParser.ASSIGN_COMPOUND, 0); }
		public ExprAssignmentCompoundContext(ExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterExprAssignmentCompound(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitExprAssignmentCompound(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitExprAssignmentCompound(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class ExprBoolContext extends ExprContext {
		public TerminalNode BOOLEAN() { return getToken(KickCParser.BOOLEAN, 0); }
		public ExprBoolContext(ExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterExprBool(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitExprBool(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitExprBool(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class ExprIdContext extends ExprContext {
		public TerminalNode NAME() { return getToken(KickCParser.NAME, 0); }
		public ExprIdContext(ExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterExprId(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitExprId(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitExprId(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class ExprDefinedContext extends ExprContext {
		public TerminalNode DEFINED() { return getToken(KickCParser.DEFINED, 0); }
		public TerminalNode NAME() { return getToken(KickCParser.NAME, 0); }
		public TerminalNode PAR_BEGIN() { return getToken(KickCParser.PAR_BEGIN, 0); }
		public TerminalNode PAR_END() { return getToken(KickCParser.PAR_END, 0); }
		public ExprDefinedContext(ExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterExprDefined(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitExprDefined(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitExprDefined(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class ExprTernaryContext extends ExprContext {
		public List<ExprContext> expr() {
			return getRuleContexts(ExprContext.class);
		}
		public ExprContext expr(int i) {
			return getRuleContext(ExprContext.class,i);
		}
		public TerminalNode CONDITION() { return getToken(KickCParser.CONDITION, 0); }
		public TerminalNode COLON() { return getToken(KickCParser.COLON, 0); }
		public ExprTernaryContext(ExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterExprTernary(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitExprTernary(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitExprTernary(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class ExprAssignmentContext extends ExprContext {
		public List<ExprContext> expr() {
			return getRuleContexts(ExprContext.class);
		}
		public ExprContext expr(int i) {
			return getRuleContext(ExprContext.class,i);
		}
		public TerminalNode ASSIGN() { return getToken(KickCParser.ASSIGN, 0); }
		public ExprAssignmentContext(ExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterExprAssignment(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitExprAssignment(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitExprAssignment(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class ExprArrayContext extends ExprContext {
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public TerminalNode BRACKET_BEGIN() { return getToken(KickCParser.BRACKET_BEGIN, 0); }
		public CommaExprContext commaExpr() {
			return getRuleContext(CommaExprContext.class,0);
		}
		public TerminalNode BRACKET_END() { return getToken(KickCParser.BRACKET_END, 0); }
		public ExprArrayContext(ExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterExprArray(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitExprArray(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitExprArray(this);
			else return visitor.visitChildren(this);
		}
	}

	public final ExprContext expr() throws RecognitionException {
		return expr(0);
	}

	private ExprContext expr(int _p) throws RecognitionException {
		ParserRuleContext _parentctx = _ctx;
		int _parentState = getState();
		ExprContext _localctx = new ExprContext(_ctx, _parentState);
		ExprContext _prevctx = _localctx;
		int _startState = 72;
		enterRecursionRule(_localctx, 72, RULE_expr, _p);
		int _la;
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(716);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,71,_ctx) ) {
			case 1:
				{
				_localctx = new ExprParContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;

				setState(655);
				match(PAR_BEGIN);
				setState(656);
				commaExpr(0);
				setState(657);
				match(PAR_END);
				}
				break;
			case 2:
				{
				_localctx = new ExprSizeOfContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(659);
				match(SIZEOF);
				setState(660);
				match(PAR_BEGIN);
				setState(663);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,65,_ctx) ) {
				case 1:
					{
					setState(661);
					expr(0);
					}
					break;
				case 2:
					{
					setState(662);
					typeSpecifier(0);
					}
					break;
				}
				setState(665);
				match(PAR_END);
				}
				break;
			case 3:
				{
				_localctx = new ExprTypeIdContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(667);
				match(TYPEID);
				setState(668);
				match(PAR_BEGIN);
				setState(671);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,66,_ctx) ) {
				case 1:
					{
					setState(669);
					expr(0);
					}
					break;
				case 2:
					{
					setState(670);
					typeSpecifier(0);
					}
					break;
				}
				setState(673);
				match(PAR_END);
				}
				break;
			case 4:
				{
				_localctx = new ExprDefinedContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(675);
				match(DEFINED);
				setState(677);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if (_la==PAR_BEGIN) {
					{
					setState(676);
					match(PAR_BEGIN);
					}
				}

				setState(679);
				match(NAME);
				setState(681);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,68,_ctx) ) {
				case 1:
					{
					setState(680);
					match(PAR_END);
					}
					break;
				}
				}
				break;
			case 5:
				{
				_localctx = new ExprCastContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(683);
				match(PAR_BEGIN);
				setState(684);
				typeSpecifier(0);
				setState(685);
				match(PAR_END);
				setState(686);
				expr(24);
				}
				break;
			case 6:
				{
				_localctx = new ExprPreModContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(688);
				_la = _input.LA(1);
				if ( !(_la==INC || _la==DEC) ) {
				_errHandler.recoverInline(this);
				}
				else {
					if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
					_errHandler.reportMatch(this);
					consume();
				}
				setState(689);
				expr(23);
				}
				break;
			case 7:
				{
				_localctx = new ExprPtrContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(690);
				match(ASTERISK);
				setState(691);
				expr(21);
				}
				break;
			case 8:
				{
				_localctx = new ExprUnaryContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(692);
				_la = _input.LA(1);
				if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << PLUS) | (1L << MINUS) | (1L << AND) | (1L << BIT_NOT))) != 0) || _la==LOGIC_NOT) ) {
				_errHandler.recoverInline(this);
				}
				else {
					if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
					_errHandler.reportMatch(this);
					consume();
				}
				setState(693);
				expr(20);
				}
				break;
			case 9:
				{
				_localctx = new ExprUnaryContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(694);
				_la = _input.LA(1);
				if ( !(_la==LESS_THAN || _la==GREATER_THAN) ) {
				_errHandler.recoverInline(this);
				}
				else {
					if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
					_errHandler.reportMatch(this);
					consume();
				}
				setState(695);
				expr(16);
				}
				break;
			case 10:
				{
				_localctx = new InitListContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(696);
				match(CURLY_BEGIN);
				setState(697);
				expr(0);
				setState(702);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (_la==COMMA) {
					{
					{
					setState(698);
					match(COMMA);
					setState(699);
					expr(0);
					}
					}
					setState(704);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				setState(705);
				match(CURLY_END);
				}
				break;
			case 11:
				{
				_localctx = new ExprIdContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(707);
				match(NAME);
				}
				break;
			case 12:
				{
				_localctx = new ExprNumberContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(708);
				match(NUMBER);
				}
				break;
			case 13:
				{
				_localctx = new ExprStringContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(710); 
				_errHandler.sync(this);
				_alt = 1;
				do {
					switch (_alt) {
					case 1:
						{
						{
						setState(709);
						match(STRING);
						}
						}
						break;
					default:
						throw new NoViableAltException(this);
					}
					setState(712); 
					_errHandler.sync(this);
					_alt = getInterpreter().adaptivePredict(_input,70,_ctx);
				} while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER );
				}
				break;
			case 14:
				{
				_localctx = new ExprCharContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(714);
				match(CHAR);
				}
				break;
			case 15:
				{
				_localctx = new ExprBoolContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(715);
				match(BOOLEAN);
				}
				break;
			}
			_ctx.stop = _input.LT(-1);
			setState(778);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,74,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					setState(776);
					_errHandler.sync(this);
					switch ( getInterpreter().adaptivePredict(_input,73,_ctx) ) {
					case 1:
						{
						_localctx = new ExprBinaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(718);
						if (!(precpred(_ctx, 19))) throw new FailedPredicateException(this, "precpred(_ctx, 19)");
						setState(719);
						_la = _input.LA(1);
						if ( !(_la==SHIFT_LEFT || _la==SHIFT_RIGHT) ) {
						_errHandler.recoverInline(this);
						}
						else {
							if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
							_errHandler.reportMatch(this);
							consume();
						}
						setState(720);
						expr(20);
						}
						break;
					case 2:
						{
						_localctx = new ExprBinaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(721);
						if (!(precpred(_ctx, 18))) throw new FailedPredicateException(this, "precpred(_ctx, 18)");
						setState(722);
						_la = _input.LA(1);
						if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << ASTERISK) | (1L << DIVIDE) | (1L << MODULO))) != 0)) ) {
						_errHandler.recoverInline(this);
						}
						else {
							if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
							_errHandler.reportMatch(this);
							consume();
						}
						setState(723);
						expr(19);
						}
						break;
					case 3:
						{
						_localctx = new ExprBinaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(724);
						if (!(precpred(_ctx, 17))) throw new FailedPredicateException(this, "precpred(_ctx, 17)");
						setState(725);
						_la = _input.LA(1);
						if ( !(_la==PLUS || _la==MINUS) ) {
						_errHandler.recoverInline(this);
						}
						else {
							if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
							_errHandler.reportMatch(this);
							consume();
						}
						setState(726);
						expr(18);
						}
						break;
					case 4:
						{
						_localctx = new ExprBinaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(727);
						if (!(precpred(_ctx, 15))) throw new FailedPredicateException(this, "precpred(_ctx, 15)");
						setState(728);
						_la = _input.LA(1);
						if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << EQUAL) | (1L << NOT_EQUAL) | (1L << LESS_THAN) | (1L << LESS_THAN_EQUAL) | (1L << GREATER_THAN_EQUAL) | (1L << GREATER_THAN))) != 0)) ) {
						_errHandler.recoverInline(this);
						}
						else {
							if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
							_errHandler.reportMatch(this);
							consume();
						}
						setState(729);
						expr(16);
						}
						break;
					case 5:
						{
						_localctx = new ExprBinaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(730);
						if (!(precpred(_ctx, 14))) throw new FailedPredicateException(this, "precpred(_ctx, 14)");
						{
						setState(731);
						match(AND);
						}
						setState(732);
						expr(15);
						}
						break;
					case 6:
						{
						_localctx = new ExprBinaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(733);
						if (!(precpred(_ctx, 13))) throw new FailedPredicateException(this, "precpred(_ctx, 13)");
						{
						setState(734);
						match(BIT_XOR);
						}
						setState(735);
						expr(14);
						}
						break;
					case 7:
						{
						_localctx = new ExprBinaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(736);
						if (!(precpred(_ctx, 12))) throw new FailedPredicateException(this, "precpred(_ctx, 12)");
						{
						setState(737);
						match(BIT_OR);
						}
						setState(738);
						expr(13);
						}
						break;
					case 8:
						{
						_localctx = new ExprBinaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(739);
						if (!(precpred(_ctx, 11))) throw new FailedPredicateException(this, "precpred(_ctx, 11)");
						{
						setState(740);
						match(LOGIC_AND);
						}
						setState(741);
						expr(12);
						}
						break;
					case 9:
						{
						_localctx = new ExprBinaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(742);
						if (!(precpred(_ctx, 10))) throw new FailedPredicateException(this, "precpred(_ctx, 10)");
						{
						setState(743);
						match(LOGIC_OR);
						}
						setState(744);
						expr(11);
						}
						break;
					case 10:
						{
						_localctx = new ExprTernaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(745);
						if (!(precpred(_ctx, 9))) throw new FailedPredicateException(this, "precpred(_ctx, 9)");
						setState(746);
						match(CONDITION);
						setState(747);
						expr(0);
						setState(748);
						match(COLON);
						setState(749);
						expr(10);
						}
						break;
					case 11:
						{
						_localctx = new ExprAssignmentContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(751);
						if (!(precpred(_ctx, 8))) throw new FailedPredicateException(this, "precpred(_ctx, 8)");
						setState(752);
						match(ASSIGN);
						setState(753);
						expr(8);
						}
						break;
					case 12:
						{
						_localctx = new ExprAssignmentCompoundContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(754);
						if (!(precpred(_ctx, 7))) throw new FailedPredicateException(this, "precpred(_ctx, 7)");
						setState(755);
						match(ASSIGN_COMPOUND);
						setState(756);
						expr(7);
						}
						break;
					case 13:
						{
						_localctx = new ExprDotContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(757);
						if (!(precpred(_ctx, 31))) throw new FailedPredicateException(this, "precpred(_ctx, 31)");
						setState(758);
						match(DOT);
						setState(759);
						match(NAME);
						}
						break;
					case 14:
						{
						_localctx = new ExprArrowContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(760);
						if (!(precpred(_ctx, 30))) throw new FailedPredicateException(this, "precpred(_ctx, 30)");
						setState(761);
						match(ARROW);
						setState(762);
						match(NAME);
						}
						break;
					case 15:
						{
						_localctx = new ExprCallContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(763);
						if (!(precpred(_ctx, 29))) throw new FailedPredicateException(this, "precpred(_ctx, 29)");
						setState(764);
						match(PAR_BEGIN);
						setState(766);
						_errHandler.sync(this);
						_la = _input.LA(1);
						if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << CURLY_BEGIN) | (1L << PAR_BEGIN) | (1L << PLUS) | (1L << MINUS) | (1L << ASTERISK) | (1L << INC) | (1L << DEC) | (1L << AND) | (1L << BIT_NOT) | (1L << LESS_THAN) | (1L << GREATER_THAN))) != 0) || ((((_la - 83)) & ~0x3f) == 0 && ((1L << (_la - 83)) & ((1L << (SIZEOF - 83)) | (1L << (TYPEID - 83)) | (1L << (DEFINED - 83)) | (1L << (LOGIC_NOT - 83)) | (1L << (BOOLEAN - 83)) | (1L << (NUMBER - 83)) | (1L << (NAME - 83)) | (1L << (STRING - 83)) | (1L << (CHAR - 83)))) != 0)) {
							{
							setState(765);
							parameterList();
							}
						}

						setState(768);
						match(PAR_END);
						}
						break;
					case 16:
						{
						_localctx = new ExprArrayContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(769);
						if (!(precpred(_ctx, 25))) throw new FailedPredicateException(this, "precpred(_ctx, 25)");
						setState(770);
						match(BRACKET_BEGIN);
						setState(771);
						commaExpr(0);
						setState(772);
						match(BRACKET_END);
						}
						break;
					case 17:
						{
						_localctx = new ExprPostModContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(774);
						if (!(precpred(_ctx, 22))) throw new FailedPredicateException(this, "precpred(_ctx, 22)");
						setState(775);
						_la = _input.LA(1);
						if ( !(_la==INC || _la==DEC) ) {
						_errHandler.recoverInline(this);
						}
						else {
							if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
							_errHandler.reportMatch(this);
							consume();
						}
						}
						break;
					}
					} 
				}
				setState(780);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,74,_ctx);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			unrollRecursionContexts(_parentctx);
		}
		return _localctx;
	}

	public static class ParameterListContext extends ParserRuleContext {
		public List<ExprContext> expr() {
			return getRuleContexts(ExprContext.class);
		}
		public ExprContext expr(int i) {
			return getRuleContext(ExprContext.class,i);
		}
		public List<TerminalNode> COMMA() { return getTokens(KickCParser.COMMA); }
		public TerminalNode COMMA(int i) {
			return getToken(KickCParser.COMMA, i);
		}
		public ParameterListContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_parameterList; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterParameterList(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitParameterList(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitParameterList(this);
			else return visitor.visitChildren(this);
		}
	}

	public final ParameterListContext parameterList() throws RecognitionException {
		ParameterListContext _localctx = new ParameterListContext(_ctx, getState());
		enterRule(_localctx, 74, RULE_parameterList);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(781);
			expr(0);
			setState(786);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==COMMA) {
				{
				{
				setState(782);
				match(COMMA);
				setState(783);
				expr(0);
				}
				}
				setState(788);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class DeclKasmContext extends ParserRuleContext {
		public TerminalNode KICKASM() { return getToken(KickCParser.KICKASM, 0); }
		public TerminalNode KICKASM_BODY() { return getToken(KickCParser.KICKASM_BODY, 0); }
		public AsmDirectivesContext asmDirectives() {
			return getRuleContext(AsmDirectivesContext.class,0);
		}
		public DeclKasmContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_declKasm; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterDeclKasm(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitDeclKasm(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitDeclKasm(this);
			else return visitor.visitChildren(this);
		}
	}

	public final DeclKasmContext declKasm() throws RecognitionException {
		DeclKasmContext _localctx = new DeclKasmContext(_ctx, getState());
		enterRule(_localctx, 76, RULE_declKasm);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(789);
			match(KICKASM);
			setState(791);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==PAR_BEGIN) {
				{
				setState(790);
				asmDirectives();
				}
			}

			setState(793);
			match(KICKASM_BODY);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class AsmDirectivesContext extends ParserRuleContext {
		public TerminalNode PAR_BEGIN() { return getToken(KickCParser.PAR_BEGIN, 0); }
		public List<AsmDirectiveContext> asmDirective() {
			return getRuleContexts(AsmDirectiveContext.class);
		}
		public AsmDirectiveContext asmDirective(int i) {
			return getRuleContext(AsmDirectiveContext.class,i);
		}
		public TerminalNode PAR_END() { return getToken(KickCParser.PAR_END, 0); }
		public List<TerminalNode> COMMA() { return getTokens(KickCParser.COMMA); }
		public TerminalNode COMMA(int i) {
			return getToken(KickCParser.COMMA, i);
		}
		public AsmDirectivesContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_asmDirectives; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterAsmDirectives(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitAsmDirectives(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitAsmDirectives(this);
			else return visitor.visitChildren(this);
		}
	}

	public final AsmDirectivesContext asmDirectives() throws RecognitionException {
		AsmDirectivesContext _localctx = new AsmDirectivesContext(_ctx, getState());
		enterRule(_localctx, 78, RULE_asmDirectives);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(795);
			match(PAR_BEGIN);
			setState(796);
			asmDirective();
			setState(801);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==COMMA) {
				{
				{
				setState(797);
				match(COMMA);
				setState(798);
				asmDirective();
				}
				}
				setState(803);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(804);
			match(PAR_END);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class AsmDirectiveContext extends ParserRuleContext {
		public AsmDirectiveContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_asmDirective; }
	 
		public AsmDirectiveContext() { }
		public void copyFrom(AsmDirectiveContext ctx) {
			super.copyFrom(ctx);
		}
	}
	public static class AsmDirectiveUsesContext extends AsmDirectiveContext {
		public TerminalNode USES() { return getToken(KickCParser.USES, 0); }
		public TerminalNode NAME() { return getToken(KickCParser.NAME, 0); }
		public AsmDirectiveUsesContext(AsmDirectiveContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterAsmDirectiveUses(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitAsmDirectiveUses(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitAsmDirectiveUses(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class AsmDirectiveBytesContext extends AsmDirectiveContext {
		public TerminalNode BYTES() { return getToken(KickCParser.BYTES, 0); }
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public AsmDirectiveBytesContext(AsmDirectiveContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterAsmDirectiveBytes(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitAsmDirectiveBytes(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitAsmDirectiveBytes(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class AsmDirectiveAddressContext extends AsmDirectiveContext {
		public TerminalNode PC() { return getToken(KickCParser.PC, 0); }
		public TerminalNode INLINE() { return getToken(KickCParser.INLINE, 0); }
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public AsmDirectiveAddressContext(AsmDirectiveContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterAsmDirectiveAddress(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitAsmDirectiveAddress(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitAsmDirectiveAddress(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class AsmDirectiveClobberContext extends AsmDirectiveContext {
		public TerminalNode CLOBBERS() { return getToken(KickCParser.CLOBBERS, 0); }
		public TerminalNode STRING() { return getToken(KickCParser.STRING, 0); }
		public AsmDirectiveClobberContext(AsmDirectiveContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterAsmDirectiveClobber(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitAsmDirectiveClobber(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitAsmDirectiveClobber(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class AsmDirectiveCyclesContext extends AsmDirectiveContext {
		public TerminalNode CYCLES() { return getToken(KickCParser.CYCLES, 0); }
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public AsmDirectiveCyclesContext(AsmDirectiveContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterAsmDirectiveCycles(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitAsmDirectiveCycles(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitAsmDirectiveCycles(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class AsmDirectiveResourceContext extends AsmDirectiveContext {
		public TerminalNode RESOURCE() { return getToken(KickCParser.RESOURCE, 0); }
		public TerminalNode STRING() { return getToken(KickCParser.STRING, 0); }
		public AsmDirectiveResourceContext(AsmDirectiveContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterAsmDirectiveResource(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitAsmDirectiveResource(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitAsmDirectiveResource(this);
			else return visitor.visitChildren(this);
		}
	}

	public final AsmDirectiveContext asmDirective() throws RecognitionException {
		AsmDirectiveContext _localctx = new AsmDirectiveContext(_ctx, getState());
		enterRule(_localctx, 80, RULE_asmDirective);
		try {
			setState(821);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case RESOURCE:
				_localctx = new AsmDirectiveResourceContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(806);
				match(RESOURCE);
				setState(807);
				match(STRING);
				}
				break;
			case USES:
				_localctx = new AsmDirectiveUsesContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(808);
				match(USES);
				setState(809);
				match(NAME);
				}
				break;
			case CLOBBERS:
				_localctx = new AsmDirectiveClobberContext(_localctx);
				enterOuterAlt(_localctx, 3);
				{
				setState(810);
				match(CLOBBERS);
				setState(811);
				match(STRING);
				}
				break;
			case BYTES:
				_localctx = new AsmDirectiveBytesContext(_localctx);
				enterOuterAlt(_localctx, 4);
				{
				setState(812);
				match(BYTES);
				setState(813);
				expr(0);
				}
				break;
			case CYCLES:
				_localctx = new AsmDirectiveCyclesContext(_localctx);
				enterOuterAlt(_localctx, 5);
				{
				setState(814);
				match(CYCLES);
				setState(815);
				expr(0);
				}
				break;
			case PC:
				_localctx = new AsmDirectiveAddressContext(_localctx);
				enterOuterAlt(_localctx, 6);
				{
				setState(816);
				match(PC);
				setState(819);
				_errHandler.sync(this);
				switch (_input.LA(1)) {
				case INLINE:
					{
					setState(817);
					match(INLINE);
					}
					break;
				case CURLY_BEGIN:
				case PAR_BEGIN:
				case PLUS:
				case MINUS:
				case ASTERISK:
				case INC:
				case DEC:
				case AND:
				case BIT_NOT:
				case LESS_THAN:
				case GREATER_THAN:
				case SIZEOF:
				case TYPEID:
				case DEFINED:
				case LOGIC_NOT:
				case BOOLEAN:
				case NUMBER:
				case NAME:
				case STRING:
				case CHAR:
					{
					setState(818);
					expr(0);
					}
					break;
				default:
					throw new NoViableAltException(this);
				}
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class AsmLinesContext extends ParserRuleContext {
		public List<AsmLineContext> asmLine() {
			return getRuleContexts(AsmLineContext.class);
		}
		public AsmLineContext asmLine(int i) {
			return getRuleContext(AsmLineContext.class,i);
		}
		public AsmLinesContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_asmLines; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterAsmLines(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitAsmLines(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitAsmLines(this);
			else return visitor.visitChildren(this);
		}
	}

	public final AsmLinesContext asmLines() throws RecognitionException {
		AsmLinesContext _localctx = new AsmLinesContext(_ctx, getState());
		enterRule(_localctx, 82, RULE_asmLines);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(826);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (((((_la - 124)) & ~0x3f) == 0 && ((1L << (_la - 124)) & ((1L << (ASM_BYTE - 124)) | (1L << (ASM_MNEMONIC - 124)) | (1L << (ASM_MULTI_NAME - 124)) | (1L << (ASM_NAME - 124)))) != 0)) {
				{
				{
				setState(823);
				asmLine();
				}
				}
				setState(828);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class AsmLineContext extends ParserRuleContext {
		public AsmLabelContext asmLabel() {
			return getRuleContext(AsmLabelContext.class,0);
		}
		public AsmInstructionContext asmInstruction() {
			return getRuleContext(AsmInstructionContext.class,0);
		}
		public AsmBytesContext asmBytes() {
			return getRuleContext(AsmBytesContext.class,0);
		}
		public AsmLineContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_asmLine; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterAsmLine(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitAsmLine(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitAsmLine(this);
			else return visitor.visitChildren(this);
		}
	}

	public final AsmLineContext asmLine() throws RecognitionException {
		AsmLineContext _localctx = new AsmLineContext(_ctx, getState());
		enterRule(_localctx, 84, RULE_asmLine);
		try {
			setState(832);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case ASM_MULTI_NAME:
			case ASM_NAME:
				enterOuterAlt(_localctx, 1);
				{
				setState(829);
				asmLabel();
				}
				break;
			case ASM_MNEMONIC:
				enterOuterAlt(_localctx, 2);
				{
				setState(830);
				asmInstruction();
				}
				break;
			case ASM_BYTE:
				enterOuterAlt(_localctx, 3);
				{
				setState(831);
				asmBytes();
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class AsmLabelContext extends ParserRuleContext {
		public AsmLabelContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_asmLabel; }
	 
		public AsmLabelContext() { }
		public void copyFrom(AsmLabelContext ctx) {
			super.copyFrom(ctx);
		}
	}
	public static class AsmLabelNameContext extends AsmLabelContext {
		public TerminalNode ASM_NAME() { return getToken(KickCParser.ASM_NAME, 0); }
		public TerminalNode ASM_COLON() { return getToken(KickCParser.ASM_COLON, 0); }
		public AsmLabelNameContext(AsmLabelContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterAsmLabelName(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitAsmLabelName(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitAsmLabelName(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class AsmLabelMultiContext extends AsmLabelContext {
		public TerminalNode ASM_MULTI_NAME() { return getToken(KickCParser.ASM_MULTI_NAME, 0); }
		public TerminalNode ASM_COLON() { return getToken(KickCParser.ASM_COLON, 0); }
		public AsmLabelMultiContext(AsmLabelContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterAsmLabelMulti(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitAsmLabelMulti(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitAsmLabelMulti(this);
			else return visitor.visitChildren(this);
		}
	}

	public final AsmLabelContext asmLabel() throws RecognitionException {
		AsmLabelContext _localctx = new AsmLabelContext(_ctx, getState());
		enterRule(_localctx, 86, RULE_asmLabel);
		try {
			setState(838);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case ASM_NAME:
				_localctx = new AsmLabelNameContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(834);
				match(ASM_NAME);
				setState(835);
				match(ASM_COLON);
				}
				break;
			case ASM_MULTI_NAME:
				_localctx = new AsmLabelMultiContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(836);
				match(ASM_MULTI_NAME);
				setState(837);
				match(ASM_COLON);
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class AsmInstructionContext extends ParserRuleContext {
		public TerminalNode ASM_MNEMONIC() { return getToken(KickCParser.ASM_MNEMONIC, 0); }
		public AsmParamModeContext asmParamMode() {
			return getRuleContext(AsmParamModeContext.class,0);
		}
		public AsmInstructionContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_asmInstruction; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterAsmInstruction(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitAsmInstruction(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitAsmInstruction(this);
			else return visitor.visitChildren(this);
		}
	}

	public final AsmInstructionContext asmInstruction() throws RecognitionException {
		AsmInstructionContext _localctx = new AsmInstructionContext(_ctx, getState());
		enterRule(_localctx, 88, RULE_asmInstruction);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(840);
			match(ASM_MNEMONIC);
			setState(842);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,83,_ctx) ) {
			case 1:
				{
				setState(841);
				asmParamMode();
				}
				break;
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class AsmBytesContext extends ParserRuleContext {
		public TerminalNode ASM_BYTE() { return getToken(KickCParser.ASM_BYTE, 0); }
		public List<AsmExprContext> asmExpr() {
			return getRuleContexts(AsmExprContext.class);
		}
		public AsmExprContext asmExpr(int i) {
			return getRuleContext(AsmExprContext.class,i);
		}
		public List<TerminalNode> ASM_COMMA() { return getTokens(KickCParser.ASM_COMMA); }
		public TerminalNode ASM_COMMA(int i) {
			return getToken(KickCParser.ASM_COMMA, i);
		}
		public AsmBytesContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_asmBytes; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterAsmBytes(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitAsmBytes(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitAsmBytes(this);
			else return visitor.visitChildren(this);
		}
	}

	public final AsmBytesContext asmBytes() throws RecognitionException {
		AsmBytesContext _localctx = new AsmBytesContext(_ctx, getState());
		enterRule(_localctx, 90, RULE_asmBytes);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(844);
			match(ASM_BYTE);
			setState(845);
			asmExpr(0);
			setState(850);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==ASM_COMMA) {
				{
				{
				setState(846);
				match(ASM_COMMA);
				setState(847);
				asmExpr(0);
				}
				}
				setState(852);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class AsmParamModeContext extends ParserRuleContext {
		public AsmParamModeContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_asmParamMode; }
	 
		public AsmParamModeContext() { }
		public void copyFrom(AsmParamModeContext ctx) {
			super.copyFrom(ctx);
		}
	}
	public static class AsmModeImmContext extends AsmParamModeContext {
		public TerminalNode ASM_IMM() { return getToken(KickCParser.ASM_IMM, 0); }
		public AsmExprContext asmExpr() {
			return getRuleContext(AsmExprContext.class,0);
		}
		public AsmModeImmContext(AsmParamModeContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterAsmModeImm(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitAsmModeImm(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitAsmModeImm(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class AsmModeAbsXYContext extends AsmParamModeContext {
		public AsmExprContext asmExpr() {
			return getRuleContext(AsmExprContext.class,0);
		}
		public TerminalNode ASM_COMMA() { return getToken(KickCParser.ASM_COMMA, 0); }
		public TerminalNode ASM_NAME() { return getToken(KickCParser.ASM_NAME, 0); }
		public AsmModeAbsXYContext(AsmParamModeContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterAsmModeAbsXY(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitAsmModeAbsXY(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitAsmModeAbsXY(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class AsmModeIdxIndXYContext extends AsmParamModeContext {
		public TerminalNode ASM_PAR_BEGIN() { return getToken(KickCParser.ASM_PAR_BEGIN, 0); }
		public AsmExprContext asmExpr() {
			return getRuleContext(AsmExprContext.class,0);
		}
		public TerminalNode ASM_COMMA() { return getToken(KickCParser.ASM_COMMA, 0); }
		public TerminalNode ASM_NAME() { return getToken(KickCParser.ASM_NAME, 0); }
		public TerminalNode ASM_PAR_END() { return getToken(KickCParser.ASM_PAR_END, 0); }
		public AsmModeIdxIndXYContext(AsmParamModeContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterAsmModeIdxIndXY(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitAsmModeIdxIndXY(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitAsmModeIdxIndXY(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class AsmModeIndContext extends AsmParamModeContext {
		public TerminalNode ASM_PAR_BEGIN() { return getToken(KickCParser.ASM_PAR_BEGIN, 0); }
		public AsmExprContext asmExpr() {
			return getRuleContext(AsmExprContext.class,0);
		}
		public TerminalNode ASM_PAR_END() { return getToken(KickCParser.ASM_PAR_END, 0); }
		public AsmModeIndContext(AsmParamModeContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterAsmModeInd(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitAsmModeInd(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitAsmModeInd(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class AsmModeAbsContext extends AsmParamModeContext {
		public AsmExprContext asmExpr() {
			return getRuleContext(AsmExprContext.class,0);
		}
		public AsmModeAbsContext(AsmParamModeContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterAsmModeAbs(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitAsmModeAbs(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitAsmModeAbs(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class AsmModeIndIdxXYContext extends AsmParamModeContext {
		public TerminalNode ASM_PAR_BEGIN() { return getToken(KickCParser.ASM_PAR_BEGIN, 0); }
		public AsmExprContext asmExpr() {
			return getRuleContext(AsmExprContext.class,0);
		}
		public TerminalNode ASM_PAR_END() { return getToken(KickCParser.ASM_PAR_END, 0); }
		public TerminalNode ASM_COMMA() { return getToken(KickCParser.ASM_COMMA, 0); }
		public TerminalNode ASM_NAME() { return getToken(KickCParser.ASM_NAME, 0); }
		public AsmModeIndIdxXYContext(AsmParamModeContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterAsmModeIndIdxXY(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitAsmModeIndIdxXY(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitAsmModeIndIdxXY(this);
			else return visitor.visitChildren(this);
		}
	}

	public final AsmParamModeContext asmParamMode() throws RecognitionException {
		AsmParamModeContext _localctx = new AsmParamModeContext(_ctx, getState());
		enterRule(_localctx, 92, RULE_asmParamMode);
		try {
			setState(876);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,85,_ctx) ) {
			case 1:
				_localctx = new AsmModeAbsContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(853);
				asmExpr(0);
				}
				break;
			case 2:
				_localctx = new AsmModeImmContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(854);
				match(ASM_IMM);
				setState(855);
				asmExpr(0);
				}
				break;
			case 3:
				_localctx = new AsmModeAbsXYContext(_localctx);
				enterOuterAlt(_localctx, 3);
				{
				setState(856);
				asmExpr(0);
				setState(857);
				match(ASM_COMMA);
				setState(858);
				match(ASM_NAME);
				}
				break;
			case 4:
				_localctx = new AsmModeIndIdxXYContext(_localctx);
				enterOuterAlt(_localctx, 4);
				{
				setState(860);
				match(ASM_PAR_BEGIN);
				setState(861);
				asmExpr(0);
				setState(862);
				match(ASM_PAR_END);
				setState(863);
				match(ASM_COMMA);
				setState(864);
				match(ASM_NAME);
				}
				break;
			case 5:
				_localctx = new AsmModeIdxIndXYContext(_localctx);
				enterOuterAlt(_localctx, 5);
				{
				setState(866);
				match(ASM_PAR_BEGIN);
				setState(867);
				asmExpr(0);
				setState(868);
				match(ASM_COMMA);
				setState(869);
				match(ASM_NAME);
				setState(870);
				match(ASM_PAR_END);
				}
				break;
			case 6:
				_localctx = new AsmModeIndContext(_localctx);
				enterOuterAlt(_localctx, 6);
				{
				setState(872);
				match(ASM_PAR_BEGIN);
				setState(873);
				asmExpr(0);
				setState(874);
				match(ASM_PAR_END);
				}
				break;
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class AsmExprContext extends ParserRuleContext {
		public AsmExprContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_asmExpr; }
	 
		public AsmExprContext() { }
		public void copyFrom(AsmExprContext ctx) {
			super.copyFrom(ctx);
		}
	}
	public static class AsmExprReplaceContext extends AsmExprContext {
		public TerminalNode ASM_CURLY_BEGIN() { return getToken(KickCParser.ASM_CURLY_BEGIN, 0); }
		public TerminalNode ASM_NAME() { return getToken(KickCParser.ASM_NAME, 0); }
		public TerminalNode ASM_CURLY_END() { return getToken(KickCParser.ASM_CURLY_END, 0); }
		public AsmExprReplaceContext(AsmExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterAsmExprReplace(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitAsmExprReplace(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitAsmExprReplace(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class AsmExprLabelRelContext extends AsmExprContext {
		public TerminalNode ASM_MULTI_REL() { return getToken(KickCParser.ASM_MULTI_REL, 0); }
		public AsmExprLabelRelContext(AsmExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterAsmExprLabelRel(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitAsmExprLabelRel(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitAsmExprLabelRel(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class AsmExprParContext extends AsmExprContext {
		public TerminalNode ASM_BRACKET_BEGIN() { return getToken(KickCParser.ASM_BRACKET_BEGIN, 0); }
		public AsmExprContext asmExpr() {
			return getRuleContext(AsmExprContext.class,0);
		}
		public TerminalNode ASM_BRACKET_END() { return getToken(KickCParser.ASM_BRACKET_END, 0); }
		public AsmExprParContext(AsmExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterAsmExprPar(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitAsmExprPar(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitAsmExprPar(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class AsmExprBinaryContext extends AsmExprContext {
		public List<AsmExprContext> asmExpr() {
			return getRuleContexts(AsmExprContext.class);
		}
		public AsmExprContext asmExpr(int i) {
			return getRuleContext(AsmExprContext.class,i);
		}
		public TerminalNode ASM_DOT() { return getToken(KickCParser.ASM_DOT, 0); }
		public TerminalNode ASM_SHIFT_LEFT() { return getToken(KickCParser.ASM_SHIFT_LEFT, 0); }
		public TerminalNode ASM_SHIFT_RIGHT() { return getToken(KickCParser.ASM_SHIFT_RIGHT, 0); }
		public TerminalNode ASM_MULTIPLY() { return getToken(KickCParser.ASM_MULTIPLY, 0); }
		public TerminalNode ASM_DIVIDE() { return getToken(KickCParser.ASM_DIVIDE, 0); }
		public TerminalNode ASM_PLUS() { return getToken(KickCParser.ASM_PLUS, 0); }
		public TerminalNode ASM_MINUS() { return getToken(KickCParser.ASM_MINUS, 0); }
		public AsmExprBinaryContext(AsmExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterAsmExprBinary(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitAsmExprBinary(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitAsmExprBinary(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class AsmExprLabelContext extends AsmExprContext {
		public TerminalNode ASM_NAME() { return getToken(KickCParser.ASM_NAME, 0); }
		public AsmExprLabelContext(AsmExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterAsmExprLabel(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitAsmExprLabel(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitAsmExprLabel(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class AsmExprIntContext extends AsmExprContext {
		public TerminalNode ASM_NUMBER() { return getToken(KickCParser.ASM_NUMBER, 0); }
		public AsmExprIntContext(AsmExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterAsmExprInt(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitAsmExprInt(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitAsmExprInt(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class AsmExprUnaryContext extends AsmExprContext {
		public AsmExprContext asmExpr() {
			return getRuleContext(AsmExprContext.class,0);
		}
		public TerminalNode ASM_PLUS() { return getToken(KickCParser.ASM_PLUS, 0); }
		public TerminalNode ASM_MINUS() { return getToken(KickCParser.ASM_MINUS, 0); }
		public TerminalNode ASM_LESS_THAN() { return getToken(KickCParser.ASM_LESS_THAN, 0); }
		public TerminalNode ASM_GREATER_THAN() { return getToken(KickCParser.ASM_GREATER_THAN, 0); }
		public AsmExprUnaryContext(AsmExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterAsmExprUnary(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitAsmExprUnary(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitAsmExprUnary(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class AsmExprCharContext extends AsmExprContext {
		public TerminalNode ASM_CHAR() { return getToken(KickCParser.ASM_CHAR, 0); }
		public AsmExprCharContext(AsmExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterAsmExprChar(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitAsmExprChar(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitAsmExprChar(this);
			else return visitor.visitChildren(this);
		}
	}

	public final AsmExprContext asmExpr() throws RecognitionException {
		return asmExpr(0);
	}

	private AsmExprContext asmExpr(int _p) throws RecognitionException {
		ParserRuleContext _parentctx = _ctx;
		int _parentState = getState();
		AsmExprContext _localctx = new AsmExprContext(_ctx, _parentState);
		AsmExprContext _prevctx = _localctx;
		int _startState = 94;
		enterRecursionRule(_localctx, 94, RULE_asmExpr, _p);
		int _la;
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(892);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case ASM_BRACKET_BEGIN:
				{
				_localctx = new AsmExprParContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;

				setState(879);
				match(ASM_BRACKET_BEGIN);
				setState(880);
				asmExpr(0);
				setState(881);
				match(ASM_BRACKET_END);
				}
				break;
			case ASM_PLUS:
			case ASM_MINUS:
			case ASM_LESS_THAN:
			case ASM_GREATER_THAN:
				{
				_localctx = new AsmExprUnaryContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(883);
				_la = _input.LA(1);
				if ( !(((((_la - 136)) & ~0x3f) == 0 && ((1L << (_la - 136)) & ((1L << (ASM_PLUS - 136)) | (1L << (ASM_MINUS - 136)) | (1L << (ASM_LESS_THAN - 136)) | (1L << (ASM_GREATER_THAN - 136)))) != 0)) ) {
				_errHandler.recoverInline(this);
				}
				else {
					if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
					_errHandler.reportMatch(this);
					consume();
				}
				setState(884);
				asmExpr(8);
				}
				break;
			case ASM_NAME:
				{
				_localctx = new AsmExprLabelContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(885);
				match(ASM_NAME);
				}
				break;
			case ASM_MULTI_REL:
				{
				_localctx = new AsmExprLabelRelContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(886);
				match(ASM_MULTI_REL);
				}
				break;
			case ASM_CURLY_BEGIN:
				{
				_localctx = new AsmExprReplaceContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(887);
				match(ASM_CURLY_BEGIN);
				setState(888);
				match(ASM_NAME);
				setState(889);
				match(ASM_CURLY_END);
				}
				break;
			case ASM_NUMBER:
				{
				_localctx = new AsmExprIntContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(890);
				match(ASM_NUMBER);
				}
				break;
			case ASM_CHAR:
				{
				_localctx = new AsmExprCharContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(891);
				match(ASM_CHAR);
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
			_ctx.stop = _input.LT(-1);
			setState(908);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,88,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					setState(906);
					_errHandler.sync(this);
					switch ( getInterpreter().adaptivePredict(_input,87,_ctx) ) {
					case 1:
						{
						_localctx = new AsmExprBinaryContext(new AsmExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_asmExpr);
						setState(894);
						if (!(precpred(_ctx, 10))) throw new FailedPredicateException(this, "precpred(_ctx, 10)");
						{
						setState(895);
						match(ASM_DOT);
						}
						setState(896);
						asmExpr(11);
						}
						break;
					case 2:
						{
						_localctx = new AsmExprBinaryContext(new AsmExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_asmExpr);
						setState(897);
						if (!(precpred(_ctx, 9))) throw new FailedPredicateException(this, "precpred(_ctx, 9)");
						setState(898);
						_la = _input.LA(1);
						if ( !(_la==ASM_SHIFT_LEFT || _la==ASM_SHIFT_RIGHT) ) {
						_errHandler.recoverInline(this);
						}
						else {
							if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
							_errHandler.reportMatch(this);
							consume();
						}
						setState(899);
						asmExpr(10);
						}
						break;
					case 3:
						{
						_localctx = new AsmExprBinaryContext(new AsmExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_asmExpr);
						setState(900);
						if (!(precpred(_ctx, 7))) throw new FailedPredicateException(this, "precpred(_ctx, 7)");
						setState(901);
						_la = _input.LA(1);
						if ( !(_la==ASM_MULTIPLY || _la==ASM_DIVIDE) ) {
						_errHandler.recoverInline(this);
						}
						else {
							if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
							_errHandler.reportMatch(this);
							consume();
						}
						setState(902);
						asmExpr(8);
						}
						break;
					case 4:
						{
						_localctx = new AsmExprBinaryContext(new AsmExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_asmExpr);
						setState(903);
						if (!(precpred(_ctx, 6))) throw new FailedPredicateException(this, "precpred(_ctx, 6)");
						setState(904);
						_la = _input.LA(1);
						if ( !(_la==ASM_PLUS || _la==ASM_MINUS) ) {
						_errHandler.recoverInline(this);
						}
						else {
							if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
							_errHandler.reportMatch(this);
							consume();
						}
						setState(905);
						asmExpr(7);
						}
						break;
					}
					} 
				}
				setState(910);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,88,_ctx);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			unrollRecursionContexts(_parentctx);
		}
		return _localctx;
	}

	public boolean sempred(RuleContext _localctx, int ruleIndex, int predIndex) {
		switch (ruleIndex) {
		case 7:
			return declVariableList_sempred((DeclVariableListContext)_localctx, predIndex);
		case 13:
			return typeSpecifier_sempred((TypeSpecifierContext)_localctx, predIndex);
		case 14:
			return type_sempred((TypeContext)_localctx, predIndex);
		case 20:
			return enumMemberList_sempred((EnumMemberListContext)_localctx, predIndex);
		case 35:
			return commaExpr_sempred((CommaExprContext)_localctx, predIndex);
		case 36:
			return expr_sempred((ExprContext)_localctx, predIndex);
		case 47:
			return asmExpr_sempred((AsmExprContext)_localctx, predIndex);
		}
		return true;
	}
	private boolean declVariableList_sempred(DeclVariableListContext _localctx, int predIndex) {
		switch (predIndex) {
		case 0:
			return precpred(_ctx, 1);
		}
		return true;
	}
	private boolean typeSpecifier_sempred(TypeSpecifierContext _localctx, int predIndex) {
		switch (predIndex) {
		case 1:
			return precpred(_ctx, 2);
		case 2:
			return precpred(_ctx, 1);
		}
		return true;
	}
	private boolean type_sempred(TypeContext _localctx, int predIndex) {
		switch (predIndex) {
		case 3:
			return precpred(_ctx, 7);
		case 4:
			return precpred(_ctx, 6);
		}
		return true;
	}
	private boolean enumMemberList_sempred(EnumMemberListContext _localctx, int predIndex) {
		switch (predIndex) {
		case 5:
			return precpred(_ctx, 1);
		}
		return true;
	}
	private boolean commaExpr_sempred(CommaExprContext _localctx, int predIndex) {
		switch (predIndex) {
		case 6:
			return precpred(_ctx, 1);
		}
		return true;
	}
	private boolean expr_sempred(ExprContext _localctx, int predIndex) {
		switch (predIndex) {
		case 7:
			return precpred(_ctx, 19);
		case 8:
			return precpred(_ctx, 18);
		case 9:
			return precpred(_ctx, 17);
		case 10:
			return precpred(_ctx, 15);
		case 11:
			return precpred(_ctx, 14);
		case 12:
			return precpred(_ctx, 13);
		case 13:
			return precpred(_ctx, 12);
		case 14:
			return precpred(_ctx, 11);
		case 15:
			return precpred(_ctx, 10);
		case 16:
			return precpred(_ctx, 9);
		case 17:
			return precpred(_ctx, 8);
		case 18:
			return precpred(_ctx, 7);
		case 19:
			return precpred(_ctx, 31);
		case 20:
			return precpred(_ctx, 30);
		case 21:
			return precpred(_ctx, 29);
		case 22:
			return precpred(_ctx, 25);
		case 23:
			return precpred(_ctx, 22);
		}
		return true;
	}
	private boolean asmExpr_sempred(AsmExprContext _localctx, int predIndex) {
		switch (predIndex) {
		case 24:
			return precpred(_ctx, 10);
		case 25:
			return precpred(_ctx, 9);
		case 26:
			return precpred(_ctx, 7);
		case 27:
			return precpred(_ctx, 6);
		}
		return true;
	}

	public static final String _serializedATN =
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\3\u00a6\u0392\4\2\t"+
		"\2\4\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n\t\n\4\13"+
		"\t\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\4\20\t\20\4\21\t\21\4\22\t\22"+
		"\4\23\t\23\4\24\t\24\4\25\t\25\4\26\t\26\4\27\t\27\4\30\t\30\4\31\t\31"+
		"\4\32\t\32\4\33\t\33\4\34\t\34\4\35\t\35\4\36\t\36\4\37\t\37\4 \t \4!"+
		"\t!\4\"\t\"\4#\t#\4$\t$\4%\t%\4&\t&\4\'\t\'\4(\t(\4)\t)\4*\t*\4+\t+\4"+
		",\t,\4-\t-\4.\t.\4/\t/\4\60\t\60\4\61\t\61\3\2\3\2\3\2\3\3\3\3\3\3\3\4"+
		"\7\4j\n\4\f\4\16\4m\13\4\3\5\3\5\5\5q\n\5\3\6\3\6\3\6\3\6\3\6\3\6\5\6"+
		"y\n\6\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\5\7"+
		"\u008a\n\7\3\b\3\b\3\b\3\t\3\t\7\t\u0091\n\t\f\t\16\t\u0094\13\t\3\t\3"+
		"\t\3\t\3\t\3\t\7\t\u009b\n\t\f\t\16\t\u009e\13\t\3\t\7\t\u00a1\n\t\f\t"+
		"\16\t\u00a4\13\t\3\n\3\n\3\n\7\n\u00a9\n\n\f\n\16\n\u00ac\13\n\3\n\3\n"+
		"\7\n\u00b0\n\n\f\n\16\n\u00b3\13\n\3\n\3\n\3\13\3\13\7\13\u00b9\n\13\f"+
		"\13\16\13\u00bc\13\13\3\13\3\13\5\13\u00c0\n\13\3\13\3\13\7\13\u00c4\n"+
		"\13\f\13\16\13\u00c7\13\13\3\13\3\13\5\13\u00cb\n\13\3\f\7\f\u00ce\n\f"+
		"\f\f\16\f\u00d1\13\f\3\f\3\f\7\f\u00d5\n\f\f\f\16\f\u00d8\13\f\3\r\3\r"+
		"\7\r\u00dc\n\r\f\r\16\r\u00df\13\r\3\16\3\16\5\16\u00e3\n\16\3\16\3\16"+
		"\3\17\3\17\3\17\3\17\3\17\3\17\3\17\3\17\5\17\u00ef\n\17\3\17\7\17\u00f2"+
		"\n\17\f\17\16\17\u00f5\13\17\3\20\3\20\3\20\3\20\3\20\3\20\3\20\3\20\5"+
		"\20\u00ff\n\20\3\20\3\20\3\20\3\20\3\20\5\20\u0106\n\20\3\20\3\20\3\20"+
		"\5\20\u010b\n\20\3\20\3\20\3\20\3\20\7\20\u0111\n\20\f\20\16\20\u0114"+
		"\13\20\3\21\3\21\3\21\3\22\3\22\5\22\u011b\n\22\3\22\3\22\6\22\u011f\n"+
		"\22\r\22\16\22\u0120\3\22\3\22\3\23\3\23\3\23\3\24\3\24\3\24\3\25\3\25"+
		"\5\25\u012d\n\25\3\25\3\25\3\25\3\25\3\26\3\26\3\26\3\26\3\26\3\26\7\26"+
		"\u0139\n\26\f\26\16\26\u013c\13\26\3\27\3\27\3\27\5\27\u0141\n\27\3\30"+
		"\3\30\7\30\u0145\n\30\f\30\16\30\u0148\13\30\3\30\3\30\3\30\5\30\u014d"+
		"\n\30\3\30\3\30\3\30\5\30\u0152\n\30\3\31\3\31\5\31\u0156\n\31\3\31\3"+
		"\31\3\32\3\32\3\32\7\32\u015d\n\32\f\32\16\32\u0160\13\32\3\33\3\33\7"+
		"\33\u0164\n\33\f\33\16\33\u0167\13\33\3\33\3\33\3\33\3\33\5\33\u016d\n"+
		"\33\3\34\3\34\3\34\3\34\3\34\3\34\3\34\3\34\3\34\3\34\3\34\3\34\3\34\3"+
		"\34\3\34\3\34\3\34\3\34\3\34\3\34\3\34\3\34\3\34\3\34\3\34\3\34\3\34\3"+
		"\34\3\34\3\34\3\34\3\34\3\34\3\34\3\34\3\34\3\34\7\34\u0194\n\34\f\34"+
		"\16\34\u0197\13\34\3\34\3\34\3\34\3\34\3\34\3\34\3\34\3\34\3\34\3\34\3"+
		"\34\3\34\3\34\3\34\3\34\3\34\3\34\3\34\3\34\3\34\3\34\3\34\3\34\3\34\3"+
		"\34\3\34\3\34\3\34\3\34\3\34\3\34\3\34\3\34\3\34\3\34\3\34\3\34\3\34\3"+
		"\34\7\34\u01c0\n\34\f\34\16\34\u01c3\13\34\3\34\5\34\u01c6\n\34\3\35\3"+
		"\35\3\35\5\35\u01cb\n\35\3\36\3\36\3\36\3\36\3\36\3\36\3\36\3\36\3\36"+
		"\5\36\u01d6\n\36\3\36\3\36\3\36\3\36\3\36\3\36\3\36\3\36\3\36\3\36\3\36"+
		"\3\36\3\36\3\36\3\36\3\36\3\36\3\36\5\36\u01ea\n\36\3\36\3\36\3\36\3\36"+
		"\3\36\7\36\u01f1\n\36\f\36\16\36\u01f4\13\36\3\36\3\36\3\36\5\36\u01f9"+
		"\n\36\3\37\6\37\u01fc\n\37\r\37\16\37\u01fd\3 \3 \3 \3 \3 \5 \u0205\n"+
		" \3 \3 \3 \3 \3 \3 \3 \3 \3 \3 \3 \5 \u0212\n \3 \7 \u0215\n \f \16 \u0218"+
		"\13 \3 \3 \3 \3 \3 \3 \3 \7 \u0221\n \f \16 \u0224\13 \3 \3 \3 \3 \3 "+
		"\3 \3 \3 \3 \7 \u022f\n \f \16 \u0232\13 \3 \3 \3 \3 \3 \3 \3 \3 \3 \3"+
		" \3 \3 \3 \3 \3 \3 \5 \u0244\n \3 \3 \3 \3 \3 \3 \3 \5 \u024d\n \3 \3"+
		" \3 \3 \3 \5 \u0254\n \3!\6!\u0257\n!\r!\16!\u0258\3!\3!\3!\5!\u025e\n"+
		"!\5!\u0260\n!\3\"\3\"\3\"\3\"\5\"\u0266\n\"\3#\3#\3#\3#\3#\5#\u026d\n"+
		"#\3#\3#\7#\u0271\n#\f#\16#\u0274\13#\5#\u0276\n#\3#\3#\3#\3#\3#\3#\5#"+
		"\u027e\n#\3$\5$\u0281\n$\3$\5$\u0284\n$\3%\3%\3%\3%\3%\3%\7%\u028c\n%"+
		"\f%\16%\u028f\13%\3&\3&\3&\3&\3&\3&\3&\3&\3&\5&\u029a\n&\3&\3&\3&\3&\3"+
		"&\3&\5&\u02a2\n&\3&\3&\3&\3&\5&\u02a8\n&\3&\3&\5&\u02ac\n&\3&\3&\3&\3"+
		"&\3&\3&\3&\3&\3&\3&\3&\3&\3&\3&\3&\3&\3&\7&\u02bf\n&\f&\16&\u02c2\13&"+
		"\3&\3&\3&\3&\3&\6&\u02c9\n&\r&\16&\u02ca\3&\3&\5&\u02cf\n&\3&\3&\3&\3"+
		"&\3&\3&\3&\3&\3&\3&\3&\3&\3&\3&\3&\3&\3&\3&\3&\3&\3&\3&\3&\3&\3&\3&\3"+
		"&\3&\3&\3&\3&\3&\3&\3&\3&\3&\3&\3&\3&\3&\3&\3&\3&\3&\3&\3&\3&\3&\5&\u0301"+
		"\n&\3&\3&\3&\3&\3&\3&\3&\3&\7&\u030b\n&\f&\16&\u030e\13&\3\'\3\'\3\'\7"+
		"\'\u0313\n\'\f\'\16\'\u0316\13\'\3(\3(\5(\u031a\n(\3(\3(\3)\3)\3)\3)\7"+
		")\u0322\n)\f)\16)\u0325\13)\3)\3)\3*\3*\3*\3*\3*\3*\3*\3*\3*\3*\3*\3*"+
		"\3*\5*\u0336\n*\5*\u0338\n*\3+\7+\u033b\n+\f+\16+\u033e\13+\3,\3,\3,\5"+
		",\u0343\n,\3-\3-\3-\3-\5-\u0349\n-\3.\3.\5.\u034d\n.\3/\3/\3/\3/\7/\u0353"+
		"\n/\f/\16/\u0356\13/\3\60\3\60\3\60\3\60\3\60\3\60\3\60\3\60\3\60\3\60"+
		"\3\60\3\60\3\60\3\60\3\60\3\60\3\60\3\60\3\60\3\60\3\60\3\60\3\60\5\60"+
		"\u036f\n\60\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61"+
		"\3\61\3\61\5\61\u037f\n\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61"+
		"\3\61\3\61\3\61\7\61\u038d\n\61\f\61\16\61\u0390\13\61\3\61\2\t\20\34"+
		"\36*HJ`\62\2\4\6\b\n\f\16\20\22\24\26\30\32\34\36 \"$&(*,.\60\62\64\66"+
		"8:<>@BDFHJLNPRTVXZ\\^`\2\r\3\2\27\30\5\2\22\23\31\32^^\4\2!!$$\3\2\35"+
		"\36\3\2\24\26\3\2\22\23\3\2\37$\3\2\u008a\u008d\3\2\u0088\u0089\3\2\u008e"+
		"\u008f\3\2\u008a\u008b\2\u0417\2b\3\2\2\2\4e\3\2\2\2\6k\3\2\2\2\bp\3\2"+
		"\2\2\nx\3\2\2\2\f\u0089\3\2\2\2\16\u008b\3\2\2\2\20\u008e\3\2\2\2\22\u00a5"+
		"\3\2\2\2\24\u00ca\3\2\2\2\26\u00cf\3\2\2\2\30\u00d9\3\2\2\2\32\u00e0\3"+
		"\2\2\2\34\u00e6\3\2\2\2\36\u0105\3\2\2\2 \u0115\3\2\2\2\"\u0118\3\2\2"+
		"\2$\u0124\3\2\2\2&\u0127\3\2\2\2(\u012a\3\2\2\2*\u0132\3\2\2\2,\u013d"+
		"\3\2\2\2.\u0142\3\2\2\2\60\u0153\3\2\2\2\62\u0159\3\2\2\2\64\u016c\3\2"+
		"\2\2\66\u01c5\3\2\2\28\u01c7\3\2\2\2:\u01f8\3\2\2\2<\u01fb\3\2\2\2>\u0253"+
		"\3\2\2\2@\u0256\3\2\2\2B\u0261\3\2\2\2D\u027d\3\2\2\2F\u0283\3\2\2\2H"+
		"\u0285\3\2\2\2J\u02ce\3\2\2\2L\u030f\3\2\2\2N\u0317\3\2\2\2P\u031d\3\2"+
		"\2\2R\u0337\3\2\2\2T\u033c\3\2\2\2V\u0342\3\2\2\2X\u0348\3\2\2\2Z\u034a"+
		"\3\2\2\2\\\u034e\3\2\2\2^\u036e\3\2\2\2`\u037e\3\2\2\2bc\5\6\4\2cd\7\2"+
		"\2\3d\3\3\2\2\2ef\5T+\2fg\7\2\2\3g\5\3\2\2\2hj\5\b\5\2ih\3\2\2\2jm\3\2"+
		"\2\2ki\3\2\2\2kl\3\2\2\2l\7\3\2\2\2mk\3\2\2\2nq\5\f\7\2oq\5\n\6\2pn\3"+
		"\2\2\2po\3\2\2\2q\t\3\2\2\2rs\7c\2\2sy\7\u00a3\2\2tu\7d\2\2uy\7\u00a3"+
		"\2\2vw\7d\2\2wy\7\u00a2\2\2xr\3\2\2\2xt\3\2\2\2xv\3\2\2\2y\13\3\2\2\2"+
		"z{\5\16\b\2{|\7\n\2\2|\u008a\3\2\2\2}~\5\"\22\2~\177\7\n\2\2\177\u008a"+
		"\3\2\2\2\u0080\u0081\5(\25\2\u0081\u0082\7\n\2\2\u0082\u008a\3\2\2\2\u0083"+
		"\u008a\5.\30\2\u0084\u008a\5N(\2\u0085\u008a\5\66\34\2\u0086\u0087\5\22"+
		"\n\2\u0087\u0088\7\n\2\2\u0088\u008a\3\2\2\2\u0089z\3\2\2\2\u0089}\3\2"+
		"\2\2\u0089\u0080\3\2\2\2\u0089\u0083\3\2\2\2\u0089\u0084\3\2\2\2\u0089"+
		"\u0085\3\2\2\2\u0089\u0086\3\2\2\2\u008a\r\3\2\2\2\u008b\u008c\5\26\f"+
		"\2\u008c\u008d\5\20\t\2\u008d\17\3\2\2\2\u008e\u0092\b\t\1\2\u008f\u0091"+
		"\5\30\r\2\u0090\u008f\3\2\2\2\u0091\u0094\3\2\2\2\u0092\u0090\3\2\2\2"+
		"\u0092\u0093\3\2\2\2\u0093\u0095\3\2\2\2\u0094\u0092\3\2\2\2\u0095\u0096"+
		"\5\24\13\2\u0096\u00a2\3\2\2\2\u0097\u0098\f\3\2\2\u0098\u009c\7\f\2\2"+
		"\u0099\u009b\5\30\r\2\u009a\u0099\3\2\2\2\u009b\u009e\3\2\2\2\u009c\u009a"+
		"\3\2\2\2\u009c\u009d\3\2\2\2\u009d\u009f\3\2\2\2\u009e\u009c\3\2\2\2\u009f"+
		"\u00a1\5\24\13\2\u00a0\u0097\3\2\2\2\u00a1\u00a4\3\2\2\2\u00a2\u00a0\3"+
		"\2\2\2\u00a2\u00a3\3\2\2\2\u00a3\21\3\2\2\2\u00a4\u00a2\3\2\2\2\u00a5"+
		"\u00a6\7)\2\2\u00a6\u00aa\5\26\f\2\u00a7\u00a9\5\30\r\2\u00a8\u00a7\3"+
		"\2\2\2\u00a9\u00ac\3\2\2\2\u00aa\u00a8\3\2\2\2\u00aa\u00ab\3\2\2\2\u00ab"+
		"\u00ad\3\2\2\2\u00ac\u00aa\3\2\2\2\u00ad\u00b1\7x\2\2\u00ae\u00b0\5\32"+
		"\16\2\u00af\u00ae\3\2\2\2\u00b0\u00b3\3\2\2\2\u00b1\u00af\3\2\2\2\u00b1"+
		"\u00b2\3\2\2\2\u00b2\u00b4\3\2\2\2\u00b3\u00b1\3\2\2\2\u00b4\u00b5\b\n"+
		"\1\2\u00b5\23\3\2\2\2\u00b6\u00ba\7x\2\2\u00b7\u00b9\5\32\16\2\u00b8\u00b7"+
		"\3\2\2\2\u00b9\u00bc\3\2\2\2\u00ba\u00b8\3\2\2\2\u00ba\u00bb\3\2\2\2\u00bb"+
		"\u00bf\3\2\2\2\u00bc\u00ba\3\2\2\2\u00bd\u00be\7\'\2\2\u00be\u00c0\5J"+
		"&\2\u00bf\u00bd\3\2\2\2\u00bf\u00c0\3\2\2\2\u00c0\u00cb\3\2\2\2\u00c1"+
		"\u00c5\7x\2\2\u00c2\u00c4\5\32\16\2\u00c3\u00c2\3\2\2\2\u00c4\u00c7\3"+
		"\2\2\2\u00c5\u00c3\3\2\2\2\u00c5\u00c6\3\2\2\2\u00c6\u00c8\3\2\2\2\u00c7"+
		"\u00c5\3\2\2\2\u00c8\u00c9\7\'\2\2\u00c9\u00cb\5N(\2\u00ca\u00b6\3\2\2"+
		"\2\u00ca\u00c1\3\2\2\2\u00cb\25\3\2\2\2\u00cc\u00ce\5:\36\2\u00cd\u00cc"+
		"\3\2\2\2\u00ce\u00d1\3\2\2\2\u00cf\u00cd\3\2\2\2\u00cf\u00d0\3\2\2\2\u00d0"+
		"\u00d2\3\2\2\2\u00d1\u00cf\3\2\2\2\u00d2\u00d6\5\36\20\2\u00d3\u00d5\5"+
		":\36\2\u00d4\u00d3\3\2\2\2\u00d5\u00d8\3\2\2\2\u00d6\u00d4\3\2\2\2\u00d6"+
		"\u00d7\3\2\2\2\u00d7\27\3\2\2\2\u00d8\u00d6\3\2\2\2\u00d9\u00dd\7\24\2"+
		"\2\u00da\u00dc\5:\36\2\u00db\u00da\3\2\2\2\u00dc\u00df\3\2\2\2\u00dd\u00db"+
		"\3\2\2\2\u00dd\u00de\3\2\2\2\u00de\31\3\2\2\2\u00df\u00dd\3\2\2\2\u00e0"+
		"\u00e2\7\6\2\2\u00e1\u00e3\5J&\2\u00e2\u00e1\3\2\2\2\u00e2\u00e3\3\2\2"+
		"\2\u00e3\u00e4\3\2\2\2\u00e4\u00e5\7\7\2\2\u00e5\33\3\2\2\2\u00e6\u00e7"+
		"\b\17\1\2\u00e7\u00e8\5\36\20\2\u00e8\u00f3\3\2\2\2\u00e9\u00ea\f\4\2"+
		"\2\u00ea\u00f2\7\24\2\2\u00eb\u00ec\f\3\2\2\u00ec\u00ee\7\6\2\2\u00ed"+
		"\u00ef\5J&\2\u00ee\u00ed\3\2\2\2\u00ee\u00ef\3\2\2\2\u00ef\u00f0\3\2\2"+
		"\2\u00f0\u00f2\7\7\2\2\u00f1\u00e9\3\2\2\2\u00f1\u00eb\3\2\2\2\u00f2\u00f5"+
		"\3\2\2\2\u00f3\u00f1\3\2\2\2\u00f3\u00f4\3\2\2\2\u00f4\35\3\2\2\2\u00f5"+
		"\u00f3\3\2\2\2\u00f6\u00f7\b\20\1\2\u00f7\u00f8\7\b\2\2\u00f8\u00f9\5"+
		"\36\20\2\u00f9\u00fa\7\t\2\2\u00fa\u0106\3\2\2\2\u00fb\u0106\7`\2\2\u00fc"+
		"\u00fe\7_\2\2\u00fd\u00ff\7`\2\2\u00fe\u00fd\3\2\2\2\u00fe\u00ff\3\2\2"+
		"\2\u00ff\u0106\3\2\2\2\u0100\u0106\5\"\22\2\u0101\u0106\5 \21\2\u0102"+
		"\u0106\5(\25\2\u0103\u0106\5&\24\2\u0104\u0106\7\3\2\2\u0105\u00f6\3\2"+
		"\2\2\u0105\u00fb\3\2\2\2\u0105\u00fc\3\2\2\2\u0105\u0100\3\2\2\2\u0105"+
		"\u0101\3\2\2\2\u0105\u0102\3\2\2\2\u0105\u0103\3\2\2\2\u0105\u0104\3\2"+
		"\2\2\u0106\u0112\3\2\2\2\u0107\u0108\f\t\2\2\u0108\u010a\7\6\2\2\u0109"+
		"\u010b\5J&\2\u010a\u0109\3\2\2\2\u010a\u010b\3\2\2\2\u010b\u010c\3\2\2"+
		"\2\u010c\u0111\7\7\2\2\u010d\u010e\f\b\2\2\u010e\u010f\7\b\2\2\u010f\u0111"+
		"\7\t\2\2\u0110\u0107\3\2\2\2\u0110\u010d\3\2\2\2\u0111\u0114\3\2\2\2\u0112"+
		"\u0110\3\2\2\2\u0112\u0113\3\2\2\2\u0113\37\3\2\2\2\u0114\u0112\3\2\2"+
		"\2\u0115\u0116\7S\2\2\u0116\u0117\7x\2\2\u0117!\3\2\2\2\u0118\u011a\7"+
		"S\2\2\u0119\u011b\7x\2\2\u011a\u0119\3\2\2\2\u011a\u011b\3\2\2\2\u011b"+
		"\u011c\3\2\2\2\u011c\u011e\7\4\2\2\u011d\u011f\5$\23\2\u011e\u011d\3\2"+
		"\2\2\u011f\u0120\3\2\2\2\u0120\u011e\3\2\2\2\u0120\u0121\3\2\2\2\u0121"+
		"\u0122\3\2\2\2\u0122\u0123\7\5\2\2\u0123#\3\2\2\2\u0124\u0125\5\16\b\2"+
		"\u0125\u0126\7\n\2\2\u0126%\3\2\2\2\u0127\u0128\7T\2\2\u0128\u0129\7x"+
		"\2\2\u0129\'\3\2\2\2\u012a\u012c\7T\2\2\u012b\u012d\7x\2\2\u012c\u012b"+
		"\3\2\2\2\u012c\u012d\3\2\2\2\u012d\u012e\3\2\2\2\u012e\u012f\7\4\2\2\u012f"+
		"\u0130\5*\26\2\u0130\u0131\7\5\2\2\u0131)\3\2\2\2\u0132\u0133\b\26\1\2"+
		"\u0133\u0134\5,\27\2\u0134\u013a\3\2\2\2\u0135\u0136\f\3\2\2\u0136\u0137"+
		"\7\f\2\2\u0137\u0139\5,\27\2\u0138\u0135\3\2\2\2\u0139\u013c\3\2\2\2\u013a"+
		"\u0138\3\2\2\2\u013a\u013b\3\2\2\2\u013b+\3\2\2\2\u013c\u013a\3\2\2\2"+
		"\u013d\u0140\7x\2\2\u013e\u013f\7\'\2\2\u013f\u0141\5J&\2\u0140\u013e"+
		"\3\2\2\2\u0140\u0141\3\2\2\2\u0141-\3\2\2\2\u0142\u0146\5\26\f\2\u0143"+
		"\u0145\5\30\r\2\u0144\u0143\3\2\2\2\u0145\u0148\3\2\2\2\u0146\u0144\3"+
		"\2\2\2\u0146\u0147\3\2\2\2\u0147\u0149\3\2\2\2\u0148\u0146\3\2\2\2\u0149"+
		"\u014a\7x\2\2\u014a\u014c\7\b\2\2\u014b\u014d\5\62\32\2\u014c\u014b\3"+
		"\2\2\2\u014c\u014d\3\2\2\2\u014d\u014e\3\2\2\2\u014e\u0151\7\t\2\2\u014f"+
		"\u0152\5\60\31\2\u0150\u0152\7\n\2\2\u0151\u014f\3\2\2\2\u0151\u0150\3"+
		"\2\2\2\u0152/\3\2\2\2\u0153\u0155\7\4\2\2\u0154\u0156\5<\37\2\u0155\u0154"+
		"\3\2\2\2\u0155\u0156\3\2\2\2\u0156\u0157\3\2\2\2\u0157\u0158\7\5\2\2\u0158"+
		"\61\3\2\2\2\u0159\u015e\5\64\33\2\u015a\u015b\7\f\2\2\u015b\u015d\5\64"+
		"\33\2\u015c\u015a\3\2\2\2\u015d\u0160\3\2\2\2\u015e\u015c\3\2\2\2\u015e"+
		"\u015f\3\2\2\2\u015f\63\3\2\2\2\u0160\u015e\3\2\2\2\u0161\u0165\5\26\f"+
		"\2\u0162\u0164\5\30\r\2\u0163\u0162\3\2\2\2\u0164\u0167\3\2\2\2\u0165"+
		"\u0163\3\2\2\2\u0165\u0166\3\2\2\2\u0166\u0168\3\2\2\2\u0167\u0165\3\2"+
		"\2\2\u0168\u0169\7x\2\2\u0169\u016d\3\2\2\2\u016a\u016d\7`\2\2\u016b\u016d"+
		"\7\16\2\2\u016c\u0161\3\2\2\2\u016c\u016a\3\2\2\2\u016c\u016b\3\2\2\2"+
		"\u016d\65\3\2\2\2\u016e\u016f\7e\2\2\u016f\u0170\7,\2\2\u0170\u0171\3"+
		"\2\2\2\u0171\u0172\7\b\2\2\u0172\u0173\7x\2\2\u0173\u01c6\7\t\2\2\u0174"+
		"\u0175\7e\2\2\u0175\u0176\7\60\2\2\u0176\u0177\3\2\2\2\u0177\u0178\7\b"+
		"\2\2\u0178\u0179\7x\2\2\u0179\u01c6\7\t\2\2\u017a\u017b\7e\2\2\u017b\u017c"+
		"\7-\2\2\u017c\u017d\3\2\2\2\u017d\u017e\7\b\2\2\u017e\u017f\7y\2\2\u017f"+
		"\u01c6\7\t\2\2\u0180\u0181\7e\2\2\u0181\u0182\7.\2\2\u0182\u0183\3\2\2"+
		"\2\u0183\u0184\7\b\2\2\u0184\u0185\7y\2\2\u0185\u01c6\7\t\2\2\u0186\u0187"+
		"\7e\2\2\u0187\u0188\7/\2\2\u0188\u0189\3\2\2\2\u0189\u018a\7\b\2\2\u018a"+
		"\u018b\7y\2\2\u018b\u01c6\7\t\2\2\u018c\u018d\7e\2\2\u018d\u018e\7*\2"+
		"\2\u018e\u018f\3\2\2\2\u018f\u0190\7\b\2\2\u0190\u0195\58\35\2\u0191\u0192"+
		"\7\f\2\2\u0192\u0194\58\35\2\u0193\u0191\3\2\2\2\u0194\u0197\3\2\2\2\u0195"+
		"\u0193\3\2\2\2\u0195\u0196\3\2\2\2\u0196\u0198\3\2\2\2\u0197\u0195\3\2"+
		"\2\2\u0198\u0199\7\t\2\2\u0199\u01c6\3\2\2\2\u019a\u019b\7e\2\2\u019b"+
		"\u019c\7+\2\2\u019c\u019d\3\2\2\2\u019d\u019e\7\b\2\2\u019e\u019f\7o\2"+
		"\2\u019f\u01c6\7\t\2\2\u01a0\u01a1\7e\2\2\u01a1\u01a2\7\61\2\2\u01a2\u01a3"+
		"\3\2\2\2\u01a3\u01a4\7\b\2\2\u01a4\u01a5\7x\2\2\u01a5\u01c6\7\t\2\2\u01a6"+
		"\u01a7\7e\2\2\u01a7\u01a8\7\62\2\2\u01a8\u01a9\3\2\2\2\u01a9\u01aa\7\b"+
		"\2\2\u01aa\u01ab\7x\2\2\u01ab\u01c6\7\t\2\2\u01ac\u01ad\7e\2\2\u01ad\u01ae"+
		"\7\63\2\2\u01ae\u01af\3\2\2\2\u01af\u01b0\7\b\2\2\u01b0\u01b1\7x\2\2\u01b1"+
		"\u01c6\7\t\2\2\u01b2\u01b3\7e\2\2\u01b3\u01b4\7D\2\2\u01b4\u01b5\3\2\2"+
		"\2\u01b5\u01b6\7\b\2\2\u01b6\u01b7\7E\2\2\u01b7\u01c6\7\t\2\2\u01b8\u01b9"+
		"\7e\2\2\u01b9\u01ba\7F\2\2\u01ba\u01bb\3\2\2\2\u01bb\u01bc\7\b\2\2\u01bc"+
		"\u01c1\7x\2\2\u01bd\u01be\7\f\2\2\u01be\u01c0\7x\2\2\u01bf\u01bd\3\2\2"+
		"\2\u01c0\u01c3\3\2\2\2\u01c1\u01bf\3\2\2\2\u01c1\u01c2\3\2\2\2\u01c2\u01c4"+
		"\3\2\2\2\u01c3\u01c1\3\2\2\2\u01c4\u01c6\7\t\2\2\u01c5\u016e\3\2\2\2\u01c5"+
		"\u0174\3\2\2\2\u01c5\u017a\3\2\2\2\u01c5\u0180\3\2\2\2\u01c5\u0186\3\2"+
		"\2\2\u01c5\u018c\3\2\2\2\u01c5\u019a\3\2\2\2\u01c5\u01a0\3\2\2\2\u01c5"+
		"\u01a6\3\2\2\2\u01c5\u01ac\3\2\2\2\u01c5\u01b2\3\2\2\2\u01c5\u01b8\3\2"+
		"\2\2\u01c6\67\3\2\2\2\u01c7\u01ca\7o\2\2\u01c8\u01c9\7\r\2\2\u01c9\u01cb"+
		"\7o\2\2\u01ca\u01c8\3\2\2\2\u01ca\u01cb\3\2\2\2\u01cb9\3\2\2\2\u01cc\u01f9"+
		"\7\64\2\2\u01cd\u01ce\7\67\2\2\u01ce\u01cf\7\b\2\2\u01cf\u01d0\7o\2\2"+
		"\u01d0\u01f9\7\t\2\2\u01d1\u01d5\7<\2\2\u01d2\u01d3\7\b\2\2\u01d3\u01d4"+
		"\7x\2\2\u01d4\u01d6\7\t\2\2\u01d5\u01d2\3\2\2\2\u01d5\u01d6\3\2\2\2\u01d6"+
		"\u01f9\3\2\2\2\u01d7\u01f9\7?\2\2\u01d8\u01f9\7@\2\2\u01d9\u01da\7>\2"+
		"\2\u01da\u01db\7\b\2\2\u01db\u01dc\7o\2\2\u01dc\u01f9\7\t\2\2\u01dd\u01f9"+
		"\79\2\2\u01de\u01f9\7:\2\2\u01df\u01f9\7A\2\2\u01e0\u01f9\7B\2\2\u01e1"+
		"\u01f9\7\65\2\2\u01e2\u01f9\7\66\2\2\u01e3\u01f9\78\2\2\u01e4\u01f9\7"+
		"C\2\2\u01e5\u01e9\7;\2\2\u01e6\u01e7\7\b\2\2\u01e7\u01e8\7x\2\2\u01e8"+
		"\u01ea\7\t\2\2\u01e9\u01e6\3\2\2\2\u01e9\u01ea\3\2\2\2\u01ea\u01f9\3\2"+
		"\2\2\u01eb\u01ec\7=\2\2\u01ec\u01ed\7\b\2\2\u01ed\u01f2\58\35\2\u01ee"+
		"\u01ef\7\f\2\2\u01ef\u01f1\58\35\2\u01f0\u01ee\3\2\2\2\u01f1\u01f4\3\2"+
		"\2\2\u01f2\u01f0\3\2\2\2\u01f2\u01f3\3\2\2\2\u01f3\u01f5\3\2\2\2\u01f4"+
		"\u01f2\3\2\2\2\u01f5\u01f6\7\t\2\2\u01f6\u01f9\3\2\2\2\u01f7\u01f9\7E"+
		"\2\2\u01f8\u01cc\3\2\2\2\u01f8\u01cd\3\2\2\2\u01f8\u01d1\3\2\2\2\u01f8"+
		"\u01d7\3\2\2\2\u01f8\u01d8\3\2\2\2\u01f8\u01d9\3\2\2\2\u01f8\u01dd\3\2"+
		"\2\2\u01f8\u01de\3\2\2\2\u01f8\u01df\3\2\2\2\u01f8\u01e0\3\2\2\2\u01f8"+
		"\u01e1\3\2\2\2\u01f8\u01e2\3\2\2\2\u01f8\u01e3\3\2\2\2\u01f8\u01e4\3\2"+
		"\2\2\u01f8\u01e5\3\2\2\2\u01f8\u01eb\3\2\2\2\u01f8\u01f7\3\2\2\2\u01f9"+
		";\3\2\2\2\u01fa\u01fc\5> \2\u01fb\u01fa\3\2\2\2\u01fc\u01fd\3\2\2\2\u01fd"+
		"\u01fb\3\2\2\2\u01fd\u01fe\3\2\2\2\u01fe=\3\2\2\2\u01ff\u0200\5\16\b\2"+
		"\u0200\u0201\7\n\2\2\u0201\u0254\3\2\2\2\u0202\u0204\7\4\2\2\u0203\u0205"+
		"\5<\37\2\u0204\u0203\3\2\2\2\u0204\u0205\3\2\2\2\u0205\u0206\3\2\2\2\u0206"+
		"\u0254\7\5\2\2\u0207\u0208\5H%\2\u0208\u0209\7\n\2\2\u0209\u0254\3\2\2"+
		"\2\u020a\u020b\7G\2\2\u020b\u020c\7\b\2\2\u020c\u020d\5H%\2\u020d\u020e"+
		"\7\t\2\2\u020e\u0211\5> \2\u020f\u0210\7H\2\2\u0210\u0212\5> \2\u0211"+
		"\u020f\3\2\2\2\u0211\u0212\3\2\2\2\u0212\u0254\3\2\2\2\u0213\u0215\5:"+
		"\36\2\u0214\u0213\3\2\2\2\u0215\u0218\3\2\2\2\u0216\u0214\3\2\2\2\u0216"+
		"\u0217\3\2\2\2\u0217\u0219\3\2\2\2\u0218\u0216\3\2\2\2\u0219\u021a\7I"+
		"\2\2\u021a\u021b\7\b\2\2\u021b\u021c\5H%\2\u021c\u021d\7\t\2\2\u021d\u021e"+
		"\5> \2\u021e\u0254\3\2\2\2\u021f\u0221\5:\36\2\u0220\u021f\3\2\2\2\u0221"+
		"\u0224\3\2\2\2\u0222\u0220\3\2\2\2\u0222\u0223\3\2\2\2\u0223\u0225\3\2"+
		"\2\2\u0224\u0222\3\2\2\2\u0225\u0226\7J\2\2\u0226\u0227\5> \2\u0227\u0228"+
		"\7I\2\2\u0228\u0229\7\b\2\2\u0229\u022a\5H%\2\u022a\u022b\7\t\2\2\u022b"+
		"\u022c\7\n\2\2\u022c\u0254\3\2\2\2\u022d\u022f\5:\36\2\u022e\u022d\3\2"+
		"\2\2\u022f\u0232\3\2\2\2\u0230\u022e\3\2\2\2\u0230\u0231\3\2\2\2\u0231"+
		"\u0233\3\2\2\2\u0232\u0230\3\2\2\2\u0233\u0234\7K\2\2\u0234\u0235\7\b"+
		"\2\2\u0235\u0236\5D#\2\u0236\u0237\7\t\2\2\u0237\u0238\5> \2\u0238\u0254"+
		"\3\2\2\2\u0239\u023a\7L\2\2\u023a\u023b\7\b\2\2\u023b\u023c\5H%\2\u023c"+
		"\u023d\7\t\2\2\u023d\u023e\7\4\2\2\u023e\u023f\5@!\2\u023f\u0240\7\5\2"+
		"\2\u0240\u0254\3\2\2\2\u0241\u0243\7M\2\2\u0242\u0244\5H%\2\u0243\u0242"+
		"\3\2\2\2\u0243\u0244\3\2\2\2\u0244\u0245\3\2\2\2\u0245\u0254\7\n\2\2\u0246"+
		"\u0247\7N\2\2\u0247\u0254\7\n\2\2\u0248\u0249\7O\2\2\u0249\u0254\7\n\2"+
		"\2\u024a\u024c\7P\2\2\u024b\u024d\5P)\2\u024c\u024b\3\2\2\2\u024c\u024d"+
		"\3\2\2\2\u024d\u024e\3\2\2\2\u024e\u024f\7\4\2\2\u024f\u0250\5T+\2\u0250"+
		"\u0251\7\u0091\2\2\u0251\u0254\3\2\2\2\u0252\u0254\5N(\2\u0253\u01ff\3"+
		"\2\2\2\u0253\u0202\3\2\2\2\u0253\u0207\3\2\2\2\u0253\u020a\3\2\2\2\u0253"+
		"\u0216\3\2\2\2\u0253\u0222\3\2\2\2\u0253\u0230\3\2\2\2\u0253\u0239\3\2"+
		"\2\2\u0253\u0241\3\2\2\2\u0253\u0246\3\2\2\2\u0253\u0248\3\2\2\2\u0253"+
		"\u024a\3\2\2\2\u0253\u0252\3\2\2\2\u0254?\3\2\2\2\u0255\u0257\5B\"\2\u0256"+
		"\u0255\3\2\2\2\u0257\u0258\3\2\2\2\u0258\u0256\3\2\2\2\u0258\u0259\3\2"+
		"\2\2\u0259\u025f\3\2\2\2\u025a\u025b\7Q\2\2\u025b\u025d\7\13\2\2\u025c"+
		"\u025e\5<\37\2\u025d\u025c\3\2\2\2\u025d\u025e\3\2\2\2\u025e\u0260\3\2"+
		"\2\2\u025f\u025a\3\2\2\2\u025f\u0260\3\2\2\2\u0260A\3\2\2\2\u0261\u0262"+
		"\7R\2\2\u0262\u0263\5J&\2\u0263\u0265\7\13\2\2\u0264\u0266\5<\37\2\u0265"+
		"\u0264\3\2\2\2\u0265\u0266\3\2\2\2\u0266C\3\2\2\2\u0267\u0268\5F$\2\u0268"+
		"\u0269\7\n\2\2\u0269\u026a\5H%\2\u026a\u026c\7\n\2\2\u026b\u026d\5H%\2"+
		"\u026c\u026b\3\2\2\2\u026c\u026d\3\2\2\2\u026d\u027e\3\2\2\2\u026e\u0272"+
		"\5\26\f\2\u026f\u0271\5\30\r\2\u0270\u026f\3\2\2\2\u0271\u0274\3\2\2\2"+
		"\u0272\u0270\3\2\2\2\u0272\u0273\3\2\2\2\u0273\u0276\3\2\2\2\u0274\u0272"+
		"\3\2\2\2\u0275\u026e\3\2\2\2\u0275\u0276\3\2\2\2\u0276\u0277\3\2\2\2\u0277"+
		"\u0278\7x\2\2\u0278\u0279\7\13\2\2\u0279\u027a\5J&\2\u027a\u027b\7\r\2"+
		"\2\u027b\u027c\5J&\2\u027c\u027e\3\2\2\2\u027d\u0267\3\2\2\2\u027d\u0275"+
		"\3\2\2\2\u027eE\3\2\2\2\u027f\u0281\5\16\b\2\u0280\u027f\3\2\2\2\u0280"+
		"\u0281\3\2\2\2\u0281\u0284\3\2\2\2\u0282\u0284\5H%\2\u0283\u0280\3\2\2"+
		"\2\u0283\u0282\3\2\2\2\u0284G\3\2\2\2\u0285\u0286\b%\1\2\u0286\u0287\5"+
		"J&\2\u0287\u028d\3\2\2\2\u0288\u0289\f\3\2\2\u0289\u028a\7\f\2\2\u028a"+
		"\u028c\5J&\2\u028b\u0288\3\2\2\2\u028c\u028f\3\2\2\2\u028d\u028b\3\2\2"+
		"\2\u028d\u028e\3\2\2\2\u028eI\3\2\2\2\u028f\u028d\3\2\2\2\u0290\u0291"+
		"\b&\1\2\u0291\u0292\7\b\2\2\u0292\u0293\5H%\2\u0293\u0294\7\t\2\2\u0294"+
		"\u02cf\3\2\2\2\u0295\u0296\7U\2\2\u0296\u0299\7\b\2\2\u0297\u029a\5J&"+
		"\2\u0298\u029a\5\34\17\2\u0299\u0297\3\2\2\2\u0299\u0298\3\2\2\2\u029a"+
		"\u029b\3\2\2\2\u029b\u029c\7\t\2\2\u029c\u02cf\3\2\2\2\u029d\u029e\7V"+
		"\2\2\u029e\u02a1\7\b\2\2\u029f\u02a2\5J&\2\u02a0\u02a2\5\34\17\2\u02a1"+
		"\u029f\3\2\2\2\u02a1\u02a0\3\2\2\2\u02a2\u02a3\3\2\2\2\u02a3\u02a4\7\t"+
		"\2\2\u02a4\u02cf\3\2\2\2\u02a5\u02a7\7W\2\2\u02a6\u02a8\7\b\2\2\u02a7"+
		"\u02a6\3\2\2\2\u02a7\u02a8\3\2\2\2\u02a8\u02a9\3\2\2\2\u02a9\u02ab\7x"+
		"\2\2\u02aa\u02ac\7\t\2\2\u02ab\u02aa\3\2\2\2\u02ab\u02ac\3\2\2\2\u02ac"+
		"\u02cf\3\2\2\2\u02ad\u02ae\7\b\2\2\u02ae\u02af\5\34\17\2\u02af\u02b0\7"+
		"\t\2\2\u02b0\u02b1\5J&\32\u02b1\u02cf\3\2\2\2\u02b2\u02b3\t\2\2\2\u02b3"+
		"\u02cf\5J&\31\u02b4\u02b5\7\24\2\2\u02b5\u02cf\5J&\27\u02b6\u02b7\t\3"+
		"\2\2\u02b7\u02cf\5J&\26\u02b8\u02b9\t\4\2\2\u02b9\u02cf\5J&\22\u02ba\u02bb"+
		"\7\4\2\2\u02bb\u02c0\5J&\2\u02bc\u02bd\7\f\2\2\u02bd\u02bf\5J&\2\u02be"+
		"\u02bc\3\2\2\2\u02bf\u02c2\3\2\2\2\u02c0\u02be\3\2\2\2\u02c0\u02c1\3\2"+
		"\2\2\u02c1\u02c3\3\2\2\2\u02c2\u02c0\3\2\2\2\u02c3\u02c4\7\5\2\2\u02c4"+
		"\u02cf\3\2\2\2\u02c5\u02cf\7x\2\2\u02c6\u02cf\7o\2\2\u02c7\u02c9\7y\2"+
		"\2\u02c8\u02c7\3\2\2\2\u02c9\u02ca\3\2\2\2\u02ca\u02c8\3\2\2\2\u02ca\u02cb"+
		"\3\2\2\2\u02cb\u02cf\3\2\2\2\u02cc\u02cf\7z\2\2\u02cd\u02cf\7a\2\2\u02ce"+
		"\u0290\3\2\2\2\u02ce\u0295\3\2\2\2\u02ce\u029d\3\2\2\2\u02ce\u02a5\3\2"+
		"\2\2\u02ce\u02ad\3\2\2\2\u02ce\u02b2\3\2\2\2\u02ce\u02b4\3\2\2\2\u02ce"+
		"\u02b6\3\2\2\2\u02ce\u02b8\3\2\2\2\u02ce\u02ba\3\2\2\2\u02ce\u02c5\3\2"+
		"\2\2\u02ce\u02c6\3\2\2\2\u02ce\u02c8\3\2\2\2\u02ce\u02cc\3\2\2\2\u02ce"+
		"\u02cd\3\2\2\2\u02cf\u030c\3\2\2\2\u02d0\u02d1\f\25\2\2\u02d1\u02d2\t"+
		"\5\2\2\u02d2\u030b\5J&\26\u02d3\u02d4\f\24\2\2\u02d4\u02d5\t\6\2\2\u02d5"+
		"\u030b\5J&\25\u02d6\u02d7\f\23\2\2\u02d7\u02d8\t\7\2\2\u02d8\u030b\5J"+
		"&\24\u02d9\u02da\f\21\2\2\u02da\u02db\t\b\2\2\u02db\u030b\5J&\22\u02dc"+
		"\u02dd\f\20\2\2\u02dd\u02de\7\31\2\2\u02de\u030b\5J&\21\u02df\u02e0\f"+
		"\17\2\2\u02e0\u02e1\7\33\2\2\u02e1\u030b\5J&\20\u02e2\u02e3\f\16\2\2\u02e3"+
		"\u02e4\7\34\2\2\u02e4\u030b\5J&\17\u02e5\u02e6\f\r\2\2\u02e6\u02e7\7%"+
		"\2\2\u02e7\u030b\5J&\16\u02e8\u02e9\f\f\2\2\u02e9\u02ea\7&\2\2\u02ea\u030b"+
		"\5J&\r\u02eb\u02ec\f\13\2\2\u02ec\u02ed\7\17\2\2\u02ed\u02ee\5J&\2\u02ee"+
		"\u02ef\7\13\2\2\u02ef\u02f0\5J&\f\u02f0\u030b\3\2\2\2\u02f1\u02f2\f\n"+
		"\2\2\u02f2\u02f3\7\'\2\2\u02f3\u030b\5J&\n\u02f4\u02f5\f\t\2\2\u02f5\u02f6"+
		"\7(\2\2\u02f6\u030b\5J&\t\u02f7\u02f8\f!\2\2\u02f8\u02f9\7\20\2\2\u02f9"+
		"\u030b\7x\2\2\u02fa\u02fb\f \2\2\u02fb\u02fc\7\21\2\2\u02fc\u030b\7x\2"+
		"\2\u02fd\u02fe\f\37\2\2\u02fe\u0300\7\b\2\2\u02ff\u0301\5L\'\2\u0300\u02ff"+
		"\3\2\2\2\u0300\u0301\3\2\2\2\u0301\u0302\3\2\2\2\u0302\u030b\7\t\2\2\u0303"+
		"\u0304\f\33\2\2\u0304\u0305\7\6\2\2\u0305\u0306\5H%\2\u0306\u0307\7\7"+
		"\2\2\u0307\u030b\3\2\2\2\u0308\u0309\f\30\2\2\u0309\u030b\t\2\2\2\u030a"+
		"\u02d0\3\2\2\2\u030a\u02d3\3\2\2\2\u030a\u02d6\3\2\2\2\u030a\u02d9\3\2"+
		"\2\2\u030a\u02dc\3\2\2\2\u030a\u02df\3\2\2\2\u030a\u02e2\3\2\2\2\u030a"+
		"\u02e5\3\2\2\2\u030a\u02e8\3\2\2\2\u030a\u02eb\3\2\2\2\u030a\u02f1\3\2"+
		"\2\2\u030a\u02f4\3\2\2\2\u030a\u02f7\3\2\2\2\u030a\u02fa\3\2\2\2\u030a"+
		"\u02fd\3\2\2\2\u030a\u0303\3\2\2\2\u030a\u0308\3\2\2\2\u030b\u030e\3\2"+
		"\2\2\u030c\u030a\3\2\2\2\u030c\u030d\3\2\2\2\u030dK\3\2\2\2\u030e\u030c"+
		"\3\2\2\2\u030f\u0314\5J&\2\u0310\u0311\7\f\2\2\u0311\u0313\5J&\2\u0312"+
		"\u0310\3\2\2\2\u0313\u0316\3\2\2\2\u0314\u0312\3\2\2\2\u0314\u0315\3\2"+
		"\2\2\u0315M\3\2\2\2\u0316\u0314\3\2\2\2\u0317\u0319\7X\2\2\u0318\u031a"+
		"\5P)\2\u0319\u0318\3\2\2\2\u0319\u031a\3\2\2\2\u031a\u031b\3\2\2\2\u031b"+
		"\u031c\7b\2\2\u031cO\3\2\2\2\u031d\u031e\7\b\2\2\u031e\u0323\5R*\2\u031f"+
		"\u0320\7\f\2\2\u0320\u0322\5R*\2\u0321\u031f\3\2\2\2\u0322\u0325\3\2\2"+
		"\2\u0323\u0321\3\2\2\2\u0323\u0324\3\2\2\2\u0324\u0326\3\2\2\2\u0325\u0323"+
		"\3\2\2\2\u0326\u0327\7\t\2\2\u0327Q\3\2\2\2\u0328\u0329\7Y\2\2\u0329\u0338"+
		"\7y\2\2\u032a\u032b\7Z\2\2\u032b\u0338\7x\2\2\u032c\u032d\7[\2\2\u032d"+
		"\u0338\7y\2\2\u032e\u032f\7\\\2\2\u032f\u0338\5J&\2\u0330\u0331\7]\2\2"+
		"\u0331\u0338\5J&\2\u0332\u0335\7+\2\2\u0333\u0336\78\2\2\u0334\u0336\5"+
		"J&\2\u0335\u0333\3\2\2\2\u0335\u0334\3\2\2\2\u0336\u0338\3\2\2\2\u0337"+
		"\u0328\3\2\2\2\u0337\u032a\3\2\2\2\u0337\u032c\3\2\2\2\u0337\u032e\3\2"+
		"\2\2\u0337\u0330\3\2\2\2\u0337\u0332\3\2\2\2\u0338S\3\2\2\2\u0339\u033b"+
		"\5V,\2\u033a\u0339\3\2\2\2\u033b\u033e\3\2\2\2\u033c\u033a\3\2\2\2\u033c"+
		"\u033d\3\2\2\2\u033dU\3\2\2\2\u033e\u033c\3\2\2\2\u033f\u0343\5X-\2\u0340"+
		"\u0343\5Z.\2\u0341\u0343\5\\/\2\u0342\u033f\3\2\2\2\u0342\u0340\3\2\2"+
		"\2\u0342\u0341\3\2\2\2\u0343W\3\2\2\2\u0344\u0345\7\u009e\2\2\u0345\u0349"+
		"\7\u0081\2\2\u0346\u0347\7\u009d\2\2\u0347\u0349\7\u0081\2\2\u0348\u0344"+
		"\3\2\2\2\u0348\u0346\3\2\2\2\u0349Y\3\2\2\2\u034a\u034c\7\177\2\2\u034b"+
		"\u034d\5^\60\2\u034c\u034b\3\2\2\2\u034c\u034d\3\2\2\2\u034d[\3\2\2\2"+
		"\u034e\u034f\7~\2\2\u034f\u0354\5`\61\2\u0350\u0351\7\u0082\2\2\u0351"+
		"\u0353\5`\61\2\u0352\u0350\3\2\2\2\u0353\u0356\3\2\2\2\u0354\u0352\3\2"+
		"\2\2\u0354\u0355\3\2\2\2\u0355]\3\2\2\2\u0356\u0354\3\2\2\2\u0357\u036f"+
		"\5`\61\2\u0358\u0359\7\u0080\2\2\u0359\u036f\5`\61\2\u035a\u035b\5`\61"+
		"\2\u035b\u035c\7\u0082\2\2\u035c\u035d\7\u009e\2\2\u035d\u036f\3\2\2\2"+
		"\u035e\u035f\7\u0083\2\2\u035f\u0360\5`\61\2\u0360\u0361\7\u0084\2\2\u0361"+
		"\u0362\7\u0082\2\2\u0362\u0363\7\u009e\2\2\u0363\u036f\3\2\2\2\u0364\u0365"+
		"\7\u0083\2\2\u0365\u0366\5`\61\2\u0366\u0367\7\u0082\2\2\u0367\u0368\7"+
		"\u009e\2\2\u0368\u0369\7\u0084\2\2\u0369\u036f\3\2\2\2\u036a\u036b\7\u0083"+
		"\2\2\u036b\u036c\5`\61\2\u036c\u036d\7\u0084\2\2\u036d\u036f\3\2\2\2\u036e"+
		"\u0357\3\2\2\2\u036e\u0358\3\2\2\2\u036e\u035a\3\2\2\2\u036e\u035e\3\2"+
		"\2\2\u036e\u0364\3\2\2\2\u036e\u036a\3\2\2\2\u036f_\3\2\2\2\u0370\u0371"+
		"\b\61\1\2\u0371\u0372\7\u0085\2\2\u0372\u0373\5`\61\2\u0373\u0374\7\u0086"+
		"\2\2\u0374\u037f\3\2\2\2\u0375\u0376\t\t\2\2\u0376\u037f\5`\61\n\u0377"+
		"\u037f\7\u009e\2\2\u0378\u037f\7\u009c\2\2\u0379\u037a\7\u0090\2\2\u037a"+
		"\u037b\7\u009e\2\2\u037b\u037f\7\u0091\2\2\u037c\u037f\7\u0092\2\2\u037d"+
		"\u037f\7\u009b\2\2\u037e\u0370\3\2\2\2\u037e\u0375\3\2\2\2\u037e\u0377"+
		"\3\2\2\2\u037e\u0378\3\2\2\2\u037e\u0379\3\2\2\2\u037e\u037c\3\2\2\2\u037e"+
		"\u037d\3\2\2\2\u037f\u038e\3\2\2\2\u0380\u0381\f\f\2\2\u0381\u0382\7\u0087"+
		"\2\2\u0382\u038d\5`\61\r\u0383\u0384\f\13\2\2\u0384\u0385\t\n\2\2\u0385"+
		"\u038d\5`\61\f\u0386\u0387\f\t\2\2\u0387\u0388\t\13\2\2\u0388\u038d\5"+
		"`\61\n\u0389\u038a\f\b\2\2\u038a\u038b\t\f\2\2\u038b\u038d\5`\61\t\u038c"+
		"\u0380\3\2\2\2\u038c\u0383\3\2\2\2\u038c\u0386\3\2\2\2\u038c\u0389\3\2"+
		"\2\2\u038d\u0390\3\2\2\2\u038e\u038c\3\2\2\2\u038e\u038f\3\2\2\2\u038f"+
		"a\3\2\2\2\u0390\u038e\3\2\2\2[kpx\u0089\u0092\u009c\u00a2\u00aa\u00b1"+
		"\u00ba\u00bf\u00c5\u00ca\u00cf\u00d6\u00dd\u00e2\u00ee\u00f1\u00f3\u00fe"+
		"\u0105\u010a\u0110\u0112\u011a\u0120\u012c\u013a\u0140\u0146\u014c\u0151"+
		"\u0155\u015e\u0165\u016c\u0195\u01c1\u01c5\u01ca\u01d5\u01e9\u01f2\u01f8"+
		"\u01fd\u0204\u0211\u0216\u0222\u0230\u0243\u024c\u0253\u0258\u025d\u025f"+
		"\u0265\u026c\u0272\u0275\u027d\u0280\u0283\u028d\u0299\u02a1\u02a7\u02ab"+
		"\u02c0\u02ca\u02ce\u0300\u030a\u030c\u0314\u0319\u0323\u0335\u0337\u033c"+
		"\u0342\u0348\u034c\u0354\u036e\u037e\u038c\u038e";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}
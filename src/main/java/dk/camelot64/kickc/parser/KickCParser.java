// Generated from /Users/jespergravgaard/c64/kickc/src/main/java/dk/camelot64/kickc/parser/KickCParser.g4 by ANTLR 4.9
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
	static { RuntimeMetaData.checkVersion("4.9", RuntimeMetaData.VERSION); }

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
		ASSIGN_COMPOUND=38, TYPEDEF=39, CONST=40, EXTERN=41, EXPORT=42, ALIGN=43, 
		INLINE=44, VOLATILE=45, STATIC=46, INTERRUPT=47, REGISTER=48, LOCAL_RESERVE=49, 
		ADDRESS=50, ADDRESS_ZEROPAGE=51, ADDRESS_MAINMEM=52, FORM_SSA=53, FORM_MA=54, 
		INTRINSIC=55, CALLINGCONVENTION=56, IF=57, ELSE=58, WHILE=59, DO=60, FOR=61, 
		SWITCH=62, RETURN=63, BREAK=64, CONTINUE=65, ASM=66, DEFAULT=67, CASE=68, 
		STRUCT=69, ENUM=70, SIZEOF=71, TYPEID=72, DEFINED=73, KICKASM=74, RESOURCE=75, 
		USES=76, CLOBBERS=77, BYTES=78, CYCLES=79, LOGIC_NOT=80, SIGNEDNESS=81, 
		SIMPLETYPE=82, BOOLEAN=83, KICKASM_BODY=84, IMPORT=85, INCLUDE=86, PRAGMA=87, 
		DEFINE=88, DEFINE_CONTINUE=89, UNDEF=90, IFDEF=91, IFNDEF=92, IFIF=93, 
		ELIF=94, IFELSE=95, ENDIF=96, ERROR=97, NUMBER=98, NUMFLOAT=99, BINFLOAT=100, 
		DECFLOAT=101, HEXFLOAT=102, NUMINT=103, BININTEGER=104, DECINTEGER=105, 
		HEXINTEGER=106, NAME=107, STRING=108, CHAR=109, WS=110, COMMENT_LINE=111, 
		COMMENT_BLOCK=112, ASM_BYTE=113, ASM_MNEMONIC=114, ASM_IMM=115, ASM_COLON=116, 
		ASM_COMMA=117, ASM_PAR_BEGIN=118, ASM_PAR_END=119, ASM_BRACKET_BEGIN=120, 
		ASM_BRACKET_END=121, ASM_DOT=122, ASM_SHIFT_LEFT=123, ASM_SHIFT_RIGHT=124, 
		ASM_PLUS=125, ASM_MINUS=126, ASM_LESS_THAN=127, ASM_GREATER_THAN=128, 
		ASM_MULTIPLY=129, ASM_DIVIDE=130, ASM_CURLY_BEGIN=131, ASM_CURLY_END=132, 
		ASM_NUMBER=133, ASM_NUMFLOAT=134, ASM_BINFLOAT=135, ASM_DECFLOAT=136, 
		ASM_HEXFLOAT=137, ASM_NUMINT=138, ASM_BININTEGER=139, ASM_DECINTEGER=140, 
		ASM_HEXINTEGER=141, ASM_CHAR=142, ASM_MULTI_REL=143, ASM_MULTI_NAME=144, 
		ASM_NAME=145, ASM_TAG=146, ASM_WS=147, ASM_COMMENT_LINE=148, ASM_COMMENT_BLOCK=149, 
		IMPORT_SYSTEMFILE=150, IMPORT_LOCALFILE=151, IMPORT_WS=152, IMPORT_COMMENT_LINE=153, 
		IMPORT_COMMENT_BLOCK=154;
	public static final int
		RULE_file = 0, RULE_asmFile = 1, RULE_declSeq = 2, RULE_decl = 3, RULE_declVariables = 4, 
		RULE_declaratorInitList = 5, RULE_declaratorInit = 6, RULE_typeDef = 7, 
		RULE_declType = 8, RULE_typeSpecifier = 9, RULE_declarator = 10, RULE_type = 11, 
		RULE_structRef = 12, RULE_structDef = 13, RULE_structMembers = 14, RULE_enumRef = 15, 
		RULE_enumDef = 16, RULE_enumMemberList = 17, RULE_enumMember = 18, RULE_declFunction = 19, 
		RULE_parameterListDecl = 20, RULE_parameterDecl = 21, RULE_pragma = 22, 
		RULE_pragmaParam = 23, RULE_directive = 24, RULE_stmtSeq = 25, RULE_stmt = 26, 
		RULE_switchCases = 27, RULE_switchCase = 28, RULE_forLoop = 29, RULE_forClassicInit = 30, 
		RULE_forClassicCondition = 31, RULE_commaExpr = 32, RULE_expr = 33, RULE_parameterList = 34, 
		RULE_kasmContent = 35, RULE_asmDirectives = 36, RULE_asmDirective = 37, 
		RULE_asmLines = 38, RULE_asmLine = 39, RULE_asmLabel = 40, RULE_asmInstruction = 41, 
		RULE_asmBytes = 42, RULE_asmParamMode = 43, RULE_asmExpr = 44;
	private static String[] makeRuleNames() {
		return new String[] {
			"file", "asmFile", "declSeq", "decl", "declVariables", "declaratorInitList", 
			"declaratorInit", "typeDef", "declType", "typeSpecifier", "declarator", 
			"type", "structRef", "structDef", "structMembers", "enumRef", "enumDef", 
			"enumMemberList", "enumMember", "declFunction", "parameterListDecl", 
			"parameterDecl", "pragma", "pragmaParam", "directive", "stmtSeq", "stmt", 
			"switchCases", "switchCase", "forLoop", "forClassicInit", "forClassicCondition", 
			"commaExpr", "expr", "parameterList", "kasmContent", "asmDirectives", 
			"asmDirective", "asmLines", "asmLine", "asmLabel", "asmInstruction", 
			"asmBytes", "asmParamMode", "asmExpr"
		};
	}
	public static final String[] ruleNames = makeRuleNames();

	private static String[] makeLiteralNames() {
		return new String[] {
			null, null, null, null, null, null, null, null, "';'", null, null, "'..'", 
			"'...'", "'?'", null, "'->'", null, null, null, null, "'%'", "'++'", 
			"'--'", "'&'", "'~'", "'^'", "'|'", null, null, "'=='", "'!='", null, 
			"'<='", "'>='", null, "'&&'", "'||'", "'='", null, "'typedef'", "'const'", 
			"'extern'", "'export'", "'__align'", "'inline'", "'volatile'", "'static'", 
			"'__interrupt'", "'register'", "'__zp_reserve'", "'__address'", "'__zp'", 
			"'__mem'", "'__ssa'", "'__ma'", "'__intrinsic'", null, "'if'", "'else'", 
			"'while'", "'do'", "'for'", "'switch'", "'return'", "'break'", "'continue'", 
			"'asm'", "'default'", "'case'", "'struct'", "'enum'", "'sizeof'", "'typeid'", 
			"'defined'", "'kickasm'", "'resource'", "'uses'", "'clobbers'", "'bytes'", 
			"'cycles'", "'!'", null, null, null, null, "'#import'", "'#include'", 
			"'#pragma'", "'#define'", null, "'#undef'", "'#ifdef'", "'#ifndef'", 
			"'#if'", "'#elif'", "'#else'", "'#endif'", "'#error'", null, null, null, 
			null, null, null, null, null, null, null, null, null, null, null, null, 
			"'.byte'", null, "'#'"
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
			"TYPEDEF", "CONST", "EXTERN", "EXPORT", "ALIGN", "INLINE", "VOLATILE", 
			"STATIC", "INTERRUPT", "REGISTER", "LOCAL_RESERVE", "ADDRESS", "ADDRESS_ZEROPAGE", 
			"ADDRESS_MAINMEM", "FORM_SSA", "FORM_MA", "INTRINSIC", "CALLINGCONVENTION", 
			"IF", "ELSE", "WHILE", "DO", "FOR", "SWITCH", "RETURN", "BREAK", "CONTINUE", 
			"ASM", "DEFAULT", "CASE", "STRUCT", "ENUM", "SIZEOF", "TYPEID", "DEFINED", 
			"KICKASM", "RESOURCE", "USES", "CLOBBERS", "BYTES", "CYCLES", "LOGIC_NOT", 
			"SIGNEDNESS", "SIMPLETYPE", "BOOLEAN", "KICKASM_BODY", "IMPORT", "INCLUDE", 
			"PRAGMA", "DEFINE", "DEFINE_CONTINUE", "UNDEF", "IFDEF", "IFNDEF", "IFIF", 
			"ELIF", "IFELSE", "ENDIF", "ERROR", "NUMBER", "NUMFLOAT", "BINFLOAT", 
			"DECFLOAT", "HEXFLOAT", "NUMINT", "BININTEGER", "DECINTEGER", "HEXINTEGER", 
			"NAME", "STRING", "CHAR", "WS", "COMMENT_LINE", "COMMENT_BLOCK", "ASM_BYTE", 
			"ASM_MNEMONIC", "ASM_IMM", "ASM_COLON", "ASM_COMMA", "ASM_PAR_BEGIN", 
			"ASM_PAR_END", "ASM_BRACKET_BEGIN", "ASM_BRACKET_END", "ASM_DOT", "ASM_SHIFT_LEFT", 
			"ASM_SHIFT_RIGHT", "ASM_PLUS", "ASM_MINUS", "ASM_LESS_THAN", "ASM_GREATER_THAN", 
			"ASM_MULTIPLY", "ASM_DIVIDE", "ASM_CURLY_BEGIN", "ASM_CURLY_END", "ASM_NUMBER", 
			"ASM_NUMFLOAT", "ASM_BINFLOAT", "ASM_DECFLOAT", "ASM_HEXFLOAT", "ASM_NUMINT", 
			"ASM_BININTEGER", "ASM_DECINTEGER", "ASM_HEXINTEGER", "ASM_CHAR", "ASM_MULTI_REL", 
			"ASM_MULTI_NAME", "ASM_NAME", "ASM_TAG", "ASM_WS", "ASM_COMMENT_LINE", 
			"ASM_COMMENT_BLOCK", "IMPORT_SYSTEMFILE", "IMPORT_LOCALFILE", "IMPORT_WS", 
			"IMPORT_COMMENT_LINE", "IMPORT_COMMENT_BLOCK"
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


	    // The C parser
	    CParser cParser;
	    // true when a typedef is being created
	    boolean isTypedef;

		public KickCParser(TokenStream input, CParser cParser) {
			this(input);
			this.cParser = cParser;
			this.isTypedef = false;
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
			setState(90);
			declSeq();
			setState(91);
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
			setState(93);
			asmLines();
			setState(94);
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
		public List<DeclContext> decl() {
			return getRuleContexts(DeclContext.class);
		}
		public DeclContext decl(int i) {
			return getRuleContext(DeclContext.class,i);
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
			setState(99);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << TYPEDEFNAME) | (1L << TYPEDEF) | (1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << INLINE) | (1L << VOLATILE) | (1L << STATIC) | (1L << INTERRUPT) | (1L << REGISTER) | (1L << LOCAL_RESERVE) | (1L << ADDRESS) | (1L << ADDRESS_ZEROPAGE) | (1L << ADDRESS_MAINMEM) | (1L << FORM_SSA) | (1L << FORM_MA) | (1L << INTRINSIC) | (1L << CALLINGCONVENTION))) != 0) || ((((_la - 69)) & ~0x3f) == 0 && ((1L << (_la - 69)) & ((1L << (STRUCT - 69)) | (1L << (ENUM - 69)) | (1L << (SIGNEDNESS - 69)) | (1L << (SIMPLETYPE - 69)) | (1L << (PRAGMA - 69)))) != 0)) {
				{
				{
				setState(96);
				decl();
				}
				}
				setState(101);
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

	public static class DeclContext extends ParserRuleContext {
		public DeclVariablesContext declVariables() {
			return getRuleContext(DeclVariablesContext.class,0);
		}
		public TerminalNode SEMICOLON() { return getToken(KickCParser.SEMICOLON, 0); }
		public DeclFunctionContext declFunction() {
			return getRuleContext(DeclFunctionContext.class,0);
		}
		public StructDefContext structDef() {
			return getRuleContext(StructDefContext.class,0);
		}
		public EnumDefContext enumDef() {
			return getRuleContext(EnumDefContext.class,0);
		}
		public PragmaContext pragma() {
			return getRuleContext(PragmaContext.class,0);
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
		enterRule(_localctx, 6, RULE_decl);
		try {
			setState(116);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,1,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				setState(102);
				declVariables();
				setState(103);
				match(SEMICOLON);
				}
				break;
			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(105);
				declFunction();
				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(106);
				structDef();
				setState(107);
				match(SEMICOLON);
				}
				break;
			case 4:
				enterOuterAlt(_localctx, 4);
				{
				setState(109);
				enumDef();
				setState(110);
				match(SEMICOLON);
				}
				break;
			case 5:
				enterOuterAlt(_localctx, 5);
				{
				setState(112);
				pragma();
				}
				break;
			case 6:
				enterOuterAlt(_localctx, 6);
				{
				setState(113);
				typeDef();
				setState(114);
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
		public DeclaratorInitListContext declaratorInitList() {
			return getRuleContext(DeclaratorInitListContext.class,0);
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
		enterRule(_localctx, 8, RULE_declVariables);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(118);
			declType();
			setState(119);
			declaratorInitList(0);
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

	public static class DeclaratorInitListContext extends ParserRuleContext {
		public DeclaratorInitContext declaratorInit() {
			return getRuleContext(DeclaratorInitContext.class,0);
		}
		public DeclaratorInitListContext declaratorInitList() {
			return getRuleContext(DeclaratorInitListContext.class,0);
		}
		public TerminalNode COMMA() { return getToken(KickCParser.COMMA, 0); }
		public DeclaratorInitListContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_declaratorInitList; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterDeclaratorInitList(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitDeclaratorInitList(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitDeclaratorInitList(this);
			else return visitor.visitChildren(this);
		}
	}

	public final DeclaratorInitListContext declaratorInitList() throws RecognitionException {
		return declaratorInitList(0);
	}

	private DeclaratorInitListContext declaratorInitList(int _p) throws RecognitionException {
		ParserRuleContext _parentctx = _ctx;
		int _parentState = getState();
		DeclaratorInitListContext _localctx = new DeclaratorInitListContext(_ctx, _parentState);
		DeclaratorInitListContext _prevctx = _localctx;
		int _startState = 10;
		enterRecursionRule(_localctx, 10, RULE_declaratorInitList, _p);
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			{
			setState(122);
			declaratorInit();
			}
			_ctx.stop = _input.LT(-1);
			setState(129);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,2,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					{
					_localctx = new DeclaratorInitListContext(_parentctx, _parentState);
					pushNewRecursionContext(_localctx, _startState, RULE_declaratorInitList);
					setState(124);
					if (!(precpred(_ctx, 1))) throw new FailedPredicateException(this, "precpred(_ctx, 1)");
					setState(125);
					match(COMMA);
					setState(126);
					declaratorInit();
					}
					} 
				}
				setState(131);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,2,_ctx);
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

	public static class DeclaratorInitContext extends ParserRuleContext {
		public DeclaratorInitContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_declaratorInit; }
	 
		public DeclaratorInitContext() { }
		public void copyFrom(DeclaratorInitContext ctx) {
			super.copyFrom(ctx);
		}
	}
	public static class DeclVariableInitKasmContext extends DeclaratorInitContext {
		public DeclaratorContext declarator() {
			return getRuleContext(DeclaratorContext.class,0);
		}
		public TerminalNode ASSIGN() { return getToken(KickCParser.ASSIGN, 0); }
		public KasmContentContext kasmContent() {
			return getRuleContext(KasmContentContext.class,0);
		}
		public DeclVariableInitKasmContext(DeclaratorInitContext ctx) { copyFrom(ctx); }
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
	public static class DeclVariableInitExprContext extends DeclaratorInitContext {
		public DeclaratorContext declarator() {
			return getRuleContext(DeclaratorContext.class,0);
		}
		public TerminalNode ASSIGN() { return getToken(KickCParser.ASSIGN, 0); }
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public DeclVariableInitExprContext(DeclaratorInitContext ctx) { copyFrom(ctx); }
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

	public final DeclaratorInitContext declaratorInit() throws RecognitionException {
		DeclaratorInitContext _localctx = new DeclaratorInitContext(_ctx, getState());
		enterRule(_localctx, 12, RULE_declaratorInit);
		try {
			setState(141);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,4,_ctx) ) {
			case 1:
				_localctx = new DeclVariableInitExprContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(132);
				declarator(0);
				setState(135);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,3,_ctx) ) {
				case 1:
					{
					setState(133);
					match(ASSIGN);
					setState(134);
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
				setState(137);
				declarator(0);
				setState(138);
				match(ASSIGN);
				setState(139);
				kasmContent();
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

	public static class TypeDefContext extends ParserRuleContext {
		public TerminalNode TYPEDEF() { return getToken(KickCParser.TYPEDEF, 0); }
		public DeclTypeContext declType() {
			return getRuleContext(DeclTypeContext.class,0);
		}
		public DeclaratorContext declarator() {
			return getRuleContext(DeclaratorContext.class,0);
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
		enterRule(_localctx, 14, RULE_typeDef);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(143);
			match(TYPEDEF);
			setState(144);
			declType();
			 isTypedef=true; 
			setState(146);
			declarator(0);
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
		enterRule(_localctx, 16, RULE_declType);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(151);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << INLINE) | (1L << VOLATILE) | (1L << STATIC) | (1L << INTERRUPT) | (1L << REGISTER) | (1L << LOCAL_RESERVE) | (1L << ADDRESS) | (1L << ADDRESS_ZEROPAGE) | (1L << ADDRESS_MAINMEM) | (1L << FORM_SSA) | (1L << FORM_MA) | (1L << INTRINSIC) | (1L << CALLINGCONVENTION))) != 0)) {
				{
				{
				setState(148);
				directive();
				}
				}
				setState(153);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(154);
			type();
			setState(158);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << INLINE) | (1L << VOLATILE) | (1L << STATIC) | (1L << INTERRUPT) | (1L << REGISTER) | (1L << LOCAL_RESERVE) | (1L << ADDRESS) | (1L << ADDRESS_ZEROPAGE) | (1L << ADDRESS_MAINMEM) | (1L << FORM_SSA) | (1L << FORM_MA) | (1L << INTRINSIC) | (1L << CALLINGCONVENTION))) != 0)) {
				{
				{
				setState(155);
				directive();
				}
				}
				setState(160);
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
		int _startState = 18;
		enterRecursionRule(_localctx, 18, RULE_typeSpecifier, _p);
		int _la;
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			{
			_localctx = new TypeSpecifierSimpleContext(_localctx);
			_ctx = _localctx;
			_prevctx = _localctx;

			setState(162);
			type();
			}
			_ctx.stop = _input.LT(-1);
			setState(174);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,9,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					setState(172);
					_errHandler.sync(this);
					switch ( getInterpreter().adaptivePredict(_input,8,_ctx) ) {
					case 1:
						{
						_localctx = new TypeSpecifierPointerContext(new TypeSpecifierContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_typeSpecifier);
						setState(164);
						if (!(precpred(_ctx, 2))) throw new FailedPredicateException(this, "precpred(_ctx, 2)");
						setState(165);
						match(ASTERISK);
						}
						break;
					case 2:
						{
						_localctx = new TypeSpecifierArrayContext(new TypeSpecifierContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_typeSpecifier);
						setState(166);
						if (!(precpred(_ctx, 1))) throw new FailedPredicateException(this, "precpred(_ctx, 1)");
						setState(167);
						match(BRACKET_BEGIN);
						setState(169);
						_errHandler.sync(this);
						_la = _input.LA(1);
						if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << CURLY_BEGIN) | (1L << PAR_BEGIN) | (1L << PLUS) | (1L << MINUS) | (1L << ASTERISK) | (1L << INC) | (1L << DEC) | (1L << AND) | (1L << BIT_NOT) | (1L << LESS_THAN) | (1L << GREATER_THAN))) != 0) || ((((_la - 71)) & ~0x3f) == 0 && ((1L << (_la - 71)) & ((1L << (SIZEOF - 71)) | (1L << (TYPEID - 71)) | (1L << (DEFINED - 71)) | (1L << (LOGIC_NOT - 71)) | (1L << (BOOLEAN - 71)) | (1L << (NUMBER - 71)) | (1L << (NAME - 71)) | (1L << (STRING - 71)) | (1L << (CHAR - 71)))) != 0)) {
							{
							setState(168);
							expr(0);
							}
						}

						setState(171);
						match(BRACKET_END);
						}
						break;
					}
					} 
				}
				setState(176);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,9,_ctx);
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

	public static class DeclaratorContext extends ParserRuleContext {
		public DeclaratorContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_declarator; }
	 
		public DeclaratorContext() { }
		public void copyFrom(DeclaratorContext ctx) {
			super.copyFrom(ctx);
		}
	}
	public static class DeclaratorPointerContext extends DeclaratorContext {
		public TerminalNode ASTERISK() { return getToken(KickCParser.ASTERISK, 0); }
		public DeclaratorContext declarator() {
			return getRuleContext(DeclaratorContext.class,0);
		}
		public List<DirectiveContext> directive() {
			return getRuleContexts(DirectiveContext.class);
		}
		public DirectiveContext directive(int i) {
			return getRuleContext(DirectiveContext.class,i);
		}
		public DeclaratorPointerContext(DeclaratorContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterDeclaratorPointer(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitDeclaratorPointer(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitDeclaratorPointer(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class DeclaratorArrayContext extends DeclaratorContext {
		public DeclaratorContext declarator() {
			return getRuleContext(DeclaratorContext.class,0);
		}
		public TerminalNode BRACKET_BEGIN() { return getToken(KickCParser.BRACKET_BEGIN, 0); }
		public TerminalNode BRACKET_END() { return getToken(KickCParser.BRACKET_END, 0); }
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public DeclaratorArrayContext(DeclaratorContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterDeclaratorArray(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitDeclaratorArray(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitDeclaratorArray(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class DeclaratorParContext extends DeclaratorContext {
		public TerminalNode PAR_BEGIN() { return getToken(KickCParser.PAR_BEGIN, 0); }
		public DeclaratorContext declarator() {
			return getRuleContext(DeclaratorContext.class,0);
		}
		public TerminalNode PAR_END() { return getToken(KickCParser.PAR_END, 0); }
		public DeclaratorParContext(DeclaratorContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterDeclaratorPar(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitDeclaratorPar(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitDeclaratorPar(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class DeclaratorNameContext extends DeclaratorContext {
		public Token NAME;
		public TerminalNode NAME() { return getToken(KickCParser.NAME, 0); }
		public DeclaratorNameContext(DeclaratorContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterDeclaratorName(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitDeclaratorName(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitDeclaratorName(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class DeclaratorProcedureContext extends DeclaratorContext {
		public DeclaratorContext declarator() {
			return getRuleContext(DeclaratorContext.class,0);
		}
		public TerminalNode PAR_BEGIN() { return getToken(KickCParser.PAR_BEGIN, 0); }
		public TerminalNode PAR_END() { return getToken(KickCParser.PAR_END, 0); }
		public ParameterListDeclContext parameterListDecl() {
			return getRuleContext(ParameterListDeclContext.class,0);
		}
		public DeclaratorProcedureContext(DeclaratorContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterDeclaratorProcedure(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitDeclaratorProcedure(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitDeclaratorProcedure(this);
			else return visitor.visitChildren(this);
		}
	}

	public final DeclaratorContext declarator() throws RecognitionException {
		return declarator(0);
	}

	private DeclaratorContext declarator(int _p) throws RecognitionException {
		ParserRuleContext _parentctx = _ctx;
		int _parentState = getState();
		DeclaratorContext _localctx = new DeclaratorContext(_ctx, _parentState);
		DeclaratorContext _prevctx = _localctx;
		int _startState = 20;
		enterRecursionRule(_localctx, 20, RULE_declarator, _p);
		int _la;
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(192);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case NAME:
				{
				_localctx = new DeclaratorNameContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;

				setState(178);
				((DeclaratorNameContext)_localctx).NAME = match(NAME);
				if(isTypedef) { cParser.addTypedef((((DeclaratorNameContext)_localctx).NAME!=null?((DeclaratorNameContext)_localctx).NAME.getText():null)); isTypedef=false; } 
				}
				break;
			case ASTERISK:
				{
				_localctx = new DeclaratorPointerContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(180);
				match(ASTERISK);
				setState(184);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << INLINE) | (1L << VOLATILE) | (1L << STATIC) | (1L << INTERRUPT) | (1L << REGISTER) | (1L << LOCAL_RESERVE) | (1L << ADDRESS) | (1L << ADDRESS_ZEROPAGE) | (1L << ADDRESS_MAINMEM) | (1L << FORM_SSA) | (1L << FORM_MA) | (1L << INTRINSIC) | (1L << CALLINGCONVENTION))) != 0)) {
					{
					{
					setState(181);
					directive();
					}
					}
					setState(186);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				setState(187);
				declarator(2);
				}
				break;
			case PAR_BEGIN:
				{
				_localctx = new DeclaratorParContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(188);
				match(PAR_BEGIN);
				setState(189);
				declarator(0);
				setState(190);
				match(PAR_END);
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
			_ctx.stop = _input.LT(-1);
			setState(208);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,15,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					setState(206);
					_errHandler.sync(this);
					switch ( getInterpreter().adaptivePredict(_input,14,_ctx) ) {
					case 1:
						{
						_localctx = new DeclaratorProcedureContext(new DeclaratorContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_declarator);
						setState(194);
						if (!(precpred(_ctx, 4))) throw new FailedPredicateException(this, "precpred(_ctx, 4)");
						setState(195);
						match(PAR_BEGIN);
						setState(197);
						_errHandler.sync(this);
						_la = _input.LA(1);
						if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << TYPEDEFNAME) | (1L << PARAM_LIST) | (1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << INLINE) | (1L << VOLATILE) | (1L << STATIC) | (1L << INTERRUPT) | (1L << REGISTER) | (1L << LOCAL_RESERVE) | (1L << ADDRESS) | (1L << ADDRESS_ZEROPAGE) | (1L << ADDRESS_MAINMEM) | (1L << FORM_SSA) | (1L << FORM_MA) | (1L << INTRINSIC) | (1L << CALLINGCONVENTION))) != 0) || ((((_la - 69)) & ~0x3f) == 0 && ((1L << (_la - 69)) & ((1L << (STRUCT - 69)) | (1L << (ENUM - 69)) | (1L << (SIGNEDNESS - 69)) | (1L << (SIMPLETYPE - 69)))) != 0)) {
							{
							setState(196);
							parameterListDecl();
							}
						}

						setState(199);
						match(PAR_END);
						}
						break;
					case 2:
						{
						_localctx = new DeclaratorArrayContext(new DeclaratorContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_declarator);
						setState(200);
						if (!(precpred(_ctx, 3))) throw new FailedPredicateException(this, "precpred(_ctx, 3)");
						setState(201);
						match(BRACKET_BEGIN);
						setState(203);
						_errHandler.sync(this);
						_la = _input.LA(1);
						if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << CURLY_BEGIN) | (1L << PAR_BEGIN) | (1L << PLUS) | (1L << MINUS) | (1L << ASTERISK) | (1L << INC) | (1L << DEC) | (1L << AND) | (1L << BIT_NOT) | (1L << LESS_THAN) | (1L << GREATER_THAN))) != 0) || ((((_la - 71)) & ~0x3f) == 0 && ((1L << (_la - 71)) & ((1L << (SIZEOF - 71)) | (1L << (TYPEID - 71)) | (1L << (DEFINED - 71)) | (1L << (LOGIC_NOT - 71)) | (1L << (BOOLEAN - 71)) | (1L << (NUMBER - 71)) | (1L << (NAME - 71)) | (1L << (STRING - 71)) | (1L << (CHAR - 71)))) != 0)) {
							{
							setState(202);
							expr(0);
							}
						}

						setState(205);
						match(BRACKET_END);
						}
						break;
					}
					} 
				}
				setState(210);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,15,_ctx);
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
		TypeContext _localctx = new TypeContext(_ctx, getState());
		enterRule(_localctx, 22, RULE_type);
		try {
			setState(221);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,17,_ctx) ) {
			case 1:
				_localctx = new TypeSimpleContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(211);
				match(SIMPLETYPE);
				}
				break;
			case 2:
				_localctx = new TypeSignedSimpleContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(212);
				match(SIGNEDNESS);
				setState(214);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,16,_ctx) ) {
				case 1:
					{
					setState(213);
					match(SIMPLETYPE);
					}
					break;
				}
				}
				break;
			case 3:
				_localctx = new TypeStructDefContext(_localctx);
				enterOuterAlt(_localctx, 3);
				{
				setState(216);
				structDef();
				}
				break;
			case 4:
				_localctx = new TypeStructRefContext(_localctx);
				enterOuterAlt(_localctx, 4);
				{
				setState(217);
				structRef();
				}
				break;
			case 5:
				_localctx = new TypeEnumDefContext(_localctx);
				enterOuterAlt(_localctx, 5);
				{
				setState(218);
				enumDef();
				}
				break;
			case 6:
				_localctx = new TypeEnumRefContext(_localctx);
				enterOuterAlt(_localctx, 6);
				{
				setState(219);
				enumRef();
				}
				break;
			case 7:
				_localctx = new TypeNamedRefContext(_localctx);
				enterOuterAlt(_localctx, 7);
				{
				setState(220);
				match(TYPEDEFNAME);
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
		enterRule(_localctx, 24, RULE_structRef);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(223);
			match(STRUCT);
			setState(224);
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
		enterRule(_localctx, 26, RULE_structDef);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(226);
			match(STRUCT);
			setState(228);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==NAME) {
				{
				setState(227);
				match(NAME);
				}
			}

			setState(230);
			match(CURLY_BEGIN);
			setState(232); 
			_errHandler.sync(this);
			_la = _input.LA(1);
			do {
				{
				{
				setState(231);
				structMembers();
				}
				}
				setState(234); 
				_errHandler.sync(this);
				_la = _input.LA(1);
			} while ( (((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << TYPEDEFNAME) | (1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << INLINE) | (1L << VOLATILE) | (1L << STATIC) | (1L << INTERRUPT) | (1L << REGISTER) | (1L << LOCAL_RESERVE) | (1L << ADDRESS) | (1L << ADDRESS_ZEROPAGE) | (1L << ADDRESS_MAINMEM) | (1L << FORM_SSA) | (1L << FORM_MA) | (1L << INTRINSIC) | (1L << CALLINGCONVENTION))) != 0) || ((((_la - 69)) & ~0x3f) == 0 && ((1L << (_la - 69)) & ((1L << (STRUCT - 69)) | (1L << (ENUM - 69)) | (1L << (SIGNEDNESS - 69)) | (1L << (SIMPLETYPE - 69)))) != 0) );
			setState(236);
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
		enterRule(_localctx, 28, RULE_structMembers);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(238);
			declVariables();
			setState(239);
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
		enterRule(_localctx, 30, RULE_enumRef);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(241);
			match(ENUM);
			setState(242);
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
		enterRule(_localctx, 32, RULE_enumDef);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(244);
			match(ENUM);
			setState(246);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==NAME) {
				{
				setState(245);
				match(NAME);
				}
			}

			setState(248);
			match(CURLY_BEGIN);
			setState(249);
			enumMemberList(0);
			setState(250);
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
		int _startState = 34;
		enterRecursionRule(_localctx, 34, RULE_enumMemberList, _p);
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			{
			setState(253);
			enumMember();
			}
			_ctx.stop = _input.LT(-1);
			setState(260);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,21,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					{
					_localctx = new EnumMemberListContext(_parentctx, _parentState);
					pushNewRecursionContext(_localctx, _startState, RULE_enumMemberList);
					setState(255);
					if (!(precpred(_ctx, 1))) throw new FailedPredicateException(this, "precpred(_ctx, 1)");
					setState(256);
					match(COMMA);
					setState(257);
					enumMember();
					}
					} 
				}
				setState(262);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,21,_ctx);
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
		enterRule(_localctx, 36, RULE_enumMember);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(263);
			match(NAME);
			setState(266);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,22,_ctx) ) {
			case 1:
				{
				setState(264);
				match(ASSIGN);
				setState(265);
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
		public DeclaratorContext declarator() {
			return getRuleContext(DeclaratorContext.class,0);
		}
		public TerminalNode CURLY_BEGIN() { return getToken(KickCParser.CURLY_BEGIN, 0); }
		public TerminalNode CURLY_END() { return getToken(KickCParser.CURLY_END, 0); }
		public StmtSeqContext stmtSeq() {
			return getRuleContext(StmtSeqContext.class,0);
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
		enterRule(_localctx, 38, RULE_declFunction);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(268);
			declType();
			setState(269);
			declarator(0);
			setState(270);
			match(CURLY_BEGIN);
			setState(272);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << TYPEDEFNAME) | (1L << CURLY_BEGIN) | (1L << PAR_BEGIN) | (1L << SEMICOLON) | (1L << PLUS) | (1L << MINUS) | (1L << ASTERISK) | (1L << INC) | (1L << DEC) | (1L << AND) | (1L << BIT_NOT) | (1L << LESS_THAN) | (1L << GREATER_THAN) | (1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << INLINE) | (1L << VOLATILE) | (1L << STATIC) | (1L << INTERRUPT) | (1L << REGISTER) | (1L << LOCAL_RESERVE) | (1L << ADDRESS) | (1L << ADDRESS_ZEROPAGE) | (1L << ADDRESS_MAINMEM) | (1L << FORM_SSA) | (1L << FORM_MA) | (1L << INTRINSIC) | (1L << CALLINGCONVENTION) | (1L << IF) | (1L << WHILE) | (1L << DO) | (1L << FOR) | (1L << SWITCH) | (1L << RETURN))) != 0) || ((((_la - 64)) & ~0x3f) == 0 && ((1L << (_la - 64)) & ((1L << (BREAK - 64)) | (1L << (CONTINUE - 64)) | (1L << (ASM - 64)) | (1L << (STRUCT - 64)) | (1L << (ENUM - 64)) | (1L << (SIZEOF - 64)) | (1L << (TYPEID - 64)) | (1L << (DEFINED - 64)) | (1L << (KICKASM - 64)) | (1L << (LOGIC_NOT - 64)) | (1L << (SIGNEDNESS - 64)) | (1L << (SIMPLETYPE - 64)) | (1L << (BOOLEAN - 64)) | (1L << (NUMBER - 64)) | (1L << (NAME - 64)) | (1L << (STRING - 64)) | (1L << (CHAR - 64)))) != 0)) {
				{
				setState(271);
				stmtSeq();
				}
			}

			setState(274);
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
		enterRule(_localctx, 40, RULE_parameterListDecl);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(276);
			parameterDecl();
			setState(281);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==COMMA) {
				{
				{
				setState(277);
				match(COMMA);
				setState(278);
				parameterDecl();
				}
				}
				setState(283);
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
		public DeclaratorContext declarator() {
			return getRuleContext(DeclaratorContext.class,0);
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
		enterRule(_localctx, 42, RULE_parameterDecl);
		try {
			setState(289);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,25,_ctx) ) {
			case 1:
				_localctx = new ParameterDeclTypeContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(284);
				declType();
				setState(285);
				declarator(0);
				}
				break;
			case 2:
				_localctx = new ParameterDeclVoidContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(287);
				match(SIMPLETYPE);
				}
				break;
			case 3:
				_localctx = new ParameterDeclListContext(_localctx);
				enterOuterAlt(_localctx, 3);
				{
				setState(288);
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

	public static class PragmaContext extends ParserRuleContext {
		public TerminalNode PRAGMA() { return getToken(KickCParser.PRAGMA, 0); }
		public TerminalNode NAME() { return getToken(KickCParser.NAME, 0); }
		public TerminalNode PAR_BEGIN() { return getToken(KickCParser.PAR_BEGIN, 0); }
		public List<PragmaParamContext> pragmaParam() {
			return getRuleContexts(PragmaParamContext.class);
		}
		public PragmaParamContext pragmaParam(int i) {
			return getRuleContext(PragmaParamContext.class,i);
		}
		public TerminalNode PAR_END() { return getToken(KickCParser.PAR_END, 0); }
		public List<TerminalNode> COMMA() { return getTokens(KickCParser.COMMA); }
		public TerminalNode COMMA(int i) {
			return getToken(KickCParser.COMMA, i);
		}
		public PragmaContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_pragma; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterPragma(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitPragma(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitPragma(this);
			else return visitor.visitChildren(this);
		}
	}

	public final PragmaContext pragma() throws RecognitionException {
		PragmaContext _localctx = new PragmaContext(_ctx, getState());
		enterRule(_localctx, 44, RULE_pragma);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(291);
			match(PRAGMA);
			setState(292);
			match(NAME);
			setState(293);
			match(PAR_BEGIN);
			setState(294);
			pragmaParam();
			setState(299);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==COMMA) {
				{
				{
				setState(295);
				match(COMMA);
				setState(296);
				pragmaParam();
				}
				}
				setState(301);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(302);
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

	public static class PragmaParamContext extends ParserRuleContext {
		public PragmaParamContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_pragmaParam; }
	 
		public PragmaParamContext() { }
		public void copyFrom(PragmaParamContext ctx) {
			super.copyFrom(ctx);
		}
	}
	public static class PragmaParamNumberContext extends PragmaParamContext {
		public TerminalNode NUMBER() { return getToken(KickCParser.NUMBER, 0); }
		public PragmaParamNumberContext(PragmaParamContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterPragmaParamNumber(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitPragmaParamNumber(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitPragmaParamNumber(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class PragmaParamStringContext extends PragmaParamContext {
		public TerminalNode STRING() { return getToken(KickCParser.STRING, 0); }
		public PragmaParamStringContext(PragmaParamContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterPragmaParamString(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitPragmaParamString(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitPragmaParamString(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class PragmaParamNameContext extends PragmaParamContext {
		public TerminalNode NAME() { return getToken(KickCParser.NAME, 0); }
		public PragmaParamNameContext(PragmaParamContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterPragmaParamName(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitPragmaParamName(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitPragmaParamName(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class PragmaParamCallingConventionContext extends PragmaParamContext {
		public TerminalNode CALLINGCONVENTION() { return getToken(KickCParser.CALLINGCONVENTION, 0); }
		public PragmaParamCallingConventionContext(PragmaParamContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterPragmaParamCallingConvention(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitPragmaParamCallingConvention(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitPragmaParamCallingConvention(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class PragmaParamRangeContext extends PragmaParamContext {
		public List<TerminalNode> NUMBER() { return getTokens(KickCParser.NUMBER); }
		public TerminalNode NUMBER(int i) {
			return getToken(KickCParser.NUMBER, i);
		}
		public TerminalNode RANGE() { return getToken(KickCParser.RANGE, 0); }
		public PragmaParamRangeContext(PragmaParamContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterPragmaParamRange(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitPragmaParamRange(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitPragmaParamRange(this);
			else return visitor.visitChildren(this);
		}
	}

	public final PragmaParamContext pragmaParam() throws RecognitionException {
		PragmaParamContext _localctx = new PragmaParamContext(_ctx, getState());
		enterRule(_localctx, 46, RULE_pragmaParam);
		try {
			setState(311);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,27,_ctx) ) {
			case 1:
				_localctx = new PragmaParamNumberContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(304);
				match(NUMBER);
				}
				break;
			case 2:
				_localctx = new PragmaParamRangeContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(305);
				match(NUMBER);
				setState(306);
				match(RANGE);
				setState(307);
				match(NUMBER);
				}
				break;
			case 3:
				_localctx = new PragmaParamNameContext(_localctx);
				enterOuterAlt(_localctx, 3);
				{
				setState(308);
				match(NAME);
				}
				break;
			case 4:
				_localctx = new PragmaParamStringContext(_localctx);
				enterOuterAlt(_localctx, 4);
				{
				setState(309);
				match(STRING);
				}
				break;
			case 5:
				_localctx = new PragmaParamCallingConventionContext(_localctx);
				enterOuterAlt(_localctx, 5);
				{
				setState(310);
				match(CALLINGCONVENTION);
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
		public List<PragmaParamContext> pragmaParam() {
			return getRuleContexts(PragmaParamContext.class);
		}
		public PragmaParamContext pragmaParam(int i) {
			return getRuleContext(PragmaParamContext.class,i);
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
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
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
		enterRule(_localctx, 48, RULE_directive);
		int _la;
		try {
			setState(358);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case CONST:
				_localctx = new DirectiveConstContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(313);
				match(CONST);
				}
				break;
			case ALIGN:
				_localctx = new DirectiveAlignContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(314);
				match(ALIGN);
				setState(315);
				match(PAR_BEGIN);
				setState(316);
				match(NUMBER);
				setState(317);
				match(PAR_END);
				}
				break;
			case REGISTER:
				_localctx = new DirectiveRegisterContext(_localctx);
				enterOuterAlt(_localctx, 3);
				{
				setState(318);
				match(REGISTER);
				setState(322);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,28,_ctx) ) {
				case 1:
					{
					setState(319);
					match(PAR_BEGIN);
					{
					setState(320);
					match(NAME);
					}
					setState(321);
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
				setState(324);
				match(ADDRESS_ZEROPAGE);
				}
				break;
			case ADDRESS_MAINMEM:
				_localctx = new DirectiveMemoryAreaMainContext(_localctx);
				enterOuterAlt(_localctx, 5);
				{
				setState(325);
				match(ADDRESS_MAINMEM);
				}
				break;
			case ADDRESS:
				_localctx = new DirectiveMemoryAreaAddressContext(_localctx);
				enterOuterAlt(_localctx, 6);
				{
				setState(326);
				match(ADDRESS);
				setState(327);
				match(PAR_BEGIN);
				{
				setState(328);
				expr(0);
				}
				setState(329);
				match(PAR_END);
				}
				break;
			case VOLATILE:
				_localctx = new DirectiveVolatileContext(_localctx);
				enterOuterAlt(_localctx, 7);
				{
				setState(331);
				match(VOLATILE);
				}
				break;
			case STATIC:
				_localctx = new DirectiveStaticContext(_localctx);
				enterOuterAlt(_localctx, 8);
				{
				setState(332);
				match(STATIC);
				}
				break;
			case FORM_SSA:
				_localctx = new DirectiveFormSsaContext(_localctx);
				enterOuterAlt(_localctx, 9);
				{
				setState(333);
				match(FORM_SSA);
				}
				break;
			case FORM_MA:
				_localctx = new DirectiveFormMaContext(_localctx);
				enterOuterAlt(_localctx, 10);
				{
				setState(334);
				match(FORM_MA);
				}
				break;
			case EXTERN:
				_localctx = new DirectiveExternContext(_localctx);
				enterOuterAlt(_localctx, 11);
				{
				setState(335);
				match(EXTERN);
				}
				break;
			case EXPORT:
				_localctx = new DirectiveExportContext(_localctx);
				enterOuterAlt(_localctx, 12);
				{
				setState(336);
				match(EXPORT);
				}
				break;
			case INLINE:
				_localctx = new DirectiveInlineContext(_localctx);
				enterOuterAlt(_localctx, 13);
				{
				setState(337);
				match(INLINE);
				}
				break;
			case INTRINSIC:
				_localctx = new DirectiveIntrinsicContext(_localctx);
				enterOuterAlt(_localctx, 14);
				{
				setState(338);
				match(INTRINSIC);
				}
				break;
			case INTERRUPT:
				_localctx = new DirectiveInterruptContext(_localctx);
				enterOuterAlt(_localctx, 15);
				{
				setState(339);
				match(INTERRUPT);
				setState(343);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,29,_ctx) ) {
				case 1:
					{
					setState(340);
					match(PAR_BEGIN);
					setState(341);
					match(NAME);
					setState(342);
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
				setState(345);
				match(LOCAL_RESERVE);
				setState(346);
				match(PAR_BEGIN);
				setState(347);
				pragmaParam();
				setState(352);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (_la==COMMA) {
					{
					{
					setState(348);
					match(COMMA);
					setState(349);
					pragmaParam();
					}
					}
					setState(354);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				setState(355);
				match(PAR_END);
				}
				break;
			case CALLINGCONVENTION:
				_localctx = new DirectiveCallingConventionContext(_localctx);
				enterOuterAlt(_localctx, 17);
				{
				setState(357);
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
		enterRule(_localctx, 50, RULE_stmtSeq);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(361); 
			_errHandler.sync(this);
			_la = _input.LA(1);
			do {
				{
				{
				setState(360);
				stmt();
				}
				}
				setState(363); 
				_errHandler.sync(this);
				_la = _input.LA(1);
			} while ( (((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << TYPEDEFNAME) | (1L << CURLY_BEGIN) | (1L << PAR_BEGIN) | (1L << SEMICOLON) | (1L << PLUS) | (1L << MINUS) | (1L << ASTERISK) | (1L << INC) | (1L << DEC) | (1L << AND) | (1L << BIT_NOT) | (1L << LESS_THAN) | (1L << GREATER_THAN) | (1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << INLINE) | (1L << VOLATILE) | (1L << STATIC) | (1L << INTERRUPT) | (1L << REGISTER) | (1L << LOCAL_RESERVE) | (1L << ADDRESS) | (1L << ADDRESS_ZEROPAGE) | (1L << ADDRESS_MAINMEM) | (1L << FORM_SSA) | (1L << FORM_MA) | (1L << INTRINSIC) | (1L << CALLINGCONVENTION) | (1L << IF) | (1L << WHILE) | (1L << DO) | (1L << FOR) | (1L << SWITCH) | (1L << RETURN))) != 0) || ((((_la - 64)) & ~0x3f) == 0 && ((1L << (_la - 64)) & ((1L << (BREAK - 64)) | (1L << (CONTINUE - 64)) | (1L << (ASM - 64)) | (1L << (STRUCT - 64)) | (1L << (ENUM - 64)) | (1L << (SIZEOF - 64)) | (1L << (TYPEID - 64)) | (1L << (DEFINED - 64)) | (1L << (KICKASM - 64)) | (1L << (LOGIC_NOT - 64)) | (1L << (SIGNEDNESS - 64)) | (1L << (SIMPLETYPE - 64)) | (1L << (BOOLEAN - 64)) | (1L << (NUMBER - 64)) | (1L << (NAME - 64)) | (1L << (STRING - 64)) | (1L << (CHAR - 64)))) != 0) );
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
		public KasmContentContext kasmContent() {
			return getRuleContext(KasmContentContext.class,0);
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
	public static class StmtEmptyContext extends StmtContext {
		public TerminalNode SEMICOLON() { return getToken(KickCParser.SEMICOLON, 0); }
		public StmtEmptyContext(StmtContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterStmtEmpty(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitStmtEmpty(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitStmtEmpty(this);
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
		enterRule(_localctx, 52, RULE_stmt);
		int _la;
		try {
			setState(450);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,40,_ctx) ) {
			case 1:
				_localctx = new StmtDeclVarContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(365);
				declVariables();
				setState(366);
				match(SEMICOLON);
				}
				break;
			case 2:
				_localctx = new StmtBlockContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(368);
				match(CURLY_BEGIN);
				setState(370);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << TYPEDEFNAME) | (1L << CURLY_BEGIN) | (1L << PAR_BEGIN) | (1L << SEMICOLON) | (1L << PLUS) | (1L << MINUS) | (1L << ASTERISK) | (1L << INC) | (1L << DEC) | (1L << AND) | (1L << BIT_NOT) | (1L << LESS_THAN) | (1L << GREATER_THAN) | (1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << INLINE) | (1L << VOLATILE) | (1L << STATIC) | (1L << INTERRUPT) | (1L << REGISTER) | (1L << LOCAL_RESERVE) | (1L << ADDRESS) | (1L << ADDRESS_ZEROPAGE) | (1L << ADDRESS_MAINMEM) | (1L << FORM_SSA) | (1L << FORM_MA) | (1L << INTRINSIC) | (1L << CALLINGCONVENTION) | (1L << IF) | (1L << WHILE) | (1L << DO) | (1L << FOR) | (1L << SWITCH) | (1L << RETURN))) != 0) || ((((_la - 64)) & ~0x3f) == 0 && ((1L << (_la - 64)) & ((1L << (BREAK - 64)) | (1L << (CONTINUE - 64)) | (1L << (ASM - 64)) | (1L << (STRUCT - 64)) | (1L << (ENUM - 64)) | (1L << (SIZEOF - 64)) | (1L << (TYPEID - 64)) | (1L << (DEFINED - 64)) | (1L << (KICKASM - 64)) | (1L << (LOGIC_NOT - 64)) | (1L << (SIGNEDNESS - 64)) | (1L << (SIMPLETYPE - 64)) | (1L << (BOOLEAN - 64)) | (1L << (NUMBER - 64)) | (1L << (NAME - 64)) | (1L << (STRING - 64)) | (1L << (CHAR - 64)))) != 0)) {
					{
					setState(369);
					stmtSeq();
					}
				}

				setState(372);
				match(CURLY_END);
				}
				break;
			case 3:
				_localctx = new StmtExprContext(_localctx);
				enterOuterAlt(_localctx, 3);
				{
				setState(373);
				commaExpr(0);
				setState(374);
				match(SEMICOLON);
				}
				break;
			case 4:
				_localctx = new StmtIfElseContext(_localctx);
				enterOuterAlt(_localctx, 4);
				{
				setState(376);
				match(IF);
				setState(377);
				match(PAR_BEGIN);
				setState(378);
				commaExpr(0);
				setState(379);
				match(PAR_END);
				setState(380);
				stmt();
				setState(383);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,34,_ctx) ) {
				case 1:
					{
					setState(381);
					match(ELSE);
					setState(382);
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
				setState(388);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << INLINE) | (1L << VOLATILE) | (1L << STATIC) | (1L << INTERRUPT) | (1L << REGISTER) | (1L << LOCAL_RESERVE) | (1L << ADDRESS) | (1L << ADDRESS_ZEROPAGE) | (1L << ADDRESS_MAINMEM) | (1L << FORM_SSA) | (1L << FORM_MA) | (1L << INTRINSIC) | (1L << CALLINGCONVENTION))) != 0)) {
					{
					{
					setState(385);
					directive();
					}
					}
					setState(390);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				setState(391);
				match(WHILE);
				setState(392);
				match(PAR_BEGIN);
				setState(393);
				commaExpr(0);
				setState(394);
				match(PAR_END);
				setState(395);
				stmt();
				}
				break;
			case 6:
				_localctx = new StmtDoWhileContext(_localctx);
				enterOuterAlt(_localctx, 6);
				{
				setState(400);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << INLINE) | (1L << VOLATILE) | (1L << STATIC) | (1L << INTERRUPT) | (1L << REGISTER) | (1L << LOCAL_RESERVE) | (1L << ADDRESS) | (1L << ADDRESS_ZEROPAGE) | (1L << ADDRESS_MAINMEM) | (1L << FORM_SSA) | (1L << FORM_MA) | (1L << INTRINSIC) | (1L << CALLINGCONVENTION))) != 0)) {
					{
					{
					setState(397);
					directive();
					}
					}
					setState(402);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				setState(403);
				match(DO);
				setState(404);
				stmt();
				setState(405);
				match(WHILE);
				setState(406);
				match(PAR_BEGIN);
				setState(407);
				commaExpr(0);
				setState(408);
				match(PAR_END);
				setState(409);
				match(SEMICOLON);
				}
				break;
			case 7:
				_localctx = new StmtForContext(_localctx);
				enterOuterAlt(_localctx, 7);
				{
				setState(414);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << INLINE) | (1L << VOLATILE) | (1L << STATIC) | (1L << INTERRUPT) | (1L << REGISTER) | (1L << LOCAL_RESERVE) | (1L << ADDRESS) | (1L << ADDRESS_ZEROPAGE) | (1L << ADDRESS_MAINMEM) | (1L << FORM_SSA) | (1L << FORM_MA) | (1L << INTRINSIC) | (1L << CALLINGCONVENTION))) != 0)) {
					{
					{
					setState(411);
					directive();
					}
					}
					setState(416);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				setState(417);
				match(FOR);
				setState(418);
				match(PAR_BEGIN);
				setState(419);
				forLoop();
				setState(420);
				match(PAR_END);
				setState(421);
				stmt();
				}
				break;
			case 8:
				_localctx = new StmtSwitchContext(_localctx);
				enterOuterAlt(_localctx, 8);
				{
				setState(423);
				match(SWITCH);
				setState(424);
				match(PAR_BEGIN);
				setState(425);
				commaExpr(0);
				setState(426);
				match(PAR_END);
				setState(427);
				match(CURLY_BEGIN);
				setState(428);
				switchCases();
				setState(429);
				match(CURLY_END);
				}
				break;
			case 9:
				_localctx = new StmtReturnContext(_localctx);
				enterOuterAlt(_localctx, 9);
				{
				setState(431);
				match(RETURN);
				setState(433);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << CURLY_BEGIN) | (1L << PAR_BEGIN) | (1L << PLUS) | (1L << MINUS) | (1L << ASTERISK) | (1L << INC) | (1L << DEC) | (1L << AND) | (1L << BIT_NOT) | (1L << LESS_THAN) | (1L << GREATER_THAN))) != 0) || ((((_la - 71)) & ~0x3f) == 0 && ((1L << (_la - 71)) & ((1L << (SIZEOF - 71)) | (1L << (TYPEID - 71)) | (1L << (DEFINED - 71)) | (1L << (LOGIC_NOT - 71)) | (1L << (BOOLEAN - 71)) | (1L << (NUMBER - 71)) | (1L << (NAME - 71)) | (1L << (STRING - 71)) | (1L << (CHAR - 71)))) != 0)) {
					{
					setState(432);
					commaExpr(0);
					}
				}

				setState(435);
				match(SEMICOLON);
				}
				break;
			case 10:
				_localctx = new StmtBreakContext(_localctx);
				enterOuterAlt(_localctx, 10);
				{
				setState(436);
				match(BREAK);
				setState(437);
				match(SEMICOLON);
				}
				break;
			case 11:
				_localctx = new StmtContinueContext(_localctx);
				enterOuterAlt(_localctx, 11);
				{
				setState(438);
				match(CONTINUE);
				setState(439);
				match(SEMICOLON);
				}
				break;
			case 12:
				_localctx = new StmtAsmContext(_localctx);
				enterOuterAlt(_localctx, 12);
				{
				setState(440);
				match(ASM);
				setState(442);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if (_la==PAR_BEGIN) {
					{
					setState(441);
					asmDirectives();
					}
				}

				setState(444);
				match(CURLY_BEGIN);
				setState(445);
				asmLines();
				setState(446);
				match(ASM_CURLY_END);
				}
				break;
			case 13:
				_localctx = new StmtDeclKasmContext(_localctx);
				enterOuterAlt(_localctx, 13);
				{
				setState(448);
				kasmContent();
				}
				break;
			case 14:
				_localctx = new StmtEmptyContext(_localctx);
				enterOuterAlt(_localctx, 14);
				{
				setState(449);
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
		enterRule(_localctx, 54, RULE_switchCases);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(453); 
			_errHandler.sync(this);
			_la = _input.LA(1);
			do {
				{
				{
				setState(452);
				switchCase();
				}
				}
				setState(455); 
				_errHandler.sync(this);
				_la = _input.LA(1);
			} while ( _la==CASE );
			setState(462);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==DEFAULT) {
				{
				setState(457);
				match(DEFAULT);
				setState(458);
				match(COLON);
				setState(460);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << TYPEDEFNAME) | (1L << CURLY_BEGIN) | (1L << PAR_BEGIN) | (1L << SEMICOLON) | (1L << PLUS) | (1L << MINUS) | (1L << ASTERISK) | (1L << INC) | (1L << DEC) | (1L << AND) | (1L << BIT_NOT) | (1L << LESS_THAN) | (1L << GREATER_THAN) | (1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << INLINE) | (1L << VOLATILE) | (1L << STATIC) | (1L << INTERRUPT) | (1L << REGISTER) | (1L << LOCAL_RESERVE) | (1L << ADDRESS) | (1L << ADDRESS_ZEROPAGE) | (1L << ADDRESS_MAINMEM) | (1L << FORM_SSA) | (1L << FORM_MA) | (1L << INTRINSIC) | (1L << CALLINGCONVENTION) | (1L << IF) | (1L << WHILE) | (1L << DO) | (1L << FOR) | (1L << SWITCH) | (1L << RETURN))) != 0) || ((((_la - 64)) & ~0x3f) == 0 && ((1L << (_la - 64)) & ((1L << (BREAK - 64)) | (1L << (CONTINUE - 64)) | (1L << (ASM - 64)) | (1L << (STRUCT - 64)) | (1L << (ENUM - 64)) | (1L << (SIZEOF - 64)) | (1L << (TYPEID - 64)) | (1L << (DEFINED - 64)) | (1L << (KICKASM - 64)) | (1L << (LOGIC_NOT - 64)) | (1L << (SIGNEDNESS - 64)) | (1L << (SIMPLETYPE - 64)) | (1L << (BOOLEAN - 64)) | (1L << (NUMBER - 64)) | (1L << (NAME - 64)) | (1L << (STRING - 64)) | (1L << (CHAR - 64)))) != 0)) {
					{
					setState(459);
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
		enterRule(_localctx, 56, RULE_switchCase);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(464);
			match(CASE);
			setState(465);
			expr(0);
			setState(466);
			match(COLON);
			setState(468);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << TYPEDEFNAME) | (1L << CURLY_BEGIN) | (1L << PAR_BEGIN) | (1L << SEMICOLON) | (1L << PLUS) | (1L << MINUS) | (1L << ASTERISK) | (1L << INC) | (1L << DEC) | (1L << AND) | (1L << BIT_NOT) | (1L << LESS_THAN) | (1L << GREATER_THAN) | (1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << INLINE) | (1L << VOLATILE) | (1L << STATIC) | (1L << INTERRUPT) | (1L << REGISTER) | (1L << LOCAL_RESERVE) | (1L << ADDRESS) | (1L << ADDRESS_ZEROPAGE) | (1L << ADDRESS_MAINMEM) | (1L << FORM_SSA) | (1L << FORM_MA) | (1L << INTRINSIC) | (1L << CALLINGCONVENTION) | (1L << IF) | (1L << WHILE) | (1L << DO) | (1L << FOR) | (1L << SWITCH) | (1L << RETURN))) != 0) || ((((_la - 64)) & ~0x3f) == 0 && ((1L << (_la - 64)) & ((1L << (BREAK - 64)) | (1L << (CONTINUE - 64)) | (1L << (ASM - 64)) | (1L << (STRUCT - 64)) | (1L << (ENUM - 64)) | (1L << (SIZEOF - 64)) | (1L << (TYPEID - 64)) | (1L << (DEFINED - 64)) | (1L << (KICKASM - 64)) | (1L << (LOGIC_NOT - 64)) | (1L << (SIGNEDNESS - 64)) | (1L << (SIMPLETYPE - 64)) | (1L << (BOOLEAN - 64)) | (1L << (NUMBER - 64)) | (1L << (NAME - 64)) | (1L << (STRING - 64)) | (1L << (CHAR - 64)))) != 0)) {
				{
				setState(467);
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
		public DeclTypeContext declType() {
			return getRuleContext(DeclTypeContext.class,0);
		}
		public DeclaratorContext declarator() {
			return getRuleContext(DeclaratorContext.class,0);
		}
		public TerminalNode COLON() { return getToken(KickCParser.COLON, 0); }
		public List<ExprContext> expr() {
			return getRuleContexts(ExprContext.class);
		}
		public ExprContext expr(int i) {
			return getRuleContext(ExprContext.class,i);
		}
		public TerminalNode RANGE() { return getToken(KickCParser.RANGE, 0); }
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
		public ForClassicConditionContext forClassicCondition() {
			return getRuleContext(ForClassicConditionContext.class,0);
		}
		public CommaExprContext commaExpr() {
			return getRuleContext(CommaExprContext.class,0);
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
		enterRule(_localctx, 58, RULE_forLoop);
		int _la;
		try {
			setState(486);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,47,_ctx) ) {
			case 1:
				_localctx = new ForClassicContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(470);
				forClassicInit();
				setState(471);
				match(SEMICOLON);
				setState(473);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << CURLY_BEGIN) | (1L << PAR_BEGIN) | (1L << PLUS) | (1L << MINUS) | (1L << ASTERISK) | (1L << INC) | (1L << DEC) | (1L << AND) | (1L << BIT_NOT) | (1L << LESS_THAN) | (1L << GREATER_THAN))) != 0) || ((((_la - 71)) & ~0x3f) == 0 && ((1L << (_la - 71)) & ((1L << (SIZEOF - 71)) | (1L << (TYPEID - 71)) | (1L << (DEFINED - 71)) | (1L << (LOGIC_NOT - 71)) | (1L << (BOOLEAN - 71)) | (1L << (NUMBER - 71)) | (1L << (NAME - 71)) | (1L << (STRING - 71)) | (1L << (CHAR - 71)))) != 0)) {
					{
					setState(472);
					forClassicCondition();
					}
				}

				setState(475);
				match(SEMICOLON);
				setState(477);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << CURLY_BEGIN) | (1L << PAR_BEGIN) | (1L << PLUS) | (1L << MINUS) | (1L << ASTERISK) | (1L << INC) | (1L << DEC) | (1L << AND) | (1L << BIT_NOT) | (1L << LESS_THAN) | (1L << GREATER_THAN))) != 0) || ((((_la - 71)) & ~0x3f) == 0 && ((1L << (_la - 71)) & ((1L << (SIZEOF - 71)) | (1L << (TYPEID - 71)) | (1L << (DEFINED - 71)) | (1L << (LOGIC_NOT - 71)) | (1L << (BOOLEAN - 71)) | (1L << (NUMBER - 71)) | (1L << (NAME - 71)) | (1L << (STRING - 71)) | (1L << (CHAR - 71)))) != 0)) {
					{
					setState(476);
					commaExpr(0);
					}
				}

				}
				break;
			case 2:
				_localctx = new ForRangeContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(479);
				declType();
				setState(480);
				declarator(0);
				setState(481);
				match(COLON);
				setState(482);
				expr(0);
				setState(483);
				match(RANGE);
				setState(484);
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
		enterRule(_localctx, 60, RULE_forClassicInit);
		int _la;
		try {
			setState(492);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case TYPEDEFNAME:
			case SEMICOLON:
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
			case SIGNEDNESS:
			case SIMPLETYPE:
				_localctx = new ForClassicInitDeclContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(489);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << TYPEDEFNAME) | (1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << INLINE) | (1L << VOLATILE) | (1L << STATIC) | (1L << INTERRUPT) | (1L << REGISTER) | (1L << LOCAL_RESERVE) | (1L << ADDRESS) | (1L << ADDRESS_ZEROPAGE) | (1L << ADDRESS_MAINMEM) | (1L << FORM_SSA) | (1L << FORM_MA) | (1L << INTRINSIC) | (1L << CALLINGCONVENTION))) != 0) || ((((_la - 69)) & ~0x3f) == 0 && ((1L << (_la - 69)) & ((1L << (STRUCT - 69)) | (1L << (ENUM - 69)) | (1L << (SIGNEDNESS - 69)) | (1L << (SIMPLETYPE - 69)))) != 0)) {
					{
					setState(488);
					declVariables();
					}
				}

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
				_localctx = new ForClassicInitExprContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(491);
				commaExpr(0);
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

	public static class ForClassicConditionContext extends ParserRuleContext {
		public CommaExprContext commaExpr() {
			return getRuleContext(CommaExprContext.class,0);
		}
		public ForClassicConditionContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_forClassicCondition; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterForClassicCondition(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitForClassicCondition(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitForClassicCondition(this);
			else return visitor.visitChildren(this);
		}
	}

	public final ForClassicConditionContext forClassicCondition() throws RecognitionException {
		ForClassicConditionContext _localctx = new ForClassicConditionContext(_ctx, getState());
		enterRule(_localctx, 62, RULE_forClassicCondition);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(494);
			commaExpr(0);
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
		int _startState = 64;
		enterRecursionRule(_localctx, 64, RULE_commaExpr, _p);
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			{
			_localctx = new CommaNoneContext(_localctx);
			_ctx = _localctx;
			_prevctx = _localctx;

			setState(497);
			expr(0);
			}
			_ctx.stop = _input.LT(-1);
			setState(504);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,50,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					{
					_localctx = new CommaSimpleContext(new CommaExprContext(_parentctx, _parentState));
					pushNewRecursionContext(_localctx, _startState, RULE_commaExpr);
					setState(499);
					if (!(precpred(_ctx, 1))) throw new FailedPredicateException(this, "precpred(_ctx, 1)");
					setState(500);
					match(COMMA);
					setState(501);
					expr(0);
					}
					} 
				}
				setState(506);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,50,_ctx);
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
		int _startState = 66;
		enterRecursionRule(_localctx, 66, RULE_expr, _p);
		int _la;
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(572);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,58,_ctx) ) {
			case 1:
				{
				_localctx = new ExprParContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;

				setState(508);
				match(PAR_BEGIN);
				setState(509);
				commaExpr(0);
				setState(510);
				match(PAR_END);
				}
				break;
			case 2:
				{
				_localctx = new ExprSizeOfContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(512);
				match(SIZEOF);
				setState(513);
				match(PAR_BEGIN);
				setState(516);
				_errHandler.sync(this);
				switch (_input.LA(1)) {
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
					setState(514);
					expr(0);
					}
					break;
				case TYPEDEFNAME:
				case STRUCT:
				case ENUM:
				case SIGNEDNESS:
				case SIMPLETYPE:
					{
					setState(515);
					typeSpecifier(0);
					}
					break;
				default:
					throw new NoViableAltException(this);
				}
				setState(518);
				match(PAR_END);
				}
				break;
			case 3:
				{
				_localctx = new ExprTypeIdContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(520);
				match(TYPEID);
				setState(521);
				match(PAR_BEGIN);
				setState(524);
				_errHandler.sync(this);
				switch (_input.LA(1)) {
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
					setState(522);
					expr(0);
					}
					break;
				case TYPEDEFNAME:
				case STRUCT:
				case ENUM:
				case SIGNEDNESS:
				case SIMPLETYPE:
					{
					setState(523);
					typeSpecifier(0);
					}
					break;
				default:
					throw new NoViableAltException(this);
				}
				setState(526);
				match(PAR_END);
				}
				break;
			case 4:
				{
				_localctx = new ExprDefinedContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(528);
				match(DEFINED);
				setState(530);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if (_la==PAR_BEGIN) {
					{
					setState(529);
					match(PAR_BEGIN);
					}
				}

				setState(532);
				match(NAME);
				setState(534);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,54,_ctx) ) {
				case 1:
					{
					setState(533);
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
				setState(536);
				match(PAR_BEGIN);
				setState(537);
				typeSpecifier(0);
				setState(538);
				match(PAR_END);
				setState(539);
				expr(24);
				}
				break;
			case 6:
				{
				_localctx = new ExprPreModContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(541);
				_la = _input.LA(1);
				if ( !(_la==INC || _la==DEC) ) {
				_errHandler.recoverInline(this);
				}
				else {
					if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
					_errHandler.reportMatch(this);
					consume();
				}
				setState(542);
				expr(23);
				}
				break;
			case 7:
				{
				_localctx = new ExprPtrContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(543);
				match(ASTERISK);
				setState(544);
				expr(21);
				}
				break;
			case 8:
				{
				_localctx = new ExprUnaryContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(545);
				_la = _input.LA(1);
				if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << PLUS) | (1L << MINUS) | (1L << AND) | (1L << BIT_NOT))) != 0) || _la==LOGIC_NOT) ) {
				_errHandler.recoverInline(this);
				}
				else {
					if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
					_errHandler.reportMatch(this);
					consume();
				}
				setState(546);
				expr(20);
				}
				break;
			case 9:
				{
				_localctx = new ExprUnaryContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(547);
				_la = _input.LA(1);
				if ( !(_la==LESS_THAN || _la==GREATER_THAN) ) {
				_errHandler.recoverInline(this);
				}
				else {
					if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
					_errHandler.reportMatch(this);
					consume();
				}
				setState(548);
				expr(16);
				}
				break;
			case 10:
				{
				_localctx = new InitListContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(549);
				match(CURLY_BEGIN);
				setState(550);
				expr(0);
				setState(555);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,55,_ctx);
				while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
					if ( _alt==1 ) {
						{
						{
						setState(551);
						match(COMMA);
						setState(552);
						expr(0);
						}
						} 
					}
					setState(557);
					_errHandler.sync(this);
					_alt = getInterpreter().adaptivePredict(_input,55,_ctx);
				}
				setState(559);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if (_la==COMMA) {
					{
					setState(558);
					match(COMMA);
					}
				}

				setState(561);
				match(CURLY_END);
				}
				break;
			case 11:
				{
				_localctx = new ExprIdContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(563);
				match(NAME);
				}
				break;
			case 12:
				{
				_localctx = new ExprNumberContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(564);
				match(NUMBER);
				}
				break;
			case 13:
				{
				_localctx = new ExprStringContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(566); 
				_errHandler.sync(this);
				_alt = 1;
				do {
					switch (_alt) {
					case 1:
						{
						{
						setState(565);
						match(STRING);
						}
						}
						break;
					default:
						throw new NoViableAltException(this);
					}
					setState(568); 
					_errHandler.sync(this);
					_alt = getInterpreter().adaptivePredict(_input,57,_ctx);
				} while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER );
				}
				break;
			case 14:
				{
				_localctx = new ExprCharContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(570);
				match(CHAR);
				}
				break;
			case 15:
				{
				_localctx = new ExprBoolContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(571);
				match(BOOLEAN);
				}
				break;
			}
			_ctx.stop = _input.LT(-1);
			setState(634);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,61,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					setState(632);
					_errHandler.sync(this);
					switch ( getInterpreter().adaptivePredict(_input,60,_ctx) ) {
					case 1:
						{
						_localctx = new ExprBinaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(574);
						if (!(precpred(_ctx, 19))) throw new FailedPredicateException(this, "precpred(_ctx, 19)");
						setState(575);
						_la = _input.LA(1);
						if ( !(_la==SHIFT_LEFT || _la==SHIFT_RIGHT) ) {
						_errHandler.recoverInline(this);
						}
						else {
							if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
							_errHandler.reportMatch(this);
							consume();
						}
						setState(576);
						expr(20);
						}
						break;
					case 2:
						{
						_localctx = new ExprBinaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(577);
						if (!(precpred(_ctx, 18))) throw new FailedPredicateException(this, "precpred(_ctx, 18)");
						setState(578);
						_la = _input.LA(1);
						if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << ASTERISK) | (1L << DIVIDE) | (1L << MODULO))) != 0)) ) {
						_errHandler.recoverInline(this);
						}
						else {
							if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
							_errHandler.reportMatch(this);
							consume();
						}
						setState(579);
						expr(19);
						}
						break;
					case 3:
						{
						_localctx = new ExprBinaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(580);
						if (!(precpred(_ctx, 17))) throw new FailedPredicateException(this, "precpred(_ctx, 17)");
						setState(581);
						_la = _input.LA(1);
						if ( !(_la==PLUS || _la==MINUS) ) {
						_errHandler.recoverInline(this);
						}
						else {
							if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
							_errHandler.reportMatch(this);
							consume();
						}
						setState(582);
						expr(18);
						}
						break;
					case 4:
						{
						_localctx = new ExprBinaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(583);
						if (!(precpred(_ctx, 15))) throw new FailedPredicateException(this, "precpred(_ctx, 15)");
						setState(584);
						_la = _input.LA(1);
						if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << EQUAL) | (1L << NOT_EQUAL) | (1L << LESS_THAN) | (1L << LESS_THAN_EQUAL) | (1L << GREATER_THAN_EQUAL) | (1L << GREATER_THAN))) != 0)) ) {
						_errHandler.recoverInline(this);
						}
						else {
							if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
							_errHandler.reportMatch(this);
							consume();
						}
						setState(585);
						expr(16);
						}
						break;
					case 5:
						{
						_localctx = new ExprBinaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(586);
						if (!(precpred(_ctx, 14))) throw new FailedPredicateException(this, "precpred(_ctx, 14)");
						{
						setState(587);
						match(AND);
						}
						setState(588);
						expr(15);
						}
						break;
					case 6:
						{
						_localctx = new ExprBinaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(589);
						if (!(precpred(_ctx, 13))) throw new FailedPredicateException(this, "precpred(_ctx, 13)");
						{
						setState(590);
						match(BIT_XOR);
						}
						setState(591);
						expr(14);
						}
						break;
					case 7:
						{
						_localctx = new ExprBinaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(592);
						if (!(precpred(_ctx, 12))) throw new FailedPredicateException(this, "precpred(_ctx, 12)");
						{
						setState(593);
						match(BIT_OR);
						}
						setState(594);
						expr(13);
						}
						break;
					case 8:
						{
						_localctx = new ExprBinaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(595);
						if (!(precpred(_ctx, 11))) throw new FailedPredicateException(this, "precpred(_ctx, 11)");
						{
						setState(596);
						match(LOGIC_AND);
						}
						setState(597);
						expr(12);
						}
						break;
					case 9:
						{
						_localctx = new ExprBinaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(598);
						if (!(precpred(_ctx, 10))) throw new FailedPredicateException(this, "precpred(_ctx, 10)");
						{
						setState(599);
						match(LOGIC_OR);
						}
						setState(600);
						expr(11);
						}
						break;
					case 10:
						{
						_localctx = new ExprTernaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(601);
						if (!(precpred(_ctx, 9))) throw new FailedPredicateException(this, "precpred(_ctx, 9)");
						setState(602);
						match(CONDITION);
						setState(603);
						expr(0);
						setState(604);
						match(COLON);
						setState(605);
						expr(10);
						}
						break;
					case 11:
						{
						_localctx = new ExprAssignmentContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(607);
						if (!(precpred(_ctx, 8))) throw new FailedPredicateException(this, "precpred(_ctx, 8)");
						setState(608);
						match(ASSIGN);
						setState(609);
						expr(8);
						}
						break;
					case 12:
						{
						_localctx = new ExprAssignmentCompoundContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(610);
						if (!(precpred(_ctx, 7))) throw new FailedPredicateException(this, "precpred(_ctx, 7)");
						setState(611);
						match(ASSIGN_COMPOUND);
						setState(612);
						expr(7);
						}
						break;
					case 13:
						{
						_localctx = new ExprDotContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(613);
						if (!(precpred(_ctx, 31))) throw new FailedPredicateException(this, "precpred(_ctx, 31)");
						setState(614);
						match(DOT);
						setState(615);
						match(NAME);
						}
						break;
					case 14:
						{
						_localctx = new ExprArrowContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(616);
						if (!(precpred(_ctx, 30))) throw new FailedPredicateException(this, "precpred(_ctx, 30)");
						setState(617);
						match(ARROW);
						setState(618);
						match(NAME);
						}
						break;
					case 15:
						{
						_localctx = new ExprCallContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(619);
						if (!(precpred(_ctx, 29))) throw new FailedPredicateException(this, "precpred(_ctx, 29)");
						setState(620);
						match(PAR_BEGIN);
						setState(622);
						_errHandler.sync(this);
						_la = _input.LA(1);
						if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << CURLY_BEGIN) | (1L << PAR_BEGIN) | (1L << PLUS) | (1L << MINUS) | (1L << ASTERISK) | (1L << INC) | (1L << DEC) | (1L << AND) | (1L << BIT_NOT) | (1L << LESS_THAN) | (1L << GREATER_THAN))) != 0) || ((((_la - 71)) & ~0x3f) == 0 && ((1L << (_la - 71)) & ((1L << (SIZEOF - 71)) | (1L << (TYPEID - 71)) | (1L << (DEFINED - 71)) | (1L << (LOGIC_NOT - 71)) | (1L << (BOOLEAN - 71)) | (1L << (NUMBER - 71)) | (1L << (NAME - 71)) | (1L << (STRING - 71)) | (1L << (CHAR - 71)))) != 0)) {
							{
							setState(621);
							parameterList();
							}
						}

						setState(624);
						match(PAR_END);
						}
						break;
					case 16:
						{
						_localctx = new ExprArrayContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(625);
						if (!(precpred(_ctx, 25))) throw new FailedPredicateException(this, "precpred(_ctx, 25)");
						setState(626);
						match(BRACKET_BEGIN);
						setState(627);
						commaExpr(0);
						setState(628);
						match(BRACKET_END);
						}
						break;
					case 17:
						{
						_localctx = new ExprPostModContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(630);
						if (!(precpred(_ctx, 22))) throw new FailedPredicateException(this, "precpred(_ctx, 22)");
						setState(631);
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
				setState(636);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,61,_ctx);
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
		enterRule(_localctx, 68, RULE_parameterList);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(637);
			expr(0);
			setState(642);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==COMMA) {
				{
				{
				setState(638);
				match(COMMA);
				setState(639);
				expr(0);
				}
				}
				setState(644);
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

	public static class KasmContentContext extends ParserRuleContext {
		public TerminalNode KICKASM() { return getToken(KickCParser.KICKASM, 0); }
		public TerminalNode KICKASM_BODY() { return getToken(KickCParser.KICKASM_BODY, 0); }
		public AsmDirectivesContext asmDirectives() {
			return getRuleContext(AsmDirectivesContext.class,0);
		}
		public KasmContentContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_kasmContent; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterKasmContent(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitKasmContent(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitKasmContent(this);
			else return visitor.visitChildren(this);
		}
	}

	public final KasmContentContext kasmContent() throws RecognitionException {
		KasmContentContext _localctx = new KasmContentContext(_ctx, getState());
		enterRule(_localctx, 70, RULE_kasmContent);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(645);
			match(KICKASM);
			setState(647);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==PAR_BEGIN) {
				{
				setState(646);
				asmDirectives();
				}
			}

			setState(649);
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
		enterRule(_localctx, 72, RULE_asmDirectives);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(651);
			match(PAR_BEGIN);
			setState(652);
			asmDirective();
			setState(657);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==COMMA) {
				{
				{
				setState(653);
				match(COMMA);
				setState(654);
				asmDirective();
				}
				}
				setState(659);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(660);
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
		enterRule(_localctx, 74, RULE_asmDirective);
		try {
			setState(672);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case RESOURCE:
				_localctx = new AsmDirectiveResourceContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(662);
				match(RESOURCE);
				setState(663);
				match(STRING);
				}
				break;
			case USES:
				_localctx = new AsmDirectiveUsesContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(664);
				match(USES);
				setState(665);
				match(NAME);
				}
				break;
			case CLOBBERS:
				_localctx = new AsmDirectiveClobberContext(_localctx);
				enterOuterAlt(_localctx, 3);
				{
				setState(666);
				match(CLOBBERS);
				setState(667);
				match(STRING);
				}
				break;
			case BYTES:
				_localctx = new AsmDirectiveBytesContext(_localctx);
				enterOuterAlt(_localctx, 4);
				{
				setState(668);
				match(BYTES);
				setState(669);
				expr(0);
				}
				break;
			case CYCLES:
				_localctx = new AsmDirectiveCyclesContext(_localctx);
				enterOuterAlt(_localctx, 5);
				{
				setState(670);
				match(CYCLES);
				setState(671);
				expr(0);
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
		enterRule(_localctx, 76, RULE_asmLines);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(677);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (((((_la - 113)) & ~0x3f) == 0 && ((1L << (_la - 113)) & ((1L << (ASM_BYTE - 113)) | (1L << (ASM_MNEMONIC - 113)) | (1L << (ASM_MULTI_NAME - 113)) | (1L << (ASM_NAME - 113)))) != 0)) {
				{
				{
				setState(674);
				asmLine();
				}
				}
				setState(679);
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
		enterRule(_localctx, 78, RULE_asmLine);
		try {
			setState(683);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case ASM_MULTI_NAME:
			case ASM_NAME:
				enterOuterAlt(_localctx, 1);
				{
				setState(680);
				asmLabel();
				}
				break;
			case ASM_MNEMONIC:
				enterOuterAlt(_localctx, 2);
				{
				setState(681);
				asmInstruction();
				}
				break;
			case ASM_BYTE:
				enterOuterAlt(_localctx, 3);
				{
				setState(682);
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
		public List<TerminalNode> ASM_TAG() { return getTokens(KickCParser.ASM_TAG); }
		public TerminalNode ASM_TAG(int i) {
			return getToken(KickCParser.ASM_TAG, i);
		}
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
		public List<TerminalNode> ASM_TAG() { return getTokens(KickCParser.ASM_TAG); }
		public TerminalNode ASM_TAG(int i) {
			return getToken(KickCParser.ASM_TAG, i);
		}
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
		enterRule(_localctx, 80, RULE_asmLabel);
		int _la;
		try {
			setState(701);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case ASM_NAME:
				_localctx = new AsmLabelNameContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(685);
				match(ASM_NAME);
				setState(686);
				match(ASM_COLON);
				setState(690);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (_la==ASM_TAG) {
					{
					{
					setState(687);
					match(ASM_TAG);
					}
					}
					setState(692);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				}
				break;
			case ASM_MULTI_NAME:
				_localctx = new AsmLabelMultiContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(693);
				match(ASM_MULTI_NAME);
				setState(694);
				match(ASM_COLON);
				setState(698);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (_la==ASM_TAG) {
					{
					{
					setState(695);
					match(ASM_TAG);
					}
					}
					setState(700);
					_errHandler.sync(this);
					_la = _input.LA(1);
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

	public static class AsmInstructionContext extends ParserRuleContext {
		public TerminalNode ASM_MNEMONIC() { return getToken(KickCParser.ASM_MNEMONIC, 0); }
		public AsmParamModeContext asmParamMode() {
			return getRuleContext(AsmParamModeContext.class,0);
		}
		public List<TerminalNode> ASM_TAG() { return getTokens(KickCParser.ASM_TAG); }
		public TerminalNode ASM_TAG(int i) {
			return getToken(KickCParser.ASM_TAG, i);
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
		enterRule(_localctx, 82, RULE_asmInstruction);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(703);
			match(ASM_MNEMONIC);
			setState(705);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,71,_ctx) ) {
			case 1:
				{
				setState(704);
				asmParamMode();
				}
				break;
			}
			setState(710);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==ASM_TAG) {
				{
				{
				setState(707);
				match(ASM_TAG);
				}
				}
				setState(712);
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
		public List<TerminalNode> ASM_TAG() { return getTokens(KickCParser.ASM_TAG); }
		public TerminalNode ASM_TAG(int i) {
			return getToken(KickCParser.ASM_TAG, i);
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
		enterRule(_localctx, 84, RULE_asmBytes);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(713);
			match(ASM_BYTE);
			setState(714);
			asmExpr(0);
			setState(719);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==ASM_COMMA) {
				{
				{
				setState(715);
				match(ASM_COMMA);
				setState(716);
				asmExpr(0);
				}
				}
				setState(721);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(725);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==ASM_TAG) {
				{
				{
				setState(722);
				match(ASM_TAG);
				}
				}
				setState(727);
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
	public static class AsmModeSPIndIdxContext extends AsmParamModeContext {
		public TerminalNode ASM_PAR_BEGIN() { return getToken(KickCParser.ASM_PAR_BEGIN, 0); }
		public AsmExprContext asmExpr() {
			return getRuleContext(AsmExprContext.class,0);
		}
		public List<TerminalNode> ASM_COMMA() { return getTokens(KickCParser.ASM_COMMA); }
		public TerminalNode ASM_COMMA(int i) {
			return getToken(KickCParser.ASM_COMMA, i);
		}
		public List<TerminalNode> ASM_NAME() { return getTokens(KickCParser.ASM_NAME); }
		public TerminalNode ASM_NAME(int i) {
			return getToken(KickCParser.ASM_NAME, i);
		}
		public TerminalNode ASM_PAR_END() { return getToken(KickCParser.ASM_PAR_END, 0); }
		public AsmModeSPIndIdxContext(AsmParamModeContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterAsmModeSPIndIdx(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitAsmModeSPIndIdx(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitAsmModeSPIndIdx(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class AsmModeIndLongContext extends AsmParamModeContext {
		public List<TerminalNode> ASM_PAR_BEGIN() { return getTokens(KickCParser.ASM_PAR_BEGIN); }
		public TerminalNode ASM_PAR_BEGIN(int i) {
			return getToken(KickCParser.ASM_PAR_BEGIN, i);
		}
		public AsmExprContext asmExpr() {
			return getRuleContext(AsmExprContext.class,0);
		}
		public List<TerminalNode> ASM_PAR_END() { return getTokens(KickCParser.ASM_PAR_END); }
		public TerminalNode ASM_PAR_END(int i) {
			return getToken(KickCParser.ASM_PAR_END, i);
		}
		public AsmModeIndLongContext(AsmParamModeContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterAsmModeIndLong(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitAsmModeIndLong(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitAsmModeIndLong(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class AsmModeAbsXYContext extends AsmParamModeContext {
		public List<AsmExprContext> asmExpr() {
			return getRuleContexts(AsmExprContext.class);
		}
		public AsmExprContext asmExpr(int i) {
			return getRuleContext(AsmExprContext.class,i);
		}
		public TerminalNode ASM_COMMA() { return getToken(KickCParser.ASM_COMMA, 0); }
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
	public static class AsmModeIndLongIdxXYContext extends AsmParamModeContext {
		public List<TerminalNode> ASM_PAR_BEGIN() { return getTokens(KickCParser.ASM_PAR_BEGIN); }
		public TerminalNode ASM_PAR_BEGIN(int i) {
			return getToken(KickCParser.ASM_PAR_BEGIN, i);
		}
		public AsmExprContext asmExpr() {
			return getRuleContext(AsmExprContext.class,0);
		}
		public List<TerminalNode> ASM_PAR_END() { return getTokens(KickCParser.ASM_PAR_END); }
		public TerminalNode ASM_PAR_END(int i) {
			return getToken(KickCParser.ASM_PAR_END, i);
		}
		public TerminalNode ASM_COMMA() { return getToken(KickCParser.ASM_COMMA, 0); }
		public TerminalNode ASM_NAME() { return getToken(KickCParser.ASM_NAME, 0); }
		public AsmModeIndLongIdxXYContext(AsmParamModeContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterAsmModeIndLongIdxXY(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitAsmModeIndLongIdxXY(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitAsmModeIndLongIdxXY(this);
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
		enterRule(_localctx, 86, RULE_asmParamMode);
		try {
			setState(773);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,75,_ctx) ) {
			case 1:
				_localctx = new AsmModeAbsContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(728);
				asmExpr(0);
				}
				break;
			case 2:
				_localctx = new AsmModeImmContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(729);
				match(ASM_IMM);
				setState(730);
				asmExpr(0);
				}
				break;
			case 3:
				_localctx = new AsmModeAbsXYContext(_localctx);
				enterOuterAlt(_localctx, 3);
				{
				setState(731);
				asmExpr(0);
				setState(732);
				match(ASM_COMMA);
				setState(733);
				asmExpr(0);
				}
				break;
			case 4:
				_localctx = new AsmModeIndIdxXYContext(_localctx);
				enterOuterAlt(_localctx, 4);
				{
				setState(735);
				match(ASM_PAR_BEGIN);
				setState(736);
				asmExpr(0);
				setState(737);
				match(ASM_PAR_END);
				setState(738);
				match(ASM_COMMA);
				setState(739);
				match(ASM_NAME);
				}
				break;
			case 5:
				_localctx = new AsmModeIndLongIdxXYContext(_localctx);
				enterOuterAlt(_localctx, 5);
				{
				setState(741);
				match(ASM_PAR_BEGIN);
				setState(742);
				match(ASM_PAR_BEGIN);
				setState(743);
				asmExpr(0);
				setState(744);
				match(ASM_PAR_END);
				setState(745);
				match(ASM_PAR_END);
				setState(746);
				match(ASM_COMMA);
				setState(747);
				match(ASM_NAME);
				}
				break;
			case 6:
				_localctx = new AsmModeSPIndIdxContext(_localctx);
				enterOuterAlt(_localctx, 6);
				{
				setState(749);
				match(ASM_PAR_BEGIN);
				setState(750);
				asmExpr(0);
				setState(751);
				match(ASM_COMMA);
				setState(752);
				match(ASM_NAME);
				setState(753);
				match(ASM_PAR_END);
				setState(754);
				match(ASM_COMMA);
				setState(755);
				match(ASM_NAME);
				}
				break;
			case 7:
				_localctx = new AsmModeIdxIndXYContext(_localctx);
				enterOuterAlt(_localctx, 7);
				{
				setState(757);
				match(ASM_PAR_BEGIN);
				setState(758);
				asmExpr(0);
				setState(759);
				match(ASM_COMMA);
				setState(760);
				match(ASM_NAME);
				setState(761);
				match(ASM_PAR_END);
				}
				break;
			case 8:
				_localctx = new AsmModeIndContext(_localctx);
				enterOuterAlt(_localctx, 8);
				{
				setState(763);
				match(ASM_PAR_BEGIN);
				setState(764);
				asmExpr(0);
				setState(765);
				match(ASM_PAR_END);
				}
				break;
			case 9:
				_localctx = new AsmModeIndLongContext(_localctx);
				enterOuterAlt(_localctx, 9);
				{
				setState(767);
				match(ASM_PAR_BEGIN);
				setState(768);
				match(ASM_PAR_BEGIN);
				setState(769);
				asmExpr(0);
				setState(770);
				match(ASM_PAR_END);
				setState(771);
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
		int _startState = 88;
		enterRecursionRule(_localctx, 88, RULE_asmExpr, _p);
		int _la;
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(789);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case ASM_BRACKET_BEGIN:
				{
				_localctx = new AsmExprParContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;

				setState(776);
				match(ASM_BRACKET_BEGIN);
				setState(777);
				asmExpr(0);
				setState(778);
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
				setState(780);
				_la = _input.LA(1);
				if ( !(((((_la - 125)) & ~0x3f) == 0 && ((1L << (_la - 125)) & ((1L << (ASM_PLUS - 125)) | (1L << (ASM_MINUS - 125)) | (1L << (ASM_LESS_THAN - 125)) | (1L << (ASM_GREATER_THAN - 125)))) != 0)) ) {
				_errHandler.recoverInline(this);
				}
				else {
					if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
					_errHandler.reportMatch(this);
					consume();
				}
				setState(781);
				asmExpr(8);
				}
				break;
			case ASM_NAME:
				{
				_localctx = new AsmExprLabelContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(782);
				match(ASM_NAME);
				}
				break;
			case ASM_MULTI_REL:
				{
				_localctx = new AsmExprLabelRelContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(783);
				match(ASM_MULTI_REL);
				}
				break;
			case ASM_CURLY_BEGIN:
				{
				_localctx = new AsmExprReplaceContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(784);
				match(ASM_CURLY_BEGIN);
				setState(785);
				match(ASM_NAME);
				setState(786);
				match(ASM_CURLY_END);
				}
				break;
			case ASM_NUMBER:
				{
				_localctx = new AsmExprIntContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(787);
				match(ASM_NUMBER);
				}
				break;
			case ASM_CHAR:
				{
				_localctx = new AsmExprCharContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(788);
				match(ASM_CHAR);
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
			_ctx.stop = _input.LT(-1);
			setState(805);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,78,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					setState(803);
					_errHandler.sync(this);
					switch ( getInterpreter().adaptivePredict(_input,77,_ctx) ) {
					case 1:
						{
						_localctx = new AsmExprBinaryContext(new AsmExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_asmExpr);
						setState(791);
						if (!(precpred(_ctx, 10))) throw new FailedPredicateException(this, "precpred(_ctx, 10)");
						{
						setState(792);
						match(ASM_DOT);
						}
						setState(793);
						asmExpr(11);
						}
						break;
					case 2:
						{
						_localctx = new AsmExprBinaryContext(new AsmExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_asmExpr);
						setState(794);
						if (!(precpred(_ctx, 9))) throw new FailedPredicateException(this, "precpred(_ctx, 9)");
						setState(795);
						_la = _input.LA(1);
						if ( !(_la==ASM_SHIFT_LEFT || _la==ASM_SHIFT_RIGHT) ) {
						_errHandler.recoverInline(this);
						}
						else {
							if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
							_errHandler.reportMatch(this);
							consume();
						}
						setState(796);
						asmExpr(10);
						}
						break;
					case 3:
						{
						_localctx = new AsmExprBinaryContext(new AsmExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_asmExpr);
						setState(797);
						if (!(precpred(_ctx, 7))) throw new FailedPredicateException(this, "precpred(_ctx, 7)");
						setState(798);
						_la = _input.LA(1);
						if ( !(_la==ASM_MULTIPLY || _la==ASM_DIVIDE) ) {
						_errHandler.recoverInline(this);
						}
						else {
							if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
							_errHandler.reportMatch(this);
							consume();
						}
						setState(799);
						asmExpr(8);
						}
						break;
					case 4:
						{
						_localctx = new AsmExprBinaryContext(new AsmExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_asmExpr);
						setState(800);
						if (!(precpred(_ctx, 6))) throw new FailedPredicateException(this, "precpred(_ctx, 6)");
						setState(801);
						_la = _input.LA(1);
						if ( !(_la==ASM_PLUS || _la==ASM_MINUS) ) {
						_errHandler.recoverInline(this);
						}
						else {
							if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
							_errHandler.reportMatch(this);
							consume();
						}
						setState(802);
						asmExpr(7);
						}
						break;
					}
					} 
				}
				setState(807);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,78,_ctx);
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
		case 5:
			return declaratorInitList_sempred((DeclaratorInitListContext)_localctx, predIndex);
		case 9:
			return typeSpecifier_sempred((TypeSpecifierContext)_localctx, predIndex);
		case 10:
			return declarator_sempred((DeclaratorContext)_localctx, predIndex);
		case 17:
			return enumMemberList_sempred((EnumMemberListContext)_localctx, predIndex);
		case 32:
			return commaExpr_sempred((CommaExprContext)_localctx, predIndex);
		case 33:
			return expr_sempred((ExprContext)_localctx, predIndex);
		case 44:
			return asmExpr_sempred((AsmExprContext)_localctx, predIndex);
		}
		return true;
	}
	private boolean declaratorInitList_sempred(DeclaratorInitListContext _localctx, int predIndex) {
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
	private boolean declarator_sempred(DeclaratorContext _localctx, int predIndex) {
		switch (predIndex) {
		case 3:
			return precpred(_ctx, 4);
		case 4:
			return precpred(_ctx, 3);
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
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\3\u009c\u032b\4\2\t"+
		"\2\4\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n\t\n\4\13"+
		"\t\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\4\20\t\20\4\21\t\21\4\22\t\22"+
		"\4\23\t\23\4\24\t\24\4\25\t\25\4\26\t\26\4\27\t\27\4\30\t\30\4\31\t\31"+
		"\4\32\t\32\4\33\t\33\4\34\t\34\4\35\t\35\4\36\t\36\4\37\t\37\4 \t \4!"+
		"\t!\4\"\t\"\4#\t#\4$\t$\4%\t%\4&\t&\4\'\t\'\4(\t(\4)\t)\4*\t*\4+\t+\4"+
		",\t,\4-\t-\4.\t.\3\2\3\2\3\2\3\3\3\3\3\3\3\4\7\4d\n\4\f\4\16\4g\13\4\3"+
		"\5\3\5\3\5\3\5\3\5\3\5\3\5\3\5\3\5\3\5\3\5\3\5\3\5\3\5\5\5w\n\5\3\6\3"+
		"\6\3\6\3\7\3\7\3\7\3\7\3\7\3\7\7\7\u0082\n\7\f\7\16\7\u0085\13\7\3\b\3"+
		"\b\3\b\5\b\u008a\n\b\3\b\3\b\3\b\3\b\5\b\u0090\n\b\3\t\3\t\3\t\3\t\3\t"+
		"\3\n\7\n\u0098\n\n\f\n\16\n\u009b\13\n\3\n\3\n\7\n\u009f\n\n\f\n\16\n"+
		"\u00a2\13\n\3\13\3\13\3\13\3\13\3\13\3\13\3\13\3\13\5\13\u00ac\n\13\3"+
		"\13\7\13\u00af\n\13\f\13\16\13\u00b2\13\13\3\f\3\f\3\f\3\f\3\f\7\f\u00b9"+
		"\n\f\f\f\16\f\u00bc\13\f\3\f\3\f\3\f\3\f\3\f\5\f\u00c3\n\f\3\f\3\f\3\f"+
		"\5\f\u00c8\n\f\3\f\3\f\3\f\3\f\5\f\u00ce\n\f\3\f\7\f\u00d1\n\f\f\f\16"+
		"\f\u00d4\13\f\3\r\3\r\3\r\5\r\u00d9\n\r\3\r\3\r\3\r\3\r\3\r\5\r\u00e0"+
		"\n\r\3\16\3\16\3\16\3\17\3\17\5\17\u00e7\n\17\3\17\3\17\6\17\u00eb\n\17"+
		"\r\17\16\17\u00ec\3\17\3\17\3\20\3\20\3\20\3\21\3\21\3\21\3\22\3\22\5"+
		"\22\u00f9\n\22\3\22\3\22\3\22\3\22\3\23\3\23\3\23\3\23\3\23\3\23\7\23"+
		"\u0105\n\23\f\23\16\23\u0108\13\23\3\24\3\24\3\24\5\24\u010d\n\24\3\25"+
		"\3\25\3\25\3\25\5\25\u0113\n\25\3\25\3\25\3\26\3\26\3\26\7\26\u011a\n"+
		"\26\f\26\16\26\u011d\13\26\3\27\3\27\3\27\3\27\3\27\5\27\u0124\n\27\3"+
		"\30\3\30\3\30\3\30\3\30\3\30\7\30\u012c\n\30\f\30\16\30\u012f\13\30\3"+
		"\30\3\30\3\31\3\31\3\31\3\31\3\31\3\31\3\31\5\31\u013a\n\31\3\32\3\32"+
		"\3\32\3\32\3\32\3\32\3\32\3\32\3\32\5\32\u0145\n\32\3\32\3\32\3\32\3\32"+
		"\3\32\3\32\3\32\3\32\3\32\3\32\3\32\3\32\3\32\3\32\3\32\3\32\3\32\3\32"+
		"\3\32\5\32\u015a\n\32\3\32\3\32\3\32\3\32\3\32\7\32\u0161\n\32\f\32\16"+
		"\32\u0164\13\32\3\32\3\32\3\32\5\32\u0169\n\32\3\33\6\33\u016c\n\33\r"+
		"\33\16\33\u016d\3\34\3\34\3\34\3\34\3\34\5\34\u0175\n\34\3\34\3\34\3\34"+
		"\3\34\3\34\3\34\3\34\3\34\3\34\3\34\3\34\5\34\u0182\n\34\3\34\7\34\u0185"+
		"\n\34\f\34\16\34\u0188\13\34\3\34\3\34\3\34\3\34\3\34\3\34\3\34\7\34\u0191"+
		"\n\34\f\34\16\34\u0194\13\34\3\34\3\34\3\34\3\34\3\34\3\34\3\34\3\34\3"+
		"\34\7\34\u019f\n\34\f\34\16\34\u01a2\13\34\3\34\3\34\3\34\3\34\3\34\3"+
		"\34\3\34\3\34\3\34\3\34\3\34\3\34\3\34\3\34\3\34\3\34\5\34\u01b4\n\34"+
		"\3\34\3\34\3\34\3\34\3\34\3\34\3\34\5\34\u01bd\n\34\3\34\3\34\3\34\3\34"+
		"\3\34\3\34\5\34\u01c5\n\34\3\35\6\35\u01c8\n\35\r\35\16\35\u01c9\3\35"+
		"\3\35\3\35\5\35\u01cf\n\35\5\35\u01d1\n\35\3\36\3\36\3\36\3\36\5\36\u01d7"+
		"\n\36\3\37\3\37\3\37\5\37\u01dc\n\37\3\37\3\37\5\37\u01e0\n\37\3\37\3"+
		"\37\3\37\3\37\3\37\3\37\3\37\5\37\u01e9\n\37\3 \5 \u01ec\n \3 \5 \u01ef"+
		"\n \3!\3!\3\"\3\"\3\"\3\"\3\"\3\"\7\"\u01f9\n\"\f\"\16\"\u01fc\13\"\3"+
		"#\3#\3#\3#\3#\3#\3#\3#\3#\5#\u0207\n#\3#\3#\3#\3#\3#\3#\5#\u020f\n#\3"+
		"#\3#\3#\3#\5#\u0215\n#\3#\3#\5#\u0219\n#\3#\3#\3#\3#\3#\3#\3#\3#\3#\3"+
		"#\3#\3#\3#\3#\3#\3#\3#\7#\u022c\n#\f#\16#\u022f\13#\3#\5#\u0232\n#\3#"+
		"\3#\3#\3#\3#\6#\u0239\n#\r#\16#\u023a\3#\3#\5#\u023f\n#\3#\3#\3#\3#\3"+
		"#\3#\3#\3#\3#\3#\3#\3#\3#\3#\3#\3#\3#\3#\3#\3#\3#\3#\3#\3#\3#\3#\3#\3"+
		"#\3#\3#\3#\3#\3#\3#\3#\3#\3#\3#\3#\3#\3#\3#\3#\3#\3#\3#\3#\3#\5#\u0271"+
		"\n#\3#\3#\3#\3#\3#\3#\3#\3#\7#\u027b\n#\f#\16#\u027e\13#\3$\3$\3$\7$\u0283"+
		"\n$\f$\16$\u0286\13$\3%\3%\5%\u028a\n%\3%\3%\3&\3&\3&\3&\7&\u0292\n&\f"+
		"&\16&\u0295\13&\3&\3&\3\'\3\'\3\'\3\'\3\'\3\'\3\'\3\'\3\'\3\'\5\'\u02a3"+
		"\n\'\3(\7(\u02a6\n(\f(\16(\u02a9\13(\3)\3)\3)\5)\u02ae\n)\3*\3*\3*\7*"+
		"\u02b3\n*\f*\16*\u02b6\13*\3*\3*\3*\7*\u02bb\n*\f*\16*\u02be\13*\5*\u02c0"+
		"\n*\3+\3+\5+\u02c4\n+\3+\7+\u02c7\n+\f+\16+\u02ca\13+\3,\3,\3,\3,\7,\u02d0"+
		"\n,\f,\16,\u02d3\13,\3,\7,\u02d6\n,\f,\16,\u02d9\13,\3-\3-\3-\3-\3-\3"+
		"-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3"+
		"-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\3-\5-\u0308\n-\3.\3.\3"+
		".\3.\3.\3.\3.\3.\3.\3.\3.\3.\3.\3.\5.\u0318\n.\3.\3.\3.\3.\3.\3.\3.\3"+
		".\3.\3.\3.\3.\7.\u0326\n.\f.\16.\u0329\13.\3.\2\t\f\24\26$BDZ/\2\4\6\b"+
		"\n\f\16\20\22\24\26\30\32\34\36 \"$&(*,.\60\62\64\668:<>@BDFHJLNPRTVX"+
		"Z\2\r\3\2\27\30\5\2\22\23\31\32RR\4\2!!$$\3\2\35\36\3\2\24\26\3\2\22\23"+
		"\3\2\37$\3\2\177\u0082\3\2}~\3\2\u0083\u0084\3\2\177\u0080\2\u03a3\2\\"+
		"\3\2\2\2\4_\3\2\2\2\6e\3\2\2\2\bv\3\2\2\2\nx\3\2\2\2\f{\3\2\2\2\16\u008f"+
		"\3\2\2\2\20\u0091\3\2\2\2\22\u0099\3\2\2\2\24\u00a3\3\2\2\2\26\u00c2\3"+
		"\2\2\2\30\u00df\3\2\2\2\32\u00e1\3\2\2\2\34\u00e4\3\2\2\2\36\u00f0\3\2"+
		"\2\2 \u00f3\3\2\2\2\"\u00f6\3\2\2\2$\u00fe\3\2\2\2&\u0109\3\2\2\2(\u010e"+
		"\3\2\2\2*\u0116\3\2\2\2,\u0123\3\2\2\2.\u0125\3\2\2\2\60\u0139\3\2\2\2"+
		"\62\u0168\3\2\2\2\64\u016b\3\2\2\2\66\u01c4\3\2\2\28\u01c7\3\2\2\2:\u01d2"+
		"\3\2\2\2<\u01e8\3\2\2\2>\u01ee\3\2\2\2@\u01f0\3\2\2\2B\u01f2\3\2\2\2D"+
		"\u023e\3\2\2\2F\u027f\3\2\2\2H\u0287\3\2\2\2J\u028d\3\2\2\2L\u02a2\3\2"+
		"\2\2N\u02a7\3\2\2\2P\u02ad\3\2\2\2R\u02bf\3\2\2\2T\u02c1\3\2\2\2V\u02cb"+
		"\3\2\2\2X\u0307\3\2\2\2Z\u0317\3\2\2\2\\]\5\6\4\2]^\7\2\2\3^\3\3\2\2\2"+
		"_`\5N(\2`a\7\2\2\3a\5\3\2\2\2bd\5\b\5\2cb\3\2\2\2dg\3\2\2\2ec\3\2\2\2"+
		"ef\3\2\2\2f\7\3\2\2\2ge\3\2\2\2hi\5\n\6\2ij\7\n\2\2jw\3\2\2\2kw\5(\25"+
		"\2lm\5\34\17\2mn\7\n\2\2nw\3\2\2\2op\5\"\22\2pq\7\n\2\2qw\3\2\2\2rw\5"+
		".\30\2st\5\20\t\2tu\7\n\2\2uw\3\2\2\2vh\3\2\2\2vk\3\2\2\2vl\3\2\2\2vo"+
		"\3\2\2\2vr\3\2\2\2vs\3\2\2\2w\t\3\2\2\2xy\5\22\n\2yz\5\f\7\2z\13\3\2\2"+
		"\2{|\b\7\1\2|}\5\16\b\2}\u0083\3\2\2\2~\177\f\3\2\2\177\u0080\7\f\2\2"+
		"\u0080\u0082\5\16\b\2\u0081~\3\2\2\2\u0082\u0085\3\2\2\2\u0083\u0081\3"+
		"\2\2\2\u0083\u0084\3\2\2\2\u0084\r\3\2\2\2\u0085\u0083\3\2\2\2\u0086\u0089"+
		"\5\26\f\2\u0087\u0088\7\'\2\2\u0088\u008a\5D#\2\u0089\u0087\3\2\2\2\u0089"+
		"\u008a\3\2\2\2\u008a\u0090\3\2\2\2\u008b\u008c\5\26\f\2\u008c\u008d\7"+
		"\'\2\2\u008d\u008e\5H%\2\u008e\u0090\3\2\2\2\u008f\u0086\3\2\2\2\u008f"+
		"\u008b\3\2\2\2\u0090\17\3\2\2\2\u0091\u0092\7)\2\2\u0092\u0093\5\22\n"+
		"\2\u0093\u0094\b\t\1\2\u0094\u0095\5\26\f\2\u0095\21\3\2\2\2\u0096\u0098"+
		"\5\62\32\2\u0097\u0096\3\2\2\2\u0098\u009b\3\2\2\2\u0099\u0097\3\2\2\2"+
		"\u0099\u009a\3\2\2\2\u009a\u009c\3\2\2\2\u009b\u0099\3\2\2\2\u009c\u00a0"+
		"\5\30\r\2\u009d\u009f\5\62\32\2\u009e\u009d\3\2\2\2\u009f\u00a2\3\2\2"+
		"\2\u00a0\u009e\3\2\2\2\u00a0\u00a1\3\2\2\2\u00a1\23\3\2\2\2\u00a2\u00a0"+
		"\3\2\2\2\u00a3\u00a4\b\13\1\2\u00a4\u00a5\5\30\r\2\u00a5\u00b0\3\2\2\2"+
		"\u00a6\u00a7\f\4\2\2\u00a7\u00af\7\24\2\2\u00a8\u00a9\f\3\2\2\u00a9\u00ab"+
		"\7\6\2\2\u00aa\u00ac\5D#\2\u00ab\u00aa\3\2\2\2\u00ab\u00ac\3\2\2\2\u00ac"+
		"\u00ad\3\2\2\2\u00ad\u00af\7\7\2\2\u00ae\u00a6\3\2\2\2\u00ae\u00a8\3\2"+
		"\2\2\u00af\u00b2\3\2\2\2\u00b0\u00ae\3\2\2\2\u00b0\u00b1\3\2\2\2\u00b1"+
		"\25\3\2\2\2\u00b2\u00b0\3\2\2\2\u00b3\u00b4\b\f\1\2\u00b4\u00b5\7m\2\2"+
		"\u00b5\u00c3\b\f\1\2\u00b6\u00ba\7\24\2\2\u00b7\u00b9\5\62\32\2\u00b8"+
		"\u00b7\3\2\2\2\u00b9\u00bc\3\2\2\2\u00ba\u00b8\3\2\2\2\u00ba\u00bb\3\2"+
		"\2\2\u00bb\u00bd\3\2\2\2\u00bc\u00ba\3\2\2\2\u00bd\u00c3\5\26\f\4\u00be"+
		"\u00bf\7\b\2\2\u00bf\u00c0\5\26\f\2\u00c0\u00c1\7\t\2\2\u00c1\u00c3\3"+
		"\2\2\2\u00c2\u00b3\3\2\2\2\u00c2\u00b6\3\2\2\2\u00c2\u00be\3\2\2\2\u00c3"+
		"\u00d2\3\2\2\2\u00c4\u00c5\f\6\2\2\u00c5\u00c7\7\b\2\2\u00c6\u00c8\5*"+
		"\26\2\u00c7\u00c6\3\2\2\2\u00c7\u00c8\3\2\2\2\u00c8\u00c9\3\2\2\2\u00c9"+
		"\u00d1\7\t\2\2\u00ca\u00cb\f\5\2\2\u00cb\u00cd\7\6\2\2\u00cc\u00ce\5D"+
		"#\2\u00cd\u00cc\3\2\2\2\u00cd\u00ce\3\2\2\2\u00ce\u00cf\3\2\2\2\u00cf"+
		"\u00d1\7\7\2\2\u00d0\u00c4\3\2\2\2\u00d0\u00ca\3\2\2\2\u00d1\u00d4\3\2"+
		"\2\2\u00d2\u00d0\3\2\2\2\u00d2\u00d3\3\2\2\2\u00d3\27\3\2\2\2\u00d4\u00d2"+
		"\3\2\2\2\u00d5\u00e0\7T\2\2\u00d6\u00d8\7S\2\2\u00d7\u00d9\7T\2\2\u00d8"+
		"\u00d7\3\2\2\2\u00d8\u00d9\3\2\2\2\u00d9\u00e0\3\2\2\2\u00da\u00e0\5\34"+
		"\17\2\u00db\u00e0\5\32\16\2\u00dc\u00e0\5\"\22\2\u00dd\u00e0\5 \21\2\u00de"+
		"\u00e0\7\3\2\2\u00df\u00d5\3\2\2\2\u00df\u00d6\3\2\2\2\u00df\u00da\3\2"+
		"\2\2\u00df\u00db\3\2\2\2\u00df\u00dc\3\2\2\2\u00df\u00dd\3\2\2\2\u00df"+
		"\u00de\3\2\2\2\u00e0\31\3\2\2\2\u00e1\u00e2\7G\2\2\u00e2\u00e3\7m\2\2"+
		"\u00e3\33\3\2\2\2\u00e4\u00e6\7G\2\2\u00e5\u00e7\7m\2\2\u00e6\u00e5\3"+
		"\2\2\2\u00e6\u00e7\3\2\2\2\u00e7\u00e8\3\2\2\2\u00e8\u00ea\7\4\2\2\u00e9"+
		"\u00eb\5\36\20\2\u00ea\u00e9\3\2\2\2\u00eb\u00ec\3\2\2\2\u00ec\u00ea\3"+
		"\2\2\2\u00ec\u00ed\3\2\2\2\u00ed\u00ee\3\2\2\2\u00ee\u00ef\7\5\2\2\u00ef"+
		"\35\3\2\2\2\u00f0\u00f1\5\n\6\2\u00f1\u00f2\7\n\2\2\u00f2\37\3\2\2\2\u00f3"+
		"\u00f4\7H\2\2\u00f4\u00f5\7m\2\2\u00f5!\3\2\2\2\u00f6\u00f8\7H\2\2\u00f7"+
		"\u00f9\7m\2\2\u00f8\u00f7\3\2\2\2\u00f8\u00f9\3\2\2\2\u00f9\u00fa\3\2"+
		"\2\2\u00fa\u00fb\7\4\2\2\u00fb\u00fc\5$\23\2\u00fc\u00fd\7\5\2\2\u00fd"+
		"#\3\2\2\2\u00fe\u00ff\b\23\1\2\u00ff\u0100\5&\24\2\u0100\u0106\3\2\2\2"+
		"\u0101\u0102\f\3\2\2\u0102\u0103\7\f\2\2\u0103\u0105\5&\24\2\u0104\u0101"+
		"\3\2\2\2\u0105\u0108\3\2\2\2\u0106\u0104\3\2\2\2\u0106\u0107\3\2\2\2\u0107"+
		"%\3\2\2\2\u0108\u0106\3\2\2\2\u0109\u010c\7m\2\2\u010a\u010b\7\'\2\2\u010b"+
		"\u010d\5D#\2\u010c\u010a\3\2\2\2\u010c\u010d\3\2\2\2\u010d\'\3\2\2\2\u010e"+
		"\u010f\5\22\n\2\u010f\u0110\5\26\f\2\u0110\u0112\7\4\2\2\u0111\u0113\5"+
		"\64\33\2\u0112\u0111\3\2\2\2\u0112\u0113\3\2\2\2\u0113\u0114\3\2\2\2\u0114"+
		"\u0115\7\5\2\2\u0115)\3\2\2\2\u0116\u011b\5,\27\2\u0117\u0118\7\f\2\2"+
		"\u0118\u011a\5,\27\2\u0119\u0117\3\2\2\2\u011a\u011d\3\2\2\2\u011b\u0119"+
		"\3\2\2\2\u011b\u011c\3\2\2\2\u011c+\3\2\2\2\u011d\u011b\3\2\2\2\u011e"+
		"\u011f\5\22\n\2\u011f\u0120\5\26\f\2\u0120\u0124\3\2\2\2\u0121\u0124\7"+
		"T\2\2\u0122\u0124\7\16\2\2\u0123\u011e\3\2\2\2\u0123\u0121\3\2\2\2\u0123"+
		"\u0122\3\2\2\2\u0124-\3\2\2\2\u0125\u0126\7Y\2\2\u0126\u0127\7m\2\2\u0127"+
		"\u0128\7\b\2\2\u0128\u012d\5\60\31\2\u0129\u012a\7\f\2\2\u012a\u012c\5"+
		"\60\31\2\u012b\u0129\3\2\2\2\u012c\u012f\3\2\2\2\u012d\u012b\3\2\2\2\u012d"+
		"\u012e\3\2\2\2\u012e\u0130\3\2\2\2\u012f\u012d\3\2\2\2\u0130\u0131\7\t"+
		"\2\2\u0131/\3\2\2\2\u0132\u013a\7d\2\2\u0133\u0134\7d\2\2\u0134\u0135"+
		"\7\r\2\2\u0135\u013a\7d\2\2\u0136\u013a\7m\2\2\u0137\u013a\7n\2\2\u0138"+
		"\u013a\7:\2\2\u0139\u0132\3\2\2\2\u0139\u0133\3\2\2\2\u0139\u0136\3\2"+
		"\2\2\u0139\u0137\3\2\2\2\u0139\u0138\3\2\2\2\u013a\61\3\2\2\2\u013b\u0169"+
		"\7*\2\2\u013c\u013d\7-\2\2\u013d\u013e\7\b\2\2\u013e\u013f\7d\2\2\u013f"+
		"\u0169\7\t\2\2\u0140\u0144\7\62\2\2\u0141\u0142\7\b\2\2\u0142\u0143\7"+
		"m\2\2\u0143\u0145\7\t\2\2\u0144\u0141\3\2\2\2\u0144\u0145\3\2\2\2\u0145"+
		"\u0169\3\2\2\2\u0146\u0169\7\65\2\2\u0147\u0169\7\66\2\2\u0148\u0149\7"+
		"\64\2\2\u0149\u014a\7\b\2\2\u014a\u014b\5D#\2\u014b\u014c\7\t\2\2\u014c"+
		"\u0169\3\2\2\2\u014d\u0169\7/\2\2\u014e\u0169\7\60\2\2\u014f\u0169\7\67"+
		"\2\2\u0150\u0169\78\2\2\u0151\u0169\7+\2\2\u0152\u0169\7,\2\2\u0153\u0169"+
		"\7.\2\2\u0154\u0169\79\2\2\u0155\u0159\7\61\2\2\u0156\u0157\7\b\2\2\u0157"+
		"\u0158\7m\2\2\u0158\u015a\7\t\2\2\u0159\u0156\3\2\2\2\u0159\u015a\3\2"+
		"\2\2\u015a\u0169\3\2\2\2\u015b\u015c\7\63\2\2\u015c\u015d\7\b\2\2\u015d"+
		"\u0162\5\60\31\2\u015e\u015f\7\f\2\2\u015f\u0161\5\60\31\2\u0160\u015e"+
		"\3\2\2\2\u0161\u0164\3\2\2\2\u0162\u0160\3\2\2\2\u0162\u0163\3\2\2\2\u0163"+
		"\u0165\3\2\2\2\u0164\u0162\3\2\2\2\u0165\u0166\7\t\2\2\u0166\u0169\3\2"+
		"\2\2\u0167\u0169\7:\2\2\u0168\u013b\3\2\2\2\u0168\u013c\3\2\2\2\u0168"+
		"\u0140\3\2\2\2\u0168\u0146\3\2\2\2\u0168\u0147\3\2\2\2\u0168\u0148\3\2"+
		"\2\2\u0168\u014d\3\2\2\2\u0168\u014e\3\2\2\2\u0168\u014f\3\2\2\2\u0168"+
		"\u0150\3\2\2\2\u0168\u0151\3\2\2\2\u0168\u0152\3\2\2\2\u0168\u0153\3\2"+
		"\2\2\u0168\u0154\3\2\2\2\u0168\u0155\3\2\2\2\u0168\u015b\3\2\2\2\u0168"+
		"\u0167\3\2\2\2\u0169\63\3\2\2\2\u016a\u016c\5\66\34\2\u016b\u016a\3\2"+
		"\2\2\u016c\u016d\3\2\2\2\u016d\u016b\3\2\2\2\u016d\u016e\3\2\2\2\u016e"+
		"\65\3\2\2\2\u016f\u0170\5\n\6\2\u0170\u0171\7\n\2\2\u0171\u01c5\3\2\2"+
		"\2\u0172\u0174\7\4\2\2\u0173\u0175\5\64\33\2\u0174\u0173\3\2\2\2\u0174"+
		"\u0175\3\2\2\2\u0175\u0176\3\2\2\2\u0176\u01c5\7\5\2\2\u0177\u0178\5B"+
		"\"\2\u0178\u0179\7\n\2\2\u0179\u01c5\3\2\2\2\u017a\u017b\7;\2\2\u017b"+
		"\u017c\7\b\2\2\u017c\u017d\5B\"\2\u017d\u017e\7\t\2\2\u017e\u0181\5\66"+
		"\34\2\u017f\u0180\7<\2\2\u0180\u0182\5\66\34\2\u0181\u017f\3\2\2\2\u0181"+
		"\u0182\3\2\2\2\u0182\u01c5\3\2\2\2\u0183\u0185\5\62\32\2\u0184\u0183\3"+
		"\2\2\2\u0185\u0188\3\2\2\2\u0186\u0184\3\2\2\2\u0186\u0187\3\2\2\2\u0187"+
		"\u0189\3\2\2\2\u0188\u0186\3\2\2\2\u0189\u018a\7=\2\2\u018a\u018b\7\b"+
		"\2\2\u018b\u018c\5B\"\2\u018c\u018d\7\t\2\2\u018d\u018e\5\66\34\2\u018e"+
		"\u01c5\3\2\2\2\u018f\u0191\5\62\32\2\u0190\u018f\3\2\2\2\u0191\u0194\3"+
		"\2\2\2\u0192\u0190\3\2\2\2\u0192\u0193\3\2\2\2\u0193\u0195\3\2\2\2\u0194"+
		"\u0192\3\2\2\2\u0195\u0196\7>\2\2\u0196\u0197\5\66\34\2\u0197\u0198\7"+
		"=\2\2\u0198\u0199\7\b\2\2\u0199\u019a\5B\"\2\u019a\u019b\7\t\2\2\u019b"+
		"\u019c\7\n\2\2\u019c\u01c5\3\2\2\2\u019d\u019f\5\62\32\2\u019e\u019d\3"+
		"\2\2\2\u019f\u01a2\3\2\2\2\u01a0\u019e\3\2\2\2\u01a0\u01a1\3\2\2\2\u01a1"+
		"\u01a3\3\2\2\2\u01a2\u01a0\3\2\2\2\u01a3\u01a4\7?\2\2\u01a4\u01a5\7\b"+
		"\2\2\u01a5\u01a6\5<\37\2\u01a6\u01a7\7\t\2\2\u01a7\u01a8\5\66\34\2\u01a8"+
		"\u01c5\3\2\2\2\u01a9\u01aa\7@\2\2\u01aa\u01ab\7\b\2\2\u01ab\u01ac\5B\""+
		"\2\u01ac\u01ad\7\t\2\2\u01ad\u01ae\7\4\2\2\u01ae\u01af\58\35\2\u01af\u01b0"+
		"\7\5\2\2\u01b0\u01c5\3\2\2\2\u01b1\u01b3\7A\2\2\u01b2\u01b4\5B\"\2\u01b3"+
		"\u01b2\3\2\2\2\u01b3\u01b4\3\2\2\2\u01b4\u01b5\3\2\2\2\u01b5\u01c5\7\n"+
		"\2\2\u01b6\u01b7\7B\2\2\u01b7\u01c5\7\n\2\2\u01b8\u01b9\7C\2\2\u01b9\u01c5"+
		"\7\n\2\2\u01ba\u01bc\7D\2\2\u01bb\u01bd\5J&\2\u01bc\u01bb\3\2\2\2\u01bc"+
		"\u01bd\3\2\2\2\u01bd\u01be\3\2\2\2\u01be\u01bf\7\4\2\2\u01bf\u01c0\5N"+
		"(\2\u01c0\u01c1\7\u0086\2\2\u01c1\u01c5\3\2\2\2\u01c2\u01c5\5H%\2\u01c3"+
		"\u01c5\7\n\2\2\u01c4\u016f\3\2\2\2\u01c4\u0172\3\2\2\2\u01c4\u0177\3\2"+
		"\2\2\u01c4\u017a\3\2\2\2\u01c4\u0186\3\2\2\2\u01c4\u0192\3\2\2\2\u01c4"+
		"\u01a0\3\2\2\2\u01c4\u01a9\3\2\2\2\u01c4\u01b1\3\2\2\2\u01c4\u01b6\3\2"+
		"\2\2\u01c4\u01b8\3\2\2\2\u01c4\u01ba\3\2\2\2\u01c4\u01c2\3\2\2\2\u01c4"+
		"\u01c3\3\2\2\2\u01c5\67\3\2\2\2\u01c6\u01c8\5:\36\2\u01c7\u01c6\3\2\2"+
		"\2\u01c8\u01c9\3\2\2\2\u01c9\u01c7\3\2\2\2\u01c9\u01ca\3\2\2\2\u01ca\u01d0"+
		"\3\2\2\2\u01cb\u01cc\7E\2\2\u01cc\u01ce\7\13\2\2\u01cd\u01cf\5\64\33\2"+
		"\u01ce\u01cd\3\2\2\2\u01ce\u01cf\3\2\2\2\u01cf\u01d1\3\2\2\2\u01d0\u01cb"+
		"\3\2\2\2\u01d0\u01d1\3\2\2\2\u01d19\3\2\2\2\u01d2\u01d3\7F\2\2\u01d3\u01d4"+
		"\5D#\2\u01d4\u01d6\7\13\2\2\u01d5\u01d7\5\64\33\2\u01d6\u01d5\3\2\2\2"+
		"\u01d6\u01d7\3\2\2\2\u01d7;\3\2\2\2\u01d8\u01d9\5> \2\u01d9\u01db\7\n"+
		"\2\2\u01da\u01dc\5@!\2\u01db\u01da\3\2\2\2\u01db\u01dc\3\2\2\2\u01dc\u01dd"+
		"\3\2\2\2\u01dd\u01df\7\n\2\2\u01de\u01e0\5B\"\2\u01df\u01de\3\2\2\2\u01df"+
		"\u01e0\3\2\2\2\u01e0\u01e9\3\2\2\2\u01e1\u01e2\5\22\n\2\u01e2\u01e3\5"+
		"\26\f\2\u01e3\u01e4\7\13\2\2\u01e4\u01e5\5D#\2\u01e5\u01e6\7\r\2\2\u01e6"+
		"\u01e7\5D#\2\u01e7\u01e9\3\2\2\2\u01e8\u01d8\3\2\2\2\u01e8\u01e1\3\2\2"+
		"\2\u01e9=\3\2\2\2\u01ea\u01ec\5\n\6\2\u01eb\u01ea\3\2\2\2\u01eb\u01ec"+
		"\3\2\2\2\u01ec\u01ef\3\2\2\2\u01ed\u01ef\5B\"\2\u01ee\u01eb\3\2\2\2\u01ee"+
		"\u01ed\3\2\2\2\u01ef?\3\2\2\2\u01f0\u01f1\5B\"\2\u01f1A\3\2\2\2\u01f2"+
		"\u01f3\b\"\1\2\u01f3\u01f4\5D#\2\u01f4\u01fa\3\2\2\2\u01f5\u01f6\f\3\2"+
		"\2\u01f6\u01f7\7\f\2\2\u01f7\u01f9\5D#\2\u01f8\u01f5\3\2\2\2\u01f9\u01fc"+
		"\3\2\2\2\u01fa\u01f8\3\2\2\2\u01fa\u01fb\3\2\2\2\u01fbC\3\2\2\2\u01fc"+
		"\u01fa\3\2\2\2\u01fd\u01fe\b#\1\2\u01fe\u01ff\7\b\2\2\u01ff\u0200\5B\""+
		"\2\u0200\u0201\7\t\2\2\u0201\u023f\3\2\2\2\u0202\u0203\7I\2\2\u0203\u0206"+
		"\7\b\2\2\u0204\u0207\5D#\2\u0205\u0207\5\24\13\2\u0206\u0204\3\2\2\2\u0206"+
		"\u0205\3\2\2\2\u0207\u0208\3\2\2\2\u0208\u0209\7\t\2\2\u0209\u023f\3\2"+
		"\2\2\u020a\u020b\7J\2\2\u020b\u020e\7\b\2\2\u020c\u020f\5D#\2\u020d\u020f"+
		"\5\24\13\2\u020e\u020c\3\2\2\2\u020e\u020d\3\2\2\2\u020f\u0210\3\2\2\2"+
		"\u0210\u0211\7\t\2\2\u0211\u023f\3\2\2\2\u0212\u0214\7K\2\2\u0213\u0215"+
		"\7\b\2\2\u0214\u0213\3\2\2\2\u0214\u0215\3\2\2\2\u0215\u0216\3\2\2\2\u0216"+
		"\u0218\7m\2\2\u0217\u0219\7\t\2\2\u0218\u0217\3\2\2\2\u0218\u0219\3\2"+
		"\2\2\u0219\u023f\3\2\2\2\u021a\u021b\7\b\2\2\u021b\u021c\5\24\13\2\u021c"+
		"\u021d\7\t\2\2\u021d\u021e\5D#\32\u021e\u023f\3\2\2\2\u021f\u0220\t\2"+
		"\2\2\u0220\u023f\5D#\31\u0221\u0222\7\24\2\2\u0222\u023f\5D#\27\u0223"+
		"\u0224\t\3\2\2\u0224\u023f\5D#\26\u0225\u0226\t\4\2\2\u0226\u023f\5D#"+
		"\22\u0227\u0228\7\4\2\2\u0228\u022d\5D#\2\u0229\u022a\7\f\2\2\u022a\u022c"+
		"\5D#\2\u022b\u0229\3\2\2\2\u022c\u022f\3\2\2\2\u022d\u022b\3\2\2\2\u022d"+
		"\u022e\3\2\2\2\u022e\u0231\3\2\2\2\u022f\u022d\3\2\2\2\u0230\u0232\7\f"+
		"\2\2\u0231\u0230\3\2\2\2\u0231\u0232\3\2\2\2\u0232\u0233\3\2\2\2\u0233"+
		"\u0234\7\5\2\2\u0234\u023f\3\2\2\2\u0235\u023f\7m\2\2\u0236\u023f\7d\2"+
		"\2\u0237\u0239\7n\2\2\u0238\u0237\3\2\2\2\u0239\u023a\3\2\2\2\u023a\u0238"+
		"\3\2\2\2\u023a\u023b\3\2\2\2\u023b\u023f\3\2\2\2\u023c\u023f\7o\2\2\u023d"+
		"\u023f\7U\2\2\u023e\u01fd\3\2\2\2\u023e\u0202\3\2\2\2\u023e\u020a\3\2"+
		"\2\2\u023e\u0212\3\2\2\2\u023e\u021a\3\2\2\2\u023e\u021f\3\2\2\2\u023e"+
		"\u0221\3\2\2\2\u023e\u0223\3\2\2\2\u023e\u0225\3\2\2\2\u023e\u0227\3\2"+
		"\2\2\u023e\u0235\3\2\2\2\u023e\u0236\3\2\2\2\u023e\u0238\3\2\2\2\u023e"+
		"\u023c\3\2\2\2\u023e\u023d\3\2\2\2\u023f\u027c\3\2\2\2\u0240\u0241\f\25"+
		"\2\2\u0241\u0242\t\5\2\2\u0242\u027b\5D#\26\u0243\u0244\f\24\2\2\u0244"+
		"\u0245\t\6\2\2\u0245\u027b\5D#\25\u0246\u0247\f\23\2\2\u0247\u0248\t\7"+
		"\2\2\u0248\u027b\5D#\24\u0249\u024a\f\21\2\2\u024a\u024b\t\b\2\2\u024b"+
		"\u027b\5D#\22\u024c\u024d\f\20\2\2\u024d\u024e\7\31\2\2\u024e\u027b\5"+
		"D#\21\u024f\u0250\f\17\2\2\u0250\u0251\7\33\2\2\u0251\u027b\5D#\20\u0252"+
		"\u0253\f\16\2\2\u0253\u0254\7\34\2\2\u0254\u027b\5D#\17\u0255\u0256\f"+
		"\r\2\2\u0256\u0257\7%\2\2\u0257\u027b\5D#\16\u0258\u0259\f\f\2\2\u0259"+
		"\u025a\7&\2\2\u025a\u027b\5D#\r\u025b\u025c\f\13\2\2\u025c\u025d\7\17"+
		"\2\2\u025d\u025e\5D#\2\u025e\u025f\7\13\2\2\u025f\u0260\5D#\f\u0260\u027b"+
		"\3\2\2\2\u0261\u0262\f\n\2\2\u0262\u0263\7\'\2\2\u0263\u027b\5D#\n\u0264"+
		"\u0265\f\t\2\2\u0265\u0266\7(\2\2\u0266\u027b\5D#\t\u0267\u0268\f!\2\2"+
		"\u0268\u0269\7\20\2\2\u0269\u027b\7m\2\2\u026a\u026b\f \2\2\u026b\u026c"+
		"\7\21\2\2\u026c\u027b\7m\2\2\u026d\u026e\f\37\2\2\u026e\u0270\7\b\2\2"+
		"\u026f\u0271\5F$\2\u0270\u026f\3\2\2\2\u0270\u0271\3\2\2\2\u0271\u0272"+
		"\3\2\2\2\u0272\u027b\7\t\2\2\u0273\u0274\f\33\2\2\u0274\u0275\7\6\2\2"+
		"\u0275\u0276\5B\"\2\u0276\u0277\7\7\2\2\u0277\u027b\3\2\2\2\u0278\u0279"+
		"\f\30\2\2\u0279\u027b\t\2\2\2\u027a\u0240\3\2\2\2\u027a\u0243\3\2\2\2"+
		"\u027a\u0246\3\2\2\2\u027a\u0249\3\2\2\2\u027a\u024c\3\2\2\2\u027a\u024f"+
		"\3\2\2\2\u027a\u0252\3\2\2\2\u027a\u0255\3\2\2\2\u027a\u0258\3\2\2\2\u027a"+
		"\u025b\3\2\2\2\u027a\u0261\3\2\2\2\u027a\u0264\3\2\2\2\u027a\u0267\3\2"+
		"\2\2\u027a\u026a\3\2\2\2\u027a\u026d\3\2\2\2\u027a\u0273\3\2\2\2\u027a"+
		"\u0278\3\2\2\2\u027b\u027e\3\2\2\2\u027c\u027a\3\2\2\2\u027c\u027d\3\2"+
		"\2\2\u027dE\3\2\2\2\u027e\u027c\3\2\2\2\u027f\u0284\5D#\2\u0280\u0281"+
		"\7\f\2\2\u0281\u0283\5D#\2\u0282\u0280\3\2\2\2\u0283\u0286\3\2\2\2\u0284"+
		"\u0282\3\2\2\2\u0284\u0285\3\2\2\2\u0285G\3\2\2\2\u0286\u0284\3\2\2\2"+
		"\u0287\u0289\7L\2\2\u0288\u028a\5J&\2\u0289\u0288\3\2\2\2\u0289\u028a"+
		"\3\2\2\2\u028a\u028b\3\2\2\2\u028b\u028c\7V\2\2\u028cI\3\2\2\2\u028d\u028e"+
		"\7\b\2\2\u028e\u0293\5L\'\2\u028f\u0290\7\f\2\2\u0290\u0292\5L\'\2\u0291"+
		"\u028f\3\2\2\2\u0292\u0295\3\2\2\2\u0293\u0291\3\2\2\2\u0293\u0294\3\2"+
		"\2\2\u0294\u0296\3\2\2\2\u0295\u0293\3\2\2\2\u0296\u0297\7\t\2\2\u0297"+
		"K\3\2\2\2\u0298\u0299\7M\2\2\u0299\u02a3\7n\2\2\u029a\u029b\7N\2\2\u029b"+
		"\u02a3\7m\2\2\u029c\u029d\7O\2\2\u029d\u02a3\7n\2\2\u029e\u029f\7P\2\2"+
		"\u029f\u02a3\5D#\2\u02a0\u02a1\7Q\2\2\u02a1\u02a3\5D#\2\u02a2\u0298\3"+
		"\2\2\2\u02a2\u029a\3\2\2\2\u02a2\u029c\3\2\2\2\u02a2\u029e\3\2\2\2\u02a2"+
		"\u02a0\3\2\2\2\u02a3M\3\2\2\2\u02a4\u02a6\5P)\2\u02a5\u02a4\3\2\2\2\u02a6"+
		"\u02a9\3\2\2\2\u02a7\u02a5\3\2\2\2\u02a7\u02a8\3\2\2\2\u02a8O\3\2\2\2"+
		"\u02a9\u02a7\3\2\2\2\u02aa\u02ae\5R*\2\u02ab\u02ae\5T+\2\u02ac\u02ae\5"+
		"V,\2\u02ad\u02aa\3\2\2\2\u02ad\u02ab\3\2\2\2\u02ad\u02ac\3\2\2\2\u02ae"+
		"Q\3\2\2\2\u02af\u02b0\7\u0093\2\2\u02b0\u02b4\7v\2\2\u02b1\u02b3\7\u0094"+
		"\2\2\u02b2\u02b1\3\2\2\2\u02b3\u02b6\3\2\2\2\u02b4\u02b2\3\2\2\2\u02b4"+
		"\u02b5\3\2\2\2\u02b5\u02c0\3\2\2\2\u02b6\u02b4\3\2\2\2\u02b7\u02b8\7\u0092"+
		"\2\2\u02b8\u02bc\7v\2\2\u02b9\u02bb\7\u0094\2\2\u02ba\u02b9\3\2\2\2\u02bb"+
		"\u02be\3\2\2\2\u02bc\u02ba\3\2\2\2\u02bc\u02bd\3\2\2\2\u02bd\u02c0\3\2"+
		"\2\2\u02be\u02bc\3\2\2\2\u02bf\u02af\3\2\2\2\u02bf\u02b7\3\2\2\2\u02c0"+
		"S\3\2\2\2\u02c1\u02c3\7t\2\2\u02c2\u02c4\5X-\2\u02c3\u02c2\3\2\2\2\u02c3"+
		"\u02c4\3\2\2\2\u02c4\u02c8\3\2\2\2\u02c5\u02c7\7\u0094\2\2\u02c6\u02c5"+
		"\3\2\2\2\u02c7\u02ca\3\2\2\2\u02c8\u02c6\3\2\2\2\u02c8\u02c9\3\2\2\2\u02c9"+
		"U\3\2\2\2\u02ca\u02c8\3\2\2\2\u02cb\u02cc\7s\2\2\u02cc\u02d1\5Z.\2\u02cd"+
		"\u02ce\7w\2\2\u02ce\u02d0\5Z.\2\u02cf\u02cd\3\2\2\2\u02d0\u02d3\3\2\2"+
		"\2\u02d1\u02cf\3\2\2\2\u02d1\u02d2\3\2\2\2\u02d2\u02d7\3\2\2\2\u02d3\u02d1"+
		"\3\2\2\2\u02d4\u02d6\7\u0094\2\2\u02d5\u02d4\3\2\2\2\u02d6\u02d9\3\2\2"+
		"\2\u02d7\u02d5\3\2\2\2\u02d7\u02d8\3\2\2\2\u02d8W\3\2\2\2\u02d9\u02d7"+
		"\3\2\2\2\u02da\u0308\5Z.\2\u02db\u02dc\7u\2\2\u02dc\u0308\5Z.\2\u02dd"+
		"\u02de\5Z.\2\u02de\u02df\7w\2\2\u02df\u02e0\5Z.\2\u02e0\u0308\3\2\2\2"+
		"\u02e1\u02e2\7x\2\2\u02e2\u02e3\5Z.\2\u02e3\u02e4\7y\2\2\u02e4\u02e5\7"+
		"w\2\2\u02e5\u02e6\7\u0093\2\2\u02e6\u0308\3\2\2\2\u02e7\u02e8\7x\2\2\u02e8"+
		"\u02e9\7x\2\2\u02e9\u02ea\5Z.\2\u02ea\u02eb\7y\2\2\u02eb\u02ec\7y\2\2"+
		"\u02ec\u02ed\7w\2\2\u02ed\u02ee\7\u0093\2\2\u02ee\u0308\3\2\2\2\u02ef"+
		"\u02f0\7x\2\2\u02f0\u02f1\5Z.\2\u02f1\u02f2\7w\2\2\u02f2\u02f3\7\u0093"+
		"\2\2\u02f3\u02f4\7y\2\2\u02f4\u02f5\7w\2\2\u02f5\u02f6\7\u0093\2\2\u02f6"+
		"\u0308\3\2\2\2\u02f7\u02f8\7x\2\2\u02f8\u02f9\5Z.\2\u02f9\u02fa\7w\2\2"+
		"\u02fa\u02fb\7\u0093\2\2\u02fb\u02fc\7y\2\2\u02fc\u0308\3\2\2\2\u02fd"+
		"\u02fe\7x\2\2\u02fe\u02ff\5Z.\2\u02ff\u0300\7y\2\2\u0300\u0308\3\2\2\2"+
		"\u0301\u0302\7x\2\2\u0302\u0303\7x\2\2\u0303\u0304\5Z.\2\u0304\u0305\7"+
		"y\2\2\u0305\u0306\7y\2\2\u0306\u0308\3\2\2\2\u0307\u02da\3\2\2\2\u0307"+
		"\u02db\3\2\2\2\u0307\u02dd\3\2\2\2\u0307\u02e1\3\2\2\2\u0307\u02e7\3\2"+
		"\2\2\u0307\u02ef\3\2\2\2\u0307\u02f7\3\2\2\2\u0307\u02fd\3\2\2\2\u0307"+
		"\u0301\3\2\2\2\u0308Y\3\2\2\2\u0309\u030a\b.\1\2\u030a\u030b\7z\2\2\u030b"+
		"\u030c\5Z.\2\u030c\u030d\7{\2\2\u030d\u0318\3\2\2\2\u030e\u030f\t\t\2"+
		"\2\u030f\u0318\5Z.\n\u0310\u0318\7\u0093\2\2\u0311\u0318\7\u0091\2\2\u0312"+
		"\u0313\7\u0085\2\2\u0313\u0314\7\u0093\2\2\u0314\u0318\7\u0086\2\2\u0315"+
		"\u0318\7\u0087\2\2\u0316\u0318\7\u0090\2\2\u0317\u0309\3\2\2\2\u0317\u030e"+
		"\3\2\2\2\u0317\u0310\3\2\2\2\u0317\u0311\3\2\2\2\u0317\u0312\3\2\2\2\u0317"+
		"\u0315\3\2\2\2\u0317\u0316\3\2\2\2\u0318\u0327\3\2\2\2\u0319\u031a\f\f"+
		"\2\2\u031a\u031b\7|\2\2\u031b\u0326\5Z.\r\u031c\u031d\f\13\2\2\u031d\u031e"+
		"\t\n\2\2\u031e\u0326\5Z.\f\u031f\u0320\f\t\2\2\u0320\u0321\t\13\2\2\u0321"+
		"\u0326\5Z.\n\u0322\u0323\f\b\2\2\u0323\u0324\t\f\2\2\u0324\u0326\5Z.\t"+
		"\u0325\u0319\3\2\2\2\u0325\u031c\3\2\2\2\u0325\u031f\3\2\2\2\u0325\u0322"+
		"\3\2\2\2\u0326\u0329\3\2\2\2\u0327\u0325\3\2\2\2\u0327\u0328\3\2\2\2\u0328"+
		"[\3\2\2\2\u0329\u0327\3\2\2\2Qev\u0083\u0089\u008f\u0099\u00a0\u00ab\u00ae"+
		"\u00b0\u00ba\u00c2\u00c7\u00cd\u00d0\u00d2\u00d8\u00df\u00e6\u00ec\u00f8"+
		"\u0106\u010c\u0112\u011b\u0123\u012d\u0139\u0144\u0159\u0162\u0168\u016d"+
		"\u0174\u0181\u0186\u0192\u01a0\u01b3\u01bc\u01c4\u01c9\u01ce\u01d0\u01d6"+
		"\u01db\u01df\u01e8\u01eb\u01ee\u01fa\u0206\u020e\u0214\u0218\u022d\u0231"+
		"\u023a\u023e\u0270\u027a\u027c\u0284\u0289\u0293\u02a2\u02a7\u02ad\u02b4"+
		"\u02bc\u02bf\u02c3\u02c8\u02d1\u02d7\u0307\u0317\u0325\u0327";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}
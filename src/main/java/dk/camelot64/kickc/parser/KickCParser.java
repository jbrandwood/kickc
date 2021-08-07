// Generated from /Users/jespergravgaard/c64/kickc/src/main/java/dk/camelot64/kickc/parser/KickCParser.g4 by ANTLR 4.9.1
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
	static { RuntimeMetaData.checkVersion("4.9.1", RuntimeMetaData.VERSION); }

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
		SWITCH=62, RETURN=63, BREAK=64, CONTINUE=65, GOTO=66, ASM=67, DEFAULT=68, 
		CASE=69, STRUCT=70, UNION=71, ENUM=72, SIZEOF=73, TYPEID=74, DEFINED=75, 
		KICKASM=76, RESOURCE=77, USES=78, CLOBBERS=79, BYTES=80, CYCLES=81, LOGIC_NOT=82, 
		SIMPLETYPE=83, BOOLEAN=84, KICKASM_BODY=85, IMPORT=86, INCLUDE=87, PRAGMA=88, 
		DEFINE=89, DEFINE_CONTINUE=90, UNDEF=91, IFDEF=92, IFNDEF=93, IFIF=94, 
		ELIF=95, IFELSE=96, ENDIF=97, ERROR=98, NUMBER=99, NUMFLOAT=100, BINFLOAT=101, 
		DECFLOAT=102, HEXFLOAT=103, NUMINT=104, BININTEGER=105, DECINTEGER=106, 
		HEXINTEGER=107, NAME=108, STRING=109, CHAR=110, WS=111, COMMENT_LINE=112, 
		COMMENT_BLOCK=113, ASM_BYTE=114, ASM_MNEMONIC=115, ASM_IMM=116, ASM_COLON=117, 
		ASM_COMMA=118, ASM_PAR_BEGIN=119, ASM_PAR_END=120, ASM_BRACKET_BEGIN=121, 
		ASM_BRACKET_END=122, ASM_DOT=123, ASM_SHIFT_LEFT=124, ASM_SHIFT_RIGHT=125, 
		ASM_PLUS=126, ASM_MINUS=127, ASM_LESS_THAN=128, ASM_GREATER_THAN=129, 
		ASM_MULTIPLY=130, ASM_DIVIDE=131, ASM_CURLY_BEGIN=132, ASM_CURLY_END=133, 
		ASM_NUMBER=134, ASM_NUMFLOAT=135, ASM_BINFLOAT=136, ASM_DECFLOAT=137, 
		ASM_HEXFLOAT=138, ASM_NUMINT=139, ASM_BININTEGER=140, ASM_DECINTEGER=141, 
		ASM_HEXINTEGER=142, ASM_CHAR=143, ASM_MULTI_REL=144, ASM_MULTI_NAME=145, 
		ASM_NAME=146, ASM_TAG=147, ASM_WS=148, ASM_COMMENT_LINE=149, ASM_COMMENT_BLOCK=150, 
		IMPORT_SYSTEMFILE=151, IMPORT_LOCALFILE=152, IMPORT_WS=153, IMPORT_COMMENT_LINE=154, 
		IMPORT_COMMENT_BLOCK=155;
	public static final int
		RULE_file = 0, RULE_asmFile = 1, RULE_declSeq = 2, RULE_decl = 3, RULE_declVariables = 4, 
		RULE_declaratorInitList = 5, RULE_declaratorInit = 6, RULE_typeDef = 7, 
		RULE_declType = 8, RULE_typeName = 9, RULE_typeNameDeclarator = 10, RULE_declarator = 11, 
		RULE_type = 12, RULE_structRef = 13, RULE_structDef = 14, RULE_structMembers = 15, 
		RULE_enumRef = 16, RULE_enumDef = 17, RULE_enumMemberList = 18, RULE_enumMember = 19, 
		RULE_declFunction = 20, RULE_parameterListDecl = 21, RULE_parameterDecl = 22, 
		RULE_pragma = 23, RULE_pragmaParam = 24, RULE_directive = 25, RULE_stmtSeq = 26, 
		RULE_stmt = 27, RULE_switchCases = 28, RULE_switchCase = 29, RULE_forLoop = 30, 
		RULE_forClassicInit = 31, RULE_forClassicCondition = 32, RULE_commaExpr = 33, 
		RULE_expr = 34, RULE_parameterList = 35, RULE_kasmContent = 36, RULE_asmDirectives = 37, 
		RULE_asmDirective = 38, RULE_asmLines = 39, RULE_asmLine = 40, RULE_asmLabel = 41, 
		RULE_asmInstruction = 42, RULE_asmBytes = 43, RULE_asmParamMode = 44, 
		RULE_asmExpr = 45;
	private static String[] makeRuleNames() {
		return new String[] {
			"file", "asmFile", "declSeq", "decl", "declVariables", "declaratorInitList", 
			"declaratorInit", "typeDef", "declType", "typeName", "typeNameDeclarator", 
			"declarator", "type", "structRef", "structDef", "structMembers", "enumRef", 
			"enumDef", "enumMemberList", "enumMember", "declFunction", "parameterListDecl", 
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
			"'extern'", "'__export'", "'__align'", "'inline'", "'volatile'", "'static'", 
			"'__interrupt'", "'register'", "'__zp_reserve'", "'__address'", "'__zp'", 
			"'__mem'", "'__ssa'", "'__ma'", "'__intrinsic'", null, "'if'", "'else'", 
			"'while'", "'do'", "'for'", "'switch'", "'return'", "'break'", "'continue'", 
			"'goto'", "'asm'", "'default'", "'case'", "'struct'", "'union'", "'enum'", 
			"'sizeof'", "'typeid'", "'defined'", "'kickasm'", "'resource'", "'uses'", 
			"'clobbers'", "'bytes'", "'cycles'", "'!'", null, null, null, "'#import'", 
			"'#include'", "'#pragma'", "'#define'", null, "'#undef'", "'#ifdef'", 
			"'#ifndef'", "'#if'", "'#elif'", "'#else'", "'#endif'", "'#error'", null, 
			null, null, null, null, null, null, null, null, null, null, null, null, 
			null, null, "'.byte'", null, "'#'"
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
			"GOTO", "ASM", "DEFAULT", "CASE", "STRUCT", "UNION", "ENUM", "SIZEOF", 
			"TYPEID", "DEFINED", "KICKASM", "RESOURCE", "USES", "CLOBBERS", "BYTES", 
			"CYCLES", "LOGIC_NOT", "SIMPLETYPE", "BOOLEAN", "KICKASM_BODY", "IMPORT", 
			"INCLUDE", "PRAGMA", "DEFINE", "DEFINE_CONTINUE", "UNDEF", "IFDEF", "IFNDEF", 
			"IFIF", "ELIF", "IFELSE", "ENDIF", "ERROR", "NUMBER", "NUMFLOAT", "BINFLOAT", 
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
			setState(92);
			declSeq();
			setState(93);
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
			setState(95);
			asmLines();
			setState(96);
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
			setState(101);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << TYPEDEFNAME) | (1L << TYPEDEF) | (1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << INLINE) | (1L << VOLATILE) | (1L << STATIC) | (1L << INTERRUPT) | (1L << REGISTER) | (1L << LOCAL_RESERVE) | (1L << ADDRESS) | (1L << ADDRESS_ZEROPAGE) | (1L << ADDRESS_MAINMEM) | (1L << FORM_SSA) | (1L << FORM_MA) | (1L << INTRINSIC) | (1L << CALLINGCONVENTION))) != 0) || ((((_la - 70)) & ~0x3f) == 0 && ((1L << (_la - 70)) & ((1L << (STRUCT - 70)) | (1L << (UNION - 70)) | (1L << (ENUM - 70)) | (1L << (SIMPLETYPE - 70)) | (1L << (PRAGMA - 70)))) != 0)) {
				{
				{
				setState(98);
				decl();
				}
				}
				setState(103);
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
			setState(118);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,1,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				setState(104);
				declVariables();
				setState(105);
				match(SEMICOLON);
				}
				break;
			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(107);
				declFunction();
				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(108);
				structDef();
				setState(109);
				match(SEMICOLON);
				}
				break;
			case 4:
				enterOuterAlt(_localctx, 4);
				{
				setState(111);
				enumDef();
				setState(112);
				match(SEMICOLON);
				}
				break;
			case 5:
				enterOuterAlt(_localctx, 5);
				{
				setState(114);
				pragma();
				}
				break;
			case 6:
				enterOuterAlt(_localctx, 6);
				{
				setState(115);
				typeDef();
				setState(116);
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
			setState(120);
			declType();
			setState(121);
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
			setState(124);
			declaratorInit();
			}
			_ctx.stop = _input.LT(-1);
			setState(131);
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
					setState(126);
					if (!(precpred(_ctx, 1))) throw new FailedPredicateException(this, "precpred(_ctx, 1)");
					setState(127);
					match(COMMA);
					setState(128);
					declaratorInit();
					}
					} 
				}
				setState(133);
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
			setState(143);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,4,_ctx) ) {
			case 1:
				_localctx = new DeclVariableInitExprContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(134);
				declarator(0);
				setState(137);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,3,_ctx) ) {
				case 1:
					{
					setState(135);
					match(ASSIGN);
					setState(136);
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
				setState(139);
				declarator(0);
				setState(140);
				match(ASSIGN);
				setState(141);
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
			setState(145);
			match(TYPEDEF);
			setState(146);
			declType();
			 isTypedef=true; 
			setState(148);
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
			setState(153);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << INLINE) | (1L << VOLATILE) | (1L << STATIC) | (1L << INTERRUPT) | (1L << REGISTER) | (1L << LOCAL_RESERVE) | (1L << ADDRESS) | (1L << ADDRESS_ZEROPAGE) | (1L << ADDRESS_MAINMEM) | (1L << FORM_SSA) | (1L << FORM_MA) | (1L << INTRINSIC) | (1L << CALLINGCONVENTION))) != 0)) {
				{
				{
				setState(150);
				directive();
				}
				}
				setState(155);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(156);
			type();
			setState(160);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << INLINE) | (1L << VOLATILE) | (1L << STATIC) | (1L << INTERRUPT) | (1L << REGISTER) | (1L << LOCAL_RESERVE) | (1L << ADDRESS) | (1L << ADDRESS_ZEROPAGE) | (1L << ADDRESS_MAINMEM) | (1L << FORM_SSA) | (1L << FORM_MA) | (1L << INTRINSIC) | (1L << CALLINGCONVENTION))) != 0)) {
				{
				{
				setState(157);
				directive();
				}
				}
				setState(162);
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

	public static class TypeNameContext extends ParserRuleContext {
		public TypeContext type() {
			return getRuleContext(TypeContext.class,0);
		}
		public TypeNameDeclaratorContext typeNameDeclarator() {
			return getRuleContext(TypeNameDeclaratorContext.class,0);
		}
		public TypeNameContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_typeName; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterTypeName(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitTypeName(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitTypeName(this);
			else return visitor.visitChildren(this);
		}
	}

	public final TypeNameContext typeName() throws RecognitionException {
		TypeNameContext _localctx = new TypeNameContext(_ctx, getState());
		enterRule(_localctx, 18, RULE_typeName);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(163);
			type();
			setState(164);
			typeNameDeclarator(0);
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

	public static class TypeNameDeclaratorContext extends ParserRuleContext {
		public TypeNameDeclaratorContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_typeNameDeclarator; }
	 
		public TypeNameDeclaratorContext() { }
		public void copyFrom(TypeNameDeclaratorContext ctx) {
			super.copyFrom(ctx);
		}
	}
	public static class TypeNameDeclaratorArrayContext extends TypeNameDeclaratorContext {
		public TypeNameDeclaratorContext typeNameDeclarator() {
			return getRuleContext(TypeNameDeclaratorContext.class,0);
		}
		public TerminalNode BRACKET_BEGIN() { return getToken(KickCParser.BRACKET_BEGIN, 0); }
		public TerminalNode BRACKET_END() { return getToken(KickCParser.BRACKET_END, 0); }
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public TypeNameDeclaratorArrayContext(TypeNameDeclaratorContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterTypeNameDeclaratorArray(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitTypeNameDeclaratorArray(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitTypeNameDeclaratorArray(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class TypeNameDeclaratorParContext extends TypeNameDeclaratorContext {
		public TerminalNode PAR_BEGIN() { return getToken(KickCParser.PAR_BEGIN, 0); }
		public TypeNameDeclaratorContext typeNameDeclarator() {
			return getRuleContext(TypeNameDeclaratorContext.class,0);
		}
		public TerminalNode PAR_END() { return getToken(KickCParser.PAR_END, 0); }
		public TypeNameDeclaratorParContext(TypeNameDeclaratorContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterTypeNameDeclaratorPar(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitTypeNameDeclaratorPar(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitTypeNameDeclaratorPar(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class TypeNameDeclaratorNameContext extends TypeNameDeclaratorContext {
		public TypeNameDeclaratorNameContext(TypeNameDeclaratorContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterTypeNameDeclaratorName(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitTypeNameDeclaratorName(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitTypeNameDeclaratorName(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class TypeNameDeclaratorProcedureContext extends TypeNameDeclaratorContext {
		public TypeNameDeclaratorContext typeNameDeclarator() {
			return getRuleContext(TypeNameDeclaratorContext.class,0);
		}
		public TerminalNode PAR_BEGIN() { return getToken(KickCParser.PAR_BEGIN, 0); }
		public TerminalNode PAR_END() { return getToken(KickCParser.PAR_END, 0); }
		public ParameterListDeclContext parameterListDecl() {
			return getRuleContext(ParameterListDeclContext.class,0);
		}
		public TypeNameDeclaratorProcedureContext(TypeNameDeclaratorContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterTypeNameDeclaratorProcedure(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitTypeNameDeclaratorProcedure(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitTypeNameDeclaratorProcedure(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class TypeNameDeclaratorPointerContext extends TypeNameDeclaratorContext {
		public TerminalNode ASTERISK() { return getToken(KickCParser.ASTERISK, 0); }
		public TypeNameDeclaratorContext typeNameDeclarator() {
			return getRuleContext(TypeNameDeclaratorContext.class,0);
		}
		public List<DirectiveContext> directive() {
			return getRuleContexts(DirectiveContext.class);
		}
		public DirectiveContext directive(int i) {
			return getRuleContext(DirectiveContext.class,i);
		}
		public TypeNameDeclaratorPointerContext(TypeNameDeclaratorContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterTypeNameDeclaratorPointer(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitTypeNameDeclaratorPointer(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitTypeNameDeclaratorPointer(this);
			else return visitor.visitChildren(this);
		}
	}

	public final TypeNameDeclaratorContext typeNameDeclarator() throws RecognitionException {
		return typeNameDeclarator(0);
	}

	private TypeNameDeclaratorContext typeNameDeclarator(int _p) throws RecognitionException {
		ParserRuleContext _parentctx = _ctx;
		int _parentState = getState();
		TypeNameDeclaratorContext _localctx = new TypeNameDeclaratorContext(_ctx, _parentState);
		TypeNameDeclaratorContext _prevctx = _localctx;
		int _startState = 20;
		enterRecursionRule(_localctx, 20, RULE_typeNameDeclarator, _p);
		int _la;
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(179);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,8,_ctx) ) {
			case 1:
				{
				_localctx = new TypeNameDeclaratorNameContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;

				}
				break;
			case 2:
				{
				_localctx = new TypeNameDeclaratorPointerContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(167);
				match(ASTERISK);
				setState(171);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,7,_ctx);
				while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
					if ( _alt==1 ) {
						{
						{
						setState(168);
						directive();
						}
						} 
					}
					setState(173);
					_errHandler.sync(this);
					_alt = getInterpreter().adaptivePredict(_input,7,_ctx);
				}
				setState(174);
				typeNameDeclarator(2);
				}
				break;
			case 3:
				{
				_localctx = new TypeNameDeclaratorParContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(175);
				match(PAR_BEGIN);
				setState(176);
				typeNameDeclarator(0);
				setState(177);
				match(PAR_END);
				}
				break;
			}
			_ctx.stop = _input.LT(-1);
			setState(195);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,12,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					setState(193);
					_errHandler.sync(this);
					switch ( getInterpreter().adaptivePredict(_input,11,_ctx) ) {
					case 1:
						{
						_localctx = new TypeNameDeclaratorProcedureContext(new TypeNameDeclaratorContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_typeNameDeclarator);
						setState(181);
						if (!(precpred(_ctx, 4))) throw new FailedPredicateException(this, "precpred(_ctx, 4)");
						setState(182);
						match(PAR_BEGIN);
						setState(184);
						_errHandler.sync(this);
						_la = _input.LA(1);
						if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << TYPEDEFNAME) | (1L << PARAM_LIST) | (1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << INLINE) | (1L << VOLATILE) | (1L << STATIC) | (1L << INTERRUPT) | (1L << REGISTER) | (1L << LOCAL_RESERVE) | (1L << ADDRESS) | (1L << ADDRESS_ZEROPAGE) | (1L << ADDRESS_MAINMEM) | (1L << FORM_SSA) | (1L << FORM_MA) | (1L << INTRINSIC) | (1L << CALLINGCONVENTION))) != 0) || ((((_la - 70)) & ~0x3f) == 0 && ((1L << (_la - 70)) & ((1L << (STRUCT - 70)) | (1L << (UNION - 70)) | (1L << (ENUM - 70)) | (1L << (SIMPLETYPE - 70)))) != 0)) {
							{
							setState(183);
							parameterListDecl();
							}
						}

						setState(186);
						match(PAR_END);
						}
						break;
					case 2:
						{
						_localctx = new TypeNameDeclaratorArrayContext(new TypeNameDeclaratorContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_typeNameDeclarator);
						setState(187);
						if (!(precpred(_ctx, 3))) throw new FailedPredicateException(this, "precpred(_ctx, 3)");
						setState(188);
						match(BRACKET_BEGIN);
						setState(190);
						_errHandler.sync(this);
						_la = _input.LA(1);
						if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << CURLY_BEGIN) | (1L << PAR_BEGIN) | (1L << PLUS) | (1L << MINUS) | (1L << ASTERISK) | (1L << INC) | (1L << DEC) | (1L << AND) | (1L << BIT_NOT))) != 0) || ((((_la - 73)) & ~0x3f) == 0 && ((1L << (_la - 73)) & ((1L << (SIZEOF - 73)) | (1L << (TYPEID - 73)) | (1L << (DEFINED - 73)) | (1L << (LOGIC_NOT - 73)) | (1L << (BOOLEAN - 73)) | (1L << (NUMBER - 73)) | (1L << (NAME - 73)) | (1L << (STRING - 73)) | (1L << (CHAR - 73)))) != 0)) {
							{
							setState(189);
							expr(0);
							}
						}

						setState(192);
						match(BRACKET_END);
						}
						break;
					}
					} 
				}
				setState(197);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,12,_ctx);
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
		int _startState = 22;
		enterRecursionRule(_localctx, 22, RULE_declarator, _p);
		int _la;
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(213);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case NAME:
				{
				_localctx = new DeclaratorNameContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;

				setState(199);
				((DeclaratorNameContext)_localctx).NAME = match(NAME);
				if(isTypedef) { cParser.addTypedef((((DeclaratorNameContext)_localctx).NAME!=null?((DeclaratorNameContext)_localctx).NAME.getText():null)); isTypedef=false; } 
				}
				break;
			case ASTERISK:
				{
				_localctx = new DeclaratorPointerContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(201);
				match(ASTERISK);
				setState(205);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << INLINE) | (1L << VOLATILE) | (1L << STATIC) | (1L << INTERRUPT) | (1L << REGISTER) | (1L << LOCAL_RESERVE) | (1L << ADDRESS) | (1L << ADDRESS_ZEROPAGE) | (1L << ADDRESS_MAINMEM) | (1L << FORM_SSA) | (1L << FORM_MA) | (1L << INTRINSIC) | (1L << CALLINGCONVENTION))) != 0)) {
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
				declarator(2);
				}
				break;
			case PAR_BEGIN:
				{
				_localctx = new DeclaratorParContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(209);
				match(PAR_BEGIN);
				setState(210);
				declarator(0);
				setState(211);
				match(PAR_END);
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
			_ctx.stop = _input.LT(-1);
			setState(229);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,18,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					setState(227);
					_errHandler.sync(this);
					switch ( getInterpreter().adaptivePredict(_input,17,_ctx) ) {
					case 1:
						{
						_localctx = new DeclaratorProcedureContext(new DeclaratorContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_declarator);
						setState(215);
						if (!(precpred(_ctx, 4))) throw new FailedPredicateException(this, "precpred(_ctx, 4)");
						setState(216);
						match(PAR_BEGIN);
						setState(218);
						_errHandler.sync(this);
						_la = _input.LA(1);
						if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << TYPEDEFNAME) | (1L << PARAM_LIST) | (1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << INLINE) | (1L << VOLATILE) | (1L << STATIC) | (1L << INTERRUPT) | (1L << REGISTER) | (1L << LOCAL_RESERVE) | (1L << ADDRESS) | (1L << ADDRESS_ZEROPAGE) | (1L << ADDRESS_MAINMEM) | (1L << FORM_SSA) | (1L << FORM_MA) | (1L << INTRINSIC) | (1L << CALLINGCONVENTION))) != 0) || ((((_la - 70)) & ~0x3f) == 0 && ((1L << (_la - 70)) & ((1L << (STRUCT - 70)) | (1L << (UNION - 70)) | (1L << (ENUM - 70)) | (1L << (SIMPLETYPE - 70)))) != 0)) {
							{
							setState(217);
							parameterListDecl();
							}
						}

						setState(220);
						match(PAR_END);
						}
						break;
					case 2:
						{
						_localctx = new DeclaratorArrayContext(new DeclaratorContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_declarator);
						setState(221);
						if (!(precpred(_ctx, 3))) throw new FailedPredicateException(this, "precpred(_ctx, 3)");
						setState(222);
						match(BRACKET_BEGIN);
						setState(224);
						_errHandler.sync(this);
						_la = _input.LA(1);
						if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << CURLY_BEGIN) | (1L << PAR_BEGIN) | (1L << PLUS) | (1L << MINUS) | (1L << ASTERISK) | (1L << INC) | (1L << DEC) | (1L << AND) | (1L << BIT_NOT))) != 0) || ((((_la - 73)) & ~0x3f) == 0 && ((1L << (_la - 73)) & ((1L << (SIZEOF - 73)) | (1L << (TYPEID - 73)) | (1L << (DEFINED - 73)) | (1L << (LOGIC_NOT - 73)) | (1L << (BOOLEAN - 73)) | (1L << (NUMBER - 73)) | (1L << (NAME - 73)) | (1L << (STRING - 73)) | (1L << (CHAR - 73)))) != 0)) {
							{
							setState(223);
							expr(0);
							}
						}

						setState(226);
						match(BRACKET_END);
						}
						break;
					}
					} 
				}
				setState(231);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,18,_ctx);
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
		public List<TerminalNode> SIMPLETYPE() { return getTokens(KickCParser.SIMPLETYPE); }
		public TerminalNode SIMPLETYPE(int i) {
			return getToken(KickCParser.SIMPLETYPE, i);
		}
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
		enterRule(_localctx, 24, RULE_type);
		try {
			int _alt;
			setState(242);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,20,_ctx) ) {
			case 1:
				_localctx = new TypeSimpleContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(233); 
				_errHandler.sync(this);
				_alt = 1;
				do {
					switch (_alt) {
					case 1:
						{
						{
						setState(232);
						match(SIMPLETYPE);
						}
						}
						break;
					default:
						throw new NoViableAltException(this);
					}
					setState(235); 
					_errHandler.sync(this);
					_alt = getInterpreter().adaptivePredict(_input,19,_ctx);
				} while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER );
				}
				break;
			case 2:
				_localctx = new TypeStructDefContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(237);
				structDef();
				}
				break;
			case 3:
				_localctx = new TypeStructRefContext(_localctx);
				enterOuterAlt(_localctx, 3);
				{
				setState(238);
				structRef();
				}
				break;
			case 4:
				_localctx = new TypeEnumDefContext(_localctx);
				enterOuterAlt(_localctx, 4);
				{
				setState(239);
				enumDef();
				}
				break;
			case 5:
				_localctx = new TypeEnumRefContext(_localctx);
				enterOuterAlt(_localctx, 5);
				{
				setState(240);
				enumRef();
				}
				break;
			case 6:
				_localctx = new TypeNamedRefContext(_localctx);
				enterOuterAlt(_localctx, 6);
				{
				setState(241);
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
		public TerminalNode NAME() { return getToken(KickCParser.NAME, 0); }
		public TerminalNode STRUCT() { return getToken(KickCParser.STRUCT, 0); }
		public TerminalNode UNION() { return getToken(KickCParser.UNION, 0); }
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
		enterRule(_localctx, 26, RULE_structRef);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(244);
			_la = _input.LA(1);
			if ( !(_la==STRUCT || _la==UNION) ) {
			_errHandler.recoverInline(this);
			}
			else {
				if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
				_errHandler.reportMatch(this);
				consume();
			}
			setState(245);
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
		public TerminalNode CURLY_BEGIN() { return getToken(KickCParser.CURLY_BEGIN, 0); }
		public TerminalNode CURLY_END() { return getToken(KickCParser.CURLY_END, 0); }
		public TerminalNode STRUCT() { return getToken(KickCParser.STRUCT, 0); }
		public TerminalNode UNION() { return getToken(KickCParser.UNION, 0); }
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
		enterRule(_localctx, 28, RULE_structDef);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(247);
			_la = _input.LA(1);
			if ( !(_la==STRUCT || _la==UNION) ) {
			_errHandler.recoverInline(this);
			}
			else {
				if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
				_errHandler.reportMatch(this);
				consume();
			}
			setState(249);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==NAME) {
				{
				setState(248);
				match(NAME);
				}
			}

			setState(251);
			match(CURLY_BEGIN);
			setState(253); 
			_errHandler.sync(this);
			_la = _input.LA(1);
			do {
				{
				{
				setState(252);
				structMembers();
				}
				}
				setState(255); 
				_errHandler.sync(this);
				_la = _input.LA(1);
			} while ( (((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << TYPEDEFNAME) | (1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << INLINE) | (1L << VOLATILE) | (1L << STATIC) | (1L << INTERRUPT) | (1L << REGISTER) | (1L << LOCAL_RESERVE) | (1L << ADDRESS) | (1L << ADDRESS_ZEROPAGE) | (1L << ADDRESS_MAINMEM) | (1L << FORM_SSA) | (1L << FORM_MA) | (1L << INTRINSIC) | (1L << CALLINGCONVENTION))) != 0) || ((((_la - 70)) & ~0x3f) == 0 && ((1L << (_la - 70)) & ((1L << (STRUCT - 70)) | (1L << (UNION - 70)) | (1L << (ENUM - 70)) | (1L << (SIMPLETYPE - 70)))) != 0) );
			setState(257);
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
		enterRule(_localctx, 30, RULE_structMembers);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(259);
			declVariables();
			setState(260);
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
		enterRule(_localctx, 32, RULE_enumRef);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(262);
			match(ENUM);
			setState(263);
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
		enterRule(_localctx, 34, RULE_enumDef);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(265);
			match(ENUM);
			setState(267);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==NAME) {
				{
				setState(266);
				match(NAME);
				}
			}

			setState(269);
			match(CURLY_BEGIN);
			setState(270);
			enumMemberList(0);
			setState(271);
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
		int _startState = 36;
		enterRecursionRule(_localctx, 36, RULE_enumMemberList, _p);
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			{
			setState(274);
			enumMember();
			}
			_ctx.stop = _input.LT(-1);
			setState(281);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,24,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					{
					_localctx = new EnumMemberListContext(_parentctx, _parentState);
					pushNewRecursionContext(_localctx, _startState, RULE_enumMemberList);
					setState(276);
					if (!(precpred(_ctx, 1))) throw new FailedPredicateException(this, "precpred(_ctx, 1)");
					setState(277);
					match(COMMA);
					setState(278);
					enumMember();
					}
					} 
				}
				setState(283);
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
		enterRule(_localctx, 38, RULE_enumMember);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(284);
			match(NAME);
			setState(287);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,25,_ctx) ) {
			case 1:
				{
				setState(285);
				match(ASSIGN);
				setState(286);
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
		enterRule(_localctx, 40, RULE_declFunction);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(289);
			declType();
			setState(290);
			declarator(0);
			setState(291);
			match(CURLY_BEGIN);
			setState(293);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << TYPEDEFNAME) | (1L << CURLY_BEGIN) | (1L << PAR_BEGIN) | (1L << SEMICOLON) | (1L << PLUS) | (1L << MINUS) | (1L << ASTERISK) | (1L << INC) | (1L << DEC) | (1L << AND) | (1L << BIT_NOT) | (1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << INLINE) | (1L << VOLATILE) | (1L << STATIC) | (1L << INTERRUPT) | (1L << REGISTER) | (1L << LOCAL_RESERVE) | (1L << ADDRESS) | (1L << ADDRESS_ZEROPAGE) | (1L << ADDRESS_MAINMEM) | (1L << FORM_SSA) | (1L << FORM_MA) | (1L << INTRINSIC) | (1L << CALLINGCONVENTION) | (1L << IF) | (1L << WHILE) | (1L << DO) | (1L << FOR) | (1L << SWITCH) | (1L << RETURN))) != 0) || ((((_la - 64)) & ~0x3f) == 0 && ((1L << (_la - 64)) & ((1L << (BREAK - 64)) | (1L << (CONTINUE - 64)) | (1L << (GOTO - 64)) | (1L << (ASM - 64)) | (1L << (STRUCT - 64)) | (1L << (UNION - 64)) | (1L << (ENUM - 64)) | (1L << (SIZEOF - 64)) | (1L << (TYPEID - 64)) | (1L << (DEFINED - 64)) | (1L << (KICKASM - 64)) | (1L << (LOGIC_NOT - 64)) | (1L << (SIMPLETYPE - 64)) | (1L << (BOOLEAN - 64)) | (1L << (NUMBER - 64)) | (1L << (NAME - 64)) | (1L << (STRING - 64)) | (1L << (CHAR - 64)))) != 0)) {
				{
				setState(292);
				stmtSeq();
				}
			}

			setState(295);
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
		enterRule(_localctx, 42, RULE_parameterListDecl);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(297);
			parameterDecl();
			setState(302);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==COMMA) {
				{
				{
				setState(298);
				match(COMMA);
				setState(299);
				parameterDecl();
				}
				}
				setState(304);
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
	public static class ParameterDeclTypeDeclaratorContext extends ParameterDeclContext {
		public DeclTypeContext declType() {
			return getRuleContext(DeclTypeContext.class,0);
		}
		public DeclaratorContext declarator() {
			return getRuleContext(DeclaratorContext.class,0);
		}
		public ParameterDeclTypeDeclaratorContext(ParameterDeclContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterParameterDeclTypeDeclarator(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitParameterDeclTypeDeclarator(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitParameterDeclTypeDeclarator(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class ParameterDeclTypeNameContext extends ParameterDeclContext {
		public TypeNameContext typeName() {
			return getRuleContext(TypeNameContext.class,0);
		}
		public ParameterDeclTypeNameContext(ParameterDeclContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterParameterDeclTypeName(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitParameterDeclTypeName(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitParameterDeclTypeName(this);
			else return visitor.visitChildren(this);
		}
	}

	public final ParameterDeclContext parameterDecl() throws RecognitionException {
		ParameterDeclContext _localctx = new ParameterDeclContext(_ctx, getState());
		enterRule(_localctx, 44, RULE_parameterDecl);
		try {
			setState(310);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,28,_ctx) ) {
			case 1:
				_localctx = new ParameterDeclTypeDeclaratorContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(305);
				declType();
				setState(306);
				declarator(0);
				}
				break;
			case 2:
				_localctx = new ParameterDeclTypeNameContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(308);
				typeName();
				}
				break;
			case 3:
				_localctx = new ParameterDeclListContext(_localctx);
				enterOuterAlt(_localctx, 3);
				{
				setState(309);
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
		enterRule(_localctx, 46, RULE_pragma);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(312);
			match(PRAGMA);
			setState(313);
			match(NAME);
			setState(314);
			match(PAR_BEGIN);
			setState(315);
			pragmaParam();
			setState(320);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==COMMA) {
				{
				{
				setState(316);
				match(COMMA);
				setState(317);
				pragmaParam();
				}
				}
				setState(322);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(323);
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
		enterRule(_localctx, 48, RULE_pragmaParam);
		try {
			setState(332);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,30,_ctx) ) {
			case 1:
				_localctx = new PragmaParamNumberContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(325);
				match(NUMBER);
				}
				break;
			case 2:
				_localctx = new PragmaParamRangeContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(326);
				match(NUMBER);
				setState(327);
				match(RANGE);
				setState(328);
				match(NUMBER);
				}
				break;
			case 3:
				_localctx = new PragmaParamNameContext(_localctx);
				enterOuterAlt(_localctx, 3);
				{
				setState(329);
				match(NAME);
				}
				break;
			case 4:
				_localctx = new PragmaParamStringContext(_localctx);
				enterOuterAlt(_localctx, 4);
				{
				setState(330);
				match(STRING);
				}
				break;
			case 5:
				_localctx = new PragmaParamCallingConventionContext(_localctx);
				enterOuterAlt(_localctx, 5);
				{
				setState(331);
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
		enterRule(_localctx, 50, RULE_directive);
		int _la;
		try {
			setState(379);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case CONST:
				_localctx = new DirectiveConstContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(334);
				match(CONST);
				}
				break;
			case ALIGN:
				_localctx = new DirectiveAlignContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(335);
				match(ALIGN);
				setState(336);
				match(PAR_BEGIN);
				setState(337);
				match(NUMBER);
				setState(338);
				match(PAR_END);
				}
				break;
			case REGISTER:
				_localctx = new DirectiveRegisterContext(_localctx);
				enterOuterAlt(_localctx, 3);
				{
				setState(339);
				match(REGISTER);
				setState(343);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,31,_ctx) ) {
				case 1:
					{
					setState(340);
					match(PAR_BEGIN);
					{
					setState(341);
					match(NAME);
					}
					setState(342);
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
				setState(345);
				match(ADDRESS_ZEROPAGE);
				}
				break;
			case ADDRESS_MAINMEM:
				_localctx = new DirectiveMemoryAreaMainContext(_localctx);
				enterOuterAlt(_localctx, 5);
				{
				setState(346);
				match(ADDRESS_MAINMEM);
				}
				break;
			case ADDRESS:
				_localctx = new DirectiveMemoryAreaAddressContext(_localctx);
				enterOuterAlt(_localctx, 6);
				{
				setState(347);
				match(ADDRESS);
				setState(348);
				match(PAR_BEGIN);
				{
				setState(349);
				expr(0);
				}
				setState(350);
				match(PAR_END);
				}
				break;
			case VOLATILE:
				_localctx = new DirectiveVolatileContext(_localctx);
				enterOuterAlt(_localctx, 7);
				{
				setState(352);
				match(VOLATILE);
				}
				break;
			case STATIC:
				_localctx = new DirectiveStaticContext(_localctx);
				enterOuterAlt(_localctx, 8);
				{
				setState(353);
				match(STATIC);
				}
				break;
			case FORM_SSA:
				_localctx = new DirectiveFormSsaContext(_localctx);
				enterOuterAlt(_localctx, 9);
				{
				setState(354);
				match(FORM_SSA);
				}
				break;
			case FORM_MA:
				_localctx = new DirectiveFormMaContext(_localctx);
				enterOuterAlt(_localctx, 10);
				{
				setState(355);
				match(FORM_MA);
				}
				break;
			case EXTERN:
				_localctx = new DirectiveExternContext(_localctx);
				enterOuterAlt(_localctx, 11);
				{
				setState(356);
				match(EXTERN);
				}
				break;
			case EXPORT:
				_localctx = new DirectiveExportContext(_localctx);
				enterOuterAlt(_localctx, 12);
				{
				setState(357);
				match(EXPORT);
				}
				break;
			case INLINE:
				_localctx = new DirectiveInlineContext(_localctx);
				enterOuterAlt(_localctx, 13);
				{
				setState(358);
				match(INLINE);
				}
				break;
			case INTRINSIC:
				_localctx = new DirectiveIntrinsicContext(_localctx);
				enterOuterAlt(_localctx, 14);
				{
				setState(359);
				match(INTRINSIC);
				}
				break;
			case INTERRUPT:
				_localctx = new DirectiveInterruptContext(_localctx);
				enterOuterAlt(_localctx, 15);
				{
				setState(360);
				match(INTERRUPT);
				setState(364);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,32,_ctx) ) {
				case 1:
					{
					setState(361);
					match(PAR_BEGIN);
					setState(362);
					match(NAME);
					setState(363);
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
				setState(366);
				match(LOCAL_RESERVE);
				setState(367);
				match(PAR_BEGIN);
				setState(368);
				pragmaParam();
				setState(373);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (_la==COMMA) {
					{
					{
					setState(369);
					match(COMMA);
					setState(370);
					pragmaParam();
					}
					}
					setState(375);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				setState(376);
				match(PAR_END);
				}
				break;
			case CALLINGCONVENTION:
				_localctx = new DirectiveCallingConventionContext(_localctx);
				enterOuterAlt(_localctx, 17);
				{
				setState(378);
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
		enterRule(_localctx, 52, RULE_stmtSeq);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(382); 
			_errHandler.sync(this);
			_la = _input.LA(1);
			do {
				{
				{
				setState(381);
				stmt();
				}
				}
				setState(384); 
				_errHandler.sync(this);
				_la = _input.LA(1);
			} while ( (((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << TYPEDEFNAME) | (1L << CURLY_BEGIN) | (1L << PAR_BEGIN) | (1L << SEMICOLON) | (1L << PLUS) | (1L << MINUS) | (1L << ASTERISK) | (1L << INC) | (1L << DEC) | (1L << AND) | (1L << BIT_NOT) | (1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << INLINE) | (1L << VOLATILE) | (1L << STATIC) | (1L << INTERRUPT) | (1L << REGISTER) | (1L << LOCAL_RESERVE) | (1L << ADDRESS) | (1L << ADDRESS_ZEROPAGE) | (1L << ADDRESS_MAINMEM) | (1L << FORM_SSA) | (1L << FORM_MA) | (1L << INTRINSIC) | (1L << CALLINGCONVENTION) | (1L << IF) | (1L << WHILE) | (1L << DO) | (1L << FOR) | (1L << SWITCH) | (1L << RETURN))) != 0) || ((((_la - 64)) & ~0x3f) == 0 && ((1L << (_la - 64)) & ((1L << (BREAK - 64)) | (1L << (CONTINUE - 64)) | (1L << (GOTO - 64)) | (1L << (ASM - 64)) | (1L << (STRUCT - 64)) | (1L << (UNION - 64)) | (1L << (ENUM - 64)) | (1L << (SIZEOF - 64)) | (1L << (TYPEID - 64)) | (1L << (DEFINED - 64)) | (1L << (KICKASM - 64)) | (1L << (LOGIC_NOT - 64)) | (1L << (SIMPLETYPE - 64)) | (1L << (BOOLEAN - 64)) | (1L << (NUMBER - 64)) | (1L << (NAME - 64)) | (1L << (STRING - 64)) | (1L << (CHAR - 64)))) != 0) );
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
	public static class StmtLabelContext extends StmtContext {
		public TerminalNode NAME() { return getToken(KickCParser.NAME, 0); }
		public TerminalNode COLON() { return getToken(KickCParser.COLON, 0); }
		public StmtLabelContext(StmtContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterStmtLabel(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitStmtLabel(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitStmtLabel(this);
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
	public static class StmtGotoContext extends StmtContext {
		public TerminalNode GOTO() { return getToken(KickCParser.GOTO, 0); }
		public TerminalNode NAME() { return getToken(KickCParser.NAME, 0); }
		public TerminalNode SEMICOLON() { return getToken(KickCParser.SEMICOLON, 0); }
		public StmtGotoContext(StmtContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterStmtGoto(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitStmtGoto(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitStmtGoto(this);
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
		enterRule(_localctx, 54, RULE_stmt);
		int _la;
		try {
			setState(476);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,43,_ctx) ) {
			case 1:
				_localctx = new StmtDeclVarContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(386);
				declVariables();
				setState(387);
				match(SEMICOLON);
				}
				break;
			case 2:
				_localctx = new StmtBlockContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(389);
				match(CURLY_BEGIN);
				setState(391);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << TYPEDEFNAME) | (1L << CURLY_BEGIN) | (1L << PAR_BEGIN) | (1L << SEMICOLON) | (1L << PLUS) | (1L << MINUS) | (1L << ASTERISK) | (1L << INC) | (1L << DEC) | (1L << AND) | (1L << BIT_NOT) | (1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << INLINE) | (1L << VOLATILE) | (1L << STATIC) | (1L << INTERRUPT) | (1L << REGISTER) | (1L << LOCAL_RESERVE) | (1L << ADDRESS) | (1L << ADDRESS_ZEROPAGE) | (1L << ADDRESS_MAINMEM) | (1L << FORM_SSA) | (1L << FORM_MA) | (1L << INTRINSIC) | (1L << CALLINGCONVENTION) | (1L << IF) | (1L << WHILE) | (1L << DO) | (1L << FOR) | (1L << SWITCH) | (1L << RETURN))) != 0) || ((((_la - 64)) & ~0x3f) == 0 && ((1L << (_la - 64)) & ((1L << (BREAK - 64)) | (1L << (CONTINUE - 64)) | (1L << (GOTO - 64)) | (1L << (ASM - 64)) | (1L << (STRUCT - 64)) | (1L << (UNION - 64)) | (1L << (ENUM - 64)) | (1L << (SIZEOF - 64)) | (1L << (TYPEID - 64)) | (1L << (DEFINED - 64)) | (1L << (KICKASM - 64)) | (1L << (LOGIC_NOT - 64)) | (1L << (SIMPLETYPE - 64)) | (1L << (BOOLEAN - 64)) | (1L << (NUMBER - 64)) | (1L << (NAME - 64)) | (1L << (STRING - 64)) | (1L << (CHAR - 64)))) != 0)) {
					{
					setState(390);
					stmtSeq();
					}
				}

				setState(393);
				match(CURLY_END);
				}
				break;
			case 3:
				_localctx = new StmtExprContext(_localctx);
				enterOuterAlt(_localctx, 3);
				{
				setState(394);
				commaExpr(0);
				setState(395);
				match(SEMICOLON);
				}
				break;
			case 4:
				_localctx = new StmtIfElseContext(_localctx);
				enterOuterAlt(_localctx, 4);
				{
				setState(397);
				match(IF);
				setState(398);
				match(PAR_BEGIN);
				setState(399);
				commaExpr(0);
				setState(400);
				match(PAR_END);
				setState(401);
				stmt();
				setState(404);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,37,_ctx) ) {
				case 1:
					{
					setState(402);
					match(ELSE);
					setState(403);
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
				setState(409);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << INLINE) | (1L << VOLATILE) | (1L << STATIC) | (1L << INTERRUPT) | (1L << REGISTER) | (1L << LOCAL_RESERVE) | (1L << ADDRESS) | (1L << ADDRESS_ZEROPAGE) | (1L << ADDRESS_MAINMEM) | (1L << FORM_SSA) | (1L << FORM_MA) | (1L << INTRINSIC) | (1L << CALLINGCONVENTION))) != 0)) {
					{
					{
					setState(406);
					directive();
					}
					}
					setState(411);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				setState(412);
				match(WHILE);
				setState(413);
				match(PAR_BEGIN);
				setState(414);
				commaExpr(0);
				setState(415);
				match(PAR_END);
				setState(416);
				stmt();
				}
				break;
			case 6:
				_localctx = new StmtDoWhileContext(_localctx);
				enterOuterAlt(_localctx, 6);
				{
				setState(421);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << INLINE) | (1L << VOLATILE) | (1L << STATIC) | (1L << INTERRUPT) | (1L << REGISTER) | (1L << LOCAL_RESERVE) | (1L << ADDRESS) | (1L << ADDRESS_ZEROPAGE) | (1L << ADDRESS_MAINMEM) | (1L << FORM_SSA) | (1L << FORM_MA) | (1L << INTRINSIC) | (1L << CALLINGCONVENTION))) != 0)) {
					{
					{
					setState(418);
					directive();
					}
					}
					setState(423);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				setState(424);
				match(DO);
				setState(425);
				stmt();
				setState(426);
				match(WHILE);
				setState(427);
				match(PAR_BEGIN);
				setState(428);
				commaExpr(0);
				setState(429);
				match(PAR_END);
				setState(430);
				match(SEMICOLON);
				}
				break;
			case 7:
				_localctx = new StmtForContext(_localctx);
				enterOuterAlt(_localctx, 7);
				{
				setState(435);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << INLINE) | (1L << VOLATILE) | (1L << STATIC) | (1L << INTERRUPT) | (1L << REGISTER) | (1L << LOCAL_RESERVE) | (1L << ADDRESS) | (1L << ADDRESS_ZEROPAGE) | (1L << ADDRESS_MAINMEM) | (1L << FORM_SSA) | (1L << FORM_MA) | (1L << INTRINSIC) | (1L << CALLINGCONVENTION))) != 0)) {
					{
					{
					setState(432);
					directive();
					}
					}
					setState(437);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				setState(438);
				match(FOR);
				setState(439);
				match(PAR_BEGIN);
				setState(440);
				forLoop();
				setState(441);
				match(PAR_END);
				setState(442);
				stmt();
				}
				break;
			case 8:
				_localctx = new StmtSwitchContext(_localctx);
				enterOuterAlt(_localctx, 8);
				{
				setState(444);
				match(SWITCH);
				setState(445);
				match(PAR_BEGIN);
				setState(446);
				commaExpr(0);
				setState(447);
				match(PAR_END);
				setState(448);
				match(CURLY_BEGIN);
				setState(449);
				switchCases();
				setState(450);
				match(CURLY_END);
				}
				break;
			case 9:
				_localctx = new StmtReturnContext(_localctx);
				enterOuterAlt(_localctx, 9);
				{
				setState(452);
				match(RETURN);
				setState(454);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << CURLY_BEGIN) | (1L << PAR_BEGIN) | (1L << PLUS) | (1L << MINUS) | (1L << ASTERISK) | (1L << INC) | (1L << DEC) | (1L << AND) | (1L << BIT_NOT))) != 0) || ((((_la - 73)) & ~0x3f) == 0 && ((1L << (_la - 73)) & ((1L << (SIZEOF - 73)) | (1L << (TYPEID - 73)) | (1L << (DEFINED - 73)) | (1L << (LOGIC_NOT - 73)) | (1L << (BOOLEAN - 73)) | (1L << (NUMBER - 73)) | (1L << (NAME - 73)) | (1L << (STRING - 73)) | (1L << (CHAR - 73)))) != 0)) {
					{
					setState(453);
					commaExpr(0);
					}
				}

				setState(456);
				match(SEMICOLON);
				}
				break;
			case 10:
				_localctx = new StmtBreakContext(_localctx);
				enterOuterAlt(_localctx, 10);
				{
				setState(457);
				match(BREAK);
				setState(458);
				match(SEMICOLON);
				}
				break;
			case 11:
				_localctx = new StmtContinueContext(_localctx);
				enterOuterAlt(_localctx, 11);
				{
				setState(459);
				match(CONTINUE);
				setState(460);
				match(SEMICOLON);
				}
				break;
			case 12:
				_localctx = new StmtAsmContext(_localctx);
				enterOuterAlt(_localctx, 12);
				{
				setState(461);
				match(ASM);
				setState(463);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if (_la==PAR_BEGIN) {
					{
					setState(462);
					asmDirectives();
					}
				}

				setState(465);
				match(CURLY_BEGIN);
				setState(466);
				asmLines();
				setState(467);
				match(ASM_CURLY_END);
				}
				break;
			case 13:
				_localctx = new StmtDeclKasmContext(_localctx);
				enterOuterAlt(_localctx, 13);
				{
				setState(469);
				kasmContent();
				}
				break;
			case 14:
				_localctx = new StmtEmptyContext(_localctx);
				enterOuterAlt(_localctx, 14);
				{
				setState(470);
				match(SEMICOLON);
				}
				break;
			case 15:
				_localctx = new StmtLabelContext(_localctx);
				enterOuterAlt(_localctx, 15);
				{
				setState(471);
				match(NAME);
				setState(472);
				match(COLON);
				}
				break;
			case 16:
				_localctx = new StmtGotoContext(_localctx);
				enterOuterAlt(_localctx, 16);
				{
				setState(473);
				match(GOTO);
				setState(474);
				match(NAME);
				setState(475);
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
		enterRule(_localctx, 56, RULE_switchCases);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(479); 
			_errHandler.sync(this);
			_la = _input.LA(1);
			do {
				{
				{
				setState(478);
				switchCase();
				}
				}
				setState(481); 
				_errHandler.sync(this);
				_la = _input.LA(1);
			} while ( _la==CASE );
			setState(488);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==DEFAULT) {
				{
				setState(483);
				match(DEFAULT);
				setState(484);
				match(COLON);
				setState(486);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << TYPEDEFNAME) | (1L << CURLY_BEGIN) | (1L << PAR_BEGIN) | (1L << SEMICOLON) | (1L << PLUS) | (1L << MINUS) | (1L << ASTERISK) | (1L << INC) | (1L << DEC) | (1L << AND) | (1L << BIT_NOT) | (1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << INLINE) | (1L << VOLATILE) | (1L << STATIC) | (1L << INTERRUPT) | (1L << REGISTER) | (1L << LOCAL_RESERVE) | (1L << ADDRESS) | (1L << ADDRESS_ZEROPAGE) | (1L << ADDRESS_MAINMEM) | (1L << FORM_SSA) | (1L << FORM_MA) | (1L << INTRINSIC) | (1L << CALLINGCONVENTION) | (1L << IF) | (1L << WHILE) | (1L << DO) | (1L << FOR) | (1L << SWITCH) | (1L << RETURN))) != 0) || ((((_la - 64)) & ~0x3f) == 0 && ((1L << (_la - 64)) & ((1L << (BREAK - 64)) | (1L << (CONTINUE - 64)) | (1L << (GOTO - 64)) | (1L << (ASM - 64)) | (1L << (STRUCT - 64)) | (1L << (UNION - 64)) | (1L << (ENUM - 64)) | (1L << (SIZEOF - 64)) | (1L << (TYPEID - 64)) | (1L << (DEFINED - 64)) | (1L << (KICKASM - 64)) | (1L << (LOGIC_NOT - 64)) | (1L << (SIMPLETYPE - 64)) | (1L << (BOOLEAN - 64)) | (1L << (NUMBER - 64)) | (1L << (NAME - 64)) | (1L << (STRING - 64)) | (1L << (CHAR - 64)))) != 0)) {
					{
					setState(485);
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
		enterRule(_localctx, 58, RULE_switchCase);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(490);
			match(CASE);
			setState(491);
			expr(0);
			setState(492);
			match(COLON);
			setState(494);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << TYPEDEFNAME) | (1L << CURLY_BEGIN) | (1L << PAR_BEGIN) | (1L << SEMICOLON) | (1L << PLUS) | (1L << MINUS) | (1L << ASTERISK) | (1L << INC) | (1L << DEC) | (1L << AND) | (1L << BIT_NOT) | (1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << INLINE) | (1L << VOLATILE) | (1L << STATIC) | (1L << INTERRUPT) | (1L << REGISTER) | (1L << LOCAL_RESERVE) | (1L << ADDRESS) | (1L << ADDRESS_ZEROPAGE) | (1L << ADDRESS_MAINMEM) | (1L << FORM_SSA) | (1L << FORM_MA) | (1L << INTRINSIC) | (1L << CALLINGCONVENTION) | (1L << IF) | (1L << WHILE) | (1L << DO) | (1L << FOR) | (1L << SWITCH) | (1L << RETURN))) != 0) || ((((_la - 64)) & ~0x3f) == 0 && ((1L << (_la - 64)) & ((1L << (BREAK - 64)) | (1L << (CONTINUE - 64)) | (1L << (GOTO - 64)) | (1L << (ASM - 64)) | (1L << (STRUCT - 64)) | (1L << (UNION - 64)) | (1L << (ENUM - 64)) | (1L << (SIZEOF - 64)) | (1L << (TYPEID - 64)) | (1L << (DEFINED - 64)) | (1L << (KICKASM - 64)) | (1L << (LOGIC_NOT - 64)) | (1L << (SIMPLETYPE - 64)) | (1L << (BOOLEAN - 64)) | (1L << (NUMBER - 64)) | (1L << (NAME - 64)) | (1L << (STRING - 64)) | (1L << (CHAR - 64)))) != 0)) {
				{
				setState(493);
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
		enterRule(_localctx, 60, RULE_forLoop);
		int _la;
		try {
			setState(512);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,50,_ctx) ) {
			case 1:
				_localctx = new ForClassicContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(496);
				forClassicInit();
				setState(497);
				match(SEMICOLON);
				setState(499);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << CURLY_BEGIN) | (1L << PAR_BEGIN) | (1L << PLUS) | (1L << MINUS) | (1L << ASTERISK) | (1L << INC) | (1L << DEC) | (1L << AND) | (1L << BIT_NOT))) != 0) || ((((_la - 73)) & ~0x3f) == 0 && ((1L << (_la - 73)) & ((1L << (SIZEOF - 73)) | (1L << (TYPEID - 73)) | (1L << (DEFINED - 73)) | (1L << (LOGIC_NOT - 73)) | (1L << (BOOLEAN - 73)) | (1L << (NUMBER - 73)) | (1L << (NAME - 73)) | (1L << (STRING - 73)) | (1L << (CHAR - 73)))) != 0)) {
					{
					setState(498);
					forClassicCondition();
					}
				}

				setState(501);
				match(SEMICOLON);
				setState(503);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << CURLY_BEGIN) | (1L << PAR_BEGIN) | (1L << PLUS) | (1L << MINUS) | (1L << ASTERISK) | (1L << INC) | (1L << DEC) | (1L << AND) | (1L << BIT_NOT))) != 0) || ((((_la - 73)) & ~0x3f) == 0 && ((1L << (_la - 73)) & ((1L << (SIZEOF - 73)) | (1L << (TYPEID - 73)) | (1L << (DEFINED - 73)) | (1L << (LOGIC_NOT - 73)) | (1L << (BOOLEAN - 73)) | (1L << (NUMBER - 73)) | (1L << (NAME - 73)) | (1L << (STRING - 73)) | (1L << (CHAR - 73)))) != 0)) {
					{
					setState(502);
					commaExpr(0);
					}
				}

				}
				break;
			case 2:
				_localctx = new ForRangeContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(505);
				declType();
				setState(506);
				declarator(0);
				setState(507);
				match(COLON);
				setState(508);
				expr(0);
				setState(509);
				match(RANGE);
				setState(510);
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
		enterRule(_localctx, 62, RULE_forClassicInit);
		int _la;
		try {
			setState(518);
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
			case UNION:
			case ENUM:
			case SIMPLETYPE:
				_localctx = new ForClassicInitDeclContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(515);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << TYPEDEFNAME) | (1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << INLINE) | (1L << VOLATILE) | (1L << STATIC) | (1L << INTERRUPT) | (1L << REGISTER) | (1L << LOCAL_RESERVE) | (1L << ADDRESS) | (1L << ADDRESS_ZEROPAGE) | (1L << ADDRESS_MAINMEM) | (1L << FORM_SSA) | (1L << FORM_MA) | (1L << INTRINSIC) | (1L << CALLINGCONVENTION))) != 0) || ((((_la - 70)) & ~0x3f) == 0 && ((1L << (_la - 70)) & ((1L << (STRUCT - 70)) | (1L << (UNION - 70)) | (1L << (ENUM - 70)) | (1L << (SIMPLETYPE - 70)))) != 0)) {
					{
					setState(514);
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
				setState(517);
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
		enterRule(_localctx, 64, RULE_forClassicCondition);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(520);
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
		int _startState = 66;
		enterRecursionRule(_localctx, 66, RULE_commaExpr, _p);
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			{
			_localctx = new CommaNoneContext(_localctx);
			_ctx = _localctx;
			_prevctx = _localctx;

			setState(523);
			expr(0);
			}
			_ctx.stop = _input.LT(-1);
			setState(530);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,53,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					{
					_localctx = new CommaSimpleContext(new CommaExprContext(_parentctx, _parentState));
					pushNewRecursionContext(_localctx, _startState, RULE_commaExpr);
					setState(525);
					if (!(precpred(_ctx, 1))) throw new FailedPredicateException(this, "precpred(_ctx, 1)");
					setState(526);
					match(COMMA);
					setState(527);
					expr(0);
					}
					} 
				}
				setState(532);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,53,_ctx);
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
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public TypeNameContext typeName() {
			return getRuleContext(TypeNameContext.class,0);
		}
		public TerminalNode PAR_BEGIN() { return getToken(KickCParser.PAR_BEGIN, 0); }
		public TerminalNode PAR_END() { return getToken(KickCParser.PAR_END, 0); }
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
		public TypeNameContext typeName() {
			return getRuleContext(TypeNameContext.class,0);
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
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public TypeNameContext typeName() {
			return getRuleContext(TypeNameContext.class,0);
		}
		public TerminalNode PAR_BEGIN() { return getToken(KickCParser.PAR_BEGIN, 0); }
		public TerminalNode PAR_END() { return getToken(KickCParser.PAR_END, 0); }
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
		int _startState = 68;
		enterRecursionRule(_localctx, 68, RULE_expr, _p);
		int _la;
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(602);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,65,_ctx) ) {
			case 1:
				{
				_localctx = new ExprParContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;

				setState(534);
				match(PAR_BEGIN);
				setState(535);
				commaExpr(0);
				setState(536);
				match(PAR_END);
				}
				break;
			case 2:
				{
				_localctx = new ExprSizeOfContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(538);
				match(SIZEOF);
				setState(540);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,54,_ctx) ) {
				case 1:
					{
					setState(539);
					match(PAR_BEGIN);
					}
					break;
				}
				setState(544);
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
					setState(542);
					expr(0);
					}
					break;
				case TYPEDEFNAME:
				case STRUCT:
				case UNION:
				case ENUM:
				case SIMPLETYPE:
					{
					setState(543);
					typeName();
					}
					break;
				default:
					throw new NoViableAltException(this);
				}
				setState(547);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,56,_ctx) ) {
				case 1:
					{
					setState(546);
					match(PAR_END);
					}
					break;
				}
				}
				break;
			case 3:
				{
				_localctx = new ExprTypeIdContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(549);
				match(TYPEID);
				setState(551);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,57,_ctx) ) {
				case 1:
					{
					setState(550);
					match(PAR_BEGIN);
					}
					break;
				}
				setState(555);
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
					setState(553);
					expr(0);
					}
					break;
				case TYPEDEFNAME:
				case STRUCT:
				case UNION:
				case ENUM:
				case SIMPLETYPE:
					{
					setState(554);
					typeName();
					}
					break;
				default:
					throw new NoViableAltException(this);
				}
				setState(558);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,59,_ctx) ) {
				case 1:
					{
					setState(557);
					match(PAR_END);
					}
					break;
				}
				}
				break;
			case 4:
				{
				_localctx = new ExprDefinedContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(560);
				match(DEFINED);
				setState(562);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if (_la==PAR_BEGIN) {
					{
					setState(561);
					match(PAR_BEGIN);
					}
				}

				setState(564);
				match(NAME);
				setState(566);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,61,_ctx) ) {
				case 1:
					{
					setState(565);
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
				setState(568);
				match(PAR_BEGIN);
				setState(569);
				typeName();
				setState(570);
				match(PAR_END);
				setState(571);
				expr(23);
				}
				break;
			case 6:
				{
				_localctx = new ExprPreModContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(573);
				_la = _input.LA(1);
				if ( !(_la==INC || _la==DEC) ) {
				_errHandler.recoverInline(this);
				}
				else {
					if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
					_errHandler.reportMatch(this);
					consume();
				}
				setState(574);
				expr(22);
				}
				break;
			case 7:
				{
				_localctx = new ExprPtrContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(575);
				match(ASTERISK);
				setState(576);
				expr(20);
				}
				break;
			case 8:
				{
				_localctx = new ExprUnaryContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(577);
				_la = _input.LA(1);
				if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << PLUS) | (1L << MINUS) | (1L << AND) | (1L << BIT_NOT))) != 0) || _la==LOGIC_NOT) ) {
				_errHandler.recoverInline(this);
				}
				else {
					if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
					_errHandler.reportMatch(this);
					consume();
				}
				setState(578);
				expr(19);
				}
				break;
			case 9:
				{
				_localctx = new InitListContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(579);
				match(CURLY_BEGIN);
				setState(580);
				expr(0);
				setState(585);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,62,_ctx);
				while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
					if ( _alt==1 ) {
						{
						{
						setState(581);
						match(COMMA);
						setState(582);
						expr(0);
						}
						} 
					}
					setState(587);
					_errHandler.sync(this);
					_alt = getInterpreter().adaptivePredict(_input,62,_ctx);
				}
				setState(589);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if (_la==COMMA) {
					{
					setState(588);
					match(COMMA);
					}
				}

				setState(591);
				match(CURLY_END);
				}
				break;
			case 10:
				{
				_localctx = new ExprIdContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(593);
				match(NAME);
				}
				break;
			case 11:
				{
				_localctx = new ExprNumberContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(594);
				match(NUMBER);
				}
				break;
			case 12:
				{
				_localctx = new ExprStringContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(596); 
				_errHandler.sync(this);
				_alt = 1;
				do {
					switch (_alt) {
					case 1:
						{
						{
						setState(595);
						match(STRING);
						}
						}
						break;
					default:
						throw new NoViableAltException(this);
					}
					setState(598); 
					_errHandler.sync(this);
					_alt = getInterpreter().adaptivePredict(_input,64,_ctx);
				} while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER );
				}
				break;
			case 13:
				{
				_localctx = new ExprCharContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(600);
				match(CHAR);
				}
				break;
			case 14:
				{
				_localctx = new ExprBoolContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(601);
				match(BOOLEAN);
				}
				break;
			}
			_ctx.stop = _input.LT(-1);
			setState(664);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,68,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					setState(662);
					_errHandler.sync(this);
					switch ( getInterpreter().adaptivePredict(_input,67,_ctx) ) {
					case 1:
						{
						_localctx = new ExprBinaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(604);
						if (!(precpred(_ctx, 18))) throw new FailedPredicateException(this, "precpred(_ctx, 18)");
						setState(605);
						_la = _input.LA(1);
						if ( !(_la==SHIFT_LEFT || _la==SHIFT_RIGHT) ) {
						_errHandler.recoverInline(this);
						}
						else {
							if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
							_errHandler.reportMatch(this);
							consume();
						}
						setState(606);
						expr(19);
						}
						break;
					case 2:
						{
						_localctx = new ExprBinaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(607);
						if (!(precpred(_ctx, 17))) throw new FailedPredicateException(this, "precpred(_ctx, 17)");
						setState(608);
						_la = _input.LA(1);
						if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << ASTERISK) | (1L << DIVIDE) | (1L << MODULO))) != 0)) ) {
						_errHandler.recoverInline(this);
						}
						else {
							if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
							_errHandler.reportMatch(this);
							consume();
						}
						setState(609);
						expr(18);
						}
						break;
					case 3:
						{
						_localctx = new ExprBinaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(610);
						if (!(precpred(_ctx, 16))) throw new FailedPredicateException(this, "precpred(_ctx, 16)");
						setState(611);
						_la = _input.LA(1);
						if ( !(_la==PLUS || _la==MINUS) ) {
						_errHandler.recoverInline(this);
						}
						else {
							if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
							_errHandler.reportMatch(this);
							consume();
						}
						setState(612);
						expr(17);
						}
						break;
					case 4:
						{
						_localctx = new ExprBinaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(613);
						if (!(precpred(_ctx, 15))) throw new FailedPredicateException(this, "precpred(_ctx, 15)");
						setState(614);
						_la = _input.LA(1);
						if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << EQUAL) | (1L << NOT_EQUAL) | (1L << LESS_THAN) | (1L << LESS_THAN_EQUAL) | (1L << GREATER_THAN_EQUAL) | (1L << GREATER_THAN))) != 0)) ) {
						_errHandler.recoverInline(this);
						}
						else {
							if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
							_errHandler.reportMatch(this);
							consume();
						}
						setState(615);
						expr(16);
						}
						break;
					case 5:
						{
						_localctx = new ExprBinaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(616);
						if (!(precpred(_ctx, 14))) throw new FailedPredicateException(this, "precpred(_ctx, 14)");
						{
						setState(617);
						match(AND);
						}
						setState(618);
						expr(15);
						}
						break;
					case 6:
						{
						_localctx = new ExprBinaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(619);
						if (!(precpred(_ctx, 13))) throw new FailedPredicateException(this, "precpred(_ctx, 13)");
						{
						setState(620);
						match(BIT_XOR);
						}
						setState(621);
						expr(14);
						}
						break;
					case 7:
						{
						_localctx = new ExprBinaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(622);
						if (!(precpred(_ctx, 12))) throw new FailedPredicateException(this, "precpred(_ctx, 12)");
						{
						setState(623);
						match(BIT_OR);
						}
						setState(624);
						expr(13);
						}
						break;
					case 8:
						{
						_localctx = new ExprBinaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(625);
						if (!(precpred(_ctx, 11))) throw new FailedPredicateException(this, "precpred(_ctx, 11)");
						{
						setState(626);
						match(LOGIC_AND);
						}
						setState(627);
						expr(12);
						}
						break;
					case 9:
						{
						_localctx = new ExprBinaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(628);
						if (!(precpred(_ctx, 10))) throw new FailedPredicateException(this, "precpred(_ctx, 10)");
						{
						setState(629);
						match(LOGIC_OR);
						}
						setState(630);
						expr(11);
						}
						break;
					case 10:
						{
						_localctx = new ExprTernaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(631);
						if (!(precpred(_ctx, 9))) throw new FailedPredicateException(this, "precpred(_ctx, 9)");
						setState(632);
						match(CONDITION);
						setState(633);
						expr(0);
						setState(634);
						match(COLON);
						setState(635);
						expr(10);
						}
						break;
					case 11:
						{
						_localctx = new ExprAssignmentContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(637);
						if (!(precpred(_ctx, 8))) throw new FailedPredicateException(this, "precpred(_ctx, 8)");
						setState(638);
						match(ASSIGN);
						setState(639);
						expr(8);
						}
						break;
					case 12:
						{
						_localctx = new ExprAssignmentCompoundContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(640);
						if (!(precpred(_ctx, 7))) throw new FailedPredicateException(this, "precpred(_ctx, 7)");
						setState(641);
						match(ASSIGN_COMPOUND);
						setState(642);
						expr(7);
						}
						break;
					case 13:
						{
						_localctx = new ExprDotContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(643);
						if (!(precpred(_ctx, 30))) throw new FailedPredicateException(this, "precpred(_ctx, 30)");
						setState(644);
						match(DOT);
						setState(645);
						match(NAME);
						}
						break;
					case 14:
						{
						_localctx = new ExprArrowContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(646);
						if (!(precpred(_ctx, 29))) throw new FailedPredicateException(this, "precpred(_ctx, 29)");
						setState(647);
						match(ARROW);
						setState(648);
						match(NAME);
						}
						break;
					case 15:
						{
						_localctx = new ExprCallContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(649);
						if (!(precpred(_ctx, 28))) throw new FailedPredicateException(this, "precpred(_ctx, 28)");
						setState(650);
						match(PAR_BEGIN);
						setState(652);
						_errHandler.sync(this);
						_la = _input.LA(1);
						if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << CURLY_BEGIN) | (1L << PAR_BEGIN) | (1L << PLUS) | (1L << MINUS) | (1L << ASTERISK) | (1L << INC) | (1L << DEC) | (1L << AND) | (1L << BIT_NOT))) != 0) || ((((_la - 73)) & ~0x3f) == 0 && ((1L << (_la - 73)) & ((1L << (SIZEOF - 73)) | (1L << (TYPEID - 73)) | (1L << (DEFINED - 73)) | (1L << (LOGIC_NOT - 73)) | (1L << (BOOLEAN - 73)) | (1L << (NUMBER - 73)) | (1L << (NAME - 73)) | (1L << (STRING - 73)) | (1L << (CHAR - 73)))) != 0)) {
							{
							setState(651);
							parameterList();
							}
						}

						setState(654);
						match(PAR_END);
						}
						break;
					case 16:
						{
						_localctx = new ExprArrayContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(655);
						if (!(precpred(_ctx, 24))) throw new FailedPredicateException(this, "precpred(_ctx, 24)");
						setState(656);
						match(BRACKET_BEGIN);
						setState(657);
						commaExpr(0);
						setState(658);
						match(BRACKET_END);
						}
						break;
					case 17:
						{
						_localctx = new ExprPostModContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(660);
						if (!(precpred(_ctx, 21))) throw new FailedPredicateException(this, "precpred(_ctx, 21)");
						setState(661);
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
				setState(666);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,68,_ctx);
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
		enterRule(_localctx, 70, RULE_parameterList);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(667);
			expr(0);
			setState(672);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==COMMA) {
				{
				{
				setState(668);
				match(COMMA);
				setState(669);
				expr(0);
				}
				}
				setState(674);
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
		enterRule(_localctx, 72, RULE_kasmContent);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(675);
			match(KICKASM);
			setState(677);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==PAR_BEGIN) {
				{
				setState(676);
				asmDirectives();
				}
			}

			setState(679);
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
		enterRule(_localctx, 74, RULE_asmDirectives);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(681);
			match(PAR_BEGIN);
			setState(682);
			asmDirective();
			setState(687);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==COMMA) {
				{
				{
				setState(683);
				match(COMMA);
				setState(684);
				asmDirective();
				}
				}
				setState(689);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(690);
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
		enterRule(_localctx, 76, RULE_asmDirective);
		try {
			setState(702);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case RESOURCE:
				_localctx = new AsmDirectiveResourceContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(692);
				match(RESOURCE);
				setState(693);
				match(STRING);
				}
				break;
			case USES:
				_localctx = new AsmDirectiveUsesContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(694);
				match(USES);
				setState(695);
				match(NAME);
				}
				break;
			case CLOBBERS:
				_localctx = new AsmDirectiveClobberContext(_localctx);
				enterOuterAlt(_localctx, 3);
				{
				setState(696);
				match(CLOBBERS);
				setState(697);
				match(STRING);
				}
				break;
			case BYTES:
				_localctx = new AsmDirectiveBytesContext(_localctx);
				enterOuterAlt(_localctx, 4);
				{
				setState(698);
				match(BYTES);
				setState(699);
				expr(0);
				}
				break;
			case CYCLES:
				_localctx = new AsmDirectiveCyclesContext(_localctx);
				enterOuterAlt(_localctx, 5);
				{
				setState(700);
				match(CYCLES);
				setState(701);
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
		enterRule(_localctx, 78, RULE_asmLines);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(707);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (((((_la - 114)) & ~0x3f) == 0 && ((1L << (_la - 114)) & ((1L << (ASM_BYTE - 114)) | (1L << (ASM_MNEMONIC - 114)) | (1L << (ASM_MULTI_NAME - 114)) | (1L << (ASM_NAME - 114)))) != 0)) {
				{
				{
				setState(704);
				asmLine();
				}
				}
				setState(709);
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
		enterRule(_localctx, 80, RULE_asmLine);
		try {
			setState(713);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case ASM_MULTI_NAME:
			case ASM_NAME:
				enterOuterAlt(_localctx, 1);
				{
				setState(710);
				asmLabel();
				}
				break;
			case ASM_MNEMONIC:
				enterOuterAlt(_localctx, 2);
				{
				setState(711);
				asmInstruction();
				}
				break;
			case ASM_BYTE:
				enterOuterAlt(_localctx, 3);
				{
				setState(712);
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
		enterRule(_localctx, 82, RULE_asmLabel);
		int _la;
		try {
			setState(731);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case ASM_NAME:
				_localctx = new AsmLabelNameContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(715);
				match(ASM_NAME);
				setState(716);
				match(ASM_COLON);
				setState(720);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (_la==ASM_TAG) {
					{
					{
					setState(717);
					match(ASM_TAG);
					}
					}
					setState(722);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				}
				break;
			case ASM_MULTI_NAME:
				_localctx = new AsmLabelMultiContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(723);
				match(ASM_MULTI_NAME);
				setState(724);
				match(ASM_COLON);
				setState(728);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (_la==ASM_TAG) {
					{
					{
					setState(725);
					match(ASM_TAG);
					}
					}
					setState(730);
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
		enterRule(_localctx, 84, RULE_asmInstruction);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(733);
			match(ASM_MNEMONIC);
			setState(735);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,78,_ctx) ) {
			case 1:
				{
				setState(734);
				asmParamMode();
				}
				break;
			}
			setState(740);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==ASM_TAG) {
				{
				{
				setState(737);
				match(ASM_TAG);
				}
				}
				setState(742);
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
		enterRule(_localctx, 86, RULE_asmBytes);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(743);
			match(ASM_BYTE);
			setState(744);
			asmExpr(0);
			setState(749);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==ASM_COMMA) {
				{
				{
				setState(745);
				match(ASM_COMMA);
				setState(746);
				asmExpr(0);
				}
				}
				setState(751);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(755);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==ASM_TAG) {
				{
				{
				setState(752);
				match(ASM_TAG);
				}
				}
				setState(757);
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
		enterRule(_localctx, 88, RULE_asmParamMode);
		try {
			setState(803);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,82,_ctx) ) {
			case 1:
				_localctx = new AsmModeAbsContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(758);
				asmExpr(0);
				}
				break;
			case 2:
				_localctx = new AsmModeImmContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(759);
				match(ASM_IMM);
				setState(760);
				asmExpr(0);
				}
				break;
			case 3:
				_localctx = new AsmModeAbsXYContext(_localctx);
				enterOuterAlt(_localctx, 3);
				{
				setState(761);
				asmExpr(0);
				setState(762);
				match(ASM_COMMA);
				setState(763);
				asmExpr(0);
				}
				break;
			case 4:
				_localctx = new AsmModeIndIdxXYContext(_localctx);
				enterOuterAlt(_localctx, 4);
				{
				setState(765);
				match(ASM_PAR_BEGIN);
				setState(766);
				asmExpr(0);
				setState(767);
				match(ASM_PAR_END);
				setState(768);
				match(ASM_COMMA);
				setState(769);
				match(ASM_NAME);
				}
				break;
			case 5:
				_localctx = new AsmModeIndLongIdxXYContext(_localctx);
				enterOuterAlt(_localctx, 5);
				{
				setState(771);
				match(ASM_PAR_BEGIN);
				setState(772);
				match(ASM_PAR_BEGIN);
				setState(773);
				asmExpr(0);
				setState(774);
				match(ASM_PAR_END);
				setState(775);
				match(ASM_PAR_END);
				setState(776);
				match(ASM_COMMA);
				setState(777);
				match(ASM_NAME);
				}
				break;
			case 6:
				_localctx = new AsmModeSPIndIdxContext(_localctx);
				enterOuterAlt(_localctx, 6);
				{
				setState(779);
				match(ASM_PAR_BEGIN);
				setState(780);
				asmExpr(0);
				setState(781);
				match(ASM_COMMA);
				setState(782);
				match(ASM_NAME);
				setState(783);
				match(ASM_PAR_END);
				setState(784);
				match(ASM_COMMA);
				setState(785);
				match(ASM_NAME);
				}
				break;
			case 7:
				_localctx = new AsmModeIdxIndXYContext(_localctx);
				enterOuterAlt(_localctx, 7);
				{
				setState(787);
				match(ASM_PAR_BEGIN);
				setState(788);
				asmExpr(0);
				setState(789);
				match(ASM_COMMA);
				setState(790);
				match(ASM_NAME);
				setState(791);
				match(ASM_PAR_END);
				}
				break;
			case 8:
				_localctx = new AsmModeIndContext(_localctx);
				enterOuterAlt(_localctx, 8);
				{
				setState(793);
				match(ASM_PAR_BEGIN);
				setState(794);
				asmExpr(0);
				setState(795);
				match(ASM_PAR_END);
				}
				break;
			case 9:
				_localctx = new AsmModeIndLongContext(_localctx);
				enterOuterAlt(_localctx, 9);
				{
				setState(797);
				match(ASM_PAR_BEGIN);
				setState(798);
				match(ASM_PAR_BEGIN);
				setState(799);
				asmExpr(0);
				setState(800);
				match(ASM_PAR_END);
				setState(801);
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
		int _startState = 90;
		enterRecursionRule(_localctx, 90, RULE_asmExpr, _p);
		int _la;
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(819);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case ASM_BRACKET_BEGIN:
				{
				_localctx = new AsmExprParContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;

				setState(806);
				match(ASM_BRACKET_BEGIN);
				setState(807);
				asmExpr(0);
				setState(808);
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
				setState(810);
				_la = _input.LA(1);
				if ( !(((((_la - 126)) & ~0x3f) == 0 && ((1L << (_la - 126)) & ((1L << (ASM_PLUS - 126)) | (1L << (ASM_MINUS - 126)) | (1L << (ASM_LESS_THAN - 126)) | (1L << (ASM_GREATER_THAN - 126)))) != 0)) ) {
				_errHandler.recoverInline(this);
				}
				else {
					if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
					_errHandler.reportMatch(this);
					consume();
				}
				setState(811);
				asmExpr(8);
				}
				break;
			case ASM_NAME:
				{
				_localctx = new AsmExprLabelContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(812);
				match(ASM_NAME);
				}
				break;
			case ASM_MULTI_REL:
				{
				_localctx = new AsmExprLabelRelContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(813);
				match(ASM_MULTI_REL);
				}
				break;
			case ASM_CURLY_BEGIN:
				{
				_localctx = new AsmExprReplaceContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(814);
				match(ASM_CURLY_BEGIN);
				setState(815);
				match(ASM_NAME);
				setState(816);
				match(ASM_CURLY_END);
				}
				break;
			case ASM_NUMBER:
				{
				_localctx = new AsmExprIntContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(817);
				match(ASM_NUMBER);
				}
				break;
			case ASM_CHAR:
				{
				_localctx = new AsmExprCharContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(818);
				match(ASM_CHAR);
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
			_ctx.stop = _input.LT(-1);
			setState(835);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,85,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					setState(833);
					_errHandler.sync(this);
					switch ( getInterpreter().adaptivePredict(_input,84,_ctx) ) {
					case 1:
						{
						_localctx = new AsmExprBinaryContext(new AsmExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_asmExpr);
						setState(821);
						if (!(precpred(_ctx, 10))) throw new FailedPredicateException(this, "precpred(_ctx, 10)");
						{
						setState(822);
						match(ASM_DOT);
						}
						setState(823);
						asmExpr(11);
						}
						break;
					case 2:
						{
						_localctx = new AsmExprBinaryContext(new AsmExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_asmExpr);
						setState(824);
						if (!(precpred(_ctx, 9))) throw new FailedPredicateException(this, "precpred(_ctx, 9)");
						setState(825);
						_la = _input.LA(1);
						if ( !(_la==ASM_SHIFT_LEFT || _la==ASM_SHIFT_RIGHT) ) {
						_errHandler.recoverInline(this);
						}
						else {
							if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
							_errHandler.reportMatch(this);
							consume();
						}
						setState(826);
						asmExpr(10);
						}
						break;
					case 3:
						{
						_localctx = new AsmExprBinaryContext(new AsmExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_asmExpr);
						setState(827);
						if (!(precpred(_ctx, 7))) throw new FailedPredicateException(this, "precpred(_ctx, 7)");
						setState(828);
						_la = _input.LA(1);
						if ( !(_la==ASM_MULTIPLY || _la==ASM_DIVIDE) ) {
						_errHandler.recoverInline(this);
						}
						else {
							if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
							_errHandler.reportMatch(this);
							consume();
						}
						setState(829);
						asmExpr(8);
						}
						break;
					case 4:
						{
						_localctx = new AsmExprBinaryContext(new AsmExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_asmExpr);
						setState(830);
						if (!(precpred(_ctx, 6))) throw new FailedPredicateException(this, "precpred(_ctx, 6)");
						setState(831);
						_la = _input.LA(1);
						if ( !(_la==ASM_PLUS || _la==ASM_MINUS) ) {
						_errHandler.recoverInline(this);
						}
						else {
							if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
							_errHandler.reportMatch(this);
							consume();
						}
						setState(832);
						asmExpr(7);
						}
						break;
					}
					} 
				}
				setState(837);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,85,_ctx);
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
		case 10:
			return typeNameDeclarator_sempred((TypeNameDeclaratorContext)_localctx, predIndex);
		case 11:
			return declarator_sempred((DeclaratorContext)_localctx, predIndex);
		case 18:
			return enumMemberList_sempred((EnumMemberListContext)_localctx, predIndex);
		case 33:
			return commaExpr_sempred((CommaExprContext)_localctx, predIndex);
		case 34:
			return expr_sempred((ExprContext)_localctx, predIndex);
		case 45:
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
	private boolean typeNameDeclarator_sempred(TypeNameDeclaratorContext _localctx, int predIndex) {
		switch (predIndex) {
		case 1:
			return precpred(_ctx, 4);
		case 2:
			return precpred(_ctx, 3);
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
			return precpred(_ctx, 18);
		case 8:
			return precpred(_ctx, 17);
		case 9:
			return precpred(_ctx, 16);
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
			return precpred(_ctx, 30);
		case 20:
			return precpred(_ctx, 29);
		case 21:
			return precpred(_ctx, 28);
		case 22:
			return precpred(_ctx, 24);
		case 23:
			return precpred(_ctx, 21);
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
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\3\u009d\u0349\4\2\t"+
		"\2\4\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n\t\n\4\13"+
		"\t\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\4\20\t\20\4\21\t\21\4\22\t\22"+
		"\4\23\t\23\4\24\t\24\4\25\t\25\4\26\t\26\4\27\t\27\4\30\t\30\4\31\t\31"+
		"\4\32\t\32\4\33\t\33\4\34\t\34\4\35\t\35\4\36\t\36\4\37\t\37\4 \t \4!"+
		"\t!\4\"\t\"\4#\t#\4$\t$\4%\t%\4&\t&\4\'\t\'\4(\t(\4)\t)\4*\t*\4+\t+\4"+
		",\t,\4-\t-\4.\t.\4/\t/\3\2\3\2\3\2\3\3\3\3\3\3\3\4\7\4f\n\4\f\4\16\4i"+
		"\13\4\3\5\3\5\3\5\3\5\3\5\3\5\3\5\3\5\3\5\3\5\3\5\3\5\3\5\3\5\5\5y\n\5"+
		"\3\6\3\6\3\6\3\7\3\7\3\7\3\7\3\7\3\7\7\7\u0084\n\7\f\7\16\7\u0087\13\7"+
		"\3\b\3\b\3\b\5\b\u008c\n\b\3\b\3\b\3\b\3\b\5\b\u0092\n\b\3\t\3\t\3\t\3"+
		"\t\3\t\3\n\7\n\u009a\n\n\f\n\16\n\u009d\13\n\3\n\3\n\7\n\u00a1\n\n\f\n"+
		"\16\n\u00a4\13\n\3\13\3\13\3\13\3\f\3\f\3\f\7\f\u00ac\n\f\f\f\16\f\u00af"+
		"\13\f\3\f\3\f\3\f\3\f\3\f\5\f\u00b6\n\f\3\f\3\f\3\f\5\f\u00bb\n\f\3\f"+
		"\3\f\3\f\3\f\5\f\u00c1\n\f\3\f\7\f\u00c4\n\f\f\f\16\f\u00c7\13\f\3\r\3"+
		"\r\3\r\3\r\3\r\7\r\u00ce\n\r\f\r\16\r\u00d1\13\r\3\r\3\r\3\r\3\r\3\r\5"+
		"\r\u00d8\n\r\3\r\3\r\3\r\5\r\u00dd\n\r\3\r\3\r\3\r\3\r\5\r\u00e3\n\r\3"+
		"\r\7\r\u00e6\n\r\f\r\16\r\u00e9\13\r\3\16\6\16\u00ec\n\16\r\16\16\16\u00ed"+
		"\3\16\3\16\3\16\3\16\3\16\5\16\u00f5\n\16\3\17\3\17\3\17\3\20\3\20\5\20"+
		"\u00fc\n\20\3\20\3\20\6\20\u0100\n\20\r\20\16\20\u0101\3\20\3\20\3\21"+
		"\3\21\3\21\3\22\3\22\3\22\3\23\3\23\5\23\u010e\n\23\3\23\3\23\3\23\3\23"+
		"\3\24\3\24\3\24\3\24\3\24\3\24\7\24\u011a\n\24\f\24\16\24\u011d\13\24"+
		"\3\25\3\25\3\25\5\25\u0122\n\25\3\26\3\26\3\26\3\26\5\26\u0128\n\26\3"+
		"\26\3\26\3\27\3\27\3\27\7\27\u012f\n\27\f\27\16\27\u0132\13\27\3\30\3"+
		"\30\3\30\3\30\3\30\5\30\u0139\n\30\3\31\3\31\3\31\3\31\3\31\3\31\7\31"+
		"\u0141\n\31\f\31\16\31\u0144\13\31\3\31\3\31\3\32\3\32\3\32\3\32\3\32"+
		"\3\32\3\32\5\32\u014f\n\32\3\33\3\33\3\33\3\33\3\33\3\33\3\33\3\33\3\33"+
		"\5\33\u015a\n\33\3\33\3\33\3\33\3\33\3\33\3\33\3\33\3\33\3\33\3\33\3\33"+
		"\3\33\3\33\3\33\3\33\3\33\3\33\3\33\3\33\5\33\u016f\n\33\3\33\3\33\3\33"+
		"\3\33\3\33\7\33\u0176\n\33\f\33\16\33\u0179\13\33\3\33\3\33\3\33\5\33"+
		"\u017e\n\33\3\34\6\34\u0181\n\34\r\34\16\34\u0182\3\35\3\35\3\35\3\35"+
		"\3\35\5\35\u018a\n\35\3\35\3\35\3\35\3\35\3\35\3\35\3\35\3\35\3\35\3\35"+
		"\3\35\5\35\u0197\n\35\3\35\7\35\u019a\n\35\f\35\16\35\u019d\13\35\3\35"+
		"\3\35\3\35\3\35\3\35\3\35\3\35\7\35\u01a6\n\35\f\35\16\35\u01a9\13\35"+
		"\3\35\3\35\3\35\3\35\3\35\3\35\3\35\3\35\3\35\7\35\u01b4\n\35\f\35\16"+
		"\35\u01b7\13\35\3\35\3\35\3\35\3\35\3\35\3\35\3\35\3\35\3\35\3\35\3\35"+
		"\3\35\3\35\3\35\3\35\3\35\5\35\u01c9\n\35\3\35\3\35\3\35\3\35\3\35\3\35"+
		"\3\35\5\35\u01d2\n\35\3\35\3\35\3\35\3\35\3\35\3\35\3\35\3\35\3\35\3\35"+
		"\3\35\5\35\u01df\n\35\3\36\6\36\u01e2\n\36\r\36\16\36\u01e3\3\36\3\36"+
		"\3\36\5\36\u01e9\n\36\5\36\u01eb\n\36\3\37\3\37\3\37\3\37\5\37\u01f1\n"+
		"\37\3 \3 \3 \5 \u01f6\n \3 \3 \5 \u01fa\n \3 \3 \3 \3 \3 \3 \3 \5 \u0203"+
		"\n \3!\5!\u0206\n!\3!\5!\u0209\n!\3\"\3\"\3#\3#\3#\3#\3#\3#\7#\u0213\n"+
		"#\f#\16#\u0216\13#\3$\3$\3$\3$\3$\3$\3$\5$\u021f\n$\3$\3$\5$\u0223\n$"+
		"\3$\5$\u0226\n$\3$\3$\5$\u022a\n$\3$\3$\5$\u022e\n$\3$\5$\u0231\n$\3$"+
		"\3$\5$\u0235\n$\3$\3$\5$\u0239\n$\3$\3$\3$\3$\3$\3$\3$\3$\3$\3$\3$\3$"+
		"\3$\3$\3$\7$\u024a\n$\f$\16$\u024d\13$\3$\5$\u0250\n$\3$\3$\3$\3$\3$\6"+
		"$\u0257\n$\r$\16$\u0258\3$\3$\5$\u025d\n$\3$\3$\3$\3$\3$\3$\3$\3$\3$\3"+
		"$\3$\3$\3$\3$\3$\3$\3$\3$\3$\3$\3$\3$\3$\3$\3$\3$\3$\3$\3$\3$\3$\3$\3"+
		"$\3$\3$\3$\3$\3$\3$\3$\3$\3$\3$\3$\3$\3$\3$\3$\5$\u028f\n$\3$\3$\3$\3"+
		"$\3$\3$\3$\3$\7$\u0299\n$\f$\16$\u029c\13$\3%\3%\3%\7%\u02a1\n%\f%\16"+
		"%\u02a4\13%\3&\3&\5&\u02a8\n&\3&\3&\3\'\3\'\3\'\3\'\7\'\u02b0\n\'\f\'"+
		"\16\'\u02b3\13\'\3\'\3\'\3(\3(\3(\3(\3(\3(\3(\3(\3(\3(\5(\u02c1\n(\3)"+
		"\7)\u02c4\n)\f)\16)\u02c7\13)\3*\3*\3*\5*\u02cc\n*\3+\3+\3+\7+\u02d1\n"+
		"+\f+\16+\u02d4\13+\3+\3+\3+\7+\u02d9\n+\f+\16+\u02dc\13+\5+\u02de\n+\3"+
		",\3,\5,\u02e2\n,\3,\7,\u02e5\n,\f,\16,\u02e8\13,\3-\3-\3-\3-\7-\u02ee"+
		"\n-\f-\16-\u02f1\13-\3-\7-\u02f4\n-\f-\16-\u02f7\13-\3.\3.\3.\3.\3.\3"+
		".\3.\3.\3.\3.\3.\3.\3.\3.\3.\3.\3.\3.\3.\3.\3.\3.\3.\3.\3.\3.\3.\3.\3"+
		".\3.\3.\3.\3.\3.\3.\3.\3.\3.\3.\3.\3.\3.\3.\3.\3.\5.\u0326\n.\3/\3/\3"+
		"/\3/\3/\3/\3/\3/\3/\3/\3/\3/\3/\3/\5/\u0336\n/\3/\3/\3/\3/\3/\3/\3/\3"+
		"/\3/\3/\3/\3/\7/\u0344\n/\f/\16/\u0347\13/\3/\2\t\f\26\30&DF\\\60\2\4"+
		"\6\b\n\f\16\20\22\24\26\30\32\34\36 \"$&(*,.\60\62\64\668:<>@BDFHJLNP"+
		"RTVXZ\\\2\r\3\2HI\3\2\27\30\5\2\22\23\31\32TT\3\2\35\36\3\2\24\26\3\2"+
		"\22\23\3\2\37$\3\2\u0080\u0083\3\2~\177\3\2\u0084\u0085\3\2\u0080\u0081"+
		"\2\u03c8\2^\3\2\2\2\4a\3\2\2\2\6g\3\2\2\2\bx\3\2\2\2\nz\3\2\2\2\f}\3\2"+
		"\2\2\16\u0091\3\2\2\2\20\u0093\3\2\2\2\22\u009b\3\2\2\2\24\u00a5\3\2\2"+
		"\2\26\u00b5\3\2\2\2\30\u00d7\3\2\2\2\32\u00f4\3\2\2\2\34\u00f6\3\2\2\2"+
		"\36\u00f9\3\2\2\2 \u0105\3\2\2\2\"\u0108\3\2\2\2$\u010b\3\2\2\2&\u0113"+
		"\3\2\2\2(\u011e\3\2\2\2*\u0123\3\2\2\2,\u012b\3\2\2\2.\u0138\3\2\2\2\60"+
		"\u013a\3\2\2\2\62\u014e\3\2\2\2\64\u017d\3\2\2\2\66\u0180\3\2\2\28\u01de"+
		"\3\2\2\2:\u01e1\3\2\2\2<\u01ec\3\2\2\2>\u0202\3\2\2\2@\u0208\3\2\2\2B"+
		"\u020a\3\2\2\2D\u020c\3\2\2\2F\u025c\3\2\2\2H\u029d\3\2\2\2J\u02a5\3\2"+
		"\2\2L\u02ab\3\2\2\2N\u02c0\3\2\2\2P\u02c5\3\2\2\2R\u02cb\3\2\2\2T\u02dd"+
		"\3\2\2\2V\u02df\3\2\2\2X\u02e9\3\2\2\2Z\u0325\3\2\2\2\\\u0335\3\2\2\2"+
		"^_\5\6\4\2_`\7\2\2\3`\3\3\2\2\2ab\5P)\2bc\7\2\2\3c\5\3\2\2\2df\5\b\5\2"+
		"ed\3\2\2\2fi\3\2\2\2ge\3\2\2\2gh\3\2\2\2h\7\3\2\2\2ig\3\2\2\2jk\5\n\6"+
		"\2kl\7\n\2\2ly\3\2\2\2my\5*\26\2no\5\36\20\2op\7\n\2\2py\3\2\2\2qr\5$"+
		"\23\2rs\7\n\2\2sy\3\2\2\2ty\5\60\31\2uv\5\20\t\2vw\7\n\2\2wy\3\2\2\2x"+
		"j\3\2\2\2xm\3\2\2\2xn\3\2\2\2xq\3\2\2\2xt\3\2\2\2xu\3\2\2\2y\t\3\2\2\2"+
		"z{\5\22\n\2{|\5\f\7\2|\13\3\2\2\2}~\b\7\1\2~\177\5\16\b\2\177\u0085\3"+
		"\2\2\2\u0080\u0081\f\3\2\2\u0081\u0082\7\f\2\2\u0082\u0084\5\16\b\2\u0083"+
		"\u0080\3\2\2\2\u0084\u0087\3\2\2\2\u0085\u0083\3\2\2\2\u0085\u0086\3\2"+
		"\2\2\u0086\r\3\2\2\2\u0087\u0085\3\2\2\2\u0088\u008b\5\30\r\2\u0089\u008a"+
		"\7\'\2\2\u008a\u008c\5F$\2\u008b\u0089\3\2\2\2\u008b\u008c\3\2\2\2\u008c"+
		"\u0092\3\2\2\2\u008d\u008e\5\30\r\2\u008e\u008f\7\'\2\2\u008f\u0090\5"+
		"J&\2\u0090\u0092\3\2\2\2\u0091\u0088\3\2\2\2\u0091\u008d\3\2\2\2\u0092"+
		"\17\3\2\2\2\u0093\u0094\7)\2\2\u0094\u0095\5\22\n\2\u0095\u0096\b\t\1"+
		"\2\u0096\u0097\5\30\r\2\u0097\21\3\2\2\2\u0098\u009a\5\64\33\2\u0099\u0098"+
		"\3\2\2\2\u009a\u009d\3\2\2\2\u009b\u0099\3\2\2\2\u009b\u009c\3\2\2\2\u009c"+
		"\u009e\3\2\2\2\u009d\u009b\3\2\2\2\u009e\u00a2\5\32\16\2\u009f\u00a1\5"+
		"\64\33\2\u00a0\u009f\3\2\2\2\u00a1\u00a4\3\2\2\2\u00a2\u00a0\3\2\2\2\u00a2"+
		"\u00a3\3\2\2\2\u00a3\23\3\2\2\2\u00a4\u00a2\3\2\2\2\u00a5\u00a6\5\32\16"+
		"\2\u00a6\u00a7\5\26\f\2\u00a7\25\3\2\2\2\u00a8\u00b6\b\f\1\2\u00a9\u00ad"+
		"\7\24\2\2\u00aa\u00ac\5\64\33\2\u00ab\u00aa\3\2\2\2\u00ac\u00af\3\2\2"+
		"\2\u00ad\u00ab\3\2\2\2\u00ad\u00ae\3\2\2\2\u00ae\u00b0\3\2\2\2\u00af\u00ad"+
		"\3\2\2\2\u00b0\u00b6\5\26\f\4\u00b1\u00b2\7\b\2\2\u00b2\u00b3\5\26\f\2"+
		"\u00b3\u00b4\7\t\2\2\u00b4\u00b6\3\2\2\2\u00b5\u00a8\3\2\2\2\u00b5\u00a9"+
		"\3\2\2\2\u00b5\u00b1\3\2\2\2\u00b6\u00c5\3\2\2\2\u00b7\u00b8\f\6\2\2\u00b8"+
		"\u00ba\7\b\2\2\u00b9\u00bb\5,\27\2\u00ba\u00b9\3\2\2\2\u00ba\u00bb\3\2"+
		"\2\2\u00bb\u00bc\3\2\2\2\u00bc\u00c4\7\t\2\2\u00bd\u00be\f\5\2\2\u00be"+
		"\u00c0\7\6\2\2\u00bf\u00c1\5F$\2\u00c0\u00bf\3\2\2\2\u00c0\u00c1\3\2\2"+
		"\2\u00c1\u00c2\3\2\2\2\u00c2\u00c4\7\7\2\2\u00c3\u00b7\3\2\2\2\u00c3\u00bd"+
		"\3\2\2\2\u00c4\u00c7\3\2\2\2\u00c5\u00c3\3\2\2\2\u00c5\u00c6\3\2\2\2\u00c6"+
		"\27\3\2\2\2\u00c7\u00c5\3\2\2\2\u00c8\u00c9\b\r\1\2\u00c9\u00ca\7n\2\2"+
		"\u00ca\u00d8\b\r\1\2\u00cb\u00cf\7\24\2\2\u00cc\u00ce\5\64\33\2\u00cd"+
		"\u00cc\3\2\2\2\u00ce\u00d1\3\2\2\2\u00cf\u00cd\3\2\2\2\u00cf\u00d0\3\2"+
		"\2\2\u00d0\u00d2\3\2\2\2\u00d1\u00cf\3\2\2\2\u00d2\u00d8\5\30\r\4\u00d3"+
		"\u00d4\7\b\2\2\u00d4\u00d5\5\30\r\2\u00d5\u00d6\7\t\2\2\u00d6\u00d8\3"+
		"\2\2\2\u00d7\u00c8\3\2\2\2\u00d7\u00cb\3\2\2\2\u00d7\u00d3\3\2\2\2\u00d8"+
		"\u00e7\3\2\2\2\u00d9\u00da\f\6\2\2\u00da\u00dc\7\b\2\2\u00db\u00dd\5,"+
		"\27\2\u00dc\u00db\3\2\2\2\u00dc\u00dd\3\2\2\2\u00dd\u00de\3\2\2\2\u00de"+
		"\u00e6\7\t\2\2\u00df\u00e0\f\5\2\2\u00e0\u00e2\7\6\2\2\u00e1\u00e3\5F"+
		"$\2\u00e2\u00e1\3\2\2\2\u00e2\u00e3\3\2\2\2\u00e3\u00e4\3\2\2\2\u00e4"+
		"\u00e6\7\7\2\2\u00e5\u00d9\3\2\2\2\u00e5\u00df\3\2\2\2\u00e6\u00e9\3\2"+
		"\2\2\u00e7\u00e5\3\2\2\2\u00e7\u00e8\3\2\2\2\u00e8\31\3\2\2\2\u00e9\u00e7"+
		"\3\2\2\2\u00ea\u00ec\7U\2\2\u00eb\u00ea\3\2\2\2\u00ec\u00ed\3\2\2\2\u00ed"+
		"\u00eb\3\2\2\2\u00ed\u00ee\3\2\2\2\u00ee\u00f5\3\2\2\2\u00ef\u00f5\5\36"+
		"\20\2\u00f0\u00f5\5\34\17\2\u00f1\u00f5\5$\23\2\u00f2\u00f5\5\"\22\2\u00f3"+
		"\u00f5\7\3\2\2\u00f4\u00eb\3\2\2\2\u00f4\u00ef\3\2\2\2\u00f4\u00f0\3\2"+
		"\2\2\u00f4\u00f1\3\2\2\2\u00f4\u00f2\3\2\2\2\u00f4\u00f3\3\2\2\2\u00f5"+
		"\33\3\2\2\2\u00f6\u00f7\t\2\2\2\u00f7\u00f8\7n\2\2\u00f8\35\3\2\2\2\u00f9"+
		"\u00fb\t\2\2\2\u00fa\u00fc\7n\2\2\u00fb\u00fa\3\2\2\2\u00fb\u00fc\3\2"+
		"\2\2\u00fc\u00fd\3\2\2\2\u00fd\u00ff\7\4\2\2\u00fe\u0100\5 \21\2\u00ff"+
		"\u00fe\3\2\2\2\u0100\u0101\3\2\2\2\u0101\u00ff\3\2\2\2\u0101\u0102\3\2"+
		"\2\2\u0102\u0103\3\2\2\2\u0103\u0104\7\5\2\2\u0104\37\3\2\2\2\u0105\u0106"+
		"\5\n\6\2\u0106\u0107\7\n\2\2\u0107!\3\2\2\2\u0108\u0109\7J\2\2\u0109\u010a"+
		"\7n\2\2\u010a#\3\2\2\2\u010b\u010d\7J\2\2\u010c\u010e\7n\2\2\u010d\u010c"+
		"\3\2\2\2\u010d\u010e\3\2\2\2\u010e\u010f\3\2\2\2\u010f\u0110\7\4\2\2\u0110"+
		"\u0111\5&\24\2\u0111\u0112\7\5\2\2\u0112%\3\2\2\2\u0113\u0114\b\24\1\2"+
		"\u0114\u0115\5(\25\2\u0115\u011b\3\2\2\2\u0116\u0117\f\3\2\2\u0117\u0118"+
		"\7\f\2\2\u0118\u011a\5(\25\2\u0119\u0116\3\2\2\2\u011a\u011d\3\2\2\2\u011b"+
		"\u0119\3\2\2\2\u011b\u011c\3\2\2\2\u011c\'\3\2\2\2\u011d\u011b\3\2\2\2"+
		"\u011e\u0121\7n\2\2\u011f\u0120\7\'\2\2\u0120\u0122\5F$\2\u0121\u011f"+
		"\3\2\2\2\u0121\u0122\3\2\2\2\u0122)\3\2\2\2\u0123\u0124\5\22\n\2\u0124"+
		"\u0125\5\30\r\2\u0125\u0127\7\4\2\2\u0126\u0128\5\66\34\2\u0127\u0126"+
		"\3\2\2\2\u0127\u0128\3\2\2\2\u0128\u0129\3\2\2\2\u0129\u012a\7\5\2\2\u012a"+
		"+\3\2\2\2\u012b\u0130\5.\30\2\u012c\u012d\7\f\2\2\u012d\u012f\5.\30\2"+
		"\u012e\u012c\3\2\2\2\u012f\u0132\3\2\2\2\u0130\u012e\3\2\2\2\u0130\u0131"+
		"\3\2\2\2\u0131-\3\2\2\2\u0132\u0130\3\2\2\2\u0133\u0134\5\22\n\2\u0134"+
		"\u0135\5\30\r\2\u0135\u0139\3\2\2\2\u0136\u0139\5\24\13\2\u0137\u0139"+
		"\7\16\2\2\u0138\u0133\3\2\2\2\u0138\u0136\3\2\2\2\u0138\u0137\3\2\2\2"+
		"\u0139/\3\2\2\2\u013a\u013b\7Z\2\2\u013b\u013c\7n\2\2\u013c\u013d\7\b"+
		"\2\2\u013d\u0142\5\62\32\2\u013e\u013f\7\f\2\2\u013f\u0141\5\62\32\2\u0140"+
		"\u013e\3\2\2\2\u0141\u0144\3\2\2\2\u0142\u0140\3\2\2\2\u0142\u0143\3\2"+
		"\2\2\u0143\u0145\3\2\2\2\u0144\u0142\3\2\2\2\u0145\u0146\7\t\2\2\u0146"+
		"\61\3\2\2\2\u0147\u014f\7e\2\2\u0148\u0149\7e\2\2\u0149\u014a\7\r\2\2"+
		"\u014a\u014f\7e\2\2\u014b\u014f\7n\2\2\u014c\u014f\7o\2\2\u014d\u014f"+
		"\7:\2\2\u014e\u0147\3\2\2\2\u014e\u0148\3\2\2\2\u014e\u014b\3\2\2\2\u014e"+
		"\u014c\3\2\2\2\u014e\u014d\3\2\2\2\u014f\63\3\2\2\2\u0150\u017e\7*\2\2"+
		"\u0151\u0152\7-\2\2\u0152\u0153\7\b\2\2\u0153\u0154\7e\2\2\u0154\u017e"+
		"\7\t\2\2\u0155\u0159\7\62\2\2\u0156\u0157\7\b\2\2\u0157\u0158\7n\2\2\u0158"+
		"\u015a\7\t\2\2\u0159\u0156\3\2\2\2\u0159\u015a\3\2\2\2\u015a\u017e\3\2"+
		"\2\2\u015b\u017e\7\65\2\2\u015c\u017e\7\66\2\2\u015d\u015e\7\64\2\2\u015e"+
		"\u015f\7\b\2\2\u015f\u0160\5F$\2\u0160\u0161\7\t\2\2\u0161\u017e\3\2\2"+
		"\2\u0162\u017e\7/\2\2\u0163\u017e\7\60\2\2\u0164\u017e\7\67\2\2\u0165"+
		"\u017e\78\2\2\u0166\u017e\7+\2\2\u0167\u017e\7,\2\2\u0168\u017e\7.\2\2"+
		"\u0169\u017e\79\2\2\u016a\u016e\7\61\2\2\u016b\u016c\7\b\2\2\u016c\u016d"+
		"\7n\2\2\u016d\u016f\7\t\2\2\u016e\u016b\3\2\2\2\u016e\u016f\3\2\2\2\u016f"+
		"\u017e\3\2\2\2\u0170\u0171\7\63\2\2\u0171\u0172\7\b\2\2\u0172\u0177\5"+
		"\62\32\2\u0173\u0174\7\f\2\2\u0174\u0176\5\62\32\2\u0175\u0173\3\2\2\2"+
		"\u0176\u0179\3\2\2\2\u0177\u0175\3\2\2\2\u0177\u0178\3\2\2\2\u0178\u017a"+
		"\3\2\2\2\u0179\u0177\3\2\2\2\u017a\u017b\7\t\2\2\u017b\u017e\3\2\2\2\u017c"+
		"\u017e\7:\2\2\u017d\u0150\3\2\2\2\u017d\u0151\3\2\2\2\u017d\u0155\3\2"+
		"\2\2\u017d\u015b\3\2\2\2\u017d\u015c\3\2\2\2\u017d\u015d\3\2\2\2\u017d"+
		"\u0162\3\2\2\2\u017d\u0163\3\2\2\2\u017d\u0164\3\2\2\2\u017d\u0165\3\2"+
		"\2\2\u017d\u0166\3\2\2\2\u017d\u0167\3\2\2\2\u017d\u0168\3\2\2\2\u017d"+
		"\u0169\3\2\2\2\u017d\u016a\3\2\2\2\u017d\u0170\3\2\2\2\u017d\u017c\3\2"+
		"\2\2\u017e\65\3\2\2\2\u017f\u0181\58\35\2\u0180\u017f\3\2\2\2\u0181\u0182"+
		"\3\2\2\2\u0182\u0180\3\2\2\2\u0182\u0183\3\2\2\2\u0183\67\3\2\2\2\u0184"+
		"\u0185\5\n\6\2\u0185\u0186\7\n\2\2\u0186\u01df\3\2\2\2\u0187\u0189\7\4"+
		"\2\2\u0188\u018a\5\66\34\2\u0189\u0188\3\2\2\2\u0189\u018a\3\2\2\2\u018a"+
		"\u018b\3\2\2\2\u018b\u01df\7\5\2\2\u018c\u018d\5D#\2\u018d\u018e\7\n\2"+
		"\2\u018e\u01df\3\2\2\2\u018f\u0190\7;\2\2\u0190\u0191\7\b\2\2\u0191\u0192"+
		"\5D#\2\u0192\u0193\7\t\2\2\u0193\u0196\58\35\2\u0194\u0195\7<\2\2\u0195"+
		"\u0197\58\35\2\u0196\u0194\3\2\2\2\u0196\u0197\3\2\2\2\u0197\u01df\3\2"+
		"\2\2\u0198\u019a\5\64\33\2\u0199\u0198\3\2\2\2\u019a\u019d\3\2\2\2\u019b"+
		"\u0199\3\2\2\2\u019b\u019c\3\2\2\2\u019c\u019e\3\2\2\2\u019d\u019b\3\2"+
		"\2\2\u019e\u019f\7=\2\2\u019f\u01a0\7\b\2\2\u01a0\u01a1\5D#\2\u01a1\u01a2"+
		"\7\t\2\2\u01a2\u01a3\58\35\2\u01a3\u01df\3\2\2\2\u01a4\u01a6\5\64\33\2"+
		"\u01a5\u01a4\3\2\2\2\u01a6\u01a9\3\2\2\2\u01a7\u01a5\3\2\2\2\u01a7\u01a8"+
		"\3\2\2\2\u01a8\u01aa\3\2\2\2\u01a9\u01a7\3\2\2\2\u01aa\u01ab\7>\2\2\u01ab"+
		"\u01ac\58\35\2\u01ac\u01ad\7=\2\2\u01ad\u01ae\7\b\2\2\u01ae\u01af\5D#"+
		"\2\u01af\u01b0\7\t\2\2\u01b0\u01b1\7\n\2\2\u01b1\u01df\3\2\2\2\u01b2\u01b4"+
		"\5\64\33\2\u01b3\u01b2\3\2\2\2\u01b4\u01b7\3\2\2\2\u01b5\u01b3\3\2\2\2"+
		"\u01b5\u01b6\3\2\2\2\u01b6\u01b8\3\2\2\2\u01b7\u01b5\3\2\2\2\u01b8\u01b9"+
		"\7?\2\2\u01b9\u01ba\7\b\2\2\u01ba\u01bb\5> \2\u01bb\u01bc\7\t\2\2\u01bc"+
		"\u01bd\58\35\2\u01bd\u01df\3\2\2\2\u01be\u01bf\7@\2\2\u01bf\u01c0\7\b"+
		"\2\2\u01c0\u01c1\5D#\2\u01c1\u01c2\7\t\2\2\u01c2\u01c3\7\4\2\2\u01c3\u01c4"+
		"\5:\36\2\u01c4\u01c5\7\5\2\2\u01c5\u01df\3\2\2\2\u01c6\u01c8\7A\2\2\u01c7"+
		"\u01c9\5D#\2\u01c8\u01c7\3\2\2\2\u01c8\u01c9\3\2\2\2\u01c9\u01ca\3\2\2"+
		"\2\u01ca\u01df\7\n\2\2\u01cb\u01cc\7B\2\2\u01cc\u01df\7\n\2\2\u01cd\u01ce"+
		"\7C\2\2\u01ce\u01df\7\n\2\2\u01cf\u01d1\7E\2\2\u01d0\u01d2\5L\'\2\u01d1"+
		"\u01d0\3\2\2\2\u01d1\u01d2\3\2\2\2\u01d2\u01d3\3\2\2\2\u01d3\u01d4\7\4"+
		"\2\2\u01d4\u01d5\5P)\2\u01d5\u01d6\7\u0087\2\2\u01d6\u01df\3\2\2\2\u01d7"+
		"\u01df\5J&\2\u01d8\u01df\7\n\2\2\u01d9\u01da\7n\2\2\u01da\u01df\7\13\2"+
		"\2\u01db\u01dc\7D\2\2\u01dc\u01dd\7n\2\2\u01dd\u01df\7\n\2\2\u01de\u0184"+
		"\3\2\2\2\u01de\u0187\3\2\2\2\u01de\u018c\3\2\2\2\u01de\u018f\3\2\2\2\u01de"+
		"\u019b\3\2\2\2\u01de\u01a7\3\2\2\2\u01de\u01b5\3\2\2\2\u01de\u01be\3\2"+
		"\2\2\u01de\u01c6\3\2\2\2\u01de\u01cb\3\2\2\2\u01de\u01cd\3\2\2\2\u01de"+
		"\u01cf\3\2\2\2\u01de\u01d7\3\2\2\2\u01de\u01d8\3\2\2\2\u01de\u01d9\3\2"+
		"\2\2\u01de\u01db\3\2\2\2\u01df9\3\2\2\2\u01e0\u01e2\5<\37\2\u01e1\u01e0"+
		"\3\2\2\2\u01e2\u01e3\3\2\2\2\u01e3\u01e1\3\2\2\2\u01e3\u01e4\3\2\2\2\u01e4"+
		"\u01ea\3\2\2\2\u01e5\u01e6\7F\2\2\u01e6\u01e8\7\13\2\2\u01e7\u01e9\5\66"+
		"\34\2\u01e8\u01e7\3\2\2\2\u01e8\u01e9\3\2\2\2\u01e9\u01eb\3\2\2\2\u01ea"+
		"\u01e5\3\2\2\2\u01ea\u01eb\3\2\2\2\u01eb;\3\2\2\2\u01ec\u01ed\7G\2\2\u01ed"+
		"\u01ee\5F$\2\u01ee\u01f0\7\13\2\2\u01ef\u01f1\5\66\34\2\u01f0\u01ef\3"+
		"\2\2\2\u01f0\u01f1\3\2\2\2\u01f1=\3\2\2\2\u01f2\u01f3\5@!\2\u01f3\u01f5"+
		"\7\n\2\2\u01f4\u01f6\5B\"\2\u01f5\u01f4\3\2\2\2\u01f5\u01f6\3\2\2\2\u01f6"+
		"\u01f7\3\2\2\2\u01f7\u01f9\7\n\2\2\u01f8\u01fa\5D#\2\u01f9\u01f8\3\2\2"+
		"\2\u01f9\u01fa\3\2\2\2\u01fa\u0203\3\2\2\2\u01fb\u01fc\5\22\n\2\u01fc"+
		"\u01fd\5\30\r\2\u01fd\u01fe\7\13\2\2\u01fe\u01ff\5F$\2\u01ff\u0200\7\r"+
		"\2\2\u0200\u0201\5F$\2\u0201\u0203\3\2\2\2\u0202\u01f2\3\2\2\2\u0202\u01fb"+
		"\3\2\2\2\u0203?\3\2\2\2\u0204\u0206\5\n\6\2\u0205\u0204\3\2\2\2\u0205"+
		"\u0206\3\2\2\2\u0206\u0209\3\2\2\2\u0207\u0209\5D#\2\u0208\u0205\3\2\2"+
		"\2\u0208\u0207\3\2\2\2\u0209A\3\2\2\2\u020a\u020b\5D#\2\u020bC\3\2\2\2"+
		"\u020c\u020d\b#\1\2\u020d\u020e\5F$\2\u020e\u0214\3\2\2\2\u020f\u0210"+
		"\f\3\2\2\u0210\u0211\7\f\2\2\u0211\u0213\5F$\2\u0212\u020f\3\2\2\2\u0213"+
		"\u0216\3\2\2\2\u0214\u0212\3\2\2\2\u0214\u0215\3\2\2\2\u0215E\3\2\2\2"+
		"\u0216\u0214\3\2\2\2\u0217\u0218\b$\1\2\u0218\u0219\7\b\2\2\u0219\u021a"+
		"\5D#\2\u021a\u021b\7\t\2\2\u021b\u025d\3\2\2\2\u021c\u021e\7K\2\2\u021d"+
		"\u021f\7\b\2\2\u021e\u021d\3\2\2\2\u021e\u021f\3\2\2\2\u021f\u0222\3\2"+
		"\2\2\u0220\u0223\5F$\2\u0221\u0223\5\24\13\2\u0222\u0220\3\2\2\2\u0222"+
		"\u0221\3\2\2\2\u0223\u0225\3\2\2\2\u0224\u0226\7\t\2\2\u0225\u0224\3\2"+
		"\2\2\u0225\u0226\3\2\2\2\u0226\u025d\3\2\2\2\u0227\u0229\7L\2\2\u0228"+
		"\u022a\7\b\2\2\u0229\u0228\3\2\2\2\u0229\u022a\3\2\2\2\u022a\u022d\3\2"+
		"\2\2\u022b\u022e\5F$\2\u022c\u022e\5\24\13\2\u022d\u022b\3\2\2\2\u022d"+
		"\u022c\3\2\2\2\u022e\u0230\3\2\2\2\u022f\u0231\7\t\2\2\u0230\u022f\3\2"+
		"\2\2\u0230\u0231\3\2\2\2\u0231\u025d\3\2\2\2\u0232\u0234\7M\2\2\u0233"+
		"\u0235\7\b\2\2\u0234\u0233\3\2\2\2\u0234\u0235\3\2\2\2\u0235\u0236\3\2"+
		"\2\2\u0236\u0238\7n\2\2\u0237\u0239\7\t\2\2\u0238\u0237\3\2\2\2\u0238"+
		"\u0239\3\2\2\2\u0239\u025d\3\2\2\2\u023a\u023b\7\b\2\2\u023b\u023c\5\24"+
		"\13\2\u023c\u023d\7\t\2\2\u023d\u023e\5F$\31\u023e\u025d\3\2\2\2\u023f"+
		"\u0240\t\3\2\2\u0240\u025d\5F$\30\u0241\u0242\7\24\2\2\u0242\u025d\5F"+
		"$\26\u0243\u0244\t\4\2\2\u0244\u025d\5F$\25\u0245\u0246\7\4\2\2\u0246"+
		"\u024b\5F$\2\u0247\u0248\7\f\2\2\u0248\u024a\5F$\2\u0249\u0247\3\2\2\2"+
		"\u024a\u024d\3\2\2\2\u024b\u0249\3\2\2\2\u024b\u024c\3\2\2\2\u024c\u024f"+
		"\3\2\2\2\u024d\u024b\3\2\2\2\u024e\u0250\7\f\2\2\u024f\u024e\3\2\2\2\u024f"+
		"\u0250\3\2\2\2\u0250\u0251\3\2\2\2\u0251\u0252\7\5\2\2\u0252\u025d\3\2"+
		"\2\2\u0253\u025d\7n\2\2\u0254\u025d\7e\2\2\u0255\u0257\7o\2\2\u0256\u0255"+
		"\3\2\2\2\u0257\u0258\3\2\2\2\u0258\u0256\3\2\2\2\u0258\u0259\3\2\2\2\u0259"+
		"\u025d\3\2\2\2\u025a\u025d\7p\2\2\u025b\u025d\7V\2\2\u025c\u0217\3\2\2"+
		"\2\u025c\u021c\3\2\2\2\u025c\u0227\3\2\2\2\u025c\u0232\3\2\2\2\u025c\u023a"+
		"\3\2\2\2\u025c\u023f\3\2\2\2\u025c\u0241\3\2\2\2\u025c\u0243\3\2\2\2\u025c"+
		"\u0245\3\2\2\2\u025c\u0253\3\2\2\2\u025c\u0254\3\2\2\2\u025c\u0256\3\2"+
		"\2\2\u025c\u025a\3\2\2\2\u025c\u025b\3\2\2\2\u025d\u029a\3\2\2\2\u025e"+
		"\u025f\f\24\2\2\u025f\u0260\t\5\2\2\u0260\u0299\5F$\25\u0261\u0262\f\23"+
		"\2\2\u0262\u0263\t\6\2\2\u0263\u0299\5F$\24\u0264\u0265\f\22\2\2\u0265"+
		"\u0266\t\7\2\2\u0266\u0299\5F$\23\u0267\u0268\f\21\2\2\u0268\u0269\t\b"+
		"\2\2\u0269\u0299\5F$\22\u026a\u026b\f\20\2\2\u026b\u026c\7\31\2\2\u026c"+
		"\u0299\5F$\21\u026d\u026e\f\17\2\2\u026e\u026f\7\33\2\2\u026f\u0299\5"+
		"F$\20\u0270\u0271\f\16\2\2\u0271\u0272\7\34\2\2\u0272\u0299\5F$\17\u0273"+
		"\u0274\f\r\2\2\u0274\u0275\7%\2\2\u0275\u0299\5F$\16\u0276\u0277\f\f\2"+
		"\2\u0277\u0278\7&\2\2\u0278\u0299\5F$\r\u0279\u027a\f\13\2\2\u027a\u027b"+
		"\7\17\2\2\u027b\u027c\5F$\2\u027c\u027d\7\13\2\2\u027d\u027e\5F$\f\u027e"+
		"\u0299\3\2\2\2\u027f\u0280\f\n\2\2\u0280\u0281\7\'\2\2\u0281\u0299\5F"+
		"$\n\u0282\u0283\f\t\2\2\u0283\u0284\7(\2\2\u0284\u0299\5F$\t\u0285\u0286"+
		"\f \2\2\u0286\u0287\7\20\2\2\u0287\u0299\7n\2\2\u0288\u0289\f\37\2\2\u0289"+
		"\u028a\7\21\2\2\u028a\u0299\7n\2\2\u028b\u028c\f\36\2\2\u028c\u028e\7"+
		"\b\2\2\u028d\u028f\5H%\2\u028e\u028d\3\2\2\2\u028e\u028f\3\2\2\2\u028f"+
		"\u0290\3\2\2\2\u0290\u0299\7\t\2\2\u0291\u0292\f\32\2\2\u0292\u0293\7"+
		"\6\2\2\u0293\u0294\5D#\2\u0294\u0295\7\7\2\2\u0295\u0299\3\2\2\2\u0296"+
		"\u0297\f\27\2\2\u0297\u0299\t\3\2\2\u0298\u025e\3\2\2\2\u0298\u0261\3"+
		"\2\2\2\u0298\u0264\3\2\2\2\u0298\u0267\3\2\2\2\u0298\u026a\3\2\2\2\u0298"+
		"\u026d\3\2\2\2\u0298\u0270\3\2\2\2\u0298\u0273\3\2\2\2\u0298\u0276\3\2"+
		"\2\2\u0298\u0279\3\2\2\2\u0298\u027f\3\2\2\2\u0298\u0282\3\2\2\2\u0298"+
		"\u0285\3\2\2\2\u0298\u0288\3\2\2\2\u0298\u028b\3\2\2\2\u0298\u0291\3\2"+
		"\2\2\u0298\u0296\3\2\2\2\u0299\u029c\3\2\2\2\u029a\u0298\3\2\2\2\u029a"+
		"\u029b\3\2\2\2\u029bG\3\2\2\2\u029c\u029a\3\2\2\2\u029d\u02a2\5F$\2\u029e"+
		"\u029f\7\f\2\2\u029f\u02a1\5F$\2\u02a0\u029e\3\2\2\2\u02a1\u02a4\3\2\2"+
		"\2\u02a2\u02a0\3\2\2\2\u02a2\u02a3\3\2\2\2\u02a3I\3\2\2\2\u02a4\u02a2"+
		"\3\2\2\2\u02a5\u02a7\7N\2\2\u02a6\u02a8\5L\'\2\u02a7\u02a6\3\2\2\2\u02a7"+
		"\u02a8\3\2\2\2\u02a8\u02a9\3\2\2\2\u02a9\u02aa\7W\2\2\u02aaK\3\2\2\2\u02ab"+
		"\u02ac\7\b\2\2\u02ac\u02b1\5N(\2\u02ad\u02ae\7\f\2\2\u02ae\u02b0\5N(\2"+
		"\u02af\u02ad\3\2\2\2\u02b0\u02b3\3\2\2\2\u02b1\u02af\3\2\2\2\u02b1\u02b2"+
		"\3\2\2\2\u02b2\u02b4\3\2\2\2\u02b3\u02b1\3\2\2\2\u02b4\u02b5\7\t\2\2\u02b5"+
		"M\3\2\2\2\u02b6\u02b7\7O\2\2\u02b7\u02c1\7o\2\2\u02b8\u02b9\7P\2\2\u02b9"+
		"\u02c1\7n\2\2\u02ba\u02bb\7Q\2\2\u02bb\u02c1\7o\2\2\u02bc\u02bd\7R\2\2"+
		"\u02bd\u02c1\5F$\2\u02be\u02bf\7S\2\2\u02bf\u02c1\5F$\2\u02c0\u02b6\3"+
		"\2\2\2\u02c0\u02b8\3\2\2\2\u02c0\u02ba\3\2\2\2\u02c0\u02bc\3\2\2\2\u02c0"+
		"\u02be\3\2\2\2\u02c1O\3\2\2\2\u02c2\u02c4\5R*\2\u02c3\u02c2\3\2\2\2\u02c4"+
		"\u02c7\3\2\2\2\u02c5\u02c3\3\2\2\2\u02c5\u02c6\3\2\2\2\u02c6Q\3\2\2\2"+
		"\u02c7\u02c5\3\2\2\2\u02c8\u02cc\5T+\2\u02c9\u02cc\5V,\2\u02ca\u02cc\5"+
		"X-\2\u02cb\u02c8\3\2\2\2\u02cb\u02c9\3\2\2\2\u02cb\u02ca\3\2\2\2\u02cc"+
		"S\3\2\2\2\u02cd\u02ce\7\u0094\2\2\u02ce\u02d2\7w\2\2\u02cf\u02d1\7\u0095"+
		"\2\2\u02d0\u02cf\3\2\2\2\u02d1\u02d4\3\2\2\2\u02d2\u02d0\3\2\2\2\u02d2"+
		"\u02d3\3\2\2\2\u02d3\u02de\3\2\2\2\u02d4\u02d2\3\2\2\2\u02d5\u02d6\7\u0093"+
		"\2\2\u02d6\u02da\7w\2\2\u02d7\u02d9\7\u0095\2\2\u02d8\u02d7\3\2\2\2\u02d9"+
		"\u02dc\3\2\2\2\u02da\u02d8\3\2\2\2\u02da\u02db\3\2\2\2\u02db\u02de\3\2"+
		"\2\2\u02dc\u02da\3\2\2\2\u02dd\u02cd\3\2\2\2\u02dd\u02d5\3\2\2\2\u02de"+
		"U\3\2\2\2\u02df\u02e1\7u\2\2\u02e0\u02e2\5Z.\2\u02e1\u02e0\3\2\2\2\u02e1"+
		"\u02e2\3\2\2\2\u02e2\u02e6\3\2\2\2\u02e3\u02e5\7\u0095\2\2\u02e4\u02e3"+
		"\3\2\2\2\u02e5\u02e8\3\2\2\2\u02e6\u02e4\3\2\2\2\u02e6\u02e7\3\2\2\2\u02e7"+
		"W\3\2\2\2\u02e8\u02e6\3\2\2\2\u02e9\u02ea\7t\2\2\u02ea\u02ef\5\\/\2\u02eb"+
		"\u02ec\7x\2\2\u02ec\u02ee\5\\/\2\u02ed\u02eb\3\2\2\2\u02ee\u02f1\3\2\2"+
		"\2\u02ef\u02ed\3\2\2\2\u02ef\u02f0\3\2\2\2\u02f0\u02f5\3\2\2\2\u02f1\u02ef"+
		"\3\2\2\2\u02f2\u02f4\7\u0095\2\2\u02f3\u02f2\3\2\2\2\u02f4\u02f7\3\2\2"+
		"\2\u02f5\u02f3\3\2\2\2\u02f5\u02f6\3\2\2\2\u02f6Y\3\2\2\2\u02f7\u02f5"+
		"\3\2\2\2\u02f8\u0326\5\\/\2\u02f9\u02fa\7v\2\2\u02fa\u0326\5\\/\2\u02fb"+
		"\u02fc\5\\/\2\u02fc\u02fd\7x\2\2\u02fd\u02fe\5\\/\2\u02fe\u0326\3\2\2"+
		"\2\u02ff\u0300\7y\2\2\u0300\u0301\5\\/\2\u0301\u0302\7z\2\2\u0302\u0303"+
		"\7x\2\2\u0303\u0304\7\u0094\2\2\u0304\u0326\3\2\2\2\u0305\u0306\7y\2\2"+
		"\u0306\u0307\7y\2\2\u0307\u0308\5\\/\2\u0308\u0309\7z\2\2\u0309\u030a"+
		"\7z\2\2\u030a\u030b\7x\2\2\u030b\u030c\7\u0094\2\2\u030c\u0326\3\2\2\2"+
		"\u030d\u030e\7y\2\2\u030e\u030f\5\\/\2\u030f\u0310\7x\2\2\u0310\u0311"+
		"\7\u0094\2\2\u0311\u0312\7z\2\2\u0312\u0313\7x\2\2\u0313\u0314\7\u0094"+
		"\2\2\u0314\u0326\3\2\2\2\u0315\u0316\7y\2\2\u0316\u0317\5\\/\2\u0317\u0318"+
		"\7x\2\2\u0318\u0319\7\u0094\2\2\u0319\u031a\7z\2\2\u031a\u0326\3\2\2\2"+
		"\u031b\u031c\7y\2\2\u031c\u031d\5\\/\2\u031d\u031e\7z\2\2\u031e\u0326"+
		"\3\2\2\2\u031f\u0320\7y\2\2\u0320\u0321\7y\2\2\u0321\u0322\5\\/\2\u0322"+
		"\u0323\7z\2\2\u0323\u0324\7z\2\2\u0324\u0326\3\2\2\2\u0325\u02f8\3\2\2"+
		"\2\u0325\u02f9\3\2\2\2\u0325\u02fb\3\2\2\2\u0325\u02ff\3\2\2\2\u0325\u0305"+
		"\3\2\2\2\u0325\u030d\3\2\2\2\u0325\u0315\3\2\2\2\u0325\u031b\3\2\2\2\u0325"+
		"\u031f\3\2\2\2\u0326[\3\2\2\2\u0327\u0328\b/\1\2\u0328\u0329\7{\2\2\u0329"+
		"\u032a\5\\/\2\u032a\u032b\7|\2\2\u032b\u0336\3\2\2\2\u032c\u032d\t\t\2"+
		"\2\u032d\u0336\5\\/\n\u032e\u0336\7\u0094\2\2\u032f\u0336\7\u0092\2\2"+
		"\u0330\u0331\7\u0086\2\2\u0331\u0332\7\u0094\2\2\u0332\u0336\7\u0087\2"+
		"\2\u0333\u0336\7\u0088\2\2\u0334\u0336\7\u0091\2\2\u0335\u0327\3\2\2\2"+
		"\u0335\u032c\3\2\2\2\u0335\u032e\3\2\2\2\u0335\u032f\3\2\2\2\u0335\u0330"+
		"\3\2\2\2\u0335\u0333\3\2\2\2\u0335\u0334\3\2\2\2\u0336\u0345\3\2\2\2\u0337"+
		"\u0338\f\f\2\2\u0338\u0339\7}\2\2\u0339\u0344\5\\/\r\u033a\u033b\f\13"+
		"\2\2\u033b\u033c\t\n\2\2\u033c\u0344\5\\/\f\u033d\u033e\f\t\2\2\u033e"+
		"\u033f\t\13\2\2\u033f\u0344\5\\/\n\u0340\u0341\f\b\2\2\u0341\u0342\t\f"+
		"\2\2\u0342\u0344\5\\/\t\u0343\u0337\3\2\2\2\u0343\u033a\3\2\2\2\u0343"+
		"\u033d\3\2\2\2\u0343\u0340\3\2\2\2\u0344\u0347\3\2\2\2\u0345\u0343\3\2"+
		"\2\2\u0345\u0346\3\2\2\2\u0346]\3\2\2\2\u0347\u0345\3\2\2\2Xgx\u0085\u008b"+
		"\u0091\u009b\u00a2\u00ad\u00b5\u00ba\u00c0\u00c3\u00c5\u00cf\u00d7\u00dc"+
		"\u00e2\u00e5\u00e7\u00ed\u00f4\u00fb\u0101\u010d\u011b\u0121\u0127\u0130"+
		"\u0138\u0142\u014e\u0159\u016e\u0177\u017d\u0182\u0189\u0196\u019b\u01a7"+
		"\u01b5\u01c8\u01d1\u01de\u01e3\u01e8\u01ea\u01f0\u01f5\u01f9\u0202\u0205"+
		"\u0208\u0214\u021e\u0222\u0225\u0229\u022d\u0230\u0234\u0238\u024b\u024f"+
		"\u0258\u025c\u028e\u0298\u029a\u02a2\u02a7\u02b1\u02c0\u02c5\u02cb\u02d2"+
		"\u02da\u02dd\u02e1\u02e6\u02ef\u02f5\u0325\u0335\u0343\u0345";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}
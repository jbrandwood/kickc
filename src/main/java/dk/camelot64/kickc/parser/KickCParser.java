// Generated from /Users/jespergravgaard/c64/kickc/src/main/java/dk/camelot64/kickc/parser/KickCParser.g4 by ANTLR 4.7
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
	static { RuntimeMetaData.checkVersion("4.7", RuntimeMetaData.VERSION); }

	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		TYPEDEFNAME=1, CURLY_BEGIN=2, CURLY_END=3, BRACKET_BEGIN=4, BRACKET_END=5, 
		PAR_BEGIN=6, PAR_END=7, SEMICOLON=8, COLON=9, COMMA=10, RANGE=11, CONDITION=12, 
		DOT=13, ARROW=14, PLUS=15, MINUS=16, ASTERISK=17, DIVIDE=18, MODULO=19, 
		INC=20, DEC=21, AND=22, BIT_NOT=23, BIT_XOR=24, BIT_OR=25, SHIFT_LEFT=26, 
		SHIFT_RIGHT=27, EQUAL=28, NOT_EQUAL=29, LESS_THAN=30, LESS_THAN_EQUAL=31, 
		GREATER_THAN_EQUAL=32, GREATER_THAN=33, LOGIC_AND=34, LOGIC_OR=35, ASSIGN=36, 
		ASSIGN_COMPOUND=37, IMPORT=38, TYPEDEF=39, PRAGMA=40, RESERVE=41, PC=42, 
		TARGET=43, LINK=44, CPU=45, CODESEG=46, DATASEG=47, ENCODING=48, CONST=49, 
		EXTERN=50, EXPORT=51, ALIGN=52, REGISTER=53, MEMORY=54, ZEROPAGE=55, MAINMEM=56, 
		INLINE=57, VOLATILE=58, INTERRUPT=59, CALLING=60, CALLINGCONVENTION=61, 
		IF=62, ELSE=63, WHILE=64, DO=65, FOR=66, SWITCH=67, RETURN=68, BREAK=69, 
		CONTINUE=70, ASM=71, DEFAULT=72, CASE=73, STRUCT=74, ENUM=75, SIZEOF=76, 
		TYPEID=77, KICKASM=78, RESOURCE=79, USES=80, CLOBBERS=81, BYTES=82, CYCLES=83, 
		LOGIC_NOT=84, SIGNEDNESS=85, SIMPLETYPE=86, BOOLEAN=87, KICKASM_BODY=88, 
		STRING=89, CHAR=90, NUMBER=91, NUMFLOAT=92, BINFLOAT=93, DECFLOAT=94, 
		HEXFLOAT=95, NUMINT=96, BININTEGER=97, DECINTEGER=98, HEXINTEGER=99, NAME=100, 
		WS=101, COMMENT_LINE=102, COMMENT_BLOCK=103, ASM_BYTE=104, ASM_MNEMONIC=105, 
		ASM_IMM=106, ASM_COLON=107, ASM_COMMA=108, ASM_PAR_BEGIN=109, ASM_PAR_END=110, 
		ASM_BRACKET_BEGIN=111, ASM_BRACKET_END=112, ASM_DOT=113, ASM_SHIFT_LEFT=114, 
		ASM_SHIFT_RIGHT=115, ASM_PLUS=116, ASM_MINUS=117, ASM_LESS_THAN=118, ASM_GREATER_THAN=119, 
		ASM_MULTIPLY=120, ASM_DIVIDE=121, ASM_CURLY_BEGIN=122, ASM_CURLY_END=123, 
		ASM_NUMBER=124, ASM_NUMFLOAT=125, ASM_BINFLOAT=126, ASM_DECFLOAT=127, 
		ASM_HEXFLOAT=128, ASM_NUMINT=129, ASM_BININTEGER=130, ASM_DECINTEGER=131, 
		ASM_HEXINTEGER=132, ASM_CHAR=133, ASM_MULTI_REL=134, ASM_MULTI_NAME=135, 
		ASM_NAME=136, ASM_WS=137, ASM_COMMENT_LINE=138, ASM_COMMENT_BLOCK=139;
	public static final int
		RULE_file = 0, RULE_asmFile = 1, RULE_declSeq = 2, RULE_declOrImport = 3, 
		RULE_importDecl = 4, RULE_decl = 5, RULE_typeDef = 6, RULE_declTypes = 7, 
		RULE_declVariables = 8, RULE_declVariableList = 9, RULE_declVariableInit = 10, 
		RULE_declFunction = 11, RULE_parameterListDecl = 12, RULE_parameterDecl = 13, 
		RULE_globalDirective = 14, RULE_directive = 15, RULE_stmtSeq = 16, RULE_stmt = 17, 
		RULE_switchCases = 18, RULE_switchCase = 19, RULE_forLoop = 20, RULE_forClassicInit = 21, 
		RULE_typeDecl = 22, RULE_structRef = 23, RULE_structDef = 24, RULE_structMembers = 25, 
		RULE_enumRef = 26, RULE_enumDef = 27, RULE_enumMemberList = 28, RULE_enumMember = 29, 
		RULE_commaExpr = 30, RULE_expr = 31, RULE_parameterList = 32, RULE_declKasm = 33, 
		RULE_asmDirectives = 34, RULE_asmDirective = 35, RULE_asmLines = 36, RULE_asmLine = 37, 
		RULE_asmLabel = 38, RULE_asmInstruction = 39, RULE_asmBytes = 40, RULE_asmParamMode = 41, 
		RULE_asmExpr = 42;
	public static final String[] ruleNames = {
		"file", "asmFile", "declSeq", "declOrImport", "importDecl", "decl", "typeDef", 
		"declTypes", "declVariables", "declVariableList", "declVariableInit", 
		"declFunction", "parameterListDecl", "parameterDecl", "globalDirective", 
		"directive", "stmtSeq", "stmt", "switchCases", "switchCase", "forLoop", 
		"forClassicInit", "typeDecl", "structRef", "structDef", "structMembers", 
		"enumRef", "enumDef", "enumMemberList", "enumMember", "commaExpr", "expr", 
		"parameterList", "declKasm", "asmDirectives", "asmDirective", "asmLines", 
		"asmLine", "asmLabel", "asmInstruction", "asmBytes", "asmParamMode", "asmExpr"
	};

	private static final String[] _LITERAL_NAMES = {
		null, null, null, null, null, null, null, null, "';'", null, null, "'..'", 
		"'?'", null, "'->'", null, null, null, null, "'%'", "'++'", "'--'", "'&'", 
		"'~'", "'^'", "'|'", null, null, "'=='", "'!='", null, "'<='", "'>='", 
		null, "'&&'", "'||'", "'='", null, "'import'", "'typedef'", "'#pragma'", 
		"'reserve'", "'pc'", "'target'", "'link'", "'cpu'", "'code_seg'", "'data_seg'", 
		"'encoding'", "'const'", "'extern'", "'export'", "'align'", "'register'", 
		"'memory'", "'__zp'", "'__mem'", "'inline'", "'volatile'", "'interrupt'", 
		"'calling'", null, "'if'", "'else'", "'while'", "'do'", "'for'", "'switch'", 
		"'return'", "'break'", "'continue'", "'asm'", "'default'", "'case'", "'struct'", 
		"'enum'", "'sizeof'", "'typeid'", "'kickasm'", "'resource'", "'uses'", 
		"'clobbers'", "'bytes'", "'cycles'", "'!'", null, null, null, null, null, 
		null, null, null, null, null, null, null, null, null, null, null, null, 
		null, null, "'.byte'", null, "'#'"
	};
	private static final String[] _SYMBOLIC_NAMES = {
		null, "TYPEDEFNAME", "CURLY_BEGIN", "CURLY_END", "BRACKET_BEGIN", "BRACKET_END", 
		"PAR_BEGIN", "PAR_END", "SEMICOLON", "COLON", "COMMA", "RANGE", "CONDITION", 
		"DOT", "ARROW", "PLUS", "MINUS", "ASTERISK", "DIVIDE", "MODULO", "INC", 
		"DEC", "AND", "BIT_NOT", "BIT_XOR", "BIT_OR", "SHIFT_LEFT", "SHIFT_RIGHT", 
		"EQUAL", "NOT_EQUAL", "LESS_THAN", "LESS_THAN_EQUAL", "GREATER_THAN_EQUAL", 
		"GREATER_THAN", "LOGIC_AND", "LOGIC_OR", "ASSIGN", "ASSIGN_COMPOUND", 
		"IMPORT", "TYPEDEF", "PRAGMA", "RESERVE", "PC", "TARGET", "LINK", "CPU", 
		"CODESEG", "DATASEG", "ENCODING", "CONST", "EXTERN", "EXPORT", "ALIGN", 
		"REGISTER", "MEMORY", "ZEROPAGE", "MAINMEM", "INLINE", "VOLATILE", "INTERRUPT", 
		"CALLING", "CALLINGCONVENTION", "IF", "ELSE", "WHILE", "DO", "FOR", "SWITCH", 
		"RETURN", "BREAK", "CONTINUE", "ASM", "DEFAULT", "CASE", "STRUCT", "ENUM", 
		"SIZEOF", "TYPEID", "KICKASM", "RESOURCE", "USES", "CLOBBERS", "BYTES", 
		"CYCLES", "LOGIC_NOT", "SIGNEDNESS", "SIMPLETYPE", "BOOLEAN", "KICKASM_BODY", 
		"STRING", "CHAR", "NUMBER", "NUMFLOAT", "BINFLOAT", "DECFLOAT", "HEXFLOAT", 
		"NUMINT", "BININTEGER", "DECINTEGER", "HEXINTEGER", "NAME", "WS", "COMMENT_LINE", 
		"COMMENT_BLOCK", "ASM_BYTE", "ASM_MNEMONIC", "ASM_IMM", "ASM_COLON", "ASM_COMMA", 
		"ASM_PAR_BEGIN", "ASM_PAR_END", "ASM_BRACKET_BEGIN", "ASM_BRACKET_END", 
		"ASM_DOT", "ASM_SHIFT_LEFT", "ASM_SHIFT_RIGHT", "ASM_PLUS", "ASM_MINUS", 
		"ASM_LESS_THAN", "ASM_GREATER_THAN", "ASM_MULTIPLY", "ASM_DIVIDE", "ASM_CURLY_BEGIN", 
		"ASM_CURLY_END", "ASM_NUMBER", "ASM_NUMFLOAT", "ASM_BINFLOAT", "ASM_DECFLOAT", 
		"ASM_HEXFLOAT", "ASM_NUMINT", "ASM_BININTEGER", "ASM_DECINTEGER", "ASM_HEXINTEGER", 
		"ASM_CHAR", "ASM_MULTI_REL", "ASM_MULTI_NAME", "ASM_NAME", "ASM_WS", "ASM_COMMENT_LINE", 
		"ASM_COMMENT_BLOCK"
	};
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
			setState(86);
			declSeq();
			setState(87);
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
			setState(89);
			asmLines();
			setState(90);
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
			setState(95);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << TYPEDEFNAME) | (1L << PAR_BEGIN) | (1L << IMPORT) | (1L << TYPEDEF) | (1L << PRAGMA) | (1L << RESERVE) | (1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << REGISTER) | (1L << MEMORY) | (1L << ZEROPAGE) | (1L << MAINMEM) | (1L << INLINE) | (1L << VOLATILE) | (1L << INTERRUPT) | (1L << CALLINGCONVENTION))) != 0) || ((((_la - 74)) & ~0x3f) == 0 && ((1L << (_la - 74)) & ((1L << (STRUCT - 74)) | (1L << (ENUM - 74)) | (1L << (KICKASM - 74)) | (1L << (SIGNEDNESS - 74)) | (1L << (SIMPLETYPE - 74)))) != 0)) {
				{
				{
				setState(92);
				declOrImport();
				}
				}
				setState(97);
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
			setState(100);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case TYPEDEFNAME:
			case PAR_BEGIN:
			case TYPEDEF:
			case PRAGMA:
			case RESERVE:
			case CONST:
			case EXTERN:
			case EXPORT:
			case ALIGN:
			case REGISTER:
			case MEMORY:
			case ZEROPAGE:
			case MAINMEM:
			case INLINE:
			case VOLATILE:
			case INTERRUPT:
			case CALLINGCONVENTION:
			case STRUCT:
			case ENUM:
			case KICKASM:
			case SIGNEDNESS:
			case SIMPLETYPE:
				enterOuterAlt(_localctx, 1);
				{
				setState(98);
				decl();
				}
				break;
			case IMPORT:
				enterOuterAlt(_localctx, 2);
				{
				setState(99);
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
		public TerminalNode IMPORT() { return getToken(KickCParser.IMPORT, 0); }
		public TerminalNode STRING() { return getToken(KickCParser.STRING, 0); }
		public ImportDeclContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_importDecl; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterImportDecl(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitImportDecl(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitImportDecl(this);
			else return visitor.visitChildren(this);
		}
	}

	public final ImportDeclContext importDecl() throws RecognitionException {
		ImportDeclContext _localctx = new ImportDeclContext(_ctx, getState());
		enterRule(_localctx, 8, RULE_importDecl);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(102);
			match(IMPORT);
			setState(103);
			match(STRING);
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
			setState(120);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,2,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				setState(105);
				declVariables();
				setState(106);
				match(SEMICOLON);
				}
				break;
			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(108);
				structDef();
				setState(109);
				match(SEMICOLON);
				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(111);
				enumDef();
				setState(112);
				match(SEMICOLON);
				}
				break;
			case 4:
				enterOuterAlt(_localctx, 4);
				{
				setState(114);
				declFunction();
				}
				break;
			case 5:
				enterOuterAlt(_localctx, 5);
				{
				setState(115);
				declKasm();
				}
				break;
			case 6:
				enterOuterAlt(_localctx, 6);
				{
				setState(116);
				globalDirective();
				}
				break;
			case 7:
				enterOuterAlt(_localctx, 7);
				{
				setState(117);
				typeDef();
				setState(118);
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

	public static class TypeDefContext extends ParserRuleContext {
		public Token NAME;
		public TerminalNode TYPEDEF() { return getToken(KickCParser.TYPEDEF, 0); }
		public TypeDeclContext typeDecl() {
			return getRuleContext(TypeDeclContext.class,0);
		}
		public TerminalNode NAME() { return getToken(KickCParser.NAME, 0); }
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
		enterRule(_localctx, 12, RULE_typeDef);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(122);
			match(TYPEDEF);
			setState(123);
			typeDecl(0);
			setState(124);
			((TypeDefContext)_localctx).NAME = match(NAME);
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

	public static class DeclTypesContext extends ParserRuleContext {
		public TypeDeclContext typeDecl() {
			return getRuleContext(TypeDeclContext.class,0);
		}
		public List<DirectiveContext> directive() {
			return getRuleContexts(DirectiveContext.class);
		}
		public DirectiveContext directive(int i) {
			return getRuleContext(DirectiveContext.class,i);
		}
		public DeclTypesContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_declTypes; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterDeclTypes(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitDeclTypes(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitDeclTypes(this);
			else return visitor.visitChildren(this);
		}
	}

	public final DeclTypesContext declTypes() throws RecognitionException {
		DeclTypesContext _localctx = new DeclTypesContext(_ctx, getState());
		enterRule(_localctx, 14, RULE_declTypes);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(130);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << RESERVE) | (1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << REGISTER) | (1L << MEMORY) | (1L << ZEROPAGE) | (1L << MAINMEM) | (1L << INLINE) | (1L << VOLATILE) | (1L << INTERRUPT) | (1L << CALLINGCONVENTION))) != 0)) {
				{
				{
				setState(127);
				directive();
				}
				}
				setState(132);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(133);
			typeDecl(0);
			setState(137);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << RESERVE) | (1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << REGISTER) | (1L << MEMORY) | (1L << ZEROPAGE) | (1L << MAINMEM) | (1L << INLINE) | (1L << VOLATILE) | (1L << INTERRUPT) | (1L << CALLINGCONVENTION))) != 0)) {
				{
				{
				setState(134);
				directive();
				}
				}
				setState(139);
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

	public static class DeclVariablesContext extends ParserRuleContext {
		public DeclTypesContext declTypes() {
			return getRuleContext(DeclTypesContext.class,0);
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
		enterRule(_localctx, 16, RULE_declVariables);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(140);
			declTypes();
			setState(141);
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
		int _startState = 18;
		enterRecursionRule(_localctx, 18, RULE_declVariableList, _p);
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			{
			setState(144);
			declVariableInit();
			}
			_ctx.stop = _input.LT(-1);
			setState(151);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,5,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					{
					_localctx = new DeclVariableListContext(_parentctx, _parentState);
					pushNewRecursionContext(_localctx, _startState, RULE_declVariableList);
					setState(146);
					if (!(precpred(_ctx, 1))) throw new FailedPredicateException(this, "precpred(_ctx, 1)");
					setState(147);
					match(COMMA);
					setState(148);
					declVariableInit();
					}
					} 
				}
				setState(153);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,5,_ctx);
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
		public DeclKasmContext declKasm() {
			return getRuleContext(DeclKasmContext.class,0);
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
		enterRule(_localctx, 20, RULE_declVariableInit);
		try {
			setState(162);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,7,_ctx) ) {
			case 1:
				_localctx = new DeclVariableInitExprContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(154);
				match(NAME);
				setState(157);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,6,_ctx) ) {
				case 1:
					{
					setState(155);
					match(ASSIGN);
					setState(156);
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
				setState(159);
				match(NAME);
				setState(160);
				match(ASSIGN);
				setState(161);
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

	public static class DeclFunctionContext extends ParserRuleContext {
		public DeclTypesContext declTypes() {
			return getRuleContext(DeclTypesContext.class,0);
		}
		public TerminalNode NAME() { return getToken(KickCParser.NAME, 0); }
		public TerminalNode PAR_BEGIN() { return getToken(KickCParser.PAR_BEGIN, 0); }
		public TerminalNode PAR_END() { return getToken(KickCParser.PAR_END, 0); }
		public TerminalNode CURLY_BEGIN() { return getToken(KickCParser.CURLY_BEGIN, 0); }
		public TerminalNode CURLY_END() { return getToken(KickCParser.CURLY_END, 0); }
		public ParameterListDeclContext parameterListDecl() {
			return getRuleContext(ParameterListDeclContext.class,0);
		}
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
		enterRule(_localctx, 22, RULE_declFunction);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(164);
			declTypes();
			setState(165);
			match(NAME);
			setState(166);
			match(PAR_BEGIN);
			setState(168);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << TYPEDEFNAME) | (1L << PAR_BEGIN) | (1L << RESERVE) | (1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << REGISTER) | (1L << MEMORY) | (1L << ZEROPAGE) | (1L << MAINMEM) | (1L << INLINE) | (1L << VOLATILE) | (1L << INTERRUPT) | (1L << CALLINGCONVENTION))) != 0) || ((((_la - 74)) & ~0x3f) == 0 && ((1L << (_la - 74)) & ((1L << (STRUCT - 74)) | (1L << (ENUM - 74)) | (1L << (SIGNEDNESS - 74)) | (1L << (SIMPLETYPE - 74)))) != 0)) {
				{
				setState(167);
				parameterListDecl();
				}
			}

			setState(170);
			match(PAR_END);
			setState(171);
			match(CURLY_BEGIN);
			setState(173);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << TYPEDEFNAME) | (1L << CURLY_BEGIN) | (1L << PAR_BEGIN) | (1L << PLUS) | (1L << MINUS) | (1L << ASTERISK) | (1L << INC) | (1L << DEC) | (1L << AND) | (1L << BIT_NOT) | (1L << LESS_THAN) | (1L << GREATER_THAN) | (1L << RESERVE) | (1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << REGISTER) | (1L << MEMORY) | (1L << ZEROPAGE) | (1L << MAINMEM) | (1L << INLINE) | (1L << VOLATILE) | (1L << INTERRUPT) | (1L << CALLINGCONVENTION) | (1L << IF))) != 0) || ((((_la - 64)) & ~0x3f) == 0 && ((1L << (_la - 64)) & ((1L << (WHILE - 64)) | (1L << (DO - 64)) | (1L << (FOR - 64)) | (1L << (SWITCH - 64)) | (1L << (RETURN - 64)) | (1L << (BREAK - 64)) | (1L << (CONTINUE - 64)) | (1L << (ASM - 64)) | (1L << (STRUCT - 64)) | (1L << (ENUM - 64)) | (1L << (SIZEOF - 64)) | (1L << (TYPEID - 64)) | (1L << (KICKASM - 64)) | (1L << (LOGIC_NOT - 64)) | (1L << (SIGNEDNESS - 64)) | (1L << (SIMPLETYPE - 64)) | (1L << (BOOLEAN - 64)) | (1L << (STRING - 64)) | (1L << (CHAR - 64)) | (1L << (NUMBER - 64)) | (1L << (NAME - 64)))) != 0)) {
				{
				setState(172);
				stmtSeq();
				}
			}

			setState(175);
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
		enterRule(_localctx, 24, RULE_parameterListDecl);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(177);
			parameterDecl();
			setState(182);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==COMMA) {
				{
				{
				setState(178);
				match(COMMA);
				setState(179);
				parameterDecl();
				}
				}
				setState(184);
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
	public static class ParameterDeclTypeContext extends ParameterDeclContext {
		public DeclTypesContext declTypes() {
			return getRuleContext(DeclTypesContext.class,0);
		}
		public TerminalNode NAME() { return getToken(KickCParser.NAME, 0); }
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
		enterRule(_localctx, 26, RULE_parameterDecl);
		try {
			setState(189);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,11,_ctx) ) {
			case 1:
				_localctx = new ParameterDeclTypeContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(185);
				declTypes();
				setState(186);
				match(NAME);
				}
				break;
			case 2:
				_localctx = new ParameterDeclVoidContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(188);
				match(SIMPLETYPE);
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
	public static class GlobalDirectiveReserveContext extends GlobalDirectiveContext {
		public TerminalNode PAR_BEGIN() { return getToken(KickCParser.PAR_BEGIN, 0); }
		public List<TerminalNode> NUMBER() { return getTokens(KickCParser.NUMBER); }
		public TerminalNode NUMBER(int i) {
			return getToken(KickCParser.NUMBER, i);
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
		enterRule(_localctx, 28, RULE_globalDirective);
		int _la;
		try {
			setState(252);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,13,_ctx) ) {
			case 1:
				_localctx = new GlobalDirectiveReserveContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				{
				setState(191);
				match(PRAGMA);
				setState(192);
				match(RESERVE);
				}
				setState(194);
				match(PAR_BEGIN);
				setState(195);
				match(NUMBER);
				setState(200);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (_la==COMMA) {
					{
					{
					setState(196);
					match(COMMA);
					setState(197);
					match(NUMBER);
					}
					}
					setState(202);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				setState(203);
				match(PAR_END);
				}
				break;
			case 2:
				_localctx = new GlobalDirectivePcContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				{
				setState(204);
				match(PRAGMA);
				setState(205);
				match(PC);
				}
				setState(207);
				match(PAR_BEGIN);
				setState(208);
				match(NUMBER);
				setState(209);
				match(PAR_END);
				}
				break;
			case 3:
				_localctx = new GlobalDirectivePlatformContext(_localctx);
				enterOuterAlt(_localctx, 3);
				{
				{
				setState(210);
				match(PRAGMA);
				setState(211);
				match(TARGET);
				}
				setState(213);
				match(PAR_BEGIN);
				setState(214);
				match(NAME);
				setState(215);
				match(PAR_END);
				}
				break;
			case 4:
				_localctx = new GlobalDirectiveCpuContext(_localctx);
				enterOuterAlt(_localctx, 4);
				{
				{
				setState(216);
				match(PRAGMA);
				setState(217);
				match(CPU);
				}
				setState(219);
				match(PAR_BEGIN);
				setState(220);
				match(NAME);
				setState(221);
				match(PAR_END);
				}
				break;
			case 5:
				_localctx = new GlobalDirectiveLinkScriptContext(_localctx);
				enterOuterAlt(_localctx, 5);
				{
				{
				setState(222);
				match(PRAGMA);
				setState(223);
				match(LINK);
				}
				setState(225);
				match(PAR_BEGIN);
				setState(226);
				match(STRING);
				setState(227);
				match(PAR_END);
				}
				break;
			case 6:
				_localctx = new GlobalDirectiveCodeSegContext(_localctx);
				enterOuterAlt(_localctx, 6);
				{
				{
				setState(228);
				match(PRAGMA);
				setState(229);
				match(CODESEG);
				}
				setState(231);
				match(PAR_BEGIN);
				setState(232);
				match(NAME);
				setState(233);
				match(PAR_END);
				}
				break;
			case 7:
				_localctx = new GlobalDirectiveDataSegContext(_localctx);
				enterOuterAlt(_localctx, 7);
				{
				{
				setState(234);
				match(PRAGMA);
				setState(235);
				match(DATASEG);
				}
				setState(237);
				match(PAR_BEGIN);
				setState(238);
				match(NAME);
				setState(239);
				match(PAR_END);
				}
				break;
			case 8:
				_localctx = new GlobalDirectiveEncodingContext(_localctx);
				enterOuterAlt(_localctx, 8);
				{
				{
				setState(240);
				match(PRAGMA);
				setState(241);
				match(ENCODING);
				}
				setState(243);
				match(PAR_BEGIN);
				setState(244);
				match(NAME);
				setState(245);
				match(PAR_END);
				}
				break;
			case 9:
				_localctx = new GlobalDirectiveCallingContext(_localctx);
				enterOuterAlt(_localctx, 9);
				{
				{
				setState(246);
				match(PRAGMA);
				setState(247);
				match(CALLING);
				}
				setState(249);
				match(PAR_BEGIN);
				setState(250);
				match(CALLINGCONVENTION);
				setState(251);
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
	public static class DirectiveMemoryAreaContext extends DirectiveContext {
		public TerminalNode ZEROPAGE() { return getToken(KickCParser.ZEROPAGE, 0); }
		public TerminalNode MAINMEM() { return getToken(KickCParser.MAINMEM, 0); }
		public TerminalNode PAR_BEGIN() { return getToken(KickCParser.PAR_BEGIN, 0); }
		public TerminalNode PAR_END() { return getToken(KickCParser.PAR_END, 0); }
		public TerminalNode NUMBER() { return getToken(KickCParser.NUMBER, 0); }
		public DirectiveMemoryAreaContext(DirectiveContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterDirectiveMemoryArea(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitDirectiveMemoryArea(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitDirectiveMemoryArea(this);
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
		public TerminalNode RESERVE() { return getToken(KickCParser.RESERVE, 0); }
		public TerminalNode PAR_BEGIN() { return getToken(KickCParser.PAR_BEGIN, 0); }
		public List<TerminalNode> NUMBER() { return getTokens(KickCParser.NUMBER); }
		public TerminalNode NUMBER(int i) {
			return getToken(KickCParser.NUMBER, i);
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
	public static class DirectiveMemoryContext extends DirectiveContext {
		public TerminalNode MEMORY() { return getToken(KickCParser.MEMORY, 0); }
		public DirectiveMemoryContext(DirectiveContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterDirectiveMemory(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitDirectiveMemory(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitDirectiveMemory(this);
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

	public final DirectiveContext directive() throws RecognitionException {
		DirectiveContext _localctx = new DirectiveContext(_ctx, getState());
		enterRule(_localctx, 30, RULE_directive);
		int _la;
		try {
			setState(294);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case CONST:
				_localctx = new DirectiveConstContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(254);
				match(CONST);
				}
				break;
			case EXTERN:
				_localctx = new DirectiveExternContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(255);
				match(EXTERN);
				}
				break;
			case EXPORT:
				_localctx = new DirectiveExportContext(_localctx);
				enterOuterAlt(_localctx, 3);
				{
				setState(256);
				match(EXPORT);
				}
				break;
			case ALIGN:
				_localctx = new DirectiveAlignContext(_localctx);
				enterOuterAlt(_localctx, 4);
				{
				setState(257);
				match(ALIGN);
				setState(258);
				match(PAR_BEGIN);
				setState(259);
				match(NUMBER);
				setState(260);
				match(PAR_END);
				}
				break;
			case REGISTER:
				_localctx = new DirectiveRegisterContext(_localctx);
				enterOuterAlt(_localctx, 5);
				{
				setState(261);
				match(REGISTER);
				setState(265);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,14,_ctx) ) {
				case 1:
					{
					setState(262);
					match(PAR_BEGIN);
					{
					setState(263);
					match(NAME);
					}
					setState(264);
					match(PAR_END);
					}
					break;
				}
				}
				break;
			case MEMORY:
				_localctx = new DirectiveMemoryContext(_localctx);
				enterOuterAlt(_localctx, 6);
				{
				setState(267);
				match(MEMORY);
				}
				break;
			case ZEROPAGE:
			case MAINMEM:
				_localctx = new DirectiveMemoryAreaContext(_localctx);
				enterOuterAlt(_localctx, 7);
				{
				setState(268);
				_la = _input.LA(1);
				if ( !(_la==ZEROPAGE || _la==MAINMEM) ) {
				_errHandler.recoverInline(this);
				}
				else {
					if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
					_errHandler.reportMatch(this);
					consume();
				}
				setState(272);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,15,_ctx) ) {
				case 1:
					{
					setState(269);
					match(PAR_BEGIN);
					{
					setState(270);
					match(NUMBER);
					}
					setState(271);
					match(PAR_END);
					}
					break;
				}
				}
				break;
			case INLINE:
				_localctx = new DirectiveInlineContext(_localctx);
				enterOuterAlt(_localctx, 8);
				{
				setState(274);
				match(INLINE);
				}
				break;
			case VOLATILE:
				_localctx = new DirectiveVolatileContext(_localctx);
				enterOuterAlt(_localctx, 9);
				{
				setState(275);
				match(VOLATILE);
				}
				break;
			case INTERRUPT:
				_localctx = new DirectiveInterruptContext(_localctx);
				enterOuterAlt(_localctx, 10);
				{
				setState(276);
				match(INTERRUPT);
				setState(280);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,16,_ctx) ) {
				case 1:
					{
					setState(277);
					match(PAR_BEGIN);
					setState(278);
					match(NAME);
					setState(279);
					match(PAR_END);
					}
					break;
				}
				}
				break;
			case RESERVE:
				_localctx = new DirectiveReserveZpContext(_localctx);
				enterOuterAlt(_localctx, 11);
				{
				setState(282);
				match(RESERVE);
				setState(283);
				match(PAR_BEGIN);
				setState(284);
				match(NUMBER);
				setState(289);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (_la==COMMA) {
					{
					{
					setState(285);
					match(COMMA);
					setState(286);
					match(NUMBER);
					}
					}
					setState(291);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				setState(292);
				match(PAR_END);
				}
				break;
			case CALLINGCONVENTION:
				_localctx = new DirectiveCallingConventionContext(_localctx);
				enterOuterAlt(_localctx, 12);
				{
				setState(293);
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
		enterRule(_localctx, 32, RULE_stmtSeq);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(297); 
			_errHandler.sync(this);
			_la = _input.LA(1);
			do {
				{
				{
				setState(296);
				stmt();
				}
				}
				setState(299); 
				_errHandler.sync(this);
				_la = _input.LA(1);
			} while ( (((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << TYPEDEFNAME) | (1L << CURLY_BEGIN) | (1L << PAR_BEGIN) | (1L << PLUS) | (1L << MINUS) | (1L << ASTERISK) | (1L << INC) | (1L << DEC) | (1L << AND) | (1L << BIT_NOT) | (1L << LESS_THAN) | (1L << GREATER_THAN) | (1L << RESERVE) | (1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << REGISTER) | (1L << MEMORY) | (1L << ZEROPAGE) | (1L << MAINMEM) | (1L << INLINE) | (1L << VOLATILE) | (1L << INTERRUPT) | (1L << CALLINGCONVENTION) | (1L << IF))) != 0) || ((((_la - 64)) & ~0x3f) == 0 && ((1L << (_la - 64)) & ((1L << (WHILE - 64)) | (1L << (DO - 64)) | (1L << (FOR - 64)) | (1L << (SWITCH - 64)) | (1L << (RETURN - 64)) | (1L << (BREAK - 64)) | (1L << (CONTINUE - 64)) | (1L << (ASM - 64)) | (1L << (STRUCT - 64)) | (1L << (ENUM - 64)) | (1L << (SIZEOF - 64)) | (1L << (TYPEID - 64)) | (1L << (KICKASM - 64)) | (1L << (LOGIC_NOT - 64)) | (1L << (SIGNEDNESS - 64)) | (1L << (SIMPLETYPE - 64)) | (1L << (BOOLEAN - 64)) | (1L << (STRING - 64)) | (1L << (CHAR - 64)) | (1L << (NUMBER - 64)) | (1L << (NAME - 64)))) != 0) );
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
		enterRule(_localctx, 34, RULE_stmt);
		int _la;
		try {
			setState(385);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,27,_ctx) ) {
			case 1:
				_localctx = new StmtDeclVarContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(301);
				declVariables();
				setState(302);
				match(SEMICOLON);
				}
				break;
			case 2:
				_localctx = new StmtBlockContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(304);
				match(CURLY_BEGIN);
				setState(306);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << TYPEDEFNAME) | (1L << CURLY_BEGIN) | (1L << PAR_BEGIN) | (1L << PLUS) | (1L << MINUS) | (1L << ASTERISK) | (1L << INC) | (1L << DEC) | (1L << AND) | (1L << BIT_NOT) | (1L << LESS_THAN) | (1L << GREATER_THAN) | (1L << RESERVE) | (1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << REGISTER) | (1L << MEMORY) | (1L << ZEROPAGE) | (1L << MAINMEM) | (1L << INLINE) | (1L << VOLATILE) | (1L << INTERRUPT) | (1L << CALLINGCONVENTION) | (1L << IF))) != 0) || ((((_la - 64)) & ~0x3f) == 0 && ((1L << (_la - 64)) & ((1L << (WHILE - 64)) | (1L << (DO - 64)) | (1L << (FOR - 64)) | (1L << (SWITCH - 64)) | (1L << (RETURN - 64)) | (1L << (BREAK - 64)) | (1L << (CONTINUE - 64)) | (1L << (ASM - 64)) | (1L << (STRUCT - 64)) | (1L << (ENUM - 64)) | (1L << (SIZEOF - 64)) | (1L << (TYPEID - 64)) | (1L << (KICKASM - 64)) | (1L << (LOGIC_NOT - 64)) | (1L << (SIGNEDNESS - 64)) | (1L << (SIMPLETYPE - 64)) | (1L << (BOOLEAN - 64)) | (1L << (STRING - 64)) | (1L << (CHAR - 64)) | (1L << (NUMBER - 64)) | (1L << (NAME - 64)))) != 0)) {
					{
					setState(305);
					stmtSeq();
					}
				}

				setState(308);
				match(CURLY_END);
				}
				break;
			case 3:
				_localctx = new StmtExprContext(_localctx);
				enterOuterAlt(_localctx, 3);
				{
				setState(309);
				commaExpr(0);
				setState(310);
				match(SEMICOLON);
				}
				break;
			case 4:
				_localctx = new StmtIfElseContext(_localctx);
				enterOuterAlt(_localctx, 4);
				{
				setState(312);
				match(IF);
				setState(313);
				match(PAR_BEGIN);
				setState(314);
				commaExpr(0);
				setState(315);
				match(PAR_END);
				setState(316);
				stmt();
				setState(319);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,21,_ctx) ) {
				case 1:
					{
					setState(317);
					match(ELSE);
					setState(318);
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
				setState(324);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << RESERVE) | (1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << REGISTER) | (1L << MEMORY) | (1L << ZEROPAGE) | (1L << MAINMEM) | (1L << INLINE) | (1L << VOLATILE) | (1L << INTERRUPT) | (1L << CALLINGCONVENTION))) != 0)) {
					{
					{
					setState(321);
					directive();
					}
					}
					setState(326);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				setState(327);
				match(WHILE);
				setState(328);
				match(PAR_BEGIN);
				setState(329);
				commaExpr(0);
				setState(330);
				match(PAR_END);
				setState(331);
				stmt();
				}
				break;
			case 6:
				_localctx = new StmtDoWhileContext(_localctx);
				enterOuterAlt(_localctx, 6);
				{
				setState(336);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << RESERVE) | (1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << REGISTER) | (1L << MEMORY) | (1L << ZEROPAGE) | (1L << MAINMEM) | (1L << INLINE) | (1L << VOLATILE) | (1L << INTERRUPT) | (1L << CALLINGCONVENTION))) != 0)) {
					{
					{
					setState(333);
					directive();
					}
					}
					setState(338);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				setState(339);
				match(DO);
				setState(340);
				stmt();
				setState(341);
				match(WHILE);
				setState(342);
				match(PAR_BEGIN);
				setState(343);
				commaExpr(0);
				setState(344);
				match(PAR_END);
				setState(345);
				match(SEMICOLON);
				}
				break;
			case 7:
				_localctx = new StmtForContext(_localctx);
				enterOuterAlt(_localctx, 7);
				{
				setState(350);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << RESERVE) | (1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << REGISTER) | (1L << MEMORY) | (1L << ZEROPAGE) | (1L << MAINMEM) | (1L << INLINE) | (1L << VOLATILE) | (1L << INTERRUPT) | (1L << CALLINGCONVENTION))) != 0)) {
					{
					{
					setState(347);
					directive();
					}
					}
					setState(352);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				setState(353);
				match(FOR);
				setState(354);
				match(PAR_BEGIN);
				setState(355);
				forLoop();
				setState(356);
				match(PAR_END);
				setState(357);
				stmt();
				}
				break;
			case 8:
				_localctx = new StmtSwitchContext(_localctx);
				enterOuterAlt(_localctx, 8);
				{
				setState(359);
				match(SWITCH);
				setState(360);
				match(PAR_BEGIN);
				setState(361);
				commaExpr(0);
				setState(362);
				match(PAR_END);
				setState(363);
				match(CURLY_BEGIN);
				setState(364);
				switchCases();
				setState(365);
				match(CURLY_END);
				}
				break;
			case 9:
				_localctx = new StmtReturnContext(_localctx);
				enterOuterAlt(_localctx, 9);
				{
				setState(367);
				match(RETURN);
				setState(369);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << CURLY_BEGIN) | (1L << PAR_BEGIN) | (1L << PLUS) | (1L << MINUS) | (1L << ASTERISK) | (1L << INC) | (1L << DEC) | (1L << AND) | (1L << BIT_NOT) | (1L << LESS_THAN) | (1L << GREATER_THAN))) != 0) || ((((_la - 76)) & ~0x3f) == 0 && ((1L << (_la - 76)) & ((1L << (SIZEOF - 76)) | (1L << (TYPEID - 76)) | (1L << (LOGIC_NOT - 76)) | (1L << (BOOLEAN - 76)) | (1L << (STRING - 76)) | (1L << (CHAR - 76)) | (1L << (NUMBER - 76)) | (1L << (NAME - 76)))) != 0)) {
					{
					setState(368);
					commaExpr(0);
					}
				}

				setState(371);
				match(SEMICOLON);
				}
				break;
			case 10:
				_localctx = new StmtBreakContext(_localctx);
				enterOuterAlt(_localctx, 10);
				{
				setState(372);
				match(BREAK);
				setState(373);
				match(SEMICOLON);
				}
				break;
			case 11:
				_localctx = new StmtContinueContext(_localctx);
				enterOuterAlt(_localctx, 11);
				{
				setState(374);
				match(CONTINUE);
				setState(375);
				match(SEMICOLON);
				}
				break;
			case 12:
				_localctx = new StmtAsmContext(_localctx);
				enterOuterAlt(_localctx, 12);
				{
				setState(376);
				match(ASM);
				setState(378);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if (_la==PAR_BEGIN) {
					{
					setState(377);
					asmDirectives();
					}
				}

				setState(380);
				match(CURLY_BEGIN);
				setState(381);
				asmLines();
				setState(382);
				match(ASM_CURLY_END);
				}
				break;
			case 13:
				_localctx = new StmtDeclKasmContext(_localctx);
				enterOuterAlt(_localctx, 13);
				{
				setState(384);
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
		enterRule(_localctx, 36, RULE_switchCases);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(388); 
			_errHandler.sync(this);
			_la = _input.LA(1);
			do {
				{
				{
				setState(387);
				switchCase();
				}
				}
				setState(390); 
				_errHandler.sync(this);
				_la = _input.LA(1);
			} while ( _la==CASE );
			setState(397);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==DEFAULT) {
				{
				setState(392);
				match(DEFAULT);
				setState(393);
				match(COLON);
				setState(395);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << TYPEDEFNAME) | (1L << CURLY_BEGIN) | (1L << PAR_BEGIN) | (1L << PLUS) | (1L << MINUS) | (1L << ASTERISK) | (1L << INC) | (1L << DEC) | (1L << AND) | (1L << BIT_NOT) | (1L << LESS_THAN) | (1L << GREATER_THAN) | (1L << RESERVE) | (1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << REGISTER) | (1L << MEMORY) | (1L << ZEROPAGE) | (1L << MAINMEM) | (1L << INLINE) | (1L << VOLATILE) | (1L << INTERRUPT) | (1L << CALLINGCONVENTION) | (1L << IF))) != 0) || ((((_la - 64)) & ~0x3f) == 0 && ((1L << (_la - 64)) & ((1L << (WHILE - 64)) | (1L << (DO - 64)) | (1L << (FOR - 64)) | (1L << (SWITCH - 64)) | (1L << (RETURN - 64)) | (1L << (BREAK - 64)) | (1L << (CONTINUE - 64)) | (1L << (ASM - 64)) | (1L << (STRUCT - 64)) | (1L << (ENUM - 64)) | (1L << (SIZEOF - 64)) | (1L << (TYPEID - 64)) | (1L << (KICKASM - 64)) | (1L << (LOGIC_NOT - 64)) | (1L << (SIGNEDNESS - 64)) | (1L << (SIMPLETYPE - 64)) | (1L << (BOOLEAN - 64)) | (1L << (STRING - 64)) | (1L << (CHAR - 64)) | (1L << (NUMBER - 64)) | (1L << (NAME - 64)))) != 0)) {
					{
					setState(394);
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
		enterRule(_localctx, 38, RULE_switchCase);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(399);
			match(CASE);
			setState(400);
			expr(0);
			setState(401);
			match(COLON);
			setState(403);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << TYPEDEFNAME) | (1L << CURLY_BEGIN) | (1L << PAR_BEGIN) | (1L << PLUS) | (1L << MINUS) | (1L << ASTERISK) | (1L << INC) | (1L << DEC) | (1L << AND) | (1L << BIT_NOT) | (1L << LESS_THAN) | (1L << GREATER_THAN) | (1L << RESERVE) | (1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << REGISTER) | (1L << MEMORY) | (1L << ZEROPAGE) | (1L << MAINMEM) | (1L << INLINE) | (1L << VOLATILE) | (1L << INTERRUPT) | (1L << CALLINGCONVENTION) | (1L << IF))) != 0) || ((((_la - 64)) & ~0x3f) == 0 && ((1L << (_la - 64)) & ((1L << (WHILE - 64)) | (1L << (DO - 64)) | (1L << (FOR - 64)) | (1L << (SWITCH - 64)) | (1L << (RETURN - 64)) | (1L << (BREAK - 64)) | (1L << (CONTINUE - 64)) | (1L << (ASM - 64)) | (1L << (STRUCT - 64)) | (1L << (ENUM - 64)) | (1L << (SIZEOF - 64)) | (1L << (TYPEID - 64)) | (1L << (KICKASM - 64)) | (1L << (LOGIC_NOT - 64)) | (1L << (SIGNEDNESS - 64)) | (1L << (SIMPLETYPE - 64)) | (1L << (BOOLEAN - 64)) | (1L << (STRING - 64)) | (1L << (CHAR - 64)) | (1L << (NUMBER - 64)) | (1L << (NAME - 64)))) != 0)) {
				{
				setState(402);
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
		public DeclTypesContext declTypes() {
			return getRuleContext(DeclTypesContext.class,0);
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
		enterRule(_localctx, 40, RULE_forLoop);
		int _la;
		try {
			setState(421);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,34,_ctx) ) {
			case 1:
				_localctx = new ForClassicContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(405);
				forClassicInit();
				setState(406);
				match(SEMICOLON);
				setState(407);
				commaExpr(0);
				setState(408);
				match(SEMICOLON);
				setState(410);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << CURLY_BEGIN) | (1L << PAR_BEGIN) | (1L << PLUS) | (1L << MINUS) | (1L << ASTERISK) | (1L << INC) | (1L << DEC) | (1L << AND) | (1L << BIT_NOT) | (1L << LESS_THAN) | (1L << GREATER_THAN))) != 0) || ((((_la - 76)) & ~0x3f) == 0 && ((1L << (_la - 76)) & ((1L << (SIZEOF - 76)) | (1L << (TYPEID - 76)) | (1L << (LOGIC_NOT - 76)) | (1L << (BOOLEAN - 76)) | (1L << (STRING - 76)) | (1L << (CHAR - 76)) | (1L << (NUMBER - 76)) | (1L << (NAME - 76)))) != 0)) {
					{
					setState(409);
					commaExpr(0);
					}
				}

				}
				break;
			case 2:
				_localctx = new ForRangeContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(413);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << TYPEDEFNAME) | (1L << PAR_BEGIN) | (1L << RESERVE) | (1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << REGISTER) | (1L << MEMORY) | (1L << ZEROPAGE) | (1L << MAINMEM) | (1L << INLINE) | (1L << VOLATILE) | (1L << INTERRUPT) | (1L << CALLINGCONVENTION))) != 0) || ((((_la - 74)) & ~0x3f) == 0 && ((1L << (_la - 74)) & ((1L << (STRUCT - 74)) | (1L << (ENUM - 74)) | (1L << (SIGNEDNESS - 74)) | (1L << (SIMPLETYPE - 74)))) != 0)) {
					{
					setState(412);
					declTypes();
					}
				}

				setState(415);
				match(NAME);
				setState(416);
				match(COLON);
				setState(417);
				expr(0);
				setState(418);
				match(RANGE);
				setState(419);
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
		enterRule(_localctx, 42, RULE_forClassicInit);
		int _la;
		try {
			setState(427);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,36,_ctx) ) {
			case 1:
				_localctx = new ForClassicInitDeclContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(424);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << TYPEDEFNAME) | (1L << PAR_BEGIN) | (1L << RESERVE) | (1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << REGISTER) | (1L << MEMORY) | (1L << ZEROPAGE) | (1L << MAINMEM) | (1L << INLINE) | (1L << VOLATILE) | (1L << INTERRUPT) | (1L << CALLINGCONVENTION))) != 0) || ((((_la - 74)) & ~0x3f) == 0 && ((1L << (_la - 74)) & ((1L << (STRUCT - 74)) | (1L << (ENUM - 74)) | (1L << (SIGNEDNESS - 74)) | (1L << (SIMPLETYPE - 74)))) != 0)) {
					{
					setState(423);
					declVariables();
					}
				}

				}
				break;
			case 2:
				_localctx = new ForClassicInitExprContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(426);
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

	public static class TypeDeclContext extends ParserRuleContext {
		public TypeDeclContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_typeDecl; }
	 
		public TypeDeclContext() { }
		public void copyFrom(TypeDeclContext ctx) {
			super.copyFrom(ctx);
		}
	}
	public static class TypeParContext extends TypeDeclContext {
		public TerminalNode PAR_BEGIN() { return getToken(KickCParser.PAR_BEGIN, 0); }
		public TypeDeclContext typeDecl() {
			return getRuleContext(TypeDeclContext.class,0);
		}
		public TerminalNode PAR_END() { return getToken(KickCParser.PAR_END, 0); }
		public TypeParContext(TypeDeclContext ctx) { copyFrom(ctx); }
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
	public static class TypeProcedureContext extends TypeDeclContext {
		public TypeDeclContext typeDecl() {
			return getRuleContext(TypeDeclContext.class,0);
		}
		public TerminalNode PAR_BEGIN() { return getToken(KickCParser.PAR_BEGIN, 0); }
		public TerminalNode PAR_END() { return getToken(KickCParser.PAR_END, 0); }
		public TypeProcedureContext(TypeDeclContext ctx) { copyFrom(ctx); }
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
	public static class TypePtrContext extends TypeDeclContext {
		public TypeDeclContext typeDecl() {
			return getRuleContext(TypeDeclContext.class,0);
		}
		public TerminalNode ASTERISK() { return getToken(KickCParser.ASTERISK, 0); }
		public TypePtrContext(TypeDeclContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).enterTypePtr(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCParserListener ) ((KickCParserListener)listener).exitTypePtr(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCParserVisitor ) return ((KickCParserVisitor<? extends T>)visitor).visitTypePtr(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class TypeArrayContext extends TypeDeclContext {
		public TypeDeclContext typeDecl() {
			return getRuleContext(TypeDeclContext.class,0);
		}
		public TerminalNode BRACKET_BEGIN() { return getToken(KickCParser.BRACKET_BEGIN, 0); }
		public TerminalNode BRACKET_END() { return getToken(KickCParser.BRACKET_END, 0); }
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public TypeArrayContext(TypeDeclContext ctx) { copyFrom(ctx); }
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
	public static class TypeStructRefContext extends TypeDeclContext {
		public StructRefContext structRef() {
			return getRuleContext(StructRefContext.class,0);
		}
		public TypeStructRefContext(TypeDeclContext ctx) { copyFrom(ctx); }
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
	public static class TypeSimpleContext extends TypeDeclContext {
		public TerminalNode SIMPLETYPE() { return getToken(KickCParser.SIMPLETYPE, 0); }
		public TypeSimpleContext(TypeDeclContext ctx) { copyFrom(ctx); }
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
	public static class TypeStructDefContext extends TypeDeclContext {
		public StructDefContext structDef() {
			return getRuleContext(StructDefContext.class,0);
		}
		public TypeStructDefContext(TypeDeclContext ctx) { copyFrom(ctx); }
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
	public static class TypeNamedRefContext extends TypeDeclContext {
		public TerminalNode TYPEDEFNAME() { return getToken(KickCParser.TYPEDEFNAME, 0); }
		public TypeNamedRefContext(TypeDeclContext ctx) { copyFrom(ctx); }
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
	public static class TypeSignedSimpleContext extends TypeDeclContext {
		public TerminalNode SIGNEDNESS() { return getToken(KickCParser.SIGNEDNESS, 0); }
		public TerminalNode SIMPLETYPE() { return getToken(KickCParser.SIMPLETYPE, 0); }
		public TypeSignedSimpleContext(TypeDeclContext ctx) { copyFrom(ctx); }
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
	public static class TypeEnumRefContext extends TypeDeclContext {
		public EnumRefContext enumRef() {
			return getRuleContext(EnumRefContext.class,0);
		}
		public TypeEnumRefContext(TypeDeclContext ctx) { copyFrom(ctx); }
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
	public static class TypeEnumDefContext extends TypeDeclContext {
		public EnumDefContext enumDef() {
			return getRuleContext(EnumDefContext.class,0);
		}
		public TypeEnumDefContext(TypeDeclContext ctx) { copyFrom(ctx); }
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

	public final TypeDeclContext typeDecl() throws RecognitionException {
		return typeDecl(0);
	}

	private TypeDeclContext typeDecl(int _p) throws RecognitionException {
		ParserRuleContext _parentctx = _ctx;
		int _parentState = getState();
		TypeDeclContext _localctx = new TypeDeclContext(_ctx, _parentState);
		TypeDeclContext _prevctx = _localctx;
		int _startState = 44;
		enterRecursionRule(_localctx, 44, RULE_typeDecl, _p);
		int _la;
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(444);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,38,_ctx) ) {
			case 1:
				{
				_localctx = new TypeParContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;

				setState(430);
				match(PAR_BEGIN);
				setState(431);
				typeDecl(0);
				setState(432);
				match(PAR_END);
				}
				break;
			case 2:
				{
				_localctx = new TypeSimpleContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(434);
				match(SIMPLETYPE);
				}
				break;
			case 3:
				{
				_localctx = new TypeSignedSimpleContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(435);
				match(SIGNEDNESS);
				setState(437);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,37,_ctx) ) {
				case 1:
					{
					setState(436);
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
				setState(439);
				structDef();
				}
				break;
			case 5:
				{
				_localctx = new TypeStructRefContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(440);
				structRef();
				}
				break;
			case 6:
				{
				_localctx = new TypeEnumDefContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(441);
				enumDef();
				}
				break;
			case 7:
				{
				_localctx = new TypeEnumRefContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(442);
				enumRef();
				}
				break;
			case 8:
				{
				_localctx = new TypeNamedRefContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(443);
				match(TYPEDEFNAME);
				}
				break;
			}
			_ctx.stop = _input.LT(-1);
			setState(459);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,41,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					setState(457);
					_errHandler.sync(this);
					switch ( getInterpreter().adaptivePredict(_input,40,_ctx) ) {
					case 1:
						{
						_localctx = new TypePtrContext(new TypeDeclContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_typeDecl);
						setState(446);
						if (!(precpred(_ctx, 8))) throw new FailedPredicateException(this, "precpred(_ctx, 8)");
						setState(447);
						match(ASTERISK);
						}
						break;
					case 2:
						{
						_localctx = new TypeArrayContext(new TypeDeclContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_typeDecl);
						setState(448);
						if (!(precpred(_ctx, 7))) throw new FailedPredicateException(this, "precpred(_ctx, 7)");
						setState(449);
						match(BRACKET_BEGIN);
						setState(451);
						_errHandler.sync(this);
						_la = _input.LA(1);
						if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << CURLY_BEGIN) | (1L << PAR_BEGIN) | (1L << PLUS) | (1L << MINUS) | (1L << ASTERISK) | (1L << INC) | (1L << DEC) | (1L << AND) | (1L << BIT_NOT) | (1L << LESS_THAN) | (1L << GREATER_THAN))) != 0) || ((((_la - 76)) & ~0x3f) == 0 && ((1L << (_la - 76)) & ((1L << (SIZEOF - 76)) | (1L << (TYPEID - 76)) | (1L << (LOGIC_NOT - 76)) | (1L << (BOOLEAN - 76)) | (1L << (STRING - 76)) | (1L << (CHAR - 76)) | (1L << (NUMBER - 76)) | (1L << (NAME - 76)))) != 0)) {
							{
							setState(450);
							expr(0);
							}
						}

						setState(453);
						match(BRACKET_END);
						}
						break;
					case 3:
						{
						_localctx = new TypeProcedureContext(new TypeDeclContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_typeDecl);
						setState(454);
						if (!(precpred(_ctx, 6))) throw new FailedPredicateException(this, "precpred(_ctx, 6)");
						setState(455);
						match(PAR_BEGIN);
						setState(456);
						match(PAR_END);
						}
						break;
					}
					} 
				}
				setState(461);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,41,_ctx);
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
		enterRule(_localctx, 46, RULE_structRef);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(462);
			match(STRUCT);
			setState(463);
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
		enterRule(_localctx, 48, RULE_structDef);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(465);
			match(STRUCT);
			setState(467);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==NAME) {
				{
				setState(466);
				match(NAME);
				}
			}

			setState(469);
			match(CURLY_BEGIN);
			setState(471); 
			_errHandler.sync(this);
			_la = _input.LA(1);
			do {
				{
				{
				setState(470);
				structMembers();
				}
				}
				setState(473); 
				_errHandler.sync(this);
				_la = _input.LA(1);
			} while ( (((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << TYPEDEFNAME) | (1L << PAR_BEGIN) | (1L << RESERVE) | (1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << REGISTER) | (1L << MEMORY) | (1L << ZEROPAGE) | (1L << MAINMEM) | (1L << INLINE) | (1L << VOLATILE) | (1L << INTERRUPT) | (1L << CALLINGCONVENTION))) != 0) || ((((_la - 74)) & ~0x3f) == 0 && ((1L << (_la - 74)) & ((1L << (STRUCT - 74)) | (1L << (ENUM - 74)) | (1L << (SIGNEDNESS - 74)) | (1L << (SIMPLETYPE - 74)))) != 0) );
			setState(475);
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
		enterRule(_localctx, 50, RULE_structMembers);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(477);
			declVariables();
			setState(478);
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
		enterRule(_localctx, 52, RULE_enumRef);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(480);
			match(ENUM);
			setState(481);
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
		enterRule(_localctx, 54, RULE_enumDef);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(483);
			match(ENUM);
			setState(485);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==NAME) {
				{
				setState(484);
				match(NAME);
				}
			}

			setState(487);
			match(CURLY_BEGIN);
			setState(488);
			enumMemberList(0);
			setState(489);
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
		int _startState = 56;
		enterRecursionRule(_localctx, 56, RULE_enumMemberList, _p);
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			{
			setState(492);
			enumMember();
			}
			_ctx.stop = _input.LT(-1);
			setState(499);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,45,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					{
					_localctx = new EnumMemberListContext(_parentctx, _parentState);
					pushNewRecursionContext(_localctx, _startState, RULE_enumMemberList);
					setState(494);
					if (!(precpred(_ctx, 1))) throw new FailedPredicateException(this, "precpred(_ctx, 1)");
					setState(495);
					match(COMMA);
					setState(496);
					enumMember();
					}
					} 
				}
				setState(501);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,45,_ctx);
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
		enterRule(_localctx, 58, RULE_enumMember);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(502);
			match(NAME);
			setState(505);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,46,_ctx) ) {
			case 1:
				{
				setState(503);
				match(ASSIGN);
				setState(504);
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
		int _startState = 60;
		enterRecursionRule(_localctx, 60, RULE_commaExpr, _p);
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			{
			_localctx = new CommaNoneContext(_localctx);
			_ctx = _localctx;
			_prevctx = _localctx;

			setState(508);
			expr(0);
			}
			_ctx.stop = _input.LT(-1);
			setState(515);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,47,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					{
					_localctx = new CommaSimpleContext(new CommaExprContext(_parentctx, _parentState));
					pushNewRecursionContext(_localctx, _startState, RULE_commaExpr);
					setState(510);
					if (!(precpred(_ctx, 1))) throw new FailedPredicateException(this, "precpred(_ctx, 1)");
					setState(511);
					match(COMMA);
					setState(512);
					expr(0);
					}
					} 
				}
				setState(517);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,47,_ctx);
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
		public TerminalNode PLUS() { return getToken(KickCParser.PLUS, 0); }
		public TerminalNode MINUS() { return getToken(KickCParser.MINUS, 0); }
		public TerminalNode LESS_THAN() { return getToken(KickCParser.LESS_THAN, 0); }
		public TerminalNode GREATER_THAN() { return getToken(KickCParser.GREATER_THAN, 0); }
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
		public TypeDeclContext typeDecl() {
			return getRuleContext(TypeDeclContext.class,0);
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
		public TypeDeclContext typeDecl() {
			return getRuleContext(TypeDeclContext.class,0);
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
		public TypeDeclContext typeDecl() {
			return getRuleContext(TypeDeclContext.class,0);
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
	public static class ExprTernaryContext extends ExprContext {
		public List<ExprContext> expr() {
			return getRuleContexts(ExprContext.class);
		}
		public ExprContext expr(int i) {
			return getRuleContext(ExprContext.class,i);
		}
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
		int _startState = 62;
		enterRecursionRule(_localctx, 62, RULE_expr, _p);
		int _la;
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(572);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,52,_ctx) ) {
			case 1:
				{
				_localctx = new ExprParContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;

				setState(519);
				match(PAR_BEGIN);
				setState(520);
				commaExpr(0);
				setState(521);
				match(PAR_END);
				}
				break;
			case 2:
				{
				_localctx = new ExprSizeOfContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(523);
				match(SIZEOF);
				setState(524);
				match(PAR_BEGIN);
				setState(527);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,48,_ctx) ) {
				case 1:
					{
					setState(525);
					expr(0);
					}
					break;
				case 2:
					{
					setState(526);
					typeDecl(0);
					}
					break;
				}
				setState(529);
				match(PAR_END);
				}
				break;
			case 3:
				{
				_localctx = new ExprTypeIdContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(531);
				match(TYPEID);
				setState(532);
				match(PAR_BEGIN);
				setState(535);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,49,_ctx) ) {
				case 1:
					{
					setState(533);
					expr(0);
					}
					break;
				case 2:
					{
					setState(534);
					typeDecl(0);
					}
					break;
				}
				setState(537);
				match(PAR_END);
				}
				break;
			case 4:
				{
				_localctx = new ExprCastContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(539);
				match(PAR_BEGIN);
				setState(540);
				typeDecl(0);
				setState(541);
				match(PAR_END);
				setState(542);
				expr(24);
				}
				break;
			case 5:
				{
				_localctx = new ExprPreModContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(544);
				_la = _input.LA(1);
				if ( !(_la==INC || _la==DEC) ) {
				_errHandler.recoverInline(this);
				}
				else {
					if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
					_errHandler.reportMatch(this);
					consume();
				}
				setState(545);
				expr(23);
				}
				break;
			case 6:
				{
				_localctx = new ExprPtrContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(546);
				match(ASTERISK);
				setState(547);
				expr(21);
				}
				break;
			case 7:
				{
				_localctx = new ExprUnaryContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(548);
				_la = _input.LA(1);
				if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << PLUS) | (1L << MINUS) | (1L << AND) | (1L << BIT_NOT))) != 0) || _la==LOGIC_NOT) ) {
				_errHandler.recoverInline(this);
				}
				else {
					if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
					_errHandler.reportMatch(this);
					consume();
				}
				setState(549);
				expr(20);
				}
				break;
			case 8:
				{
				_localctx = new ExprUnaryContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(550);
				_la = _input.LA(1);
				if ( !(_la==LESS_THAN || _la==GREATER_THAN) ) {
				_errHandler.recoverInline(this);
				}
				else {
					if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
					_errHandler.reportMatch(this);
					consume();
				}
				setState(551);
				expr(16);
				}
				break;
			case 9:
				{
				_localctx = new InitListContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(552);
				match(CURLY_BEGIN);
				setState(553);
				expr(0);
				setState(558);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (_la==COMMA) {
					{
					{
					setState(554);
					match(COMMA);
					setState(555);
					expr(0);
					}
					}
					setState(560);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				setState(561);
				match(CURLY_END);
				}
				break;
			case 10:
				{
				_localctx = new ExprIdContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(563);
				match(NAME);
				}
				break;
			case 11:
				{
				_localctx = new ExprNumberContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(564);
				match(NUMBER);
				}
				break;
			case 12:
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
					_alt = getInterpreter().adaptivePredict(_input,51,_ctx);
				} while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER );
				}
				break;
			case 13:
				{
				_localctx = new ExprCharContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(570);
				match(CHAR);
				}
				break;
			case 14:
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
			_alt = getInterpreter().adaptivePredict(_input,55,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					setState(632);
					_errHandler.sync(this);
					switch ( getInterpreter().adaptivePredict(_input,54,_ctx) ) {
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
						if (!(precpred(_ctx, 30))) throw new FailedPredicateException(this, "precpred(_ctx, 30)");
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
						if (!(precpred(_ctx, 29))) throw new FailedPredicateException(this, "precpred(_ctx, 29)");
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
						if (!(precpred(_ctx, 28))) throw new FailedPredicateException(this, "precpred(_ctx, 28)");
						setState(620);
						match(PAR_BEGIN);
						setState(622);
						_errHandler.sync(this);
						_la = _input.LA(1);
						if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << CURLY_BEGIN) | (1L << PAR_BEGIN) | (1L << PLUS) | (1L << MINUS) | (1L << ASTERISK) | (1L << INC) | (1L << DEC) | (1L << AND) | (1L << BIT_NOT) | (1L << LESS_THAN) | (1L << GREATER_THAN))) != 0) || ((((_la - 76)) & ~0x3f) == 0 && ((1L << (_la - 76)) & ((1L << (SIZEOF - 76)) | (1L << (TYPEID - 76)) | (1L << (LOGIC_NOT - 76)) | (1L << (BOOLEAN - 76)) | (1L << (STRING - 76)) | (1L << (CHAR - 76)) | (1L << (NUMBER - 76)) | (1L << (NAME - 76)))) != 0)) {
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
				_alt = getInterpreter().adaptivePredict(_input,55,_ctx);
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
		enterRule(_localctx, 64, RULE_parameterList);
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
		enterRule(_localctx, 66, RULE_declKasm);
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
		enterRule(_localctx, 68, RULE_asmDirectives);
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
		enterRule(_localctx, 70, RULE_asmDirective);
		try {
			setState(677);
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
			case PC:
				_localctx = new AsmDirectiveAddressContext(_localctx);
				enterOuterAlt(_localctx, 6);
				{
				setState(672);
				match(PC);
				setState(675);
				_errHandler.sync(this);
				switch (_input.LA(1)) {
				case INLINE:
					{
					setState(673);
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
				case LOGIC_NOT:
				case BOOLEAN:
				case STRING:
				case CHAR:
				case NUMBER:
				case NAME:
					{
					setState(674);
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
		enterRule(_localctx, 72, RULE_asmLines);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(682);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (((((_la - 104)) & ~0x3f) == 0 && ((1L << (_la - 104)) & ((1L << (ASM_BYTE - 104)) | (1L << (ASM_MNEMONIC - 104)) | (1L << (ASM_MULTI_NAME - 104)) | (1L << (ASM_NAME - 104)))) != 0)) {
				{
				{
				setState(679);
				asmLine();
				}
				}
				setState(684);
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
		enterRule(_localctx, 74, RULE_asmLine);
		try {
			setState(688);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case ASM_MULTI_NAME:
			case ASM_NAME:
				enterOuterAlt(_localctx, 1);
				{
				setState(685);
				asmLabel();
				}
				break;
			case ASM_MNEMONIC:
				enterOuterAlt(_localctx, 2);
				{
				setState(686);
				asmInstruction();
				}
				break;
			case ASM_BYTE:
				enterOuterAlt(_localctx, 3);
				{
				setState(687);
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
		enterRule(_localctx, 76, RULE_asmLabel);
		try {
			setState(694);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case ASM_NAME:
				_localctx = new AsmLabelNameContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(690);
				match(ASM_NAME);
				setState(691);
				match(ASM_COLON);
				}
				break;
			case ASM_MULTI_NAME:
				_localctx = new AsmLabelMultiContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(692);
				match(ASM_MULTI_NAME);
				setState(693);
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
		enterRule(_localctx, 78, RULE_asmInstruction);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(696);
			match(ASM_MNEMONIC);
			setState(698);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,64,_ctx) ) {
			case 1:
				{
				setState(697);
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
		enterRule(_localctx, 80, RULE_asmBytes);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(700);
			match(ASM_BYTE);
			setState(701);
			asmExpr(0);
			setState(706);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==ASM_COMMA) {
				{
				{
				setState(702);
				match(ASM_COMMA);
				setState(703);
				asmExpr(0);
				}
				}
				setState(708);
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
		enterRule(_localctx, 82, RULE_asmParamMode);
		try {
			setState(732);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,66,_ctx) ) {
			case 1:
				_localctx = new AsmModeAbsContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(709);
				asmExpr(0);
				}
				break;
			case 2:
				_localctx = new AsmModeImmContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(710);
				match(ASM_IMM);
				setState(711);
				asmExpr(0);
				}
				break;
			case 3:
				_localctx = new AsmModeAbsXYContext(_localctx);
				enterOuterAlt(_localctx, 3);
				{
				setState(712);
				asmExpr(0);
				setState(713);
				match(ASM_COMMA);
				setState(714);
				match(ASM_NAME);
				}
				break;
			case 4:
				_localctx = new AsmModeIndIdxXYContext(_localctx);
				enterOuterAlt(_localctx, 4);
				{
				setState(716);
				match(ASM_PAR_BEGIN);
				setState(717);
				asmExpr(0);
				setState(718);
				match(ASM_PAR_END);
				setState(719);
				match(ASM_COMMA);
				setState(720);
				match(ASM_NAME);
				}
				break;
			case 5:
				_localctx = new AsmModeIdxIndXYContext(_localctx);
				enterOuterAlt(_localctx, 5);
				{
				setState(722);
				match(ASM_PAR_BEGIN);
				setState(723);
				asmExpr(0);
				setState(724);
				match(ASM_COMMA);
				setState(725);
				match(ASM_NAME);
				setState(726);
				match(ASM_PAR_END);
				}
				break;
			case 6:
				_localctx = new AsmModeIndContext(_localctx);
				enterOuterAlt(_localctx, 6);
				{
				setState(728);
				match(ASM_PAR_BEGIN);
				setState(729);
				asmExpr(0);
				setState(730);
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
		int _startState = 84;
		enterRecursionRule(_localctx, 84, RULE_asmExpr, _p);
		int _la;
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(748);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case ASM_BRACKET_BEGIN:
				{
				_localctx = new AsmExprParContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;

				setState(735);
				match(ASM_BRACKET_BEGIN);
				setState(736);
				asmExpr(0);
				setState(737);
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
				setState(739);
				_la = _input.LA(1);
				if ( !(((((_la - 116)) & ~0x3f) == 0 && ((1L << (_la - 116)) & ((1L << (ASM_PLUS - 116)) | (1L << (ASM_MINUS - 116)) | (1L << (ASM_LESS_THAN - 116)) | (1L << (ASM_GREATER_THAN - 116)))) != 0)) ) {
				_errHandler.recoverInline(this);
				}
				else {
					if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
					_errHandler.reportMatch(this);
					consume();
				}
				setState(740);
				asmExpr(8);
				}
				break;
			case ASM_NAME:
				{
				_localctx = new AsmExprLabelContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(741);
				match(ASM_NAME);
				}
				break;
			case ASM_MULTI_REL:
				{
				_localctx = new AsmExprLabelRelContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(742);
				match(ASM_MULTI_REL);
				}
				break;
			case ASM_CURLY_BEGIN:
				{
				_localctx = new AsmExprReplaceContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(743);
				match(ASM_CURLY_BEGIN);
				setState(744);
				match(ASM_NAME);
				setState(745);
				match(ASM_CURLY_END);
				}
				break;
			case ASM_NUMBER:
				{
				_localctx = new AsmExprIntContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(746);
				match(ASM_NUMBER);
				}
				break;
			case ASM_CHAR:
				{
				_localctx = new AsmExprCharContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(747);
				match(ASM_CHAR);
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
			_ctx.stop = _input.LT(-1);
			setState(764);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,69,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					setState(762);
					_errHandler.sync(this);
					switch ( getInterpreter().adaptivePredict(_input,68,_ctx) ) {
					case 1:
						{
						_localctx = new AsmExprBinaryContext(new AsmExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_asmExpr);
						setState(750);
						if (!(precpred(_ctx, 10))) throw new FailedPredicateException(this, "precpred(_ctx, 10)");
						{
						setState(751);
						match(ASM_DOT);
						}
						setState(752);
						asmExpr(11);
						}
						break;
					case 2:
						{
						_localctx = new AsmExprBinaryContext(new AsmExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_asmExpr);
						setState(753);
						if (!(precpred(_ctx, 9))) throw new FailedPredicateException(this, "precpred(_ctx, 9)");
						setState(754);
						_la = _input.LA(1);
						if ( !(_la==ASM_SHIFT_LEFT || _la==ASM_SHIFT_RIGHT) ) {
						_errHandler.recoverInline(this);
						}
						else {
							if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
							_errHandler.reportMatch(this);
							consume();
						}
						setState(755);
						asmExpr(10);
						}
						break;
					case 3:
						{
						_localctx = new AsmExprBinaryContext(new AsmExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_asmExpr);
						setState(756);
						if (!(precpred(_ctx, 7))) throw new FailedPredicateException(this, "precpred(_ctx, 7)");
						setState(757);
						_la = _input.LA(1);
						if ( !(_la==ASM_MULTIPLY || _la==ASM_DIVIDE) ) {
						_errHandler.recoverInline(this);
						}
						else {
							if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
							_errHandler.reportMatch(this);
							consume();
						}
						setState(758);
						asmExpr(8);
						}
						break;
					case 4:
						{
						_localctx = new AsmExprBinaryContext(new AsmExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_asmExpr);
						setState(759);
						if (!(precpred(_ctx, 6))) throw new FailedPredicateException(this, "precpred(_ctx, 6)");
						setState(760);
						_la = _input.LA(1);
						if ( !(_la==ASM_PLUS || _la==ASM_MINUS) ) {
						_errHandler.recoverInline(this);
						}
						else {
							if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
							_errHandler.reportMatch(this);
							consume();
						}
						setState(761);
						asmExpr(7);
						}
						break;
					}
					} 
				}
				setState(766);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,69,_ctx);
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
		case 9:
			return declVariableList_sempred((DeclVariableListContext)_localctx, predIndex);
		case 22:
			return typeDecl_sempred((TypeDeclContext)_localctx, predIndex);
		case 28:
			return enumMemberList_sempred((EnumMemberListContext)_localctx, predIndex);
		case 30:
			return commaExpr_sempred((CommaExprContext)_localctx, predIndex);
		case 31:
			return expr_sempred((ExprContext)_localctx, predIndex);
		case 42:
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
	private boolean typeDecl_sempred(TypeDeclContext _localctx, int predIndex) {
		switch (predIndex) {
		case 1:
			return precpred(_ctx, 8);
		case 2:
			return precpred(_ctx, 7);
		case 3:
			return precpred(_ctx, 6);
		}
		return true;
	}
	private boolean enumMemberList_sempred(EnumMemberListContext _localctx, int predIndex) {
		switch (predIndex) {
		case 4:
			return precpred(_ctx, 1);
		}
		return true;
	}
	private boolean commaExpr_sempred(CommaExprContext _localctx, int predIndex) {
		switch (predIndex) {
		case 5:
			return precpred(_ctx, 1);
		}
		return true;
	}
	private boolean expr_sempred(ExprContext _localctx, int predIndex) {
		switch (predIndex) {
		case 6:
			return precpred(_ctx, 19);
		case 7:
			return precpred(_ctx, 18);
		case 8:
			return precpred(_ctx, 17);
		case 9:
			return precpred(_ctx, 15);
		case 10:
			return precpred(_ctx, 14);
		case 11:
			return precpred(_ctx, 13);
		case 12:
			return precpred(_ctx, 12);
		case 13:
			return precpred(_ctx, 11);
		case 14:
			return precpred(_ctx, 10);
		case 15:
			return precpred(_ctx, 9);
		case 16:
			return precpred(_ctx, 8);
		case 17:
			return precpred(_ctx, 7);
		case 18:
			return precpred(_ctx, 30);
		case 19:
			return precpred(_ctx, 29);
		case 20:
			return precpred(_ctx, 28);
		case 21:
			return precpred(_ctx, 25);
		case 22:
			return precpred(_ctx, 22);
		}
		return true;
	}
	private boolean asmExpr_sempred(AsmExprContext _localctx, int predIndex) {
		switch (predIndex) {
		case 23:
			return precpred(_ctx, 10);
		case 24:
			return precpred(_ctx, 9);
		case 25:
			return precpred(_ctx, 7);
		case 26:
			return precpred(_ctx, 6);
		}
		return true;
	}

	public static final String _serializedATN =
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\3\u008d\u0302\4\2\t"+
		"\2\4\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n\t\n\4\13"+
		"\t\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\4\20\t\20\4\21\t\21\4\22\t\22"+
		"\4\23\t\23\4\24\t\24\4\25\t\25\4\26\t\26\4\27\t\27\4\30\t\30\4\31\t\31"+
		"\4\32\t\32\4\33\t\33\4\34\t\34\4\35\t\35\4\36\t\36\4\37\t\37\4 \t \4!"+
		"\t!\4\"\t\"\4#\t#\4$\t$\4%\t%\4&\t&\4\'\t\'\4(\t(\4)\t)\4*\t*\4+\t+\4"+
		",\t,\3\2\3\2\3\2\3\3\3\3\3\3\3\4\7\4`\n\4\f\4\16\4c\13\4\3\5\3\5\5\5g"+
		"\n\5\3\6\3\6\3\6\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3"+
		"\7\3\7\5\7{\n\7\3\b\3\b\3\b\3\b\3\b\3\t\7\t\u0083\n\t\f\t\16\t\u0086\13"+
		"\t\3\t\3\t\7\t\u008a\n\t\f\t\16\t\u008d\13\t\3\n\3\n\3\n\3\13\3\13\3\13"+
		"\3\13\3\13\3\13\7\13\u0098\n\13\f\13\16\13\u009b\13\13\3\f\3\f\3\f\5\f"+
		"\u00a0\n\f\3\f\3\f\3\f\5\f\u00a5\n\f\3\r\3\r\3\r\3\r\5\r\u00ab\n\r\3\r"+
		"\3\r\3\r\5\r\u00b0\n\r\3\r\3\r\3\16\3\16\3\16\7\16\u00b7\n\16\f\16\16"+
		"\16\u00ba\13\16\3\17\3\17\3\17\3\17\5\17\u00c0\n\17\3\20\3\20\3\20\3\20"+
		"\3\20\3\20\3\20\7\20\u00c9\n\20\f\20\16\20\u00cc\13\20\3\20\3\20\3\20"+
		"\3\20\3\20\3\20\3\20\3\20\3\20\3\20\3\20\3\20\3\20\3\20\3\20\3\20\3\20"+
		"\3\20\3\20\3\20\3\20\3\20\3\20\3\20\3\20\3\20\3\20\3\20\3\20\3\20\3\20"+
		"\3\20\3\20\3\20\3\20\3\20\3\20\3\20\3\20\3\20\3\20\3\20\3\20\3\20\3\20"+
		"\3\20\3\20\3\20\3\20\5\20\u00ff\n\20\3\21\3\21\3\21\3\21\3\21\3\21\3\21"+
		"\3\21\3\21\3\21\3\21\5\21\u010c\n\21\3\21\3\21\3\21\3\21\3\21\5\21\u0113"+
		"\n\21\3\21\3\21\3\21\3\21\3\21\3\21\5\21\u011b\n\21\3\21\3\21\3\21\3\21"+
		"\3\21\7\21\u0122\n\21\f\21\16\21\u0125\13\21\3\21\3\21\5\21\u0129\n\21"+
		"\3\22\6\22\u012c\n\22\r\22\16\22\u012d\3\23\3\23\3\23\3\23\3\23\5\23\u0135"+
		"\n\23\3\23\3\23\3\23\3\23\3\23\3\23\3\23\3\23\3\23\3\23\3\23\5\23\u0142"+
		"\n\23\3\23\7\23\u0145\n\23\f\23\16\23\u0148\13\23\3\23\3\23\3\23\3\23"+
		"\3\23\3\23\3\23\7\23\u0151\n\23\f\23\16\23\u0154\13\23\3\23\3\23\3\23"+
		"\3\23\3\23\3\23\3\23\3\23\3\23\7\23\u015f\n\23\f\23\16\23\u0162\13\23"+
		"\3\23\3\23\3\23\3\23\3\23\3\23\3\23\3\23\3\23\3\23\3\23\3\23\3\23\3\23"+
		"\3\23\3\23\5\23\u0174\n\23\3\23\3\23\3\23\3\23\3\23\3\23\3\23\5\23\u017d"+
		"\n\23\3\23\3\23\3\23\3\23\3\23\5\23\u0184\n\23\3\24\6\24\u0187\n\24\r"+
		"\24\16\24\u0188\3\24\3\24\3\24\5\24\u018e\n\24\5\24\u0190\n\24\3\25\3"+
		"\25\3\25\3\25\5\25\u0196\n\25\3\26\3\26\3\26\3\26\3\26\5\26\u019d\n\26"+
		"\3\26\5\26\u01a0\n\26\3\26\3\26\3\26\3\26\3\26\3\26\5\26\u01a8\n\26\3"+
		"\27\5\27\u01ab\n\27\3\27\5\27\u01ae\n\27\3\30\3\30\3\30\3\30\3\30\3\30"+
		"\3\30\3\30\5\30\u01b8\n\30\3\30\3\30\3\30\3\30\3\30\5\30\u01bf\n\30\3"+
		"\30\3\30\3\30\3\30\3\30\5\30\u01c6\n\30\3\30\3\30\3\30\3\30\7\30\u01cc"+
		"\n\30\f\30\16\30\u01cf\13\30\3\31\3\31\3\31\3\32\3\32\5\32\u01d6\n\32"+
		"\3\32\3\32\6\32\u01da\n\32\r\32\16\32\u01db\3\32\3\32\3\33\3\33\3\33\3"+
		"\34\3\34\3\34\3\35\3\35\5\35\u01e8\n\35\3\35\3\35\3\35\3\35\3\36\3\36"+
		"\3\36\3\36\3\36\3\36\7\36\u01f4\n\36\f\36\16\36\u01f7\13\36\3\37\3\37"+
		"\3\37\5\37\u01fc\n\37\3 \3 \3 \3 \3 \3 \7 \u0204\n \f \16 \u0207\13 \3"+
		"!\3!\3!\3!\3!\3!\3!\3!\3!\5!\u0212\n!\3!\3!\3!\3!\3!\3!\5!\u021a\n!\3"+
		"!\3!\3!\3!\3!\3!\3!\3!\3!\3!\3!\3!\3!\3!\3!\3!\3!\3!\3!\7!\u022f\n!\f"+
		"!\16!\u0232\13!\3!\3!\3!\3!\3!\6!\u0239\n!\r!\16!\u023a\3!\3!\5!\u023f"+
		"\n!\3!\3!\3!\3!\3!\3!\3!\3!\3!\3!\3!\3!\3!\3!\3!\3!\3!\3!\3!\3!\3!\3!"+
		"\3!\3!\3!\3!\3!\3!\3!\3!\3!\3!\3!\3!\3!\3!\3!\3!\3!\3!\3!\3!\3!\3!\3!"+
		"\3!\3!\3!\5!\u0271\n!\3!\3!\3!\3!\3!\3!\3!\3!\7!\u027b\n!\f!\16!\u027e"+
		"\13!\3\"\3\"\3\"\7\"\u0283\n\"\f\"\16\"\u0286\13\"\3#\3#\5#\u028a\n#\3"+
		"#\3#\3$\3$\3$\3$\7$\u0292\n$\f$\16$\u0295\13$\3$\3$\3%\3%\3%\3%\3%\3%"+
		"\3%\3%\3%\3%\3%\3%\3%\5%\u02a6\n%\5%\u02a8\n%\3&\7&\u02ab\n&\f&\16&\u02ae"+
		"\13&\3\'\3\'\3\'\5\'\u02b3\n\'\3(\3(\3(\3(\5(\u02b9\n(\3)\3)\5)\u02bd"+
		"\n)\3*\3*\3*\3*\7*\u02c3\n*\f*\16*\u02c6\13*\3+\3+\3+\3+\3+\3+\3+\3+\3"+
		"+\3+\3+\3+\3+\3+\3+\3+\3+\3+\3+\3+\3+\3+\3+\5+\u02df\n+\3,\3,\3,\3,\3"+
		",\3,\3,\3,\3,\3,\3,\3,\3,\3,\5,\u02ef\n,\3,\3,\3,\3,\3,\3,\3,\3,\3,\3"+
		",\3,\3,\7,\u02fd\n,\f,\16,\u0300\13,\3,\2\b\24.:>@V-\2\4\6\b\n\f\16\20"+
		"\22\24\26\30\32\34\36 \"$&(*,.\60\62\64\668:<>@BDFHJLNPRTV\2\16\3\29:"+
		"\3\2\26\27\5\2\21\22\30\31VV\4\2  ##\3\2\34\35\3\2\23\25\3\2\21\22\3\2"+
		"\36#\3\2vy\3\2tu\3\2z{\3\2vw\2\u036f\2X\3\2\2\2\4[\3\2\2\2\6a\3\2\2\2"+
		"\bf\3\2\2\2\nh\3\2\2\2\fz\3\2\2\2\16|\3\2\2\2\20\u0084\3\2\2\2\22\u008e"+
		"\3\2\2\2\24\u0091\3\2\2\2\26\u00a4\3\2\2\2\30\u00a6\3\2\2\2\32\u00b3\3"+
		"\2\2\2\34\u00bf\3\2\2\2\36\u00fe\3\2\2\2 \u0128\3\2\2\2\"\u012b\3\2\2"+
		"\2$\u0183\3\2\2\2&\u0186\3\2\2\2(\u0191\3\2\2\2*\u01a7\3\2\2\2,\u01ad"+
		"\3\2\2\2.\u01be\3\2\2\2\60\u01d0\3\2\2\2\62\u01d3\3\2\2\2\64\u01df\3\2"+
		"\2\2\66\u01e2\3\2\2\28\u01e5\3\2\2\2:\u01ed\3\2\2\2<\u01f8\3\2\2\2>\u01fd"+
		"\3\2\2\2@\u023e\3\2\2\2B\u027f\3\2\2\2D\u0287\3\2\2\2F\u028d\3\2\2\2H"+
		"\u02a7\3\2\2\2J\u02ac\3\2\2\2L\u02b2\3\2\2\2N\u02b8\3\2\2\2P\u02ba\3\2"+
		"\2\2R\u02be\3\2\2\2T\u02de\3\2\2\2V\u02ee\3\2\2\2XY\5\6\4\2YZ\7\2\2\3"+
		"Z\3\3\2\2\2[\\\5J&\2\\]\7\2\2\3]\5\3\2\2\2^`\5\b\5\2_^\3\2\2\2`c\3\2\2"+
		"\2a_\3\2\2\2ab\3\2\2\2b\7\3\2\2\2ca\3\2\2\2dg\5\f\7\2eg\5\n\6\2fd\3\2"+
		"\2\2fe\3\2\2\2g\t\3\2\2\2hi\7(\2\2ij\7[\2\2j\13\3\2\2\2kl\5\22\n\2lm\7"+
		"\n\2\2m{\3\2\2\2no\5\62\32\2op\7\n\2\2p{\3\2\2\2qr\58\35\2rs\7\n\2\2s"+
		"{\3\2\2\2t{\5\30\r\2u{\5D#\2v{\5\36\20\2wx\5\16\b\2xy\7\n\2\2y{\3\2\2"+
		"\2zk\3\2\2\2zn\3\2\2\2zq\3\2\2\2zt\3\2\2\2zu\3\2\2\2zv\3\2\2\2zw\3\2\2"+
		"\2{\r\3\2\2\2|}\7)\2\2}~\5.\30\2~\177\7f\2\2\177\u0080\b\b\1\2\u0080\17"+
		"\3\2\2\2\u0081\u0083\5 \21\2\u0082\u0081\3\2\2\2\u0083\u0086\3\2\2\2\u0084"+
		"\u0082\3\2\2\2\u0084\u0085\3\2\2\2\u0085\u0087\3\2\2\2\u0086\u0084\3\2"+
		"\2\2\u0087\u008b\5.\30\2\u0088\u008a\5 \21\2\u0089\u0088\3\2\2\2\u008a"+
		"\u008d\3\2\2\2\u008b\u0089\3\2\2\2\u008b\u008c\3\2\2\2\u008c\21\3\2\2"+
		"\2\u008d\u008b\3\2\2\2\u008e\u008f\5\20\t\2\u008f\u0090\5\24\13\2\u0090"+
		"\23\3\2\2\2\u0091\u0092\b\13\1\2\u0092\u0093\5\26\f\2\u0093\u0099\3\2"+
		"\2\2\u0094\u0095\f\3\2\2\u0095\u0096\7\f\2\2\u0096\u0098\5\26\f\2\u0097"+
		"\u0094\3\2\2\2\u0098\u009b\3\2\2\2\u0099\u0097\3\2\2\2\u0099\u009a\3\2"+
		"\2\2\u009a\25\3\2\2\2\u009b\u0099\3\2\2\2\u009c\u009f\7f\2\2\u009d\u009e"+
		"\7&\2\2\u009e\u00a0\5@!\2\u009f\u009d\3\2\2\2\u009f\u00a0\3\2\2\2\u00a0"+
		"\u00a5\3\2\2\2\u00a1\u00a2\7f\2\2\u00a2\u00a3\7&\2\2\u00a3\u00a5\5D#\2"+
		"\u00a4\u009c\3\2\2\2\u00a4\u00a1\3\2\2\2\u00a5\27\3\2\2\2\u00a6\u00a7"+
		"\5\20\t\2\u00a7\u00a8\7f\2\2\u00a8\u00aa\7\b\2\2\u00a9\u00ab\5\32\16\2"+
		"\u00aa\u00a9\3\2\2\2\u00aa\u00ab\3\2\2\2\u00ab\u00ac\3\2\2\2\u00ac\u00ad"+
		"\7\t\2\2\u00ad\u00af\7\4\2\2\u00ae\u00b0\5\"\22\2\u00af\u00ae\3\2\2\2"+
		"\u00af\u00b0\3\2\2\2\u00b0\u00b1\3\2\2\2\u00b1\u00b2\7\5\2\2\u00b2\31"+
		"\3\2\2\2\u00b3\u00b8\5\34\17\2\u00b4\u00b5\7\f\2\2\u00b5\u00b7\5\34\17"+
		"\2\u00b6\u00b4\3\2\2\2\u00b7\u00ba\3\2\2\2\u00b8\u00b6\3\2\2\2\u00b8\u00b9"+
		"\3\2\2\2\u00b9\33\3\2\2\2\u00ba\u00b8\3\2\2\2\u00bb\u00bc\5\20\t\2\u00bc"+
		"\u00bd\7f\2\2\u00bd\u00c0\3\2\2\2\u00be\u00c0\7X\2\2\u00bf\u00bb\3\2\2"+
		"\2\u00bf\u00be\3\2\2\2\u00c0\35\3\2\2\2\u00c1\u00c2\7*\2\2\u00c2\u00c3"+
		"\7+\2\2\u00c3\u00c4\3\2\2\2\u00c4\u00c5\7\b\2\2\u00c5\u00ca\7]\2\2\u00c6"+
		"\u00c7\7\f\2\2\u00c7\u00c9\7]\2\2\u00c8\u00c6\3\2\2\2\u00c9\u00cc\3\2"+
		"\2\2\u00ca\u00c8\3\2\2\2\u00ca\u00cb\3\2\2\2\u00cb\u00cd\3\2\2\2\u00cc"+
		"\u00ca\3\2\2\2\u00cd\u00ff\7\t\2\2\u00ce\u00cf\7*\2\2\u00cf\u00d0\7,\2"+
		"\2\u00d0\u00d1\3\2\2\2\u00d1\u00d2\7\b\2\2\u00d2\u00d3\7]\2\2\u00d3\u00ff"+
		"\7\t\2\2\u00d4\u00d5\7*\2\2\u00d5\u00d6\7-\2\2\u00d6\u00d7\3\2\2\2\u00d7"+
		"\u00d8\7\b\2\2\u00d8\u00d9\7f\2\2\u00d9\u00ff\7\t\2\2\u00da\u00db\7*\2"+
		"\2\u00db\u00dc\7/\2\2\u00dc\u00dd\3\2\2\2\u00dd\u00de\7\b\2\2\u00de\u00df"+
		"\7f\2\2\u00df\u00ff\7\t\2\2\u00e0\u00e1\7*\2\2\u00e1\u00e2\7.\2\2\u00e2"+
		"\u00e3\3\2\2\2\u00e3\u00e4\7\b\2\2\u00e4\u00e5\7[\2\2\u00e5\u00ff\7\t"+
		"\2\2\u00e6\u00e7\7*\2\2\u00e7\u00e8\7\60\2\2\u00e8\u00e9\3\2\2\2\u00e9"+
		"\u00ea\7\b\2\2\u00ea\u00eb\7f\2\2\u00eb\u00ff\7\t\2\2\u00ec\u00ed\7*\2"+
		"\2\u00ed\u00ee\7\61\2\2\u00ee\u00ef\3\2\2\2\u00ef\u00f0\7\b\2\2\u00f0"+
		"\u00f1\7f\2\2\u00f1\u00ff\7\t\2\2\u00f2\u00f3\7*\2\2\u00f3\u00f4\7\62"+
		"\2\2\u00f4\u00f5\3\2\2\2\u00f5\u00f6\7\b\2\2\u00f6\u00f7\7f\2\2\u00f7"+
		"\u00ff\7\t\2\2\u00f8\u00f9\7*\2\2\u00f9\u00fa\7>\2\2\u00fa\u00fb\3\2\2"+
		"\2\u00fb\u00fc\7\b\2\2\u00fc\u00fd\7?\2\2\u00fd\u00ff\7\t\2\2\u00fe\u00c1"+
		"\3\2\2\2\u00fe\u00ce\3\2\2\2\u00fe\u00d4\3\2\2\2\u00fe\u00da\3\2\2\2\u00fe"+
		"\u00e0\3\2\2\2\u00fe\u00e6\3\2\2\2\u00fe\u00ec\3\2\2\2\u00fe\u00f2\3\2"+
		"\2\2\u00fe\u00f8\3\2\2\2\u00ff\37\3\2\2\2\u0100\u0129\7\63\2\2\u0101\u0129"+
		"\7\64\2\2\u0102\u0129\7\65\2\2\u0103\u0104\7\66\2\2\u0104\u0105\7\b\2"+
		"\2\u0105\u0106\7]\2\2\u0106\u0129\7\t\2\2\u0107\u010b\7\67\2\2\u0108\u0109"+
		"\7\b\2\2\u0109\u010a\7f\2\2\u010a\u010c\7\t\2\2\u010b\u0108\3\2\2\2\u010b"+
		"\u010c\3\2\2\2\u010c\u0129\3\2\2\2\u010d\u0129\78\2\2\u010e\u0112\t\2"+
		"\2\2\u010f\u0110\7\b\2\2\u0110\u0111\7]\2\2\u0111\u0113\7\t\2\2\u0112"+
		"\u010f\3\2\2\2\u0112\u0113\3\2\2\2\u0113\u0129\3\2\2\2\u0114\u0129\7;"+
		"\2\2\u0115\u0129\7<\2\2\u0116\u011a\7=\2\2\u0117\u0118\7\b\2\2\u0118\u0119"+
		"\7f\2\2\u0119\u011b\7\t\2\2\u011a\u0117\3\2\2\2\u011a\u011b\3\2\2\2\u011b"+
		"\u0129\3\2\2\2\u011c\u011d\7+\2\2\u011d\u011e\7\b\2\2\u011e\u0123\7]\2"+
		"\2\u011f\u0120\7\f\2\2\u0120\u0122\7]\2\2\u0121\u011f\3\2\2\2\u0122\u0125"+
		"\3\2\2\2\u0123\u0121\3\2\2\2\u0123\u0124\3\2\2\2\u0124\u0126\3\2\2\2\u0125"+
		"\u0123\3\2\2\2\u0126\u0129\7\t\2\2\u0127\u0129\7?\2\2\u0128\u0100\3\2"+
		"\2\2\u0128\u0101\3\2\2\2\u0128\u0102\3\2\2\2\u0128\u0103\3\2\2\2\u0128"+
		"\u0107\3\2\2\2\u0128\u010d\3\2\2\2\u0128\u010e\3\2\2\2\u0128\u0114\3\2"+
		"\2\2\u0128\u0115\3\2\2\2\u0128\u0116\3\2\2\2\u0128\u011c\3\2\2\2\u0128"+
		"\u0127\3\2\2\2\u0129!\3\2\2\2\u012a\u012c\5$\23\2\u012b\u012a\3\2\2\2"+
		"\u012c\u012d\3\2\2\2\u012d\u012b\3\2\2\2\u012d\u012e\3\2\2\2\u012e#\3"+
		"\2\2\2\u012f\u0130\5\22\n\2\u0130\u0131\7\n\2\2\u0131\u0184\3\2\2\2\u0132"+
		"\u0134\7\4\2\2\u0133\u0135\5\"\22\2\u0134\u0133\3\2\2\2\u0134\u0135\3"+
		"\2\2\2\u0135\u0136\3\2\2\2\u0136\u0184\7\5\2\2\u0137\u0138\5> \2\u0138"+
		"\u0139\7\n\2\2\u0139\u0184\3\2\2\2\u013a\u013b\7@\2\2\u013b\u013c\7\b"+
		"\2\2\u013c\u013d\5> \2\u013d\u013e\7\t\2\2\u013e\u0141\5$\23\2\u013f\u0140"+
		"\7A\2\2\u0140\u0142\5$\23\2\u0141\u013f\3\2\2\2\u0141\u0142\3\2\2\2\u0142"+
		"\u0184\3\2\2\2\u0143\u0145\5 \21\2\u0144\u0143\3\2\2\2\u0145\u0148\3\2"+
		"\2\2\u0146\u0144\3\2\2\2\u0146\u0147\3\2\2\2\u0147\u0149\3\2\2\2\u0148"+
		"\u0146\3\2\2\2\u0149\u014a\7B\2\2\u014a\u014b\7\b\2\2\u014b\u014c\5> "+
		"\2\u014c\u014d\7\t\2\2\u014d\u014e\5$\23\2\u014e\u0184\3\2\2\2\u014f\u0151"+
		"\5 \21\2\u0150\u014f\3\2\2\2\u0151\u0154\3\2\2\2\u0152\u0150\3\2\2\2\u0152"+
		"\u0153\3\2\2\2\u0153\u0155\3\2\2\2\u0154\u0152\3\2\2\2\u0155\u0156\7C"+
		"\2\2\u0156\u0157\5$\23\2\u0157\u0158\7B\2\2\u0158\u0159\7\b\2\2\u0159"+
		"\u015a\5> \2\u015a\u015b\7\t\2\2\u015b\u015c\7\n\2\2\u015c\u0184\3\2\2"+
		"\2\u015d\u015f\5 \21\2\u015e\u015d\3\2\2\2\u015f\u0162\3\2\2\2\u0160\u015e"+
		"\3\2\2\2\u0160\u0161\3\2\2\2\u0161\u0163\3\2\2\2\u0162\u0160\3\2\2\2\u0163"+
		"\u0164\7D\2\2\u0164\u0165\7\b\2\2\u0165\u0166\5*\26\2\u0166\u0167\7\t"+
		"\2\2\u0167\u0168\5$\23\2\u0168\u0184\3\2\2\2\u0169\u016a\7E\2\2\u016a"+
		"\u016b\7\b\2\2\u016b\u016c\5> \2\u016c\u016d\7\t\2\2\u016d\u016e\7\4\2"+
		"\2\u016e\u016f\5&\24\2\u016f\u0170\7\5\2\2\u0170\u0184\3\2\2\2\u0171\u0173"+
		"\7F\2\2\u0172\u0174\5> \2\u0173\u0172\3\2\2\2\u0173\u0174\3\2\2\2\u0174"+
		"\u0175\3\2\2\2\u0175\u0184\7\n\2\2\u0176\u0177\7G\2\2\u0177\u0184\7\n"+
		"\2\2\u0178\u0179\7H\2\2\u0179\u0184\7\n\2\2\u017a\u017c\7I\2\2\u017b\u017d"+
		"\5F$\2\u017c\u017b\3\2\2\2\u017c\u017d\3\2\2\2\u017d\u017e\3\2\2\2\u017e"+
		"\u017f\7\4\2\2\u017f\u0180\5J&\2\u0180\u0181\7}\2\2\u0181\u0184\3\2\2"+
		"\2\u0182\u0184\5D#\2\u0183\u012f\3\2\2\2\u0183\u0132\3\2\2\2\u0183\u0137"+
		"\3\2\2\2\u0183\u013a\3\2\2\2\u0183\u0146\3\2\2\2\u0183\u0152\3\2\2\2\u0183"+
		"\u0160\3\2\2\2\u0183\u0169\3\2\2\2\u0183\u0171\3\2\2\2\u0183\u0176\3\2"+
		"\2\2\u0183\u0178\3\2\2\2\u0183\u017a\3\2\2\2\u0183\u0182\3\2\2\2\u0184"+
		"%\3\2\2\2\u0185\u0187\5(\25\2\u0186\u0185\3\2\2\2\u0187\u0188\3\2\2\2"+
		"\u0188\u0186\3\2\2\2\u0188\u0189\3\2\2\2\u0189\u018f\3\2\2\2\u018a\u018b"+
		"\7J\2\2\u018b\u018d\7\13\2\2\u018c\u018e\5\"\22\2\u018d\u018c\3\2\2\2"+
		"\u018d\u018e\3\2\2\2\u018e\u0190\3\2\2\2\u018f\u018a\3\2\2\2\u018f\u0190"+
		"\3\2\2\2\u0190\'\3\2\2\2\u0191\u0192\7K\2\2\u0192\u0193\5@!\2\u0193\u0195"+
		"\7\13\2\2\u0194\u0196\5\"\22\2\u0195\u0194\3\2\2\2\u0195\u0196\3\2\2\2"+
		"\u0196)\3\2\2\2\u0197\u0198\5,\27\2\u0198\u0199\7\n\2\2\u0199\u019a\5"+
		"> \2\u019a\u019c\7\n\2\2\u019b\u019d\5> \2\u019c\u019b\3\2\2\2\u019c\u019d"+
		"\3\2\2\2\u019d\u01a8\3\2\2\2\u019e\u01a0\5\20\t\2\u019f\u019e\3\2\2\2"+
		"\u019f\u01a0\3\2\2\2\u01a0\u01a1\3\2\2\2\u01a1\u01a2\7f\2\2\u01a2\u01a3"+
		"\7\13\2\2\u01a3\u01a4\5@!\2\u01a4\u01a5\7\r\2\2\u01a5\u01a6\5@!\2\u01a6"+
		"\u01a8\3\2\2\2\u01a7\u0197\3\2\2\2\u01a7\u019f\3\2\2\2\u01a8+\3\2\2\2"+
		"\u01a9\u01ab\5\22\n\2\u01aa\u01a9\3\2\2\2\u01aa\u01ab\3\2\2\2\u01ab\u01ae"+
		"\3\2\2\2\u01ac\u01ae\5> \2\u01ad\u01aa\3\2\2\2\u01ad\u01ac\3\2\2\2\u01ae"+
		"-\3\2\2\2\u01af\u01b0\b\30\1\2\u01b0\u01b1\7\b\2\2\u01b1\u01b2\5.\30\2"+
		"\u01b2\u01b3\7\t\2\2\u01b3\u01bf\3\2\2\2\u01b4\u01bf\7X\2\2\u01b5\u01b7"+
		"\7W\2\2\u01b6\u01b8\7X\2\2\u01b7\u01b6\3\2\2\2\u01b7\u01b8\3\2\2\2\u01b8"+
		"\u01bf\3\2\2\2\u01b9\u01bf\5\62\32\2\u01ba\u01bf\5\60\31\2\u01bb\u01bf"+
		"\58\35\2\u01bc\u01bf\5\66\34\2\u01bd\u01bf\7\3\2\2\u01be\u01af\3\2\2\2"+
		"\u01be\u01b4\3\2\2\2\u01be\u01b5\3\2\2\2\u01be\u01b9\3\2\2\2\u01be\u01ba"+
		"\3\2\2\2\u01be\u01bb\3\2\2\2\u01be\u01bc\3\2\2\2\u01be\u01bd\3\2\2\2\u01bf"+
		"\u01cd\3\2\2\2\u01c0\u01c1\f\n\2\2\u01c1\u01cc\7\23\2\2\u01c2\u01c3\f"+
		"\t\2\2\u01c3\u01c5\7\6\2\2\u01c4\u01c6\5@!\2\u01c5\u01c4\3\2\2\2\u01c5"+
		"\u01c6\3\2\2\2\u01c6\u01c7\3\2\2\2\u01c7\u01cc\7\7\2\2\u01c8\u01c9\f\b"+
		"\2\2\u01c9\u01ca\7\b\2\2\u01ca\u01cc\7\t\2\2\u01cb\u01c0\3\2\2\2\u01cb"+
		"\u01c2\3\2\2\2\u01cb\u01c8\3\2\2\2\u01cc\u01cf\3\2\2\2\u01cd\u01cb\3\2"+
		"\2\2\u01cd\u01ce\3\2\2\2\u01ce/\3\2\2\2\u01cf\u01cd\3\2\2\2\u01d0\u01d1"+
		"\7L\2\2\u01d1\u01d2\7f\2\2\u01d2\61\3\2\2\2\u01d3\u01d5\7L\2\2\u01d4\u01d6"+
		"\7f\2\2\u01d5\u01d4\3\2\2\2\u01d5\u01d6\3\2\2\2\u01d6\u01d7\3\2\2\2\u01d7"+
		"\u01d9\7\4\2\2\u01d8\u01da\5\64\33\2\u01d9\u01d8\3\2\2\2\u01da\u01db\3"+
		"\2\2\2\u01db\u01d9\3\2\2\2\u01db\u01dc\3\2\2\2\u01dc\u01dd\3\2\2\2\u01dd"+
		"\u01de\7\5\2\2\u01de\63\3\2\2\2\u01df\u01e0\5\22\n\2\u01e0\u01e1\7\n\2"+
		"\2\u01e1\65\3\2\2\2\u01e2\u01e3\7M\2\2\u01e3\u01e4\7f\2\2\u01e4\67\3\2"+
		"\2\2\u01e5\u01e7\7M\2\2\u01e6\u01e8\7f\2\2\u01e7\u01e6\3\2\2\2\u01e7\u01e8"+
		"\3\2\2\2\u01e8\u01e9\3\2\2\2\u01e9\u01ea\7\4\2\2\u01ea\u01eb\5:\36\2\u01eb"+
		"\u01ec\7\5\2\2\u01ec9\3\2\2\2\u01ed\u01ee\b\36\1\2\u01ee\u01ef\5<\37\2"+
		"\u01ef\u01f5\3\2\2\2\u01f0\u01f1\f\3\2\2\u01f1\u01f2\7\f\2\2\u01f2\u01f4"+
		"\5<\37\2\u01f3\u01f0\3\2\2\2\u01f4\u01f7\3\2\2\2\u01f5\u01f3\3\2\2\2\u01f5"+
		"\u01f6\3\2\2\2\u01f6;\3\2\2\2\u01f7\u01f5\3\2\2\2\u01f8\u01fb\7f\2\2\u01f9"+
		"\u01fa\7&\2\2\u01fa\u01fc\5@!\2\u01fb\u01f9\3\2\2\2\u01fb\u01fc\3\2\2"+
		"\2\u01fc=\3\2\2\2\u01fd\u01fe\b \1\2\u01fe\u01ff\5@!\2\u01ff\u0205\3\2"+
		"\2\2\u0200\u0201\f\3\2\2\u0201\u0202\7\f\2\2\u0202\u0204\5@!\2\u0203\u0200"+
		"\3\2\2\2\u0204\u0207\3\2\2\2\u0205\u0203\3\2\2\2\u0205\u0206\3\2\2\2\u0206"+
		"?\3\2\2\2\u0207\u0205\3\2\2\2\u0208\u0209\b!\1\2\u0209\u020a\7\b\2\2\u020a"+
		"\u020b\5> \2\u020b\u020c\7\t\2\2\u020c\u023f\3\2\2\2\u020d\u020e\7N\2"+
		"\2\u020e\u0211\7\b\2\2\u020f\u0212\5@!\2\u0210\u0212\5.\30\2\u0211\u020f"+
		"\3\2\2\2\u0211\u0210\3\2\2\2\u0212\u0213\3\2\2\2\u0213\u0214\7\t\2\2\u0214"+
		"\u023f\3\2\2\2\u0215\u0216\7O\2\2\u0216\u0219\7\b\2\2\u0217\u021a\5@!"+
		"\2\u0218\u021a\5.\30\2\u0219\u0217\3\2\2\2\u0219\u0218\3\2\2\2\u021a\u021b"+
		"\3\2\2\2\u021b\u021c\7\t\2\2\u021c\u023f\3\2\2\2\u021d\u021e\7\b\2\2\u021e"+
		"\u021f\5.\30\2\u021f\u0220\7\t\2\2\u0220\u0221\5@!\32\u0221\u023f\3\2"+
		"\2\2\u0222\u0223\t\3\2\2\u0223\u023f\5@!\31\u0224\u0225\7\23\2\2\u0225"+
		"\u023f\5@!\27\u0226\u0227\t\4\2\2\u0227\u023f\5@!\26\u0228\u0229\t\5\2"+
		"\2\u0229\u023f\5@!\22\u022a\u022b\7\4\2\2\u022b\u0230\5@!\2\u022c\u022d"+
		"\7\f\2\2\u022d\u022f\5@!\2\u022e\u022c\3\2\2\2\u022f\u0232\3\2\2\2\u0230"+
		"\u022e\3\2\2\2\u0230\u0231\3\2\2\2\u0231\u0233\3\2\2\2\u0232\u0230\3\2"+
		"\2\2\u0233\u0234\7\5\2\2\u0234\u023f\3\2\2\2\u0235\u023f\7f\2\2\u0236"+
		"\u023f\7]\2\2\u0237\u0239\7[\2\2\u0238\u0237\3\2\2\2\u0239\u023a\3\2\2"+
		"\2\u023a\u0238\3\2\2\2\u023a\u023b\3\2\2\2\u023b\u023f\3\2\2\2\u023c\u023f"+
		"\7\\\2\2\u023d\u023f\7Y\2\2\u023e\u0208\3\2\2\2\u023e\u020d\3\2\2\2\u023e"+
		"\u0215\3\2\2\2\u023e\u021d\3\2\2\2\u023e\u0222\3\2\2\2\u023e\u0224\3\2"+
		"\2\2\u023e\u0226\3\2\2\2\u023e\u0228\3\2\2\2\u023e\u022a\3\2\2\2\u023e"+
		"\u0235\3\2\2\2\u023e\u0236\3\2\2\2\u023e\u0238\3\2\2\2\u023e\u023c\3\2"+
		"\2\2\u023e\u023d\3\2\2\2\u023f\u027c\3\2\2\2\u0240\u0241\f\25\2\2\u0241"+
		"\u0242\t\6\2\2\u0242\u027b\5@!\26\u0243\u0244\f\24\2\2\u0244\u0245\t\7"+
		"\2\2\u0245\u027b\5@!\25\u0246\u0247\f\23\2\2\u0247\u0248\t\b\2\2\u0248"+
		"\u027b\5@!\24\u0249\u024a\f\21\2\2\u024a\u024b\t\t\2\2\u024b\u027b\5@"+
		"!\22\u024c\u024d\f\20\2\2\u024d\u024e\7\30\2\2\u024e\u027b\5@!\21\u024f"+
		"\u0250\f\17\2\2\u0250\u0251\7\32\2\2\u0251\u027b\5@!\20\u0252\u0253\f"+
		"\16\2\2\u0253\u0254\7\33\2\2\u0254\u027b\5@!\17\u0255\u0256\f\r\2\2\u0256"+
		"\u0257\7$\2\2\u0257\u027b\5@!\16\u0258\u0259\f\f\2\2\u0259\u025a\7%\2"+
		"\2\u025a\u027b\5@!\r\u025b\u025c\f\13\2\2\u025c\u025d\7\16\2\2\u025d\u025e"+
		"\5@!\2\u025e\u025f\7\13\2\2\u025f\u0260\5@!\f\u0260\u027b\3\2\2\2\u0261"+
		"\u0262\f\n\2\2\u0262\u0263\7&\2\2\u0263\u027b\5@!\n\u0264\u0265\f\t\2"+
		"\2\u0265\u0266\7\'\2\2\u0266\u027b\5@!\t\u0267\u0268\f \2\2\u0268\u0269"+
		"\7\17\2\2\u0269\u027b\7f\2\2\u026a\u026b\f\37\2\2\u026b\u026c\7\20\2\2"+
		"\u026c\u027b\7f\2\2\u026d\u026e\f\36\2\2\u026e\u0270\7\b\2\2\u026f\u0271"+
		"\5B\"\2\u0270\u026f\3\2\2\2\u0270\u0271\3\2\2\2\u0271\u0272\3\2\2\2\u0272"+
		"\u027b\7\t\2\2\u0273\u0274\f\33\2\2\u0274\u0275\7\6\2\2\u0275\u0276\5"+
		"> \2\u0276\u0277\7\7\2\2\u0277\u027b\3\2\2\2\u0278\u0279\f\30\2\2\u0279"+
		"\u027b\t\3\2\2\u027a\u0240\3\2\2\2\u027a\u0243\3\2\2\2\u027a\u0246\3\2"+
		"\2\2\u027a\u0249\3\2\2\2\u027a\u024c\3\2\2\2\u027a\u024f\3\2\2\2\u027a"+
		"\u0252\3\2\2\2\u027a\u0255\3\2\2\2\u027a\u0258\3\2\2\2\u027a\u025b\3\2"+
		"\2\2\u027a\u0261\3\2\2\2\u027a\u0264\3\2\2\2\u027a\u0267\3\2\2\2\u027a"+
		"\u026a\3\2\2\2\u027a\u026d\3\2\2\2\u027a\u0273\3\2\2\2\u027a\u0278\3\2"+
		"\2\2\u027b\u027e\3\2\2\2\u027c\u027a\3\2\2\2\u027c\u027d\3\2\2\2\u027d"+
		"A\3\2\2\2\u027e\u027c\3\2\2\2\u027f\u0284\5@!\2\u0280\u0281\7\f\2\2\u0281"+
		"\u0283\5@!\2\u0282\u0280\3\2\2\2\u0283\u0286\3\2\2\2\u0284\u0282\3\2\2"+
		"\2\u0284\u0285\3\2\2\2\u0285C\3\2\2\2\u0286\u0284\3\2\2\2\u0287\u0289"+
		"\7P\2\2\u0288\u028a\5F$\2\u0289\u0288\3\2\2\2\u0289\u028a\3\2\2\2\u028a"+
		"\u028b\3\2\2\2\u028b\u028c\7Z\2\2\u028cE\3\2\2\2\u028d\u028e\7\b\2\2\u028e"+
		"\u0293\5H%\2\u028f\u0290\7\f\2\2\u0290\u0292\5H%\2\u0291\u028f\3\2\2\2"+
		"\u0292\u0295\3\2\2\2\u0293\u0291\3\2\2\2\u0293\u0294\3\2\2\2\u0294\u0296"+
		"\3\2\2\2\u0295\u0293\3\2\2\2\u0296\u0297\7\t\2\2\u0297G\3\2\2\2\u0298"+
		"\u0299\7Q\2\2\u0299\u02a8\7[\2\2\u029a\u029b\7R\2\2\u029b\u02a8\7f\2\2"+
		"\u029c\u029d\7S\2\2\u029d\u02a8\7[\2\2\u029e\u029f\7T\2\2\u029f\u02a8"+
		"\5@!\2\u02a0\u02a1\7U\2\2\u02a1\u02a8\5@!\2\u02a2\u02a5\7,\2\2\u02a3\u02a6"+
		"\7;\2\2\u02a4\u02a6\5@!\2\u02a5\u02a3\3\2\2\2\u02a5\u02a4\3\2\2\2\u02a6"+
		"\u02a8\3\2\2\2\u02a7\u0298\3\2\2\2\u02a7\u029a\3\2\2\2\u02a7\u029c\3\2"+
		"\2\2\u02a7\u029e\3\2\2\2\u02a7\u02a0\3\2\2\2\u02a7\u02a2\3\2\2\2\u02a8"+
		"I\3\2\2\2\u02a9\u02ab\5L\'\2\u02aa\u02a9\3\2\2\2\u02ab\u02ae\3\2\2\2\u02ac"+
		"\u02aa\3\2\2\2\u02ac\u02ad\3\2\2\2\u02adK\3\2\2\2\u02ae\u02ac\3\2\2\2"+
		"\u02af\u02b3\5N(\2\u02b0\u02b3\5P)\2\u02b1\u02b3\5R*\2\u02b2\u02af\3\2"+
		"\2\2\u02b2\u02b0\3\2\2\2\u02b2\u02b1\3\2\2\2\u02b3M\3\2\2\2\u02b4\u02b5"+
		"\7\u008a\2\2\u02b5\u02b9\7m\2\2\u02b6\u02b7\7\u0089\2\2\u02b7\u02b9\7"+
		"m\2\2\u02b8\u02b4\3\2\2\2\u02b8\u02b6\3\2\2\2\u02b9O\3\2\2\2\u02ba\u02bc"+
		"\7k\2\2\u02bb\u02bd\5T+\2\u02bc\u02bb\3\2\2\2\u02bc\u02bd\3\2\2\2\u02bd"+
		"Q\3\2\2\2\u02be\u02bf\7j\2\2\u02bf\u02c4\5V,\2\u02c0\u02c1\7n\2\2\u02c1"+
		"\u02c3\5V,\2\u02c2\u02c0\3\2\2\2\u02c3\u02c6\3\2\2\2\u02c4\u02c2\3\2\2"+
		"\2\u02c4\u02c5\3\2\2\2\u02c5S\3\2\2\2\u02c6\u02c4\3\2\2\2\u02c7\u02df"+
		"\5V,\2\u02c8\u02c9\7l\2\2\u02c9\u02df\5V,\2\u02ca\u02cb\5V,\2\u02cb\u02cc"+
		"\7n\2\2\u02cc\u02cd\7\u008a\2\2\u02cd\u02df\3\2\2\2\u02ce\u02cf\7o\2\2"+
		"\u02cf\u02d0\5V,\2\u02d0\u02d1\7p\2\2\u02d1\u02d2\7n\2\2\u02d2\u02d3\7"+
		"\u008a\2\2\u02d3\u02df\3\2\2\2\u02d4\u02d5\7o\2\2\u02d5\u02d6\5V,\2\u02d6"+
		"\u02d7\7n\2\2\u02d7\u02d8\7\u008a\2\2\u02d8\u02d9\7p\2\2\u02d9\u02df\3"+
		"\2\2\2\u02da\u02db\7o\2\2\u02db\u02dc\5V,\2\u02dc\u02dd\7p\2\2\u02dd\u02df"+
		"\3\2\2\2\u02de\u02c7\3\2\2\2\u02de\u02c8\3\2\2\2\u02de\u02ca\3\2\2\2\u02de"+
		"\u02ce\3\2\2\2\u02de\u02d4\3\2\2\2\u02de\u02da\3\2\2\2\u02dfU\3\2\2\2"+
		"\u02e0\u02e1\b,\1\2\u02e1\u02e2\7q\2\2\u02e2\u02e3\5V,\2\u02e3\u02e4\7"+
		"r\2\2\u02e4\u02ef\3\2\2\2\u02e5\u02e6\t\n\2\2\u02e6\u02ef\5V,\n\u02e7"+
		"\u02ef\7\u008a\2\2\u02e8\u02ef\7\u0088\2\2\u02e9\u02ea\7|\2\2\u02ea\u02eb"+
		"\7\u008a\2\2\u02eb\u02ef\7}\2\2\u02ec\u02ef\7~\2\2\u02ed\u02ef\7\u0087"+
		"\2\2\u02ee\u02e0\3\2\2\2\u02ee\u02e5\3\2\2\2\u02ee\u02e7\3\2\2\2\u02ee"+
		"\u02e8\3\2\2\2\u02ee\u02e9\3\2\2\2\u02ee\u02ec\3\2\2\2\u02ee\u02ed\3\2"+
		"\2\2\u02ef\u02fe\3\2\2\2\u02f0\u02f1\f\f\2\2\u02f1\u02f2\7s\2\2\u02f2"+
		"\u02fd\5V,\r\u02f3\u02f4\f\13\2\2\u02f4\u02f5\t\13\2\2\u02f5\u02fd\5V"+
		",\f\u02f6\u02f7\f\t\2\2\u02f7\u02f8\t\f\2\2\u02f8\u02fd\5V,\n\u02f9\u02fa"+
		"\f\b\2\2\u02fa\u02fb\t\r\2\2\u02fb\u02fd\5V,\t\u02fc\u02f0\3\2\2\2\u02fc"+
		"\u02f3\3\2\2\2\u02fc\u02f6\3\2\2\2\u02fc\u02f9\3\2\2\2\u02fd\u0300\3\2"+
		"\2\2\u02fe\u02fc\3\2\2\2\u02fe\u02ff\3\2\2\2\u02ffW\3\2\2\2\u0300\u02fe"+
		"\3\2\2\2Hafz\u0084\u008b\u0099\u009f\u00a4\u00aa\u00af\u00b8\u00bf\u00ca"+
		"\u00fe\u010b\u0112\u011a\u0123\u0128\u012d\u0134\u0141\u0146\u0152\u0160"+
		"\u0173\u017c\u0183\u0188\u018d\u018f\u0195\u019c\u019f\u01a7\u01aa\u01ad"+
		"\u01b7\u01be\u01c5\u01cb\u01cd\u01d5\u01db\u01e7\u01f5\u01fb\u0205\u0211"+
		"\u0219\u0230\u023a\u023e\u0270\u027a\u027c\u0284\u0289\u0293\u02a5\u02a7"+
		"\u02ac\u02b2\u02b8\u02bc\u02c4\u02de\u02ee\u02fc\u02fe";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}
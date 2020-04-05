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
		PAR_BEGIN=6, PAR_END=7, SEMICOLON=8, COLON=9, COMMA=10, RANGE=11, CONDITION=12, 
		DOT=13, ARROW=14, PLUS=15, MINUS=16, ASTERISK=17, DIVIDE=18, MODULO=19, 
		INC=20, DEC=21, AND=22, BIT_NOT=23, BIT_XOR=24, BIT_OR=25, SHIFT_LEFT=26, 
		SHIFT_RIGHT=27, EQUAL=28, NOT_EQUAL=29, LESS_THAN=30, LESS_THAN_EQUAL=31, 
		GREATER_THAN_EQUAL=32, GREATER_THAN=33, LOGIC_AND=34, LOGIC_OR=35, ASSIGN=36, 
		ASSIGN_COMPOUND=37, IMPORT=38, TYPEDEF=39, PRAGMA=40, RESERVE=41, PC=42, 
		TARGET=43, LINK=44, CPU=45, CODESEG=46, DATASEG=47, ENCODING=48, CONST=49, 
		EXTERN=50, EXPORT=51, ALIGN=52, INLINE=53, VOLATILE=54, STATIC=55, INTERRUPT=56, 
		REGISTER=57, ADDRESS=58, ADDRESS_ZEROPAGE=59, ADDRESS_MAINMEM=60, FORM_SSA=61, 
		FORM_MA=62, CALLING=63, CALLINGCONVENTION=64, VARMODEL=65, IF=66, ELSE=67, 
		WHILE=68, DO=69, FOR=70, SWITCH=71, RETURN=72, BREAK=73, CONTINUE=74, 
		ASM=75, DEFAULT=76, CASE=77, STRUCT=78, ENUM=79, SIZEOF=80, TYPEID=81, 
		KICKASM=82, RESOURCE=83, USES=84, CLOBBERS=85, BYTES=86, CYCLES=87, LOGIC_NOT=88, 
		SIGNEDNESS=89, SIMPLETYPE=90, BOOLEAN=91, KICKASM_BODY=92, STRING=93, 
		CHAR=94, DEFINE=95, DEFINE_CONTINUE=96, UNDEF=97, IFDEF=98, IFNDEF=99, 
		IFELSE=100, ENDIF=101, NUMBER=102, NUMFLOAT=103, BINFLOAT=104, DECFLOAT=105, 
		HEXFLOAT=106, NUMINT=107, BININTEGER=108, DECINTEGER=109, HEXINTEGER=110, 
		NAME=111, WS=112, COMMENT_LINE=113, COMMENT_BLOCK=114, ASM_BYTE=115, ASM_MNEMONIC=116, 
		ASM_IMM=117, ASM_COLON=118, ASM_COMMA=119, ASM_PAR_BEGIN=120, ASM_PAR_END=121, 
		ASM_BRACKET_BEGIN=122, ASM_BRACKET_END=123, ASM_DOT=124, ASM_SHIFT_LEFT=125, 
		ASM_SHIFT_RIGHT=126, ASM_PLUS=127, ASM_MINUS=128, ASM_LESS_THAN=129, ASM_GREATER_THAN=130, 
		ASM_MULTIPLY=131, ASM_DIVIDE=132, ASM_CURLY_BEGIN=133, ASM_CURLY_END=134, 
		ASM_NUMBER=135, ASM_NUMFLOAT=136, ASM_BINFLOAT=137, ASM_DECFLOAT=138, 
		ASM_HEXFLOAT=139, ASM_NUMINT=140, ASM_BININTEGER=141, ASM_DECINTEGER=142, 
		ASM_HEXINTEGER=143, ASM_CHAR=144, ASM_MULTI_REL=145, ASM_MULTI_NAME=146, 
		ASM_NAME=147, ASM_WS=148, ASM_COMMENT_LINE=149, ASM_COMMENT_BLOCK=150;
	public static final int
		RULE_file = 0, RULE_asmFile = 1, RULE_declSeq = 2, RULE_declOrImport = 3, 
		RULE_importDecl = 4, RULE_decl = 5, RULE_declVariables = 6, RULE_declVariableList = 7, 
		RULE_typeDef = 8, RULE_declVariableInit = 9, RULE_declType = 10, RULE_declPointer = 11, 
		RULE_declArray = 12, RULE_typeSpecifier = 13, RULE_type = 14, RULE_structRef = 15, 
		RULE_structDef = 16, RULE_structMembers = 17, RULE_enumRef = 18, RULE_enumDef = 19, 
		RULE_enumMemberList = 20, RULE_enumMember = 21, RULE_declFunction = 22, 
		RULE_parameterListDecl = 23, RULE_parameterDecl = 24, RULE_globalDirective = 25, 
		RULE_directive = 26, RULE_stmtSeq = 27, RULE_stmt = 28, RULE_switchCases = 29, 
		RULE_switchCase = 30, RULE_forLoop = 31, RULE_forClassicInit = 32, RULE_commaExpr = 33, 
		RULE_expr = 34, RULE_parameterList = 35, RULE_declKasm = 36, RULE_asmDirectives = 37, 
		RULE_asmDirective = 38, RULE_asmLines = 39, RULE_asmLine = 40, RULE_asmLabel = 41, 
		RULE_asmInstruction = 42, RULE_asmBytes = 43, RULE_asmParamMode = 44, 
		RULE_asmExpr = 45;
	private static String[] makeRuleNames() {
		return new String[] {
			"file", "asmFile", "declSeq", "declOrImport", "importDecl", "decl", "declVariables", 
			"declVariableList", "typeDef", "declVariableInit", "declType", "declPointer", 
			"declArray", "typeSpecifier", "type", "structRef", "structDef", "structMembers", 
			"enumRef", "enumDef", "enumMemberList", "enumMember", "declFunction", 
			"parameterListDecl", "parameterDecl", "globalDirective", "directive", 
			"stmtSeq", "stmt", "switchCases", "switchCase", "forLoop", "forClassicInit", 
			"commaExpr", "expr", "parameterList", "declKasm", "asmDirectives", "asmDirective", 
			"asmLines", "asmLine", "asmLabel", "asmInstruction", "asmBytes", "asmParamMode", 
			"asmExpr"
		};
	}
	public static final String[] ruleNames = makeRuleNames();

	private static String[] makeLiteralNames() {
		return new String[] {
			null, null, null, null, null, null, null, null, "';'", null, null, "'..'", 
			"'?'", null, "'->'", null, null, null, null, "'%'", "'++'", "'--'", "'&'", 
			"'~'", "'^'", "'|'", null, null, "'=='", "'!='", null, "'<='", "'>='", 
			null, "'&&'", "'||'", "'='", null, "'import'", "'typedef'", "'#pragma'", 
			"'reserve'", "'pc'", "'target'", "'link'", "'cpu'", "'code_seg'", "'data_seg'", 
			"'encoding'", "'const'", "'extern'", "'export'", "'align'", "'inline'", 
			"'volatile'", "'static'", "'interrupt'", "'register'", "'__address'", 
			"'__zp'", "'__mem'", "'__ssa'", "'__ma'", "'calling'", null, "'var_model'", 
			"'if'", "'else'", "'while'", "'do'", "'for'", "'switch'", "'return'", 
			"'break'", "'continue'", "'asm'", "'default'", "'case'", "'struct'", 
			"'enum'", "'sizeof'", "'typeid'", "'kickasm'", "'resource'", "'uses'", 
			"'clobbers'", "'bytes'", "'cycles'", "'!'", null, null, null, null, null, 
			null, "'#define'", "'\\\n'", "'#undef'", "'#ifdef'", "'#ifndef'", "'#else'", 
			"'#endif'", null, null, null, null, null, null, null, null, null, null, 
			null, null, null, "'.byte'", null, "'#'"
		};
	}
	private static final String[] _LITERAL_NAMES = makeLiteralNames();
	private static String[] makeSymbolicNames() {
		return new String[] {
			null, "TYPEDEFNAME", "CURLY_BEGIN", "CURLY_END", "BRACKET_BEGIN", "BRACKET_END", 
			"PAR_BEGIN", "PAR_END", "SEMICOLON", "COLON", "COMMA", "RANGE", "CONDITION", 
			"DOT", "ARROW", "PLUS", "MINUS", "ASTERISK", "DIVIDE", "MODULO", "INC", 
			"DEC", "AND", "BIT_NOT", "BIT_XOR", "BIT_OR", "SHIFT_LEFT", "SHIFT_RIGHT", 
			"EQUAL", "NOT_EQUAL", "LESS_THAN", "LESS_THAN_EQUAL", "GREATER_THAN_EQUAL", 
			"GREATER_THAN", "LOGIC_AND", "LOGIC_OR", "ASSIGN", "ASSIGN_COMPOUND", 
			"IMPORT", "TYPEDEF", "PRAGMA", "RESERVE", "PC", "TARGET", "LINK", "CPU", 
			"CODESEG", "DATASEG", "ENCODING", "CONST", "EXTERN", "EXPORT", "ALIGN", 
			"INLINE", "VOLATILE", "STATIC", "INTERRUPT", "REGISTER", "ADDRESS", "ADDRESS_ZEROPAGE", 
			"ADDRESS_MAINMEM", "FORM_SSA", "FORM_MA", "CALLING", "CALLINGCONVENTION", 
			"VARMODEL", "IF", "ELSE", "WHILE", "DO", "FOR", "SWITCH", "RETURN", "BREAK", 
			"CONTINUE", "ASM", "DEFAULT", "CASE", "STRUCT", "ENUM", "SIZEOF", "TYPEID", 
			"KICKASM", "RESOURCE", "USES", "CLOBBERS", "BYTES", "CYCLES", "LOGIC_NOT", 
			"SIGNEDNESS", "SIMPLETYPE", "BOOLEAN", "KICKASM_BODY", "STRING", "CHAR", 
			"DEFINE", "DEFINE_CONTINUE", "UNDEF", "IFDEF", "IFNDEF", "IFELSE", "ENDIF", 
			"NUMBER", "NUMFLOAT", "BINFLOAT", "DECFLOAT", "HEXFLOAT", "NUMINT", "BININTEGER", 
			"DECINTEGER", "HEXINTEGER", "NAME", "WS", "COMMENT_LINE", "COMMENT_BLOCK", 
			"ASM_BYTE", "ASM_MNEMONIC", "ASM_IMM", "ASM_COLON", "ASM_COMMA", "ASM_PAR_BEGIN", 
			"ASM_PAR_END", "ASM_BRACKET_BEGIN", "ASM_BRACKET_END", "ASM_DOT", "ASM_SHIFT_LEFT", 
			"ASM_SHIFT_RIGHT", "ASM_PLUS", "ASM_MINUS", "ASM_LESS_THAN", "ASM_GREATER_THAN", 
			"ASM_MULTIPLY", "ASM_DIVIDE", "ASM_CURLY_BEGIN", "ASM_CURLY_END", "ASM_NUMBER", 
			"ASM_NUMFLOAT", "ASM_BINFLOAT", "ASM_DECFLOAT", "ASM_HEXFLOAT", "ASM_NUMINT", 
			"ASM_BININTEGER", "ASM_DECINTEGER", "ASM_HEXINTEGER", "ASM_CHAR", "ASM_MULTI_REL", 
			"ASM_MULTI_NAME", "ASM_NAME", "ASM_WS", "ASM_COMMENT_LINE", "ASM_COMMENT_BLOCK"
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
			setState(101);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << TYPEDEFNAME) | (1L << PAR_BEGIN) | (1L << IMPORT) | (1L << TYPEDEF) | (1L << PRAGMA) | (1L << RESERVE) | (1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << INLINE) | (1L << VOLATILE) | (1L << STATIC) | (1L << INTERRUPT) | (1L << REGISTER) | (1L << ADDRESS) | (1L << ADDRESS_ZEROPAGE) | (1L << ADDRESS_MAINMEM) | (1L << FORM_SSA) | (1L << FORM_MA))) != 0) || ((((_la - 64)) & ~0x3f) == 0 && ((1L << (_la - 64)) & ((1L << (CALLINGCONVENTION - 64)) | (1L << (STRUCT - 64)) | (1L << (ENUM - 64)) | (1L << (KICKASM - 64)) | (1L << (SIGNEDNESS - 64)) | (1L << (SIMPLETYPE - 64)))) != 0)) {
				{
				{
				setState(98);
				declOrImport();
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
			setState(106);
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
			case INLINE:
			case VOLATILE:
			case STATIC:
			case INTERRUPT:
			case REGISTER:
			case ADDRESS:
			case ADDRESS_ZEROPAGE:
			case ADDRESS_MAINMEM:
			case FORM_SSA:
			case FORM_MA:
			case CALLINGCONVENTION:
			case STRUCT:
			case ENUM:
			case KICKASM:
			case SIGNEDNESS:
			case SIMPLETYPE:
				enterOuterAlt(_localctx, 1);
				{
				setState(104);
				decl();
				}
				break;
			case IMPORT:
				enterOuterAlt(_localctx, 2);
				{
				setState(105);
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
			setState(108);
			match(IMPORT);
			setState(109);
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
			setState(126);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,2,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				setState(111);
				declVariables();
				setState(112);
				match(SEMICOLON);
				}
				break;
			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(114);
				structDef();
				setState(115);
				match(SEMICOLON);
				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(117);
				enumDef();
				setState(118);
				match(SEMICOLON);
				}
				break;
			case 4:
				enterOuterAlt(_localctx, 4);
				{
				setState(120);
				declFunction();
				}
				break;
			case 5:
				enterOuterAlt(_localctx, 5);
				{
				setState(121);
				declKasm();
				}
				break;
			case 6:
				enterOuterAlt(_localctx, 6);
				{
				setState(122);
				globalDirective();
				}
				break;
			case 7:
				enterOuterAlt(_localctx, 7);
				{
				setState(123);
				typeDef();
				setState(124);
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
			setState(128);
			declType();
			setState(129);
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
			setState(135);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==ASTERISK) {
				{
				{
				setState(132);
				declPointer();
				}
				}
				setState(137);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(138);
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
					setState(140);
					if (!(precpred(_ctx, 1))) throw new FailedPredicateException(this, "precpred(_ctx, 1)");
					setState(141);
					match(COMMA);
					setState(145);
					_errHandler.sync(this);
					_la = _input.LA(1);
					while (_la==ASTERISK) {
						{
						{
						setState(142);
						declPointer();
						}
						}
						setState(147);
						_errHandler.sync(this);
						_la = _input.LA(1);
					}
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
			setState(154);
			match(TYPEDEF);
			setState(155);
			declType();
			setState(159);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==ASTERISK) {
				{
				{
				setState(156);
				declPointer();
				}
				}
				setState(161);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(162);
			((TypeDefContext)_localctx).NAME = match(NAME);
			setState(166);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==BRACKET_BEGIN) {
				{
				{
				setState(163);
				declArray();
				}
				}
				setState(168);
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
			setState(191);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,11,_ctx) ) {
			case 1:
				_localctx = new DeclVariableInitExprContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(171);
				match(NAME);
				setState(175);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,8,_ctx);
				while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
					if ( _alt==1 ) {
						{
						{
						setState(172);
						declArray();
						}
						} 
					}
					setState(177);
					_errHandler.sync(this);
					_alt = getInterpreter().adaptivePredict(_input,8,_ctx);
				}
				setState(180);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,9,_ctx) ) {
				case 1:
					{
					setState(178);
					match(ASSIGN);
					setState(179);
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
				setState(182);
				match(NAME);
				setState(186);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (_la==BRACKET_BEGIN) {
					{
					{
					setState(183);
					declArray();
					}
					}
					setState(188);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				setState(189);
				match(ASSIGN);
				setState(190);
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
			setState(196);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (((((_la - 41)) & ~0x3f) == 0 && ((1L << (_la - 41)) & ((1L << (RESERVE - 41)) | (1L << (CONST - 41)) | (1L << (EXTERN - 41)) | (1L << (EXPORT - 41)) | (1L << (ALIGN - 41)) | (1L << (INLINE - 41)) | (1L << (VOLATILE - 41)) | (1L << (STATIC - 41)) | (1L << (INTERRUPT - 41)) | (1L << (REGISTER - 41)) | (1L << (ADDRESS - 41)) | (1L << (ADDRESS_ZEROPAGE - 41)) | (1L << (ADDRESS_MAINMEM - 41)) | (1L << (FORM_SSA - 41)) | (1L << (FORM_MA - 41)) | (1L << (CALLINGCONVENTION - 41)))) != 0)) {
				{
				{
				setState(193);
				directive();
				}
				}
				setState(198);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(199);
			type(0);
			setState(203);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (((((_la - 41)) & ~0x3f) == 0 && ((1L << (_la - 41)) & ((1L << (RESERVE - 41)) | (1L << (CONST - 41)) | (1L << (EXTERN - 41)) | (1L << (EXPORT - 41)) | (1L << (ALIGN - 41)) | (1L << (INLINE - 41)) | (1L << (VOLATILE - 41)) | (1L << (STATIC - 41)) | (1L << (INTERRUPT - 41)) | (1L << (REGISTER - 41)) | (1L << (ADDRESS - 41)) | (1L << (ADDRESS_ZEROPAGE - 41)) | (1L << (ADDRESS_MAINMEM - 41)) | (1L << (FORM_SSA - 41)) | (1L << (FORM_MA - 41)) | (1L << (CALLINGCONVENTION - 41)))) != 0)) {
				{
				{
				setState(200);
				directive();
				}
				}
				setState(205);
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
			setState(206);
			match(ASTERISK);
			setState(210);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (((((_la - 41)) & ~0x3f) == 0 && ((1L << (_la - 41)) & ((1L << (RESERVE - 41)) | (1L << (CONST - 41)) | (1L << (EXTERN - 41)) | (1L << (EXPORT - 41)) | (1L << (ALIGN - 41)) | (1L << (INLINE - 41)) | (1L << (VOLATILE - 41)) | (1L << (STATIC - 41)) | (1L << (INTERRUPT - 41)) | (1L << (REGISTER - 41)) | (1L << (ADDRESS - 41)) | (1L << (ADDRESS_ZEROPAGE - 41)) | (1L << (ADDRESS_MAINMEM - 41)) | (1L << (FORM_SSA - 41)) | (1L << (FORM_MA - 41)) | (1L << (CALLINGCONVENTION - 41)))) != 0)) {
				{
				{
				setState(207);
				directive();
				}
				}
				setState(212);
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
			setState(213);
			match(BRACKET_BEGIN);
			setState(215);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << CURLY_BEGIN) | (1L << PAR_BEGIN) | (1L << PLUS) | (1L << MINUS) | (1L << ASTERISK) | (1L << INC) | (1L << DEC) | (1L << AND) | (1L << BIT_NOT) | (1L << LESS_THAN) | (1L << GREATER_THAN))) != 0) || ((((_la - 80)) & ~0x3f) == 0 && ((1L << (_la - 80)) & ((1L << (SIZEOF - 80)) | (1L << (TYPEID - 80)) | (1L << (LOGIC_NOT - 80)) | (1L << (BOOLEAN - 80)) | (1L << (STRING - 80)) | (1L << (CHAR - 80)) | (1L << (NUMBER - 80)) | (1L << (NAME - 80)))) != 0)) {
				{
				setState(214);
				expr(0);
				}
			}

			setState(217);
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

			setState(220);
			type(0);
			}
			_ctx.stop = _input.LT(-1);
			setState(232);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,18,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					setState(230);
					_errHandler.sync(this);
					switch ( getInterpreter().adaptivePredict(_input,17,_ctx) ) {
					case 1:
						{
						_localctx = new TypeSpecifierPointerContext(new TypeSpecifierContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_typeSpecifier);
						setState(222);
						if (!(precpred(_ctx, 2))) throw new FailedPredicateException(this, "precpred(_ctx, 2)");
						setState(223);
						match(ASTERISK);
						}
						break;
					case 2:
						{
						_localctx = new TypeSpecifierArrayContext(new TypeSpecifierContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_typeSpecifier);
						setState(224);
						if (!(precpred(_ctx, 1))) throw new FailedPredicateException(this, "precpred(_ctx, 1)");
						setState(225);
						match(BRACKET_BEGIN);
						setState(227);
						_errHandler.sync(this);
						_la = _input.LA(1);
						if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << CURLY_BEGIN) | (1L << PAR_BEGIN) | (1L << PLUS) | (1L << MINUS) | (1L << ASTERISK) | (1L << INC) | (1L << DEC) | (1L << AND) | (1L << BIT_NOT) | (1L << LESS_THAN) | (1L << GREATER_THAN))) != 0) || ((((_la - 80)) & ~0x3f) == 0 && ((1L << (_la - 80)) & ((1L << (SIZEOF - 80)) | (1L << (TYPEID - 80)) | (1L << (LOGIC_NOT - 80)) | (1L << (BOOLEAN - 80)) | (1L << (STRING - 80)) | (1L << (CHAR - 80)) | (1L << (NUMBER - 80)) | (1L << (NAME - 80)))) != 0)) {
							{
							setState(226);
							expr(0);
							}
						}

						setState(229);
						match(BRACKET_END);
						}
						break;
					}
					} 
				}
				setState(234);
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
			setState(250);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,20,_ctx) ) {
			case 1:
				{
				_localctx = new TypeParContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;

				setState(236);
				match(PAR_BEGIN);
				setState(237);
				type(0);
				setState(238);
				match(PAR_END);
				}
				break;
			case 2:
				{
				_localctx = new TypeSimpleContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(240);
				match(SIMPLETYPE);
				}
				break;
			case 3:
				{
				_localctx = new TypeSignedSimpleContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(241);
				match(SIGNEDNESS);
				setState(243);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,19,_ctx) ) {
				case 1:
					{
					setState(242);
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
				setState(245);
				structDef();
				}
				break;
			case 5:
				{
				_localctx = new TypeStructRefContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(246);
				structRef();
				}
				break;
			case 6:
				{
				_localctx = new TypeEnumDefContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(247);
				enumDef();
				}
				break;
			case 7:
				{
				_localctx = new TypeEnumRefContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(248);
				enumRef();
				}
				break;
			case 8:
				{
				_localctx = new TypeNamedRefContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(249);
				match(TYPEDEFNAME);
				}
				break;
			}
			_ctx.stop = _input.LT(-1);
			setState(263);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,23,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					setState(261);
					_errHandler.sync(this);
					switch ( getInterpreter().adaptivePredict(_input,22,_ctx) ) {
					case 1:
						{
						_localctx = new TypeArrayContext(new TypeContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_type);
						setState(252);
						if (!(precpred(_ctx, 7))) throw new FailedPredicateException(this, "precpred(_ctx, 7)");
						setState(253);
						match(BRACKET_BEGIN);
						setState(255);
						_errHandler.sync(this);
						_la = _input.LA(1);
						if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << CURLY_BEGIN) | (1L << PAR_BEGIN) | (1L << PLUS) | (1L << MINUS) | (1L << ASTERISK) | (1L << INC) | (1L << DEC) | (1L << AND) | (1L << BIT_NOT) | (1L << LESS_THAN) | (1L << GREATER_THAN))) != 0) || ((((_la - 80)) & ~0x3f) == 0 && ((1L << (_la - 80)) & ((1L << (SIZEOF - 80)) | (1L << (TYPEID - 80)) | (1L << (LOGIC_NOT - 80)) | (1L << (BOOLEAN - 80)) | (1L << (STRING - 80)) | (1L << (CHAR - 80)) | (1L << (NUMBER - 80)) | (1L << (NAME - 80)))) != 0)) {
							{
							setState(254);
							expr(0);
							}
						}

						setState(257);
						match(BRACKET_END);
						}
						break;
					case 2:
						{
						_localctx = new TypeProcedureContext(new TypeContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_type);
						setState(258);
						if (!(precpred(_ctx, 6))) throw new FailedPredicateException(this, "precpred(_ctx, 6)");
						setState(259);
						match(PAR_BEGIN);
						setState(260);
						match(PAR_END);
						}
						break;
					}
					} 
				}
				setState(265);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,23,_ctx);
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
			setState(266);
			match(STRUCT);
			setState(267);
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
			setState(269);
			match(STRUCT);
			setState(271);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==NAME) {
				{
				setState(270);
				match(NAME);
				}
			}

			setState(273);
			match(CURLY_BEGIN);
			setState(275); 
			_errHandler.sync(this);
			_la = _input.LA(1);
			do {
				{
				{
				setState(274);
				structMembers();
				}
				}
				setState(277); 
				_errHandler.sync(this);
				_la = _input.LA(1);
			} while ( (((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << TYPEDEFNAME) | (1L << PAR_BEGIN) | (1L << RESERVE) | (1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << INLINE) | (1L << VOLATILE) | (1L << STATIC) | (1L << INTERRUPT) | (1L << REGISTER) | (1L << ADDRESS) | (1L << ADDRESS_ZEROPAGE) | (1L << ADDRESS_MAINMEM) | (1L << FORM_SSA) | (1L << FORM_MA))) != 0) || ((((_la - 64)) & ~0x3f) == 0 && ((1L << (_la - 64)) & ((1L << (CALLINGCONVENTION - 64)) | (1L << (STRUCT - 64)) | (1L << (ENUM - 64)) | (1L << (SIGNEDNESS - 64)) | (1L << (SIMPLETYPE - 64)))) != 0) );
			setState(279);
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
			setState(281);
			declVariables();
			setState(282);
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
			setState(284);
			match(ENUM);
			setState(285);
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
			setState(287);
			match(ENUM);
			setState(289);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==NAME) {
				{
				setState(288);
				match(NAME);
				}
			}

			setState(291);
			match(CURLY_BEGIN);
			setState(292);
			enumMemberList(0);
			setState(293);
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
			setState(296);
			enumMember();
			}
			_ctx.stop = _input.LT(-1);
			setState(303);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,27,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					{
					_localctx = new EnumMemberListContext(_parentctx, _parentState);
					pushNewRecursionContext(_localctx, _startState, RULE_enumMemberList);
					setState(298);
					if (!(precpred(_ctx, 1))) throw new FailedPredicateException(this, "precpred(_ctx, 1)");
					setState(299);
					match(COMMA);
					setState(300);
					enumMember();
					}
					} 
				}
				setState(305);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,27,_ctx);
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
			setState(306);
			match(NAME);
			setState(309);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,28,_ctx) ) {
			case 1:
				{
				setState(307);
				match(ASSIGN);
				setState(308);
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
		public TerminalNode CURLY_BEGIN() { return getToken(KickCParser.CURLY_BEGIN, 0); }
		public TerminalNode CURLY_END() { return getToken(KickCParser.CURLY_END, 0); }
		public List<DeclPointerContext> declPointer() {
			return getRuleContexts(DeclPointerContext.class);
		}
		public DeclPointerContext declPointer(int i) {
			return getRuleContext(DeclPointerContext.class,i);
		}
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
		enterRule(_localctx, 44, RULE_declFunction);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(311);
			declType();
			setState(315);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==ASTERISK) {
				{
				{
				setState(312);
				declPointer();
				}
				}
				setState(317);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(318);
			match(NAME);
			setState(319);
			match(PAR_BEGIN);
			setState(321);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << TYPEDEFNAME) | (1L << PAR_BEGIN) | (1L << RESERVE) | (1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << INLINE) | (1L << VOLATILE) | (1L << STATIC) | (1L << INTERRUPT) | (1L << REGISTER) | (1L << ADDRESS) | (1L << ADDRESS_ZEROPAGE) | (1L << ADDRESS_MAINMEM) | (1L << FORM_SSA) | (1L << FORM_MA))) != 0) || ((((_la - 64)) & ~0x3f) == 0 && ((1L << (_la - 64)) & ((1L << (CALLINGCONVENTION - 64)) | (1L << (STRUCT - 64)) | (1L << (ENUM - 64)) | (1L << (SIGNEDNESS - 64)) | (1L << (SIMPLETYPE - 64)))) != 0)) {
				{
				setState(320);
				parameterListDecl();
				}
			}

			setState(323);
			match(PAR_END);
			setState(324);
			match(CURLY_BEGIN);
			setState(326);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << TYPEDEFNAME) | (1L << CURLY_BEGIN) | (1L << PAR_BEGIN) | (1L << PLUS) | (1L << MINUS) | (1L << ASTERISK) | (1L << INC) | (1L << DEC) | (1L << AND) | (1L << BIT_NOT) | (1L << LESS_THAN) | (1L << GREATER_THAN) | (1L << RESERVE) | (1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << INLINE) | (1L << VOLATILE) | (1L << STATIC) | (1L << INTERRUPT) | (1L << REGISTER) | (1L << ADDRESS) | (1L << ADDRESS_ZEROPAGE) | (1L << ADDRESS_MAINMEM) | (1L << FORM_SSA) | (1L << FORM_MA))) != 0) || ((((_la - 64)) & ~0x3f) == 0 && ((1L << (_la - 64)) & ((1L << (CALLINGCONVENTION - 64)) | (1L << (IF - 64)) | (1L << (WHILE - 64)) | (1L << (DO - 64)) | (1L << (FOR - 64)) | (1L << (SWITCH - 64)) | (1L << (RETURN - 64)) | (1L << (BREAK - 64)) | (1L << (CONTINUE - 64)) | (1L << (ASM - 64)) | (1L << (STRUCT - 64)) | (1L << (ENUM - 64)) | (1L << (SIZEOF - 64)) | (1L << (TYPEID - 64)) | (1L << (KICKASM - 64)) | (1L << (LOGIC_NOT - 64)) | (1L << (SIGNEDNESS - 64)) | (1L << (SIMPLETYPE - 64)) | (1L << (BOOLEAN - 64)) | (1L << (STRING - 64)) | (1L << (CHAR - 64)) | (1L << (NUMBER - 64)) | (1L << (NAME - 64)))) != 0)) {
				{
				setState(325);
				stmtSeq();
				}
			}

			setState(328);
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
		enterRule(_localctx, 46, RULE_parameterListDecl);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(330);
			parameterDecl();
			setState(335);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==COMMA) {
				{
				{
				setState(331);
				match(COMMA);
				setState(332);
				parameterDecl();
				}
				}
				setState(337);
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
		enterRule(_localctx, 48, RULE_parameterDecl);
		int _la;
		try {
			setState(348);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,34,_ctx) ) {
			case 1:
				_localctx = new ParameterDeclTypeContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(338);
				declType();
				setState(342);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (_la==ASTERISK) {
					{
					{
					setState(339);
					declPointer();
					}
					}
					setState(344);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				setState(345);
				match(NAME);
				}
				break;
			case 2:
				_localctx = new ParameterDeclVoidContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(347);
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
		enterRule(_localctx, 50, RULE_globalDirective);
		int _la;
		try {
			setState(424);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,37,_ctx) ) {
			case 1:
				_localctx = new GlobalDirectiveReserveContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				{
				setState(350);
				match(PRAGMA);
				setState(351);
				match(RESERVE);
				}
				setState(353);
				match(PAR_BEGIN);
				setState(354);
				match(NUMBER);
				setState(359);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (_la==COMMA) {
					{
					{
					setState(355);
					match(COMMA);
					setState(356);
					match(NUMBER);
					}
					}
					setState(361);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				setState(362);
				match(PAR_END);
				}
				break;
			case 2:
				_localctx = new GlobalDirectivePcContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				{
				setState(363);
				match(PRAGMA);
				setState(364);
				match(PC);
				}
				setState(366);
				match(PAR_BEGIN);
				setState(367);
				match(NUMBER);
				setState(368);
				match(PAR_END);
				}
				break;
			case 3:
				_localctx = new GlobalDirectivePlatformContext(_localctx);
				enterOuterAlt(_localctx, 3);
				{
				{
				setState(369);
				match(PRAGMA);
				setState(370);
				match(TARGET);
				}
				setState(372);
				match(PAR_BEGIN);
				setState(373);
				match(NAME);
				setState(374);
				match(PAR_END);
				}
				break;
			case 4:
				_localctx = new GlobalDirectiveCpuContext(_localctx);
				enterOuterAlt(_localctx, 4);
				{
				{
				setState(375);
				match(PRAGMA);
				setState(376);
				match(CPU);
				}
				setState(378);
				match(PAR_BEGIN);
				setState(379);
				match(NAME);
				setState(380);
				match(PAR_END);
				}
				break;
			case 5:
				_localctx = new GlobalDirectiveLinkScriptContext(_localctx);
				enterOuterAlt(_localctx, 5);
				{
				{
				setState(381);
				match(PRAGMA);
				setState(382);
				match(LINK);
				}
				setState(384);
				match(PAR_BEGIN);
				setState(385);
				match(STRING);
				setState(386);
				match(PAR_END);
				}
				break;
			case 6:
				_localctx = new GlobalDirectiveCodeSegContext(_localctx);
				enterOuterAlt(_localctx, 6);
				{
				{
				setState(387);
				match(PRAGMA);
				setState(388);
				match(CODESEG);
				}
				setState(390);
				match(PAR_BEGIN);
				setState(391);
				match(NAME);
				setState(392);
				match(PAR_END);
				}
				break;
			case 7:
				_localctx = new GlobalDirectiveDataSegContext(_localctx);
				enterOuterAlt(_localctx, 7);
				{
				{
				setState(393);
				match(PRAGMA);
				setState(394);
				match(DATASEG);
				}
				setState(396);
				match(PAR_BEGIN);
				setState(397);
				match(NAME);
				setState(398);
				match(PAR_END);
				}
				break;
			case 8:
				_localctx = new GlobalDirectiveEncodingContext(_localctx);
				enterOuterAlt(_localctx, 8);
				{
				{
				setState(399);
				match(PRAGMA);
				setState(400);
				match(ENCODING);
				}
				setState(402);
				match(PAR_BEGIN);
				setState(403);
				match(NAME);
				setState(404);
				match(PAR_END);
				}
				break;
			case 9:
				_localctx = new GlobalDirectiveCallingContext(_localctx);
				enterOuterAlt(_localctx, 9);
				{
				{
				setState(405);
				match(PRAGMA);
				setState(406);
				match(CALLING);
				}
				setState(408);
				match(PAR_BEGIN);
				setState(409);
				match(CALLINGCONVENTION);
				setState(410);
				match(PAR_END);
				}
				break;
			case 10:
				_localctx = new GlobalDirectiveVarModelContext(_localctx);
				enterOuterAlt(_localctx, 10);
				{
				{
				setState(411);
				match(PRAGMA);
				setState(412);
				match(VARMODEL);
				}
				setState(414);
				match(PAR_BEGIN);
				setState(415);
				match(NAME);
				setState(420);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (_la==COMMA) {
					{
					{
					setState(416);
					match(COMMA);
					setState(417);
					match(NAME);
					}
					}
					setState(422);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				setState(423);
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
		enterRule(_localctx, 52, RULE_directive);
		int _la;
		try {
			setState(468);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case CONST:
				_localctx = new DirectiveConstContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(426);
				match(CONST);
				}
				break;
			case ALIGN:
				_localctx = new DirectiveAlignContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(427);
				match(ALIGN);
				setState(428);
				match(PAR_BEGIN);
				setState(429);
				match(NUMBER);
				setState(430);
				match(PAR_END);
				}
				break;
			case REGISTER:
				_localctx = new DirectiveRegisterContext(_localctx);
				enterOuterAlt(_localctx, 3);
				{
				setState(431);
				match(REGISTER);
				setState(435);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,38,_ctx) ) {
				case 1:
					{
					setState(432);
					match(PAR_BEGIN);
					{
					setState(433);
					match(NAME);
					}
					setState(434);
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
				setState(437);
				match(ADDRESS_ZEROPAGE);
				}
				break;
			case ADDRESS_MAINMEM:
				_localctx = new DirectiveMemoryAreaMainContext(_localctx);
				enterOuterAlt(_localctx, 5);
				{
				setState(438);
				match(ADDRESS_MAINMEM);
				}
				break;
			case ADDRESS:
				_localctx = new DirectiveMemoryAreaAddressContext(_localctx);
				enterOuterAlt(_localctx, 6);
				{
				setState(439);
				match(ADDRESS);
				setState(440);
				match(PAR_BEGIN);
				{
				setState(441);
				match(NUMBER);
				}
				setState(442);
				match(PAR_END);
				}
				break;
			case VOLATILE:
				_localctx = new DirectiveVolatileContext(_localctx);
				enterOuterAlt(_localctx, 7);
				{
				setState(443);
				match(VOLATILE);
				}
				break;
			case STATIC:
				_localctx = new DirectiveStaticContext(_localctx);
				enterOuterAlt(_localctx, 8);
				{
				setState(444);
				match(STATIC);
				}
				break;
			case FORM_SSA:
				_localctx = new DirectiveFormSsaContext(_localctx);
				enterOuterAlt(_localctx, 9);
				{
				setState(445);
				match(FORM_SSA);
				}
				break;
			case FORM_MA:
				_localctx = new DirectiveFormMaContext(_localctx);
				enterOuterAlt(_localctx, 10);
				{
				setState(446);
				match(FORM_MA);
				}
				break;
			case EXTERN:
				_localctx = new DirectiveExternContext(_localctx);
				enterOuterAlt(_localctx, 11);
				{
				setState(447);
				match(EXTERN);
				}
				break;
			case EXPORT:
				_localctx = new DirectiveExportContext(_localctx);
				enterOuterAlt(_localctx, 12);
				{
				setState(448);
				match(EXPORT);
				}
				break;
			case INLINE:
				_localctx = new DirectiveInlineContext(_localctx);
				enterOuterAlt(_localctx, 13);
				{
				setState(449);
				match(INLINE);
				}
				break;
			case INTERRUPT:
				_localctx = new DirectiveInterruptContext(_localctx);
				enterOuterAlt(_localctx, 14);
				{
				setState(450);
				match(INTERRUPT);
				setState(454);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,39,_ctx) ) {
				case 1:
					{
					setState(451);
					match(PAR_BEGIN);
					setState(452);
					match(NAME);
					setState(453);
					match(PAR_END);
					}
					break;
				}
				}
				break;
			case RESERVE:
				_localctx = new DirectiveReserveZpContext(_localctx);
				enterOuterAlt(_localctx, 15);
				{
				setState(456);
				match(RESERVE);
				setState(457);
				match(PAR_BEGIN);
				setState(458);
				match(NUMBER);
				setState(463);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (_la==COMMA) {
					{
					{
					setState(459);
					match(COMMA);
					setState(460);
					match(NUMBER);
					}
					}
					setState(465);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				setState(466);
				match(PAR_END);
				}
				break;
			case CALLINGCONVENTION:
				_localctx = new DirectiveCallingConventionContext(_localctx);
				enterOuterAlt(_localctx, 16);
				{
				setState(467);
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
		enterRule(_localctx, 54, RULE_stmtSeq);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(471); 
			_errHandler.sync(this);
			_la = _input.LA(1);
			do {
				{
				{
				setState(470);
				stmt();
				}
				}
				setState(473); 
				_errHandler.sync(this);
				_la = _input.LA(1);
			} while ( (((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << TYPEDEFNAME) | (1L << CURLY_BEGIN) | (1L << PAR_BEGIN) | (1L << PLUS) | (1L << MINUS) | (1L << ASTERISK) | (1L << INC) | (1L << DEC) | (1L << AND) | (1L << BIT_NOT) | (1L << LESS_THAN) | (1L << GREATER_THAN) | (1L << RESERVE) | (1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << INLINE) | (1L << VOLATILE) | (1L << STATIC) | (1L << INTERRUPT) | (1L << REGISTER) | (1L << ADDRESS) | (1L << ADDRESS_ZEROPAGE) | (1L << ADDRESS_MAINMEM) | (1L << FORM_SSA) | (1L << FORM_MA))) != 0) || ((((_la - 64)) & ~0x3f) == 0 && ((1L << (_la - 64)) & ((1L << (CALLINGCONVENTION - 64)) | (1L << (IF - 64)) | (1L << (WHILE - 64)) | (1L << (DO - 64)) | (1L << (FOR - 64)) | (1L << (SWITCH - 64)) | (1L << (RETURN - 64)) | (1L << (BREAK - 64)) | (1L << (CONTINUE - 64)) | (1L << (ASM - 64)) | (1L << (STRUCT - 64)) | (1L << (ENUM - 64)) | (1L << (SIZEOF - 64)) | (1L << (TYPEID - 64)) | (1L << (KICKASM - 64)) | (1L << (LOGIC_NOT - 64)) | (1L << (SIGNEDNESS - 64)) | (1L << (SIMPLETYPE - 64)) | (1L << (BOOLEAN - 64)) | (1L << (STRING - 64)) | (1L << (CHAR - 64)) | (1L << (NUMBER - 64)) | (1L << (NAME - 64)))) != 0) );
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
		enterRule(_localctx, 56, RULE_stmt);
		int _la;
		try {
			setState(559);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,50,_ctx) ) {
			case 1:
				_localctx = new StmtDeclVarContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(475);
				declVariables();
				setState(476);
				match(SEMICOLON);
				}
				break;
			case 2:
				_localctx = new StmtBlockContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(478);
				match(CURLY_BEGIN);
				setState(480);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << TYPEDEFNAME) | (1L << CURLY_BEGIN) | (1L << PAR_BEGIN) | (1L << PLUS) | (1L << MINUS) | (1L << ASTERISK) | (1L << INC) | (1L << DEC) | (1L << AND) | (1L << BIT_NOT) | (1L << LESS_THAN) | (1L << GREATER_THAN) | (1L << RESERVE) | (1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << INLINE) | (1L << VOLATILE) | (1L << STATIC) | (1L << INTERRUPT) | (1L << REGISTER) | (1L << ADDRESS) | (1L << ADDRESS_ZEROPAGE) | (1L << ADDRESS_MAINMEM) | (1L << FORM_SSA) | (1L << FORM_MA))) != 0) || ((((_la - 64)) & ~0x3f) == 0 && ((1L << (_la - 64)) & ((1L << (CALLINGCONVENTION - 64)) | (1L << (IF - 64)) | (1L << (WHILE - 64)) | (1L << (DO - 64)) | (1L << (FOR - 64)) | (1L << (SWITCH - 64)) | (1L << (RETURN - 64)) | (1L << (BREAK - 64)) | (1L << (CONTINUE - 64)) | (1L << (ASM - 64)) | (1L << (STRUCT - 64)) | (1L << (ENUM - 64)) | (1L << (SIZEOF - 64)) | (1L << (TYPEID - 64)) | (1L << (KICKASM - 64)) | (1L << (LOGIC_NOT - 64)) | (1L << (SIGNEDNESS - 64)) | (1L << (SIMPLETYPE - 64)) | (1L << (BOOLEAN - 64)) | (1L << (STRING - 64)) | (1L << (CHAR - 64)) | (1L << (NUMBER - 64)) | (1L << (NAME - 64)))) != 0)) {
					{
					setState(479);
					stmtSeq();
					}
				}

				setState(482);
				match(CURLY_END);
				}
				break;
			case 3:
				_localctx = new StmtExprContext(_localctx);
				enterOuterAlt(_localctx, 3);
				{
				setState(483);
				commaExpr(0);
				setState(484);
				match(SEMICOLON);
				}
				break;
			case 4:
				_localctx = new StmtIfElseContext(_localctx);
				enterOuterAlt(_localctx, 4);
				{
				setState(486);
				match(IF);
				setState(487);
				match(PAR_BEGIN);
				setState(488);
				commaExpr(0);
				setState(489);
				match(PAR_END);
				setState(490);
				stmt();
				setState(493);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,44,_ctx) ) {
				case 1:
					{
					setState(491);
					match(ELSE);
					setState(492);
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
				setState(498);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (((((_la - 41)) & ~0x3f) == 0 && ((1L << (_la - 41)) & ((1L << (RESERVE - 41)) | (1L << (CONST - 41)) | (1L << (EXTERN - 41)) | (1L << (EXPORT - 41)) | (1L << (ALIGN - 41)) | (1L << (INLINE - 41)) | (1L << (VOLATILE - 41)) | (1L << (STATIC - 41)) | (1L << (INTERRUPT - 41)) | (1L << (REGISTER - 41)) | (1L << (ADDRESS - 41)) | (1L << (ADDRESS_ZEROPAGE - 41)) | (1L << (ADDRESS_MAINMEM - 41)) | (1L << (FORM_SSA - 41)) | (1L << (FORM_MA - 41)) | (1L << (CALLINGCONVENTION - 41)))) != 0)) {
					{
					{
					setState(495);
					directive();
					}
					}
					setState(500);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				setState(501);
				match(WHILE);
				setState(502);
				match(PAR_BEGIN);
				setState(503);
				commaExpr(0);
				setState(504);
				match(PAR_END);
				setState(505);
				stmt();
				}
				break;
			case 6:
				_localctx = new StmtDoWhileContext(_localctx);
				enterOuterAlt(_localctx, 6);
				{
				setState(510);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (((((_la - 41)) & ~0x3f) == 0 && ((1L << (_la - 41)) & ((1L << (RESERVE - 41)) | (1L << (CONST - 41)) | (1L << (EXTERN - 41)) | (1L << (EXPORT - 41)) | (1L << (ALIGN - 41)) | (1L << (INLINE - 41)) | (1L << (VOLATILE - 41)) | (1L << (STATIC - 41)) | (1L << (INTERRUPT - 41)) | (1L << (REGISTER - 41)) | (1L << (ADDRESS - 41)) | (1L << (ADDRESS_ZEROPAGE - 41)) | (1L << (ADDRESS_MAINMEM - 41)) | (1L << (FORM_SSA - 41)) | (1L << (FORM_MA - 41)) | (1L << (CALLINGCONVENTION - 41)))) != 0)) {
					{
					{
					setState(507);
					directive();
					}
					}
					setState(512);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				setState(513);
				match(DO);
				setState(514);
				stmt();
				setState(515);
				match(WHILE);
				setState(516);
				match(PAR_BEGIN);
				setState(517);
				commaExpr(0);
				setState(518);
				match(PAR_END);
				setState(519);
				match(SEMICOLON);
				}
				break;
			case 7:
				_localctx = new StmtForContext(_localctx);
				enterOuterAlt(_localctx, 7);
				{
				setState(524);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (((((_la - 41)) & ~0x3f) == 0 && ((1L << (_la - 41)) & ((1L << (RESERVE - 41)) | (1L << (CONST - 41)) | (1L << (EXTERN - 41)) | (1L << (EXPORT - 41)) | (1L << (ALIGN - 41)) | (1L << (INLINE - 41)) | (1L << (VOLATILE - 41)) | (1L << (STATIC - 41)) | (1L << (INTERRUPT - 41)) | (1L << (REGISTER - 41)) | (1L << (ADDRESS - 41)) | (1L << (ADDRESS_ZEROPAGE - 41)) | (1L << (ADDRESS_MAINMEM - 41)) | (1L << (FORM_SSA - 41)) | (1L << (FORM_MA - 41)) | (1L << (CALLINGCONVENTION - 41)))) != 0)) {
					{
					{
					setState(521);
					directive();
					}
					}
					setState(526);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				setState(527);
				match(FOR);
				setState(528);
				match(PAR_BEGIN);
				setState(529);
				forLoop();
				setState(530);
				match(PAR_END);
				setState(531);
				stmt();
				}
				break;
			case 8:
				_localctx = new StmtSwitchContext(_localctx);
				enterOuterAlt(_localctx, 8);
				{
				setState(533);
				match(SWITCH);
				setState(534);
				match(PAR_BEGIN);
				setState(535);
				commaExpr(0);
				setState(536);
				match(PAR_END);
				setState(537);
				match(CURLY_BEGIN);
				setState(538);
				switchCases();
				setState(539);
				match(CURLY_END);
				}
				break;
			case 9:
				_localctx = new StmtReturnContext(_localctx);
				enterOuterAlt(_localctx, 9);
				{
				setState(541);
				match(RETURN);
				setState(543);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << CURLY_BEGIN) | (1L << PAR_BEGIN) | (1L << PLUS) | (1L << MINUS) | (1L << ASTERISK) | (1L << INC) | (1L << DEC) | (1L << AND) | (1L << BIT_NOT) | (1L << LESS_THAN) | (1L << GREATER_THAN))) != 0) || ((((_la - 80)) & ~0x3f) == 0 && ((1L << (_la - 80)) & ((1L << (SIZEOF - 80)) | (1L << (TYPEID - 80)) | (1L << (LOGIC_NOT - 80)) | (1L << (BOOLEAN - 80)) | (1L << (STRING - 80)) | (1L << (CHAR - 80)) | (1L << (NUMBER - 80)) | (1L << (NAME - 80)))) != 0)) {
					{
					setState(542);
					commaExpr(0);
					}
				}

				setState(545);
				match(SEMICOLON);
				}
				break;
			case 10:
				_localctx = new StmtBreakContext(_localctx);
				enterOuterAlt(_localctx, 10);
				{
				setState(546);
				match(BREAK);
				setState(547);
				match(SEMICOLON);
				}
				break;
			case 11:
				_localctx = new StmtContinueContext(_localctx);
				enterOuterAlt(_localctx, 11);
				{
				setState(548);
				match(CONTINUE);
				setState(549);
				match(SEMICOLON);
				}
				break;
			case 12:
				_localctx = new StmtAsmContext(_localctx);
				enterOuterAlt(_localctx, 12);
				{
				setState(550);
				match(ASM);
				setState(552);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if (_la==PAR_BEGIN) {
					{
					setState(551);
					asmDirectives();
					}
				}

				setState(554);
				match(CURLY_BEGIN);
				setState(555);
				asmLines();
				setState(556);
				match(ASM_CURLY_END);
				}
				break;
			case 13:
				_localctx = new StmtDeclKasmContext(_localctx);
				enterOuterAlt(_localctx, 13);
				{
				setState(558);
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
		enterRule(_localctx, 58, RULE_switchCases);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(562); 
			_errHandler.sync(this);
			_la = _input.LA(1);
			do {
				{
				{
				setState(561);
				switchCase();
				}
				}
				setState(564); 
				_errHandler.sync(this);
				_la = _input.LA(1);
			} while ( _la==CASE );
			setState(571);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==DEFAULT) {
				{
				setState(566);
				match(DEFAULT);
				setState(567);
				match(COLON);
				setState(569);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << TYPEDEFNAME) | (1L << CURLY_BEGIN) | (1L << PAR_BEGIN) | (1L << PLUS) | (1L << MINUS) | (1L << ASTERISK) | (1L << INC) | (1L << DEC) | (1L << AND) | (1L << BIT_NOT) | (1L << LESS_THAN) | (1L << GREATER_THAN) | (1L << RESERVE) | (1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << INLINE) | (1L << VOLATILE) | (1L << STATIC) | (1L << INTERRUPT) | (1L << REGISTER) | (1L << ADDRESS) | (1L << ADDRESS_ZEROPAGE) | (1L << ADDRESS_MAINMEM) | (1L << FORM_SSA) | (1L << FORM_MA))) != 0) || ((((_la - 64)) & ~0x3f) == 0 && ((1L << (_la - 64)) & ((1L << (CALLINGCONVENTION - 64)) | (1L << (IF - 64)) | (1L << (WHILE - 64)) | (1L << (DO - 64)) | (1L << (FOR - 64)) | (1L << (SWITCH - 64)) | (1L << (RETURN - 64)) | (1L << (BREAK - 64)) | (1L << (CONTINUE - 64)) | (1L << (ASM - 64)) | (1L << (STRUCT - 64)) | (1L << (ENUM - 64)) | (1L << (SIZEOF - 64)) | (1L << (TYPEID - 64)) | (1L << (KICKASM - 64)) | (1L << (LOGIC_NOT - 64)) | (1L << (SIGNEDNESS - 64)) | (1L << (SIMPLETYPE - 64)) | (1L << (BOOLEAN - 64)) | (1L << (STRING - 64)) | (1L << (CHAR - 64)) | (1L << (NUMBER - 64)) | (1L << (NAME - 64)))) != 0)) {
					{
					setState(568);
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
		enterRule(_localctx, 60, RULE_switchCase);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(573);
			match(CASE);
			setState(574);
			expr(0);
			setState(575);
			match(COLON);
			setState(577);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << TYPEDEFNAME) | (1L << CURLY_BEGIN) | (1L << PAR_BEGIN) | (1L << PLUS) | (1L << MINUS) | (1L << ASTERISK) | (1L << INC) | (1L << DEC) | (1L << AND) | (1L << BIT_NOT) | (1L << LESS_THAN) | (1L << GREATER_THAN) | (1L << RESERVE) | (1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << INLINE) | (1L << VOLATILE) | (1L << STATIC) | (1L << INTERRUPT) | (1L << REGISTER) | (1L << ADDRESS) | (1L << ADDRESS_ZEROPAGE) | (1L << ADDRESS_MAINMEM) | (1L << FORM_SSA) | (1L << FORM_MA))) != 0) || ((((_la - 64)) & ~0x3f) == 0 && ((1L << (_la - 64)) & ((1L << (CALLINGCONVENTION - 64)) | (1L << (IF - 64)) | (1L << (WHILE - 64)) | (1L << (DO - 64)) | (1L << (FOR - 64)) | (1L << (SWITCH - 64)) | (1L << (RETURN - 64)) | (1L << (BREAK - 64)) | (1L << (CONTINUE - 64)) | (1L << (ASM - 64)) | (1L << (STRUCT - 64)) | (1L << (ENUM - 64)) | (1L << (SIZEOF - 64)) | (1L << (TYPEID - 64)) | (1L << (KICKASM - 64)) | (1L << (LOGIC_NOT - 64)) | (1L << (SIGNEDNESS - 64)) | (1L << (SIMPLETYPE - 64)) | (1L << (BOOLEAN - 64)) | (1L << (STRING - 64)) | (1L << (CHAR - 64)) | (1L << (NUMBER - 64)) | (1L << (NAME - 64)))) != 0)) {
				{
				setState(576);
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
		enterRule(_localctx, 62, RULE_forLoop);
		int _la;
		try {
			setState(601);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,58,_ctx) ) {
			case 1:
				_localctx = new ForClassicContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(579);
				forClassicInit();
				setState(580);
				match(SEMICOLON);
				setState(581);
				commaExpr(0);
				setState(582);
				match(SEMICOLON);
				setState(584);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << CURLY_BEGIN) | (1L << PAR_BEGIN) | (1L << PLUS) | (1L << MINUS) | (1L << ASTERISK) | (1L << INC) | (1L << DEC) | (1L << AND) | (1L << BIT_NOT) | (1L << LESS_THAN) | (1L << GREATER_THAN))) != 0) || ((((_la - 80)) & ~0x3f) == 0 && ((1L << (_la - 80)) & ((1L << (SIZEOF - 80)) | (1L << (TYPEID - 80)) | (1L << (LOGIC_NOT - 80)) | (1L << (BOOLEAN - 80)) | (1L << (STRING - 80)) | (1L << (CHAR - 80)) | (1L << (NUMBER - 80)) | (1L << (NAME - 80)))) != 0)) {
					{
					setState(583);
					commaExpr(0);
					}
				}

				}
				break;
			case 2:
				_localctx = new ForRangeContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(593);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << TYPEDEFNAME) | (1L << PAR_BEGIN) | (1L << RESERVE) | (1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << INLINE) | (1L << VOLATILE) | (1L << STATIC) | (1L << INTERRUPT) | (1L << REGISTER) | (1L << ADDRESS) | (1L << ADDRESS_ZEROPAGE) | (1L << ADDRESS_MAINMEM) | (1L << FORM_SSA) | (1L << FORM_MA))) != 0) || ((((_la - 64)) & ~0x3f) == 0 && ((1L << (_la - 64)) & ((1L << (CALLINGCONVENTION - 64)) | (1L << (STRUCT - 64)) | (1L << (ENUM - 64)) | (1L << (SIGNEDNESS - 64)) | (1L << (SIMPLETYPE - 64)))) != 0)) {
					{
					setState(586);
					declType();
					setState(590);
					_errHandler.sync(this);
					_la = _input.LA(1);
					while (_la==ASTERISK) {
						{
						{
						setState(587);
						declPointer();
						}
						}
						setState(592);
						_errHandler.sync(this);
						_la = _input.LA(1);
					}
					}
				}

				setState(595);
				match(NAME);
				setState(596);
				match(COLON);
				setState(597);
				expr(0);
				setState(598);
				match(RANGE);
				setState(599);
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
		enterRule(_localctx, 64, RULE_forClassicInit);
		int _la;
		try {
			setState(607);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,60,_ctx) ) {
			case 1:
				_localctx = new ForClassicInitDeclContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(604);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << TYPEDEFNAME) | (1L << PAR_BEGIN) | (1L << RESERVE) | (1L << CONST) | (1L << EXTERN) | (1L << EXPORT) | (1L << ALIGN) | (1L << INLINE) | (1L << VOLATILE) | (1L << STATIC) | (1L << INTERRUPT) | (1L << REGISTER) | (1L << ADDRESS) | (1L << ADDRESS_ZEROPAGE) | (1L << ADDRESS_MAINMEM) | (1L << FORM_SSA) | (1L << FORM_MA))) != 0) || ((((_la - 64)) & ~0x3f) == 0 && ((1L << (_la - 64)) & ((1L << (CALLINGCONVENTION - 64)) | (1L << (STRUCT - 64)) | (1L << (ENUM - 64)) | (1L << (SIGNEDNESS - 64)) | (1L << (SIMPLETYPE - 64)))) != 0)) {
					{
					setState(603);
					declVariables();
					}
				}

				}
				break;
			case 2:
				_localctx = new ForClassicInitExprContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(606);
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

			setState(610);
			expr(0);
			}
			_ctx.stop = _input.LT(-1);
			setState(617);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,61,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					{
					_localctx = new CommaSimpleContext(new CommaExprContext(_parentctx, _parentState));
					pushNewRecursionContext(_localctx, _startState, RULE_commaExpr);
					setState(612);
					if (!(precpred(_ctx, 1))) throw new FailedPredicateException(this, "precpred(_ctx, 1)");
					setState(613);
					match(COMMA);
					setState(614);
					expr(0);
					}
					} 
				}
				setState(619);
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
			setState(674);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,66,_ctx) ) {
			case 1:
				{
				_localctx = new ExprParContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;

				setState(621);
				match(PAR_BEGIN);
				setState(622);
				commaExpr(0);
				setState(623);
				match(PAR_END);
				}
				break;
			case 2:
				{
				_localctx = new ExprSizeOfContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(625);
				match(SIZEOF);
				setState(626);
				match(PAR_BEGIN);
				setState(629);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,62,_ctx) ) {
				case 1:
					{
					setState(627);
					expr(0);
					}
					break;
				case 2:
					{
					setState(628);
					typeSpecifier(0);
					}
					break;
				}
				setState(631);
				match(PAR_END);
				}
				break;
			case 3:
				{
				_localctx = new ExprTypeIdContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(633);
				match(TYPEID);
				setState(634);
				match(PAR_BEGIN);
				setState(637);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,63,_ctx) ) {
				case 1:
					{
					setState(635);
					expr(0);
					}
					break;
				case 2:
					{
					setState(636);
					typeSpecifier(0);
					}
					break;
				}
				setState(639);
				match(PAR_END);
				}
				break;
			case 4:
				{
				_localctx = new ExprCastContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(641);
				match(PAR_BEGIN);
				setState(642);
				typeSpecifier(0);
				setState(643);
				match(PAR_END);
				setState(644);
				expr(24);
				}
				break;
			case 5:
				{
				_localctx = new ExprPreModContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(646);
				_la = _input.LA(1);
				if ( !(_la==INC || _la==DEC) ) {
				_errHandler.recoverInline(this);
				}
				else {
					if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
					_errHandler.reportMatch(this);
					consume();
				}
				setState(647);
				expr(23);
				}
				break;
			case 6:
				{
				_localctx = new ExprPtrContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(648);
				match(ASTERISK);
				setState(649);
				expr(21);
				}
				break;
			case 7:
				{
				_localctx = new ExprUnaryContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(650);
				_la = _input.LA(1);
				if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << PLUS) | (1L << MINUS) | (1L << AND) | (1L << BIT_NOT))) != 0) || _la==LOGIC_NOT) ) {
				_errHandler.recoverInline(this);
				}
				else {
					if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
					_errHandler.reportMatch(this);
					consume();
				}
				setState(651);
				expr(20);
				}
				break;
			case 8:
				{
				_localctx = new ExprUnaryContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(652);
				_la = _input.LA(1);
				if ( !(_la==LESS_THAN || _la==GREATER_THAN) ) {
				_errHandler.recoverInline(this);
				}
				else {
					if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
					_errHandler.reportMatch(this);
					consume();
				}
				setState(653);
				expr(16);
				}
				break;
			case 9:
				{
				_localctx = new InitListContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(654);
				match(CURLY_BEGIN);
				setState(655);
				expr(0);
				setState(660);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (_la==COMMA) {
					{
					{
					setState(656);
					match(COMMA);
					setState(657);
					expr(0);
					}
					}
					setState(662);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				setState(663);
				match(CURLY_END);
				}
				break;
			case 10:
				{
				_localctx = new ExprIdContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(665);
				match(NAME);
				}
				break;
			case 11:
				{
				_localctx = new ExprNumberContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(666);
				match(NUMBER);
				}
				break;
			case 12:
				{
				_localctx = new ExprStringContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(668); 
				_errHandler.sync(this);
				_alt = 1;
				do {
					switch (_alt) {
					case 1:
						{
						{
						setState(667);
						match(STRING);
						}
						}
						break;
					default:
						throw new NoViableAltException(this);
					}
					setState(670); 
					_errHandler.sync(this);
					_alt = getInterpreter().adaptivePredict(_input,65,_ctx);
				} while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER );
				}
				break;
			case 13:
				{
				_localctx = new ExprCharContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(672);
				match(CHAR);
				}
				break;
			case 14:
				{
				_localctx = new ExprBoolContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(673);
				match(BOOLEAN);
				}
				break;
			}
			_ctx.stop = _input.LT(-1);
			setState(736);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,69,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					setState(734);
					_errHandler.sync(this);
					switch ( getInterpreter().adaptivePredict(_input,68,_ctx) ) {
					case 1:
						{
						_localctx = new ExprBinaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(676);
						if (!(precpred(_ctx, 19))) throw new FailedPredicateException(this, "precpred(_ctx, 19)");
						setState(677);
						_la = _input.LA(1);
						if ( !(_la==SHIFT_LEFT || _la==SHIFT_RIGHT) ) {
						_errHandler.recoverInline(this);
						}
						else {
							if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
							_errHandler.reportMatch(this);
							consume();
						}
						setState(678);
						expr(20);
						}
						break;
					case 2:
						{
						_localctx = new ExprBinaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(679);
						if (!(precpred(_ctx, 18))) throw new FailedPredicateException(this, "precpred(_ctx, 18)");
						setState(680);
						_la = _input.LA(1);
						if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << ASTERISK) | (1L << DIVIDE) | (1L << MODULO))) != 0)) ) {
						_errHandler.recoverInline(this);
						}
						else {
							if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
							_errHandler.reportMatch(this);
							consume();
						}
						setState(681);
						expr(19);
						}
						break;
					case 3:
						{
						_localctx = new ExprBinaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(682);
						if (!(precpred(_ctx, 17))) throw new FailedPredicateException(this, "precpred(_ctx, 17)");
						setState(683);
						_la = _input.LA(1);
						if ( !(_la==PLUS || _la==MINUS) ) {
						_errHandler.recoverInline(this);
						}
						else {
							if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
							_errHandler.reportMatch(this);
							consume();
						}
						setState(684);
						expr(18);
						}
						break;
					case 4:
						{
						_localctx = new ExprBinaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(685);
						if (!(precpred(_ctx, 15))) throw new FailedPredicateException(this, "precpred(_ctx, 15)");
						setState(686);
						_la = _input.LA(1);
						if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << EQUAL) | (1L << NOT_EQUAL) | (1L << LESS_THAN) | (1L << LESS_THAN_EQUAL) | (1L << GREATER_THAN_EQUAL) | (1L << GREATER_THAN))) != 0)) ) {
						_errHandler.recoverInline(this);
						}
						else {
							if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
							_errHandler.reportMatch(this);
							consume();
						}
						setState(687);
						expr(16);
						}
						break;
					case 5:
						{
						_localctx = new ExprBinaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(688);
						if (!(precpred(_ctx, 14))) throw new FailedPredicateException(this, "precpred(_ctx, 14)");
						{
						setState(689);
						match(AND);
						}
						setState(690);
						expr(15);
						}
						break;
					case 6:
						{
						_localctx = new ExprBinaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(691);
						if (!(precpred(_ctx, 13))) throw new FailedPredicateException(this, "precpred(_ctx, 13)");
						{
						setState(692);
						match(BIT_XOR);
						}
						setState(693);
						expr(14);
						}
						break;
					case 7:
						{
						_localctx = new ExprBinaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(694);
						if (!(precpred(_ctx, 12))) throw new FailedPredicateException(this, "precpred(_ctx, 12)");
						{
						setState(695);
						match(BIT_OR);
						}
						setState(696);
						expr(13);
						}
						break;
					case 8:
						{
						_localctx = new ExprBinaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(697);
						if (!(precpred(_ctx, 11))) throw new FailedPredicateException(this, "precpred(_ctx, 11)");
						{
						setState(698);
						match(LOGIC_AND);
						}
						setState(699);
						expr(12);
						}
						break;
					case 9:
						{
						_localctx = new ExprBinaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(700);
						if (!(precpred(_ctx, 10))) throw new FailedPredicateException(this, "precpred(_ctx, 10)");
						{
						setState(701);
						match(LOGIC_OR);
						}
						setState(702);
						expr(11);
						}
						break;
					case 10:
						{
						_localctx = new ExprTernaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(703);
						if (!(precpred(_ctx, 9))) throw new FailedPredicateException(this, "precpred(_ctx, 9)");
						setState(704);
						match(CONDITION);
						setState(705);
						expr(0);
						setState(706);
						match(COLON);
						setState(707);
						expr(10);
						}
						break;
					case 11:
						{
						_localctx = new ExprAssignmentContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(709);
						if (!(precpred(_ctx, 8))) throw new FailedPredicateException(this, "precpred(_ctx, 8)");
						setState(710);
						match(ASSIGN);
						setState(711);
						expr(8);
						}
						break;
					case 12:
						{
						_localctx = new ExprAssignmentCompoundContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(712);
						if (!(precpred(_ctx, 7))) throw new FailedPredicateException(this, "precpred(_ctx, 7)");
						setState(713);
						match(ASSIGN_COMPOUND);
						setState(714);
						expr(7);
						}
						break;
					case 13:
						{
						_localctx = new ExprDotContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(715);
						if (!(precpred(_ctx, 30))) throw new FailedPredicateException(this, "precpred(_ctx, 30)");
						setState(716);
						match(DOT);
						setState(717);
						match(NAME);
						}
						break;
					case 14:
						{
						_localctx = new ExprArrowContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(718);
						if (!(precpred(_ctx, 29))) throw new FailedPredicateException(this, "precpred(_ctx, 29)");
						setState(719);
						match(ARROW);
						setState(720);
						match(NAME);
						}
						break;
					case 15:
						{
						_localctx = new ExprCallContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(721);
						if (!(precpred(_ctx, 28))) throw new FailedPredicateException(this, "precpred(_ctx, 28)");
						setState(722);
						match(PAR_BEGIN);
						setState(724);
						_errHandler.sync(this);
						_la = _input.LA(1);
						if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << CURLY_BEGIN) | (1L << PAR_BEGIN) | (1L << PLUS) | (1L << MINUS) | (1L << ASTERISK) | (1L << INC) | (1L << DEC) | (1L << AND) | (1L << BIT_NOT) | (1L << LESS_THAN) | (1L << GREATER_THAN))) != 0) || ((((_la - 80)) & ~0x3f) == 0 && ((1L << (_la - 80)) & ((1L << (SIZEOF - 80)) | (1L << (TYPEID - 80)) | (1L << (LOGIC_NOT - 80)) | (1L << (BOOLEAN - 80)) | (1L << (STRING - 80)) | (1L << (CHAR - 80)) | (1L << (NUMBER - 80)) | (1L << (NAME - 80)))) != 0)) {
							{
							setState(723);
							parameterList();
							}
						}

						setState(726);
						match(PAR_END);
						}
						break;
					case 16:
						{
						_localctx = new ExprArrayContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(727);
						if (!(precpred(_ctx, 25))) throw new FailedPredicateException(this, "precpred(_ctx, 25)");
						setState(728);
						match(BRACKET_BEGIN);
						setState(729);
						commaExpr(0);
						setState(730);
						match(BRACKET_END);
						}
						break;
					case 17:
						{
						_localctx = new ExprPostModContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(732);
						if (!(precpred(_ctx, 22))) throw new FailedPredicateException(this, "precpred(_ctx, 22)");
						setState(733);
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
				setState(738);
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
			setState(739);
			expr(0);
			setState(744);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==COMMA) {
				{
				{
				setState(740);
				match(COMMA);
				setState(741);
				expr(0);
				}
				}
				setState(746);
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
		enterRule(_localctx, 72, RULE_declKasm);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(747);
			match(KICKASM);
			setState(749);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==PAR_BEGIN) {
				{
				setState(748);
				asmDirectives();
				}
			}

			setState(751);
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
			setState(753);
			match(PAR_BEGIN);
			setState(754);
			asmDirective();
			setState(759);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==COMMA) {
				{
				{
				setState(755);
				match(COMMA);
				setState(756);
				asmDirective();
				}
				}
				setState(761);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(762);
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
		enterRule(_localctx, 76, RULE_asmDirective);
		try {
			setState(779);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case RESOURCE:
				_localctx = new AsmDirectiveResourceContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(764);
				match(RESOURCE);
				setState(765);
				match(STRING);
				}
				break;
			case USES:
				_localctx = new AsmDirectiveUsesContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(766);
				match(USES);
				setState(767);
				match(NAME);
				}
				break;
			case CLOBBERS:
				_localctx = new AsmDirectiveClobberContext(_localctx);
				enterOuterAlt(_localctx, 3);
				{
				setState(768);
				match(CLOBBERS);
				setState(769);
				match(STRING);
				}
				break;
			case BYTES:
				_localctx = new AsmDirectiveBytesContext(_localctx);
				enterOuterAlt(_localctx, 4);
				{
				setState(770);
				match(BYTES);
				setState(771);
				expr(0);
				}
				break;
			case CYCLES:
				_localctx = new AsmDirectiveCyclesContext(_localctx);
				enterOuterAlt(_localctx, 5);
				{
				setState(772);
				match(CYCLES);
				setState(773);
				expr(0);
				}
				break;
			case PC:
				_localctx = new AsmDirectiveAddressContext(_localctx);
				enterOuterAlt(_localctx, 6);
				{
				setState(774);
				match(PC);
				setState(777);
				_errHandler.sync(this);
				switch (_input.LA(1)) {
				case INLINE:
					{
					setState(775);
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
					setState(776);
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
		enterRule(_localctx, 78, RULE_asmLines);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(784);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (((((_la - 115)) & ~0x3f) == 0 && ((1L << (_la - 115)) & ((1L << (ASM_BYTE - 115)) | (1L << (ASM_MNEMONIC - 115)) | (1L << (ASM_MULTI_NAME - 115)) | (1L << (ASM_NAME - 115)))) != 0)) {
				{
				{
				setState(781);
				asmLine();
				}
				}
				setState(786);
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
			setState(790);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case ASM_MULTI_NAME:
			case ASM_NAME:
				enterOuterAlt(_localctx, 1);
				{
				setState(787);
				asmLabel();
				}
				break;
			case ASM_MNEMONIC:
				enterOuterAlt(_localctx, 2);
				{
				setState(788);
				asmInstruction();
				}
				break;
			case ASM_BYTE:
				enterOuterAlt(_localctx, 3);
				{
				setState(789);
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
		enterRule(_localctx, 82, RULE_asmLabel);
		try {
			setState(796);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case ASM_NAME:
				_localctx = new AsmLabelNameContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(792);
				match(ASM_NAME);
				setState(793);
				match(ASM_COLON);
				}
				break;
			case ASM_MULTI_NAME:
				_localctx = new AsmLabelMultiContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(794);
				match(ASM_MULTI_NAME);
				setState(795);
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
		enterRule(_localctx, 84, RULE_asmInstruction);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(798);
			match(ASM_MNEMONIC);
			setState(800);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,78,_ctx) ) {
			case 1:
				{
				setState(799);
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
		enterRule(_localctx, 86, RULE_asmBytes);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(802);
			match(ASM_BYTE);
			setState(803);
			asmExpr(0);
			setState(808);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==ASM_COMMA) {
				{
				{
				setState(804);
				match(ASM_COMMA);
				setState(805);
				asmExpr(0);
				}
				}
				setState(810);
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
		enterRule(_localctx, 88, RULE_asmParamMode);
		try {
			setState(834);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,80,_ctx) ) {
			case 1:
				_localctx = new AsmModeAbsContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(811);
				asmExpr(0);
				}
				break;
			case 2:
				_localctx = new AsmModeImmContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(812);
				match(ASM_IMM);
				setState(813);
				asmExpr(0);
				}
				break;
			case 3:
				_localctx = new AsmModeAbsXYContext(_localctx);
				enterOuterAlt(_localctx, 3);
				{
				setState(814);
				asmExpr(0);
				setState(815);
				match(ASM_COMMA);
				setState(816);
				match(ASM_NAME);
				}
				break;
			case 4:
				_localctx = new AsmModeIndIdxXYContext(_localctx);
				enterOuterAlt(_localctx, 4);
				{
				setState(818);
				match(ASM_PAR_BEGIN);
				setState(819);
				asmExpr(0);
				setState(820);
				match(ASM_PAR_END);
				setState(821);
				match(ASM_COMMA);
				setState(822);
				match(ASM_NAME);
				}
				break;
			case 5:
				_localctx = new AsmModeIdxIndXYContext(_localctx);
				enterOuterAlt(_localctx, 5);
				{
				setState(824);
				match(ASM_PAR_BEGIN);
				setState(825);
				asmExpr(0);
				setState(826);
				match(ASM_COMMA);
				setState(827);
				match(ASM_NAME);
				setState(828);
				match(ASM_PAR_END);
				}
				break;
			case 6:
				_localctx = new AsmModeIndContext(_localctx);
				enterOuterAlt(_localctx, 6);
				{
				setState(830);
				match(ASM_PAR_BEGIN);
				setState(831);
				asmExpr(0);
				setState(832);
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
			setState(850);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case ASM_BRACKET_BEGIN:
				{
				_localctx = new AsmExprParContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;

				setState(837);
				match(ASM_BRACKET_BEGIN);
				setState(838);
				asmExpr(0);
				setState(839);
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
				setState(841);
				_la = _input.LA(1);
				if ( !(((((_la - 127)) & ~0x3f) == 0 && ((1L << (_la - 127)) & ((1L << (ASM_PLUS - 127)) | (1L << (ASM_MINUS - 127)) | (1L << (ASM_LESS_THAN - 127)) | (1L << (ASM_GREATER_THAN - 127)))) != 0)) ) {
				_errHandler.recoverInline(this);
				}
				else {
					if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
					_errHandler.reportMatch(this);
					consume();
				}
				setState(842);
				asmExpr(8);
				}
				break;
			case ASM_NAME:
				{
				_localctx = new AsmExprLabelContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(843);
				match(ASM_NAME);
				}
				break;
			case ASM_MULTI_REL:
				{
				_localctx = new AsmExprLabelRelContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(844);
				match(ASM_MULTI_REL);
				}
				break;
			case ASM_CURLY_BEGIN:
				{
				_localctx = new AsmExprReplaceContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(845);
				match(ASM_CURLY_BEGIN);
				setState(846);
				match(ASM_NAME);
				setState(847);
				match(ASM_CURLY_END);
				}
				break;
			case ASM_NUMBER:
				{
				_localctx = new AsmExprIntContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(848);
				match(ASM_NUMBER);
				}
				break;
			case ASM_CHAR:
				{
				_localctx = new AsmExprCharContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(849);
				match(ASM_CHAR);
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
			_ctx.stop = _input.LT(-1);
			setState(866);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,83,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					setState(864);
					_errHandler.sync(this);
					switch ( getInterpreter().adaptivePredict(_input,82,_ctx) ) {
					case 1:
						{
						_localctx = new AsmExprBinaryContext(new AsmExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_asmExpr);
						setState(852);
						if (!(precpred(_ctx, 10))) throw new FailedPredicateException(this, "precpred(_ctx, 10)");
						{
						setState(853);
						match(ASM_DOT);
						}
						setState(854);
						asmExpr(11);
						}
						break;
					case 2:
						{
						_localctx = new AsmExprBinaryContext(new AsmExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_asmExpr);
						setState(855);
						if (!(precpred(_ctx, 9))) throw new FailedPredicateException(this, "precpred(_ctx, 9)");
						setState(856);
						_la = _input.LA(1);
						if ( !(_la==ASM_SHIFT_LEFT || _la==ASM_SHIFT_RIGHT) ) {
						_errHandler.recoverInline(this);
						}
						else {
							if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
							_errHandler.reportMatch(this);
							consume();
						}
						setState(857);
						asmExpr(10);
						}
						break;
					case 3:
						{
						_localctx = new AsmExprBinaryContext(new AsmExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_asmExpr);
						setState(858);
						if (!(precpred(_ctx, 7))) throw new FailedPredicateException(this, "precpred(_ctx, 7)");
						setState(859);
						_la = _input.LA(1);
						if ( !(_la==ASM_MULTIPLY || _la==ASM_DIVIDE) ) {
						_errHandler.recoverInline(this);
						}
						else {
							if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
							_errHandler.reportMatch(this);
							consume();
						}
						setState(860);
						asmExpr(8);
						}
						break;
					case 4:
						{
						_localctx = new AsmExprBinaryContext(new AsmExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_asmExpr);
						setState(861);
						if (!(precpred(_ctx, 6))) throw new FailedPredicateException(this, "precpred(_ctx, 6)");
						setState(862);
						_la = _input.LA(1);
						if ( !(_la==ASM_PLUS || _la==ASM_MINUS) ) {
						_errHandler.recoverInline(this);
						}
						else {
							if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
							_errHandler.reportMatch(this);
							consume();
						}
						setState(863);
						asmExpr(7);
						}
						break;
					}
					} 
				}
				setState(868);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,83,_ctx);
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
		case 33:
			return commaExpr_sempred((CommaExprContext)_localctx, predIndex);
		case 34:
			return expr_sempred((ExprContext)_localctx, predIndex);
		case 45:
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
			return precpred(_ctx, 30);
		case 20:
			return precpred(_ctx, 29);
		case 21:
			return precpred(_ctx, 28);
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
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\3\u0098\u0368\4\2\t"+
		"\2\4\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n\t\n\4\13"+
		"\t\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\4\20\t\20\4\21\t\21\4\22\t\22"+
		"\4\23\t\23\4\24\t\24\4\25\t\25\4\26\t\26\4\27\t\27\4\30\t\30\4\31\t\31"+
		"\4\32\t\32\4\33\t\33\4\34\t\34\4\35\t\35\4\36\t\36\4\37\t\37\4 \t \4!"+
		"\t!\4\"\t\"\4#\t#\4$\t$\4%\t%\4&\t&\4\'\t\'\4(\t(\4)\t)\4*\t*\4+\t+\4"+
		",\t,\4-\t-\4.\t.\4/\t/\3\2\3\2\3\2\3\3\3\3\3\3\3\4\7\4f\n\4\f\4\16\4i"+
		"\13\4\3\5\3\5\5\5m\n\5\3\6\3\6\3\6\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7"+
		"\3\7\3\7\3\7\3\7\3\7\3\7\5\7\u0081\n\7\3\b\3\b\3\b\3\t\3\t\7\t\u0088\n"+
		"\t\f\t\16\t\u008b\13\t\3\t\3\t\3\t\3\t\3\t\7\t\u0092\n\t\f\t\16\t\u0095"+
		"\13\t\3\t\7\t\u0098\n\t\f\t\16\t\u009b\13\t\3\n\3\n\3\n\7\n\u00a0\n\n"+
		"\f\n\16\n\u00a3\13\n\3\n\3\n\7\n\u00a7\n\n\f\n\16\n\u00aa\13\n\3\n\3\n"+
		"\3\13\3\13\7\13\u00b0\n\13\f\13\16\13\u00b3\13\13\3\13\3\13\5\13\u00b7"+
		"\n\13\3\13\3\13\7\13\u00bb\n\13\f\13\16\13\u00be\13\13\3\13\3\13\5\13"+
		"\u00c2\n\13\3\f\7\f\u00c5\n\f\f\f\16\f\u00c8\13\f\3\f\3\f\7\f\u00cc\n"+
		"\f\f\f\16\f\u00cf\13\f\3\r\3\r\7\r\u00d3\n\r\f\r\16\r\u00d6\13\r\3\16"+
		"\3\16\5\16\u00da\n\16\3\16\3\16\3\17\3\17\3\17\3\17\3\17\3\17\3\17\3\17"+
		"\5\17\u00e6\n\17\3\17\7\17\u00e9\n\17\f\17\16\17\u00ec\13\17\3\20\3\20"+
		"\3\20\3\20\3\20\3\20\3\20\3\20\5\20\u00f6\n\20\3\20\3\20\3\20\3\20\3\20"+
		"\5\20\u00fd\n\20\3\20\3\20\3\20\5\20\u0102\n\20\3\20\3\20\3\20\3\20\7"+
		"\20\u0108\n\20\f\20\16\20\u010b\13\20\3\21\3\21\3\21\3\22\3\22\5\22\u0112"+
		"\n\22\3\22\3\22\6\22\u0116\n\22\r\22\16\22\u0117\3\22\3\22\3\23\3\23\3"+
		"\23\3\24\3\24\3\24\3\25\3\25\5\25\u0124\n\25\3\25\3\25\3\25\3\25\3\26"+
		"\3\26\3\26\3\26\3\26\3\26\7\26\u0130\n\26\f\26\16\26\u0133\13\26\3\27"+
		"\3\27\3\27\5\27\u0138\n\27\3\30\3\30\7\30\u013c\n\30\f\30\16\30\u013f"+
		"\13\30\3\30\3\30\3\30\5\30\u0144\n\30\3\30\3\30\3\30\5\30\u0149\n\30\3"+
		"\30\3\30\3\31\3\31\3\31\7\31\u0150\n\31\f\31\16\31\u0153\13\31\3\32\3"+
		"\32\7\32\u0157\n\32\f\32\16\32\u015a\13\32\3\32\3\32\3\32\5\32\u015f\n"+
		"\32\3\33\3\33\3\33\3\33\3\33\3\33\3\33\7\33\u0168\n\33\f\33\16\33\u016b"+
		"\13\33\3\33\3\33\3\33\3\33\3\33\3\33\3\33\3\33\3\33\3\33\3\33\3\33\3\33"+
		"\3\33\3\33\3\33\3\33\3\33\3\33\3\33\3\33\3\33\3\33\3\33\3\33\3\33\3\33"+
		"\3\33\3\33\3\33\3\33\3\33\3\33\3\33\3\33\3\33\3\33\3\33\3\33\3\33\3\33"+
		"\3\33\3\33\3\33\3\33\3\33\3\33\3\33\3\33\3\33\3\33\3\33\3\33\3\33\3\33"+
		"\3\33\7\33\u01a5\n\33\f\33\16\33\u01a8\13\33\3\33\5\33\u01ab\n\33\3\34"+
		"\3\34\3\34\3\34\3\34\3\34\3\34\3\34\3\34\5\34\u01b6\n\34\3\34\3\34\3\34"+
		"\3\34\3\34\3\34\3\34\3\34\3\34\3\34\3\34\3\34\3\34\3\34\3\34\3\34\3\34"+
		"\5\34\u01c9\n\34\3\34\3\34\3\34\3\34\3\34\7\34\u01d0\n\34\f\34\16\34\u01d3"+
		"\13\34\3\34\3\34\5\34\u01d7\n\34\3\35\6\35\u01da\n\35\r\35\16\35\u01db"+
		"\3\36\3\36\3\36\3\36\3\36\5\36\u01e3\n\36\3\36\3\36\3\36\3\36\3\36\3\36"+
		"\3\36\3\36\3\36\3\36\3\36\5\36\u01f0\n\36\3\36\7\36\u01f3\n\36\f\36\16"+
		"\36\u01f6\13\36\3\36\3\36\3\36\3\36\3\36\3\36\3\36\7\36\u01ff\n\36\f\36"+
		"\16\36\u0202\13\36\3\36\3\36\3\36\3\36\3\36\3\36\3\36\3\36\3\36\7\36\u020d"+
		"\n\36\f\36\16\36\u0210\13\36\3\36\3\36\3\36\3\36\3\36\3\36\3\36\3\36\3"+
		"\36\3\36\3\36\3\36\3\36\3\36\3\36\3\36\5\36\u0222\n\36\3\36\3\36\3\36"+
		"\3\36\3\36\3\36\3\36\5\36\u022b\n\36\3\36\3\36\3\36\3\36\3\36\5\36\u0232"+
		"\n\36\3\37\6\37\u0235\n\37\r\37\16\37\u0236\3\37\3\37\3\37\5\37\u023c"+
		"\n\37\5\37\u023e\n\37\3 \3 \3 \3 \5 \u0244\n \3!\3!\3!\3!\3!\5!\u024b"+
		"\n!\3!\3!\7!\u024f\n!\f!\16!\u0252\13!\5!\u0254\n!\3!\3!\3!\3!\3!\3!\5"+
		"!\u025c\n!\3\"\5\"\u025f\n\"\3\"\5\"\u0262\n\"\3#\3#\3#\3#\3#\3#\7#\u026a"+
		"\n#\f#\16#\u026d\13#\3$\3$\3$\3$\3$\3$\3$\3$\3$\5$\u0278\n$\3$\3$\3$\3"+
		"$\3$\3$\5$\u0280\n$\3$\3$\3$\3$\3$\3$\3$\3$\3$\3$\3$\3$\3$\3$\3$\3$\3"+
		"$\3$\3$\7$\u0295\n$\f$\16$\u0298\13$\3$\3$\3$\3$\3$\6$\u029f\n$\r$\16"+
		"$\u02a0\3$\3$\5$\u02a5\n$\3$\3$\3$\3$\3$\3$\3$\3$\3$\3$\3$\3$\3$\3$\3"+
		"$\3$\3$\3$\3$\3$\3$\3$\3$\3$\3$\3$\3$\3$\3$\3$\3$\3$\3$\3$\3$\3$\3$\3"+
		"$\3$\3$\3$\3$\3$\3$\3$\3$\3$\3$\5$\u02d7\n$\3$\3$\3$\3$\3$\3$\3$\3$\7"+
		"$\u02e1\n$\f$\16$\u02e4\13$\3%\3%\3%\7%\u02e9\n%\f%\16%\u02ec\13%\3&\3"+
		"&\5&\u02f0\n&\3&\3&\3\'\3\'\3\'\3\'\7\'\u02f8\n\'\f\'\16\'\u02fb\13\'"+
		"\3\'\3\'\3(\3(\3(\3(\3(\3(\3(\3(\3(\3(\3(\3(\3(\5(\u030c\n(\5(\u030e\n"+
		"(\3)\7)\u0311\n)\f)\16)\u0314\13)\3*\3*\3*\5*\u0319\n*\3+\3+\3+\3+\5+"+
		"\u031f\n+\3,\3,\5,\u0323\n,\3-\3-\3-\3-\7-\u0329\n-\f-\16-\u032c\13-\3"+
		".\3.\3.\3.\3.\3.\3.\3.\3.\3.\3.\3.\3.\3.\3.\3.\3.\3.\3.\3.\3.\3.\3.\5"+
		".\u0345\n.\3/\3/\3/\3/\3/\3/\3/\3/\3/\3/\3/\3/\3/\3/\5/\u0355\n/\3/\3"+
		"/\3/\3/\3/\3/\3/\3/\3/\3/\3/\3/\7/\u0363\n/\f/\16/\u0366\13/\3/\2\t\20"+
		"\34\36*DF\\\60\2\4\6\b\n\f\16\20\22\24\26\30\32\34\36 \"$&(*,.\60\62\64"+
		"\668:<>@BDFHJLNPRTVXZ\\\2\r\3\2\26\27\5\2\21\22\30\31ZZ\4\2  ##\3\2\34"+
		"\35\3\2\23\25\3\2\21\22\3\2\36#\3\2\u0081\u0084\3\2\177\u0080\3\2\u0085"+
		"\u0086\3\2\u0081\u0082\2\u03e4\2^\3\2\2\2\4a\3\2\2\2\6g\3\2\2\2\bl\3\2"+
		"\2\2\nn\3\2\2\2\f\u0080\3\2\2\2\16\u0082\3\2\2\2\20\u0085\3\2\2\2\22\u009c"+
		"\3\2\2\2\24\u00c1\3\2\2\2\26\u00c6\3\2\2\2\30\u00d0\3\2\2\2\32\u00d7\3"+
		"\2\2\2\34\u00dd\3\2\2\2\36\u00fc\3\2\2\2 \u010c\3\2\2\2\"\u010f\3\2\2"+
		"\2$\u011b\3\2\2\2&\u011e\3\2\2\2(\u0121\3\2\2\2*\u0129\3\2\2\2,\u0134"+
		"\3\2\2\2.\u0139\3\2\2\2\60\u014c\3\2\2\2\62\u015e\3\2\2\2\64\u01aa\3\2"+
		"\2\2\66\u01d6\3\2\2\28\u01d9\3\2\2\2:\u0231\3\2\2\2<\u0234\3\2\2\2>\u023f"+
		"\3\2\2\2@\u025b\3\2\2\2B\u0261\3\2\2\2D\u0263\3\2\2\2F\u02a4\3\2\2\2H"+
		"\u02e5\3\2\2\2J\u02ed\3\2\2\2L\u02f3\3\2\2\2N\u030d\3\2\2\2P\u0312\3\2"+
		"\2\2R\u0318\3\2\2\2T\u031e\3\2\2\2V\u0320\3\2\2\2X\u0324\3\2\2\2Z\u0344"+
		"\3\2\2\2\\\u0354\3\2\2\2^_\5\6\4\2_`\7\2\2\3`\3\3\2\2\2ab\5P)\2bc\7\2"+
		"\2\3c\5\3\2\2\2df\5\b\5\2ed\3\2\2\2fi\3\2\2\2ge\3\2\2\2gh\3\2\2\2h\7\3"+
		"\2\2\2ig\3\2\2\2jm\5\f\7\2km\5\n\6\2lj\3\2\2\2lk\3\2\2\2m\t\3\2\2\2no"+
		"\7(\2\2op\7_\2\2p\13\3\2\2\2qr\5\16\b\2rs\7\n\2\2s\u0081\3\2\2\2tu\5\""+
		"\22\2uv\7\n\2\2v\u0081\3\2\2\2wx\5(\25\2xy\7\n\2\2y\u0081\3\2\2\2z\u0081"+
		"\5.\30\2{\u0081\5J&\2|\u0081\5\64\33\2}~\5\22\n\2~\177\7\n\2\2\177\u0081"+
		"\3\2\2\2\u0080q\3\2\2\2\u0080t\3\2\2\2\u0080w\3\2\2\2\u0080z\3\2\2\2\u0080"+
		"{\3\2\2\2\u0080|\3\2\2\2\u0080}\3\2\2\2\u0081\r\3\2\2\2\u0082\u0083\5"+
		"\26\f\2\u0083\u0084\5\20\t\2\u0084\17\3\2\2\2\u0085\u0089\b\t\1\2\u0086"+
		"\u0088\5\30\r\2\u0087\u0086\3\2\2\2\u0088\u008b\3\2\2\2\u0089\u0087\3"+
		"\2\2\2\u0089\u008a\3\2\2\2\u008a\u008c\3\2\2\2\u008b\u0089\3\2\2\2\u008c"+
		"\u008d\5\24\13\2\u008d\u0099\3\2\2\2\u008e\u008f\f\3\2\2\u008f\u0093\7"+
		"\f\2\2\u0090\u0092\5\30\r\2\u0091\u0090\3\2\2\2\u0092\u0095\3\2\2\2\u0093"+
		"\u0091\3\2\2\2\u0093\u0094\3\2\2\2\u0094\u0096\3\2\2\2\u0095\u0093\3\2"+
		"\2\2\u0096\u0098\5\24\13\2\u0097\u008e\3\2\2\2\u0098\u009b\3\2\2\2\u0099"+
		"\u0097\3\2\2\2\u0099\u009a\3\2\2\2\u009a\21\3\2\2\2\u009b\u0099\3\2\2"+
		"\2\u009c\u009d\7)\2\2\u009d\u00a1\5\26\f\2\u009e\u00a0\5\30\r\2\u009f"+
		"\u009e\3\2\2\2\u00a0\u00a3\3\2\2\2\u00a1\u009f\3\2\2\2\u00a1\u00a2\3\2"+
		"\2\2\u00a2\u00a4\3\2\2\2\u00a3\u00a1\3\2\2\2\u00a4\u00a8\7q\2\2\u00a5"+
		"\u00a7\5\32\16\2\u00a6\u00a5\3\2\2\2\u00a7\u00aa\3\2\2\2\u00a8\u00a6\3"+
		"\2\2\2\u00a8\u00a9\3\2\2\2\u00a9\u00ab\3\2\2\2\u00aa\u00a8\3\2\2\2\u00ab"+
		"\u00ac\b\n\1\2\u00ac\23\3\2\2\2\u00ad\u00b1\7q\2\2\u00ae\u00b0\5\32\16"+
		"\2\u00af\u00ae\3\2\2\2\u00b0\u00b3\3\2\2\2\u00b1\u00af\3\2\2\2\u00b1\u00b2"+
		"\3\2\2\2\u00b2\u00b6\3\2\2\2\u00b3\u00b1\3\2\2\2\u00b4\u00b5\7&\2\2\u00b5"+
		"\u00b7\5F$\2\u00b6\u00b4\3\2\2\2\u00b6\u00b7\3\2\2\2\u00b7\u00c2\3\2\2"+
		"\2\u00b8\u00bc\7q\2\2\u00b9\u00bb\5\32\16\2\u00ba\u00b9\3\2\2\2\u00bb"+
		"\u00be\3\2\2\2\u00bc\u00ba\3\2\2\2\u00bc\u00bd\3\2\2\2\u00bd\u00bf\3\2"+
		"\2\2\u00be\u00bc\3\2\2\2\u00bf\u00c0\7&\2\2\u00c0\u00c2\5J&\2\u00c1\u00ad"+
		"\3\2\2\2\u00c1\u00b8\3\2\2\2\u00c2\25\3\2\2\2\u00c3\u00c5\5\66\34\2\u00c4"+
		"\u00c3\3\2\2\2\u00c5\u00c8\3\2\2\2\u00c6\u00c4\3\2\2\2\u00c6\u00c7\3\2"+
		"\2\2\u00c7\u00c9\3\2\2\2\u00c8\u00c6\3\2\2\2\u00c9\u00cd\5\36\20\2\u00ca"+
		"\u00cc\5\66\34\2\u00cb\u00ca\3\2\2\2\u00cc\u00cf\3\2\2\2\u00cd\u00cb\3"+
		"\2\2\2\u00cd\u00ce\3\2\2\2\u00ce\27\3\2\2\2\u00cf\u00cd\3\2\2\2\u00d0"+
		"\u00d4\7\23\2\2\u00d1\u00d3\5\66\34\2\u00d2\u00d1\3\2\2\2\u00d3\u00d6"+
		"\3\2\2\2\u00d4\u00d2\3\2\2\2\u00d4\u00d5\3\2\2\2\u00d5\31\3\2\2\2\u00d6"+
		"\u00d4\3\2\2\2\u00d7\u00d9\7\6\2\2\u00d8\u00da\5F$\2\u00d9\u00d8\3\2\2"+
		"\2\u00d9\u00da\3\2\2\2\u00da\u00db\3\2\2\2\u00db\u00dc\7\7\2\2\u00dc\33"+
		"\3\2\2\2\u00dd\u00de\b\17\1\2\u00de\u00df\5\36\20\2\u00df\u00ea\3\2\2"+
		"\2\u00e0\u00e1\f\4\2\2\u00e1\u00e9\7\23\2\2\u00e2\u00e3\f\3\2\2\u00e3"+
		"\u00e5\7\6\2\2\u00e4\u00e6\5F$\2\u00e5\u00e4\3\2\2\2\u00e5\u00e6\3\2\2"+
		"\2\u00e6\u00e7\3\2\2\2\u00e7\u00e9\7\7\2\2\u00e8\u00e0\3\2\2\2\u00e8\u00e2"+
		"\3\2\2\2\u00e9\u00ec\3\2\2\2\u00ea\u00e8\3\2\2\2\u00ea\u00eb\3\2\2\2\u00eb"+
		"\35\3\2\2\2\u00ec\u00ea\3\2\2\2\u00ed\u00ee\b\20\1\2\u00ee\u00ef\7\b\2"+
		"\2\u00ef\u00f0\5\36\20\2\u00f0\u00f1\7\t\2\2\u00f1\u00fd\3\2\2\2\u00f2"+
		"\u00fd\7\\\2\2\u00f3\u00f5\7[\2\2\u00f4\u00f6\7\\\2\2\u00f5\u00f4\3\2"+
		"\2\2\u00f5\u00f6\3\2\2\2\u00f6\u00fd\3\2\2\2\u00f7\u00fd\5\"\22\2\u00f8"+
		"\u00fd\5 \21\2\u00f9\u00fd\5(\25\2\u00fa\u00fd\5&\24\2\u00fb\u00fd\7\3"+
		"\2\2\u00fc\u00ed\3\2\2\2\u00fc\u00f2\3\2\2\2\u00fc\u00f3\3\2\2\2\u00fc"+
		"\u00f7\3\2\2\2\u00fc\u00f8\3\2\2\2\u00fc\u00f9\3\2\2\2\u00fc\u00fa\3\2"+
		"\2\2\u00fc\u00fb\3\2\2\2\u00fd\u0109\3\2\2\2\u00fe\u00ff\f\t\2\2\u00ff"+
		"\u0101\7\6\2\2\u0100\u0102\5F$\2\u0101\u0100\3\2\2\2\u0101\u0102\3\2\2"+
		"\2\u0102\u0103\3\2\2\2\u0103\u0108\7\7\2\2\u0104\u0105\f\b\2\2\u0105\u0106"+
		"\7\b\2\2\u0106\u0108\7\t\2\2\u0107\u00fe\3\2\2\2\u0107\u0104\3\2\2\2\u0108"+
		"\u010b\3\2\2\2\u0109\u0107\3\2\2\2\u0109\u010a\3\2\2\2\u010a\37\3\2\2"+
		"\2\u010b\u0109\3\2\2\2\u010c\u010d\7P\2\2\u010d\u010e\7q\2\2\u010e!\3"+
		"\2\2\2\u010f\u0111\7P\2\2\u0110\u0112\7q\2\2\u0111\u0110\3\2\2\2\u0111"+
		"\u0112\3\2\2\2\u0112\u0113\3\2\2\2\u0113\u0115\7\4\2\2\u0114\u0116\5$"+
		"\23\2\u0115\u0114\3\2\2\2\u0116\u0117\3\2\2\2\u0117\u0115\3\2\2\2\u0117"+
		"\u0118\3\2\2\2\u0118\u0119\3\2\2\2\u0119\u011a\7\5\2\2\u011a#\3\2\2\2"+
		"\u011b\u011c\5\16\b\2\u011c\u011d\7\n\2\2\u011d%\3\2\2\2\u011e\u011f\7"+
		"Q\2\2\u011f\u0120\7q\2\2\u0120\'\3\2\2\2\u0121\u0123\7Q\2\2\u0122\u0124"+
		"\7q\2\2\u0123\u0122\3\2\2\2\u0123\u0124\3\2\2\2\u0124\u0125\3\2\2\2\u0125"+
		"\u0126\7\4\2\2\u0126\u0127\5*\26\2\u0127\u0128\7\5\2\2\u0128)\3\2\2\2"+
		"\u0129\u012a\b\26\1\2\u012a\u012b\5,\27\2\u012b\u0131\3\2\2\2\u012c\u012d"+
		"\f\3\2\2\u012d\u012e\7\f\2\2\u012e\u0130\5,\27\2\u012f\u012c\3\2\2\2\u0130"+
		"\u0133\3\2\2\2\u0131\u012f\3\2\2\2\u0131\u0132\3\2\2\2\u0132+\3\2\2\2"+
		"\u0133\u0131\3\2\2\2\u0134\u0137\7q\2\2\u0135\u0136\7&\2\2\u0136\u0138"+
		"\5F$\2\u0137\u0135\3\2\2\2\u0137\u0138\3\2\2\2\u0138-\3\2\2\2\u0139\u013d"+
		"\5\26\f\2\u013a\u013c\5\30\r\2\u013b\u013a\3\2\2\2\u013c\u013f\3\2\2\2"+
		"\u013d\u013b\3\2\2\2\u013d\u013e\3\2\2\2\u013e\u0140\3\2\2\2\u013f\u013d"+
		"\3\2\2\2\u0140\u0141\7q\2\2\u0141\u0143\7\b\2\2\u0142\u0144\5\60\31\2"+
		"\u0143\u0142\3\2\2\2\u0143\u0144\3\2\2\2\u0144\u0145\3\2\2\2\u0145\u0146"+
		"\7\t\2\2\u0146\u0148\7\4\2\2\u0147\u0149\58\35\2\u0148\u0147\3\2\2\2\u0148"+
		"\u0149\3\2\2\2\u0149\u014a\3\2\2\2\u014a\u014b\7\5\2\2\u014b/\3\2\2\2"+
		"\u014c\u0151\5\62\32\2\u014d\u014e\7\f\2\2\u014e\u0150\5\62\32\2\u014f"+
		"\u014d\3\2\2\2\u0150\u0153\3\2\2\2\u0151\u014f\3\2\2\2\u0151\u0152\3\2"+
		"\2\2\u0152\61\3\2\2\2\u0153\u0151\3\2\2\2\u0154\u0158\5\26\f\2\u0155\u0157"+
		"\5\30\r\2\u0156\u0155\3\2\2\2\u0157\u015a\3\2\2\2\u0158\u0156\3\2\2\2"+
		"\u0158\u0159\3\2\2\2\u0159\u015b\3\2\2\2\u015a\u0158\3\2\2\2\u015b\u015c"+
		"\7q\2\2\u015c\u015f\3\2\2\2\u015d\u015f\7\\\2\2\u015e\u0154\3\2\2\2\u015e"+
		"\u015d\3\2\2\2\u015f\63\3\2\2\2\u0160\u0161\7*\2\2\u0161\u0162\7+\2\2"+
		"\u0162\u0163\3\2\2\2\u0163\u0164\7\b\2\2\u0164\u0169\7h\2\2\u0165\u0166"+
		"\7\f\2\2\u0166\u0168\7h\2\2\u0167\u0165\3\2\2\2\u0168\u016b\3\2\2\2\u0169"+
		"\u0167\3\2\2\2\u0169\u016a\3\2\2\2\u016a\u016c\3\2\2\2\u016b\u0169\3\2"+
		"\2\2\u016c\u01ab\7\t\2\2\u016d\u016e\7*\2\2\u016e\u016f\7,\2\2\u016f\u0170"+
		"\3\2\2\2\u0170\u0171\7\b\2\2\u0171\u0172\7h\2\2\u0172\u01ab\7\t\2\2\u0173"+
		"\u0174\7*\2\2\u0174\u0175\7-\2\2\u0175\u0176\3\2\2\2\u0176\u0177\7\b\2"+
		"\2\u0177\u0178\7q\2\2\u0178\u01ab\7\t\2\2\u0179\u017a\7*\2\2\u017a\u017b"+
		"\7/\2\2\u017b\u017c\3\2\2\2\u017c\u017d\7\b\2\2\u017d\u017e\7q\2\2\u017e"+
		"\u01ab\7\t\2\2\u017f\u0180\7*\2\2\u0180\u0181\7.\2\2\u0181\u0182\3\2\2"+
		"\2\u0182\u0183\7\b\2\2\u0183\u0184\7_\2\2\u0184\u01ab\7\t\2\2\u0185\u0186"+
		"\7*\2\2\u0186\u0187\7\60\2\2\u0187\u0188\3\2\2\2\u0188\u0189\7\b\2\2\u0189"+
		"\u018a\7q\2\2\u018a\u01ab\7\t\2\2\u018b\u018c\7*\2\2\u018c\u018d\7\61"+
		"\2\2\u018d\u018e\3\2\2\2\u018e\u018f\7\b\2\2\u018f\u0190\7q\2\2\u0190"+
		"\u01ab\7\t\2\2\u0191\u0192\7*\2\2\u0192\u0193\7\62\2\2\u0193\u0194\3\2"+
		"\2\2\u0194\u0195\7\b\2\2\u0195\u0196\7q\2\2\u0196\u01ab\7\t\2\2\u0197"+
		"\u0198\7*\2\2\u0198\u0199\7A\2\2\u0199\u019a\3\2\2\2\u019a\u019b\7\b\2"+
		"\2\u019b\u019c\7B\2\2\u019c\u01ab\7\t\2\2\u019d\u019e\7*\2\2\u019e\u019f"+
		"\7C\2\2\u019f\u01a0\3\2\2\2\u01a0\u01a1\7\b\2\2\u01a1\u01a6\7q\2\2\u01a2"+
		"\u01a3\7\f\2\2\u01a3\u01a5\7q\2\2\u01a4\u01a2\3\2\2\2\u01a5\u01a8\3\2"+
		"\2\2\u01a6\u01a4\3\2\2\2\u01a6\u01a7\3\2\2\2\u01a7\u01a9\3\2\2\2\u01a8"+
		"\u01a6\3\2\2\2\u01a9\u01ab\7\t\2\2\u01aa\u0160\3\2\2\2\u01aa\u016d\3\2"+
		"\2\2\u01aa\u0173\3\2\2\2\u01aa\u0179\3\2\2\2\u01aa\u017f\3\2\2\2\u01aa"+
		"\u0185\3\2\2\2\u01aa\u018b\3\2\2\2\u01aa\u0191\3\2\2\2\u01aa\u0197\3\2"+
		"\2\2\u01aa\u019d\3\2\2\2\u01ab\65\3\2\2\2\u01ac\u01d7\7\63\2\2\u01ad\u01ae"+
		"\7\66\2\2\u01ae\u01af\7\b\2\2\u01af\u01b0\7h\2\2\u01b0\u01d7\7\t\2\2\u01b1"+
		"\u01b5\7;\2\2\u01b2\u01b3\7\b\2\2\u01b3\u01b4\7q\2\2\u01b4\u01b6\7\t\2"+
		"\2\u01b5\u01b2\3\2\2\2\u01b5\u01b6\3\2\2\2\u01b6\u01d7\3\2\2\2\u01b7\u01d7"+
		"\7=\2\2\u01b8\u01d7\7>\2\2\u01b9\u01ba\7<\2\2\u01ba\u01bb\7\b\2\2\u01bb"+
		"\u01bc\7h\2\2\u01bc\u01d7\7\t\2\2\u01bd\u01d7\78\2\2\u01be\u01d7\79\2"+
		"\2\u01bf\u01d7\7?\2\2\u01c0\u01d7\7@\2\2\u01c1\u01d7\7\64\2\2\u01c2\u01d7"+
		"\7\65\2\2\u01c3\u01d7\7\67\2\2\u01c4\u01c8\7:\2\2\u01c5\u01c6\7\b\2\2"+
		"\u01c6\u01c7\7q\2\2\u01c7\u01c9\7\t\2\2\u01c8\u01c5\3\2\2\2\u01c8\u01c9"+
		"\3\2\2\2\u01c9\u01d7\3\2\2\2\u01ca\u01cb\7+\2\2\u01cb\u01cc\7\b\2\2\u01cc"+
		"\u01d1\7h\2\2\u01cd\u01ce\7\f\2\2\u01ce\u01d0\7h\2\2\u01cf\u01cd\3\2\2"+
		"\2\u01d0\u01d3\3\2\2\2\u01d1\u01cf\3\2\2\2\u01d1\u01d2\3\2\2\2\u01d2\u01d4"+
		"\3\2\2\2\u01d3\u01d1\3\2\2\2\u01d4\u01d7\7\t\2\2\u01d5\u01d7\7B\2\2\u01d6"+
		"\u01ac\3\2\2\2\u01d6\u01ad\3\2\2\2\u01d6\u01b1\3\2\2\2\u01d6\u01b7\3\2"+
		"\2\2\u01d6\u01b8\3\2\2\2\u01d6\u01b9\3\2\2\2\u01d6\u01bd\3\2\2\2\u01d6"+
		"\u01be\3\2\2\2\u01d6\u01bf\3\2\2\2\u01d6\u01c0\3\2\2\2\u01d6\u01c1\3\2"+
		"\2\2\u01d6\u01c2\3\2\2\2\u01d6\u01c3\3\2\2\2\u01d6\u01c4\3\2\2\2\u01d6"+
		"\u01ca\3\2\2\2\u01d6\u01d5\3\2\2\2\u01d7\67\3\2\2\2\u01d8\u01da\5:\36"+
		"\2\u01d9\u01d8\3\2\2\2\u01da\u01db\3\2\2\2\u01db\u01d9\3\2\2\2\u01db\u01dc"+
		"\3\2\2\2\u01dc9\3\2\2\2\u01dd\u01de\5\16\b\2\u01de\u01df\7\n\2\2\u01df"+
		"\u0232\3\2\2\2\u01e0\u01e2\7\4\2\2\u01e1\u01e3\58\35\2\u01e2\u01e1\3\2"+
		"\2\2\u01e2\u01e3\3\2\2\2\u01e3\u01e4\3\2\2\2\u01e4\u0232\7\5\2\2\u01e5"+
		"\u01e6\5D#\2\u01e6\u01e7\7\n\2\2\u01e7\u0232\3\2\2\2\u01e8\u01e9\7D\2"+
		"\2\u01e9\u01ea\7\b\2\2\u01ea\u01eb\5D#\2\u01eb\u01ec\7\t\2\2\u01ec\u01ef"+
		"\5:\36\2\u01ed\u01ee\7E\2\2\u01ee\u01f0\5:\36\2\u01ef\u01ed\3\2\2\2\u01ef"+
		"\u01f0\3\2\2\2\u01f0\u0232\3\2\2\2\u01f1\u01f3\5\66\34\2\u01f2\u01f1\3"+
		"\2\2\2\u01f3\u01f6\3\2\2\2\u01f4\u01f2\3\2\2\2\u01f4\u01f5\3\2\2\2\u01f5"+
		"\u01f7\3\2\2\2\u01f6\u01f4\3\2\2\2\u01f7\u01f8\7F\2\2\u01f8\u01f9\7\b"+
		"\2\2\u01f9\u01fa\5D#\2\u01fa\u01fb\7\t\2\2\u01fb\u01fc\5:\36\2\u01fc\u0232"+
		"\3\2\2\2\u01fd\u01ff\5\66\34\2\u01fe\u01fd\3\2\2\2\u01ff\u0202\3\2\2\2"+
		"\u0200\u01fe\3\2\2\2\u0200\u0201\3\2\2\2\u0201\u0203\3\2\2\2\u0202\u0200"+
		"\3\2\2\2\u0203\u0204\7G\2\2\u0204\u0205\5:\36\2\u0205\u0206\7F\2\2\u0206"+
		"\u0207\7\b\2\2\u0207\u0208\5D#\2\u0208\u0209\7\t\2\2\u0209\u020a\7\n\2"+
		"\2\u020a\u0232\3\2\2\2\u020b\u020d\5\66\34\2\u020c\u020b\3\2\2\2\u020d"+
		"\u0210\3\2\2\2\u020e\u020c\3\2\2\2\u020e\u020f\3\2\2\2\u020f\u0211\3\2"+
		"\2\2\u0210\u020e\3\2\2\2\u0211\u0212\7H\2\2\u0212\u0213\7\b\2\2\u0213"+
		"\u0214\5@!\2\u0214\u0215\7\t\2\2\u0215\u0216\5:\36\2\u0216\u0232\3\2\2"+
		"\2\u0217\u0218\7I\2\2\u0218\u0219\7\b\2\2\u0219\u021a\5D#\2\u021a\u021b"+
		"\7\t\2\2\u021b\u021c\7\4\2\2\u021c\u021d\5<\37\2\u021d\u021e\7\5\2\2\u021e"+
		"\u0232\3\2\2\2\u021f\u0221\7J\2\2\u0220\u0222\5D#\2\u0221\u0220\3\2\2"+
		"\2\u0221\u0222\3\2\2\2\u0222\u0223\3\2\2\2\u0223\u0232\7\n\2\2\u0224\u0225"+
		"\7K\2\2\u0225\u0232\7\n\2\2\u0226\u0227\7L\2\2\u0227\u0232\7\n\2\2\u0228"+
		"\u022a\7M\2\2\u0229\u022b\5L\'\2\u022a\u0229\3\2\2\2\u022a\u022b\3\2\2"+
		"\2\u022b\u022c\3\2\2\2\u022c\u022d\7\4\2\2\u022d\u022e\5P)\2\u022e\u022f"+
		"\7\u0088\2\2\u022f\u0232\3\2\2\2\u0230\u0232\5J&\2\u0231\u01dd\3\2\2\2"+
		"\u0231\u01e0\3\2\2\2\u0231\u01e5\3\2\2\2\u0231\u01e8\3\2\2\2\u0231\u01f4"+
		"\3\2\2\2\u0231\u0200\3\2\2\2\u0231\u020e\3\2\2\2\u0231\u0217\3\2\2\2\u0231"+
		"\u021f\3\2\2\2\u0231\u0224\3\2\2\2\u0231\u0226\3\2\2\2\u0231\u0228\3\2"+
		"\2\2\u0231\u0230\3\2\2\2\u0232;\3\2\2\2\u0233\u0235\5> \2\u0234\u0233"+
		"\3\2\2\2\u0235\u0236\3\2\2\2\u0236\u0234\3\2\2\2\u0236\u0237\3\2\2\2\u0237"+
		"\u023d\3\2\2\2\u0238\u0239\7N\2\2\u0239\u023b\7\13\2\2\u023a\u023c\58"+
		"\35\2\u023b\u023a\3\2\2\2\u023b\u023c\3\2\2\2\u023c\u023e\3\2\2\2\u023d"+
		"\u0238\3\2\2\2\u023d\u023e\3\2\2\2\u023e=\3\2\2\2\u023f\u0240\7O\2\2\u0240"+
		"\u0241\5F$\2\u0241\u0243\7\13\2\2\u0242\u0244\58\35\2\u0243\u0242\3\2"+
		"\2\2\u0243\u0244\3\2\2\2\u0244?\3\2\2\2\u0245\u0246\5B\"\2\u0246\u0247"+
		"\7\n\2\2\u0247\u0248\5D#\2\u0248\u024a\7\n\2\2\u0249\u024b\5D#\2\u024a"+
		"\u0249\3\2\2\2\u024a\u024b\3\2\2\2\u024b\u025c\3\2\2\2\u024c\u0250\5\26"+
		"\f\2\u024d\u024f\5\30\r\2\u024e\u024d\3\2\2\2\u024f\u0252\3\2\2\2\u0250"+
		"\u024e\3\2\2\2\u0250\u0251\3\2\2\2\u0251\u0254\3\2\2\2\u0252\u0250\3\2"+
		"\2\2\u0253\u024c\3\2\2\2\u0253\u0254\3\2\2\2\u0254\u0255\3\2\2\2\u0255"+
		"\u0256\7q\2\2\u0256\u0257\7\13\2\2\u0257\u0258\5F$\2\u0258\u0259\7\r\2"+
		"\2\u0259\u025a\5F$\2\u025a\u025c\3\2\2\2\u025b\u0245\3\2\2\2\u025b\u0253"+
		"\3\2\2\2\u025cA\3\2\2\2\u025d\u025f\5\16\b\2\u025e\u025d\3\2\2\2\u025e"+
		"\u025f\3\2\2\2\u025f\u0262\3\2\2\2\u0260\u0262\5D#\2\u0261\u025e\3\2\2"+
		"\2\u0261\u0260\3\2\2\2\u0262C\3\2\2\2\u0263\u0264\b#\1\2\u0264\u0265\5"+
		"F$\2\u0265\u026b\3\2\2\2\u0266\u0267\f\3\2\2\u0267\u0268\7\f\2\2\u0268"+
		"\u026a\5F$\2\u0269\u0266\3\2\2\2\u026a\u026d\3\2\2\2\u026b\u0269\3\2\2"+
		"\2\u026b\u026c\3\2\2\2\u026cE\3\2\2\2\u026d\u026b\3\2\2\2\u026e\u026f"+
		"\b$\1\2\u026f\u0270\7\b\2\2\u0270\u0271\5D#\2\u0271\u0272\7\t\2\2\u0272"+
		"\u02a5\3\2\2\2\u0273\u0274\7R\2\2\u0274\u0277\7\b\2\2\u0275\u0278\5F$"+
		"\2\u0276\u0278\5\34\17\2\u0277\u0275\3\2\2\2\u0277\u0276\3\2\2\2\u0278"+
		"\u0279\3\2\2\2\u0279\u027a\7\t\2\2\u027a\u02a5\3\2\2\2\u027b\u027c\7S"+
		"\2\2\u027c\u027f\7\b\2\2\u027d\u0280\5F$\2\u027e\u0280\5\34\17\2\u027f"+
		"\u027d\3\2\2\2\u027f\u027e\3\2\2\2\u0280\u0281\3\2\2\2\u0281\u0282\7\t"+
		"\2\2\u0282\u02a5\3\2\2\2\u0283\u0284\7\b\2\2\u0284\u0285\5\34\17\2\u0285"+
		"\u0286\7\t\2\2\u0286\u0287\5F$\32\u0287\u02a5\3\2\2\2\u0288\u0289\t\2"+
		"\2\2\u0289\u02a5\5F$\31\u028a\u028b\7\23\2\2\u028b\u02a5\5F$\27\u028c"+
		"\u028d\t\3\2\2\u028d\u02a5\5F$\26\u028e\u028f\t\4\2\2\u028f\u02a5\5F$"+
		"\22\u0290\u0291\7\4\2\2\u0291\u0296\5F$\2\u0292\u0293\7\f\2\2\u0293\u0295"+
		"\5F$\2\u0294\u0292\3\2\2\2\u0295\u0298\3\2\2\2\u0296\u0294\3\2\2\2\u0296"+
		"\u0297\3\2\2\2\u0297\u0299\3\2\2\2\u0298\u0296\3\2\2\2\u0299\u029a\7\5"+
		"\2\2\u029a\u02a5\3\2\2\2\u029b\u02a5\7q\2\2\u029c\u02a5\7h\2\2\u029d\u029f"+
		"\7_\2\2\u029e\u029d\3\2\2\2\u029f\u02a0\3\2\2\2\u02a0\u029e\3\2\2\2\u02a0"+
		"\u02a1\3\2\2\2\u02a1\u02a5\3\2\2\2\u02a2\u02a5\7`\2\2\u02a3\u02a5\7]\2"+
		"\2\u02a4\u026e\3\2\2\2\u02a4\u0273\3\2\2\2\u02a4\u027b\3\2\2\2\u02a4\u0283"+
		"\3\2\2\2\u02a4\u0288\3\2\2\2\u02a4\u028a\3\2\2\2\u02a4\u028c\3\2\2\2\u02a4"+
		"\u028e\3\2\2\2\u02a4\u0290\3\2\2\2\u02a4\u029b\3\2\2\2\u02a4\u029c\3\2"+
		"\2\2\u02a4\u029e\3\2\2\2\u02a4\u02a2\3\2\2\2\u02a4\u02a3\3\2\2\2\u02a5"+
		"\u02e2\3\2\2\2\u02a6\u02a7\f\25\2\2\u02a7\u02a8\t\5\2\2\u02a8\u02e1\5"+
		"F$\26\u02a9\u02aa\f\24\2\2\u02aa\u02ab\t\6\2\2\u02ab\u02e1\5F$\25\u02ac"+
		"\u02ad\f\23\2\2\u02ad\u02ae\t\7\2\2\u02ae\u02e1\5F$\24\u02af\u02b0\f\21"+
		"\2\2\u02b0\u02b1\t\b\2\2\u02b1\u02e1\5F$\22\u02b2\u02b3\f\20\2\2\u02b3"+
		"\u02b4\7\30\2\2\u02b4\u02e1\5F$\21\u02b5\u02b6\f\17\2\2\u02b6\u02b7\7"+
		"\32\2\2\u02b7\u02e1\5F$\20\u02b8\u02b9\f\16\2\2\u02b9\u02ba\7\33\2\2\u02ba"+
		"\u02e1\5F$\17\u02bb\u02bc\f\r\2\2\u02bc\u02bd\7$\2\2\u02bd\u02e1\5F$\16"+
		"\u02be\u02bf\f\f\2\2\u02bf\u02c0\7%\2\2\u02c0\u02e1\5F$\r\u02c1\u02c2"+
		"\f\13\2\2\u02c2\u02c3\7\16\2\2\u02c3\u02c4\5F$\2\u02c4\u02c5\7\13\2\2"+
		"\u02c5\u02c6\5F$\f\u02c6\u02e1\3\2\2\2\u02c7\u02c8\f\n\2\2\u02c8\u02c9"+
		"\7&\2\2\u02c9\u02e1\5F$\n\u02ca\u02cb\f\t\2\2\u02cb\u02cc\7\'\2\2\u02cc"+
		"\u02e1\5F$\t\u02cd\u02ce\f \2\2\u02ce\u02cf\7\17\2\2\u02cf\u02e1\7q\2"+
		"\2\u02d0\u02d1\f\37\2\2\u02d1\u02d2\7\20\2\2\u02d2\u02e1\7q\2\2\u02d3"+
		"\u02d4\f\36\2\2\u02d4\u02d6\7\b\2\2\u02d5\u02d7\5H%\2\u02d6\u02d5\3\2"+
		"\2\2\u02d6\u02d7\3\2\2\2\u02d7\u02d8\3\2\2\2\u02d8\u02e1\7\t\2\2\u02d9"+
		"\u02da\f\33\2\2\u02da\u02db\7\6\2\2\u02db\u02dc\5D#\2\u02dc\u02dd\7\7"+
		"\2\2\u02dd\u02e1\3\2\2\2\u02de\u02df\f\30\2\2\u02df\u02e1\t\2\2\2\u02e0"+
		"\u02a6\3\2\2\2\u02e0\u02a9\3\2\2\2\u02e0\u02ac\3\2\2\2\u02e0\u02af\3\2"+
		"\2\2\u02e0\u02b2\3\2\2\2\u02e0\u02b5\3\2\2\2\u02e0\u02b8\3\2\2\2\u02e0"+
		"\u02bb\3\2\2\2\u02e0\u02be\3\2\2\2\u02e0\u02c1\3\2\2\2\u02e0\u02c7\3\2"+
		"\2\2\u02e0\u02ca\3\2\2\2\u02e0\u02cd\3\2\2\2\u02e0\u02d0\3\2\2\2\u02e0"+
		"\u02d3\3\2\2\2\u02e0\u02d9\3\2\2\2\u02e0\u02de\3\2\2\2\u02e1\u02e4\3\2"+
		"\2\2\u02e2\u02e0\3\2\2\2\u02e2\u02e3\3\2\2\2\u02e3G\3\2\2\2\u02e4\u02e2"+
		"\3\2\2\2\u02e5\u02ea\5F$\2\u02e6\u02e7\7\f\2\2\u02e7\u02e9\5F$\2\u02e8"+
		"\u02e6\3\2\2\2\u02e9\u02ec\3\2\2\2\u02ea\u02e8\3\2\2\2\u02ea\u02eb\3\2"+
		"\2\2\u02ebI\3\2\2\2\u02ec\u02ea\3\2\2\2\u02ed\u02ef\7T\2\2\u02ee\u02f0"+
		"\5L\'\2\u02ef\u02ee\3\2\2\2\u02ef\u02f0\3\2\2\2\u02f0\u02f1\3\2\2\2\u02f1"+
		"\u02f2\7^\2\2\u02f2K\3\2\2\2\u02f3\u02f4\7\b\2\2\u02f4\u02f9\5N(\2\u02f5"+
		"\u02f6\7\f\2\2\u02f6\u02f8\5N(\2\u02f7\u02f5\3\2\2\2\u02f8\u02fb\3\2\2"+
		"\2\u02f9\u02f7\3\2\2\2\u02f9\u02fa\3\2\2\2\u02fa\u02fc\3\2\2\2\u02fb\u02f9"+
		"\3\2\2\2\u02fc\u02fd\7\t\2\2\u02fdM\3\2\2\2\u02fe\u02ff\7U\2\2\u02ff\u030e"+
		"\7_\2\2\u0300\u0301\7V\2\2\u0301\u030e\7q\2\2\u0302\u0303\7W\2\2\u0303"+
		"\u030e\7_\2\2\u0304\u0305\7X\2\2\u0305\u030e\5F$\2\u0306\u0307\7Y\2\2"+
		"\u0307\u030e\5F$\2\u0308\u030b\7,\2\2\u0309\u030c\7\67\2\2\u030a\u030c"+
		"\5F$\2\u030b\u0309\3\2\2\2\u030b\u030a\3\2\2\2\u030c\u030e\3\2\2\2\u030d"+
		"\u02fe\3\2\2\2\u030d\u0300\3\2\2\2\u030d\u0302\3\2\2\2\u030d\u0304\3\2"+
		"\2\2\u030d\u0306\3\2\2\2\u030d\u0308\3\2\2\2\u030eO\3\2\2\2\u030f\u0311"+
		"\5R*\2\u0310\u030f\3\2\2\2\u0311\u0314\3\2\2\2\u0312\u0310\3\2\2\2\u0312"+
		"\u0313\3\2\2\2\u0313Q\3\2\2\2\u0314\u0312\3\2\2\2\u0315\u0319\5T+\2\u0316"+
		"\u0319\5V,\2\u0317\u0319\5X-\2\u0318\u0315\3\2\2\2\u0318\u0316\3\2\2\2"+
		"\u0318\u0317\3\2\2\2\u0319S\3\2\2\2\u031a\u031b\7\u0095\2\2\u031b\u031f"+
		"\7x\2\2\u031c\u031d\7\u0094\2\2\u031d\u031f\7x\2\2\u031e\u031a\3\2\2\2"+
		"\u031e\u031c\3\2\2\2\u031fU\3\2\2\2\u0320\u0322\7v\2\2\u0321\u0323\5Z"+
		".\2\u0322\u0321\3\2\2\2\u0322\u0323\3\2\2\2\u0323W\3\2\2\2\u0324\u0325"+
		"\7u\2\2\u0325\u032a\5\\/\2\u0326\u0327\7y\2\2\u0327\u0329\5\\/\2\u0328"+
		"\u0326\3\2\2\2\u0329\u032c\3\2\2\2\u032a\u0328\3\2\2\2\u032a\u032b\3\2"+
		"\2\2\u032bY\3\2\2\2\u032c\u032a\3\2\2\2\u032d\u0345\5\\/\2\u032e\u032f"+
		"\7w\2\2\u032f\u0345\5\\/\2\u0330\u0331\5\\/\2\u0331\u0332\7y\2\2\u0332"+
		"\u0333\7\u0095\2\2\u0333\u0345\3\2\2\2\u0334\u0335\7z\2\2\u0335\u0336"+
		"\5\\/\2\u0336\u0337\7{\2\2\u0337\u0338\7y\2\2\u0338\u0339\7\u0095\2\2"+
		"\u0339\u0345\3\2\2\2\u033a\u033b\7z\2\2\u033b\u033c\5\\/\2\u033c\u033d"+
		"\7y\2\2\u033d\u033e\7\u0095\2\2\u033e\u033f\7{\2\2\u033f\u0345\3\2\2\2"+
		"\u0340\u0341\7z\2\2\u0341\u0342\5\\/\2\u0342\u0343\7{\2\2\u0343\u0345"+
		"\3\2\2\2\u0344\u032d\3\2\2\2\u0344\u032e\3\2\2\2\u0344\u0330\3\2\2\2\u0344"+
		"\u0334\3\2\2\2\u0344\u033a\3\2\2\2\u0344\u0340\3\2\2\2\u0345[\3\2\2\2"+
		"\u0346\u0347\b/\1\2\u0347\u0348\7|\2\2\u0348\u0349\5\\/\2\u0349\u034a"+
		"\7}\2\2\u034a\u0355\3\2\2\2\u034b\u034c\t\t\2\2\u034c\u0355\5\\/\n\u034d"+
		"\u0355\7\u0095\2\2\u034e\u0355\7\u0093\2\2\u034f\u0350\7\u0087\2\2\u0350"+
		"\u0351\7\u0095\2\2\u0351\u0355\7\u0088\2\2\u0352\u0355\7\u0089\2\2\u0353"+
		"\u0355\7\u0092\2\2\u0354\u0346\3\2\2\2\u0354\u034b\3\2\2\2\u0354\u034d"+
		"\3\2\2\2\u0354\u034e\3\2\2\2\u0354\u034f\3\2\2\2\u0354\u0352\3\2\2\2\u0354"+
		"\u0353\3\2\2\2\u0355\u0364\3\2\2\2\u0356\u0357\f\f\2\2\u0357\u0358\7~"+
		"\2\2\u0358\u0363\5\\/\r\u0359\u035a\f\13\2\2\u035a\u035b\t\n\2\2\u035b"+
		"\u0363\5\\/\f\u035c\u035d\f\t\2\2\u035d\u035e\t\13\2\2\u035e\u0363\5\\"+
		"/\n\u035f\u0360\f\b\2\2\u0360\u0361\t\f\2\2\u0361\u0363\5\\/\t\u0362\u0356"+
		"\3\2\2\2\u0362\u0359\3\2\2\2\u0362\u035c\3\2\2\2\u0362\u035f\3\2\2\2\u0363"+
		"\u0366\3\2\2\2\u0364\u0362\3\2\2\2\u0364\u0365\3\2\2\2\u0365]\3\2\2\2"+
		"\u0366\u0364\3\2\2\2Vgl\u0080\u0089\u0093\u0099\u00a1\u00a8\u00b1\u00b6"+
		"\u00bc\u00c1\u00c6\u00cd\u00d4\u00d9\u00e5\u00e8\u00ea\u00f5\u00fc\u0101"+
		"\u0107\u0109\u0111\u0117\u0123\u0131\u0137\u013d\u0143\u0148\u0151\u0158"+
		"\u015e\u0169\u01a6\u01aa\u01b5\u01c8\u01d1\u01d6\u01db\u01e2\u01ef\u01f4"+
		"\u0200\u020e\u0221\u022a\u0231\u0236\u023b\u023d\u0243\u024a\u0250\u0253"+
		"\u025b\u025e\u0261\u026b\u0277\u027f\u0296\u02a0\u02a4\u02d6\u02e0\u02e2"+
		"\u02ea\u02ef\u02f9\u030b\u030d\u0312\u0318\u031e\u0322\u032a\u0344\u0354"+
		"\u0362\u0364";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}
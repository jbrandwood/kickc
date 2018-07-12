// Generated from C:/c64/kickc/src/main/java/dk/camelot64/kickc/parser\KickC.g4 by ANTLR 4.7
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
		T__0=1, T__1=2, T__2=3, T__3=4, T__4=5, T__5=6, T__6=7, T__7=8, T__8=9, 
		T__9=10, T__10=11, T__11=12, T__12=13, T__13=14, T__14=15, T__15=16, T__16=17, 
		T__17=18, T__18=19, T__19=20, T__20=21, T__21=22, T__22=23, T__23=24, 
		T__24=25, T__25=26, T__26=27, T__27=28, T__28=29, T__29=30, T__30=31, 
		T__31=32, T__32=33, T__33=34, T__34=35, T__35=36, T__36=37, T__37=38, 
		T__38=39, T__39=40, T__40=41, T__41=42, T__42=43, T__43=44, T__44=45, 
		T__45=46, T__46=47, T__47=48, T__48=49, T__49=50, T__50=51, T__51=52, 
		T__52=53, T__53=54, T__54=55, T__55=56, T__56=57, T__57=58, T__58=59, 
		T__59=60, T__60=61, T__61=62, T__62=63, MNEMONIC=64, KICKASM=65, SIMPLETYPE=66, 
		STRING=67, CHAR=68, BOOLEAN=69, NUMBER=70, NUMFLOAT=71, BINFLOAT=72, DECFLOAT=73, 
		HEXFLOAT=74, NUMINT=75, BININTEGER=76, DECINTEGER=77, HEXINTEGER=78, NAME=79, 
		ASMREL=80, WS=81, COMMENT_LINE=82, COMMENT_BLOCK=83;
	public static final int
		RULE_file = 0, RULE_asmFile = 1, RULE_importSeq = 2, RULE_importDecl = 3, 
		RULE_declSeq = 4, RULE_decl = 5, RULE_declVariable = 6, RULE_declFunction = 7, 
		RULE_declKasm = 8, RULE_kasmParams = 9, RULE_kasmParam = 10, RULE_kasmResourceList = 11, 
		RULE_kasmParamList = 12, RULE_parameterListDecl = 13, RULE_parameterDecl = 14, 
		RULE_directive = 15, RULE_stmtSeq = 16, RULE_stmt = 17, RULE_forDeclaration = 18, 
		RULE_forIteration = 19, RULE_typeDecl = 20, RULE_expr = 21, RULE_parameterList = 22, 
		RULE_asmLines = 23, RULE_asmLine = 24, RULE_asmLabel = 25, RULE_asmInstruction = 26, 
		RULE_asmBytes = 27, RULE_asmParamMode = 28, RULE_asmExpr = 29;
	public static final String[] ruleNames = {
		"file", "asmFile", "importSeq", "importDecl", "declSeq", "decl", "declVariable", 
		"declFunction", "declKasm", "kasmParams", "kasmParam", "kasmResourceList", 
		"kasmParamList", "parameterListDecl", "parameterDecl", "directive", "stmtSeq", 
		"stmt", "forDeclaration", "forIteration", "typeDecl", "expr", "parameterList", 
		"asmLines", "asmLine", "asmLabel", "asmInstruction", "asmBytes", "asmParamMode", 
		"asmExpr"
	};

	private static final String[] _LITERAL_NAMES = {
		null, "'import'", "'='", "';'", "'('", "')'", "'{'", "'}'", "'kickasm'", 
		"'resources'", "'clobber'", "'param'", "','", "':'", "'const'", "'extern'", 
		"'align'", "'register'", "'inline'", "'if'", "'else'", "'while'", "'do'", 
		"'for'", "'return'", "'asm'", "'..'", "'signed'", "'*'", "'['", "']'", 
		"'--'", "'++'", "'+'", "'-'", "'!'", "'&'", "'~'", "'>>'", "'<<'", "'/'", 
		"'%'", "'<'", "'>'", "'=='", "'!='", "'<='", "'>='", "'^'", "'|'", "'&&'", 
		"'||'", "'+='", "'-='", "'*='", "'/='", "'%='", "'<<='", "'>>='", "'&='", 
		"'|='", "'^='", "'.byte'", "'#'"
	};
	private static final String[] _SYMBOLIC_NAMES = {
		null, null, null, null, null, null, null, null, null, null, null, null, 
		null, null, null, null, null, null, null, null, null, null, null, null, 
		null, null, null, null, null, null, null, null, null, null, null, null, 
		null, null, null, null, null, null, null, null, null, null, null, null, 
		null, null, null, null, null, null, null, null, null, null, null, null, 
		null, null, null, null, "MNEMONIC", "KICKASM", "SIMPLETYPE", "STRING", 
		"CHAR", "BOOLEAN", "NUMBER", "NUMFLOAT", "BINFLOAT", "DECFLOAT", "HEXFLOAT", 
		"NUMINT", "BININTEGER", "DECINTEGER", "HEXINTEGER", "NAME", "ASMREL", 
		"WS", "COMMENT_LINE", "COMMENT_BLOCK"
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
	public String getGrammarFileName() { return "KickC.g4"; }

	@Override
	public String[] getRuleNames() { return ruleNames; }

	@Override
	public String getSerializedATN() { return _serializedATN; }

	@Override
	public ATN getATN() { return _ATN; }

	public KickCParser(TokenStream input) {
		super(input);
		_interp = new ParserATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}
	public static class FileContext extends ParserRuleContext {
		public ImportSeqContext importSeq() {
			return getRuleContext(ImportSeqContext.class,0);
		}
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
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterFile(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitFile(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitFile(this);
			else return visitor.visitChildren(this);
		}
	}

	public final FileContext file() throws RecognitionException {
		FileContext _localctx = new FileContext(_ctx, getState());
		enterRule(_localctx, 0, RULE_file);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(60);
			importSeq();
			setState(61);
			declSeq();
			setState(62);
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
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterAsmFile(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitAsmFile(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitAsmFile(this);
			else return visitor.visitChildren(this);
		}
	}

	public final AsmFileContext asmFile() throws RecognitionException {
		AsmFileContext _localctx = new AsmFileContext(_ctx, getState());
		enterRule(_localctx, 2, RULE_asmFile);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(64);
			asmLines();
			setState(65);
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

	public static class ImportSeqContext extends ParserRuleContext {
		public List<ImportDeclContext> importDecl() {
			return getRuleContexts(ImportDeclContext.class);
		}
		public ImportDeclContext importDecl(int i) {
			return getRuleContext(ImportDeclContext.class,i);
		}
		public ImportSeqContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_importSeq; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterImportSeq(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitImportSeq(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitImportSeq(this);
			else return visitor.visitChildren(this);
		}
	}

	public final ImportSeqContext importSeq() throws RecognitionException {
		ImportSeqContext _localctx = new ImportSeqContext(_ctx, getState());
		enterRule(_localctx, 4, RULE_importSeq);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(70);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==T__0) {
				{
				{
				setState(67);
				importDecl();
				}
				}
				setState(72);
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

	public static class ImportDeclContext extends ParserRuleContext {
		public TerminalNode STRING() { return getToken(KickCParser.STRING, 0); }
		public ImportDeclContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_importDecl; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterImportDecl(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitImportDecl(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitImportDecl(this);
			else return visitor.visitChildren(this);
		}
	}

	public final ImportDeclContext importDecl() throws RecognitionException {
		ImportDeclContext _localctx = new ImportDeclContext(_ctx, getState());
		enterRule(_localctx, 6, RULE_importDecl);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(73);
			match(T__0);
			setState(74);
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
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterDeclSeq(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitDeclSeq(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitDeclSeq(this);
			else return visitor.visitChildren(this);
		}
	}

	public final DeclSeqContext declSeq() throws RecognitionException {
		DeclSeqContext _localctx = new DeclSeqContext(_ctx, getState());
		enterRule(_localctx, 8, RULE_declSeq);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(77); 
			_errHandler.sync(this);
			_la = _input.LA(1);
			do {
				{
				{
				setState(76);
				decl();
				}
				}
				setState(79); 
				_errHandler.sync(this);
				_la = _input.LA(1);
			} while ( ((((_la - 8)) & ~0x3f) == 0 && ((1L << (_la - 8)) & ((1L << (T__7 - 8)) | (1L << (T__13 - 8)) | (1L << (T__14 - 8)) | (1L << (T__15 - 8)) | (1L << (T__16 - 8)) | (1L << (T__17 - 8)) | (1L << (T__26 - 8)) | (1L << (SIMPLETYPE - 8)))) != 0) );
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
		public DeclVariableContext declVariable() {
			return getRuleContext(DeclVariableContext.class,0);
		}
		public DeclFunctionContext declFunction() {
			return getRuleContext(DeclFunctionContext.class,0);
		}
		public DeclKasmContext declKasm() {
			return getRuleContext(DeclKasmContext.class,0);
		}
		public DeclContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_decl; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterDecl(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitDecl(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitDecl(this);
			else return visitor.visitChildren(this);
		}
	}

	public final DeclContext decl() throws RecognitionException {
		DeclContext _localctx = new DeclContext(_ctx, getState());
		enterRule(_localctx, 10, RULE_decl);
		try {
			setState(84);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,2,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				setState(81);
				declVariable();
				}
				break;
			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(82);
				declFunction();
				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(83);
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

	public static class DeclVariableContext extends ParserRuleContext {
		public TypeDeclContext typeDecl() {
			return getRuleContext(TypeDeclContext.class,0);
		}
		public TerminalNode NAME() { return getToken(KickCParser.NAME, 0); }
		public List<DirectiveContext> directive() {
			return getRuleContexts(DirectiveContext.class);
		}
		public DirectiveContext directive(int i) {
			return getRuleContext(DirectiveContext.class,i);
		}
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public DeclVariableContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_declVariable; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterDeclVariable(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitDeclVariable(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitDeclVariable(this);
			else return visitor.visitChildren(this);
		}
	}

	public final DeclVariableContext declVariable() throws RecognitionException {
		DeclVariableContext _localctx = new DeclVariableContext(_ctx, getState());
		enterRule(_localctx, 12, RULE_declVariable);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(89);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__13) | (1L << T__14) | (1L << T__15) | (1L << T__16) | (1L << T__17))) != 0)) {
				{
				{
				setState(86);
				directive();
				}
				}
				setState(91);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(92);
			typeDecl(0);
			setState(96);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__13) | (1L << T__14) | (1L << T__15) | (1L << T__16) | (1L << T__17))) != 0)) {
				{
				{
				setState(93);
				directive();
				}
				}
				setState(98);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(99);
			match(NAME);
			setState(102);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__1) {
				{
				setState(100);
				match(T__1);
				setState(101);
				expr(0);
				}
			}

			setState(104);
			match(T__2);
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
		public TypeDeclContext typeDecl() {
			return getRuleContext(TypeDeclContext.class,0);
		}
		public TerminalNode NAME() { return getToken(KickCParser.NAME, 0); }
		public List<DirectiveContext> directive() {
			return getRuleContexts(DirectiveContext.class);
		}
		public DirectiveContext directive(int i) {
			return getRuleContext(DirectiveContext.class,i);
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
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterDeclFunction(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitDeclFunction(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitDeclFunction(this);
			else return visitor.visitChildren(this);
		}
	}

	public final DeclFunctionContext declFunction() throws RecognitionException {
		DeclFunctionContext _localctx = new DeclFunctionContext(_ctx, getState());
		enterRule(_localctx, 14, RULE_declFunction);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(109);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__13) | (1L << T__14) | (1L << T__15) | (1L << T__16) | (1L << T__17))) != 0)) {
				{
				{
				setState(106);
				directive();
				}
				}
				setState(111);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(112);
			typeDecl(0);
			setState(116);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__13) | (1L << T__14) | (1L << T__15) | (1L << T__16) | (1L << T__17))) != 0)) {
				{
				{
				setState(113);
				directive();
				}
				}
				setState(118);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(119);
			match(NAME);
			setState(120);
			match(T__3);
			setState(122);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (((((_la - 14)) & ~0x3f) == 0 && ((1L << (_la - 14)) & ((1L << (T__13 - 14)) | (1L << (T__14 - 14)) | (1L << (T__15 - 14)) | (1L << (T__16 - 14)) | (1L << (T__17 - 14)) | (1L << (T__26 - 14)) | (1L << (SIMPLETYPE - 14)))) != 0)) {
				{
				setState(121);
				parameterListDecl();
				}
			}

			setState(124);
			match(T__4);
			setState(125);
			match(T__5);
			setState(127);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__3) | (1L << T__5) | (1L << T__7) | (1L << T__13) | (1L << T__14) | (1L << T__15) | (1L << T__16) | (1L << T__17) | (1L << T__18) | (1L << T__20) | (1L << T__21) | (1L << T__22) | (1L << T__23) | (1L << T__24) | (1L << T__26) | (1L << T__27) | (1L << T__30) | (1L << T__31) | (1L << T__32) | (1L << T__33) | (1L << T__34) | (1L << T__35) | (1L << T__36) | (1L << T__41) | (1L << T__42))) != 0) || ((((_la - 66)) & ~0x3f) == 0 && ((1L << (_la - 66)) & ((1L << (SIMPLETYPE - 66)) | (1L << (STRING - 66)) | (1L << (CHAR - 66)) | (1L << (BOOLEAN - 66)) | (1L << (NUMBER - 66)) | (1L << (NAME - 66)))) != 0)) {
				{
				setState(126);
				stmtSeq();
				}
			}

			setState(129);
			match(T__6);
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
		public KasmParamsContext kasmParams() {
			return getRuleContext(KasmParamsContext.class,0);
		}
		public DeclKasmContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_declKasm; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterDeclKasm(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitDeclKasm(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitDeclKasm(this);
			else return visitor.visitChildren(this);
		}
	}

	public final DeclKasmContext declKasm() throws RecognitionException {
		DeclKasmContext _localctx = new DeclKasmContext(_ctx, getState());
		enterRule(_localctx, 16, RULE_declKasm);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(131);
			match(T__7);
			setState(133);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__3) {
				{
				setState(132);
				kasmParams();
				}
			}

			setState(135);
			match(KICKASM);
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

	public static class KasmParamsContext extends ParserRuleContext {
		public List<KasmParamContext> kasmParam() {
			return getRuleContexts(KasmParamContext.class);
		}
		public KasmParamContext kasmParam(int i) {
			return getRuleContext(KasmParamContext.class,i);
		}
		public KasmParamsContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_kasmParams; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterKasmParams(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitKasmParams(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitKasmParams(this);
			else return visitor.visitChildren(this);
		}
	}

	public final KasmParamsContext kasmParams() throws RecognitionException {
		KasmParamsContext _localctx = new KasmParamsContext(_ctx, getState());
		enterRule(_localctx, 18, RULE_kasmParams);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(137);
			match(T__3);
			setState(138);
			kasmParam();
			setState(143);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==T__2) {
				{
				{
				setState(139);
				match(T__2);
				setState(140);
				kasmParam();
				}
				}
				setState(145);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(146);
			match(T__4);
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

	public static class KasmParamContext extends ParserRuleContext {
		public KasmResourceListContext kasmResourceList() {
			return getRuleContext(KasmResourceListContext.class,0);
		}
		public TerminalNode STRING() { return getToken(KickCParser.STRING, 0); }
		public KasmParamListContext kasmParamList() {
			return getRuleContext(KasmParamListContext.class,0);
		}
		public KasmParamContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_kasmParam; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterKasmParam(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitKasmParam(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitKasmParam(this);
			else return visitor.visitChildren(this);
		}
	}

	public final KasmParamContext kasmParam() throws RecognitionException {
		KasmParamContext _localctx = new KasmParamContext(_ctx, getState());
		enterRule(_localctx, 20, RULE_kasmParam);
		try {
			setState(154);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case T__8:
				enterOuterAlt(_localctx, 1);
				{
				setState(148);
				match(T__8);
				setState(149);
				kasmResourceList();
				}
				break;
			case T__9:
				enterOuterAlt(_localctx, 2);
				{
				setState(150);
				match(T__9);
				setState(151);
				match(STRING);
				}
				break;
			case T__10:
				enterOuterAlt(_localctx, 3);
				{
				setState(152);
				match(T__10);
				setState(153);
				kasmParamList();
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

	public static class KasmResourceListContext extends ParserRuleContext {
		public List<TerminalNode> STRING() { return getTokens(KickCParser.STRING); }
		public TerminalNode STRING(int i) {
			return getToken(KickCParser.STRING, i);
		}
		public KasmResourceListContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_kasmResourceList; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterKasmResourceList(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitKasmResourceList(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitKasmResourceList(this);
			else return visitor.visitChildren(this);
		}
	}

	public final KasmResourceListContext kasmResourceList() throws RecognitionException {
		KasmResourceListContext _localctx = new KasmResourceListContext(_ctx, getState());
		enterRule(_localctx, 22, RULE_kasmResourceList);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(156);
			match(STRING);
			setState(161);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==T__11) {
				{
				{
				setState(157);
				match(T__11);
				setState(158);
				match(STRING);
				}
				}
				setState(163);
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

	public static class KasmParamListContext extends ParserRuleContext {
		public List<TerminalNode> NAME() { return getTokens(KickCParser.NAME); }
		public TerminalNode NAME(int i) {
			return getToken(KickCParser.NAME, i);
		}
		public List<ExprContext> expr() {
			return getRuleContexts(ExprContext.class);
		}
		public ExprContext expr(int i) {
			return getRuleContext(ExprContext.class,i);
		}
		public KasmParamListContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_kasmParamList; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterKasmParamList(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitKasmParamList(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitKasmParamList(this);
			else return visitor.visitChildren(this);
		}
	}

	public final KasmParamListContext kasmParamList() throws RecognitionException {
		KasmParamListContext _localctx = new KasmParamListContext(_ctx, getState());
		enterRule(_localctx, 24, RULE_kasmParamList);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(164);
			match(NAME);
			setState(165);
			match(T__12);
			setState(166);
			expr(0);
			setState(173);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==T__11) {
				{
				{
				setState(167);
				match(T__11);
				setState(168);
				match(NAME);
				setState(169);
				match(T__12);
				setState(170);
				expr(0);
				}
				}
				setState(175);
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

	public static class ParameterListDeclContext extends ParserRuleContext {
		public List<ParameterDeclContext> parameterDecl() {
			return getRuleContexts(ParameterDeclContext.class);
		}
		public ParameterDeclContext parameterDecl(int i) {
			return getRuleContext(ParameterDeclContext.class,i);
		}
		public ParameterListDeclContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_parameterListDecl; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterParameterListDecl(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitParameterListDecl(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitParameterListDecl(this);
			else return visitor.visitChildren(this);
		}
	}

	public final ParameterListDeclContext parameterListDecl() throws RecognitionException {
		ParameterListDeclContext _localctx = new ParameterListDeclContext(_ctx, getState());
		enterRule(_localctx, 26, RULE_parameterListDecl);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(176);
			parameterDecl();
			setState(181);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==T__11) {
				{
				{
				setState(177);
				match(T__11);
				setState(178);
				parameterDecl();
				}
				}
				setState(183);
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
		public TypeDeclContext typeDecl() {
			return getRuleContext(TypeDeclContext.class,0);
		}
		public TerminalNode NAME() { return getToken(KickCParser.NAME, 0); }
		public List<DirectiveContext> directive() {
			return getRuleContexts(DirectiveContext.class);
		}
		public DirectiveContext directive(int i) {
			return getRuleContext(DirectiveContext.class,i);
		}
		public ParameterDeclContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_parameterDecl; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterParameterDecl(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitParameterDecl(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitParameterDecl(this);
			else return visitor.visitChildren(this);
		}
	}

	public final ParameterDeclContext parameterDecl() throws RecognitionException {
		ParameterDeclContext _localctx = new ParameterDeclContext(_ctx, getState());
		enterRule(_localctx, 28, RULE_parameterDecl);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(187);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__13) | (1L << T__14) | (1L << T__15) | (1L << T__16) | (1L << T__17))) != 0)) {
				{
				{
				setState(184);
				directive();
				}
				}
				setState(189);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(190);
			typeDecl(0);
			setState(194);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__13) | (1L << T__14) | (1L << T__15) | (1L << T__16) | (1L << T__17))) != 0)) {
				{
				{
				setState(191);
				directive();
				}
				}
				setState(196);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(197);
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
		public DirectiveInlineContext(DirectiveContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterDirectiveInline(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitDirectiveInline(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitDirectiveInline(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class DirectiveExternContext extends DirectiveContext {
		public DirectiveExternContext(DirectiveContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterDirectiveExtern(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitDirectiveExtern(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitDirectiveExtern(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class DirectiveConstContext extends DirectiveContext {
		public DirectiveConstContext(DirectiveContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterDirectiveConst(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitDirectiveConst(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitDirectiveConst(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class DirectiveAlignContext extends DirectiveContext {
		public TerminalNode NUMBER() { return getToken(KickCParser.NUMBER, 0); }
		public DirectiveAlignContext(DirectiveContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterDirectiveAlign(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitDirectiveAlign(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitDirectiveAlign(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class DirectiveRegisterContext extends DirectiveContext {
		public TerminalNode NAME() { return getToken(KickCParser.NAME, 0); }
		public DirectiveRegisterContext(DirectiveContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterDirectiveRegister(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitDirectiveRegister(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitDirectiveRegister(this);
			else return visitor.visitChildren(this);
		}
	}

	public final DirectiveContext directive() throws RecognitionException {
		DirectiveContext _localctx = new DirectiveContext(_ctx, getState());
		enterRule(_localctx, 30, RULE_directive);
		try {
			setState(210);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case T__13:
				_localctx = new DirectiveConstContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(199);
				match(T__13);
				}
				break;
			case T__14:
				_localctx = new DirectiveExternContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(200);
				match(T__14);
				}
				break;
			case T__15:
				_localctx = new DirectiveAlignContext(_localctx);
				enterOuterAlt(_localctx, 3);
				{
				setState(201);
				match(T__15);
				setState(202);
				match(T__3);
				setState(203);
				match(NUMBER);
				setState(204);
				match(T__4);
				}
				break;
			case T__16:
				_localctx = new DirectiveRegisterContext(_localctx);
				enterOuterAlt(_localctx, 4);
				{
				setState(205);
				match(T__16);
				setState(206);
				match(T__3);
				setState(207);
				match(NAME);
				setState(208);
				match(T__4);
				}
				break;
			case T__17:
				_localctx = new DirectiveInlineContext(_localctx);
				enterOuterAlt(_localctx, 5);
				{
				setState(209);
				match(T__17);
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
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterStmtSeq(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitStmtSeq(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitStmtSeq(this);
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
			setState(213); 
			_errHandler.sync(this);
			_la = _input.LA(1);
			do {
				{
				{
				setState(212);
				stmt();
				}
				}
				setState(215); 
				_errHandler.sync(this);
				_la = _input.LA(1);
			} while ( (((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__3) | (1L << T__5) | (1L << T__7) | (1L << T__13) | (1L << T__14) | (1L << T__15) | (1L << T__16) | (1L << T__17) | (1L << T__18) | (1L << T__20) | (1L << T__21) | (1L << T__22) | (1L << T__23) | (1L << T__24) | (1L << T__26) | (1L << T__27) | (1L << T__30) | (1L << T__31) | (1L << T__32) | (1L << T__33) | (1L << T__34) | (1L << T__35) | (1L << T__36) | (1L << T__41) | (1L << T__42))) != 0) || ((((_la - 66)) & ~0x3f) == 0 && ((1L << (_la - 66)) & ((1L << (SIMPLETYPE - 66)) | (1L << (STRING - 66)) | (1L << (CHAR - 66)) | (1L << (BOOLEAN - 66)) | (1L << (NUMBER - 66)) | (1L << (NAME - 66)))) != 0) );
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
		public DeclVariableContext declVariable() {
			return getRuleContext(DeclVariableContext.class,0);
		}
		public StmtDeclVarContext(StmtContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterStmtDeclVar(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitStmtDeclVar(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitStmtDeclVar(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class StmtBlockContext extends StmtContext {
		public StmtSeqContext stmtSeq() {
			return getRuleContext(StmtSeqContext.class,0);
		}
		public StmtBlockContext(StmtContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterStmtBlock(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitStmtBlock(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitStmtBlock(this);
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
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterStmtDeclKasm(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitStmtDeclKasm(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitStmtDeclKasm(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class StmtExprContext extends StmtContext {
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public StmtExprContext(StmtContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterStmtExpr(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitStmtExpr(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitStmtExpr(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class StmtWhileContext extends StmtContext {
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public StmtContext stmt() {
			return getRuleContext(StmtContext.class,0);
		}
		public DirectiveContext directive() {
			return getRuleContext(DirectiveContext.class,0);
		}
		public StmtWhileContext(StmtContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterStmtWhile(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitStmtWhile(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitStmtWhile(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class StmtDoWhileContext extends StmtContext {
		public StmtContext stmt() {
			return getRuleContext(StmtContext.class,0);
		}
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public DirectiveContext directive() {
			return getRuleContext(DirectiveContext.class,0);
		}
		public StmtDoWhileContext(StmtContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterStmtDoWhile(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitStmtDoWhile(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitStmtDoWhile(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class StmtForContext extends StmtContext {
		public ForIterationContext forIteration() {
			return getRuleContext(ForIterationContext.class,0);
		}
		public StmtContext stmt() {
			return getRuleContext(StmtContext.class,0);
		}
		public DirectiveContext directive() {
			return getRuleContext(DirectiveContext.class,0);
		}
		public ForDeclarationContext forDeclaration() {
			return getRuleContext(ForDeclarationContext.class,0);
		}
		public StmtForContext(StmtContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterStmtFor(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitStmtFor(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitStmtFor(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class StmtAsmContext extends StmtContext {
		public AsmLinesContext asmLines() {
			return getRuleContext(AsmLinesContext.class,0);
		}
		public StmtAsmContext(StmtContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterStmtAsm(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitStmtAsm(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitStmtAsm(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class StmtIfElseContext extends StmtContext {
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public List<StmtContext> stmt() {
			return getRuleContexts(StmtContext.class);
		}
		public StmtContext stmt(int i) {
			return getRuleContext(StmtContext.class,i);
		}
		public StmtIfElseContext(StmtContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterStmtIfElse(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitStmtIfElse(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitStmtIfElse(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class StmtReturnContext extends StmtContext {
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public StmtReturnContext(StmtContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterStmtReturn(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitStmtReturn(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitStmtReturn(this);
			else return visitor.visitChildren(this);
		}
	}

	public final StmtContext stmt() throws RecognitionException {
		StmtContext _localctx = new StmtContext(_ctx, getState());
		enterRule(_localctx, 34, RULE_stmt);
		int _la;
		try {
			setState(278);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,27,_ctx) ) {
			case 1:
				_localctx = new StmtDeclVarContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(217);
				declVariable();
				}
				break;
			case 2:
				_localctx = new StmtBlockContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(218);
				match(T__5);
				setState(220);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__3) | (1L << T__5) | (1L << T__7) | (1L << T__13) | (1L << T__14) | (1L << T__15) | (1L << T__16) | (1L << T__17) | (1L << T__18) | (1L << T__20) | (1L << T__21) | (1L << T__22) | (1L << T__23) | (1L << T__24) | (1L << T__26) | (1L << T__27) | (1L << T__30) | (1L << T__31) | (1L << T__32) | (1L << T__33) | (1L << T__34) | (1L << T__35) | (1L << T__36) | (1L << T__41) | (1L << T__42))) != 0) || ((((_la - 66)) & ~0x3f) == 0 && ((1L << (_la - 66)) & ((1L << (SIMPLETYPE - 66)) | (1L << (STRING - 66)) | (1L << (CHAR - 66)) | (1L << (BOOLEAN - 66)) | (1L << (NUMBER - 66)) | (1L << (NAME - 66)))) != 0)) {
					{
					setState(219);
					stmtSeq();
					}
				}

				setState(222);
				match(T__6);
				}
				break;
			case 3:
				_localctx = new StmtExprContext(_localctx);
				enterOuterAlt(_localctx, 3);
				{
				setState(223);
				expr(0);
				setState(224);
				match(T__2);
				}
				break;
			case 4:
				_localctx = new StmtIfElseContext(_localctx);
				enterOuterAlt(_localctx, 4);
				{
				setState(226);
				match(T__18);
				setState(227);
				match(T__3);
				setState(228);
				expr(0);
				setState(229);
				match(T__4);
				setState(230);
				stmt();
				setState(233);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,21,_ctx) ) {
				case 1:
					{
					setState(231);
					match(T__19);
					setState(232);
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
				setState(236);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__13) | (1L << T__14) | (1L << T__15) | (1L << T__16) | (1L << T__17))) != 0)) {
					{
					setState(235);
					directive();
					}
				}

				setState(238);
				match(T__20);
				setState(239);
				match(T__3);
				setState(240);
				expr(0);
				setState(241);
				match(T__4);
				setState(242);
				stmt();
				}
				break;
			case 6:
				_localctx = new StmtDoWhileContext(_localctx);
				enterOuterAlt(_localctx, 6);
				{
				setState(245);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__13) | (1L << T__14) | (1L << T__15) | (1L << T__16) | (1L << T__17))) != 0)) {
					{
					setState(244);
					directive();
					}
				}

				setState(247);
				match(T__21);
				setState(248);
				stmt();
				setState(249);
				match(T__20);
				setState(250);
				match(T__3);
				setState(251);
				expr(0);
				setState(252);
				match(T__4);
				setState(253);
				match(T__2);
				}
				break;
			case 7:
				_localctx = new StmtForContext(_localctx);
				enterOuterAlt(_localctx, 7);
				{
				setState(256);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__13) | (1L << T__14) | (1L << T__15) | (1L << T__16) | (1L << T__17))) != 0)) {
					{
					setState(255);
					directive();
					}
				}

				setState(258);
				match(T__22);
				setState(259);
				match(T__3);
				setState(261);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__13) | (1L << T__14) | (1L << T__15) | (1L << T__16) | (1L << T__17) | (1L << T__26))) != 0) || _la==SIMPLETYPE || _la==NAME) {
					{
					setState(260);
					forDeclaration();
					}
				}

				setState(263);
				forIteration();
				setState(264);
				match(T__4);
				setState(265);
				stmt();
				}
				break;
			case 8:
				_localctx = new StmtReturnContext(_localctx);
				enterOuterAlt(_localctx, 8);
				{
				setState(267);
				match(T__23);
				setState(269);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__3) | (1L << T__5) | (1L << T__27) | (1L << T__30) | (1L << T__31) | (1L << T__32) | (1L << T__33) | (1L << T__34) | (1L << T__35) | (1L << T__36) | (1L << T__41) | (1L << T__42))) != 0) || ((((_la - 67)) & ~0x3f) == 0 && ((1L << (_la - 67)) & ((1L << (STRING - 67)) | (1L << (CHAR - 67)) | (1L << (BOOLEAN - 67)) | (1L << (NUMBER - 67)) | (1L << (NAME - 67)))) != 0)) {
					{
					setState(268);
					expr(0);
					}
				}

				setState(271);
				match(T__2);
				}
				break;
			case 9:
				_localctx = new StmtAsmContext(_localctx);
				enterOuterAlt(_localctx, 9);
				{
				setState(272);
				match(T__24);
				setState(273);
				match(T__5);
				setState(274);
				asmLines();
				setState(275);
				match(T__6);
				}
				break;
			case 10:
				_localctx = new StmtDeclKasmContext(_localctx);
				enterOuterAlt(_localctx, 10);
				{
				setState(277);
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

	public static class ForDeclarationContext extends ParserRuleContext {
		public ForDeclarationContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_forDeclaration; }
	 
		public ForDeclarationContext() { }
		public void copyFrom(ForDeclarationContext ctx) {
			super.copyFrom(ctx);
		}
	}
	public static class ForDeclContext extends ForDeclarationContext {
		public TerminalNode NAME() { return getToken(KickCParser.NAME, 0); }
		public List<DirectiveContext> directive() {
			return getRuleContexts(DirectiveContext.class);
		}
		public DirectiveContext directive(int i) {
			return getRuleContext(DirectiveContext.class,i);
		}
		public TypeDeclContext typeDecl() {
			return getRuleContext(TypeDeclContext.class,0);
		}
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public ForDeclContext(ForDeclarationContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterForDecl(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitForDecl(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitForDecl(this);
			else return visitor.visitChildren(this);
		}
	}

	public final ForDeclarationContext forDeclaration() throws RecognitionException {
		ForDeclarationContext _localctx = new ForDeclarationContext(_ctx, getState());
		enterRule(_localctx, 36, RULE_forDeclaration);
		int _la;
		try {
			int _alt;
			_localctx = new ForDeclContext(_localctx);
			enterOuterAlt(_localctx, 1);
			{
			setState(283);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,28,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					{
					{
					setState(280);
					directive();
					}
					} 
				}
				setState(285);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,28,_ctx);
			}
			setState(287);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__26 || _la==SIMPLETYPE) {
				{
				setState(286);
				typeDecl(0);
				}
			}

			setState(292);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__13) | (1L << T__14) | (1L << T__15) | (1L << T__16) | (1L << T__17))) != 0)) {
				{
				{
				setState(289);
				directive();
				}
				}
				setState(294);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(295);
			match(NAME);
			setState(298);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__1) {
				{
				setState(296);
				match(T__1);
				setState(297);
				expr(0);
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

	public static class ForIterationContext extends ParserRuleContext {
		public ForIterationContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_forIteration; }
	 
		public ForIterationContext() { }
		public void copyFrom(ForIterationContext ctx) {
			super.copyFrom(ctx);
		}
	}
	public static class ForRangeContext extends ForIterationContext {
		public List<ExprContext> expr() {
			return getRuleContexts(ExprContext.class);
		}
		public ExprContext expr(int i) {
			return getRuleContext(ExprContext.class,i);
		}
		public ForRangeContext(ForIterationContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterForRange(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitForRange(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitForRange(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class ForClassicContext extends ForIterationContext {
		public List<ExprContext> expr() {
			return getRuleContexts(ExprContext.class);
		}
		public ExprContext expr(int i) {
			return getRuleContext(ExprContext.class,i);
		}
		public ForClassicContext(ForIterationContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterForClassic(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitForClassic(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitForClassic(this);
			else return visitor.visitChildren(this);
		}
	}

	public final ForIterationContext forIteration() throws RecognitionException {
		ForIterationContext _localctx = new ForIterationContext(_ctx, getState());
		enterRule(_localctx, 38, RULE_forIteration);
		try {
			setState(310);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case T__2:
				_localctx = new ForClassicContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(300);
				match(T__2);
				setState(301);
				expr(0);
				setState(302);
				match(T__2);
				setState(303);
				expr(0);
				}
				break;
			case T__12:
				_localctx = new ForRangeContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(305);
				match(T__12);
				setState(306);
				expr(0);
				{
				setState(307);
				match(T__25);
				}
				setState(308);
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
	public static class TypePtrContext extends TypeDeclContext {
		public TypeDeclContext typeDecl() {
			return getRuleContext(TypeDeclContext.class,0);
		}
		public TypePtrContext(TypeDeclContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterTypePtr(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitTypePtr(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitTypePtr(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class TypeArrayContext extends TypeDeclContext {
		public TypeDeclContext typeDecl() {
			return getRuleContext(TypeDeclContext.class,0);
		}
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public TypeArrayContext(TypeDeclContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterTypeArray(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitTypeArray(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitTypeArray(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class TypeSimpleContext extends TypeDeclContext {
		public TerminalNode SIMPLETYPE() { return getToken(KickCParser.SIMPLETYPE, 0); }
		public TypeSimpleContext(TypeDeclContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterTypeSimple(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitTypeSimple(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitTypeSimple(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class TypeSignedSimpleContext extends TypeDeclContext {
		public TerminalNode SIMPLETYPE() { return getToken(KickCParser.SIMPLETYPE, 0); }
		public TypeSignedSimpleContext(TypeDeclContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterTypeSignedSimple(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitTypeSignedSimple(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitTypeSignedSimple(this);
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
		int _startState = 40;
		enterRecursionRule(_localctx, 40, RULE_typeDecl, _p);
		int _la;
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(316);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case SIMPLETYPE:
				{
				_localctx = new TypeSimpleContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;

				setState(313);
				match(SIMPLETYPE);
				}
				break;
			case T__26:
				{
				_localctx = new TypeSignedSimpleContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(314);
				match(T__26);
				setState(315);
				match(SIMPLETYPE);
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
			_ctx.stop = _input.LT(-1);
			setState(328);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,36,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					setState(326);
					_errHandler.sync(this);
					switch ( getInterpreter().adaptivePredict(_input,35,_ctx) ) {
					case 1:
						{
						_localctx = new TypePtrContext(new TypeDeclContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_typeDecl);
						setState(318);
						if (!(precpred(_ctx, 2))) throw new FailedPredicateException(this, "precpred(_ctx, 2)");
						setState(319);
						match(T__27);
						}
						break;
					case 2:
						{
						_localctx = new TypeArrayContext(new TypeDeclContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_typeDecl);
						setState(320);
						if (!(precpred(_ctx, 1))) throw new FailedPredicateException(this, "precpred(_ctx, 1)");
						setState(321);
						match(T__28);
						setState(323);
						_errHandler.sync(this);
						_la = _input.LA(1);
						if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__3) | (1L << T__5) | (1L << T__27) | (1L << T__30) | (1L << T__31) | (1L << T__32) | (1L << T__33) | (1L << T__34) | (1L << T__35) | (1L << T__36) | (1L << T__41) | (1L << T__42))) != 0) || ((((_la - 67)) & ~0x3f) == 0 && ((1L << (_la - 67)) & ((1L << (STRING - 67)) | (1L << (CHAR - 67)) | (1L << (BOOLEAN - 67)) | (1L << (NUMBER - 67)) | (1L << (NAME - 67)))) != 0)) {
							{
							setState(322);
							expr(0);
							}
						}

						setState(325);
						match(T__29);
						}
						break;
					}
					} 
				}
				setState(330);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,36,_ctx);
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
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public ExprPtrContext(ExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterExprPtr(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitExprPtr(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitExprPtr(this);
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
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterExprPreMod(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitExprPreMod(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitExprPreMod(this);
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
		public ExprBinaryContext(ExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterExprBinary(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitExprBinary(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitExprBinary(this);
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
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterExprPostMod(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitExprPostMod(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitExprPostMod(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class ExprUnaryContext extends ExprContext {
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public ExprUnaryContext(ExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterExprUnary(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitExprUnary(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitExprUnary(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class ExprNumberContext extends ExprContext {
		public TerminalNode NUMBER() { return getToken(KickCParser.NUMBER, 0); }
		public ExprNumberContext(ExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterExprNumber(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitExprNumber(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitExprNumber(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class ExprCharContext extends ExprContext {
		public TerminalNode CHAR() { return getToken(KickCParser.CHAR, 0); }
		public ExprCharContext(ExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterExprChar(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitExprChar(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitExprChar(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class InitListContext extends ExprContext {
		public List<ExprContext> expr() {
			return getRuleContexts(ExprContext.class);
		}
		public ExprContext expr(int i) {
			return getRuleContext(ExprContext.class,i);
		}
		public InitListContext(ExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterInitList(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitInitList(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitInitList(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class ExprCastContext extends ExprContext {
		public TypeDeclContext typeDecl() {
			return getRuleContext(TypeDeclContext.class,0);
		}
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public ExprCastContext(ExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterExprCast(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitExprCast(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitExprCast(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class ExprCallContext extends ExprContext {
		public TerminalNode NAME() { return getToken(KickCParser.NAME, 0); }
		public ParameterListContext parameterList() {
			return getRuleContext(ParameterListContext.class,0);
		}
		public ExprCallContext(ExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterExprCall(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitExprCall(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitExprCall(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class ExprParContext extends ExprContext {
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public ExprParContext(ExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterExprPar(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitExprPar(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitExprPar(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class ExprStringContext extends ExprContext {
		public TerminalNode STRING() { return getToken(KickCParser.STRING, 0); }
		public ExprStringContext(ExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterExprString(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitExprString(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitExprString(this);
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
		public ExprAssignmentCompoundContext(ExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterExprAssignmentCompound(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitExprAssignmentCompound(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitExprAssignmentCompound(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class ExprBoolContext extends ExprContext {
		public TerminalNode BOOLEAN() { return getToken(KickCParser.BOOLEAN, 0); }
		public ExprBoolContext(ExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterExprBool(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitExprBool(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitExprBool(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class ExprIdContext extends ExprContext {
		public TerminalNode NAME() { return getToken(KickCParser.NAME, 0); }
		public ExprIdContext(ExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterExprId(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitExprId(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitExprId(this);
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
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterExprAssignment(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitExprAssignment(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitExprAssignment(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class ExprArrayContext extends ExprContext {
		public List<ExprContext> expr() {
			return getRuleContexts(ExprContext.class);
		}
		public ExprContext expr(int i) {
			return getRuleContext(ExprContext.class,i);
		}
		public ExprArrayContext(ExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterExprArray(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitExprArray(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitExprArray(this);
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
		int _startState = 42;
		enterRecursionRule(_localctx, 42, RULE_expr, _p);
		int _la;
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(371);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,39,_ctx) ) {
			case 1:
				{
				_localctx = new ExprParContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;

				setState(332);
				match(T__3);
				setState(333);
				expr(0);
				setState(334);
				match(T__4);
				}
				break;
			case 2:
				{
				_localctx = new ExprCallContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(336);
				match(NAME);
				setState(337);
				match(T__3);
				setState(339);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__3) | (1L << T__5) | (1L << T__27) | (1L << T__30) | (1L << T__31) | (1L << T__32) | (1L << T__33) | (1L << T__34) | (1L << T__35) | (1L << T__36) | (1L << T__41) | (1L << T__42))) != 0) || ((((_la - 67)) & ~0x3f) == 0 && ((1L << (_la - 67)) & ((1L << (STRING - 67)) | (1L << (CHAR - 67)) | (1L << (BOOLEAN - 67)) | (1L << (NUMBER - 67)) | (1L << (NAME - 67)))) != 0)) {
					{
					setState(338);
					parameterList();
					}
				}

				setState(341);
				match(T__4);
				}
				break;
			case 3:
				{
				_localctx = new ExprCastContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(342);
				match(T__3);
				setState(343);
				typeDecl(0);
				setState(344);
				match(T__4);
				setState(345);
				expr(23);
				}
				break;
			case 4:
				{
				_localctx = new ExprPreModContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(347);
				_la = _input.LA(1);
				if ( !(_la==T__30 || _la==T__31) ) {
				_errHandler.recoverInline(this);
				}
				else {
					if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
					_errHandler.reportMatch(this);
					consume();
				}
				setState(348);
				expr(22);
				}
				break;
			case 5:
				{
				_localctx = new ExprPtrContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(349);
				match(T__27);
				setState(350);
				expr(20);
				}
				break;
			case 6:
				{
				_localctx = new ExprUnaryContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(351);
				_la = _input.LA(1);
				if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__32) | (1L << T__33) | (1L << T__34) | (1L << T__35) | (1L << T__36))) != 0)) ) {
				_errHandler.recoverInline(this);
				}
				else {
					if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
					_errHandler.reportMatch(this);
					consume();
				}
				setState(352);
				expr(19);
				}
				break;
			case 7:
				{
				_localctx = new ExprUnaryContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(353);
				_la = _input.LA(1);
				if ( !(_la==T__41 || _la==T__42) ) {
				_errHandler.recoverInline(this);
				}
				else {
					if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
					_errHandler.reportMatch(this);
					consume();
				}
				setState(354);
				expr(15);
				}
				break;
			case 8:
				{
				_localctx = new InitListContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(355);
				match(T__5);
				setState(356);
				expr(0);
				setState(361);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (_la==T__11) {
					{
					{
					setState(357);
					match(T__11);
					setState(358);
					expr(0);
					}
					}
					setState(363);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				setState(364);
				match(T__6);
				}
				break;
			case 9:
				{
				_localctx = new ExprIdContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(366);
				match(NAME);
				}
				break;
			case 10:
				{
				_localctx = new ExprNumberContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(367);
				match(NUMBER);
				}
				break;
			case 11:
				{
				_localctx = new ExprStringContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(368);
				match(STRING);
				}
				break;
			case 12:
				{
				_localctx = new ExprCharContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(369);
				match(CHAR);
				}
				break;
			case 13:
				{
				_localctx = new ExprBoolContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(370);
				match(BOOLEAN);
				}
				break;
			}
			_ctx.stop = _input.LT(-1);
			setState(415);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,41,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					setState(413);
					_errHandler.sync(this);
					switch ( getInterpreter().adaptivePredict(_input,40,_ctx) ) {
					case 1:
						{
						_localctx = new ExprBinaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(373);
						if (!(precpred(_ctx, 18))) throw new FailedPredicateException(this, "precpred(_ctx, 18)");
						setState(374);
						_la = _input.LA(1);
						if ( !(_la==T__37 || _la==T__38) ) {
						_errHandler.recoverInline(this);
						}
						else {
							if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
							_errHandler.reportMatch(this);
							consume();
						}
						setState(375);
						expr(19);
						}
						break;
					case 2:
						{
						_localctx = new ExprBinaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(376);
						if (!(precpred(_ctx, 17))) throw new FailedPredicateException(this, "precpred(_ctx, 17)");
						setState(377);
						_la = _input.LA(1);
						if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__27) | (1L << T__39) | (1L << T__40))) != 0)) ) {
						_errHandler.recoverInline(this);
						}
						else {
							if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
							_errHandler.reportMatch(this);
							consume();
						}
						setState(378);
						expr(18);
						}
						break;
					case 3:
						{
						_localctx = new ExprBinaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(379);
						if (!(precpred(_ctx, 16))) throw new FailedPredicateException(this, "precpred(_ctx, 16)");
						setState(380);
						_la = _input.LA(1);
						if ( !(_la==T__32 || _la==T__33) ) {
						_errHandler.recoverInline(this);
						}
						else {
							if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
							_errHandler.reportMatch(this);
							consume();
						}
						setState(381);
						expr(17);
						}
						break;
					case 4:
						{
						_localctx = new ExprBinaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(382);
						if (!(precpred(_ctx, 14))) throw new FailedPredicateException(this, "precpred(_ctx, 14)");
						setState(383);
						_la = _input.LA(1);
						if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__41) | (1L << T__42) | (1L << T__43) | (1L << T__44) | (1L << T__45) | (1L << T__46))) != 0)) ) {
						_errHandler.recoverInline(this);
						}
						else {
							if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
							_errHandler.reportMatch(this);
							consume();
						}
						setState(384);
						expr(15);
						}
						break;
					case 5:
						{
						_localctx = new ExprBinaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(385);
						if (!(precpred(_ctx, 13))) throw new FailedPredicateException(this, "precpred(_ctx, 13)");
						{
						setState(386);
						match(T__35);
						}
						setState(387);
						expr(14);
						}
						break;
					case 6:
						{
						_localctx = new ExprBinaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(388);
						if (!(precpred(_ctx, 12))) throw new FailedPredicateException(this, "precpred(_ctx, 12)");
						{
						setState(389);
						match(T__47);
						}
						setState(390);
						expr(13);
						}
						break;
					case 7:
						{
						_localctx = new ExprBinaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(391);
						if (!(precpred(_ctx, 11))) throw new FailedPredicateException(this, "precpred(_ctx, 11)");
						{
						setState(392);
						match(T__48);
						}
						setState(393);
						expr(12);
						}
						break;
					case 8:
						{
						_localctx = new ExprBinaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(394);
						if (!(precpred(_ctx, 10))) throw new FailedPredicateException(this, "precpred(_ctx, 10)");
						{
						setState(395);
						match(T__49);
						}
						setState(396);
						expr(11);
						}
						break;
					case 9:
						{
						_localctx = new ExprBinaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(397);
						if (!(precpred(_ctx, 9))) throw new FailedPredicateException(this, "precpred(_ctx, 9)");
						{
						setState(398);
						match(T__50);
						}
						setState(399);
						expr(10);
						}
						break;
					case 10:
						{
						_localctx = new ExprAssignmentContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(400);
						if (!(precpred(_ctx, 8))) throw new FailedPredicateException(this, "precpred(_ctx, 8)");
						setState(401);
						match(T__1);
						setState(402);
						expr(8);
						}
						break;
					case 11:
						{
						_localctx = new ExprAssignmentCompoundContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(403);
						if (!(precpred(_ctx, 7))) throw new FailedPredicateException(this, "precpred(_ctx, 7)");
						setState(404);
						_la = _input.LA(1);
						if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__51) | (1L << T__52) | (1L << T__53) | (1L << T__54) | (1L << T__55) | (1L << T__56) | (1L << T__57) | (1L << T__58) | (1L << T__59) | (1L << T__60))) != 0)) ) {
						_errHandler.recoverInline(this);
						}
						else {
							if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
							_errHandler.reportMatch(this);
							consume();
						}
						setState(405);
						expr(7);
						}
						break;
					case 12:
						{
						_localctx = new ExprArrayContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(406);
						if (!(precpred(_ctx, 24))) throw new FailedPredicateException(this, "precpred(_ctx, 24)");
						setState(407);
						match(T__28);
						setState(408);
						expr(0);
						setState(409);
						match(T__29);
						}
						break;
					case 13:
						{
						_localctx = new ExprPostModContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(411);
						if (!(precpred(_ctx, 21))) throw new FailedPredicateException(this, "precpred(_ctx, 21)");
						setState(412);
						_la = _input.LA(1);
						if ( !(_la==T__30 || _la==T__31) ) {
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
				setState(417);
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

	public static class ParameterListContext extends ParserRuleContext {
		public List<ExprContext> expr() {
			return getRuleContexts(ExprContext.class);
		}
		public ExprContext expr(int i) {
			return getRuleContext(ExprContext.class,i);
		}
		public ParameterListContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_parameterList; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterParameterList(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitParameterList(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitParameterList(this);
			else return visitor.visitChildren(this);
		}
	}

	public final ParameterListContext parameterList() throws RecognitionException {
		ParameterListContext _localctx = new ParameterListContext(_ctx, getState());
		enterRule(_localctx, 44, RULE_parameterList);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(418);
			expr(0);
			setState(423);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==T__11) {
				{
				{
				setState(419);
				match(T__11);
				setState(420);
				expr(0);
				}
				}
				setState(425);
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
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterAsmLines(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitAsmLines(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitAsmLines(this);
			else return visitor.visitChildren(this);
		}
	}

	public final AsmLinesContext asmLines() throws RecognitionException {
		AsmLinesContext _localctx = new AsmLinesContext(_ctx, getState());
		enterRule(_localctx, 46, RULE_asmLines);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(429);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (((((_la - 35)) & ~0x3f) == 0 && ((1L << (_la - 35)) & ((1L << (T__34 - 35)) | (1L << (T__61 - 35)) | (1L << (MNEMONIC - 35)) | (1L << (NAME - 35)))) != 0)) {
				{
				{
				setState(426);
				asmLine();
				}
				}
				setState(431);
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
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterAsmLine(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitAsmLine(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitAsmLine(this);
			else return visitor.visitChildren(this);
		}
	}

	public final AsmLineContext asmLine() throws RecognitionException {
		AsmLineContext _localctx = new AsmLineContext(_ctx, getState());
		enterRule(_localctx, 48, RULE_asmLine);
		try {
			setState(435);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case T__34:
			case NAME:
				enterOuterAlt(_localctx, 1);
				{
				setState(432);
				asmLabel();
				}
				break;
			case MNEMONIC:
				enterOuterAlt(_localctx, 2);
				{
				setState(433);
				asmInstruction();
				}
				break;
			case T__61:
				enterOuterAlt(_localctx, 3);
				{
				setState(434);
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
		public TerminalNode NAME() { return getToken(KickCParser.NAME, 0); }
		public AsmLabelNameContext(AsmLabelContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterAsmLabelName(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitAsmLabelName(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitAsmLabelName(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class AsmLabelMultiContext extends AsmLabelContext {
		public TerminalNode NAME() { return getToken(KickCParser.NAME, 0); }
		public AsmLabelMultiContext(AsmLabelContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterAsmLabelMulti(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitAsmLabelMulti(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitAsmLabelMulti(this);
			else return visitor.visitChildren(this);
		}
	}

	public final AsmLabelContext asmLabel() throws RecognitionException {
		AsmLabelContext _localctx = new AsmLabelContext(_ctx, getState());
		enterRule(_localctx, 50, RULE_asmLabel);
		int _la;
		try {
			setState(444);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case NAME:
				_localctx = new AsmLabelNameContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(437);
				match(NAME);
				setState(438);
				match(T__12);
				}
				break;
			case T__34:
				_localctx = new AsmLabelMultiContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(439);
				match(T__34);
				setState(441);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if (_la==NAME) {
					{
					setState(440);
					match(NAME);
					}
				}

				setState(443);
				match(T__12);
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
		public TerminalNode MNEMONIC() { return getToken(KickCParser.MNEMONIC, 0); }
		public AsmParamModeContext asmParamMode() {
			return getRuleContext(AsmParamModeContext.class,0);
		}
		public AsmInstructionContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_asmInstruction; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterAsmInstruction(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitAsmInstruction(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitAsmInstruction(this);
			else return visitor.visitChildren(this);
		}
	}

	public final AsmInstructionContext asmInstruction() throws RecognitionException {
		AsmInstructionContext _localctx = new AsmInstructionContext(_ctx, getState());
		enterRule(_localctx, 52, RULE_asmInstruction);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(446);
			match(MNEMONIC);
			setState(448);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,47,_ctx) ) {
			case 1:
				{
				setState(447);
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
		public List<AsmExprContext> asmExpr() {
			return getRuleContexts(AsmExprContext.class);
		}
		public AsmExprContext asmExpr(int i) {
			return getRuleContext(AsmExprContext.class,i);
		}
		public AsmBytesContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_asmBytes; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterAsmBytes(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitAsmBytes(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitAsmBytes(this);
			else return visitor.visitChildren(this);
		}
	}

	public final AsmBytesContext asmBytes() throws RecognitionException {
		AsmBytesContext _localctx = new AsmBytesContext(_ctx, getState());
		enterRule(_localctx, 54, RULE_asmBytes);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(450);
			match(T__61);
			setState(451);
			asmExpr(0);
			setState(456);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==T__11) {
				{
				{
				setState(452);
				match(T__11);
				setState(453);
				asmExpr(0);
				}
				}
				setState(458);
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
		public AsmExprContext asmExpr() {
			return getRuleContext(AsmExprContext.class,0);
		}
		public AsmModeImmContext(AsmParamModeContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterAsmModeImm(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitAsmModeImm(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitAsmModeImm(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class AsmModeAbsXYContext extends AsmParamModeContext {
		public AsmExprContext asmExpr() {
			return getRuleContext(AsmExprContext.class,0);
		}
		public TerminalNode NAME() { return getToken(KickCParser.NAME, 0); }
		public AsmModeAbsXYContext(AsmParamModeContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterAsmModeAbsXY(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitAsmModeAbsXY(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitAsmModeAbsXY(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class AsmModeIdxIndXYContext extends AsmParamModeContext {
		public AsmExprContext asmExpr() {
			return getRuleContext(AsmExprContext.class,0);
		}
		public TerminalNode NAME() { return getToken(KickCParser.NAME, 0); }
		public AsmModeIdxIndXYContext(AsmParamModeContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterAsmModeIdxIndXY(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitAsmModeIdxIndXY(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitAsmModeIdxIndXY(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class AsmModeIndContext extends AsmParamModeContext {
		public AsmExprContext asmExpr() {
			return getRuleContext(AsmExprContext.class,0);
		}
		public AsmModeIndContext(AsmParamModeContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterAsmModeInd(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitAsmModeInd(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitAsmModeInd(this);
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
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterAsmModeAbs(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitAsmModeAbs(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitAsmModeAbs(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class AsmModeIndIdxXYContext extends AsmParamModeContext {
		public AsmExprContext asmExpr() {
			return getRuleContext(AsmExprContext.class,0);
		}
		public TerminalNode NAME() { return getToken(KickCParser.NAME, 0); }
		public AsmModeIndIdxXYContext(AsmParamModeContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterAsmModeIndIdxXY(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitAsmModeIndIdxXY(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitAsmModeIndIdxXY(this);
			else return visitor.visitChildren(this);
		}
	}

	public final AsmParamModeContext asmParamMode() throws RecognitionException {
		AsmParamModeContext _localctx = new AsmParamModeContext(_ctx, getState());
		enterRule(_localctx, 56, RULE_asmParamMode);
		try {
			setState(482);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,49,_ctx) ) {
			case 1:
				_localctx = new AsmModeAbsContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(459);
				asmExpr(0);
				}
				break;
			case 2:
				_localctx = new AsmModeImmContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(460);
				match(T__62);
				setState(461);
				asmExpr(0);
				}
				break;
			case 3:
				_localctx = new AsmModeAbsXYContext(_localctx);
				enterOuterAlt(_localctx, 3);
				{
				setState(462);
				asmExpr(0);
				setState(463);
				match(T__11);
				setState(464);
				match(NAME);
				}
				break;
			case 4:
				_localctx = new AsmModeIndIdxXYContext(_localctx);
				enterOuterAlt(_localctx, 4);
				{
				setState(466);
				match(T__3);
				setState(467);
				asmExpr(0);
				setState(468);
				match(T__4);
				setState(469);
				match(T__11);
				setState(470);
				match(NAME);
				}
				break;
			case 5:
				_localctx = new AsmModeIdxIndXYContext(_localctx);
				enterOuterAlt(_localctx, 5);
				{
				setState(472);
				match(T__3);
				setState(473);
				asmExpr(0);
				setState(474);
				match(T__11);
				setState(475);
				match(NAME);
				setState(476);
				match(T__4);
				}
				break;
			case 6:
				_localctx = new AsmModeIndContext(_localctx);
				enterOuterAlt(_localctx, 6);
				{
				setState(478);
				match(T__3);
				setState(479);
				asmExpr(0);
				setState(480);
				match(T__4);
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
		public TerminalNode NAME() { return getToken(KickCParser.NAME, 0); }
		public AsmExprReplaceContext(AsmExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterAsmExprReplace(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitAsmExprReplace(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitAsmExprReplace(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class AsmExprLabelRelContext extends AsmExprContext {
		public TerminalNode ASMREL() { return getToken(KickCParser.ASMREL, 0); }
		public AsmExprLabelRelContext(AsmExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterAsmExprLabelRel(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitAsmExprLabelRel(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitAsmExprLabelRel(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class AsmExprParContext extends AsmExprContext {
		public AsmExprContext asmExpr() {
			return getRuleContext(AsmExprContext.class,0);
		}
		public AsmExprParContext(AsmExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterAsmExprPar(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitAsmExprPar(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitAsmExprPar(this);
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
		public AsmExprBinaryContext(AsmExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterAsmExprBinary(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitAsmExprBinary(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitAsmExprBinary(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class AsmExprLabelContext extends AsmExprContext {
		public TerminalNode NAME() { return getToken(KickCParser.NAME, 0); }
		public AsmExprLabelContext(AsmExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterAsmExprLabel(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitAsmExprLabel(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitAsmExprLabel(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class AsmExprIntContext extends AsmExprContext {
		public TerminalNode NUMBER() { return getToken(KickCParser.NUMBER, 0); }
		public AsmExprIntContext(AsmExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterAsmExprInt(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitAsmExprInt(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitAsmExprInt(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class AsmExprUnaryContext extends AsmExprContext {
		public AsmExprContext asmExpr() {
			return getRuleContext(AsmExprContext.class,0);
		}
		public AsmExprUnaryContext(AsmExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterAsmExprUnary(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitAsmExprUnary(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitAsmExprUnary(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class AsmExprCharContext extends AsmExprContext {
		public TerminalNode CHAR() { return getToken(KickCParser.CHAR, 0); }
		public AsmExprCharContext(AsmExprContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterAsmExprChar(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitAsmExprChar(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitAsmExprChar(this);
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
		int _startState = 58;
		enterRecursionRule(_localctx, 58, RULE_asmExpr, _p);
		int _la;
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(498);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case T__28:
				{
				_localctx = new AsmExprParContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;

				setState(485);
				match(T__28);
				setState(486);
				asmExpr(0);
				setState(487);
				match(T__29);
				}
				break;
			case T__32:
			case T__33:
			case T__41:
			case T__42:
				{
				_localctx = new AsmExprUnaryContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(489);
				_la = _input.LA(1);
				if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__32) | (1L << T__33) | (1L << T__41) | (1L << T__42))) != 0)) ) {
				_errHandler.recoverInline(this);
				}
				else {
					if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
					_errHandler.reportMatch(this);
					consume();
				}
				setState(490);
				asmExpr(8);
				}
				break;
			case NAME:
				{
				_localctx = new AsmExprLabelContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(491);
				match(NAME);
				}
				break;
			case ASMREL:
				{
				_localctx = new AsmExprLabelRelContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(492);
				match(ASMREL);
				}
				break;
			case T__5:
				{
				_localctx = new AsmExprReplaceContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(493);
				match(T__5);
				setState(494);
				match(NAME);
				setState(495);
				match(T__6);
				}
				break;
			case NUMBER:
				{
				_localctx = new AsmExprIntContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(496);
				match(NUMBER);
				}
				break;
			case CHAR:
				{
				_localctx = new AsmExprCharContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(497);
				match(CHAR);
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
			_ctx.stop = _input.LT(-1);
			setState(511);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,52,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					setState(509);
					_errHandler.sync(this);
					switch ( getInterpreter().adaptivePredict(_input,51,_ctx) ) {
					case 1:
						{
						_localctx = new AsmExprBinaryContext(new AsmExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_asmExpr);
						setState(500);
						if (!(precpred(_ctx, 9))) throw new FailedPredicateException(this, "precpred(_ctx, 9)");
						setState(501);
						_la = _input.LA(1);
						if ( !(_la==T__37 || _la==T__38) ) {
						_errHandler.recoverInline(this);
						}
						else {
							if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
							_errHandler.reportMatch(this);
							consume();
						}
						setState(502);
						asmExpr(10);
						}
						break;
					case 2:
						{
						_localctx = new AsmExprBinaryContext(new AsmExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_asmExpr);
						setState(503);
						if (!(precpred(_ctx, 7))) throw new FailedPredicateException(this, "precpred(_ctx, 7)");
						setState(504);
						_la = _input.LA(1);
						if ( !(_la==T__27 || _la==T__39) ) {
						_errHandler.recoverInline(this);
						}
						else {
							if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
							_errHandler.reportMatch(this);
							consume();
						}
						setState(505);
						asmExpr(8);
						}
						break;
					case 3:
						{
						_localctx = new AsmExprBinaryContext(new AsmExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_asmExpr);
						setState(506);
						if (!(precpred(_ctx, 6))) throw new FailedPredicateException(this, "precpred(_ctx, 6)");
						setState(507);
						_la = _input.LA(1);
						if ( !(_la==T__32 || _la==T__33) ) {
						_errHandler.recoverInline(this);
						}
						else {
							if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
							_errHandler.reportMatch(this);
							consume();
						}
						setState(508);
						asmExpr(7);
						}
						break;
					}
					} 
				}
				setState(513);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,52,_ctx);
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
		case 20:
			return typeDecl_sempred((TypeDeclContext)_localctx, predIndex);
		case 21:
			return expr_sempred((ExprContext)_localctx, predIndex);
		case 29:
			return asmExpr_sempred((AsmExprContext)_localctx, predIndex);
		}
		return true;
	}
	private boolean typeDecl_sempred(TypeDeclContext _localctx, int predIndex) {
		switch (predIndex) {
		case 0:
			return precpred(_ctx, 2);
		case 1:
			return precpred(_ctx, 1);
		}
		return true;
	}
	private boolean expr_sempred(ExprContext _localctx, int predIndex) {
		switch (predIndex) {
		case 2:
			return precpred(_ctx, 18);
		case 3:
			return precpred(_ctx, 17);
		case 4:
			return precpred(_ctx, 16);
		case 5:
			return precpred(_ctx, 14);
		case 6:
			return precpred(_ctx, 13);
		case 7:
			return precpred(_ctx, 12);
		case 8:
			return precpred(_ctx, 11);
		case 9:
			return precpred(_ctx, 10);
		case 10:
			return precpred(_ctx, 9);
		case 11:
			return precpred(_ctx, 8);
		case 12:
			return precpred(_ctx, 7);
		case 13:
			return precpred(_ctx, 24);
		case 14:
			return precpred(_ctx, 21);
		}
		return true;
	}
	private boolean asmExpr_sempred(AsmExprContext _localctx, int predIndex) {
		switch (predIndex) {
		case 15:
			return precpred(_ctx, 9);
		case 16:
			return precpred(_ctx, 7);
		case 17:
			return precpred(_ctx, 6);
		}
		return true;
	}

	public static final String _serializedATN =
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\3U\u0205\4\2\t\2\4"+
		"\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n\t\n\4\13\t"+
		"\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\4\20\t\20\4\21\t\21\4\22\t\22"+
		"\4\23\t\23\4\24\t\24\4\25\t\25\4\26\t\26\4\27\t\27\4\30\t\30\4\31\t\31"+
		"\4\32\t\32\4\33\t\33\4\34\t\34\4\35\t\35\4\36\t\36\4\37\t\37\3\2\3\2\3"+
		"\2\3\2\3\3\3\3\3\3\3\4\7\4G\n\4\f\4\16\4J\13\4\3\5\3\5\3\5\3\6\6\6P\n"+
		"\6\r\6\16\6Q\3\7\3\7\3\7\5\7W\n\7\3\b\7\bZ\n\b\f\b\16\b]\13\b\3\b\3\b"+
		"\7\ba\n\b\f\b\16\bd\13\b\3\b\3\b\3\b\5\bi\n\b\3\b\3\b\3\t\7\tn\n\t\f\t"+
		"\16\tq\13\t\3\t\3\t\7\tu\n\t\f\t\16\tx\13\t\3\t\3\t\3\t\5\t}\n\t\3\t\3"+
		"\t\3\t\5\t\u0082\n\t\3\t\3\t\3\n\3\n\5\n\u0088\n\n\3\n\3\n\3\13\3\13\3"+
		"\13\3\13\7\13\u0090\n\13\f\13\16\13\u0093\13\13\3\13\3\13\3\f\3\f\3\f"+
		"\3\f\3\f\3\f\5\f\u009d\n\f\3\r\3\r\3\r\7\r\u00a2\n\r\f\r\16\r\u00a5\13"+
		"\r\3\16\3\16\3\16\3\16\3\16\3\16\3\16\7\16\u00ae\n\16\f\16\16\16\u00b1"+
		"\13\16\3\17\3\17\3\17\7\17\u00b6\n\17\f\17\16\17\u00b9\13\17\3\20\7\20"+
		"\u00bc\n\20\f\20\16\20\u00bf\13\20\3\20\3\20\7\20\u00c3\n\20\f\20\16\20"+
		"\u00c6\13\20\3\20\3\20\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3"+
		"\21\3\21\5\21\u00d5\n\21\3\22\6\22\u00d8\n\22\r\22\16\22\u00d9\3\23\3"+
		"\23\3\23\5\23\u00df\n\23\3\23\3\23\3\23\3\23\3\23\3\23\3\23\3\23\3\23"+
		"\3\23\3\23\5\23\u00ec\n\23\3\23\5\23\u00ef\n\23\3\23\3\23\3\23\3\23\3"+
		"\23\3\23\3\23\5\23\u00f8\n\23\3\23\3\23\3\23\3\23\3\23\3\23\3\23\3\23"+
		"\3\23\5\23\u0103\n\23\3\23\3\23\3\23\5\23\u0108\n\23\3\23\3\23\3\23\3"+
		"\23\3\23\3\23\5\23\u0110\n\23\3\23\3\23\3\23\3\23\3\23\3\23\3\23\5\23"+
		"\u0119\n\23\3\24\7\24\u011c\n\24\f\24\16\24\u011f\13\24\3\24\5\24\u0122"+
		"\n\24\3\24\7\24\u0125\n\24\f\24\16\24\u0128\13\24\3\24\3\24\3\24\5\24"+
		"\u012d\n\24\3\25\3\25\3\25\3\25\3\25\3\25\3\25\3\25\3\25\3\25\5\25\u0139"+
		"\n\25\3\26\3\26\3\26\3\26\5\26\u013f\n\26\3\26\3\26\3\26\3\26\3\26\5\26"+
		"\u0146\n\26\3\26\7\26\u0149\n\26\f\26\16\26\u014c\13\26\3\27\3\27\3\27"+
		"\3\27\3\27\3\27\3\27\3\27\5\27\u0156\n\27\3\27\3\27\3\27\3\27\3\27\3\27"+
		"\3\27\3\27\3\27\3\27\3\27\3\27\3\27\3\27\3\27\3\27\3\27\3\27\7\27\u016a"+
		"\n\27\f\27\16\27\u016d\13\27\3\27\3\27\3\27\3\27\3\27\3\27\3\27\5\27\u0176"+
		"\n\27\3\27\3\27\3\27\3\27\3\27\3\27\3\27\3\27\3\27\3\27\3\27\3\27\3\27"+
		"\3\27\3\27\3\27\3\27\3\27\3\27\3\27\3\27\3\27\3\27\3\27\3\27\3\27\3\27"+
		"\3\27\3\27\3\27\3\27\3\27\3\27\3\27\3\27\3\27\3\27\3\27\3\27\3\27\7\27"+
		"\u01a0\n\27\f\27\16\27\u01a3\13\27\3\30\3\30\3\30\7\30\u01a8\n\30\f\30"+
		"\16\30\u01ab\13\30\3\31\7\31\u01ae\n\31\f\31\16\31\u01b1\13\31\3\32\3"+
		"\32\3\32\5\32\u01b6\n\32\3\33\3\33\3\33\3\33\5\33\u01bc\n\33\3\33\5\33"+
		"\u01bf\n\33\3\34\3\34\5\34\u01c3\n\34\3\35\3\35\3\35\3\35\7\35\u01c9\n"+
		"\35\f\35\16\35\u01cc\13\35\3\36\3\36\3\36\3\36\3\36\3\36\3\36\3\36\3\36"+
		"\3\36\3\36\3\36\3\36\3\36\3\36\3\36\3\36\3\36\3\36\3\36\3\36\3\36\3\36"+
		"\5\36\u01e5\n\36\3\37\3\37\3\37\3\37\3\37\3\37\3\37\3\37\3\37\3\37\3\37"+
		"\3\37\3\37\3\37\5\37\u01f5\n\37\3\37\3\37\3\37\3\37\3\37\3\37\3\37\3\37"+
		"\3\37\7\37\u0200\n\37\f\37\16\37\u0203\13\37\3\37\2\5*,< \2\4\6\b\n\f"+
		"\16\20\22\24\26\30\32\34\36 \"$&(*,.\60\62\64\668:<\2\f\3\2!\"\3\2#\'"+
		"\3\2,-\3\2()\4\2\36\36*+\3\2#$\3\2,\61\3\2\66?\4\2#$,-\4\2\36\36**\2\u0249"+
		"\2>\3\2\2\2\4B\3\2\2\2\6H\3\2\2\2\bK\3\2\2\2\nO\3\2\2\2\fV\3\2\2\2\16"+
		"[\3\2\2\2\20o\3\2\2\2\22\u0085\3\2\2\2\24\u008b\3\2\2\2\26\u009c\3\2\2"+
		"\2\30\u009e\3\2\2\2\32\u00a6\3\2\2\2\34\u00b2\3\2\2\2\36\u00bd\3\2\2\2"+
		" \u00d4\3\2\2\2\"\u00d7\3\2\2\2$\u0118\3\2\2\2&\u011d\3\2\2\2(\u0138\3"+
		"\2\2\2*\u013e\3\2\2\2,\u0175\3\2\2\2.\u01a4\3\2\2\2\60\u01af\3\2\2\2\62"+
		"\u01b5\3\2\2\2\64\u01be\3\2\2\2\66\u01c0\3\2\2\28\u01c4\3\2\2\2:\u01e4"+
		"\3\2\2\2<\u01f4\3\2\2\2>?\5\6\4\2?@\5\n\6\2@A\7\2\2\3A\3\3\2\2\2BC\5\60"+
		"\31\2CD\7\2\2\3D\5\3\2\2\2EG\5\b\5\2FE\3\2\2\2GJ\3\2\2\2HF\3\2\2\2HI\3"+
		"\2\2\2I\7\3\2\2\2JH\3\2\2\2KL\7\3\2\2LM\7E\2\2M\t\3\2\2\2NP\5\f\7\2ON"+
		"\3\2\2\2PQ\3\2\2\2QO\3\2\2\2QR\3\2\2\2R\13\3\2\2\2SW\5\16\b\2TW\5\20\t"+
		"\2UW\5\22\n\2VS\3\2\2\2VT\3\2\2\2VU\3\2\2\2W\r\3\2\2\2XZ\5 \21\2YX\3\2"+
		"\2\2Z]\3\2\2\2[Y\3\2\2\2[\\\3\2\2\2\\^\3\2\2\2][\3\2\2\2^b\5*\26\2_a\5"+
		" \21\2`_\3\2\2\2ad\3\2\2\2b`\3\2\2\2bc\3\2\2\2ce\3\2\2\2db\3\2\2\2eh\7"+
		"Q\2\2fg\7\4\2\2gi\5,\27\2hf\3\2\2\2hi\3\2\2\2ij\3\2\2\2jk\7\5\2\2k\17"+
		"\3\2\2\2ln\5 \21\2ml\3\2\2\2nq\3\2\2\2om\3\2\2\2op\3\2\2\2pr\3\2\2\2q"+
		"o\3\2\2\2rv\5*\26\2su\5 \21\2ts\3\2\2\2ux\3\2\2\2vt\3\2\2\2vw\3\2\2\2"+
		"wy\3\2\2\2xv\3\2\2\2yz\7Q\2\2z|\7\6\2\2{}\5\34\17\2|{\3\2\2\2|}\3\2\2"+
		"\2}~\3\2\2\2~\177\7\7\2\2\177\u0081\7\b\2\2\u0080\u0082\5\"\22\2\u0081"+
		"\u0080\3\2\2\2\u0081\u0082\3\2\2\2\u0082\u0083\3\2\2\2\u0083\u0084\7\t"+
		"\2\2\u0084\21\3\2\2\2\u0085\u0087\7\n\2\2\u0086\u0088\5\24\13\2\u0087"+
		"\u0086\3\2\2\2\u0087\u0088\3\2\2\2\u0088\u0089\3\2\2\2\u0089\u008a\7C"+
		"\2\2\u008a\23\3\2\2\2\u008b\u008c\7\6\2\2\u008c\u0091\5\26\f\2\u008d\u008e"+
		"\7\5\2\2\u008e\u0090\5\26\f\2\u008f\u008d\3\2\2\2\u0090\u0093\3\2\2\2"+
		"\u0091\u008f\3\2\2\2\u0091\u0092\3\2\2\2\u0092\u0094\3\2\2\2\u0093\u0091"+
		"\3\2\2\2\u0094\u0095\7\7\2\2\u0095\25\3\2\2\2\u0096\u0097\7\13\2\2\u0097"+
		"\u009d\5\30\r\2\u0098\u0099\7\f\2\2\u0099\u009d\7E\2\2\u009a\u009b\7\r"+
		"\2\2\u009b\u009d\5\32\16\2\u009c\u0096\3\2\2\2\u009c\u0098\3\2\2\2\u009c"+
		"\u009a\3\2\2\2\u009d\27\3\2\2\2\u009e\u00a3\7E\2\2\u009f\u00a0\7\16\2"+
		"\2\u00a0\u00a2\7E\2\2\u00a1\u009f\3\2\2\2\u00a2\u00a5\3\2\2\2\u00a3\u00a1"+
		"\3\2\2\2\u00a3\u00a4\3\2\2\2\u00a4\31\3\2\2\2\u00a5\u00a3\3\2\2\2\u00a6"+
		"\u00a7\7Q\2\2\u00a7\u00a8\7\17\2\2\u00a8\u00af\5,\27\2\u00a9\u00aa\7\16"+
		"\2\2\u00aa\u00ab\7Q\2\2\u00ab\u00ac\7\17\2\2\u00ac\u00ae\5,\27\2\u00ad"+
		"\u00a9\3\2\2\2\u00ae\u00b1\3\2\2\2\u00af\u00ad\3\2\2\2\u00af\u00b0\3\2"+
		"\2\2\u00b0\33\3\2\2\2\u00b1\u00af\3\2\2\2\u00b2\u00b7\5\36\20\2\u00b3"+
		"\u00b4\7\16\2\2\u00b4\u00b6\5\36\20\2\u00b5\u00b3\3\2\2\2\u00b6\u00b9"+
		"\3\2\2\2\u00b7\u00b5\3\2\2\2\u00b7\u00b8\3\2\2\2\u00b8\35\3\2\2\2\u00b9"+
		"\u00b7\3\2\2\2\u00ba\u00bc\5 \21\2\u00bb\u00ba\3\2\2\2\u00bc\u00bf\3\2"+
		"\2\2\u00bd\u00bb\3\2\2\2\u00bd\u00be\3\2\2\2\u00be\u00c0\3\2\2\2\u00bf"+
		"\u00bd\3\2\2\2\u00c0\u00c4\5*\26\2\u00c1\u00c3\5 \21\2\u00c2\u00c1\3\2"+
		"\2\2\u00c3\u00c6\3\2\2\2\u00c4\u00c2\3\2\2\2\u00c4\u00c5\3\2\2\2\u00c5"+
		"\u00c7\3\2\2\2\u00c6\u00c4\3\2\2\2\u00c7\u00c8\7Q\2\2\u00c8\37\3\2\2\2"+
		"\u00c9\u00d5\7\20\2\2\u00ca\u00d5\7\21\2\2\u00cb\u00cc\7\22\2\2\u00cc"+
		"\u00cd\7\6\2\2\u00cd\u00ce\7H\2\2\u00ce\u00d5\7\7\2\2\u00cf\u00d0\7\23"+
		"\2\2\u00d0\u00d1\7\6\2\2\u00d1\u00d2\7Q\2\2\u00d2\u00d5\7\7\2\2\u00d3"+
		"\u00d5\7\24\2\2\u00d4\u00c9\3\2\2\2\u00d4\u00ca\3\2\2\2\u00d4\u00cb\3"+
		"\2\2\2\u00d4\u00cf\3\2\2\2\u00d4\u00d3\3\2\2\2\u00d5!\3\2\2\2\u00d6\u00d8"+
		"\5$\23\2\u00d7\u00d6\3\2\2\2\u00d8\u00d9\3\2\2\2\u00d9\u00d7\3\2\2\2\u00d9"+
		"\u00da\3\2\2\2\u00da#\3\2\2\2\u00db\u0119\5\16\b\2\u00dc\u00de\7\b\2\2"+
		"\u00dd\u00df\5\"\22\2\u00de\u00dd\3\2\2\2\u00de\u00df\3\2\2\2\u00df\u00e0"+
		"\3\2\2\2\u00e0\u0119\7\t\2\2\u00e1\u00e2\5,\27\2\u00e2\u00e3\7\5\2\2\u00e3"+
		"\u0119\3\2\2\2\u00e4\u00e5\7\25\2\2\u00e5\u00e6\7\6\2\2\u00e6\u00e7\5"+
		",\27\2\u00e7\u00e8\7\7\2\2\u00e8\u00eb\5$\23\2\u00e9\u00ea\7\26\2\2\u00ea"+
		"\u00ec\5$\23\2\u00eb\u00e9\3\2\2\2\u00eb\u00ec\3\2\2\2\u00ec\u0119\3\2"+
		"\2\2\u00ed\u00ef\5 \21\2\u00ee\u00ed\3\2\2\2\u00ee\u00ef\3\2\2\2\u00ef"+
		"\u00f0\3\2\2\2\u00f0\u00f1\7\27\2\2\u00f1\u00f2\7\6\2\2\u00f2\u00f3\5"+
		",\27\2\u00f3\u00f4\7\7\2\2\u00f4\u00f5\5$\23\2\u00f5\u0119\3\2\2\2\u00f6"+
		"\u00f8\5 \21\2\u00f7\u00f6\3\2\2\2\u00f7\u00f8\3\2\2\2\u00f8\u00f9\3\2"+
		"\2\2\u00f9\u00fa\7\30\2\2\u00fa\u00fb\5$\23\2\u00fb\u00fc\7\27\2\2\u00fc"+
		"\u00fd\7\6\2\2\u00fd\u00fe\5,\27\2\u00fe\u00ff\7\7\2\2\u00ff\u0100\7\5"+
		"\2\2\u0100\u0119\3\2\2\2\u0101\u0103\5 \21\2\u0102\u0101\3\2\2\2\u0102"+
		"\u0103\3\2\2\2\u0103\u0104\3\2\2\2\u0104\u0105\7\31\2\2\u0105\u0107\7"+
		"\6\2\2\u0106\u0108\5&\24\2\u0107\u0106\3\2\2\2\u0107\u0108\3\2\2\2\u0108"+
		"\u0109\3\2\2\2\u0109\u010a\5(\25\2\u010a\u010b\7\7\2\2\u010b\u010c\5$"+
		"\23\2\u010c\u0119\3\2\2\2\u010d\u010f\7\32\2\2\u010e\u0110\5,\27\2\u010f"+
		"\u010e\3\2\2\2\u010f\u0110\3\2\2\2\u0110\u0111\3\2\2\2\u0111\u0119\7\5"+
		"\2\2\u0112\u0113\7\33\2\2\u0113\u0114\7\b\2\2\u0114\u0115\5\60\31\2\u0115"+
		"\u0116\7\t\2\2\u0116\u0119\3\2\2\2\u0117\u0119\5\22\n\2\u0118\u00db\3"+
		"\2\2\2\u0118\u00dc\3\2\2\2\u0118\u00e1\3\2\2\2\u0118\u00e4\3\2\2\2\u0118"+
		"\u00ee\3\2\2\2\u0118\u00f7\3\2\2\2\u0118\u0102\3\2\2\2\u0118\u010d\3\2"+
		"\2\2\u0118\u0112\3\2\2\2\u0118\u0117\3\2\2\2\u0119%\3\2\2\2\u011a\u011c"+
		"\5 \21\2\u011b\u011a\3\2\2\2\u011c\u011f\3\2\2\2\u011d\u011b\3\2\2\2\u011d"+
		"\u011e\3\2\2\2\u011e\u0121\3\2\2\2\u011f\u011d\3\2\2\2\u0120\u0122\5*"+
		"\26\2\u0121\u0120\3\2\2\2\u0121\u0122\3\2\2\2\u0122\u0126\3\2\2\2\u0123"+
		"\u0125\5 \21\2\u0124\u0123\3\2\2\2\u0125\u0128\3\2\2\2\u0126\u0124\3\2"+
		"\2\2\u0126\u0127\3\2\2\2\u0127\u0129\3\2\2\2\u0128\u0126\3\2\2\2\u0129"+
		"\u012c\7Q\2\2\u012a\u012b\7\4\2\2\u012b\u012d\5,\27\2\u012c\u012a\3\2"+
		"\2\2\u012c\u012d\3\2\2\2\u012d\'\3\2\2\2\u012e\u012f\7\5\2\2\u012f\u0130"+
		"\5,\27\2\u0130\u0131\7\5\2\2\u0131\u0132\5,\27\2\u0132\u0139\3\2\2\2\u0133"+
		"\u0134\7\17\2\2\u0134\u0135\5,\27\2\u0135\u0136\7\34\2\2\u0136\u0137\5"+
		",\27\2\u0137\u0139\3\2\2\2\u0138\u012e\3\2\2\2\u0138\u0133\3\2\2\2\u0139"+
		")\3\2\2\2\u013a\u013b\b\26\1\2\u013b\u013f\7D\2\2\u013c\u013d\7\35\2\2"+
		"\u013d\u013f\7D\2\2\u013e\u013a\3\2\2\2\u013e\u013c\3\2\2\2\u013f\u014a"+
		"\3\2\2\2\u0140\u0141\f\4\2\2\u0141\u0149\7\36\2\2\u0142\u0143\f\3\2\2"+
		"\u0143\u0145\7\37\2\2\u0144\u0146\5,\27\2\u0145\u0144\3\2\2\2\u0145\u0146"+
		"\3\2\2\2\u0146\u0147\3\2\2\2\u0147\u0149\7 \2\2\u0148\u0140\3\2\2\2\u0148"+
		"\u0142\3\2\2\2\u0149\u014c\3\2\2\2\u014a\u0148\3\2\2\2\u014a\u014b\3\2"+
		"\2\2\u014b+\3\2\2\2\u014c\u014a\3\2\2\2\u014d\u014e\b\27\1\2\u014e\u014f"+
		"\7\6\2\2\u014f\u0150\5,\27\2\u0150\u0151\7\7\2\2\u0151\u0176\3\2\2\2\u0152"+
		"\u0153\7Q\2\2\u0153\u0155\7\6\2\2\u0154\u0156\5.\30\2\u0155\u0154\3\2"+
		"\2\2\u0155\u0156\3\2\2\2\u0156\u0157\3\2\2\2\u0157\u0176\7\7\2\2\u0158"+
		"\u0159\7\6\2\2\u0159\u015a\5*\26\2\u015a\u015b\7\7\2\2\u015b\u015c\5,"+
		"\27\31\u015c\u0176\3\2\2\2\u015d\u015e\t\2\2\2\u015e\u0176\5,\27\30\u015f"+
		"\u0160\7\36\2\2\u0160\u0176\5,\27\26\u0161\u0162\t\3\2\2\u0162\u0176\5"+
		",\27\25\u0163\u0164\t\4\2\2\u0164\u0176\5,\27\21\u0165\u0166\7\b\2\2\u0166"+
		"\u016b\5,\27\2\u0167\u0168\7\16\2\2\u0168\u016a\5,\27\2\u0169\u0167\3"+
		"\2\2\2\u016a\u016d\3\2\2\2\u016b\u0169\3\2\2\2\u016b\u016c\3\2\2\2\u016c"+
		"\u016e\3\2\2\2\u016d\u016b\3\2\2\2\u016e\u016f\7\t\2\2\u016f\u0176\3\2"+
		"\2\2\u0170\u0176\7Q\2\2\u0171\u0176\7H\2\2\u0172\u0176\7E\2\2\u0173\u0176"+
		"\7F\2\2\u0174\u0176\7G\2\2\u0175\u014d\3\2\2\2\u0175\u0152\3\2\2\2\u0175"+
		"\u0158\3\2\2\2\u0175\u015d\3\2\2\2\u0175\u015f\3\2\2\2\u0175\u0161\3\2"+
		"\2\2\u0175\u0163\3\2\2\2\u0175\u0165\3\2\2\2\u0175\u0170\3\2\2\2\u0175"+
		"\u0171\3\2\2\2\u0175\u0172\3\2\2\2\u0175\u0173\3\2\2\2\u0175\u0174\3\2"+
		"\2\2\u0176\u01a1\3\2\2\2\u0177\u0178\f\24\2\2\u0178\u0179\t\5\2\2\u0179"+
		"\u01a0\5,\27\25\u017a\u017b\f\23\2\2\u017b\u017c\t\6\2\2\u017c\u01a0\5"+
		",\27\24\u017d\u017e\f\22\2\2\u017e\u017f\t\7\2\2\u017f\u01a0\5,\27\23"+
		"\u0180\u0181\f\20\2\2\u0181\u0182\t\b\2\2\u0182\u01a0\5,\27\21\u0183\u0184"+
		"\f\17\2\2\u0184\u0185\7&\2\2\u0185\u01a0\5,\27\20\u0186\u0187\f\16\2\2"+
		"\u0187\u0188\7\62\2\2\u0188\u01a0\5,\27\17\u0189\u018a\f\r\2\2\u018a\u018b"+
		"\7\63\2\2\u018b\u01a0\5,\27\16\u018c\u018d\f\f\2\2\u018d\u018e\7\64\2"+
		"\2\u018e\u01a0\5,\27\r\u018f\u0190\f\13\2\2\u0190\u0191\7\65\2\2\u0191"+
		"\u01a0\5,\27\f\u0192\u0193\f\n\2\2\u0193\u0194\7\4\2\2\u0194\u01a0\5,"+
		"\27\n\u0195\u0196\f\t\2\2\u0196\u0197\t\t\2\2\u0197\u01a0\5,\27\t\u0198"+
		"\u0199\f\32\2\2\u0199\u019a\7\37\2\2\u019a\u019b\5,\27\2\u019b\u019c\7"+
		" \2\2\u019c\u01a0\3\2\2\2\u019d\u019e\f\27\2\2\u019e\u01a0\t\2\2\2\u019f"+
		"\u0177\3\2\2\2\u019f\u017a\3\2\2\2\u019f\u017d\3\2\2\2\u019f\u0180\3\2"+
		"\2\2\u019f\u0183\3\2\2\2\u019f\u0186\3\2\2\2\u019f\u0189\3\2\2\2\u019f"+
		"\u018c\3\2\2\2\u019f\u018f\3\2\2\2\u019f\u0192\3\2\2\2\u019f\u0195\3\2"+
		"\2\2\u019f\u0198\3\2\2\2\u019f\u019d\3\2\2\2\u01a0\u01a3\3\2\2\2\u01a1"+
		"\u019f\3\2\2\2\u01a1\u01a2\3\2\2\2\u01a2-\3\2\2\2\u01a3\u01a1\3\2\2\2"+
		"\u01a4\u01a9\5,\27\2\u01a5\u01a6\7\16\2\2\u01a6\u01a8\5,\27\2\u01a7\u01a5"+
		"\3\2\2\2\u01a8\u01ab\3\2\2\2\u01a9\u01a7\3\2\2\2\u01a9\u01aa\3\2\2\2\u01aa"+
		"/\3\2\2\2\u01ab\u01a9\3\2\2\2\u01ac\u01ae\5\62\32\2\u01ad\u01ac\3\2\2"+
		"\2\u01ae\u01b1\3\2\2\2\u01af\u01ad\3\2\2\2\u01af\u01b0\3\2\2\2\u01b0\61"+
		"\3\2\2\2\u01b1\u01af\3\2\2\2\u01b2\u01b6\5\64\33\2\u01b3\u01b6\5\66\34"+
		"\2\u01b4\u01b6\58\35\2\u01b5\u01b2\3\2\2\2\u01b5\u01b3\3\2\2\2\u01b5\u01b4"+
		"\3\2\2\2\u01b6\63\3\2\2\2\u01b7\u01b8\7Q\2\2\u01b8\u01bf\7\17\2\2\u01b9"+
		"\u01bb\7%\2\2\u01ba\u01bc\7Q\2\2\u01bb\u01ba\3\2\2\2\u01bb\u01bc\3\2\2"+
		"\2\u01bc\u01bd\3\2\2\2\u01bd\u01bf\7\17\2\2\u01be\u01b7\3\2\2\2\u01be"+
		"\u01b9\3\2\2\2\u01bf\65\3\2\2\2\u01c0\u01c2\7B\2\2\u01c1\u01c3\5:\36\2"+
		"\u01c2\u01c1\3\2\2\2\u01c2\u01c3\3\2\2\2\u01c3\67\3\2\2\2\u01c4\u01c5"+
		"\7@\2\2\u01c5\u01ca\5<\37\2\u01c6\u01c7\7\16\2\2\u01c7\u01c9\5<\37\2\u01c8"+
		"\u01c6\3\2\2\2\u01c9\u01cc\3\2\2\2\u01ca\u01c8\3\2\2\2\u01ca\u01cb\3\2"+
		"\2\2\u01cb9\3\2\2\2\u01cc\u01ca\3\2\2\2\u01cd\u01e5\5<\37\2\u01ce\u01cf"+
		"\7A\2\2\u01cf\u01e5\5<\37\2\u01d0\u01d1\5<\37\2\u01d1\u01d2\7\16\2\2\u01d2"+
		"\u01d3\7Q\2\2\u01d3\u01e5\3\2\2\2\u01d4\u01d5\7\6\2\2\u01d5\u01d6\5<\37"+
		"\2\u01d6\u01d7\7\7\2\2\u01d7\u01d8\7\16\2\2\u01d8\u01d9\7Q\2\2\u01d9\u01e5"+
		"\3\2\2\2\u01da\u01db\7\6\2\2\u01db\u01dc\5<\37\2\u01dc\u01dd\7\16\2\2"+
		"\u01dd\u01de\7Q\2\2\u01de\u01df\7\7\2\2\u01df\u01e5\3\2\2\2\u01e0\u01e1"+
		"\7\6\2\2\u01e1\u01e2\5<\37\2\u01e2\u01e3\7\7\2\2\u01e3\u01e5\3\2\2\2\u01e4"+
		"\u01cd\3\2\2\2\u01e4\u01ce\3\2\2\2\u01e4\u01d0\3\2\2\2\u01e4\u01d4\3\2"+
		"\2\2\u01e4\u01da\3\2\2\2\u01e4\u01e0\3\2\2\2\u01e5;\3\2\2\2\u01e6\u01e7"+
		"\b\37\1\2\u01e7\u01e8\7\37\2\2\u01e8\u01e9\5<\37\2\u01e9\u01ea\7 \2\2"+
		"\u01ea\u01f5\3\2\2\2\u01eb\u01ec\t\n\2\2\u01ec\u01f5\5<\37\n\u01ed\u01f5"+
		"\7Q\2\2\u01ee\u01f5\7R\2\2\u01ef\u01f0\7\b\2\2\u01f0\u01f1\7Q\2\2\u01f1"+
		"\u01f5\7\t\2\2\u01f2\u01f5\7H\2\2\u01f3\u01f5\7F\2\2\u01f4\u01e6\3\2\2"+
		"\2\u01f4\u01eb\3\2\2\2\u01f4\u01ed\3\2\2\2\u01f4\u01ee\3\2\2\2\u01f4\u01ef"+
		"\3\2\2\2\u01f4\u01f2\3\2\2\2\u01f4\u01f3\3\2\2\2\u01f5\u0201\3\2\2\2\u01f6"+
		"\u01f7\f\13\2\2\u01f7\u01f8\t\5\2\2\u01f8\u0200\5<\37\f\u01f9\u01fa\f"+
		"\t\2\2\u01fa\u01fb\t\13\2\2\u01fb\u0200\5<\37\n\u01fc\u01fd\f\b\2\2\u01fd"+
		"\u01fe\t\7\2\2\u01fe\u0200\5<\37\t\u01ff\u01f6\3\2\2\2\u01ff\u01f9\3\2"+
		"\2\2\u01ff\u01fc\3\2\2\2\u0200\u0203\3\2\2\2\u0201\u01ff\3\2\2\2\u0201"+
		"\u0202\3\2\2\2\u0202=\3\2\2\2\u0203\u0201\3\2\2\2\67HQV[bhov|\u0081\u0087"+
		"\u0091\u009c\u00a3\u00af\u00b7\u00bd\u00c4\u00d4\u00d9\u00de\u00eb\u00ee"+
		"\u00f7\u0102\u0107\u010f\u0118\u011d\u0121\u0126\u012c\u0138\u013e\u0145"+
		"\u0148\u014a\u0155\u016b\u0175\u019f\u01a1\u01a9\u01af\u01b5\u01bb\u01be"+
		"\u01c2\u01ca\u01e4\u01f4\u01ff\u0201";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}
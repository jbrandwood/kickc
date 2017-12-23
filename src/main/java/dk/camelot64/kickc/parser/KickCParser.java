// Generated from C:/c64/src/kickc/src/main/java/dk/camelot64/kickc/parser\KickC.g4 by ANTLR 4.7
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
		T__45=46, T__46=47, MNEMONIC=48, SIMPLETYPE=49, STRING=50, CHAR=51, BOOLEAN=52, 
		NUMBER=53, NUMFLOAT=54, BINFLOAT=55, DECFLOAT=56, HEXFLOAT=57, NUMINT=58, 
		BININTEGER=59, DECINTEGER=60, HEXINTEGER=61, NAME=62, ASMREL=63, WS=64, 
		COMMENT_LINE=65, COMMENT_BLOCK=66;
	public static final int
		RULE_file = 0, RULE_asmFile = 1, RULE_importSeq = 2, RULE_importDecl = 3, 
		RULE_declSeq = 4, RULE_decl = 5, RULE_parameterListDecl = 6, RULE_parameterDecl = 7, 
		RULE_declVar = 8, RULE_stmtSeq = 9, RULE_stmt = 10, RULE_forDeclaration = 11, 
		RULE_forIteration = 12, RULE_typeDecl = 13, RULE_lvalue = 14, RULE_expr = 15, 
		RULE_parameterList = 16, RULE_asmLines = 17, RULE_asmLine = 18, RULE_asmLabel = 19, 
		RULE_asmInstruction = 20, RULE_asmParamMode = 21, RULE_asmExpr = 22;
	public static final String[] ruleNames = {
		"file", "asmFile", "importSeq", "importDecl", "declSeq", "decl", "parameterListDecl", 
		"parameterDecl", "declVar", "stmtSeq", "stmt", "forDeclaration", "forIteration", 
		"typeDecl", "lvalue", "expr", "parameterList", "asmLines", "asmLine", 
		"asmLabel", "asmInstruction", "asmParamMode", "asmExpr"
	};

	private static final String[] _LITERAL_NAMES = {
		null, "'import'", "'('", "')'", "'{'", "'}'", "','", "'const'", "'='", 
		"';'", "'if'", "'else'", "'while'", "'do'", "'for'", "'return'", "'asm'", 
		"':'", "'..'", "'signed'", "'*'", "'['", "']'", "'<'", "'>'", "'--'", 
		"'++'", "'+'", "'-'", "'!'", "'&'", "'~'", "'>>'", "'<<'", "'/'", "'%'", 
		"'=='", "'!='", "'<>'", "'<='", "'=<'", "'>='", "'=>'", "'^'", "'|'", 
		"'&&'", "'||'", "'#'"
	};
	private static final String[] _SYMBOLIC_NAMES = {
		null, null, null, null, null, null, null, null, null, null, null, null, 
		null, null, null, null, null, null, null, null, null, null, null, null, 
		null, null, null, null, null, null, null, null, null, null, null, null, 
		null, null, null, null, null, null, null, null, null, null, null, null, 
		"MNEMONIC", "SIMPLETYPE", "STRING", "CHAR", "BOOLEAN", "NUMBER", "NUMFLOAT", 
		"BINFLOAT", "DECFLOAT", "HEXFLOAT", "NUMINT", "BININTEGER", "DECINTEGER", 
		"HEXINTEGER", "NAME", "ASMREL", "WS", "COMMENT_LINE", "COMMENT_BLOCK"
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
			setState(46);
			importSeq();
			setState(47);
			declSeq();
			setState(48);
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
			setState(50);
			asmLines();
			setState(51);
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
			setState(56);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==T__0) {
				{
				{
				setState(53);
				importDecl();
				}
				}
				setState(58);
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
			setState(59);
			match(T__0);
			setState(60);
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
			setState(63); 
			_errHandler.sync(this);
			_la = _input.LA(1);
			do {
				{
				{
				setState(62);
				decl();
				}
				}
				setState(65); 
				_errHandler.sync(this);
				_la = _input.LA(1);
			} while ( (((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__6) | (1L << T__18) | (1L << SIMPLETYPE))) != 0) );
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
		public DeclContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_decl; }
	 
		public DeclContext() { }
		public void copyFrom(DeclContext ctx) {
			super.copyFrom(ctx);
		}
	}
	public static class DeclVariableContext extends DeclContext {
		public DeclVarContext declVar() {
			return getRuleContext(DeclVarContext.class,0);
		}
		public DeclVariableContext(DeclContext ctx) { copyFrom(ctx); }
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
	public static class DeclMethodContext extends DeclContext {
		public TypeDeclContext typeDecl() {
			return getRuleContext(TypeDeclContext.class,0);
		}
		public TerminalNode NAME() { return getToken(KickCParser.NAME, 0); }
		public ParameterListDeclContext parameterListDecl() {
			return getRuleContext(ParameterListDeclContext.class,0);
		}
		public StmtSeqContext stmtSeq() {
			return getRuleContext(StmtSeqContext.class,0);
		}
		public DeclMethodContext(DeclContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterDeclMethod(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitDeclMethod(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitDeclMethod(this);
			else return visitor.visitChildren(this);
		}
	}

	public final DeclContext decl() throws RecognitionException {
		DeclContext _localctx = new DeclContext(_ctx, getState());
		enterRule(_localctx, 10, RULE_decl);
		int _la;
		try {
			setState(81);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,4,_ctx) ) {
			case 1:
				_localctx = new DeclMethodContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(67);
				typeDecl(0);
				setState(68);
				match(NAME);
				setState(69);
				match(T__1);
				setState(71);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if (_la==T__18 || _la==SIMPLETYPE) {
					{
					setState(70);
					parameterListDecl();
					}
				}

				setState(73);
				match(T__2);
				setState(74);
				match(T__3);
				setState(76);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__1) | (1L << T__3) | (1L << T__6) | (1L << T__9) | (1L << T__11) | (1L << T__12) | (1L << T__13) | (1L << T__14) | (1L << T__15) | (1L << T__18) | (1L << T__19) | (1L << T__22) | (1L << T__23) | (1L << T__24) | (1L << T__25) | (1L << T__26) | (1L << T__27) | (1L << T__28) | (1L << T__29) | (1L << T__30) | (1L << SIMPLETYPE) | (1L << STRING) | (1L << CHAR) | (1L << BOOLEAN) | (1L << NUMBER) | (1L << NAME))) != 0)) {
					{
					setState(75);
					stmtSeq();
					}
				}

				setState(78);
				match(T__4);
				}
				break;
			case 2:
				_localctx = new DeclVariableContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(80);
				declVar();
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
		enterRule(_localctx, 12, RULE_parameterListDecl);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(83);
			parameterDecl();
			setState(88);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==T__5) {
				{
				{
				setState(84);
				match(T__5);
				setState(85);
				parameterDecl();
				}
				}
				setState(90);
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
		enterRule(_localctx, 14, RULE_parameterDecl);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(91);
			typeDecl(0);
			setState(92);
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

	public static class DeclVarContext extends ParserRuleContext {
		public TypeDeclContext typeDecl() {
			return getRuleContext(TypeDeclContext.class,0);
		}
		public TerminalNode NAME() { return getToken(KickCParser.NAME, 0); }
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public DeclVarContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_declVar; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterDeclVar(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitDeclVar(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitDeclVar(this);
			else return visitor.visitChildren(this);
		}
	}

	public final DeclVarContext declVar() throws RecognitionException {
		DeclVarContext _localctx = new DeclVarContext(_ctx, getState());
		enterRule(_localctx, 16, RULE_declVar);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(95);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__6) {
				{
				setState(94);
				match(T__6);
				}
			}

			setState(97);
			typeDecl(0);
			setState(98);
			match(NAME);
			setState(101);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__7) {
				{
				setState(99);
				match(T__7);
				setState(100);
				expr(0);
				}
			}

			setState(103);
			match(T__8);
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
		enterRule(_localctx, 18, RULE_stmtSeq);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(106); 
			_errHandler.sync(this);
			_la = _input.LA(1);
			do {
				{
				{
				setState(105);
				stmt();
				}
				}
				setState(108); 
				_errHandler.sync(this);
				_la = _input.LA(1);
			} while ( (((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__1) | (1L << T__3) | (1L << T__6) | (1L << T__9) | (1L << T__11) | (1L << T__12) | (1L << T__13) | (1L << T__14) | (1L << T__15) | (1L << T__18) | (1L << T__19) | (1L << T__22) | (1L << T__23) | (1L << T__24) | (1L << T__25) | (1L << T__26) | (1L << T__27) | (1L << T__28) | (1L << T__29) | (1L << T__30) | (1L << SIMPLETYPE) | (1L << STRING) | (1L << CHAR) | (1L << BOOLEAN) | (1L << NUMBER) | (1L << NAME))) != 0) );
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
		public DeclVarContext declVar() {
			return getRuleContext(DeclVarContext.class,0);
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
	public static class StmtAssignmentContext extends StmtContext {
		public LvalueContext lvalue() {
			return getRuleContext(LvalueContext.class,0);
		}
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public StmtAssignmentContext(StmtContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterStmtAssignment(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitStmtAssignment(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitStmtAssignment(this);
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
		enterRule(_localctx, 20, RULE_stmt);
		int _la;
		try {
			setState(166);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,13,_ctx) ) {
			case 1:
				_localctx = new StmtDeclVarContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(110);
				declVar();
				}
				break;
			case 2:
				_localctx = new StmtBlockContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(111);
				match(T__3);
				setState(113);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__1) | (1L << T__3) | (1L << T__6) | (1L << T__9) | (1L << T__11) | (1L << T__12) | (1L << T__13) | (1L << T__14) | (1L << T__15) | (1L << T__18) | (1L << T__19) | (1L << T__22) | (1L << T__23) | (1L << T__24) | (1L << T__25) | (1L << T__26) | (1L << T__27) | (1L << T__28) | (1L << T__29) | (1L << T__30) | (1L << SIMPLETYPE) | (1L << STRING) | (1L << CHAR) | (1L << BOOLEAN) | (1L << NUMBER) | (1L << NAME))) != 0)) {
					{
					setState(112);
					stmtSeq();
					}
				}

				setState(115);
				match(T__4);
				}
				break;
			case 3:
				_localctx = new StmtAssignmentContext(_localctx);
				enterOuterAlt(_localctx, 3);
				{
				setState(116);
				lvalue(0);
				setState(117);
				match(T__7);
				setState(118);
				expr(0);
				setState(119);
				match(T__8);
				}
				break;
			case 4:
				_localctx = new StmtExprContext(_localctx);
				enterOuterAlt(_localctx, 4);
				{
				setState(121);
				expr(0);
				setState(122);
				match(T__8);
				}
				break;
			case 5:
				_localctx = new StmtIfElseContext(_localctx);
				enterOuterAlt(_localctx, 5);
				{
				setState(124);
				match(T__9);
				setState(125);
				match(T__1);
				setState(126);
				expr(0);
				setState(127);
				match(T__2);
				setState(128);
				stmt();
				setState(131);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,10,_ctx) ) {
				case 1:
					{
					setState(129);
					match(T__10);
					setState(130);
					stmt();
					}
					break;
				}
				}
				break;
			case 6:
				_localctx = new StmtWhileContext(_localctx);
				enterOuterAlt(_localctx, 6);
				{
				setState(133);
				match(T__11);
				setState(134);
				match(T__1);
				setState(135);
				expr(0);
				setState(136);
				match(T__2);
				setState(137);
				stmt();
				}
				break;
			case 7:
				_localctx = new StmtDoWhileContext(_localctx);
				enterOuterAlt(_localctx, 7);
				{
				setState(139);
				match(T__12);
				setState(140);
				stmt();
				setState(141);
				match(T__11);
				setState(142);
				match(T__1);
				setState(143);
				expr(0);
				setState(144);
				match(T__2);
				setState(145);
				match(T__8);
				}
				break;
			case 8:
				_localctx = new StmtForContext(_localctx);
				enterOuterAlt(_localctx, 8);
				{
				setState(147);
				match(T__13);
				setState(148);
				match(T__1);
				setState(150);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__18) | (1L << SIMPLETYPE) | (1L << NAME))) != 0)) {
					{
					setState(149);
					forDeclaration();
					}
				}

				setState(152);
				forIteration();
				setState(153);
				match(T__2);
				setState(154);
				stmt();
				}
				break;
			case 9:
				_localctx = new StmtReturnContext(_localctx);
				enterOuterAlt(_localctx, 9);
				{
				setState(156);
				match(T__14);
				setState(158);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__1) | (1L << T__3) | (1L << T__19) | (1L << T__22) | (1L << T__23) | (1L << T__24) | (1L << T__25) | (1L << T__26) | (1L << T__27) | (1L << T__28) | (1L << T__29) | (1L << T__30) | (1L << STRING) | (1L << CHAR) | (1L << BOOLEAN) | (1L << NUMBER) | (1L << NAME))) != 0)) {
					{
					setState(157);
					expr(0);
					}
				}

				setState(160);
				match(T__8);
				}
				break;
			case 10:
				_localctx = new StmtAsmContext(_localctx);
				enterOuterAlt(_localctx, 10);
				{
				setState(161);
				match(T__15);
				setState(162);
				match(T__3);
				setState(163);
				asmLines();
				setState(164);
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
		enterRule(_localctx, 22, RULE_forDeclaration);
		int _la;
		try {
			_localctx = new ForDeclContext(_localctx);
			enterOuterAlt(_localctx, 1);
			{
			setState(169);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__18 || _la==SIMPLETYPE) {
				{
				setState(168);
				typeDecl(0);
				}
			}

			setState(171);
			match(NAME);
			setState(174);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__7) {
				{
				setState(172);
				match(T__7);
				setState(173);
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
		enterRule(_localctx, 24, RULE_forIteration);
		int _la;
		try {
			setState(187);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case T__8:
				_localctx = new ForClassicContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(176);
				match(T__8);
				setState(177);
				expr(0);
				setState(178);
				match(T__8);
				setState(180);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__1) | (1L << T__3) | (1L << T__19) | (1L << T__22) | (1L << T__23) | (1L << T__24) | (1L << T__25) | (1L << T__26) | (1L << T__27) | (1L << T__28) | (1L << T__29) | (1L << T__30) | (1L << STRING) | (1L << CHAR) | (1L << BOOLEAN) | (1L << NUMBER) | (1L << NAME))) != 0)) {
					{
					setState(179);
					expr(0);
					}
				}

				}
				break;
			case T__16:
				_localctx = new ForRangeContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(182);
				match(T__16);
				setState(183);
				expr(0);
				{
				setState(184);
				match(T__17);
				}
				setState(185);
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
		int _startState = 26;
		enterRecursionRule(_localctx, 26, RULE_typeDecl, _p);
		int _la;
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(193);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case SIMPLETYPE:
				{
				_localctx = new TypeSimpleContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;

				setState(190);
				match(SIMPLETYPE);
				}
				break;
			case T__18:
				{
				_localctx = new TypeSignedSimpleContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(191);
				match(T__18);
				setState(192);
				match(SIMPLETYPE);
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
			_ctx.stop = _input.LT(-1);
			setState(205);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,21,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					setState(203);
					_errHandler.sync(this);
					switch ( getInterpreter().adaptivePredict(_input,20,_ctx) ) {
					case 1:
						{
						_localctx = new TypePtrContext(new TypeDeclContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_typeDecl);
						setState(195);
						if (!(precpred(_ctx, 2))) throw new FailedPredicateException(this, "precpred(_ctx, 2)");
						setState(196);
						match(T__19);
						}
						break;
					case 2:
						{
						_localctx = new TypeArrayContext(new TypeDeclContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_typeDecl);
						setState(197);
						if (!(precpred(_ctx, 1))) throw new FailedPredicateException(this, "precpred(_ctx, 1)");
						setState(198);
						match(T__20);
						setState(200);
						_errHandler.sync(this);
						_la = _input.LA(1);
						if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__1) | (1L << T__3) | (1L << T__19) | (1L << T__22) | (1L << T__23) | (1L << T__24) | (1L << T__25) | (1L << T__26) | (1L << T__27) | (1L << T__28) | (1L << T__29) | (1L << T__30) | (1L << STRING) | (1L << CHAR) | (1L << BOOLEAN) | (1L << NUMBER) | (1L << NAME))) != 0)) {
							{
							setState(199);
							expr(0);
							}
						}

						setState(202);
						match(T__21);
						}
						break;
					}
					} 
				}
				setState(207);
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

	public static class LvalueContext extends ParserRuleContext {
		public LvalueContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_lvalue; }
	 
		public LvalueContext() { }
		public void copyFrom(LvalueContext ctx) {
			super.copyFrom(ctx);
		}
	}
	public static class LvalueNameContext extends LvalueContext {
		public TerminalNode NAME() { return getToken(KickCParser.NAME, 0); }
		public LvalueNameContext(LvalueContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterLvalueName(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitLvalueName(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitLvalueName(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class LvaluePtrContext extends LvalueContext {
		public TerminalNode NAME() { return getToken(KickCParser.NAME, 0); }
		public LvaluePtrContext(LvalueContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterLvaluePtr(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitLvaluePtr(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitLvaluePtr(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class LvaluePtrExprContext extends LvalueContext {
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public LvaluePtrExprContext(LvalueContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterLvaluePtrExpr(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitLvaluePtrExpr(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitLvaluePtrExpr(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class LvalueArrayContext extends LvalueContext {
		public LvalueContext lvalue() {
			return getRuleContext(LvalueContext.class,0);
		}
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public LvalueArrayContext(LvalueContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterLvalueArray(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitLvalueArray(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitLvalueArray(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class LvalueLoHiContext extends LvalueContext {
		public LvalueContext lvalue() {
			return getRuleContext(LvalueContext.class,0);
		}
		public LvalueLoHiContext(LvalueContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterLvalueLoHi(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitLvalueLoHi(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitLvalueLoHi(this);
			else return visitor.visitChildren(this);
		}
	}

	public final LvalueContext lvalue() throws RecognitionException {
		return lvalue(0);
	}

	private LvalueContext lvalue(int _p) throws RecognitionException {
		ParserRuleContext _parentctx = _ctx;
		int _parentState = getState();
		LvalueContext _localctx = new LvalueContext(_ctx, _parentState);
		LvalueContext _prevctx = _localctx;
		int _startState = 28;
		enterRecursionRule(_localctx, 28, RULE_lvalue, _p);
		int _la;
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(219);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,22,_ctx) ) {
			case 1:
				{
				_localctx = new LvalueNameContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;

				setState(209);
				match(NAME);
				}
				break;
			case 2:
				{
				_localctx = new LvaluePtrContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(210);
				match(T__19);
				setState(211);
				match(NAME);
				}
				break;
			case 3:
				{
				_localctx = new LvaluePtrExprContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(212);
				match(T__19);
				setState(213);
				match(T__1);
				setState(214);
				expr(0);
				setState(215);
				match(T__2);
				}
				break;
			case 4:
				{
				_localctx = new LvalueLoHiContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(217);
				_la = _input.LA(1);
				if ( !(_la==T__22 || _la==T__23) ) {
				_errHandler.recoverInline(this);
				}
				else {
					if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
					_errHandler.reportMatch(this);
					consume();
				}
				setState(218);
				lvalue(2);
				}
				break;
			}
			_ctx.stop = _input.LT(-1);
			setState(228);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,23,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					{
					_localctx = new LvalueArrayContext(new LvalueContext(_parentctx, _parentState));
					pushNewRecursionContext(_localctx, _startState, RULE_lvalue);
					setState(221);
					if (!(precpred(_ctx, 1))) throw new FailedPredicateException(this, "precpred(_ctx, 1)");
					setState(222);
					match(T__20);
					setState(223);
					expr(0);
					setState(224);
					match(T__21);
					}
					} 
				}
				setState(230);
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
		int _startState = 30;
		enterRecursionRule(_localctx, 30, RULE_expr, _p);
		int _la;
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(267);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,26,_ctx) ) {
			case 1:
				{
				_localctx = new ExprParContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;

				setState(232);
				match(T__1);
				setState(233);
				expr(0);
				setState(234);
				match(T__2);
				}
				break;
			case 2:
				{
				_localctx = new ExprCallContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(236);
				match(NAME);
				setState(237);
				match(T__1);
				setState(239);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__1) | (1L << T__3) | (1L << T__19) | (1L << T__22) | (1L << T__23) | (1L << T__24) | (1L << T__25) | (1L << T__26) | (1L << T__27) | (1L << T__28) | (1L << T__29) | (1L << T__30) | (1L << STRING) | (1L << CHAR) | (1L << BOOLEAN) | (1L << NUMBER) | (1L << NAME))) != 0)) {
					{
					setState(238);
					parameterList();
					}
				}

				setState(241);
				match(T__2);
				}
				break;
			case 3:
				{
				_localctx = new ExprCastContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(242);
				match(T__1);
				setState(243);
				typeDecl(0);
				setState(244);
				match(T__2);
				setState(245);
				expr(20);
				}
				break;
			case 4:
				{
				_localctx = new ExprPreModContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(247);
				_la = _input.LA(1);
				if ( !(_la==T__24 || _la==T__25) ) {
				_errHandler.recoverInline(this);
				}
				else {
					if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
					_errHandler.reportMatch(this);
					consume();
				}
				setState(248);
				expr(18);
				}
				break;
			case 5:
				{
				_localctx = new ExprUnaryContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(249);
				_la = _input.LA(1);
				if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__19) | (1L << T__22) | (1L << T__23) | (1L << T__26) | (1L << T__27) | (1L << T__28) | (1L << T__29) | (1L << T__30))) != 0)) ) {
				_errHandler.recoverInline(this);
				}
				else {
					if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
					_errHandler.reportMatch(this);
					consume();
				}
				setState(250);
				expr(16);
				}
				break;
			case 6:
				{
				_localctx = new InitListContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(251);
				match(T__3);
				setState(252);
				expr(0);
				setState(257);
				_errHandler.sync(this);
				_la = _input.LA(1);
				while (_la==T__5) {
					{
					{
					setState(253);
					match(T__5);
					setState(254);
					expr(0);
					}
					}
					setState(259);
					_errHandler.sync(this);
					_la = _input.LA(1);
				}
				setState(260);
				match(T__4);
				}
				break;
			case 7:
				{
				_localctx = new ExprIdContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(262);
				match(NAME);
				}
				break;
			case 8:
				{
				_localctx = new ExprNumberContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(263);
				match(NUMBER);
				}
				break;
			case 9:
				{
				_localctx = new ExprStringContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(264);
				match(STRING);
				}
				break;
			case 10:
				{
				_localctx = new ExprCharContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(265);
				match(CHAR);
				}
				break;
			case 11:
				{
				_localctx = new ExprBoolContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(266);
				match(BOOLEAN);
				}
				break;
			}
			_ctx.stop = _input.LT(-1);
			setState(305);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,28,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					setState(303);
					_errHandler.sync(this);
					switch ( getInterpreter().adaptivePredict(_input,27,_ctx) ) {
					case 1:
						{
						_localctx = new ExprBinaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(269);
						if (!(precpred(_ctx, 15))) throw new FailedPredicateException(this, "precpred(_ctx, 15)");
						setState(270);
						_la = _input.LA(1);
						if ( !(_la==T__31 || _la==T__32) ) {
						_errHandler.recoverInline(this);
						}
						else {
							if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
							_errHandler.reportMatch(this);
							consume();
						}
						setState(271);
						expr(16);
						}
						break;
					case 2:
						{
						_localctx = new ExprBinaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(272);
						if (!(precpred(_ctx, 14))) throw new FailedPredicateException(this, "precpred(_ctx, 14)");
						setState(273);
						_la = _input.LA(1);
						if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__19) | (1L << T__33) | (1L << T__34))) != 0)) ) {
						_errHandler.recoverInline(this);
						}
						else {
							if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
							_errHandler.reportMatch(this);
							consume();
						}
						setState(274);
						expr(15);
						}
						break;
					case 3:
						{
						_localctx = new ExprBinaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(275);
						if (!(precpred(_ctx, 13))) throw new FailedPredicateException(this, "precpred(_ctx, 13)");
						setState(276);
						_la = _input.LA(1);
						if ( !(_la==T__26 || _la==T__27) ) {
						_errHandler.recoverInline(this);
						}
						else {
							if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
							_errHandler.reportMatch(this);
							consume();
						}
						setState(277);
						expr(14);
						}
						break;
					case 4:
						{
						_localctx = new ExprBinaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(278);
						if (!(precpred(_ctx, 12))) throw new FailedPredicateException(this, "precpred(_ctx, 12)");
						setState(279);
						_la = _input.LA(1);
						if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__22) | (1L << T__23) | (1L << T__35) | (1L << T__36) | (1L << T__37) | (1L << T__38) | (1L << T__39) | (1L << T__40) | (1L << T__41))) != 0)) ) {
						_errHandler.recoverInline(this);
						}
						else {
							if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
							_errHandler.reportMatch(this);
							consume();
						}
						setState(280);
						expr(13);
						}
						break;
					case 5:
						{
						_localctx = new ExprBinaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(281);
						if (!(precpred(_ctx, 11))) throw new FailedPredicateException(this, "precpred(_ctx, 11)");
						{
						setState(282);
						match(T__29);
						}
						setState(283);
						expr(12);
						}
						break;
					case 6:
						{
						_localctx = new ExprBinaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(284);
						if (!(precpred(_ctx, 10))) throw new FailedPredicateException(this, "precpred(_ctx, 10)");
						{
						setState(285);
						match(T__42);
						}
						setState(286);
						expr(11);
						}
						break;
					case 7:
						{
						_localctx = new ExprBinaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(287);
						if (!(precpred(_ctx, 9))) throw new FailedPredicateException(this, "precpred(_ctx, 9)");
						{
						setState(288);
						match(T__43);
						}
						setState(289);
						expr(10);
						}
						break;
					case 8:
						{
						_localctx = new ExprBinaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(290);
						if (!(precpred(_ctx, 8))) throw new FailedPredicateException(this, "precpred(_ctx, 8)");
						{
						setState(291);
						match(T__44);
						}
						setState(292);
						expr(9);
						}
						break;
					case 9:
						{
						_localctx = new ExprBinaryContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(293);
						if (!(precpred(_ctx, 7))) throw new FailedPredicateException(this, "precpred(_ctx, 7)");
						{
						setState(294);
						match(T__45);
						}
						setState(295);
						expr(8);
						}
						break;
					case 10:
						{
						_localctx = new ExprArrayContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(296);
						if (!(precpred(_ctx, 19))) throw new FailedPredicateException(this, "precpred(_ctx, 19)");
						setState(297);
						match(T__20);
						setState(298);
						expr(0);
						setState(299);
						match(T__21);
						}
						break;
					case 11:
						{
						_localctx = new ExprPostModContext(new ExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(301);
						if (!(precpred(_ctx, 17))) throw new FailedPredicateException(this, "precpred(_ctx, 17)");
						setState(302);
						_la = _input.LA(1);
						if ( !(_la==T__24 || _la==T__25) ) {
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
				setState(307);
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
		enterRule(_localctx, 32, RULE_parameterList);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(308);
			expr(0);
			setState(313);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==T__5) {
				{
				{
				setState(309);
				match(T__5);
				setState(310);
				expr(0);
				}
				}
				setState(315);
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
		enterRule(_localctx, 34, RULE_asmLines);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(319);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__28) | (1L << MNEMONIC) | (1L << NAME))) != 0)) {
				{
				{
				setState(316);
				asmLine();
				}
				}
				setState(321);
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
		enterRule(_localctx, 36, RULE_asmLine);
		try {
			setState(324);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case T__28:
			case NAME:
				enterOuterAlt(_localctx, 1);
				{
				setState(322);
				asmLabel();
				}
				break;
			case MNEMONIC:
				enterOuterAlt(_localctx, 2);
				{
				setState(323);
				asmInstruction();
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
		public TerminalNode NAME() { return getToken(KickCParser.NAME, 0); }
		public AsmLabelContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_asmLabel; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).enterAsmLabel(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof KickCListener ) ((KickCListener)listener).exitAsmLabel(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof KickCVisitor ) return ((KickCVisitor<? extends T>)visitor).visitAsmLabel(this);
			else return visitor.visitChildren(this);
		}
	}

	public final AsmLabelContext asmLabel() throws RecognitionException {
		AsmLabelContext _localctx = new AsmLabelContext(_ctx, getState());
		enterRule(_localctx, 38, RULE_asmLabel);
		try {
			setState(330);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case NAME:
				enterOuterAlt(_localctx, 1);
				{
				setState(326);
				match(NAME);
				setState(327);
				match(T__16);
				}
				break;
			case T__28:
				enterOuterAlt(_localctx, 2);
				{
				setState(328);
				match(T__28);
				setState(329);
				match(T__16);
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
		enterRule(_localctx, 40, RULE_asmInstruction);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(332);
			match(MNEMONIC);
			setState(334);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,33,_ctx) ) {
			case 1:
				{
				setState(333);
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
		enterRule(_localctx, 42, RULE_asmParamMode);
		try {
			setState(359);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,34,_ctx) ) {
			case 1:
				_localctx = new AsmModeAbsContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(336);
				asmExpr(0);
				}
				break;
			case 2:
				_localctx = new AsmModeImmContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(337);
				match(T__46);
				setState(338);
				asmExpr(0);
				}
				break;
			case 3:
				_localctx = new AsmModeAbsXYContext(_localctx);
				enterOuterAlt(_localctx, 3);
				{
				setState(339);
				asmExpr(0);
				setState(340);
				match(T__5);
				setState(341);
				match(NAME);
				}
				break;
			case 4:
				_localctx = new AsmModeIndIdxXYContext(_localctx);
				enterOuterAlt(_localctx, 4);
				{
				setState(343);
				match(T__1);
				setState(344);
				asmExpr(0);
				setState(345);
				match(T__2);
				setState(346);
				match(T__5);
				setState(347);
				match(NAME);
				}
				break;
			case 5:
				_localctx = new AsmModeIdxIndXYContext(_localctx);
				enterOuterAlt(_localctx, 5);
				{
				setState(349);
				match(T__1);
				setState(350);
				asmExpr(0);
				setState(351);
				match(T__5);
				setState(352);
				match(NAME);
				setState(353);
				match(T__2);
				}
				break;
			case 6:
				_localctx = new AsmModeIndContext(_localctx);
				enterOuterAlt(_localctx, 6);
				{
				setState(355);
				match(T__1);
				setState(356);
				asmExpr(0);
				setState(357);
				match(T__2);
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
		int _startState = 44;
		enterRecursionRule(_localctx, 44, RULE_asmExpr, _p);
		int _la;
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(371);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case T__22:
			case T__23:
			case T__26:
			case T__27:
				{
				_localctx = new AsmExprUnaryContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;

				setState(362);
				_la = _input.LA(1);
				if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__22) | (1L << T__23) | (1L << T__26) | (1L << T__27))) != 0)) ) {
				_errHandler.recoverInline(this);
				}
				else {
					if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
					_errHandler.reportMatch(this);
					consume();
				}
				setState(363);
				asmExpr(8);
				}
				break;
			case NAME:
				{
				_localctx = new AsmExprLabelContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(364);
				match(NAME);
				}
				break;
			case ASMREL:
				{
				_localctx = new AsmExprLabelRelContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(365);
				match(ASMREL);
				}
				break;
			case T__3:
				{
				_localctx = new AsmExprReplaceContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(366);
				match(T__3);
				setState(367);
				match(NAME);
				setState(368);
				match(T__4);
				}
				break;
			case NUMBER:
				{
				_localctx = new AsmExprIntContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(369);
				match(NUMBER);
				}
				break;
			case CHAR:
				{
				_localctx = new AsmExprCharContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(370);
				match(CHAR);
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
			_ctx.stop = _input.LT(-1);
			setState(381);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,37,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					setState(379);
					_errHandler.sync(this);
					switch ( getInterpreter().adaptivePredict(_input,36,_ctx) ) {
					case 1:
						{
						_localctx = new AsmExprBinaryContext(new AsmExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_asmExpr);
						setState(373);
						if (!(precpred(_ctx, 7))) throw new FailedPredicateException(this, "precpred(_ctx, 7)");
						setState(374);
						_la = _input.LA(1);
						if ( !(_la==T__19 || _la==T__33) ) {
						_errHandler.recoverInline(this);
						}
						else {
							if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
							_errHandler.reportMatch(this);
							consume();
						}
						setState(375);
						asmExpr(8);
						}
						break;
					case 2:
						{
						_localctx = new AsmExprBinaryContext(new AsmExprContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_asmExpr);
						setState(376);
						if (!(precpred(_ctx, 6))) throw new FailedPredicateException(this, "precpred(_ctx, 6)");
						setState(377);
						_la = _input.LA(1);
						if ( !(_la==T__26 || _la==T__27) ) {
						_errHandler.recoverInline(this);
						}
						else {
							if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
							_errHandler.reportMatch(this);
							consume();
						}
						setState(378);
						asmExpr(7);
						}
						break;
					}
					} 
				}
				setState(383);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,37,_ctx);
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
		case 13:
			return typeDecl_sempred((TypeDeclContext)_localctx, predIndex);
		case 14:
			return lvalue_sempred((LvalueContext)_localctx, predIndex);
		case 15:
			return expr_sempred((ExprContext)_localctx, predIndex);
		case 22:
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
	private boolean lvalue_sempred(LvalueContext _localctx, int predIndex) {
		switch (predIndex) {
		case 2:
			return precpred(_ctx, 1);
		}
		return true;
	}
	private boolean expr_sempred(ExprContext _localctx, int predIndex) {
		switch (predIndex) {
		case 3:
			return precpred(_ctx, 15);
		case 4:
			return precpred(_ctx, 14);
		case 5:
			return precpred(_ctx, 13);
		case 6:
			return precpred(_ctx, 12);
		case 7:
			return precpred(_ctx, 11);
		case 8:
			return precpred(_ctx, 10);
		case 9:
			return precpred(_ctx, 9);
		case 10:
			return precpred(_ctx, 8);
		case 11:
			return precpred(_ctx, 7);
		case 12:
			return precpred(_ctx, 19);
		case 13:
			return precpred(_ctx, 17);
		}
		return true;
	}
	private boolean asmExpr_sempred(AsmExprContext _localctx, int predIndex) {
		switch (predIndex) {
		case 14:
			return precpred(_ctx, 7);
		case 15:
			return precpred(_ctx, 6);
		}
		return true;
	}

	public static final String _serializedATN =
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\3D\u0183\4\2\t\2\4"+
		"\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n\t\n\4\13\t"+
		"\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\4\20\t\20\4\21\t\21\4\22\t\22"+
		"\4\23\t\23\4\24\t\24\4\25\t\25\4\26\t\26\4\27\t\27\4\30\t\30\3\2\3\2\3"+
		"\2\3\2\3\3\3\3\3\3\3\4\7\49\n\4\f\4\16\4<\13\4\3\5\3\5\3\5\3\6\6\6B\n"+
		"\6\r\6\16\6C\3\7\3\7\3\7\3\7\5\7J\n\7\3\7\3\7\3\7\5\7O\n\7\3\7\3\7\3\7"+
		"\5\7T\n\7\3\b\3\b\3\b\7\bY\n\b\f\b\16\b\\\13\b\3\t\3\t\3\t\3\n\5\nb\n"+
		"\n\3\n\3\n\3\n\3\n\5\nh\n\n\3\n\3\n\3\13\6\13m\n\13\r\13\16\13n\3\f\3"+
		"\f\3\f\5\ft\n\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3"+
		"\f\3\f\3\f\5\f\u0086\n\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3\f\3"+
		"\f\3\f\3\f\3\f\3\f\3\f\5\f\u0099\n\f\3\f\3\f\3\f\3\f\3\f\3\f\5\f\u00a1"+
		"\n\f\3\f\3\f\3\f\3\f\3\f\3\f\5\f\u00a9\n\f\3\r\5\r\u00ac\n\r\3\r\3\r\3"+
		"\r\5\r\u00b1\n\r\3\16\3\16\3\16\3\16\5\16\u00b7\n\16\3\16\3\16\3\16\3"+
		"\16\3\16\5\16\u00be\n\16\3\17\3\17\3\17\3\17\5\17\u00c4\n\17\3\17\3\17"+
		"\3\17\3\17\3\17\5\17\u00cb\n\17\3\17\7\17\u00ce\n\17\f\17\16\17\u00d1"+
		"\13\17\3\20\3\20\3\20\3\20\3\20\3\20\3\20\3\20\3\20\3\20\3\20\5\20\u00de"+
		"\n\20\3\20\3\20\3\20\3\20\3\20\7\20\u00e5\n\20\f\20\16\20\u00e8\13\20"+
		"\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\5\21\u00f2\n\21\3\21\3\21\3\21"+
		"\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\7\21\u0102\n\21"+
		"\f\21\16\21\u0105\13\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\5\21\u010e"+
		"\n\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21"+
		"\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21"+
		"\3\21\3\21\3\21\3\21\3\21\3\21\3\21\7\21\u0132\n\21\f\21\16\21\u0135\13"+
		"\21\3\22\3\22\3\22\7\22\u013a\n\22\f\22\16\22\u013d\13\22\3\23\7\23\u0140"+
		"\n\23\f\23\16\23\u0143\13\23\3\24\3\24\5\24\u0147\n\24\3\25\3\25\3\25"+
		"\3\25\5\25\u014d\n\25\3\26\3\26\5\26\u0151\n\26\3\27\3\27\3\27\3\27\3"+
		"\27\3\27\3\27\3\27\3\27\3\27\3\27\3\27\3\27\3\27\3\27\3\27\3\27\3\27\3"+
		"\27\3\27\3\27\3\27\3\27\5\27\u016a\n\27\3\30\3\30\3\30\3\30\3\30\3\30"+
		"\3\30\3\30\3\30\3\30\5\30\u0176\n\30\3\30\3\30\3\30\3\30\3\30\3\30\7\30"+
		"\u017e\n\30\f\30\16\30\u0181\13\30\3\30\2\6\34\36 .\31\2\4\6\b\n\f\16"+
		"\20\22\24\26\30\32\34\36 \"$&(*,.\2\13\3\2\31\32\3\2\33\34\5\2\26\26\31"+
		"\32\35!\3\2\"#\4\2\26\26$%\3\2\35\36\4\2\31\32&,\4\2\31\32\35\36\4\2\26"+
		"\26$$\2\u01b5\2\60\3\2\2\2\4\64\3\2\2\2\6:\3\2\2\2\b=\3\2\2\2\nA\3\2\2"+
		"\2\fS\3\2\2\2\16U\3\2\2\2\20]\3\2\2\2\22a\3\2\2\2\24l\3\2\2\2\26\u00a8"+
		"\3\2\2\2\30\u00ab\3\2\2\2\32\u00bd\3\2\2\2\34\u00c3\3\2\2\2\36\u00dd\3"+
		"\2\2\2 \u010d\3\2\2\2\"\u0136\3\2\2\2$\u0141\3\2\2\2&\u0146\3\2\2\2(\u014c"+
		"\3\2\2\2*\u014e\3\2\2\2,\u0169\3\2\2\2.\u0175\3\2\2\2\60\61\5\6\4\2\61"+
		"\62\5\n\6\2\62\63\7\2\2\3\63\3\3\2\2\2\64\65\5$\23\2\65\66\7\2\2\3\66"+
		"\5\3\2\2\2\679\5\b\5\28\67\3\2\2\29<\3\2\2\2:8\3\2\2\2:;\3\2\2\2;\7\3"+
		"\2\2\2<:\3\2\2\2=>\7\3\2\2>?\7\64\2\2?\t\3\2\2\2@B\5\f\7\2A@\3\2\2\2B"+
		"C\3\2\2\2CA\3\2\2\2CD\3\2\2\2D\13\3\2\2\2EF\5\34\17\2FG\7@\2\2GI\7\4\2"+
		"\2HJ\5\16\b\2IH\3\2\2\2IJ\3\2\2\2JK\3\2\2\2KL\7\5\2\2LN\7\6\2\2MO\5\24"+
		"\13\2NM\3\2\2\2NO\3\2\2\2OP\3\2\2\2PQ\7\7\2\2QT\3\2\2\2RT\5\22\n\2SE\3"+
		"\2\2\2SR\3\2\2\2T\r\3\2\2\2UZ\5\20\t\2VW\7\b\2\2WY\5\20\t\2XV\3\2\2\2"+
		"Y\\\3\2\2\2ZX\3\2\2\2Z[\3\2\2\2[\17\3\2\2\2\\Z\3\2\2\2]^\5\34\17\2^_\7"+
		"@\2\2_\21\3\2\2\2`b\7\t\2\2a`\3\2\2\2ab\3\2\2\2bc\3\2\2\2cd\5\34\17\2"+
		"dg\7@\2\2ef\7\n\2\2fh\5 \21\2ge\3\2\2\2gh\3\2\2\2hi\3\2\2\2ij\7\13\2\2"+
		"j\23\3\2\2\2km\5\26\f\2lk\3\2\2\2mn\3\2\2\2nl\3\2\2\2no\3\2\2\2o\25\3"+
		"\2\2\2p\u00a9\5\22\n\2qs\7\6\2\2rt\5\24\13\2sr\3\2\2\2st\3\2\2\2tu\3\2"+
		"\2\2u\u00a9\7\7\2\2vw\5\36\20\2wx\7\n\2\2xy\5 \21\2yz\7\13\2\2z\u00a9"+
		"\3\2\2\2{|\5 \21\2|}\7\13\2\2}\u00a9\3\2\2\2~\177\7\f\2\2\177\u0080\7"+
		"\4\2\2\u0080\u0081\5 \21\2\u0081\u0082\7\5\2\2\u0082\u0085\5\26\f\2\u0083"+
		"\u0084\7\r\2\2\u0084\u0086\5\26\f\2\u0085\u0083\3\2\2\2\u0085\u0086\3"+
		"\2\2\2\u0086\u00a9\3\2\2\2\u0087\u0088\7\16\2\2\u0088\u0089\7\4\2\2\u0089"+
		"\u008a\5 \21\2\u008a\u008b\7\5\2\2\u008b\u008c\5\26\f\2\u008c\u00a9\3"+
		"\2\2\2\u008d\u008e\7\17\2\2\u008e\u008f\5\26\f\2\u008f\u0090\7\16\2\2"+
		"\u0090\u0091\7\4\2\2\u0091\u0092\5 \21\2\u0092\u0093\7\5\2\2\u0093\u0094"+
		"\7\13\2\2\u0094\u00a9\3\2\2\2\u0095\u0096\7\20\2\2\u0096\u0098\7\4\2\2"+
		"\u0097\u0099\5\30\r\2\u0098\u0097\3\2\2\2\u0098\u0099\3\2\2\2\u0099\u009a"+
		"\3\2\2\2\u009a\u009b\5\32\16\2\u009b\u009c\7\5\2\2\u009c\u009d\5\26\f"+
		"\2\u009d\u00a9\3\2\2\2\u009e\u00a0\7\21\2\2\u009f\u00a1\5 \21\2\u00a0"+
		"\u009f\3\2\2\2\u00a0\u00a1\3\2\2\2\u00a1\u00a2\3\2\2\2\u00a2\u00a9\7\13"+
		"\2\2\u00a3\u00a4\7\22\2\2\u00a4\u00a5\7\6\2\2\u00a5\u00a6\5$\23\2\u00a6"+
		"\u00a7\7\7\2\2\u00a7\u00a9\3\2\2\2\u00a8p\3\2\2\2\u00a8q\3\2\2\2\u00a8"+
		"v\3\2\2\2\u00a8{\3\2\2\2\u00a8~\3\2\2\2\u00a8\u0087\3\2\2\2\u00a8\u008d"+
		"\3\2\2\2\u00a8\u0095\3\2\2\2\u00a8\u009e\3\2\2\2\u00a8\u00a3\3\2\2\2\u00a9"+
		"\27\3\2\2\2\u00aa\u00ac\5\34\17\2\u00ab\u00aa\3\2\2\2\u00ab\u00ac\3\2"+
		"\2\2\u00ac\u00ad\3\2\2\2\u00ad\u00b0\7@\2\2\u00ae\u00af\7\n\2\2\u00af"+
		"\u00b1\5 \21\2\u00b0\u00ae\3\2\2\2\u00b0\u00b1\3\2\2\2\u00b1\31\3\2\2"+
		"\2\u00b2\u00b3\7\13\2\2\u00b3\u00b4\5 \21\2\u00b4\u00b6\7\13\2\2\u00b5"+
		"\u00b7\5 \21\2\u00b6\u00b5\3\2\2\2\u00b6\u00b7\3\2\2\2\u00b7\u00be\3\2"+
		"\2\2\u00b8\u00b9\7\23\2\2\u00b9\u00ba\5 \21\2\u00ba\u00bb\7\24\2\2\u00bb"+
		"\u00bc\5 \21\2\u00bc\u00be\3\2\2\2\u00bd\u00b2\3\2\2\2\u00bd\u00b8\3\2"+
		"\2\2\u00be\33\3\2\2\2\u00bf\u00c0\b\17\1\2\u00c0\u00c4\7\63\2\2\u00c1"+
		"\u00c2\7\25\2\2\u00c2\u00c4\7\63\2\2\u00c3\u00bf\3\2\2\2\u00c3\u00c1\3"+
		"\2\2\2\u00c4\u00cf\3\2\2\2\u00c5\u00c6\f\4\2\2\u00c6\u00ce\7\26\2\2\u00c7"+
		"\u00c8\f\3\2\2\u00c8\u00ca\7\27\2\2\u00c9\u00cb\5 \21\2\u00ca\u00c9\3"+
		"\2\2\2\u00ca\u00cb\3\2\2\2\u00cb\u00cc\3\2\2\2\u00cc\u00ce\7\30\2\2\u00cd"+
		"\u00c5\3\2\2\2\u00cd\u00c7\3\2\2\2\u00ce\u00d1\3\2\2\2\u00cf\u00cd\3\2"+
		"\2\2\u00cf\u00d0\3\2\2\2\u00d0\35\3\2\2\2\u00d1\u00cf\3\2\2\2\u00d2\u00d3"+
		"\b\20\1\2\u00d3\u00de\7@\2\2\u00d4\u00d5\7\26\2\2\u00d5\u00de\7@\2\2\u00d6"+
		"\u00d7\7\26\2\2\u00d7\u00d8\7\4\2\2\u00d8\u00d9\5 \21\2\u00d9\u00da\7"+
		"\5\2\2\u00da\u00de\3\2\2\2\u00db\u00dc\t\2\2\2\u00dc\u00de\5\36\20\4\u00dd"+
		"\u00d2\3\2\2\2\u00dd\u00d4\3\2\2\2\u00dd\u00d6\3\2\2\2\u00dd\u00db\3\2"+
		"\2\2\u00de\u00e6\3\2\2\2\u00df\u00e0\f\3\2\2\u00e0\u00e1\7\27\2\2\u00e1"+
		"\u00e2\5 \21\2\u00e2\u00e3\7\30\2\2\u00e3\u00e5\3\2\2\2\u00e4\u00df\3"+
		"\2\2\2\u00e5\u00e8\3\2\2\2\u00e6\u00e4\3\2\2\2\u00e6\u00e7\3\2\2\2\u00e7"+
		"\37\3\2\2\2\u00e8\u00e6\3\2\2\2\u00e9\u00ea\b\21\1\2\u00ea\u00eb\7\4\2"+
		"\2\u00eb\u00ec\5 \21\2\u00ec\u00ed\7\5\2\2\u00ed\u010e\3\2\2\2\u00ee\u00ef"+
		"\7@\2\2\u00ef\u00f1\7\4\2\2\u00f0\u00f2\5\"\22\2\u00f1\u00f0\3\2\2\2\u00f1"+
		"\u00f2\3\2\2\2\u00f2\u00f3\3\2\2\2\u00f3\u010e\7\5\2\2\u00f4\u00f5\7\4"+
		"\2\2\u00f5\u00f6\5\34\17\2\u00f6\u00f7\7\5\2\2\u00f7\u00f8\5 \21\26\u00f8"+
		"\u010e\3\2\2\2\u00f9\u00fa\t\3\2\2\u00fa\u010e\5 \21\24\u00fb\u00fc\t"+
		"\4\2\2\u00fc\u010e\5 \21\22\u00fd\u00fe\7\6\2\2\u00fe\u0103\5 \21\2\u00ff"+
		"\u0100\7\b\2\2\u0100\u0102\5 \21\2\u0101\u00ff\3\2\2\2\u0102\u0105\3\2"+
		"\2\2\u0103\u0101\3\2\2\2\u0103\u0104\3\2\2\2\u0104\u0106\3\2\2\2\u0105"+
		"\u0103\3\2\2\2\u0106\u0107\7\7\2\2\u0107\u010e\3\2\2\2\u0108\u010e\7@"+
		"\2\2\u0109\u010e\7\67\2\2\u010a\u010e\7\64\2\2\u010b\u010e\7\65\2\2\u010c"+
		"\u010e\7\66\2\2\u010d\u00e9\3\2\2\2\u010d\u00ee\3\2\2\2\u010d\u00f4\3"+
		"\2\2\2\u010d\u00f9\3\2\2\2\u010d\u00fb\3\2\2\2\u010d\u00fd\3\2\2\2\u010d"+
		"\u0108\3\2\2\2\u010d\u0109\3\2\2\2\u010d\u010a\3\2\2\2\u010d\u010b\3\2"+
		"\2\2\u010d\u010c\3\2\2\2\u010e\u0133\3\2\2\2\u010f\u0110\f\21\2\2\u0110"+
		"\u0111\t\5\2\2\u0111\u0132\5 \21\22\u0112\u0113\f\20\2\2\u0113\u0114\t"+
		"\6\2\2\u0114\u0132\5 \21\21\u0115\u0116\f\17\2\2\u0116\u0117\t\7\2\2\u0117"+
		"\u0132\5 \21\20\u0118\u0119\f\16\2\2\u0119\u011a\t\b\2\2\u011a\u0132\5"+
		" \21\17\u011b\u011c\f\r\2\2\u011c\u011d\7 \2\2\u011d\u0132\5 \21\16\u011e"+
		"\u011f\f\f\2\2\u011f\u0120\7-\2\2\u0120\u0132\5 \21\r\u0121\u0122\f\13"+
		"\2\2\u0122\u0123\7.\2\2\u0123\u0132\5 \21\f\u0124\u0125\f\n\2\2\u0125"+
		"\u0126\7/\2\2\u0126\u0132\5 \21\13\u0127\u0128\f\t\2\2\u0128\u0129\7\60"+
		"\2\2\u0129\u0132\5 \21\n\u012a\u012b\f\25\2\2\u012b\u012c\7\27\2\2\u012c"+
		"\u012d\5 \21\2\u012d\u012e\7\30\2\2\u012e\u0132\3\2\2\2\u012f\u0130\f"+
		"\23\2\2\u0130\u0132\t\3\2\2\u0131\u010f\3\2\2\2\u0131\u0112\3\2\2\2\u0131"+
		"\u0115\3\2\2\2\u0131\u0118\3\2\2\2\u0131\u011b\3\2\2\2\u0131\u011e\3\2"+
		"\2\2\u0131\u0121\3\2\2\2\u0131\u0124\3\2\2\2\u0131\u0127\3\2\2\2\u0131"+
		"\u012a\3\2\2\2\u0131\u012f\3\2\2\2\u0132\u0135\3\2\2\2\u0133\u0131\3\2"+
		"\2\2\u0133\u0134\3\2\2\2\u0134!\3\2\2\2\u0135\u0133\3\2\2\2\u0136\u013b"+
		"\5 \21\2\u0137\u0138\7\b\2\2\u0138\u013a\5 \21\2\u0139\u0137\3\2\2\2\u013a"+
		"\u013d\3\2\2\2\u013b\u0139\3\2\2\2\u013b\u013c\3\2\2\2\u013c#\3\2\2\2"+
		"\u013d\u013b\3\2\2\2\u013e\u0140\5&\24\2\u013f\u013e\3\2\2\2\u0140\u0143"+
		"\3\2\2\2\u0141\u013f\3\2\2\2\u0141\u0142\3\2\2\2\u0142%\3\2\2\2\u0143"+
		"\u0141\3\2\2\2\u0144\u0147\5(\25\2\u0145\u0147\5*\26\2\u0146\u0144\3\2"+
		"\2\2\u0146\u0145\3\2\2\2\u0147\'\3\2\2\2\u0148\u0149\7@\2\2\u0149\u014d"+
		"\7\23\2\2\u014a\u014b\7\37\2\2\u014b\u014d\7\23\2\2\u014c\u0148\3\2\2"+
		"\2\u014c\u014a\3\2\2\2\u014d)\3\2\2\2\u014e\u0150\7\62\2\2\u014f\u0151"+
		"\5,\27\2\u0150\u014f\3\2\2\2\u0150\u0151\3\2\2\2\u0151+\3\2\2\2\u0152"+
		"\u016a\5.\30\2\u0153\u0154\7\61\2\2\u0154\u016a\5.\30\2\u0155\u0156\5"+
		".\30\2\u0156\u0157\7\b\2\2\u0157\u0158\7@\2\2\u0158\u016a\3\2\2\2\u0159"+
		"\u015a\7\4\2\2\u015a\u015b\5.\30\2\u015b\u015c\7\5\2\2\u015c\u015d\7\b"+
		"\2\2\u015d\u015e\7@\2\2\u015e\u016a\3\2\2\2\u015f\u0160\7\4\2\2\u0160"+
		"\u0161\5.\30\2\u0161\u0162\7\b\2\2\u0162\u0163\7@\2\2\u0163\u0164\7\5"+
		"\2\2\u0164\u016a\3\2\2\2\u0165\u0166\7\4\2\2\u0166\u0167\5.\30\2\u0167"+
		"\u0168\7\5\2\2\u0168\u016a\3\2\2\2\u0169\u0152\3\2\2\2\u0169\u0153\3\2"+
		"\2\2\u0169\u0155\3\2\2\2\u0169\u0159\3\2\2\2\u0169\u015f\3\2\2\2\u0169"+
		"\u0165\3\2\2\2\u016a-\3\2\2\2\u016b\u016c\b\30\1\2\u016c\u016d\t\t\2\2"+
		"\u016d\u0176\5.\30\n\u016e\u0176\7@\2\2\u016f\u0176\7A\2\2\u0170\u0171"+
		"\7\6\2\2\u0171\u0172\7@\2\2\u0172\u0176\7\7\2\2\u0173\u0176\7\67\2\2\u0174"+
		"\u0176\7\65\2\2\u0175\u016b\3\2\2\2\u0175\u016e\3\2\2\2\u0175\u016f\3"+
		"\2\2\2\u0175\u0170\3\2\2\2\u0175\u0173\3\2\2\2\u0175\u0174\3\2\2\2\u0176"+
		"\u017f\3\2\2\2\u0177\u0178\f\t\2\2\u0178\u0179\t\n\2\2\u0179\u017e\5."+
		"\30\n\u017a\u017b\f\b\2\2\u017b\u017c\t\7\2\2\u017c\u017e\5.\30\t\u017d"+
		"\u0177\3\2\2\2\u017d\u017a\3\2\2\2\u017e\u0181\3\2\2\2\u017f\u017d\3\2"+
		"\2\2\u017f\u0180\3\2\2\2\u0180/\3\2\2\2\u0181\u017f\3\2\2\2(:CINSZagn"+
		"s\u0085\u0098\u00a0\u00a8\u00ab\u00b0\u00b6\u00bd\u00c3\u00ca\u00cd\u00cf"+
		"\u00dd\u00e6\u00f1\u0103\u010d\u0131\u0133\u013b\u0141\u0146\u014c\u0150"+
		"\u0169\u0175\u017d\u017f";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}
// Generated from /Users/jespergravgaard/c64/src/kickc/src/dk/camelot64/kickc/asm/parser/Asm6502.g4 by ANTLR 4.7
package dk.camelot64.kickc.asm.parser;
import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.misc.*;
import org.antlr.v4.runtime.tree.*;
import java.util.List;
import java.util.Iterator;
import java.util.ArrayList;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast"})
public class Asm6502Parser extends Parser {
	static { RuntimeMetaData.checkVersion("4.7", RuntimeMetaData.VERSION); }

	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		T__0=1, T__1=2, T__2=3, T__3=4, T__4=5, T__5=6, T__6=7, T__7=8, T__8=9, 
		T__9=10, MNEMONIC=11, NUMINT=12, BININTEGER=13, DECINTEGER=14, HEXINTEGER=15, 
		NAME=16, WS=17;
	public static final int
		RULE_file = 0, RULE_line = 1, RULE_label = 2, RULE_comment = 3, RULE_instruction = 4, 
		RULE_paramMode = 5, RULE_param = 6;
	public static final String[] ruleNames = {
		"file", "line", "label", "comment", "instruction", "paramMode", "param"
	};

	private static final String[] _LITERAL_NAMES = {
		null, "'\n'", "':'", "'//'", "'#'", "',x'", "',y'", "'('", "')'", "'{'", 
		"'}'"
	};
	private static final String[] _SYMBOLIC_NAMES = {
		null, null, null, null, null, null, null, null, null, null, null, "MNEMONIC", 
		"NUMINT", "BININTEGER", "DECINTEGER", "HEXINTEGER", "NAME", "WS"
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
	public String getGrammarFileName() { return "Asm6502.g4"; }

	@Override
	public String[] getRuleNames() { return ruleNames; }

	@Override
	public String getSerializedATN() { return _serializedATN; }

	@Override
	public ATN getATN() { return _ATN; }

	public Asm6502Parser(TokenStream input) {
		super(input);
		_interp = new ParserATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}
	public static class FileContext extends ParserRuleContext {
		public List<LineContext> line() {
			return getRuleContexts(LineContext.class);
		}
		public LineContext line(int i) {
			return getRuleContext(LineContext.class,i);
		}
		public TerminalNode EOF() { return getToken(Asm6502Parser.EOF, 0); }
		public FileContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_file; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof Asm6502Listener ) ((Asm6502Listener)listener).enterFile(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof Asm6502Listener ) ((Asm6502Listener)listener).exitFile(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof Asm6502Visitor ) return ((Asm6502Visitor<? extends T>)visitor).visitFile(this);
			else return visitor.visitChildren(this);
		}
	}

	public final FileContext file() throws RecognitionException {
		FileContext _localctx = new FileContext(_ctx, getState());
		enterRule(_localctx, 0, RULE_file);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(14);
			line();
			setState(19);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==T__0) {
				{
				{
				setState(15);
				match(T__0);
				setState(16);
				line();
				}
				}
				setState(21);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(22);
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

	public static class LineContext extends ParserRuleContext {
		public LabelContext label() {
			return getRuleContext(LabelContext.class,0);
		}
		public InstructionContext instruction() {
			return getRuleContext(InstructionContext.class,0);
		}
		public CommentContext comment() {
			return getRuleContext(CommentContext.class,0);
		}
		public LineContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_line; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof Asm6502Listener ) ((Asm6502Listener)listener).enterLine(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof Asm6502Listener ) ((Asm6502Listener)listener).exitLine(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof Asm6502Visitor ) return ((Asm6502Visitor<? extends T>)visitor).visitLine(this);
			else return visitor.visitChildren(this);
		}
	}

	public final LineContext line() throws RecognitionException {
		LineContext _localctx = new LineContext(_ctx, getState());
		enterRule(_localctx, 2, RULE_line);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(25);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==NAME) {
				{
				setState(24);
				label();
				}
			}

			setState(28);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==MNEMONIC) {
				{
				setState(27);
				instruction();
				}
			}

			setState(31);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__2) {
				{
				setState(30);
				comment();
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

	public static class LabelContext extends ParserRuleContext {
		public TerminalNode NAME() { return getToken(Asm6502Parser.NAME, 0); }
		public LabelContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_label; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof Asm6502Listener ) ((Asm6502Listener)listener).enterLabel(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof Asm6502Listener ) ((Asm6502Listener)listener).exitLabel(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof Asm6502Visitor ) return ((Asm6502Visitor<? extends T>)visitor).visitLabel(this);
			else return visitor.visitChildren(this);
		}
	}

	public final LabelContext label() throws RecognitionException {
		LabelContext _localctx = new LabelContext(_ctx, getState());
		enterRule(_localctx, 4, RULE_label);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(33);
			match(NAME);
			setState(34);
			match(T__1);
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

	public static class CommentContext extends ParserRuleContext {
		public CommentContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_comment; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof Asm6502Listener ) ((Asm6502Listener)listener).enterComment(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof Asm6502Listener ) ((Asm6502Listener)listener).exitComment(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof Asm6502Visitor ) return ((Asm6502Visitor<? extends T>)visitor).visitComment(this);
			else return visitor.visitChildren(this);
		}
	}

	public final CommentContext comment() throws RecognitionException {
		CommentContext _localctx = new CommentContext(_ctx, getState());
		enterRule(_localctx, 6, RULE_comment);
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(36);
			match(T__2);
			setState(40);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,4,_ctx);
			while ( _alt!=1 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1+1 ) {
					{
					{
					setState(37);
					matchWildcard();
					}
					} 
				}
				setState(42);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,4,_ctx);
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

	public static class InstructionContext extends ParserRuleContext {
		public TerminalNode MNEMONIC() { return getToken(Asm6502Parser.MNEMONIC, 0); }
		public ParamModeContext paramMode() {
			return getRuleContext(ParamModeContext.class,0);
		}
		public InstructionContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_instruction; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof Asm6502Listener ) ((Asm6502Listener)listener).enterInstruction(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof Asm6502Listener ) ((Asm6502Listener)listener).exitInstruction(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof Asm6502Visitor ) return ((Asm6502Visitor<? extends T>)visitor).visitInstruction(this);
			else return visitor.visitChildren(this);
		}
	}

	public final InstructionContext instruction() throws RecognitionException {
		InstructionContext _localctx = new InstructionContext(_ctx, getState());
		enterRule(_localctx, 8, RULE_instruction);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(43);
			match(MNEMONIC);
			setState(45);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__3) | (1L << T__6) | (1L << T__8) | (1L << NUMINT) | (1L << NAME))) != 0)) {
				{
				setState(44);
				paramMode();
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

	public static class ParamModeContext extends ParserRuleContext {
		public ParamModeContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_paramMode; }
	 
		public ParamModeContext() { }
		public void copyFrom(ParamModeContext ctx) {
			super.copyFrom(ctx);
		}
	}
	public static class ModeIndXContext extends ParamModeContext {
		public ParamContext param() {
			return getRuleContext(ParamContext.class,0);
		}
		public ModeIndXContext(ParamModeContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof Asm6502Listener ) ((Asm6502Listener)listener).enterModeIndX(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof Asm6502Listener ) ((Asm6502Listener)listener).exitModeIndX(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof Asm6502Visitor ) return ((Asm6502Visitor<? extends T>)visitor).visitModeIndX(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class ModeImmContext extends ParamModeContext {
		public ParamContext param() {
			return getRuleContext(ParamContext.class,0);
		}
		public ModeImmContext(ParamModeContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof Asm6502Listener ) ((Asm6502Listener)listener).enterModeImm(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof Asm6502Listener ) ((Asm6502Listener)listener).exitModeImm(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof Asm6502Visitor ) return ((Asm6502Visitor<? extends T>)visitor).visitModeImm(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class ModeIndYContext extends ParamModeContext {
		public ParamContext param() {
			return getRuleContext(ParamContext.class,0);
		}
		public ModeIndYContext(ParamModeContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof Asm6502Listener ) ((Asm6502Listener)listener).enterModeIndY(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof Asm6502Listener ) ((Asm6502Listener)listener).exitModeIndY(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof Asm6502Visitor ) return ((Asm6502Visitor<? extends T>)visitor).visitModeIndY(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class ModeAbsYContext extends ParamModeContext {
		public ParamContext param() {
			return getRuleContext(ParamContext.class,0);
		}
		public ModeAbsYContext(ParamModeContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof Asm6502Listener ) ((Asm6502Listener)listener).enterModeAbsY(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof Asm6502Listener ) ((Asm6502Listener)listener).exitModeAbsY(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof Asm6502Visitor ) return ((Asm6502Visitor<? extends T>)visitor).visitModeAbsY(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class ModeIndContext extends ParamModeContext {
		public ParamContext param() {
			return getRuleContext(ParamContext.class,0);
		}
		public ModeIndContext(ParamModeContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof Asm6502Listener ) ((Asm6502Listener)listener).enterModeInd(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof Asm6502Listener ) ((Asm6502Listener)listener).exitModeInd(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof Asm6502Visitor ) return ((Asm6502Visitor<? extends T>)visitor).visitModeInd(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class ModeAbsContext extends ParamModeContext {
		public ParamContext param() {
			return getRuleContext(ParamContext.class,0);
		}
		public ModeAbsContext(ParamModeContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof Asm6502Listener ) ((Asm6502Listener)listener).enterModeAbs(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof Asm6502Listener ) ((Asm6502Listener)listener).exitModeAbs(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof Asm6502Visitor ) return ((Asm6502Visitor<? extends T>)visitor).visitModeAbs(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class ModeAbsXContext extends ParamModeContext {
		public ParamContext param() {
			return getRuleContext(ParamContext.class,0);
		}
		public ModeAbsXContext(ParamModeContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof Asm6502Listener ) ((Asm6502Listener)listener).enterModeAbsX(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof Asm6502Listener ) ((Asm6502Listener)listener).exitModeAbsX(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof Asm6502Visitor ) return ((Asm6502Visitor<? extends T>)visitor).visitModeAbsX(this);
			else return visitor.visitChildren(this);
		}
	}

	public final ParamModeContext paramMode() throws RecognitionException {
		ParamModeContext _localctx = new ParamModeContext(_ctx, getState());
		enterRule(_localctx, 10, RULE_paramMode);
		try {
			setState(70);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,6,_ctx) ) {
			case 1:
				_localctx = new ModeAbsContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(47);
				param();
				}
				break;
			case 2:
				_localctx = new ModeImmContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(48);
				match(T__3);
				setState(49);
				param();
				}
				break;
			case 3:
				_localctx = new ModeAbsXContext(_localctx);
				enterOuterAlt(_localctx, 3);
				{
				setState(50);
				param();
				setState(51);
				match(T__4);
				}
				break;
			case 4:
				_localctx = new ModeAbsYContext(_localctx);
				enterOuterAlt(_localctx, 4);
				{
				setState(53);
				param();
				setState(54);
				match(T__5);
				}
				break;
			case 5:
				_localctx = new ModeIndYContext(_localctx);
				enterOuterAlt(_localctx, 5);
				{
				setState(56);
				match(T__6);
				setState(57);
				param();
				setState(58);
				match(T__7);
				setState(59);
				match(T__5);
				}
				break;
			case 6:
				_localctx = new ModeIndXContext(_localctx);
				enterOuterAlt(_localctx, 6);
				{
				setState(61);
				match(T__6);
				setState(62);
				param();
				setState(63);
				match(T__4);
				setState(64);
				match(T__7);
				}
				break;
			case 7:
				_localctx = new ModeIndContext(_localctx);
				enterOuterAlt(_localctx, 7);
				{
				setState(66);
				match(T__6);
				setState(67);
				param();
				setState(68);
				match(T__7);
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

	public static class ParamContext extends ParserRuleContext {
		public ParamContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_param; }
	 
		public ParamContext() { }
		public void copyFrom(ParamContext ctx) {
			super.copyFrom(ctx);
		}
	}
	public static class ParamReplaceContext extends ParamContext {
		public TerminalNode NAME() { return getToken(Asm6502Parser.NAME, 0); }
		public ParamReplaceContext(ParamContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof Asm6502Listener ) ((Asm6502Listener)listener).enterParamReplace(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof Asm6502Listener ) ((Asm6502Listener)listener).exitParamReplace(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof Asm6502Visitor ) return ((Asm6502Visitor<? extends T>)visitor).visitParamReplace(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class ParamIntContext extends ParamContext {
		public TerminalNode NUMINT() { return getToken(Asm6502Parser.NUMINT, 0); }
		public ParamIntContext(ParamContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof Asm6502Listener ) ((Asm6502Listener)listener).enterParamInt(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof Asm6502Listener ) ((Asm6502Listener)listener).exitParamInt(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof Asm6502Visitor ) return ((Asm6502Visitor<? extends T>)visitor).visitParamInt(this);
			else return visitor.visitChildren(this);
		}
	}
	public static class ParamLabelContext extends ParamContext {
		public TerminalNode NAME() { return getToken(Asm6502Parser.NAME, 0); }
		public ParamLabelContext(ParamContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof Asm6502Listener ) ((Asm6502Listener)listener).enterParamLabel(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof Asm6502Listener ) ((Asm6502Listener)listener).exitParamLabel(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof Asm6502Visitor ) return ((Asm6502Visitor<? extends T>)visitor).visitParamLabel(this);
			else return visitor.visitChildren(this);
		}
	}

	public final ParamContext param() throws RecognitionException {
		ParamContext _localctx = new ParamContext(_ctx, getState());
		enterRule(_localctx, 12, RULE_param);
		try {
			setState(77);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case NAME:
				_localctx = new ParamLabelContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(72);
				match(NAME);
				}
				break;
			case T__8:
				_localctx = new ParamReplaceContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(73);
				match(T__8);
				setState(74);
				match(NAME);
				setState(75);
				match(T__9);
				}
				break;
			case NUMINT:
				_localctx = new ParamIntContext(_localctx);
				enterOuterAlt(_localctx, 3);
				{
				setState(76);
				match(NUMINT);
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

	public static final String _serializedATN =
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\3\23R\4\2\t\2\4\3\t"+
		"\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\3\2\3\2\3\2\7\2\24\n\2\f\2"+
		"\16\2\27\13\2\3\2\3\2\3\3\5\3\34\n\3\3\3\5\3\37\n\3\3\3\5\3\"\n\3\3\4"+
		"\3\4\3\4\3\5\3\5\7\5)\n\5\f\5\16\5,\13\5\3\6\3\6\5\6\60\n\6\3\7\3\7\3"+
		"\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7\3\7"+
		"\3\7\3\7\3\7\5\7I\n\7\3\b\3\b\3\b\3\b\3\b\5\bP\n\b\3\b\3*\2\t\2\4\6\b"+
		"\n\f\16\2\2\2X\2\20\3\2\2\2\4\33\3\2\2\2\6#\3\2\2\2\b&\3\2\2\2\n-\3\2"+
		"\2\2\fH\3\2\2\2\16O\3\2\2\2\20\25\5\4\3\2\21\22\7\3\2\2\22\24\5\4\3\2"+
		"\23\21\3\2\2\2\24\27\3\2\2\2\25\23\3\2\2\2\25\26\3\2\2\2\26\30\3\2\2\2"+
		"\27\25\3\2\2\2\30\31\7\2\2\3\31\3\3\2\2\2\32\34\5\6\4\2\33\32\3\2\2\2"+
		"\33\34\3\2\2\2\34\36\3\2\2\2\35\37\5\n\6\2\36\35\3\2\2\2\36\37\3\2\2\2"+
		"\37!\3\2\2\2 \"\5\b\5\2! \3\2\2\2!\"\3\2\2\2\"\5\3\2\2\2#$\7\22\2\2$%"+
		"\7\4\2\2%\7\3\2\2\2&*\7\5\2\2\')\13\2\2\2(\'\3\2\2\2),\3\2\2\2*+\3\2\2"+
		"\2*(\3\2\2\2+\t\3\2\2\2,*\3\2\2\2-/\7\r\2\2.\60\5\f\7\2/.\3\2\2\2/\60"+
		"\3\2\2\2\60\13\3\2\2\2\61I\5\16\b\2\62\63\7\6\2\2\63I\5\16\b\2\64\65\5"+
		"\16\b\2\65\66\7\7\2\2\66I\3\2\2\2\678\5\16\b\289\7\b\2\29I\3\2\2\2:;\7"+
		"\t\2\2;<\5\16\b\2<=\7\n\2\2=>\7\b\2\2>I\3\2\2\2?@\7\t\2\2@A\5\16\b\2A"+
		"B\7\7\2\2BC\7\n\2\2CI\3\2\2\2DE\7\t\2\2EF\5\16\b\2FG\7\n\2\2GI\3\2\2\2"+
		"H\61\3\2\2\2H\62\3\2\2\2H\64\3\2\2\2H\67\3\2\2\2H:\3\2\2\2H?\3\2\2\2H"+
		"D\3\2\2\2I\r\3\2\2\2JP\7\22\2\2KL\7\13\2\2LM\7\22\2\2MP\7\f\2\2NP\7\16"+
		"\2\2OJ\3\2\2\2OK\3\2\2\2ON\3\2\2\2P\17\3\2\2\2\n\25\33\36!*/HO";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}
// Generated from /Users/jespergravgaard/c64/kickc/src/test/java/dk/camelot64/kickc/parsing/macros/Macros.g4 by ANTLR 4.7.2
package dk.camelot64.kickc.parsing.macros;


import org.antlr.v4.runtime.Lexer;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.TokenStream;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.misc.*;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast"})
public class MacrosLexer extends Lexer {
	static { RuntimeMetaData.checkVersion("4.7.2", RuntimeMetaData.VERSION); }

	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		T__0=1, T__1=2, T__2=3, T__3=4, T__4=5, PAR_BEGIN=6, PAR_END=7, COMMA=8, 
		SIMPLETYPE=9, IDENTIFIER=10, NUMBER=11, DEFINE=12, UNDEF=13, IFDEF=14, 
		IFNDEF=15, IFELSE=16, ENDIF=17, DEFINE_CONTINUE=18, WHITESPACE=19;
	public static String[] channelNames = {
		"DEFAULT_TOKEN_CHANNEL", "HIDDEN"
	};

	public static String[] modeNames = {
		"DEFAULT_MODE"
	};

	private static String[] makeRuleNames() {
		return new String[] {
			"T__0", "T__1", "T__2", "T__3", "T__4", "PAR_BEGIN", "PAR_END", "COMMA", 
			"SIMPLETYPE", "IDENTIFIER", "NUMBER", "DEFINE", "UNDEF", "IFDEF", "IFNDEF", 
			"IFELSE", "ENDIF", "DEFINE_CONTINUE", "WHITESPACE"
		};
	}
	public static final String[] ruleNames = makeRuleNames();

	private static String[] makeLiteralNames() {
		return new String[] {
			null, "';'", "'*'", "'/'", "'+'", "'-'", "'('", "')'", "','", null, null, 
			null, "'#define'", "'#undef'", "'#ifdef'", "'#ifndef'", "'#else'", "'#endif'", 
			"'\\\n'"
		};
	}
	private static final String[] _LITERAL_NAMES = makeLiteralNames();
	private static String[] makeSymbolicNames() {
		return new String[] {
			null, null, null, null, null, null, "PAR_BEGIN", "PAR_END", "COMMA", 
			"SIMPLETYPE", "IDENTIFIER", "NUMBER", "DEFINE", "UNDEF", "IFDEF", "IFNDEF", 
			"IFELSE", "ENDIF", "DEFINE_CONTINUE", "WHITESPACE"
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




	public MacrosLexer(CharStream input) {
		super(input);
		_interp = new LexerATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}

	@Override
	public String getGrammarFileName() { return "Macros.g4"; }

	@Override
	public String[] getRuleNames() { return ruleNames; }

	@Override
	public String getSerializedATN() { return _serializedATN; }

	@Override
	public String[] getChannelNames() { return channelNames; }

	@Override
	public String[] getModeNames() { return modeNames; }

	@Override
	public ATN getATN() { return _ATN; }

	public static final String _serializedATN =
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\2\25\u0083\b\1\4\2"+
		"\t\2\4\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n\t\n\4"+
		"\13\t\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\4\20\t\20\4\21\t\21\4\22"+
		"\t\22\4\23\t\23\4\24\t\24\3\2\3\2\3\3\3\3\3\4\3\4\3\5\3\5\3\6\3\6\3\7"+
		"\3\7\3\b\3\b\3\t\3\t\3\n\3\n\3\n\3\n\3\n\3\n\3\n\5\nA\n\n\3\13\3\13\7"+
		"\13E\n\13\f\13\16\13H\13\13\3\f\6\fK\n\f\r\f\16\fL\3\r\3\r\3\r\3\r\3\r"+
		"\3\r\3\r\3\r\3\16\3\16\3\16\3\16\3\16\3\16\3\16\3\17\3\17\3\17\3\17\3"+
		"\17\3\17\3\17\3\20\3\20\3\20\3\20\3\20\3\20\3\20\3\20\3\21\3\21\3\21\3"+
		"\21\3\21\3\21\3\22\3\22\3\22\3\22\3\22\3\22\3\22\3\23\3\23\3\23\3\24\6"+
		"\24~\n\24\r\24\16\24\177\3\24\3\24\2\2\25\3\3\5\4\7\5\t\6\13\7\r\b\17"+
		"\t\21\n\23\13\25\f\27\r\31\16\33\17\35\20\37\21!\22#\23%\24\'\25\3\2\6"+
		"\5\2C\\aac|\6\2\62;C\\aac|\3\2\62;\5\2\13\f\17\17\"\"\2\u0086\2\3\3\2"+
		"\2\2\2\5\3\2\2\2\2\7\3\2\2\2\2\t\3\2\2\2\2\13\3\2\2\2\2\r\3\2\2\2\2\17"+
		"\3\2\2\2\2\21\3\2\2\2\2\23\3\2\2\2\2\25\3\2\2\2\2\27\3\2\2\2\2\31\3\2"+
		"\2\2\2\33\3\2\2\2\2\35\3\2\2\2\2\37\3\2\2\2\2!\3\2\2\2\2#\3\2\2\2\2%\3"+
		"\2\2\2\2\'\3\2\2\2\3)\3\2\2\2\5+\3\2\2\2\7-\3\2\2\2\t/\3\2\2\2\13\61\3"+
		"\2\2\2\r\63\3\2\2\2\17\65\3\2\2\2\21\67\3\2\2\2\23@\3\2\2\2\25B\3\2\2"+
		"\2\27J\3\2\2\2\31N\3\2\2\2\33V\3\2\2\2\35]\3\2\2\2\37d\3\2\2\2!l\3\2\2"+
		"\2#r\3\2\2\2%y\3\2\2\2\'}\3\2\2\2)*\7=\2\2*\4\3\2\2\2+,\7,\2\2,\6\3\2"+
		"\2\2-.\7\61\2\2.\b\3\2\2\2/\60\7-\2\2\60\n\3\2\2\2\61\62\7/\2\2\62\f\3"+
		"\2\2\2\63\64\7*\2\2\64\16\3\2\2\2\65\66\7+\2\2\66\20\3\2\2\2\678\7.\2"+
		"\28\22\3\2\2\29:\7e\2\2:;\7j\2\2;<\7c\2\2<A\7t\2\2=>\7k\2\2>?\7p\2\2?"+
		"A\7v\2\2@9\3\2\2\2@=\3\2\2\2A\24\3\2\2\2BF\t\2\2\2CE\t\3\2\2DC\3\2\2\2"+
		"EH\3\2\2\2FD\3\2\2\2FG\3\2\2\2G\26\3\2\2\2HF\3\2\2\2IK\t\4\2\2JI\3\2\2"+
		"\2KL\3\2\2\2LJ\3\2\2\2LM\3\2\2\2M\30\3\2\2\2NO\7%\2\2OP\7f\2\2PQ\7g\2"+
		"\2QR\7h\2\2RS\7k\2\2ST\7p\2\2TU\7g\2\2U\32\3\2\2\2VW\7%\2\2WX\7w\2\2X"+
		"Y\7p\2\2YZ\7f\2\2Z[\7g\2\2[\\\7h\2\2\\\34\3\2\2\2]^\7%\2\2^_\7k\2\2_`"+
		"\7h\2\2`a\7f\2\2ab\7g\2\2bc\7h\2\2c\36\3\2\2\2de\7%\2\2ef\7k\2\2fg\7h"+
		"\2\2gh\7p\2\2hi\7f\2\2ij\7g\2\2jk\7h\2\2k \3\2\2\2lm\7%\2\2mn\7g\2\2n"+
		"o\7n\2\2op\7u\2\2pq\7g\2\2q\"\3\2\2\2rs\7%\2\2st\7g\2\2tu\7p\2\2uv\7f"+
		"\2\2vw\7k\2\2wx\7h\2\2x$\3\2\2\2yz\7^\2\2z{\7\f\2\2{&\3\2\2\2|~\t\5\2"+
		"\2}|\3\2\2\2~\177\3\2\2\2\177}\3\2\2\2\177\u0080\3\2\2\2\u0080\u0081\3"+
		"\2\2\2\u0081\u0082\b\24\2\2\u0082(\3\2\2\2\7\2@FL\177\3\2\3\2";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}
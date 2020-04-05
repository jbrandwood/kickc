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
		SIMPLETYPE=9, IDENTIFIER=10, NUMBER=11, DEFINE=12, UNDEF=13, DEFINE_CONTINUE=14, 
		WHITESPACE=15;
	public static String[] channelNames = {
		"DEFAULT_TOKEN_CHANNEL", "HIDDEN"
	};

	public static String[] modeNames = {
		"DEFAULT_MODE"
	};

	private static String[] makeRuleNames() {
		return new String[] {
			"T__0", "T__1", "T__2", "T__3", "T__4", "PAR_BEGIN", "PAR_END", "COMMA", 
			"SIMPLETYPE", "IDENTIFIER", "NUMBER", "DEFINE", "UNDEF", "DEFINE_CONTINUE", 
			"WHITESPACE"
		};
	}
	public static final String[] ruleNames = makeRuleNames();

	private static String[] makeLiteralNames() {
		return new String[] {
			null, "';'", "'*'", "'/'", "'+'", "'-'", "'('", "')'", "','", null, null, 
			null, "'#define'", "'#undef'", "'\\\n'"
		};
	}
	private static final String[] _LITERAL_NAMES = makeLiteralNames();
	private static String[] makeSymbolicNames() {
		return new String[] {
			null, null, null, null, null, null, "PAR_BEGIN", "PAR_END", "COMMA", 
			"SIMPLETYPE", "IDENTIFIER", "NUMBER", "DEFINE", "UNDEF", "DEFINE_CONTINUE", 
			"WHITESPACE"
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
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\2\21]\b\1\4\2\t\2\4"+
		"\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n\t\n\4\13\t"+
		"\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\4\20\t\20\3\2\3\2\3\3\3\3\3\4"+
		"\3\4\3\5\3\5\3\6\3\6\3\7\3\7\3\b\3\b\3\t\3\t\3\n\3\n\3\n\3\n\3\n\3\n\3"+
		"\n\5\n9\n\n\3\13\6\13<\n\13\r\13\16\13=\3\f\6\fA\n\f\r\f\16\fB\3\r\3\r"+
		"\3\r\3\r\3\r\3\r\3\r\3\r\3\16\3\16\3\16\3\16\3\16\3\16\3\16\3\17\3\17"+
		"\3\17\3\20\6\20X\n\20\r\20\16\20Y\3\20\3\20\2\2\21\3\3\5\4\7\5\t\6\13"+
		"\7\r\b\17\t\21\n\23\13\25\f\27\r\31\16\33\17\35\20\37\21\3\2\5\5\2C\\"+
		"aac|\3\2\62;\5\2\13\f\17\17\"\"\2`\2\3\3\2\2\2\2\5\3\2\2\2\2\7\3\2\2\2"+
		"\2\t\3\2\2\2\2\13\3\2\2\2\2\r\3\2\2\2\2\17\3\2\2\2\2\21\3\2\2\2\2\23\3"+
		"\2\2\2\2\25\3\2\2\2\2\27\3\2\2\2\2\31\3\2\2\2\2\33\3\2\2\2\2\35\3\2\2"+
		"\2\2\37\3\2\2\2\3!\3\2\2\2\5#\3\2\2\2\7%\3\2\2\2\t\'\3\2\2\2\13)\3\2\2"+
		"\2\r+\3\2\2\2\17-\3\2\2\2\21/\3\2\2\2\238\3\2\2\2\25;\3\2\2\2\27@\3\2"+
		"\2\2\31D\3\2\2\2\33L\3\2\2\2\35S\3\2\2\2\37W\3\2\2\2!\"\7=\2\2\"\4\3\2"+
		"\2\2#$\7,\2\2$\6\3\2\2\2%&\7\61\2\2&\b\3\2\2\2\'(\7-\2\2(\n\3\2\2\2)*"+
		"\7/\2\2*\f\3\2\2\2+,\7*\2\2,\16\3\2\2\2-.\7+\2\2.\20\3\2\2\2/\60\7.\2"+
		"\2\60\22\3\2\2\2\61\62\7e\2\2\62\63\7j\2\2\63\64\7c\2\2\649\7t\2\2\65"+
		"\66\7k\2\2\66\67\7p\2\2\679\7v\2\28\61\3\2\2\28\65\3\2\2\29\24\3\2\2\2"+
		":<\t\2\2\2;:\3\2\2\2<=\3\2\2\2=;\3\2\2\2=>\3\2\2\2>\26\3\2\2\2?A\t\3\2"+
		"\2@?\3\2\2\2AB\3\2\2\2B@\3\2\2\2BC\3\2\2\2C\30\3\2\2\2DE\7%\2\2EF\7f\2"+
		"\2FG\7g\2\2GH\7h\2\2HI\7k\2\2IJ\7p\2\2JK\7g\2\2K\32\3\2\2\2LM\7%\2\2M"+
		"N\7w\2\2NO\7p\2\2OP\7f\2\2PQ\7g\2\2QR\7h\2\2R\34\3\2\2\2ST\7^\2\2TU\7"+
		"\f\2\2U\36\3\2\2\2VX\t\4\2\2WV\3\2\2\2XY\3\2\2\2YW\3\2\2\2YZ\3\2\2\2Z"+
		"[\3\2\2\2[\\\b\20\2\2\\ \3\2\2\2\7\28=BY\3\2\3\2";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}
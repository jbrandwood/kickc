// Generated from /Users/jespergravgaard/c64/src/kickc/src/dk/camelot64/kickc/parser/KickC.g4 by ANTLR 4.7
package dk.camelot64.kickc.parser;
import org.antlr.v4.runtime.Lexer;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.TokenStream;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.misc.*;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast"})
public class KickCLexer extends Lexer {
	static { RuntimeMetaData.checkVersion("4.7", RuntimeMetaData.VERSION); }

	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		T__0=1, T__1=2, T__2=3, T__3=4, T__4=5, T__5=6, NAME=7, FLOAT=8, HEXINTEGER=9, 
		DECINTEGER=10, BININTEGER=11, WS=12;
	public static String[] channelNames = {
		"DEFAULT_TOKEN_CHANNEL", "HIDDEN"
	};

	public static String[] modeNames = {
		"DEFAULT_MODE"
	};

	public static final String[] ruleNames = {
		"T__0", "T__1", "T__2", "T__3", "T__4", "T__5", "NAME", "NAME_START", 
		"NAME_CHAR", "FLOAT", "HEXINTEGER", "HEXDIGIT", "DECINTEGER", "DECDIGIT", 
		"BININTEGER", "BINDIGIT", "WS"
	};

	private static final String[] _LITERAL_NAMES = {
		null, "'('", "')'", "'+'", "'-'", "'*'", "'/'"
	};
	private static final String[] _SYMBOLIC_NAMES = {
		null, null, null, null, null, null, null, "NAME", "FLOAT", "HEXINTEGER", 
		"DECINTEGER", "BININTEGER", "WS"
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


	public KickCLexer(CharStream input) {
		super(input);
		_interp = new LexerATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}

	@Override
	public String getGrammarFileName() { return "KickC.g4"; }

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
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\2\16x\b\1\4\2\t\2\4"+
		"\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n\t\n\4\13\t"+
		"\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\4\20\t\20\4\21\t\21\4\22\t\22"+
		"\3\2\3\2\3\3\3\3\3\4\3\4\3\5\3\5\3\6\3\6\3\7\3\7\3\b\3\b\7\b\64\n\b\f"+
		"\b\16\b\67\13\b\3\t\3\t\3\n\3\n\3\13\7\13>\n\13\f\13\16\13A\13\13\3\13"+
		"\3\13\6\13E\n\13\r\13\16\13F\3\f\3\f\3\f\6\fL\n\f\r\f\16\fM\3\f\3\f\6"+
		"\fR\n\f\r\f\16\fS\5\fV\n\f\3\r\3\r\3\16\6\16[\n\16\r\16\16\16\\\3\17\3"+
		"\17\3\20\3\20\3\20\6\20d\n\20\r\20\16\20e\3\20\3\20\6\20j\n\20\r\20\16"+
		"\20k\5\20n\n\20\3\21\3\21\3\22\6\22s\n\22\r\22\16\22t\3\22\3\22\2\2\23"+
		"\3\3\5\4\7\5\t\6\13\7\r\b\17\t\21\2\23\2\25\n\27\13\31\2\33\f\35\2\37"+
		"\r!\2#\16\3\2\n\5\2C\\aac|\6\2\62;C\\aac|\4\2ZZzz\5\2\62;CHch\3\2\62;"+
		"\4\2DDdd\3\2\62\63\5\2\13\f\17\17\"\"\2}\2\3\3\2\2\2\2\5\3\2\2\2\2\7\3"+
		"\2\2\2\2\t\3\2\2\2\2\13\3\2\2\2\2\r\3\2\2\2\2\17\3\2\2\2\2\25\3\2\2\2"+
		"\2\27\3\2\2\2\2\33\3\2\2\2\2\37\3\2\2\2\2#\3\2\2\2\3%\3\2\2\2\5\'\3\2"+
		"\2\2\7)\3\2\2\2\t+\3\2\2\2\13-\3\2\2\2\r/\3\2\2\2\17\61\3\2\2\2\218\3"+
		"\2\2\2\23:\3\2\2\2\25?\3\2\2\2\27U\3\2\2\2\31W\3\2\2\2\33Z\3\2\2\2\35"+
		"^\3\2\2\2\37m\3\2\2\2!o\3\2\2\2#r\3\2\2\2%&\7*\2\2&\4\3\2\2\2\'(\7+\2"+
		"\2(\6\3\2\2\2)*\7-\2\2*\b\3\2\2\2+,\7/\2\2,\n\3\2\2\2-.\7,\2\2.\f\3\2"+
		"\2\2/\60\7\61\2\2\60\16\3\2\2\2\61\65\5\21\t\2\62\64\5\23\n\2\63\62\3"+
		"\2\2\2\64\67\3\2\2\2\65\63\3\2\2\2\65\66\3\2\2\2\66\20\3\2\2\2\67\65\3"+
		"\2\2\289\t\2\2\29\22\3\2\2\2:;\t\3\2\2;\24\3\2\2\2<>\5\35\17\2=<\3\2\2"+
		"\2>A\3\2\2\2?=\3\2\2\2?@\3\2\2\2@B\3\2\2\2A?\3\2\2\2BD\7\60\2\2CE\5\35"+
		"\17\2DC\3\2\2\2EF\3\2\2\2FD\3\2\2\2FG\3\2\2\2G\26\3\2\2\2HI\7\62\2\2I"+
		"K\t\4\2\2JL\5\31\r\2KJ\3\2\2\2LM\3\2\2\2MK\3\2\2\2MN\3\2\2\2NV\3\2\2\2"+
		"OQ\7&\2\2PR\5\31\r\2QP\3\2\2\2RS\3\2\2\2SQ\3\2\2\2ST\3\2\2\2TV\3\2\2\2"+
		"UH\3\2\2\2UO\3\2\2\2V\30\3\2\2\2WX\t\5\2\2X\32\3\2\2\2Y[\5\35\17\2ZY\3"+
		"\2\2\2[\\\3\2\2\2\\Z\3\2\2\2\\]\3\2\2\2]\34\3\2\2\2^_\t\6\2\2_\36\3\2"+
		"\2\2`a\7\62\2\2ac\t\7\2\2bd\5!\21\2cb\3\2\2\2de\3\2\2\2ec\3\2\2\2ef\3"+
		"\2\2\2fn\3\2\2\2gi\7\'\2\2hj\5!\21\2ih\3\2\2\2jk\3\2\2\2ki\3\2\2\2kl\3"+
		"\2\2\2ln\3\2\2\2m`\3\2\2\2mg\3\2\2\2n \3\2\2\2op\t\b\2\2p\"\3\2\2\2qs"+
		"\t\t\2\2rq\3\2\2\2st\3\2\2\2tr\3\2\2\2tu\3\2\2\2uv\3\2\2\2vw\b\22\2\2"+
		"w$\3\2\2\2\16\2\65?FMSU\\ekmt\3\b\2\2";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}
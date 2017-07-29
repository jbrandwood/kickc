// Generated from /Users/jespergravgaard/c64/src/kickc/src/dk/camelot64/kickc/asm/parser/Asm6502.g4 by ANTLR 4.7
package dk.camelot64.kickc.asm.parser;
import org.antlr.v4.runtime.Lexer;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.TokenStream;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.misc.*;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast"})
public class Asm6502Lexer extends Lexer {
	static { RuntimeMetaData.checkVersion("4.7", RuntimeMetaData.VERSION); }

	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		T__0=1, T__1=2, T__2=3, T__3=4, T__4=5, T__5=6, T__6=7, T__7=8, T__8=9, 
		T__9=10, T__10=11, T__11=12, T__12=13, T__13=14, T__14=15, T__15=16, MNEMONIC=17, 
		NUMINT=18, BININTEGER=19, DECINTEGER=20, HEXINTEGER=21, NAME=22, WS=23;
	public static String[] channelNames = {
		"DEFAULT_TOKEN_CHANNEL", "HIDDEN"
	};

	public static String[] modeNames = {
		"DEFAULT_MODE"
	};

	public static final String[] ruleNames = {
		"T__0", "T__1", "T__2", "T__3", "T__4", "T__5", "T__6", "T__7", "T__8", 
		"T__9", "T__10", "T__11", "T__12", "T__13", "T__14", "T__15", "MNEMONIC", 
		"NUMINT", "BININTEGER", "DECINTEGER", "HEXINTEGER", "BINDIGIT", "DECDIGIT", 
		"HEXDIGIT", "NAME", "NAME_START", "NAME_CHAR", "WS"
	};

	private static final String[] _LITERAL_NAMES = {
		null, "'\n'", "':'", "'//'", "'#'", "',x'", "',y'", "'('", "')'", "'+'", 
		"'-'", "'<'", "'>'", "'*'", "'/'", "'{'", "'}'"
	};
	private static final String[] _SYMBOLIC_NAMES = {
		null, null, null, null, null, null, null, null, null, null, null, null, 
		null, null, null, null, null, "MNEMONIC", "NUMINT", "BININTEGER", "DECINTEGER", 
		"HEXINTEGER", "NAME", "WS"
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


	public Asm6502Lexer(CharStream input) {
		super(input);
		_interp = new LexerATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}

	@Override
	public String getGrammarFileName() { return "Asm6502.g4"; }

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
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\2\31\u00a5\b\1\4\2"+
		"\t\2\4\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n\t\n\4"+
		"\13\t\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\4\20\t\20\4\21\t\21\4\22"+
		"\t\22\4\23\t\23\4\24\t\24\4\25\t\25\4\26\t\26\4\27\t\27\4\30\t\30\4\31"+
		"\t\31\4\32\t\32\4\33\t\33\4\34\t\34\4\35\t\35\3\2\3\2\3\3\3\3\3\4\3\4"+
		"\3\4\3\5\3\5\3\6\3\6\3\6\3\7\3\7\3\7\3\b\3\b\3\t\3\t\3\n\3\n\3\13\3\13"+
		"\3\f\3\f\3\r\3\r\3\16\3\16\3\17\3\17\3\20\3\20\3\21\3\21\3\22\3\22\3\22"+
		"\3\22\3\23\3\23\3\23\5\23f\n\23\3\24\3\24\3\24\6\24k\n\24\r\24\16\24l"+
		"\3\24\3\24\6\24q\n\24\r\24\16\24r\5\24u\n\24\3\25\6\25x\n\25\r\25\16\25"+
		"y\3\26\3\26\3\26\3\26\3\26\5\26\u0081\n\26\3\26\6\26\u0084\n\26\r\26\16"+
		"\26\u0085\3\27\3\27\3\30\3\30\3\31\3\31\3\32\3\32\7\32\u0090\n\32\f\32"+
		"\16\32\u0093\13\32\3\32\7\32\u0096\n\32\f\32\16\32\u0099\13\32\3\33\3"+
		"\33\3\34\3\34\3\35\6\35\u00a0\n\35\r\35\16\35\u00a1\3\35\3\35\2\2\36\3"+
		"\3\5\4\7\5\t\6\13\7\r\b\17\t\21\n\23\13\25\f\27\r\31\16\33\17\35\20\37"+
		"\21!\22#\23%\24\'\25)\26+\27-\2/\2\61\2\63\30\65\2\67\29\31\3\2\13\4\2"+
		"C\\c|\4\2DDdd\3\2\62\63\3\2\62;\5\2\62;CHch\4\2--//\6\2##C\\aac|\6\2\62"+
		";C\\aac|\5\2\13\13\17\17\"\"\2\u00ab\2\3\3\2\2\2\2\5\3\2\2\2\2\7\3\2\2"+
		"\2\2\t\3\2\2\2\2\13\3\2\2\2\2\r\3\2\2\2\2\17\3\2\2\2\2\21\3\2\2\2\2\23"+
		"\3\2\2\2\2\25\3\2\2\2\2\27\3\2\2\2\2\31\3\2\2\2\2\33\3\2\2\2\2\35\3\2"+
		"\2\2\2\37\3\2\2\2\2!\3\2\2\2\2#\3\2\2\2\2%\3\2\2\2\2\'\3\2\2\2\2)\3\2"+
		"\2\2\2+\3\2\2\2\2\63\3\2\2\2\29\3\2\2\2\3;\3\2\2\2\5=\3\2\2\2\7?\3\2\2"+
		"\2\tB\3\2\2\2\13D\3\2\2\2\rG\3\2\2\2\17J\3\2\2\2\21L\3\2\2\2\23N\3\2\2"+
		"\2\25P\3\2\2\2\27R\3\2\2\2\31T\3\2\2\2\33V\3\2\2\2\35X\3\2\2\2\37Z\3\2"+
		"\2\2!\\\3\2\2\2#^\3\2\2\2%e\3\2\2\2\'t\3\2\2\2)w\3\2\2\2+\u0080\3\2\2"+
		"\2-\u0087\3\2\2\2/\u0089\3\2\2\2\61\u008b\3\2\2\2\63\u008d\3\2\2\2\65"+
		"\u009a\3\2\2\2\67\u009c\3\2\2\29\u009f\3\2\2\2;<\7\f\2\2<\4\3\2\2\2=>"+
		"\7<\2\2>\6\3\2\2\2?@\7\61\2\2@A\7\61\2\2A\b\3\2\2\2BC\7%\2\2C\n\3\2\2"+
		"\2DE\7.\2\2EF\7z\2\2F\f\3\2\2\2GH\7.\2\2HI\7{\2\2I\16\3\2\2\2JK\7*\2\2"+
		"K\20\3\2\2\2LM\7+\2\2M\22\3\2\2\2NO\7-\2\2O\24\3\2\2\2PQ\7/\2\2Q\26\3"+
		"\2\2\2RS\7>\2\2S\30\3\2\2\2TU\7@\2\2U\32\3\2\2\2VW\7,\2\2W\34\3\2\2\2"+
		"XY\7\61\2\2Y\36\3\2\2\2Z[\7}\2\2[ \3\2\2\2\\]\7\177\2\2]\"\3\2\2\2^_\t"+
		"\2\2\2_`\t\2\2\2`a\t\2\2\2a$\3\2\2\2bf\5)\25\2cf\5+\26\2df\5\'\24\2eb"+
		"\3\2\2\2ec\3\2\2\2ed\3\2\2\2f&\3\2\2\2gh\7\62\2\2hj\t\3\2\2ik\5-\27\2"+
		"ji\3\2\2\2kl\3\2\2\2lj\3\2\2\2lm\3\2\2\2mu\3\2\2\2np\7\'\2\2oq\5-\27\2"+
		"po\3\2\2\2qr\3\2\2\2rp\3\2\2\2rs\3\2\2\2su\3\2\2\2tg\3\2\2\2tn\3\2\2\2"+
		"u(\3\2\2\2vx\5/\30\2wv\3\2\2\2xy\3\2\2\2yw\3\2\2\2yz\3\2\2\2z*\3\2\2\2"+
		"{\u0081\7&\2\2|}\7\62\2\2}\u0081\7z\2\2~\177\7\62\2\2\177\u0081\7Z\2\2"+
		"\u0080{\3\2\2\2\u0080|\3\2\2\2\u0080~\3\2\2\2\u0081\u0083\3\2\2\2\u0082"+
		"\u0084\5\61\31\2\u0083\u0082\3\2\2\2\u0084\u0085\3\2\2\2\u0085\u0083\3"+
		"\2\2\2\u0085\u0086\3\2\2\2\u0086,\3\2\2\2\u0087\u0088\t\4\2\2\u0088.\3"+
		"\2\2\2\u0089\u008a\t\5\2\2\u008a\60\3\2\2\2\u008b\u008c\t\6\2\2\u008c"+
		"\62\3\2\2\2\u008d\u0091\5\65\33\2\u008e\u0090\5\67\34\2\u008f\u008e\3"+
		"\2\2\2\u0090\u0093\3\2\2\2\u0091\u008f\3\2\2\2\u0091\u0092\3\2\2\2\u0092"+
		"\u0097\3\2\2\2\u0093\u0091\3\2\2\2\u0094\u0096\t\7\2\2\u0095\u0094\3\2"+
		"\2\2\u0096\u0099\3\2\2\2\u0097\u0095\3\2\2\2\u0097\u0098\3\2\2\2\u0098"+
		"\64\3\2\2\2\u0099\u0097\3\2\2\2\u009a\u009b\t\b\2\2\u009b\66\3\2\2\2\u009c"+
		"\u009d\t\t\2\2\u009d8\3\2\2\2\u009e\u00a0\t\n\2\2\u009f\u009e\3\2\2\2"+
		"\u00a0\u00a1\3\2\2\2\u00a1\u009f\3\2\2\2\u00a1\u00a2\3\2\2\2\u00a2\u00a3"+
		"\3\2\2\2\u00a3\u00a4\b\35\2\2\u00a4:\3\2\2\2\r\2elrty\u0080\u0085\u0091"+
		"\u0097\u00a1\3\b\2\2";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}
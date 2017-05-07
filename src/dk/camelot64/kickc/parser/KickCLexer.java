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
		T__0=1, T__1=2, T__2=3, T__3=4, T__4=5, T__5=6, T__6=7, T__7=8, T__8=9, 
		T__9=10, T__10=11, T__11=12, T__12=13, T__13=14, T__14=15, T__15=16, T__16=17, 
		T__17=18, T__18=19, T__19=20, T__20=21, T__21=22, T__22=23, T__23=24, 
		T__24=25, T__25=26, T__26=27, T__27=28, TYPE=29, STRING=30, BOOLEAN=31, 
		NUMBER=32, NUMFLOAT=33, BINFLOAT=34, DECFLOAT=35, HEXFLOAT=36, NUMINT=37, 
		BININTEGER=38, DECINTEGER=39, HEXINTEGER=40, NAME=41, WS=42;
	public static String[] channelNames = {
		"DEFAULT_TOKEN_CHANNEL", "HIDDEN"
	};

	public static String[] modeNames = {
		"DEFAULT_MODE"
	};

	public static final String[] ruleNames = {
		"T__0", "T__1", "T__2", "T__3", "T__4", "T__5", "T__6", "T__7", "T__8", 
		"T__9", "T__10", "T__11", "T__12", "T__13", "T__14", "T__15", "T__16", 
		"T__17", "T__18", "T__19", "T__20", "T__21", "T__22", "T__23", "T__24", 
		"T__25", "T__26", "T__27", "TYPE", "STRING", "BOOLEAN", "NUMBER", "NUMFLOAT", 
		"BINFLOAT", "DECFLOAT", "HEXFLOAT", "NUMINT", "BININTEGER", "DECINTEGER", 
		"HEXINTEGER", "BINDIGIT", "DECDIGIT", "HEXDIGIT", "NAME", "NAME_START", 
		"NAME_CHAR", "WS"
	};

	private static final String[] _LITERAL_NAMES = {
		null, "'{'", "'}'", "'='", "';'", "'if'", "'('", "')'", "'else'", "'while'", 
		"'+'", "'-'", "'not'", "'!'", "'*'", "'/'", "'=='", "'!='", "'<>'", "'<'", 
		"'<='", "'=<'", "'>='", "'=>'", "'>'", "'and'", "'&&'", "'or'", "'||'"
	};
	private static final String[] _SYMBOLIC_NAMES = {
		null, null, null, null, null, null, null, null, null, null, null, null, 
		null, null, null, null, null, null, null, null, null, null, null, null, 
		null, null, null, null, null, "TYPE", "STRING", "BOOLEAN", "NUMBER", "NUMFLOAT", 
		"BINFLOAT", "DECFLOAT", "HEXFLOAT", "NUMINT", "BININTEGER", "DECINTEGER", 
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
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\2,\u0154\b\1\4\2\t"+
		"\2\4\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n\t\n\4\13"+
		"\t\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\4\20\t\20\4\21\t\21\4\22\t\22"+
		"\4\23\t\23\4\24\t\24\4\25\t\25\4\26\t\26\4\27\t\27\4\30\t\30\4\31\t\31"+
		"\4\32\t\32\4\33\t\33\4\34\t\34\4\35\t\35\4\36\t\36\4\37\t\37\4 \t \4!"+
		"\t!\4\"\t\"\4#\t#\4$\t$\4%\t%\4&\t&\4\'\t\'\4(\t(\4)\t)\4*\t*\4+\t+\4"+
		",\t,\4-\t-\4.\t.\4/\t/\4\60\t\60\3\2\3\2\3\3\3\3\3\4\3\4\3\5\3\5\3\6\3"+
		"\6\3\6\3\7\3\7\3\b\3\b\3\t\3\t\3\t\3\t\3\t\3\n\3\n\3\n\3\n\3\n\3\n\3\13"+
		"\3\13\3\f\3\f\3\r\3\r\3\r\3\r\3\16\3\16\3\17\3\17\3\20\3\20\3\21\3\21"+
		"\3\21\3\22\3\22\3\22\3\23\3\23\3\23\3\24\3\24\3\25\3\25\3\25\3\26\3\26"+
		"\3\26\3\27\3\27\3\27\3\30\3\30\3\30\3\31\3\31\3\32\3\32\3\32\3\32\3\33"+
		"\3\33\3\33\3\34\3\34\3\34\3\35\3\35\3\35\3\36\3\36\3\36\3\36\3\36\3\36"+
		"\3\36\3\36\3\36\3\36\3\36\3\36\3\36\3\36\3\36\3\36\3\36\3\36\3\36\3\36"+
		"\3\36\5\36\u00c5\n\36\3\37\3\37\3\37\3\37\7\37\u00cb\n\37\f\37\16\37\u00ce"+
		"\13\37\3\37\3\37\3 \3 \3 \3 \3 \3 \3 \3 \3 \5 \u00db\n \3!\3!\5!\u00df"+
		"\n!\3\"\3\"\3\"\5\"\u00e4\n\"\3#\3#\3#\3#\3#\5#\u00eb\n#\3#\7#\u00ee\n"+
		"#\f#\16#\u00f1\13#\3#\3#\6#\u00f5\n#\r#\16#\u00f6\3$\7$\u00fa\n$\f$\16"+
		"$\u00fd\13$\3$\3$\6$\u0101\n$\r$\16$\u0102\3%\3%\3%\3%\3%\5%\u010a\n%"+
		"\3%\7%\u010d\n%\f%\16%\u0110\13%\3%\3%\6%\u0114\n%\r%\16%\u0115\3&\3&"+
		"\3&\5&\u011b\n&\3\'\3\'\3\'\6\'\u0120\n\'\r\'\16\'\u0121\3\'\3\'\6\'\u0126"+
		"\n\'\r\'\16\'\u0127\5\'\u012a\n\'\3(\6(\u012d\n(\r(\16(\u012e\3)\3)\3"+
		")\3)\3)\5)\u0136\n)\3)\6)\u0139\n)\r)\16)\u013a\3*\3*\3+\3+\3,\3,\3-\3"+
		"-\7-\u0145\n-\f-\16-\u0148\13-\3.\3.\3/\3/\3\60\6\60\u014f\n\60\r\60\16"+
		"\60\u0150\3\60\3\60\2\2\61\3\3\5\4\7\5\t\6\13\7\r\b\17\t\21\n\23\13\25"+
		"\f\27\r\31\16\33\17\35\20\37\21!\22#\23%\24\'\25)\26+\27-\30/\31\61\32"+
		"\63\33\65\34\67\359\36;\37= ?!A\"C#E$G%I&K\'M(O)Q*S\2U\2W\2Y+[\2]\2_,"+
		"\3\2\n\3\2$$\4\2DDdd\3\2\62\63\3\2\62;\5\2\62;CHch\5\2C\\aac|\6\2\62;"+
		"C\\aac|\5\2\13\f\17\17\"\"\2\u016c\2\3\3\2\2\2\2\5\3\2\2\2\2\7\3\2\2\2"+
		"\2\t\3\2\2\2\2\13\3\2\2\2\2\r\3\2\2\2\2\17\3\2\2\2\2\21\3\2\2\2\2\23\3"+
		"\2\2\2\2\25\3\2\2\2\2\27\3\2\2\2\2\31\3\2\2\2\2\33\3\2\2\2\2\35\3\2\2"+
		"\2\2\37\3\2\2\2\2!\3\2\2\2\2#\3\2\2\2\2%\3\2\2\2\2\'\3\2\2\2\2)\3\2\2"+
		"\2\2+\3\2\2\2\2-\3\2\2\2\2/\3\2\2\2\2\61\3\2\2\2\2\63\3\2\2\2\2\65\3\2"+
		"\2\2\2\67\3\2\2\2\29\3\2\2\2\2;\3\2\2\2\2=\3\2\2\2\2?\3\2\2\2\2A\3\2\2"+
		"\2\2C\3\2\2\2\2E\3\2\2\2\2G\3\2\2\2\2I\3\2\2\2\2K\3\2\2\2\2M\3\2\2\2\2"+
		"O\3\2\2\2\2Q\3\2\2\2\2Y\3\2\2\2\2_\3\2\2\2\3a\3\2\2\2\5c\3\2\2\2\7e\3"+
		"\2\2\2\tg\3\2\2\2\13i\3\2\2\2\rl\3\2\2\2\17n\3\2\2\2\21p\3\2\2\2\23u\3"+
		"\2\2\2\25{\3\2\2\2\27}\3\2\2\2\31\177\3\2\2\2\33\u0083\3\2\2\2\35\u0085"+
		"\3\2\2\2\37\u0087\3\2\2\2!\u0089\3\2\2\2#\u008c\3\2\2\2%\u008f\3\2\2\2"+
		"\'\u0092\3\2\2\2)\u0094\3\2\2\2+\u0097\3\2\2\2-\u009a\3\2\2\2/\u009d\3"+
		"\2\2\2\61\u00a0\3\2\2\2\63\u00a2\3\2\2\2\65\u00a6\3\2\2\2\67\u00a9\3\2"+
		"\2\29\u00ac\3\2\2\2;\u00c4\3\2\2\2=\u00c6\3\2\2\2?\u00da\3\2\2\2A\u00de"+
		"\3\2\2\2C\u00e3\3\2\2\2E\u00ea\3\2\2\2G\u00fb\3\2\2\2I\u0109\3\2\2\2K"+
		"\u011a\3\2\2\2M\u0129\3\2\2\2O\u012c\3\2\2\2Q\u0135\3\2\2\2S\u013c\3\2"+
		"\2\2U\u013e\3\2\2\2W\u0140\3\2\2\2Y\u0142\3\2\2\2[\u0149\3\2\2\2]\u014b"+
		"\3\2\2\2_\u014e\3\2\2\2ab\7}\2\2b\4\3\2\2\2cd\7\177\2\2d\6\3\2\2\2ef\7"+
		"?\2\2f\b\3\2\2\2gh\7=\2\2h\n\3\2\2\2ij\7k\2\2jk\7h\2\2k\f\3\2\2\2lm\7"+
		"*\2\2m\16\3\2\2\2no\7+\2\2o\20\3\2\2\2pq\7g\2\2qr\7n\2\2rs\7u\2\2st\7"+
		"g\2\2t\22\3\2\2\2uv\7y\2\2vw\7j\2\2wx\7k\2\2xy\7n\2\2yz\7g\2\2z\24\3\2"+
		"\2\2{|\7-\2\2|\26\3\2\2\2}~\7/\2\2~\30\3\2\2\2\177\u0080\7p\2\2\u0080"+
		"\u0081\7q\2\2\u0081\u0082\7v\2\2\u0082\32\3\2\2\2\u0083\u0084\7#\2\2\u0084"+
		"\34\3\2\2\2\u0085\u0086\7,\2\2\u0086\36\3\2\2\2\u0087\u0088\7\61\2\2\u0088"+
		" \3\2\2\2\u0089\u008a\7?\2\2\u008a\u008b\7?\2\2\u008b\"\3\2\2\2\u008c"+
		"\u008d\7#\2\2\u008d\u008e\7?\2\2\u008e$\3\2\2\2\u008f\u0090\7>\2\2\u0090"+
		"\u0091\7@\2\2\u0091&\3\2\2\2\u0092\u0093\7>\2\2\u0093(\3\2\2\2\u0094\u0095"+
		"\7>\2\2\u0095\u0096\7?\2\2\u0096*\3\2\2\2\u0097\u0098\7?\2\2\u0098\u0099"+
		"\7>\2\2\u0099,\3\2\2\2\u009a\u009b\7@\2\2\u009b\u009c\7?\2\2\u009c.\3"+
		"\2\2\2\u009d\u009e\7?\2\2\u009e\u009f\7@\2\2\u009f\60\3\2\2\2\u00a0\u00a1"+
		"\7@\2\2\u00a1\62\3\2\2\2\u00a2\u00a3\7c\2\2\u00a3\u00a4\7p\2\2\u00a4\u00a5"+
		"\7f\2\2\u00a5\64\3\2\2\2\u00a6\u00a7\7(\2\2\u00a7\u00a8\7(\2\2\u00a8\66"+
		"\3\2\2\2\u00a9\u00aa\7q\2\2\u00aa\u00ab\7t\2\2\u00ab8\3\2\2\2\u00ac\u00ad"+
		"\7~\2\2\u00ad\u00ae\7~\2\2\u00ae:\3\2\2\2\u00af\u00b0\7d\2\2\u00b0\u00b1"+
		"\7{\2\2\u00b1\u00b2\7v\2\2\u00b2\u00c5\7g\2\2\u00b3\u00b4\7y\2\2\u00b4"+
		"\u00b5\7q\2\2\u00b5\u00b6\7t\2\2\u00b6\u00c5\7f\2\2\u00b7\u00b8\7u\2\2"+
		"\u00b8\u00b9\7v\2\2\u00b9\u00ba\7t\2\2\u00ba\u00bb\7k\2\2\u00bb\u00bc"+
		"\7p\2\2\u00bc\u00c5\7i\2\2\u00bd\u00be\7d\2\2\u00be\u00bf\7q\2\2\u00bf"+
		"\u00c0\7q\2\2\u00c0\u00c1\7n\2\2\u00c1\u00c2\7g\2\2\u00c2\u00c3\7c\2\2"+
		"\u00c3\u00c5\7p\2\2\u00c4\u00af\3\2\2\2\u00c4\u00b3\3\2\2\2\u00c4\u00b7"+
		"\3\2\2\2\u00c4\u00bd\3\2\2\2\u00c5<\3\2\2\2\u00c6\u00cc\7$\2\2\u00c7\u00c8"+
		"\7^\2\2\u00c8\u00cb\7$\2\2\u00c9\u00cb\n\2\2\2\u00ca\u00c7\3\2\2\2\u00ca"+
		"\u00c9\3\2\2\2\u00cb\u00ce\3\2\2\2\u00cc\u00ca\3\2\2\2\u00cc\u00cd\3\2"+
		"\2\2\u00cd\u00cf\3\2\2\2\u00ce\u00cc\3\2\2\2\u00cf\u00d0\7$\2\2\u00d0"+
		">\3\2\2\2\u00d1\u00d2\7v\2\2\u00d2\u00d3\7t\2\2\u00d3\u00d4\7w\2\2\u00d4"+
		"\u00db\7g\2\2\u00d5\u00d6\7h\2\2\u00d6\u00d7\7c\2\2\u00d7\u00d8\7n\2\2"+
		"\u00d8\u00d9\7u\2\2\u00d9\u00db\7g\2\2\u00da\u00d1\3\2\2\2\u00da\u00d5"+
		"\3\2\2\2\u00db@\3\2\2\2\u00dc\u00df\5C\"\2\u00dd\u00df\5K&\2\u00de\u00dc"+
		"\3\2\2\2\u00de\u00dd\3\2\2\2\u00dfB\3\2\2\2\u00e0\u00e4\5E#\2\u00e1\u00e4"+
		"\5G$\2\u00e2\u00e4\5I%\2\u00e3\u00e0\3\2\2\2\u00e3\u00e1\3\2\2\2\u00e3"+
		"\u00e2\3\2\2\2\u00e4D\3\2\2\2\u00e5\u00eb\7\'\2\2\u00e6\u00e7\7\62\2\2"+
		"\u00e7\u00eb\7d\2\2\u00e8\u00e9\7\62\2\2\u00e9\u00eb\7D\2\2\u00ea\u00e5"+
		"\3\2\2\2\u00ea\u00e6\3\2\2\2\u00ea\u00e8\3\2\2\2\u00eb\u00ef\3\2\2\2\u00ec"+
		"\u00ee\5S*\2\u00ed\u00ec\3\2\2\2\u00ee\u00f1\3\2\2\2\u00ef\u00ed\3\2\2"+
		"\2\u00ef\u00f0\3\2\2\2\u00f0\u00f2\3\2\2\2\u00f1\u00ef\3\2\2\2\u00f2\u00f4"+
		"\7\60\2\2\u00f3\u00f5\5S*\2\u00f4\u00f3\3\2\2\2\u00f5\u00f6\3\2\2\2\u00f6"+
		"\u00f4\3\2\2\2\u00f6\u00f7\3\2\2\2\u00f7F\3\2\2\2\u00f8\u00fa\5U+\2\u00f9"+
		"\u00f8\3\2\2\2\u00fa\u00fd\3\2\2\2\u00fb\u00f9\3\2\2\2\u00fb\u00fc\3\2"+
		"\2\2\u00fc\u00fe\3\2\2\2\u00fd\u00fb\3\2\2\2\u00fe\u0100\7\60\2\2\u00ff"+
		"\u0101\5U+\2\u0100\u00ff\3\2\2\2\u0101\u0102\3\2\2\2\u0102\u0100\3\2\2"+
		"\2\u0102\u0103\3\2\2\2\u0103H\3\2\2\2\u0104\u010a\7&\2\2\u0105\u0106\7"+
		"\62\2\2\u0106\u010a\7z\2\2\u0107\u0108\7\62\2\2\u0108\u010a\7Z\2\2\u0109"+
		"\u0104\3\2\2\2\u0109\u0105\3\2\2\2\u0109\u0107\3\2\2\2\u010a\u010e\3\2"+
		"\2\2\u010b\u010d\5W,\2\u010c\u010b\3\2\2\2\u010d\u0110\3\2\2\2\u010e\u010c"+
		"\3\2\2\2\u010e\u010f\3\2\2\2\u010f\u0111\3\2\2\2\u0110\u010e\3\2\2\2\u0111"+
		"\u0113\7\60\2\2\u0112\u0114\5W,\2\u0113\u0112\3\2\2\2\u0114\u0115\3\2"+
		"\2\2\u0115\u0113\3\2\2\2\u0115\u0116\3\2\2\2\u0116J\3\2\2\2\u0117\u011b"+
		"\5O(\2\u0118\u011b\5Q)\2\u0119\u011b\5M\'\2\u011a\u0117\3\2\2\2\u011a"+
		"\u0118\3\2\2\2\u011a\u0119\3\2\2\2\u011bL\3\2\2\2\u011c\u011d\7\62\2\2"+
		"\u011d\u011f\t\3\2\2\u011e\u0120\5S*\2\u011f\u011e\3\2\2\2\u0120\u0121"+
		"\3\2\2\2\u0121\u011f\3\2\2\2\u0121\u0122\3\2\2\2\u0122\u012a\3\2\2\2\u0123"+
		"\u0125\7\'\2\2\u0124\u0126\5S*\2\u0125\u0124\3\2\2\2\u0126\u0127\3\2\2"+
		"\2\u0127\u0125\3\2\2\2\u0127\u0128\3\2\2\2\u0128\u012a\3\2\2\2\u0129\u011c"+
		"\3\2\2\2\u0129\u0123\3\2\2\2\u012aN\3\2\2\2\u012b\u012d\5U+\2\u012c\u012b"+
		"\3\2\2\2\u012d\u012e\3\2\2\2\u012e\u012c\3\2\2\2\u012e\u012f\3\2\2\2\u012f"+
		"P\3\2\2\2\u0130\u0136\7&\2\2\u0131\u0132\7\62\2\2\u0132\u0136\7z\2\2\u0133"+
		"\u0134\7\62\2\2\u0134\u0136\7Z\2\2\u0135\u0130\3\2\2\2\u0135\u0131\3\2"+
		"\2\2\u0135\u0133\3\2\2\2\u0136\u0138\3\2\2\2\u0137\u0139\5W,\2\u0138\u0137"+
		"\3\2\2\2\u0139\u013a\3\2\2\2\u013a\u0138\3\2\2\2\u013a\u013b\3\2\2\2\u013b"+
		"R\3\2\2\2\u013c\u013d\t\4\2\2\u013dT\3\2\2\2\u013e\u013f\t\5\2\2\u013f"+
		"V\3\2\2\2\u0140\u0141\t\6\2\2\u0141X\3\2\2\2\u0142\u0146\5[.\2\u0143\u0145"+
		"\5]/\2\u0144\u0143\3\2\2\2\u0145\u0148\3\2\2\2\u0146\u0144\3\2\2\2\u0146"+
		"\u0147\3\2\2\2\u0147Z\3\2\2\2\u0148\u0146\3\2\2\2\u0149\u014a\t\7\2\2"+
		"\u014a\\\3\2\2\2\u014b\u014c\t\b\2\2\u014c^\3\2\2\2\u014d\u014f\t\t\2"+
		"\2\u014e\u014d\3\2\2\2\u014f\u0150\3\2\2\2\u0150\u014e\3\2\2\2\u0150\u0151"+
		"\3\2\2\2\u0151\u0152\3\2\2\2\u0152\u0153\b\60\2\2\u0153`\3\2\2\2\32\2"+
		"\u00c4\u00ca\u00cc\u00da\u00de\u00e3\u00ea\u00ef\u00f6\u00fb\u0102\u0109"+
		"\u010e\u0115\u011a\u0121\u0127\u0129\u012e\u0135\u013a\u0146\u0150\3\b"+
		"\2\2";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}
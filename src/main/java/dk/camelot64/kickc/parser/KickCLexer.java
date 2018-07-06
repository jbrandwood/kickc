// Generated from /Users/jespergravgaard/c64/kickc/src/main/java/dk/camelot64/kickc/parser/KickC.g4 by ANTLR 4.7
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
		T__24=25, T__25=26, T__26=27, T__27=28, T__28=29, T__29=30, T__30=31, 
		T__31=32, T__32=33, T__33=34, T__34=35, T__35=36, T__36=37, T__37=38, 
		T__38=39, T__39=40, T__40=41, T__41=42, T__42=43, T__43=44, T__44=45, 
		T__45=46, T__46=47, T__47=48, T__48=49, T__49=50, T__50=51, T__51=52, 
		T__52=53, T__53=54, T__54=55, T__55=56, T__56=57, T__57=58, T__58=59, 
		T__59=60, T__60=61, T__61=62, MNEMONIC=63, KICKASM=64, SIMPLETYPE=65, 
		STRING=66, CHAR=67, BOOLEAN=68, NUMBER=69, NUMFLOAT=70, BINFLOAT=71, DECFLOAT=72, 
		HEXFLOAT=73, NUMINT=74, BININTEGER=75, DECINTEGER=76, HEXINTEGER=77, NAME=78, 
		ASMREL=79, WS=80, COMMENT_LINE=81, COMMENT_BLOCK=82;
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
		"T__25", "T__26", "T__27", "T__28", "T__29", "T__30", "T__31", "T__32", 
		"T__33", "T__34", "T__35", "T__36", "T__37", "T__38", "T__39", "T__40", 
		"T__41", "T__42", "T__43", "T__44", "T__45", "T__46", "T__47", "T__48", 
		"T__49", "T__50", "T__51", "T__52", "T__53", "T__54", "T__55", "T__56", 
		"T__57", "T__58", "T__59", "T__60", "T__61", "MNEMONIC", "KICKASM", "SIMPLETYPE", 
		"STRING", "CHAR", "BOOLEAN", "NUMBER", "NUMFLOAT", "BINFLOAT", "DECFLOAT", 
		"HEXFLOAT", "NUMINT", "BININTEGER", "DECINTEGER", "HEXINTEGER", "BINDIGIT", 
		"DECDIGIT", "HEXDIGIT", "NAME", "NAME_START", "NAME_CHAR", "ASMREL", "WS", 
		"COMMENT_LINE", "COMMENT_BLOCK"
	};

	private static final String[] _LITERAL_NAMES = {
		null, "'import'", "'='", "';'", "'('", "')'", "'{'", "'}'", "'kickasm'", 
		"'clobber'", "'param'", "','", "':'", "'const'", "'extern'", "'align'", 
		"'register'", "'inline'", "'if'", "'else'", "'while'", "'do'", "'for'", 
		"'return'", "'asm'", "'..'", "'signed'", "'*'", "'['", "']'", "'--'", 
		"'++'", "'+'", "'-'", "'!'", "'&'", "'~'", "'>>'", "'<<'", "'/'", "'%'", 
		"'<'", "'>'", "'=='", "'!='", "'<='", "'>='", "'^'", "'|'", "'&&'", "'||'", 
		"'+='", "'-='", "'*='", "'/='", "'%='", "'<<='", "'>>='", "'&='", "'|='", 
		"'^='", "'.byte'", "'#'"
	};
	private static final String[] _SYMBOLIC_NAMES = {
		null, null, null, null, null, null, null, null, null, null, null, null, 
		null, null, null, null, null, null, null, null, null, null, null, null, 
		null, null, null, null, null, null, null, null, null, null, null, null, 
		null, null, null, null, null, null, null, null, null, null, null, null, 
		null, null, null, null, null, null, null, null, null, null, null, null, 
		null, null, null, "MNEMONIC", "KICKASM", "SIMPLETYPE", "STRING", "CHAR", 
		"BOOLEAN", "NUMBER", "NUMFLOAT", "BINFLOAT", "DECFLOAT", "HEXFLOAT", "NUMINT", 
		"BININTEGER", "DECINTEGER", "HEXINTEGER", "NAME", "ASMREL", "WS", "COMMENT_LINE", 
		"COMMENT_BLOCK"
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
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\2T\u034b\b\1\4\2\t"+
		"\2\4\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n\t\n\4\13"+
		"\t\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\4\20\t\20\4\21\t\21\4\22\t\22"+
		"\4\23\t\23\4\24\t\24\4\25\t\25\4\26\t\26\4\27\t\27\4\30\t\30\4\31\t\31"+
		"\4\32\t\32\4\33\t\33\4\34\t\34\4\35\t\35\4\36\t\36\4\37\t\37\4 \t \4!"+
		"\t!\4\"\t\"\4#\t#\4$\t$\4%\t%\4&\t&\4\'\t\'\4(\t(\4)\t)\4*\t*\4+\t+\4"+
		",\t,\4-\t-\4.\t.\4/\t/\4\60\t\60\4\61\t\61\4\62\t\62\4\63\t\63\4\64\t"+
		"\64\4\65\t\65\4\66\t\66\4\67\t\67\48\t8\49\t9\4:\t:\4;\t;\4<\t<\4=\t="+
		"\4>\t>\4?\t?\4@\t@\4A\tA\4B\tB\4C\tC\4D\tD\4E\tE\4F\tF\4G\tG\4H\tH\4I"+
		"\tI\4J\tJ\4K\tK\4L\tL\4M\tM\4N\tN\4O\tO\4P\tP\4Q\tQ\4R\tR\4S\tS\4T\tT"+
		"\4U\tU\4V\tV\4W\tW\4X\tX\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\3\3\3\3\4\3\4\3"+
		"\5\3\5\3\6\3\6\3\7\3\7\3\b\3\b\3\t\3\t\3\t\3\t\3\t\3\t\3\t\3\t\3\n\3\n"+
		"\3\n\3\n\3\n\3\n\3\n\3\n\3\13\3\13\3\13\3\13\3\13\3\13\3\f\3\f\3\r\3\r"+
		"\3\16\3\16\3\16\3\16\3\16\3\16\3\17\3\17\3\17\3\17\3\17\3\17\3\17\3\20"+
		"\3\20\3\20\3\20\3\20\3\20\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\21"+
		"\3\22\3\22\3\22\3\22\3\22\3\22\3\22\3\23\3\23\3\23\3\24\3\24\3\24\3\24"+
		"\3\24\3\25\3\25\3\25\3\25\3\25\3\25\3\26\3\26\3\26\3\27\3\27\3\27\3\27"+
		"\3\30\3\30\3\30\3\30\3\30\3\30\3\30\3\31\3\31\3\31\3\31\3\32\3\32\3\32"+
		"\3\33\3\33\3\33\3\33\3\33\3\33\3\33\3\34\3\34\3\35\3\35\3\36\3\36\3\37"+
		"\3\37\3\37\3 \3 \3 \3!\3!\3\"\3\"\3#\3#\3$\3$\3%\3%\3&\3&\3&\3\'\3\'\3"+
		"\'\3(\3(\3)\3)\3*\3*\3+\3+\3,\3,\3,\3-\3-\3-\3.\3.\3.\3/\3/\3/\3\60\3"+
		"\60\3\61\3\61\3\62\3\62\3\62\3\63\3\63\3\63\3\64\3\64\3\64\3\65\3\65\3"+
		"\65\3\66\3\66\3\66\3\67\3\67\3\67\38\38\38\39\39\39\39\3:\3:\3:\3:\3;"+
		"\3;\3;\3<\3<\3<\3=\3=\3=\3>\3>\3>\3>\3>\3>\3?\3?\3@\3@\3@\3@\3@\3@\3@"+
		"\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@"+
		"\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@"+
		"\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@"+
		"\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@"+
		"\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@"+
		"\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@"+
		"\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@"+
		"\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@"+
		"\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@"+
		"\3@\3@\3@\3@\3@\3@\3@\3@\5@\u026c\n@\3A\3A\3A\3A\7A\u0272\nA\fA\16A\u0275"+
		"\13A\3A\3A\3A\3B\3B\3B\3B\3B\3B\3B\3B\3B\3B\3B\3B\3B\3B\3B\3B\3B\3B\3"+
		"B\3B\3B\5B\u028f\nB\3C\3C\3C\3C\7C\u0295\nC\fC\16C\u0298\13C\3C\3C\3D"+
		"\3D\3D\3D\5D\u02a0\nD\3D\3D\3E\3E\3E\3E\3E\3E\3E\3E\3E\5E\u02ad\nE\3F"+
		"\3F\5F\u02b1\nF\3G\3G\3G\5G\u02b6\nG\3H\3H\3H\3H\3H\5H\u02bd\nH\3H\7H"+
		"\u02c0\nH\fH\16H\u02c3\13H\3H\3H\6H\u02c7\nH\rH\16H\u02c8\3I\7I\u02cc"+
		"\nI\fI\16I\u02cf\13I\3I\3I\6I\u02d3\nI\rI\16I\u02d4\3J\3J\3J\3J\3J\5J"+
		"\u02dc\nJ\3J\7J\u02df\nJ\fJ\16J\u02e2\13J\3J\3J\6J\u02e6\nJ\rJ\16J\u02e7"+
		"\3K\3K\3K\5K\u02ed\nK\3L\3L\3L\6L\u02f2\nL\rL\16L\u02f3\3L\3L\6L\u02f8"+
		"\nL\rL\16L\u02f9\5L\u02fc\nL\3M\6M\u02ff\nM\rM\16M\u0300\3N\3N\3N\3N\3"+
		"N\5N\u0308\nN\3N\6N\u030b\nN\rN\16N\u030c\3O\3O\3P\3P\3Q\3Q\3R\3R\7R\u0317"+
		"\nR\fR\16R\u031a\13R\3S\3S\3T\3T\3U\3U\7U\u0322\nU\fU\16U\u0325\13U\3"+
		"U\6U\u0328\nU\rU\16U\u0329\3V\6V\u032d\nV\rV\16V\u032e\3V\3V\3W\3W\3W"+
		"\3W\7W\u0337\nW\fW\16W\u033a\13W\3W\3W\3X\3X\3X\3X\7X\u0342\nX\fX\16X"+
		"\u0345\13X\3X\3X\3X\3X\3X\4\u0273\u0343\2Y\3\3\5\4\7\5\t\6\13\7\r\b\17"+
		"\t\21\n\23\13\25\f\27\r\31\16\33\17\35\20\37\21!\22#\23%\24\'\25)\26+"+
		"\27-\30/\31\61\32\63\33\65\34\67\359\36;\37= ?!A\"C#E$G%I&K\'M(O)Q*S+"+
		"U,W-Y.[/]\60_\61a\62c\63e\64g\65i\66k\67m8o9q:s;u<w=y>{?}@\177A\u0081"+
		"B\u0083C\u0085D\u0087E\u0089F\u008bG\u008dH\u008fI\u0091J\u0093K\u0095"+
		"L\u0097M\u0099N\u009bO\u009d\2\u009f\2\u00a1\2\u00a3P\u00a5\2\u00a7\2"+
		"\u00a9Q\u00abR\u00adS\u00afT\3\2\r\3\2$$\3\2))\4\2DDdd\3\2\62\63\3\2\62"+
		";\5\2\62;CHch\5\2C\\aac|\6\2\62;C\\aac|\4\2--//\5\2\13\f\17\17\"\"\4\2"+
		"\f\f\17\17\2\u03b3\2\3\3\2\2\2\2\5\3\2\2\2\2\7\3\2\2\2\2\t\3\2\2\2\2\13"+
		"\3\2\2\2\2\r\3\2\2\2\2\17\3\2\2\2\2\21\3\2\2\2\2\23\3\2\2\2\2\25\3\2\2"+
		"\2\2\27\3\2\2\2\2\31\3\2\2\2\2\33\3\2\2\2\2\35\3\2\2\2\2\37\3\2\2\2\2"+
		"!\3\2\2\2\2#\3\2\2\2\2%\3\2\2\2\2\'\3\2\2\2\2)\3\2\2\2\2+\3\2\2\2\2-\3"+
		"\2\2\2\2/\3\2\2\2\2\61\3\2\2\2\2\63\3\2\2\2\2\65\3\2\2\2\2\67\3\2\2\2"+
		"\29\3\2\2\2\2;\3\2\2\2\2=\3\2\2\2\2?\3\2\2\2\2A\3\2\2\2\2C\3\2\2\2\2E"+
		"\3\2\2\2\2G\3\2\2\2\2I\3\2\2\2\2K\3\2\2\2\2M\3\2\2\2\2O\3\2\2\2\2Q\3\2"+
		"\2\2\2S\3\2\2\2\2U\3\2\2\2\2W\3\2\2\2\2Y\3\2\2\2\2[\3\2\2\2\2]\3\2\2\2"+
		"\2_\3\2\2\2\2a\3\2\2\2\2c\3\2\2\2\2e\3\2\2\2\2g\3\2\2\2\2i\3\2\2\2\2k"+
		"\3\2\2\2\2m\3\2\2\2\2o\3\2\2\2\2q\3\2\2\2\2s\3\2\2\2\2u\3\2\2\2\2w\3\2"+
		"\2\2\2y\3\2\2\2\2{\3\2\2\2\2}\3\2\2\2\2\177\3\2\2\2\2\u0081\3\2\2\2\2"+
		"\u0083\3\2\2\2\2\u0085\3\2\2\2\2\u0087\3\2\2\2\2\u0089\3\2\2\2\2\u008b"+
		"\3\2\2\2\2\u008d\3\2\2\2\2\u008f\3\2\2\2\2\u0091\3\2\2\2\2\u0093\3\2\2"+
		"\2\2\u0095\3\2\2\2\2\u0097\3\2\2\2\2\u0099\3\2\2\2\2\u009b\3\2\2\2\2\u00a3"+
		"\3\2\2\2\2\u00a9\3\2\2\2\2\u00ab\3\2\2\2\2\u00ad\3\2\2\2\2\u00af\3\2\2"+
		"\2\3\u00b1\3\2\2\2\5\u00b8\3\2\2\2\7\u00ba\3\2\2\2\t\u00bc\3\2\2\2\13"+
		"\u00be\3\2\2\2\r\u00c0\3\2\2\2\17\u00c2\3\2\2\2\21\u00c4\3\2\2\2\23\u00cc"+
		"\3\2\2\2\25\u00d4\3\2\2\2\27\u00da\3\2\2\2\31\u00dc\3\2\2\2\33\u00de\3"+
		"\2\2\2\35\u00e4\3\2\2\2\37\u00eb\3\2\2\2!\u00f1\3\2\2\2#\u00fa\3\2\2\2"+
		"%\u0101\3\2\2\2\'\u0104\3\2\2\2)\u0109\3\2\2\2+\u010f\3\2\2\2-\u0112\3"+
		"\2\2\2/\u0116\3\2\2\2\61\u011d\3\2\2\2\63\u0121\3\2\2\2\65\u0124\3\2\2"+
		"\2\67\u012b\3\2\2\29\u012d\3\2\2\2;\u012f\3\2\2\2=\u0131\3\2\2\2?\u0134"+
		"\3\2\2\2A\u0137\3\2\2\2C\u0139\3\2\2\2E\u013b\3\2\2\2G\u013d\3\2\2\2I"+
		"\u013f\3\2\2\2K\u0141\3\2\2\2M\u0144\3\2\2\2O\u0147\3\2\2\2Q\u0149\3\2"+
		"\2\2S\u014b\3\2\2\2U\u014d\3\2\2\2W\u014f\3\2\2\2Y\u0152\3\2\2\2[\u0155"+
		"\3\2\2\2]\u0158\3\2\2\2_\u015b\3\2\2\2a\u015d\3\2\2\2c\u015f\3\2\2\2e"+
		"\u0162\3\2\2\2g\u0165\3\2\2\2i\u0168\3\2\2\2k\u016b\3\2\2\2m\u016e\3\2"+
		"\2\2o\u0171\3\2\2\2q\u0174\3\2\2\2s\u0178\3\2\2\2u\u017c\3\2\2\2w\u017f"+
		"\3\2\2\2y\u0182\3\2\2\2{\u0185\3\2\2\2}\u018b\3\2\2\2\177\u026b\3\2\2"+
		"\2\u0081\u026d\3\2\2\2\u0083\u028e\3\2\2\2\u0085\u0290\3\2\2\2\u0087\u029b"+
		"\3\2\2\2\u0089\u02ac\3\2\2\2\u008b\u02b0\3\2\2\2\u008d\u02b5\3\2\2\2\u008f"+
		"\u02bc\3\2\2\2\u0091\u02cd\3\2\2\2\u0093\u02db\3\2\2\2\u0095\u02ec\3\2"+
		"\2\2\u0097\u02fb\3\2\2\2\u0099\u02fe\3\2\2\2\u009b\u0307\3\2\2\2\u009d"+
		"\u030e\3\2\2\2\u009f\u0310\3\2\2\2\u00a1\u0312\3\2\2\2\u00a3\u0314\3\2"+
		"\2\2\u00a5\u031b\3\2\2\2\u00a7\u031d\3\2\2\2\u00a9\u031f\3\2\2\2\u00ab"+
		"\u032c\3\2\2\2\u00ad\u0332\3\2\2\2\u00af\u033d\3\2\2\2\u00b1\u00b2\7k"+
		"\2\2\u00b2\u00b3\7o\2\2\u00b3\u00b4\7r\2\2\u00b4\u00b5\7q\2\2\u00b5\u00b6"+
		"\7t\2\2\u00b6\u00b7\7v\2\2\u00b7\4\3\2\2\2\u00b8\u00b9\7?\2\2\u00b9\6"+
		"\3\2\2\2\u00ba\u00bb\7=\2\2\u00bb\b\3\2\2\2\u00bc\u00bd\7*\2\2\u00bd\n"+
		"\3\2\2\2\u00be\u00bf\7+\2\2\u00bf\f\3\2\2\2\u00c0\u00c1\7}\2\2\u00c1\16"+
		"\3\2\2\2\u00c2\u00c3\7\177\2\2\u00c3\20\3\2\2\2\u00c4\u00c5\7m\2\2\u00c5"+
		"\u00c6\7k\2\2\u00c6\u00c7\7e\2\2\u00c7\u00c8\7m\2\2\u00c8\u00c9\7c\2\2"+
		"\u00c9\u00ca\7u\2\2\u00ca\u00cb\7o\2\2\u00cb\22\3\2\2\2\u00cc\u00cd\7"+
		"e\2\2\u00cd\u00ce\7n\2\2\u00ce\u00cf\7q\2\2\u00cf\u00d0\7d\2\2\u00d0\u00d1"+
		"\7d\2\2\u00d1\u00d2\7g\2\2\u00d2\u00d3\7t\2\2\u00d3\24\3\2\2\2\u00d4\u00d5"+
		"\7r\2\2\u00d5\u00d6\7c\2\2\u00d6\u00d7\7t\2\2\u00d7\u00d8\7c\2\2\u00d8"+
		"\u00d9\7o\2\2\u00d9\26\3\2\2\2\u00da\u00db\7.\2\2\u00db\30\3\2\2\2\u00dc"+
		"\u00dd\7<\2\2\u00dd\32\3\2\2\2\u00de\u00df\7e\2\2\u00df\u00e0\7q\2\2\u00e0"+
		"\u00e1\7p\2\2\u00e1\u00e2\7u\2\2\u00e2\u00e3\7v\2\2\u00e3\34\3\2\2\2\u00e4"+
		"\u00e5\7g\2\2\u00e5\u00e6\7z\2\2\u00e6\u00e7\7v\2\2\u00e7\u00e8\7g\2\2"+
		"\u00e8\u00e9\7t\2\2\u00e9\u00ea\7p\2\2\u00ea\36\3\2\2\2\u00eb\u00ec\7"+
		"c\2\2\u00ec\u00ed\7n\2\2\u00ed\u00ee\7k\2\2\u00ee\u00ef\7i\2\2\u00ef\u00f0"+
		"\7p\2\2\u00f0 \3\2\2\2\u00f1\u00f2\7t\2\2\u00f2\u00f3\7g\2\2\u00f3\u00f4"+
		"\7i\2\2\u00f4\u00f5\7k\2\2\u00f5\u00f6\7u\2\2\u00f6\u00f7\7v\2\2\u00f7"+
		"\u00f8\7g\2\2\u00f8\u00f9\7t\2\2\u00f9\"\3\2\2\2\u00fa\u00fb\7k\2\2\u00fb"+
		"\u00fc\7p\2\2\u00fc\u00fd\7n\2\2\u00fd\u00fe\7k\2\2\u00fe\u00ff\7p\2\2"+
		"\u00ff\u0100\7g\2\2\u0100$\3\2\2\2\u0101\u0102\7k\2\2\u0102\u0103\7h\2"+
		"\2\u0103&\3\2\2\2\u0104\u0105\7g\2\2\u0105\u0106\7n\2\2\u0106\u0107\7"+
		"u\2\2\u0107\u0108\7g\2\2\u0108(\3\2\2\2\u0109\u010a\7y\2\2\u010a\u010b"+
		"\7j\2\2\u010b\u010c\7k\2\2\u010c\u010d\7n\2\2\u010d\u010e\7g\2\2\u010e"+
		"*\3\2\2\2\u010f\u0110\7f\2\2\u0110\u0111\7q\2\2\u0111,\3\2\2\2\u0112\u0113"+
		"\7h\2\2\u0113\u0114\7q\2\2\u0114\u0115\7t\2\2\u0115.\3\2\2\2\u0116\u0117"+
		"\7t\2\2\u0117\u0118\7g\2\2\u0118\u0119\7v\2\2\u0119\u011a\7w\2\2\u011a"+
		"\u011b\7t\2\2\u011b\u011c\7p\2\2\u011c\60\3\2\2\2\u011d\u011e\7c\2\2\u011e"+
		"\u011f\7u\2\2\u011f\u0120\7o\2\2\u0120\62\3\2\2\2\u0121\u0122\7\60\2\2"+
		"\u0122\u0123\7\60\2\2\u0123\64\3\2\2\2\u0124\u0125\7u\2\2\u0125\u0126"+
		"\7k\2\2\u0126\u0127\7i\2\2\u0127\u0128\7p\2\2\u0128\u0129\7g\2\2\u0129"+
		"\u012a\7f\2\2\u012a\66\3\2\2\2\u012b\u012c\7,\2\2\u012c8\3\2\2\2\u012d"+
		"\u012e\7]\2\2\u012e:\3\2\2\2\u012f\u0130\7_\2\2\u0130<\3\2\2\2\u0131\u0132"+
		"\7/\2\2\u0132\u0133\7/\2\2\u0133>\3\2\2\2\u0134\u0135\7-\2\2\u0135\u0136"+
		"\7-\2\2\u0136@\3\2\2\2\u0137\u0138\7-\2\2\u0138B\3\2\2\2\u0139\u013a\7"+
		"/\2\2\u013aD\3\2\2\2\u013b\u013c\7#\2\2\u013cF\3\2\2\2\u013d\u013e\7("+
		"\2\2\u013eH\3\2\2\2\u013f\u0140\7\u0080\2\2\u0140J\3\2\2\2\u0141\u0142"+
		"\7@\2\2\u0142\u0143\7@\2\2\u0143L\3\2\2\2\u0144\u0145\7>\2\2\u0145\u0146"+
		"\7>\2\2\u0146N\3\2\2\2\u0147\u0148\7\61\2\2\u0148P\3\2\2\2\u0149\u014a"+
		"\7\'\2\2\u014aR\3\2\2\2\u014b\u014c\7>\2\2\u014cT\3\2\2\2\u014d\u014e"+
		"\7@\2\2\u014eV\3\2\2\2\u014f\u0150\7?\2\2\u0150\u0151\7?\2\2\u0151X\3"+
		"\2\2\2\u0152\u0153\7#\2\2\u0153\u0154\7?\2\2\u0154Z\3\2\2\2\u0155\u0156"+
		"\7>\2\2\u0156\u0157\7?\2\2\u0157\\\3\2\2\2\u0158\u0159\7@\2\2\u0159\u015a"+
		"\7?\2\2\u015a^\3\2\2\2\u015b\u015c\7`\2\2\u015c`\3\2\2\2\u015d\u015e\7"+
		"~\2\2\u015eb\3\2\2\2\u015f\u0160\7(\2\2\u0160\u0161\7(\2\2\u0161d\3\2"+
		"\2\2\u0162\u0163\7~\2\2\u0163\u0164\7~\2\2\u0164f\3\2\2\2\u0165\u0166"+
		"\7-\2\2\u0166\u0167\7?\2\2\u0167h\3\2\2\2\u0168\u0169\7/\2\2\u0169\u016a"+
		"\7?\2\2\u016aj\3\2\2\2\u016b\u016c\7,\2\2\u016c\u016d\7?\2\2\u016dl\3"+
		"\2\2\2\u016e\u016f\7\61\2\2\u016f\u0170\7?\2\2\u0170n\3\2\2\2\u0171\u0172"+
		"\7\'\2\2\u0172\u0173\7?\2\2\u0173p\3\2\2\2\u0174\u0175\7>\2\2\u0175\u0176"+
		"\7>\2\2\u0176\u0177\7?\2\2\u0177r\3\2\2\2\u0178\u0179\7@\2\2\u0179\u017a"+
		"\7@\2\2\u017a\u017b\7?\2\2\u017bt\3\2\2\2\u017c\u017d\7(\2\2\u017d\u017e"+
		"\7?\2\2\u017ev\3\2\2\2\u017f\u0180\7~\2\2\u0180\u0181\7?\2\2\u0181x\3"+
		"\2\2\2\u0182\u0183\7`\2\2\u0183\u0184\7?\2\2\u0184z\3\2\2\2\u0185\u0186"+
		"\7\60\2\2\u0186\u0187\7d\2\2\u0187\u0188\7{\2\2\u0188\u0189\7v\2\2\u0189"+
		"\u018a\7g\2\2\u018a|\3\2\2\2\u018b\u018c\7%\2\2\u018c~\3\2\2\2\u018d\u018e"+
		"\7d\2\2\u018e\u018f\7t\2\2\u018f\u026c\7m\2\2\u0190\u0191\7q\2\2\u0191"+
		"\u0192\7t\2\2\u0192\u026c\7c\2\2\u0193\u0194\7m\2\2\u0194\u0195\7k\2\2"+
		"\u0195\u026c\7n\2\2\u0196\u0197\7u\2\2\u0197\u0198\7n\2\2\u0198\u026c"+
		"\7q\2\2\u0199\u019a\7p\2\2\u019a\u019b\7q\2\2\u019b\u026c\7r\2\2\u019c"+
		"\u019d\7c\2\2\u019d\u019e\7u\2\2\u019e\u026c\7n\2\2\u019f\u01a0\7r\2\2"+
		"\u01a0\u01a1\7j\2\2\u01a1\u026c\7r\2\2\u01a2\u01a3\7c\2\2\u01a3\u01a4"+
		"\7p\2\2\u01a4\u026c\7e\2\2\u01a5\u01a6\7d\2\2\u01a6\u01a7\7r\2\2\u01a7"+
		"\u026c\7n\2\2\u01a8\u01a9\7e\2\2\u01a9\u01aa\7n\2\2\u01aa\u026c\7e\2\2"+
		"\u01ab\u01ac\7l\2\2\u01ac\u01ad\7u\2\2\u01ad\u026c\7t\2\2\u01ae\u01af"+
		"\7c\2\2\u01af\u01b0\7p\2\2\u01b0\u026c\7f\2\2\u01b1\u01b2\7t\2\2\u01b2"+
		"\u01b3\7n\2\2\u01b3\u026c\7c\2\2\u01b4\u01b5\7d\2\2\u01b5\u01b6\7k\2\2"+
		"\u01b6\u026c\7v\2\2\u01b7\u01b8\7t\2\2\u01b8\u01b9\7q\2\2\u01b9\u026c"+
		"\7n\2\2\u01ba\u01bb\7r\2\2\u01bb\u01bc\7n\2\2\u01bc\u026c\7c\2\2\u01bd"+
		"\u01be\7r\2\2\u01be\u01bf\7n\2\2\u01bf\u026c\7r\2\2\u01c0\u01c1\7d\2\2"+
		"\u01c1\u01c2\7o\2\2\u01c2\u026c\7k\2\2\u01c3\u01c4\7u\2\2\u01c4\u01c5"+
		"\7g\2\2\u01c5\u026c\7e\2\2\u01c6\u01c7\7t\2\2\u01c7\u01c8\7v\2\2\u01c8"+
		"\u026c\7k\2\2\u01c9\u01ca\7g\2\2\u01ca\u01cb\7q\2\2\u01cb\u026c\7t\2\2"+
		"\u01cc\u01cd\7u\2\2\u01cd\u01ce\7t\2\2\u01ce\u026c\7g\2\2\u01cf\u01d0"+
		"\7n\2\2\u01d0\u01d1\7u\2\2\u01d1\u026c\7t\2\2\u01d2\u01d3\7r\2\2\u01d3"+
		"\u01d4\7j\2\2\u01d4\u026c\7c\2\2\u01d5\u01d6\7c\2\2\u01d6\u01d7\7n\2\2"+
		"\u01d7\u026c\7t\2\2\u01d8\u01d9\7l\2\2\u01d9\u01da\7o\2\2\u01da\u026c"+
		"\7r\2\2\u01db\u01dc\7d\2\2\u01dc\u01dd\7x\2\2\u01dd\u026c\7e\2\2\u01de"+
		"\u01df\7e\2\2\u01df\u01e0\7n\2\2\u01e0\u026c\7k\2\2\u01e1\u01e2\7t\2\2"+
		"\u01e2\u01e3\7v\2\2\u01e3\u026c\7u\2\2\u01e4\u01e5\7c\2\2\u01e5\u01e6"+
		"\7f\2\2\u01e6\u026c\7e\2\2\u01e7\u01e8\7t\2\2\u01e8\u01e9\7t\2\2\u01e9"+
		"\u026c\7c\2\2\u01ea\u01eb\7d\2\2\u01eb\u01ec\7x\2\2\u01ec\u026c\7u\2\2"+
		"\u01ed\u01ee\7u\2\2\u01ee\u01ef\7g\2\2\u01ef\u026c\7k\2\2\u01f0\u01f1"+
		"\7u\2\2\u01f1\u01f2\7c\2\2\u01f2\u026c\7z\2\2\u01f3\u01f4\7u\2\2\u01f4"+
		"\u01f5\7v\2\2\u01f5\u026c\7{\2\2\u01f6\u01f7\7u\2\2\u01f7\u01f8\7v\2\2"+
		"\u01f8\u026c\7c\2\2\u01f9\u01fa\7u\2\2\u01fa\u01fb\7v\2\2\u01fb\u026c"+
		"\7z\2\2\u01fc\u01fd\7f\2\2\u01fd\u01fe\7g\2\2\u01fe\u026c\7{\2\2\u01ff"+
		"\u0200\7v\2\2\u0200\u0201\7z\2\2\u0201\u026c\7c\2\2\u0202\u0203\7z\2\2"+
		"\u0203\u0204\7c\2\2\u0204\u026c\7c\2\2\u0205\u0206\7d\2\2\u0206\u0207"+
		"\7e\2\2\u0207\u026c\7e\2\2\u0208\u0209\7c\2\2\u0209\u020a\7j\2\2\u020a"+
		"\u026c\7z\2\2\u020b\u020c\7v\2\2\u020c\u020d\7{\2\2\u020d\u026c\7c\2\2"+
		"\u020e\u020f\7v\2\2\u020f\u0210\7z\2\2\u0210\u026c\7u\2\2\u0211\u0212"+
		"\7v\2\2\u0212\u0213\7c\2\2\u0213\u026c\7u\2\2\u0214\u0215\7u\2\2\u0215"+
		"\u0216\7j\2\2\u0216\u026c\7{\2\2\u0217\u0218\7u\2\2\u0218\u0219\7j\2\2"+
		"\u0219\u026c\7z\2\2\u021a\u021b\7n\2\2\u021b\u021c\7f\2\2\u021c\u026c"+
		"\7{\2\2\u021d\u021e\7n\2\2\u021e\u021f\7f\2\2\u021f\u026c\7c\2\2\u0220"+
		"\u0221\7n\2\2\u0221\u0222\7f\2\2\u0222\u026c\7z\2\2\u0223\u0224\7n\2\2"+
		"\u0224\u0225\7c\2\2\u0225\u026c\7z\2\2\u0226\u0227\7v\2\2\u0227\u0228"+
		"\7c\2\2\u0228\u026c\7{\2\2\u0229\u022a\7v\2\2\u022a\u022b\7c\2\2\u022b"+
		"\u026c\7z\2\2\u022c\u022d\7d\2\2\u022d\u022e\7e\2\2\u022e\u026c\7u\2\2"+
		"\u022f\u0230\7e\2\2\u0230\u0231\7n\2\2\u0231\u026c\7x\2\2\u0232\u0233"+
		"\7v\2\2\u0233\u0234\7u\2\2\u0234\u026c\7z\2\2\u0235\u0236\7n\2\2\u0236"+
		"\u0237\7c\2\2\u0237\u026c\7u\2\2\u0238\u0239\7e\2\2\u0239\u023a\7r\2\2"+
		"\u023a\u026c\7{\2\2\u023b\u023c\7e\2\2\u023c\u023d\7o\2\2\u023d\u026c"+
		"\7r\2\2\u023e\u023f\7e\2\2\u023f\u0240\7r\2\2\u0240\u026c\7z\2\2\u0241"+
		"\u0242\7f\2\2\u0242\u0243\7e\2\2\u0243\u026c\7r\2\2\u0244\u0245\7f\2\2"+
		"\u0245\u0246\7g\2\2\u0246\u026c\7e\2\2\u0247\u0248\7k\2\2\u0248\u0249"+
		"\7p\2\2\u0249\u026c\7e\2\2\u024a\u024b\7c\2\2\u024b\u024c\7z\2\2\u024c"+
		"\u026c\7u\2\2\u024d\u024e\7d\2\2\u024e\u024f\7p\2\2\u024f\u026c\7g\2\2"+
		"\u0250\u0251\7e\2\2\u0251\u0252\7n\2\2\u0252\u026c\7f\2\2\u0253\u0254"+
		"\7u\2\2\u0254\u0255\7d\2\2\u0255\u026c\7e\2\2\u0256\u0257\7k\2\2\u0257"+
		"\u0258\7u\2\2\u0258\u026c\7e\2\2\u0259\u025a\7k\2\2\u025a\u025b\7p\2\2"+
		"\u025b\u026c\7z\2\2\u025c\u025d\7d\2\2\u025d\u025e\7g\2\2\u025e\u026c"+
		"\7s\2\2\u025f\u0260\7u\2\2\u0260\u0261\7g\2\2\u0261\u026c\7f\2\2\u0262"+
		"\u0263\7f\2\2\u0263\u0264\7g\2\2\u0264\u026c\7z\2\2\u0265\u0266\7k\2\2"+
		"\u0266\u0267\7p\2\2\u0267\u026c\7{\2\2\u0268\u0269\7t\2\2\u0269\u026a"+
		"\7q\2\2\u026a\u026c\7t\2\2\u026b\u018d\3\2\2\2\u026b\u0190\3\2\2\2\u026b"+
		"\u0193\3\2\2\2\u026b\u0196\3\2\2\2\u026b\u0199\3\2\2\2\u026b\u019c\3\2"+
		"\2\2\u026b\u019f\3\2\2\2\u026b\u01a2\3\2\2\2\u026b\u01a5\3\2\2\2\u026b"+
		"\u01a8\3\2\2\2\u026b\u01ab\3\2\2\2\u026b\u01ae\3\2\2\2\u026b\u01b1\3\2"+
		"\2\2\u026b\u01b4\3\2\2\2\u026b\u01b7\3\2\2\2\u026b\u01ba\3\2\2\2\u026b"+
		"\u01bd\3\2\2\2\u026b\u01c0\3\2\2\2\u026b\u01c3\3\2\2\2\u026b\u01c6\3\2"+
		"\2\2\u026b\u01c9\3\2\2\2\u026b\u01cc\3\2\2\2\u026b\u01cf\3\2\2\2\u026b"+
		"\u01d2\3\2\2\2\u026b\u01d5\3\2\2\2\u026b\u01d8\3\2\2\2\u026b\u01db\3\2"+
		"\2\2\u026b\u01de\3\2\2\2\u026b\u01e1\3\2\2\2\u026b\u01e4\3\2\2\2\u026b"+
		"\u01e7\3\2\2\2\u026b\u01ea\3\2\2\2\u026b\u01ed\3\2\2\2\u026b\u01f0\3\2"+
		"\2\2\u026b\u01f3\3\2\2\2\u026b\u01f6\3\2\2\2\u026b\u01f9\3\2\2\2\u026b"+
		"\u01fc\3\2\2\2\u026b\u01ff\3\2\2\2\u026b\u0202\3\2\2\2\u026b\u0205\3\2"+
		"\2\2\u026b\u0208\3\2\2\2\u026b\u020b\3\2\2\2\u026b\u020e\3\2\2\2\u026b"+
		"\u0211\3\2\2\2\u026b\u0214\3\2\2\2\u026b\u0217\3\2\2\2\u026b\u021a\3\2"+
		"\2\2\u026b\u021d\3\2\2\2\u026b\u0220\3\2\2\2\u026b\u0223\3\2\2\2\u026b"+
		"\u0226\3\2\2\2\u026b\u0229\3\2\2\2\u026b\u022c\3\2\2\2\u026b\u022f\3\2"+
		"\2\2\u026b\u0232\3\2\2\2\u026b\u0235\3\2\2\2\u026b\u0238\3\2\2\2\u026b"+
		"\u023b\3\2\2\2\u026b\u023e\3\2\2\2\u026b\u0241\3\2\2\2\u026b\u0244\3\2"+
		"\2\2\u026b\u0247\3\2\2\2\u026b\u024a\3\2\2\2\u026b\u024d\3\2\2\2\u026b"+
		"\u0250\3\2\2\2\u026b\u0253\3\2\2\2\u026b\u0256\3\2\2\2\u026b\u0259\3\2"+
		"\2\2\u026b\u025c\3\2\2\2\u026b\u025f\3\2\2\2\u026b\u0262\3\2\2\2\u026b"+
		"\u0265\3\2\2\2\u026b\u0268\3\2\2\2\u026c\u0080\3\2\2\2\u026d\u026e\7}"+
		"\2\2\u026e\u026f\7}\2\2\u026f\u0273\3\2\2\2\u0270\u0272\13\2\2\2\u0271"+
		"\u0270\3\2\2\2\u0272\u0275\3\2\2\2\u0273\u0274\3\2\2\2\u0273\u0271\3\2"+
		"\2\2\u0274\u0276\3\2\2\2\u0275\u0273\3\2\2\2\u0276\u0277\7\177\2\2\u0277"+
		"\u0278\7\177\2\2\u0278\u0082\3\2\2\2\u0279\u027a\7d\2\2\u027a\u027b\7"+
		"{\2\2\u027b\u027c\7v\2\2\u027c\u028f\7g\2\2\u027d\u027e\7y\2\2\u027e\u027f"+
		"\7q\2\2\u027f\u0280\7t\2\2\u0280\u028f\7f\2\2\u0281\u0282\7f\2\2\u0282"+
		"\u0283\7y\2\2\u0283\u0284\7q\2\2\u0284\u0285\7t\2\2\u0285\u028f\7f\2\2"+
		"\u0286\u0287\7d\2\2\u0287\u0288\7q\2\2\u0288\u0289\7q\2\2\u0289\u028f"+
		"\7n\2\2\u028a\u028b\7x\2\2\u028b\u028c\7q\2\2\u028c\u028d\7k\2\2\u028d"+
		"\u028f\7f\2\2\u028e\u0279\3\2\2\2\u028e\u027d\3\2\2\2\u028e\u0281\3\2"+
		"\2\2\u028e\u0286\3\2\2\2\u028e\u028a\3\2\2\2\u028f\u0084\3\2\2\2\u0290"+
		"\u0296\7$\2\2\u0291\u0292\7^\2\2\u0292\u0295\7$\2\2\u0293\u0295\n\2\2"+
		"\2\u0294\u0291\3\2\2\2\u0294\u0293\3\2\2\2\u0295\u0298\3\2\2\2\u0296\u0294"+
		"\3\2\2\2\u0296\u0297\3\2\2\2\u0297\u0299\3\2\2\2\u0298\u0296\3\2\2\2\u0299"+
		"\u029a\7$\2\2\u029a\u0086\3\2\2\2\u029b\u029f\7)\2\2\u029c\u029d\7^\2"+
		"\2\u029d\u02a0\7)\2\2\u029e\u02a0\n\3\2\2\u029f\u029c\3\2\2\2\u029f\u029e"+
		"\3\2\2\2\u02a0\u02a1\3\2\2\2\u02a1\u02a2\7)\2\2\u02a2\u0088\3\2\2\2\u02a3"+
		"\u02a4\7v\2\2\u02a4\u02a5\7t\2\2\u02a5\u02a6\7w\2\2\u02a6\u02ad\7g\2\2"+
		"\u02a7\u02a8\7h\2\2\u02a8\u02a9\7c\2\2\u02a9\u02aa\7n\2\2\u02aa\u02ab"+
		"\7u\2\2\u02ab\u02ad\7g\2\2\u02ac\u02a3\3\2\2\2\u02ac\u02a7\3\2\2\2\u02ad"+
		"\u008a\3\2\2\2\u02ae\u02b1\5\u008dG\2\u02af\u02b1\5\u0095K\2\u02b0\u02ae"+
		"\3\2\2\2\u02b0\u02af\3\2\2\2\u02b1\u008c\3\2\2\2\u02b2\u02b6\5\u008fH"+
		"\2\u02b3\u02b6\5\u0091I\2\u02b4\u02b6\5\u0093J\2\u02b5\u02b2\3\2\2\2\u02b5"+
		"\u02b3\3\2\2\2\u02b5\u02b4\3\2\2\2\u02b6\u008e\3\2\2\2\u02b7\u02bd\7\'"+
		"\2\2\u02b8\u02b9\7\62\2\2\u02b9\u02bd\7d\2\2\u02ba\u02bb\7\62\2\2\u02bb"+
		"\u02bd\7D\2\2\u02bc\u02b7\3\2\2\2\u02bc\u02b8\3\2\2\2\u02bc\u02ba\3\2"+
		"\2\2\u02bd\u02c1\3\2\2\2\u02be\u02c0\5\u009dO\2\u02bf\u02be\3\2\2\2\u02c0"+
		"\u02c3\3\2\2\2\u02c1\u02bf\3\2\2\2\u02c1\u02c2\3\2\2\2\u02c2\u02c4\3\2"+
		"\2\2\u02c3\u02c1\3\2\2\2\u02c4\u02c6\7\60\2\2\u02c5\u02c7\5\u009dO\2\u02c6"+
		"\u02c5\3\2\2\2\u02c7\u02c8\3\2\2\2\u02c8\u02c6\3\2\2\2\u02c8\u02c9\3\2"+
		"\2\2\u02c9\u0090\3\2\2\2\u02ca\u02cc\5\u009fP\2\u02cb\u02ca\3\2\2\2\u02cc"+
		"\u02cf\3\2\2\2\u02cd\u02cb\3\2\2\2\u02cd\u02ce\3\2\2\2\u02ce\u02d0\3\2"+
		"\2\2\u02cf\u02cd\3\2\2\2\u02d0\u02d2\7\60\2\2\u02d1\u02d3\5\u009fP\2\u02d2"+
		"\u02d1\3\2\2\2\u02d3\u02d4\3\2\2\2\u02d4\u02d2\3\2\2\2\u02d4\u02d5\3\2"+
		"\2\2\u02d5\u0092\3\2\2\2\u02d6\u02dc\7&\2\2\u02d7\u02d8\7\62\2\2\u02d8"+
		"\u02dc\7z\2\2\u02d9\u02da\7\62\2\2\u02da\u02dc\7Z\2\2\u02db\u02d6\3\2"+
		"\2\2\u02db\u02d7\3\2\2\2\u02db\u02d9\3\2\2\2\u02dc\u02e0\3\2\2\2\u02dd"+
		"\u02df\5\u00a1Q\2\u02de\u02dd\3\2\2\2\u02df\u02e2\3\2\2\2\u02e0\u02de"+
		"\3\2\2\2\u02e0\u02e1\3\2\2\2\u02e1\u02e3\3\2\2\2\u02e2\u02e0\3\2\2\2\u02e3"+
		"\u02e5\7\60\2\2\u02e4\u02e6\5\u00a1Q\2\u02e5\u02e4\3\2\2\2\u02e6\u02e7"+
		"\3\2\2\2\u02e7\u02e5\3\2\2\2\u02e7\u02e8\3\2\2\2\u02e8\u0094\3\2\2\2\u02e9"+
		"\u02ed\5\u0099M\2\u02ea\u02ed\5\u009bN\2\u02eb\u02ed\5\u0097L\2\u02ec"+
		"\u02e9\3\2\2\2\u02ec\u02ea\3\2\2\2\u02ec\u02eb\3\2\2\2\u02ed\u0096\3\2"+
		"\2\2\u02ee\u02ef\7\62\2\2\u02ef\u02f1\t\4\2\2\u02f0\u02f2\5\u009dO\2\u02f1"+
		"\u02f0\3\2\2\2\u02f2\u02f3\3\2\2\2\u02f3\u02f1\3\2\2\2\u02f3\u02f4\3\2"+
		"\2\2\u02f4\u02fc\3\2\2\2\u02f5\u02f7\7\'\2\2\u02f6\u02f8\5\u009dO\2\u02f7"+
		"\u02f6\3\2\2\2\u02f8\u02f9\3\2\2\2\u02f9\u02f7\3\2\2\2\u02f9\u02fa\3\2"+
		"\2\2\u02fa\u02fc\3\2\2\2\u02fb\u02ee\3\2\2\2\u02fb\u02f5\3\2\2\2\u02fc"+
		"\u0098\3\2\2\2\u02fd\u02ff\5\u009fP\2\u02fe\u02fd\3\2\2\2\u02ff\u0300"+
		"\3\2\2\2\u0300\u02fe\3\2\2\2\u0300\u0301\3\2\2\2\u0301\u009a\3\2\2\2\u0302"+
		"\u0308\7&\2\2\u0303\u0304\7\62\2\2\u0304\u0308\7z\2\2\u0305\u0306\7\62"+
		"\2\2\u0306\u0308\7Z\2\2\u0307\u0302\3\2\2\2\u0307\u0303\3\2\2\2\u0307"+
		"\u0305\3\2\2\2\u0308\u030a\3\2\2\2\u0309\u030b\5\u00a1Q\2\u030a\u0309"+
		"\3\2\2\2\u030b\u030c\3\2\2\2\u030c\u030a\3\2\2\2\u030c\u030d\3\2\2\2\u030d"+
		"\u009c\3\2\2\2\u030e\u030f\t\5\2\2\u030f\u009e\3\2\2\2\u0310\u0311\t\6"+
		"\2\2\u0311\u00a0\3\2\2\2\u0312\u0313\t\7\2\2\u0313\u00a2\3\2\2\2\u0314"+
		"\u0318\5\u00a5S\2\u0315\u0317\5\u00a7T\2\u0316\u0315\3\2\2\2\u0317\u031a"+
		"\3\2\2\2\u0318\u0316\3\2\2\2\u0318\u0319\3\2\2\2\u0319\u00a4\3\2\2\2\u031a"+
		"\u0318\3\2\2\2\u031b\u031c\t\b\2\2\u031c\u00a6\3\2\2\2\u031d\u031e\t\t"+
		"\2\2\u031e\u00a8\3\2\2\2\u031f\u0323\7#\2\2\u0320\u0322\5\u00a7T\2\u0321"+
		"\u0320\3\2\2\2\u0322\u0325\3\2\2\2\u0323\u0321\3\2\2\2\u0323\u0324\3\2"+
		"\2\2\u0324\u0327\3\2\2\2\u0325\u0323\3\2\2\2\u0326\u0328\t\n\2\2\u0327"+
		"\u0326\3\2\2\2\u0328\u0329\3\2\2\2\u0329\u0327\3\2\2\2\u0329\u032a\3\2"+
		"\2\2\u032a\u00aa\3\2\2\2\u032b\u032d\t\13\2\2\u032c\u032b\3\2\2\2\u032d"+
		"\u032e\3\2\2\2\u032e\u032c\3\2\2\2\u032e\u032f\3\2\2\2\u032f\u0330\3\2"+
		"\2\2\u0330\u0331\bV\2\2\u0331\u00ac\3\2\2\2\u0332\u0333\7\61\2\2\u0333"+
		"\u0334\7\61\2\2\u0334\u0338\3\2\2\2\u0335\u0337\n\f\2\2\u0336\u0335\3"+
		"\2\2\2\u0337\u033a\3\2\2\2\u0338\u0336\3\2\2\2\u0338\u0339\3\2\2\2\u0339"+
		"\u033b\3\2\2\2\u033a\u0338\3\2\2\2\u033b\u033c\bW\2\2\u033c\u00ae\3\2"+
		"\2\2\u033d\u033e\7\61\2\2\u033e\u033f\7,\2\2\u033f\u0343\3\2\2\2\u0340"+
		"\u0342\13\2\2\2\u0341\u0340\3\2\2\2\u0342\u0345\3\2\2\2\u0343\u0344\3"+
		"\2\2\2\u0343\u0341\3\2\2\2\u0344\u0346\3\2\2\2\u0345\u0343\3\2\2\2\u0346"+
		"\u0347\7,\2\2\u0347\u0348\7\61\2\2\u0348\u0349\3\2\2\2\u0349\u034a\bX"+
		"\2\2\u034a\u00b0\3\2\2\2!\2\u026b\u0273\u028e\u0294\u0296\u029f\u02ac"+
		"\u02b0\u02b5\u02bc\u02c1\u02c8\u02cd\u02d4\u02db\u02e0\u02e7\u02ec\u02f3"+
		"\u02f9\u02fb\u0300\u0307\u030c\u0318\u0323\u0329\u032e\u0338\u0343\3\b"+
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
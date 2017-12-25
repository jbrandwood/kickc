// Generated from /Users/jespergravgaard/c64/src/kickc/src/main/java/dk/camelot64/kickc/parser/KickC.g4 by ANTLR 4.7
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
		T__45=46, T__46=47, MNEMONIC=48, SIMPLETYPE=49, STRING=50, CHAR=51, BOOLEAN=52, 
		NUMBER=53, NUMFLOAT=54, BINFLOAT=55, DECFLOAT=56, HEXFLOAT=57, NUMINT=58, 
		BININTEGER=59, DECINTEGER=60, HEXINTEGER=61, NAME=62, ASMREL=63, WS=64, 
		COMMENT_LINE=65, COMMENT_BLOCK=66;
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
		"T__41", "T__42", "T__43", "T__44", "T__45", "T__46", "MNEMONIC", "SIMPLETYPE", 
		"STRING", "CHAR", "BOOLEAN", "NUMBER", "NUMFLOAT", "BINFLOAT", "DECFLOAT", 
		"HEXFLOAT", "NUMINT", "BININTEGER", "DECINTEGER", "HEXINTEGER", "BINDIGIT", 
		"DECDIGIT", "HEXDIGIT", "NAME", "NAME_START", "NAME_CHAR", "ASMREL", "WS", 
		"COMMENT_LINE", "COMMENT_BLOCK"
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
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\2D\u02c5\b\1\4\2\t"+
		"\2\4\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n\t\n\4\13"+
		"\t\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\4\20\t\20\4\21\t\21\4\22\t\22"+
		"\4\23\t\23\4\24\t\24\4\25\t\25\4\26\t\26\4\27\t\27\4\30\t\30\4\31\t\31"+
		"\4\32\t\32\4\33\t\33\4\34\t\34\4\35\t\35\4\36\t\36\4\37\t\37\4 \t \4!"+
		"\t!\4\"\t\"\4#\t#\4$\t$\4%\t%\4&\t&\4\'\t\'\4(\t(\4)\t)\4*\t*\4+\t+\4"+
		",\t,\4-\t-\4.\t.\4/\t/\4\60\t\60\4\61\t\61\4\62\t\62\4\63\t\63\4\64\t"+
		"\64\4\65\t\65\4\66\t\66\4\67\t\67\48\t8\49\t9\4:\t:\4;\t;\4<\t<\4=\t="+
		"\4>\t>\4?\t?\4@\t@\4A\tA\4B\tB\4C\tC\4D\tD\4E\tE\4F\tF\4G\tG\4H\tH\3\2"+
		"\3\2\3\2\3\2\3\2\3\2\3\2\3\3\3\3\3\4\3\4\3\5\3\5\3\6\3\6\3\7\3\7\3\b\3"+
		"\b\3\b\3\b\3\b\3\b\3\t\3\t\3\n\3\n\3\13\3\13\3\13\3\f\3\f\3\f\3\f\3\f"+
		"\3\r\3\r\3\r\3\r\3\r\3\r\3\16\3\16\3\16\3\17\3\17\3\17\3\17\3\20\3\20"+
		"\3\20\3\20\3\20\3\20\3\20\3\21\3\21\3\21\3\21\3\22\3\22\3\23\3\23\3\23"+
		"\3\24\3\24\3\24\3\24\3\24\3\24\3\24\3\25\3\25\3\26\3\26\3\27\3\27\3\30"+
		"\3\30\3\31\3\31\3\32\3\32\3\32\3\33\3\33\3\33\3\34\3\34\3\35\3\35\3\36"+
		"\3\36\3\37\3\37\3 \3 \3!\3!\3!\3\"\3\"\3\"\3#\3#\3$\3$\3%\3%\3%\3&\3&"+
		"\3&\3\'\3\'\3\'\3(\3(\3(\3)\3)\3)\3*\3*\3*\3+\3+\3+\3,\3,\3-\3-\3.\3."+
		"\3.\3/\3/\3/\3\60\3\60\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3"+
		"\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3"+
		"\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3"+
		"\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3"+
		"\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3"+
		"\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3"+
		"\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3"+
		"\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3"+
		"\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3"+
		"\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3"+
		"\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3"+
		"\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3"+
		"\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3"+
		"\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3"+
		"\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3"+
		"\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\5"+
		"\61\u01f9\n\61\3\62\3\62\3\62\3\62\3\62\3\62\3\62\3\62\3\62\3\62\3\62"+
		"\3\62\3\62\3\62\3\62\3\62\3\62\3\62\3\62\5\62\u020e\n\62\3\63\3\63\3\63"+
		"\3\63\7\63\u0214\n\63\f\63\16\63\u0217\13\63\3\63\3\63\3\64\3\64\3\64"+
		"\3\64\5\64\u021f\n\64\3\64\3\64\3\65\3\65\3\65\3\65\3\65\3\65\3\65\3\65"+
		"\3\65\5\65\u022c\n\65\3\66\3\66\5\66\u0230\n\66\3\67\3\67\3\67\5\67\u0235"+
		"\n\67\38\38\38\38\38\58\u023c\n8\38\78\u023f\n8\f8\168\u0242\138\38\3"+
		"8\68\u0246\n8\r8\168\u0247\39\79\u024b\n9\f9\169\u024e\139\39\39\69\u0252"+
		"\n9\r9\169\u0253\3:\3:\3:\3:\3:\5:\u025b\n:\3:\7:\u025e\n:\f:\16:\u0261"+
		"\13:\3:\3:\6:\u0265\n:\r:\16:\u0266\3;\3;\3;\5;\u026c\n;\3<\3<\3<\6<\u0271"+
		"\n<\r<\16<\u0272\3<\3<\6<\u0277\n<\r<\16<\u0278\5<\u027b\n<\3=\6=\u027e"+
		"\n=\r=\16=\u027f\3>\3>\3>\3>\3>\5>\u0287\n>\3>\6>\u028a\n>\r>\16>\u028b"+
		"\3?\3?\3@\3@\3A\3A\3B\3B\7B\u0296\nB\fB\16B\u0299\13B\3C\3C\3D\3D\3E\3"+
		"E\7E\u02a1\nE\fE\16E\u02a4\13E\3F\6F\u02a7\nF\rF\16F\u02a8\3F\3F\3G\3"+
		"G\3G\3G\7G\u02b1\nG\fG\16G\u02b4\13G\3G\3G\3H\3H\3H\3H\7H\u02bc\nH\fH"+
		"\16H\u02bf\13H\3H\3H\3H\3H\3H\3\u02bd\2I\3\3\5\4\7\5\t\6\13\7\r\b\17\t"+
		"\21\n\23\13\25\f\27\r\31\16\33\17\35\20\37\21!\22#\23%\24\'\25)\26+\27"+
		"-\30/\31\61\32\63\33\65\34\67\359\36;\37= ?!A\"C#E$G%I&K\'M(O)Q*S+U,W"+
		"-Y.[/]\60_\61a\62c\63e\64g\65i\66k\67m8o9q:s;u<w=y>{?}\2\177\2\u0081\2"+
		"\u0083@\u0085\2\u0087\2\u0089A\u008bB\u008dC\u008fD\3\2\r\3\2$$\3\2))"+
		"\4\2DDdd\3\2\62\63\3\2\62;\5\2\62;CHch\5\2C\\aac|\6\2\62;C\\aac|\4\2-"+
		"-//\5\2\13\f\17\17\"\"\4\2\f\f\17\17\2\u0329\2\3\3\2\2\2\2\5\3\2\2\2\2"+
		"\7\3\2\2\2\2\t\3\2\2\2\2\13\3\2\2\2\2\r\3\2\2\2\2\17\3\2\2\2\2\21\3\2"+
		"\2\2\2\23\3\2\2\2\2\25\3\2\2\2\2\27\3\2\2\2\2\31\3\2\2\2\2\33\3\2\2\2"+
		"\2\35\3\2\2\2\2\37\3\2\2\2\2!\3\2\2\2\2#\3\2\2\2\2%\3\2\2\2\2\'\3\2\2"+
		"\2\2)\3\2\2\2\2+\3\2\2\2\2-\3\2\2\2\2/\3\2\2\2\2\61\3\2\2\2\2\63\3\2\2"+
		"\2\2\65\3\2\2\2\2\67\3\2\2\2\29\3\2\2\2\2;\3\2\2\2\2=\3\2\2\2\2?\3\2\2"+
		"\2\2A\3\2\2\2\2C\3\2\2\2\2E\3\2\2\2\2G\3\2\2\2\2I\3\2\2\2\2K\3\2\2\2\2"+
		"M\3\2\2\2\2O\3\2\2\2\2Q\3\2\2\2\2S\3\2\2\2\2U\3\2\2\2\2W\3\2\2\2\2Y\3"+
		"\2\2\2\2[\3\2\2\2\2]\3\2\2\2\2_\3\2\2\2\2a\3\2\2\2\2c\3\2\2\2\2e\3\2\2"+
		"\2\2g\3\2\2\2\2i\3\2\2\2\2k\3\2\2\2\2m\3\2\2\2\2o\3\2\2\2\2q\3\2\2\2\2"+
		"s\3\2\2\2\2u\3\2\2\2\2w\3\2\2\2\2y\3\2\2\2\2{\3\2\2\2\2\u0083\3\2\2\2"+
		"\2\u0089\3\2\2\2\2\u008b\3\2\2\2\2\u008d\3\2\2\2\2\u008f\3\2\2\2\3\u0091"+
		"\3\2\2\2\5\u0098\3\2\2\2\7\u009a\3\2\2\2\t\u009c\3\2\2\2\13\u009e\3\2"+
		"\2\2\r\u00a0\3\2\2\2\17\u00a2\3\2\2\2\21\u00a8\3\2\2\2\23\u00aa\3\2\2"+
		"\2\25\u00ac\3\2\2\2\27\u00af\3\2\2\2\31\u00b4\3\2\2\2\33\u00ba\3\2\2\2"+
		"\35\u00bd\3\2\2\2\37\u00c1\3\2\2\2!\u00c8\3\2\2\2#\u00cc\3\2\2\2%\u00ce"+
		"\3\2\2\2\'\u00d1\3\2\2\2)\u00d8\3\2\2\2+\u00da\3\2\2\2-\u00dc\3\2\2\2"+
		"/\u00de\3\2\2\2\61\u00e0\3\2\2\2\63\u00e2\3\2\2\2\65\u00e5\3\2\2\2\67"+
		"\u00e8\3\2\2\29\u00ea\3\2\2\2;\u00ec\3\2\2\2=\u00ee\3\2\2\2?\u00f0\3\2"+
		"\2\2A\u00f2\3\2\2\2C\u00f5\3\2\2\2E\u00f8\3\2\2\2G\u00fa\3\2\2\2I\u00fc"+
		"\3\2\2\2K\u00ff\3\2\2\2M\u0102\3\2\2\2O\u0105\3\2\2\2Q\u0108\3\2\2\2S"+
		"\u010b\3\2\2\2U\u010e\3\2\2\2W\u0111\3\2\2\2Y\u0113\3\2\2\2[\u0115\3\2"+
		"\2\2]\u0118\3\2\2\2_\u011b\3\2\2\2a\u01f8\3\2\2\2c\u020d\3\2\2\2e\u020f"+
		"\3\2\2\2g\u021a\3\2\2\2i\u022b\3\2\2\2k\u022f\3\2\2\2m\u0234\3\2\2\2o"+
		"\u023b\3\2\2\2q\u024c\3\2\2\2s\u025a\3\2\2\2u\u026b\3\2\2\2w\u027a\3\2"+
		"\2\2y\u027d\3\2\2\2{\u0286\3\2\2\2}\u028d\3\2\2\2\177\u028f\3\2\2\2\u0081"+
		"\u0291\3\2\2\2\u0083\u0293\3\2\2\2\u0085\u029a\3\2\2\2\u0087\u029c\3\2"+
		"\2\2\u0089\u029e\3\2\2\2\u008b\u02a6\3\2\2\2\u008d\u02ac\3\2\2\2\u008f"+
		"\u02b7\3\2\2\2\u0091\u0092\7k\2\2\u0092\u0093\7o\2\2\u0093\u0094\7r\2"+
		"\2\u0094\u0095\7q\2\2\u0095\u0096\7t\2\2\u0096\u0097\7v\2\2\u0097\4\3"+
		"\2\2\2\u0098\u0099\7*\2\2\u0099\6\3\2\2\2\u009a\u009b\7+\2\2\u009b\b\3"+
		"\2\2\2\u009c\u009d\7}\2\2\u009d\n\3\2\2\2\u009e\u009f\7\177\2\2\u009f"+
		"\f\3\2\2\2\u00a0\u00a1\7.\2\2\u00a1\16\3\2\2\2\u00a2\u00a3\7e\2\2\u00a3"+
		"\u00a4\7q\2\2\u00a4\u00a5\7p\2\2\u00a5\u00a6\7u\2\2\u00a6\u00a7\7v\2\2"+
		"\u00a7\20\3\2\2\2\u00a8\u00a9\7?\2\2\u00a9\22\3\2\2\2\u00aa\u00ab\7=\2"+
		"\2\u00ab\24\3\2\2\2\u00ac\u00ad\7k\2\2\u00ad\u00ae\7h\2\2\u00ae\26\3\2"+
		"\2\2\u00af\u00b0\7g\2\2\u00b0\u00b1\7n\2\2\u00b1\u00b2\7u\2\2\u00b2\u00b3"+
		"\7g\2\2\u00b3\30\3\2\2\2\u00b4\u00b5\7y\2\2\u00b5\u00b6\7j\2\2\u00b6\u00b7"+
		"\7k\2\2\u00b7\u00b8\7n\2\2\u00b8\u00b9\7g\2\2\u00b9\32\3\2\2\2\u00ba\u00bb"+
		"\7f\2\2\u00bb\u00bc\7q\2\2\u00bc\34\3\2\2\2\u00bd\u00be\7h\2\2\u00be\u00bf"+
		"\7q\2\2\u00bf\u00c0\7t\2\2\u00c0\36\3\2\2\2\u00c1\u00c2\7t\2\2\u00c2\u00c3"+
		"\7g\2\2\u00c3\u00c4\7v\2\2\u00c4\u00c5\7w\2\2\u00c5\u00c6\7t\2\2\u00c6"+
		"\u00c7\7p\2\2\u00c7 \3\2\2\2\u00c8\u00c9\7c\2\2\u00c9\u00ca\7u\2\2\u00ca"+
		"\u00cb\7o\2\2\u00cb\"\3\2\2\2\u00cc\u00cd\7<\2\2\u00cd$\3\2\2\2\u00ce"+
		"\u00cf\7\60\2\2\u00cf\u00d0\7\60\2\2\u00d0&\3\2\2\2\u00d1\u00d2\7u\2\2"+
		"\u00d2\u00d3\7k\2\2\u00d3\u00d4\7i\2\2\u00d4\u00d5\7p\2\2\u00d5\u00d6"+
		"\7g\2\2\u00d6\u00d7\7f\2\2\u00d7(\3\2\2\2\u00d8\u00d9\7,\2\2\u00d9*\3"+
		"\2\2\2\u00da\u00db\7]\2\2\u00db,\3\2\2\2\u00dc\u00dd\7_\2\2\u00dd.\3\2"+
		"\2\2\u00de\u00df\7>\2\2\u00df\60\3\2\2\2\u00e0\u00e1\7@\2\2\u00e1\62\3"+
		"\2\2\2\u00e2\u00e3\7/\2\2\u00e3\u00e4\7/\2\2\u00e4\64\3\2\2\2\u00e5\u00e6"+
		"\7-\2\2\u00e6\u00e7\7-\2\2\u00e7\66\3\2\2\2\u00e8\u00e9\7-\2\2\u00e98"+
		"\3\2\2\2\u00ea\u00eb\7/\2\2\u00eb:\3\2\2\2\u00ec\u00ed\7#\2\2\u00ed<\3"+
		"\2\2\2\u00ee\u00ef\7(\2\2\u00ef>\3\2\2\2\u00f0\u00f1\7\u0080\2\2\u00f1"+
		"@\3\2\2\2\u00f2\u00f3\7@\2\2\u00f3\u00f4\7@\2\2\u00f4B\3\2\2\2\u00f5\u00f6"+
		"\7>\2\2\u00f6\u00f7\7>\2\2\u00f7D\3\2\2\2\u00f8\u00f9\7\61\2\2\u00f9F"+
		"\3\2\2\2\u00fa\u00fb\7\'\2\2\u00fbH\3\2\2\2\u00fc\u00fd\7?\2\2\u00fd\u00fe"+
		"\7?\2\2\u00feJ\3\2\2\2\u00ff\u0100\7#\2\2\u0100\u0101\7?\2\2\u0101L\3"+
		"\2\2\2\u0102\u0103\7>\2\2\u0103\u0104\7@\2\2\u0104N\3\2\2\2\u0105\u0106"+
		"\7>\2\2\u0106\u0107\7?\2\2\u0107P\3\2\2\2\u0108\u0109\7?\2\2\u0109\u010a"+
		"\7>\2\2\u010aR\3\2\2\2\u010b\u010c\7@\2\2\u010c\u010d\7?\2\2\u010dT\3"+
		"\2\2\2\u010e\u010f\7?\2\2\u010f\u0110\7@\2\2\u0110V\3\2\2\2\u0111\u0112"+
		"\7`\2\2\u0112X\3\2\2\2\u0113\u0114\7~\2\2\u0114Z\3\2\2\2\u0115\u0116\7"+
		"(\2\2\u0116\u0117\7(\2\2\u0117\\\3\2\2\2\u0118\u0119\7~\2\2\u0119\u011a"+
		"\7~\2\2\u011a^\3\2\2\2\u011b\u011c\7%\2\2\u011c`\3\2\2\2\u011d\u011e\7"+
		"d\2\2\u011e\u011f\7t\2\2\u011f\u01f9\7m\2\2\u0120\u0121\7q\2\2\u0121\u0122"+
		"\7t\2\2\u0122\u01f9\7c\2\2\u0123\u0124\7m\2\2\u0124\u0125\7k\2\2\u0125"+
		"\u01f9\7n\2\2\u0126\u0127\7u\2\2\u0127\u0128\7n\2\2\u0128\u01f9\7q\2\2"+
		"\u0129\u012a\7p\2\2\u012a\u012b\7q\2\2\u012b\u01f9\7r\2\2\u012c\u012d"+
		"\7c\2\2\u012d\u012e\7u\2\2\u012e\u01f9\7n\2\2\u012f\u0130\7r\2\2\u0130"+
		"\u0131\7j\2\2\u0131\u01f9\7r\2\2\u0132\u0133\7c\2\2\u0133\u0134\7p\2\2"+
		"\u0134\u01f9\7e\2\2\u0135\u0136\7d\2\2\u0136\u0137\7r\2\2\u0137\u01f9"+
		"\7n\2\2\u0138\u0139\7e\2\2\u0139\u013a\7n\2\2\u013a\u01f9\7e\2\2\u013b"+
		"\u013c\7l\2\2\u013c\u013d\7u\2\2\u013d\u01f9\7t\2\2\u013e\u013f\7c\2\2"+
		"\u013f\u0140\7p\2\2\u0140\u01f9\7f\2\2\u0141\u0142\7t\2\2\u0142\u0143"+
		"\7n\2\2\u0143\u01f9\7c\2\2\u0144\u0145\7d\2\2\u0145\u0146\7k\2\2\u0146"+
		"\u01f9\7v\2\2\u0147\u0148\7t\2\2\u0148\u0149\7q\2\2\u0149\u01f9\7n\2\2"+
		"\u014a\u014b\7r\2\2\u014b\u014c\7n\2\2\u014c\u01f9\7c\2\2\u014d\u014e"+
		"\7r\2\2\u014e\u014f\7n\2\2\u014f\u01f9\7r\2\2\u0150\u0151\7d\2\2\u0151"+
		"\u0152\7o\2\2\u0152\u01f9\7k\2\2\u0153\u0154\7u\2\2\u0154\u0155\7g\2\2"+
		"\u0155\u01f9\7e\2\2\u0156\u0157\7t\2\2\u0157\u0158\7v\2\2\u0158\u01f9"+
		"\7k\2\2\u0159\u015a\7g\2\2\u015a\u015b\7q\2\2\u015b\u01f9\7t\2\2\u015c"+
		"\u015d\7u\2\2\u015d\u015e\7t\2\2\u015e\u01f9\7g\2\2\u015f\u0160\7n\2\2"+
		"\u0160\u0161\7u\2\2\u0161\u01f9\7t\2\2\u0162\u0163\7r\2\2\u0163\u0164"+
		"\7j\2\2\u0164\u01f9\7c\2\2\u0165\u0166\7c\2\2\u0166\u0167\7n\2\2\u0167"+
		"\u01f9\7t\2\2\u0168\u0169\7l\2\2\u0169\u016a\7o\2\2\u016a\u01f9\7r\2\2"+
		"\u016b\u016c\7d\2\2\u016c\u016d\7x\2\2\u016d\u01f9\7e\2\2\u016e\u016f"+
		"\7e\2\2\u016f\u0170\7n\2\2\u0170\u01f9\7k\2\2\u0171\u0172\7t\2\2\u0172"+
		"\u0173\7v\2\2\u0173\u01f9\7u\2\2\u0174\u0175\7c\2\2\u0175\u0176\7f\2\2"+
		"\u0176\u01f9\7e\2\2\u0177\u0178\7t\2\2\u0178\u0179\7t\2\2\u0179\u01f9"+
		"\7c\2\2\u017a\u017b\7d\2\2\u017b\u017c\7x\2\2\u017c\u01f9\7u\2\2\u017d"+
		"\u017e\7u\2\2\u017e\u017f\7g\2\2\u017f\u01f9\7k\2\2\u0180\u0181\7u\2\2"+
		"\u0181\u0182\7c\2\2\u0182\u01f9\7z\2\2\u0183\u0184\7u\2\2\u0184\u0185"+
		"\7v\2\2\u0185\u01f9\7{\2\2\u0186\u0187\7u\2\2\u0187\u0188\7v\2\2\u0188"+
		"\u01f9\7c\2\2\u0189\u018a\7u\2\2\u018a\u018b\7v\2\2\u018b\u01f9\7z\2\2"+
		"\u018c\u018d\7f\2\2\u018d\u018e\7g\2\2\u018e\u01f9\7{\2\2\u018f\u0190"+
		"\7v\2\2\u0190\u0191\7z\2\2\u0191\u01f9\7c\2\2\u0192\u0193\7z\2\2\u0193"+
		"\u0194\7c\2\2\u0194\u01f9\7c\2\2\u0195\u0196\7d\2\2\u0196\u0197\7e\2\2"+
		"\u0197\u01f9\7e\2\2\u0198\u0199\7c\2\2\u0199\u019a\7j\2\2\u019a\u01f9"+
		"\7z\2\2\u019b\u019c\7v\2\2\u019c\u019d\7{\2\2\u019d\u01f9\7c\2\2\u019e"+
		"\u019f\7v\2\2\u019f\u01a0\7z\2\2\u01a0\u01f9\7u\2\2\u01a1\u01a2\7v\2\2"+
		"\u01a2\u01a3\7c\2\2\u01a3\u01f9\7u\2\2\u01a4\u01a5\7u\2\2\u01a5\u01a6"+
		"\7j\2\2\u01a6\u01f9\7{\2\2\u01a7\u01a8\7u\2\2\u01a8\u01a9\7j\2\2\u01a9"+
		"\u01f9\7z\2\2\u01aa\u01ab\7n\2\2\u01ab\u01ac\7f\2\2\u01ac\u01f9\7{\2\2"+
		"\u01ad\u01ae\7n\2\2\u01ae\u01af\7f\2\2\u01af\u01f9\7c\2\2\u01b0\u01b1"+
		"\7n\2\2\u01b1\u01b2\7f\2\2\u01b2\u01f9\7z\2\2\u01b3\u01b4\7n\2\2\u01b4"+
		"\u01b5\7c\2\2\u01b5\u01f9\7z\2\2\u01b6\u01b7\7v\2\2\u01b7\u01b8\7c\2\2"+
		"\u01b8\u01f9\7{\2\2\u01b9\u01ba\7v\2\2\u01ba\u01bb\7c\2\2\u01bb\u01f9"+
		"\7z\2\2\u01bc\u01bd\7d\2\2\u01bd\u01be\7e\2\2\u01be\u01f9\7u\2\2\u01bf"+
		"\u01c0\7e\2\2\u01c0\u01c1\7n\2\2\u01c1\u01f9\7x\2\2\u01c2\u01c3\7v\2\2"+
		"\u01c3\u01c4\7u\2\2\u01c4\u01f9\7z\2\2\u01c5\u01c6\7n\2\2\u01c6\u01c7"+
		"\7c\2\2\u01c7\u01f9\7u\2\2\u01c8\u01c9\7e\2\2\u01c9\u01ca\7r\2\2\u01ca"+
		"\u01f9\7{\2\2\u01cb\u01cc\7e\2\2\u01cc\u01cd\7o\2\2\u01cd\u01f9\7r\2\2"+
		"\u01ce\u01cf\7e\2\2\u01cf\u01d0\7r\2\2\u01d0\u01f9\7z\2\2\u01d1\u01d2"+
		"\7f\2\2\u01d2\u01d3\7e\2\2\u01d3\u01f9\7r\2\2\u01d4\u01d5\7f\2\2\u01d5"+
		"\u01d6\7g\2\2\u01d6\u01f9\7e\2\2\u01d7\u01d8\7k\2\2\u01d8\u01d9\7p\2\2"+
		"\u01d9\u01f9\7e\2\2\u01da\u01db\7c\2\2\u01db\u01dc\7z\2\2\u01dc\u01f9"+
		"\7u\2\2\u01dd\u01de\7d\2\2\u01de\u01df\7p\2\2\u01df\u01f9\7g\2\2\u01e0"+
		"\u01e1\7e\2\2\u01e1\u01e2\7n\2\2\u01e2\u01f9\7f\2\2\u01e3\u01e4\7u\2\2"+
		"\u01e4\u01e5\7d\2\2\u01e5\u01f9\7e\2\2\u01e6\u01e7\7k\2\2\u01e7\u01e8"+
		"\7u\2\2\u01e8\u01f9\7e\2\2\u01e9\u01ea\7k\2\2\u01ea\u01eb\7p\2\2\u01eb"+
		"\u01f9\7z\2\2\u01ec\u01ed\7d\2\2\u01ed\u01ee\7g\2\2\u01ee\u01f9\7s\2\2"+
		"\u01ef\u01f0\7u\2\2\u01f0\u01f1\7g\2\2\u01f1\u01f9\7f\2\2\u01f2\u01f3"+
		"\7f\2\2\u01f3\u01f4\7g\2\2\u01f4\u01f9\7z\2\2\u01f5\u01f6\7k\2\2\u01f6"+
		"\u01f7\7p\2\2\u01f7\u01f9\7{\2\2\u01f8\u011d\3\2\2\2\u01f8\u0120\3\2\2"+
		"\2\u01f8\u0123\3\2\2\2\u01f8\u0126\3\2\2\2\u01f8\u0129\3\2\2\2\u01f8\u012c"+
		"\3\2\2\2\u01f8\u012f\3\2\2\2\u01f8\u0132\3\2\2\2\u01f8\u0135\3\2\2\2\u01f8"+
		"\u0138\3\2\2\2\u01f8\u013b\3\2\2\2\u01f8\u013e\3\2\2\2\u01f8\u0141\3\2"+
		"\2\2\u01f8\u0144\3\2\2\2\u01f8\u0147\3\2\2\2\u01f8\u014a\3\2\2\2\u01f8"+
		"\u014d\3\2\2\2\u01f8\u0150\3\2\2\2\u01f8\u0153\3\2\2\2\u01f8\u0156\3\2"+
		"\2\2\u01f8\u0159\3\2\2\2\u01f8\u015c\3\2\2\2\u01f8\u015f\3\2\2\2\u01f8"+
		"\u0162\3\2\2\2\u01f8\u0165\3\2\2\2\u01f8\u0168\3\2\2\2\u01f8\u016b\3\2"+
		"\2\2\u01f8\u016e\3\2\2\2\u01f8\u0171\3\2\2\2\u01f8\u0174\3\2\2\2\u01f8"+
		"\u0177\3\2\2\2\u01f8\u017a\3\2\2\2\u01f8\u017d\3\2\2\2\u01f8\u0180\3\2"+
		"\2\2\u01f8\u0183\3\2\2\2\u01f8\u0186\3\2\2\2\u01f8\u0189\3\2\2\2\u01f8"+
		"\u018c\3\2\2\2\u01f8\u018f\3\2\2\2\u01f8\u0192\3\2\2\2\u01f8\u0195\3\2"+
		"\2\2\u01f8\u0198\3\2\2\2\u01f8\u019b\3\2\2\2\u01f8\u019e\3\2\2\2\u01f8"+
		"\u01a1\3\2\2\2\u01f8\u01a4\3\2\2\2\u01f8\u01a7\3\2\2\2\u01f8\u01aa\3\2"+
		"\2\2\u01f8\u01ad\3\2\2\2\u01f8\u01b0\3\2\2\2\u01f8\u01b3\3\2\2\2\u01f8"+
		"\u01b6\3\2\2\2\u01f8\u01b9\3\2\2\2\u01f8\u01bc\3\2\2\2\u01f8\u01bf\3\2"+
		"\2\2\u01f8\u01c2\3\2\2\2\u01f8\u01c5\3\2\2\2\u01f8\u01c8\3\2\2\2\u01f8"+
		"\u01cb\3\2\2\2\u01f8\u01ce\3\2\2\2\u01f8\u01d1\3\2\2\2\u01f8\u01d4\3\2"+
		"\2\2\u01f8\u01d7\3\2\2\2\u01f8\u01da\3\2\2\2\u01f8\u01dd\3\2\2\2\u01f8"+
		"\u01e0\3\2\2\2\u01f8\u01e3\3\2\2\2\u01f8\u01e6\3\2\2\2\u01f8\u01e9\3\2"+
		"\2\2\u01f8\u01ec\3\2\2\2\u01f8\u01ef\3\2\2\2\u01f8\u01f2\3\2\2\2\u01f8"+
		"\u01f5\3\2\2\2\u01f9b\3\2\2\2\u01fa\u01fb\7d\2\2\u01fb\u01fc\7{\2\2\u01fc"+
		"\u01fd\7v\2\2\u01fd\u020e\7g\2\2\u01fe\u01ff\7y\2\2\u01ff\u0200\7q\2\2"+
		"\u0200\u0201\7t\2\2\u0201\u020e\7f\2\2\u0202\u0203\7d\2\2\u0203\u0204"+
		"\7q\2\2\u0204\u0205\7q\2\2\u0205\u0206\7n\2\2\u0206\u0207\7g\2\2\u0207"+
		"\u0208\7c\2\2\u0208\u020e\7p\2\2\u0209\u020a\7x\2\2\u020a\u020b\7q\2\2"+
		"\u020b\u020c\7k\2\2\u020c\u020e\7f\2\2\u020d\u01fa\3\2\2\2\u020d\u01fe"+
		"\3\2\2\2\u020d\u0202\3\2\2\2\u020d\u0209\3\2\2\2\u020ed\3\2\2\2\u020f"+
		"\u0215\7$\2\2\u0210\u0211\7^\2\2\u0211\u0214\7$\2\2\u0212\u0214\n\2\2"+
		"\2\u0213\u0210\3\2\2\2\u0213\u0212\3\2\2\2\u0214\u0217\3\2\2\2\u0215\u0213"+
		"\3\2\2\2\u0215\u0216\3\2\2\2\u0216\u0218\3\2\2\2\u0217\u0215\3\2\2\2\u0218"+
		"\u0219\7$\2\2\u0219f\3\2\2\2\u021a\u021e\7)\2\2\u021b\u021c\7^\2\2\u021c"+
		"\u021f\7)\2\2\u021d\u021f\n\3\2\2\u021e\u021b\3\2\2\2\u021e\u021d\3\2"+
		"\2\2\u021f\u0220\3\2\2\2\u0220\u0221\7)\2\2\u0221h\3\2\2\2\u0222\u0223"+
		"\7v\2\2\u0223\u0224\7t\2\2\u0224\u0225\7w\2\2\u0225\u022c\7g\2\2\u0226"+
		"\u0227\7h\2\2\u0227\u0228\7c\2\2\u0228\u0229\7n\2\2\u0229\u022a\7u\2\2"+
		"\u022a\u022c\7g\2\2\u022b\u0222\3\2\2\2\u022b\u0226\3\2\2\2\u022cj\3\2"+
		"\2\2\u022d\u0230\5m\67\2\u022e\u0230\5u;\2\u022f\u022d\3\2\2\2\u022f\u022e"+
		"\3\2\2\2\u0230l\3\2\2\2\u0231\u0235\5o8\2\u0232\u0235\5q9\2\u0233\u0235"+
		"\5s:\2\u0234\u0231\3\2\2\2\u0234\u0232\3\2\2\2\u0234\u0233\3\2\2\2\u0235"+
		"n\3\2\2\2\u0236\u023c\7\'\2\2\u0237\u0238\7\62\2\2\u0238\u023c\7d\2\2"+
		"\u0239\u023a\7\62\2\2\u023a\u023c\7D\2\2\u023b\u0236\3\2\2\2\u023b\u0237"+
		"\3\2\2\2\u023b\u0239\3\2\2\2\u023c\u0240\3\2\2\2\u023d\u023f\5}?\2\u023e"+
		"\u023d\3\2\2\2\u023f\u0242\3\2\2\2\u0240\u023e\3\2\2\2\u0240\u0241\3\2"+
		"\2\2\u0241\u0243\3\2\2\2\u0242\u0240\3\2\2\2\u0243\u0245\7\60\2\2\u0244"+
		"\u0246\5}?\2\u0245\u0244\3\2\2\2\u0246\u0247\3\2\2\2\u0247\u0245\3\2\2"+
		"\2\u0247\u0248\3\2\2\2\u0248p\3\2\2\2\u0249\u024b\5\177@\2\u024a\u0249"+
		"\3\2\2\2\u024b\u024e\3\2\2\2\u024c\u024a\3\2\2\2\u024c\u024d\3\2\2\2\u024d"+
		"\u024f\3\2\2\2\u024e\u024c\3\2\2\2\u024f\u0251\7\60\2\2\u0250\u0252\5"+
		"\177@\2\u0251\u0250\3\2\2\2\u0252\u0253\3\2\2\2\u0253\u0251\3\2\2\2\u0253"+
		"\u0254\3\2\2\2\u0254r\3\2\2\2\u0255\u025b\7&\2\2\u0256\u0257\7\62\2\2"+
		"\u0257\u025b\7z\2\2\u0258\u0259\7\62\2\2\u0259\u025b\7Z\2\2\u025a\u0255"+
		"\3\2\2\2\u025a\u0256\3\2\2\2\u025a\u0258\3\2\2\2\u025b\u025f\3\2\2\2\u025c"+
		"\u025e\5\u0081A\2\u025d\u025c\3\2\2\2\u025e\u0261\3\2\2\2\u025f\u025d"+
		"\3\2\2\2\u025f\u0260\3\2\2\2\u0260\u0262\3\2\2\2\u0261\u025f\3\2\2\2\u0262"+
		"\u0264\7\60\2\2\u0263\u0265\5\u0081A\2\u0264\u0263\3\2\2\2\u0265\u0266"+
		"\3\2\2\2\u0266\u0264\3\2\2\2\u0266\u0267\3\2\2\2\u0267t\3\2\2\2\u0268"+
		"\u026c\5y=\2\u0269\u026c\5{>\2\u026a\u026c\5w<\2\u026b\u0268\3\2\2\2\u026b"+
		"\u0269\3\2\2\2\u026b\u026a\3\2\2\2\u026cv\3\2\2\2\u026d\u026e\7\62\2\2"+
		"\u026e\u0270\t\4\2\2\u026f\u0271\5}?\2\u0270\u026f\3\2\2\2\u0271\u0272"+
		"\3\2\2\2\u0272\u0270\3\2\2\2\u0272\u0273\3\2\2\2\u0273\u027b\3\2\2\2\u0274"+
		"\u0276\7\'\2\2\u0275\u0277\5}?\2\u0276\u0275\3\2\2\2\u0277\u0278\3\2\2"+
		"\2\u0278\u0276\3\2\2\2\u0278\u0279\3\2\2\2\u0279\u027b\3\2\2\2\u027a\u026d"+
		"\3\2\2\2\u027a\u0274\3\2\2\2\u027bx\3\2\2\2\u027c\u027e\5\177@\2\u027d"+
		"\u027c\3\2\2\2\u027e\u027f\3\2\2\2\u027f\u027d\3\2\2\2\u027f\u0280\3\2"+
		"\2\2\u0280z\3\2\2\2\u0281\u0287\7&\2\2\u0282\u0283\7\62\2\2\u0283\u0287"+
		"\7z\2\2\u0284\u0285\7\62\2\2\u0285\u0287\7Z\2\2\u0286\u0281\3\2\2\2\u0286"+
		"\u0282\3\2\2\2\u0286\u0284\3\2\2\2\u0287\u0289\3\2\2\2\u0288\u028a\5\u0081"+
		"A\2\u0289\u0288\3\2\2\2\u028a\u028b\3\2\2\2\u028b\u0289\3\2\2\2\u028b"+
		"\u028c\3\2\2\2\u028c|\3\2\2\2\u028d\u028e\t\5\2\2\u028e~\3\2\2\2\u028f"+
		"\u0290\t\6\2\2\u0290\u0080\3\2\2\2\u0291\u0292\t\7\2\2\u0292\u0082\3\2"+
		"\2\2\u0293\u0297\5\u0085C\2\u0294\u0296\5\u0087D\2\u0295\u0294\3\2\2\2"+
		"\u0296\u0299\3\2\2\2\u0297\u0295\3\2\2\2\u0297\u0298\3\2\2\2\u0298\u0084"+
		"\3\2\2\2\u0299\u0297\3\2\2\2\u029a\u029b\t\b\2\2\u029b\u0086\3\2\2\2\u029c"+
		"\u029d\t\t\2\2\u029d\u0088\3\2\2\2\u029e\u02a2\7#\2\2\u029f\u02a1\t\n"+
		"\2\2\u02a0\u029f\3\2\2\2\u02a1\u02a4\3\2\2\2\u02a2\u02a0\3\2\2\2\u02a2"+
		"\u02a3\3\2\2\2\u02a3\u008a\3\2\2\2\u02a4\u02a2\3\2\2\2\u02a5\u02a7\t\13"+
		"\2\2\u02a6\u02a5\3\2\2\2\u02a7\u02a8\3\2\2\2\u02a8\u02a6\3\2\2\2\u02a8"+
		"\u02a9\3\2\2\2\u02a9\u02aa\3\2\2\2\u02aa\u02ab\bF\2\2\u02ab\u008c\3\2"+
		"\2\2\u02ac\u02ad\7\61\2\2\u02ad\u02ae\7\61\2\2\u02ae\u02b2\3\2\2\2\u02af"+
		"\u02b1\n\f\2\2\u02b0\u02af\3\2\2\2\u02b1\u02b4\3\2\2\2\u02b2\u02b0\3\2"+
		"\2\2\u02b2\u02b3\3\2\2\2\u02b3\u02b5\3\2\2\2\u02b4\u02b2\3\2\2\2\u02b5"+
		"\u02b6\bG\2\2\u02b6\u008e\3\2\2\2\u02b7\u02b8\7\61\2\2\u02b8\u02b9\7,"+
		"\2\2\u02b9\u02bd\3\2\2\2\u02ba\u02bc\13\2\2\2\u02bb\u02ba\3\2\2\2\u02bc"+
		"\u02bf\3\2\2\2\u02bd\u02be\3\2\2\2\u02bd\u02bb\3\2\2\2\u02be\u02c0\3\2"+
		"\2\2\u02bf\u02bd\3\2\2\2\u02c0\u02c1\7,\2\2\u02c1\u02c2\7\61\2\2\u02c2"+
		"\u02c3\3\2\2\2\u02c3\u02c4\bH\2\2\u02c4\u0090\3\2\2\2\37\2\u01f8\u020d"+
		"\u0213\u0215\u021e\u022b\u022f\u0234\u023b\u0240\u0247\u024c\u0253\u025a"+
		"\u025f\u0266\u026b\u0272\u0278\u027a\u027f\u0286\u028b\u0297\u02a2\u02a8"+
		"\u02b2\u02bd\3\b\2\2";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}
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
		T__59=60, T__60=61, T__61=62, T__62=63, T__63=64, T__64=65, T__65=66, 
		T__66=67, T__67=68, T__68=69, T__69=70, MNEMONIC=71, KICKASM=72, SIMPLETYPE=73, 
		STRING=74, CHAR=75, BOOLEAN=76, NUMBER=77, NUMFLOAT=78, BINFLOAT=79, DECFLOAT=80, 
		HEXFLOAT=81, NUMINT=82, BININTEGER=83, DECINTEGER=84, HEXINTEGER=85, NAME=86, 
		ASMREL=87, WS=88, COMMENT_LINE=89, COMMENT_BLOCK=90;
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
		"T__57", "T__58", "T__59", "T__60", "T__61", "T__62", "T__63", "T__64", 
		"T__65", "T__66", "T__67", "T__68", "T__69", "MNEMONIC", "KICKASM", "SIMPLETYPE", 
		"STRING", "CHAR", "BOOLEAN", "NUMBER", "NUMFLOAT", "BINFLOAT", "DECFLOAT", 
		"HEXFLOAT", "NUMINT", "BININTEGER", "DECINTEGER", "HEXINTEGER", "BINDIGIT", 
		"DECDIGIT", "HEXDIGIT", "NAME", "NAME_START", "NAME_CHAR", "ASMREL", "WS", 
		"COMMENT_LINE", "COMMENT_BLOCK"
	};

	private static final String[] _LITERAL_NAMES = {
		null, "'import'", "'='", "';'", "'('", "')'", "'{'", "'}'", "'kickasm'", 
		"','", "'resource'", "'uses'", "'clobbers'", "'param'", "':'", "'bytes'", 
		"'cycles'", "'pc'", "'inline'", "'const'", "'extern'", "'align'", "'register'", 
		"'volatile'", "'interrupt'", "'if'", "'else'", "'while'", "'do'", "'for'", 
		"'return'", "'asm'", "'..'", "'signed'", "'*'", "'['", "']'", "'--'", 
		"'++'", "'+'", "'-'", "'!'", "'&'", "'~'", "'>>'", "'<<'", "'/'", "'%'", 
		"'<'", "'>'", "'=='", "'!='", "'<='", "'>='", "'^'", "'|'", "'&&'", "'||'", 
		"'+='", "'-='", "'*='", "'/='", "'%='", "'<<='", "'>>='", "'&='", "'|='", 
		"'^='", "'.byte'", "'#'", "'.'"
	};
	private static final String[] _SYMBOLIC_NAMES = {
		null, null, null, null, null, null, null, null, null, null, null, null, 
		null, null, null, null, null, null, null, null, null, null, null, null, 
		null, null, null, null, null, null, null, null, null, null, null, null, 
		null, null, null, null, null, null, null, null, null, null, null, null, 
		null, null, null, null, null, null, null, null, null, null, null, null, 
		null, null, null, null, null, null, null, null, null, null, null, "MNEMONIC", 
		"KICKASM", "SIMPLETYPE", "STRING", "CHAR", "BOOLEAN", "NUMBER", "NUMFLOAT", 
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
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\2\\\u038f\b\1\4\2\t"+
		"\2\4\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n\t\n\4\13"+
		"\t\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\4\20\t\20\4\21\t\21\4\22\t\22"+
		"\4\23\t\23\4\24\t\24\4\25\t\25\4\26\t\26\4\27\t\27\4\30\t\30\4\31\t\31"+
		"\4\32\t\32\4\33\t\33\4\34\t\34\4\35\t\35\4\36\t\36\4\37\t\37\4 \t \4!"+
		"\t!\4\"\t\"\4#\t#\4$\t$\4%\t%\4&\t&\4\'\t\'\4(\t(\4)\t)\4*\t*\4+\t+\4"+
		",\t,\4-\t-\4.\t.\4/\t/\4\60\t\60\4\61\t\61\4\62\t\62\4\63\t\63\4\64\t"+
		"\64\4\65\t\65\4\66\t\66\4\67\t\67\48\t8\49\t9\4:\t:\4;\t;\4<\t<\4=\t="+
		"\4>\t>\4?\t?\4@\t@\4A\tA\4B\tB\4C\tC\4D\tD\4E\tE\4F\tF\4G\tG\4H\tH\4I"+
		"\tI\4J\tJ\4K\tK\4L\tL\4M\tM\4N\tN\4O\tO\4P\tP\4Q\tQ\4R\tR\4S\tS\4T\tT"+
		"\4U\tU\4V\tV\4W\tW\4X\tX\4Y\tY\4Z\tZ\4[\t[\4\\\t\\\4]\t]\4^\t^\4_\t_\4"+
		"`\t`\3\2\3\2\3\2\3\2\3\2\3\2\3\2\3\3\3\3\3\4\3\4\3\5\3\5\3\6\3\6\3\7\3"+
		"\7\3\b\3\b\3\t\3\t\3\t\3\t\3\t\3\t\3\t\3\t\3\n\3\n\3\13\3\13\3\13\3\13"+
		"\3\13\3\13\3\13\3\13\3\13\3\f\3\f\3\f\3\f\3\f\3\r\3\r\3\r\3\r\3\r\3\r"+
		"\3\r\3\r\3\r\3\16\3\16\3\16\3\16\3\16\3\16\3\17\3\17\3\20\3\20\3\20\3"+
		"\20\3\20\3\20\3\21\3\21\3\21\3\21\3\21\3\21\3\21\3\22\3\22\3\22\3\23\3"+
		"\23\3\23\3\23\3\23\3\23\3\23\3\24\3\24\3\24\3\24\3\24\3\24\3\25\3\25\3"+
		"\25\3\25\3\25\3\25\3\25\3\26\3\26\3\26\3\26\3\26\3\26\3\27\3\27\3\27\3"+
		"\27\3\27\3\27\3\27\3\27\3\27\3\30\3\30\3\30\3\30\3\30\3\30\3\30\3\30\3"+
		"\30\3\31\3\31\3\31\3\31\3\31\3\31\3\31\3\31\3\31\3\31\3\32\3\32\3\32\3"+
		"\33\3\33\3\33\3\33\3\33\3\34\3\34\3\34\3\34\3\34\3\34\3\35\3\35\3\35\3"+
		"\36\3\36\3\36\3\36\3\37\3\37\3\37\3\37\3\37\3\37\3\37\3 \3 \3 \3 \3!\3"+
		"!\3!\3\"\3\"\3\"\3\"\3\"\3\"\3\"\3#\3#\3$\3$\3%\3%\3&\3&\3&\3\'\3\'\3"+
		"\'\3(\3(\3)\3)\3*\3*\3+\3+\3,\3,\3-\3-\3-\3.\3.\3.\3/\3/\3\60\3\60\3\61"+
		"\3\61\3\62\3\62\3\63\3\63\3\63\3\64\3\64\3\64\3\65\3\65\3\65\3\66\3\66"+
		"\3\66\3\67\3\67\38\38\39\39\39\3:\3:\3:\3;\3;\3;\3<\3<\3<\3=\3=\3=\3>"+
		"\3>\3>\3?\3?\3?\3@\3@\3@\3@\3A\3A\3A\3A\3B\3B\3B\3C\3C\3C\3D\3D\3D\3E"+
		"\3E\3E\3E\3E\3E\3F\3F\3G\3G\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H"+
		"\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H"+
		"\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H"+
		"\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H"+
		"\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H"+
		"\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H"+
		"\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H"+
		"\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H"+
		"\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H"+
		"\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H\3H"+
		"\3H\5H\u02b0\nH\3I\3I\3I\3I\7I\u02b6\nI\fI\16I\u02b9\13I\3I\3I\3I\3J\3"+
		"J\3J\3J\3J\3J\3J\3J\3J\3J\3J\3J\3J\3J\3J\3J\3J\3J\3J\3J\3J\5J\u02d3\n"+
		"J\3K\3K\3K\3K\7K\u02d9\nK\fK\16K\u02dc\13K\3K\3K\3L\3L\3L\3L\5L\u02e4"+
		"\nL\3L\3L\3M\3M\3M\3M\3M\3M\3M\3M\3M\5M\u02f1\nM\3N\3N\5N\u02f5\nN\3O"+
		"\3O\3O\5O\u02fa\nO\3P\3P\3P\3P\3P\5P\u0301\nP\3P\7P\u0304\nP\fP\16P\u0307"+
		"\13P\3P\3P\6P\u030b\nP\rP\16P\u030c\3Q\7Q\u0310\nQ\fQ\16Q\u0313\13Q\3"+
		"Q\3Q\6Q\u0317\nQ\rQ\16Q\u0318\3R\3R\3R\3R\3R\5R\u0320\nR\3R\7R\u0323\n"+
		"R\fR\16R\u0326\13R\3R\3R\6R\u032a\nR\rR\16R\u032b\3S\3S\3S\5S\u0331\n"+
		"S\3T\3T\3T\6T\u0336\nT\rT\16T\u0337\3T\3T\6T\u033c\nT\rT\16T\u033d\5T"+
		"\u0340\nT\3U\6U\u0343\nU\rU\16U\u0344\3V\3V\3V\3V\3V\5V\u034c\nV\3V\6"+
		"V\u034f\nV\rV\16V\u0350\3W\3W\3X\3X\3Y\3Y\3Z\3Z\7Z\u035b\nZ\fZ\16Z\u035e"+
		"\13Z\3[\3[\3\\\3\\\3]\3]\7]\u0366\n]\f]\16]\u0369\13]\3]\6]\u036c\n]\r"+
		"]\16]\u036d\3^\6^\u0371\n^\r^\16^\u0372\3^\3^\3_\3_\3_\3_\7_\u037b\n_"+
		"\f_\16_\u037e\13_\3_\3_\3`\3`\3`\3`\7`\u0386\n`\f`\16`\u0389\13`\3`\3"+
		"`\3`\3`\3`\4\u02b7\u0387\2a\3\3\5\4\7\5\t\6\13\7\r\b\17\t\21\n\23\13\25"+
		"\f\27\r\31\16\33\17\35\20\37\21!\22#\23%\24\'\25)\26+\27-\30/\31\61\32"+
		"\63\33\65\34\67\359\36;\37= ?!A\"C#E$G%I&K\'M(O)Q*S+U,W-Y.[/]\60_\61a"+
		"\62c\63e\64g\65i\66k\67m8o9q:s;u<w=y>{?}@\177A\u0081B\u0083C\u0085D\u0087"+
		"E\u0089F\u008bG\u008dH\u008fI\u0091J\u0093K\u0095L\u0097M\u0099N\u009b"+
		"O\u009dP\u009fQ\u00a1R\u00a3S\u00a5T\u00a7U\u00a9V\u00abW\u00ad\2\u00af"+
		"\2\u00b1\2\u00b3X\u00b5\2\u00b7\2\u00b9Y\u00bbZ\u00bd[\u00bf\\\3\2\r\3"+
		"\2$$\3\2))\4\2DDdd\3\2\62\63\3\2\62;\5\2\62;CHch\5\2C\\aac|\6\2\62;C\\"+
		"aac|\4\2--//\6\2\13\f\17\17\"\"\u00a2\u00a2\4\2\f\f\17\17\2\u03f7\2\3"+
		"\3\2\2\2\2\5\3\2\2\2\2\7\3\2\2\2\2\t\3\2\2\2\2\13\3\2\2\2\2\r\3\2\2\2"+
		"\2\17\3\2\2\2\2\21\3\2\2\2\2\23\3\2\2\2\2\25\3\2\2\2\2\27\3\2\2\2\2\31"+
		"\3\2\2\2\2\33\3\2\2\2\2\35\3\2\2\2\2\37\3\2\2\2\2!\3\2\2\2\2#\3\2\2\2"+
		"\2%\3\2\2\2\2\'\3\2\2\2\2)\3\2\2\2\2+\3\2\2\2\2-\3\2\2\2\2/\3\2\2\2\2"+
		"\61\3\2\2\2\2\63\3\2\2\2\2\65\3\2\2\2\2\67\3\2\2\2\29\3\2\2\2\2;\3\2\2"+
		"\2\2=\3\2\2\2\2?\3\2\2\2\2A\3\2\2\2\2C\3\2\2\2\2E\3\2\2\2\2G\3\2\2\2\2"+
		"I\3\2\2\2\2K\3\2\2\2\2M\3\2\2\2\2O\3\2\2\2\2Q\3\2\2\2\2S\3\2\2\2\2U\3"+
		"\2\2\2\2W\3\2\2\2\2Y\3\2\2\2\2[\3\2\2\2\2]\3\2\2\2\2_\3\2\2\2\2a\3\2\2"+
		"\2\2c\3\2\2\2\2e\3\2\2\2\2g\3\2\2\2\2i\3\2\2\2\2k\3\2\2\2\2m\3\2\2\2\2"+
		"o\3\2\2\2\2q\3\2\2\2\2s\3\2\2\2\2u\3\2\2\2\2w\3\2\2\2\2y\3\2\2\2\2{\3"+
		"\2\2\2\2}\3\2\2\2\2\177\3\2\2\2\2\u0081\3\2\2\2\2\u0083\3\2\2\2\2\u0085"+
		"\3\2\2\2\2\u0087\3\2\2\2\2\u0089\3\2\2\2\2\u008b\3\2\2\2\2\u008d\3\2\2"+
		"\2\2\u008f\3\2\2\2\2\u0091\3\2\2\2\2\u0093\3\2\2\2\2\u0095\3\2\2\2\2\u0097"+
		"\3\2\2\2\2\u0099\3\2\2\2\2\u009b\3\2\2\2\2\u009d\3\2\2\2\2\u009f\3\2\2"+
		"\2\2\u00a1\3\2\2\2\2\u00a3\3\2\2\2\2\u00a5\3\2\2\2\2\u00a7\3\2\2\2\2\u00a9"+
		"\3\2\2\2\2\u00ab\3\2\2\2\2\u00b3\3\2\2\2\2\u00b9\3\2\2\2\2\u00bb\3\2\2"+
		"\2\2\u00bd\3\2\2\2\2\u00bf\3\2\2\2\3\u00c1\3\2\2\2\5\u00c8\3\2\2\2\7\u00ca"+
		"\3\2\2\2\t\u00cc\3\2\2\2\13\u00ce\3\2\2\2\r\u00d0\3\2\2\2\17\u00d2\3\2"+
		"\2\2\21\u00d4\3\2\2\2\23\u00dc\3\2\2\2\25\u00de\3\2\2\2\27\u00e7\3\2\2"+
		"\2\31\u00ec\3\2\2\2\33\u00f5\3\2\2\2\35\u00fb\3\2\2\2\37\u00fd\3\2\2\2"+
		"!\u0103\3\2\2\2#\u010a\3\2\2\2%\u010d\3\2\2\2\'\u0114\3\2\2\2)\u011a\3"+
		"\2\2\2+\u0121\3\2\2\2-\u0127\3\2\2\2/\u0130\3\2\2\2\61\u0139\3\2\2\2\63"+
		"\u0143\3\2\2\2\65\u0146\3\2\2\2\67\u014b\3\2\2\29\u0151\3\2\2\2;\u0154"+
		"\3\2\2\2=\u0158\3\2\2\2?\u015f\3\2\2\2A\u0163\3\2\2\2C\u0166\3\2\2\2E"+
		"\u016d\3\2\2\2G\u016f\3\2\2\2I\u0171\3\2\2\2K\u0173\3\2\2\2M\u0176\3\2"+
		"\2\2O\u0179\3\2\2\2Q\u017b\3\2\2\2S\u017d\3\2\2\2U\u017f\3\2\2\2W\u0181"+
		"\3\2\2\2Y\u0183\3\2\2\2[\u0186\3\2\2\2]\u0189\3\2\2\2_\u018b\3\2\2\2a"+
		"\u018d\3\2\2\2c\u018f\3\2\2\2e\u0191\3\2\2\2g\u0194\3\2\2\2i\u0197\3\2"+
		"\2\2k\u019a\3\2\2\2m\u019d\3\2\2\2o\u019f\3\2\2\2q\u01a1\3\2\2\2s\u01a4"+
		"\3\2\2\2u\u01a7\3\2\2\2w\u01aa\3\2\2\2y\u01ad\3\2\2\2{\u01b0\3\2\2\2}"+
		"\u01b3\3\2\2\2\177\u01b6\3\2\2\2\u0081\u01ba\3\2\2\2\u0083\u01be\3\2\2"+
		"\2\u0085\u01c1\3\2\2\2\u0087\u01c4\3\2\2\2\u0089\u01c7\3\2\2\2\u008b\u01cd"+
		"\3\2\2\2\u008d\u01cf\3\2\2\2\u008f\u02af\3\2\2\2\u0091\u02b1\3\2\2\2\u0093"+
		"\u02d2\3\2\2\2\u0095\u02d4\3\2\2\2\u0097\u02df\3\2\2\2\u0099\u02f0\3\2"+
		"\2\2\u009b\u02f4\3\2\2\2\u009d\u02f9\3\2\2\2\u009f\u0300\3\2\2\2\u00a1"+
		"\u0311\3\2\2\2\u00a3\u031f\3\2\2\2\u00a5\u0330\3\2\2\2\u00a7\u033f\3\2"+
		"\2\2\u00a9\u0342\3\2\2\2\u00ab\u034b\3\2\2\2\u00ad\u0352\3\2\2\2\u00af"+
		"\u0354\3\2\2\2\u00b1\u0356\3\2\2\2\u00b3\u0358\3\2\2\2\u00b5\u035f\3\2"+
		"\2\2\u00b7\u0361\3\2\2\2\u00b9\u0363\3\2\2\2\u00bb\u0370\3\2\2\2\u00bd"+
		"\u0376\3\2\2\2\u00bf\u0381\3\2\2\2\u00c1\u00c2\7k\2\2\u00c2\u00c3\7o\2"+
		"\2\u00c3\u00c4\7r\2\2\u00c4\u00c5\7q\2\2\u00c5\u00c6\7t\2\2\u00c6\u00c7"+
		"\7v\2\2\u00c7\4\3\2\2\2\u00c8\u00c9\7?\2\2\u00c9\6\3\2\2\2\u00ca\u00cb"+
		"\7=\2\2\u00cb\b\3\2\2\2\u00cc\u00cd\7*\2\2\u00cd\n\3\2\2\2\u00ce\u00cf"+
		"\7+\2\2\u00cf\f\3\2\2\2\u00d0\u00d1\7}\2\2\u00d1\16\3\2\2\2\u00d2\u00d3"+
		"\7\177\2\2\u00d3\20\3\2\2\2\u00d4\u00d5\7m\2\2\u00d5\u00d6\7k\2\2\u00d6"+
		"\u00d7\7e\2\2\u00d7\u00d8\7m\2\2\u00d8\u00d9\7c\2\2\u00d9\u00da\7u\2\2"+
		"\u00da\u00db\7o\2\2\u00db\22\3\2\2\2\u00dc\u00dd\7.\2\2\u00dd\24\3\2\2"+
		"\2\u00de\u00df\7t\2\2\u00df\u00e0\7g\2\2\u00e0\u00e1\7u\2\2\u00e1\u00e2"+
		"\7q\2\2\u00e2\u00e3\7w\2\2\u00e3\u00e4\7t\2\2\u00e4\u00e5\7e\2\2\u00e5"+
		"\u00e6\7g\2\2\u00e6\26\3\2\2\2\u00e7\u00e8\7w\2\2\u00e8\u00e9\7u\2\2\u00e9"+
		"\u00ea\7g\2\2\u00ea\u00eb\7u\2\2\u00eb\30\3\2\2\2\u00ec\u00ed\7e\2\2\u00ed"+
		"\u00ee\7n\2\2\u00ee\u00ef\7q\2\2\u00ef\u00f0\7d\2\2\u00f0\u00f1\7d\2\2"+
		"\u00f1\u00f2\7g\2\2\u00f2\u00f3\7t\2\2\u00f3\u00f4\7u\2\2\u00f4\32\3\2"+
		"\2\2\u00f5\u00f6\7r\2\2\u00f6\u00f7\7c\2\2\u00f7\u00f8\7t\2\2\u00f8\u00f9"+
		"\7c\2\2\u00f9\u00fa\7o\2\2\u00fa\34\3\2\2\2\u00fb\u00fc\7<\2\2\u00fc\36"+
		"\3\2\2\2\u00fd\u00fe\7d\2\2\u00fe\u00ff\7{\2\2\u00ff\u0100\7v\2\2\u0100"+
		"\u0101\7g\2\2\u0101\u0102\7u\2\2\u0102 \3\2\2\2\u0103\u0104\7e\2\2\u0104"+
		"\u0105\7{\2\2\u0105\u0106\7e\2\2\u0106\u0107\7n\2\2\u0107\u0108\7g\2\2"+
		"\u0108\u0109\7u\2\2\u0109\"\3\2\2\2\u010a\u010b\7r\2\2\u010b\u010c\7e"+
		"\2\2\u010c$\3\2\2\2\u010d\u010e\7k\2\2\u010e\u010f\7p\2\2\u010f\u0110"+
		"\7n\2\2\u0110\u0111\7k\2\2\u0111\u0112\7p\2\2\u0112\u0113\7g\2\2\u0113"+
		"&\3\2\2\2\u0114\u0115\7e\2\2\u0115\u0116\7q\2\2\u0116\u0117\7p\2\2\u0117"+
		"\u0118\7u\2\2\u0118\u0119\7v\2\2\u0119(\3\2\2\2\u011a\u011b\7g\2\2\u011b"+
		"\u011c\7z\2\2\u011c\u011d\7v\2\2\u011d\u011e\7g\2\2\u011e\u011f\7t\2\2"+
		"\u011f\u0120\7p\2\2\u0120*\3\2\2\2\u0121\u0122\7c\2\2\u0122\u0123\7n\2"+
		"\2\u0123\u0124\7k\2\2\u0124\u0125\7i\2\2\u0125\u0126\7p\2\2\u0126,\3\2"+
		"\2\2\u0127\u0128\7t\2\2\u0128\u0129\7g\2\2\u0129\u012a\7i\2\2\u012a\u012b"+
		"\7k\2\2\u012b\u012c\7u\2\2\u012c\u012d\7v\2\2\u012d\u012e\7g\2\2\u012e"+
		"\u012f\7t\2\2\u012f.\3\2\2\2\u0130\u0131\7x\2\2\u0131\u0132\7q\2\2\u0132"+
		"\u0133\7n\2\2\u0133\u0134\7c\2\2\u0134\u0135\7v\2\2\u0135\u0136\7k\2\2"+
		"\u0136\u0137\7n\2\2\u0137\u0138\7g\2\2\u0138\60\3\2\2\2\u0139\u013a\7"+
		"k\2\2\u013a\u013b\7p\2\2\u013b\u013c\7v\2\2\u013c\u013d\7g\2\2\u013d\u013e"+
		"\7t\2\2\u013e\u013f\7t\2\2\u013f\u0140\7w\2\2\u0140\u0141\7r\2\2\u0141"+
		"\u0142\7v\2\2\u0142\62\3\2\2\2\u0143\u0144\7k\2\2\u0144\u0145\7h\2\2\u0145"+
		"\64\3\2\2\2\u0146\u0147\7g\2\2\u0147\u0148\7n\2\2\u0148\u0149\7u\2\2\u0149"+
		"\u014a\7g\2\2\u014a\66\3\2\2\2\u014b\u014c\7y\2\2\u014c\u014d\7j\2\2\u014d"+
		"\u014e\7k\2\2\u014e\u014f\7n\2\2\u014f\u0150\7g\2\2\u01508\3\2\2\2\u0151"+
		"\u0152\7f\2\2\u0152\u0153\7q\2\2\u0153:\3\2\2\2\u0154\u0155\7h\2\2\u0155"+
		"\u0156\7q\2\2\u0156\u0157\7t\2\2\u0157<\3\2\2\2\u0158\u0159\7t\2\2\u0159"+
		"\u015a\7g\2\2\u015a\u015b\7v\2\2\u015b\u015c\7w\2\2\u015c\u015d\7t\2\2"+
		"\u015d\u015e\7p\2\2\u015e>\3\2\2\2\u015f\u0160\7c\2\2\u0160\u0161\7u\2"+
		"\2\u0161\u0162\7o\2\2\u0162@\3\2\2\2\u0163\u0164\7\60\2\2\u0164\u0165"+
		"\7\60\2\2\u0165B\3\2\2\2\u0166\u0167\7u\2\2\u0167\u0168\7k\2\2\u0168\u0169"+
		"\7i\2\2\u0169\u016a\7p\2\2\u016a\u016b\7g\2\2\u016b\u016c\7f\2\2\u016c"+
		"D\3\2\2\2\u016d\u016e\7,\2\2\u016eF\3\2\2\2\u016f\u0170\7]\2\2\u0170H"+
		"\3\2\2\2\u0171\u0172\7_\2\2\u0172J\3\2\2\2\u0173\u0174\7/\2\2\u0174\u0175"+
		"\7/\2\2\u0175L\3\2\2\2\u0176\u0177\7-\2\2\u0177\u0178\7-\2\2\u0178N\3"+
		"\2\2\2\u0179\u017a\7-\2\2\u017aP\3\2\2\2\u017b\u017c\7/\2\2\u017cR\3\2"+
		"\2\2\u017d\u017e\7#\2\2\u017eT\3\2\2\2\u017f\u0180\7(\2\2\u0180V\3\2\2"+
		"\2\u0181\u0182\7\u0080\2\2\u0182X\3\2\2\2\u0183\u0184\7@\2\2\u0184\u0185"+
		"\7@\2\2\u0185Z\3\2\2\2\u0186\u0187\7>\2\2\u0187\u0188\7>\2\2\u0188\\\3"+
		"\2\2\2\u0189\u018a\7\61\2\2\u018a^\3\2\2\2\u018b\u018c\7\'\2\2\u018c`"+
		"\3\2\2\2\u018d\u018e\7>\2\2\u018eb\3\2\2\2\u018f\u0190\7@\2\2\u0190d\3"+
		"\2\2\2\u0191\u0192\7?\2\2\u0192\u0193\7?\2\2\u0193f\3\2\2\2\u0194\u0195"+
		"\7#\2\2\u0195\u0196\7?\2\2\u0196h\3\2\2\2\u0197\u0198\7>\2\2\u0198\u0199"+
		"\7?\2\2\u0199j\3\2\2\2\u019a\u019b\7@\2\2\u019b\u019c\7?\2\2\u019cl\3"+
		"\2\2\2\u019d\u019e\7`\2\2\u019en\3\2\2\2\u019f\u01a0\7~\2\2\u01a0p\3\2"+
		"\2\2\u01a1\u01a2\7(\2\2\u01a2\u01a3\7(\2\2\u01a3r\3\2\2\2\u01a4\u01a5"+
		"\7~\2\2\u01a5\u01a6\7~\2\2\u01a6t\3\2\2\2\u01a7\u01a8\7-\2\2\u01a8\u01a9"+
		"\7?\2\2\u01a9v\3\2\2\2\u01aa\u01ab\7/\2\2\u01ab\u01ac\7?\2\2\u01acx\3"+
		"\2\2\2\u01ad\u01ae\7,\2\2\u01ae\u01af\7?\2\2\u01afz\3\2\2\2\u01b0\u01b1"+
		"\7\61\2\2\u01b1\u01b2\7?\2\2\u01b2|\3\2\2\2\u01b3\u01b4\7\'\2\2\u01b4"+
		"\u01b5\7?\2\2\u01b5~\3\2\2\2\u01b6\u01b7\7>\2\2\u01b7\u01b8\7>\2\2\u01b8"+
		"\u01b9\7?\2\2\u01b9\u0080\3\2\2\2\u01ba\u01bb\7@\2\2\u01bb\u01bc\7@\2"+
		"\2\u01bc\u01bd\7?\2\2\u01bd\u0082\3\2\2\2\u01be\u01bf\7(\2\2\u01bf\u01c0"+
		"\7?\2\2\u01c0\u0084\3\2\2\2\u01c1\u01c2\7~\2\2\u01c2\u01c3\7?\2\2\u01c3"+
		"\u0086\3\2\2\2\u01c4\u01c5\7`\2\2\u01c5\u01c6\7?\2\2\u01c6\u0088\3\2\2"+
		"\2\u01c7\u01c8\7\60\2\2\u01c8\u01c9\7d\2\2\u01c9\u01ca\7{\2\2\u01ca\u01cb"+
		"\7v\2\2\u01cb\u01cc\7g\2\2\u01cc\u008a\3\2\2\2\u01cd\u01ce\7%\2\2\u01ce"+
		"\u008c\3\2\2\2\u01cf\u01d0\7\60\2\2\u01d0\u008e\3\2\2\2\u01d1\u01d2\7"+
		"d\2\2\u01d2\u01d3\7t\2\2\u01d3\u02b0\7m\2\2\u01d4\u01d5\7q\2\2\u01d5\u01d6"+
		"\7t\2\2\u01d6\u02b0\7c\2\2\u01d7\u01d8\7m\2\2\u01d8\u01d9\7k\2\2\u01d9"+
		"\u02b0\7n\2\2\u01da\u01db\7u\2\2\u01db\u01dc\7n\2\2\u01dc\u02b0\7q\2\2"+
		"\u01dd\u01de\7p\2\2\u01de\u01df\7q\2\2\u01df\u02b0\7r\2\2\u01e0\u01e1"+
		"\7c\2\2\u01e1\u01e2\7u\2\2\u01e2\u02b0\7n\2\2\u01e3\u01e4\7r\2\2\u01e4"+
		"\u01e5\7j\2\2\u01e5\u02b0\7r\2\2\u01e6\u01e7\7c\2\2\u01e7\u01e8\7p\2\2"+
		"\u01e8\u02b0\7e\2\2\u01e9\u01ea\7d\2\2\u01ea\u01eb\7r\2\2\u01eb\u02b0"+
		"\7n\2\2\u01ec\u01ed\7e\2\2\u01ed\u01ee\7n\2\2\u01ee\u02b0\7e\2\2\u01ef"+
		"\u01f0\7l\2\2\u01f0\u01f1\7u\2\2\u01f1\u02b0\7t\2\2\u01f2\u01f3\7c\2\2"+
		"\u01f3\u01f4\7p\2\2\u01f4\u02b0\7f\2\2\u01f5\u01f6\7t\2\2\u01f6\u01f7"+
		"\7n\2\2\u01f7\u02b0\7c\2\2\u01f8\u01f9\7d\2\2\u01f9\u01fa\7k\2\2\u01fa"+
		"\u02b0\7v\2\2\u01fb\u01fc\7t\2\2\u01fc\u01fd\7q\2\2\u01fd\u02b0\7n\2\2"+
		"\u01fe\u01ff\7r\2\2\u01ff\u0200\7n\2\2\u0200\u02b0\7c\2\2\u0201\u0202"+
		"\7r\2\2\u0202\u0203\7n\2\2\u0203\u02b0\7r\2\2\u0204\u0205\7d\2\2\u0205"+
		"\u0206\7o\2\2\u0206\u02b0\7k\2\2\u0207\u0208\7u\2\2\u0208\u0209\7g\2\2"+
		"\u0209\u02b0\7e\2\2\u020a\u020b\7t\2\2\u020b\u020c\7v\2\2\u020c\u02b0"+
		"\7k\2\2\u020d\u020e\7g\2\2\u020e\u020f\7q\2\2\u020f\u02b0\7t\2\2\u0210"+
		"\u0211\7u\2\2\u0211\u0212\7t\2\2\u0212\u02b0\7g\2\2\u0213\u0214\7n\2\2"+
		"\u0214\u0215\7u\2\2\u0215\u02b0\7t\2\2\u0216\u0217\7r\2\2\u0217\u0218"+
		"\7j\2\2\u0218\u02b0\7c\2\2\u0219\u021a\7c\2\2\u021a\u021b\7n\2\2\u021b"+
		"\u02b0\7t\2\2\u021c\u021d\7l\2\2\u021d\u021e\7o\2\2\u021e\u02b0\7r\2\2"+
		"\u021f\u0220\7d\2\2\u0220\u0221\7x\2\2\u0221\u02b0\7e\2\2\u0222\u0223"+
		"\7e\2\2\u0223\u0224\7n\2\2\u0224\u02b0\7k\2\2\u0225\u0226\7t\2\2\u0226"+
		"\u0227\7v\2\2\u0227\u02b0\7u\2\2\u0228\u0229\7c\2\2\u0229\u022a\7f\2\2"+
		"\u022a\u02b0\7e\2\2\u022b\u022c\7t\2\2\u022c\u022d\7t\2\2\u022d\u02b0"+
		"\7c\2\2\u022e\u022f\7d\2\2\u022f\u0230\7x\2\2\u0230\u02b0\7u\2\2\u0231"+
		"\u0232\7u\2\2\u0232\u0233\7g\2\2\u0233\u02b0\7k\2\2\u0234\u0235\7u\2\2"+
		"\u0235\u0236\7c\2\2\u0236\u02b0\7z\2\2\u0237\u0238\7u\2\2\u0238\u0239"+
		"\7v\2\2\u0239\u02b0\7{\2\2\u023a\u023b\7u\2\2\u023b\u023c\7v\2\2\u023c"+
		"\u02b0\7c\2\2\u023d\u023e\7u\2\2\u023e\u023f\7v\2\2\u023f\u02b0\7z\2\2"+
		"\u0240\u0241\7f\2\2\u0241\u0242\7g\2\2\u0242\u02b0\7{\2\2\u0243\u0244"+
		"\7v\2\2\u0244\u0245\7z\2\2\u0245\u02b0\7c\2\2\u0246\u0247\7z\2\2\u0247"+
		"\u0248\7c\2\2\u0248\u02b0\7c\2\2\u0249\u024a\7d\2\2\u024a\u024b\7e\2\2"+
		"\u024b\u02b0\7e\2\2\u024c\u024d\7c\2\2\u024d\u024e\7j\2\2\u024e\u02b0"+
		"\7z\2\2\u024f\u0250\7v\2\2\u0250\u0251\7{\2\2\u0251\u02b0\7c\2\2\u0252"+
		"\u0253\7v\2\2\u0253\u0254\7z\2\2\u0254\u02b0\7u\2\2\u0255\u0256\7v\2\2"+
		"\u0256\u0257\7c\2\2\u0257\u02b0\7u\2\2\u0258\u0259\7u\2\2\u0259\u025a"+
		"\7j\2\2\u025a\u02b0\7{\2\2\u025b\u025c\7u\2\2\u025c\u025d\7j\2\2\u025d"+
		"\u02b0\7z\2\2\u025e\u025f\7n\2\2\u025f\u0260\7f\2\2\u0260\u02b0\7{\2\2"+
		"\u0261\u0262\7n\2\2\u0262\u0263\7f\2\2\u0263\u02b0\7c\2\2\u0264\u0265"+
		"\7n\2\2\u0265\u0266\7f\2\2\u0266\u02b0\7z\2\2\u0267\u0268\7n\2\2\u0268"+
		"\u0269\7c\2\2\u0269\u02b0\7z\2\2\u026a\u026b\7v\2\2\u026b\u026c\7c\2\2"+
		"\u026c\u02b0\7{\2\2\u026d\u026e\7v\2\2\u026e\u026f\7c\2\2\u026f\u02b0"+
		"\7z\2\2\u0270\u0271\7d\2\2\u0271\u0272\7e\2\2\u0272\u02b0\7u\2\2\u0273"+
		"\u0274\7e\2\2\u0274\u0275\7n\2\2\u0275\u02b0\7x\2\2\u0276\u0277\7v\2\2"+
		"\u0277\u0278\7u\2\2\u0278\u02b0\7z\2\2\u0279\u027a\7n\2\2\u027a\u027b"+
		"\7c\2\2\u027b\u02b0\7u\2\2\u027c\u027d\7e\2\2\u027d\u027e\7r\2\2\u027e"+
		"\u02b0\7{\2\2\u027f\u0280\7e\2\2\u0280\u0281\7o\2\2\u0281\u02b0\7r\2\2"+
		"\u0282\u0283\7e\2\2\u0283\u0284\7r\2\2\u0284\u02b0\7z\2\2\u0285\u0286"+
		"\7f\2\2\u0286\u0287\7e\2\2\u0287\u02b0\7r\2\2\u0288\u0289\7f\2\2\u0289"+
		"\u028a\7g\2\2\u028a\u02b0\7e\2\2\u028b\u028c\7k\2\2\u028c\u028d\7p\2\2"+
		"\u028d\u02b0\7e\2\2\u028e\u028f\7c\2\2\u028f\u0290\7z\2\2\u0290\u02b0"+
		"\7u\2\2\u0291\u0292\7d\2\2\u0292\u0293\7p\2\2\u0293\u02b0\7g\2\2\u0294"+
		"\u0295\7e\2\2\u0295\u0296\7n\2\2\u0296\u02b0\7f\2\2\u0297\u0298\7u\2\2"+
		"\u0298\u0299\7d\2\2\u0299\u02b0\7e\2\2\u029a\u029b\7k\2\2\u029b\u029c"+
		"\7u\2\2\u029c\u02b0\7e\2\2\u029d\u029e\7k\2\2\u029e\u029f\7p\2\2\u029f"+
		"\u02b0\7z\2\2\u02a0\u02a1\7d\2\2\u02a1\u02a2\7g\2\2\u02a2\u02b0\7s\2\2"+
		"\u02a3\u02a4\7u\2\2\u02a4\u02a5\7g\2\2\u02a5\u02b0\7f\2\2\u02a6\u02a7"+
		"\7f\2\2\u02a7\u02a8\7g\2\2\u02a8\u02b0\7z\2\2\u02a9\u02aa\7k\2\2\u02aa"+
		"\u02ab\7p\2\2\u02ab\u02b0\7{\2\2\u02ac\u02ad\7t\2\2\u02ad\u02ae\7q\2\2"+
		"\u02ae\u02b0\7t\2\2\u02af\u01d1\3\2\2\2\u02af\u01d4\3\2\2\2\u02af\u01d7"+
		"\3\2\2\2\u02af\u01da\3\2\2\2\u02af\u01dd\3\2\2\2\u02af\u01e0\3\2\2\2\u02af"+
		"\u01e3\3\2\2\2\u02af\u01e6\3\2\2\2\u02af\u01e9\3\2\2\2\u02af\u01ec\3\2"+
		"\2\2\u02af\u01ef\3\2\2\2\u02af\u01f2\3\2\2\2\u02af\u01f5\3\2\2\2\u02af"+
		"\u01f8\3\2\2\2\u02af\u01fb\3\2\2\2\u02af\u01fe\3\2\2\2\u02af\u0201\3\2"+
		"\2\2\u02af\u0204\3\2\2\2\u02af\u0207\3\2\2\2\u02af\u020a\3\2\2\2\u02af"+
		"\u020d\3\2\2\2\u02af\u0210\3\2\2\2\u02af\u0213\3\2\2\2\u02af\u0216\3\2"+
		"\2\2\u02af\u0219\3\2\2\2\u02af\u021c\3\2\2\2\u02af\u021f\3\2\2\2\u02af"+
		"\u0222\3\2\2\2\u02af\u0225\3\2\2\2\u02af\u0228\3\2\2\2\u02af\u022b\3\2"+
		"\2\2\u02af\u022e\3\2\2\2\u02af\u0231\3\2\2\2\u02af\u0234\3\2\2\2\u02af"+
		"\u0237\3\2\2\2\u02af\u023a\3\2\2\2\u02af\u023d\3\2\2\2\u02af\u0240\3\2"+
		"\2\2\u02af\u0243\3\2\2\2\u02af\u0246\3\2\2\2\u02af\u0249\3\2\2\2\u02af"+
		"\u024c\3\2\2\2\u02af\u024f\3\2\2\2\u02af\u0252\3\2\2\2\u02af\u0255\3\2"+
		"\2\2\u02af\u0258\3\2\2\2\u02af\u025b\3\2\2\2\u02af\u025e\3\2\2\2\u02af"+
		"\u0261\3\2\2\2\u02af\u0264\3\2\2\2\u02af\u0267\3\2\2\2\u02af\u026a\3\2"+
		"\2\2\u02af\u026d\3\2\2\2\u02af\u0270\3\2\2\2\u02af\u0273\3\2\2\2\u02af"+
		"\u0276\3\2\2\2\u02af\u0279\3\2\2\2\u02af\u027c\3\2\2\2\u02af\u027f\3\2"+
		"\2\2\u02af\u0282\3\2\2\2\u02af\u0285\3\2\2\2\u02af\u0288\3\2\2\2\u02af"+
		"\u028b\3\2\2\2\u02af\u028e\3\2\2\2\u02af\u0291\3\2\2\2\u02af\u0294\3\2"+
		"\2\2\u02af\u0297\3\2\2\2\u02af\u029a\3\2\2\2\u02af\u029d\3\2\2\2\u02af"+
		"\u02a0\3\2\2\2\u02af\u02a3\3\2\2\2\u02af\u02a6\3\2\2\2\u02af\u02a9\3\2"+
		"\2\2\u02af\u02ac\3\2\2\2\u02b0\u0090\3\2\2\2\u02b1\u02b2\7}\2\2\u02b2"+
		"\u02b3\7}\2\2\u02b3\u02b7\3\2\2\2\u02b4\u02b6\13\2\2\2\u02b5\u02b4\3\2"+
		"\2\2\u02b6\u02b9\3\2\2\2\u02b7\u02b8\3\2\2\2\u02b7\u02b5\3\2\2\2\u02b8"+
		"\u02ba\3\2\2\2\u02b9\u02b7\3\2\2\2\u02ba\u02bb\7\177\2\2\u02bb\u02bc\7"+
		"\177\2\2\u02bc\u0092\3\2\2\2\u02bd\u02be\7d\2\2\u02be\u02bf\7{\2\2\u02bf"+
		"\u02c0\7v\2\2\u02c0\u02d3\7g\2\2\u02c1\u02c2\7y\2\2\u02c2\u02c3\7q\2\2"+
		"\u02c3\u02c4\7t\2\2\u02c4\u02d3\7f\2\2\u02c5\u02c6\7f\2\2\u02c6\u02c7"+
		"\7y\2\2\u02c7\u02c8\7q\2\2\u02c8\u02c9\7t\2\2\u02c9\u02d3\7f\2\2\u02ca"+
		"\u02cb\7d\2\2\u02cb\u02cc\7q\2\2\u02cc\u02cd\7q\2\2\u02cd\u02d3\7n\2\2"+
		"\u02ce\u02cf\7x\2\2\u02cf\u02d0\7q\2\2\u02d0\u02d1\7k\2\2\u02d1\u02d3"+
		"\7f\2\2\u02d2\u02bd\3\2\2\2\u02d2\u02c1\3\2\2\2\u02d2\u02c5\3\2\2\2\u02d2"+
		"\u02ca\3\2\2\2\u02d2\u02ce\3\2\2\2\u02d3\u0094\3\2\2\2\u02d4\u02da\7$"+
		"\2\2\u02d5\u02d6\7^\2\2\u02d6\u02d9\7$\2\2\u02d7\u02d9\n\2\2\2\u02d8\u02d5"+
		"\3\2\2\2\u02d8\u02d7\3\2\2\2\u02d9\u02dc\3\2\2\2\u02da\u02d8\3\2\2\2\u02da"+
		"\u02db\3\2\2\2\u02db\u02dd\3\2\2\2\u02dc\u02da\3\2\2\2\u02dd\u02de\7$"+
		"\2\2\u02de\u0096\3\2\2\2\u02df\u02e3\7)\2\2\u02e0\u02e1\7^\2\2\u02e1\u02e4"+
		"\7)\2\2\u02e2\u02e4\n\3\2\2\u02e3\u02e0\3\2\2\2\u02e3\u02e2\3\2\2\2\u02e4"+
		"\u02e5\3\2\2\2\u02e5\u02e6\7)\2\2\u02e6\u0098\3\2\2\2\u02e7\u02e8\7v\2"+
		"\2\u02e8\u02e9\7t\2\2\u02e9\u02ea\7w\2\2\u02ea\u02f1\7g\2\2\u02eb\u02ec"+
		"\7h\2\2\u02ec\u02ed\7c\2\2\u02ed\u02ee\7n\2\2\u02ee\u02ef\7u\2\2\u02ef"+
		"\u02f1\7g\2\2\u02f0\u02e7\3\2\2\2\u02f0\u02eb\3\2\2\2\u02f1\u009a\3\2"+
		"\2\2\u02f2\u02f5\5\u009dO\2\u02f3\u02f5\5\u00a5S\2\u02f4\u02f2\3\2\2\2"+
		"\u02f4\u02f3\3\2\2\2\u02f5\u009c\3\2\2\2\u02f6\u02fa\5\u009fP\2\u02f7"+
		"\u02fa\5\u00a1Q\2\u02f8\u02fa\5\u00a3R\2\u02f9\u02f6\3\2\2\2\u02f9\u02f7"+
		"\3\2\2\2\u02f9\u02f8\3\2\2\2\u02fa\u009e\3\2\2\2\u02fb\u0301\7\'\2\2\u02fc"+
		"\u02fd\7\62\2\2\u02fd\u0301\7d\2\2\u02fe\u02ff\7\62\2\2\u02ff\u0301\7"+
		"D\2\2\u0300\u02fb\3\2\2\2\u0300\u02fc\3\2\2\2\u0300\u02fe\3\2\2\2\u0301"+
		"\u0305\3\2\2\2\u0302\u0304\5\u00adW\2\u0303\u0302\3\2\2\2\u0304\u0307"+
		"\3\2\2\2\u0305\u0303\3\2\2\2\u0305\u0306\3\2\2\2\u0306\u0308\3\2\2\2\u0307"+
		"\u0305\3\2\2\2\u0308\u030a\7\60\2\2\u0309\u030b\5\u00adW\2\u030a\u0309"+
		"\3\2\2\2\u030b\u030c\3\2\2\2\u030c\u030a\3\2\2\2\u030c\u030d\3\2\2\2\u030d"+
		"\u00a0\3\2\2\2\u030e\u0310\5\u00afX\2\u030f\u030e\3\2\2\2\u0310\u0313"+
		"\3\2\2\2\u0311\u030f\3\2\2\2\u0311\u0312\3\2\2\2\u0312\u0314\3\2\2\2\u0313"+
		"\u0311\3\2\2\2\u0314\u0316\7\60\2\2\u0315\u0317\5\u00afX\2\u0316\u0315"+
		"\3\2\2\2\u0317\u0318\3\2\2\2\u0318\u0316\3\2\2\2\u0318\u0319\3\2\2\2\u0319"+
		"\u00a2\3\2\2\2\u031a\u0320\7&\2\2\u031b\u031c\7\62\2\2\u031c\u0320\7z"+
		"\2\2\u031d\u031e\7\62\2\2\u031e\u0320\7Z\2\2\u031f\u031a\3\2\2\2\u031f"+
		"\u031b\3\2\2\2\u031f\u031d\3\2\2\2\u0320\u0324\3\2\2\2\u0321\u0323\5\u00b1"+
		"Y\2\u0322\u0321\3\2\2\2\u0323\u0326\3\2\2\2\u0324\u0322\3\2\2\2\u0324"+
		"\u0325\3\2\2\2\u0325\u0327\3\2\2\2\u0326\u0324\3\2\2\2\u0327\u0329\7\60"+
		"\2\2\u0328\u032a\5\u00b1Y\2\u0329\u0328\3\2\2\2\u032a\u032b\3\2\2\2\u032b"+
		"\u0329\3\2\2\2\u032b\u032c\3\2\2\2\u032c\u00a4\3\2\2\2\u032d\u0331\5\u00a9"+
		"U\2\u032e\u0331\5\u00abV\2\u032f\u0331\5\u00a7T\2\u0330\u032d\3\2\2\2"+
		"\u0330\u032e\3\2\2\2\u0330\u032f\3\2\2\2\u0331\u00a6\3\2\2\2\u0332\u0333"+
		"\7\62\2\2\u0333\u0335\t\4\2\2\u0334\u0336\5\u00adW\2\u0335\u0334\3\2\2"+
		"\2\u0336\u0337\3\2\2\2\u0337\u0335\3\2\2\2\u0337\u0338\3\2\2\2\u0338\u0340"+
		"\3\2\2\2\u0339\u033b\7\'\2\2\u033a\u033c\5\u00adW\2\u033b\u033a\3\2\2"+
		"\2\u033c\u033d\3\2\2\2\u033d\u033b\3\2\2\2\u033d\u033e\3\2\2\2\u033e\u0340"+
		"\3\2\2\2\u033f\u0332\3\2\2\2\u033f\u0339\3\2\2\2\u0340\u00a8\3\2\2\2\u0341"+
		"\u0343\5\u00afX\2\u0342\u0341\3\2\2\2\u0343\u0344\3\2\2\2\u0344\u0342"+
		"\3\2\2\2\u0344\u0345\3\2\2\2\u0345\u00aa\3\2\2\2\u0346\u034c\7&\2\2\u0347"+
		"\u0348\7\62\2\2\u0348\u034c\7z\2\2\u0349\u034a\7\62\2\2\u034a\u034c\7"+
		"Z\2\2\u034b\u0346\3\2\2\2\u034b\u0347\3\2\2\2\u034b\u0349\3\2\2\2\u034c"+
		"\u034e\3\2\2\2\u034d\u034f\5\u00b1Y\2\u034e\u034d\3\2\2\2\u034f\u0350"+
		"\3\2\2\2\u0350\u034e\3\2\2\2\u0350\u0351\3\2\2\2\u0351\u00ac\3\2\2\2\u0352"+
		"\u0353\t\5\2\2\u0353\u00ae\3\2\2\2\u0354\u0355\t\6\2\2\u0355\u00b0\3\2"+
		"\2\2\u0356\u0357\t\7\2\2\u0357\u00b2\3\2\2\2\u0358\u035c\5\u00b5[\2\u0359"+
		"\u035b\5\u00b7\\\2\u035a\u0359\3\2\2\2\u035b\u035e\3\2\2\2\u035c\u035a"+
		"\3\2\2\2\u035c\u035d\3\2\2\2\u035d\u00b4\3\2\2\2\u035e\u035c\3\2\2\2\u035f"+
		"\u0360\t\b\2\2\u0360\u00b6\3\2\2\2\u0361\u0362\t\t\2\2\u0362\u00b8\3\2"+
		"\2\2\u0363\u0367\7#\2\2\u0364\u0366\5\u00b7\\\2\u0365\u0364\3\2\2\2\u0366"+
		"\u0369\3\2\2\2\u0367\u0365\3\2\2\2\u0367\u0368\3\2\2\2\u0368\u036b\3\2"+
		"\2\2\u0369\u0367\3\2\2\2\u036a\u036c\t\n\2\2\u036b\u036a\3\2\2\2\u036c"+
		"\u036d\3\2\2\2\u036d\u036b\3\2\2\2\u036d\u036e\3\2\2\2\u036e\u00ba\3\2"+
		"\2\2\u036f\u0371\t\13\2\2\u0370\u036f\3\2\2\2\u0371\u0372\3\2\2\2\u0372"+
		"\u0370\3\2\2\2\u0372\u0373\3\2\2\2\u0373\u0374\3\2\2\2\u0374\u0375\b^"+
		"\2\2\u0375\u00bc\3\2\2\2\u0376\u0377\7\61\2\2\u0377\u0378\7\61\2\2\u0378"+
		"\u037c\3\2\2\2\u0379\u037b\n\f\2\2\u037a\u0379\3\2\2\2\u037b\u037e\3\2"+
		"\2\2\u037c\u037a\3\2\2\2\u037c\u037d\3\2\2\2\u037d\u037f\3\2\2\2\u037e"+
		"\u037c\3\2\2\2\u037f\u0380\b_\3\2\u0380\u00be\3\2\2\2\u0381\u0382\7\61"+
		"\2\2\u0382\u0383\7,\2\2\u0383\u0387\3\2\2\2\u0384\u0386\13\2\2\2\u0385"+
		"\u0384\3\2\2\2\u0386\u0389\3\2\2\2\u0387\u0388\3\2\2\2\u0387\u0385\3\2"+
		"\2\2\u0388\u038a\3\2\2\2\u0389\u0387\3\2\2\2\u038a\u038b\7,\2\2\u038b"+
		"\u038c\7\61\2\2\u038c\u038d\3\2\2\2\u038d\u038e\b`\3\2\u038e\u00c0\3\2"+
		"\2\2!\2\u02af\u02b7\u02d2\u02d8\u02da\u02e3\u02f0\u02f4\u02f9\u0300\u0305"+
		"\u030c\u0311\u0318\u031f\u0324\u032b\u0330\u0337\u033d\u033f\u0344\u034b"+
		"\u0350\u035c\u0367\u036d\u0372\u037c\u0387\4\2\3\2\2\4\2";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}
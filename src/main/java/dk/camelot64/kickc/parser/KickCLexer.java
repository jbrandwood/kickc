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
		T__66=67, T__67=68, T__68=69, T__69=70, T__70=71, T__71=72, T__72=73, 
		T__73=74, T__74=75, T__75=76, T__76=77, T__77=78, MNEMONIC=79, KICKASM=80, 
		SIMPLETYPE=81, STRING=82, CHAR=83, BOOLEAN=84, NUMBER=85, NUMFLOAT=86, 
		BINFLOAT=87, DECFLOAT=88, HEXFLOAT=89, NUMINT=90, BININTEGER=91, DECINTEGER=92, 
		HEXINTEGER=93, NAME=94, ASMREL=95, WS=96, COMMENT_LINE=97, COMMENT_BLOCK=98;
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
		"T__65", "T__66", "T__67", "T__68", "T__69", "T__70", "T__71", "T__72", 
		"T__73", "T__74", "T__75", "T__76", "T__77", "MNEMONIC", "KICKASM", "SIMPLETYPE", 
		"STRING", "CHAR", "BOOLEAN", "NUMBER", "NUMFLOAT", "BINFLOAT", "DECFLOAT", 
		"HEXFLOAT", "NUMINT", "BININTEGER", "DECINTEGER", "HEXINTEGER", "BINDIGIT", 
		"DECDIGIT", "HEXDIGIT", "NAME", "NAME_START", "NAME_CHAR", "ASMREL", "WS", 
		"COMMENT_LINE", "COMMENT_BLOCK"
	};

	private static final String[] _LITERAL_NAMES = {
		null, "'import'", "';'", "','", "'='", "'('", "')'", "'{'", "'}'", "'#'", 
		"'pc'", "'const'", "'extern'", "'align'", "'register'", "'inline'", "'volatile'", 
		"'interrupt'", "'reserve'", "'if'", "'else'", "'while'", "'do'", "'for'", 
		"'return'", "'break'", "'continue'", "'asm'", "':'", "'..'", "'signed'", 
		"'unsigned'", "'*'", "'['", "']'", "'struct'", "'.'", "'->'", "'sizeof'", 
		"'typeid'", "'--'", "'++'", "'+'", "'-'", "'!'", "'&'", "'~'", "'>>'", 
		"'<<'", "'/'", "'%'", "'<'", "'>'", "'=='", "'!='", "'<='", "'>='", "'^'", 
		"'|'", "'&&'", "'||'", "'?'", "'+='", "'-='", "'*='", "'/='", "'%='", 
		"'<<='", "'>>='", "'&='", "'|='", "'^='", "'kickasm'", "'resource'", "'uses'", 
		"'clobbers'", "'bytes'", "'cycles'", "'.byte'"
	};
	private static final String[] _SYMBOLIC_NAMES = {
		null, null, null, null, null, null, null, null, null, null, null, null, 
		null, null, null, null, null, null, null, null, null, null, null, null, 
		null, null, null, null, null, null, null, null, null, null, null, null, 
		null, null, null, null, null, null, null, null, null, null, null, null, 
		null, null, null, null, null, null, null, null, null, null, null, null, 
		null, null, null, null, null, null, null, null, null, null, null, null, 
		null, null, null, null, null, null, null, "MNEMONIC", "KICKASM", "SIMPLETYPE", 
		"STRING", "CHAR", "BOOLEAN", "NUMBER", "NUMFLOAT", "BINFLOAT", "DECFLOAT", 
		"HEXFLOAT", "NUMINT", "BININTEGER", "DECINTEGER", "HEXINTEGER", "NAME", 
		"ASMREL", "WS", "COMMENT_LINE", "COMMENT_BLOCK"
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
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\2d\u03ea\b\1\4\2\t"+
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
		"`\t`\4a\ta\4b\tb\4c\tc\4d\td\4e\te\4f\tf\4g\tg\4h\th\3\2\3\2\3\2\3\2\3"+
		"\2\3\2\3\2\3\3\3\3\3\4\3\4\3\5\3\5\3\6\3\6\3\7\3\7\3\b\3\b\3\t\3\t\3\n"+
		"\3\n\3\13\3\13\3\13\3\f\3\f\3\f\3\f\3\f\3\f\3\r\3\r\3\r\3\r\3\r\3\r\3"+
		"\r\3\16\3\16\3\16\3\16\3\16\3\16\3\17\3\17\3\17\3\17\3\17\3\17\3\17\3"+
		"\17\3\17\3\20\3\20\3\20\3\20\3\20\3\20\3\20\3\21\3\21\3\21\3\21\3\21\3"+
		"\21\3\21\3\21\3\21\3\22\3\22\3\22\3\22\3\22\3\22\3\22\3\22\3\22\3\22\3"+
		"\23\3\23\3\23\3\23\3\23\3\23\3\23\3\23\3\24\3\24\3\24\3\25\3\25\3\25\3"+
		"\25\3\25\3\26\3\26\3\26\3\26\3\26\3\26\3\27\3\27\3\27\3\30\3\30\3\30\3"+
		"\30\3\31\3\31\3\31\3\31\3\31\3\31\3\31\3\32\3\32\3\32\3\32\3\32\3\32\3"+
		"\33\3\33\3\33\3\33\3\33\3\33\3\33\3\33\3\33\3\34\3\34\3\34\3\34\3\35\3"+
		"\35\3\36\3\36\3\36\3\37\3\37\3\37\3\37\3\37\3\37\3\37\3 \3 \3 \3 \3 \3"+
		" \3 \3 \3 \3!\3!\3\"\3\"\3#\3#\3$\3$\3$\3$\3$\3$\3$\3%\3%\3&\3&\3&\3\'"+
		"\3\'\3\'\3\'\3\'\3\'\3\'\3(\3(\3(\3(\3(\3(\3(\3)\3)\3)\3*\3*\3*\3+\3+"+
		"\3,\3,\3-\3-\3.\3.\3/\3/\3\60\3\60\3\60\3\61\3\61\3\61\3\62\3\62\3\63"+
		"\3\63\3\64\3\64\3\65\3\65\3\66\3\66\3\66\3\67\3\67\3\67\38\38\38\39\3"+
		"9\39\3:\3:\3;\3;\3<\3<\3<\3=\3=\3=\3>\3>\3?\3?\3?\3@\3@\3@\3A\3A\3A\3"+
		"B\3B\3B\3C\3C\3C\3D\3D\3D\3D\3E\3E\3E\3E\3F\3F\3F\3G\3G\3G\3H\3H\3H\3"+
		"I\3I\3I\3I\3I\3I\3I\3I\3J\3J\3J\3J\3J\3J\3J\3J\3J\3K\3K\3K\3K\3K\3L\3"+
		"L\3L\3L\3L\3L\3L\3L\3L\3M\3M\3M\3M\3M\3M\3N\3N\3N\3N\3N\3N\3N\3O\3O\3"+
		"O\3O\3O\3O\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3"+
		"P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3"+
		"P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3"+
		"P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3"+
		"P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3"+
		"P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3"+
		"P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3"+
		"P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3"+
		"P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3"+
		"P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\5P\u02f4\nP\3"+
		"Q\3Q\3Q\3Q\7Q\u02fa\nQ\fQ\16Q\u02fd\13Q\3Q\3Q\3Q\3R\3R\3R\3R\3R\3R\3R"+
		"\3R\3R\3R\3R\3R\3R\3R\3R\3R\3R\3R\3R\3R\3R\3R\3R\3R\3R\3R\3R\3R\3R\3R"+
		"\3R\3R\3R\3R\3R\3R\3R\5R\u0327\nR\3S\3S\3S\3S\7S\u032d\nS\fS\16S\u0330"+
		"\13S\3S\3S\5S\u0334\nS\3T\3T\3T\3T\5T\u033a\nT\3T\3T\3U\3U\3U\3U\3U\3"+
		"U\3U\3U\3U\5U\u0347\nU\3V\3V\5V\u034b\nV\3W\3W\3W\5W\u0350\nW\3X\3X\3"+
		"X\3X\3X\5X\u0357\nX\3X\7X\u035a\nX\fX\16X\u035d\13X\3X\3X\6X\u0361\nX"+
		"\rX\16X\u0362\3Y\7Y\u0366\nY\fY\16Y\u0369\13Y\3Y\3Y\6Y\u036d\nY\rY\16"+
		"Y\u036e\3Z\3Z\3Z\3Z\3Z\5Z\u0376\nZ\3Z\7Z\u0379\nZ\fZ\16Z\u037c\13Z\3Z"+
		"\3Z\6Z\u0380\nZ\rZ\16Z\u0381\3[\3[\3[\5[\u0387\n[\3[\3[\3[\5[\u038c\n"+
		"[\3\\\3\\\3\\\6\\\u0391\n\\\r\\\16\\\u0392\3\\\3\\\6\\\u0397\n\\\r\\\16"+
		"\\\u0398\5\\\u039b\n\\\3]\6]\u039e\n]\r]\16]\u039f\3^\3^\3^\3^\3^\5^\u03a7"+
		"\n^\3^\6^\u03aa\n^\r^\16^\u03ab\3_\3_\3`\3`\3a\3a\3b\3b\7b\u03b6\nb\f"+
		"b\16b\u03b9\13b\3c\3c\3d\3d\3e\3e\7e\u03c1\ne\fe\16e\u03c4\13e\3e\6e\u03c7"+
		"\ne\re\16e\u03c8\3f\6f\u03cc\nf\rf\16f\u03cd\3f\3f\3g\3g\3g\3g\7g\u03d6"+
		"\ng\fg\16g\u03d9\13g\3g\3g\3h\3h\3h\3h\7h\u03e1\nh\fh\16h\u03e4\13h\3"+
		"h\3h\3h\3h\3h\4\u02fb\u03e2\2i\3\3\5\4\7\5\t\6\13\7\r\b\17\t\21\n\23\13"+
		"\25\f\27\r\31\16\33\17\35\20\37\21!\22#\23%\24\'\25)\26+\27-\30/\31\61"+
		"\32\63\33\65\34\67\359\36;\37= ?!A\"C#E$G%I&K\'M(O)Q*S+U,W-Y.[/]\60_\61"+
		"a\62c\63e\64g\65i\66k\67m8o9q:s;u<w=y>{?}@\177A\u0081B\u0083C\u0085D\u0087"+
		"E\u0089F\u008bG\u008dH\u008fI\u0091J\u0093K\u0095L\u0097M\u0099N\u009b"+
		"O\u009dP\u009fQ\u00a1R\u00a3S\u00a5T\u00a7U\u00a9V\u00abW\u00adX\u00af"+
		"Y\u00b1Z\u00b3[\u00b5\\\u00b7]\u00b9^\u00bb_\u00bd\2\u00bf\2\u00c1\2\u00c3"+
		"`\u00c5\2\u00c7\2\u00c9a\u00cbb\u00cdc\u00cfd\3\2\17\3\2$$\3\2))\4\2u"+
		"uww\7\2dfkknnuuyy\4\2DDdd\3\2\62\63\3\2\62;\5\2\62;CHch\5\2C\\aac|\6\2"+
		"\62;C\\aac|\4\2--//\6\2\13\f\17\17\"\"\u00a2\u00a2\4\2\f\f\17\17\2\u0459"+
		"\2\3\3\2\2\2\2\5\3\2\2\2\2\7\3\2\2\2\2\t\3\2\2\2\2\13\3\2\2\2\2\r\3\2"+
		"\2\2\2\17\3\2\2\2\2\21\3\2\2\2\2\23\3\2\2\2\2\25\3\2\2\2\2\27\3\2\2\2"+
		"\2\31\3\2\2\2\2\33\3\2\2\2\2\35\3\2\2\2\2\37\3\2\2\2\2!\3\2\2\2\2#\3\2"+
		"\2\2\2%\3\2\2\2\2\'\3\2\2\2\2)\3\2\2\2\2+\3\2\2\2\2-\3\2\2\2\2/\3\2\2"+
		"\2\2\61\3\2\2\2\2\63\3\2\2\2\2\65\3\2\2\2\2\67\3\2\2\2\29\3\2\2\2\2;\3"+
		"\2\2\2\2=\3\2\2\2\2?\3\2\2\2\2A\3\2\2\2\2C\3\2\2\2\2E\3\2\2\2\2G\3\2\2"+
		"\2\2I\3\2\2\2\2K\3\2\2\2\2M\3\2\2\2\2O\3\2\2\2\2Q\3\2\2\2\2S\3\2\2\2\2"+
		"U\3\2\2\2\2W\3\2\2\2\2Y\3\2\2\2\2[\3\2\2\2\2]\3\2\2\2\2_\3\2\2\2\2a\3"+
		"\2\2\2\2c\3\2\2\2\2e\3\2\2\2\2g\3\2\2\2\2i\3\2\2\2\2k\3\2\2\2\2m\3\2\2"+
		"\2\2o\3\2\2\2\2q\3\2\2\2\2s\3\2\2\2\2u\3\2\2\2\2w\3\2\2\2\2y\3\2\2\2\2"+
		"{\3\2\2\2\2}\3\2\2\2\2\177\3\2\2\2\2\u0081\3\2\2\2\2\u0083\3\2\2\2\2\u0085"+
		"\3\2\2\2\2\u0087\3\2\2\2\2\u0089\3\2\2\2\2\u008b\3\2\2\2\2\u008d\3\2\2"+
		"\2\2\u008f\3\2\2\2\2\u0091\3\2\2\2\2\u0093\3\2\2\2\2\u0095\3\2\2\2\2\u0097"+
		"\3\2\2\2\2\u0099\3\2\2\2\2\u009b\3\2\2\2\2\u009d\3\2\2\2\2\u009f\3\2\2"+
		"\2\2\u00a1\3\2\2\2\2\u00a3\3\2\2\2\2\u00a5\3\2\2\2\2\u00a7\3\2\2\2\2\u00a9"+
		"\3\2\2\2\2\u00ab\3\2\2\2\2\u00ad\3\2\2\2\2\u00af\3\2\2\2\2\u00b1\3\2\2"+
		"\2\2\u00b3\3\2\2\2\2\u00b5\3\2\2\2\2\u00b7\3\2\2\2\2\u00b9\3\2\2\2\2\u00bb"+
		"\3\2\2\2\2\u00c3\3\2\2\2\2\u00c9\3\2\2\2\2\u00cb\3\2\2\2\2\u00cd\3\2\2"+
		"\2\2\u00cf\3\2\2\2\3\u00d1\3\2\2\2\5\u00d8\3\2\2\2\7\u00da\3\2\2\2\t\u00dc"+
		"\3\2\2\2\13\u00de\3\2\2\2\r\u00e0\3\2\2\2\17\u00e2\3\2\2\2\21\u00e4\3"+
		"\2\2\2\23\u00e6\3\2\2\2\25\u00e8\3\2\2\2\27\u00eb\3\2\2\2\31\u00f1\3\2"+
		"\2\2\33\u00f8\3\2\2\2\35\u00fe\3\2\2\2\37\u0107\3\2\2\2!\u010e\3\2\2\2"+
		"#\u0117\3\2\2\2%\u0121\3\2\2\2\'\u0129\3\2\2\2)\u012c\3\2\2\2+\u0131\3"+
		"\2\2\2-\u0137\3\2\2\2/\u013a\3\2\2\2\61\u013e\3\2\2\2\63\u0145\3\2\2\2"+
		"\65\u014b\3\2\2\2\67\u0154\3\2\2\29\u0158\3\2\2\2;\u015a\3\2\2\2=\u015d"+
		"\3\2\2\2?\u0164\3\2\2\2A\u016d\3\2\2\2C\u016f\3\2\2\2E\u0171\3\2\2\2G"+
		"\u0173\3\2\2\2I\u017a\3\2\2\2K\u017c\3\2\2\2M\u017f\3\2\2\2O\u0186\3\2"+
		"\2\2Q\u018d\3\2\2\2S\u0190\3\2\2\2U\u0193\3\2\2\2W\u0195\3\2\2\2Y\u0197"+
		"\3\2\2\2[\u0199\3\2\2\2]\u019b\3\2\2\2_\u019d\3\2\2\2a\u01a0\3\2\2\2c"+
		"\u01a3\3\2\2\2e\u01a5\3\2\2\2g\u01a7\3\2\2\2i\u01a9\3\2\2\2k\u01ab\3\2"+
		"\2\2m\u01ae\3\2\2\2o\u01b1\3\2\2\2q\u01b4\3\2\2\2s\u01b7\3\2\2\2u\u01b9"+
		"\3\2\2\2w\u01bb\3\2\2\2y\u01be\3\2\2\2{\u01c1\3\2\2\2}\u01c3\3\2\2\2\177"+
		"\u01c6\3\2\2\2\u0081\u01c9\3\2\2\2\u0083\u01cc\3\2\2\2\u0085\u01cf\3\2"+
		"\2\2\u0087\u01d2\3\2\2\2\u0089\u01d6\3\2\2\2\u008b\u01da\3\2\2\2\u008d"+
		"\u01dd\3\2\2\2\u008f\u01e0\3\2\2\2\u0091\u01e3\3\2\2\2\u0093\u01eb\3\2"+
		"\2\2\u0095\u01f4\3\2\2\2\u0097\u01f9\3\2\2\2\u0099\u0202\3\2\2\2\u009b"+
		"\u0208\3\2\2\2\u009d\u020f\3\2\2\2\u009f\u02f3\3\2\2\2\u00a1\u02f5\3\2"+
		"\2\2\u00a3\u0326\3\2\2\2\u00a5\u0328\3\2\2\2\u00a7\u0335\3\2\2\2\u00a9"+
		"\u0346\3\2\2\2\u00ab\u034a\3\2\2\2\u00ad\u034f\3\2\2\2\u00af\u0356\3\2"+
		"\2\2\u00b1\u0367\3\2\2\2\u00b3\u0375\3\2\2\2\u00b5\u0386\3\2\2\2\u00b7"+
		"\u039a\3\2\2\2\u00b9\u039d\3\2\2\2\u00bb\u03a6\3\2\2\2\u00bd\u03ad\3\2"+
		"\2\2\u00bf\u03af\3\2\2\2\u00c1\u03b1\3\2\2\2\u00c3\u03b3\3\2\2\2\u00c5"+
		"\u03ba\3\2\2\2\u00c7\u03bc\3\2\2\2\u00c9\u03be\3\2\2\2\u00cb\u03cb\3\2"+
		"\2\2\u00cd\u03d1\3\2\2\2\u00cf\u03dc\3\2\2\2\u00d1\u00d2\7k\2\2\u00d2"+
		"\u00d3\7o\2\2\u00d3\u00d4\7r\2\2\u00d4\u00d5\7q\2\2\u00d5\u00d6\7t\2\2"+
		"\u00d6\u00d7\7v\2\2\u00d7\4\3\2\2\2\u00d8\u00d9\7=\2\2\u00d9\6\3\2\2\2"+
		"\u00da\u00db\7.\2\2\u00db\b\3\2\2\2\u00dc\u00dd\7?\2\2\u00dd\n\3\2\2\2"+
		"\u00de\u00df\7*\2\2\u00df\f\3\2\2\2\u00e0\u00e1\7+\2\2\u00e1\16\3\2\2"+
		"\2\u00e2\u00e3\7}\2\2\u00e3\20\3\2\2\2\u00e4\u00e5\7\177\2\2\u00e5\22"+
		"\3\2\2\2\u00e6\u00e7\7%\2\2\u00e7\24\3\2\2\2\u00e8\u00e9\7r\2\2\u00e9"+
		"\u00ea\7e\2\2\u00ea\26\3\2\2\2\u00eb\u00ec\7e\2\2\u00ec\u00ed\7q\2\2\u00ed"+
		"\u00ee\7p\2\2\u00ee\u00ef\7u\2\2\u00ef\u00f0\7v\2\2\u00f0\30\3\2\2\2\u00f1"+
		"\u00f2\7g\2\2\u00f2\u00f3\7z\2\2\u00f3\u00f4\7v\2\2\u00f4\u00f5\7g\2\2"+
		"\u00f5\u00f6\7t\2\2\u00f6\u00f7\7p\2\2\u00f7\32\3\2\2\2\u00f8\u00f9\7"+
		"c\2\2\u00f9\u00fa\7n\2\2\u00fa\u00fb\7k\2\2\u00fb\u00fc\7i\2\2\u00fc\u00fd"+
		"\7p\2\2\u00fd\34\3\2\2\2\u00fe\u00ff\7t\2\2\u00ff\u0100\7g\2\2\u0100\u0101"+
		"\7i\2\2\u0101\u0102\7k\2\2\u0102\u0103\7u\2\2\u0103\u0104\7v\2\2\u0104"+
		"\u0105\7g\2\2\u0105\u0106\7t\2\2\u0106\36\3\2\2\2\u0107\u0108\7k\2\2\u0108"+
		"\u0109\7p\2\2\u0109\u010a\7n\2\2\u010a\u010b\7k\2\2\u010b\u010c\7p\2\2"+
		"\u010c\u010d\7g\2\2\u010d \3\2\2\2\u010e\u010f\7x\2\2\u010f\u0110\7q\2"+
		"\2\u0110\u0111\7n\2\2\u0111\u0112\7c\2\2\u0112\u0113\7v\2\2\u0113\u0114"+
		"\7k\2\2\u0114\u0115\7n\2\2\u0115\u0116\7g\2\2\u0116\"\3\2\2\2\u0117\u0118"+
		"\7k\2\2\u0118\u0119\7p\2\2\u0119\u011a\7v\2\2\u011a\u011b\7g\2\2\u011b"+
		"\u011c\7t\2\2\u011c\u011d\7t\2\2\u011d\u011e\7w\2\2\u011e\u011f\7r\2\2"+
		"\u011f\u0120\7v\2\2\u0120$\3\2\2\2\u0121\u0122\7t\2\2\u0122\u0123\7g\2"+
		"\2\u0123\u0124\7u\2\2\u0124\u0125\7g\2\2\u0125\u0126\7t\2\2\u0126\u0127"+
		"\7x\2\2\u0127\u0128\7g\2\2\u0128&\3\2\2\2\u0129\u012a\7k\2\2\u012a\u012b"+
		"\7h\2\2\u012b(\3\2\2\2\u012c\u012d\7g\2\2\u012d\u012e\7n\2\2\u012e\u012f"+
		"\7u\2\2\u012f\u0130\7g\2\2\u0130*\3\2\2\2\u0131\u0132\7y\2\2\u0132\u0133"+
		"\7j\2\2\u0133\u0134\7k\2\2\u0134\u0135\7n\2\2\u0135\u0136\7g\2\2\u0136"+
		",\3\2\2\2\u0137\u0138\7f\2\2\u0138\u0139\7q\2\2\u0139.\3\2\2\2\u013a\u013b"+
		"\7h\2\2\u013b\u013c\7q\2\2\u013c\u013d\7t\2\2\u013d\60\3\2\2\2\u013e\u013f"+
		"\7t\2\2\u013f\u0140\7g\2\2\u0140\u0141\7v\2\2\u0141\u0142\7w\2\2\u0142"+
		"\u0143\7t\2\2\u0143\u0144\7p\2\2\u0144\62\3\2\2\2\u0145\u0146\7d\2\2\u0146"+
		"\u0147\7t\2\2\u0147\u0148\7g\2\2\u0148\u0149\7c\2\2\u0149\u014a\7m\2\2"+
		"\u014a\64\3\2\2\2\u014b\u014c\7e\2\2\u014c\u014d\7q\2\2\u014d\u014e\7"+
		"p\2\2\u014e\u014f\7v\2\2\u014f\u0150\7k\2\2\u0150\u0151\7p\2\2\u0151\u0152"+
		"\7w\2\2\u0152\u0153\7g\2\2\u0153\66\3\2\2\2\u0154\u0155\7c\2\2\u0155\u0156"+
		"\7u\2\2\u0156\u0157\7o\2\2\u01578\3\2\2\2\u0158\u0159\7<\2\2\u0159:\3"+
		"\2\2\2\u015a\u015b\7\60\2\2\u015b\u015c\7\60\2\2\u015c<\3\2\2\2\u015d"+
		"\u015e\7u\2\2\u015e\u015f\7k\2\2\u015f\u0160\7i\2\2\u0160\u0161\7p\2\2"+
		"\u0161\u0162\7g\2\2\u0162\u0163\7f\2\2\u0163>\3\2\2\2\u0164\u0165\7w\2"+
		"\2\u0165\u0166\7p\2\2\u0166\u0167\7u\2\2\u0167\u0168\7k\2\2\u0168\u0169"+
		"\7i\2\2\u0169\u016a\7p\2\2\u016a\u016b\7g\2\2\u016b\u016c\7f\2\2\u016c"+
		"@\3\2\2\2\u016d\u016e\7,\2\2\u016eB\3\2\2\2\u016f\u0170\7]\2\2\u0170D"+
		"\3\2\2\2\u0171\u0172\7_\2\2\u0172F\3\2\2\2\u0173\u0174\7u\2\2\u0174\u0175"+
		"\7v\2\2\u0175\u0176\7t\2\2\u0176\u0177\7w\2\2\u0177\u0178\7e\2\2\u0178"+
		"\u0179\7v\2\2\u0179H\3\2\2\2\u017a\u017b\7\60\2\2\u017bJ\3\2\2\2\u017c"+
		"\u017d\7/\2\2\u017d\u017e\7@\2\2\u017eL\3\2\2\2\u017f\u0180\7u\2\2\u0180"+
		"\u0181\7k\2\2\u0181\u0182\7|\2\2\u0182\u0183\7g\2\2\u0183\u0184\7q\2\2"+
		"\u0184\u0185\7h\2\2\u0185N\3\2\2\2\u0186\u0187\7v\2\2\u0187\u0188\7{\2"+
		"\2\u0188\u0189\7r\2\2\u0189\u018a\7g\2\2\u018a\u018b\7k\2\2\u018b\u018c"+
		"\7f\2\2\u018cP\3\2\2\2\u018d\u018e\7/\2\2\u018e\u018f\7/\2\2\u018fR\3"+
		"\2\2\2\u0190\u0191\7-\2\2\u0191\u0192\7-\2\2\u0192T\3\2\2\2\u0193\u0194"+
		"\7-\2\2\u0194V\3\2\2\2\u0195\u0196\7/\2\2\u0196X\3\2\2\2\u0197\u0198\7"+
		"#\2\2\u0198Z\3\2\2\2\u0199\u019a\7(\2\2\u019a\\\3\2\2\2\u019b\u019c\7"+
		"\u0080\2\2\u019c^\3\2\2\2\u019d\u019e\7@\2\2\u019e\u019f\7@\2\2\u019f"+
		"`\3\2\2\2\u01a0\u01a1\7>\2\2\u01a1\u01a2\7>\2\2\u01a2b\3\2\2\2\u01a3\u01a4"+
		"\7\61\2\2\u01a4d\3\2\2\2\u01a5\u01a6\7\'\2\2\u01a6f\3\2\2\2\u01a7\u01a8"+
		"\7>\2\2\u01a8h\3\2\2\2\u01a9\u01aa\7@\2\2\u01aaj\3\2\2\2\u01ab\u01ac\7"+
		"?\2\2\u01ac\u01ad\7?\2\2\u01adl\3\2\2\2\u01ae\u01af\7#\2\2\u01af\u01b0"+
		"\7?\2\2\u01b0n\3\2\2\2\u01b1\u01b2\7>\2\2\u01b2\u01b3\7?\2\2\u01b3p\3"+
		"\2\2\2\u01b4\u01b5\7@\2\2\u01b5\u01b6\7?\2\2\u01b6r\3\2\2\2\u01b7\u01b8"+
		"\7`\2\2\u01b8t\3\2\2\2\u01b9\u01ba\7~\2\2\u01bav\3\2\2\2\u01bb\u01bc\7"+
		"(\2\2\u01bc\u01bd\7(\2\2\u01bdx\3\2\2\2\u01be\u01bf\7~\2\2\u01bf\u01c0"+
		"\7~\2\2\u01c0z\3\2\2\2\u01c1\u01c2\7A\2\2\u01c2|\3\2\2\2\u01c3\u01c4\7"+
		"-\2\2\u01c4\u01c5\7?\2\2\u01c5~\3\2\2\2\u01c6\u01c7\7/\2\2\u01c7\u01c8"+
		"\7?\2\2\u01c8\u0080\3\2\2\2\u01c9\u01ca\7,\2\2\u01ca\u01cb\7?\2\2\u01cb"+
		"\u0082\3\2\2\2\u01cc\u01cd\7\61\2\2\u01cd\u01ce\7?\2\2\u01ce\u0084\3\2"+
		"\2\2\u01cf\u01d0\7\'\2\2\u01d0\u01d1\7?\2\2\u01d1\u0086\3\2\2\2\u01d2"+
		"\u01d3\7>\2\2\u01d3\u01d4\7>\2\2\u01d4\u01d5\7?\2\2\u01d5\u0088\3\2\2"+
		"\2\u01d6\u01d7\7@\2\2\u01d7\u01d8\7@\2\2\u01d8\u01d9\7?\2\2\u01d9\u008a"+
		"\3\2\2\2\u01da\u01db\7(\2\2\u01db\u01dc\7?\2\2\u01dc\u008c\3\2\2\2\u01dd"+
		"\u01de\7~\2\2\u01de\u01df\7?\2\2\u01df\u008e\3\2\2\2\u01e0\u01e1\7`\2"+
		"\2\u01e1\u01e2\7?\2\2\u01e2\u0090\3\2\2\2\u01e3\u01e4\7m\2\2\u01e4\u01e5"+
		"\7k\2\2\u01e5\u01e6\7e\2\2\u01e6\u01e7\7m\2\2\u01e7\u01e8\7c\2\2\u01e8"+
		"\u01e9\7u\2\2\u01e9\u01ea\7o\2\2\u01ea\u0092\3\2\2\2\u01eb\u01ec\7t\2"+
		"\2\u01ec\u01ed\7g\2\2\u01ed\u01ee\7u\2\2\u01ee\u01ef\7q\2\2\u01ef\u01f0"+
		"\7w\2\2\u01f0\u01f1\7t\2\2\u01f1\u01f2\7e\2\2\u01f2\u01f3\7g\2\2\u01f3"+
		"\u0094\3\2\2\2\u01f4\u01f5\7w\2\2\u01f5\u01f6\7u\2\2\u01f6\u01f7\7g\2"+
		"\2\u01f7\u01f8\7u\2\2\u01f8\u0096\3\2\2\2\u01f9\u01fa\7e\2\2\u01fa\u01fb"+
		"\7n\2\2\u01fb\u01fc\7q\2\2\u01fc\u01fd\7d\2\2\u01fd\u01fe\7d\2\2\u01fe"+
		"\u01ff\7g\2\2\u01ff\u0200\7t\2\2\u0200\u0201\7u\2\2\u0201\u0098\3\2\2"+
		"\2\u0202\u0203\7d\2\2\u0203\u0204\7{\2\2\u0204\u0205\7v\2\2\u0205\u0206"+
		"\7g\2\2\u0206\u0207\7u\2\2\u0207\u009a\3\2\2\2\u0208\u0209\7e\2\2\u0209"+
		"\u020a\7{\2\2\u020a\u020b\7e\2\2\u020b\u020c\7n\2\2\u020c\u020d\7g\2\2"+
		"\u020d\u020e\7u\2\2\u020e\u009c\3\2\2\2\u020f\u0210\7\60\2\2\u0210\u0211"+
		"\7d\2\2\u0211\u0212\7{\2\2\u0212\u0213\7v\2\2\u0213\u0214\7g\2\2\u0214"+
		"\u009e\3\2\2\2\u0215\u0216\7d\2\2\u0216\u0217\7t\2\2\u0217\u02f4\7m\2"+
		"\2\u0218\u0219\7q\2\2\u0219\u021a\7t\2\2\u021a\u02f4\7c\2\2\u021b\u021c"+
		"\7m\2\2\u021c\u021d\7k\2\2\u021d\u02f4\7n\2\2\u021e\u021f\7u\2\2\u021f"+
		"\u0220\7n\2\2\u0220\u02f4\7q\2\2\u0221\u0222\7p\2\2\u0222\u0223\7q\2\2"+
		"\u0223\u02f4\7r\2\2\u0224\u0225\7c\2\2\u0225\u0226\7u\2\2\u0226\u02f4"+
		"\7n\2\2\u0227\u0228\7r\2\2\u0228\u0229\7j\2\2\u0229\u02f4\7r\2\2\u022a"+
		"\u022b\7c\2\2\u022b\u022c\7p\2\2\u022c\u02f4\7e\2\2\u022d\u022e\7d\2\2"+
		"\u022e\u022f\7r\2\2\u022f\u02f4\7n\2\2\u0230\u0231\7e\2\2\u0231\u0232"+
		"\7n\2\2\u0232\u02f4\7e\2\2\u0233\u0234\7l\2\2\u0234\u0235\7u\2\2\u0235"+
		"\u02f4\7t\2\2\u0236\u0237\7c\2\2\u0237\u0238\7p\2\2\u0238\u02f4\7f\2\2"+
		"\u0239\u023a\7t\2\2\u023a\u023b\7n\2\2\u023b\u02f4\7c\2\2\u023c\u023d"+
		"\7d\2\2\u023d\u023e\7k\2\2\u023e\u02f4\7v\2\2\u023f\u0240\7t\2\2\u0240"+
		"\u0241\7q\2\2\u0241\u02f4\7n\2\2\u0242\u0243\7r\2\2\u0243\u0244\7n\2\2"+
		"\u0244\u02f4\7c\2\2\u0245\u0246\7r\2\2\u0246\u0247\7n\2\2\u0247\u02f4"+
		"\7r\2\2\u0248\u0249\7d\2\2\u0249\u024a\7o\2\2\u024a\u02f4\7k\2\2\u024b"+
		"\u024c\7u\2\2\u024c\u024d\7g\2\2\u024d\u02f4\7e\2\2\u024e\u024f\7t\2\2"+
		"\u024f\u0250\7v\2\2\u0250\u02f4\7k\2\2\u0251\u0252\7g\2\2\u0252\u0253"+
		"\7q\2\2\u0253\u02f4\7t\2\2\u0254\u0255\7u\2\2\u0255\u0256\7t\2\2\u0256"+
		"\u02f4\7g\2\2\u0257\u0258\7n\2\2\u0258\u0259\7u\2\2\u0259\u02f4\7t\2\2"+
		"\u025a\u025b\7r\2\2\u025b\u025c\7j\2\2\u025c\u02f4\7c\2\2\u025d\u025e"+
		"\7c\2\2\u025e\u025f\7n\2\2\u025f\u02f4\7t\2\2\u0260\u0261\7l\2\2\u0261"+
		"\u0262\7o\2\2\u0262\u02f4\7r\2\2\u0263\u0264\7d\2\2\u0264\u0265\7x\2\2"+
		"\u0265\u02f4\7e\2\2\u0266\u0267\7e\2\2\u0267\u0268\7n\2\2\u0268\u02f4"+
		"\7k\2\2\u0269\u026a\7t\2\2\u026a\u026b\7v\2\2\u026b\u02f4\7u\2\2\u026c"+
		"\u026d\7c\2\2\u026d\u026e\7f\2\2\u026e\u02f4\7e\2\2\u026f\u0270\7t\2\2"+
		"\u0270\u0271\7t\2\2\u0271\u02f4\7c\2\2\u0272\u0273\7d\2\2\u0273\u0274"+
		"\7x\2\2\u0274\u02f4\7u\2\2\u0275\u0276\7u\2\2\u0276\u0277\7g\2\2\u0277"+
		"\u02f4\7k\2\2\u0278\u0279\7u\2\2\u0279\u027a\7c\2\2\u027a\u02f4\7z\2\2"+
		"\u027b\u027c\7u\2\2\u027c\u027d\7v\2\2\u027d\u02f4\7{\2\2\u027e\u027f"+
		"\7u\2\2\u027f\u0280\7v\2\2\u0280\u02f4\7c\2\2\u0281\u0282\7u\2\2\u0282"+
		"\u0283\7v\2\2\u0283\u02f4\7z\2\2\u0284\u0285\7f\2\2\u0285\u0286\7g\2\2"+
		"\u0286\u02f4\7{\2\2\u0287\u0288\7v\2\2\u0288\u0289\7z\2\2\u0289\u02f4"+
		"\7c\2\2\u028a\u028b\7z\2\2\u028b\u028c\7c\2\2\u028c\u02f4\7c\2\2\u028d"+
		"\u028e\7d\2\2\u028e\u028f\7e\2\2\u028f\u02f4\7e\2\2\u0290\u0291\7c\2\2"+
		"\u0291\u0292\7j\2\2\u0292\u02f4\7z\2\2\u0293\u0294\7v\2\2\u0294\u0295"+
		"\7{\2\2\u0295\u02f4\7c\2\2\u0296\u0297\7v\2\2\u0297\u0298\7z\2\2\u0298"+
		"\u02f4\7u\2\2\u0299\u029a\7v\2\2\u029a\u029b\7c\2\2\u029b\u02f4\7u\2\2"+
		"\u029c\u029d\7u\2\2\u029d\u029e\7j\2\2\u029e\u02f4\7{\2\2\u029f\u02a0"+
		"\7u\2\2\u02a0\u02a1\7j\2\2\u02a1\u02f4\7z\2\2\u02a2\u02a3\7n\2\2\u02a3"+
		"\u02a4\7f\2\2\u02a4\u02f4\7{\2\2\u02a5\u02a6\7n\2\2\u02a6\u02a7\7f\2\2"+
		"\u02a7\u02f4\7c\2\2\u02a8\u02a9\7n\2\2\u02a9\u02aa\7f\2\2\u02aa\u02f4"+
		"\7z\2\2\u02ab\u02ac\7n\2\2\u02ac\u02ad\7c\2\2\u02ad\u02f4\7z\2\2\u02ae"+
		"\u02af\7v\2\2\u02af\u02b0\7c\2\2\u02b0\u02f4\7{\2\2\u02b1\u02b2\7v\2\2"+
		"\u02b2\u02b3\7c\2\2\u02b3\u02f4\7z\2\2\u02b4\u02b5\7d\2\2\u02b5\u02b6"+
		"\7e\2\2\u02b6\u02f4\7u\2\2\u02b7\u02b8\7e\2\2\u02b8\u02b9\7n\2\2\u02b9"+
		"\u02f4\7x\2\2\u02ba\u02bb\7v\2\2\u02bb\u02bc\7u\2\2\u02bc\u02f4\7z\2\2"+
		"\u02bd\u02be\7n\2\2\u02be\u02bf\7c\2\2\u02bf\u02f4\7u\2\2\u02c0\u02c1"+
		"\7e\2\2\u02c1\u02c2\7r\2\2\u02c2\u02f4\7{\2\2\u02c3\u02c4\7e\2\2\u02c4"+
		"\u02c5\7o\2\2\u02c5\u02f4\7r\2\2\u02c6\u02c7\7e\2\2\u02c7\u02c8\7r\2\2"+
		"\u02c8\u02f4\7z\2\2\u02c9\u02ca\7f\2\2\u02ca\u02cb\7e\2\2\u02cb\u02f4"+
		"\7r\2\2\u02cc\u02cd\7f\2\2\u02cd\u02ce\7g\2\2\u02ce\u02f4\7e\2\2\u02cf"+
		"\u02d0\7k\2\2\u02d0\u02d1\7p\2\2\u02d1\u02f4\7e\2\2\u02d2\u02d3\7c\2\2"+
		"\u02d3\u02d4\7z\2\2\u02d4\u02f4\7u\2\2\u02d5\u02d6\7d\2\2\u02d6\u02d7"+
		"\7p\2\2\u02d7\u02f4\7g\2\2\u02d8\u02d9\7e\2\2\u02d9\u02da\7n\2\2\u02da"+
		"\u02f4\7f\2\2\u02db\u02dc\7u\2\2\u02dc\u02dd\7d\2\2\u02dd\u02f4\7e\2\2"+
		"\u02de\u02df\7k\2\2\u02df\u02e0\7u\2\2\u02e0\u02f4\7e\2\2\u02e1\u02e2"+
		"\7k\2\2\u02e2\u02e3\7p\2\2\u02e3\u02f4\7z\2\2\u02e4\u02e5\7d\2\2\u02e5"+
		"\u02e6\7g\2\2\u02e6\u02f4\7s\2\2\u02e7\u02e8\7u\2\2\u02e8\u02e9\7g\2\2"+
		"\u02e9\u02f4\7f\2\2\u02ea\u02eb\7f\2\2\u02eb\u02ec\7g\2\2\u02ec\u02f4"+
		"\7z\2\2\u02ed\u02ee\7k\2\2\u02ee\u02ef\7p\2\2\u02ef\u02f4\7{\2\2\u02f0"+
		"\u02f1\7t\2\2\u02f1\u02f2\7q\2\2\u02f2\u02f4\7t\2\2\u02f3\u0215\3\2\2"+
		"\2\u02f3\u0218\3\2\2\2\u02f3\u021b\3\2\2\2\u02f3\u021e\3\2\2\2\u02f3\u0221"+
		"\3\2\2\2\u02f3\u0224\3\2\2\2\u02f3\u0227\3\2\2\2\u02f3\u022a\3\2\2\2\u02f3"+
		"\u022d\3\2\2\2\u02f3\u0230\3\2\2\2\u02f3\u0233\3\2\2\2\u02f3\u0236\3\2"+
		"\2\2\u02f3\u0239\3\2\2\2\u02f3\u023c\3\2\2\2\u02f3\u023f\3\2\2\2\u02f3"+
		"\u0242\3\2\2\2\u02f3\u0245\3\2\2\2\u02f3\u0248\3\2\2\2\u02f3\u024b\3\2"+
		"\2\2\u02f3\u024e\3\2\2\2\u02f3\u0251\3\2\2\2\u02f3\u0254\3\2\2\2\u02f3"+
		"\u0257\3\2\2\2\u02f3\u025a\3\2\2\2\u02f3\u025d\3\2\2\2\u02f3\u0260\3\2"+
		"\2\2\u02f3\u0263\3\2\2\2\u02f3\u0266\3\2\2\2\u02f3\u0269\3\2\2\2\u02f3"+
		"\u026c\3\2\2\2\u02f3\u026f\3\2\2\2\u02f3\u0272\3\2\2\2\u02f3\u0275\3\2"+
		"\2\2\u02f3\u0278\3\2\2\2\u02f3\u027b\3\2\2\2\u02f3\u027e\3\2\2\2\u02f3"+
		"\u0281\3\2\2\2\u02f3\u0284\3\2\2\2\u02f3\u0287\3\2\2\2\u02f3\u028a\3\2"+
		"\2\2\u02f3\u028d\3\2\2\2\u02f3\u0290\3\2\2\2\u02f3\u0293\3\2\2\2\u02f3"+
		"\u0296\3\2\2\2\u02f3\u0299\3\2\2\2\u02f3\u029c\3\2\2\2\u02f3\u029f\3\2"+
		"\2\2\u02f3\u02a2\3\2\2\2\u02f3\u02a5\3\2\2\2\u02f3\u02a8\3\2\2\2\u02f3"+
		"\u02ab\3\2\2\2\u02f3\u02ae\3\2\2\2\u02f3\u02b1\3\2\2\2\u02f3\u02b4\3\2"+
		"\2\2\u02f3\u02b7\3\2\2\2\u02f3\u02ba\3\2\2\2\u02f3\u02bd\3\2\2\2\u02f3"+
		"\u02c0\3\2\2\2\u02f3\u02c3\3\2\2\2\u02f3\u02c6\3\2\2\2\u02f3\u02c9\3\2"+
		"\2\2\u02f3\u02cc\3\2\2\2\u02f3\u02cf\3\2\2\2\u02f3\u02d2\3\2\2\2\u02f3"+
		"\u02d5\3\2\2\2\u02f3\u02d8\3\2\2\2\u02f3\u02db\3\2\2\2\u02f3\u02de\3\2"+
		"\2\2\u02f3\u02e1\3\2\2\2\u02f3\u02e4\3\2\2\2\u02f3\u02e7\3\2\2\2\u02f3"+
		"\u02ea\3\2\2\2\u02f3\u02ed\3\2\2\2\u02f3\u02f0\3\2\2\2\u02f4\u00a0\3\2"+
		"\2\2\u02f5\u02f6\7}\2\2\u02f6\u02f7\7}\2\2\u02f7\u02fb\3\2\2\2\u02f8\u02fa"+
		"\13\2\2\2\u02f9\u02f8\3\2\2\2\u02fa\u02fd\3\2\2\2\u02fb\u02fc\3\2\2\2"+
		"\u02fb\u02f9\3\2\2\2\u02fc\u02fe\3\2\2\2\u02fd\u02fb\3\2\2\2\u02fe\u02ff"+
		"\7\177\2\2\u02ff\u0300\7\177\2\2\u0300\u00a2\3\2\2\2\u0301\u0302\7d\2"+
		"\2\u0302\u0303\7{\2\2\u0303\u0304\7v\2\2\u0304\u0327\7g\2\2\u0305\u0306"+
		"\7y\2\2\u0306\u0307\7q\2\2\u0307\u0308\7t\2\2\u0308\u0327\7f\2\2\u0309"+
		"\u030a\7f\2\2\u030a\u030b\7y\2\2\u030b\u030c\7q\2\2\u030c\u030d\7t\2\2"+
		"\u030d\u0327\7f\2\2\u030e\u030f\7d\2\2\u030f\u0310\7q\2\2\u0310\u0311"+
		"\7q\2\2\u0311\u0327\7n\2\2\u0312\u0313\7e\2\2\u0313\u0314\7j\2\2\u0314"+
		"\u0315\7c\2\2\u0315\u0327\7t\2\2\u0316\u0317\7u\2\2\u0317\u0318\7j\2\2"+
		"\u0318\u0319\7q\2\2\u0319\u031a\7t\2\2\u031a\u0327\7v\2\2\u031b\u031c"+
		"\7k\2\2\u031c\u031d\7p\2\2\u031d\u0327\7v\2\2\u031e\u031f\7n\2\2\u031f"+
		"\u0320\7q\2\2\u0320\u0321\7p\2\2\u0321\u0327\7i\2\2\u0322\u0323\7x\2\2"+
		"\u0323\u0324\7q\2\2\u0324\u0325\7k\2\2\u0325\u0327\7f\2\2\u0326\u0301"+
		"\3\2\2\2\u0326\u0305\3\2\2\2\u0326\u0309\3\2\2\2\u0326\u030e\3\2\2\2\u0326"+
		"\u0312\3\2\2\2\u0326\u0316\3\2\2\2\u0326\u031b\3\2\2\2\u0326\u031e\3\2"+
		"\2\2\u0326\u0322\3\2\2\2\u0327\u00a4\3\2\2\2\u0328\u032e\7$\2\2\u0329"+
		"\u032a\7^\2\2\u032a\u032d\7$\2\2\u032b\u032d\n\2\2\2\u032c\u0329\3\2\2"+
		"\2\u032c\u032b\3\2\2\2\u032d\u0330\3\2\2\2\u032e\u032c\3\2\2\2\u032e\u032f"+
		"\3\2\2\2\u032f\u0331\3\2\2\2\u0330\u032e\3\2\2\2\u0331\u0333\7$\2\2\u0332"+
		"\u0334\7|\2\2\u0333\u0332\3\2\2\2\u0333\u0334\3\2\2\2\u0334\u00a6\3\2"+
		"\2\2\u0335\u0339\7)\2\2\u0336\u0337\7^\2\2\u0337\u033a\7)\2\2\u0338\u033a"+
		"\n\3\2\2\u0339\u0336\3\2\2\2\u0339\u0338\3\2\2\2\u033a\u033b\3\2\2\2\u033b"+
		"\u033c\7)\2\2\u033c\u00a8\3\2\2\2\u033d\u033e\7v\2\2\u033e\u033f\7t\2"+
		"\2\u033f\u0340\7w\2\2\u0340\u0347\7g\2\2\u0341\u0342\7h\2\2\u0342\u0343"+
		"\7c\2\2\u0343\u0344\7n\2\2\u0344\u0345\7u\2\2\u0345\u0347\7g\2\2\u0346"+
		"\u033d\3\2\2\2\u0346\u0341\3\2\2\2\u0347\u00aa\3\2\2\2\u0348\u034b\5\u00ad"+
		"W\2\u0349\u034b\5\u00b5[\2\u034a\u0348\3\2\2\2\u034a\u0349\3\2\2\2\u034b"+
		"\u00ac\3\2\2\2\u034c\u0350\5\u00afX\2\u034d\u0350\5\u00b1Y\2\u034e\u0350"+
		"\5\u00b3Z\2\u034f\u034c\3\2\2\2\u034f\u034d\3\2\2\2\u034f\u034e\3\2\2"+
		"\2\u0350\u00ae\3\2\2\2\u0351\u0357\7\'\2\2\u0352\u0353\7\62\2\2\u0353"+
		"\u0357\7d\2\2\u0354\u0355\7\62\2\2\u0355\u0357\7D\2\2\u0356\u0351\3\2"+
		"\2\2\u0356\u0352\3\2\2\2\u0356\u0354\3\2\2\2\u0357\u035b\3\2\2\2\u0358"+
		"\u035a\5\u00bd_\2\u0359\u0358\3\2\2\2\u035a\u035d\3\2\2\2\u035b\u0359"+
		"\3\2\2\2\u035b\u035c\3\2\2\2\u035c\u035e\3\2\2\2\u035d\u035b\3\2\2\2\u035e"+
		"\u0360\7\60\2\2\u035f\u0361\5\u00bd_\2\u0360\u035f\3\2\2\2\u0361\u0362"+
		"\3\2\2\2\u0362\u0360\3\2\2\2\u0362\u0363\3\2\2\2\u0363\u00b0\3\2\2\2\u0364"+
		"\u0366\5\u00bf`\2\u0365\u0364\3\2\2\2\u0366\u0369\3\2\2\2\u0367\u0365"+
		"\3\2\2\2\u0367\u0368\3\2\2\2\u0368\u036a\3\2\2\2\u0369\u0367\3\2\2\2\u036a"+
		"\u036c\7\60\2\2\u036b\u036d\5\u00bf`\2\u036c\u036b\3\2\2\2\u036d\u036e"+
		"\3\2\2\2\u036e\u036c\3\2\2\2\u036e\u036f\3\2\2\2\u036f\u00b2\3\2\2\2\u0370"+
		"\u0376\7&\2\2\u0371\u0372\7\62\2\2\u0372\u0376\7z\2\2\u0373\u0374\7\62"+
		"\2\2\u0374\u0376\7Z\2\2\u0375\u0370\3\2\2\2\u0375\u0371\3\2\2\2\u0375"+
		"\u0373\3\2\2\2\u0376\u037a\3\2\2\2\u0377\u0379\5\u00c1a\2\u0378\u0377"+
		"\3\2\2\2\u0379\u037c\3\2\2\2\u037a\u0378\3\2\2\2\u037a\u037b\3\2\2\2\u037b"+
		"\u037d\3\2\2\2\u037c\u037a\3\2\2\2\u037d\u037f\7\60\2\2\u037e\u0380\5"+
		"\u00c1a\2\u037f\u037e\3\2\2\2\u0380\u0381\3\2\2\2\u0381\u037f\3\2\2\2"+
		"\u0381\u0382\3\2\2\2\u0382\u00b4\3\2\2\2\u0383\u0387\5\u00b9]\2\u0384"+
		"\u0387\5\u00bb^\2\u0385\u0387\5\u00b7\\\2\u0386\u0383\3\2\2\2\u0386\u0384"+
		"\3\2\2\2\u0386\u0385\3\2\2\2\u0387\u038b\3\2\2\2\u0388\u0389\t\4\2\2\u0389"+
		"\u038c\t\5\2\2\u038a\u038c\7n\2\2\u038b\u0388\3\2\2\2\u038b\u038a\3\2"+
		"\2\2\u038b\u038c\3\2\2\2\u038c\u00b6\3\2\2\2\u038d\u038e\7\62\2\2\u038e"+
		"\u0390\t\6\2\2\u038f\u0391\5\u00bd_\2\u0390\u038f\3\2\2\2\u0391\u0392"+
		"\3\2\2\2\u0392\u0390\3\2\2\2\u0392\u0393\3\2\2\2\u0393\u039b\3\2\2\2\u0394"+
		"\u0396\7\'\2\2\u0395\u0397\5\u00bd_\2\u0396\u0395\3\2\2\2\u0397\u0398"+
		"\3\2\2\2\u0398\u0396\3\2\2\2\u0398\u0399\3\2\2\2\u0399\u039b\3\2\2\2\u039a"+
		"\u038d\3\2\2\2\u039a\u0394\3\2\2\2\u039b\u00b8\3\2\2\2\u039c\u039e\5\u00bf"+
		"`\2\u039d\u039c\3\2\2\2\u039e\u039f\3\2\2\2\u039f\u039d\3\2\2\2\u039f"+
		"\u03a0\3\2\2\2\u03a0\u00ba\3\2\2\2\u03a1\u03a7\7&\2\2\u03a2\u03a3\7\62"+
		"\2\2\u03a3\u03a7\7z\2\2\u03a4\u03a5\7\62\2\2\u03a5\u03a7\7Z\2\2\u03a6"+
		"\u03a1\3\2\2\2\u03a6\u03a2\3\2\2\2\u03a6\u03a4\3\2\2\2\u03a7\u03a9\3\2"+
		"\2\2\u03a8\u03aa\5\u00c1a\2\u03a9\u03a8\3\2\2\2\u03aa\u03ab\3\2\2\2\u03ab"+
		"\u03a9\3\2\2\2\u03ab\u03ac\3\2\2\2\u03ac\u00bc\3\2\2\2\u03ad\u03ae\t\7"+
		"\2\2\u03ae\u00be\3\2\2\2\u03af\u03b0\t\b\2\2\u03b0\u00c0\3\2\2\2\u03b1"+
		"\u03b2\t\t\2\2\u03b2\u00c2\3\2\2\2\u03b3\u03b7\5\u00c5c\2\u03b4\u03b6"+
		"\5\u00c7d\2\u03b5\u03b4\3\2\2\2\u03b6\u03b9\3\2\2\2\u03b7\u03b5\3\2\2"+
		"\2\u03b7\u03b8\3\2\2\2\u03b8\u00c4\3\2\2\2\u03b9\u03b7\3\2\2\2\u03ba\u03bb"+
		"\t\n\2\2\u03bb\u00c6\3\2\2\2\u03bc\u03bd\t\13\2\2\u03bd\u00c8\3\2\2\2"+
		"\u03be\u03c2\7#\2\2\u03bf\u03c1\5\u00c7d\2\u03c0\u03bf\3\2\2\2\u03c1\u03c4"+
		"\3\2\2\2\u03c2\u03c0\3\2\2\2\u03c2\u03c3\3\2\2\2\u03c3\u03c6\3\2\2\2\u03c4"+
		"\u03c2\3\2\2\2\u03c5\u03c7\t\f\2\2\u03c6\u03c5\3\2\2\2\u03c7\u03c8\3\2"+
		"\2\2\u03c8\u03c6\3\2\2\2\u03c8\u03c9\3\2\2\2\u03c9\u00ca\3\2\2\2\u03ca"+
		"\u03cc\t\r\2\2\u03cb\u03ca\3\2\2\2\u03cc\u03cd\3\2\2\2\u03cd\u03cb\3\2"+
		"\2\2\u03cd\u03ce\3\2\2\2\u03ce\u03cf\3\2\2\2\u03cf\u03d0\bf\2\2\u03d0"+
		"\u00cc\3\2\2\2\u03d1\u03d2\7\61\2\2\u03d2\u03d3\7\61\2\2\u03d3\u03d7\3"+
		"\2\2\2\u03d4\u03d6\n\16\2\2\u03d5\u03d4\3\2\2\2\u03d6\u03d9\3\2\2\2\u03d7"+
		"\u03d5\3\2\2\2\u03d7\u03d8\3\2\2\2\u03d8\u03da\3\2\2\2\u03d9\u03d7\3\2"+
		"\2\2\u03da\u03db\bg\3\2\u03db\u00ce\3\2\2\2\u03dc\u03dd\7\61\2\2\u03dd"+
		"\u03de\7,\2\2\u03de\u03e2\3\2\2\2\u03df\u03e1\13\2\2\2\u03e0\u03df\3\2"+
		"\2\2\u03e1\u03e4\3\2\2\2\u03e2\u03e3\3\2\2\2\u03e2\u03e0\3\2\2\2\u03e3"+
		"\u03e5\3\2\2\2\u03e4\u03e2\3\2\2\2\u03e5\u03e6\7,\2\2\u03e6\u03e7\7\61"+
		"\2\2\u03e7\u03e8\3\2\2\2\u03e8\u03e9\bh\3\2\u03e9\u00d0\3\2\2\2#\2\u02f3"+
		"\u02fb\u0326\u032c\u032e\u0333\u0339\u0346\u034a\u034f\u0356\u035b\u0362"+
		"\u0367\u036e\u0375\u037a\u0381\u0386\u038b\u0392\u0398\u039a\u039f\u03a6"+
		"\u03ab\u03b7\u03c2\u03c8\u03cd\u03d7\u03e2\4\2\3\2\2\4\2";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}
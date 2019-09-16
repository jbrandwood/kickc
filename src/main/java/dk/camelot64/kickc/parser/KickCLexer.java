// Generated from /Users/jespergravgaard/c64/kickc/src/main/java/dk/camelot64/kickc/parser/KickCLexer.g4 by ANTLR 4.7
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
		TYPEDEFNAME=1, CURLY_BEGIN=2, CURLY_END=3, BRACKET_BEGIN=4, BRACKET_END=5, 
		PAR_BEGIN=6, PAR_END=7, SEMICOLON=8, COLON=9, COMMA=10, RANGE=11, CONDITION=12, 
		DOT=13, ARROW=14, PLUS=15, MINUS=16, ASTERISK=17, DIVIDE=18, MODULO=19, 
		INC=20, DEC=21, AND=22, BIT_NOT=23, BIT_XOR=24, BIT_OR=25, SHIFT_LEFT=26, 
		SHIFT_RIGHT=27, EQUAL=28, NOT_EQUAL=29, LESS_THAN=30, LESS_THAN_EQUAL=31, 
		GREATER_THAN_EQUAL=32, GREATER_THAN=33, LOGIC_AND=34, LOGIC_OR=35, ASSIGN=36, 
		ASSIGN_COMPOUND=37, IMPORT=38, TYPEDEF=39, PRAGMA=40, RESERVE=41, PC=42, 
		TARGET=43, LINK=44, CPU=45, CODESEG=46, DATASEG=47, ENCODING=48, CONST=49, 
		EXTERN=50, EXPORT=51, ALIGN=52, REGISTER=53, INLINE=54, VOLATILE=55, INTERRUPT=56, 
		CALLING=57, CALLINGCONVENTION=58, IF=59, ELSE=60, WHILE=61, DO=62, FOR=63, 
		SWITCH=64, RETURN=65, BREAK=66, CONTINUE=67, ASM=68, DEFAULT=69, CASE=70, 
		STRUCT=71, ENUM=72, SIZEOF=73, TYPEID=74, KICKASM=75, RESOURCE=76, USES=77, 
		CLOBBERS=78, BYTES=79, CYCLES=80, LOGIC_NOT=81, SIGNEDNESS=82, SIMPLETYPE=83, 
		BOOLEAN=84, KICKASM_BODY=85, STRING=86, CHAR=87, NUMBER=88, NUMFLOAT=89, 
		BINFLOAT=90, DECFLOAT=91, HEXFLOAT=92, NUMINT=93, BININTEGER=94, DECINTEGER=95, 
		HEXINTEGER=96, NAME=97, WS=98, COMMENT_LINE=99, COMMENT_BLOCK=100, ASM_BYTE=101, 
		ASM_MNEMONIC=102, ASM_IMM=103, ASM_COLON=104, ASM_COMMA=105, ASM_PAR_BEGIN=106, 
		ASM_PAR_END=107, ASM_BRACKET_BEGIN=108, ASM_BRACKET_END=109, ASM_DOT=110, 
		ASM_SHIFT_LEFT=111, ASM_SHIFT_RIGHT=112, ASM_PLUS=113, ASM_MINUS=114, 
		ASM_LESS_THAN=115, ASM_GREATER_THAN=116, ASM_MULTIPLY=117, ASM_DIVIDE=118, 
		ASM_CURLY_BEGIN=119, ASM_CURLY_END=120, ASM_NUMBER=121, ASM_NUMFLOAT=122, 
		ASM_BINFLOAT=123, ASM_DECFLOAT=124, ASM_HEXFLOAT=125, ASM_NUMINT=126, 
		ASM_BININTEGER=127, ASM_DECINTEGER=128, ASM_HEXINTEGER=129, ASM_CHAR=130, 
		ASM_MULTI_REL=131, ASM_MULTI_NAME=132, ASM_NAME=133, ASM_WS=134, ASM_COMMENT_LINE=135, 
		ASM_COMMENT_BLOCK=136;
	public static final int
		ASM_MODE=1;
	public static String[] channelNames = {
		"DEFAULT_TOKEN_CHANNEL", "HIDDEN"
	};

	public static String[] modeNames = {
		"DEFAULT_MODE", "ASM_MODE"
	};

	public static final String[] ruleNames = {
		"CURLY_BEGIN", "CURLY_END", "BRACKET_BEGIN", "BRACKET_END", "PAR_BEGIN", 
		"PAR_END", "SEMICOLON", "COLON", "COMMA", "RANGE", "CONDITION", "DOT", 
		"ARROW", "PLUS", "MINUS", "ASTERISK", "DIVIDE", "MODULO", "INC", "DEC", 
		"AND", "BIT_NOT", "BIT_XOR", "BIT_OR", "SHIFT_LEFT", "SHIFT_RIGHT", "EQUAL", 
		"NOT_EQUAL", "LESS_THAN", "LESS_THAN_EQUAL", "GREATER_THAN_EQUAL", "GREATER_THAN", 
		"LOGIC_AND", "LOGIC_OR", "ASSIGN", "ASSIGN_COMPOUND", "IMPORT", "TYPEDEF", 
		"PRAGMA", "RESERVE", "PC", "TARGET", "LINK", "CPU", "CODESEG", "DATASEG", 
		"ENCODING", "CONST", "EXTERN", "EXPORT", "ALIGN", "REGISTER", "INLINE", 
		"VOLATILE", "INTERRUPT", "CALLING", "CALLINGCONVENTION", "IF", "ELSE", 
		"WHILE", "DO", "FOR", "SWITCH", "RETURN", "BREAK", "CONTINUE", "ASM", 
		"DEFAULT", "CASE", "STRUCT", "ENUM", "SIZEOF", "TYPEID", "KICKASM", "RESOURCE", 
		"USES", "CLOBBERS", "BYTES", "CYCLES", "LOGIC_NOT", "SIGNEDNESS", "SIMPLETYPE", 
		"BOOLEAN", "KICKASM_BODY", "STRING", "CHAR", "NUMBER", "NUMFLOAT", "BINFLOAT", 
		"DECFLOAT", "HEXFLOAT", "NUMINT", "BININTEGER", "DECINTEGER", "HEXINTEGER", 
		"BINDIGIT", "DECDIGIT", "HEXDIGIT", "NAME", "NAME_START", "NAME_CHAR", 
		"WS", "COMMENT_LINE", "COMMENT_BLOCK", "ASM_BYTE", "ASM_MNEMONIC", "ASM_IMM", 
		"ASM_COLON", "ASM_COMMA", "ASM_PAR_BEGIN", "ASM_PAR_END", "ASM_BRACKET_BEGIN", 
		"ASM_BRACKET_END", "ASM_DOT", "ASM_SHIFT_LEFT", "ASM_SHIFT_RIGHT", "ASM_PLUS", 
		"ASM_MINUS", "ASM_LESS_THAN", "ASM_GREATER_THAN", "ASM_MULTIPLY", "ASM_DIVIDE", 
		"ASM_CURLY_BEGIN", "ASM_CURLY_END", "ASM_NUMBER", "ASM_NUMFLOAT", "ASM_BINFLOAT", 
		"ASM_DECFLOAT", "ASM_HEXFLOAT", "ASM_NUMINT", "ASM_BININTEGER", "ASM_DECINTEGER", 
		"ASM_HEXINTEGER", "ASM_BINDIGIT", "ASM_DECDIGIT", "ASM_HEXDIGIT", "ASM_CHAR", 
		"ASM_MULTI_REL", "ASM_MULTI_NAME", "ASM_NAME", "ASM_NAME_START", "ASM_NAME_CHAR", 
		"ASM_WS", "ASM_COMMENT_LINE", "ASM_COMMENT_BLOCK"
	};

	private static final String[] _LITERAL_NAMES = {
		null, null, null, null, null, null, null, null, "';'", null, null, "'..'", 
		"'?'", null, "'->'", null, null, null, null, "'%'", "'++'", "'--'", "'&'", 
		"'~'", "'^'", "'|'", null, null, "'=='", "'!='", null, "'<='", "'>='", 
		null, "'&&'", "'||'", "'='", null, "'import'", "'typedef'", "'#pragma'", 
		"'reserve'", "'pc'", "'target'", "'link'", "'cpu'", "'code_seg'", "'data_seg'", 
		"'encoding'", "'const'", "'extern'", "'export'", "'align'", "'register'", 
		"'inline'", "'volatile'", "'interrupt'", "'calling'", null, "'if'", "'else'", 
		"'while'", "'do'", "'for'", "'switch'", "'return'", "'break'", "'continue'", 
		"'asm'", "'default'", "'case'", "'struct'", "'enum'", "'sizeof'", "'typeid'", 
		"'kickasm'", "'resource'", "'uses'", "'clobbers'", "'bytes'", "'cycles'", 
		"'!'", null, null, null, null, null, null, null, null, null, null, null, 
		null, null, null, null, null, null, null, null, "'.byte'", null, "'#'"
	};
	private static final String[] _SYMBOLIC_NAMES = {
		null, "TYPEDEFNAME", "CURLY_BEGIN", "CURLY_END", "BRACKET_BEGIN", "BRACKET_END", 
		"PAR_BEGIN", "PAR_END", "SEMICOLON", "COLON", "COMMA", "RANGE", "CONDITION", 
		"DOT", "ARROW", "PLUS", "MINUS", "ASTERISK", "DIVIDE", "MODULO", "INC", 
		"DEC", "AND", "BIT_NOT", "BIT_XOR", "BIT_OR", "SHIFT_LEFT", "SHIFT_RIGHT", 
		"EQUAL", "NOT_EQUAL", "LESS_THAN", "LESS_THAN_EQUAL", "GREATER_THAN_EQUAL", 
		"GREATER_THAN", "LOGIC_AND", "LOGIC_OR", "ASSIGN", "ASSIGN_COMPOUND", 
		"IMPORT", "TYPEDEF", "PRAGMA", "RESERVE", "PC", "TARGET", "LINK", "CPU", 
		"CODESEG", "DATASEG", "ENCODING", "CONST", "EXTERN", "EXPORT", "ALIGN", 
		"REGISTER", "INLINE", "VOLATILE", "INTERRUPT", "CALLING", "CALLINGCONVENTION", 
		"IF", "ELSE", "WHILE", "DO", "FOR", "SWITCH", "RETURN", "BREAK", "CONTINUE", 
		"ASM", "DEFAULT", "CASE", "STRUCT", "ENUM", "SIZEOF", "TYPEID", "KICKASM", 
		"RESOURCE", "USES", "CLOBBERS", "BYTES", "CYCLES", "LOGIC_NOT", "SIGNEDNESS", 
		"SIMPLETYPE", "BOOLEAN", "KICKASM_BODY", "STRING", "CHAR", "NUMBER", "NUMFLOAT", 
		"BINFLOAT", "DECFLOAT", "HEXFLOAT", "NUMINT", "BININTEGER", "DECINTEGER", 
		"HEXINTEGER", "NAME", "WS", "COMMENT_LINE", "COMMENT_BLOCK", "ASM_BYTE", 
		"ASM_MNEMONIC", "ASM_IMM", "ASM_COLON", "ASM_COMMA", "ASM_PAR_BEGIN", 
		"ASM_PAR_END", "ASM_BRACKET_BEGIN", "ASM_BRACKET_END", "ASM_DOT", "ASM_SHIFT_LEFT", 
		"ASM_SHIFT_RIGHT", "ASM_PLUS", "ASM_MINUS", "ASM_LESS_THAN", "ASM_GREATER_THAN", 
		"ASM_MULTIPLY", "ASM_DIVIDE", "ASM_CURLY_BEGIN", "ASM_CURLY_END", "ASM_NUMBER", 
		"ASM_NUMFLOAT", "ASM_BINFLOAT", "ASM_DECFLOAT", "ASM_HEXFLOAT", "ASM_NUMINT", 
		"ASM_BININTEGER", "ASM_DECINTEGER", "ASM_HEXINTEGER", "ASM_CHAR", "ASM_MULTI_REL", 
		"ASM_MULTI_NAME", "ASM_NAME", "ASM_WS", "ASM_COMMENT_LINE", "ASM_COMMENT_BLOCK"
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



	    /** The C-Parser. Used for importing C-files and communicating with the Parser about typedefs. */
	    CParser cParser;
	    /** True of the next string is the name of a C-file to import*/
	    boolean importEnter = false;
	    /** True if the next CURLY starts ASM_MODE */
	    boolean asmEnter = false;
	    /** Counts the nested curlies inside ASM_MODE to determine when to exit ASM_MODE */
	    int asmCurlyCount = 0;

		public KickCLexer(CharStream input, CParser cParser) {
			this(input);
			this.cParser = cParser;
		}


	public KickCLexer(CharStream input) {
		super(input);
		_interp = new LexerATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}

	@Override
	public String getGrammarFileName() { return "KickCLexer.g4"; }

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

	@Override
	public void action(RuleContext _localctx, int ruleIndex, int actionIndex) {
		switch (ruleIndex) {
		case 0:
			CURLY_BEGIN_action((RuleContext)_localctx, actionIndex);
			break;
		case 36:
			IMPORT_action((RuleContext)_localctx, actionIndex);
			break;
		case 66:
			ASM_action((RuleContext)_localctx, actionIndex);
			break;
		case 84:
			STRING_action((RuleContext)_localctx, actionIndex);
			break;
		case 98:
			NAME_action((RuleContext)_localctx, actionIndex);
			break;
		case 122:
			ASM_CURLY_BEGIN_action((RuleContext)_localctx, actionIndex);
			break;
		case 123:
			ASM_CURLY_END_action((RuleContext)_localctx, actionIndex);
			break;
		}
	}
	private void CURLY_BEGIN_action(RuleContext _localctx, int actionIndex) {
		switch (actionIndex) {
		case 0:
			 if(asmEnter) { pushMode(ASM_MODE); asmEnter=false; } 
			break;
		}
	}
	private void IMPORT_action(RuleContext _localctx, int actionIndex) {
		switch (actionIndex) {
		case 1:
			 importEnter=true; 
			break;
		}
	}
	private void ASM_action(RuleContext _localctx, int actionIndex) {
		switch (actionIndex) {
		case 2:
			 asmEnter=true; 
			break;
		}
	}
	private void STRING_action(RuleContext _localctx, int actionIndex) {
		switch (actionIndex) {
		case 3:
			 if(importEnter) { importEnter=false; cParser.loadCFile(getText()); } 
			break;
		}
	}
	private void NAME_action(RuleContext _localctx, int actionIndex) {
		switch (actionIndex) {
		case 4:
			if(cParser.isTypedef(getText())) setType(TYPEDEFNAME); 
			break;
		}
	}
	private void ASM_CURLY_BEGIN_action(RuleContext _localctx, int actionIndex) {
		switch (actionIndex) {
		case 5:
			 asmCurlyCount++; 
			break;
		}
	}
	private void ASM_CURLY_END_action(RuleContext _localctx, int actionIndex) {
		switch (actionIndex) {
		case 6:
			 asmCurlyCount--; if(asmCurlyCount<0) { popMode(); } 
			break;
		}
	}

	public static final String _serializedATN =
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\2\u008a\u0567\b\1\b"+
		"\1\4\2\t\2\4\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n"+
		"\t\n\4\13\t\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\4\20\t\20\4\21\t\21"+
		"\4\22\t\22\4\23\t\23\4\24\t\24\4\25\t\25\4\26\t\26\4\27\t\27\4\30\t\30"+
		"\4\31\t\31\4\32\t\32\4\33\t\33\4\34\t\34\4\35\t\35\4\36\t\36\4\37\t\37"+
		"\4 \t \4!\t!\4\"\t\"\4#\t#\4$\t$\4%\t%\4&\t&\4\'\t\'\4(\t(\4)\t)\4*\t"+
		"*\4+\t+\4,\t,\4-\t-\4.\t.\4/\t/\4\60\t\60\4\61\t\61\4\62\t\62\4\63\t\63"+
		"\4\64\t\64\4\65\t\65\4\66\t\66\4\67\t\67\48\t8\49\t9\4:\t:\4;\t;\4<\t"+
		"<\4=\t=\4>\t>\4?\t?\4@\t@\4A\tA\4B\tB\4C\tC\4D\tD\4E\tE\4F\tF\4G\tG\4"+
		"H\tH\4I\tI\4J\tJ\4K\tK\4L\tL\4M\tM\4N\tN\4O\tO\4P\tP\4Q\tQ\4R\tR\4S\t"+
		"S\4T\tT\4U\tU\4V\tV\4W\tW\4X\tX\4Y\tY\4Z\tZ\4[\t[\4\\\t\\\4]\t]\4^\t^"+
		"\4_\t_\4`\t`\4a\ta\4b\tb\4c\tc\4d\td\4e\te\4f\tf\4g\tg\4h\th\4i\ti\4j"+
		"\tj\4k\tk\4l\tl\4m\tm\4n\tn\4o\to\4p\tp\4q\tq\4r\tr\4s\ts\4t\tt\4u\tu"+
		"\4v\tv\4w\tw\4x\tx\4y\ty\4z\tz\4{\t{\4|\t|\4}\t}\4~\t~\4\177\t\177\4\u0080"+
		"\t\u0080\4\u0081\t\u0081\4\u0082\t\u0082\4\u0083\t\u0083\4\u0084\t\u0084"+
		"\4\u0085\t\u0085\4\u0086\t\u0086\4\u0087\t\u0087\4\u0088\t\u0088\4\u0089"+
		"\t\u0089\4\u008a\t\u008a\4\u008b\t\u008b\4\u008c\t\u008c\4\u008d\t\u008d"+
		"\4\u008e\t\u008e\4\u008f\t\u008f\4\u0090\t\u0090\4\u0091\t\u0091\4\u0092"+
		"\t\u0092\3\2\3\2\3\2\3\3\3\3\3\4\3\4\3\5\3\5\3\6\3\6\3\7\3\7\3\b\3\b\3"+
		"\t\3\t\3\n\3\n\3\13\3\13\3\13\3\f\3\f\3\r\3\r\3\16\3\16\3\16\3\17\3\17"+
		"\3\20\3\20\3\21\3\21\3\22\3\22\3\23\3\23\3\24\3\24\3\24\3\25\3\25\3\25"+
		"\3\26\3\26\3\27\3\27\3\30\3\30\3\31\3\31\3\32\3\32\3\32\3\33\3\33\3\33"+
		"\3\34\3\34\3\34\3\35\3\35\3\35\3\36\3\36\3\37\3\37\3\37\3 \3 \3 \3!\3"+
		"!\3\"\3\"\3\"\3#\3#\3#\3$\3$\3%\3%\3%\3%\3%\3%\3%\3%\3%\3%\3%\3%\3%\3"+
		"%\3%\3%\3%\3%\3%\3%\3%\3%\5%\u0190\n%\3&\3&\3&\3&\3&\3&\3&\3&\3&\3\'\3"+
		"\'\3\'\3\'\3\'\3\'\3\'\3\'\3(\3(\3(\3(\3(\3(\3(\3(\3)\3)\3)\3)\3)\3)\3"+
		")\3)\3*\3*\3*\3+\3+\3+\3+\3+\3+\3+\3,\3,\3,\3,\3,\3-\3-\3-\3-\3.\3.\3"+
		".\3.\3.\3.\3.\3.\3.\3/\3/\3/\3/\3/\3/\3/\3/\3/\3\60\3\60\3\60\3\60\3\60"+
		"\3\60\3\60\3\60\3\60\3\61\3\61\3\61\3\61\3\61\3\61\3\62\3\62\3\62\3\62"+
		"\3\62\3\62\3\62\3\63\3\63\3\63\3\63\3\63\3\63\3\63\3\64\3\64\3\64\3\64"+
		"\3\64\3\64\3\65\3\65\3\65\3\65\3\65\3\65\3\65\3\65\3\65\3\66\3\66\3\66"+
		"\3\66\3\66\3\66\3\66\3\67\3\67\3\67\3\67\3\67\3\67\3\67\3\67\3\67\38\3"+
		"8\38\38\38\38\38\38\38\38\39\39\39\39\39\39\39\39\3:\3:\3:\3:\3:\3:\3"+
		":\3:\3:\3:\3:\3:\3:\3:\3:\3:\3:\3:\3:\3:\5:\u023a\n:\3;\3;\3;\3<\3<\3"+
		"<\3<\3<\3=\3=\3=\3=\3=\3=\3>\3>\3>\3?\3?\3?\3?\3@\3@\3@\3@\3@\3@\3@\3"+
		"A\3A\3A\3A\3A\3A\3A\3B\3B\3B\3B\3B\3B\3C\3C\3C\3C\3C\3C\3C\3C\3C\3D\3"+
		"D\3D\3D\3D\3D\3E\3E\3E\3E\3E\3E\3E\3E\3F\3F\3F\3F\3F\3G\3G\3G\3G\3G\3"+
		"G\3G\3H\3H\3H\3H\3H\3I\3I\3I\3I\3I\3I\3I\3J\3J\3J\3J\3J\3J\3J\3K\3K\3"+
		"K\3K\3K\3K\3K\3K\3L\3L\3L\3L\3L\3L\3L\3L\3L\3M\3M\3M\3M\3M\3N\3N\3N\3"+
		"N\3N\3N\3N\3N\3N\3O\3O\3O\3O\3O\3O\3P\3P\3P\3P\3P\3P\3P\3Q\3Q\3R\3R\3"+
		"R\3R\3R\3R\3R\3R\3R\3R\3R\3R\3R\3R\5R\u02d7\nR\3S\3S\3S\3S\3S\3S\3S\3"+
		"S\3S\3S\3S\3S\3S\3S\3S\3S\3S\3S\3S\3S\3S\3S\3S\3S\3S\3S\3S\3S\3S\3S\3"+
		"S\3S\3S\3S\3S\3S\3S\5S\u02fe\nS\3T\3T\3T\3T\3T\3T\3T\3T\3T\5T\u0309\n"+
		"T\3U\3U\3U\3U\7U\u030f\nU\fU\16U\u0312\13U\3U\3U\3U\3V\3V\3V\3V\7V\u031b"+
		"\nV\fV\16V\u031e\13V\3V\3V\5V\u0322\nV\3V\3V\5V\u0326\nV\5V\u0328\nV\3"+
		"V\5V\u032b\nV\3V\3V\3W\3W\3W\3W\5W\u0333\nW\3W\3W\3X\3X\5X\u0339\nX\3"+
		"Y\3Y\3Y\5Y\u033e\nY\3Z\3Z\3Z\3Z\3Z\5Z\u0345\nZ\3Z\7Z\u0348\nZ\fZ\16Z\u034b"+
		"\13Z\3Z\3Z\6Z\u034f\nZ\rZ\16Z\u0350\3[\7[\u0354\n[\f[\16[\u0357\13[\3"+
		"[\3[\6[\u035b\n[\r[\16[\u035c\3\\\3\\\3\\\3\\\3\\\5\\\u0364\n\\\3\\\7"+
		"\\\u0367\n\\\f\\\16\\\u036a\13\\\3\\\3\\\6\\\u036e\n\\\r\\\16\\\u036f"+
		"\3]\3]\3]\5]\u0375\n]\3]\3]\3]\5]\u037a\n]\3^\3^\3^\6^\u037f\n^\r^\16"+
		"^\u0380\3^\3^\6^\u0385\n^\r^\16^\u0386\5^\u0389\n^\3_\6_\u038c\n_\r_\16"+
		"_\u038d\3`\3`\3`\3`\3`\5`\u0395\n`\3`\6`\u0398\n`\r`\16`\u0399\3a\3a\3"+
		"b\3b\3c\3c\3d\3d\7d\u03a4\nd\fd\16d\u03a7\13d\3d\3d\3e\3e\3f\3f\3g\6g"+
		"\u03b0\ng\rg\16g\u03b1\3g\3g\3h\3h\3h\3h\7h\u03ba\nh\fh\16h\u03bd\13h"+
		"\3h\3h\3i\3i\3i\3i\7i\u03c5\ni\fi\16i\u03c8\13i\3i\3i\3i\3i\3i\3j\3j\3"+
		"j\3j\3j\3j\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3"+
		"k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3"+
		"k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3"+
		"k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3"+
		"k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3"+
		"k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3"+
		"k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3"+
		"k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3"+
		"k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3"+
		"k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\3k\5k\u04b3\nk\3"+
		"l\3l\3m\3m\3n\3n\3o\3o\3p\3p\3q\3q\3r\3r\3s\3s\3t\3t\3t\3u\3u\3u\3v\3"+
		"v\3w\3w\3x\3x\3y\3y\3z\3z\3{\3{\3|\3|\3|\3}\3}\3}\3~\3~\5~\u04df\n~\3"+
		"\177\3\177\3\177\5\177\u04e4\n\177\3\u0080\3\u0080\7\u0080\u04e8\n\u0080"+
		"\f\u0080\16\u0080\u04eb\13\u0080\3\u0080\3\u0080\6\u0080\u04ef\n\u0080"+
		"\r\u0080\16\u0080\u04f0\3\u0081\7\u0081\u04f4\n\u0081\f\u0081\16\u0081"+
		"\u04f7\13\u0081\3\u0081\3\u0081\6\u0081\u04fb\n\u0081\r\u0081\16\u0081"+
		"\u04fc\3\u0082\3\u0082\7\u0082\u0501\n\u0082\f\u0082\16\u0082\u0504\13"+
		"\u0082\3\u0082\3\u0082\6\u0082\u0508\n\u0082\r\u0082\16\u0082\u0509\3"+
		"\u0083\3\u0083\3\u0083\5\u0083\u050f\n\u0083\3\u0084\3\u0084\6\u0084\u0513"+
		"\n\u0084\r\u0084\16\u0084\u0514\3\u0085\6\u0085\u0518\n\u0085\r\u0085"+
		"\16\u0085\u0519\3\u0086\3\u0086\6\u0086\u051e\n\u0086\r\u0086\16\u0086"+
		"\u051f\3\u0087\3\u0087\3\u0088\3\u0088\3\u0089\3\u0089\3\u008a\3\u008a"+
		"\3\u008a\3\u008a\5\u008a\u052c\n\u008a\3\u008a\3\u008a\3\u008b\3\u008b"+
		"\6\u008b\u0532\n\u008b\r\u008b\16\u008b\u0533\3\u008c\3\u008c\7\u008c"+
		"\u0538\n\u008c\f\u008c\16\u008c\u053b\13\u008c\3\u008d\3\u008d\7\u008d"+
		"\u053f\n\u008d\f\u008d\16\u008d\u0542\13\u008d\3\u008e\3\u008e\3\u008f"+
		"\3\u008f\3\u0090\6\u0090\u0549\n\u0090\r\u0090\16\u0090\u054a\3\u0090"+
		"\3\u0090\3\u0091\3\u0091\3\u0091\3\u0091\7\u0091\u0553\n\u0091\f\u0091"+
		"\16\u0091\u0556\13\u0091\3\u0091\3\u0091\3\u0092\3\u0092\3\u0092\3\u0092"+
		"\7\u0092\u055e\n\u0092\f\u0092\16\u0092\u0561\13\u0092\3\u0092\3\u0092"+
		"\3\u0092\3\u0092\3\u0092\5\u0310\u03c6\u055f\2\u0093\4\4\6\5\b\6\n\7\f"+
		"\b\16\t\20\n\22\13\24\f\26\r\30\16\32\17\34\20\36\21 \22\"\23$\24&\25"+
		"(\26*\27,\30.\31\60\32\62\33\64\34\66\358\36:\37< >!@\"B#D$F%H&J\'L(N"+
		")P*R+T,V-X.Z/\\\60^\61`\62b\63d\64f\65h\66j\67l8n9p:r;t<v=x>z?|@~A\u0080"+
		"B\u0082C\u0084D\u0086E\u0088F\u008aG\u008cH\u008eI\u0090J\u0092K\u0094"+
		"L\u0096M\u0098N\u009aO\u009cP\u009eQ\u00a0R\u00a2S\u00a4T\u00a6U\u00a8"+
		"V\u00aaW\u00acX\u00aeY\u00b0Z\u00b2[\u00b4\\\u00b6]\u00b8^\u00ba_\u00bc"+
		"`\u00bea\u00c0b\u00c2\2\u00c4\2\u00c6\2\u00c8c\u00ca\2\u00cc\2\u00ced"+
		"\u00d0e\u00d2f\u00d4g\u00d6h\u00d8i\u00daj\u00dck\u00del\u00e0m\u00e2"+
		"n\u00e4o\u00e6p\u00e8q\u00ear\u00ecs\u00eet\u00f0u\u00f2v\u00f4w\u00f6"+
		"x\u00f8y\u00faz\u00fc{\u00fe|\u0100}\u0102~\u0104\177\u0106\u0080\u0108"+
		"\u0081\u010a\u0082\u010c\u0083\u010e\2\u0110\2\u0112\2\u0114\u0084\u0116"+
		"\u0085\u0118\u0086\u011a\u0087\u011c\2\u011e\2\u0120\u0088\u0122\u0089"+
		"\u0124\u008a\4\2\3\23\3\2$$\3\2||\4\2rruu\4\2ooww\7\2$$))hhpptt\3\2))"+
		"\4\2uuww\7\2dfkknnuuyy\4\2DDdd\3\2\62\63\3\2\62;\5\2\62;CHch\5\2C\\aa"+
		"c|\6\2\62;C\\aac|\6\2\13\f\17\17\"\"\u00a2\u00a2\4\2\f\f\17\17\4\2--/"+
		"/\2\u05f1\2\4\3\2\2\2\2\6\3\2\2\2\2\b\3\2\2\2\2\n\3\2\2\2\2\f\3\2\2\2"+
		"\2\16\3\2\2\2\2\20\3\2\2\2\2\22\3\2\2\2\2\24\3\2\2\2\2\26\3\2\2\2\2\30"+
		"\3\2\2\2\2\32\3\2\2\2\2\34\3\2\2\2\2\36\3\2\2\2\2 \3\2\2\2\2\"\3\2\2\2"+
		"\2$\3\2\2\2\2&\3\2\2\2\2(\3\2\2\2\2*\3\2\2\2\2,\3\2\2\2\2.\3\2\2\2\2\60"+
		"\3\2\2\2\2\62\3\2\2\2\2\64\3\2\2\2\2\66\3\2\2\2\28\3\2\2\2\2:\3\2\2\2"+
		"\2<\3\2\2\2\2>\3\2\2\2\2@\3\2\2\2\2B\3\2\2\2\2D\3\2\2\2\2F\3\2\2\2\2H"+
		"\3\2\2\2\2J\3\2\2\2\2L\3\2\2\2\2N\3\2\2\2\2P\3\2\2\2\2R\3\2\2\2\2T\3\2"+
		"\2\2\2V\3\2\2\2\2X\3\2\2\2\2Z\3\2\2\2\2\\\3\2\2\2\2^\3\2\2\2\2`\3\2\2"+
		"\2\2b\3\2\2\2\2d\3\2\2\2\2f\3\2\2\2\2h\3\2\2\2\2j\3\2\2\2\2l\3\2\2\2\2"+
		"n\3\2\2\2\2p\3\2\2\2\2r\3\2\2\2\2t\3\2\2\2\2v\3\2\2\2\2x\3\2\2\2\2z\3"+
		"\2\2\2\2|\3\2\2\2\2~\3\2\2\2\2\u0080\3\2\2\2\2\u0082\3\2\2\2\2\u0084\3"+
		"\2\2\2\2\u0086\3\2\2\2\2\u0088\3\2\2\2\2\u008a\3\2\2\2\2\u008c\3\2\2\2"+
		"\2\u008e\3\2\2\2\2\u0090\3\2\2\2\2\u0092\3\2\2\2\2\u0094\3\2\2\2\2\u0096"+
		"\3\2\2\2\2\u0098\3\2\2\2\2\u009a\3\2\2\2\2\u009c\3\2\2\2\2\u009e\3\2\2"+
		"\2\2\u00a0\3\2\2\2\2\u00a2\3\2\2\2\2\u00a4\3\2\2\2\2\u00a6\3\2\2\2\2\u00a8"+
		"\3\2\2\2\2\u00aa\3\2\2\2\2\u00ac\3\2\2\2\2\u00ae\3\2\2\2\2\u00b0\3\2\2"+
		"\2\2\u00b2\3\2\2\2\2\u00b4\3\2\2\2\2\u00b6\3\2\2\2\2\u00b8\3\2\2\2\2\u00ba"+
		"\3\2\2\2\2\u00bc\3\2\2\2\2\u00be\3\2\2\2\2\u00c0\3\2\2\2\2\u00c8\3\2\2"+
		"\2\2\u00ce\3\2\2\2\2\u00d0\3\2\2\2\2\u00d2\3\2\2\2\3\u00d4\3\2\2\2\3\u00d6"+
		"\3\2\2\2\3\u00d8\3\2\2\2\3\u00da\3\2\2\2\3\u00dc\3\2\2\2\3\u00de\3\2\2"+
		"\2\3\u00e0\3\2\2\2\3\u00e2\3\2\2\2\3\u00e4\3\2\2\2\3\u00e6\3\2\2\2\3\u00e8"+
		"\3\2\2\2\3\u00ea\3\2\2\2\3\u00ec\3\2\2\2\3\u00ee\3\2\2\2\3\u00f0\3\2\2"+
		"\2\3\u00f2\3\2\2\2\3\u00f4\3\2\2\2\3\u00f6\3\2\2\2\3\u00f8\3\2\2\2\3\u00fa"+
		"\3\2\2\2\3\u00fc\3\2\2\2\3\u00fe\3\2\2\2\3\u0100\3\2\2\2\3\u0102\3\2\2"+
		"\2\3\u0104\3\2\2\2\3\u0106\3\2\2\2\3\u0108\3\2\2\2\3\u010a\3\2\2\2\3\u010c"+
		"\3\2\2\2\3\u0114\3\2\2\2\3\u0116\3\2\2\2\3\u0118\3\2\2\2\3\u011a\3\2\2"+
		"\2\3\u0120\3\2\2\2\3\u0122\3\2\2\2\3\u0124\3\2\2\2\4\u0126\3\2\2\2\6\u0129"+
		"\3\2\2\2\b\u012b\3\2\2\2\n\u012d\3\2\2\2\f\u012f\3\2\2\2\16\u0131\3\2"+
		"\2\2\20\u0133\3\2\2\2\22\u0135\3\2\2\2\24\u0137\3\2\2\2\26\u0139\3\2\2"+
		"\2\30\u013c\3\2\2\2\32\u013e\3\2\2\2\34\u0140\3\2\2\2\36\u0143\3\2\2\2"+
		" \u0145\3\2\2\2\"\u0147\3\2\2\2$\u0149\3\2\2\2&\u014b\3\2\2\2(\u014d\3"+
		"\2\2\2*\u0150\3\2\2\2,\u0153\3\2\2\2.\u0155\3\2\2\2\60\u0157\3\2\2\2\62"+
		"\u0159\3\2\2\2\64\u015b\3\2\2\2\66\u015e\3\2\2\28\u0161\3\2\2\2:\u0164"+
		"\3\2\2\2<\u0167\3\2\2\2>\u0169\3\2\2\2@\u016c\3\2\2\2B\u016f\3\2\2\2D"+
		"\u0171\3\2\2\2F\u0174\3\2\2\2H\u0177\3\2\2\2J\u018f\3\2\2\2L\u0191\3\2"+
		"\2\2N\u019a\3\2\2\2P\u01a2\3\2\2\2R\u01aa\3\2\2\2T\u01b2\3\2\2\2V\u01b5"+
		"\3\2\2\2X\u01bc\3\2\2\2Z\u01c1\3\2\2\2\\\u01c5\3\2\2\2^\u01ce\3\2\2\2"+
		"`\u01d7\3\2\2\2b\u01e0\3\2\2\2d\u01e6\3\2\2\2f\u01ed\3\2\2\2h\u01f4\3"+
		"\2\2\2j\u01fa\3\2\2\2l\u0203\3\2\2\2n\u020a\3\2\2\2p\u0213\3\2\2\2r\u021d"+
		"\3\2\2\2t\u0239\3\2\2\2v\u023b\3\2\2\2x\u023e\3\2\2\2z\u0243\3\2\2\2|"+
		"\u0249\3\2\2\2~\u024c\3\2\2\2\u0080\u0250\3\2\2\2\u0082\u0257\3\2\2\2"+
		"\u0084\u025e\3\2\2\2\u0086\u0264\3\2\2\2\u0088\u026d\3\2\2\2\u008a\u0273"+
		"\3\2\2\2\u008c\u027b\3\2\2\2\u008e\u0280\3\2\2\2\u0090\u0287\3\2\2\2\u0092"+
		"\u028c\3\2\2\2\u0094\u0293\3\2\2\2\u0096\u029a\3\2\2\2\u0098\u02a2\3\2"+
		"\2\2\u009a\u02ab\3\2\2\2\u009c\u02b0\3\2\2\2\u009e\u02b9\3\2\2\2\u00a0"+
		"\u02bf\3\2\2\2\u00a2\u02c6\3\2\2\2\u00a4\u02d6\3\2\2\2\u00a6\u02fd\3\2"+
		"\2\2\u00a8\u0308\3\2\2\2\u00aa\u030a\3\2\2\2\u00ac\u0316\3\2\2\2\u00ae"+
		"\u032e\3\2\2\2\u00b0\u0338\3\2\2\2\u00b2\u033d\3\2\2\2\u00b4\u0344\3\2"+
		"\2\2\u00b6\u0355\3\2\2\2\u00b8\u0363\3\2\2\2\u00ba\u0374\3\2\2\2\u00bc"+
		"\u0388\3\2\2\2\u00be\u038b\3\2\2\2\u00c0\u0394\3\2\2\2\u00c2\u039b\3\2"+
		"\2\2\u00c4\u039d\3\2\2\2\u00c6\u039f\3\2\2\2\u00c8\u03a1\3\2\2\2\u00ca"+
		"\u03aa\3\2\2\2\u00cc\u03ac\3\2\2\2\u00ce\u03af\3\2\2\2\u00d0\u03b5\3\2"+
		"\2\2\u00d2\u03c0\3\2\2\2\u00d4\u03ce\3\2\2\2\u00d6\u04b2\3\2\2\2\u00d8"+
		"\u04b4\3\2\2\2\u00da\u04b6\3\2\2\2\u00dc\u04b8\3\2\2\2\u00de\u04ba\3\2"+
		"\2\2\u00e0\u04bc\3\2\2\2\u00e2\u04be\3\2\2\2\u00e4\u04c0\3\2\2\2\u00e6"+
		"\u04c2\3\2\2\2\u00e8\u04c4\3\2\2\2\u00ea\u04c7\3\2\2\2\u00ec\u04ca\3\2"+
		"\2\2\u00ee\u04cc\3\2\2\2\u00f0\u04ce\3\2\2\2\u00f2\u04d0\3\2\2\2\u00f4"+
		"\u04d2\3\2\2\2\u00f6\u04d4\3\2\2\2\u00f8\u04d6\3\2\2\2\u00fa\u04d9\3\2"+
		"\2\2\u00fc\u04de\3\2\2\2\u00fe\u04e3\3\2\2\2\u0100\u04e5\3\2\2\2\u0102"+
		"\u04f5\3\2\2\2\u0104\u04fe\3\2\2\2\u0106\u050e\3\2\2\2\u0108\u0510\3\2"+
		"\2\2\u010a\u0517\3\2\2\2\u010c\u051b\3\2\2\2\u010e\u0521\3\2\2\2\u0110"+
		"\u0523\3\2\2\2\u0112\u0525\3\2\2\2\u0114\u0527\3\2\2\2\u0116\u052f\3\2"+
		"\2\2\u0118\u0535\3\2\2\2\u011a\u053c\3\2\2\2\u011c\u0543\3\2\2\2\u011e"+
		"\u0545\3\2\2\2\u0120\u0548\3\2\2\2\u0122\u054e\3\2\2\2\u0124\u0559\3\2"+
		"\2\2\u0126\u0127\7}\2\2\u0127\u0128\b\2\2\2\u0128\5\3\2\2\2\u0129\u012a"+
		"\7\177\2\2\u012a\7\3\2\2\2\u012b\u012c\7]\2\2\u012c\t\3\2\2\2\u012d\u012e"+
		"\7_\2\2\u012e\13\3\2\2\2\u012f\u0130\7*\2\2\u0130\r\3\2\2\2\u0131\u0132"+
		"\7+\2\2\u0132\17\3\2\2\2\u0133\u0134\7=\2\2\u0134\21\3\2\2\2\u0135\u0136"+
		"\7<\2\2\u0136\23\3\2\2\2\u0137\u0138\7.\2\2\u0138\25\3\2\2\2\u0139\u013a"+
		"\7\60\2\2\u013a\u013b\7\60\2\2\u013b\27\3\2\2\2\u013c\u013d\7A\2\2\u013d"+
		"\31\3\2\2\2\u013e\u013f\7\60\2\2\u013f\33\3\2\2\2\u0140\u0141\7/\2\2\u0141"+
		"\u0142\7@\2\2\u0142\35\3\2\2\2\u0143\u0144\7-\2\2\u0144\37\3\2\2\2\u0145"+
		"\u0146\7/\2\2\u0146!\3\2\2\2\u0147\u0148\7,\2\2\u0148#\3\2\2\2\u0149\u014a"+
		"\7\61\2\2\u014a%\3\2\2\2\u014b\u014c\7\'\2\2\u014c\'\3\2\2\2\u014d\u014e"+
		"\7-\2\2\u014e\u014f\7-\2\2\u014f)\3\2\2\2\u0150\u0151\7/\2\2\u0151\u0152"+
		"\7/\2\2\u0152+\3\2\2\2\u0153\u0154\7(\2\2\u0154-\3\2\2\2\u0155\u0156\7"+
		"\u0080\2\2\u0156/\3\2\2\2\u0157\u0158\7`\2\2\u0158\61\3\2\2\2\u0159\u015a"+
		"\7~\2\2\u015a\63\3\2\2\2\u015b\u015c\7>\2\2\u015c\u015d\7>\2\2\u015d\65"+
		"\3\2\2\2\u015e\u015f\7@\2\2\u015f\u0160\7@\2\2\u0160\67\3\2\2\2\u0161"+
		"\u0162\7?\2\2\u0162\u0163\7?\2\2\u01639\3\2\2\2\u0164\u0165\7#\2\2\u0165"+
		"\u0166\7?\2\2\u0166;\3\2\2\2\u0167\u0168\7>\2\2\u0168=\3\2\2\2\u0169\u016a"+
		"\7>\2\2\u016a\u016b\7?\2\2\u016b?\3\2\2\2\u016c\u016d\7@\2\2\u016d\u016e"+
		"\7?\2\2\u016eA\3\2\2\2\u016f\u0170\7@\2\2\u0170C\3\2\2\2\u0171\u0172\7"+
		"(\2\2\u0172\u0173\7(\2\2\u0173E\3\2\2\2\u0174\u0175\7~\2\2\u0175\u0176"+
		"\7~\2\2\u0176G\3\2\2\2\u0177\u0178\7?\2\2\u0178I\3\2\2\2\u0179\u017a\7"+
		"-\2\2\u017a\u0190\7?\2\2\u017b\u017c\7/\2\2\u017c\u0190\7?\2\2\u017d\u017e"+
		"\7,\2\2\u017e\u0190\7?\2\2\u017f\u0180\7\61\2\2\u0180\u0190\7?\2\2\u0181"+
		"\u0182\7\'\2\2\u0182\u0190\7?\2\2\u0183\u0184\7>\2\2\u0184\u0185\7>\2"+
		"\2\u0185\u0190\7?\2\2\u0186\u0187\7@\2\2\u0187\u0188\7@\2\2\u0188\u0190"+
		"\7?\2\2\u0189\u018a\7(\2\2\u018a\u0190\7?\2\2\u018b\u018c\7~\2\2\u018c"+
		"\u0190\7?\2\2\u018d\u018e\7`\2\2\u018e\u0190\7?\2\2\u018f\u0179\3\2\2"+
		"\2\u018f\u017b\3\2\2\2\u018f\u017d\3\2\2\2\u018f\u017f\3\2\2\2\u018f\u0181"+
		"\3\2\2\2\u018f\u0183\3\2\2\2\u018f\u0186\3\2\2\2\u018f\u0189\3\2\2\2\u018f"+
		"\u018b\3\2\2\2\u018f\u018d\3\2\2\2\u0190K\3\2\2\2\u0191\u0192\7k\2\2\u0192"+
		"\u0193\7o\2\2\u0193\u0194\7r\2\2\u0194\u0195\7q\2\2\u0195\u0196\7t\2\2"+
		"\u0196\u0197\7v\2\2\u0197\u0198\3\2\2\2\u0198\u0199\b&\3\2\u0199M\3\2"+
		"\2\2\u019a\u019b\7v\2\2\u019b\u019c\7{\2\2\u019c\u019d\7r\2\2\u019d\u019e"+
		"\7g\2\2\u019e\u019f\7f\2\2\u019f\u01a0\7g\2\2\u01a0\u01a1\7h\2\2\u01a1"+
		"O\3\2\2\2\u01a2\u01a3\7%\2\2\u01a3\u01a4\7r\2\2\u01a4\u01a5\7t\2\2\u01a5"+
		"\u01a6\7c\2\2\u01a6\u01a7\7i\2\2\u01a7\u01a8\7o\2\2\u01a8\u01a9\7c\2\2"+
		"\u01a9Q\3\2\2\2\u01aa\u01ab\7t\2\2\u01ab\u01ac\7g\2\2\u01ac\u01ad\7u\2"+
		"\2\u01ad\u01ae\7g\2\2\u01ae\u01af\7t\2\2\u01af\u01b0\7x\2\2\u01b0\u01b1"+
		"\7g\2\2\u01b1S\3\2\2\2\u01b2\u01b3\7r\2\2\u01b3\u01b4\7e\2\2\u01b4U\3"+
		"\2\2\2\u01b5\u01b6\7v\2\2\u01b6\u01b7\7c\2\2\u01b7\u01b8\7t\2\2\u01b8"+
		"\u01b9\7i\2\2\u01b9\u01ba\7g\2\2\u01ba\u01bb\7v\2\2\u01bbW\3\2\2\2\u01bc"+
		"\u01bd\7n\2\2\u01bd\u01be\7k\2\2\u01be\u01bf\7p\2\2\u01bf\u01c0\7m\2\2"+
		"\u01c0Y\3\2\2\2\u01c1\u01c2\7e\2\2\u01c2\u01c3\7r\2\2\u01c3\u01c4\7w\2"+
		"\2\u01c4[\3\2\2\2\u01c5\u01c6\7e\2\2\u01c6\u01c7\7q\2\2\u01c7\u01c8\7"+
		"f\2\2\u01c8\u01c9\7g\2\2\u01c9\u01ca\7a\2\2\u01ca\u01cb\7u\2\2\u01cb\u01cc"+
		"\7g\2\2\u01cc\u01cd\7i\2\2\u01cd]\3\2\2\2\u01ce\u01cf\7f\2\2\u01cf\u01d0"+
		"\7c\2\2\u01d0\u01d1\7v\2\2\u01d1\u01d2\7c\2\2\u01d2\u01d3\7a\2\2\u01d3"+
		"\u01d4\7u\2\2\u01d4\u01d5\7g\2\2\u01d5\u01d6\7i\2\2\u01d6_\3\2\2\2\u01d7"+
		"\u01d8\7g\2\2\u01d8\u01d9\7p\2\2\u01d9\u01da\7e\2\2\u01da\u01db\7q\2\2"+
		"\u01db\u01dc\7f\2\2\u01dc\u01dd\7k\2\2\u01dd\u01de\7p\2\2\u01de\u01df"+
		"\7i\2\2\u01dfa\3\2\2\2\u01e0\u01e1\7e\2\2\u01e1\u01e2\7q\2\2\u01e2\u01e3"+
		"\7p\2\2\u01e3\u01e4\7u\2\2\u01e4\u01e5\7v\2\2\u01e5c\3\2\2\2\u01e6\u01e7"+
		"\7g\2\2\u01e7\u01e8\7z\2\2\u01e8\u01e9\7v\2\2\u01e9\u01ea\7g\2\2\u01ea"+
		"\u01eb\7t\2\2\u01eb\u01ec\7p\2\2\u01ece\3\2\2\2\u01ed\u01ee\7g\2\2\u01ee"+
		"\u01ef\7z\2\2\u01ef\u01f0\7r\2\2\u01f0\u01f1\7q\2\2\u01f1\u01f2\7t\2\2"+
		"\u01f2\u01f3\7v\2\2\u01f3g\3\2\2\2\u01f4\u01f5\7c\2\2\u01f5\u01f6\7n\2"+
		"\2\u01f6\u01f7\7k\2\2\u01f7\u01f8\7i\2\2\u01f8\u01f9\7p\2\2\u01f9i\3\2"+
		"\2\2\u01fa\u01fb\7t\2\2\u01fb\u01fc\7g\2\2\u01fc\u01fd\7i\2\2\u01fd\u01fe"+
		"\7k\2\2\u01fe\u01ff\7u\2\2\u01ff\u0200\7v\2\2\u0200\u0201\7g\2\2\u0201"+
		"\u0202\7t\2\2\u0202k\3\2\2\2\u0203\u0204\7k\2\2\u0204\u0205\7p\2\2\u0205"+
		"\u0206\7n\2\2\u0206\u0207\7k\2\2\u0207\u0208\7p\2\2\u0208\u0209\7g\2\2"+
		"\u0209m\3\2\2\2\u020a\u020b\7x\2\2\u020b\u020c\7q\2\2\u020c\u020d\7n\2"+
		"\2\u020d\u020e\7c\2\2\u020e\u020f\7v\2\2\u020f\u0210\7k\2\2\u0210\u0211"+
		"\7n\2\2\u0211\u0212\7g\2\2\u0212o\3\2\2\2\u0213\u0214\7k\2\2\u0214\u0215"+
		"\7p\2\2\u0215\u0216\7v\2\2\u0216\u0217\7g\2\2\u0217\u0218\7t\2\2\u0218"+
		"\u0219\7t\2\2\u0219\u021a\7w\2\2\u021a\u021b\7r\2\2\u021b\u021c\7v\2\2"+
		"\u021cq\3\2\2\2\u021d\u021e\7e\2\2\u021e\u021f\7c\2\2\u021f\u0220\7n\2"+
		"\2\u0220\u0221\7n\2\2\u0221\u0222\7k\2\2\u0222\u0223\7p\2\2\u0223\u0224"+
		"\7i\2\2\u0224s\3\2\2\2\u0225\u0226\7a\2\2\u0226\u0227\7a\2\2\u0227\u0228"+
		"\7u\2\2\u0228\u0229\7v\2\2\u0229\u022a\7c\2\2\u022a\u022b\7e\2\2\u022b"+
		"\u022c\7m\2\2\u022c\u022d\7e\2\2\u022d\u022e\7c\2\2\u022e\u022f\7n\2\2"+
		"\u022f\u023a\7n\2\2\u0230\u0231\7a\2\2\u0231\u0232\7a\2\2\u0232\u0233"+
		"\7r\2\2\u0233\u0234\7j\2\2\u0234\u0235\7k\2\2\u0235\u0236\7e\2\2\u0236"+
		"\u0237\7c\2\2\u0237\u0238\7n\2\2\u0238\u023a\7n\2\2\u0239\u0225\3\2\2"+
		"\2\u0239\u0230\3\2\2\2\u023au\3\2\2\2\u023b\u023c\7k\2\2\u023c\u023d\7"+
		"h\2\2\u023dw\3\2\2\2\u023e\u023f\7g\2\2\u023f\u0240\7n\2\2\u0240\u0241"+
		"\7u\2\2\u0241\u0242\7g\2\2\u0242y\3\2\2\2\u0243\u0244\7y\2\2\u0244\u0245"+
		"\7j\2\2\u0245\u0246\7k\2\2\u0246\u0247\7n\2\2\u0247\u0248\7g\2\2\u0248"+
		"{\3\2\2\2\u0249\u024a\7f\2\2\u024a\u024b\7q\2\2\u024b}\3\2\2\2\u024c\u024d"+
		"\7h\2\2\u024d\u024e\7q\2\2\u024e\u024f\7t\2\2\u024f\177\3\2\2\2\u0250"+
		"\u0251\7u\2\2\u0251\u0252\7y\2\2\u0252\u0253\7k\2\2\u0253\u0254\7v\2\2"+
		"\u0254\u0255\7e\2\2\u0255\u0256\7j\2\2\u0256\u0081\3\2\2\2\u0257\u0258"+
		"\7t\2\2\u0258\u0259\7g\2\2\u0259\u025a\7v\2\2\u025a\u025b\7w\2\2\u025b"+
		"\u025c\7t\2\2\u025c\u025d\7p\2\2\u025d\u0083\3\2\2\2\u025e\u025f\7d\2"+
		"\2\u025f\u0260\7t\2\2\u0260\u0261\7g\2\2\u0261\u0262\7c\2\2\u0262\u0263"+
		"\7m\2\2\u0263\u0085\3\2\2\2\u0264\u0265\7e\2\2\u0265\u0266\7q\2\2\u0266"+
		"\u0267\7p\2\2\u0267\u0268\7v\2\2\u0268\u0269\7k\2\2\u0269\u026a\7p\2\2"+
		"\u026a\u026b\7w\2\2\u026b\u026c\7g\2\2\u026c\u0087\3\2\2\2\u026d\u026e"+
		"\7c\2\2\u026e\u026f\7u\2\2\u026f\u0270\7o\2\2\u0270\u0271\3\2\2\2\u0271"+
		"\u0272\bD\4\2\u0272\u0089\3\2\2\2\u0273\u0274\7f\2\2\u0274\u0275\7g\2"+
		"\2\u0275\u0276\7h\2\2\u0276\u0277\7c\2\2\u0277\u0278\7w\2\2\u0278\u0279"+
		"\7n\2\2\u0279\u027a\7v\2\2\u027a\u008b\3\2\2\2\u027b\u027c\7e\2\2\u027c"+
		"\u027d\7c\2\2\u027d\u027e\7u\2\2\u027e\u027f\7g\2\2\u027f\u008d\3\2\2"+
		"\2\u0280\u0281\7u\2\2\u0281\u0282\7v\2\2\u0282\u0283\7t\2\2\u0283\u0284"+
		"\7w\2\2\u0284\u0285\7e\2\2\u0285\u0286\7v\2\2\u0286\u008f\3\2\2\2\u0287"+
		"\u0288\7g\2\2\u0288\u0289\7p\2\2\u0289\u028a\7w\2\2\u028a\u028b\7o\2\2"+
		"\u028b\u0091\3\2\2\2\u028c\u028d\7u\2\2\u028d\u028e\7k\2\2\u028e\u028f"+
		"\7|\2\2\u028f\u0290\7g\2\2\u0290\u0291\7q\2\2\u0291\u0292\7h\2\2\u0292"+
		"\u0093\3\2\2\2\u0293\u0294\7v\2\2\u0294\u0295\7{\2\2\u0295\u0296\7r\2"+
		"\2\u0296\u0297\7g\2\2\u0297\u0298\7k\2\2\u0298\u0299\7f\2\2\u0299\u0095"+
		"\3\2\2\2\u029a\u029b\7m\2\2\u029b\u029c\7k\2\2\u029c\u029d\7e\2\2\u029d"+
		"\u029e\7m\2\2\u029e\u029f\7c\2\2\u029f\u02a0\7u\2\2\u02a0\u02a1\7o\2\2"+
		"\u02a1\u0097\3\2\2\2\u02a2\u02a3\7t\2\2\u02a3\u02a4\7g\2\2\u02a4\u02a5"+
		"\7u\2\2\u02a5\u02a6\7q\2\2\u02a6\u02a7\7w\2\2\u02a7\u02a8\7t\2\2\u02a8"+
		"\u02a9\7e\2\2\u02a9\u02aa\7g\2\2\u02aa\u0099\3\2\2\2\u02ab\u02ac\7w\2"+
		"\2\u02ac\u02ad\7u\2\2\u02ad\u02ae\7g\2\2\u02ae\u02af\7u\2\2\u02af\u009b"+
		"\3\2\2\2\u02b0\u02b1\7e\2\2\u02b1\u02b2\7n\2\2\u02b2\u02b3\7q\2\2\u02b3"+
		"\u02b4\7d\2\2\u02b4\u02b5\7d\2\2\u02b5\u02b6\7g\2\2\u02b6\u02b7\7t\2\2"+
		"\u02b7\u02b8\7u\2\2\u02b8\u009d\3\2\2\2\u02b9\u02ba\7d\2\2\u02ba\u02bb"+
		"\7{\2\2\u02bb\u02bc\7v\2\2\u02bc\u02bd\7g\2\2\u02bd\u02be\7u\2\2\u02be"+
		"\u009f\3\2\2\2\u02bf\u02c0\7e\2\2\u02c0\u02c1\7{\2\2\u02c1\u02c2\7e\2"+
		"\2\u02c2\u02c3\7n\2\2\u02c3\u02c4\7g\2\2\u02c4\u02c5\7u\2\2\u02c5\u00a1"+
		"\3\2\2\2\u02c6\u02c7\7#\2\2\u02c7\u00a3\3\2\2\2\u02c8\u02c9\7u\2\2\u02c9"+
		"\u02ca\7k\2\2\u02ca\u02cb\7i\2\2\u02cb\u02cc\7p\2\2\u02cc\u02cd\7g\2\2"+
		"\u02cd\u02d7\7f\2\2\u02ce\u02cf\7w\2\2\u02cf\u02d0\7p\2\2\u02d0\u02d1"+
		"\7u\2\2\u02d1\u02d2\7k\2\2\u02d2\u02d3\7i\2\2\u02d3\u02d4\7p\2\2\u02d4"+
		"\u02d5\7g\2\2\u02d5\u02d7\7f\2\2\u02d6\u02c8\3\2\2\2\u02d6\u02ce\3\2\2"+
		"\2\u02d7\u00a5\3\2\2\2\u02d8\u02d9\7d\2\2\u02d9\u02da\7{\2\2\u02da\u02db"+
		"\7v\2\2\u02db\u02fe\7g\2\2\u02dc\u02dd\7y\2\2\u02dd\u02de\7q\2\2\u02de"+
		"\u02df\7t\2\2\u02df\u02fe\7f\2\2\u02e0\u02e1\7f\2\2\u02e1\u02e2\7y\2\2"+
		"\u02e2\u02e3\7q\2\2\u02e3\u02e4\7t\2\2\u02e4\u02fe\7f\2\2\u02e5\u02e6"+
		"\7d\2\2\u02e6\u02e7\7q\2\2\u02e7\u02e8\7q\2\2\u02e8\u02fe\7n\2\2\u02e9"+
		"\u02ea\7e\2\2\u02ea\u02eb\7j\2\2\u02eb\u02ec\7c\2\2\u02ec\u02fe\7t\2\2"+
		"\u02ed\u02ee\7u\2\2\u02ee\u02ef\7j\2\2\u02ef\u02f0\7q\2\2\u02f0\u02f1"+
		"\7t\2\2\u02f1\u02fe\7v\2\2\u02f2\u02f3\7k\2\2\u02f3\u02f4\7p\2\2\u02f4"+
		"\u02fe\7v\2\2\u02f5\u02f6\7n\2\2\u02f6\u02f7\7q\2\2\u02f7\u02f8\7p\2\2"+
		"\u02f8\u02fe\7i\2\2\u02f9\u02fa\7x\2\2\u02fa\u02fb\7q\2\2\u02fb\u02fc"+
		"\7k\2\2\u02fc\u02fe\7f\2\2\u02fd\u02d8\3\2\2\2\u02fd\u02dc\3\2\2\2\u02fd"+
		"\u02e0\3\2\2\2\u02fd\u02e5\3\2\2\2\u02fd\u02e9\3\2\2\2\u02fd\u02ed\3\2"+
		"\2\2\u02fd\u02f2\3\2\2\2\u02fd\u02f5\3\2\2\2\u02fd\u02f9\3\2\2\2\u02fe"+
		"\u00a7\3\2\2\2\u02ff\u0300\7v\2\2\u0300\u0301\7t\2\2\u0301\u0302\7w\2"+
		"\2\u0302\u0309\7g\2\2\u0303\u0304\7h\2\2\u0304\u0305\7c\2\2\u0305\u0306"+
		"\7n\2\2\u0306\u0307\7u\2\2\u0307\u0309\7g\2\2\u0308\u02ff\3\2\2\2\u0308"+
		"\u0303\3\2\2\2\u0309\u00a9\3\2\2\2\u030a\u030b\7}\2\2\u030b\u030c\7}\2"+
		"\2\u030c\u0310\3\2\2\2\u030d\u030f\13\2\2\2\u030e\u030d\3\2\2\2\u030f"+
		"\u0312\3\2\2\2\u0310\u0311\3\2\2\2\u0310\u030e\3\2\2\2\u0311\u0313\3\2"+
		"\2\2\u0312\u0310\3\2\2\2\u0313\u0314\7\177\2\2\u0314\u0315\7\177\2\2\u0315"+
		"\u00ab\3\2\2\2\u0316\u031c\7$\2\2\u0317\u0318\7^\2\2\u0318\u031b\7$\2"+
		"\2\u0319\u031b\n\2\2\2\u031a\u0317\3\2\2\2\u031a\u0319\3\2\2\2\u031b\u031e"+
		"\3\2\2\2\u031c\u031a\3\2\2\2\u031c\u031d\3\2\2\2\u031d\u031f\3\2\2\2\u031e"+
		"\u031c\3\2\2\2\u031f\u0321\7$\2\2\u0320\u0322\t\3\2\2\u0321\u0320\3\2"+
		"\2\2\u0321\u0322\3\2\2\2\u0322\u0327\3\2\2\2\u0323\u0325\t\4\2\2\u0324"+
		"\u0326\t\5\2\2\u0325\u0324\3\2\2\2\u0325\u0326\3\2\2\2\u0326\u0328\3\2"+
		"\2\2\u0327\u0323\3\2\2\2\u0327\u0328\3\2\2\2\u0328\u032a\3\2\2\2\u0329"+
		"\u032b\t\3\2\2\u032a\u0329\3\2\2\2\u032a\u032b\3\2\2\2\u032b\u032c\3\2"+
		"\2\2\u032c\u032d\bV\5\2\u032d\u00ad\3\2\2\2\u032e\u0332\7)\2\2\u032f\u0330"+
		"\7^\2\2\u0330\u0333\t\6\2\2\u0331\u0333\n\7\2\2\u0332\u032f\3\2\2\2\u0332"+
		"\u0331\3\2\2\2\u0333\u0334\3\2\2\2\u0334\u0335\7)\2\2\u0335\u00af\3\2"+
		"\2\2\u0336\u0339\5\u00b2Y\2\u0337\u0339\5\u00ba]\2\u0338\u0336\3\2\2\2"+
		"\u0338\u0337\3\2\2\2\u0339\u00b1\3\2\2\2\u033a\u033e\5\u00b4Z\2\u033b"+
		"\u033e\5\u00b6[\2\u033c\u033e\5\u00b8\\\2\u033d\u033a\3\2\2\2\u033d\u033b"+
		"\3\2\2\2\u033d\u033c\3\2\2\2\u033e\u00b3\3\2\2\2\u033f\u0345\7\'\2\2\u0340"+
		"\u0341\7\62\2\2\u0341\u0345\7d\2\2\u0342\u0343\7\62\2\2\u0343\u0345\7"+
		"D\2\2\u0344\u033f\3\2\2\2\u0344\u0340\3\2\2\2\u0344\u0342\3\2\2\2\u0345"+
		"\u0349\3\2\2\2\u0346\u0348\5\u00c2a\2\u0347\u0346\3\2\2\2\u0348\u034b"+
		"\3\2\2\2\u0349\u0347\3\2\2\2\u0349\u034a\3\2\2\2\u034a\u034c\3\2\2\2\u034b"+
		"\u0349\3\2\2\2\u034c\u034e\7\60\2\2\u034d\u034f\5\u00c2a\2\u034e\u034d"+
		"\3\2\2\2\u034f\u0350\3\2\2\2\u0350\u034e\3\2\2\2\u0350\u0351\3\2\2\2\u0351"+
		"\u00b5\3\2\2\2\u0352\u0354\5\u00c4b\2\u0353\u0352\3\2\2\2\u0354\u0357"+
		"\3\2\2\2\u0355\u0353\3\2\2\2\u0355\u0356\3\2\2\2\u0356\u0358\3\2\2\2\u0357"+
		"\u0355\3\2\2\2\u0358\u035a\7\60\2\2\u0359\u035b\5\u00c4b\2\u035a\u0359"+
		"\3\2\2\2\u035b\u035c\3\2\2\2\u035c\u035a\3\2\2\2\u035c\u035d\3\2\2\2\u035d"+
		"\u00b7\3\2\2\2\u035e\u0364\7&\2\2\u035f\u0360\7\62\2\2\u0360\u0364\7z"+
		"\2\2\u0361\u0362\7\62\2\2\u0362\u0364\7Z\2\2\u0363\u035e\3\2\2\2\u0363"+
		"\u035f\3\2\2\2\u0363\u0361\3\2\2\2\u0364\u0368\3\2\2\2\u0365\u0367\5\u00c6"+
		"c\2\u0366\u0365\3\2\2\2\u0367\u036a\3\2\2\2\u0368\u0366\3\2\2\2\u0368"+
		"\u0369\3\2\2\2\u0369\u036b\3\2\2\2\u036a\u0368\3\2\2\2\u036b\u036d\7\60"+
		"\2\2\u036c\u036e\5\u00c6c\2\u036d\u036c\3\2\2\2\u036e\u036f\3\2\2\2\u036f"+
		"\u036d\3\2\2\2\u036f\u0370\3\2\2\2\u0370\u00b9\3\2\2\2\u0371\u0375\5\u00be"+
		"_\2\u0372\u0375\5\u00c0`\2\u0373\u0375\5\u00bc^\2\u0374\u0371\3\2\2\2"+
		"\u0374\u0372\3\2\2\2\u0374\u0373\3\2\2\2\u0375\u0379\3\2\2\2\u0376\u0377"+
		"\t\b\2\2\u0377\u037a\t\t\2\2\u0378\u037a\7n\2\2\u0379\u0376\3\2\2\2\u0379"+
		"\u0378\3\2\2\2\u0379\u037a\3\2\2\2\u037a\u00bb\3\2\2\2\u037b\u037c\7\62"+
		"\2\2\u037c\u037e\t\n\2\2\u037d\u037f\5\u00c2a\2\u037e\u037d\3\2\2\2\u037f"+
		"\u0380\3\2\2\2\u0380\u037e\3\2\2\2\u0380\u0381\3\2\2\2\u0381\u0389\3\2"+
		"\2\2\u0382\u0384\7\'\2\2\u0383\u0385\5\u00c2a\2\u0384\u0383\3\2\2\2\u0385"+
		"\u0386\3\2\2\2\u0386\u0384\3\2\2\2\u0386\u0387\3\2\2\2\u0387\u0389\3\2"+
		"\2\2\u0388\u037b\3\2\2\2\u0388\u0382\3\2\2\2\u0389\u00bd\3\2\2\2\u038a"+
		"\u038c\5\u00c4b\2\u038b\u038a\3\2\2\2\u038c\u038d\3\2\2\2\u038d\u038b"+
		"\3\2\2\2\u038d\u038e\3\2\2\2\u038e\u00bf\3\2\2\2\u038f\u0395\7&\2\2\u0390"+
		"\u0391\7\62\2\2\u0391\u0395\7z\2\2\u0392\u0393\7\62\2\2\u0393\u0395\7"+
		"Z\2\2\u0394\u038f\3\2\2\2\u0394\u0390\3\2\2\2\u0394\u0392\3\2\2\2\u0395"+
		"\u0397\3\2\2\2\u0396\u0398\5\u00c6c\2\u0397\u0396\3\2\2\2\u0398\u0399"+
		"\3\2\2\2\u0399\u0397\3\2\2\2\u0399\u039a\3\2\2\2\u039a\u00c1\3\2\2\2\u039b"+
		"\u039c\t\13\2\2\u039c\u00c3\3\2\2\2\u039d\u039e\t\f\2\2\u039e\u00c5\3"+
		"\2\2\2\u039f\u03a0\t\r\2\2\u03a0\u00c7\3\2\2\2\u03a1\u03a5\5\u00cae\2"+
		"\u03a2\u03a4\5\u00ccf\2\u03a3\u03a2\3\2\2\2\u03a4\u03a7\3\2\2\2\u03a5"+
		"\u03a3\3\2\2\2\u03a5\u03a6\3\2\2\2\u03a6\u03a8\3\2\2\2\u03a7\u03a5\3\2"+
		"\2\2\u03a8\u03a9\bd\6\2\u03a9\u00c9\3\2\2\2\u03aa\u03ab\t\16\2\2\u03ab"+
		"\u00cb\3\2\2\2\u03ac\u03ad\t\17\2\2\u03ad\u00cd\3\2\2\2\u03ae\u03b0\t"+
		"\20\2\2\u03af\u03ae\3\2\2\2\u03b0\u03b1\3\2\2\2\u03b1\u03af\3\2\2\2\u03b1"+
		"\u03b2\3\2\2\2\u03b2\u03b3\3\2\2\2\u03b3\u03b4\bg\7\2\u03b4\u00cf\3\2"+
		"\2\2\u03b5\u03b6\7\61\2\2\u03b6\u03b7\7\61\2\2\u03b7\u03bb\3\2\2\2\u03b8"+
		"\u03ba\n\21\2\2\u03b9\u03b8\3\2\2\2\u03ba\u03bd\3\2\2\2\u03bb\u03b9\3"+
		"\2\2\2\u03bb\u03bc\3\2\2\2\u03bc\u03be\3\2\2\2\u03bd\u03bb\3\2\2\2\u03be"+
		"\u03bf\bh\b\2\u03bf\u00d1\3\2\2\2\u03c0\u03c1\7\61\2\2\u03c1\u03c2\7,"+
		"\2\2\u03c2\u03c6\3\2\2\2\u03c3\u03c5\13\2\2\2\u03c4\u03c3\3\2\2\2\u03c5"+
		"\u03c8\3\2\2\2\u03c6\u03c7\3\2\2\2\u03c6\u03c4\3\2\2\2\u03c7\u03c9\3\2"+
		"\2\2\u03c8\u03c6\3\2\2\2\u03c9\u03ca\7,\2\2\u03ca\u03cb\7\61\2\2\u03cb"+
		"\u03cc\3\2\2\2\u03cc\u03cd\bi\b\2\u03cd\u00d3\3\2\2\2\u03ce\u03cf\7\60"+
		"\2\2\u03cf\u03d0\7d\2\2\u03d0\u03d1\7{\2\2\u03d1\u03d2\7v\2\2\u03d2\u03d3"+
		"\7g\2\2\u03d3\u00d5\3\2\2\2\u03d4\u03d5\7d\2\2\u03d5\u03d6\7t\2\2\u03d6"+
		"\u04b3\7m\2\2\u03d7\u03d8\7q\2\2\u03d8\u03d9\7t\2\2\u03d9\u04b3\7c\2\2"+
		"\u03da\u03db\7m\2\2\u03db\u03dc\7k\2\2\u03dc\u04b3\7n\2\2\u03dd\u03de"+
		"\7u\2\2\u03de\u03df\7n\2\2\u03df\u04b3\7q\2\2\u03e0\u03e1\7p\2\2\u03e1"+
		"\u03e2\7q\2\2\u03e2\u04b3\7r\2\2\u03e3\u03e4\7c\2\2\u03e4\u03e5\7u\2\2"+
		"\u03e5\u04b3\7n\2\2\u03e6\u03e7\7r\2\2\u03e7\u03e8\7j\2\2\u03e8\u04b3"+
		"\7r\2\2\u03e9\u03ea\7c\2\2\u03ea\u03eb\7p\2\2\u03eb\u04b3\7e\2\2\u03ec"+
		"\u03ed\7d\2\2\u03ed\u03ee\7r\2\2\u03ee\u04b3\7n\2\2\u03ef\u03f0\7e\2\2"+
		"\u03f0\u03f1\7n\2\2\u03f1\u04b3\7e\2\2\u03f2\u03f3\7l\2\2\u03f3\u03f4"+
		"\7u\2\2\u03f4\u04b3\7t\2\2\u03f5\u03f6\7c\2\2\u03f6\u03f7\7p\2\2\u03f7"+
		"\u04b3\7f\2\2\u03f8\u03f9\7t\2\2\u03f9\u03fa\7n\2\2\u03fa\u04b3\7c\2\2"+
		"\u03fb\u03fc\7d\2\2\u03fc\u03fd\7k\2\2\u03fd\u04b3\7v\2\2\u03fe\u03ff"+
		"\7t\2\2\u03ff\u0400\7q\2\2\u0400\u04b3\7n\2\2\u0401\u0402\7r\2\2\u0402"+
		"\u0403\7n\2\2\u0403\u04b3\7c\2\2\u0404\u0405\7r\2\2\u0405\u0406\7n\2\2"+
		"\u0406\u04b3\7r\2\2\u0407\u0408\7d\2\2\u0408\u0409\7o\2\2\u0409\u04b3"+
		"\7k\2\2\u040a\u040b\7u\2\2\u040b\u040c\7g\2\2\u040c\u04b3\7e\2\2\u040d"+
		"\u040e\7t\2\2\u040e\u040f\7v\2\2\u040f\u04b3\7k\2\2\u0410\u0411\7g\2\2"+
		"\u0411\u0412\7q\2\2\u0412\u04b3\7t\2\2\u0413\u0414\7u\2\2\u0414\u0415"+
		"\7t\2\2\u0415\u04b3\7g\2\2\u0416\u0417\7n\2\2\u0417\u0418\7u\2\2\u0418"+
		"\u04b3\7t\2\2\u0419\u041a\7r\2\2\u041a\u041b\7j\2\2\u041b\u04b3\7c\2\2"+
		"\u041c\u041d\7c\2\2\u041d\u041e\7n\2\2\u041e\u04b3\7t\2\2\u041f\u0420"+
		"\7l\2\2\u0420\u0421\7o\2\2\u0421\u04b3\7r\2\2\u0422\u0423\7d\2\2\u0423"+
		"\u0424\7x\2\2\u0424\u04b3\7e\2\2\u0425\u0426\7e\2\2\u0426\u0427\7n\2\2"+
		"\u0427\u04b3\7k\2\2\u0428\u0429\7t\2\2\u0429\u042a\7v\2\2\u042a\u04b3"+
		"\7u\2\2\u042b\u042c\7c\2\2\u042c\u042d\7f\2\2\u042d\u04b3\7e\2\2\u042e"+
		"\u042f\7t\2\2\u042f\u0430\7t\2\2\u0430\u04b3\7c\2\2\u0431\u0432\7d\2\2"+
		"\u0432\u0433\7x\2\2\u0433\u04b3\7u\2\2\u0434\u0435\7u\2\2\u0435\u0436"+
		"\7g\2\2\u0436\u04b3\7k\2\2\u0437\u0438\7u\2\2\u0438\u0439\7c\2\2\u0439"+
		"\u04b3\7z\2\2\u043a\u043b\7u\2\2\u043b\u043c\7v\2\2\u043c\u04b3\7{\2\2"+
		"\u043d\u043e\7u\2\2\u043e\u043f\7v\2\2\u043f\u04b3\7c\2\2\u0440\u0441"+
		"\7u\2\2\u0441\u0442\7v\2\2\u0442\u04b3\7z\2\2\u0443\u0444\7f\2\2\u0444"+
		"\u0445\7g\2\2\u0445\u04b3\7{\2\2\u0446\u0447\7v\2\2\u0447\u0448\7z\2\2"+
		"\u0448\u04b3\7c\2\2\u0449\u044a\7z\2\2\u044a\u044b\7c\2\2\u044b\u04b3"+
		"\7c\2\2\u044c\u044d\7d\2\2\u044d\u044e\7e\2\2\u044e\u04b3\7e\2\2\u044f"+
		"\u0450\7c\2\2\u0450\u0451\7j\2\2\u0451\u04b3\7z\2\2\u0452\u0453\7v\2\2"+
		"\u0453\u0454\7{\2\2\u0454\u04b3\7c\2\2\u0455\u0456\7v\2\2\u0456\u0457"+
		"\7z\2\2\u0457\u04b3\7u\2\2\u0458\u0459\7v\2\2\u0459\u045a\7c\2\2\u045a"+
		"\u04b3\7u\2\2\u045b\u045c\7u\2\2\u045c\u045d\7j\2\2\u045d\u04b3\7{\2\2"+
		"\u045e\u045f\7u\2\2\u045f\u0460\7j\2\2\u0460\u04b3\7z\2\2\u0461\u0462"+
		"\7n\2\2\u0462\u0463\7f\2\2\u0463\u04b3\7{\2\2\u0464\u0465\7n\2\2\u0465"+
		"\u0466\7f\2\2\u0466\u04b3\7c\2\2\u0467\u0468\7n\2\2\u0468\u0469\7f\2\2"+
		"\u0469\u04b3\7z\2\2\u046a\u046b\7n\2\2\u046b\u046c\7c\2\2\u046c\u04b3"+
		"\7z\2\2\u046d\u046e\7v\2\2\u046e\u046f\7c\2\2\u046f\u04b3\7{\2\2\u0470"+
		"\u0471\7v\2\2\u0471\u0472\7c\2\2\u0472\u04b3\7z\2\2\u0473\u0474\7d\2\2"+
		"\u0474\u0475\7e\2\2\u0475\u04b3\7u\2\2\u0476\u0477\7e\2\2\u0477\u0478"+
		"\7n\2\2\u0478\u04b3\7x\2\2\u0479\u047a\7v\2\2\u047a\u047b\7u\2\2\u047b"+
		"\u04b3\7z\2\2\u047c\u047d\7n\2\2\u047d\u047e\7c\2\2\u047e\u04b3\7u\2\2"+
		"\u047f\u0480\7e\2\2\u0480\u0481\7r\2\2\u0481\u04b3\7{\2\2\u0482\u0483"+
		"\7e\2\2\u0483\u0484\7o\2\2\u0484\u04b3\7r\2\2\u0485\u0486\7e\2\2\u0486"+
		"\u0487\7r\2\2\u0487\u04b3\7z\2\2\u0488\u0489\7f\2\2\u0489\u048a\7e\2\2"+
		"\u048a\u04b3\7r\2\2\u048b\u048c\7f\2\2\u048c\u048d\7g\2\2\u048d\u04b3"+
		"\7e\2\2\u048e\u048f\7k\2\2\u048f\u0490\7p\2\2\u0490\u04b3\7e\2\2\u0491"+
		"\u0492\7c\2\2\u0492\u0493\7z\2\2\u0493\u04b3\7u\2\2\u0494\u0495\7d\2\2"+
		"\u0495\u0496\7p\2\2\u0496\u04b3\7g\2\2\u0497\u0498\7e\2\2\u0498\u0499"+
		"\7n\2\2\u0499\u04b3\7f\2\2\u049a\u049b\7u\2\2\u049b\u049c\7d\2\2\u049c"+
		"\u04b3\7e\2\2\u049d\u049e\7k\2\2\u049e\u049f\7u\2\2\u049f\u04b3\7e\2\2"+
		"\u04a0\u04a1\7k\2\2\u04a1\u04a2\7p\2\2\u04a2\u04b3\7z\2\2\u04a3\u04a4"+
		"\7d\2\2\u04a4\u04a5\7g\2\2\u04a5\u04b3\7s\2\2\u04a6\u04a7\7u\2\2\u04a7"+
		"\u04a8\7g\2\2\u04a8\u04b3\7f\2\2\u04a9\u04aa\7f\2\2\u04aa\u04ab\7g\2\2"+
		"\u04ab\u04b3\7z\2\2\u04ac\u04ad\7k\2\2\u04ad\u04ae\7p\2\2\u04ae\u04b3"+
		"\7{\2\2\u04af\u04b0\7t\2\2\u04b0\u04b1\7q\2\2\u04b1\u04b3\7t\2\2\u04b2"+
		"\u03d4\3\2\2\2\u04b2\u03d7\3\2\2\2\u04b2\u03da\3\2\2\2\u04b2\u03dd\3\2"+
		"\2\2\u04b2\u03e0\3\2\2\2\u04b2\u03e3\3\2\2\2\u04b2\u03e6\3\2\2\2\u04b2"+
		"\u03e9\3\2\2\2\u04b2\u03ec\3\2\2\2\u04b2\u03ef\3\2\2\2\u04b2\u03f2\3\2"+
		"\2\2\u04b2\u03f5\3\2\2\2\u04b2\u03f8\3\2\2\2\u04b2\u03fb\3\2\2\2\u04b2"+
		"\u03fe\3\2\2\2\u04b2\u0401\3\2\2\2\u04b2\u0404\3\2\2\2\u04b2\u0407\3\2"+
		"\2\2\u04b2\u040a\3\2\2\2\u04b2\u040d\3\2\2\2\u04b2\u0410\3\2\2\2\u04b2"+
		"\u0413\3\2\2\2\u04b2\u0416\3\2\2\2\u04b2\u0419\3\2\2\2\u04b2\u041c\3\2"+
		"\2\2\u04b2\u041f\3\2\2\2\u04b2\u0422\3\2\2\2\u04b2\u0425\3\2\2\2\u04b2"+
		"\u0428\3\2\2\2\u04b2\u042b\3\2\2\2\u04b2\u042e\3\2\2\2\u04b2\u0431\3\2"+
		"\2\2\u04b2\u0434\3\2\2\2\u04b2\u0437\3\2\2\2\u04b2\u043a\3\2\2\2\u04b2"+
		"\u043d\3\2\2\2\u04b2\u0440\3\2\2\2\u04b2\u0443\3\2\2\2\u04b2\u0446\3\2"+
		"\2\2\u04b2\u0449\3\2\2\2\u04b2\u044c\3\2\2\2\u04b2\u044f\3\2\2\2\u04b2"+
		"\u0452\3\2\2\2\u04b2\u0455\3\2\2\2\u04b2\u0458\3\2\2\2\u04b2\u045b\3\2"+
		"\2\2\u04b2\u045e\3\2\2\2\u04b2\u0461\3\2\2\2\u04b2\u0464\3\2\2\2\u04b2"+
		"\u0467\3\2\2\2\u04b2\u046a\3\2\2\2\u04b2\u046d\3\2\2\2\u04b2\u0470\3\2"+
		"\2\2\u04b2\u0473\3\2\2\2\u04b2\u0476\3\2\2\2\u04b2\u0479\3\2\2\2\u04b2"+
		"\u047c\3\2\2\2\u04b2\u047f\3\2\2\2\u04b2\u0482\3\2\2\2\u04b2\u0485\3\2"+
		"\2\2\u04b2\u0488\3\2\2\2\u04b2\u048b\3\2\2\2\u04b2\u048e\3\2\2\2\u04b2"+
		"\u0491\3\2\2\2\u04b2\u0494\3\2\2\2\u04b2\u0497\3\2\2\2\u04b2\u049a\3\2"+
		"\2\2\u04b2\u049d\3\2\2\2\u04b2\u04a0\3\2\2\2\u04b2\u04a3\3\2\2\2\u04b2"+
		"\u04a6\3\2\2\2\u04b2\u04a9\3\2\2\2\u04b2\u04ac\3\2\2\2\u04b2\u04af\3\2"+
		"\2\2\u04b3\u00d7\3\2\2\2\u04b4\u04b5\7%\2\2\u04b5\u00d9\3\2\2\2\u04b6"+
		"\u04b7\7<\2\2\u04b7\u00db\3\2\2\2\u04b8\u04b9\7.\2\2\u04b9\u00dd\3\2\2"+
		"\2\u04ba\u04bb\7*\2\2\u04bb\u00df\3\2\2\2\u04bc\u04bd\7+\2\2\u04bd\u00e1"+
		"\3\2\2\2\u04be\u04bf\7]\2\2\u04bf\u00e3\3\2\2\2\u04c0\u04c1\7_\2\2\u04c1"+
		"\u00e5\3\2\2\2\u04c2\u04c3\7\60\2\2\u04c3\u00e7\3\2\2\2\u04c4\u04c5\7"+
		">\2\2\u04c5\u04c6\7>\2\2\u04c6\u00e9\3\2\2\2\u04c7\u04c8\7@\2\2\u04c8"+
		"\u04c9\7@\2\2\u04c9\u00eb\3\2\2\2\u04ca\u04cb\7-\2\2\u04cb\u00ed\3\2\2"+
		"\2\u04cc\u04cd\7/\2\2\u04cd\u00ef\3\2\2\2\u04ce\u04cf\7>\2\2\u04cf\u00f1"+
		"\3\2\2\2\u04d0\u04d1\7@\2\2\u04d1\u00f3\3\2\2\2\u04d2\u04d3\7,\2\2\u04d3"+
		"\u00f5\3\2\2\2\u04d4\u04d5\7\61\2\2\u04d5\u00f7\3\2\2\2\u04d6\u04d7\7"+
		"}\2\2\u04d7\u04d8\b|\t\2\u04d8\u00f9\3\2\2\2\u04d9\u04da\7\177\2\2\u04da"+
		"\u04db\b}\n\2\u04db\u00fb\3\2\2\2\u04dc\u04df\5\u00fe\177\2\u04dd\u04df"+
		"\5\u0106\u0083\2\u04de\u04dc\3\2\2\2\u04de\u04dd\3\2\2\2\u04df\u00fd\3"+
		"\2\2\2\u04e0\u04e4\5\u0100\u0080\2\u04e1\u04e4\5\u0102\u0081\2\u04e2\u04e4"+
		"\5\u0104\u0082\2\u04e3\u04e0\3\2\2\2\u04e3\u04e1\3\2\2\2\u04e3\u04e2\3"+
		"\2\2\2\u04e4\u00ff\3\2\2\2\u04e5\u04e9\7\'\2\2\u04e6\u04e8\5\u010e\u0087"+
		"\2\u04e7\u04e6\3\2\2\2\u04e8\u04eb\3\2\2\2\u04e9\u04e7\3\2\2\2\u04e9\u04ea"+
		"\3\2\2\2\u04ea\u04ec\3\2\2\2\u04eb\u04e9\3\2\2\2\u04ec\u04ee\7\60\2\2"+
		"\u04ed\u04ef\5\u010e\u0087\2\u04ee\u04ed\3\2\2\2\u04ef\u04f0\3\2\2\2\u04f0"+
		"\u04ee\3\2\2\2\u04f0\u04f1\3\2\2\2\u04f1\u0101\3\2\2\2\u04f2\u04f4\5\u0110"+
		"\u0088\2\u04f3\u04f2\3\2\2\2\u04f4\u04f7\3\2\2\2\u04f5\u04f3\3\2\2\2\u04f5"+
		"\u04f6\3\2\2\2\u04f6\u04f8\3\2\2\2\u04f7\u04f5\3\2\2\2\u04f8\u04fa\7\60"+
		"\2\2\u04f9\u04fb\5\u0110\u0088\2\u04fa\u04f9\3\2\2\2\u04fb\u04fc\3\2\2"+
		"\2\u04fc\u04fa\3\2\2\2\u04fc\u04fd\3\2\2\2\u04fd\u0103\3\2\2\2\u04fe\u0502"+
		"\7&\2\2\u04ff\u0501\5\u0112\u0089\2\u0500\u04ff\3\2\2\2\u0501\u0504\3"+
		"\2\2\2\u0502\u0500\3\2\2\2\u0502\u0503\3\2\2\2\u0503\u0505\3\2\2\2\u0504"+
		"\u0502\3\2\2\2\u0505\u0507\7\60\2\2\u0506\u0508\5\u0112\u0089\2\u0507"+
		"\u0506\3\2\2\2\u0508\u0509\3\2\2\2\u0509\u0507\3\2\2\2\u0509\u050a\3\2"+
		"\2\2\u050a\u0105\3\2\2\2\u050b\u050f\5\u010a\u0085\2\u050c\u050f\5\u010c"+
		"\u0086\2\u050d\u050f\5\u0108\u0084\2\u050e\u050b\3\2\2\2\u050e\u050c\3"+
		"\2\2\2\u050e\u050d\3\2\2\2\u050f\u0107\3\2\2\2\u0510\u0512\7\'\2\2\u0511"+
		"\u0513\5\u010e\u0087\2\u0512\u0511\3\2\2\2\u0513\u0514\3\2\2\2\u0514\u0512"+
		"\3\2\2\2\u0514\u0515\3\2\2\2\u0515\u0109\3\2\2\2\u0516\u0518\5\u0110\u0088"+
		"\2\u0517\u0516\3\2\2\2\u0518\u0519\3\2\2\2\u0519\u0517\3\2\2\2\u0519\u051a"+
		"\3\2\2\2\u051a\u010b\3\2\2\2\u051b\u051d\7&\2\2\u051c\u051e\5\u0112\u0089"+
		"\2\u051d\u051c\3\2\2\2\u051e\u051f\3\2\2\2\u051f\u051d\3\2\2\2\u051f\u0520"+
		"\3\2\2\2\u0520\u010d\3\2\2\2\u0521\u0522\t\13\2\2\u0522\u010f\3\2\2\2"+
		"\u0523\u0524\t\f\2\2\u0524\u0111\3\2\2\2\u0525\u0526\t\r\2\2\u0526\u0113"+
		"\3\2\2\2\u0527\u052b\7)\2\2\u0528\u0529\7^\2\2\u0529\u052c\t\6\2\2\u052a"+
		"\u052c\n\7\2\2\u052b\u0528\3\2\2\2\u052b\u052a\3\2\2\2\u052c\u052d\3\2"+
		"\2\2\u052d\u052e\7)\2\2\u052e\u0115\3\2\2\2\u052f\u0531\5\u0118\u008c"+
		"\2\u0530\u0532\t\22\2\2\u0531\u0530\3\2\2\2\u0532\u0533\3\2\2\2\u0533"+
		"\u0531\3\2\2\2\u0533\u0534\3\2\2\2\u0534\u0117\3\2\2\2\u0535\u0539\7#"+
		"\2\2\u0536\u0538\5\u011e\u008f\2\u0537\u0536\3\2\2\2\u0538\u053b\3\2\2"+
		"\2\u0539\u0537\3\2\2\2\u0539\u053a\3\2\2\2\u053a\u0119\3\2\2\2\u053b\u0539"+
		"\3\2\2\2\u053c\u0540\5\u011c\u008e\2\u053d\u053f\5\u011e\u008f\2\u053e"+
		"\u053d\3\2\2\2\u053f\u0542\3\2\2\2\u0540\u053e\3\2\2\2\u0540\u0541\3\2"+
		"\2\2\u0541\u011b\3\2\2\2\u0542\u0540\3\2\2\2\u0543\u0544\t\16\2\2\u0544"+
		"\u011d\3\2\2\2\u0545\u0546\t\17\2\2\u0546\u011f\3\2\2\2\u0547\u0549\t"+
		"\20\2\2\u0548\u0547\3\2\2\2\u0549\u054a\3\2\2\2\u054a\u0548\3\2\2\2\u054a"+
		"\u054b\3\2\2\2\u054b\u054c\3\2\2\2\u054c\u054d\b\u0090\7\2\u054d\u0121"+
		"\3\2\2\2\u054e\u054f\7\61\2\2\u054f\u0550\7\61\2\2\u0550\u0554\3\2\2\2"+
		"\u0551\u0553\n\21\2\2\u0552\u0551\3\2\2\2\u0553\u0556\3\2\2\2\u0554\u0552"+
		"\3\2\2\2\u0554\u0555\3\2\2\2\u0555\u0557\3\2\2\2\u0556\u0554\3\2\2\2\u0557"+
		"\u0558\b\u0091\b\2\u0558\u0123\3\2\2\2\u0559\u055a\7\61\2\2\u055a\u055b"+
		"\7,\2\2\u055b\u055f\3\2\2\2\u055c\u055e\13\2\2\2\u055d\u055c\3\2\2\2\u055e"+
		"\u0561\3\2\2\2\u055f\u0560\3\2\2\2\u055f\u055d\3\2\2\2\u0560\u0562\3\2"+
		"\2\2\u0561\u055f\3\2\2\2\u0562\u0563\7,\2\2\u0563\u0564\7\61\2\2\u0564"+
		"\u0565\3\2\2\2\u0565\u0566\b\u0092\b\2\u0566\u0125\3\2\2\2;\2\3\u018f"+
		"\u0239\u02d6\u02fd\u0308\u0310\u031a\u031c\u0321\u0325\u0327\u032a\u0332"+
		"\u0338\u033d\u0344\u0349\u0350\u0355\u035c\u0363\u0368\u036f\u0374\u0379"+
		"\u0380\u0386\u0388\u038d\u0394\u0399\u03a5\u03b1\u03bb\u03c6\u04b2\u04de"+
		"\u04e3\u04e9\u04f0\u04f5\u04fc\u0502\u0509\u050e\u0514\u0519\u051f\u052b"+
		"\u0533\u0539\u0540\u054a\u0554\u055f\13\3\2\2\3&\3\3D\4\3V\5\3d\6\2\3"+
		"\2\2\4\2\3|\7\3}\b";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}
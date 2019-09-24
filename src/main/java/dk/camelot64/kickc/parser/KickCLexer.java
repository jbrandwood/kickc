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
		EXTERN=50, EXPORT=51, ALIGN=52, REGISTER=53, MEMORY=54, INLINE=55, VOLATILE=56, 
		INTERRUPT=57, CALLING=58, CALLINGCONVENTION=59, IF=60, ELSE=61, WHILE=62, 
		DO=63, FOR=64, SWITCH=65, RETURN=66, BREAK=67, CONTINUE=68, ASM=69, DEFAULT=70, 
		CASE=71, STRUCT=72, ENUM=73, SIZEOF=74, TYPEID=75, KICKASM=76, RESOURCE=77, 
		USES=78, CLOBBERS=79, BYTES=80, CYCLES=81, LOGIC_NOT=82, SIGNEDNESS=83, 
		SIMPLETYPE=84, BOOLEAN=85, KICKASM_BODY=86, STRING=87, CHAR=88, NUMBER=89, 
		NUMFLOAT=90, BINFLOAT=91, DECFLOAT=92, HEXFLOAT=93, NUMINT=94, BININTEGER=95, 
		DECINTEGER=96, HEXINTEGER=97, NAME=98, WS=99, COMMENT_LINE=100, COMMENT_BLOCK=101, 
		ASM_BYTE=102, ASM_MNEMONIC=103, ASM_IMM=104, ASM_COLON=105, ASM_COMMA=106, 
		ASM_PAR_BEGIN=107, ASM_PAR_END=108, ASM_BRACKET_BEGIN=109, ASM_BRACKET_END=110, 
		ASM_DOT=111, ASM_SHIFT_LEFT=112, ASM_SHIFT_RIGHT=113, ASM_PLUS=114, ASM_MINUS=115, 
		ASM_LESS_THAN=116, ASM_GREATER_THAN=117, ASM_MULTIPLY=118, ASM_DIVIDE=119, 
		ASM_CURLY_BEGIN=120, ASM_CURLY_END=121, ASM_NUMBER=122, ASM_NUMFLOAT=123, 
		ASM_BINFLOAT=124, ASM_DECFLOAT=125, ASM_HEXFLOAT=126, ASM_NUMINT=127, 
		ASM_BININTEGER=128, ASM_DECINTEGER=129, ASM_HEXINTEGER=130, ASM_CHAR=131, 
		ASM_MULTI_REL=132, ASM_MULTI_NAME=133, ASM_NAME=134, ASM_WS=135, ASM_COMMENT_LINE=136, 
		ASM_COMMENT_BLOCK=137;
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
		"ENCODING", "CONST", "EXTERN", "EXPORT", "ALIGN", "REGISTER", "MEMORY", 
		"INLINE", "VOLATILE", "INTERRUPT", "CALLING", "CALLINGCONVENTION", "IF", 
		"ELSE", "WHILE", "DO", "FOR", "SWITCH", "RETURN", "BREAK", "CONTINUE", 
		"ASM", "DEFAULT", "CASE", "STRUCT", "ENUM", "SIZEOF", "TYPEID", "KICKASM", 
		"RESOURCE", "USES", "CLOBBERS", "BYTES", "CYCLES", "LOGIC_NOT", "SIGNEDNESS", 
		"SIMPLETYPE", "BOOLEAN", "KICKASM_BODY", "STRING", "CHAR", "NUMBER", "NUMFLOAT", 
		"BINFLOAT", "DECFLOAT", "HEXFLOAT", "NUMINT", "BININTEGER", "DECINTEGER", 
		"HEXINTEGER", "BINDIGIT", "DECDIGIT", "HEXDIGIT", "NAME", "NAME_START", 
		"NAME_CHAR", "WS", "COMMENT_LINE", "COMMENT_BLOCK", "ASM_BYTE", "ASM_MNEMONIC", 
		"ASM_IMM", "ASM_COLON", "ASM_COMMA", "ASM_PAR_BEGIN", "ASM_PAR_END", "ASM_BRACKET_BEGIN", 
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
		"'memory'", "'inline'", "'volatile'", "'interrupt'", "'calling'", null, 
		"'if'", "'else'", "'while'", "'do'", "'for'", "'switch'", "'return'", 
		"'break'", "'continue'", "'asm'", "'default'", "'case'", "'struct'", "'enum'", 
		"'sizeof'", "'typeid'", "'kickasm'", "'resource'", "'uses'", "'clobbers'", 
		"'bytes'", "'cycles'", "'!'", null, null, null, null, null, null, null, 
		null, null, null, null, null, null, null, null, null, null, null, null, 
		"'.byte'", null, "'#'"
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
		"REGISTER", "MEMORY", "INLINE", "VOLATILE", "INTERRUPT", "CALLING", "CALLINGCONVENTION", 
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
		case 67:
			ASM_action((RuleContext)_localctx, actionIndex);
			break;
		case 85:
			STRING_action((RuleContext)_localctx, actionIndex);
			break;
		case 99:
			NAME_action((RuleContext)_localctx, actionIndex);
			break;
		case 123:
			ASM_CURLY_BEGIN_action((RuleContext)_localctx, actionIndex);
			break;
		case 124:
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
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\2\u008b\u0570\b\1\b"+
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
		"\t\u0092\4\u0093\t\u0093\3\2\3\2\3\2\3\3\3\3\3\4\3\4\3\5\3\5\3\6\3\6\3"+
		"\7\3\7\3\b\3\b\3\t\3\t\3\n\3\n\3\13\3\13\3\13\3\f\3\f\3\r\3\r\3\16\3\16"+
		"\3\16\3\17\3\17\3\20\3\20\3\21\3\21\3\22\3\22\3\23\3\23\3\24\3\24\3\24"+
		"\3\25\3\25\3\25\3\26\3\26\3\27\3\27\3\30\3\30\3\31\3\31\3\32\3\32\3\32"+
		"\3\33\3\33\3\33\3\34\3\34\3\34\3\35\3\35\3\35\3\36\3\36\3\37\3\37\3\37"+
		"\3 \3 \3 \3!\3!\3\"\3\"\3\"\3#\3#\3#\3$\3$\3%\3%\3%\3%\3%\3%\3%\3%\3%"+
		"\3%\3%\3%\3%\3%\3%\3%\3%\3%\3%\3%\3%\3%\5%\u0192\n%\3&\3&\3&\3&\3&\3&"+
		"\3&\3&\3&\3\'\3\'\3\'\3\'\3\'\3\'\3\'\3\'\3(\3(\3(\3(\3(\3(\3(\3(\3)\3"+
		")\3)\3)\3)\3)\3)\3)\3*\3*\3*\3+\3+\3+\3+\3+\3+\3+\3,\3,\3,\3,\3,\3-\3"+
		"-\3-\3-\3.\3.\3.\3.\3.\3.\3.\3.\3.\3/\3/\3/\3/\3/\3/\3/\3/\3/\3\60\3\60"+
		"\3\60\3\60\3\60\3\60\3\60\3\60\3\60\3\61\3\61\3\61\3\61\3\61\3\61\3\62"+
		"\3\62\3\62\3\62\3\62\3\62\3\62\3\63\3\63\3\63\3\63\3\63\3\63\3\63\3\64"+
		"\3\64\3\64\3\64\3\64\3\64\3\65\3\65\3\65\3\65\3\65\3\65\3\65\3\65\3\65"+
		"\3\66\3\66\3\66\3\66\3\66\3\66\3\66\3\67\3\67\3\67\3\67\3\67\3\67\3\67"+
		"\38\38\38\38\38\38\38\38\38\39\39\39\39\39\39\39\39\39\39\3:\3:\3:\3:"+
		"\3:\3:\3:\3:\3;\3;\3;\3;\3;\3;\3;\3;\3;\3;\3;\3;\3;\3;\3;\3;\3;\3;\3;"+
		"\3;\5;\u0243\n;\3<\3<\3<\3=\3=\3=\3=\3=\3>\3>\3>\3>\3>\3>\3?\3?\3?\3@"+
		"\3@\3@\3@\3A\3A\3A\3A\3A\3A\3A\3B\3B\3B\3B\3B\3B\3B\3C\3C\3C\3C\3C\3C"+
		"\3D\3D\3D\3D\3D\3D\3D\3D\3D\3E\3E\3E\3E\3E\3E\3F\3F\3F\3F\3F\3F\3F\3F"+
		"\3G\3G\3G\3G\3G\3H\3H\3H\3H\3H\3H\3H\3I\3I\3I\3I\3I\3J\3J\3J\3J\3J\3J"+
		"\3J\3K\3K\3K\3K\3K\3K\3K\3L\3L\3L\3L\3L\3L\3L\3L\3M\3M\3M\3M\3M\3M\3M"+
		"\3M\3M\3N\3N\3N\3N\3N\3O\3O\3O\3O\3O\3O\3O\3O\3O\3P\3P\3P\3P\3P\3P\3Q"+
		"\3Q\3Q\3Q\3Q\3Q\3Q\3R\3R\3S\3S\3S\3S\3S\3S\3S\3S\3S\3S\3S\3S\3S\3S\5S"+
		"\u02e0\nS\3T\3T\3T\3T\3T\3T\3T\3T\3T\3T\3T\3T\3T\3T\3T\3T\3T\3T\3T\3T"+
		"\3T\3T\3T\3T\3T\3T\3T\3T\3T\3T\3T\3T\3T\3T\3T\3T\3T\5T\u0307\nT\3U\3U"+
		"\3U\3U\3U\3U\3U\3U\3U\5U\u0312\nU\3V\3V\3V\3V\7V\u0318\nV\fV\16V\u031b"+
		"\13V\3V\3V\3V\3W\3W\3W\3W\7W\u0324\nW\fW\16W\u0327\13W\3W\3W\5W\u032b"+
		"\nW\3W\3W\5W\u032f\nW\5W\u0331\nW\3W\5W\u0334\nW\3W\3W\3X\3X\3X\3X\5X"+
		"\u033c\nX\3X\3X\3Y\3Y\5Y\u0342\nY\3Z\3Z\3Z\5Z\u0347\nZ\3[\3[\3[\3[\3["+
		"\5[\u034e\n[\3[\7[\u0351\n[\f[\16[\u0354\13[\3[\3[\6[\u0358\n[\r[\16["+
		"\u0359\3\\\7\\\u035d\n\\\f\\\16\\\u0360\13\\\3\\\3\\\6\\\u0364\n\\\r\\"+
		"\16\\\u0365\3]\3]\3]\3]\3]\5]\u036d\n]\3]\7]\u0370\n]\f]\16]\u0373\13"+
		"]\3]\3]\6]\u0377\n]\r]\16]\u0378\3^\3^\3^\5^\u037e\n^\3^\3^\3^\5^\u0383"+
		"\n^\3_\3_\3_\6_\u0388\n_\r_\16_\u0389\3_\3_\6_\u038e\n_\r_\16_\u038f\5"+
		"_\u0392\n_\3`\6`\u0395\n`\r`\16`\u0396\3a\3a\3a\3a\3a\5a\u039e\na\3a\6"+
		"a\u03a1\na\ra\16a\u03a2\3b\3b\3c\3c\3d\3d\3e\3e\7e\u03ad\ne\fe\16e\u03b0"+
		"\13e\3e\3e\3f\3f\3g\3g\3h\6h\u03b9\nh\rh\16h\u03ba\3h\3h\3i\3i\3i\3i\7"+
		"i\u03c3\ni\fi\16i\u03c6\13i\3i\3i\3j\3j\3j\3j\7j\u03ce\nj\fj\16j\u03d1"+
		"\13j\3j\3j\3j\3j\3j\3k\3k\3k\3k\3k\3k\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3"+
		"l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3"+
		"l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3"+
		"l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3"+
		"l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3"+
		"l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3"+
		"l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3"+
		"l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3"+
		"l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3"+
		"l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3l\3"+
		"l\3l\3l\3l\3l\5l\u04bc\nl\3m\3m\3n\3n\3o\3o\3p\3p\3q\3q\3r\3r\3s\3s\3"+
		"t\3t\3u\3u\3u\3v\3v\3v\3w\3w\3x\3x\3y\3y\3z\3z\3{\3{\3|\3|\3}\3}\3}\3"+
		"~\3~\3~\3\177\3\177\5\177\u04e8\n\177\3\u0080\3\u0080\3\u0080\5\u0080"+
		"\u04ed\n\u0080\3\u0081\3\u0081\7\u0081\u04f1\n\u0081\f\u0081\16\u0081"+
		"\u04f4\13\u0081\3\u0081\3\u0081\6\u0081\u04f8\n\u0081\r\u0081\16\u0081"+
		"\u04f9\3\u0082\7\u0082\u04fd\n\u0082\f\u0082\16\u0082\u0500\13\u0082\3"+
		"\u0082\3\u0082\6\u0082\u0504\n\u0082\r\u0082\16\u0082\u0505\3\u0083\3"+
		"\u0083\7\u0083\u050a\n\u0083\f\u0083\16\u0083\u050d\13\u0083\3\u0083\3"+
		"\u0083\6\u0083\u0511\n\u0083\r\u0083\16\u0083\u0512\3\u0084\3\u0084\3"+
		"\u0084\5\u0084\u0518\n\u0084\3\u0085\3\u0085\6\u0085\u051c\n\u0085\r\u0085"+
		"\16\u0085\u051d\3\u0086\6\u0086\u0521\n\u0086\r\u0086\16\u0086\u0522\3"+
		"\u0087\3\u0087\6\u0087\u0527\n\u0087\r\u0087\16\u0087\u0528\3\u0088\3"+
		"\u0088\3\u0089\3\u0089\3\u008a\3\u008a\3\u008b\3\u008b\3\u008b\3\u008b"+
		"\5\u008b\u0535\n\u008b\3\u008b\3\u008b\3\u008c\3\u008c\6\u008c\u053b\n"+
		"\u008c\r\u008c\16\u008c\u053c\3\u008d\3\u008d\7\u008d\u0541\n\u008d\f"+
		"\u008d\16\u008d\u0544\13\u008d\3\u008e\3\u008e\7\u008e\u0548\n\u008e\f"+
		"\u008e\16\u008e\u054b\13\u008e\3\u008f\3\u008f\3\u0090\3\u0090\3\u0091"+
		"\6\u0091\u0552\n\u0091\r\u0091\16\u0091\u0553\3\u0091\3\u0091\3\u0092"+
		"\3\u0092\3\u0092\3\u0092\7\u0092\u055c\n\u0092\f\u0092\16\u0092\u055f"+
		"\13\u0092\3\u0092\3\u0092\3\u0093\3\u0093\3\u0093\3\u0093\7\u0093\u0567"+
		"\n\u0093\f\u0093\16\u0093\u056a\13\u0093\3\u0093\3\u0093\3\u0093\3\u0093"+
		"\3\u0093\5\u0319\u03cf\u0568\2\u0094\4\4\6\5\b\6\n\7\f\b\16\t\20\n\22"+
		"\13\24\f\26\r\30\16\32\17\34\20\36\21 \22\"\23$\24&\25(\26*\27,\30.\31"+
		"\60\32\62\33\64\34\66\358\36:\37< >!@\"B#D$F%H&J\'L(N)P*R+T,V-X.Z/\\\60"+
		"^\61`\62b\63d\64f\65h\66j\67l8n9p:r;t<v=x>z?|@~A\u0080B\u0082C\u0084D"+
		"\u0086E\u0088F\u008aG\u008cH\u008eI\u0090J\u0092K\u0094L\u0096M\u0098"+
		"N\u009aO\u009cP\u009eQ\u00a0R\u00a2S\u00a4T\u00a6U\u00a8V\u00aaW\u00ac"+
		"X\u00aeY\u00b0Z\u00b2[\u00b4\\\u00b6]\u00b8^\u00ba_\u00bc`\u00bea\u00c0"+
		"b\u00c2c\u00c4\2\u00c6\2\u00c8\2\u00cad\u00cc\2\u00ce\2\u00d0e\u00d2f"+
		"\u00d4g\u00d6h\u00d8i\u00daj\u00dck\u00del\u00e0m\u00e2n\u00e4o\u00e6"+
		"p\u00e8q\u00ear\u00ecs\u00eet\u00f0u\u00f2v\u00f4w\u00f6x\u00f8y\u00fa"+
		"z\u00fc{\u00fe|\u0100}\u0102~\u0104\177\u0106\u0080\u0108\u0081\u010a"+
		"\u0082\u010c\u0083\u010e\u0084\u0110\2\u0112\2\u0114\2\u0116\u0085\u0118"+
		"\u0086\u011a\u0087\u011c\u0088\u011e\2\u0120\2\u0122\u0089\u0124\u008a"+
		"\u0126\u008b\4\2\3\23\3\2$$\3\2||\4\2rruu\4\2ooww\7\2$$))hhpptt\3\2))"+
		"\4\2uuww\7\2dfkknnuuyy\4\2DDdd\3\2\62\63\3\2\62;\5\2\62;CHch\5\2C\\aa"+
		"c|\6\2\62;C\\aac|\6\2\13\f\17\17\"\"\u00a2\u00a2\4\2\f\f\17\17\4\2--/"+
		"/\2\u05fa\2\4\3\2\2\2\2\6\3\2\2\2\2\b\3\2\2\2\2\n\3\2\2\2\2\f\3\2\2\2"+
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
		"\3\2\2\2\2\u00bc\3\2\2\2\2\u00be\3\2\2\2\2\u00c0\3\2\2\2\2\u00c2\3\2\2"+
		"\2\2\u00ca\3\2\2\2\2\u00d0\3\2\2\2\2\u00d2\3\2\2\2\2\u00d4\3\2\2\2\3\u00d6"+
		"\3\2\2\2\3\u00d8\3\2\2\2\3\u00da\3\2\2\2\3\u00dc\3\2\2\2\3\u00de\3\2\2"+
		"\2\3\u00e0\3\2\2\2\3\u00e2\3\2\2\2\3\u00e4\3\2\2\2\3\u00e6\3\2\2\2\3\u00e8"+
		"\3\2\2\2\3\u00ea\3\2\2\2\3\u00ec\3\2\2\2\3\u00ee\3\2\2\2\3\u00f0\3\2\2"+
		"\2\3\u00f2\3\2\2\2\3\u00f4\3\2\2\2\3\u00f6\3\2\2\2\3\u00f8\3\2\2\2\3\u00fa"+
		"\3\2\2\2\3\u00fc\3\2\2\2\3\u00fe\3\2\2\2\3\u0100\3\2\2\2\3\u0102\3\2\2"+
		"\2\3\u0104\3\2\2\2\3\u0106\3\2\2\2\3\u0108\3\2\2\2\3\u010a\3\2\2\2\3\u010c"+
		"\3\2\2\2\3\u010e\3\2\2\2\3\u0116\3\2\2\2\3\u0118\3\2\2\2\3\u011a\3\2\2"+
		"\2\3\u011c\3\2\2\2\3\u0122\3\2\2\2\3\u0124\3\2\2\2\3\u0126\3\2\2\2\4\u0128"+
		"\3\2\2\2\6\u012b\3\2\2\2\b\u012d\3\2\2\2\n\u012f\3\2\2\2\f\u0131\3\2\2"+
		"\2\16\u0133\3\2\2\2\20\u0135\3\2\2\2\22\u0137\3\2\2\2\24\u0139\3\2\2\2"+
		"\26\u013b\3\2\2\2\30\u013e\3\2\2\2\32\u0140\3\2\2\2\34\u0142\3\2\2\2\36"+
		"\u0145\3\2\2\2 \u0147\3\2\2\2\"\u0149\3\2\2\2$\u014b\3\2\2\2&\u014d\3"+
		"\2\2\2(\u014f\3\2\2\2*\u0152\3\2\2\2,\u0155\3\2\2\2.\u0157\3\2\2\2\60"+
		"\u0159\3\2\2\2\62\u015b\3\2\2\2\64\u015d\3\2\2\2\66\u0160\3\2\2\28\u0163"+
		"\3\2\2\2:\u0166\3\2\2\2<\u0169\3\2\2\2>\u016b\3\2\2\2@\u016e\3\2\2\2B"+
		"\u0171\3\2\2\2D\u0173\3\2\2\2F\u0176\3\2\2\2H\u0179\3\2\2\2J\u0191\3\2"+
		"\2\2L\u0193\3\2\2\2N\u019c\3\2\2\2P\u01a4\3\2\2\2R\u01ac\3\2\2\2T\u01b4"+
		"\3\2\2\2V\u01b7\3\2\2\2X\u01be\3\2\2\2Z\u01c3\3\2\2\2\\\u01c7\3\2\2\2"+
		"^\u01d0\3\2\2\2`\u01d9\3\2\2\2b\u01e2\3\2\2\2d\u01e8\3\2\2\2f\u01ef\3"+
		"\2\2\2h\u01f6\3\2\2\2j\u01fc\3\2\2\2l\u0205\3\2\2\2n\u020c\3\2\2\2p\u0213"+
		"\3\2\2\2r\u021c\3\2\2\2t\u0226\3\2\2\2v\u0242\3\2\2\2x\u0244\3\2\2\2z"+
		"\u0247\3\2\2\2|\u024c\3\2\2\2~\u0252\3\2\2\2\u0080\u0255\3\2\2\2\u0082"+
		"\u0259\3\2\2\2\u0084\u0260\3\2\2\2\u0086\u0267\3\2\2\2\u0088\u026d\3\2"+
		"\2\2\u008a\u0276\3\2\2\2\u008c\u027c\3\2\2\2\u008e\u0284\3\2\2\2\u0090"+
		"\u0289\3\2\2\2\u0092\u0290\3\2\2\2\u0094\u0295\3\2\2\2\u0096\u029c\3\2"+
		"\2\2\u0098\u02a3\3\2\2\2\u009a\u02ab\3\2\2\2\u009c\u02b4\3\2\2\2\u009e"+
		"\u02b9\3\2\2\2\u00a0\u02c2\3\2\2\2\u00a2\u02c8\3\2\2\2\u00a4\u02cf\3\2"+
		"\2\2\u00a6\u02df\3\2\2\2\u00a8\u0306\3\2\2\2\u00aa\u0311\3\2\2\2\u00ac"+
		"\u0313\3\2\2\2\u00ae\u031f\3\2\2\2\u00b0\u0337\3\2\2\2\u00b2\u0341\3\2"+
		"\2\2\u00b4\u0346\3\2\2\2\u00b6\u034d\3\2\2\2\u00b8\u035e\3\2\2\2\u00ba"+
		"\u036c\3\2\2\2\u00bc\u037d\3\2\2\2\u00be\u0391\3\2\2\2\u00c0\u0394\3\2"+
		"\2\2\u00c2\u039d\3\2\2\2\u00c4\u03a4\3\2\2\2\u00c6\u03a6\3\2\2\2\u00c8"+
		"\u03a8\3\2\2\2\u00ca\u03aa\3\2\2\2\u00cc\u03b3\3\2\2\2\u00ce\u03b5\3\2"+
		"\2\2\u00d0\u03b8\3\2\2\2\u00d2\u03be\3\2\2\2\u00d4\u03c9\3\2\2\2\u00d6"+
		"\u03d7\3\2\2\2\u00d8\u04bb\3\2\2\2\u00da\u04bd\3\2\2\2\u00dc\u04bf\3\2"+
		"\2\2\u00de\u04c1\3\2\2\2\u00e0\u04c3\3\2\2\2\u00e2\u04c5\3\2\2\2\u00e4"+
		"\u04c7\3\2\2\2\u00e6\u04c9\3\2\2\2\u00e8\u04cb\3\2\2\2\u00ea\u04cd\3\2"+
		"\2\2\u00ec\u04d0\3\2\2\2\u00ee\u04d3\3\2\2\2\u00f0\u04d5\3\2\2\2\u00f2"+
		"\u04d7\3\2\2\2\u00f4\u04d9\3\2\2\2\u00f6\u04db\3\2\2\2\u00f8\u04dd\3\2"+
		"\2\2\u00fa\u04df\3\2\2\2\u00fc\u04e2\3\2\2\2\u00fe\u04e7\3\2\2\2\u0100"+
		"\u04ec\3\2\2\2\u0102\u04ee\3\2\2\2\u0104\u04fe\3\2\2\2\u0106\u0507\3\2"+
		"\2\2\u0108\u0517\3\2\2\2\u010a\u0519\3\2\2\2\u010c\u0520\3\2\2\2\u010e"+
		"\u0524\3\2\2\2\u0110\u052a\3\2\2\2\u0112\u052c\3\2\2\2\u0114\u052e\3\2"+
		"\2\2\u0116\u0530\3\2\2\2\u0118\u0538\3\2\2\2\u011a\u053e\3\2\2\2\u011c"+
		"\u0545\3\2\2\2\u011e\u054c\3\2\2\2\u0120\u054e\3\2\2\2\u0122\u0551\3\2"+
		"\2\2\u0124\u0557\3\2\2\2\u0126\u0562\3\2\2\2\u0128\u0129\7}\2\2\u0129"+
		"\u012a\b\2\2\2\u012a\5\3\2\2\2\u012b\u012c\7\177\2\2\u012c\7\3\2\2\2\u012d"+
		"\u012e\7]\2\2\u012e\t\3\2\2\2\u012f\u0130\7_\2\2\u0130\13\3\2\2\2\u0131"+
		"\u0132\7*\2\2\u0132\r\3\2\2\2\u0133\u0134\7+\2\2\u0134\17\3\2\2\2\u0135"+
		"\u0136\7=\2\2\u0136\21\3\2\2\2\u0137\u0138\7<\2\2\u0138\23\3\2\2\2\u0139"+
		"\u013a\7.\2\2\u013a\25\3\2\2\2\u013b\u013c\7\60\2\2\u013c\u013d\7\60\2"+
		"\2\u013d\27\3\2\2\2\u013e\u013f\7A\2\2\u013f\31\3\2\2\2\u0140\u0141\7"+
		"\60\2\2\u0141\33\3\2\2\2\u0142\u0143\7/\2\2\u0143\u0144\7@\2\2\u0144\35"+
		"\3\2\2\2\u0145\u0146\7-\2\2\u0146\37\3\2\2\2\u0147\u0148\7/\2\2\u0148"+
		"!\3\2\2\2\u0149\u014a\7,\2\2\u014a#\3\2\2\2\u014b\u014c\7\61\2\2\u014c"+
		"%\3\2\2\2\u014d\u014e\7\'\2\2\u014e\'\3\2\2\2\u014f\u0150\7-\2\2\u0150"+
		"\u0151\7-\2\2\u0151)\3\2\2\2\u0152\u0153\7/\2\2\u0153\u0154\7/\2\2\u0154"+
		"+\3\2\2\2\u0155\u0156\7(\2\2\u0156-\3\2\2\2\u0157\u0158\7\u0080\2\2\u0158"+
		"/\3\2\2\2\u0159\u015a\7`\2\2\u015a\61\3\2\2\2\u015b\u015c\7~\2\2\u015c"+
		"\63\3\2\2\2\u015d\u015e\7>\2\2\u015e\u015f\7>\2\2\u015f\65\3\2\2\2\u0160"+
		"\u0161\7@\2\2\u0161\u0162\7@\2\2\u0162\67\3\2\2\2\u0163\u0164\7?\2\2\u0164"+
		"\u0165\7?\2\2\u01659\3\2\2\2\u0166\u0167\7#\2\2\u0167\u0168\7?\2\2\u0168"+
		";\3\2\2\2\u0169\u016a\7>\2\2\u016a=\3\2\2\2\u016b\u016c\7>\2\2\u016c\u016d"+
		"\7?\2\2\u016d?\3\2\2\2\u016e\u016f\7@\2\2\u016f\u0170\7?\2\2\u0170A\3"+
		"\2\2\2\u0171\u0172\7@\2\2\u0172C\3\2\2\2\u0173\u0174\7(\2\2\u0174\u0175"+
		"\7(\2\2\u0175E\3\2\2\2\u0176\u0177\7~\2\2\u0177\u0178\7~\2\2\u0178G\3"+
		"\2\2\2\u0179\u017a\7?\2\2\u017aI\3\2\2\2\u017b\u017c\7-\2\2\u017c\u0192"+
		"\7?\2\2\u017d\u017e\7/\2\2\u017e\u0192\7?\2\2\u017f\u0180\7,\2\2\u0180"+
		"\u0192\7?\2\2\u0181\u0182\7\61\2\2\u0182\u0192\7?\2\2\u0183\u0184\7\'"+
		"\2\2\u0184\u0192\7?\2\2\u0185\u0186\7>\2\2\u0186\u0187\7>\2\2\u0187\u0192"+
		"\7?\2\2\u0188\u0189\7@\2\2\u0189\u018a\7@\2\2\u018a\u0192\7?\2\2\u018b"+
		"\u018c\7(\2\2\u018c\u0192\7?\2\2\u018d\u018e\7~\2\2\u018e\u0192\7?\2\2"+
		"\u018f\u0190\7`\2\2\u0190\u0192\7?\2\2\u0191\u017b\3\2\2\2\u0191\u017d"+
		"\3\2\2\2\u0191\u017f\3\2\2\2\u0191\u0181\3\2\2\2\u0191\u0183\3\2\2\2\u0191"+
		"\u0185\3\2\2\2\u0191\u0188\3\2\2\2\u0191\u018b\3\2\2\2\u0191\u018d\3\2"+
		"\2\2\u0191\u018f\3\2\2\2\u0192K\3\2\2\2\u0193\u0194\7k\2\2\u0194\u0195"+
		"\7o\2\2\u0195\u0196\7r\2\2\u0196\u0197\7q\2\2\u0197\u0198\7t\2\2\u0198"+
		"\u0199\7v\2\2\u0199\u019a\3\2\2\2\u019a\u019b\b&\3\2\u019bM\3\2\2\2\u019c"+
		"\u019d\7v\2\2\u019d\u019e\7{\2\2\u019e\u019f\7r\2\2\u019f\u01a0\7g\2\2"+
		"\u01a0\u01a1\7f\2\2\u01a1\u01a2\7g\2\2\u01a2\u01a3\7h\2\2\u01a3O\3\2\2"+
		"\2\u01a4\u01a5\7%\2\2\u01a5\u01a6\7r\2\2\u01a6\u01a7\7t\2\2\u01a7\u01a8"+
		"\7c\2\2\u01a8\u01a9\7i\2\2\u01a9\u01aa\7o\2\2\u01aa\u01ab\7c\2\2\u01ab"+
		"Q\3\2\2\2\u01ac\u01ad\7t\2\2\u01ad\u01ae\7g\2\2\u01ae\u01af\7u\2\2\u01af"+
		"\u01b0\7g\2\2\u01b0\u01b1\7t\2\2\u01b1\u01b2\7x\2\2\u01b2\u01b3\7g\2\2"+
		"\u01b3S\3\2\2\2\u01b4\u01b5\7r\2\2\u01b5\u01b6\7e\2\2\u01b6U\3\2\2\2\u01b7"+
		"\u01b8\7v\2\2\u01b8\u01b9\7c\2\2\u01b9\u01ba\7t\2\2\u01ba\u01bb\7i\2\2"+
		"\u01bb\u01bc\7g\2\2\u01bc\u01bd\7v\2\2\u01bdW\3\2\2\2\u01be\u01bf\7n\2"+
		"\2\u01bf\u01c0\7k\2\2\u01c0\u01c1\7p\2\2\u01c1\u01c2\7m\2\2\u01c2Y\3\2"+
		"\2\2\u01c3\u01c4\7e\2\2\u01c4\u01c5\7r\2\2\u01c5\u01c6\7w\2\2\u01c6[\3"+
		"\2\2\2\u01c7\u01c8\7e\2\2\u01c8\u01c9\7q\2\2\u01c9\u01ca\7f\2\2\u01ca"+
		"\u01cb\7g\2\2\u01cb\u01cc\7a\2\2\u01cc\u01cd\7u\2\2\u01cd\u01ce\7g\2\2"+
		"\u01ce\u01cf\7i\2\2\u01cf]\3\2\2\2\u01d0\u01d1\7f\2\2\u01d1\u01d2\7c\2"+
		"\2\u01d2\u01d3\7v\2\2\u01d3\u01d4\7c\2\2\u01d4\u01d5\7a\2\2\u01d5\u01d6"+
		"\7u\2\2\u01d6\u01d7\7g\2\2\u01d7\u01d8\7i\2\2\u01d8_\3\2\2\2\u01d9\u01da"+
		"\7g\2\2\u01da\u01db\7p\2\2\u01db\u01dc\7e\2\2\u01dc\u01dd\7q\2\2\u01dd"+
		"\u01de\7f\2\2\u01de\u01df\7k\2\2\u01df\u01e0\7p\2\2\u01e0\u01e1\7i\2\2"+
		"\u01e1a\3\2\2\2\u01e2\u01e3\7e\2\2\u01e3\u01e4\7q\2\2\u01e4\u01e5\7p\2"+
		"\2\u01e5\u01e6\7u\2\2\u01e6\u01e7\7v\2\2\u01e7c\3\2\2\2\u01e8\u01e9\7"+
		"g\2\2\u01e9\u01ea\7z\2\2\u01ea\u01eb\7v\2\2\u01eb\u01ec\7g\2\2\u01ec\u01ed"+
		"\7t\2\2\u01ed\u01ee\7p\2\2\u01eee\3\2\2\2\u01ef\u01f0\7g\2\2\u01f0\u01f1"+
		"\7z\2\2\u01f1\u01f2\7r\2\2\u01f2\u01f3\7q\2\2\u01f3\u01f4\7t\2\2\u01f4"+
		"\u01f5\7v\2\2\u01f5g\3\2\2\2\u01f6\u01f7\7c\2\2\u01f7\u01f8\7n\2\2\u01f8"+
		"\u01f9\7k\2\2\u01f9\u01fa\7i\2\2\u01fa\u01fb\7p\2\2\u01fbi\3\2\2\2\u01fc"+
		"\u01fd\7t\2\2\u01fd\u01fe\7g\2\2\u01fe\u01ff\7i\2\2\u01ff\u0200\7k\2\2"+
		"\u0200\u0201\7u\2\2\u0201\u0202\7v\2\2\u0202\u0203\7g\2\2\u0203\u0204"+
		"\7t\2\2\u0204k\3\2\2\2\u0205\u0206\7o\2\2\u0206\u0207\7g\2\2\u0207\u0208"+
		"\7o\2\2\u0208\u0209\7q\2\2\u0209\u020a\7t\2\2\u020a\u020b\7{\2\2\u020b"+
		"m\3\2\2\2\u020c\u020d\7k\2\2\u020d\u020e\7p\2\2\u020e\u020f\7n\2\2\u020f"+
		"\u0210\7k\2\2\u0210\u0211\7p\2\2\u0211\u0212\7g\2\2\u0212o\3\2\2\2\u0213"+
		"\u0214\7x\2\2\u0214\u0215\7q\2\2\u0215\u0216\7n\2\2\u0216\u0217\7c\2\2"+
		"\u0217\u0218\7v\2\2\u0218\u0219\7k\2\2\u0219\u021a\7n\2\2\u021a\u021b"+
		"\7g\2\2\u021bq\3\2\2\2\u021c\u021d\7k\2\2\u021d\u021e\7p\2\2\u021e\u021f"+
		"\7v\2\2\u021f\u0220\7g\2\2\u0220\u0221\7t\2\2\u0221\u0222\7t\2\2\u0222"+
		"\u0223\7w\2\2\u0223\u0224\7r\2\2\u0224\u0225\7v\2\2\u0225s\3\2\2\2\u0226"+
		"\u0227\7e\2\2\u0227\u0228\7c\2\2\u0228\u0229\7n\2\2\u0229\u022a\7n\2\2"+
		"\u022a\u022b\7k\2\2\u022b\u022c\7p\2\2\u022c\u022d\7i\2\2\u022du\3\2\2"+
		"\2\u022e\u022f\7a\2\2\u022f\u0230\7a\2\2\u0230\u0231\7u\2\2\u0231\u0232"+
		"\7v\2\2\u0232\u0233\7c\2\2\u0233\u0234\7e\2\2\u0234\u0235\7m\2\2\u0235"+
		"\u0236\7e\2\2\u0236\u0237\7c\2\2\u0237\u0238\7n\2\2\u0238\u0243\7n\2\2"+
		"\u0239\u023a\7a\2\2\u023a\u023b\7a\2\2\u023b\u023c\7r\2\2\u023c\u023d"+
		"\7j\2\2\u023d\u023e\7k\2\2\u023e\u023f\7e\2\2\u023f\u0240\7c\2\2\u0240"+
		"\u0241\7n\2\2\u0241\u0243\7n\2\2\u0242\u022e\3\2\2\2\u0242\u0239\3\2\2"+
		"\2\u0243w\3\2\2\2\u0244\u0245\7k\2\2\u0245\u0246\7h\2\2\u0246y\3\2\2\2"+
		"\u0247\u0248\7g\2\2\u0248\u0249\7n\2\2\u0249\u024a\7u\2\2\u024a\u024b"+
		"\7g\2\2\u024b{\3\2\2\2\u024c\u024d\7y\2\2\u024d\u024e\7j\2\2\u024e\u024f"+
		"\7k\2\2\u024f\u0250\7n\2\2\u0250\u0251\7g\2\2\u0251}\3\2\2\2\u0252\u0253"+
		"\7f\2\2\u0253\u0254\7q\2\2\u0254\177\3\2\2\2\u0255\u0256\7h\2\2\u0256"+
		"\u0257\7q\2\2\u0257\u0258\7t\2\2\u0258\u0081\3\2\2\2\u0259\u025a\7u\2"+
		"\2\u025a\u025b\7y\2\2\u025b\u025c\7k\2\2\u025c\u025d\7v\2\2\u025d\u025e"+
		"\7e\2\2\u025e\u025f\7j\2\2\u025f\u0083\3\2\2\2\u0260\u0261\7t\2\2\u0261"+
		"\u0262\7g\2\2\u0262\u0263\7v\2\2\u0263\u0264\7w\2\2\u0264\u0265\7t\2\2"+
		"\u0265\u0266\7p\2\2\u0266\u0085\3\2\2\2\u0267\u0268\7d\2\2\u0268\u0269"+
		"\7t\2\2\u0269\u026a\7g\2\2\u026a\u026b\7c\2\2\u026b\u026c\7m\2\2\u026c"+
		"\u0087\3\2\2\2\u026d\u026e\7e\2\2\u026e\u026f\7q\2\2\u026f\u0270\7p\2"+
		"\2\u0270\u0271\7v\2\2\u0271\u0272\7k\2\2\u0272\u0273\7p\2\2\u0273\u0274"+
		"\7w\2\2\u0274\u0275\7g\2\2\u0275\u0089\3\2\2\2\u0276\u0277\7c\2\2\u0277"+
		"\u0278\7u\2\2\u0278\u0279\7o\2\2\u0279\u027a\3\2\2\2\u027a\u027b\bE\4"+
		"\2\u027b\u008b\3\2\2\2\u027c\u027d\7f\2\2\u027d\u027e\7g\2\2\u027e\u027f"+
		"\7h\2\2\u027f\u0280\7c\2\2\u0280\u0281\7w\2\2\u0281\u0282\7n\2\2\u0282"+
		"\u0283\7v\2\2\u0283\u008d\3\2\2\2\u0284\u0285\7e\2\2\u0285\u0286\7c\2"+
		"\2\u0286\u0287\7u\2\2\u0287\u0288\7g\2\2\u0288\u008f\3\2\2\2\u0289\u028a"+
		"\7u\2\2\u028a\u028b\7v\2\2\u028b\u028c\7t\2\2\u028c\u028d\7w\2\2\u028d"+
		"\u028e\7e\2\2\u028e\u028f\7v\2\2\u028f\u0091\3\2\2\2\u0290\u0291\7g\2"+
		"\2\u0291\u0292\7p\2\2\u0292\u0293\7w\2\2\u0293\u0294\7o\2\2\u0294\u0093"+
		"\3\2\2\2\u0295\u0296\7u\2\2\u0296\u0297\7k\2\2\u0297\u0298\7|\2\2\u0298"+
		"\u0299\7g\2\2\u0299\u029a\7q\2\2\u029a\u029b\7h\2\2\u029b\u0095\3\2\2"+
		"\2\u029c\u029d\7v\2\2\u029d\u029e\7{\2\2\u029e\u029f\7r\2\2\u029f\u02a0"+
		"\7g\2\2\u02a0\u02a1\7k\2\2\u02a1\u02a2\7f\2\2\u02a2\u0097\3\2\2\2\u02a3"+
		"\u02a4\7m\2\2\u02a4\u02a5\7k\2\2\u02a5\u02a6\7e\2\2\u02a6\u02a7\7m\2\2"+
		"\u02a7\u02a8\7c\2\2\u02a8\u02a9\7u\2\2\u02a9\u02aa\7o\2\2\u02aa\u0099"+
		"\3\2\2\2\u02ab\u02ac\7t\2\2\u02ac\u02ad\7g\2\2\u02ad\u02ae\7u\2\2\u02ae"+
		"\u02af\7q\2\2\u02af\u02b0\7w\2\2\u02b0\u02b1\7t\2\2\u02b1\u02b2\7e\2\2"+
		"\u02b2\u02b3\7g\2\2\u02b3\u009b\3\2\2\2\u02b4\u02b5\7w\2\2\u02b5\u02b6"+
		"\7u\2\2\u02b6\u02b7\7g\2\2\u02b7\u02b8\7u\2\2\u02b8\u009d\3\2\2\2\u02b9"+
		"\u02ba\7e\2\2\u02ba\u02bb\7n\2\2\u02bb\u02bc\7q\2\2\u02bc\u02bd\7d\2\2"+
		"\u02bd\u02be\7d\2\2\u02be\u02bf\7g\2\2\u02bf\u02c0\7t\2\2\u02c0\u02c1"+
		"\7u\2\2\u02c1\u009f\3\2\2\2\u02c2\u02c3\7d\2\2\u02c3\u02c4\7{\2\2\u02c4"+
		"\u02c5\7v\2\2\u02c5\u02c6\7g\2\2\u02c6\u02c7\7u\2\2\u02c7\u00a1\3\2\2"+
		"\2\u02c8\u02c9\7e\2\2\u02c9\u02ca\7{\2\2\u02ca\u02cb\7e\2\2\u02cb\u02cc"+
		"\7n\2\2\u02cc\u02cd\7g\2\2\u02cd\u02ce\7u\2\2\u02ce\u00a3\3\2\2\2\u02cf"+
		"\u02d0\7#\2\2\u02d0\u00a5\3\2\2\2\u02d1\u02d2\7u\2\2\u02d2\u02d3\7k\2"+
		"\2\u02d3\u02d4\7i\2\2\u02d4\u02d5\7p\2\2\u02d5\u02d6\7g\2\2\u02d6\u02e0"+
		"\7f\2\2\u02d7\u02d8\7w\2\2\u02d8\u02d9\7p\2\2\u02d9\u02da\7u\2\2\u02da"+
		"\u02db\7k\2\2\u02db\u02dc\7i\2\2\u02dc\u02dd\7p\2\2\u02dd\u02de\7g\2\2"+
		"\u02de\u02e0\7f\2\2\u02df\u02d1\3\2\2\2\u02df\u02d7\3\2\2\2\u02e0\u00a7"+
		"\3\2\2\2\u02e1\u02e2\7d\2\2\u02e2\u02e3\7{\2\2\u02e3\u02e4\7v\2\2\u02e4"+
		"\u0307\7g\2\2\u02e5\u02e6\7y\2\2\u02e6\u02e7\7q\2\2\u02e7\u02e8\7t\2\2"+
		"\u02e8\u0307\7f\2\2\u02e9\u02ea\7f\2\2\u02ea\u02eb\7y\2\2\u02eb\u02ec"+
		"\7q\2\2\u02ec\u02ed\7t\2\2\u02ed\u0307\7f\2\2\u02ee\u02ef\7d\2\2\u02ef"+
		"\u02f0\7q\2\2\u02f0\u02f1\7q\2\2\u02f1\u0307\7n\2\2\u02f2\u02f3\7e\2\2"+
		"\u02f3\u02f4\7j\2\2\u02f4\u02f5\7c\2\2\u02f5\u0307\7t\2\2\u02f6\u02f7"+
		"\7u\2\2\u02f7\u02f8\7j\2\2\u02f8\u02f9\7q\2\2\u02f9\u02fa\7t\2\2\u02fa"+
		"\u0307\7v\2\2\u02fb\u02fc\7k\2\2\u02fc\u02fd\7p\2\2\u02fd\u0307\7v\2\2"+
		"\u02fe\u02ff\7n\2\2\u02ff\u0300\7q\2\2\u0300\u0301\7p\2\2\u0301\u0307"+
		"\7i\2\2\u0302\u0303\7x\2\2\u0303\u0304\7q\2\2\u0304\u0305\7k\2\2\u0305"+
		"\u0307\7f\2\2\u0306\u02e1\3\2\2\2\u0306\u02e5\3\2\2\2\u0306\u02e9\3\2"+
		"\2\2\u0306\u02ee\3\2\2\2\u0306\u02f2\3\2\2\2\u0306\u02f6\3\2\2\2\u0306"+
		"\u02fb\3\2\2\2\u0306\u02fe\3\2\2\2\u0306\u0302\3\2\2\2\u0307\u00a9\3\2"+
		"\2\2\u0308\u0309\7v\2\2\u0309\u030a\7t\2\2\u030a\u030b\7w\2\2\u030b\u0312"+
		"\7g\2\2\u030c\u030d\7h\2\2\u030d\u030e\7c\2\2\u030e\u030f\7n\2\2\u030f"+
		"\u0310\7u\2\2\u0310\u0312\7g\2\2\u0311\u0308\3\2\2\2\u0311\u030c\3\2\2"+
		"\2\u0312\u00ab\3\2\2\2\u0313\u0314\7}\2\2\u0314\u0315\7}\2\2\u0315\u0319"+
		"\3\2\2\2\u0316\u0318\13\2\2\2\u0317\u0316\3\2\2\2\u0318\u031b\3\2\2\2"+
		"\u0319\u031a\3\2\2\2\u0319\u0317\3\2\2\2\u031a\u031c\3\2\2\2\u031b\u0319"+
		"\3\2\2\2\u031c\u031d\7\177\2\2\u031d\u031e\7\177\2\2\u031e\u00ad\3\2\2"+
		"\2\u031f\u0325\7$\2\2\u0320\u0321\7^\2\2\u0321\u0324\7$\2\2\u0322\u0324"+
		"\n\2\2\2\u0323\u0320\3\2\2\2\u0323\u0322\3\2\2\2\u0324\u0327\3\2\2\2\u0325"+
		"\u0323\3\2\2\2\u0325\u0326\3\2\2\2\u0326\u0328\3\2\2\2\u0327\u0325\3\2"+
		"\2\2\u0328\u032a\7$\2\2\u0329\u032b\t\3\2\2\u032a\u0329\3\2\2\2\u032a"+
		"\u032b\3\2\2\2\u032b\u0330\3\2\2\2\u032c\u032e\t\4\2\2\u032d\u032f\t\5"+
		"\2\2\u032e\u032d\3\2\2\2\u032e\u032f\3\2\2\2\u032f\u0331\3\2\2\2\u0330"+
		"\u032c\3\2\2\2\u0330\u0331\3\2\2\2\u0331\u0333\3\2\2\2\u0332\u0334\t\3"+
		"\2\2\u0333\u0332\3\2\2\2\u0333\u0334\3\2\2\2\u0334\u0335\3\2\2\2\u0335"+
		"\u0336\bW\5\2\u0336\u00af\3\2\2\2\u0337\u033b\7)\2\2\u0338\u0339\7^\2"+
		"\2\u0339\u033c\t\6\2\2\u033a\u033c\n\7\2\2\u033b\u0338\3\2\2\2\u033b\u033a"+
		"\3\2\2\2\u033c\u033d\3\2\2\2\u033d\u033e\7)\2\2\u033e\u00b1\3\2\2\2\u033f"+
		"\u0342\5\u00b4Z\2\u0340\u0342\5\u00bc^\2\u0341\u033f\3\2\2\2\u0341\u0340"+
		"\3\2\2\2\u0342\u00b3\3\2\2\2\u0343\u0347\5\u00b6[\2\u0344\u0347\5\u00b8"+
		"\\\2\u0345\u0347\5\u00ba]\2\u0346\u0343\3\2\2\2\u0346\u0344\3\2\2\2\u0346"+
		"\u0345\3\2\2\2\u0347\u00b5\3\2\2\2\u0348\u034e\7\'\2\2\u0349\u034a\7\62"+
		"\2\2\u034a\u034e\7d\2\2\u034b\u034c\7\62\2\2\u034c\u034e\7D\2\2\u034d"+
		"\u0348\3\2\2\2\u034d\u0349\3\2\2\2\u034d\u034b\3\2\2\2\u034e\u0352\3\2"+
		"\2\2\u034f\u0351\5\u00c4b\2\u0350\u034f\3\2\2\2\u0351\u0354\3\2\2\2\u0352"+
		"\u0350\3\2\2\2\u0352\u0353\3\2\2\2\u0353\u0355\3\2\2\2\u0354\u0352\3\2"+
		"\2\2\u0355\u0357\7\60\2\2\u0356\u0358\5\u00c4b\2\u0357\u0356\3\2\2\2\u0358"+
		"\u0359\3\2\2\2\u0359\u0357\3\2\2\2\u0359\u035a\3\2\2\2\u035a\u00b7\3\2"+
		"\2\2\u035b\u035d\5\u00c6c\2\u035c\u035b\3\2\2\2\u035d\u0360\3\2\2\2\u035e"+
		"\u035c\3\2\2\2\u035e\u035f\3\2\2\2\u035f\u0361\3\2\2\2\u0360\u035e\3\2"+
		"\2\2\u0361\u0363\7\60\2\2\u0362\u0364\5\u00c6c\2\u0363\u0362\3\2\2\2\u0364"+
		"\u0365\3\2\2\2\u0365\u0363\3\2\2\2\u0365\u0366\3\2\2\2\u0366\u00b9\3\2"+
		"\2\2\u0367\u036d\7&\2\2\u0368\u0369\7\62\2\2\u0369\u036d\7z\2\2\u036a"+
		"\u036b\7\62\2\2\u036b\u036d\7Z\2\2\u036c\u0367\3\2\2\2\u036c\u0368\3\2"+
		"\2\2\u036c\u036a\3\2\2\2\u036d\u0371\3\2\2\2\u036e\u0370\5\u00c8d\2\u036f"+
		"\u036e\3\2\2\2\u0370\u0373\3\2\2\2\u0371\u036f\3\2\2\2\u0371\u0372\3\2"+
		"\2\2\u0372\u0374\3\2\2\2\u0373\u0371\3\2\2\2\u0374\u0376\7\60\2\2\u0375"+
		"\u0377\5\u00c8d\2\u0376\u0375\3\2\2\2\u0377\u0378\3\2\2\2\u0378\u0376"+
		"\3\2\2\2\u0378\u0379\3\2\2\2\u0379\u00bb\3\2\2\2\u037a\u037e\5\u00c0`"+
		"\2\u037b\u037e\5\u00c2a\2\u037c\u037e\5\u00be_\2\u037d\u037a\3\2\2\2\u037d"+
		"\u037b\3\2\2\2\u037d\u037c\3\2\2\2\u037e\u0382\3\2\2\2\u037f\u0380\t\b"+
		"\2\2\u0380\u0383\t\t\2\2\u0381\u0383\7n\2\2\u0382\u037f\3\2\2\2\u0382"+
		"\u0381\3\2\2\2\u0382\u0383\3\2\2\2\u0383\u00bd\3\2\2\2\u0384\u0385\7\62"+
		"\2\2\u0385\u0387\t\n\2\2\u0386\u0388\5\u00c4b\2\u0387\u0386\3\2\2\2\u0388"+
		"\u0389\3\2\2\2\u0389\u0387\3\2\2\2\u0389\u038a\3\2\2\2\u038a\u0392\3\2"+
		"\2\2\u038b\u038d\7\'\2\2\u038c\u038e\5\u00c4b\2\u038d\u038c\3\2\2\2\u038e"+
		"\u038f\3\2\2\2\u038f\u038d\3\2\2\2\u038f\u0390\3\2\2\2\u0390\u0392\3\2"+
		"\2\2\u0391\u0384\3\2\2\2\u0391\u038b\3\2\2\2\u0392\u00bf\3\2\2\2\u0393"+
		"\u0395\5\u00c6c\2\u0394\u0393\3\2\2\2\u0395\u0396\3\2\2\2\u0396\u0394"+
		"\3\2\2\2\u0396\u0397\3\2\2\2\u0397\u00c1\3\2\2\2\u0398\u039e\7&\2\2\u0399"+
		"\u039a\7\62\2\2\u039a\u039e\7z\2\2\u039b\u039c\7\62\2\2\u039c\u039e\7"+
		"Z\2\2\u039d\u0398\3\2\2\2\u039d\u0399\3\2\2\2\u039d\u039b\3\2\2\2\u039e"+
		"\u03a0\3\2\2\2\u039f\u03a1\5\u00c8d\2\u03a0\u039f\3\2\2\2\u03a1\u03a2"+
		"\3\2\2\2\u03a2\u03a0\3\2\2\2\u03a2\u03a3\3\2\2\2\u03a3\u00c3\3\2\2\2\u03a4"+
		"\u03a5\t\13\2\2\u03a5\u00c5\3\2\2\2\u03a6\u03a7\t\f\2\2\u03a7\u00c7\3"+
		"\2\2\2\u03a8\u03a9\t\r\2\2\u03a9\u00c9\3\2\2\2\u03aa\u03ae\5\u00ccf\2"+
		"\u03ab\u03ad\5\u00ceg\2\u03ac\u03ab\3\2\2\2\u03ad\u03b0\3\2\2\2\u03ae"+
		"\u03ac\3\2\2\2\u03ae\u03af\3\2\2\2\u03af\u03b1\3\2\2\2\u03b0\u03ae\3\2"+
		"\2\2\u03b1\u03b2\be\6\2\u03b2\u00cb\3\2\2\2\u03b3\u03b4\t\16\2\2\u03b4"+
		"\u00cd\3\2\2\2\u03b5\u03b6\t\17\2\2\u03b6\u00cf\3\2\2\2\u03b7\u03b9\t"+
		"\20\2\2\u03b8\u03b7\3\2\2\2\u03b9\u03ba\3\2\2\2\u03ba\u03b8\3\2\2\2\u03ba"+
		"\u03bb\3\2\2\2\u03bb\u03bc\3\2\2\2\u03bc\u03bd\bh\7\2\u03bd\u00d1\3\2"+
		"\2\2\u03be\u03bf\7\61\2\2\u03bf\u03c0\7\61\2\2\u03c0\u03c4\3\2\2\2\u03c1"+
		"\u03c3\n\21\2\2\u03c2\u03c1\3\2\2\2\u03c3\u03c6\3\2\2\2\u03c4\u03c2\3"+
		"\2\2\2\u03c4\u03c5\3\2\2\2\u03c5\u03c7\3\2\2\2\u03c6\u03c4\3\2\2\2\u03c7"+
		"\u03c8\bi\b\2\u03c8\u00d3\3\2\2\2\u03c9\u03ca\7\61\2\2\u03ca\u03cb\7,"+
		"\2\2\u03cb\u03cf\3\2\2\2\u03cc\u03ce\13\2\2\2\u03cd\u03cc\3\2\2\2\u03ce"+
		"\u03d1\3\2\2\2\u03cf\u03d0\3\2\2\2\u03cf\u03cd\3\2\2\2\u03d0\u03d2\3\2"+
		"\2\2\u03d1\u03cf\3\2\2\2\u03d2\u03d3\7,\2\2\u03d3\u03d4\7\61\2\2\u03d4"+
		"\u03d5\3\2\2\2\u03d5\u03d6\bj\b\2\u03d6\u00d5\3\2\2\2\u03d7\u03d8\7\60"+
		"\2\2\u03d8\u03d9\7d\2\2\u03d9\u03da\7{\2\2\u03da\u03db\7v\2\2\u03db\u03dc"+
		"\7g\2\2\u03dc\u00d7\3\2\2\2\u03dd\u03de\7d\2\2\u03de\u03df\7t\2\2\u03df"+
		"\u04bc\7m\2\2\u03e0\u03e1\7q\2\2\u03e1\u03e2\7t\2\2\u03e2\u04bc\7c\2\2"+
		"\u03e3\u03e4\7m\2\2\u03e4\u03e5\7k\2\2\u03e5\u04bc\7n\2\2\u03e6\u03e7"+
		"\7u\2\2\u03e7\u03e8\7n\2\2\u03e8\u04bc\7q\2\2\u03e9\u03ea\7p\2\2\u03ea"+
		"\u03eb\7q\2\2\u03eb\u04bc\7r\2\2\u03ec\u03ed\7c\2\2\u03ed\u03ee\7u\2\2"+
		"\u03ee\u04bc\7n\2\2\u03ef\u03f0\7r\2\2\u03f0\u03f1\7j\2\2\u03f1\u04bc"+
		"\7r\2\2\u03f2\u03f3\7c\2\2\u03f3\u03f4\7p\2\2\u03f4\u04bc\7e\2\2\u03f5"+
		"\u03f6\7d\2\2\u03f6\u03f7\7r\2\2\u03f7\u04bc\7n\2\2\u03f8\u03f9\7e\2\2"+
		"\u03f9\u03fa\7n\2\2\u03fa\u04bc\7e\2\2\u03fb\u03fc\7l\2\2\u03fc\u03fd"+
		"\7u\2\2\u03fd\u04bc\7t\2\2\u03fe\u03ff\7c\2\2\u03ff\u0400\7p\2\2\u0400"+
		"\u04bc\7f\2\2\u0401\u0402\7t\2\2\u0402\u0403\7n\2\2\u0403\u04bc\7c\2\2"+
		"\u0404\u0405\7d\2\2\u0405\u0406\7k\2\2\u0406\u04bc\7v\2\2\u0407\u0408"+
		"\7t\2\2\u0408\u0409\7q\2\2\u0409\u04bc\7n\2\2\u040a\u040b\7r\2\2\u040b"+
		"\u040c\7n\2\2\u040c\u04bc\7c\2\2\u040d\u040e\7r\2\2\u040e\u040f\7n\2\2"+
		"\u040f\u04bc\7r\2\2\u0410\u0411\7d\2\2\u0411\u0412\7o\2\2\u0412\u04bc"+
		"\7k\2\2\u0413\u0414\7u\2\2\u0414\u0415\7g\2\2\u0415\u04bc\7e\2\2\u0416"+
		"\u0417\7t\2\2\u0417\u0418\7v\2\2\u0418\u04bc\7k\2\2\u0419\u041a\7g\2\2"+
		"\u041a\u041b\7q\2\2\u041b\u04bc\7t\2\2\u041c\u041d\7u\2\2\u041d\u041e"+
		"\7t\2\2\u041e\u04bc\7g\2\2\u041f\u0420\7n\2\2\u0420\u0421\7u\2\2\u0421"+
		"\u04bc\7t\2\2\u0422\u0423\7r\2\2\u0423\u0424\7j\2\2\u0424\u04bc\7c\2\2"+
		"\u0425\u0426\7c\2\2\u0426\u0427\7n\2\2\u0427\u04bc\7t\2\2\u0428\u0429"+
		"\7l\2\2\u0429\u042a\7o\2\2\u042a\u04bc\7r\2\2\u042b\u042c\7d\2\2\u042c"+
		"\u042d\7x\2\2\u042d\u04bc\7e\2\2\u042e\u042f\7e\2\2\u042f\u0430\7n\2\2"+
		"\u0430\u04bc\7k\2\2\u0431\u0432\7t\2\2\u0432\u0433\7v\2\2\u0433\u04bc"+
		"\7u\2\2\u0434\u0435\7c\2\2\u0435\u0436\7f\2\2\u0436\u04bc\7e\2\2\u0437"+
		"\u0438\7t\2\2\u0438\u0439\7t\2\2\u0439\u04bc\7c\2\2\u043a\u043b\7d\2\2"+
		"\u043b\u043c\7x\2\2\u043c\u04bc\7u\2\2\u043d\u043e\7u\2\2\u043e\u043f"+
		"\7g\2\2\u043f\u04bc\7k\2\2\u0440\u0441\7u\2\2\u0441\u0442\7c\2\2\u0442"+
		"\u04bc\7z\2\2\u0443\u0444\7u\2\2\u0444\u0445\7v\2\2\u0445\u04bc\7{\2\2"+
		"\u0446\u0447\7u\2\2\u0447\u0448\7v\2\2\u0448\u04bc\7c\2\2\u0449\u044a"+
		"\7u\2\2\u044a\u044b\7v\2\2\u044b\u04bc\7z\2\2\u044c\u044d\7f\2\2\u044d"+
		"\u044e\7g\2\2\u044e\u04bc\7{\2\2\u044f\u0450\7v\2\2\u0450\u0451\7z\2\2"+
		"\u0451\u04bc\7c\2\2\u0452\u0453\7z\2\2\u0453\u0454\7c\2\2\u0454\u04bc"+
		"\7c\2\2\u0455\u0456\7d\2\2\u0456\u0457\7e\2\2\u0457\u04bc\7e\2\2\u0458"+
		"\u0459\7c\2\2\u0459\u045a\7j\2\2\u045a\u04bc\7z\2\2\u045b\u045c\7v\2\2"+
		"\u045c\u045d\7{\2\2\u045d\u04bc\7c\2\2\u045e\u045f\7v\2\2\u045f\u0460"+
		"\7z\2\2\u0460\u04bc\7u\2\2\u0461\u0462\7v\2\2\u0462\u0463\7c\2\2\u0463"+
		"\u04bc\7u\2\2\u0464\u0465\7u\2\2\u0465\u0466\7j\2\2\u0466\u04bc\7{\2\2"+
		"\u0467\u0468\7u\2\2\u0468\u0469\7j\2\2\u0469\u04bc\7z\2\2\u046a\u046b"+
		"\7n\2\2\u046b\u046c\7f\2\2\u046c\u04bc\7{\2\2\u046d\u046e\7n\2\2\u046e"+
		"\u046f\7f\2\2\u046f\u04bc\7c\2\2\u0470\u0471\7n\2\2\u0471\u0472\7f\2\2"+
		"\u0472\u04bc\7z\2\2\u0473\u0474\7n\2\2\u0474\u0475\7c\2\2\u0475\u04bc"+
		"\7z\2\2\u0476\u0477\7v\2\2\u0477\u0478\7c\2\2\u0478\u04bc\7{\2\2\u0479"+
		"\u047a\7v\2\2\u047a\u047b\7c\2\2\u047b\u04bc\7z\2\2\u047c\u047d\7d\2\2"+
		"\u047d\u047e\7e\2\2\u047e\u04bc\7u\2\2\u047f\u0480\7e\2\2\u0480\u0481"+
		"\7n\2\2\u0481\u04bc\7x\2\2\u0482\u0483\7v\2\2\u0483\u0484\7u\2\2\u0484"+
		"\u04bc\7z\2\2\u0485\u0486\7n\2\2\u0486\u0487\7c\2\2\u0487\u04bc\7u\2\2"+
		"\u0488\u0489\7e\2\2\u0489\u048a\7r\2\2\u048a\u04bc\7{\2\2\u048b\u048c"+
		"\7e\2\2\u048c\u048d\7o\2\2\u048d\u04bc\7r\2\2\u048e\u048f\7e\2\2\u048f"+
		"\u0490\7r\2\2\u0490\u04bc\7z\2\2\u0491\u0492\7f\2\2\u0492\u0493\7e\2\2"+
		"\u0493\u04bc\7r\2\2\u0494\u0495\7f\2\2\u0495\u0496\7g\2\2\u0496\u04bc"+
		"\7e\2\2\u0497\u0498\7k\2\2\u0498\u0499\7p\2\2\u0499\u04bc\7e\2\2\u049a"+
		"\u049b\7c\2\2\u049b\u049c\7z\2\2\u049c\u04bc\7u\2\2\u049d\u049e\7d\2\2"+
		"\u049e\u049f\7p\2\2\u049f\u04bc\7g\2\2\u04a0\u04a1\7e\2\2\u04a1\u04a2"+
		"\7n\2\2\u04a2\u04bc\7f\2\2\u04a3\u04a4\7u\2\2\u04a4\u04a5\7d\2\2\u04a5"+
		"\u04bc\7e\2\2\u04a6\u04a7\7k\2\2\u04a7\u04a8\7u\2\2\u04a8\u04bc\7e\2\2"+
		"\u04a9\u04aa\7k\2\2\u04aa\u04ab\7p\2\2\u04ab\u04bc\7z\2\2\u04ac\u04ad"+
		"\7d\2\2\u04ad\u04ae\7g\2\2\u04ae\u04bc\7s\2\2\u04af\u04b0\7u\2\2\u04b0"+
		"\u04b1\7g\2\2\u04b1\u04bc\7f\2\2\u04b2\u04b3\7f\2\2\u04b3\u04b4\7g\2\2"+
		"\u04b4\u04bc\7z\2\2\u04b5\u04b6\7k\2\2\u04b6\u04b7\7p\2\2\u04b7\u04bc"+
		"\7{\2\2\u04b8\u04b9\7t\2\2\u04b9\u04ba\7q\2\2\u04ba\u04bc\7t\2\2\u04bb"+
		"\u03dd\3\2\2\2\u04bb\u03e0\3\2\2\2\u04bb\u03e3\3\2\2\2\u04bb\u03e6\3\2"+
		"\2\2\u04bb\u03e9\3\2\2\2\u04bb\u03ec\3\2\2\2\u04bb\u03ef\3\2\2\2\u04bb"+
		"\u03f2\3\2\2\2\u04bb\u03f5\3\2\2\2\u04bb\u03f8\3\2\2\2\u04bb\u03fb\3\2"+
		"\2\2\u04bb\u03fe\3\2\2\2\u04bb\u0401\3\2\2\2\u04bb\u0404\3\2\2\2\u04bb"+
		"\u0407\3\2\2\2\u04bb\u040a\3\2\2\2\u04bb\u040d\3\2\2\2\u04bb\u0410\3\2"+
		"\2\2\u04bb\u0413\3\2\2\2\u04bb\u0416\3\2\2\2\u04bb\u0419\3\2\2\2\u04bb"+
		"\u041c\3\2\2\2\u04bb\u041f\3\2\2\2\u04bb\u0422\3\2\2\2\u04bb\u0425\3\2"+
		"\2\2\u04bb\u0428\3\2\2\2\u04bb\u042b\3\2\2\2\u04bb\u042e\3\2\2\2\u04bb"+
		"\u0431\3\2\2\2\u04bb\u0434\3\2\2\2\u04bb\u0437\3\2\2\2\u04bb\u043a\3\2"+
		"\2\2\u04bb\u043d\3\2\2\2\u04bb\u0440\3\2\2\2\u04bb\u0443\3\2\2\2\u04bb"+
		"\u0446\3\2\2\2\u04bb\u0449\3\2\2\2\u04bb\u044c\3\2\2\2\u04bb\u044f\3\2"+
		"\2\2\u04bb\u0452\3\2\2\2\u04bb\u0455\3\2\2\2\u04bb\u0458\3\2\2\2\u04bb"+
		"\u045b\3\2\2\2\u04bb\u045e\3\2\2\2\u04bb\u0461\3\2\2\2\u04bb\u0464\3\2"+
		"\2\2\u04bb\u0467\3\2\2\2\u04bb\u046a\3\2\2\2\u04bb\u046d\3\2\2\2\u04bb"+
		"\u0470\3\2\2\2\u04bb\u0473\3\2\2\2\u04bb\u0476\3\2\2\2\u04bb\u0479\3\2"+
		"\2\2\u04bb\u047c\3\2\2\2\u04bb\u047f\3\2\2\2\u04bb\u0482\3\2\2\2\u04bb"+
		"\u0485\3\2\2\2\u04bb\u0488\3\2\2\2\u04bb\u048b\3\2\2\2\u04bb\u048e\3\2"+
		"\2\2\u04bb\u0491\3\2\2\2\u04bb\u0494\3\2\2\2\u04bb\u0497\3\2\2\2\u04bb"+
		"\u049a\3\2\2\2\u04bb\u049d\3\2\2\2\u04bb\u04a0\3\2\2\2\u04bb\u04a3\3\2"+
		"\2\2\u04bb\u04a6\3\2\2\2\u04bb\u04a9\3\2\2\2\u04bb\u04ac\3\2\2\2\u04bb"+
		"\u04af\3\2\2\2\u04bb\u04b2\3\2\2\2\u04bb\u04b5\3\2\2\2\u04bb\u04b8\3\2"+
		"\2\2\u04bc\u00d9\3\2\2\2\u04bd\u04be\7%\2\2\u04be\u00db\3\2\2\2\u04bf"+
		"\u04c0\7<\2\2\u04c0\u00dd\3\2\2\2\u04c1\u04c2\7.\2\2\u04c2\u00df\3\2\2"+
		"\2\u04c3\u04c4\7*\2\2\u04c4\u00e1\3\2\2\2\u04c5\u04c6\7+\2\2\u04c6\u00e3"+
		"\3\2\2\2\u04c7\u04c8\7]\2\2\u04c8\u00e5\3\2\2\2\u04c9\u04ca\7_\2\2\u04ca"+
		"\u00e7\3\2\2\2\u04cb\u04cc\7\60\2\2\u04cc\u00e9\3\2\2\2\u04cd\u04ce\7"+
		">\2\2\u04ce\u04cf\7>\2\2\u04cf\u00eb\3\2\2\2\u04d0\u04d1\7@\2\2\u04d1"+
		"\u04d2\7@\2\2\u04d2\u00ed\3\2\2\2\u04d3\u04d4\7-\2\2\u04d4\u00ef\3\2\2"+
		"\2\u04d5\u04d6\7/\2\2\u04d6\u00f1\3\2\2\2\u04d7\u04d8\7>\2\2\u04d8\u00f3"+
		"\3\2\2\2\u04d9\u04da\7@\2\2\u04da\u00f5\3\2\2\2\u04db\u04dc\7,\2\2\u04dc"+
		"\u00f7\3\2\2\2\u04dd\u04de\7\61\2\2\u04de\u00f9\3\2\2\2\u04df\u04e0\7"+
		"}\2\2\u04e0\u04e1\b}\t\2\u04e1\u00fb\3\2\2\2\u04e2\u04e3\7\177\2\2\u04e3"+
		"\u04e4\b~\n\2\u04e4\u00fd\3\2\2\2\u04e5\u04e8\5\u0100\u0080\2\u04e6\u04e8"+
		"\5\u0108\u0084\2\u04e7\u04e5\3\2\2\2\u04e7\u04e6\3\2\2\2\u04e8\u00ff\3"+
		"\2\2\2\u04e9\u04ed\5\u0102\u0081\2\u04ea\u04ed\5\u0104\u0082\2\u04eb\u04ed"+
		"\5\u0106\u0083\2\u04ec\u04e9\3\2\2\2\u04ec\u04ea\3\2\2\2\u04ec\u04eb\3"+
		"\2\2\2\u04ed\u0101\3\2\2\2\u04ee\u04f2\7\'\2\2\u04ef\u04f1\5\u0110\u0088"+
		"\2\u04f0\u04ef\3\2\2\2\u04f1\u04f4\3\2\2\2\u04f2\u04f0\3\2\2\2\u04f2\u04f3"+
		"\3\2\2\2\u04f3\u04f5\3\2\2\2\u04f4\u04f2\3\2\2\2\u04f5\u04f7\7\60\2\2"+
		"\u04f6\u04f8\5\u0110\u0088\2\u04f7\u04f6\3\2\2\2\u04f8\u04f9\3\2\2\2\u04f9"+
		"\u04f7\3\2\2\2\u04f9\u04fa\3\2\2\2\u04fa\u0103\3\2\2\2\u04fb\u04fd\5\u0112"+
		"\u0089\2\u04fc\u04fb\3\2\2\2\u04fd\u0500\3\2\2\2\u04fe\u04fc\3\2\2\2\u04fe"+
		"\u04ff\3\2\2\2\u04ff\u0501\3\2\2\2\u0500\u04fe\3\2\2\2\u0501\u0503\7\60"+
		"\2\2\u0502\u0504\5\u0112\u0089\2\u0503\u0502\3\2\2\2\u0504\u0505\3\2\2"+
		"\2\u0505\u0503\3\2\2\2\u0505\u0506\3\2\2\2\u0506\u0105\3\2\2\2\u0507\u050b"+
		"\7&\2\2\u0508\u050a\5\u0114\u008a\2\u0509\u0508\3\2\2\2\u050a\u050d\3"+
		"\2\2\2\u050b\u0509\3\2\2\2\u050b\u050c\3\2\2\2\u050c\u050e\3\2\2\2\u050d"+
		"\u050b\3\2\2\2\u050e\u0510\7\60\2\2\u050f\u0511\5\u0114\u008a\2\u0510"+
		"\u050f\3\2\2\2\u0511\u0512\3\2\2\2\u0512\u0510\3\2\2\2\u0512\u0513\3\2"+
		"\2\2\u0513\u0107\3\2\2\2\u0514\u0518\5\u010c\u0086\2\u0515\u0518\5\u010e"+
		"\u0087\2\u0516\u0518\5\u010a\u0085\2\u0517\u0514\3\2\2\2\u0517\u0515\3"+
		"\2\2\2\u0517\u0516\3\2\2\2\u0518\u0109\3\2\2\2\u0519\u051b\7\'\2\2\u051a"+
		"\u051c\5\u0110\u0088\2\u051b\u051a\3\2\2\2\u051c\u051d\3\2\2\2\u051d\u051b"+
		"\3\2\2\2\u051d\u051e\3\2\2\2\u051e\u010b\3\2\2\2\u051f\u0521\5\u0112\u0089"+
		"\2\u0520\u051f\3\2\2\2\u0521\u0522\3\2\2\2\u0522\u0520\3\2\2\2\u0522\u0523"+
		"\3\2\2\2\u0523\u010d\3\2\2\2\u0524\u0526\7&\2\2\u0525\u0527\5\u0114\u008a"+
		"\2\u0526\u0525\3\2\2\2\u0527\u0528\3\2\2\2\u0528\u0526\3\2\2\2\u0528\u0529"+
		"\3\2\2\2\u0529\u010f\3\2\2\2\u052a\u052b\t\13\2\2\u052b\u0111\3\2\2\2"+
		"\u052c\u052d\t\f\2\2\u052d\u0113\3\2\2\2\u052e\u052f\t\r\2\2\u052f\u0115"+
		"\3\2\2\2\u0530\u0534\7)\2\2\u0531\u0532\7^\2\2\u0532\u0535\t\6\2\2\u0533"+
		"\u0535\n\7\2\2\u0534\u0531\3\2\2\2\u0534\u0533\3\2\2\2\u0535\u0536\3\2"+
		"\2\2\u0536\u0537\7)\2\2\u0537\u0117\3\2\2\2\u0538\u053a\5\u011a\u008d"+
		"\2\u0539\u053b\t\22\2\2\u053a\u0539\3\2\2\2\u053b\u053c\3\2\2\2\u053c"+
		"\u053a\3\2\2\2\u053c\u053d\3\2\2\2\u053d\u0119\3\2\2\2\u053e\u0542\7#"+
		"\2\2\u053f\u0541\5\u0120\u0090\2\u0540\u053f\3\2\2\2\u0541\u0544\3\2\2"+
		"\2\u0542\u0540\3\2\2\2\u0542\u0543\3\2\2\2\u0543\u011b\3\2\2\2\u0544\u0542"+
		"\3\2\2\2\u0545\u0549\5\u011e\u008f\2\u0546\u0548\5\u0120\u0090\2\u0547"+
		"\u0546\3\2\2\2\u0548\u054b\3\2\2\2\u0549\u0547\3\2\2\2\u0549\u054a\3\2"+
		"\2\2\u054a\u011d\3\2\2\2\u054b\u0549\3\2\2\2\u054c\u054d\t\16\2\2\u054d"+
		"\u011f\3\2\2\2\u054e\u054f\t\17\2\2\u054f\u0121\3\2\2\2\u0550\u0552\t"+
		"\20\2\2\u0551\u0550\3\2\2\2\u0552\u0553\3\2\2\2\u0553\u0551\3\2\2\2\u0553"+
		"\u0554\3\2\2\2\u0554\u0555\3\2\2\2\u0555\u0556\b\u0091\7\2\u0556\u0123"+
		"\3\2\2\2\u0557\u0558\7\61\2\2\u0558\u0559\7\61\2\2\u0559\u055d\3\2\2\2"+
		"\u055a\u055c\n\21\2\2\u055b\u055a\3\2\2\2\u055c\u055f\3\2\2\2\u055d\u055b"+
		"\3\2\2\2\u055d\u055e\3\2\2\2\u055e\u0560\3\2\2\2\u055f\u055d\3\2\2\2\u0560"+
		"\u0561\b\u0092\b\2\u0561\u0125\3\2\2\2\u0562\u0563\7\61\2\2\u0563\u0564"+
		"\7,\2\2\u0564\u0568\3\2\2\2\u0565\u0567\13\2\2\2\u0566\u0565\3\2\2\2\u0567"+
		"\u056a\3\2\2\2\u0568\u0569\3\2\2\2\u0568\u0566\3\2\2\2\u0569\u056b\3\2"+
		"\2\2\u056a\u0568\3\2\2\2\u056b\u056c\7,\2\2\u056c\u056d\7\61\2\2\u056d"+
		"\u056e\3\2\2\2\u056e\u056f\b\u0093\b\2\u056f\u0127\3\2\2\2;\2\3\u0191"+
		"\u0242\u02df\u0306\u0311\u0319\u0323\u0325\u032a\u032e\u0330\u0333\u033b"+
		"\u0341\u0346\u034d\u0352\u0359\u035e\u0365\u036c\u0371\u0378\u037d\u0382"+
		"\u0389\u038f\u0391\u0396\u039d\u03a2\u03ae\u03ba\u03c4\u03cf\u04bb\u04e7"+
		"\u04ec\u04f2\u04f9\u04fe\u0505\u050b\u0512\u0517\u051d\u0522\u0528\u0534"+
		"\u053c\u0542\u0549\u0553\u055d\u0568\13\3\2\2\3&\3\3E\4\3W\5\3e\6\2\3"+
		"\2\2\4\2\3}\7\3~\b";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}
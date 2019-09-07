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
		IF=57, ELSE=58, WHILE=59, DO=60, FOR=61, SWITCH=62, RETURN=63, BREAK=64, 
		CONTINUE=65, ASM=66, DEFAULT=67, CASE=68, STRUCT=69, ENUM=70, SIZEOF=71, 
		TYPEID=72, KICKASM=73, RESOURCE=74, USES=75, CLOBBERS=76, BYTES=77, CYCLES=78, 
		LOGIC_NOT=79, SIGNEDNESS=80, SIMPLETYPE=81, BOOLEAN=82, KICKASM_BODY=83, 
		STRING=84, CHAR=85, NUMBER=86, NUMFLOAT=87, BINFLOAT=88, DECFLOAT=89, 
		HEXFLOAT=90, NUMINT=91, BININTEGER=92, DECINTEGER=93, HEXINTEGER=94, NAME=95, 
		WS=96, COMMENT_LINE=97, COMMENT_BLOCK=98, ASM_BYTE=99, ASM_MNEMONIC=100, 
		ASM_IMM=101, ASM_COLON=102, ASM_COMMA=103, ASM_PAR_BEGIN=104, ASM_PAR_END=105, 
		ASM_BRACKET_BEGIN=106, ASM_BRACKET_END=107, ASM_DOT=108, ASM_SHIFT_LEFT=109, 
		ASM_SHIFT_RIGHT=110, ASM_PLUS=111, ASM_MINUS=112, ASM_LESS_THAN=113, ASM_GREATER_THAN=114, 
		ASM_MULTIPLY=115, ASM_DIVIDE=116, ASM_CURLY_BEGIN=117, ASM_CURLY_END=118, 
		ASM_NUMBER=119, ASM_NUMFLOAT=120, ASM_BINFLOAT=121, ASM_DECFLOAT=122, 
		ASM_HEXFLOAT=123, ASM_NUMINT=124, ASM_BININTEGER=125, ASM_DECINTEGER=126, 
		ASM_HEXINTEGER=127, ASM_CHAR=128, ASM_MULTI_REL=129, ASM_MULTI_NAME=130, 
		ASM_NAME=131, ASM_WS=132, ASM_COMMENT_LINE=133, ASM_COMMENT_BLOCK=134;
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
		"VOLATILE", "INTERRUPT", "IF", "ELSE", "WHILE", "DO", "FOR", "SWITCH", 
		"RETURN", "BREAK", "CONTINUE", "ASM", "DEFAULT", "CASE", "STRUCT", "ENUM", 
		"SIZEOF", "TYPEID", "KICKASM", "RESOURCE", "USES", "CLOBBERS", "BYTES", 
		"CYCLES", "LOGIC_NOT", "SIGNEDNESS", "SIMPLETYPE", "BOOLEAN", "KICKASM_BODY", 
		"STRING", "CHAR", "NUMBER", "NUMFLOAT", "BINFLOAT", "DECFLOAT", "HEXFLOAT", 
		"NUMINT", "BININTEGER", "DECINTEGER", "HEXINTEGER", "BINDIGIT", "DECDIGIT", 
		"HEXDIGIT", "NAME", "NAME_START", "NAME_CHAR", "WS", "COMMENT_LINE", "COMMENT_BLOCK", 
		"ASM_BYTE", "ASM_MNEMONIC", "ASM_IMM", "ASM_COLON", "ASM_COMMA", "ASM_PAR_BEGIN", 
		"ASM_PAR_END", "ASM_BRACKET_BEGIN", "ASM_BRACKET_END", "ASM_DOT", "ASM_SHIFT_LEFT", 
		"ASM_SHIFT_RIGHT", "ASM_PLUS", "ASM_MINUS", "ASM_LESS_THAN", "ASM_GREATER_THAN", 
		"ASM_MULTIPLY", "ASM_DIVIDE", "ASM_CURLY_BEGIN", "ASM_CURLY_END", "ASM_NUMBER", 
		"ASM_NUMFLOAT", "ASM_BINFLOAT", "ASM_DECFLOAT", "ASM_HEXFLOAT", "ASM_NUMINT", 
		"ASM_BININTEGER", "ASM_DECINTEGER", "ASM_HEXINTEGER", "ASM_BINDIGIT", 
		"ASM_DECDIGIT", "ASM_HEXDIGIT", "ASM_CHAR", "ASM_MULTI_REL", "ASM_MULTI_NAME", 
		"ASM_NAME", "ASM_NAME_START", "ASM_NAME_CHAR", "ASM_WS", "ASM_COMMENT_LINE", 
		"ASM_COMMENT_BLOCK"
	};

	private static final String[] _LITERAL_NAMES = {
		null, null, null, null, null, null, null, null, "';'", null, null, "'..'", 
		"'?'", null, "'->'", null, null, null, null, "'%'", "'++'", "'--'", "'&'", 
		"'~'", "'^'", "'|'", null, null, "'=='", "'!='", null, "'<='", "'>='", 
		null, "'&&'", "'||'", "'='", null, "'import'", "'typedef'", "'#pragma'", 
		"'reserve'", "'pc'", "'target'", "'link'", "'cpu'", "'code_seg'", "'data_seg'", 
		"'encoding'", "'const'", "'extern'", "'export'", "'align'", "'register'", 
		"'inline'", "'volatile'", "'interrupt'", "'if'", "'else'", "'while'", 
		"'do'", "'for'", "'switch'", "'return'", "'break'", "'continue'", "'asm'", 
		"'default'", "'case'", "'struct'", "'enum'", "'sizeof'", "'typeid'", "'kickasm'", 
		"'resource'", "'uses'", "'clobbers'", "'bytes'", "'cycles'", "'!'", null, 
		null, null, null, null, null, null, null, null, null, null, null, null, 
		null, null, null, null, null, null, "'.byte'", null, "'#'"
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
		"REGISTER", "INLINE", "VOLATILE", "INTERRUPT", "IF", "ELSE", "WHILE", 
		"DO", "FOR", "SWITCH", "RETURN", "BREAK", "CONTINUE", "ASM", "DEFAULT", 
		"CASE", "STRUCT", "ENUM", "SIZEOF", "TYPEID", "KICKASM", "RESOURCE", "USES", 
		"CLOBBERS", "BYTES", "CYCLES", "LOGIC_NOT", "SIGNEDNESS", "SIMPLETYPE", 
		"BOOLEAN", "KICKASM_BODY", "STRING", "CHAR", "NUMBER", "NUMFLOAT", "BINFLOAT", 
		"DECFLOAT", "HEXFLOAT", "NUMINT", "BININTEGER", "DECINTEGER", "HEXINTEGER", 
		"NAME", "WS", "COMMENT_LINE", "COMMENT_BLOCK", "ASM_BYTE", "ASM_MNEMONIC", 
		"ASM_IMM", "ASM_COLON", "ASM_COMMA", "ASM_PAR_BEGIN", "ASM_PAR_END", "ASM_BRACKET_BEGIN", 
		"ASM_BRACKET_END", "ASM_DOT", "ASM_SHIFT_LEFT", "ASM_SHIFT_RIGHT", "ASM_PLUS", 
		"ASM_MINUS", "ASM_LESS_THAN", "ASM_GREATER_THAN", "ASM_MULTIPLY", "ASM_DIVIDE", 
		"ASM_CURLY_BEGIN", "ASM_CURLY_END", "ASM_NUMBER", "ASM_NUMFLOAT", "ASM_BINFLOAT", 
		"ASM_DECFLOAT", "ASM_HEXFLOAT", "ASM_NUMINT", "ASM_BININTEGER", "ASM_DECINTEGER", 
		"ASM_HEXINTEGER", "ASM_CHAR", "ASM_MULTI_REL", "ASM_MULTI_NAME", "ASM_NAME", 
		"ASM_WS", "ASM_COMMENT_LINE", "ASM_COMMENT_BLOCK"
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
		case 64:
			ASM_action((RuleContext)_localctx, actionIndex);
			break;
		case 82:
			STRING_action((RuleContext)_localctx, actionIndex);
			break;
		case 96:
			NAME_action((RuleContext)_localctx, actionIndex);
			break;
		case 120:
			ASM_CURLY_BEGIN_action((RuleContext)_localctx, actionIndex);
			break;
		case 121:
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
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\2\u0088\u0545\b\1\b"+
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
		"\4\u008e\t\u008e\4\u008f\t\u008f\4\u0090\t\u0090\3\2\3\2\3\2\3\3\3\3\3"+
		"\4\3\4\3\5\3\5\3\6\3\6\3\7\3\7\3\b\3\b\3\t\3\t\3\n\3\n\3\13\3\13\3\13"+
		"\3\f\3\f\3\r\3\r\3\16\3\16\3\16\3\17\3\17\3\20\3\20\3\21\3\21\3\22\3\22"+
		"\3\23\3\23\3\24\3\24\3\24\3\25\3\25\3\25\3\26\3\26\3\27\3\27\3\30\3\30"+
		"\3\31\3\31\3\32\3\32\3\32\3\33\3\33\3\33\3\34\3\34\3\34\3\35\3\35\3\35"+
		"\3\36\3\36\3\37\3\37\3\37\3 \3 \3 \3!\3!\3\"\3\"\3\"\3#\3#\3#\3$\3$\3"+
		"%\3%\3%\3%\3%\3%\3%\3%\3%\3%\3%\3%\3%\3%\3%\3%\3%\3%\3%\3%\3%\3%\5%\u018c"+
		"\n%\3&\3&\3&\3&\3&\3&\3&\3&\3&\3\'\3\'\3\'\3\'\3\'\3\'\3\'\3\'\3(\3(\3"+
		"(\3(\3(\3(\3(\3(\3)\3)\3)\3)\3)\3)\3)\3)\3*\3*\3*\3+\3+\3+\3+\3+\3+\3"+
		"+\3,\3,\3,\3,\3,\3-\3-\3-\3-\3.\3.\3.\3.\3.\3.\3.\3.\3.\3/\3/\3/\3/\3"+
		"/\3/\3/\3/\3/\3\60\3\60\3\60\3\60\3\60\3\60\3\60\3\60\3\60\3\61\3\61\3"+
		"\61\3\61\3\61\3\61\3\62\3\62\3\62\3\62\3\62\3\62\3\62\3\63\3\63\3\63\3"+
		"\63\3\63\3\63\3\63\3\64\3\64\3\64\3\64\3\64\3\64\3\65\3\65\3\65\3\65\3"+
		"\65\3\65\3\65\3\65\3\65\3\66\3\66\3\66\3\66\3\66\3\66\3\66\3\67\3\67\3"+
		"\67\3\67\3\67\3\67\3\67\3\67\3\67\38\38\38\38\38\38\38\38\38\38\39\39"+
		"\39\3:\3:\3:\3:\3:\3;\3;\3;\3;\3;\3;\3<\3<\3<\3=\3=\3=\3=\3>\3>\3>\3>"+
		"\3>\3>\3>\3?\3?\3?\3?\3?\3?\3?\3@\3@\3@\3@\3@\3@\3A\3A\3A\3A\3A\3A\3A"+
		"\3A\3A\3B\3B\3B\3B\3B\3B\3C\3C\3C\3C\3C\3C\3C\3C\3D\3D\3D\3D\3D\3E\3E"+
		"\3E\3E\3E\3E\3E\3F\3F\3F\3F\3F\3G\3G\3G\3G\3G\3G\3G\3H\3H\3H\3H\3H\3H"+
		"\3H\3I\3I\3I\3I\3I\3I\3I\3I\3J\3J\3J\3J\3J\3J\3J\3J\3J\3K\3K\3K\3K\3K"+
		"\3L\3L\3L\3L\3L\3L\3L\3L\3L\3M\3M\3M\3M\3M\3M\3N\3N\3N\3N\3N\3N\3N\3O"+
		"\3O\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\5P\u02b5\nP\3Q\3Q\3Q\3Q"+
		"\3Q\3Q\3Q\3Q\3Q\3Q\3Q\3Q\3Q\3Q\3Q\3Q\3Q\3Q\3Q\3Q\3Q\3Q\3Q\3Q\3Q\3Q\3Q"+
		"\3Q\3Q\3Q\3Q\3Q\3Q\3Q\3Q\3Q\3Q\5Q\u02dc\nQ\3R\3R\3R\3R\3R\3R\3R\3R\3R"+
		"\5R\u02e7\nR\3S\3S\3S\3S\7S\u02ed\nS\fS\16S\u02f0\13S\3S\3S\3S\3T\3T\3"+
		"T\3T\7T\u02f9\nT\fT\16T\u02fc\13T\3T\3T\5T\u0300\nT\3T\3T\5T\u0304\nT"+
		"\5T\u0306\nT\3T\5T\u0309\nT\3T\3T\3U\3U\3U\3U\5U\u0311\nU\3U\3U\3V\3V"+
		"\5V\u0317\nV\3W\3W\3W\5W\u031c\nW\3X\3X\3X\3X\3X\5X\u0323\nX\3X\7X\u0326"+
		"\nX\fX\16X\u0329\13X\3X\3X\6X\u032d\nX\rX\16X\u032e\3Y\7Y\u0332\nY\fY"+
		"\16Y\u0335\13Y\3Y\3Y\6Y\u0339\nY\rY\16Y\u033a\3Z\3Z\3Z\3Z\3Z\5Z\u0342"+
		"\nZ\3Z\7Z\u0345\nZ\fZ\16Z\u0348\13Z\3Z\3Z\6Z\u034c\nZ\rZ\16Z\u034d\3["+
		"\3[\3[\5[\u0353\n[\3[\3[\3[\5[\u0358\n[\3\\\3\\\3\\\6\\\u035d\n\\\r\\"+
		"\16\\\u035e\3\\\3\\\6\\\u0363\n\\\r\\\16\\\u0364\5\\\u0367\n\\\3]\6]\u036a"+
		"\n]\r]\16]\u036b\3^\3^\3^\3^\3^\5^\u0373\n^\3^\6^\u0376\n^\r^\16^\u0377"+
		"\3_\3_\3`\3`\3a\3a\3b\3b\7b\u0382\nb\fb\16b\u0385\13b\3b\3b\3c\3c\3d\3"+
		"d\3e\6e\u038e\ne\re\16e\u038f\3e\3e\3f\3f\3f\3f\7f\u0398\nf\ff\16f\u039b"+
		"\13f\3f\3f\3g\3g\3g\3g\7g\u03a3\ng\fg\16g\u03a6\13g\3g\3g\3g\3g\3g\3h"+
		"\3h\3h\3h\3h\3h\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i"+
		"\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i"+
		"\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i"+
		"\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i"+
		"\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i"+
		"\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i"+
		"\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i"+
		"\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i"+
		"\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i"+
		"\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\3i\5i\u0491"+
		"\ni\3j\3j\3k\3k\3l\3l\3m\3m\3n\3n\3o\3o\3p\3p\3q\3q\3r\3r\3r\3s\3s\3s"+
		"\3t\3t\3u\3u\3v\3v\3w\3w\3x\3x\3y\3y\3z\3z\3z\3{\3{\3{\3|\3|\5|\u04bd"+
		"\n|\3}\3}\3}\5}\u04c2\n}\3~\3~\7~\u04c6\n~\f~\16~\u04c9\13~\3~\3~\6~\u04cd"+
		"\n~\r~\16~\u04ce\3\177\7\177\u04d2\n\177\f\177\16\177\u04d5\13\177\3\177"+
		"\3\177\6\177\u04d9\n\177\r\177\16\177\u04da\3\u0080\3\u0080\7\u0080\u04df"+
		"\n\u0080\f\u0080\16\u0080\u04e2\13\u0080\3\u0080\3\u0080\6\u0080\u04e6"+
		"\n\u0080\r\u0080\16\u0080\u04e7\3\u0081\3\u0081\3\u0081\5\u0081\u04ed"+
		"\n\u0081\3\u0082\3\u0082\6\u0082\u04f1\n\u0082\r\u0082\16\u0082\u04f2"+
		"\3\u0083\6\u0083\u04f6\n\u0083\r\u0083\16\u0083\u04f7\3\u0084\3\u0084"+
		"\6\u0084\u04fc\n\u0084\r\u0084\16\u0084\u04fd\3\u0085\3\u0085\3\u0086"+
		"\3\u0086\3\u0087\3\u0087\3\u0088\3\u0088\3\u0088\3\u0088\5\u0088\u050a"+
		"\n\u0088\3\u0088\3\u0088\3\u0089\3\u0089\6\u0089\u0510\n\u0089\r\u0089"+
		"\16\u0089\u0511\3\u008a\3\u008a\7\u008a\u0516\n\u008a\f\u008a\16\u008a"+
		"\u0519\13\u008a\3\u008b\3\u008b\7\u008b\u051d\n\u008b\f\u008b\16\u008b"+
		"\u0520\13\u008b\3\u008c\3\u008c\3\u008d\3\u008d\3\u008e\6\u008e\u0527"+
		"\n\u008e\r\u008e\16\u008e\u0528\3\u008e\3\u008e\3\u008f\3\u008f\3\u008f"+
		"\3\u008f\7\u008f\u0531\n\u008f\f\u008f\16\u008f\u0534\13\u008f\3\u008f"+
		"\3\u008f\3\u0090\3\u0090\3\u0090\3\u0090\7\u0090\u053c\n\u0090\f\u0090"+
		"\16\u0090\u053f\13\u0090\3\u0090\3\u0090\3\u0090\3\u0090\3\u0090\5\u02ee"+
		"\u03a4\u053d\2\u0091\4\4\6\5\b\6\n\7\f\b\16\t\20\n\22\13\24\f\26\r\30"+
		"\16\32\17\34\20\36\21 \22\"\23$\24&\25(\26*\27,\30.\31\60\32\62\33\64"+
		"\34\66\358\36:\37< >!@\"B#D$F%H&J\'L(N)P*R+T,V-X.Z/\\\60^\61`\62b\63d"+
		"\64f\65h\66j\67l8n9p:r;t<v=x>z?|@~A\u0080B\u0082C\u0084D\u0086E\u0088"+
		"F\u008aG\u008cH\u008eI\u0090J\u0092K\u0094L\u0096M\u0098N\u009aO\u009c"+
		"P\u009eQ\u00a0R\u00a2S\u00a4T\u00a6U\u00a8V\u00aaW\u00acX\u00aeY\u00b0"+
		"Z\u00b2[\u00b4\\\u00b6]\u00b8^\u00ba_\u00bc`\u00be\2\u00c0\2\u00c2\2\u00c4"+
		"a\u00c6\2\u00c8\2\u00cab\u00ccc\u00ced\u00d0e\u00d2f\u00d4g\u00d6h\u00d8"+
		"i\u00daj\u00dck\u00del\u00e0m\u00e2n\u00e4o\u00e6p\u00e8q\u00ear\u00ec"+
		"s\u00eet\u00f0u\u00f2v\u00f4w\u00f6x\u00f8y\u00faz\u00fc{\u00fe|\u0100"+
		"}\u0102~\u0104\177\u0106\u0080\u0108\u0081\u010a\2\u010c\2\u010e\2\u0110"+
		"\u0082\u0112\u0083\u0114\u0084\u0116\u0085\u0118\2\u011a\2\u011c\u0086"+
		"\u011e\u0087\u0120\u0088\4\2\3\23\3\2$$\3\2||\4\2rruu\4\2ooww\7\2$$))"+
		"hhpptt\3\2))\4\2uuww\7\2dfkknnuuyy\4\2DDdd\3\2\62\63\3\2\62;\5\2\62;C"+
		"Hch\5\2C\\aac|\6\2\62;C\\aac|\6\2\13\f\17\17\"\"\u00a2\u00a2\4\2\f\f\17"+
		"\17\4\2--//\2\u05ce\2\4\3\2\2\2\2\6\3\2\2\2\2\b\3\2\2\2\2\n\3\2\2\2\2"+
		"\f\3\2\2\2\2\16\3\2\2\2\2\20\3\2\2\2\2\22\3\2\2\2\2\24\3\2\2\2\2\26\3"+
		"\2\2\2\2\30\3\2\2\2\2\32\3\2\2\2\2\34\3\2\2\2\2\36\3\2\2\2\2 \3\2\2\2"+
		"\2\"\3\2\2\2\2$\3\2\2\2\2&\3\2\2\2\2(\3\2\2\2\2*\3\2\2\2\2,\3\2\2\2\2"+
		".\3\2\2\2\2\60\3\2\2\2\2\62\3\2\2\2\2\64\3\2\2\2\2\66\3\2\2\2\28\3\2\2"+
		"\2\2:\3\2\2\2\2<\3\2\2\2\2>\3\2\2\2\2@\3\2\2\2\2B\3\2\2\2\2D\3\2\2\2\2"+
		"F\3\2\2\2\2H\3\2\2\2\2J\3\2\2\2\2L\3\2\2\2\2N\3\2\2\2\2P\3\2\2\2\2R\3"+
		"\2\2\2\2T\3\2\2\2\2V\3\2\2\2\2X\3\2\2\2\2Z\3\2\2\2\2\\\3\2\2\2\2^\3\2"+
		"\2\2\2`\3\2\2\2\2b\3\2\2\2\2d\3\2\2\2\2f\3\2\2\2\2h\3\2\2\2\2j\3\2\2\2"+
		"\2l\3\2\2\2\2n\3\2\2\2\2p\3\2\2\2\2r\3\2\2\2\2t\3\2\2\2\2v\3\2\2\2\2x"+
		"\3\2\2\2\2z\3\2\2\2\2|\3\2\2\2\2~\3\2\2\2\2\u0080\3\2\2\2\2\u0082\3\2"+
		"\2\2\2\u0084\3\2\2\2\2\u0086\3\2\2\2\2\u0088\3\2\2\2\2\u008a\3\2\2\2\2"+
		"\u008c\3\2\2\2\2\u008e\3\2\2\2\2\u0090\3\2\2\2\2\u0092\3\2\2\2\2\u0094"+
		"\3\2\2\2\2\u0096\3\2\2\2\2\u0098\3\2\2\2\2\u009a\3\2\2\2\2\u009c\3\2\2"+
		"\2\2\u009e\3\2\2\2\2\u00a0\3\2\2\2\2\u00a2\3\2\2\2\2\u00a4\3\2\2\2\2\u00a6"+
		"\3\2\2\2\2\u00a8\3\2\2\2\2\u00aa\3\2\2\2\2\u00ac\3\2\2\2\2\u00ae\3\2\2"+
		"\2\2\u00b0\3\2\2\2\2\u00b2\3\2\2\2\2\u00b4\3\2\2\2\2\u00b6\3\2\2\2\2\u00b8"+
		"\3\2\2\2\2\u00ba\3\2\2\2\2\u00bc\3\2\2\2\2\u00c4\3\2\2\2\2\u00ca\3\2\2"+
		"\2\2\u00cc\3\2\2\2\2\u00ce\3\2\2\2\3\u00d0\3\2\2\2\3\u00d2\3\2\2\2\3\u00d4"+
		"\3\2\2\2\3\u00d6\3\2\2\2\3\u00d8\3\2\2\2\3\u00da\3\2\2\2\3\u00dc\3\2\2"+
		"\2\3\u00de\3\2\2\2\3\u00e0\3\2\2\2\3\u00e2\3\2\2\2\3\u00e4\3\2\2\2\3\u00e6"+
		"\3\2\2\2\3\u00e8\3\2\2\2\3\u00ea\3\2\2\2\3\u00ec\3\2\2\2\3\u00ee\3\2\2"+
		"\2\3\u00f0\3\2\2\2\3\u00f2\3\2\2\2\3\u00f4\3\2\2\2\3\u00f6\3\2\2\2\3\u00f8"+
		"\3\2\2\2\3\u00fa\3\2\2\2\3\u00fc\3\2\2\2\3\u00fe\3\2\2\2\3\u0100\3\2\2"+
		"\2\3\u0102\3\2\2\2\3\u0104\3\2\2\2\3\u0106\3\2\2\2\3\u0108\3\2\2\2\3\u0110"+
		"\3\2\2\2\3\u0112\3\2\2\2\3\u0114\3\2\2\2\3\u0116\3\2\2\2\3\u011c\3\2\2"+
		"\2\3\u011e\3\2\2\2\3\u0120\3\2\2\2\4\u0122\3\2\2\2\6\u0125\3\2\2\2\b\u0127"+
		"\3\2\2\2\n\u0129\3\2\2\2\f\u012b\3\2\2\2\16\u012d\3\2\2\2\20\u012f\3\2"+
		"\2\2\22\u0131\3\2\2\2\24\u0133\3\2\2\2\26\u0135\3\2\2\2\30\u0138\3\2\2"+
		"\2\32\u013a\3\2\2\2\34\u013c\3\2\2\2\36\u013f\3\2\2\2 \u0141\3\2\2\2\""+
		"\u0143\3\2\2\2$\u0145\3\2\2\2&\u0147\3\2\2\2(\u0149\3\2\2\2*\u014c\3\2"+
		"\2\2,\u014f\3\2\2\2.\u0151\3\2\2\2\60\u0153\3\2\2\2\62\u0155\3\2\2\2\64"+
		"\u0157\3\2\2\2\66\u015a\3\2\2\28\u015d\3\2\2\2:\u0160\3\2\2\2<\u0163\3"+
		"\2\2\2>\u0165\3\2\2\2@\u0168\3\2\2\2B\u016b\3\2\2\2D\u016d\3\2\2\2F\u0170"+
		"\3\2\2\2H\u0173\3\2\2\2J\u018b\3\2\2\2L\u018d\3\2\2\2N\u0196\3\2\2\2P"+
		"\u019e\3\2\2\2R\u01a6\3\2\2\2T\u01ae\3\2\2\2V\u01b1\3\2\2\2X\u01b8\3\2"+
		"\2\2Z\u01bd\3\2\2\2\\\u01c1\3\2\2\2^\u01ca\3\2\2\2`\u01d3\3\2\2\2b\u01dc"+
		"\3\2\2\2d\u01e2\3\2\2\2f\u01e9\3\2\2\2h\u01f0\3\2\2\2j\u01f6\3\2\2\2l"+
		"\u01ff\3\2\2\2n\u0206\3\2\2\2p\u020f\3\2\2\2r\u0219\3\2\2\2t\u021c\3\2"+
		"\2\2v\u0221\3\2\2\2x\u0227\3\2\2\2z\u022a\3\2\2\2|\u022e\3\2\2\2~\u0235"+
		"\3\2\2\2\u0080\u023c\3\2\2\2\u0082\u0242\3\2\2\2\u0084\u024b\3\2\2\2\u0086"+
		"\u0251\3\2\2\2\u0088\u0259\3\2\2\2\u008a\u025e\3\2\2\2\u008c\u0265\3\2"+
		"\2\2\u008e\u026a\3\2\2\2\u0090\u0271\3\2\2\2\u0092\u0278\3\2\2\2\u0094"+
		"\u0280\3\2\2\2\u0096\u0289\3\2\2\2\u0098\u028e\3\2\2\2\u009a\u0297\3\2"+
		"\2\2\u009c\u029d\3\2\2\2\u009e\u02a4\3\2\2\2\u00a0\u02b4\3\2\2\2\u00a2"+
		"\u02db\3\2\2\2\u00a4\u02e6\3\2\2\2\u00a6\u02e8\3\2\2\2\u00a8\u02f4\3\2"+
		"\2\2\u00aa\u030c\3\2\2\2\u00ac\u0316\3\2\2\2\u00ae\u031b\3\2\2\2\u00b0"+
		"\u0322\3\2\2\2\u00b2\u0333\3\2\2\2\u00b4\u0341\3\2\2\2\u00b6\u0352\3\2"+
		"\2\2\u00b8\u0366\3\2\2\2\u00ba\u0369\3\2\2\2\u00bc\u0372\3\2\2\2\u00be"+
		"\u0379\3\2\2\2\u00c0\u037b\3\2\2\2\u00c2\u037d\3\2\2\2\u00c4\u037f\3\2"+
		"\2\2\u00c6\u0388\3\2\2\2\u00c8\u038a\3\2\2\2\u00ca\u038d\3\2\2\2\u00cc"+
		"\u0393\3\2\2\2\u00ce\u039e\3\2\2\2\u00d0\u03ac\3\2\2\2\u00d2\u0490\3\2"+
		"\2\2\u00d4\u0492\3\2\2\2\u00d6\u0494\3\2\2\2\u00d8\u0496\3\2\2\2\u00da"+
		"\u0498\3\2\2\2\u00dc\u049a\3\2\2\2\u00de\u049c\3\2\2\2\u00e0\u049e\3\2"+
		"\2\2\u00e2\u04a0\3\2\2\2\u00e4\u04a2\3\2\2\2\u00e6\u04a5\3\2\2\2\u00e8"+
		"\u04a8\3\2\2\2\u00ea\u04aa\3\2\2\2\u00ec\u04ac\3\2\2\2\u00ee\u04ae\3\2"+
		"\2\2\u00f0\u04b0\3\2\2\2\u00f2\u04b2\3\2\2\2\u00f4\u04b4\3\2\2\2\u00f6"+
		"\u04b7\3\2\2\2\u00f8\u04bc\3\2\2\2\u00fa\u04c1\3\2\2\2\u00fc\u04c3\3\2"+
		"\2\2\u00fe\u04d3\3\2\2\2\u0100\u04dc\3\2\2\2\u0102\u04ec\3\2\2\2\u0104"+
		"\u04ee\3\2\2\2\u0106\u04f5\3\2\2\2\u0108\u04f9\3\2\2\2\u010a\u04ff\3\2"+
		"\2\2\u010c\u0501\3\2\2\2\u010e\u0503\3\2\2\2\u0110\u0505\3\2\2\2\u0112"+
		"\u050d\3\2\2\2\u0114\u0513\3\2\2\2\u0116\u051a\3\2\2\2\u0118\u0521\3\2"+
		"\2\2\u011a\u0523\3\2\2\2\u011c\u0526\3\2\2\2\u011e\u052c\3\2\2\2\u0120"+
		"\u0537\3\2\2\2\u0122\u0123\7}\2\2\u0123\u0124\b\2\2\2\u0124\5\3\2\2\2"+
		"\u0125\u0126\7\177\2\2\u0126\7\3\2\2\2\u0127\u0128\7]\2\2\u0128\t\3\2"+
		"\2\2\u0129\u012a\7_\2\2\u012a\13\3\2\2\2\u012b\u012c\7*\2\2\u012c\r\3"+
		"\2\2\2\u012d\u012e\7+\2\2\u012e\17\3\2\2\2\u012f\u0130\7=\2\2\u0130\21"+
		"\3\2\2\2\u0131\u0132\7<\2\2\u0132\23\3\2\2\2\u0133\u0134\7.\2\2\u0134"+
		"\25\3\2\2\2\u0135\u0136\7\60\2\2\u0136\u0137\7\60\2\2\u0137\27\3\2\2\2"+
		"\u0138\u0139\7A\2\2\u0139\31\3\2\2\2\u013a\u013b\7\60\2\2\u013b\33\3\2"+
		"\2\2\u013c\u013d\7/\2\2\u013d\u013e\7@\2\2\u013e\35\3\2\2\2\u013f\u0140"+
		"\7-\2\2\u0140\37\3\2\2\2\u0141\u0142\7/\2\2\u0142!\3\2\2\2\u0143\u0144"+
		"\7,\2\2\u0144#\3\2\2\2\u0145\u0146\7\61\2\2\u0146%\3\2\2\2\u0147\u0148"+
		"\7\'\2\2\u0148\'\3\2\2\2\u0149\u014a\7-\2\2\u014a\u014b\7-\2\2\u014b)"+
		"\3\2\2\2\u014c\u014d\7/\2\2\u014d\u014e\7/\2\2\u014e+\3\2\2\2\u014f\u0150"+
		"\7(\2\2\u0150-\3\2\2\2\u0151\u0152\7\u0080\2\2\u0152/\3\2\2\2\u0153\u0154"+
		"\7`\2\2\u0154\61\3\2\2\2\u0155\u0156\7~\2\2\u0156\63\3\2\2\2\u0157\u0158"+
		"\7>\2\2\u0158\u0159\7>\2\2\u0159\65\3\2\2\2\u015a\u015b\7@\2\2\u015b\u015c"+
		"\7@\2\2\u015c\67\3\2\2\2\u015d\u015e\7?\2\2\u015e\u015f\7?\2\2\u015f9"+
		"\3\2\2\2\u0160\u0161\7#\2\2\u0161\u0162\7?\2\2\u0162;\3\2\2\2\u0163\u0164"+
		"\7>\2\2\u0164=\3\2\2\2\u0165\u0166\7>\2\2\u0166\u0167\7?\2\2\u0167?\3"+
		"\2\2\2\u0168\u0169\7@\2\2\u0169\u016a\7?\2\2\u016aA\3\2\2\2\u016b\u016c"+
		"\7@\2\2\u016cC\3\2\2\2\u016d\u016e\7(\2\2\u016e\u016f\7(\2\2\u016fE\3"+
		"\2\2\2\u0170\u0171\7~\2\2\u0171\u0172\7~\2\2\u0172G\3\2\2\2\u0173\u0174"+
		"\7?\2\2\u0174I\3\2\2\2\u0175\u0176\7-\2\2\u0176\u018c\7?\2\2\u0177\u0178"+
		"\7/\2\2\u0178\u018c\7?\2\2\u0179\u017a\7,\2\2\u017a\u018c\7?\2\2\u017b"+
		"\u017c\7\61\2\2\u017c\u018c\7?\2\2\u017d\u017e\7\'\2\2\u017e\u018c\7?"+
		"\2\2\u017f\u0180\7>\2\2\u0180\u0181\7>\2\2\u0181\u018c\7?\2\2\u0182\u0183"+
		"\7@\2\2\u0183\u0184\7@\2\2\u0184\u018c\7?\2\2\u0185\u0186\7(\2\2\u0186"+
		"\u018c\7?\2\2\u0187\u0188\7~\2\2\u0188\u018c\7?\2\2\u0189\u018a\7`\2\2"+
		"\u018a\u018c\7?\2\2\u018b\u0175\3\2\2\2\u018b\u0177\3\2\2\2\u018b\u0179"+
		"\3\2\2\2\u018b\u017b\3\2\2\2\u018b\u017d\3\2\2\2\u018b\u017f\3\2\2\2\u018b"+
		"\u0182\3\2\2\2\u018b\u0185\3\2\2\2\u018b\u0187\3\2\2\2\u018b\u0189\3\2"+
		"\2\2\u018cK\3\2\2\2\u018d\u018e\7k\2\2\u018e\u018f\7o\2\2\u018f\u0190"+
		"\7r\2\2\u0190\u0191\7q\2\2\u0191\u0192\7t\2\2\u0192\u0193\7v\2\2\u0193"+
		"\u0194\3\2\2\2\u0194\u0195\b&\3\2\u0195M\3\2\2\2\u0196\u0197\7v\2\2\u0197"+
		"\u0198\7{\2\2\u0198\u0199\7r\2\2\u0199\u019a\7g\2\2\u019a\u019b\7f\2\2"+
		"\u019b\u019c\7g\2\2\u019c\u019d\7h\2\2\u019dO\3\2\2\2\u019e\u019f\7%\2"+
		"\2\u019f\u01a0\7r\2\2\u01a0\u01a1\7t\2\2\u01a1\u01a2\7c\2\2\u01a2\u01a3"+
		"\7i\2\2\u01a3\u01a4\7o\2\2\u01a4\u01a5\7c\2\2\u01a5Q\3\2\2\2\u01a6\u01a7"+
		"\7t\2\2\u01a7\u01a8\7g\2\2\u01a8\u01a9\7u\2\2\u01a9\u01aa\7g\2\2\u01aa"+
		"\u01ab\7t\2\2\u01ab\u01ac\7x\2\2\u01ac\u01ad\7g\2\2\u01adS\3\2\2\2\u01ae"+
		"\u01af\7r\2\2\u01af\u01b0\7e\2\2\u01b0U\3\2\2\2\u01b1\u01b2\7v\2\2\u01b2"+
		"\u01b3\7c\2\2\u01b3\u01b4\7t\2\2\u01b4\u01b5\7i\2\2\u01b5\u01b6\7g\2\2"+
		"\u01b6\u01b7\7v\2\2\u01b7W\3\2\2\2\u01b8\u01b9\7n\2\2\u01b9\u01ba\7k\2"+
		"\2\u01ba\u01bb\7p\2\2\u01bb\u01bc\7m\2\2\u01bcY\3\2\2\2\u01bd\u01be\7"+
		"e\2\2\u01be\u01bf\7r\2\2\u01bf\u01c0\7w\2\2\u01c0[\3\2\2\2\u01c1\u01c2"+
		"\7e\2\2\u01c2\u01c3\7q\2\2\u01c3\u01c4\7f\2\2\u01c4\u01c5\7g\2\2\u01c5"+
		"\u01c6\7a\2\2\u01c6\u01c7\7u\2\2\u01c7\u01c8\7g\2\2\u01c8\u01c9\7i\2\2"+
		"\u01c9]\3\2\2\2\u01ca\u01cb\7f\2\2\u01cb\u01cc\7c\2\2\u01cc\u01cd\7v\2"+
		"\2\u01cd\u01ce\7c\2\2\u01ce\u01cf\7a\2\2\u01cf\u01d0\7u\2\2\u01d0\u01d1"+
		"\7g\2\2\u01d1\u01d2\7i\2\2\u01d2_\3\2\2\2\u01d3\u01d4\7g\2\2\u01d4\u01d5"+
		"\7p\2\2\u01d5\u01d6\7e\2\2\u01d6\u01d7\7q\2\2\u01d7\u01d8\7f\2\2\u01d8"+
		"\u01d9\7k\2\2\u01d9\u01da\7p\2\2\u01da\u01db\7i\2\2\u01dba\3\2\2\2\u01dc"+
		"\u01dd\7e\2\2\u01dd\u01de\7q\2\2\u01de\u01df\7p\2\2\u01df\u01e0\7u\2\2"+
		"\u01e0\u01e1\7v\2\2\u01e1c\3\2\2\2\u01e2\u01e3\7g\2\2\u01e3\u01e4\7z\2"+
		"\2\u01e4\u01e5\7v\2\2\u01e5\u01e6\7g\2\2\u01e6\u01e7\7t\2\2\u01e7\u01e8"+
		"\7p\2\2\u01e8e\3\2\2\2\u01e9\u01ea\7g\2\2\u01ea\u01eb\7z\2\2\u01eb\u01ec"+
		"\7r\2\2\u01ec\u01ed\7q\2\2\u01ed\u01ee\7t\2\2\u01ee\u01ef\7v\2\2\u01ef"+
		"g\3\2\2\2\u01f0\u01f1\7c\2\2\u01f1\u01f2\7n\2\2\u01f2\u01f3\7k\2\2\u01f3"+
		"\u01f4\7i\2\2\u01f4\u01f5\7p\2\2\u01f5i\3\2\2\2\u01f6\u01f7\7t\2\2\u01f7"+
		"\u01f8\7g\2\2\u01f8\u01f9\7i\2\2\u01f9\u01fa\7k\2\2\u01fa\u01fb\7u\2\2"+
		"\u01fb\u01fc\7v\2\2\u01fc\u01fd\7g\2\2\u01fd\u01fe\7t\2\2\u01fek\3\2\2"+
		"\2\u01ff\u0200\7k\2\2\u0200\u0201\7p\2\2\u0201\u0202\7n\2\2\u0202\u0203"+
		"\7k\2\2\u0203\u0204\7p\2\2\u0204\u0205\7g\2\2\u0205m\3\2\2\2\u0206\u0207"+
		"\7x\2\2\u0207\u0208\7q\2\2\u0208\u0209\7n\2\2\u0209\u020a\7c\2\2\u020a"+
		"\u020b\7v\2\2\u020b\u020c\7k\2\2\u020c\u020d\7n\2\2\u020d\u020e\7g\2\2"+
		"\u020eo\3\2\2\2\u020f\u0210\7k\2\2\u0210\u0211\7p\2\2\u0211\u0212\7v\2"+
		"\2\u0212\u0213\7g\2\2\u0213\u0214\7t\2\2\u0214\u0215\7t\2\2\u0215\u0216"+
		"\7w\2\2\u0216\u0217\7r\2\2\u0217\u0218\7v\2\2\u0218q\3\2\2\2\u0219\u021a"+
		"\7k\2\2\u021a\u021b\7h\2\2\u021bs\3\2\2\2\u021c\u021d\7g\2\2\u021d\u021e"+
		"\7n\2\2\u021e\u021f\7u\2\2\u021f\u0220\7g\2\2\u0220u\3\2\2\2\u0221\u0222"+
		"\7y\2\2\u0222\u0223\7j\2\2\u0223\u0224\7k\2\2\u0224\u0225\7n\2\2\u0225"+
		"\u0226\7g\2\2\u0226w\3\2\2\2\u0227\u0228\7f\2\2\u0228\u0229\7q\2\2\u0229"+
		"y\3\2\2\2\u022a\u022b\7h\2\2\u022b\u022c\7q\2\2\u022c\u022d\7t\2\2\u022d"+
		"{\3\2\2\2\u022e\u022f\7u\2\2\u022f\u0230\7y\2\2\u0230\u0231\7k\2\2\u0231"+
		"\u0232\7v\2\2\u0232\u0233\7e\2\2\u0233\u0234\7j\2\2\u0234}\3\2\2\2\u0235"+
		"\u0236\7t\2\2\u0236\u0237\7g\2\2\u0237\u0238\7v\2\2\u0238\u0239\7w\2\2"+
		"\u0239\u023a\7t\2\2\u023a\u023b\7p\2\2\u023b\177\3\2\2\2\u023c\u023d\7"+
		"d\2\2\u023d\u023e\7t\2\2\u023e\u023f\7g\2\2\u023f\u0240\7c\2\2\u0240\u0241"+
		"\7m\2\2\u0241\u0081\3\2\2\2\u0242\u0243\7e\2\2\u0243\u0244\7q\2\2\u0244"+
		"\u0245\7p\2\2\u0245\u0246\7v\2\2\u0246\u0247\7k\2\2\u0247\u0248\7p\2\2"+
		"\u0248\u0249\7w\2\2\u0249\u024a\7g\2\2\u024a\u0083\3\2\2\2\u024b\u024c"+
		"\7c\2\2\u024c\u024d\7u\2\2\u024d\u024e\7o\2\2\u024e\u024f\3\2\2\2\u024f"+
		"\u0250\bB\4\2\u0250\u0085\3\2\2\2\u0251\u0252\7f\2\2\u0252\u0253\7g\2"+
		"\2\u0253\u0254\7h\2\2\u0254\u0255\7c\2\2\u0255\u0256\7w\2\2\u0256\u0257"+
		"\7n\2\2\u0257\u0258\7v\2\2\u0258\u0087\3\2\2\2\u0259\u025a\7e\2\2\u025a"+
		"\u025b\7c\2\2\u025b\u025c\7u\2\2\u025c\u025d\7g\2\2\u025d\u0089\3\2\2"+
		"\2\u025e\u025f\7u\2\2\u025f\u0260\7v\2\2\u0260\u0261\7t\2\2\u0261\u0262"+
		"\7w\2\2\u0262\u0263\7e\2\2\u0263\u0264\7v\2\2\u0264\u008b\3\2\2\2\u0265"+
		"\u0266\7g\2\2\u0266\u0267\7p\2\2\u0267\u0268\7w\2\2\u0268\u0269\7o\2\2"+
		"\u0269\u008d\3\2\2\2\u026a\u026b\7u\2\2\u026b\u026c\7k\2\2\u026c\u026d"+
		"\7|\2\2\u026d\u026e\7g\2\2\u026e\u026f\7q\2\2\u026f\u0270\7h\2\2\u0270"+
		"\u008f\3\2\2\2\u0271\u0272\7v\2\2\u0272\u0273\7{\2\2\u0273\u0274\7r\2"+
		"\2\u0274\u0275\7g\2\2\u0275\u0276\7k\2\2\u0276\u0277\7f\2\2\u0277\u0091"+
		"\3\2\2\2\u0278\u0279\7m\2\2\u0279\u027a\7k\2\2\u027a\u027b\7e\2\2\u027b"+
		"\u027c\7m\2\2\u027c\u027d\7c\2\2\u027d\u027e\7u\2\2\u027e\u027f\7o\2\2"+
		"\u027f\u0093\3\2\2\2\u0280\u0281\7t\2\2\u0281\u0282\7g\2\2\u0282\u0283"+
		"\7u\2\2\u0283\u0284\7q\2\2\u0284\u0285\7w\2\2\u0285\u0286\7t\2\2\u0286"+
		"\u0287\7e\2\2\u0287\u0288\7g\2\2\u0288\u0095\3\2\2\2\u0289\u028a\7w\2"+
		"\2\u028a\u028b\7u\2\2\u028b\u028c\7g\2\2\u028c\u028d\7u\2\2\u028d\u0097"+
		"\3\2\2\2\u028e\u028f\7e\2\2\u028f\u0290\7n\2\2\u0290\u0291\7q\2\2\u0291"+
		"\u0292\7d\2\2\u0292\u0293\7d\2\2\u0293\u0294\7g\2\2\u0294\u0295\7t\2\2"+
		"\u0295\u0296\7u\2\2\u0296\u0099\3\2\2\2\u0297\u0298\7d\2\2\u0298\u0299"+
		"\7{\2\2\u0299\u029a\7v\2\2\u029a\u029b\7g\2\2\u029b\u029c\7u\2\2\u029c"+
		"\u009b\3\2\2\2\u029d\u029e\7e\2\2\u029e\u029f\7{\2\2\u029f\u02a0\7e\2"+
		"\2\u02a0\u02a1\7n\2\2\u02a1\u02a2\7g\2\2\u02a2\u02a3\7u\2\2\u02a3\u009d"+
		"\3\2\2\2\u02a4\u02a5\7#\2\2\u02a5\u009f\3\2\2\2\u02a6\u02a7\7u\2\2\u02a7"+
		"\u02a8\7k\2\2\u02a8\u02a9\7i\2\2\u02a9\u02aa\7p\2\2\u02aa\u02ab\7g\2\2"+
		"\u02ab\u02b5\7f\2\2\u02ac\u02ad\7w\2\2\u02ad\u02ae\7p\2\2\u02ae\u02af"+
		"\7u\2\2\u02af\u02b0\7k\2\2\u02b0\u02b1\7i\2\2\u02b1\u02b2\7p\2\2\u02b2"+
		"\u02b3\7g\2\2\u02b3\u02b5\7f\2\2\u02b4\u02a6\3\2\2\2\u02b4\u02ac\3\2\2"+
		"\2\u02b5\u00a1\3\2\2\2\u02b6\u02b7\7d\2\2\u02b7\u02b8\7{\2\2\u02b8\u02b9"+
		"\7v\2\2\u02b9\u02dc\7g\2\2\u02ba\u02bb\7y\2\2\u02bb\u02bc\7q\2\2\u02bc"+
		"\u02bd\7t\2\2\u02bd\u02dc\7f\2\2\u02be\u02bf\7f\2\2\u02bf\u02c0\7y\2\2"+
		"\u02c0\u02c1\7q\2\2\u02c1\u02c2\7t\2\2\u02c2\u02dc\7f\2\2\u02c3\u02c4"+
		"\7d\2\2\u02c4\u02c5\7q\2\2\u02c5\u02c6\7q\2\2\u02c6\u02dc\7n\2\2\u02c7"+
		"\u02c8\7e\2\2\u02c8\u02c9\7j\2\2\u02c9\u02ca\7c\2\2\u02ca\u02dc\7t\2\2"+
		"\u02cb\u02cc\7u\2\2\u02cc\u02cd\7j\2\2\u02cd\u02ce\7q\2\2\u02ce\u02cf"+
		"\7t\2\2\u02cf\u02dc\7v\2\2\u02d0\u02d1\7k\2\2\u02d1\u02d2\7p\2\2\u02d2"+
		"\u02dc\7v\2\2\u02d3\u02d4\7n\2\2\u02d4\u02d5\7q\2\2\u02d5\u02d6\7p\2\2"+
		"\u02d6\u02dc\7i\2\2\u02d7\u02d8\7x\2\2\u02d8\u02d9\7q\2\2\u02d9\u02da"+
		"\7k\2\2\u02da\u02dc\7f\2\2\u02db\u02b6\3\2\2\2\u02db\u02ba\3\2\2\2\u02db"+
		"\u02be\3\2\2\2\u02db\u02c3\3\2\2\2\u02db\u02c7\3\2\2\2\u02db\u02cb\3\2"+
		"\2\2\u02db\u02d0\3\2\2\2\u02db\u02d3\3\2\2\2\u02db\u02d7\3\2\2\2\u02dc"+
		"\u00a3\3\2\2\2\u02dd\u02de\7v\2\2\u02de\u02df\7t\2\2\u02df\u02e0\7w\2"+
		"\2\u02e0\u02e7\7g\2\2\u02e1\u02e2\7h\2\2\u02e2\u02e3\7c\2\2\u02e3\u02e4"+
		"\7n\2\2\u02e4\u02e5\7u\2\2\u02e5\u02e7\7g\2\2\u02e6\u02dd\3\2\2\2\u02e6"+
		"\u02e1\3\2\2\2\u02e7\u00a5\3\2\2\2\u02e8\u02e9\7}\2\2\u02e9\u02ea\7}\2"+
		"\2\u02ea\u02ee\3\2\2\2\u02eb\u02ed\13\2\2\2\u02ec\u02eb\3\2\2\2\u02ed"+
		"\u02f0\3\2\2\2\u02ee\u02ef\3\2\2\2\u02ee\u02ec\3\2\2\2\u02ef\u02f1\3\2"+
		"\2\2\u02f0\u02ee\3\2\2\2\u02f1\u02f2\7\177\2\2\u02f2\u02f3\7\177\2\2\u02f3"+
		"\u00a7\3\2\2\2\u02f4\u02fa\7$\2\2\u02f5\u02f6\7^\2\2\u02f6\u02f9\7$\2"+
		"\2\u02f7\u02f9\n\2\2\2\u02f8\u02f5\3\2\2\2\u02f8\u02f7\3\2\2\2\u02f9\u02fc"+
		"\3\2\2\2\u02fa\u02f8\3\2\2\2\u02fa\u02fb\3\2\2\2\u02fb\u02fd\3\2\2\2\u02fc"+
		"\u02fa\3\2\2\2\u02fd\u02ff\7$\2\2\u02fe\u0300\t\3\2\2\u02ff\u02fe\3\2"+
		"\2\2\u02ff\u0300\3\2\2\2\u0300\u0305\3\2\2\2\u0301\u0303\t\4\2\2\u0302"+
		"\u0304\t\5\2\2\u0303\u0302\3\2\2\2\u0303\u0304\3\2\2\2\u0304\u0306\3\2"+
		"\2\2\u0305\u0301\3\2\2\2\u0305\u0306\3\2\2\2\u0306\u0308\3\2\2\2\u0307"+
		"\u0309\t\3\2\2\u0308\u0307\3\2\2\2\u0308\u0309\3\2\2\2\u0309\u030a\3\2"+
		"\2\2\u030a\u030b\bT\5\2\u030b\u00a9\3\2\2\2\u030c\u0310\7)\2\2\u030d\u030e"+
		"\7^\2\2\u030e\u0311\t\6\2\2\u030f\u0311\n\7\2\2\u0310\u030d\3\2\2\2\u0310"+
		"\u030f\3\2\2\2\u0311\u0312\3\2\2\2\u0312\u0313\7)\2\2\u0313\u00ab\3\2"+
		"\2\2\u0314\u0317\5\u00aeW\2\u0315\u0317\5\u00b6[\2\u0316\u0314\3\2\2\2"+
		"\u0316\u0315\3\2\2\2\u0317\u00ad\3\2\2\2\u0318\u031c\5\u00b0X\2\u0319"+
		"\u031c\5\u00b2Y\2\u031a\u031c\5\u00b4Z\2\u031b\u0318\3\2\2\2\u031b\u0319"+
		"\3\2\2\2\u031b\u031a\3\2\2\2\u031c\u00af\3\2\2\2\u031d\u0323\7\'\2\2\u031e"+
		"\u031f\7\62\2\2\u031f\u0323\7d\2\2\u0320\u0321\7\62\2\2\u0321\u0323\7"+
		"D\2\2\u0322\u031d\3\2\2\2\u0322\u031e\3\2\2\2\u0322\u0320\3\2\2\2\u0323"+
		"\u0327\3\2\2\2\u0324\u0326\5\u00be_\2\u0325\u0324\3\2\2\2\u0326\u0329"+
		"\3\2\2\2\u0327\u0325\3\2\2\2\u0327\u0328\3\2\2\2\u0328\u032a\3\2\2\2\u0329"+
		"\u0327\3\2\2\2\u032a\u032c\7\60\2\2\u032b\u032d\5\u00be_\2\u032c\u032b"+
		"\3\2\2\2\u032d\u032e\3\2\2\2\u032e\u032c\3\2\2\2\u032e\u032f\3\2\2\2\u032f"+
		"\u00b1\3\2\2\2\u0330\u0332\5\u00c0`\2\u0331\u0330\3\2\2\2\u0332\u0335"+
		"\3\2\2\2\u0333\u0331\3\2\2\2\u0333\u0334\3\2\2\2\u0334\u0336\3\2\2\2\u0335"+
		"\u0333\3\2\2\2\u0336\u0338\7\60\2\2\u0337\u0339\5\u00c0`\2\u0338\u0337"+
		"\3\2\2\2\u0339\u033a\3\2\2\2\u033a\u0338\3\2\2\2\u033a\u033b\3\2\2\2\u033b"+
		"\u00b3\3\2\2\2\u033c\u0342\7&\2\2\u033d\u033e\7\62\2\2\u033e\u0342\7z"+
		"\2\2\u033f\u0340\7\62\2\2\u0340\u0342\7Z\2\2\u0341\u033c\3\2\2\2\u0341"+
		"\u033d\3\2\2\2\u0341\u033f\3\2\2\2\u0342\u0346\3\2\2\2\u0343\u0345\5\u00c2"+
		"a\2\u0344\u0343\3\2\2\2\u0345\u0348\3\2\2\2\u0346\u0344\3\2\2\2\u0346"+
		"\u0347\3\2\2\2\u0347\u0349\3\2\2\2\u0348\u0346\3\2\2\2\u0349\u034b\7\60"+
		"\2\2\u034a\u034c\5\u00c2a\2\u034b\u034a\3\2\2\2\u034c\u034d\3\2\2\2\u034d"+
		"\u034b\3\2\2\2\u034d\u034e\3\2\2\2\u034e\u00b5\3\2\2\2\u034f\u0353\5\u00ba"+
		"]\2\u0350\u0353\5\u00bc^\2\u0351\u0353\5\u00b8\\\2\u0352\u034f\3\2\2\2"+
		"\u0352\u0350\3\2\2\2\u0352\u0351\3\2\2\2\u0353\u0357\3\2\2\2\u0354\u0355"+
		"\t\b\2\2\u0355\u0358\t\t\2\2\u0356\u0358\7n\2\2\u0357\u0354\3\2\2\2\u0357"+
		"\u0356\3\2\2\2\u0357\u0358\3\2\2\2\u0358\u00b7\3\2\2\2\u0359\u035a\7\62"+
		"\2\2\u035a\u035c\t\n\2\2\u035b\u035d\5\u00be_\2\u035c\u035b\3\2\2\2\u035d"+
		"\u035e\3\2\2\2\u035e\u035c\3\2\2\2\u035e\u035f\3\2\2\2\u035f\u0367\3\2"+
		"\2\2\u0360\u0362\7\'\2\2\u0361\u0363\5\u00be_\2\u0362\u0361\3\2\2\2\u0363"+
		"\u0364\3\2\2\2\u0364\u0362\3\2\2\2\u0364\u0365\3\2\2\2\u0365\u0367\3\2"+
		"\2\2\u0366\u0359\3\2\2\2\u0366\u0360\3\2\2\2\u0367\u00b9\3\2\2\2\u0368"+
		"\u036a\5\u00c0`\2\u0369\u0368\3\2\2\2\u036a\u036b\3\2\2\2\u036b\u0369"+
		"\3\2\2\2\u036b\u036c\3\2\2\2\u036c\u00bb\3\2\2\2\u036d\u0373\7&\2\2\u036e"+
		"\u036f\7\62\2\2\u036f\u0373\7z\2\2\u0370\u0371\7\62\2\2\u0371\u0373\7"+
		"Z\2\2\u0372\u036d\3\2\2\2\u0372\u036e\3\2\2\2\u0372\u0370\3\2\2\2\u0373"+
		"\u0375\3\2\2\2\u0374\u0376\5\u00c2a\2\u0375\u0374\3\2\2\2\u0376\u0377"+
		"\3\2\2\2\u0377\u0375\3\2\2\2\u0377\u0378\3\2\2\2\u0378\u00bd\3\2\2\2\u0379"+
		"\u037a\t\13\2\2\u037a\u00bf\3\2\2\2\u037b\u037c\t\f\2\2\u037c\u00c1\3"+
		"\2\2\2\u037d\u037e\t\r\2\2\u037e\u00c3\3\2\2\2\u037f\u0383\5\u00c6c\2"+
		"\u0380\u0382\5\u00c8d\2\u0381\u0380\3\2\2\2\u0382\u0385\3\2\2\2\u0383"+
		"\u0381\3\2\2\2\u0383\u0384\3\2\2\2\u0384\u0386\3\2\2\2\u0385\u0383\3\2"+
		"\2\2\u0386\u0387\bb\6\2\u0387\u00c5\3\2\2\2\u0388\u0389\t\16\2\2\u0389"+
		"\u00c7\3\2\2\2\u038a\u038b\t\17\2\2\u038b\u00c9\3\2\2\2\u038c\u038e\t"+
		"\20\2\2\u038d\u038c\3\2\2\2\u038e\u038f\3\2\2\2\u038f\u038d\3\2\2\2\u038f"+
		"\u0390\3\2\2\2\u0390\u0391\3\2\2\2\u0391\u0392\be\7\2\u0392\u00cb\3\2"+
		"\2\2\u0393\u0394\7\61\2\2\u0394\u0395\7\61\2\2\u0395\u0399\3\2\2\2\u0396"+
		"\u0398\n\21\2\2\u0397\u0396\3\2\2\2\u0398\u039b\3\2\2\2\u0399\u0397\3"+
		"\2\2\2\u0399\u039a\3\2\2\2\u039a\u039c\3\2\2\2\u039b\u0399\3\2\2\2\u039c"+
		"\u039d\bf\b\2\u039d\u00cd\3\2\2\2\u039e\u039f\7\61\2\2\u039f\u03a0\7,"+
		"\2\2\u03a0\u03a4\3\2\2\2\u03a1\u03a3\13\2\2\2\u03a2\u03a1\3\2\2\2\u03a3"+
		"\u03a6\3\2\2\2\u03a4\u03a5\3\2\2\2\u03a4\u03a2\3\2\2\2\u03a5\u03a7\3\2"+
		"\2\2\u03a6\u03a4\3\2\2\2\u03a7\u03a8\7,\2\2\u03a8\u03a9\7\61\2\2\u03a9"+
		"\u03aa\3\2\2\2\u03aa\u03ab\bg\b\2\u03ab\u00cf\3\2\2\2\u03ac\u03ad\7\60"+
		"\2\2\u03ad\u03ae\7d\2\2\u03ae\u03af\7{\2\2\u03af\u03b0\7v\2\2\u03b0\u03b1"+
		"\7g\2\2\u03b1\u00d1\3\2\2\2\u03b2\u03b3\7d\2\2\u03b3\u03b4\7t\2\2\u03b4"+
		"\u0491\7m\2\2\u03b5\u03b6\7q\2\2\u03b6\u03b7\7t\2\2\u03b7\u0491\7c\2\2"+
		"\u03b8\u03b9\7m\2\2\u03b9\u03ba\7k\2\2\u03ba\u0491\7n\2\2\u03bb\u03bc"+
		"\7u\2\2\u03bc\u03bd\7n\2\2\u03bd\u0491\7q\2\2\u03be\u03bf\7p\2\2\u03bf"+
		"\u03c0\7q\2\2\u03c0\u0491\7r\2\2\u03c1\u03c2\7c\2\2\u03c2\u03c3\7u\2\2"+
		"\u03c3\u0491\7n\2\2\u03c4\u03c5\7r\2\2\u03c5\u03c6\7j\2\2\u03c6\u0491"+
		"\7r\2\2\u03c7\u03c8\7c\2\2\u03c8\u03c9\7p\2\2\u03c9\u0491\7e\2\2\u03ca"+
		"\u03cb\7d\2\2\u03cb\u03cc\7r\2\2\u03cc\u0491\7n\2\2\u03cd\u03ce\7e\2\2"+
		"\u03ce\u03cf\7n\2\2\u03cf\u0491\7e\2\2\u03d0\u03d1\7l\2\2\u03d1\u03d2"+
		"\7u\2\2\u03d2\u0491\7t\2\2\u03d3\u03d4\7c\2\2\u03d4\u03d5\7p\2\2\u03d5"+
		"\u0491\7f\2\2\u03d6\u03d7\7t\2\2\u03d7\u03d8\7n\2\2\u03d8\u0491\7c\2\2"+
		"\u03d9\u03da\7d\2\2\u03da\u03db\7k\2\2\u03db\u0491\7v\2\2\u03dc\u03dd"+
		"\7t\2\2\u03dd\u03de\7q\2\2\u03de\u0491\7n\2\2\u03df\u03e0\7r\2\2\u03e0"+
		"\u03e1\7n\2\2\u03e1\u0491\7c\2\2\u03e2\u03e3\7r\2\2\u03e3\u03e4\7n\2\2"+
		"\u03e4\u0491\7r\2\2\u03e5\u03e6\7d\2\2\u03e6\u03e7\7o\2\2\u03e7\u0491"+
		"\7k\2\2\u03e8\u03e9\7u\2\2\u03e9\u03ea\7g\2\2\u03ea\u0491\7e\2\2\u03eb"+
		"\u03ec\7t\2\2\u03ec\u03ed\7v\2\2\u03ed\u0491\7k\2\2\u03ee\u03ef\7g\2\2"+
		"\u03ef\u03f0\7q\2\2\u03f0\u0491\7t\2\2\u03f1\u03f2\7u\2\2\u03f2\u03f3"+
		"\7t\2\2\u03f3\u0491\7g\2\2\u03f4\u03f5\7n\2\2\u03f5\u03f6\7u\2\2\u03f6"+
		"\u0491\7t\2\2\u03f7\u03f8\7r\2\2\u03f8\u03f9\7j\2\2\u03f9\u0491\7c\2\2"+
		"\u03fa\u03fb\7c\2\2\u03fb\u03fc\7n\2\2\u03fc\u0491\7t\2\2\u03fd\u03fe"+
		"\7l\2\2\u03fe\u03ff\7o\2\2\u03ff\u0491\7r\2\2\u0400\u0401\7d\2\2\u0401"+
		"\u0402\7x\2\2\u0402\u0491\7e\2\2\u0403\u0404\7e\2\2\u0404\u0405\7n\2\2"+
		"\u0405\u0491\7k\2\2\u0406\u0407\7t\2\2\u0407\u0408\7v\2\2\u0408\u0491"+
		"\7u\2\2\u0409\u040a\7c\2\2\u040a\u040b\7f\2\2\u040b\u0491\7e\2\2\u040c"+
		"\u040d\7t\2\2\u040d\u040e\7t\2\2\u040e\u0491\7c\2\2\u040f\u0410\7d\2\2"+
		"\u0410\u0411\7x\2\2\u0411\u0491\7u\2\2\u0412\u0413\7u\2\2\u0413\u0414"+
		"\7g\2\2\u0414\u0491\7k\2\2\u0415\u0416\7u\2\2\u0416\u0417\7c\2\2\u0417"+
		"\u0491\7z\2\2\u0418\u0419\7u\2\2\u0419\u041a\7v\2\2\u041a\u0491\7{\2\2"+
		"\u041b\u041c\7u\2\2\u041c\u041d\7v\2\2\u041d\u0491\7c\2\2\u041e\u041f"+
		"\7u\2\2\u041f\u0420\7v\2\2\u0420\u0491\7z\2\2\u0421\u0422\7f\2\2\u0422"+
		"\u0423\7g\2\2\u0423\u0491\7{\2\2\u0424\u0425\7v\2\2\u0425\u0426\7z\2\2"+
		"\u0426\u0491\7c\2\2\u0427\u0428\7z\2\2\u0428\u0429\7c\2\2\u0429\u0491"+
		"\7c\2\2\u042a\u042b\7d\2\2\u042b\u042c\7e\2\2\u042c\u0491\7e\2\2\u042d"+
		"\u042e\7c\2\2\u042e\u042f\7j\2\2\u042f\u0491\7z\2\2\u0430\u0431\7v\2\2"+
		"\u0431\u0432\7{\2\2\u0432\u0491\7c\2\2\u0433\u0434\7v\2\2\u0434\u0435"+
		"\7z\2\2\u0435\u0491\7u\2\2\u0436\u0437\7v\2\2\u0437\u0438\7c\2\2\u0438"+
		"\u0491\7u\2\2\u0439\u043a\7u\2\2\u043a\u043b\7j\2\2\u043b\u0491\7{\2\2"+
		"\u043c\u043d\7u\2\2\u043d\u043e\7j\2\2\u043e\u0491\7z\2\2\u043f\u0440"+
		"\7n\2\2\u0440\u0441\7f\2\2\u0441\u0491\7{\2\2\u0442\u0443\7n\2\2\u0443"+
		"\u0444\7f\2\2\u0444\u0491\7c\2\2\u0445\u0446\7n\2\2\u0446\u0447\7f\2\2"+
		"\u0447\u0491\7z\2\2\u0448\u0449\7n\2\2\u0449\u044a\7c\2\2\u044a\u0491"+
		"\7z\2\2\u044b\u044c\7v\2\2\u044c\u044d\7c\2\2\u044d\u0491\7{\2\2\u044e"+
		"\u044f\7v\2\2\u044f\u0450\7c\2\2\u0450\u0491\7z\2\2\u0451\u0452\7d\2\2"+
		"\u0452\u0453\7e\2\2\u0453\u0491\7u\2\2\u0454\u0455\7e\2\2\u0455\u0456"+
		"\7n\2\2\u0456\u0491\7x\2\2\u0457\u0458\7v\2\2\u0458\u0459\7u\2\2\u0459"+
		"\u0491\7z\2\2\u045a\u045b\7n\2\2\u045b\u045c\7c\2\2\u045c\u0491\7u\2\2"+
		"\u045d\u045e\7e\2\2\u045e\u045f\7r\2\2\u045f\u0491\7{\2\2\u0460\u0461"+
		"\7e\2\2\u0461\u0462\7o\2\2\u0462\u0491\7r\2\2\u0463\u0464\7e\2\2\u0464"+
		"\u0465\7r\2\2\u0465\u0491\7z\2\2\u0466\u0467\7f\2\2\u0467\u0468\7e\2\2"+
		"\u0468\u0491\7r\2\2\u0469\u046a\7f\2\2\u046a\u046b\7g\2\2\u046b\u0491"+
		"\7e\2\2\u046c\u046d\7k\2\2\u046d\u046e\7p\2\2\u046e\u0491\7e\2\2\u046f"+
		"\u0470\7c\2\2\u0470\u0471\7z\2\2\u0471\u0491\7u\2\2\u0472\u0473\7d\2\2"+
		"\u0473\u0474\7p\2\2\u0474\u0491\7g\2\2\u0475\u0476\7e\2\2\u0476\u0477"+
		"\7n\2\2\u0477\u0491\7f\2\2\u0478\u0479\7u\2\2\u0479\u047a\7d\2\2\u047a"+
		"\u0491\7e\2\2\u047b\u047c\7k\2\2\u047c\u047d\7u\2\2\u047d\u0491\7e\2\2"+
		"\u047e\u047f\7k\2\2\u047f\u0480\7p\2\2\u0480\u0491\7z\2\2\u0481\u0482"+
		"\7d\2\2\u0482\u0483\7g\2\2\u0483\u0491\7s\2\2\u0484\u0485\7u\2\2\u0485"+
		"\u0486\7g\2\2\u0486\u0491\7f\2\2\u0487\u0488\7f\2\2\u0488\u0489\7g\2\2"+
		"\u0489\u0491\7z\2\2\u048a\u048b\7k\2\2\u048b\u048c\7p\2\2\u048c\u0491"+
		"\7{\2\2\u048d\u048e\7t\2\2\u048e\u048f\7q\2\2\u048f\u0491\7t\2\2\u0490"+
		"\u03b2\3\2\2\2\u0490\u03b5\3\2\2\2\u0490\u03b8\3\2\2\2\u0490\u03bb\3\2"+
		"\2\2\u0490\u03be\3\2\2\2\u0490\u03c1\3\2\2\2\u0490\u03c4\3\2\2\2\u0490"+
		"\u03c7\3\2\2\2\u0490\u03ca\3\2\2\2\u0490\u03cd\3\2\2\2\u0490\u03d0\3\2"+
		"\2\2\u0490\u03d3\3\2\2\2\u0490\u03d6\3\2\2\2\u0490\u03d9\3\2\2\2\u0490"+
		"\u03dc\3\2\2\2\u0490\u03df\3\2\2\2\u0490\u03e2\3\2\2\2\u0490\u03e5\3\2"+
		"\2\2\u0490\u03e8\3\2\2\2\u0490\u03eb\3\2\2\2\u0490\u03ee\3\2\2\2\u0490"+
		"\u03f1\3\2\2\2\u0490\u03f4\3\2\2\2\u0490\u03f7\3\2\2\2\u0490\u03fa\3\2"+
		"\2\2\u0490\u03fd\3\2\2\2\u0490\u0400\3\2\2\2\u0490\u0403\3\2\2\2\u0490"+
		"\u0406\3\2\2\2\u0490\u0409\3\2\2\2\u0490\u040c\3\2\2\2\u0490\u040f\3\2"+
		"\2\2\u0490\u0412\3\2\2\2\u0490\u0415\3\2\2\2\u0490\u0418\3\2\2\2\u0490"+
		"\u041b\3\2\2\2\u0490\u041e\3\2\2\2\u0490\u0421\3\2\2\2\u0490\u0424\3\2"+
		"\2\2\u0490\u0427\3\2\2\2\u0490\u042a\3\2\2\2\u0490\u042d\3\2\2\2\u0490"+
		"\u0430\3\2\2\2\u0490\u0433\3\2\2\2\u0490\u0436\3\2\2\2\u0490\u0439\3\2"+
		"\2\2\u0490\u043c\3\2\2\2\u0490\u043f\3\2\2\2\u0490\u0442\3\2\2\2\u0490"+
		"\u0445\3\2\2\2\u0490\u0448\3\2\2\2\u0490\u044b\3\2\2\2\u0490\u044e\3\2"+
		"\2\2\u0490\u0451\3\2\2\2\u0490\u0454\3\2\2\2\u0490\u0457\3\2\2\2\u0490"+
		"\u045a\3\2\2\2\u0490\u045d\3\2\2\2\u0490\u0460\3\2\2\2\u0490\u0463\3\2"+
		"\2\2\u0490\u0466\3\2\2\2\u0490\u0469\3\2\2\2\u0490\u046c\3\2\2\2\u0490"+
		"\u046f\3\2\2\2\u0490\u0472\3\2\2\2\u0490\u0475\3\2\2\2\u0490\u0478\3\2"+
		"\2\2\u0490\u047b\3\2\2\2\u0490\u047e\3\2\2\2\u0490\u0481\3\2\2\2\u0490"+
		"\u0484\3\2\2\2\u0490\u0487\3\2\2\2\u0490\u048a\3\2\2\2\u0490\u048d\3\2"+
		"\2\2\u0491\u00d3\3\2\2\2\u0492\u0493\7%\2\2\u0493\u00d5\3\2\2\2\u0494"+
		"\u0495\7<\2\2\u0495\u00d7\3\2\2\2\u0496\u0497\7.\2\2\u0497\u00d9\3\2\2"+
		"\2\u0498\u0499\7*\2\2\u0499\u00db\3\2\2\2\u049a\u049b\7+\2\2\u049b\u00dd"+
		"\3\2\2\2\u049c\u049d\7]\2\2\u049d\u00df\3\2\2\2\u049e\u049f\7_\2\2\u049f"+
		"\u00e1\3\2\2\2\u04a0\u04a1\7\60\2\2\u04a1\u00e3\3\2\2\2\u04a2\u04a3\7"+
		">\2\2\u04a3\u04a4\7>\2\2\u04a4\u00e5\3\2\2\2\u04a5\u04a6\7@\2\2\u04a6"+
		"\u04a7\7@\2\2\u04a7\u00e7\3\2\2\2\u04a8\u04a9\7-\2\2\u04a9\u00e9\3\2\2"+
		"\2\u04aa\u04ab\7/\2\2\u04ab\u00eb\3\2\2\2\u04ac\u04ad\7>\2\2\u04ad\u00ed"+
		"\3\2\2\2\u04ae\u04af\7@\2\2\u04af\u00ef\3\2\2\2\u04b0\u04b1\7,\2\2\u04b1"+
		"\u00f1\3\2\2\2\u04b2\u04b3\7\61\2\2\u04b3\u00f3\3\2\2\2\u04b4\u04b5\7"+
		"}\2\2\u04b5\u04b6\bz\t\2\u04b6\u00f5\3\2\2\2\u04b7\u04b8\7\177\2\2\u04b8"+
		"\u04b9\b{\n\2\u04b9\u00f7\3\2\2\2\u04ba\u04bd\5\u00fa}\2\u04bb\u04bd\5"+
		"\u0102\u0081\2\u04bc\u04ba\3\2\2\2\u04bc\u04bb\3\2\2\2\u04bd\u00f9\3\2"+
		"\2\2\u04be\u04c2\5\u00fc~\2\u04bf\u04c2\5\u00fe\177\2\u04c0\u04c2\5\u0100"+
		"\u0080\2\u04c1\u04be\3\2\2\2\u04c1\u04bf\3\2\2\2\u04c1\u04c0\3\2\2\2\u04c2"+
		"\u00fb\3\2\2\2\u04c3\u04c7\7\'\2\2\u04c4\u04c6\5\u010a\u0085\2\u04c5\u04c4"+
		"\3\2\2\2\u04c6\u04c9\3\2\2\2\u04c7\u04c5\3\2\2\2\u04c7\u04c8\3\2\2\2\u04c8"+
		"\u04ca\3\2\2\2\u04c9\u04c7\3\2\2\2\u04ca\u04cc\7\60\2\2\u04cb\u04cd\5"+
		"\u010a\u0085\2\u04cc\u04cb\3\2\2\2\u04cd\u04ce\3\2\2\2\u04ce\u04cc\3\2"+
		"\2\2\u04ce\u04cf\3\2\2\2\u04cf\u00fd\3\2\2\2\u04d0\u04d2\5\u010c\u0086"+
		"\2\u04d1\u04d0\3\2\2\2\u04d2\u04d5\3\2\2\2\u04d3\u04d1\3\2\2\2\u04d3\u04d4"+
		"\3\2\2\2\u04d4\u04d6\3\2\2\2\u04d5\u04d3\3\2\2\2\u04d6\u04d8\7\60\2\2"+
		"\u04d7\u04d9\5\u010c\u0086\2\u04d8\u04d7\3\2\2\2\u04d9\u04da\3\2\2\2\u04da"+
		"\u04d8\3\2\2\2\u04da\u04db\3\2\2\2\u04db\u00ff\3\2\2\2\u04dc\u04e0\7&"+
		"\2\2\u04dd\u04df\5\u010e\u0087\2\u04de\u04dd\3\2\2\2\u04df\u04e2\3\2\2"+
		"\2\u04e0\u04de\3\2\2\2\u04e0\u04e1\3\2\2\2\u04e1\u04e3\3\2\2\2\u04e2\u04e0"+
		"\3\2\2\2\u04e3\u04e5\7\60\2\2\u04e4\u04e6\5\u010e\u0087\2\u04e5\u04e4"+
		"\3\2\2\2\u04e6\u04e7\3\2\2\2\u04e7\u04e5\3\2\2\2\u04e7\u04e8\3\2\2\2\u04e8"+
		"\u0101\3\2\2\2\u04e9\u04ed\5\u0106\u0083\2\u04ea\u04ed\5\u0108\u0084\2"+
		"\u04eb\u04ed\5\u0104\u0082\2\u04ec\u04e9\3\2\2\2\u04ec\u04ea\3\2\2\2\u04ec"+
		"\u04eb\3\2\2\2\u04ed\u0103\3\2\2\2\u04ee\u04f0\7\'\2\2\u04ef\u04f1\5\u010a"+
		"\u0085\2\u04f0\u04ef\3\2\2\2\u04f1\u04f2\3\2\2\2\u04f2\u04f0\3\2\2\2\u04f2"+
		"\u04f3\3\2\2\2\u04f3\u0105\3\2\2\2\u04f4\u04f6\5\u010c\u0086\2\u04f5\u04f4"+
		"\3\2\2\2\u04f6\u04f7\3\2\2\2\u04f7\u04f5\3\2\2\2\u04f7\u04f8\3\2\2\2\u04f8"+
		"\u0107\3\2\2\2\u04f9\u04fb\7&\2\2\u04fa\u04fc\5\u010e\u0087\2\u04fb\u04fa"+
		"\3\2\2\2\u04fc\u04fd\3\2\2\2\u04fd\u04fb\3\2\2\2\u04fd\u04fe\3\2\2\2\u04fe"+
		"\u0109\3\2\2\2\u04ff\u0500\t\13\2\2\u0500\u010b\3\2\2\2\u0501\u0502\t"+
		"\f\2\2\u0502\u010d\3\2\2\2\u0503\u0504\t\r\2\2\u0504\u010f\3\2\2\2\u0505"+
		"\u0509\7)\2\2\u0506\u0507\7^\2\2\u0507\u050a\t\6\2\2\u0508\u050a\n\7\2"+
		"\2\u0509\u0506\3\2\2\2\u0509\u0508\3\2\2\2\u050a\u050b\3\2\2\2\u050b\u050c"+
		"\7)\2\2\u050c\u0111\3\2\2\2\u050d\u050f\5\u0114\u008a\2\u050e\u0510\t"+
		"\22\2\2\u050f\u050e\3\2\2\2\u0510\u0511\3\2\2\2\u0511\u050f\3\2\2\2\u0511"+
		"\u0512\3\2\2\2\u0512\u0113\3\2\2\2\u0513\u0517\7#\2\2\u0514\u0516\5\u011a"+
		"\u008d\2\u0515\u0514\3\2\2\2\u0516\u0519\3\2\2\2\u0517\u0515\3\2\2\2\u0517"+
		"\u0518\3\2\2\2\u0518\u0115\3\2\2\2\u0519\u0517\3\2\2\2\u051a\u051e\5\u0118"+
		"\u008c\2\u051b\u051d\5\u011a\u008d\2\u051c\u051b\3\2\2\2\u051d\u0520\3"+
		"\2\2\2\u051e\u051c\3\2\2\2\u051e\u051f\3\2\2\2\u051f\u0117\3\2\2\2\u0520"+
		"\u051e\3\2\2\2\u0521\u0522\t\16\2\2\u0522\u0119\3\2\2\2\u0523\u0524\t"+
		"\17\2\2\u0524\u011b\3\2\2\2\u0525\u0527\t\20\2\2\u0526\u0525\3\2\2\2\u0527"+
		"\u0528\3\2\2\2\u0528\u0526\3\2\2\2\u0528\u0529\3\2\2\2\u0529\u052a\3\2"+
		"\2\2\u052a\u052b\b\u008e\7\2\u052b\u011d\3\2\2\2\u052c\u052d\7\61\2\2"+
		"\u052d\u052e\7\61\2\2\u052e\u0532\3\2\2\2\u052f\u0531\n\21\2\2\u0530\u052f"+
		"\3\2\2\2\u0531\u0534\3\2\2\2\u0532\u0530\3\2\2\2\u0532\u0533\3\2\2\2\u0533"+
		"\u0535\3\2\2\2\u0534\u0532\3\2\2\2\u0535\u0536\b\u008f\b\2\u0536\u011f"+
		"\3\2\2\2\u0537\u0538\7\61\2\2\u0538\u0539\7,\2\2\u0539\u053d\3\2\2\2\u053a"+
		"\u053c\13\2\2\2\u053b\u053a\3\2\2\2\u053c\u053f\3\2\2\2\u053d\u053e\3"+
		"\2\2\2\u053d\u053b\3\2\2\2\u053e\u0540\3\2\2\2\u053f\u053d\3\2\2\2\u0540"+
		"\u0541\7,\2\2\u0541\u0542\7\61\2\2\u0542\u0543\3\2\2\2\u0543\u0544\b\u0090"+
		"\b\2\u0544\u0121\3\2\2\2:\2\3\u018b\u02b4\u02db\u02e6\u02ee\u02f8\u02fa"+
		"\u02ff\u0303\u0305\u0308\u0310\u0316\u031b\u0322\u0327\u032e\u0333\u033a"+
		"\u0341\u0346\u034d\u0352\u0357\u035e\u0364\u0366\u036b\u0372\u0377\u0383"+
		"\u038f\u0399\u03a4\u0490\u04bc\u04c1\u04c7\u04ce\u04d3\u04da\u04e0\u04e7"+
		"\u04ec\u04f2\u04f7\u04fd\u0509\u0511\u0517\u051e\u0528\u0532\u053d\13"+
		"\3\2\2\3&\3\3B\4\3T\5\3b\6\2\3\2\2\4\2\3z\7\3{\b";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}
// Generated from C:/c64/kickc/src/main/java/dk/camelot64/kickc/parser\KickCLexer.g4 by ANTLR 4.7.2
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
	static { RuntimeMetaData.checkVersion("4.7.2", RuntimeMetaData.VERSION); }

	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		TYPEDEFNAME=1, CURLY_BEGIN=2, CURLY_END=3, BRACKET_BEGIN=4, BRACKET_END=5, 
		PAR_BEGIN=6, PAR_END=7, SEMICOLON=8, COLON=9, COMMA=10, RANGE=11, PARAM_LIST=12, 
		CONDITION=13, DOT=14, ARROW=15, PLUS=16, MINUS=17, ASTERISK=18, DIVIDE=19, 
		MODULO=20, INC=21, DEC=22, AND=23, BIT_NOT=24, BIT_XOR=25, BIT_OR=26, 
		SHIFT_LEFT=27, SHIFT_RIGHT=28, EQUAL=29, NOT_EQUAL=30, LESS_THAN=31, LESS_THAN_EQUAL=32, 
		GREATER_THAN_EQUAL=33, GREATER_THAN=34, LOGIC_AND=35, LOGIC_OR=36, ASSIGN=37, 
		ASSIGN_COMPOUND=38, TYPEDEF=39, RESERVE=40, PC=41, TARGET=42, LINK=43, 
		EXTENSION=44, EMULATOR=45, CPU=46, CODESEG=47, DATASEG=48, ENCODING=49, 
		CONST=50, EXTERN=51, EXPORT=52, ALIGN=53, INLINE=54, VOLATILE=55, STATIC=56, 
		INTERRUPT=57, REGISTER=58, LOCAL_RESERVE=59, ADDRESS=60, ADDRESS_ZEROPAGE=61, 
		ADDRESS_MAINMEM=62, FORM_SSA=63, FORM_MA=64, INTRINSIC=65, CALLING=66, 
		CALLINGCONVENTION=67, VARMODEL=68, IF=69, ELSE=70, WHILE=71, DO=72, FOR=73, 
		SWITCH=74, RETURN=75, BREAK=76, CONTINUE=77, ASM=78, DEFAULT=79, CASE=80, 
		STRUCT=81, ENUM=82, SIZEOF=83, TYPEID=84, DEFINED=85, KICKASM=86, RESOURCE=87, 
		USES=88, CLOBBERS=89, BYTES=90, CYCLES=91, LOGIC_NOT=92, SIGNEDNESS=93, 
		SIMPLETYPE=94, BOOLEAN=95, KICKASM_BODY=96, IMPORT=97, INCLUDE=98, PRAGMA=99, 
		DEFINE=100, DEFINE_CONTINUE=101, UNDEF=102, IFDEF=103, IFNDEF=104, IFIF=105, 
		ELIF=106, IFELSE=107, ENDIF=108, ERROR=109, NUMBER=110, NUMFLOAT=111, 
		BINFLOAT=112, DECFLOAT=113, HEXFLOAT=114, NUMINT=115, BININTEGER=116, 
		DECINTEGER=117, HEXINTEGER=118, NAME=119, STRING=120, CHAR=121, WS=122, 
		COMMENT_LINE=123, COMMENT_BLOCK=124, ASM_BYTE=125, ASM_MNEMONIC=126, ASM_IMM=127, 
		ASM_COLON=128, ASM_COMMA=129, ASM_PAR_BEGIN=130, ASM_PAR_END=131, ASM_BRACKET_BEGIN=132, 
		ASM_BRACKET_END=133, ASM_DOT=134, ASM_SHIFT_LEFT=135, ASM_SHIFT_RIGHT=136, 
		ASM_PLUS=137, ASM_MINUS=138, ASM_LESS_THAN=139, ASM_GREATER_THAN=140, 
		ASM_MULTIPLY=141, ASM_DIVIDE=142, ASM_CURLY_BEGIN=143, ASM_CURLY_END=144, 
		ASM_NUMBER=145, ASM_NUMFLOAT=146, ASM_BINFLOAT=147, ASM_DECFLOAT=148, 
		ASM_HEXFLOAT=149, ASM_NUMINT=150, ASM_BININTEGER=151, ASM_DECINTEGER=152, 
		ASM_HEXINTEGER=153, ASM_CHAR=154, ASM_MULTI_REL=155, ASM_MULTI_NAME=156, 
		ASM_NAME=157, ASM_WS=158, ASM_COMMENT_LINE=159, ASM_COMMENT_BLOCK=160, 
		IMPORT_SYSTEMFILE=161, IMPORT_LOCALFILE=162, IMPORT_WS=163, IMPORT_COMMENT_LINE=164, 
		IMPORT_COMMENT_BLOCK=165;
	public static final int
		ASM_MODE=1, IMPORT_MODE=2;
	public static String[] channelNames = {
		"DEFAULT_TOKEN_CHANNEL", "HIDDEN"
	};

	public static String[] modeNames = {
		"DEFAULT_MODE", "ASM_MODE", "IMPORT_MODE"
	};

	private static String[] makeRuleNames() {
		return new String[] {
			"CURLY_BEGIN", "CURLY_END", "BRACKET_BEGIN", "BRACKET_END", "PAR_BEGIN", 
			"PAR_END", "SEMICOLON", "COLON", "COMMA", "RANGE", "PARAM_LIST", "CONDITION", 
			"DOT", "ARROW", "PLUS", "MINUS", "ASTERISK", "DIVIDE", "MODULO", "INC", 
			"DEC", "AND", "BIT_NOT", "BIT_XOR", "BIT_OR", "SHIFT_LEFT", "SHIFT_RIGHT", 
			"EQUAL", "NOT_EQUAL", "LESS_THAN", "LESS_THAN_EQUAL", "GREATER_THAN_EQUAL", 
			"GREATER_THAN", "LOGIC_AND", "LOGIC_OR", "ASSIGN", "ASSIGN_COMPOUND", 
			"TYPEDEF", "RESERVE", "PC", "TARGET", "LINK", "EXTENSION", "EMULATOR", 
			"CPU", "CODESEG", "DATASEG", "ENCODING", "CONST", "EXTERN", "EXPORT", 
			"ALIGN", "INLINE", "VOLATILE", "STATIC", "INTERRUPT", "REGISTER", "LOCAL_RESERVE", 
			"ADDRESS", "ADDRESS_ZEROPAGE", "ADDRESS_MAINMEM", "FORM_SSA", "FORM_MA", 
			"INTRINSIC", "CALLING", "CALLINGCONVENTION", "VARMODEL", "IF", "ELSE", 
			"WHILE", "DO", "FOR", "SWITCH", "RETURN", "BREAK", "CONTINUE", "ASM", 
			"DEFAULT", "CASE", "STRUCT", "ENUM", "SIZEOF", "TYPEID", "DEFINED", "KICKASM", 
			"RESOURCE", "USES", "CLOBBERS", "BYTES", "CYCLES", "LOGIC_NOT", "SIGNEDNESS", 
			"SIMPLETYPE", "BOOLEAN", "KICKASM_BODY", "IMPORT", "INCLUDE", "PRAGMA", 
			"DEFINE", "DEFINE_CONTINUE", "UNDEF", "IFDEF", "IFNDEF", "IFIF", "ELIF", 
			"IFELSE", "ENDIF", "ERROR", "NUMBER", "NUMFLOAT", "BINFLOAT", "DECFLOAT", 
			"HEXFLOAT", "NUMINT", "BININTEGER", "DECINTEGER", "HEXINTEGER", "BINDIGIT", 
			"DECDIGIT", "HEXDIGIT", "NAME", "NAME_START", "NAME_CHAR", "STRING", 
			"CHAR", "WS", "COMMENT_LINE", "COMMENT_BLOCK", "ASM_BYTE", "ASM_MNEMONIC", 
			"ASM_IMM", "ASM_COLON", "ASM_COMMA", "ASM_PAR_BEGIN", "ASM_PAR_END", 
			"ASM_BRACKET_BEGIN", "ASM_BRACKET_END", "ASM_DOT", "ASM_SHIFT_LEFT", 
			"ASM_SHIFT_RIGHT", "ASM_PLUS", "ASM_MINUS", "ASM_LESS_THAN", "ASM_GREATER_THAN", 
			"ASM_MULTIPLY", "ASM_DIVIDE", "ASM_CURLY_BEGIN", "ASM_CURLY_END", "ASM_NUMBER", 
			"ASM_NUMFLOAT", "ASM_BINFLOAT", "ASM_DECFLOAT", "ASM_HEXFLOAT", "ASM_NUMINT", 
			"ASM_BININTEGER", "ASM_DECINTEGER", "ASM_HEXINTEGER", "ASM_BINDIGIT", 
			"ASM_DECDIGIT", "ASM_HEXDIGIT", "ASM_CHAR", "ASM_MULTI_REL", "ASM_MULTI_NAME", 
			"ASM_NAME", "ASM_NAME_START", "ASM_NAME_CHAR", "ASM_WS", "ASM_COMMENT_LINE", 
			"ASM_COMMENT_BLOCK", "IMPORT_SYSTEMFILE", "IMPORT_LOCALFILE", "IMPORT_WS", 
			"IMPORT_COMMENT_LINE", "IMPORT_COMMENT_BLOCK"
		};
	}
	public static final String[] ruleNames = makeRuleNames();

	private static String[] makeLiteralNames() {
		return new String[] {
			null, null, null, null, null, null, null, null, "';'", null, null, "'..'", 
			"'...'", "'?'", null, "'->'", null, null, null, null, "'%'", "'++'", 
			"'--'", "'&'", "'~'", "'^'", "'|'", null, null, "'=='", "'!='", null, 
			"'<='", "'>='", null, "'&&'", "'||'", "'='", null, "'typedef'", "'zp_reserve'", 
			"'pc'", "'target'", "'link'", "'extension'", "'emulator'", "'cpu'", "'code_seg'", 
			"'data_seg'", "'encoding'", "'const'", "'extern'", "'export'", "'align'", 
			"'inline'", "'volatile'", "'static'", "'interrupt'", "'register'", "'__zp_reserve'", 
			"'__address'", "'__zp'", "'__mem'", "'__ssa'", "'__ma'", "'__intrinsic'", 
			"'calling'", null, "'var_model'", "'if'", "'else'", "'while'", "'do'", 
			"'for'", "'switch'", "'return'", "'break'", "'continue'", "'asm'", "'default'", 
			"'case'", "'struct'", "'enum'", "'sizeof'", "'typeid'", "'defined'", 
			"'kickasm'", "'resource'", "'uses'", "'clobbers'", "'bytes'", "'cycles'", 
			"'!'", null, null, null, null, "'#import'", "'#include'", "'#pragma'", 
			"'#define'", null, "'#undef'", "'#ifdef'", "'#ifndef'", "'#if'", "'#elif'", 
			"'#else'", "'#endif'", "'#error'", null, null, null, null, null, null, 
			null, null, null, null, null, null, null, null, null, "'.byte'", null, 
			"'#'"
		};
	}
	private static final String[] _LITERAL_NAMES = makeLiteralNames();
	private static String[] makeSymbolicNames() {
		return new String[] {
			null, "TYPEDEFNAME", "CURLY_BEGIN", "CURLY_END", "BRACKET_BEGIN", "BRACKET_END", 
			"PAR_BEGIN", "PAR_END", "SEMICOLON", "COLON", "COMMA", "RANGE", "PARAM_LIST", 
			"CONDITION", "DOT", "ARROW", "PLUS", "MINUS", "ASTERISK", "DIVIDE", "MODULO", 
			"INC", "DEC", "AND", "BIT_NOT", "BIT_XOR", "BIT_OR", "SHIFT_LEFT", "SHIFT_RIGHT", 
			"EQUAL", "NOT_EQUAL", "LESS_THAN", "LESS_THAN_EQUAL", "GREATER_THAN_EQUAL", 
			"GREATER_THAN", "LOGIC_AND", "LOGIC_OR", "ASSIGN", "ASSIGN_COMPOUND", 
			"TYPEDEF", "RESERVE", "PC", "TARGET", "LINK", "EXTENSION", "EMULATOR", 
			"CPU", "CODESEG", "DATASEG", "ENCODING", "CONST", "EXTERN", "EXPORT", 
			"ALIGN", "INLINE", "VOLATILE", "STATIC", "INTERRUPT", "REGISTER", "LOCAL_RESERVE", 
			"ADDRESS", "ADDRESS_ZEROPAGE", "ADDRESS_MAINMEM", "FORM_SSA", "FORM_MA", 
			"INTRINSIC", "CALLING", "CALLINGCONVENTION", "VARMODEL", "IF", "ELSE", 
			"WHILE", "DO", "FOR", "SWITCH", "RETURN", "BREAK", "CONTINUE", "ASM", 
			"DEFAULT", "CASE", "STRUCT", "ENUM", "SIZEOF", "TYPEID", "DEFINED", "KICKASM", 
			"RESOURCE", "USES", "CLOBBERS", "BYTES", "CYCLES", "LOGIC_NOT", "SIGNEDNESS", 
			"SIMPLETYPE", "BOOLEAN", "KICKASM_BODY", "IMPORT", "INCLUDE", "PRAGMA", 
			"DEFINE", "DEFINE_CONTINUE", "UNDEF", "IFDEF", "IFNDEF", "IFIF", "ELIF", 
			"IFELSE", "ENDIF", "ERROR", "NUMBER", "NUMFLOAT", "BINFLOAT", "DECFLOAT", 
			"HEXFLOAT", "NUMINT", "BININTEGER", "DECINTEGER", "HEXINTEGER", "NAME", 
			"STRING", "CHAR", "WS", "COMMENT_LINE", "COMMENT_BLOCK", "ASM_BYTE", 
			"ASM_MNEMONIC", "ASM_IMM", "ASM_COLON", "ASM_COMMA", "ASM_PAR_BEGIN", 
			"ASM_PAR_END", "ASM_BRACKET_BEGIN", "ASM_BRACKET_END", "ASM_DOT", "ASM_SHIFT_LEFT", 
			"ASM_SHIFT_RIGHT", "ASM_PLUS", "ASM_MINUS", "ASM_LESS_THAN", "ASM_GREATER_THAN", 
			"ASM_MULTIPLY", "ASM_DIVIDE", "ASM_CURLY_BEGIN", "ASM_CURLY_END", "ASM_NUMBER", 
			"ASM_NUMFLOAT", "ASM_BINFLOAT", "ASM_DECFLOAT", "ASM_HEXFLOAT", "ASM_NUMINT", 
			"ASM_BININTEGER", "ASM_DECINTEGER", "ASM_HEXINTEGER", "ASM_CHAR", "ASM_MULTI_REL", 
			"ASM_MULTI_NAME", "ASM_NAME", "ASM_WS", "ASM_COMMENT_LINE", "ASM_COMMENT_BLOCK", 
			"IMPORT_SYSTEMFILE", "IMPORT_LOCALFILE", "IMPORT_WS", "IMPORT_COMMENT_LINE", 
			"IMPORT_COMMENT_BLOCK"
		};
	}
	private static final String[] _SYMBOLIC_NAMES = makeSymbolicNames();
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
		case 76:
			ASM_action((RuleContext)_localctx, actionIndex);
			break;
		case 95:
			IMPORT_action((RuleContext)_localctx, actionIndex);
			break;
		case 96:
			INCLUDE_action((RuleContext)_localctx, actionIndex);
			break;
		case 120:
			NAME_action((RuleContext)_localctx, actionIndex);
			break;
		case 146:
			ASM_CURLY_BEGIN_action((RuleContext)_localctx, actionIndex);
			break;
		case 147:
			ASM_CURLY_END_action((RuleContext)_localctx, actionIndex);
			break;
		case 169:
			IMPORT_SYSTEMFILE_action((RuleContext)_localctx, actionIndex);
			break;
		case 170:
			IMPORT_LOCALFILE_action((RuleContext)_localctx, actionIndex);
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
	private void ASM_action(RuleContext _localctx, int actionIndex) {
		switch (actionIndex) {
		case 1:
			 asmEnter=true; 
			break;
		}
	}
	private void IMPORT_action(RuleContext _localctx, int actionIndex) {
		switch (actionIndex) {
		case 2:
			 pushMode(IMPORT_MODE);  
			break;
		}
	}
	private void INCLUDE_action(RuleContext _localctx, int actionIndex) {
		switch (actionIndex) {
		case 3:
			 pushMode(IMPORT_MODE); 
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
	private void IMPORT_SYSTEMFILE_action(RuleContext _localctx, int actionIndex) {
		switch (actionIndex) {
		case 7:
			 popMode(); 
			break;
		}
	}
	private void IMPORT_LOCALFILE_action(RuleContext _localctx, int actionIndex) {
		switch (actionIndex) {
		case 8:
			 popMode(); 
			break;
		}
	}

	public static final String _serializedATN =
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\2\u00a7\u0695\b\1\b"+
		"\1\b\1\4\2\t\2\4\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t"+
		"\4\n\t\n\4\13\t\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\4\20\t\20\4\21"+
		"\t\21\4\22\t\22\4\23\t\23\4\24\t\24\4\25\t\25\4\26\t\26\4\27\t\27\4\30"+
		"\t\30\4\31\t\31\4\32\t\32\4\33\t\33\4\34\t\34\4\35\t\35\4\36\t\36\4\37"+
		"\t\37\4 \t \4!\t!\4\"\t\"\4#\t#\4$\t$\4%\t%\4&\t&\4\'\t\'\4(\t(\4)\t)"+
		"\4*\t*\4+\t+\4,\t,\4-\t-\4.\t.\4/\t/\4\60\t\60\4\61\t\61\4\62\t\62\4\63"+
		"\t\63\4\64\t\64\4\65\t\65\4\66\t\66\4\67\t\67\48\t8\49\t9\4:\t:\4;\t;"+
		"\4<\t<\4=\t=\4>\t>\4?\t?\4@\t@\4A\tA\4B\tB\4C\tC\4D\tD\4E\tE\4F\tF\4G"+
		"\tG\4H\tH\4I\tI\4J\tJ\4K\tK\4L\tL\4M\tM\4N\tN\4O\tO\4P\tP\4Q\tQ\4R\tR"+
		"\4S\tS\4T\tT\4U\tU\4V\tV\4W\tW\4X\tX\4Y\tY\4Z\tZ\4[\t[\4\\\t\\\4]\t]\4"+
		"^\t^\4_\t_\4`\t`\4a\ta\4b\tb\4c\tc\4d\td\4e\te\4f\tf\4g\tg\4h\th\4i\t"+
		"i\4j\tj\4k\tk\4l\tl\4m\tm\4n\tn\4o\to\4p\tp\4q\tq\4r\tr\4s\ts\4t\tt\4"+
		"u\tu\4v\tv\4w\tw\4x\tx\4y\ty\4z\tz\4{\t{\4|\t|\4}\t}\4~\t~\4\177\t\177"+
		"\4\u0080\t\u0080\4\u0081\t\u0081\4\u0082\t\u0082\4\u0083\t\u0083\4\u0084"+
		"\t\u0084\4\u0085\t\u0085\4\u0086\t\u0086\4\u0087\t\u0087\4\u0088\t\u0088"+
		"\4\u0089\t\u0089\4\u008a\t\u008a\4\u008b\t\u008b\4\u008c\t\u008c\4\u008d"+
		"\t\u008d\4\u008e\t\u008e\4\u008f\t\u008f\4\u0090\t\u0090\4\u0091\t\u0091"+
		"\4\u0092\t\u0092\4\u0093\t\u0093\4\u0094\t\u0094\4\u0095\t\u0095\4\u0096"+
		"\t\u0096\4\u0097\t\u0097\4\u0098\t\u0098\4\u0099\t\u0099\4\u009a\t\u009a"+
		"\4\u009b\t\u009b\4\u009c\t\u009c\4\u009d\t\u009d\4\u009e\t\u009e\4\u009f"+
		"\t\u009f\4\u00a0\t\u00a0\4\u00a1\t\u00a1\4\u00a2\t\u00a2\4\u00a3\t\u00a3"+
		"\4\u00a4\t\u00a4\4\u00a5\t\u00a5\4\u00a6\t\u00a6\4\u00a7\t\u00a7\4\u00a8"+
		"\t\u00a8\4\u00a9\t\u00a9\4\u00aa\t\u00aa\4\u00ab\t\u00ab\4\u00ac\t\u00ac"+
		"\4\u00ad\t\u00ad\4\u00ae\t\u00ae\4\u00af\t\u00af\3\2\3\2\3\2\3\3\3\3\3"+
		"\4\3\4\3\5\3\5\3\6\3\6\3\7\3\7\3\b\3\b\3\t\3\t\3\n\3\n\3\13\3\13\3\13"+
		"\3\f\3\f\3\f\3\f\3\r\3\r\3\16\3\16\3\17\3\17\3\17\3\20\3\20\3\21\3\21"+
		"\3\22\3\22\3\23\3\23\3\24\3\24\3\25\3\25\3\25\3\26\3\26\3\26\3\27\3\27"+
		"\3\30\3\30\3\31\3\31\3\32\3\32\3\33\3\33\3\33\3\34\3\34\3\34\3\35\3\35"+
		"\3\35\3\36\3\36\3\36\3\37\3\37\3 \3 \3 \3!\3!\3!\3\"\3\"\3#\3#\3#\3$\3"+
		"$\3$\3%\3%\3&\3&\3&\3&\3&\3&\3&\3&\3&\3&\3&\3&\3&\3&\3&\3&\3&\3&\3&\3"+
		"&\3&\3&\5&\u01cf\n&\3\'\3\'\3\'\3\'\3\'\3\'\3\'\3\'\3(\3(\3(\3(\3(\3("+
		"\3(\3(\3(\3(\3(\3)\3)\3)\3*\3*\3*\3*\3*\3*\3*\3+\3+\3+\3+\3+\3,\3,\3,"+
		"\3,\3,\3,\3,\3,\3,\3,\3-\3-\3-\3-\3-\3-\3-\3-\3-\3.\3.\3.\3.\3/\3/\3/"+
		"\3/\3/\3/\3/\3/\3/\3\60\3\60\3\60\3\60\3\60\3\60\3\60\3\60\3\60\3\61\3"+
		"\61\3\61\3\61\3\61\3\61\3\61\3\61\3\61\3\62\3\62\3\62\3\62\3\62\3\62\3"+
		"\63\3\63\3\63\3\63\3\63\3\63\3\63\3\64\3\64\3\64\3\64\3\64\3\64\3\64\3"+
		"\65\3\65\3\65\3\65\3\65\3\65\3\66\3\66\3\66\3\66\3\66\3\66\3\66\3\67\3"+
		"\67\3\67\3\67\3\67\3\67\3\67\3\67\3\67\38\38\38\38\38\38\38\39\39\39\3"+
		"9\39\39\39\39\39\39\3:\3:\3:\3:\3:\3:\3:\3:\3:\3;\3;\3;\3;\3;\3;\3;\3"+
		";\3;\3;\3;\3;\3;\3<\3<\3<\3<\3<\3<\3<\3<\3<\3<\3=\3=\3=\3=\3=\3>\3>\3"+
		">\3>\3>\3>\3?\3?\3?\3?\3?\3?\3@\3@\3@\3@\3@\3A\3A\3A\3A\3A\3A\3A\3A\3"+
		"A\3A\3A\3A\3B\3B\3B\3B\3B\3B\3B\3B\3C\3C\3C\3C\3C\3C\3C\3C\3C\3C\3C\3"+
		"C\3C\3C\3C\3C\3C\3C\3C\3C\5C\u02be\nC\3D\3D\3D\3D\3D\3D\3D\3D\3D\3D\3"+
		"E\3E\3E\3F\3F\3F\3F\3F\3G\3G\3G\3G\3G\3G\3H\3H\3H\3I\3I\3I\3I\3J\3J\3"+
		"J\3J\3J\3J\3J\3K\3K\3K\3K\3K\3K\3K\3L\3L\3L\3L\3L\3L\3M\3M\3M\3M\3M\3"+
		"M\3M\3M\3M\3N\3N\3N\3N\3N\3N\3O\3O\3O\3O\3O\3O\3O\3O\3P\3P\3P\3P\3P\3"+
		"Q\3Q\3Q\3Q\3Q\3Q\3Q\3R\3R\3R\3R\3R\3S\3S\3S\3S\3S\3S\3S\3T\3T\3T\3T\3"+
		"T\3T\3T\3U\3U\3U\3U\3U\3U\3U\3U\3V\3V\3V\3V\3V\3V\3V\3V\3W\3W\3W\3W\3"+
		"W\3W\3W\3W\3W\3X\3X\3X\3X\3X\3Y\3Y\3Y\3Y\3Y\3Y\3Y\3Y\3Y\3Z\3Z\3Z\3Z\3"+
		"Z\3Z\3[\3[\3[\3[\3[\3[\3[\3\\\3\\\3]\3]\3]\3]\3]\3]\3]\3]\3]\3]\3]\3]"+
		"\3]\3]\5]\u036d\n]\3^\3^\3^\3^\3^\3^\3^\3^\3^\3^\3^\3^\3^\3^\3^\3^\3^"+
		"\3^\3^\3^\3^\3^\3^\3^\3^\3^\3^\3^\3^\3^\3^\3^\3^\3^\3^\3^\3^\5^\u0394"+
		"\n^\3_\3_\3_\3_\3_\3_\3_\3_\3_\5_\u039f\n_\3`\3`\3`\3`\7`\u03a5\n`\f`"+
		"\16`\u03a8\13`\3`\3`\3`\3a\3a\3a\3a\3a\3a\3a\3a\3a\3a\3b\3b\3b\3b\3b\3"+
		"b\3b\3b\3b\3b\3b\3c\3c\3c\3c\3c\3c\3c\3c\3d\3d\3d\3d\3d\3d\3d\3d\3e\3"+
		"e\3e\3e\3e\5e\u03d7\ne\3f\3f\3f\3f\3f\3f\3f\3g\3g\3g\3g\3g\3g\3g\3h\3"+
		"h\3h\3h\3h\3h\3h\3h\3i\3i\3i\3i\3j\3j\3j\3j\3j\3j\3k\3k\3k\3k\3k\3k\3"+
		"l\3l\3l\3l\3l\3l\3l\3m\3m\3m\3m\3m\3m\3m\3n\3n\5n\u040f\nn\3o\3o\3o\5"+
		"o\u0414\no\3p\3p\3p\3p\3p\5p\u041b\np\3p\7p\u041e\np\fp\16p\u0421\13p"+
		"\3p\3p\6p\u0425\np\rp\16p\u0426\3q\7q\u042a\nq\fq\16q\u042d\13q\3q\3q"+
		"\6q\u0431\nq\rq\16q\u0432\3r\3r\3r\3r\3r\5r\u043a\nr\3r\7r\u043d\nr\f"+
		"r\16r\u0440\13r\3r\3r\6r\u0444\nr\rr\16r\u0445\3s\3s\3s\5s\u044b\ns\3"+
		"s\3s\3s\5s\u0450\ns\3t\3t\3t\6t\u0455\nt\rt\16t\u0456\3t\3t\6t\u045b\n"+
		"t\rt\16t\u045c\5t\u045f\nt\3u\6u\u0462\nu\ru\16u\u0463\3v\3v\3v\3v\3v"+
		"\5v\u046b\nv\3v\6v\u046e\nv\rv\16v\u046f\3w\3w\3x\3x\3y\3y\3z\3z\7z\u047a"+
		"\nz\fz\16z\u047d\13z\3z\3z\3{\3{\3|\3|\3}\3}\3}\3}\7}\u0489\n}\f}\16}"+
		"\u048c\13}\3}\3}\5}\u0490\n}\3}\3}\5}\u0494\n}\5}\u0496\n}\3}\5}\u0499"+
		"\n}\3~\3~\3~\3~\3~\3~\5~\u04a1\n~\3~\5~\u04a4\n~\3~\3~\3\177\6\177\u04a9"+
		"\n\177\r\177\16\177\u04aa\3\177\3\177\3\u0080\3\u0080\3\u0080\3\u0080"+
		"\7\u0080\u04b3\n\u0080\f\u0080\16\u0080\u04b6\13\u0080\3\u0080\3\u0080"+
		"\3\u0081\3\u0081\3\u0081\3\u0081\7\u0081\u04be\n\u0081\f\u0081\16\u0081"+
		"\u04c1\13\u0081\3\u0081\3\u0081\3\u0081\3\u0081\3\u0081\3\u0082\3\u0082"+
		"\3\u0082\3\u0082\3\u0082\3\u0082\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083"+
		"\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083"+
		"\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083"+
		"\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083"+
		"\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083"+
		"\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083"+
		"\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083"+
		"\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083"+
		"\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083"+
		"\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083"+
		"\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083"+
		"\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083"+
		"\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083"+
		"\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083"+
		"\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083"+
		"\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083"+
		"\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083"+
		"\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083"+
		"\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083"+
		"\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083"+
		"\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083"+
		"\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083"+
		"\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083"+
		"\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083"+
		"\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083\3\u0083"+
		"\3\u0083\5\u0083\u05ac\n\u0083\3\u0084\3\u0084\3\u0085\3\u0085\3\u0086"+
		"\3\u0086\3\u0087\3\u0087\3\u0088\3\u0088\3\u0089\3\u0089\3\u008a\3\u008a"+
		"\3\u008b\3\u008b\3\u008c\3\u008c\3\u008c\3\u008d\3\u008d\3\u008d\3\u008e"+
		"\3\u008e\3\u008f\3\u008f\3\u0090\3\u0090\3\u0091\3\u0091\3\u0092\3\u0092"+
		"\3\u0093\3\u0093\3\u0094\3\u0094\3\u0094\3\u0095\3\u0095\3\u0095\3\u0096"+
		"\3\u0096\5\u0096\u05d8\n\u0096\3\u0097\3\u0097\3\u0097\5\u0097\u05dd\n"+
		"\u0097\3\u0098\3\u0098\7\u0098\u05e1\n\u0098\f\u0098\16\u0098\u05e4\13"+
		"\u0098\3\u0098\3\u0098\6\u0098\u05e8\n\u0098\r\u0098\16\u0098\u05e9\3"+
		"\u0099\7\u0099\u05ed\n\u0099\f\u0099\16\u0099\u05f0\13\u0099\3\u0099\3"+
		"\u0099\6\u0099\u05f4\n\u0099\r\u0099\16\u0099\u05f5\3\u009a\3\u009a\7"+
		"\u009a\u05fa\n\u009a\f\u009a\16\u009a\u05fd\13\u009a\3\u009a\3\u009a\6"+
		"\u009a\u0601\n\u009a\r\u009a\16\u009a\u0602\3\u009b\3\u009b\3\u009b\5"+
		"\u009b\u0608\n\u009b\3\u009c\3\u009c\6\u009c\u060c\n\u009c\r\u009c\16"+
		"\u009c\u060d\3\u009d\6\u009d\u0611\n\u009d\r\u009d\16\u009d\u0612\3\u009e"+
		"\3\u009e\6\u009e\u0617\n\u009e\r\u009e\16\u009e\u0618\3\u009f\3\u009f"+
		"\3\u00a0\3\u00a0\3\u00a1\3\u00a1\3\u00a2\3\u00a2\3\u00a2\3\u00a2\5\u00a2"+
		"\u0625\n\u00a2\3\u00a2\3\u00a2\3\u00a3\3\u00a3\6\u00a3\u062b\n\u00a3\r"+
		"\u00a3\16\u00a3\u062c\3\u00a4\3\u00a4\7\u00a4\u0631\n\u00a4\f\u00a4\16"+
		"\u00a4\u0634\13\u00a4\3\u00a5\3\u00a5\7\u00a5\u0638\n\u00a5\f\u00a5\16"+
		"\u00a5\u063b\13\u00a5\3\u00a6\3\u00a6\3\u00a7\3\u00a7\3\u00a8\6\u00a8"+
		"\u0642\n\u00a8\r\u00a8\16\u00a8\u0643\3\u00a8\3\u00a8\3\u00a9\3\u00a9"+
		"\3\u00a9\3\u00a9\7\u00a9\u064c\n\u00a9\f\u00a9\16\u00a9\u064f\13\u00a9"+
		"\3\u00a9\3\u00a9\3\u00aa\3\u00aa\3\u00aa\3\u00aa\7\u00aa\u0657\n\u00aa"+
		"\f\u00aa\16\u00aa\u065a\13\u00aa\3\u00aa\3\u00aa\3\u00aa\3\u00aa\3\u00aa"+
		"\3\u00ab\3\u00ab\6\u00ab\u0663\n\u00ab\r\u00ab\16\u00ab\u0664\3\u00ab"+
		"\3\u00ab\3\u00ab\3\u00ac\3\u00ac\3\u00ac\3\u00ac\7\u00ac\u066e\n\u00ac"+
		"\f\u00ac\16\u00ac\u0671\13\u00ac\3\u00ac\3\u00ac\3\u00ac\3\u00ad\6\u00ad"+
		"\u0677\n\u00ad\r\u00ad\16\u00ad\u0678\3\u00ad\3\u00ad\3\u00ae\3\u00ae"+
		"\3\u00ae\3\u00ae\7\u00ae\u0681\n\u00ae\f\u00ae\16\u00ae\u0684\13\u00ae"+
		"\3\u00ae\3\u00ae\3\u00af\3\u00af\3\u00af\3\u00af\7\u00af\u068c\n\u00af"+
		"\f\u00af\16\u00af\u068f\13\u00af\3\u00af\3\u00af\3\u00af\3\u00af\3\u00af"+
		"\6\u03a6\u04bf\u0658\u068d\2\u00b0\5\4\7\5\t\6\13\7\r\b\17\t\21\n\23\13"+
		"\25\f\27\r\31\16\33\17\35\20\37\21!\22#\23%\24\'\25)\26+\27-\30/\31\61"+
		"\32\63\33\65\34\67\359\36;\37= ?!A\"C#E$G%I&K\'M(O)Q*S+U,W-Y.[/]\60_\61"+
		"a\62c\63e\64g\65i\66k\67m8o9q:s;u<w=y>{?}@\177A\u0081B\u0083C\u0085D\u0087"+
		"E\u0089F\u008bG\u008dH\u008fI\u0091J\u0093K\u0095L\u0097M\u0099N\u009b"+
		"O\u009dP\u009fQ\u00a1R\u00a3S\u00a5T\u00a7U\u00a9V\u00abW\u00adX\u00af"+
		"Y\u00b1Z\u00b3[\u00b5\\\u00b7]\u00b9^\u00bb_\u00bd`\u00bfa\u00c1b\u00c3"+
		"c\u00c5d\u00c7e\u00c9f\u00cbg\u00cdh\u00cfi\u00d1j\u00d3k\u00d5l\u00d7"+
		"m\u00d9n\u00dbo\u00ddp\u00dfq\u00e1r\u00e3s\u00e5t\u00e7u\u00e9v\u00eb"+
		"w\u00edx\u00ef\2\u00f1\2\u00f3\2\u00f5y\u00f7\2\u00f9\2\u00fbz\u00fd{"+
		"\u00ff|\u0101}\u0103~\u0105\177\u0107\u0080\u0109\u0081\u010b\u0082\u010d"+
		"\u0083\u010f\u0084\u0111\u0085\u0113\u0086\u0115\u0087\u0117\u0088\u0119"+
		"\u0089\u011b\u008a\u011d\u008b\u011f\u008c\u0121\u008d\u0123\u008e\u0125"+
		"\u008f\u0127\u0090\u0129\u0091\u012b\u0092\u012d\u0093\u012f\u0094\u0131"+
		"\u0095\u0133\u0096\u0135\u0097\u0137\u0098\u0139\u0099\u013b\u009a\u013d"+
		"\u009b\u013f\2\u0141\2\u0143\2\u0145\u009c\u0147\u009d\u0149\u009e\u014b"+
		"\u009f\u014d\2\u014f\2\u0151\u00a0\u0153\u00a1\u0155\u00a2\u0157\u00a3"+
		"\u0159\u00a4\u015b\u00a5\u015d\u00a6\u015f\u00a7\5\2\3\4\25\4\2uuww\7"+
		"\2dfkknnuuyy\4\2DDdd\3\2\62\63\3\2\62;\5\2\62;CHch\5\2C\\aac|\6\2\62;"+
		"C\\aac|\3\2$$\3\2||\4\2rruu\4\2ooww\7\2$$))hhpptt\4\2\62;ch\3\2))\6\2"+
		"\13\f\17\17\"\"\u00a2\u00a2\4\2\f\f\17\17\4\2--//\7\2/;C\\^^aac|\2\u0726"+
		"\2\5\3\2\2\2\2\7\3\2\2\2\2\t\3\2\2\2\2\13\3\2\2\2\2\r\3\2\2\2\2\17\3\2"+
		"\2\2\2\21\3\2\2\2\2\23\3\2\2\2\2\25\3\2\2\2\2\27\3\2\2\2\2\31\3\2\2\2"+
		"\2\33\3\2\2\2\2\35\3\2\2\2\2\37\3\2\2\2\2!\3\2\2\2\2#\3\2\2\2\2%\3\2\2"+
		"\2\2\'\3\2\2\2\2)\3\2\2\2\2+\3\2\2\2\2-\3\2\2\2\2/\3\2\2\2\2\61\3\2\2"+
		"\2\2\63\3\2\2\2\2\65\3\2\2\2\2\67\3\2\2\2\29\3\2\2\2\2;\3\2\2\2\2=\3\2"+
		"\2\2\2?\3\2\2\2\2A\3\2\2\2\2C\3\2\2\2\2E\3\2\2\2\2G\3\2\2\2\2I\3\2\2\2"+
		"\2K\3\2\2\2\2M\3\2\2\2\2O\3\2\2\2\2Q\3\2\2\2\2S\3\2\2\2\2U\3\2\2\2\2W"+
		"\3\2\2\2\2Y\3\2\2\2\2[\3\2\2\2\2]\3\2\2\2\2_\3\2\2\2\2a\3\2\2\2\2c\3\2"+
		"\2\2\2e\3\2\2\2\2g\3\2\2\2\2i\3\2\2\2\2k\3\2\2\2\2m\3\2\2\2\2o\3\2\2\2"+
		"\2q\3\2\2\2\2s\3\2\2\2\2u\3\2\2\2\2w\3\2\2\2\2y\3\2\2\2\2{\3\2\2\2\2}"+
		"\3\2\2\2\2\177\3\2\2\2\2\u0081\3\2\2\2\2\u0083\3\2\2\2\2\u0085\3\2\2\2"+
		"\2\u0087\3\2\2\2\2\u0089\3\2\2\2\2\u008b\3\2\2\2\2\u008d\3\2\2\2\2\u008f"+
		"\3\2\2\2\2\u0091\3\2\2\2\2\u0093\3\2\2\2\2\u0095\3\2\2\2\2\u0097\3\2\2"+
		"\2\2\u0099\3\2\2\2\2\u009b\3\2\2\2\2\u009d\3\2\2\2\2\u009f\3\2\2\2\2\u00a1"+
		"\3\2\2\2\2\u00a3\3\2\2\2\2\u00a5\3\2\2\2\2\u00a7\3\2\2\2\2\u00a9\3\2\2"+
		"\2\2\u00ab\3\2\2\2\2\u00ad\3\2\2\2\2\u00af\3\2\2\2\2\u00b1\3\2\2\2\2\u00b3"+
		"\3\2\2\2\2\u00b5\3\2\2\2\2\u00b7\3\2\2\2\2\u00b9\3\2\2\2\2\u00bb\3\2\2"+
		"\2\2\u00bd\3\2\2\2\2\u00bf\3\2\2\2\2\u00c1\3\2\2\2\2\u00c3\3\2\2\2\2\u00c5"+
		"\3\2\2\2\2\u00c7\3\2\2\2\2\u00c9\3\2\2\2\2\u00cb\3\2\2\2\2\u00cd\3\2\2"+
		"\2\2\u00cf\3\2\2\2\2\u00d1\3\2\2\2\2\u00d3\3\2\2\2\2\u00d5\3\2\2\2\2\u00d7"+
		"\3\2\2\2\2\u00d9\3\2\2\2\2\u00db\3\2\2\2\2\u00dd\3\2\2\2\2\u00df\3\2\2"+
		"\2\2\u00e1\3\2\2\2\2\u00e3\3\2\2\2\2\u00e5\3\2\2\2\2\u00e7\3\2\2\2\2\u00e9"+
		"\3\2\2\2\2\u00eb\3\2\2\2\2\u00ed\3\2\2\2\2\u00f5\3\2\2\2\2\u00fb\3\2\2"+
		"\2\2\u00fd\3\2\2\2\2\u00ff\3\2\2\2\2\u0101\3\2\2\2\2\u0103\3\2\2\2\3\u0105"+
		"\3\2\2\2\3\u0107\3\2\2\2\3\u0109\3\2\2\2\3\u010b\3\2\2\2\3\u010d\3\2\2"+
		"\2\3\u010f\3\2\2\2\3\u0111\3\2\2\2\3\u0113\3\2\2\2\3\u0115\3\2\2\2\3\u0117"+
		"\3\2\2\2\3\u0119\3\2\2\2\3\u011b\3\2\2\2\3\u011d\3\2\2\2\3\u011f\3\2\2"+
		"\2\3\u0121\3\2\2\2\3\u0123\3\2\2\2\3\u0125\3\2\2\2\3\u0127\3\2\2\2\3\u0129"+
		"\3\2\2\2\3\u012b\3\2\2\2\3\u012d\3\2\2\2\3\u012f\3\2\2\2\3\u0131\3\2\2"+
		"\2\3\u0133\3\2\2\2\3\u0135\3\2\2\2\3\u0137\3\2\2\2\3\u0139\3\2\2\2\3\u013b"+
		"\3\2\2\2\3\u013d\3\2\2\2\3\u0145\3\2\2\2\3\u0147\3\2\2\2\3\u0149\3\2\2"+
		"\2\3\u014b\3\2\2\2\3\u0151\3\2\2\2\3\u0153\3\2\2\2\3\u0155\3\2\2\2\4\u0157"+
		"\3\2\2\2\4\u0159\3\2\2\2\4\u015b\3\2\2\2\4\u015d\3\2\2\2\4\u015f\3\2\2"+
		"\2\5\u0161\3\2\2\2\7\u0164\3\2\2\2\t\u0166\3\2\2\2\13\u0168\3\2\2\2\r"+
		"\u016a\3\2\2\2\17\u016c\3\2\2\2\21\u016e\3\2\2\2\23\u0170\3\2\2\2\25\u0172"+
		"\3\2\2\2\27\u0174\3\2\2\2\31\u0177\3\2\2\2\33\u017b\3\2\2\2\35\u017d\3"+
		"\2\2\2\37\u017f\3\2\2\2!\u0182\3\2\2\2#\u0184\3\2\2\2%\u0186\3\2\2\2\'"+
		"\u0188\3\2\2\2)\u018a\3\2\2\2+\u018c\3\2\2\2-\u018f\3\2\2\2/\u0192\3\2"+
		"\2\2\61\u0194\3\2\2\2\63\u0196\3\2\2\2\65\u0198\3\2\2\2\67\u019a\3\2\2"+
		"\29\u019d\3\2\2\2;\u01a0\3\2\2\2=\u01a3\3\2\2\2?\u01a6\3\2\2\2A\u01a8"+
		"\3\2\2\2C\u01ab\3\2\2\2E\u01ae\3\2\2\2G\u01b0\3\2\2\2I\u01b3\3\2\2\2K"+
		"\u01b6\3\2\2\2M\u01ce\3\2\2\2O\u01d0\3\2\2\2Q\u01d8\3\2\2\2S\u01e3\3\2"+
		"\2\2U\u01e6\3\2\2\2W\u01ed\3\2\2\2Y\u01f2\3\2\2\2[\u01fc\3\2\2\2]\u0205"+
		"\3\2\2\2_\u0209\3\2\2\2a\u0212\3\2\2\2c\u021b\3\2\2\2e\u0224\3\2\2\2g"+
		"\u022a\3\2\2\2i\u0231\3\2\2\2k\u0238\3\2\2\2m\u023e\3\2\2\2o\u0245\3\2"+
		"\2\2q\u024e\3\2\2\2s\u0255\3\2\2\2u\u025f\3\2\2\2w\u0268\3\2\2\2y\u0275"+
		"\3\2\2\2{\u027f\3\2\2\2}\u0284\3\2\2\2\177\u028a\3\2\2\2\u0081\u0290\3"+
		"\2\2\2\u0083\u0295\3\2\2\2\u0085\u02a1\3\2\2\2\u0087\u02bd\3\2\2\2\u0089"+
		"\u02bf\3\2\2\2\u008b\u02c9\3\2\2\2\u008d\u02cc\3\2\2\2\u008f\u02d1\3\2"+
		"\2\2\u0091\u02d7\3\2\2\2\u0093\u02da\3\2\2\2\u0095\u02de\3\2\2\2\u0097"+
		"\u02e5\3\2\2\2\u0099\u02ec\3\2\2\2\u009b\u02f2\3\2\2\2\u009d\u02fb\3\2"+
		"\2\2\u009f\u0301\3\2\2\2\u00a1\u0309\3\2\2\2\u00a3\u030e\3\2\2\2\u00a5"+
		"\u0315\3\2\2\2\u00a7\u031a\3\2\2\2\u00a9\u0321\3\2\2\2\u00ab\u0328\3\2"+
		"\2\2\u00ad\u0330\3\2\2\2\u00af\u0338\3\2\2\2\u00b1\u0341\3\2\2\2\u00b3"+
		"\u0346\3\2\2\2\u00b5\u034f\3\2\2\2\u00b7\u0355\3\2\2\2\u00b9\u035c\3\2"+
		"\2\2\u00bb\u036c\3\2\2\2\u00bd\u0393\3\2\2\2\u00bf\u039e\3\2\2\2\u00c1"+
		"\u03a0\3\2\2\2\u00c3\u03ac\3\2\2\2\u00c5\u03b6\3\2\2\2\u00c7\u03c1\3\2"+
		"\2\2\u00c9\u03c9\3\2\2\2\u00cb\u03d6\3\2\2\2\u00cd\u03d8\3\2\2\2\u00cf"+
		"\u03df\3\2\2\2\u00d1\u03e6\3\2\2\2\u00d3\u03ee\3\2\2\2\u00d5\u03f2\3\2"+
		"\2\2\u00d7\u03f8\3\2\2\2\u00d9\u03fe\3\2\2\2\u00db\u0405\3\2\2\2\u00dd"+
		"\u040e\3\2\2\2\u00df\u0413\3\2\2\2\u00e1\u041a\3\2\2\2\u00e3\u042b\3\2"+
		"\2\2\u00e5\u0439\3\2\2\2\u00e7\u044a\3\2\2\2\u00e9\u045e\3\2\2\2\u00eb"+
		"\u0461\3\2\2\2\u00ed\u046a\3\2\2\2\u00ef\u0471\3\2\2\2\u00f1\u0473\3\2"+
		"\2\2\u00f3\u0475\3\2\2\2\u00f5\u0477\3\2\2\2\u00f7\u0480\3\2\2\2\u00f9"+
		"\u0482\3\2\2\2\u00fb\u0484\3\2\2\2\u00fd\u049a\3\2\2\2\u00ff\u04a8\3\2"+
		"\2\2\u0101\u04ae\3\2\2\2\u0103\u04b9\3\2\2\2\u0105\u04c7\3\2\2\2\u0107"+
		"\u05ab\3\2\2\2\u0109\u05ad\3\2\2\2\u010b\u05af\3\2\2\2\u010d\u05b1\3\2"+
		"\2\2\u010f\u05b3\3\2\2\2\u0111\u05b5\3\2\2\2\u0113\u05b7\3\2\2\2\u0115"+
		"\u05b9\3\2\2\2\u0117\u05bb\3\2\2\2\u0119\u05bd\3\2\2\2\u011b\u05c0\3\2"+
		"\2\2\u011d\u05c3\3\2\2\2\u011f\u05c5\3\2\2\2\u0121\u05c7\3\2\2\2\u0123"+
		"\u05c9\3\2\2\2\u0125\u05cb\3\2\2\2\u0127\u05cd\3\2\2\2\u0129\u05cf\3\2"+
		"\2\2\u012b\u05d2\3\2\2\2\u012d\u05d7\3\2\2\2\u012f\u05dc\3\2\2\2\u0131"+
		"\u05de\3\2\2\2\u0133\u05ee\3\2\2\2\u0135\u05f7\3\2\2\2\u0137\u0607\3\2"+
		"\2\2\u0139\u0609\3\2\2\2\u013b\u0610\3\2\2\2\u013d\u0614\3\2\2\2\u013f"+
		"\u061a\3\2\2\2\u0141\u061c\3\2\2\2\u0143\u061e\3\2\2\2\u0145\u0620\3\2"+
		"\2\2\u0147\u0628\3\2\2\2\u0149\u062e\3\2\2\2\u014b\u0635\3\2\2\2\u014d"+
		"\u063c\3\2\2\2\u014f\u063e\3\2\2\2\u0151\u0641\3\2\2\2\u0153\u0647\3\2"+
		"\2\2\u0155\u0652\3\2\2\2\u0157\u0660\3\2\2\2\u0159\u0669\3\2\2\2\u015b"+
		"\u0676\3\2\2\2\u015d\u067c\3\2\2\2\u015f\u0687\3\2\2\2\u0161\u0162\7}"+
		"\2\2\u0162\u0163\b\2\2\2\u0163\6\3\2\2\2\u0164\u0165\7\177\2\2\u0165\b"+
		"\3\2\2\2\u0166\u0167\7]\2\2\u0167\n\3\2\2\2\u0168\u0169\7_\2\2\u0169\f"+
		"\3\2\2\2\u016a\u016b\7*\2\2\u016b\16\3\2\2\2\u016c\u016d\7+\2\2\u016d"+
		"\20\3\2\2\2\u016e\u016f\7=\2\2\u016f\22\3\2\2\2\u0170\u0171\7<\2\2\u0171"+
		"\24\3\2\2\2\u0172\u0173\7.\2\2\u0173\26\3\2\2\2\u0174\u0175\7\60\2\2\u0175"+
		"\u0176\7\60\2\2\u0176\30\3\2\2\2\u0177\u0178\7\60\2\2\u0178\u0179\7\60"+
		"\2\2\u0179\u017a\7\60\2\2\u017a\32\3\2\2\2\u017b\u017c\7A\2\2\u017c\34"+
		"\3\2\2\2\u017d\u017e\7\60\2\2\u017e\36\3\2\2\2\u017f\u0180\7/\2\2\u0180"+
		"\u0181\7@\2\2\u0181 \3\2\2\2\u0182\u0183\7-\2\2\u0183\"\3\2\2\2\u0184"+
		"\u0185\7/\2\2\u0185$\3\2\2\2\u0186\u0187\7,\2\2\u0187&\3\2\2\2\u0188\u0189"+
		"\7\61\2\2\u0189(\3\2\2\2\u018a\u018b\7\'\2\2\u018b*\3\2\2\2\u018c\u018d"+
		"\7-\2\2\u018d\u018e\7-\2\2\u018e,\3\2\2\2\u018f\u0190\7/\2\2\u0190\u0191"+
		"\7/\2\2\u0191.\3\2\2\2\u0192\u0193\7(\2\2\u0193\60\3\2\2\2\u0194\u0195"+
		"\7\u0080\2\2\u0195\62\3\2\2\2\u0196\u0197\7`\2\2\u0197\64\3\2\2\2\u0198"+
		"\u0199\7~\2\2\u0199\66\3\2\2\2\u019a\u019b\7>\2\2\u019b\u019c\7>\2\2\u019c"+
		"8\3\2\2\2\u019d\u019e\7@\2\2\u019e\u019f\7@\2\2\u019f:\3\2\2\2\u01a0\u01a1"+
		"\7?\2\2\u01a1\u01a2\7?\2\2\u01a2<\3\2\2\2\u01a3\u01a4\7#\2\2\u01a4\u01a5"+
		"\7?\2\2\u01a5>\3\2\2\2\u01a6\u01a7\7>\2\2\u01a7@\3\2\2\2\u01a8\u01a9\7"+
		">\2\2\u01a9\u01aa\7?\2\2\u01aaB\3\2\2\2\u01ab\u01ac\7@\2\2\u01ac\u01ad"+
		"\7?\2\2\u01adD\3\2\2\2\u01ae\u01af\7@\2\2\u01afF\3\2\2\2\u01b0\u01b1\7"+
		"(\2\2\u01b1\u01b2\7(\2\2\u01b2H\3\2\2\2\u01b3\u01b4\7~\2\2\u01b4\u01b5"+
		"\7~\2\2\u01b5J\3\2\2\2\u01b6\u01b7\7?\2\2\u01b7L\3\2\2\2\u01b8\u01b9\7"+
		"-\2\2\u01b9\u01cf\7?\2\2\u01ba\u01bb\7/\2\2\u01bb\u01cf\7?\2\2\u01bc\u01bd"+
		"\7,\2\2\u01bd\u01cf\7?\2\2\u01be\u01bf\7\61\2\2\u01bf\u01cf\7?\2\2\u01c0"+
		"\u01c1\7\'\2\2\u01c1\u01cf\7?\2\2\u01c2\u01c3\7>\2\2\u01c3\u01c4\7>\2"+
		"\2\u01c4\u01cf\7?\2\2\u01c5\u01c6\7@\2\2\u01c6\u01c7\7@\2\2\u01c7\u01cf"+
		"\7?\2\2\u01c8\u01c9\7(\2\2\u01c9\u01cf\7?\2\2\u01ca\u01cb\7~\2\2\u01cb"+
		"\u01cf\7?\2\2\u01cc\u01cd\7`\2\2\u01cd\u01cf\7?\2\2\u01ce\u01b8\3\2\2"+
		"\2\u01ce\u01ba\3\2\2\2\u01ce\u01bc\3\2\2\2\u01ce\u01be\3\2\2\2\u01ce\u01c0"+
		"\3\2\2\2\u01ce\u01c2\3\2\2\2\u01ce\u01c5\3\2\2\2\u01ce\u01c8\3\2\2\2\u01ce"+
		"\u01ca\3\2\2\2\u01ce\u01cc\3\2\2\2\u01cfN\3\2\2\2\u01d0\u01d1\7v\2\2\u01d1"+
		"\u01d2\7{\2\2\u01d2\u01d3\7r\2\2\u01d3\u01d4\7g\2\2\u01d4\u01d5\7f\2\2"+
		"\u01d5\u01d6\7g\2\2\u01d6\u01d7\7h\2\2\u01d7P\3\2\2\2\u01d8\u01d9\7|\2"+
		"\2\u01d9\u01da\7r\2\2\u01da\u01db\7a\2\2\u01db\u01dc\7t\2\2\u01dc\u01dd"+
		"\7g\2\2\u01dd\u01de\7u\2\2\u01de\u01df\7g\2\2\u01df\u01e0\7t\2\2\u01e0"+
		"\u01e1\7x\2\2\u01e1\u01e2\7g\2\2\u01e2R\3\2\2\2\u01e3\u01e4\7r\2\2\u01e4"+
		"\u01e5\7e\2\2\u01e5T\3\2\2\2\u01e6\u01e7\7v\2\2\u01e7\u01e8\7c\2\2\u01e8"+
		"\u01e9\7t\2\2\u01e9\u01ea\7i\2\2\u01ea\u01eb\7g\2\2\u01eb\u01ec\7v\2\2"+
		"\u01ecV\3\2\2\2\u01ed\u01ee\7n\2\2\u01ee\u01ef\7k\2\2\u01ef\u01f0\7p\2"+
		"\2\u01f0\u01f1\7m\2\2\u01f1X\3\2\2\2\u01f2\u01f3\7g\2\2\u01f3\u01f4\7"+
		"z\2\2\u01f4\u01f5\7v\2\2\u01f5\u01f6\7g\2\2\u01f6\u01f7\7p\2\2\u01f7\u01f8"+
		"\7u\2\2\u01f8\u01f9\7k\2\2\u01f9\u01fa\7q\2\2\u01fa\u01fb\7p\2\2\u01fb"+
		"Z\3\2\2\2\u01fc\u01fd\7g\2\2\u01fd\u01fe\7o\2\2\u01fe\u01ff\7w\2\2\u01ff"+
		"\u0200\7n\2\2\u0200\u0201\7c\2\2\u0201\u0202\7v\2\2\u0202\u0203\7q\2\2"+
		"\u0203\u0204\7t\2\2\u0204\\\3\2\2\2\u0205\u0206\7e\2\2\u0206\u0207\7r"+
		"\2\2\u0207\u0208\7w\2\2\u0208^\3\2\2\2\u0209\u020a\7e\2\2\u020a\u020b"+
		"\7q\2\2\u020b\u020c\7f\2\2\u020c\u020d\7g\2\2\u020d\u020e\7a\2\2\u020e"+
		"\u020f\7u\2\2\u020f\u0210\7g\2\2\u0210\u0211\7i\2\2\u0211`\3\2\2\2\u0212"+
		"\u0213\7f\2\2\u0213\u0214\7c\2\2\u0214\u0215\7v\2\2\u0215\u0216\7c\2\2"+
		"\u0216\u0217\7a\2\2\u0217\u0218\7u\2\2\u0218\u0219\7g\2\2\u0219\u021a"+
		"\7i\2\2\u021ab\3\2\2\2\u021b\u021c\7g\2\2\u021c\u021d\7p\2\2\u021d\u021e"+
		"\7e\2\2\u021e\u021f\7q\2\2\u021f\u0220\7f\2\2\u0220\u0221\7k\2\2\u0221"+
		"\u0222\7p\2\2\u0222\u0223\7i\2\2\u0223d\3\2\2\2\u0224\u0225\7e\2\2\u0225"+
		"\u0226\7q\2\2\u0226\u0227\7p\2\2\u0227\u0228\7u\2\2\u0228\u0229\7v\2\2"+
		"\u0229f\3\2\2\2\u022a\u022b\7g\2\2\u022b\u022c\7z\2\2\u022c\u022d\7v\2"+
		"\2\u022d\u022e\7g\2\2\u022e\u022f\7t\2\2\u022f\u0230\7p\2\2\u0230h\3\2"+
		"\2\2\u0231\u0232\7g\2\2\u0232\u0233\7z\2\2\u0233\u0234\7r\2\2\u0234\u0235"+
		"\7q\2\2\u0235\u0236\7t\2\2\u0236\u0237\7v\2\2\u0237j\3\2\2\2\u0238\u0239"+
		"\7c\2\2\u0239\u023a\7n\2\2\u023a\u023b\7k\2\2\u023b\u023c\7i\2\2\u023c"+
		"\u023d\7p\2\2\u023dl\3\2\2\2\u023e\u023f\7k\2\2\u023f\u0240\7p\2\2\u0240"+
		"\u0241\7n\2\2\u0241\u0242\7k\2\2\u0242\u0243\7p\2\2\u0243\u0244\7g\2\2"+
		"\u0244n\3\2\2\2\u0245\u0246\7x\2\2\u0246\u0247\7q\2\2\u0247\u0248\7n\2"+
		"\2\u0248\u0249\7c\2\2\u0249\u024a\7v\2\2\u024a\u024b\7k\2\2\u024b\u024c"+
		"\7n\2\2\u024c\u024d\7g\2\2\u024dp\3\2\2\2\u024e\u024f\7u\2\2\u024f\u0250"+
		"\7v\2\2\u0250\u0251\7c\2\2\u0251\u0252\7v\2\2\u0252\u0253\7k\2\2\u0253"+
		"\u0254\7e\2\2\u0254r\3\2\2\2\u0255\u0256\7k\2\2\u0256\u0257\7p\2\2\u0257"+
		"\u0258\7v\2\2\u0258\u0259\7g\2\2\u0259\u025a\7t\2\2\u025a\u025b\7t\2\2"+
		"\u025b\u025c\7w\2\2\u025c\u025d\7r\2\2\u025d\u025e\7v\2\2\u025et\3\2\2"+
		"\2\u025f\u0260\7t\2\2\u0260\u0261\7g\2\2\u0261\u0262\7i\2\2\u0262\u0263"+
		"\7k\2\2\u0263\u0264\7u\2\2\u0264\u0265\7v\2\2\u0265\u0266\7g\2\2\u0266"+
		"\u0267\7t\2\2\u0267v\3\2\2\2\u0268\u0269\7a\2\2\u0269\u026a\7a\2\2\u026a"+
		"\u026b\7|\2\2\u026b\u026c\7r\2\2\u026c\u026d\7a\2\2\u026d\u026e\7t\2\2"+
		"\u026e\u026f\7g\2\2\u026f\u0270\7u\2\2\u0270\u0271\7g\2\2\u0271\u0272"+
		"\7t\2\2\u0272\u0273\7x\2\2\u0273\u0274\7g\2\2\u0274x\3\2\2\2\u0275\u0276"+
		"\7a\2\2\u0276\u0277\7a\2\2\u0277\u0278\7c\2\2\u0278\u0279\7f\2\2\u0279"+
		"\u027a\7f\2\2\u027a\u027b\7t\2\2\u027b\u027c\7g\2\2\u027c\u027d\7u\2\2"+
		"\u027d\u027e\7u\2\2\u027ez\3\2\2\2\u027f\u0280\7a\2\2\u0280\u0281\7a\2"+
		"\2\u0281\u0282\7|\2\2\u0282\u0283\7r\2\2\u0283|\3\2\2\2\u0284\u0285\7"+
		"a\2\2\u0285\u0286\7a\2\2\u0286\u0287\7o\2\2\u0287\u0288\7g\2\2\u0288\u0289"+
		"\7o\2\2\u0289~\3\2\2\2\u028a\u028b\7a\2\2\u028b\u028c\7a\2\2\u028c\u028d"+
		"\7u\2\2\u028d\u028e\7u\2\2\u028e\u028f\7c\2\2\u028f\u0080\3\2\2\2\u0290"+
		"\u0291\7a\2\2\u0291\u0292\7a\2\2\u0292\u0293\7o\2\2\u0293\u0294\7c\2\2"+
		"\u0294\u0082\3\2\2\2\u0295\u0296\7a\2\2\u0296\u0297\7a\2\2\u0297\u0298"+
		"\7k\2\2\u0298\u0299\7p\2\2\u0299\u029a\7v\2\2\u029a\u029b\7t\2\2\u029b"+
		"\u029c\7k\2\2\u029c\u029d\7p\2\2\u029d\u029e\7u\2\2\u029e\u029f\7k\2\2"+
		"\u029f\u02a0\7e\2\2\u02a0\u0084\3\2\2\2\u02a1\u02a2\7e\2\2\u02a2\u02a3"+
		"\7c\2\2\u02a3\u02a4\7n\2\2\u02a4\u02a5\7n\2\2\u02a5\u02a6\7k\2\2\u02a6"+
		"\u02a7\7p\2\2\u02a7\u02a8\7i\2\2\u02a8\u0086\3\2\2\2\u02a9\u02aa\7a\2"+
		"\2\u02aa\u02ab\7a\2\2\u02ab\u02ac\7u\2\2\u02ac\u02ad\7v\2\2\u02ad\u02ae"+
		"\7c\2\2\u02ae\u02af\7e\2\2\u02af\u02b0\7m\2\2\u02b0\u02b1\7e\2\2\u02b1"+
		"\u02b2\7c\2\2\u02b2\u02b3\7n\2\2\u02b3\u02be\7n\2\2\u02b4\u02b5\7a\2\2"+
		"\u02b5\u02b6\7a\2\2\u02b6\u02b7\7r\2\2\u02b7\u02b8\7j\2\2\u02b8\u02b9"+
		"\7k\2\2\u02b9\u02ba\7e\2\2\u02ba\u02bb\7c\2\2\u02bb\u02bc\7n\2\2\u02bc"+
		"\u02be\7n\2\2\u02bd\u02a9\3\2\2\2\u02bd\u02b4\3\2\2\2\u02be\u0088\3\2"+
		"\2\2\u02bf\u02c0\7x\2\2\u02c0\u02c1\7c\2\2\u02c1\u02c2\7t\2\2\u02c2\u02c3"+
		"\7a\2\2\u02c3\u02c4\7o\2\2\u02c4\u02c5\7q\2\2\u02c5\u02c6\7f\2\2\u02c6"+
		"\u02c7\7g\2\2\u02c7\u02c8\7n\2\2\u02c8\u008a\3\2\2\2\u02c9\u02ca\7k\2"+
		"\2\u02ca\u02cb\7h\2\2\u02cb\u008c\3\2\2\2\u02cc\u02cd\7g\2\2\u02cd\u02ce"+
		"\7n\2\2\u02ce\u02cf\7u\2\2\u02cf\u02d0\7g\2\2\u02d0\u008e\3\2\2\2\u02d1"+
		"\u02d2\7y\2\2\u02d2\u02d3\7j\2\2\u02d3\u02d4\7k\2\2\u02d4\u02d5\7n\2\2"+
		"\u02d5\u02d6\7g\2\2\u02d6\u0090\3\2\2\2\u02d7\u02d8\7f\2\2\u02d8\u02d9"+
		"\7q\2\2\u02d9\u0092\3\2\2\2\u02da\u02db\7h\2\2\u02db\u02dc\7q\2\2\u02dc"+
		"\u02dd\7t\2\2\u02dd\u0094\3\2\2\2\u02de\u02df\7u\2\2\u02df\u02e0\7y\2"+
		"\2\u02e0\u02e1\7k\2\2\u02e1\u02e2\7v\2\2\u02e2\u02e3\7e\2\2\u02e3\u02e4"+
		"\7j\2\2\u02e4\u0096\3\2\2\2\u02e5\u02e6\7t\2\2\u02e6\u02e7\7g\2\2\u02e7"+
		"\u02e8\7v\2\2\u02e8\u02e9\7w\2\2\u02e9\u02ea\7t\2\2\u02ea\u02eb\7p\2\2"+
		"\u02eb\u0098\3\2\2\2\u02ec\u02ed\7d\2\2\u02ed\u02ee\7t\2\2\u02ee\u02ef"+
		"\7g\2\2\u02ef\u02f0\7c\2\2\u02f0\u02f1\7m\2\2\u02f1\u009a\3\2\2\2\u02f2"+
		"\u02f3\7e\2\2\u02f3\u02f4\7q\2\2\u02f4\u02f5\7p\2\2\u02f5\u02f6\7v\2\2"+
		"\u02f6\u02f7\7k\2\2\u02f7\u02f8\7p\2\2\u02f8\u02f9\7w\2\2\u02f9\u02fa"+
		"\7g\2\2\u02fa\u009c\3\2\2\2\u02fb\u02fc\7c\2\2\u02fc\u02fd\7u\2\2\u02fd"+
		"\u02fe\7o\2\2\u02fe\u02ff\3\2\2\2\u02ff\u0300\bN\3\2\u0300\u009e\3\2\2"+
		"\2\u0301\u0302\7f\2\2\u0302\u0303\7g\2\2\u0303\u0304\7h\2\2\u0304\u0305"+
		"\7c\2\2\u0305\u0306\7w\2\2\u0306\u0307\7n\2\2\u0307\u0308\7v\2\2\u0308"+
		"\u00a0\3\2\2\2\u0309\u030a\7e\2\2\u030a\u030b\7c\2\2\u030b\u030c\7u\2"+
		"\2\u030c\u030d\7g\2\2\u030d\u00a2\3\2\2\2\u030e\u030f\7u\2\2\u030f\u0310"+
		"\7v\2\2\u0310\u0311\7t\2\2\u0311\u0312\7w\2\2\u0312\u0313\7e\2\2\u0313"+
		"\u0314\7v\2\2\u0314\u00a4\3\2\2\2\u0315\u0316\7g\2\2\u0316\u0317\7p\2"+
		"\2\u0317\u0318\7w\2\2\u0318\u0319\7o\2\2\u0319\u00a6\3\2\2\2\u031a\u031b"+
		"\7u\2\2\u031b\u031c\7k\2\2\u031c\u031d\7|\2\2\u031d\u031e\7g\2\2\u031e"+
		"\u031f\7q\2\2\u031f\u0320\7h\2\2\u0320\u00a8\3\2\2\2\u0321\u0322\7v\2"+
		"\2\u0322\u0323\7{\2\2\u0323\u0324\7r\2\2\u0324\u0325\7g\2\2\u0325\u0326"+
		"\7k\2\2\u0326\u0327\7f\2\2\u0327\u00aa\3\2\2\2\u0328\u0329\7f\2\2\u0329"+
		"\u032a\7g\2\2\u032a\u032b\7h\2\2\u032b\u032c\7k\2\2\u032c\u032d\7p\2\2"+
		"\u032d\u032e\7g\2\2\u032e\u032f\7f\2\2\u032f\u00ac\3\2\2\2\u0330\u0331"+
		"\7m\2\2\u0331\u0332\7k\2\2\u0332\u0333\7e\2\2\u0333\u0334\7m\2\2\u0334"+
		"\u0335\7c\2\2\u0335\u0336\7u\2\2\u0336\u0337\7o\2\2\u0337\u00ae\3\2\2"+
		"\2\u0338\u0339\7t\2\2\u0339\u033a\7g\2\2\u033a\u033b\7u\2\2\u033b\u033c"+
		"\7q\2\2\u033c\u033d\7w\2\2\u033d\u033e\7t\2\2\u033e\u033f\7e\2\2\u033f"+
		"\u0340\7g\2\2\u0340\u00b0\3\2\2\2\u0341\u0342\7w\2\2\u0342\u0343\7u\2"+
		"\2\u0343\u0344\7g\2\2\u0344\u0345\7u\2\2\u0345\u00b2\3\2\2\2\u0346\u0347"+
		"\7e\2\2\u0347\u0348\7n\2\2\u0348\u0349\7q\2\2\u0349\u034a\7d\2\2\u034a"+
		"\u034b\7d\2\2\u034b\u034c\7g\2\2\u034c\u034d\7t\2\2\u034d\u034e\7u\2\2"+
		"\u034e\u00b4\3\2\2\2\u034f\u0350\7d\2\2\u0350\u0351\7{\2\2\u0351\u0352"+
		"\7v\2\2\u0352\u0353\7g\2\2\u0353\u0354\7u\2\2\u0354\u00b6\3\2\2\2\u0355"+
		"\u0356\7e\2\2\u0356\u0357\7{\2\2\u0357\u0358\7e\2\2\u0358\u0359\7n\2\2"+
		"\u0359\u035a\7g\2\2\u035a\u035b\7u\2\2\u035b\u00b8\3\2\2\2\u035c\u035d"+
		"\7#\2\2\u035d\u00ba\3\2\2\2\u035e\u035f\7u\2\2\u035f\u0360\7k\2\2\u0360"+
		"\u0361\7i\2\2\u0361\u0362\7p\2\2\u0362\u0363\7g\2\2\u0363\u036d\7f\2\2"+
		"\u0364\u0365\7w\2\2\u0365\u0366\7p\2\2\u0366\u0367\7u\2\2\u0367\u0368"+
		"\7k\2\2\u0368\u0369\7i\2\2\u0369\u036a\7p\2\2\u036a\u036b\7g\2\2\u036b"+
		"\u036d\7f\2\2\u036c\u035e\3\2\2\2\u036c\u0364\3\2\2\2\u036d\u00bc\3\2"+
		"\2\2\u036e\u036f\7d\2\2\u036f\u0370\7{\2\2\u0370\u0371\7v\2\2\u0371\u0394"+
		"\7g\2\2\u0372\u0373\7y\2\2\u0373\u0374\7q\2\2\u0374\u0375\7t\2\2\u0375"+
		"\u0394\7f\2\2\u0376\u0377\7f\2\2\u0377\u0378\7y\2\2\u0378\u0379\7q\2\2"+
		"\u0379\u037a\7t\2\2\u037a\u0394\7f\2\2\u037b\u037c\7d\2\2\u037c\u037d"+
		"\7q\2\2\u037d\u037e\7q\2\2\u037e\u0394\7n\2\2\u037f\u0380\7e\2\2\u0380"+
		"\u0381\7j\2\2\u0381\u0382\7c\2\2\u0382\u0394\7t\2\2\u0383\u0384\7u\2\2"+
		"\u0384\u0385\7j\2\2\u0385\u0386\7q\2\2\u0386\u0387\7t\2\2\u0387\u0394"+
		"\7v\2\2\u0388\u0389\7k\2\2\u0389\u038a\7p\2\2\u038a\u0394\7v\2\2\u038b"+
		"\u038c\7n\2\2\u038c\u038d\7q\2\2\u038d\u038e\7p\2\2\u038e\u0394\7i\2\2"+
		"\u038f\u0390\7x\2\2\u0390\u0391\7q\2\2\u0391\u0392\7k\2\2\u0392\u0394"+
		"\7f\2\2\u0393\u036e\3\2\2\2\u0393\u0372\3\2\2\2\u0393\u0376\3\2\2\2\u0393"+
		"\u037b\3\2\2\2\u0393\u037f\3\2\2\2\u0393\u0383\3\2\2\2\u0393\u0388\3\2"+
		"\2\2\u0393\u038b\3\2\2\2\u0393\u038f\3\2\2\2\u0394\u00be\3\2\2\2\u0395"+
		"\u0396\7v\2\2\u0396\u0397\7t\2\2\u0397\u0398\7w\2\2\u0398\u039f\7g\2\2"+
		"\u0399\u039a\7h\2\2\u039a\u039b\7c\2\2\u039b\u039c\7n\2\2\u039c\u039d"+
		"\7u\2\2\u039d\u039f\7g\2\2\u039e\u0395\3\2\2\2\u039e\u0399\3\2\2\2\u039f"+
		"\u00c0\3\2\2\2\u03a0\u03a1\7}\2\2\u03a1\u03a2\7}\2\2\u03a2\u03a6\3\2\2"+
		"\2\u03a3\u03a5\13\2\2\2\u03a4\u03a3\3\2\2\2\u03a5\u03a8\3\2\2\2\u03a6"+
		"\u03a7\3\2\2\2\u03a6\u03a4\3\2\2\2\u03a7\u03a9\3\2\2\2\u03a8\u03a6\3\2"+
		"\2\2\u03a9\u03aa\7\177\2\2\u03aa\u03ab\7\177\2\2\u03ab\u00c2\3\2\2\2\u03ac"+
		"\u03ad\7%\2\2\u03ad\u03ae\7k\2\2\u03ae\u03af\7o\2\2\u03af\u03b0\7r\2\2"+
		"\u03b0\u03b1\7q\2\2\u03b1\u03b2\7t\2\2\u03b2\u03b3\7v\2\2\u03b3\u03b4"+
		"\3\2\2\2\u03b4\u03b5\ba\4\2\u03b5\u00c4\3\2\2\2\u03b6\u03b7\7%\2\2\u03b7"+
		"\u03b8\7k\2\2\u03b8\u03b9\7p\2\2\u03b9\u03ba\7e\2\2\u03ba\u03bb\7n\2\2"+
		"\u03bb\u03bc\7w\2\2\u03bc\u03bd\7f\2\2\u03bd\u03be\7g\2\2\u03be\u03bf"+
		"\3\2\2\2\u03bf\u03c0\bb\5\2\u03c0\u00c6\3\2\2\2\u03c1\u03c2\7%\2\2\u03c2"+
		"\u03c3\7r\2\2\u03c3\u03c4\7t\2\2\u03c4\u03c5\7c\2\2\u03c5\u03c6\7i\2\2"+
		"\u03c6\u03c7\7o\2\2\u03c7\u03c8\7c\2\2\u03c8\u00c8\3\2\2\2\u03c9\u03ca"+
		"\7%\2\2\u03ca\u03cb\7f\2\2\u03cb\u03cc\7g\2\2\u03cc\u03cd\7h\2\2\u03cd"+
		"\u03ce\7k\2\2\u03ce\u03cf\7p\2\2\u03cf\u03d0\7g\2\2\u03d0\u00ca\3\2\2"+
		"\2\u03d1\u03d2\7^\2\2\u03d2\u03d7\7\f\2\2\u03d3\u03d4\7^\2\2\u03d4\u03d5"+
		"\7\17\2\2\u03d5\u03d7\7\f\2\2\u03d6\u03d1\3\2\2\2\u03d6\u03d3\3\2\2\2"+
		"\u03d7\u00cc\3\2\2\2\u03d8\u03d9\7%\2\2\u03d9\u03da\7w\2\2\u03da\u03db"+
		"\7p\2\2\u03db\u03dc\7f\2\2\u03dc\u03dd\7g\2\2\u03dd\u03de\7h\2\2\u03de"+
		"\u00ce\3\2\2\2\u03df\u03e0\7%\2\2\u03e0\u03e1\7k\2\2\u03e1\u03e2\7h\2"+
		"\2\u03e2\u03e3\7f\2\2\u03e3\u03e4\7g\2\2\u03e4\u03e5\7h\2\2\u03e5\u00d0"+
		"\3\2\2\2\u03e6\u03e7\7%\2\2\u03e7\u03e8\7k\2\2\u03e8\u03e9\7h\2\2\u03e9"+
		"\u03ea\7p\2\2\u03ea\u03eb\7f\2\2\u03eb\u03ec\7g\2\2\u03ec\u03ed\7h\2\2"+
		"\u03ed\u00d2\3\2\2\2\u03ee\u03ef\7%\2\2\u03ef\u03f0\7k\2\2\u03f0\u03f1"+
		"\7h\2\2\u03f1\u00d4\3\2\2\2\u03f2\u03f3\7%\2\2\u03f3\u03f4\7g\2\2\u03f4"+
		"\u03f5\7n\2\2\u03f5\u03f6\7k\2\2\u03f6\u03f7\7h\2\2\u03f7\u00d6\3\2\2"+
		"\2\u03f8\u03f9\7%\2\2\u03f9\u03fa\7g\2\2\u03fa\u03fb\7n\2\2\u03fb\u03fc"+
		"\7u\2\2\u03fc\u03fd\7g\2\2\u03fd\u00d8\3\2\2\2\u03fe\u03ff\7%\2\2\u03ff"+
		"\u0400\7g\2\2\u0400\u0401\7p\2\2\u0401\u0402\7f\2\2\u0402\u0403\7k\2\2"+
		"\u0403\u0404\7h\2\2\u0404\u00da\3\2\2\2\u0405\u0406\7%\2\2\u0406\u0407"+
		"\7g\2\2\u0407\u0408\7t\2\2\u0408\u0409\7t\2\2\u0409\u040a\7q\2\2\u040a"+
		"\u040b\7t\2\2\u040b\u00dc\3\2\2\2\u040c\u040f\5\u00dfo\2\u040d\u040f\5"+
		"\u00e7s\2\u040e\u040c\3\2\2\2\u040e\u040d\3\2\2\2\u040f\u00de\3\2\2\2"+
		"\u0410\u0414\5\u00e1p\2\u0411\u0414\5\u00e3q\2\u0412\u0414\5\u00e5r\2"+
		"\u0413\u0410\3\2\2\2\u0413\u0411\3\2\2\2\u0413\u0412\3\2\2\2\u0414\u00e0"+
		"\3\2\2\2\u0415\u041b\7\'\2\2\u0416\u0417\7\62\2\2\u0417\u041b\7d\2\2\u0418"+
		"\u0419\7\62\2\2\u0419\u041b\7D\2\2\u041a\u0415\3\2\2\2\u041a\u0416\3\2"+
		"\2\2\u041a\u0418\3\2\2\2\u041b\u041f\3\2\2\2\u041c\u041e\5\u00efw\2\u041d"+
		"\u041c\3\2\2\2\u041e\u0421\3\2\2\2\u041f\u041d\3\2\2\2\u041f\u0420\3\2"+
		"\2\2\u0420\u0422\3\2\2\2\u0421\u041f\3\2\2\2\u0422\u0424\7\60\2\2\u0423"+
		"\u0425\5\u00efw\2\u0424\u0423\3\2\2\2\u0425\u0426\3\2\2\2\u0426\u0424"+
		"\3\2\2\2\u0426\u0427\3\2\2\2\u0427\u00e2\3\2\2\2\u0428\u042a\5\u00f1x"+
		"\2\u0429\u0428\3\2\2\2\u042a\u042d\3\2\2\2\u042b\u0429\3\2\2\2\u042b\u042c"+
		"\3\2\2\2\u042c\u042e\3\2\2\2\u042d\u042b\3\2\2\2\u042e\u0430\7\60\2\2"+
		"\u042f\u0431\5\u00f1x\2\u0430\u042f\3\2\2\2\u0431\u0432\3\2\2\2\u0432"+
		"\u0430\3\2\2\2\u0432\u0433\3\2\2\2\u0433\u00e4\3\2\2\2\u0434\u043a\7&"+
		"\2\2\u0435\u0436\7\62\2\2\u0436\u043a\7z\2\2\u0437\u0438\7\62\2\2\u0438"+
		"\u043a\7Z\2\2\u0439\u0434\3\2\2\2\u0439\u0435\3\2\2\2\u0439\u0437\3\2"+
		"\2\2\u043a\u043e\3\2\2\2\u043b\u043d\5\u00f3y\2\u043c\u043b\3\2\2\2\u043d"+
		"\u0440\3\2\2\2\u043e\u043c\3\2\2\2\u043e\u043f\3\2\2\2\u043f\u0441\3\2"+
		"\2\2\u0440\u043e\3\2\2\2\u0441\u0443\7\60\2\2\u0442\u0444\5\u00f3y\2\u0443"+
		"\u0442\3\2\2\2\u0444\u0445\3\2\2\2\u0445\u0443\3\2\2\2\u0445\u0446\3\2"+
		"\2\2\u0446\u00e6\3\2\2\2\u0447\u044b\5\u00ebu\2\u0448\u044b\5\u00edv\2"+
		"\u0449\u044b\5\u00e9t\2\u044a\u0447\3\2\2\2\u044a\u0448\3\2\2\2\u044a"+
		"\u0449\3\2\2\2\u044b\u044f\3\2\2\2\u044c\u044d\t\2\2\2\u044d\u0450\t\3"+
		"\2\2\u044e\u0450\7n\2\2\u044f\u044c\3\2\2\2\u044f\u044e\3\2\2\2\u044f"+
		"\u0450\3\2\2\2\u0450\u00e8\3\2\2\2\u0451\u0452\7\62\2\2\u0452\u0454\t"+
		"\4\2\2\u0453\u0455\5\u00efw\2\u0454\u0453\3\2\2\2\u0455\u0456\3\2\2\2"+
		"\u0456\u0454\3\2\2\2\u0456\u0457\3\2\2\2\u0457\u045f\3\2\2\2\u0458\u045a"+
		"\7\'\2\2\u0459\u045b\5\u00efw\2\u045a\u0459\3\2\2\2\u045b\u045c\3\2\2"+
		"\2\u045c\u045a\3\2\2\2\u045c\u045d\3\2\2\2\u045d\u045f\3\2\2\2\u045e\u0451"+
		"\3\2\2\2\u045e\u0458\3\2\2\2\u045f\u00ea\3\2\2\2\u0460\u0462\5\u00f1x"+
		"\2\u0461\u0460\3\2\2\2\u0462\u0463\3\2\2\2\u0463\u0461\3\2\2\2\u0463\u0464"+
		"\3\2\2\2\u0464\u00ec\3\2\2\2\u0465\u046b\7&\2\2\u0466\u0467\7\62\2\2\u0467"+
		"\u046b\7z\2\2\u0468\u0469\7\62\2\2\u0469\u046b\7Z\2\2\u046a\u0465\3\2"+
		"\2\2\u046a\u0466\3\2\2\2\u046a\u0468\3\2\2\2\u046b\u046d\3\2\2\2\u046c"+
		"\u046e\5\u00f3y\2\u046d\u046c\3\2\2\2\u046e\u046f\3\2\2\2\u046f\u046d"+
		"\3\2\2\2\u046f\u0470\3\2\2\2\u0470\u00ee\3\2\2\2\u0471\u0472\t\5\2\2\u0472"+
		"\u00f0\3\2\2\2\u0473\u0474\t\6\2\2\u0474\u00f2\3\2\2\2\u0475\u0476\t\7"+
		"\2\2\u0476\u00f4\3\2\2\2\u0477\u047b\5\u00f7{\2\u0478\u047a\5\u00f9|\2"+
		"\u0479\u0478\3\2\2\2\u047a\u047d\3\2\2\2\u047b\u0479\3\2\2\2\u047b\u047c"+
		"\3\2\2\2\u047c\u047e\3\2\2\2\u047d\u047b\3\2\2\2\u047e\u047f\bz\6\2\u047f"+
		"\u00f6\3\2\2\2\u0480\u0481\t\b\2\2\u0481\u00f8\3\2\2\2\u0482\u0483\t\t"+
		"\2\2\u0483\u00fa\3\2\2\2\u0484\u048a\7$\2\2\u0485\u0486\7^\2\2\u0486\u0489"+
		"\7$\2\2\u0487\u0489\n\n\2\2\u0488\u0485\3\2\2\2\u0488\u0487\3\2\2\2\u0489"+
		"\u048c\3\2\2\2\u048a\u0488\3\2\2\2\u048a\u048b\3\2\2\2\u048b\u048d\3\2"+
		"\2\2\u048c\u048a\3\2\2\2\u048d\u048f\7$\2\2\u048e\u0490\t\13\2\2\u048f"+
		"\u048e\3\2\2\2\u048f\u0490\3\2\2\2\u0490\u0495\3\2\2\2\u0491\u0493\t\f"+
		"\2\2\u0492\u0494\t\r\2\2\u0493\u0492\3\2\2\2\u0493\u0494\3\2\2\2\u0494"+
		"\u0496\3\2\2\2\u0495\u0491\3\2\2\2\u0495\u0496\3\2\2\2\u0496\u0498\3\2"+
		"\2\2\u0497\u0499\t\13\2\2\u0498\u0497\3\2\2\2\u0498\u0499\3\2\2\2\u0499"+
		"\u00fc\3\2\2\2\u049a\u04a3\7)\2\2\u049b\u04a0\7^\2\2\u049c\u04a1\t\16"+
		"\2\2\u049d\u049e\7z\2\2\u049e\u049f\t\17\2\2\u049f\u04a1\t\17\2\2\u04a0"+
		"\u049c\3\2\2\2\u04a0\u049d\3\2\2\2\u04a1\u04a4\3\2\2\2\u04a2\u04a4\n\20"+
		"\2\2\u04a3\u049b\3\2\2\2\u04a3\u04a2\3\2\2\2\u04a4\u04a5\3\2\2\2\u04a5"+
		"\u04a6\7)\2\2\u04a6\u00fe\3\2\2\2\u04a7\u04a9\t\21\2\2\u04a8\u04a7\3\2"+
		"\2\2\u04a9\u04aa\3\2\2\2\u04aa\u04a8\3\2\2\2\u04aa\u04ab\3\2\2\2\u04ab"+
		"\u04ac\3\2\2\2\u04ac\u04ad\b\177\7\2\u04ad\u0100\3\2\2\2\u04ae\u04af\7"+
		"\61\2\2\u04af\u04b0\7\61\2\2\u04b0\u04b4\3\2\2\2\u04b1\u04b3\n\22\2\2"+
		"\u04b2\u04b1\3\2\2\2\u04b3\u04b6\3\2\2\2\u04b4\u04b2\3\2\2\2\u04b4\u04b5"+
		"\3\2\2\2\u04b5\u04b7\3\2\2\2\u04b6\u04b4\3\2\2\2\u04b7\u04b8\b\u0080\b"+
		"\2\u04b8\u0102\3\2\2\2\u04b9\u04ba\7\61\2\2\u04ba\u04bb\7,\2\2\u04bb\u04bf"+
		"\3\2\2\2\u04bc\u04be\13\2\2\2\u04bd\u04bc\3\2\2\2\u04be\u04c1\3\2\2\2"+
		"\u04bf\u04c0\3\2\2\2\u04bf\u04bd\3\2\2\2\u04c0\u04c2\3\2\2\2\u04c1\u04bf"+
		"\3\2\2\2\u04c2\u04c3\7,\2\2\u04c3\u04c4\7\61\2\2\u04c4\u04c5\3\2\2\2\u04c5"+
		"\u04c6\b\u0081\b\2\u04c6\u0104\3\2\2\2\u04c7\u04c8\7\60\2\2\u04c8\u04c9"+
		"\7d\2\2\u04c9\u04ca\7{\2\2\u04ca\u04cb\7v\2\2\u04cb\u04cc\7g\2\2\u04cc"+
		"\u0106\3\2\2\2\u04cd\u04ce\7d\2\2\u04ce\u04cf\7t\2\2\u04cf\u05ac\7m\2"+
		"\2\u04d0\u04d1\7q\2\2\u04d1\u04d2\7t\2\2\u04d2\u05ac\7c\2\2\u04d3\u04d4"+
		"\7m\2\2\u04d4\u04d5\7k\2\2\u04d5\u05ac\7n\2\2\u04d6\u04d7\7u\2\2\u04d7"+
		"\u04d8\7n\2\2\u04d8\u05ac\7q\2\2\u04d9\u04da\7p\2\2\u04da\u04db\7q\2\2"+
		"\u04db\u05ac\7r\2\2\u04dc\u04dd\7c\2\2\u04dd\u04de\7u\2\2\u04de\u05ac"+
		"\7n\2\2\u04df\u04e0\7r\2\2\u04e0\u04e1\7j\2\2\u04e1\u05ac\7r\2\2\u04e2"+
		"\u04e3\7c\2\2\u04e3\u04e4\7p\2\2\u04e4\u05ac\7e\2\2\u04e5\u04e6\7d\2\2"+
		"\u04e6\u04e7\7r\2\2\u04e7\u05ac\7n\2\2\u04e8\u04e9\7e\2\2\u04e9\u04ea"+
		"\7n\2\2\u04ea\u05ac\7e\2\2\u04eb\u04ec\7l\2\2\u04ec\u04ed\7u\2\2\u04ed"+
		"\u05ac\7t\2\2\u04ee\u04ef\7c\2\2\u04ef\u04f0\7p\2\2\u04f0\u05ac\7f\2\2"+
		"\u04f1\u04f2\7t\2\2\u04f2\u04f3\7n\2\2\u04f3\u05ac\7c\2\2\u04f4\u04f5"+
		"\7d\2\2\u04f5\u04f6\7k\2\2\u04f6\u05ac\7v\2\2\u04f7\u04f8\7t\2\2\u04f8"+
		"\u04f9\7q\2\2\u04f9\u05ac\7n\2\2\u04fa\u04fb\7r\2\2\u04fb\u04fc\7n\2\2"+
		"\u04fc\u05ac\7c\2\2\u04fd\u04fe\7r\2\2\u04fe\u04ff\7n\2\2\u04ff\u05ac"+
		"\7r\2\2\u0500\u0501\7d\2\2\u0501\u0502\7o\2\2\u0502\u05ac\7k\2\2\u0503"+
		"\u0504\7u\2\2\u0504\u0505\7g\2\2\u0505\u05ac\7e\2\2\u0506\u0507\7t\2\2"+
		"\u0507\u0508\7v\2\2\u0508\u05ac\7k\2\2\u0509\u050a\7g\2\2\u050a\u050b"+
		"\7q\2\2\u050b\u05ac\7t\2\2\u050c\u050d\7u\2\2\u050d\u050e\7t\2\2\u050e"+
		"\u05ac\7g\2\2\u050f\u0510\7n\2\2\u0510\u0511\7u\2\2\u0511\u05ac\7t\2\2"+
		"\u0512\u0513\7r\2\2\u0513\u0514\7j\2\2\u0514\u05ac\7c\2\2\u0515\u0516"+
		"\7c\2\2\u0516\u0517\7n\2\2\u0517\u05ac\7t\2\2\u0518\u0519\7l\2\2\u0519"+
		"\u051a\7o\2\2\u051a\u05ac\7r\2\2\u051b\u051c\7d\2\2\u051c\u051d\7x\2\2"+
		"\u051d\u05ac\7e\2\2\u051e\u051f\7e\2\2\u051f\u0520\7n\2\2\u0520\u05ac"+
		"\7k\2\2\u0521\u0522\7t\2\2\u0522\u0523\7v\2\2\u0523\u05ac\7u\2\2\u0524"+
		"\u0525\7c\2\2\u0525\u0526\7f\2\2\u0526\u05ac\7e\2\2\u0527\u0528\7t\2\2"+
		"\u0528\u0529\7t\2\2\u0529\u05ac\7c\2\2\u052a\u052b\7d\2\2\u052b\u052c"+
		"\7x\2\2\u052c\u05ac\7u\2\2\u052d\u052e\7u\2\2\u052e\u052f\7g\2\2\u052f"+
		"\u05ac\7k\2\2\u0530\u0531\7u\2\2\u0531\u0532\7c\2\2\u0532\u05ac\7z\2\2"+
		"\u0533\u0534\7u\2\2\u0534\u0535\7v\2\2\u0535\u05ac\7{\2\2\u0536\u0537"+
		"\7u\2\2\u0537\u0538\7v\2\2\u0538\u05ac\7c\2\2\u0539\u053a\7u\2\2\u053a"+
		"\u053b\7v\2\2\u053b\u05ac\7z\2\2\u053c\u053d\7f\2\2\u053d\u053e\7g\2\2"+
		"\u053e\u05ac\7{\2\2\u053f\u0540\7v\2\2\u0540\u0541\7z\2\2\u0541\u05ac"+
		"\7c\2\2\u0542\u0543\7z\2\2\u0543\u0544\7c\2\2\u0544\u05ac\7c\2\2\u0545"+
		"\u0546\7d\2\2\u0546\u0547\7e\2\2\u0547\u05ac\7e\2\2\u0548\u0549\7c\2\2"+
		"\u0549\u054a\7j\2\2\u054a\u05ac\7z\2\2\u054b\u054c\7v\2\2\u054c\u054d"+
		"\7{\2\2\u054d\u05ac\7c\2\2\u054e\u054f\7v\2\2\u054f\u0550\7z\2\2\u0550"+
		"\u05ac\7u\2\2\u0551\u0552\7v\2\2\u0552\u0553\7c\2\2\u0553\u05ac\7u\2\2"+
		"\u0554\u0555\7u\2\2\u0555\u0556\7j\2\2\u0556\u05ac\7{\2\2\u0557\u0558"+
		"\7u\2\2\u0558\u0559\7j\2\2\u0559\u05ac\7z\2\2\u055a\u055b\7n\2\2\u055b"+
		"\u055c\7f\2\2\u055c\u05ac\7{\2\2\u055d\u055e\7n\2\2\u055e\u055f\7f\2\2"+
		"\u055f\u05ac\7c\2\2\u0560\u0561\7n\2\2\u0561\u0562\7f\2\2\u0562\u05ac"+
		"\7z\2\2\u0563\u0564\7n\2\2\u0564\u0565\7c\2\2\u0565\u05ac\7z\2\2\u0566"+
		"\u0567\7v\2\2\u0567\u0568\7c\2\2\u0568\u05ac\7{\2\2\u0569\u056a\7v\2\2"+
		"\u056a\u056b\7c\2\2\u056b\u05ac\7z\2\2\u056c\u056d\7d\2\2\u056d\u056e"+
		"\7e\2\2\u056e\u05ac\7u\2\2\u056f\u0570\7e\2\2\u0570\u0571\7n\2\2\u0571"+
		"\u05ac\7x\2\2\u0572\u0573\7v\2\2\u0573\u0574\7u\2\2\u0574\u05ac\7z\2\2"+
		"\u0575\u0576\7n\2\2\u0576\u0577\7c\2\2\u0577\u05ac\7u\2\2\u0578\u0579"+
		"\7e\2\2\u0579\u057a\7r\2\2\u057a\u05ac\7{\2\2\u057b\u057c\7e\2\2\u057c"+
		"\u057d\7o\2\2\u057d\u05ac\7r\2\2\u057e\u057f\7e\2\2\u057f\u0580\7r\2\2"+
		"\u0580\u05ac\7z\2\2\u0581\u0582\7f\2\2\u0582\u0583\7e\2\2\u0583\u05ac"+
		"\7r\2\2\u0584\u0585\7f\2\2\u0585\u0586\7g\2\2\u0586\u05ac\7e\2\2\u0587"+
		"\u0588\7k\2\2\u0588\u0589\7p\2\2\u0589\u05ac\7e\2\2\u058a\u058b\7c\2\2"+
		"\u058b\u058c\7z\2\2\u058c\u05ac\7u\2\2\u058d\u058e\7d\2\2\u058e\u058f"+
		"\7p\2\2\u058f\u05ac\7g\2\2\u0590\u0591\7e\2\2\u0591\u0592\7n\2\2\u0592"+
		"\u05ac\7f\2\2\u0593\u0594\7u\2\2\u0594\u0595\7d\2\2\u0595\u05ac\7e\2\2"+
		"\u0596\u0597\7k\2\2\u0597\u0598\7u\2\2\u0598\u05ac\7e\2\2\u0599\u059a"+
		"\7k\2\2\u059a\u059b\7p\2\2\u059b\u05ac\7z\2\2\u059c\u059d\7d\2\2\u059d"+
		"\u059e\7g\2\2\u059e\u05ac\7s\2\2\u059f\u05a0\7u\2\2\u05a0\u05a1\7g\2\2"+
		"\u05a1\u05ac\7f\2\2\u05a2\u05a3\7f\2\2\u05a3\u05a4\7g\2\2\u05a4\u05ac"+
		"\7z\2\2\u05a5\u05a6\7k\2\2\u05a6\u05a7\7p\2\2\u05a7\u05ac\7{\2\2\u05a8"+
		"\u05a9\7t\2\2\u05a9\u05aa\7q\2\2\u05aa\u05ac\7t\2\2\u05ab\u04cd\3\2\2"+
		"\2\u05ab\u04d0\3\2\2\2\u05ab\u04d3\3\2\2\2\u05ab\u04d6\3\2\2\2\u05ab\u04d9"+
		"\3\2\2\2\u05ab\u04dc\3\2\2\2\u05ab\u04df\3\2\2\2\u05ab\u04e2\3\2\2\2\u05ab"+
		"\u04e5\3\2\2\2\u05ab\u04e8\3\2\2\2\u05ab\u04eb\3\2\2\2\u05ab\u04ee\3\2"+
		"\2\2\u05ab\u04f1\3\2\2\2\u05ab\u04f4\3\2\2\2\u05ab\u04f7\3\2\2\2\u05ab"+
		"\u04fa\3\2\2\2\u05ab\u04fd\3\2\2\2\u05ab\u0500\3\2\2\2\u05ab\u0503\3\2"+
		"\2\2\u05ab\u0506\3\2\2\2\u05ab\u0509\3\2\2\2\u05ab\u050c\3\2\2\2\u05ab"+
		"\u050f\3\2\2\2\u05ab\u0512\3\2\2\2\u05ab\u0515\3\2\2\2\u05ab\u0518\3\2"+
		"\2\2\u05ab\u051b\3\2\2\2\u05ab\u051e\3\2\2\2\u05ab\u0521\3\2\2\2\u05ab"+
		"\u0524\3\2\2\2\u05ab\u0527\3\2\2\2\u05ab\u052a\3\2\2\2\u05ab\u052d\3\2"+
		"\2\2\u05ab\u0530\3\2\2\2\u05ab\u0533\3\2\2\2\u05ab\u0536\3\2\2\2\u05ab"+
		"\u0539\3\2\2\2\u05ab\u053c\3\2\2\2\u05ab\u053f\3\2\2\2\u05ab\u0542\3\2"+
		"\2\2\u05ab\u0545\3\2\2\2\u05ab\u0548\3\2\2\2\u05ab\u054b\3\2\2\2\u05ab"+
		"\u054e\3\2\2\2\u05ab\u0551\3\2\2\2\u05ab\u0554\3\2\2\2\u05ab\u0557\3\2"+
		"\2\2\u05ab\u055a\3\2\2\2\u05ab\u055d\3\2\2\2\u05ab\u0560\3\2\2\2\u05ab"+
		"\u0563\3\2\2\2\u05ab\u0566\3\2\2\2\u05ab\u0569\3\2\2\2\u05ab\u056c\3\2"+
		"\2\2\u05ab\u056f\3\2\2\2\u05ab\u0572\3\2\2\2\u05ab\u0575\3\2\2\2\u05ab"+
		"\u0578\3\2\2\2\u05ab\u057b\3\2\2\2\u05ab\u057e\3\2\2\2\u05ab\u0581\3\2"+
		"\2\2\u05ab\u0584\3\2\2\2\u05ab\u0587\3\2\2\2\u05ab\u058a\3\2\2\2\u05ab"+
		"\u058d\3\2\2\2\u05ab\u0590\3\2\2\2\u05ab\u0593\3\2\2\2\u05ab\u0596\3\2"+
		"\2\2\u05ab\u0599\3\2\2\2\u05ab\u059c\3\2\2\2\u05ab\u059f\3\2\2\2\u05ab"+
		"\u05a2\3\2\2\2\u05ab\u05a5\3\2\2\2\u05ab\u05a8\3\2\2\2\u05ac\u0108\3\2"+
		"\2\2\u05ad\u05ae\7%\2\2\u05ae\u010a\3\2\2\2\u05af\u05b0\7<\2\2\u05b0\u010c"+
		"\3\2\2\2\u05b1\u05b2\7.\2\2\u05b2\u010e\3\2\2\2\u05b3\u05b4\7*\2\2\u05b4"+
		"\u0110\3\2\2\2\u05b5\u05b6\7+\2\2\u05b6\u0112\3\2\2\2\u05b7\u05b8\7]\2"+
		"\2\u05b8\u0114\3\2\2\2\u05b9\u05ba\7_\2\2\u05ba\u0116\3\2\2\2\u05bb\u05bc"+
		"\7\60\2\2\u05bc\u0118\3\2\2\2\u05bd\u05be\7>\2\2\u05be\u05bf\7>\2\2\u05bf"+
		"\u011a\3\2\2\2\u05c0\u05c1\7@\2\2\u05c1\u05c2\7@\2\2\u05c2\u011c\3\2\2"+
		"\2\u05c3\u05c4\7-\2\2\u05c4\u011e\3\2\2\2\u05c5\u05c6\7/\2\2\u05c6\u0120"+
		"\3\2\2\2\u05c7\u05c8\7>\2\2\u05c8\u0122\3\2\2\2\u05c9\u05ca\7@\2\2\u05ca"+
		"\u0124\3\2\2\2\u05cb\u05cc\7,\2\2\u05cc\u0126\3\2\2\2\u05cd\u05ce\7\61"+
		"\2\2\u05ce\u0128\3\2\2\2\u05cf\u05d0\7}\2\2\u05d0\u05d1\b\u0094\t\2\u05d1"+
		"\u012a\3\2\2\2\u05d2\u05d3\7\177\2\2\u05d3\u05d4\b\u0095\n\2\u05d4\u012c"+
		"\3\2\2\2\u05d5\u05d8\5\u012f\u0097\2\u05d6\u05d8\5\u0137\u009b\2\u05d7"+
		"\u05d5\3\2\2\2\u05d7\u05d6\3\2\2\2\u05d8\u012e\3\2\2\2\u05d9\u05dd\5\u0131"+
		"\u0098\2\u05da\u05dd\5\u0133\u0099\2\u05db\u05dd\5\u0135\u009a\2\u05dc"+
		"\u05d9\3\2\2\2\u05dc\u05da\3\2\2\2\u05dc\u05db\3\2\2\2\u05dd\u0130\3\2"+
		"\2\2\u05de\u05e2\7\'\2\2\u05df\u05e1\5\u013f\u009f\2\u05e0\u05df\3\2\2"+
		"\2\u05e1\u05e4\3\2\2\2\u05e2\u05e0\3\2\2\2\u05e2\u05e3\3\2\2\2\u05e3\u05e5"+
		"\3\2\2\2\u05e4\u05e2\3\2\2\2\u05e5\u05e7\7\60\2\2\u05e6\u05e8\5\u013f"+
		"\u009f\2\u05e7\u05e6\3\2\2\2\u05e8\u05e9\3\2\2\2\u05e9\u05e7\3\2\2\2\u05e9"+
		"\u05ea\3\2\2\2\u05ea\u0132\3\2\2\2\u05eb\u05ed\5\u0141\u00a0\2\u05ec\u05eb"+
		"\3\2\2\2\u05ed\u05f0\3\2\2\2\u05ee\u05ec\3\2\2\2\u05ee\u05ef\3\2\2\2\u05ef"+
		"\u05f1\3\2\2\2\u05f0\u05ee\3\2\2\2\u05f1\u05f3\7\60\2\2\u05f2\u05f4\5"+
		"\u0141\u00a0\2\u05f3\u05f2\3\2\2\2\u05f4\u05f5\3\2\2\2\u05f5\u05f3\3\2"+
		"\2\2\u05f5\u05f6\3\2\2\2\u05f6\u0134\3\2\2\2\u05f7\u05fb\7&\2\2\u05f8"+
		"\u05fa\5\u0143\u00a1\2\u05f9\u05f8\3\2\2\2\u05fa\u05fd\3\2\2\2\u05fb\u05f9"+
		"\3\2\2\2\u05fb\u05fc\3\2\2\2\u05fc\u05fe\3\2\2\2\u05fd\u05fb\3\2\2\2\u05fe"+
		"\u0600\7\60\2\2\u05ff\u0601\5\u0143\u00a1\2\u0600\u05ff\3\2\2\2\u0601"+
		"\u0602\3\2\2\2\u0602\u0600\3\2\2\2\u0602\u0603\3\2\2\2\u0603\u0136\3\2"+
		"\2\2\u0604\u0608\5\u013b\u009d\2\u0605\u0608\5\u013d\u009e\2\u0606\u0608"+
		"\5\u0139\u009c\2\u0607\u0604\3\2\2\2\u0607\u0605\3\2\2\2\u0607\u0606\3"+
		"\2\2\2\u0608\u0138\3\2\2\2\u0609\u060b\7\'\2\2\u060a\u060c\5\u013f\u009f"+
		"\2\u060b\u060a\3\2\2\2\u060c\u060d\3\2\2\2\u060d\u060b\3\2\2\2\u060d\u060e"+
		"\3\2\2\2\u060e\u013a\3\2\2\2\u060f\u0611\5\u0141\u00a0\2\u0610\u060f\3"+
		"\2\2\2\u0611\u0612\3\2\2\2\u0612\u0610\3\2\2\2\u0612\u0613\3\2\2\2\u0613"+
		"\u013c\3\2\2\2\u0614\u0616\7&\2\2\u0615\u0617\5\u0143\u00a1\2\u0616\u0615"+
		"\3\2\2\2\u0617\u0618\3\2\2\2\u0618\u0616\3\2\2\2\u0618\u0619\3\2\2\2\u0619"+
		"\u013e\3\2\2\2\u061a\u061b\t\5\2\2\u061b\u0140\3\2\2\2\u061c\u061d\t\6"+
		"\2\2\u061d\u0142\3\2\2\2\u061e\u061f\t\7\2\2\u061f\u0144\3\2\2\2\u0620"+
		"\u0624\7)\2\2\u0621\u0622\7^\2\2\u0622\u0625\t\16\2\2\u0623\u0625\n\20"+
		"\2\2\u0624\u0621\3\2\2\2\u0624\u0623\3\2\2\2\u0625\u0626\3\2\2\2\u0626"+
		"\u0627\7)\2\2\u0627\u0146\3\2\2\2\u0628\u062a\5\u0149\u00a4\2\u0629\u062b"+
		"\t\23\2\2\u062a\u0629\3\2\2\2\u062b\u062c\3\2\2\2\u062c\u062a\3\2\2\2"+
		"\u062c\u062d\3\2\2\2\u062d\u0148\3\2\2\2\u062e\u0632\7#\2\2\u062f\u0631"+
		"\5\u014f\u00a7\2\u0630\u062f\3\2\2\2\u0631\u0634\3\2\2\2\u0632\u0630\3"+
		"\2\2\2\u0632\u0633\3\2\2\2\u0633\u014a\3\2\2\2\u0634\u0632\3\2\2\2\u0635"+
		"\u0639\5\u014d\u00a6\2\u0636\u0638\5\u014f\u00a7\2\u0637\u0636\3\2\2\2"+
		"\u0638\u063b\3\2\2\2\u0639\u0637\3\2\2\2\u0639\u063a\3\2\2\2\u063a\u014c"+
		"\3\2\2\2\u063b\u0639\3\2\2\2\u063c\u063d\t\b\2\2\u063d\u014e\3\2\2\2\u063e"+
		"\u063f\t\t\2\2\u063f\u0150\3\2\2\2\u0640\u0642\t\21\2\2\u0641\u0640\3"+
		"\2\2\2\u0642\u0643\3\2\2\2\u0643\u0641\3\2\2\2\u0643\u0644\3\2\2\2\u0644"+
		"\u0645\3\2\2\2\u0645\u0646\b\u00a8\7\2\u0646\u0152\3\2\2\2\u0647\u0648"+
		"\7\61\2\2\u0648\u0649\7\61\2\2\u0649\u064d\3\2\2\2\u064a\u064c\n\22\2"+
		"\2\u064b\u064a\3\2\2\2\u064c\u064f\3\2\2\2\u064d\u064b\3\2\2\2\u064d\u064e"+
		"\3\2\2\2\u064e\u0650\3\2\2\2\u064f\u064d\3\2\2\2\u0650\u0651\b\u00a9\b"+
		"\2\u0651\u0154\3\2\2\2\u0652\u0653\7\61\2\2\u0653\u0654\7,\2\2\u0654\u0658"+
		"\3\2\2\2\u0655\u0657\13\2\2\2\u0656\u0655\3\2\2\2\u0657\u065a\3\2\2\2"+
		"\u0658\u0659\3\2\2\2\u0658\u0656\3\2\2\2\u0659\u065b\3\2\2\2\u065a\u0658"+
		"\3\2\2\2\u065b\u065c\7,\2\2\u065c\u065d\7\61\2\2\u065d\u065e\3\2\2\2\u065e"+
		"\u065f\b\u00aa\b\2\u065f\u0156\3\2\2\2\u0660\u0662\7>\2\2\u0661\u0663"+
		"\t\24\2\2\u0662\u0661\3\2\2\2\u0663\u0664\3\2\2\2\u0664\u0662\3\2\2\2"+
		"\u0664\u0665\3\2\2\2\u0665\u0666\3\2\2\2\u0666\u0667\7@\2\2\u0667\u0668"+
		"\b\u00ab\13\2\u0668\u0158\3\2\2\2\u0669\u066f\7$\2\2\u066a\u066b\7^\2"+
		"\2\u066b\u066e\7$\2\2\u066c\u066e\n\n\2\2\u066d\u066a\3\2\2\2\u066d\u066c"+
		"\3\2\2\2\u066e\u0671\3\2\2\2\u066f\u066d\3\2\2\2\u066f\u0670\3\2\2\2\u0670"+
		"\u0672\3\2\2\2\u0671\u066f\3\2\2\2\u0672\u0673\7$\2\2\u0673\u0674\b\u00ac"+
		"\f\2\u0674\u015a\3\2\2\2\u0675\u0677\t\21\2\2\u0676\u0675\3\2\2\2\u0677"+
		"\u0678\3\2\2\2\u0678\u0676\3\2\2\2\u0678\u0679\3\2\2\2\u0679\u067a\3\2"+
		"\2\2\u067a\u067b\b\u00ad\7\2\u067b\u015c\3\2\2\2\u067c\u067d\7\61\2\2"+
		"\u067d\u067e\7\61\2\2\u067e\u0682\3\2\2\2\u067f\u0681\n\22\2\2\u0680\u067f"+
		"\3\2\2\2\u0681\u0684\3\2\2\2\u0682\u0680\3\2\2\2\u0682\u0683\3\2\2\2\u0683"+
		"\u0685\3\2\2\2\u0684\u0682\3\2\2\2\u0685\u0686\b\u00ae\b\2\u0686\u015e"+
		"\3\2\2\2\u0687\u0688\7\61\2\2\u0688\u0689\7,\2\2\u0689\u068d\3\2\2\2\u068a"+
		"\u068c\13\2\2\2\u068b\u068a\3\2\2\2\u068c\u068f\3\2\2\2\u068d\u068e\3"+
		"\2\2\2\u068d\u068b\3\2\2\2\u068e\u0690\3\2\2\2\u068f\u068d\3\2\2\2\u0690"+
		"\u0691\7,\2\2\u0691\u0692\7\61\2\2\u0692\u0693\3\2\2\2\u0693\u0694\b\u00af"+
		"\b\2\u0694\u0160\3\2\2\2D\2\3\4\u01ce\u02bd\u036c\u0393\u039e\u03a6\u03d6"+
		"\u040e\u0413\u041a\u041f\u0426\u042b\u0432\u0439\u043e\u0445\u044a\u044f"+
		"\u0456\u045c\u045e\u0463\u046a\u046f\u047b\u0488\u048a\u048f\u0493\u0495"+
		"\u0498\u04a0\u04a3\u04aa\u04b4\u04bf\u05ab\u05d7\u05dc\u05e2\u05e9\u05ee"+
		"\u05f5\u05fb\u0602\u0607\u060d\u0612\u0618\u0624\u062c\u0632\u0639\u0643"+
		"\u064d\u0658\u0664\u066d\u066f\u0678\u0682\u068d\r\3\2\2\3N\3\3a\4\3b"+
		"\5\3z\6\2\3\2\2\4\2\3\u0094\7\3\u0095\b\3\u00ab\t\3\u00ac\n";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}
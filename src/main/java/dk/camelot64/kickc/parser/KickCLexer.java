// Generated from /Users/jespergravgaard/c64/kickc/src/main/java/dk/camelot64/kickc/parser/KickCLexer.g4 by ANTLR 4.7.2
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
		CPU=44, CODESEG=45, DATASEG=46, ENCODING=47, CONST=48, EXTERN=49, EXPORT=50, 
		ALIGN=51, INLINE=52, VOLATILE=53, STATIC=54, INTERRUPT=55, REGISTER=56, 
		ADDRESS=57, ADDRESS_ZEROPAGE=58, ADDRESS_MAINMEM=59, FORM_SSA=60, FORM_MA=61, 
		INTRINSIC=62, CALLING=63, CALLINGCONVENTION=64, VARMODEL=65, IF=66, ELSE=67, 
		WHILE=68, DO=69, FOR=70, SWITCH=71, RETURN=72, BREAK=73, CONTINUE=74, 
		ASM=75, DEFAULT=76, CASE=77, STRUCT=78, ENUM=79, SIZEOF=80, TYPEID=81, 
		DEFINED=82, KICKASM=83, RESOURCE=84, USES=85, CLOBBERS=86, BYTES=87, CYCLES=88, 
		LOGIC_NOT=89, SIGNEDNESS=90, SIMPLETYPE=91, BOOLEAN=92, KICKASM_BODY=93, 
		IMPORT=94, INCLUDE=95, PRAGMA=96, DEFINE=97, DEFINE_CONTINUE=98, UNDEF=99, 
		IFDEF=100, IFNDEF=101, IFIF=102, ELIF=103, IFELSE=104, ENDIF=105, NUMBER=106, 
		NUMFLOAT=107, BINFLOAT=108, DECFLOAT=109, HEXFLOAT=110, NUMINT=111, BININTEGER=112, 
		DECINTEGER=113, HEXINTEGER=114, NAME=115, STRING=116, CHAR=117, WS=118, 
		COMMENT_LINE=119, COMMENT_BLOCK=120, ASM_BYTE=121, ASM_MNEMONIC=122, ASM_IMM=123, 
		ASM_COLON=124, ASM_COMMA=125, ASM_PAR_BEGIN=126, ASM_PAR_END=127, ASM_BRACKET_BEGIN=128, 
		ASM_BRACKET_END=129, ASM_DOT=130, ASM_SHIFT_LEFT=131, ASM_SHIFT_RIGHT=132, 
		ASM_PLUS=133, ASM_MINUS=134, ASM_LESS_THAN=135, ASM_GREATER_THAN=136, 
		ASM_MULTIPLY=137, ASM_DIVIDE=138, ASM_CURLY_BEGIN=139, ASM_CURLY_END=140, 
		ASM_NUMBER=141, ASM_NUMFLOAT=142, ASM_BINFLOAT=143, ASM_DECFLOAT=144, 
		ASM_HEXFLOAT=145, ASM_NUMINT=146, ASM_BININTEGER=147, ASM_DECINTEGER=148, 
		ASM_HEXINTEGER=149, ASM_CHAR=150, ASM_MULTI_REL=151, ASM_MULTI_NAME=152, 
		ASM_NAME=153, ASM_WS=154, ASM_COMMENT_LINE=155, ASM_COMMENT_BLOCK=156, 
		IMPORT_SYSTEMFILE=157, IMPORT_LOCALFILE=158, IMPORT_WS=159, IMPORT_COMMENT_LINE=160, 
		IMPORT_COMMENT_BLOCK=161;
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
			"TYPEDEF", "RESERVE", "PC", "TARGET", "LINK", "CPU", "CODESEG", "DATASEG", 
			"ENCODING", "CONST", "EXTERN", "EXPORT", "ALIGN", "INLINE", "VOLATILE", 
			"STATIC", "INTERRUPT", "REGISTER", "ADDRESS", "ADDRESS_ZEROPAGE", "ADDRESS_MAINMEM", 
			"FORM_SSA", "FORM_MA", "INTRINSIC", "CALLING", "CALLINGCONVENTION", "VARMODEL", 
			"IF", "ELSE", "WHILE", "DO", "FOR", "SWITCH", "RETURN", "BREAK", "CONTINUE", 
			"ASM", "DEFAULT", "CASE", "STRUCT", "ENUM", "SIZEOF", "TYPEID", "DEFINED", 
			"KICKASM", "RESOURCE", "USES", "CLOBBERS", "BYTES", "CYCLES", "LOGIC_NOT", 
			"SIGNEDNESS", "SIMPLETYPE", "BOOLEAN", "KICKASM_BODY", "IMPORT", "INCLUDE", 
			"PRAGMA", "DEFINE", "DEFINE_CONTINUE", "UNDEF", "IFDEF", "IFNDEF", "IFIF", 
			"ELIF", "IFELSE", "ENDIF", "NUMBER", "NUMFLOAT", "BINFLOAT", "DECFLOAT", 
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
			"'<='", "'>='", null, "'&&'", "'||'", "'='", null, "'typedef'", "'reserve'", 
			"'pc'", "'target'", "'link'", "'cpu'", "'code_seg'", "'data_seg'", "'encoding'", 
			"'const'", "'extern'", "'export'", "'align'", "'inline'", "'volatile'", 
			"'static'", "'interrupt'", "'register'", "'__address'", "'__zp'", "'__mem'", 
			"'__ssa'", "'__ma'", "'__intrinsic'", "'calling'", null, "'var_model'", 
			"'if'", "'else'", "'while'", "'do'", "'for'", "'switch'", "'return'", 
			"'break'", "'continue'", "'asm'", "'default'", "'case'", "'struct'", 
			"'enum'", "'sizeof'", "'typeid'", "'defined'", "'kickasm'", "'resource'", 
			"'uses'", "'clobbers'", "'bytes'", "'cycles'", "'!'", null, null, null, 
			null, "'#import'", "'#include'", "'#pragma'", "'#define'", null, "'#undef'", 
			"'#ifdef'", "'#ifndef'", "'#if'", "'#elif'", "'#else'", "'#endif'", null, 
			null, null, null, null, null, null, null, null, null, null, null, null, 
			null, null, "'.byte'", null, "'#'"
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
			"TYPEDEF", "RESERVE", "PC", "TARGET", "LINK", "CPU", "CODESEG", "DATASEG", 
			"ENCODING", "CONST", "EXTERN", "EXPORT", "ALIGN", "INLINE", "VOLATILE", 
			"STATIC", "INTERRUPT", "REGISTER", "ADDRESS", "ADDRESS_ZEROPAGE", "ADDRESS_MAINMEM", 
			"FORM_SSA", "FORM_MA", "INTRINSIC", "CALLING", "CALLINGCONVENTION", "VARMODEL", 
			"IF", "ELSE", "WHILE", "DO", "FOR", "SWITCH", "RETURN", "BREAK", "CONTINUE", 
			"ASM", "DEFAULT", "CASE", "STRUCT", "ENUM", "SIZEOF", "TYPEID", "DEFINED", 
			"KICKASM", "RESOURCE", "USES", "CLOBBERS", "BYTES", "CYCLES", "LOGIC_NOT", 
			"SIGNEDNESS", "SIMPLETYPE", "BOOLEAN", "KICKASM_BODY", "IMPORT", "INCLUDE", 
			"PRAGMA", "DEFINE", "DEFINE_CONTINUE", "UNDEF", "IFDEF", "IFNDEF", "IFIF", 
			"ELIF", "IFELSE", "ENDIF", "NUMBER", "NUMFLOAT", "BINFLOAT", "DECFLOAT", 
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
		case 73:
			ASM_action((RuleContext)_localctx, actionIndex);
			break;
		case 92:
			IMPORT_action((RuleContext)_localctx, actionIndex);
			break;
		case 93:
			INCLUDE_action((RuleContext)_localctx, actionIndex);
			break;
		case 116:
			NAME_action((RuleContext)_localctx, actionIndex);
			break;
		case 142:
			ASM_CURLY_BEGIN_action((RuleContext)_localctx, actionIndex);
			break;
		case 143:
			ASM_CURLY_END_action((RuleContext)_localctx, actionIndex);
			break;
		case 165:
			IMPORT_SYSTEMFILE_action((RuleContext)_localctx, actionIndex);
			break;
		case 166:
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
			 popMode();cParser.includeCFile(getText(), true); 
			break;
		}
	}
	private void IMPORT_LOCALFILE_action(RuleContext _localctx, int actionIndex) {
		switch (actionIndex) {
		case 8:
			 popMode(); cParser.includeCFile(getText(), false); 
			break;
		}
	}

	public static final String _serializedATN =
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\2\u00a3\u0663\b\1\b"+
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
		"\t\u00a8\4\u00a9\t\u00a9\4\u00aa\t\u00aa\4\u00ab\t\u00ab\3\2\3\2\3\2\3"+
		"\3\3\3\3\4\3\4\3\5\3\5\3\6\3\6\3\7\3\7\3\b\3\b\3\t\3\t\3\n\3\n\3\13\3"+
		"\13\3\13\3\f\3\f\3\f\3\f\3\r\3\r\3\16\3\16\3\17\3\17\3\17\3\20\3\20\3"+
		"\21\3\21\3\22\3\22\3\23\3\23\3\24\3\24\3\25\3\25\3\25\3\26\3\26\3\26\3"+
		"\27\3\27\3\30\3\30\3\31\3\31\3\32\3\32\3\33\3\33\3\33\3\34\3\34\3\34\3"+
		"\35\3\35\3\35\3\36\3\36\3\36\3\37\3\37\3 \3 \3 \3!\3!\3!\3\"\3\"\3#\3"+
		"#\3#\3$\3$\3$\3%\3%\3&\3&\3&\3&\3&\3&\3&\3&\3&\3&\3&\3&\3&\3&\3&\3&\3"+
		"&\3&\3&\3&\3&\3&\5&\u01c7\n&\3\'\3\'\3\'\3\'\3\'\3\'\3\'\3\'\3(\3(\3("+
		"\3(\3(\3(\3(\3(\3)\3)\3)\3*\3*\3*\3*\3*\3*\3*\3+\3+\3+\3+\3+\3,\3,\3,"+
		"\3,\3-\3-\3-\3-\3-\3-\3-\3-\3-\3.\3.\3.\3.\3.\3.\3.\3.\3.\3/\3/\3/\3/"+
		"\3/\3/\3/\3/\3/\3\60\3\60\3\60\3\60\3\60\3\60\3\61\3\61\3\61\3\61\3\61"+
		"\3\61\3\61\3\62\3\62\3\62\3\62\3\62\3\62\3\62\3\63\3\63\3\63\3\63\3\63"+
		"\3\63\3\64\3\64\3\64\3\64\3\64\3\64\3\64\3\65\3\65\3\65\3\65\3\65\3\65"+
		"\3\65\3\65\3\65\3\66\3\66\3\66\3\66\3\66\3\66\3\66\3\67\3\67\3\67\3\67"+
		"\3\67\3\67\3\67\3\67\3\67\3\67\38\38\38\38\38\38\38\38\38\39\39\39\39"+
		"\39\39\39\39\39\39\3:\3:\3:\3:\3:\3;\3;\3;\3;\3;\3;\3<\3<\3<\3<\3<\3<"+
		"\3=\3=\3=\3=\3=\3>\3>\3>\3>\3>\3>\3>\3>\3>\3>\3>\3>\3?\3?\3?\3?\3?\3?"+
		"\3?\3?\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\3@\5@"+
		"\u0293\n@\3A\3A\3A\3A\3A\3A\3A\3A\3A\3A\3B\3B\3B\3C\3C\3C\3C\3C\3D\3D"+
		"\3D\3D\3D\3D\3E\3E\3E\3F\3F\3F\3F\3G\3G\3G\3G\3G\3G\3G\3H\3H\3H\3H\3H"+
		"\3H\3H\3I\3I\3I\3I\3I\3I\3J\3J\3J\3J\3J\3J\3J\3J\3J\3K\3K\3K\3K\3K\3K"+
		"\3L\3L\3L\3L\3L\3L\3L\3L\3M\3M\3M\3M\3M\3N\3N\3N\3N\3N\3N\3N\3O\3O\3O"+
		"\3O\3O\3P\3P\3P\3P\3P\3P\3P\3Q\3Q\3Q\3Q\3Q\3Q\3Q\3R\3R\3R\3R\3R\3R\3R"+
		"\3R\3S\3S\3S\3S\3S\3S\3S\3S\3T\3T\3T\3T\3T\3T\3T\3T\3T\3U\3U\3U\3U\3U"+
		"\3V\3V\3V\3V\3V\3V\3V\3V\3V\3W\3W\3W\3W\3W\3W\3X\3X\3X\3X\3X\3X\3X\3Y"+
		"\3Y\3Z\3Z\3Z\3Z\3Z\3Z\3Z\3Z\3Z\3Z\3Z\3Z\3Z\3Z\5Z\u0342\nZ\3[\3[\3[\3["+
		"\3[\3[\3[\3[\3[\3[\3[\3[\3[\3[\3[\3[\3[\3[\3[\3[\3[\3[\3[\3[\3[\3[\3["+
		"\3[\3[\3[\3[\3[\3[\3[\3[\3[\3[\5[\u0369\n[\3\\\3\\\3\\\3\\\3\\\3\\\3\\"+
		"\3\\\3\\\5\\\u0374\n\\\3]\3]\3]\3]\7]\u037a\n]\f]\16]\u037d\13]\3]\3]"+
		"\3]\3^\3^\3^\3^\3^\3^\3^\3^\3^\3^\3_\3_\3_\3_\3_\3_\3_\3_\3_\3_\3_\3`"+
		"\3`\3`\3`\3`\3`\3`\3`\3a\3a\3a\3a\3a\3a\3a\3a\3b\3b\3b\3b\3b\5b\u03ac"+
		"\nb\3c\3c\3c\3c\3c\3c\3c\3d\3d\3d\3d\3d\3d\3d\3e\3e\3e\3e\3e\3e\3e\3e"+
		"\3f\3f\3f\3f\3g\3g\3g\3g\3g\3g\3h\3h\3h\3h\3h\3h\3i\3i\3i\3i\3i\3i\3i"+
		"\3j\3j\5j\u03dd\nj\3k\3k\3k\5k\u03e2\nk\3l\3l\3l\3l\3l\5l\u03e9\nl\3l"+
		"\7l\u03ec\nl\fl\16l\u03ef\13l\3l\3l\6l\u03f3\nl\rl\16l\u03f4\3m\7m\u03f8"+
		"\nm\fm\16m\u03fb\13m\3m\3m\6m\u03ff\nm\rm\16m\u0400\3n\3n\3n\3n\3n\5n"+
		"\u0408\nn\3n\7n\u040b\nn\fn\16n\u040e\13n\3n\3n\6n\u0412\nn\rn\16n\u0413"+
		"\3o\3o\3o\5o\u0419\no\3o\3o\3o\5o\u041e\no\3p\3p\3p\6p\u0423\np\rp\16"+
		"p\u0424\3p\3p\6p\u0429\np\rp\16p\u042a\5p\u042d\np\3q\6q\u0430\nq\rq\16"+
		"q\u0431\3r\3r\3r\3r\3r\5r\u0439\nr\3r\6r\u043c\nr\rr\16r\u043d\3s\3s\3"+
		"t\3t\3u\3u\3v\3v\7v\u0448\nv\fv\16v\u044b\13v\3v\3v\3w\3w\3x\3x\3y\3y"+
		"\3y\3y\7y\u0457\ny\fy\16y\u045a\13y\3y\3y\5y\u045e\ny\3y\3y\5y\u0462\n"+
		"y\5y\u0464\ny\3y\5y\u0467\ny\3z\3z\3z\3z\3z\3z\5z\u046f\nz\3z\5z\u0472"+
		"\nz\3z\3z\3{\6{\u0477\n{\r{\16{\u0478\3{\3{\3|\3|\3|\3|\7|\u0481\n|\f"+
		"|\16|\u0484\13|\3|\3|\3}\3}\3}\3}\7}\u048c\n}\f}\16}\u048f\13}\3}\3}\3"+
		"}\3}\3}\3~\3~\3~\3~\3~\3~\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3"+
		"\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177"+
		"\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177"+
		"\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177"+
		"\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177"+
		"\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177"+
		"\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177"+
		"\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177"+
		"\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177"+
		"\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177"+
		"\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177"+
		"\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177"+
		"\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177"+
		"\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177"+
		"\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177"+
		"\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177"+
		"\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177"+
		"\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177"+
		"\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\3\177\5\177"+
		"\u057a\n\177\3\u0080\3\u0080\3\u0081\3\u0081\3\u0082\3\u0082\3\u0083\3"+
		"\u0083\3\u0084\3\u0084\3\u0085\3\u0085\3\u0086\3\u0086\3\u0087\3\u0087"+
		"\3\u0088\3\u0088\3\u0088\3\u0089\3\u0089\3\u0089\3\u008a\3\u008a\3\u008b"+
		"\3\u008b\3\u008c\3\u008c\3\u008d\3\u008d\3\u008e\3\u008e\3\u008f\3\u008f"+
		"\3\u0090\3\u0090\3\u0090\3\u0091\3\u0091\3\u0091\3\u0092\3\u0092\5\u0092"+
		"\u05a6\n\u0092\3\u0093\3\u0093\3\u0093\5\u0093\u05ab\n\u0093\3\u0094\3"+
		"\u0094\7\u0094\u05af\n\u0094\f\u0094\16\u0094\u05b2\13\u0094\3\u0094\3"+
		"\u0094\6\u0094\u05b6\n\u0094\r\u0094\16\u0094\u05b7\3\u0095\7\u0095\u05bb"+
		"\n\u0095\f\u0095\16\u0095\u05be\13\u0095\3\u0095\3\u0095\6\u0095\u05c2"+
		"\n\u0095\r\u0095\16\u0095\u05c3\3\u0096\3\u0096\7\u0096\u05c8\n\u0096"+
		"\f\u0096\16\u0096\u05cb\13\u0096\3\u0096\3\u0096\6\u0096\u05cf\n\u0096"+
		"\r\u0096\16\u0096\u05d0\3\u0097\3\u0097\3\u0097\5\u0097\u05d6\n\u0097"+
		"\3\u0098\3\u0098\6\u0098\u05da\n\u0098\r\u0098\16\u0098\u05db\3\u0099"+
		"\6\u0099\u05df\n\u0099\r\u0099\16\u0099\u05e0\3\u009a\3\u009a\6\u009a"+
		"\u05e5\n\u009a\r\u009a\16\u009a\u05e6\3\u009b\3\u009b\3\u009c\3\u009c"+
		"\3\u009d\3\u009d\3\u009e\3\u009e\3\u009e\3\u009e\5\u009e\u05f3\n\u009e"+
		"\3\u009e\3\u009e\3\u009f\3\u009f\6\u009f\u05f9\n\u009f\r\u009f\16\u009f"+
		"\u05fa\3\u00a0\3\u00a0\7\u00a0\u05ff\n\u00a0\f\u00a0\16\u00a0\u0602\13"+
		"\u00a0\3\u00a1\3\u00a1\7\u00a1\u0606\n\u00a1\f\u00a1\16\u00a1\u0609\13"+
		"\u00a1\3\u00a2\3\u00a2\3\u00a3\3\u00a3\3\u00a4\6\u00a4\u0610\n\u00a4\r"+
		"\u00a4\16\u00a4\u0611\3\u00a4\3\u00a4\3\u00a5\3\u00a5\3\u00a5\3\u00a5"+
		"\7\u00a5\u061a\n\u00a5\f\u00a5\16\u00a5\u061d\13\u00a5\3\u00a5\3\u00a5"+
		"\3\u00a6\3\u00a6\3\u00a6\3\u00a6\7\u00a6\u0625\n\u00a6\f\u00a6\16\u00a6"+
		"\u0628\13\u00a6\3\u00a6\3\u00a6\3\u00a6\3\u00a6\3\u00a6\3\u00a7\3\u00a7"+
		"\6\u00a7\u0631\n\u00a7\r\u00a7\16\u00a7\u0632\3\u00a7\3\u00a7\3\u00a7"+
		"\3\u00a8\3\u00a8\3\u00a8\3\u00a8\7\u00a8\u063c\n\u00a8\f\u00a8\16\u00a8"+
		"\u063f\13\u00a8\3\u00a8\3\u00a8\3\u00a8\3\u00a9\6\u00a9\u0645\n\u00a9"+
		"\r\u00a9\16\u00a9\u0646\3\u00a9\3\u00a9\3\u00aa\3\u00aa\3\u00aa\3\u00aa"+
		"\7\u00aa\u064f\n\u00aa\f\u00aa\16\u00aa\u0652\13\u00aa\3\u00aa\3\u00aa"+
		"\3\u00ab\3\u00ab\3\u00ab\3\u00ab\7\u00ab\u065a\n\u00ab\f\u00ab\16\u00ab"+
		"\u065d\13\u00ab\3\u00ab\3\u00ab\3\u00ab\3\u00ab\3\u00ab\6\u037b\u048d"+
		"\u0626\u065b\2\u00ac\5\4\7\5\t\6\13\7\r\b\17\t\21\n\23\13\25\f\27\r\31"+
		"\16\33\17\35\20\37\21!\22#\23%\24\'\25)\26+\27-\30/\31\61\32\63\33\65"+
		"\34\67\359\36;\37= ?!A\"C#E$G%I&K\'M(O)Q*S+U,W-Y.[/]\60_\61a\62c\63e\64"+
		"g\65i\66k\67m8o9q:s;u<w=y>{?}@\177A\u0081B\u0083C\u0085D\u0087E\u0089"+
		"F\u008bG\u008dH\u008fI\u0091J\u0093K\u0095L\u0097M\u0099N\u009bO\u009d"+
		"P\u009fQ\u00a1R\u00a3S\u00a5T\u00a7U\u00a9V\u00abW\u00adX\u00afY\u00b1"+
		"Z\u00b3[\u00b5\\\u00b7]\u00b9^\u00bb_\u00bd`\u00bfa\u00c1b\u00c3c\u00c5"+
		"d\u00c7e\u00c9f\u00cbg\u00cdh\u00cfi\u00d1j\u00d3k\u00d5l\u00d7m\u00d9"+
		"n\u00dbo\u00ddp\u00dfq\u00e1r\u00e3s\u00e5t\u00e7\2\u00e9\2\u00eb\2\u00ed"+
		"u\u00ef\2\u00f1\2\u00f3v\u00f5w\u00f7x\u00f9y\u00fbz\u00fd{\u00ff|\u0101"+
		"}\u0103~\u0105\177\u0107\u0080\u0109\u0081\u010b\u0082\u010d\u0083\u010f"+
		"\u0084\u0111\u0085\u0113\u0086\u0115\u0087\u0117\u0088\u0119\u0089\u011b"+
		"\u008a\u011d\u008b\u011f\u008c\u0121\u008d\u0123\u008e\u0125\u008f\u0127"+
		"\u0090\u0129\u0091\u012b\u0092\u012d\u0093\u012f\u0094\u0131\u0095\u0133"+
		"\u0096\u0135\u0097\u0137\2\u0139\2\u013b\2\u013d\u0098\u013f\u0099\u0141"+
		"\u009a\u0143\u009b\u0145\2\u0147\2\u0149\u009c\u014b\u009d\u014d\u009e"+
		"\u014f\u009f\u0151\u00a0\u0153\u00a1\u0155\u00a2\u0157\u00a3\5\2\3\4\25"+
		"\4\2uuww\7\2dfkknnuuyy\4\2DDdd\3\2\62\63\3\2\62;\5\2\62;CHch\5\2C\\aa"+
		"c|\6\2\62;C\\aac|\3\2$$\3\2||\4\2rruu\4\2ooww\7\2$$))hhpptt\4\2\62;ch"+
		"\3\2))\6\2\13\f\17\17\"\"\u00a2\u00a2\4\2\f\f\17\17\4\2--//\7\2/;C\\^"+
		"^aac|\2\u06f4\2\5\3\2\2\2\2\7\3\2\2\2\2\t\3\2\2\2\2\13\3\2\2\2\2\r\3\2"+
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
		"\3\2\2\2\2\u00bd\3\2\2\2\2\u00bf\3\2\2\2\2\u00c1\3\2\2\2\2\u00c3\3\2\2"+
		"\2\2\u00c5\3\2\2\2\2\u00c7\3\2\2\2\2\u00c9\3\2\2\2\2\u00cb\3\2\2\2\2\u00cd"+
		"\3\2\2\2\2\u00cf\3\2\2\2\2\u00d1\3\2\2\2\2\u00d3\3\2\2\2\2\u00d5\3\2\2"+
		"\2\2\u00d7\3\2\2\2\2\u00d9\3\2\2\2\2\u00db\3\2\2\2\2\u00dd\3\2\2\2\2\u00df"+
		"\3\2\2\2\2\u00e1\3\2\2\2\2\u00e3\3\2\2\2\2\u00e5\3\2\2\2\2\u00ed\3\2\2"+
		"\2\2\u00f3\3\2\2\2\2\u00f5\3\2\2\2\2\u00f7\3\2\2\2\2\u00f9\3\2\2\2\2\u00fb"+
		"\3\2\2\2\3\u00fd\3\2\2\2\3\u00ff\3\2\2\2\3\u0101\3\2\2\2\3\u0103\3\2\2"+
		"\2\3\u0105\3\2\2\2\3\u0107\3\2\2\2\3\u0109\3\2\2\2\3\u010b\3\2\2\2\3\u010d"+
		"\3\2\2\2\3\u010f\3\2\2\2\3\u0111\3\2\2\2\3\u0113\3\2\2\2\3\u0115\3\2\2"+
		"\2\3\u0117\3\2\2\2\3\u0119\3\2\2\2\3\u011b\3\2\2\2\3\u011d\3\2\2\2\3\u011f"+
		"\3\2\2\2\3\u0121\3\2\2\2\3\u0123\3\2\2\2\3\u0125\3\2\2\2\3\u0127\3\2\2"+
		"\2\3\u0129\3\2\2\2\3\u012b\3\2\2\2\3\u012d\3\2\2\2\3\u012f\3\2\2\2\3\u0131"+
		"\3\2\2\2\3\u0133\3\2\2\2\3\u0135\3\2\2\2\3\u013d\3\2\2\2\3\u013f\3\2\2"+
		"\2\3\u0141\3\2\2\2\3\u0143\3\2\2\2\3\u0149\3\2\2\2\3\u014b\3\2\2\2\3\u014d"+
		"\3\2\2\2\4\u014f\3\2\2\2\4\u0151\3\2\2\2\4\u0153\3\2\2\2\4\u0155\3\2\2"+
		"\2\4\u0157\3\2\2\2\5\u0159\3\2\2\2\7\u015c\3\2\2\2\t\u015e\3\2\2\2\13"+
		"\u0160\3\2\2\2\r\u0162\3\2\2\2\17\u0164\3\2\2\2\21\u0166\3\2\2\2\23\u0168"+
		"\3\2\2\2\25\u016a\3\2\2\2\27\u016c\3\2\2\2\31\u016f\3\2\2\2\33\u0173\3"+
		"\2\2\2\35\u0175\3\2\2\2\37\u0177\3\2\2\2!\u017a\3\2\2\2#\u017c\3\2\2\2"+
		"%\u017e\3\2\2\2\'\u0180\3\2\2\2)\u0182\3\2\2\2+\u0184\3\2\2\2-\u0187\3"+
		"\2\2\2/\u018a\3\2\2\2\61\u018c\3\2\2\2\63\u018e\3\2\2\2\65\u0190\3\2\2"+
		"\2\67\u0192\3\2\2\29\u0195\3\2\2\2;\u0198\3\2\2\2=\u019b\3\2\2\2?\u019e"+
		"\3\2\2\2A\u01a0\3\2\2\2C\u01a3\3\2\2\2E\u01a6\3\2\2\2G\u01a8\3\2\2\2I"+
		"\u01ab\3\2\2\2K\u01ae\3\2\2\2M\u01c6\3\2\2\2O\u01c8\3\2\2\2Q\u01d0\3\2"+
		"\2\2S\u01d8\3\2\2\2U\u01db\3\2\2\2W\u01e2\3\2\2\2Y\u01e7\3\2\2\2[\u01eb"+
		"\3\2\2\2]\u01f4\3\2\2\2_\u01fd\3\2\2\2a\u0206\3\2\2\2c\u020c\3\2\2\2e"+
		"\u0213\3\2\2\2g\u021a\3\2\2\2i\u0220\3\2\2\2k\u0227\3\2\2\2m\u0230\3\2"+
		"\2\2o\u0237\3\2\2\2q\u0241\3\2\2\2s\u024a\3\2\2\2u\u0254\3\2\2\2w\u0259"+
		"\3\2\2\2y\u025f\3\2\2\2{\u0265\3\2\2\2}\u026a\3\2\2\2\177\u0276\3\2\2"+
		"\2\u0081\u0292\3\2\2\2\u0083\u0294\3\2\2\2\u0085\u029e\3\2\2\2\u0087\u02a1"+
		"\3\2\2\2\u0089\u02a6\3\2\2\2\u008b\u02ac\3\2\2\2\u008d\u02af\3\2\2\2\u008f"+
		"\u02b3\3\2\2\2\u0091\u02ba\3\2\2\2\u0093\u02c1\3\2\2\2\u0095\u02c7\3\2"+
		"\2\2\u0097\u02d0\3\2\2\2\u0099\u02d6\3\2\2\2\u009b\u02de\3\2\2\2\u009d"+
		"\u02e3\3\2\2\2\u009f\u02ea\3\2\2\2\u00a1\u02ef\3\2\2\2\u00a3\u02f6\3\2"+
		"\2\2\u00a5\u02fd\3\2\2\2\u00a7\u0305\3\2\2\2\u00a9\u030d\3\2\2\2\u00ab"+
		"\u0316\3\2\2\2\u00ad\u031b\3\2\2\2\u00af\u0324\3\2\2\2\u00b1\u032a\3\2"+
		"\2\2\u00b3\u0331\3\2\2\2\u00b5\u0341\3\2\2\2\u00b7\u0368\3\2\2\2\u00b9"+
		"\u0373\3\2\2\2\u00bb\u0375\3\2\2\2\u00bd\u0381\3\2\2\2\u00bf\u038b\3\2"+
		"\2\2\u00c1\u0396\3\2\2\2\u00c3\u039e\3\2\2\2\u00c5\u03ab\3\2\2\2\u00c7"+
		"\u03ad\3\2\2\2\u00c9\u03b4\3\2\2\2\u00cb\u03bb\3\2\2\2\u00cd\u03c3\3\2"+
		"\2\2\u00cf\u03c7\3\2\2\2\u00d1\u03cd\3\2\2\2\u00d3\u03d3\3\2\2\2\u00d5"+
		"\u03dc\3\2\2\2\u00d7\u03e1\3\2\2\2\u00d9\u03e8\3\2\2\2\u00db\u03f9\3\2"+
		"\2\2\u00dd\u0407\3\2\2\2\u00df\u0418\3\2\2\2\u00e1\u042c\3\2\2\2\u00e3"+
		"\u042f\3\2\2\2\u00e5\u0438\3\2\2\2\u00e7\u043f\3\2\2\2\u00e9\u0441\3\2"+
		"\2\2\u00eb\u0443\3\2\2\2\u00ed\u0445\3\2\2\2\u00ef\u044e\3\2\2\2\u00f1"+
		"\u0450\3\2\2\2\u00f3\u0452\3\2\2\2\u00f5\u0468\3\2\2\2\u00f7\u0476\3\2"+
		"\2\2\u00f9\u047c\3\2\2\2\u00fb\u0487\3\2\2\2\u00fd\u0495\3\2\2\2\u00ff"+
		"\u0579\3\2\2\2\u0101\u057b\3\2\2\2\u0103\u057d\3\2\2\2\u0105\u057f\3\2"+
		"\2\2\u0107\u0581\3\2\2\2\u0109\u0583\3\2\2\2\u010b\u0585\3\2\2\2\u010d"+
		"\u0587\3\2\2\2\u010f\u0589\3\2\2\2\u0111\u058b\3\2\2\2\u0113\u058e\3\2"+
		"\2\2\u0115\u0591\3\2\2\2\u0117\u0593\3\2\2\2\u0119\u0595\3\2\2\2\u011b"+
		"\u0597\3\2\2\2\u011d\u0599\3\2\2\2\u011f\u059b\3\2\2\2\u0121\u059d\3\2"+
		"\2\2\u0123\u05a0\3\2\2\2\u0125\u05a5\3\2\2\2\u0127\u05aa\3\2\2\2\u0129"+
		"\u05ac\3\2\2\2\u012b\u05bc\3\2\2\2\u012d\u05c5\3\2\2\2\u012f\u05d5\3\2"+
		"\2\2\u0131\u05d7\3\2\2\2\u0133\u05de\3\2\2\2\u0135\u05e2\3\2\2\2\u0137"+
		"\u05e8\3\2\2\2\u0139\u05ea\3\2\2\2\u013b\u05ec\3\2\2\2\u013d\u05ee\3\2"+
		"\2\2\u013f\u05f6\3\2\2\2\u0141\u05fc\3\2\2\2\u0143\u0603\3\2\2\2\u0145"+
		"\u060a\3\2\2\2\u0147\u060c\3\2\2\2\u0149\u060f\3\2\2\2\u014b\u0615\3\2"+
		"\2\2\u014d\u0620\3\2\2\2\u014f\u062e\3\2\2\2\u0151\u0637\3\2\2\2\u0153"+
		"\u0644\3\2\2\2\u0155\u064a\3\2\2\2\u0157\u0655\3\2\2\2\u0159\u015a\7}"+
		"\2\2\u015a\u015b\b\2\2\2\u015b\6\3\2\2\2\u015c\u015d\7\177\2\2\u015d\b"+
		"\3\2\2\2\u015e\u015f\7]\2\2\u015f\n\3\2\2\2\u0160\u0161\7_\2\2\u0161\f"+
		"\3\2\2\2\u0162\u0163\7*\2\2\u0163\16\3\2\2\2\u0164\u0165\7+\2\2\u0165"+
		"\20\3\2\2\2\u0166\u0167\7=\2\2\u0167\22\3\2\2\2\u0168\u0169\7<\2\2\u0169"+
		"\24\3\2\2\2\u016a\u016b\7.\2\2\u016b\26\3\2\2\2\u016c\u016d\7\60\2\2\u016d"+
		"\u016e\7\60\2\2\u016e\30\3\2\2\2\u016f\u0170\7\60\2\2\u0170\u0171\7\60"+
		"\2\2\u0171\u0172\7\60\2\2\u0172\32\3\2\2\2\u0173\u0174\7A\2\2\u0174\34"+
		"\3\2\2\2\u0175\u0176\7\60\2\2\u0176\36\3\2\2\2\u0177\u0178\7/\2\2\u0178"+
		"\u0179\7@\2\2\u0179 \3\2\2\2\u017a\u017b\7-\2\2\u017b\"\3\2\2\2\u017c"+
		"\u017d\7/\2\2\u017d$\3\2\2\2\u017e\u017f\7,\2\2\u017f&\3\2\2\2\u0180\u0181"+
		"\7\61\2\2\u0181(\3\2\2\2\u0182\u0183\7\'\2\2\u0183*\3\2\2\2\u0184\u0185"+
		"\7-\2\2\u0185\u0186\7-\2\2\u0186,\3\2\2\2\u0187\u0188\7/\2\2\u0188\u0189"+
		"\7/\2\2\u0189.\3\2\2\2\u018a\u018b\7(\2\2\u018b\60\3\2\2\2\u018c\u018d"+
		"\7\u0080\2\2\u018d\62\3\2\2\2\u018e\u018f\7`\2\2\u018f\64\3\2\2\2\u0190"+
		"\u0191\7~\2\2\u0191\66\3\2\2\2\u0192\u0193\7>\2\2\u0193\u0194\7>\2\2\u0194"+
		"8\3\2\2\2\u0195\u0196\7@\2\2\u0196\u0197\7@\2\2\u0197:\3\2\2\2\u0198\u0199"+
		"\7?\2\2\u0199\u019a\7?\2\2\u019a<\3\2\2\2\u019b\u019c\7#\2\2\u019c\u019d"+
		"\7?\2\2\u019d>\3\2\2\2\u019e\u019f\7>\2\2\u019f@\3\2\2\2\u01a0\u01a1\7"+
		">\2\2\u01a1\u01a2\7?\2\2\u01a2B\3\2\2\2\u01a3\u01a4\7@\2\2\u01a4\u01a5"+
		"\7?\2\2\u01a5D\3\2\2\2\u01a6\u01a7\7@\2\2\u01a7F\3\2\2\2\u01a8\u01a9\7"+
		"(\2\2\u01a9\u01aa\7(\2\2\u01aaH\3\2\2\2\u01ab\u01ac\7~\2\2\u01ac\u01ad"+
		"\7~\2\2\u01adJ\3\2\2\2\u01ae\u01af\7?\2\2\u01afL\3\2\2\2\u01b0\u01b1\7"+
		"-\2\2\u01b1\u01c7\7?\2\2\u01b2\u01b3\7/\2\2\u01b3\u01c7\7?\2\2\u01b4\u01b5"+
		"\7,\2\2\u01b5\u01c7\7?\2\2\u01b6\u01b7\7\61\2\2\u01b7\u01c7\7?\2\2\u01b8"+
		"\u01b9\7\'\2\2\u01b9\u01c7\7?\2\2\u01ba\u01bb\7>\2\2\u01bb\u01bc\7>\2"+
		"\2\u01bc\u01c7\7?\2\2\u01bd\u01be\7@\2\2\u01be\u01bf\7@\2\2\u01bf\u01c7"+
		"\7?\2\2\u01c0\u01c1\7(\2\2\u01c1\u01c7\7?\2\2\u01c2\u01c3\7~\2\2\u01c3"+
		"\u01c7\7?\2\2\u01c4\u01c5\7`\2\2\u01c5\u01c7\7?\2\2\u01c6\u01b0\3\2\2"+
		"\2\u01c6\u01b2\3\2\2\2\u01c6\u01b4\3\2\2\2\u01c6\u01b6\3\2\2\2\u01c6\u01b8"+
		"\3\2\2\2\u01c6\u01ba\3\2\2\2\u01c6\u01bd\3\2\2\2\u01c6\u01c0\3\2\2\2\u01c6"+
		"\u01c2\3\2\2\2\u01c6\u01c4\3\2\2\2\u01c7N\3\2\2\2\u01c8\u01c9\7v\2\2\u01c9"+
		"\u01ca\7{\2\2\u01ca\u01cb\7r\2\2\u01cb\u01cc\7g\2\2\u01cc\u01cd\7f\2\2"+
		"\u01cd\u01ce\7g\2\2\u01ce\u01cf\7h\2\2\u01cfP\3\2\2\2\u01d0\u01d1\7t\2"+
		"\2\u01d1\u01d2\7g\2\2\u01d2\u01d3\7u\2\2\u01d3\u01d4\7g\2\2\u01d4\u01d5"+
		"\7t\2\2\u01d5\u01d6\7x\2\2\u01d6\u01d7\7g\2\2\u01d7R\3\2\2\2\u01d8\u01d9"+
		"\7r\2\2\u01d9\u01da\7e\2\2\u01daT\3\2\2\2\u01db\u01dc\7v\2\2\u01dc\u01dd"+
		"\7c\2\2\u01dd\u01de\7t\2\2\u01de\u01df\7i\2\2\u01df\u01e0\7g\2\2\u01e0"+
		"\u01e1\7v\2\2\u01e1V\3\2\2\2\u01e2\u01e3\7n\2\2\u01e3\u01e4\7k\2\2\u01e4"+
		"\u01e5\7p\2\2\u01e5\u01e6\7m\2\2\u01e6X\3\2\2\2\u01e7\u01e8\7e\2\2\u01e8"+
		"\u01e9\7r\2\2\u01e9\u01ea\7w\2\2\u01eaZ\3\2\2\2\u01eb\u01ec\7e\2\2\u01ec"+
		"\u01ed\7q\2\2\u01ed\u01ee\7f\2\2\u01ee\u01ef\7g\2\2\u01ef\u01f0\7a\2\2"+
		"\u01f0\u01f1\7u\2\2\u01f1\u01f2\7g\2\2\u01f2\u01f3\7i\2\2\u01f3\\\3\2"+
		"\2\2\u01f4\u01f5\7f\2\2\u01f5\u01f6\7c\2\2\u01f6\u01f7\7v\2\2\u01f7\u01f8"+
		"\7c\2\2\u01f8\u01f9\7a\2\2\u01f9\u01fa\7u\2\2\u01fa\u01fb\7g\2\2\u01fb"+
		"\u01fc\7i\2\2\u01fc^\3\2\2\2\u01fd\u01fe\7g\2\2\u01fe\u01ff\7p\2\2\u01ff"+
		"\u0200\7e\2\2\u0200\u0201\7q\2\2\u0201\u0202\7f\2\2\u0202\u0203\7k\2\2"+
		"\u0203\u0204\7p\2\2\u0204\u0205\7i\2\2\u0205`\3\2\2\2\u0206\u0207\7e\2"+
		"\2\u0207\u0208\7q\2\2\u0208\u0209\7p\2\2\u0209\u020a\7u\2\2\u020a\u020b"+
		"\7v\2\2\u020bb\3\2\2\2\u020c\u020d\7g\2\2\u020d\u020e\7z\2\2\u020e\u020f"+
		"\7v\2\2\u020f\u0210\7g\2\2\u0210\u0211\7t\2\2\u0211\u0212\7p\2\2\u0212"+
		"d\3\2\2\2\u0213\u0214\7g\2\2\u0214\u0215\7z\2\2\u0215\u0216\7r\2\2\u0216"+
		"\u0217\7q\2\2\u0217\u0218\7t\2\2\u0218\u0219\7v\2\2\u0219f\3\2\2\2\u021a"+
		"\u021b\7c\2\2\u021b\u021c\7n\2\2\u021c\u021d\7k\2\2\u021d\u021e\7i\2\2"+
		"\u021e\u021f\7p\2\2\u021fh\3\2\2\2\u0220\u0221\7k\2\2\u0221\u0222\7p\2"+
		"\2\u0222\u0223\7n\2\2\u0223\u0224\7k\2\2\u0224\u0225\7p\2\2\u0225\u0226"+
		"\7g\2\2\u0226j\3\2\2\2\u0227\u0228\7x\2\2\u0228\u0229\7q\2\2\u0229\u022a"+
		"\7n\2\2\u022a\u022b\7c\2\2\u022b\u022c\7v\2\2\u022c\u022d\7k\2\2\u022d"+
		"\u022e\7n\2\2\u022e\u022f\7g\2\2\u022fl\3\2\2\2\u0230\u0231\7u\2\2\u0231"+
		"\u0232\7v\2\2\u0232\u0233\7c\2\2\u0233\u0234\7v\2\2\u0234\u0235\7k\2\2"+
		"\u0235\u0236\7e\2\2\u0236n\3\2\2\2\u0237\u0238\7k\2\2\u0238\u0239\7p\2"+
		"\2\u0239\u023a\7v\2\2\u023a\u023b\7g\2\2\u023b\u023c\7t\2\2\u023c\u023d"+
		"\7t\2\2\u023d\u023e\7w\2\2\u023e\u023f\7r\2\2\u023f\u0240\7v\2\2\u0240"+
		"p\3\2\2\2\u0241\u0242\7t\2\2\u0242\u0243\7g\2\2\u0243\u0244\7i\2\2\u0244"+
		"\u0245\7k\2\2\u0245\u0246\7u\2\2\u0246\u0247\7v\2\2\u0247\u0248\7g\2\2"+
		"\u0248\u0249\7t\2\2\u0249r\3\2\2\2\u024a\u024b\7a\2\2\u024b\u024c\7a\2"+
		"\2\u024c\u024d\7c\2\2\u024d\u024e\7f\2\2\u024e\u024f\7f\2\2\u024f\u0250"+
		"\7t\2\2\u0250\u0251\7g\2\2\u0251\u0252\7u\2\2\u0252\u0253\7u\2\2\u0253"+
		"t\3\2\2\2\u0254\u0255\7a\2\2\u0255\u0256\7a\2\2\u0256\u0257\7|\2\2\u0257"+
		"\u0258\7r\2\2\u0258v\3\2\2\2\u0259\u025a\7a\2\2\u025a\u025b\7a\2\2\u025b"+
		"\u025c\7o\2\2\u025c\u025d\7g\2\2\u025d\u025e\7o\2\2\u025ex\3\2\2\2\u025f"+
		"\u0260\7a\2\2\u0260\u0261\7a\2\2\u0261\u0262\7u\2\2\u0262\u0263\7u\2\2"+
		"\u0263\u0264\7c\2\2\u0264z\3\2\2\2\u0265\u0266\7a\2\2\u0266\u0267\7a\2"+
		"\2\u0267\u0268\7o\2\2\u0268\u0269\7c\2\2\u0269|\3\2\2\2\u026a\u026b\7"+
		"a\2\2\u026b\u026c\7a\2\2\u026c\u026d\7k\2\2\u026d\u026e\7p\2\2\u026e\u026f"+
		"\7v\2\2\u026f\u0270\7t\2\2\u0270\u0271\7k\2\2\u0271\u0272\7p\2\2\u0272"+
		"\u0273\7u\2\2\u0273\u0274\7k\2\2\u0274\u0275\7e\2\2\u0275~\3\2\2\2\u0276"+
		"\u0277\7e\2\2\u0277\u0278\7c\2\2\u0278\u0279\7n\2\2\u0279\u027a\7n\2\2"+
		"\u027a\u027b\7k\2\2\u027b\u027c\7p\2\2\u027c\u027d\7i\2\2\u027d\u0080"+
		"\3\2\2\2\u027e\u027f\7a\2\2\u027f\u0280\7a\2\2\u0280\u0281\7u\2\2\u0281"+
		"\u0282\7v\2\2\u0282\u0283\7c\2\2\u0283\u0284\7e\2\2\u0284\u0285\7m\2\2"+
		"\u0285\u0286\7e\2\2\u0286\u0287\7c\2\2\u0287\u0288\7n\2\2\u0288\u0293"+
		"\7n\2\2\u0289\u028a\7a\2\2\u028a\u028b\7a\2\2\u028b\u028c\7r\2\2\u028c"+
		"\u028d\7j\2\2\u028d\u028e\7k\2\2\u028e\u028f\7e\2\2\u028f\u0290\7c\2\2"+
		"\u0290\u0291\7n\2\2\u0291\u0293\7n\2\2\u0292\u027e\3\2\2\2\u0292\u0289"+
		"\3\2\2\2\u0293\u0082\3\2\2\2\u0294\u0295\7x\2\2\u0295\u0296\7c\2\2\u0296"+
		"\u0297\7t\2\2\u0297\u0298\7a\2\2\u0298\u0299\7o\2\2\u0299\u029a\7q\2\2"+
		"\u029a\u029b\7f\2\2\u029b\u029c\7g\2\2\u029c\u029d\7n\2\2\u029d\u0084"+
		"\3\2\2\2\u029e\u029f\7k\2\2\u029f\u02a0\7h\2\2\u02a0\u0086\3\2\2\2\u02a1"+
		"\u02a2\7g\2\2\u02a2\u02a3\7n\2\2\u02a3\u02a4\7u\2\2\u02a4\u02a5\7g\2\2"+
		"\u02a5\u0088\3\2\2\2\u02a6\u02a7\7y\2\2\u02a7\u02a8\7j\2\2\u02a8\u02a9"+
		"\7k\2\2\u02a9\u02aa\7n\2\2\u02aa\u02ab\7g\2\2\u02ab\u008a\3\2\2\2\u02ac"+
		"\u02ad\7f\2\2\u02ad\u02ae\7q\2\2\u02ae\u008c\3\2\2\2\u02af\u02b0\7h\2"+
		"\2\u02b0\u02b1\7q\2\2\u02b1\u02b2\7t\2\2\u02b2\u008e\3\2\2\2\u02b3\u02b4"+
		"\7u\2\2\u02b4\u02b5\7y\2\2\u02b5\u02b6\7k\2\2\u02b6\u02b7\7v\2\2\u02b7"+
		"\u02b8\7e\2\2\u02b8\u02b9\7j\2\2\u02b9\u0090\3\2\2\2\u02ba\u02bb\7t\2"+
		"\2\u02bb\u02bc\7g\2\2\u02bc\u02bd\7v\2\2\u02bd\u02be\7w\2\2\u02be\u02bf"+
		"\7t\2\2\u02bf\u02c0\7p\2\2\u02c0\u0092\3\2\2\2\u02c1\u02c2\7d\2\2\u02c2"+
		"\u02c3\7t\2\2\u02c3\u02c4\7g\2\2\u02c4\u02c5\7c\2\2\u02c5\u02c6\7m\2\2"+
		"\u02c6\u0094\3\2\2\2\u02c7\u02c8\7e\2\2\u02c8\u02c9\7q\2\2\u02c9\u02ca"+
		"\7p\2\2\u02ca\u02cb\7v\2\2\u02cb\u02cc\7k\2\2\u02cc\u02cd\7p\2\2\u02cd"+
		"\u02ce\7w\2\2\u02ce\u02cf\7g\2\2\u02cf\u0096\3\2\2\2\u02d0\u02d1\7c\2"+
		"\2\u02d1\u02d2\7u\2\2\u02d2\u02d3\7o\2\2\u02d3\u02d4\3\2\2\2\u02d4\u02d5"+
		"\bK\3\2\u02d5\u0098\3\2\2\2\u02d6\u02d7\7f\2\2\u02d7\u02d8\7g\2\2\u02d8"+
		"\u02d9\7h\2\2\u02d9\u02da\7c\2\2\u02da\u02db\7w\2\2\u02db\u02dc\7n\2\2"+
		"\u02dc\u02dd\7v\2\2\u02dd\u009a\3\2\2\2\u02de\u02df\7e\2\2\u02df\u02e0"+
		"\7c\2\2\u02e0\u02e1\7u\2\2\u02e1\u02e2\7g\2\2\u02e2\u009c\3\2\2\2\u02e3"+
		"\u02e4\7u\2\2\u02e4\u02e5\7v\2\2\u02e5\u02e6\7t\2\2\u02e6\u02e7\7w\2\2"+
		"\u02e7\u02e8\7e\2\2\u02e8\u02e9\7v\2\2\u02e9\u009e\3\2\2\2\u02ea\u02eb"+
		"\7g\2\2\u02eb\u02ec\7p\2\2\u02ec\u02ed\7w\2\2\u02ed\u02ee\7o\2\2\u02ee"+
		"\u00a0\3\2\2\2\u02ef\u02f0\7u\2\2\u02f0\u02f1\7k\2\2\u02f1\u02f2\7|\2"+
		"\2\u02f2\u02f3\7g\2\2\u02f3\u02f4\7q\2\2\u02f4\u02f5\7h\2\2\u02f5\u00a2"+
		"\3\2\2\2\u02f6\u02f7\7v\2\2\u02f7\u02f8\7{\2\2\u02f8\u02f9\7r\2\2\u02f9"+
		"\u02fa\7g\2\2\u02fa\u02fb\7k\2\2\u02fb\u02fc\7f\2\2\u02fc\u00a4\3\2\2"+
		"\2\u02fd\u02fe\7f\2\2\u02fe\u02ff\7g\2\2\u02ff\u0300\7h\2\2\u0300\u0301"+
		"\7k\2\2\u0301\u0302\7p\2\2\u0302\u0303\7g\2\2\u0303\u0304\7f\2\2\u0304"+
		"\u00a6\3\2\2\2\u0305\u0306\7m\2\2\u0306\u0307\7k\2\2\u0307\u0308\7e\2"+
		"\2\u0308\u0309\7m\2\2\u0309\u030a\7c\2\2\u030a\u030b\7u\2\2\u030b\u030c"+
		"\7o\2\2\u030c\u00a8\3\2\2\2\u030d\u030e\7t\2\2\u030e\u030f\7g\2\2\u030f"+
		"\u0310\7u\2\2\u0310\u0311\7q\2\2\u0311\u0312\7w\2\2\u0312\u0313\7t\2\2"+
		"\u0313\u0314\7e\2\2\u0314\u0315\7g\2\2\u0315\u00aa\3\2\2\2\u0316\u0317"+
		"\7w\2\2\u0317\u0318\7u\2\2\u0318\u0319\7g\2\2\u0319\u031a\7u\2\2\u031a"+
		"\u00ac\3\2\2\2\u031b\u031c\7e\2\2\u031c\u031d\7n\2\2\u031d\u031e\7q\2"+
		"\2\u031e\u031f\7d\2\2\u031f\u0320\7d\2\2\u0320\u0321\7g\2\2\u0321\u0322"+
		"\7t\2\2\u0322\u0323\7u\2\2\u0323\u00ae\3\2\2\2\u0324\u0325\7d\2\2\u0325"+
		"\u0326\7{\2\2\u0326\u0327\7v\2\2\u0327\u0328\7g\2\2\u0328\u0329\7u\2\2"+
		"\u0329\u00b0\3\2\2\2\u032a\u032b\7e\2\2\u032b\u032c\7{\2\2\u032c\u032d"+
		"\7e\2\2\u032d\u032e\7n\2\2\u032e\u032f\7g\2\2\u032f\u0330\7u\2\2\u0330"+
		"\u00b2\3\2\2\2\u0331\u0332\7#\2\2\u0332\u00b4\3\2\2\2\u0333\u0334\7u\2"+
		"\2\u0334\u0335\7k\2\2\u0335\u0336\7i\2\2\u0336\u0337\7p\2\2\u0337\u0338"+
		"\7g\2\2\u0338\u0342\7f\2\2\u0339\u033a\7w\2\2\u033a\u033b\7p\2\2\u033b"+
		"\u033c\7u\2\2\u033c\u033d\7k\2\2\u033d\u033e\7i\2\2\u033e\u033f\7p\2\2"+
		"\u033f\u0340\7g\2\2\u0340\u0342\7f\2\2\u0341\u0333\3\2\2\2\u0341\u0339"+
		"\3\2\2\2\u0342\u00b6\3\2\2\2\u0343\u0344\7d\2\2\u0344\u0345\7{\2\2\u0345"+
		"\u0346\7v\2\2\u0346\u0369\7g\2\2\u0347\u0348\7y\2\2\u0348\u0349\7q\2\2"+
		"\u0349\u034a\7t\2\2\u034a\u0369\7f\2\2\u034b\u034c\7f\2\2\u034c\u034d"+
		"\7y\2\2\u034d\u034e\7q\2\2\u034e\u034f\7t\2\2\u034f\u0369\7f\2\2\u0350"+
		"\u0351\7d\2\2\u0351\u0352\7q\2\2\u0352\u0353\7q\2\2\u0353\u0369\7n\2\2"+
		"\u0354\u0355\7e\2\2\u0355\u0356\7j\2\2\u0356\u0357\7c\2\2\u0357\u0369"+
		"\7t\2\2\u0358\u0359\7u\2\2\u0359\u035a\7j\2\2\u035a\u035b\7q\2\2\u035b"+
		"\u035c\7t\2\2\u035c\u0369\7v\2\2\u035d\u035e\7k\2\2\u035e\u035f\7p\2\2"+
		"\u035f\u0369\7v\2\2\u0360\u0361\7n\2\2\u0361\u0362\7q\2\2\u0362\u0363"+
		"\7p\2\2\u0363\u0369\7i\2\2\u0364\u0365\7x\2\2\u0365\u0366\7q\2\2\u0366"+
		"\u0367\7k\2\2\u0367\u0369\7f\2\2\u0368\u0343\3\2\2\2\u0368\u0347\3\2\2"+
		"\2\u0368\u034b\3\2\2\2\u0368\u0350\3\2\2\2\u0368\u0354\3\2\2\2\u0368\u0358"+
		"\3\2\2\2\u0368\u035d\3\2\2\2\u0368\u0360\3\2\2\2\u0368\u0364\3\2\2\2\u0369"+
		"\u00b8\3\2\2\2\u036a\u036b\7v\2\2\u036b\u036c\7t\2\2\u036c\u036d\7w\2"+
		"\2\u036d\u0374\7g\2\2\u036e\u036f\7h\2\2\u036f\u0370\7c\2\2\u0370\u0371"+
		"\7n\2\2\u0371\u0372\7u\2\2\u0372\u0374\7g\2\2\u0373\u036a\3\2\2\2\u0373"+
		"\u036e\3\2\2\2\u0374\u00ba\3\2\2\2\u0375\u0376\7}\2\2\u0376\u0377\7}\2"+
		"\2\u0377\u037b\3\2\2\2\u0378\u037a\13\2\2\2\u0379\u0378\3\2\2\2\u037a"+
		"\u037d\3\2\2\2\u037b\u037c\3\2\2\2\u037b\u0379\3\2\2\2\u037c\u037e\3\2"+
		"\2\2\u037d\u037b\3\2\2\2\u037e\u037f\7\177\2\2\u037f\u0380\7\177\2\2\u0380"+
		"\u00bc\3\2\2\2\u0381\u0382\7%\2\2\u0382\u0383\7k\2\2\u0383\u0384\7o\2"+
		"\2\u0384\u0385\7r\2\2\u0385\u0386\7q\2\2\u0386\u0387\7t\2\2\u0387\u0388"+
		"\7v\2\2\u0388\u0389\3\2\2\2\u0389\u038a\b^\4\2\u038a\u00be\3\2\2\2\u038b"+
		"\u038c\7%\2\2\u038c\u038d\7k\2\2\u038d\u038e\7p\2\2\u038e\u038f\7e\2\2"+
		"\u038f\u0390\7n\2\2\u0390\u0391\7w\2\2\u0391\u0392\7f\2\2\u0392\u0393"+
		"\7g\2\2\u0393\u0394\3\2\2\2\u0394\u0395\b_\5\2\u0395\u00c0\3\2\2\2\u0396"+
		"\u0397\7%\2\2\u0397\u0398\7r\2\2\u0398\u0399\7t\2\2\u0399\u039a\7c\2\2"+
		"\u039a\u039b\7i\2\2\u039b\u039c\7o\2\2\u039c\u039d\7c\2\2\u039d\u00c2"+
		"\3\2\2\2\u039e\u039f\7%\2\2\u039f\u03a0\7f\2\2\u03a0\u03a1\7g\2\2\u03a1"+
		"\u03a2\7h\2\2\u03a2\u03a3\7k\2\2\u03a3\u03a4\7p\2\2\u03a4\u03a5\7g\2\2"+
		"\u03a5\u00c4\3\2\2\2\u03a6\u03a7\7^\2\2\u03a7\u03ac\7\f\2\2\u03a8\u03a9"+
		"\7^\2\2\u03a9\u03aa\7\17\2\2\u03aa\u03ac\7\f\2\2\u03ab\u03a6\3\2\2\2\u03ab"+
		"\u03a8\3\2\2\2\u03ac\u00c6\3\2\2\2\u03ad\u03ae\7%\2\2\u03ae\u03af\7w\2"+
		"\2\u03af\u03b0\7p\2\2\u03b0\u03b1\7f\2\2\u03b1\u03b2\7g\2\2\u03b2\u03b3"+
		"\7h\2\2\u03b3\u00c8\3\2\2\2\u03b4\u03b5\7%\2\2\u03b5\u03b6\7k\2\2\u03b6"+
		"\u03b7\7h\2\2\u03b7\u03b8\7f\2\2\u03b8\u03b9\7g\2\2\u03b9\u03ba\7h\2\2"+
		"\u03ba\u00ca\3\2\2\2\u03bb\u03bc\7%\2\2\u03bc\u03bd\7k\2\2\u03bd\u03be"+
		"\7h\2\2\u03be\u03bf\7p\2\2\u03bf\u03c0\7f\2\2\u03c0\u03c1\7g\2\2\u03c1"+
		"\u03c2\7h\2\2\u03c2\u00cc\3\2\2\2\u03c3\u03c4\7%\2\2\u03c4\u03c5\7k\2"+
		"\2\u03c5\u03c6\7h\2\2\u03c6\u00ce\3\2\2\2\u03c7\u03c8\7%\2\2\u03c8\u03c9"+
		"\7g\2\2\u03c9\u03ca\7n\2\2\u03ca\u03cb\7k\2\2\u03cb\u03cc\7h\2\2\u03cc"+
		"\u00d0\3\2\2\2\u03cd\u03ce\7%\2\2\u03ce\u03cf\7g\2\2\u03cf\u03d0\7n\2"+
		"\2\u03d0\u03d1\7u\2\2\u03d1\u03d2\7g\2\2\u03d2\u00d2\3\2\2\2\u03d3\u03d4"+
		"\7%\2\2\u03d4\u03d5\7g\2\2\u03d5\u03d6\7p\2\2\u03d6\u03d7\7f\2\2\u03d7"+
		"\u03d8\7k\2\2\u03d8\u03d9\7h\2\2\u03d9\u00d4\3\2\2\2\u03da\u03dd\5\u00d7"+
		"k\2\u03db\u03dd\5\u00dfo\2\u03dc\u03da\3\2\2\2\u03dc\u03db\3\2\2\2\u03dd"+
		"\u00d6\3\2\2\2\u03de\u03e2\5\u00d9l\2\u03df\u03e2\5\u00dbm\2\u03e0\u03e2"+
		"\5\u00ddn\2\u03e1\u03de\3\2\2\2\u03e1\u03df\3\2\2\2\u03e1\u03e0\3\2\2"+
		"\2\u03e2\u00d8\3\2\2\2\u03e3\u03e9\7\'\2\2\u03e4\u03e5\7\62\2\2\u03e5"+
		"\u03e9\7d\2\2\u03e6\u03e7\7\62\2\2\u03e7\u03e9\7D\2\2\u03e8\u03e3\3\2"+
		"\2\2\u03e8\u03e4\3\2\2\2\u03e8\u03e6\3\2\2\2\u03e9\u03ed\3\2\2\2\u03ea"+
		"\u03ec\5\u00e7s\2\u03eb\u03ea\3\2\2\2\u03ec\u03ef\3\2\2\2\u03ed\u03eb"+
		"\3\2\2\2\u03ed\u03ee\3\2\2\2\u03ee\u03f0\3\2\2\2\u03ef\u03ed\3\2\2\2\u03f0"+
		"\u03f2\7\60\2\2\u03f1\u03f3\5\u00e7s\2\u03f2\u03f1\3\2\2\2\u03f3\u03f4"+
		"\3\2\2\2\u03f4\u03f2\3\2\2\2\u03f4\u03f5\3\2\2\2\u03f5\u00da\3\2\2\2\u03f6"+
		"\u03f8\5\u00e9t\2\u03f7\u03f6\3\2\2\2\u03f8\u03fb\3\2\2\2\u03f9\u03f7"+
		"\3\2\2\2\u03f9\u03fa\3\2\2\2\u03fa\u03fc\3\2\2\2\u03fb\u03f9\3\2\2\2\u03fc"+
		"\u03fe\7\60\2\2\u03fd\u03ff\5\u00e9t\2\u03fe\u03fd\3\2\2\2\u03ff\u0400"+
		"\3\2\2\2\u0400\u03fe\3\2\2\2\u0400\u0401\3\2\2\2\u0401\u00dc\3\2\2\2\u0402"+
		"\u0408\7&\2\2\u0403\u0404\7\62\2\2\u0404\u0408\7z\2\2\u0405\u0406\7\62"+
		"\2\2\u0406\u0408\7Z\2\2\u0407\u0402\3\2\2\2\u0407\u0403\3\2\2\2\u0407"+
		"\u0405\3\2\2\2\u0408\u040c\3\2\2\2\u0409\u040b\5\u00ebu\2\u040a\u0409"+
		"\3\2\2\2\u040b\u040e\3\2\2\2\u040c\u040a\3\2\2\2\u040c\u040d\3\2\2\2\u040d"+
		"\u040f\3\2\2\2\u040e\u040c\3\2\2\2\u040f\u0411\7\60\2\2\u0410\u0412\5"+
		"\u00ebu\2\u0411\u0410\3\2\2\2\u0412\u0413\3\2\2\2\u0413\u0411\3\2\2\2"+
		"\u0413\u0414\3\2\2\2\u0414\u00de\3\2\2\2\u0415\u0419\5\u00e3q\2\u0416"+
		"\u0419\5\u00e5r\2\u0417\u0419\5\u00e1p\2\u0418\u0415\3\2\2\2\u0418\u0416"+
		"\3\2\2\2\u0418\u0417\3\2\2\2\u0419\u041d\3\2\2\2\u041a\u041b\t\2\2\2\u041b"+
		"\u041e\t\3\2\2\u041c\u041e\7n\2\2\u041d\u041a\3\2\2\2\u041d\u041c\3\2"+
		"\2\2\u041d\u041e\3\2\2\2\u041e\u00e0\3\2\2\2\u041f\u0420\7\62\2\2\u0420"+
		"\u0422\t\4\2\2\u0421\u0423\5\u00e7s\2\u0422\u0421\3\2\2\2\u0423\u0424"+
		"\3\2\2\2\u0424\u0422\3\2\2\2\u0424\u0425\3\2\2\2\u0425\u042d\3\2\2\2\u0426"+
		"\u0428\7\'\2\2\u0427\u0429\5\u00e7s\2\u0428\u0427\3\2\2\2\u0429\u042a"+
		"\3\2\2\2\u042a\u0428\3\2\2\2\u042a\u042b\3\2\2\2\u042b\u042d\3\2\2\2\u042c"+
		"\u041f\3\2\2\2\u042c\u0426\3\2\2\2\u042d\u00e2\3\2\2\2\u042e\u0430\5\u00e9"+
		"t\2\u042f\u042e\3\2\2\2\u0430\u0431\3\2\2\2\u0431\u042f\3\2\2\2\u0431"+
		"\u0432\3\2\2\2\u0432\u00e4\3\2\2\2\u0433\u0439\7&\2\2\u0434\u0435\7\62"+
		"\2\2\u0435\u0439\7z\2\2\u0436\u0437\7\62\2\2\u0437\u0439\7Z\2\2\u0438"+
		"\u0433\3\2\2\2\u0438\u0434\3\2\2\2\u0438\u0436\3\2\2\2\u0439\u043b\3\2"+
		"\2\2\u043a\u043c\5\u00ebu\2\u043b\u043a\3\2\2\2\u043c\u043d\3\2\2\2\u043d"+
		"\u043b\3\2\2\2\u043d\u043e\3\2\2\2\u043e\u00e6\3\2\2\2\u043f\u0440\t\5"+
		"\2\2\u0440\u00e8\3\2\2\2\u0441\u0442\t\6\2\2\u0442\u00ea\3\2\2\2\u0443"+
		"\u0444\t\7\2\2\u0444\u00ec\3\2\2\2\u0445\u0449\5\u00efw\2\u0446\u0448"+
		"\5\u00f1x\2\u0447\u0446\3\2\2\2\u0448\u044b\3\2\2\2\u0449\u0447\3\2\2"+
		"\2\u0449\u044a\3\2\2\2\u044a\u044c\3\2\2\2\u044b\u0449\3\2\2\2\u044c\u044d"+
		"\bv\6\2\u044d\u00ee\3\2\2\2\u044e\u044f\t\b\2\2\u044f\u00f0\3\2\2\2\u0450"+
		"\u0451\t\t\2\2\u0451\u00f2\3\2\2\2\u0452\u0458\7$\2\2\u0453\u0454\7^\2"+
		"\2\u0454\u0457\7$\2\2\u0455\u0457\n\n\2\2\u0456\u0453\3\2\2\2\u0456\u0455"+
		"\3\2\2\2\u0457\u045a\3\2\2\2\u0458\u0456\3\2\2\2\u0458\u0459\3\2\2\2\u0459"+
		"\u045b\3\2\2\2\u045a\u0458\3\2\2\2\u045b\u045d\7$\2\2\u045c\u045e\t\13"+
		"\2\2\u045d\u045c\3\2\2\2\u045d\u045e\3\2\2\2\u045e\u0463\3\2\2\2\u045f"+
		"\u0461\t\f\2\2\u0460\u0462\t\r\2\2\u0461\u0460\3\2\2\2\u0461\u0462\3\2"+
		"\2\2\u0462\u0464\3\2\2\2\u0463\u045f\3\2\2\2\u0463\u0464\3\2\2\2\u0464"+
		"\u0466\3\2\2\2\u0465\u0467\t\13\2\2\u0466\u0465\3\2\2\2\u0466\u0467\3"+
		"\2\2\2\u0467\u00f4\3\2\2\2\u0468\u0471\7)\2\2\u0469\u046e\7^\2\2\u046a"+
		"\u046f\t\16\2\2\u046b\u046c\7z\2\2\u046c\u046d\t\17\2\2\u046d\u046f\t"+
		"\17\2\2\u046e\u046a\3\2\2\2\u046e\u046b\3\2\2\2\u046f\u0472\3\2\2\2\u0470"+
		"\u0472\n\20\2\2\u0471\u0469\3\2\2\2\u0471\u0470\3\2\2\2\u0472\u0473\3"+
		"\2\2\2\u0473\u0474\7)\2\2\u0474\u00f6\3\2\2\2\u0475\u0477\t\21\2\2\u0476"+
		"\u0475\3\2\2\2\u0477\u0478\3\2\2\2\u0478\u0476\3\2\2\2\u0478\u0479\3\2"+
		"\2\2\u0479\u047a\3\2\2\2\u047a\u047b\b{\7\2\u047b\u00f8\3\2\2\2\u047c"+
		"\u047d\7\61\2\2\u047d\u047e\7\61\2\2\u047e\u0482\3\2\2\2\u047f\u0481\n"+
		"\22\2\2\u0480\u047f\3\2\2\2\u0481\u0484\3\2\2\2\u0482\u0480\3\2\2\2\u0482"+
		"\u0483\3\2\2\2\u0483\u0485\3\2\2\2\u0484\u0482\3\2\2\2\u0485\u0486\b|"+
		"\b\2\u0486\u00fa\3\2\2\2\u0487\u0488\7\61\2\2\u0488\u0489\7,\2\2\u0489"+
		"\u048d\3\2\2\2\u048a\u048c\13\2\2\2\u048b\u048a\3\2\2\2\u048c\u048f\3"+
		"\2\2\2\u048d\u048e\3\2\2\2\u048d\u048b\3\2\2\2\u048e\u0490\3\2\2\2\u048f"+
		"\u048d\3\2\2\2\u0490\u0491\7,\2\2\u0491\u0492\7\61\2\2\u0492\u0493\3\2"+
		"\2\2\u0493\u0494\b}\b\2\u0494\u00fc\3\2\2\2\u0495\u0496\7\60\2\2\u0496"+
		"\u0497\7d\2\2\u0497\u0498\7{\2\2\u0498\u0499\7v\2\2\u0499\u049a\7g\2\2"+
		"\u049a\u00fe\3\2\2\2\u049b\u049c\7d\2\2\u049c\u049d\7t\2\2\u049d\u057a"+
		"\7m\2\2\u049e\u049f\7q\2\2\u049f\u04a0\7t\2\2\u04a0\u057a\7c\2\2\u04a1"+
		"\u04a2\7m\2\2\u04a2\u04a3\7k\2\2\u04a3\u057a\7n\2\2\u04a4\u04a5\7u\2\2"+
		"\u04a5\u04a6\7n\2\2\u04a6\u057a\7q\2\2\u04a7\u04a8\7p\2\2\u04a8\u04a9"+
		"\7q\2\2\u04a9\u057a\7r\2\2\u04aa\u04ab\7c\2\2\u04ab\u04ac\7u\2\2\u04ac"+
		"\u057a\7n\2\2\u04ad\u04ae\7r\2\2\u04ae\u04af\7j\2\2\u04af\u057a\7r\2\2"+
		"\u04b0\u04b1\7c\2\2\u04b1\u04b2\7p\2\2\u04b2\u057a\7e\2\2\u04b3\u04b4"+
		"\7d\2\2\u04b4\u04b5\7r\2\2\u04b5\u057a\7n\2\2\u04b6\u04b7\7e\2\2\u04b7"+
		"\u04b8\7n\2\2\u04b8\u057a\7e\2\2\u04b9\u04ba\7l\2\2\u04ba\u04bb\7u\2\2"+
		"\u04bb\u057a\7t\2\2\u04bc\u04bd\7c\2\2\u04bd\u04be\7p\2\2\u04be\u057a"+
		"\7f\2\2\u04bf\u04c0\7t\2\2\u04c0\u04c1\7n\2\2\u04c1\u057a\7c\2\2\u04c2"+
		"\u04c3\7d\2\2\u04c3\u04c4\7k\2\2\u04c4\u057a\7v\2\2\u04c5\u04c6\7t\2\2"+
		"\u04c6\u04c7\7q\2\2\u04c7\u057a\7n\2\2\u04c8\u04c9\7r\2\2\u04c9\u04ca"+
		"\7n\2\2\u04ca\u057a\7c\2\2\u04cb\u04cc\7r\2\2\u04cc\u04cd\7n\2\2\u04cd"+
		"\u057a\7r\2\2\u04ce\u04cf\7d\2\2\u04cf\u04d0\7o\2\2\u04d0\u057a\7k\2\2"+
		"\u04d1\u04d2\7u\2\2\u04d2\u04d3\7g\2\2\u04d3\u057a\7e\2\2\u04d4\u04d5"+
		"\7t\2\2\u04d5\u04d6\7v\2\2\u04d6\u057a\7k\2\2\u04d7\u04d8\7g\2\2\u04d8"+
		"\u04d9\7q\2\2\u04d9\u057a\7t\2\2\u04da\u04db\7u\2\2\u04db\u04dc\7t\2\2"+
		"\u04dc\u057a\7g\2\2\u04dd\u04de\7n\2\2\u04de\u04df\7u\2\2\u04df\u057a"+
		"\7t\2\2\u04e0\u04e1\7r\2\2\u04e1\u04e2\7j\2\2\u04e2\u057a\7c\2\2\u04e3"+
		"\u04e4\7c\2\2\u04e4\u04e5\7n\2\2\u04e5\u057a\7t\2\2\u04e6\u04e7\7l\2\2"+
		"\u04e7\u04e8\7o\2\2\u04e8\u057a\7r\2\2\u04e9\u04ea\7d\2\2\u04ea\u04eb"+
		"\7x\2\2\u04eb\u057a\7e\2\2\u04ec\u04ed\7e\2\2\u04ed\u04ee\7n\2\2\u04ee"+
		"\u057a\7k\2\2\u04ef\u04f0\7t\2\2\u04f0\u04f1\7v\2\2\u04f1\u057a\7u\2\2"+
		"\u04f2\u04f3\7c\2\2\u04f3\u04f4\7f\2\2\u04f4\u057a\7e\2\2\u04f5\u04f6"+
		"\7t\2\2\u04f6\u04f7\7t\2\2\u04f7\u057a\7c\2\2\u04f8\u04f9\7d\2\2\u04f9"+
		"\u04fa\7x\2\2\u04fa\u057a\7u\2\2\u04fb\u04fc\7u\2\2\u04fc\u04fd\7g\2\2"+
		"\u04fd\u057a\7k\2\2\u04fe\u04ff\7u\2\2\u04ff\u0500\7c\2\2\u0500\u057a"+
		"\7z\2\2\u0501\u0502\7u\2\2\u0502\u0503\7v\2\2\u0503\u057a\7{\2\2\u0504"+
		"\u0505\7u\2\2\u0505\u0506\7v\2\2\u0506\u057a\7c\2\2\u0507\u0508\7u\2\2"+
		"\u0508\u0509\7v\2\2\u0509\u057a\7z\2\2\u050a\u050b\7f\2\2\u050b\u050c"+
		"\7g\2\2\u050c\u057a\7{\2\2\u050d\u050e\7v\2\2\u050e\u050f\7z\2\2\u050f"+
		"\u057a\7c\2\2\u0510\u0511\7z\2\2\u0511\u0512\7c\2\2\u0512\u057a\7c\2\2"+
		"\u0513\u0514\7d\2\2\u0514\u0515\7e\2\2\u0515\u057a\7e\2\2\u0516\u0517"+
		"\7c\2\2\u0517\u0518\7j\2\2\u0518\u057a\7z\2\2\u0519\u051a\7v\2\2\u051a"+
		"\u051b\7{\2\2\u051b\u057a\7c\2\2\u051c\u051d\7v\2\2\u051d\u051e\7z\2\2"+
		"\u051e\u057a\7u\2\2\u051f\u0520\7v\2\2\u0520\u0521\7c\2\2\u0521\u057a"+
		"\7u\2\2\u0522\u0523\7u\2\2\u0523\u0524\7j\2\2\u0524\u057a\7{\2\2\u0525"+
		"\u0526\7u\2\2\u0526\u0527\7j\2\2\u0527\u057a\7z\2\2\u0528\u0529\7n\2\2"+
		"\u0529\u052a\7f\2\2\u052a\u057a\7{\2\2\u052b\u052c\7n\2\2\u052c\u052d"+
		"\7f\2\2\u052d\u057a\7c\2\2\u052e\u052f\7n\2\2\u052f\u0530\7f\2\2\u0530"+
		"\u057a\7z\2\2\u0531\u0532\7n\2\2\u0532\u0533\7c\2\2\u0533\u057a\7z\2\2"+
		"\u0534\u0535\7v\2\2\u0535\u0536\7c\2\2\u0536\u057a\7{\2\2\u0537\u0538"+
		"\7v\2\2\u0538\u0539\7c\2\2\u0539\u057a\7z\2\2\u053a\u053b\7d\2\2\u053b"+
		"\u053c\7e\2\2\u053c\u057a\7u\2\2\u053d\u053e\7e\2\2\u053e\u053f\7n\2\2"+
		"\u053f\u057a\7x\2\2\u0540\u0541\7v\2\2\u0541\u0542\7u\2\2\u0542\u057a"+
		"\7z\2\2\u0543\u0544\7n\2\2\u0544\u0545\7c\2\2\u0545\u057a\7u\2\2\u0546"+
		"\u0547\7e\2\2\u0547\u0548\7r\2\2\u0548\u057a\7{\2\2\u0549\u054a\7e\2\2"+
		"\u054a\u054b\7o\2\2\u054b\u057a\7r\2\2\u054c\u054d\7e\2\2\u054d\u054e"+
		"\7r\2\2\u054e\u057a\7z\2\2\u054f\u0550\7f\2\2\u0550\u0551\7e\2\2\u0551"+
		"\u057a\7r\2\2\u0552\u0553\7f\2\2\u0553\u0554\7g\2\2\u0554\u057a\7e\2\2"+
		"\u0555\u0556\7k\2\2\u0556\u0557\7p\2\2\u0557\u057a\7e\2\2\u0558\u0559"+
		"\7c\2\2\u0559\u055a\7z\2\2\u055a\u057a\7u\2\2\u055b\u055c\7d\2\2\u055c"+
		"\u055d\7p\2\2\u055d\u057a\7g\2\2\u055e\u055f\7e\2\2\u055f\u0560\7n\2\2"+
		"\u0560\u057a\7f\2\2\u0561\u0562\7u\2\2\u0562\u0563\7d\2\2\u0563\u057a"+
		"\7e\2\2\u0564\u0565\7k\2\2\u0565\u0566\7u\2\2\u0566\u057a\7e\2\2\u0567"+
		"\u0568\7k\2\2\u0568\u0569\7p\2\2\u0569\u057a\7z\2\2\u056a\u056b\7d\2\2"+
		"\u056b\u056c\7g\2\2\u056c\u057a\7s\2\2\u056d\u056e\7u\2\2\u056e\u056f"+
		"\7g\2\2\u056f\u057a\7f\2\2\u0570\u0571\7f\2\2\u0571\u0572\7g\2\2\u0572"+
		"\u057a\7z\2\2\u0573\u0574\7k\2\2\u0574\u0575\7p\2\2\u0575\u057a\7{\2\2"+
		"\u0576\u0577\7t\2\2\u0577\u0578\7q\2\2\u0578\u057a\7t\2\2\u0579\u049b"+
		"\3\2\2\2\u0579\u049e\3\2\2\2\u0579\u04a1\3\2\2\2\u0579\u04a4\3\2\2\2\u0579"+
		"\u04a7\3\2\2\2\u0579\u04aa\3\2\2\2\u0579\u04ad\3\2\2\2\u0579\u04b0\3\2"+
		"\2\2\u0579\u04b3\3\2\2\2\u0579\u04b6\3\2\2\2\u0579\u04b9\3\2\2\2\u0579"+
		"\u04bc\3\2\2\2\u0579\u04bf\3\2\2\2\u0579\u04c2\3\2\2\2\u0579\u04c5\3\2"+
		"\2\2\u0579\u04c8\3\2\2\2\u0579\u04cb\3\2\2\2\u0579\u04ce\3\2\2\2\u0579"+
		"\u04d1\3\2\2\2\u0579\u04d4\3\2\2\2\u0579\u04d7\3\2\2\2\u0579\u04da\3\2"+
		"\2\2\u0579\u04dd\3\2\2\2\u0579\u04e0\3\2\2\2\u0579\u04e3\3\2\2\2\u0579"+
		"\u04e6\3\2\2\2\u0579\u04e9\3\2\2\2\u0579\u04ec\3\2\2\2\u0579\u04ef\3\2"+
		"\2\2\u0579\u04f2\3\2\2\2\u0579\u04f5\3\2\2\2\u0579\u04f8\3\2\2\2\u0579"+
		"\u04fb\3\2\2\2\u0579\u04fe\3\2\2\2\u0579\u0501\3\2\2\2\u0579\u0504\3\2"+
		"\2\2\u0579\u0507\3\2\2\2\u0579\u050a\3\2\2\2\u0579\u050d\3\2\2\2\u0579"+
		"\u0510\3\2\2\2\u0579\u0513\3\2\2\2\u0579\u0516\3\2\2\2\u0579\u0519\3\2"+
		"\2\2\u0579\u051c\3\2\2\2\u0579\u051f\3\2\2\2\u0579\u0522\3\2\2\2\u0579"+
		"\u0525\3\2\2\2\u0579\u0528\3\2\2\2\u0579\u052b\3\2\2\2\u0579\u052e\3\2"+
		"\2\2\u0579\u0531\3\2\2\2\u0579\u0534\3\2\2\2\u0579\u0537\3\2\2\2\u0579"+
		"\u053a\3\2\2\2\u0579\u053d\3\2\2\2\u0579\u0540\3\2\2\2\u0579\u0543\3\2"+
		"\2\2\u0579\u0546\3\2\2\2\u0579\u0549\3\2\2\2\u0579\u054c\3\2\2\2\u0579"+
		"\u054f\3\2\2\2\u0579\u0552\3\2\2\2\u0579\u0555\3\2\2\2\u0579\u0558\3\2"+
		"\2\2\u0579\u055b\3\2\2\2\u0579\u055e\3\2\2\2\u0579\u0561\3\2\2\2\u0579"+
		"\u0564\3\2\2\2\u0579\u0567\3\2\2\2\u0579\u056a\3\2\2\2\u0579\u056d\3\2"+
		"\2\2\u0579\u0570\3\2\2\2\u0579\u0573\3\2\2\2\u0579\u0576\3\2\2\2\u057a"+
		"\u0100\3\2\2\2\u057b\u057c\7%\2\2\u057c\u0102\3\2\2\2\u057d\u057e\7<\2"+
		"\2\u057e\u0104\3\2\2\2\u057f\u0580\7.\2\2\u0580\u0106\3\2\2\2\u0581\u0582"+
		"\7*\2\2\u0582\u0108\3\2\2\2\u0583\u0584\7+\2\2\u0584\u010a\3\2\2\2\u0585"+
		"\u0586\7]\2\2\u0586\u010c\3\2\2\2\u0587\u0588\7_\2\2\u0588\u010e\3\2\2"+
		"\2\u0589\u058a\7\60\2\2\u058a\u0110\3\2\2\2\u058b\u058c\7>\2\2\u058c\u058d"+
		"\7>\2\2\u058d\u0112\3\2\2\2\u058e\u058f\7@\2\2\u058f\u0590\7@\2\2\u0590"+
		"\u0114\3\2\2\2\u0591\u0592\7-\2\2\u0592\u0116\3\2\2\2\u0593\u0594\7/\2"+
		"\2\u0594\u0118\3\2\2\2\u0595\u0596\7>\2\2\u0596\u011a\3\2\2\2\u0597\u0598"+
		"\7@\2\2\u0598\u011c\3\2\2\2\u0599\u059a\7,\2\2\u059a\u011e\3\2\2\2\u059b"+
		"\u059c\7\61\2\2\u059c\u0120\3\2\2\2\u059d\u059e\7}\2\2\u059e\u059f\b\u0090"+
		"\t\2\u059f\u0122\3\2\2\2\u05a0\u05a1\7\177\2\2\u05a1\u05a2\b\u0091\n\2"+
		"\u05a2\u0124\3\2\2\2\u05a3\u05a6\5\u0127\u0093\2\u05a4\u05a6\5\u012f\u0097"+
		"\2\u05a5\u05a3\3\2\2\2\u05a5\u05a4\3\2\2\2\u05a6\u0126\3\2\2\2\u05a7\u05ab"+
		"\5\u0129\u0094\2\u05a8\u05ab\5\u012b\u0095\2\u05a9\u05ab\5\u012d\u0096"+
		"\2\u05aa\u05a7\3\2\2\2\u05aa\u05a8\3\2\2\2\u05aa\u05a9\3\2\2\2\u05ab\u0128"+
		"\3\2\2\2\u05ac\u05b0\7\'\2\2\u05ad\u05af\5\u0137\u009b\2\u05ae\u05ad\3"+
		"\2\2\2\u05af\u05b2\3\2\2\2\u05b0\u05ae\3\2\2\2\u05b0\u05b1\3\2\2\2\u05b1"+
		"\u05b3\3\2\2\2\u05b2\u05b0\3\2\2\2\u05b3\u05b5\7\60\2\2\u05b4\u05b6\5"+
		"\u0137\u009b\2\u05b5\u05b4\3\2\2\2\u05b6\u05b7\3\2\2\2\u05b7\u05b5\3\2"+
		"\2\2\u05b7\u05b8\3\2\2\2\u05b8\u012a\3\2\2\2\u05b9\u05bb\5\u0139\u009c"+
		"\2\u05ba\u05b9\3\2\2\2\u05bb\u05be\3\2\2\2\u05bc\u05ba\3\2\2\2\u05bc\u05bd"+
		"\3\2\2\2\u05bd\u05bf\3\2\2\2\u05be\u05bc\3\2\2\2\u05bf\u05c1\7\60\2\2"+
		"\u05c0\u05c2\5\u0139\u009c\2\u05c1\u05c0\3\2\2\2\u05c2\u05c3\3\2\2\2\u05c3"+
		"\u05c1\3\2\2\2\u05c3\u05c4\3\2\2\2\u05c4\u012c\3\2\2\2\u05c5\u05c9\7&"+
		"\2\2\u05c6\u05c8\5\u013b\u009d\2\u05c7\u05c6\3\2\2\2\u05c8\u05cb\3\2\2"+
		"\2\u05c9\u05c7\3\2\2\2\u05c9\u05ca\3\2\2\2\u05ca\u05cc\3\2\2\2\u05cb\u05c9"+
		"\3\2\2\2\u05cc\u05ce\7\60\2\2\u05cd\u05cf\5\u013b\u009d\2\u05ce\u05cd"+
		"\3\2\2\2\u05cf\u05d0\3\2\2\2\u05d0\u05ce\3\2\2\2\u05d0\u05d1\3\2\2\2\u05d1"+
		"\u012e\3\2\2\2\u05d2\u05d6\5\u0133\u0099\2\u05d3\u05d6\5\u0135\u009a\2"+
		"\u05d4\u05d6\5\u0131\u0098\2\u05d5\u05d2\3\2\2\2\u05d5\u05d3\3\2\2\2\u05d5"+
		"\u05d4\3\2\2\2\u05d6\u0130\3\2\2\2\u05d7\u05d9\7\'\2\2\u05d8\u05da\5\u0137"+
		"\u009b\2\u05d9\u05d8\3\2\2\2\u05da\u05db\3\2\2\2\u05db\u05d9\3\2\2\2\u05db"+
		"\u05dc\3\2\2\2\u05dc\u0132\3\2\2\2\u05dd\u05df\5\u0139\u009c\2\u05de\u05dd"+
		"\3\2\2\2\u05df\u05e0\3\2\2\2\u05e0\u05de\3\2\2\2\u05e0\u05e1\3\2\2\2\u05e1"+
		"\u0134\3\2\2\2\u05e2\u05e4\7&\2\2\u05e3\u05e5\5\u013b\u009d\2\u05e4\u05e3"+
		"\3\2\2\2\u05e5\u05e6\3\2\2\2\u05e6\u05e4\3\2\2\2\u05e6\u05e7\3\2\2\2\u05e7"+
		"\u0136\3\2\2\2\u05e8\u05e9\t\5\2\2\u05e9\u0138\3\2\2\2\u05ea\u05eb\t\6"+
		"\2\2\u05eb\u013a\3\2\2\2\u05ec\u05ed\t\7\2\2\u05ed\u013c\3\2\2\2\u05ee"+
		"\u05f2\7)\2\2\u05ef\u05f0\7^\2\2\u05f0\u05f3\t\16\2\2\u05f1\u05f3\n\20"+
		"\2\2\u05f2\u05ef\3\2\2\2\u05f2\u05f1\3\2\2\2\u05f3\u05f4\3\2\2\2\u05f4"+
		"\u05f5\7)\2\2\u05f5\u013e\3\2\2\2\u05f6\u05f8\5\u0141\u00a0\2\u05f7\u05f9"+
		"\t\23\2\2\u05f8\u05f7\3\2\2\2\u05f9\u05fa\3\2\2\2\u05fa\u05f8\3\2\2\2"+
		"\u05fa\u05fb\3\2\2\2\u05fb\u0140\3\2\2\2\u05fc\u0600\7#\2\2\u05fd\u05ff"+
		"\5\u0147\u00a3\2\u05fe\u05fd\3\2\2\2\u05ff\u0602\3\2\2\2\u0600\u05fe\3"+
		"\2\2\2\u0600\u0601\3\2\2\2\u0601\u0142\3\2\2\2\u0602\u0600\3\2\2\2\u0603"+
		"\u0607\5\u0145\u00a2\2\u0604\u0606\5\u0147\u00a3\2\u0605\u0604\3\2\2\2"+
		"\u0606\u0609\3\2\2\2\u0607\u0605\3\2\2\2\u0607\u0608\3\2\2\2\u0608\u0144"+
		"\3\2\2\2\u0609\u0607\3\2\2\2\u060a\u060b\t\b\2\2\u060b\u0146\3\2\2\2\u060c"+
		"\u060d\t\t\2\2\u060d\u0148\3\2\2\2\u060e\u0610\t\21\2\2\u060f\u060e\3"+
		"\2\2\2\u0610\u0611\3\2\2\2\u0611\u060f\3\2\2\2\u0611\u0612\3\2\2\2\u0612"+
		"\u0613\3\2\2\2\u0613\u0614\b\u00a4\7\2\u0614\u014a\3\2\2\2\u0615\u0616"+
		"\7\61\2\2\u0616\u0617\7\61\2\2\u0617\u061b\3\2\2\2\u0618\u061a\n\22\2"+
		"\2\u0619\u0618\3\2\2\2\u061a\u061d\3\2\2\2\u061b\u0619\3\2\2\2\u061b\u061c"+
		"\3\2\2\2\u061c\u061e\3\2\2\2\u061d\u061b\3\2\2\2\u061e\u061f\b\u00a5\b"+
		"\2\u061f\u014c\3\2\2\2\u0620\u0621\7\61\2\2\u0621\u0622\7,\2\2\u0622\u0626"+
		"\3\2\2\2\u0623\u0625\13\2\2\2\u0624\u0623\3\2\2\2\u0625\u0628\3\2\2\2"+
		"\u0626\u0627\3\2\2\2\u0626\u0624\3\2\2\2\u0627\u0629\3\2\2\2\u0628\u0626"+
		"\3\2\2\2\u0629\u062a\7,\2\2\u062a\u062b\7\61\2\2\u062b\u062c\3\2\2\2\u062c"+
		"\u062d\b\u00a6\b\2\u062d\u014e\3\2\2\2\u062e\u0630\7>\2\2\u062f\u0631"+
		"\t\24\2\2\u0630\u062f\3\2\2\2\u0631\u0632\3\2\2\2\u0632\u0630\3\2\2\2"+
		"\u0632\u0633\3\2\2\2\u0633\u0634\3\2\2\2\u0634\u0635\7@\2\2\u0635\u0636"+
		"\b\u00a7\13\2\u0636\u0150\3\2\2\2\u0637\u063d\7$\2\2\u0638\u0639\7^\2"+
		"\2\u0639\u063c\7$\2\2\u063a\u063c\n\n\2\2\u063b\u0638\3\2\2\2\u063b\u063a"+
		"\3\2\2\2\u063c\u063f\3\2\2\2\u063d\u063b\3\2\2\2\u063d\u063e\3\2\2\2\u063e"+
		"\u0640\3\2\2\2\u063f\u063d\3\2\2\2\u0640\u0641\7$\2\2\u0641\u0642\b\u00a8"+
		"\f\2\u0642\u0152\3\2\2\2\u0643\u0645\t\21\2\2\u0644\u0643\3\2\2\2\u0645"+
		"\u0646\3\2\2\2\u0646\u0644\3\2\2\2\u0646\u0647\3\2\2\2\u0647\u0648\3\2"+
		"\2\2\u0648\u0649\b\u00a9\7\2\u0649\u0154\3\2\2\2\u064a\u064b\7\61\2\2"+
		"\u064b\u064c\7\61\2\2\u064c\u0650\3\2\2\2\u064d\u064f\n\22\2\2\u064e\u064d"+
		"\3\2\2\2\u064f\u0652\3\2\2\2\u0650\u064e\3\2\2\2\u0650\u0651\3\2\2\2\u0651"+
		"\u0653\3\2\2\2\u0652\u0650\3\2\2\2\u0653\u0654\b\u00aa\b\2\u0654\u0156"+
		"\3\2\2\2\u0655\u0656\7\61\2\2\u0656\u0657\7,\2\2\u0657\u065b\3\2\2\2\u0658"+
		"\u065a\13\2\2\2\u0659\u0658\3\2\2\2\u065a\u065d\3\2\2\2\u065b\u065c\3"+
		"\2\2\2\u065b\u0659\3\2\2\2\u065c\u065e\3\2\2\2\u065d\u065b\3\2\2\2\u065e"+
		"\u065f\7,\2\2\u065f\u0660\7\61\2\2\u0660\u0661\3\2\2\2\u0661\u0662\b\u00ab"+
		"\b\2\u0662\u0158\3\2\2\2D\2\3\4\u01c6\u0292\u0341\u0368\u0373\u037b\u03ab"+
		"\u03dc\u03e1\u03e8\u03ed\u03f4\u03f9\u0400\u0407\u040c\u0413\u0418\u041d"+
		"\u0424\u042a\u042c\u0431\u0438\u043d\u0449\u0456\u0458\u045d\u0461\u0463"+
		"\u0466\u046e\u0471\u0478\u0482\u048d\u0579\u05a5\u05aa\u05b0\u05b7\u05bc"+
		"\u05c3\u05c9\u05d0\u05d5\u05db\u05e0\u05e6\u05f2\u05fa\u0600\u0607\u0611"+
		"\u061b\u0626\u0632\u063b\u063d\u0646\u0650\u065b\r\3\2\2\3K\3\3^\4\3_"+
		"\5\3v\6\2\3\2\2\4\2\3\u0090\7\3\u0091\b\3\u00a7\t\3\u00a8\n";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}
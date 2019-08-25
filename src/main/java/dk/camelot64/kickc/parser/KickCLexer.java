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
		PAR_BEGIN=6, PAR_END=7, SEMICOLON=8, COLON=9, COMMA=10, RANGE=11, QUESTION=12, 
		DOT=13, ARROW=14, PLUS=15, MINUS=16, ASTERISK=17, DIVIDE=18, MODULO=19, 
		INC=20, DEC=21, AND=22, BIT_NOT=23, BIT_XOR=24, BIT_OR=25, SHIFT_LEFT=26, 
		SHIFT_RIGHT=27, EQUAL=28, NOT_EQUAL=29, LESS_THAN=30, LESS_THAN_EQUAL=31, 
		GREATER_THAN_EQUAL=32, GREATER_THAN=33, LOGIC_AND=34, LOGIC_OR=35, ASSIGN=36, 
		ASSIGN_COMPOUND=37, IMPORT=38, TYPEDEF=39, PRAGMA=40, RESERVE=41, PC=42, 
		TARGET=43, LINK=44, CODESEG=45, DATASEG=46, ENCODING=47, CONST=48, EXTERN=49, 
		EXPORT=50, ALIGN=51, REGISTER=52, INLINE=53, VOLATILE=54, INTERRUPT=55, 
		IF=56, ELSE=57, WHILE=58, DO=59, FOR=60, SWITCH=61, RETURN=62, BREAK=63, 
		CONTINUE=64, ASM=65, DEFAULT=66, CASE=67, STRUCT=68, ENUM=69, SIZEOF=70, 
		TYPEID=71, KICKASM=72, RESOURCE=73, USES=74, CLOBBERS=75, BYTES=76, CYCLES=77, 
		LOGIC_NOT=78, SIGNEDNESS=79, SIMPLETYPE=80, BOOLEAN=81, KICKASM_BODY=82, 
		STRING=83, CHAR=84, NUMBER=85, NUMFLOAT=86, BINFLOAT=87, DECFLOAT=88, 
		HEXFLOAT=89, NUMINT=90, BININTEGER=91, DECINTEGER=92, HEXINTEGER=93, NAME=94, 
		WS=95, COMMENT_LINE=96, COMMENT_BLOCK=97, ASM_BYTE=98, ASM_MNEMONIC=99, 
		ASM_REL=100, ASM_IMM=101, ASM_COLON=102, ASM_EXCL=103, ASM_COMMA=104, 
		ASM_PAR_BEGIN=105, ASM_PAR_END=106, ASM_BRACKET_BEGIN=107, ASM_BRACKET_END=108, 
		ASM_DOT=109, ASM_SHIFT_LEFT=110, ASM_SHIFT_RIGHT=111, ASM_PLUS=112, ASM_MINUS=113, 
		ASM_LESS_THAN=114, ASM_GREATER_THAN=115, ASM_MULTIPLY=116, ASM_DIVIDE=117, 
		ASM_CURLY_BEGIN=118, ASM_CURLY_END=119, ASM_NUMBER=120, ASM_NUMFLOAT=121, 
		ASM_BINFLOAT=122, ASM_DECFLOAT=123, ASM_HEXFLOAT=124, ASM_NUMINT=125, 
		ASM_BININTEGER=126, ASM_DECINTEGER=127, ASM_HEXINTEGER=128, ASM_CHAR=129, 
		ASM_NAME=130, ASM_WS=131, ASM_COMMENT_LINE=132, ASM_COMMENT_BLOCK=133;
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
		"PAR_END", "SEMICOLON", "COLON", "COMMA", "RANGE", "QUESTION", "DOT", 
		"ARROW", "PLUS", "MINUS", "ASTERISK", "DIVIDE", "MODULO", "INC", "DEC", 
		"AND", "BIT_NOT", "BIT_XOR", "BIT_OR", "SHIFT_LEFT", "SHIFT_RIGHT", "EQUAL", 
		"NOT_EQUAL", "LESS_THAN", "LESS_THAN_EQUAL", "GREATER_THAN_EQUAL", "GREATER_THAN", 
		"LOGIC_AND", "LOGIC_OR", "ASSIGN", "ASSIGN_COMPOUND", "IMPORT", "TYPEDEF", 
		"PRAGMA", "RESERVE", "PC", "TARGET", "LINK", "CODESEG", "DATASEG", "ENCODING", 
		"CONST", "EXTERN", "EXPORT", "ALIGN", "REGISTER", "INLINE", "VOLATILE", 
		"INTERRUPT", "IF", "ELSE", "WHILE", "DO", "FOR", "SWITCH", "RETURN", "BREAK", 
		"CONTINUE", "ASM", "DEFAULT", "CASE", "STRUCT", "ENUM", "SIZEOF", "TYPEID", 
		"KICKASM", "RESOURCE", "USES", "CLOBBERS", "BYTES", "CYCLES", "LOGIC_NOT", 
		"SIGNEDNESS", "SIMPLETYPE", "BOOLEAN", "KICKASM_BODY", "STRING", "CHAR", 
		"NUMBER", "NUMFLOAT", "BINFLOAT", "DECFLOAT", "HEXFLOAT", "NUMINT", "BININTEGER", 
		"DECINTEGER", "HEXINTEGER", "BINDIGIT", "DECDIGIT", "HEXDIGIT", "NAME", 
		"NAME_START", "NAME_CHAR", "WS", "COMMENT_LINE", "COMMENT_BLOCK", "ASM_BYTE", 
		"ASM_MNEMONIC", "ASM_REL", "ASM_IMM", "ASM_COLON", "ASM_EXCL", "ASM_COMMA", 
		"ASM_PAR_BEGIN", "ASM_PAR_END", "ASM_BRACKET_BEGIN", "ASM_BRACKET_END", 
		"ASM_DOT", "ASM_SHIFT_LEFT", "ASM_SHIFT_RIGHT", "ASM_PLUS", "ASM_MINUS", 
		"ASM_LESS_THAN", "ASM_GREATER_THAN", "ASM_MULTIPLY", "ASM_DIVIDE", "ASM_CURLY_BEGIN", 
		"ASM_CURLY_END", "ASM_NUMBER", "ASM_NUMFLOAT", "ASM_BINFLOAT", "ASM_DECFLOAT", 
		"ASM_HEXFLOAT", "ASM_NUMINT", "ASM_BININTEGER", "ASM_DECINTEGER", "ASM_HEXINTEGER", 
		"ASM_BINDIGIT", "ASM_DECDIGIT", "ASM_HEXDIGIT", "ASM_CHAR", "ASM_NAME", 
		"ASM_NAME_START", "ASM_NAME_CHAR", "ASM_WS", "ASM_COMMENT_LINE", "ASM_COMMENT_BLOCK"
	};

	private static final String[] _LITERAL_NAMES = {
		null, null, null, null, null, null, null, null, "';'", null, null, "'..'", 
		"'?'", null, "'->'", null, null, null, null, "'%'", "'++'", "'--'", "'&'", 
		"'~'", "'^'", "'|'", null, null, "'=='", "'!='", null, "'<='", "'>='", 
		null, "'&&'", "'||'", "'='", null, "'import'", "'typedef'", "'#pragma'", 
		"'reserve'", "'pc'", "'target'", "'link'", "'code_seg'", "'data_seg'", 
		"'encoding'", "'const'", "'extern'", "'export'", "'align'", "'register'", 
		"'inline'", "'volatile'", "'interrupt'", "'if'", "'else'", "'while'", 
		"'do'", "'for'", "'switch'", "'return'", "'break'", "'continue'", "'asm'", 
		"'default'", "'case'", "'struct'", "'enum'", "'sizeof'", "'typeid'", "'kickasm'", 
		"'resource'", "'uses'", "'clobbers'", "'bytes'", "'cycles'", null, null, 
		null, null, null, null, null, null, null, null, null, null, null, null, 
		null, null, null, null, null, null, "'.byte'", null, null, "'#'"
	};
	private static final String[] _SYMBOLIC_NAMES = {
		null, "TYPEDEFNAME", "CURLY_BEGIN", "CURLY_END", "BRACKET_BEGIN", "BRACKET_END", 
		"PAR_BEGIN", "PAR_END", "SEMICOLON", "COLON", "COMMA", "RANGE", "QUESTION", 
		"DOT", "ARROW", "PLUS", "MINUS", "ASTERISK", "DIVIDE", "MODULO", "INC", 
		"DEC", "AND", "BIT_NOT", "BIT_XOR", "BIT_OR", "SHIFT_LEFT", "SHIFT_RIGHT", 
		"EQUAL", "NOT_EQUAL", "LESS_THAN", "LESS_THAN_EQUAL", "GREATER_THAN_EQUAL", 
		"GREATER_THAN", "LOGIC_AND", "LOGIC_OR", "ASSIGN", "ASSIGN_COMPOUND", 
		"IMPORT", "TYPEDEF", "PRAGMA", "RESERVE", "PC", "TARGET", "LINK", "CODESEG", 
		"DATASEG", "ENCODING", "CONST", "EXTERN", "EXPORT", "ALIGN", "REGISTER", 
		"INLINE", "VOLATILE", "INTERRUPT", "IF", "ELSE", "WHILE", "DO", "FOR", 
		"SWITCH", "RETURN", "BREAK", "CONTINUE", "ASM", "DEFAULT", "CASE", "STRUCT", 
		"ENUM", "SIZEOF", "TYPEID", "KICKASM", "RESOURCE", "USES", "CLOBBERS", 
		"BYTES", "CYCLES", "LOGIC_NOT", "SIGNEDNESS", "SIMPLETYPE", "BOOLEAN", 
		"KICKASM_BODY", "STRING", "CHAR", "NUMBER", "NUMFLOAT", "BINFLOAT", "DECFLOAT", 
		"HEXFLOAT", "NUMINT", "BININTEGER", "DECINTEGER", "HEXINTEGER", "NAME", 
		"WS", "COMMENT_LINE", "COMMENT_BLOCK", "ASM_BYTE", "ASM_MNEMONIC", "ASM_REL", 
		"ASM_IMM", "ASM_COLON", "ASM_EXCL", "ASM_COMMA", "ASM_PAR_BEGIN", "ASM_PAR_END", 
		"ASM_BRACKET_BEGIN", "ASM_BRACKET_END", "ASM_DOT", "ASM_SHIFT_LEFT", "ASM_SHIFT_RIGHT", 
		"ASM_PLUS", "ASM_MINUS", "ASM_LESS_THAN", "ASM_GREATER_THAN", "ASM_MULTIPLY", 
		"ASM_DIVIDE", "ASM_CURLY_BEGIN", "ASM_CURLY_END", "ASM_NUMBER", "ASM_NUMFLOAT", 
		"ASM_BINFLOAT", "ASM_DECFLOAT", "ASM_HEXFLOAT", "ASM_NUMINT", "ASM_BININTEGER", 
		"ASM_DECINTEGER", "ASM_HEXINTEGER", "ASM_CHAR", "ASM_NAME", "ASM_WS", 
		"ASM_COMMENT_LINE", "ASM_COMMENT_BLOCK"
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
		case 63:
			ASM_action((RuleContext)_localctx, actionIndex);
			break;
		case 81:
			STRING_action((RuleContext)_localctx, actionIndex);
			break;
		case 95:
			NAME_action((RuleContext)_localctx, actionIndex);
			break;
		case 121:
			ASM_CURLY_BEGIN_action((RuleContext)_localctx, actionIndex);
			break;
		case 122:
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
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\2\u0087\u0540\b\1\b"+
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
		"\4\u008e\t\u008e\4\u008f\t\u008f\3\2\3\2\3\2\3\3\3\3\3\4\3\4\3\5\3\5\3"+
		"\6\3\6\3\7\3\7\3\b\3\b\3\t\3\t\3\n\3\n\3\13\3\13\3\13\3\f\3\f\3\r\3\r"+
		"\3\16\3\16\3\16\3\17\3\17\3\20\3\20\3\21\3\21\3\22\3\22\3\23\3\23\3\24"+
		"\3\24\3\24\3\25\3\25\3\25\3\26\3\26\3\27\3\27\3\30\3\30\3\31\3\31\3\32"+
		"\3\32\3\32\3\33\3\33\3\33\3\34\3\34\3\34\3\35\3\35\3\35\3\36\3\36\3\37"+
		"\3\37\3\37\3 \3 \3 \3!\3!\3\"\3\"\3\"\3#\3#\3#\3$\3$\3%\3%\3%\3%\3%\3"+
		"%\3%\3%\3%\3%\3%\3%\3%\3%\3%\3%\3%\3%\3%\3%\3%\3%\5%\u018a\n%\3&\3&\3"+
		"&\3&\3&\3&\3&\3&\3&\3\'\3\'\3\'\3\'\3\'\3\'\3\'\3\'\3(\3(\3(\3(\3(\3("+
		"\3(\3(\3)\3)\3)\3)\3)\3)\3)\3)\3*\3*\3*\3+\3+\3+\3+\3+\3+\3+\3,\3,\3,"+
		"\3,\3,\3-\3-\3-\3-\3-\3-\3-\3-\3-\3.\3.\3.\3.\3.\3.\3.\3.\3.\3/\3/\3/"+
		"\3/\3/\3/\3/\3/\3/\3\60\3\60\3\60\3\60\3\60\3\60\3\61\3\61\3\61\3\61\3"+
		"\61\3\61\3\61\3\62\3\62\3\62\3\62\3\62\3\62\3\62\3\63\3\63\3\63\3\63\3"+
		"\63\3\63\3\64\3\64\3\64\3\64\3\64\3\64\3\64\3\64\3\64\3\65\3\65\3\65\3"+
		"\65\3\65\3\65\3\65\3\66\3\66\3\66\3\66\3\66\3\66\3\66\3\66\3\66\3\67\3"+
		"\67\3\67\3\67\3\67\3\67\3\67\3\67\3\67\3\67\38\38\38\39\39\39\39\39\3"+
		":\3:\3:\3:\3:\3:\3;\3;\3;\3<\3<\3<\3<\3=\3=\3=\3=\3=\3=\3=\3>\3>\3>\3"+
		">\3>\3>\3>\3?\3?\3?\3?\3?\3?\3@\3@\3@\3@\3@\3@\3@\3@\3@\3A\3A\3A\3A\3"+
		"A\3A\3B\3B\3B\3B\3B\3B\3B\3B\3C\3C\3C\3C\3C\3D\3D\3D\3D\3D\3D\3D\3E\3"+
		"E\3E\3E\3E\3F\3F\3F\3F\3F\3F\3F\3G\3G\3G\3G\3G\3G\3G\3H\3H\3H\3H\3H\3"+
		"H\3H\3H\3I\3I\3I\3I\3I\3I\3I\3I\3I\3J\3J\3J\3J\3J\3K\3K\3K\3K\3K\3K\3"+
		"K\3K\3K\3L\3L\3L\3L\3L\3L\3M\3M\3M\3M\3M\3M\3M\3N\3N\3O\3O\3O\3O\3O\3"+
		"O\3O\3O\3O\3O\3O\3O\3O\3O\5O\u02af\nO\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3"+
		"P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3P\3"+
		"P\3P\3P\3P\5P\u02d6\nP\3Q\3Q\3Q\3Q\3Q\3Q\3Q\3Q\3Q\5Q\u02e1\nQ\3R\3R\3"+
		"R\3R\7R\u02e7\nR\fR\16R\u02ea\13R\3R\3R\3R\3S\3S\3S\3S\7S\u02f3\nS\fS"+
		"\16S\u02f6\13S\3S\3S\5S\u02fa\nS\3S\3S\5S\u02fe\nS\5S\u0300\nS\3S\5S\u0303"+
		"\nS\3S\3S\3T\3T\3T\3T\5T\u030b\nT\3T\3T\3U\3U\5U\u0311\nU\3V\3V\3V\5V"+
		"\u0316\nV\3W\3W\3W\3W\3W\5W\u031d\nW\3W\7W\u0320\nW\fW\16W\u0323\13W\3"+
		"W\3W\6W\u0327\nW\rW\16W\u0328\3X\7X\u032c\nX\fX\16X\u032f\13X\3X\3X\6"+
		"X\u0333\nX\rX\16X\u0334\3Y\3Y\3Y\3Y\3Y\5Y\u033c\nY\3Y\7Y\u033f\nY\fY\16"+
		"Y\u0342\13Y\3Y\3Y\6Y\u0346\nY\rY\16Y\u0347\3Z\3Z\3Z\5Z\u034d\nZ\3Z\3Z"+
		"\3Z\5Z\u0352\nZ\3[\3[\3[\6[\u0357\n[\r[\16[\u0358\3[\3[\6[\u035d\n[\r"+
		"[\16[\u035e\5[\u0361\n[\3\\\6\\\u0364\n\\\r\\\16\\\u0365\3]\3]\3]\3]\3"+
		"]\5]\u036d\n]\3]\6]\u0370\n]\r]\16]\u0371\3^\3^\3_\3_\3`\3`\3a\3a\7a\u037c"+
		"\na\fa\16a\u037f\13a\3a\3a\3b\3b\3c\3c\3d\6d\u0388\nd\rd\16d\u0389\3d"+
		"\3d\3e\3e\3e\3e\7e\u0392\ne\fe\16e\u0395\13e\3e\3e\3f\3f\3f\3f\7f\u039d"+
		"\nf\ff\16f\u03a0\13f\3f\3f\3f\3f\3f\3g\3g\3g\3g\3g\3g\3h\3h\3h\3h\3h\3"+
		"h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3"+
		"h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3"+
		"h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3"+
		"h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3"+
		"h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3"+
		"h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3"+
		"h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3"+
		"h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3"+
		"h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3h\3"+
		"h\3h\3h\3h\3h\3h\3h\3h\3h\3h\5h\u048b\nh\3i\3i\7i\u048f\ni\fi\16i\u0492"+
		"\13i\3i\6i\u0495\ni\ri\16i\u0496\3j\3j\3k\3k\3l\3l\3m\3m\3n\3n\3o\3o\3"+
		"p\3p\3q\3q\3r\3r\3s\3s\3s\3t\3t\3t\3u\3u\3v\3v\3w\3w\3x\3x\3y\3y\3z\3"+
		"z\3{\3{\3{\3|\3|\3|\3}\3}\5}\u04c5\n}\3~\3~\3~\5~\u04ca\n~\3\177\3\177"+
		"\7\177\u04ce\n\177\f\177\16\177\u04d1\13\177\3\177\3\177\6\177\u04d5\n"+
		"\177\r\177\16\177\u04d6\3\u0080\7\u0080\u04da\n\u0080\f\u0080\16\u0080"+
		"\u04dd\13\u0080\3\u0080\3\u0080\6\u0080\u04e1\n\u0080\r\u0080\16\u0080"+
		"\u04e2\3\u0081\3\u0081\7\u0081\u04e7\n\u0081\f\u0081\16\u0081\u04ea\13"+
		"\u0081\3\u0081\3\u0081\6\u0081\u04ee\n\u0081\r\u0081\16\u0081\u04ef\3"+
		"\u0082\3\u0082\3\u0082\5\u0082\u04f5\n\u0082\3\u0083\3\u0083\6\u0083\u04f9"+
		"\n\u0083\r\u0083\16\u0083\u04fa\3\u0084\6\u0084\u04fe\n\u0084\r\u0084"+
		"\16\u0084\u04ff\3\u0085\3\u0085\6\u0085\u0504\n\u0085\r\u0085\16\u0085"+
		"\u0505\3\u0086\3\u0086\3\u0087\3\u0087\3\u0088\3\u0088\3\u0089\3\u0089"+
		"\3\u0089\3\u0089\5\u0089\u0512\n\u0089\3\u0089\3\u0089\3\u008a\3\u008a"+
		"\7\u008a\u0518\n\u008a\f\u008a\16\u008a\u051b\13\u008a\3\u008b\3\u008b"+
		"\3\u008c\3\u008c\3\u008d\6\u008d\u0522\n\u008d\r\u008d\16\u008d\u0523"+
		"\3\u008d\3\u008d\3\u008e\3\u008e\3\u008e\3\u008e\7\u008e\u052c\n\u008e"+
		"\f\u008e\16\u008e\u052f\13\u008e\3\u008e\3\u008e\3\u008f\3\u008f\3\u008f"+
		"\3\u008f\7\u008f\u0537\n\u008f\f\u008f\16\u008f\u053a\13\u008f\3\u008f"+
		"\3\u008f\3\u008f\3\u008f\3\u008f\5\u02e8\u039e\u0538\2\u0090\4\4\6\5\b"+
		"\6\n\7\f\b\16\t\20\n\22\13\24\f\26\r\30\16\32\17\34\20\36\21 \22\"\23"+
		"$\24&\25(\26*\27,\30.\31\60\32\62\33\64\34\66\358\36:\37< >!@\"B#D$F%"+
		"H&J\'L(N)P*R+T,V-X.Z/\\\60^\61`\62b\63d\64f\65h\66j\67l8n9p:r;t<v=x>z"+
		"?|@~A\u0080B\u0082C\u0084D\u0086E\u0088F\u008aG\u008cH\u008eI\u0090J\u0092"+
		"K\u0094L\u0096M\u0098N\u009aO\u009cP\u009eQ\u00a0R\u00a2S\u00a4T\u00a6"+
		"U\u00a8V\u00aaW\u00acX\u00aeY\u00b0Z\u00b2[\u00b4\\\u00b6]\u00b8^\u00ba"+
		"_\u00bc\2\u00be\2\u00c0\2\u00c2`\u00c4\2\u00c6\2\u00c8a\u00cab\u00ccc"+
		"\u00ced\u00d0e\u00d2f\u00d4g\u00d6h\u00d8i\u00daj\u00dck\u00del\u00e0"+
		"m\u00e2n\u00e4o\u00e6p\u00e8q\u00ear\u00ecs\u00eet\u00f0u\u00f2v\u00f4"+
		"w\u00f6x\u00f8y\u00faz\u00fc{\u00fe|\u0100}\u0102~\u0104\177\u0106\u0080"+
		"\u0108\u0081\u010a\u0082\u010c\2\u010e\2\u0110\2\u0112\u0083\u0114\u0084"+
		"\u0116\2\u0118\2\u011a\u0085\u011c\u0086\u011e\u0087\4\2\3\23\3\2$$\3"+
		"\2||\4\2rruu\4\2ooww\7\2$$))hhpptt\3\2))\4\2uuww\7\2dfkknnuuyy\4\2DDd"+
		"d\3\2\62\63\3\2\62;\5\2\62;CHch\5\2C\\aac|\6\2\62;C\\aac|\6\2\13\f\17"+
		"\17\"\"\u00a2\u00a2\4\2\f\f\17\17\4\2--//\2\u05c9\2\4\3\2\2\2\2\6\3\2"+
		"\2\2\2\b\3\2\2\2\2\n\3\2\2\2\2\f\3\2\2\2\2\16\3\2\2\2\2\20\3\2\2\2\2\22"+
		"\3\2\2\2\2\24\3\2\2\2\2\26\3\2\2\2\2\30\3\2\2\2\2\32\3\2\2\2\2\34\3\2"+
		"\2\2\2\36\3\2\2\2\2 \3\2\2\2\2\"\3\2\2\2\2$\3\2\2\2\2&\3\2\2\2\2(\3\2"+
		"\2\2\2*\3\2\2\2\2,\3\2\2\2\2.\3\2\2\2\2\60\3\2\2\2\2\62\3\2\2\2\2\64\3"+
		"\2\2\2\2\66\3\2\2\2\28\3\2\2\2\2:\3\2\2\2\2<\3\2\2\2\2>\3\2\2\2\2@\3\2"+
		"\2\2\2B\3\2\2\2\2D\3\2\2\2\2F\3\2\2\2\2H\3\2\2\2\2J\3\2\2\2\2L\3\2\2\2"+
		"\2N\3\2\2\2\2P\3\2\2\2\2R\3\2\2\2\2T\3\2\2\2\2V\3\2\2\2\2X\3\2\2\2\2Z"+
		"\3\2\2\2\2\\\3\2\2\2\2^\3\2\2\2\2`\3\2\2\2\2b\3\2\2\2\2d\3\2\2\2\2f\3"+
		"\2\2\2\2h\3\2\2\2\2j\3\2\2\2\2l\3\2\2\2\2n\3\2\2\2\2p\3\2\2\2\2r\3\2\2"+
		"\2\2t\3\2\2\2\2v\3\2\2\2\2x\3\2\2\2\2z\3\2\2\2\2|\3\2\2\2\2~\3\2\2\2\2"+
		"\u0080\3\2\2\2\2\u0082\3\2\2\2\2\u0084\3\2\2\2\2\u0086\3\2\2\2\2\u0088"+
		"\3\2\2\2\2\u008a\3\2\2\2\2\u008c\3\2\2\2\2\u008e\3\2\2\2\2\u0090\3\2\2"+
		"\2\2\u0092\3\2\2\2\2\u0094\3\2\2\2\2\u0096\3\2\2\2\2\u0098\3\2\2\2\2\u009a"+
		"\3\2\2\2\2\u009c\3\2\2\2\2\u009e\3\2\2\2\2\u00a0\3\2\2\2\2\u00a2\3\2\2"+
		"\2\2\u00a4\3\2\2\2\2\u00a6\3\2\2\2\2\u00a8\3\2\2\2\2\u00aa\3\2\2\2\2\u00ac"+
		"\3\2\2\2\2\u00ae\3\2\2\2\2\u00b0\3\2\2\2\2\u00b2\3\2\2\2\2\u00b4\3\2\2"+
		"\2\2\u00b6\3\2\2\2\2\u00b8\3\2\2\2\2\u00ba\3\2\2\2\2\u00c2\3\2\2\2\2\u00c8"+
		"\3\2\2\2\2\u00ca\3\2\2\2\2\u00cc\3\2\2\2\3\u00ce\3\2\2\2\3\u00d0\3\2\2"+
		"\2\3\u00d2\3\2\2\2\3\u00d4\3\2\2\2\3\u00d6\3\2\2\2\3\u00d8\3\2\2\2\3\u00da"+
		"\3\2\2\2\3\u00dc\3\2\2\2\3\u00de\3\2\2\2\3\u00e0\3\2\2\2\3\u00e2\3\2\2"+
		"\2\3\u00e4\3\2\2\2\3\u00e6\3\2\2\2\3\u00e8\3\2\2\2\3\u00ea\3\2\2\2\3\u00ec"+
		"\3\2\2\2\3\u00ee\3\2\2\2\3\u00f0\3\2\2\2\3\u00f2\3\2\2\2\3\u00f4\3\2\2"+
		"\2\3\u00f6\3\2\2\2\3\u00f8\3\2\2\2\3\u00fa\3\2\2\2\3\u00fc\3\2\2\2\3\u00fe"+
		"\3\2\2\2\3\u0100\3\2\2\2\3\u0102\3\2\2\2\3\u0104\3\2\2\2\3\u0106\3\2\2"+
		"\2\3\u0108\3\2\2\2\3\u010a\3\2\2\2\3\u0112\3\2\2\2\3\u0114\3\2\2\2\3\u011a"+
		"\3\2\2\2\3\u011c\3\2\2\2\3\u011e\3\2\2\2\4\u0120\3\2\2\2\6\u0123\3\2\2"+
		"\2\b\u0125\3\2\2\2\n\u0127\3\2\2\2\f\u0129\3\2\2\2\16\u012b\3\2\2\2\20"+
		"\u012d\3\2\2\2\22\u012f\3\2\2\2\24\u0131\3\2\2\2\26\u0133\3\2\2\2\30\u0136"+
		"\3\2\2\2\32\u0138\3\2\2\2\34\u013a\3\2\2\2\36\u013d\3\2\2\2 \u013f\3\2"+
		"\2\2\"\u0141\3\2\2\2$\u0143\3\2\2\2&\u0145\3\2\2\2(\u0147\3\2\2\2*\u014a"+
		"\3\2\2\2,\u014d\3\2\2\2.\u014f\3\2\2\2\60\u0151\3\2\2\2\62\u0153\3\2\2"+
		"\2\64\u0155\3\2\2\2\66\u0158\3\2\2\28\u015b\3\2\2\2:\u015e\3\2\2\2<\u0161"+
		"\3\2\2\2>\u0163\3\2\2\2@\u0166\3\2\2\2B\u0169\3\2\2\2D\u016b\3\2\2\2F"+
		"\u016e\3\2\2\2H\u0171\3\2\2\2J\u0189\3\2\2\2L\u018b\3\2\2\2N\u0194\3\2"+
		"\2\2P\u019c\3\2\2\2R\u01a4\3\2\2\2T\u01ac\3\2\2\2V\u01af\3\2\2\2X\u01b6"+
		"\3\2\2\2Z\u01bb\3\2\2\2\\\u01c4\3\2\2\2^\u01cd\3\2\2\2`\u01d6\3\2\2\2"+
		"b\u01dc\3\2\2\2d\u01e3\3\2\2\2f\u01ea\3\2\2\2h\u01f0\3\2\2\2j\u01f9\3"+
		"\2\2\2l\u0200\3\2\2\2n\u0209\3\2\2\2p\u0213\3\2\2\2r\u0216\3\2\2\2t\u021b"+
		"\3\2\2\2v\u0221\3\2\2\2x\u0224\3\2\2\2z\u0228\3\2\2\2|\u022f\3\2\2\2~"+
		"\u0236\3\2\2\2\u0080\u023c\3\2\2\2\u0082\u0245\3\2\2\2\u0084\u024b\3\2"+
		"\2\2\u0086\u0253\3\2\2\2\u0088\u0258\3\2\2\2\u008a\u025f\3\2\2\2\u008c"+
		"\u0264\3\2\2\2\u008e\u026b\3\2\2\2\u0090\u0272\3\2\2\2\u0092\u027a\3\2"+
		"\2\2\u0094\u0283\3\2\2\2\u0096\u0288\3\2\2\2\u0098\u0291\3\2\2\2\u009a"+
		"\u0297\3\2\2\2\u009c\u029e\3\2\2\2\u009e\u02ae\3\2\2\2\u00a0\u02d5\3\2"+
		"\2\2\u00a2\u02e0\3\2\2\2\u00a4\u02e2\3\2\2\2\u00a6\u02ee\3\2\2\2\u00a8"+
		"\u0306\3\2\2\2\u00aa\u0310\3\2\2\2\u00ac\u0315\3\2\2\2\u00ae\u031c\3\2"+
		"\2\2\u00b0\u032d\3\2\2\2\u00b2\u033b\3\2\2\2\u00b4\u034c\3\2\2\2\u00b6"+
		"\u0360\3\2\2\2\u00b8\u0363\3\2\2\2\u00ba\u036c\3\2\2\2\u00bc\u0373\3\2"+
		"\2\2\u00be\u0375\3\2\2\2\u00c0\u0377\3\2\2\2\u00c2\u0379\3\2\2\2\u00c4"+
		"\u0382\3\2\2\2\u00c6\u0384\3\2\2\2\u00c8\u0387\3\2\2\2\u00ca\u038d\3\2"+
		"\2\2\u00cc\u0398\3\2\2\2\u00ce\u03a6\3\2\2\2\u00d0\u048a\3\2\2\2\u00d2"+
		"\u048c\3\2\2\2\u00d4\u0498\3\2\2\2\u00d6\u049a\3\2\2\2\u00d8\u049c\3\2"+
		"\2\2\u00da\u049e\3\2\2\2\u00dc\u04a0\3\2\2\2\u00de\u04a2\3\2\2\2\u00e0"+
		"\u04a4\3\2\2\2\u00e2\u04a6\3\2\2\2\u00e4\u04a8\3\2\2\2\u00e6\u04aa\3\2"+
		"\2\2\u00e8\u04ad\3\2\2\2\u00ea\u04b0\3\2\2\2\u00ec\u04b2\3\2\2\2\u00ee"+
		"\u04b4\3\2\2\2\u00f0\u04b6\3\2\2\2\u00f2\u04b8\3\2\2\2\u00f4\u04ba\3\2"+
		"\2\2\u00f6\u04bc\3\2\2\2\u00f8\u04bf\3\2\2\2\u00fa\u04c4\3\2\2\2\u00fc"+
		"\u04c9\3\2\2\2\u00fe\u04cb\3\2\2\2\u0100\u04db\3\2\2\2\u0102\u04e4\3\2"+
		"\2\2\u0104\u04f4\3\2\2\2\u0106\u04f6\3\2\2\2\u0108\u04fd\3\2\2\2\u010a"+
		"\u0501\3\2\2\2\u010c\u0507\3\2\2\2\u010e\u0509\3\2\2\2\u0110\u050b\3\2"+
		"\2\2\u0112\u050d\3\2\2\2\u0114\u0515\3\2\2\2\u0116\u051c\3\2\2\2\u0118"+
		"\u051e\3\2\2\2\u011a\u0521\3\2\2\2\u011c\u0527\3\2\2\2\u011e\u0532\3\2"+
		"\2\2\u0120\u0121\7}\2\2\u0121\u0122\b\2\2\2\u0122\5\3\2\2\2\u0123\u0124"+
		"\7\177\2\2\u0124\7\3\2\2\2\u0125\u0126\7]\2\2\u0126\t\3\2\2\2\u0127\u0128"+
		"\7_\2\2\u0128\13\3\2\2\2\u0129\u012a\7*\2\2\u012a\r\3\2\2\2\u012b\u012c"+
		"\7+\2\2\u012c\17\3\2\2\2\u012d\u012e\7=\2\2\u012e\21\3\2\2\2\u012f\u0130"+
		"\7<\2\2\u0130\23\3\2\2\2\u0131\u0132\7.\2\2\u0132\25\3\2\2\2\u0133\u0134"+
		"\7\60\2\2\u0134\u0135\7\60\2\2\u0135\27\3\2\2\2\u0136\u0137\7A\2\2\u0137"+
		"\31\3\2\2\2\u0138\u0139\7\60\2\2\u0139\33\3\2\2\2\u013a\u013b\7/\2\2\u013b"+
		"\u013c\7@\2\2\u013c\35\3\2\2\2\u013d\u013e\7-\2\2\u013e\37\3\2\2\2\u013f"+
		"\u0140\7/\2\2\u0140!\3\2\2\2\u0141\u0142\7,\2\2\u0142#\3\2\2\2\u0143\u0144"+
		"\7\61\2\2\u0144%\3\2\2\2\u0145\u0146\7\'\2\2\u0146\'\3\2\2\2\u0147\u0148"+
		"\7-\2\2\u0148\u0149\7-\2\2\u0149)\3\2\2\2\u014a\u014b\7/\2\2\u014b\u014c"+
		"\7/\2\2\u014c+\3\2\2\2\u014d\u014e\7(\2\2\u014e-\3\2\2\2\u014f\u0150\7"+
		"\u0080\2\2\u0150/\3\2\2\2\u0151\u0152\7`\2\2\u0152\61\3\2\2\2\u0153\u0154"+
		"\7~\2\2\u0154\63\3\2\2\2\u0155\u0156\7>\2\2\u0156\u0157\7>\2\2\u0157\65"+
		"\3\2\2\2\u0158\u0159\7@\2\2\u0159\u015a\7@\2\2\u015a\67\3\2\2\2\u015b"+
		"\u015c\7?\2\2\u015c\u015d\7?\2\2\u015d9\3\2\2\2\u015e\u015f\7#\2\2\u015f"+
		"\u0160\7?\2\2\u0160;\3\2\2\2\u0161\u0162\7>\2\2\u0162=\3\2\2\2\u0163\u0164"+
		"\7>\2\2\u0164\u0165\7?\2\2\u0165?\3\2\2\2\u0166\u0167\7@\2\2\u0167\u0168"+
		"\7?\2\2\u0168A\3\2\2\2\u0169\u016a\7@\2\2\u016aC\3\2\2\2\u016b\u016c\7"+
		"(\2\2\u016c\u016d\7(\2\2\u016dE\3\2\2\2\u016e\u016f\7~\2\2\u016f\u0170"+
		"\7~\2\2\u0170G\3\2\2\2\u0171\u0172\7?\2\2\u0172I\3\2\2\2\u0173\u0174\7"+
		"-\2\2\u0174\u018a\7?\2\2\u0175\u0176\7/\2\2\u0176\u018a\7?\2\2\u0177\u0178"+
		"\7,\2\2\u0178\u018a\7?\2\2\u0179\u017a\7\61\2\2\u017a\u018a\7?\2\2\u017b"+
		"\u017c\7\'\2\2\u017c\u018a\7?\2\2\u017d\u017e\7>\2\2\u017e\u017f\7>\2"+
		"\2\u017f\u018a\7?\2\2\u0180\u0181\7@\2\2\u0181\u0182\7@\2\2\u0182\u018a"+
		"\7?\2\2\u0183\u0184\7(\2\2\u0184\u018a\7?\2\2\u0185\u0186\7~\2\2\u0186"+
		"\u018a\7?\2\2\u0187\u0188\7`\2\2\u0188\u018a\7?\2\2\u0189\u0173\3\2\2"+
		"\2\u0189\u0175\3\2\2\2\u0189\u0177\3\2\2\2\u0189\u0179\3\2\2\2\u0189\u017b"+
		"\3\2\2\2\u0189\u017d\3\2\2\2\u0189\u0180\3\2\2\2\u0189\u0183\3\2\2\2\u0189"+
		"\u0185\3\2\2\2\u0189\u0187\3\2\2\2\u018aK\3\2\2\2\u018b\u018c\7k\2\2\u018c"+
		"\u018d\7o\2\2\u018d\u018e\7r\2\2\u018e\u018f\7q\2\2\u018f\u0190\7t\2\2"+
		"\u0190\u0191\7v\2\2\u0191\u0192\3\2\2\2\u0192\u0193\b&\3\2\u0193M\3\2"+
		"\2\2\u0194\u0195\7v\2\2\u0195\u0196\7{\2\2\u0196\u0197\7r\2\2\u0197\u0198"+
		"\7g\2\2\u0198\u0199\7f\2\2\u0199\u019a\7g\2\2\u019a\u019b\7h\2\2\u019b"+
		"O\3\2\2\2\u019c\u019d\7%\2\2\u019d\u019e\7r\2\2\u019e\u019f\7t\2\2\u019f"+
		"\u01a0\7c\2\2\u01a0\u01a1\7i\2\2\u01a1\u01a2\7o\2\2\u01a2\u01a3\7c\2\2"+
		"\u01a3Q\3\2\2\2\u01a4\u01a5\7t\2\2\u01a5\u01a6\7g\2\2\u01a6\u01a7\7u\2"+
		"\2\u01a7\u01a8\7g\2\2\u01a8\u01a9\7t\2\2\u01a9\u01aa\7x\2\2\u01aa\u01ab"+
		"\7g\2\2\u01abS\3\2\2\2\u01ac\u01ad\7r\2\2\u01ad\u01ae\7e\2\2\u01aeU\3"+
		"\2\2\2\u01af\u01b0\7v\2\2\u01b0\u01b1\7c\2\2\u01b1\u01b2\7t\2\2\u01b2"+
		"\u01b3\7i\2\2\u01b3\u01b4\7g\2\2\u01b4\u01b5\7v\2\2\u01b5W\3\2\2\2\u01b6"+
		"\u01b7\7n\2\2\u01b7\u01b8\7k\2\2\u01b8\u01b9\7p\2\2\u01b9\u01ba\7m\2\2"+
		"\u01baY\3\2\2\2\u01bb\u01bc\7e\2\2\u01bc\u01bd\7q\2\2\u01bd\u01be\7f\2"+
		"\2\u01be\u01bf\7g\2\2\u01bf\u01c0\7a\2\2\u01c0\u01c1\7u\2\2\u01c1\u01c2"+
		"\7g\2\2\u01c2\u01c3\7i\2\2\u01c3[\3\2\2\2\u01c4\u01c5\7f\2\2\u01c5\u01c6"+
		"\7c\2\2\u01c6\u01c7\7v\2\2\u01c7\u01c8\7c\2\2\u01c8\u01c9\7a\2\2\u01c9"+
		"\u01ca\7u\2\2\u01ca\u01cb\7g\2\2\u01cb\u01cc\7i\2\2\u01cc]\3\2\2\2\u01cd"+
		"\u01ce\7g\2\2\u01ce\u01cf\7p\2\2\u01cf\u01d0\7e\2\2\u01d0\u01d1\7q\2\2"+
		"\u01d1\u01d2\7f\2\2\u01d2\u01d3\7k\2\2\u01d3\u01d4\7p\2\2\u01d4\u01d5"+
		"\7i\2\2\u01d5_\3\2\2\2\u01d6\u01d7\7e\2\2\u01d7\u01d8\7q\2\2\u01d8\u01d9"+
		"\7p\2\2\u01d9\u01da\7u\2\2\u01da\u01db\7v\2\2\u01dba\3\2\2\2\u01dc\u01dd"+
		"\7g\2\2\u01dd\u01de\7z\2\2\u01de\u01df\7v\2\2\u01df\u01e0\7g\2\2\u01e0"+
		"\u01e1\7t\2\2\u01e1\u01e2\7p\2\2\u01e2c\3\2\2\2\u01e3\u01e4\7g\2\2\u01e4"+
		"\u01e5\7z\2\2\u01e5\u01e6\7r\2\2\u01e6\u01e7\7q\2\2\u01e7\u01e8\7t\2\2"+
		"\u01e8\u01e9\7v\2\2\u01e9e\3\2\2\2\u01ea\u01eb\7c\2\2\u01eb\u01ec\7n\2"+
		"\2\u01ec\u01ed\7k\2\2\u01ed\u01ee\7i\2\2\u01ee\u01ef\7p\2\2\u01efg\3\2"+
		"\2\2\u01f0\u01f1\7t\2\2\u01f1\u01f2\7g\2\2\u01f2\u01f3\7i\2\2\u01f3\u01f4"+
		"\7k\2\2\u01f4\u01f5\7u\2\2\u01f5\u01f6\7v\2\2\u01f6\u01f7\7g\2\2\u01f7"+
		"\u01f8\7t\2\2\u01f8i\3\2\2\2\u01f9\u01fa\7k\2\2\u01fa\u01fb\7p\2\2\u01fb"+
		"\u01fc\7n\2\2\u01fc\u01fd\7k\2\2\u01fd\u01fe\7p\2\2\u01fe\u01ff\7g\2\2"+
		"\u01ffk\3\2\2\2\u0200\u0201\7x\2\2\u0201\u0202\7q\2\2\u0202\u0203\7n\2"+
		"\2\u0203\u0204\7c\2\2\u0204\u0205\7v\2\2\u0205\u0206\7k\2\2\u0206\u0207"+
		"\7n\2\2\u0207\u0208\7g\2\2\u0208m\3\2\2\2\u0209\u020a\7k\2\2\u020a\u020b"+
		"\7p\2\2\u020b\u020c\7v\2\2\u020c\u020d\7g\2\2\u020d\u020e\7t\2\2\u020e"+
		"\u020f\7t\2\2\u020f\u0210\7w\2\2\u0210\u0211\7r\2\2\u0211\u0212\7v\2\2"+
		"\u0212o\3\2\2\2\u0213\u0214\7k\2\2\u0214\u0215\7h\2\2\u0215q\3\2\2\2\u0216"+
		"\u0217\7g\2\2\u0217\u0218\7n\2\2\u0218\u0219\7u\2\2\u0219\u021a\7g\2\2"+
		"\u021as\3\2\2\2\u021b\u021c\7y\2\2\u021c\u021d\7j\2\2\u021d\u021e\7k\2"+
		"\2\u021e\u021f\7n\2\2\u021f\u0220\7g\2\2\u0220u\3\2\2\2\u0221\u0222\7"+
		"f\2\2\u0222\u0223\7q\2\2\u0223w\3\2\2\2\u0224\u0225\7h\2\2\u0225\u0226"+
		"\7q\2\2\u0226\u0227\7t\2\2\u0227y\3\2\2\2\u0228\u0229\7u\2\2\u0229\u022a"+
		"\7y\2\2\u022a\u022b\7k\2\2\u022b\u022c\7v\2\2\u022c\u022d\7e\2\2\u022d"+
		"\u022e\7j\2\2\u022e{\3\2\2\2\u022f\u0230\7t\2\2\u0230\u0231\7g\2\2\u0231"+
		"\u0232\7v\2\2\u0232\u0233\7w\2\2\u0233\u0234\7t\2\2\u0234\u0235\7p\2\2"+
		"\u0235}\3\2\2\2\u0236\u0237\7d\2\2\u0237\u0238\7t\2\2\u0238\u0239\7g\2"+
		"\2\u0239\u023a\7c\2\2\u023a\u023b\7m\2\2\u023b\177\3\2\2\2\u023c\u023d"+
		"\7e\2\2\u023d\u023e\7q\2\2\u023e\u023f\7p\2\2\u023f\u0240\7v\2\2\u0240"+
		"\u0241\7k\2\2\u0241\u0242\7p\2\2\u0242\u0243\7w\2\2\u0243\u0244\7g\2\2"+
		"\u0244\u0081\3\2\2\2\u0245\u0246\7c\2\2\u0246\u0247\7u\2\2\u0247\u0248"+
		"\7o\2\2\u0248\u0249\3\2\2\2\u0249\u024a\bA\4\2\u024a\u0083\3\2\2\2\u024b"+
		"\u024c\7f\2\2\u024c\u024d\7g\2\2\u024d\u024e\7h\2\2\u024e\u024f\7c\2\2"+
		"\u024f\u0250\7w\2\2\u0250\u0251\7n\2\2\u0251\u0252\7v\2\2\u0252\u0085"+
		"\3\2\2\2\u0253\u0254\7e\2\2\u0254\u0255\7c\2\2\u0255\u0256\7u\2\2\u0256"+
		"\u0257\7g\2\2\u0257\u0087\3\2\2\2\u0258\u0259\7u\2\2\u0259\u025a\7v\2"+
		"\2\u025a\u025b\7t\2\2\u025b\u025c\7w\2\2\u025c\u025d\7e\2\2\u025d\u025e"+
		"\7v\2\2\u025e\u0089\3\2\2\2\u025f\u0260\7g\2\2\u0260\u0261\7p\2\2\u0261"+
		"\u0262\7w\2\2\u0262\u0263\7o\2\2\u0263\u008b\3\2\2\2\u0264\u0265\7u\2"+
		"\2\u0265\u0266\7k\2\2\u0266\u0267\7|\2\2\u0267\u0268\7g\2\2\u0268\u0269"+
		"\7q\2\2\u0269\u026a\7h\2\2\u026a\u008d\3\2\2\2\u026b\u026c\7v\2\2\u026c"+
		"\u026d\7{\2\2\u026d\u026e\7r\2\2\u026e\u026f\7g\2\2\u026f\u0270\7k\2\2"+
		"\u0270\u0271\7f\2\2\u0271\u008f\3\2\2\2\u0272\u0273\7m\2\2\u0273\u0274"+
		"\7k\2\2\u0274\u0275\7e\2\2\u0275\u0276\7m\2\2\u0276\u0277\7c\2\2\u0277"+
		"\u0278\7u\2\2\u0278\u0279\7o\2\2\u0279\u0091\3\2\2\2\u027a\u027b\7t\2"+
		"\2\u027b\u027c\7g\2\2\u027c\u027d\7u\2\2\u027d\u027e\7q\2\2\u027e\u027f"+
		"\7w\2\2\u027f\u0280\7t\2\2\u0280\u0281\7e\2\2\u0281\u0282\7g\2\2\u0282"+
		"\u0093\3\2\2\2\u0283\u0284\7w\2\2\u0284\u0285\7u\2\2\u0285\u0286\7g\2"+
		"\2\u0286\u0287\7u\2\2\u0287\u0095\3\2\2\2\u0288\u0289\7e\2\2\u0289\u028a"+
		"\7n\2\2\u028a\u028b\7q\2\2\u028b\u028c\7d\2\2\u028c\u028d\7d\2\2\u028d"+
		"\u028e\7g\2\2\u028e\u028f\7t\2\2\u028f\u0290\7u\2\2\u0290\u0097\3\2\2"+
		"\2\u0291\u0292\7d\2\2\u0292\u0293\7{\2\2\u0293\u0294\7v\2\2\u0294\u0295"+
		"\7g\2\2\u0295\u0296\7u\2\2\u0296\u0099\3\2\2\2\u0297\u0298\7e\2\2\u0298"+
		"\u0299\7{\2\2\u0299\u029a\7e\2\2\u029a\u029b\7n\2\2\u029b\u029c\7g\2\2"+
		"\u029c\u029d\7u\2\2\u029d\u009b\3\2\2\2\u029e\u029f\7#\2\2\u029f\u009d"+
		"\3\2\2\2\u02a0\u02a1\7u\2\2\u02a1\u02a2\7k\2\2\u02a2\u02a3\7i\2\2\u02a3"+
		"\u02a4\7p\2\2\u02a4\u02a5\7g\2\2\u02a5\u02af\7f\2\2\u02a6\u02a7\7w\2\2"+
		"\u02a7\u02a8\7p\2\2\u02a8\u02a9\7u\2\2\u02a9\u02aa\7k\2\2\u02aa\u02ab"+
		"\7i\2\2\u02ab\u02ac\7p\2\2\u02ac\u02ad\7g\2\2\u02ad\u02af\7f\2\2\u02ae"+
		"\u02a0\3\2\2\2\u02ae\u02a6\3\2\2\2\u02af\u009f\3\2\2\2\u02b0\u02b1\7d"+
		"\2\2\u02b1\u02b2\7{\2\2\u02b2\u02b3\7v\2\2\u02b3\u02d6\7g\2\2\u02b4\u02b5"+
		"\7y\2\2\u02b5\u02b6\7q\2\2\u02b6\u02b7\7t\2\2\u02b7\u02d6\7f\2\2\u02b8"+
		"\u02b9\7f\2\2\u02b9\u02ba\7y\2\2\u02ba\u02bb\7q\2\2\u02bb\u02bc\7t\2\2"+
		"\u02bc\u02d6\7f\2\2\u02bd\u02be\7d\2\2\u02be\u02bf\7q\2\2\u02bf\u02c0"+
		"\7q\2\2\u02c0\u02d6\7n\2\2\u02c1\u02c2\7e\2\2\u02c2\u02c3\7j\2\2\u02c3"+
		"\u02c4\7c\2\2\u02c4\u02d6\7t\2\2\u02c5\u02c6\7u\2\2\u02c6\u02c7\7j\2\2"+
		"\u02c7\u02c8\7q\2\2\u02c8\u02c9\7t\2\2\u02c9\u02d6\7v\2\2\u02ca\u02cb"+
		"\7k\2\2\u02cb\u02cc\7p\2\2\u02cc\u02d6\7v\2\2\u02cd\u02ce\7n\2\2\u02ce"+
		"\u02cf\7q\2\2\u02cf\u02d0\7p\2\2\u02d0\u02d6\7i\2\2\u02d1\u02d2\7x\2\2"+
		"\u02d2\u02d3\7q\2\2\u02d3\u02d4\7k\2\2\u02d4\u02d6\7f\2\2\u02d5\u02b0"+
		"\3\2\2\2\u02d5\u02b4\3\2\2\2\u02d5\u02b8\3\2\2\2\u02d5\u02bd\3\2\2\2\u02d5"+
		"\u02c1\3\2\2\2\u02d5\u02c5\3\2\2\2\u02d5\u02ca\3\2\2\2\u02d5\u02cd\3\2"+
		"\2\2\u02d5\u02d1\3\2\2\2\u02d6\u00a1\3\2\2\2\u02d7\u02d8\7v\2\2\u02d8"+
		"\u02d9\7t\2\2\u02d9\u02da\7w\2\2\u02da\u02e1\7g\2\2\u02db\u02dc\7h\2\2"+
		"\u02dc\u02dd\7c\2\2\u02dd\u02de\7n\2\2\u02de\u02df\7u\2\2\u02df\u02e1"+
		"\7g\2\2\u02e0\u02d7\3\2\2\2\u02e0\u02db\3\2\2\2\u02e1\u00a3\3\2\2\2\u02e2"+
		"\u02e3\7}\2\2\u02e3\u02e4\7}\2\2\u02e4\u02e8\3\2\2\2\u02e5\u02e7\13\2"+
		"\2\2\u02e6\u02e5\3\2\2\2\u02e7\u02ea\3\2\2\2\u02e8\u02e9\3\2\2\2\u02e8"+
		"\u02e6\3\2\2\2\u02e9\u02eb\3\2\2\2\u02ea\u02e8\3\2\2\2\u02eb\u02ec\7\177"+
		"\2\2\u02ec\u02ed\7\177\2\2\u02ed\u00a5\3\2\2\2\u02ee\u02f4\7$\2\2\u02ef"+
		"\u02f0\7^\2\2\u02f0\u02f3\7$\2\2\u02f1\u02f3\n\2\2\2\u02f2\u02ef\3\2\2"+
		"\2\u02f2\u02f1\3\2\2\2\u02f3\u02f6\3\2\2\2\u02f4\u02f2\3\2\2\2\u02f4\u02f5"+
		"\3\2\2\2\u02f5\u02f7\3\2\2\2\u02f6\u02f4\3\2\2\2\u02f7\u02f9\7$\2\2\u02f8"+
		"\u02fa\t\3\2\2\u02f9\u02f8\3\2\2\2\u02f9\u02fa\3\2\2\2\u02fa\u02ff\3\2"+
		"\2\2\u02fb\u02fd\t\4\2\2\u02fc\u02fe\t\5\2\2\u02fd\u02fc\3\2\2\2\u02fd"+
		"\u02fe\3\2\2\2\u02fe\u0300\3\2\2\2\u02ff\u02fb\3\2\2\2\u02ff\u0300\3\2"+
		"\2\2\u0300\u0302\3\2\2\2\u0301\u0303\t\3\2\2\u0302\u0301\3\2\2\2\u0302"+
		"\u0303\3\2\2\2\u0303\u0304\3\2\2\2\u0304\u0305\bS\5\2\u0305\u00a7\3\2"+
		"\2\2\u0306\u030a\7)\2\2\u0307\u0308\7^\2\2\u0308\u030b\t\6\2\2\u0309\u030b"+
		"\n\7\2\2\u030a\u0307\3\2\2\2\u030a\u0309\3\2\2\2\u030b\u030c\3\2\2\2\u030c"+
		"\u030d\7)\2\2\u030d\u00a9\3\2\2\2\u030e\u0311\5\u00acV\2\u030f\u0311\5"+
		"\u00b4Z\2\u0310\u030e\3\2\2\2\u0310\u030f\3\2\2\2\u0311\u00ab\3\2\2\2"+
		"\u0312\u0316\5\u00aeW\2\u0313\u0316\5\u00b0X\2\u0314\u0316\5\u00b2Y\2"+
		"\u0315\u0312\3\2\2\2\u0315\u0313\3\2\2\2\u0315\u0314\3\2\2\2\u0316\u00ad"+
		"\3\2\2\2\u0317\u031d\7\'\2\2\u0318\u0319\7\62\2\2\u0319\u031d\7d\2\2\u031a"+
		"\u031b\7\62\2\2\u031b\u031d\7D\2\2\u031c\u0317\3\2\2\2\u031c\u0318\3\2"+
		"\2\2\u031c\u031a\3\2\2\2\u031d\u0321\3\2\2\2\u031e\u0320\5\u00bc^\2\u031f"+
		"\u031e\3\2\2\2\u0320\u0323\3\2\2\2\u0321\u031f\3\2\2\2\u0321\u0322\3\2"+
		"\2\2\u0322\u0324\3\2\2\2\u0323\u0321\3\2\2\2\u0324\u0326\7\60\2\2\u0325"+
		"\u0327\5\u00bc^\2\u0326\u0325\3\2\2\2\u0327\u0328\3\2\2\2\u0328\u0326"+
		"\3\2\2\2\u0328\u0329\3\2\2\2\u0329\u00af\3\2\2\2\u032a\u032c\5\u00be_"+
		"\2\u032b\u032a\3\2\2\2\u032c\u032f\3\2\2\2\u032d\u032b\3\2\2\2\u032d\u032e"+
		"\3\2\2\2\u032e\u0330\3\2\2\2\u032f\u032d\3\2\2\2\u0330\u0332\7\60\2\2"+
		"\u0331\u0333\5\u00be_\2\u0332\u0331\3\2\2\2\u0333\u0334\3\2\2\2\u0334"+
		"\u0332\3\2\2\2\u0334\u0335\3\2\2\2\u0335\u00b1\3\2\2\2\u0336\u033c\7&"+
		"\2\2\u0337\u0338\7\62\2\2\u0338\u033c\7z\2\2\u0339\u033a\7\62\2\2\u033a"+
		"\u033c\7Z\2\2\u033b\u0336\3\2\2\2\u033b\u0337\3\2\2\2\u033b\u0339\3\2"+
		"\2\2\u033c\u0340\3\2\2\2\u033d\u033f\5\u00c0`\2\u033e\u033d\3\2\2\2\u033f"+
		"\u0342\3\2\2\2\u0340\u033e\3\2\2\2\u0340\u0341\3\2\2\2\u0341\u0343\3\2"+
		"\2\2\u0342\u0340\3\2\2\2\u0343\u0345\7\60\2\2\u0344\u0346\5\u00c0`\2\u0345"+
		"\u0344\3\2\2\2\u0346\u0347\3\2\2\2\u0347\u0345\3\2\2\2\u0347\u0348\3\2"+
		"\2\2\u0348\u00b3\3\2\2\2\u0349\u034d\5\u00b8\\\2\u034a\u034d\5\u00ba]"+
		"\2\u034b\u034d\5\u00b6[\2\u034c\u0349\3\2\2\2\u034c\u034a\3\2\2\2\u034c"+
		"\u034b\3\2\2\2\u034d\u0351\3\2\2\2\u034e\u034f\t\b\2\2\u034f\u0352\t\t"+
		"\2\2\u0350\u0352\7n\2\2\u0351\u034e\3\2\2\2\u0351\u0350\3\2\2\2\u0351"+
		"\u0352\3\2\2\2\u0352\u00b5\3\2\2\2\u0353\u0354\7\62\2\2\u0354\u0356\t"+
		"\n\2\2\u0355\u0357\5\u00bc^\2\u0356\u0355\3\2\2\2\u0357\u0358\3\2\2\2"+
		"\u0358\u0356\3\2\2\2\u0358\u0359\3\2\2\2\u0359\u0361\3\2\2\2\u035a\u035c"+
		"\7\'\2\2\u035b\u035d\5\u00bc^\2\u035c\u035b\3\2\2\2\u035d\u035e\3\2\2"+
		"\2\u035e\u035c\3\2\2\2\u035e\u035f\3\2\2\2\u035f\u0361\3\2\2\2\u0360\u0353"+
		"\3\2\2\2\u0360\u035a\3\2\2\2\u0361\u00b7\3\2\2\2\u0362\u0364\5\u00be_"+
		"\2\u0363\u0362\3\2\2\2\u0364\u0365\3\2\2\2\u0365\u0363\3\2\2\2\u0365\u0366"+
		"\3\2\2\2\u0366\u00b9\3\2\2\2\u0367\u036d\7&\2\2\u0368\u0369\7\62\2\2\u0369"+
		"\u036d\7z\2\2\u036a\u036b\7\62\2\2\u036b\u036d\7Z\2\2\u036c\u0367\3\2"+
		"\2\2\u036c\u0368\3\2\2\2\u036c\u036a\3\2\2\2\u036d\u036f\3\2\2\2\u036e"+
		"\u0370\5\u00c0`\2\u036f\u036e\3\2\2\2\u0370\u0371\3\2\2\2\u0371\u036f"+
		"\3\2\2\2\u0371\u0372\3\2\2\2\u0372\u00bb\3\2\2\2\u0373\u0374\t\13\2\2"+
		"\u0374\u00bd\3\2\2\2\u0375\u0376\t\f\2\2\u0376\u00bf\3\2\2\2\u0377\u0378"+
		"\t\r\2\2\u0378\u00c1\3\2\2\2\u0379\u037d\5\u00c4b\2\u037a\u037c\5\u00c6"+
		"c\2\u037b\u037a\3\2\2\2\u037c\u037f\3\2\2\2\u037d\u037b\3\2\2\2\u037d"+
		"\u037e\3\2\2\2\u037e\u0380\3\2\2\2\u037f\u037d\3\2\2\2\u0380\u0381\ba"+
		"\6\2\u0381\u00c3\3\2\2\2\u0382\u0383\t\16\2\2\u0383\u00c5\3\2\2\2\u0384"+
		"\u0385\t\17\2\2\u0385\u00c7\3\2\2\2\u0386\u0388\t\20\2\2\u0387\u0386\3"+
		"\2\2\2\u0388\u0389\3\2\2\2\u0389\u0387\3\2\2\2\u0389\u038a\3\2\2\2\u038a"+
		"\u038b\3\2\2\2\u038b\u038c\bd\7\2\u038c\u00c9\3\2\2\2\u038d\u038e\7\61"+
		"\2\2\u038e\u038f\7\61\2\2\u038f\u0393\3\2\2\2\u0390\u0392\n\21\2\2\u0391"+
		"\u0390\3\2\2\2\u0392\u0395\3\2\2\2\u0393\u0391\3\2\2\2\u0393\u0394\3\2"+
		"\2\2\u0394\u0396\3\2\2\2\u0395\u0393\3\2\2\2\u0396\u0397\be\b\2\u0397"+
		"\u00cb\3\2\2\2\u0398\u0399\7\61\2\2\u0399\u039a\7,\2\2\u039a\u039e\3\2"+
		"\2\2\u039b\u039d\13\2\2\2\u039c\u039b\3\2\2\2\u039d\u03a0\3\2\2\2\u039e"+
		"\u039f\3\2\2\2\u039e\u039c\3\2\2\2\u039f\u03a1\3\2\2\2\u03a0\u039e\3\2"+
		"\2\2\u03a1\u03a2\7,\2\2\u03a2\u03a3\7\61\2\2\u03a3\u03a4\3\2\2\2\u03a4"+
		"\u03a5\bf\b\2\u03a5\u00cd\3\2\2\2\u03a6\u03a7\7\60\2\2\u03a7\u03a8\7d"+
		"\2\2\u03a8\u03a9\7{\2\2\u03a9\u03aa\7v\2\2\u03aa\u03ab\7g\2\2\u03ab\u00cf"+
		"\3\2\2\2\u03ac\u03ad\7d\2\2\u03ad\u03ae\7t\2\2\u03ae\u048b\7m\2\2\u03af"+
		"\u03b0\7q\2\2\u03b0\u03b1\7t\2\2\u03b1\u048b\7c\2\2\u03b2\u03b3\7m\2\2"+
		"\u03b3\u03b4\7k\2\2\u03b4\u048b\7n\2\2\u03b5\u03b6\7u\2\2\u03b6\u03b7"+
		"\7n\2\2\u03b7\u048b\7q\2\2\u03b8\u03b9\7p\2\2\u03b9\u03ba\7q\2\2\u03ba"+
		"\u048b\7r\2\2\u03bb\u03bc\7c\2\2\u03bc\u03bd\7u\2\2\u03bd\u048b\7n\2\2"+
		"\u03be\u03bf\7r\2\2\u03bf\u03c0\7j\2\2\u03c0\u048b\7r\2\2\u03c1\u03c2"+
		"\7c\2\2\u03c2\u03c3\7p\2\2\u03c3\u048b\7e\2\2\u03c4\u03c5\7d\2\2\u03c5"+
		"\u03c6\7r\2\2\u03c6\u048b\7n\2\2\u03c7\u03c8\7e\2\2\u03c8\u03c9\7n\2\2"+
		"\u03c9\u048b\7e\2\2\u03ca\u03cb\7l\2\2\u03cb\u03cc\7u\2\2\u03cc\u048b"+
		"\7t\2\2\u03cd\u03ce\7c\2\2\u03ce\u03cf\7p\2\2\u03cf\u048b\7f\2\2\u03d0"+
		"\u03d1\7t\2\2\u03d1\u03d2\7n\2\2\u03d2\u048b\7c\2\2\u03d3\u03d4\7d\2\2"+
		"\u03d4\u03d5\7k\2\2\u03d5\u048b\7v\2\2\u03d6\u03d7\7t\2\2\u03d7\u03d8"+
		"\7q\2\2\u03d8\u048b\7n\2\2\u03d9\u03da\7r\2\2\u03da\u03db\7n\2\2\u03db"+
		"\u048b\7c\2\2\u03dc\u03dd\7r\2\2\u03dd\u03de\7n\2\2\u03de\u048b\7r\2\2"+
		"\u03df\u03e0\7d\2\2\u03e0\u03e1\7o\2\2\u03e1\u048b\7k\2\2\u03e2\u03e3"+
		"\7u\2\2\u03e3\u03e4\7g\2\2\u03e4\u048b\7e\2\2\u03e5\u03e6\7t\2\2\u03e6"+
		"\u03e7\7v\2\2\u03e7\u048b\7k\2\2\u03e8\u03e9\7g\2\2\u03e9\u03ea\7q\2\2"+
		"\u03ea\u048b\7t\2\2\u03eb\u03ec\7u\2\2\u03ec\u03ed\7t\2\2\u03ed\u048b"+
		"\7g\2\2\u03ee\u03ef\7n\2\2\u03ef\u03f0\7u\2\2\u03f0\u048b\7t\2\2\u03f1"+
		"\u03f2\7r\2\2\u03f2\u03f3\7j\2\2\u03f3\u048b\7c\2\2\u03f4\u03f5\7c\2\2"+
		"\u03f5\u03f6\7n\2\2\u03f6\u048b\7t\2\2\u03f7\u03f8\7l\2\2\u03f8\u03f9"+
		"\7o\2\2\u03f9\u048b\7r\2\2\u03fa\u03fb\7d\2\2\u03fb\u03fc\7x\2\2\u03fc"+
		"\u048b\7e\2\2\u03fd\u03fe\7e\2\2\u03fe\u03ff\7n\2\2\u03ff\u048b\7k\2\2"+
		"\u0400\u0401\7t\2\2\u0401\u0402\7v\2\2\u0402\u048b\7u\2\2\u0403\u0404"+
		"\7c\2\2\u0404\u0405\7f\2\2\u0405\u048b\7e\2\2\u0406\u0407\7t\2\2\u0407"+
		"\u0408\7t\2\2\u0408\u048b\7c\2\2\u0409\u040a\7d\2\2\u040a\u040b\7x\2\2"+
		"\u040b\u048b\7u\2\2\u040c\u040d\7u\2\2\u040d\u040e\7g\2\2\u040e\u048b"+
		"\7k\2\2\u040f\u0410\7u\2\2\u0410\u0411\7c\2\2\u0411\u048b\7z\2\2\u0412"+
		"\u0413\7u\2\2\u0413\u0414\7v\2\2\u0414\u048b\7{\2\2\u0415\u0416\7u\2\2"+
		"\u0416\u0417\7v\2\2\u0417\u048b\7c\2\2\u0418\u0419\7u\2\2\u0419\u041a"+
		"\7v\2\2\u041a\u048b\7z\2\2\u041b\u041c\7f\2\2\u041c\u041d\7g\2\2\u041d"+
		"\u048b\7{\2\2\u041e\u041f\7v\2\2\u041f\u0420\7z\2\2\u0420\u048b\7c\2\2"+
		"\u0421\u0422\7z\2\2\u0422\u0423\7c\2\2\u0423\u048b\7c\2\2\u0424\u0425"+
		"\7d\2\2\u0425\u0426\7e\2\2\u0426\u048b\7e\2\2\u0427\u0428\7c\2\2\u0428"+
		"\u0429\7j\2\2\u0429\u048b\7z\2\2\u042a\u042b\7v\2\2\u042b\u042c\7{\2\2"+
		"\u042c\u048b\7c\2\2\u042d\u042e\7v\2\2\u042e\u042f\7z\2\2\u042f\u048b"+
		"\7u\2\2\u0430\u0431\7v\2\2\u0431\u0432\7c\2\2\u0432\u048b\7u\2\2\u0433"+
		"\u0434\7u\2\2\u0434\u0435\7j\2\2\u0435\u048b\7{\2\2\u0436\u0437\7u\2\2"+
		"\u0437\u0438\7j\2\2\u0438\u048b\7z\2\2\u0439\u043a\7n\2\2\u043a\u043b"+
		"\7f\2\2\u043b\u048b\7{\2\2\u043c\u043d\7n\2\2\u043d\u043e\7f\2\2\u043e"+
		"\u048b\7c\2\2\u043f\u0440\7n\2\2\u0440\u0441\7f\2\2\u0441\u048b\7z\2\2"+
		"\u0442\u0443\7n\2\2\u0443\u0444\7c\2\2\u0444\u048b\7z\2\2\u0445\u0446"+
		"\7v\2\2\u0446\u0447\7c\2\2\u0447\u048b\7{\2\2\u0448\u0449\7v\2\2\u0449"+
		"\u044a\7c\2\2\u044a\u048b\7z\2\2\u044b\u044c\7d\2\2\u044c\u044d\7e\2\2"+
		"\u044d\u048b\7u\2\2\u044e\u044f\7e\2\2\u044f\u0450\7n\2\2\u0450\u048b"+
		"\7x\2\2\u0451\u0452\7v\2\2\u0452\u0453\7u\2\2\u0453\u048b\7z\2\2\u0454"+
		"\u0455\7n\2\2\u0455\u0456\7c\2\2\u0456\u048b\7u\2\2\u0457\u0458\7e\2\2"+
		"\u0458\u0459\7r\2\2\u0459\u048b\7{\2\2\u045a\u045b\7e\2\2\u045b\u045c"+
		"\7o\2\2\u045c\u048b\7r\2\2\u045d\u045e\7e\2\2\u045e\u045f\7r\2\2\u045f"+
		"\u048b\7z\2\2\u0460\u0461\7f\2\2\u0461\u0462\7e\2\2\u0462\u048b\7r\2\2"+
		"\u0463\u0464\7f\2\2\u0464\u0465\7g\2\2\u0465\u048b\7e\2\2\u0466\u0467"+
		"\7k\2\2\u0467\u0468\7p\2\2\u0468\u048b\7e\2\2\u0469\u046a\7c\2\2\u046a"+
		"\u046b\7z\2\2\u046b\u048b\7u\2\2\u046c\u046d\7d\2\2\u046d\u046e\7p\2\2"+
		"\u046e\u048b\7g\2\2\u046f\u0470\7e\2\2\u0470\u0471\7n\2\2\u0471\u048b"+
		"\7f\2\2\u0472\u0473\7u\2\2\u0473\u0474\7d\2\2\u0474\u048b\7e\2\2\u0475"+
		"\u0476\7k\2\2\u0476\u0477\7u\2\2\u0477\u048b\7e\2\2\u0478\u0479\7k\2\2"+
		"\u0479\u047a\7p\2\2\u047a\u048b\7z\2\2\u047b\u047c\7d\2\2\u047c\u047d"+
		"\7g\2\2\u047d\u048b\7s\2\2\u047e\u047f\7u\2\2\u047f\u0480\7g\2\2\u0480"+
		"\u048b\7f\2\2\u0481\u0482\7f\2\2\u0482\u0483\7g\2\2\u0483\u048b\7z\2\2"+
		"\u0484\u0485\7k\2\2\u0485\u0486\7p\2\2\u0486\u048b\7{\2\2\u0487\u0488"+
		"\7t\2\2\u0488\u0489\7q\2\2\u0489\u048b\7t\2\2\u048a\u03ac\3\2\2\2\u048a"+
		"\u03af\3\2\2\2\u048a\u03b2\3\2\2\2\u048a\u03b5\3\2\2\2\u048a\u03b8\3\2"+
		"\2\2\u048a\u03bb\3\2\2\2\u048a\u03be\3\2\2\2\u048a\u03c1\3\2\2\2\u048a"+
		"\u03c4\3\2\2\2\u048a\u03c7\3\2\2\2\u048a\u03ca\3\2\2\2\u048a\u03cd\3\2"+
		"\2\2\u048a\u03d0\3\2\2\2\u048a\u03d3\3\2\2\2\u048a\u03d6\3\2\2\2\u048a"+
		"\u03d9\3\2\2\2\u048a\u03dc\3\2\2\2\u048a\u03df\3\2\2\2\u048a\u03e2\3\2"+
		"\2\2\u048a\u03e5\3\2\2\2\u048a\u03e8\3\2\2\2\u048a\u03eb\3\2\2\2\u048a"+
		"\u03ee\3\2\2\2\u048a\u03f1\3\2\2\2\u048a\u03f4\3\2\2\2\u048a\u03f7\3\2"+
		"\2\2\u048a\u03fa\3\2\2\2\u048a\u03fd\3\2\2\2\u048a\u0400\3\2\2\2\u048a"+
		"\u0403\3\2\2\2\u048a\u0406\3\2\2\2\u048a\u0409\3\2\2\2\u048a\u040c\3\2"+
		"\2\2\u048a\u040f\3\2\2\2\u048a\u0412\3\2\2\2\u048a\u0415\3\2\2\2\u048a"+
		"\u0418\3\2\2\2\u048a\u041b\3\2\2\2\u048a\u041e\3\2\2\2\u048a\u0421\3\2"+
		"\2\2\u048a\u0424\3\2\2\2\u048a\u0427\3\2\2\2\u048a\u042a\3\2\2\2\u048a"+
		"\u042d\3\2\2\2\u048a\u0430\3\2\2\2\u048a\u0433\3\2\2\2\u048a\u0436\3\2"+
		"\2\2\u048a\u0439\3\2\2\2\u048a\u043c\3\2\2\2\u048a\u043f\3\2\2\2\u048a"+
		"\u0442\3\2\2\2\u048a\u0445\3\2\2\2\u048a\u0448\3\2\2\2\u048a\u044b\3\2"+
		"\2\2\u048a\u044e\3\2\2\2\u048a\u0451\3\2\2\2\u048a\u0454\3\2\2\2\u048a"+
		"\u0457\3\2\2\2\u048a\u045a\3\2\2\2\u048a\u045d\3\2\2\2\u048a\u0460\3\2"+
		"\2\2\u048a\u0463\3\2\2\2\u048a\u0466\3\2\2\2\u048a\u0469\3\2\2\2\u048a"+
		"\u046c\3\2\2\2\u048a\u046f\3\2\2\2\u048a\u0472\3\2\2\2\u048a\u0475\3\2"+
		"\2\2\u048a\u0478\3\2\2\2\u048a\u047b\3\2\2\2\u048a\u047e\3\2\2\2\u048a"+
		"\u0481\3\2\2\2\u048a\u0484\3\2\2\2\u048a\u0487\3\2\2\2\u048b\u00d1\3\2"+
		"\2\2\u048c\u0490\7#\2\2\u048d\u048f\5\u0118\u008c\2\u048e\u048d\3\2\2"+
		"\2\u048f\u0492\3\2\2\2\u0490\u048e\3\2\2\2\u0490\u0491\3\2\2\2\u0491\u0494"+
		"\3\2\2\2\u0492\u0490\3\2\2\2\u0493\u0495\t\22\2\2\u0494\u0493\3\2\2\2"+
		"\u0495\u0496\3\2\2\2\u0496\u0494\3\2\2\2\u0496\u0497\3\2\2\2\u0497\u00d3"+
		"\3\2\2\2\u0498\u0499\7%\2\2\u0499\u00d5\3\2\2\2\u049a\u049b\7<\2\2\u049b"+
		"\u00d7\3\2\2\2\u049c\u049d\7#\2\2\u049d\u00d9\3\2\2\2\u049e\u049f\7.\2"+
		"\2\u049f\u00db\3\2\2\2\u04a0\u04a1\7*\2\2\u04a1\u00dd\3\2\2\2\u04a2\u04a3"+
		"\7+\2\2\u04a3\u00df\3\2\2\2\u04a4\u04a5\7]\2\2\u04a5\u00e1\3\2\2\2\u04a6"+
		"\u04a7\7_\2\2\u04a7\u00e3\3\2\2\2\u04a8\u04a9\7\60\2\2\u04a9\u00e5\3\2"+
		"\2\2\u04aa\u04ab\7>\2\2\u04ab\u04ac\7>\2\2\u04ac\u00e7\3\2\2\2\u04ad\u04ae"+
		"\7@\2\2\u04ae\u04af\7@\2\2\u04af\u00e9\3\2\2\2\u04b0\u04b1\7-\2\2\u04b1"+
		"\u00eb\3\2\2\2\u04b2\u04b3\7/\2\2\u04b3\u00ed\3\2\2\2\u04b4\u04b5\7>\2"+
		"\2\u04b5\u00ef\3\2\2\2\u04b6\u04b7\7@\2\2\u04b7\u00f1\3\2\2\2\u04b8\u04b9"+
		"\7,\2\2\u04b9\u00f3\3\2\2\2\u04ba\u04bb\7\61\2\2\u04bb\u00f5\3\2\2\2\u04bc"+
		"\u04bd\7}\2\2\u04bd\u04be\b{\t\2\u04be\u00f7\3\2\2\2\u04bf\u04c0\7\177"+
		"\2\2\u04c0\u04c1\b|\n\2\u04c1\u00f9\3\2\2\2\u04c2\u04c5\5\u00fc~\2\u04c3"+
		"\u04c5\5\u0104\u0082\2\u04c4\u04c2\3\2\2\2\u04c4\u04c3\3\2\2\2\u04c5\u00fb"+
		"\3\2\2\2\u04c6\u04ca\5\u00fe\177\2\u04c7\u04ca\5\u0100\u0080\2\u04c8\u04ca"+
		"\5\u0102\u0081\2\u04c9\u04c6\3\2\2\2\u04c9\u04c7\3\2\2\2\u04c9\u04c8\3"+
		"\2\2\2\u04ca\u00fd\3\2\2\2\u04cb\u04cf\7\'\2\2\u04cc\u04ce\5\u010c\u0086"+
		"\2\u04cd\u04cc\3\2\2\2\u04ce\u04d1\3\2\2\2\u04cf\u04cd\3\2\2\2\u04cf\u04d0"+
		"\3\2\2\2\u04d0\u04d2\3\2\2\2\u04d1\u04cf\3\2\2\2\u04d2\u04d4\7\60\2\2"+
		"\u04d3\u04d5\5\u010c\u0086\2\u04d4\u04d3\3\2\2\2\u04d5\u04d6\3\2\2\2\u04d6"+
		"\u04d4\3\2\2\2\u04d6\u04d7\3\2\2\2\u04d7\u00ff\3\2\2\2\u04d8\u04da\5\u010e"+
		"\u0087\2\u04d9\u04d8\3\2\2\2\u04da\u04dd\3\2\2\2\u04db\u04d9\3\2\2\2\u04db"+
		"\u04dc\3\2\2\2\u04dc\u04de\3\2\2\2\u04dd\u04db\3\2\2\2\u04de\u04e0\7\60"+
		"\2\2\u04df\u04e1\5\u010e\u0087\2\u04e0\u04df\3\2\2\2\u04e1\u04e2\3\2\2"+
		"\2\u04e2\u04e0\3\2\2\2\u04e2\u04e3\3\2\2\2\u04e3\u0101\3\2\2\2\u04e4\u04e8"+
		"\7&\2\2\u04e5\u04e7\5\u0110\u0088\2\u04e6\u04e5\3\2\2\2\u04e7\u04ea\3"+
		"\2\2\2\u04e8\u04e6\3\2\2\2\u04e8\u04e9\3\2\2\2\u04e9\u04eb\3\2\2\2\u04ea"+
		"\u04e8\3\2\2\2\u04eb\u04ed\7\60\2\2\u04ec\u04ee\5\u0110\u0088\2\u04ed"+
		"\u04ec\3\2\2\2\u04ee\u04ef\3\2\2\2\u04ef\u04ed\3\2\2\2\u04ef\u04f0\3\2"+
		"\2\2\u04f0\u0103\3\2\2\2\u04f1\u04f5\5\u0108\u0084\2\u04f2\u04f5\5\u010a"+
		"\u0085\2\u04f3\u04f5\5\u0106\u0083\2\u04f4\u04f1\3\2\2\2\u04f4\u04f2\3"+
		"\2\2\2\u04f4\u04f3\3\2\2\2\u04f5\u0105\3\2\2\2\u04f6\u04f8\7\'\2\2\u04f7"+
		"\u04f9\5\u010c\u0086\2\u04f8\u04f7\3\2\2\2\u04f9\u04fa\3\2\2\2\u04fa\u04f8"+
		"\3\2\2\2\u04fa\u04fb\3\2\2\2\u04fb\u0107\3\2\2\2\u04fc\u04fe\5\u010e\u0087"+
		"\2\u04fd\u04fc\3\2\2\2\u04fe\u04ff\3\2\2\2\u04ff\u04fd\3\2\2\2\u04ff\u0500"+
		"\3\2\2\2\u0500\u0109\3\2\2\2\u0501\u0503\7&\2\2\u0502\u0504\5\u0110\u0088"+
		"\2\u0503\u0502\3\2\2\2\u0504\u0505\3\2\2\2\u0505\u0503\3\2\2\2\u0505\u0506"+
		"\3\2\2\2\u0506\u010b\3\2\2\2\u0507\u0508\t\13\2\2\u0508\u010d\3\2\2\2"+
		"\u0509\u050a\t\f\2\2\u050a\u010f\3\2\2\2\u050b\u050c\t\r\2\2\u050c\u0111"+
		"\3\2\2\2\u050d\u0511\7)\2\2\u050e\u050f\7^\2\2\u050f\u0512\t\6\2\2\u0510"+
		"\u0512\n\7\2\2\u0511\u050e\3\2\2\2\u0511\u0510\3\2\2\2\u0512\u0513\3\2"+
		"\2\2\u0513\u0514\7)\2\2\u0514\u0113\3\2\2\2\u0515\u0519\5\u0116\u008b"+
		"\2\u0516\u0518\5\u0118\u008c\2\u0517\u0516\3\2\2\2\u0518\u051b\3\2\2\2"+
		"\u0519\u0517\3\2\2\2\u0519\u051a\3\2\2\2\u051a\u0115\3\2\2\2\u051b\u0519"+
		"\3\2\2\2\u051c\u051d\t\16\2\2\u051d\u0117\3\2\2\2\u051e\u051f\t\17\2\2"+
		"\u051f\u0119\3\2\2\2\u0520\u0522\t\20\2\2\u0521\u0520\3\2\2\2\u0522\u0523"+
		"\3\2\2\2\u0523\u0521\3\2\2\2\u0523\u0524\3\2\2\2\u0524\u0525\3\2\2\2\u0525"+
		"\u0526\b\u008d\7\2\u0526\u011b\3\2\2\2\u0527\u0528\7\61\2\2\u0528\u0529"+
		"\7\61\2\2\u0529\u052d\3\2\2\2\u052a\u052c\n\21\2\2\u052b\u052a\3\2\2\2"+
		"\u052c\u052f\3\2\2\2\u052d\u052b\3\2\2\2\u052d\u052e\3\2\2\2\u052e\u0530"+
		"\3\2\2\2\u052f\u052d\3\2\2\2\u0530\u0531\b\u008e\b\2\u0531\u011d\3\2\2"+
		"\2\u0532\u0533\7\61\2\2\u0533\u0534\7,\2\2\u0534\u0538\3\2\2\2\u0535\u0537"+
		"\13\2\2\2\u0536\u0535\3\2\2\2\u0537\u053a\3\2\2\2\u0538\u0539\3\2\2\2"+
		"\u0538\u0536\3\2\2\2\u0539\u053b\3\2\2\2\u053a\u0538\3\2\2\2\u053b\u053c"+
		"\7,\2\2\u053c\u053d\7\61\2\2\u053d\u053e\3\2\2\2\u053e\u053f\b\u008f\b"+
		"\2\u053f\u011f\3\2\2\2:\2\3\u0189\u02ae\u02d5\u02e0\u02e8\u02f2\u02f4"+
		"\u02f9\u02fd\u02ff\u0302\u030a\u0310\u0315\u031c\u0321\u0328\u032d\u0334"+
		"\u033b\u0340\u0347\u034c\u0351\u0358\u035e\u0360\u0365\u036c\u0371\u037d"+
		"\u0389\u0393\u039e\u048a\u0490\u0496\u04c4\u04c9\u04cf\u04d6\u04db\u04e2"+
		"\u04e8\u04ef\u04f4\u04fa\u04ff\u0505\u0511\u0519\u0523\u052d\u0538\13"+
		"\3\2\2\3&\3\3A\4\3S\5\3a\6\2\3\2\2\4\2\3{\7\3|\b";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}
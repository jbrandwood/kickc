// Generated from /Users/jespergravgaard/c64/src/kickc/src/dk/camelot64/kickc/asm/parser/Asm6502.g4 by ANTLR 4.7
package dk.camelot64.kickc.asm.parser;
import org.antlr.v4.runtime.Lexer;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.TokenStream;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.misc.*;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast"})
public class Asm6502Lexer extends Lexer {
	static { RuntimeMetaData.checkVersion("4.7", RuntimeMetaData.VERSION); }

	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		T__0=1, T__1=2, T__2=3, T__3=4, T__4=5, T__5=6, T__6=7, T__7=8, T__8=9, 
		T__9=10, MNEMONIC=11, NUMINT=12, BININTEGER=13, DECINTEGER=14, HEXINTEGER=15, 
		NAME=16, WS=17;
	public static String[] channelNames = {
		"DEFAULT_TOKEN_CHANNEL", "HIDDEN"
	};

	public static String[] modeNames = {
		"DEFAULT_MODE"
	};

	public static final String[] ruleNames = {
		"T__0", "T__1", "T__2", "T__3", "T__4", "T__5", "T__6", "T__7", "T__8", 
		"T__9", "MNEMONIC", "NUMINT", "BININTEGER", "DECINTEGER", "HEXINTEGER", 
		"BINDIGIT", "DECDIGIT", "HEXDIGIT", "NAME", "NAME_START", "NAME_CHAR", 
		"WS"
	};

	private static final String[] _LITERAL_NAMES = {
		null, "'\n'", "':'", "'//'", "'#'", "',x'", "',y'", "'('", "')'", "'{'", 
		"'}'"
	};
	private static final String[] _SYMBOLIC_NAMES = {
		null, null, null, null, null, null, null, null, null, null, null, "MNEMONIC", 
		"NUMINT", "BININTEGER", "DECINTEGER", "HEXINTEGER", "NAME", "WS"
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


	public Asm6502Lexer(CharStream input) {
		super(input);
		_interp = new LexerATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}

	@Override
	public String getGrammarFileName() { return "Asm6502.g4"; }

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
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\2\23\u008d\b\1\4\2"+
		"\t\2\4\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n\t\n\4"+
		"\13\t\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\4\20\t\20\4\21\t\21\4\22"+
		"\t\22\4\23\t\23\4\24\t\24\4\25\t\25\4\26\t\26\4\27\t\27\3\2\3\2\3\3\3"+
		"\3\3\4\3\4\3\4\3\5\3\5\3\6\3\6\3\6\3\7\3\7\3\7\3\b\3\b\3\t\3\t\3\n\3\n"+
		"\3\13\3\13\3\f\3\f\3\f\3\f\3\r\3\r\3\r\5\rN\n\r\3\16\3\16\3\16\6\16S\n"+
		"\16\r\16\16\16T\3\16\3\16\6\16Y\n\16\r\16\16\16Z\5\16]\n\16\3\17\6\17"+
		"`\n\17\r\17\16\17a\3\20\3\20\3\20\3\20\3\20\5\20i\n\20\3\20\6\20l\n\20"+
		"\r\20\16\20m\3\21\3\21\3\22\3\22\3\23\3\23\3\24\3\24\7\24x\n\24\f\24\16"+
		"\24{\13\24\3\24\7\24~\n\24\f\24\16\24\u0081\13\24\3\25\3\25\3\26\3\26"+
		"\3\27\6\27\u0088\n\27\r\27\16\27\u0089\3\27\3\27\2\2\30\3\3\5\4\7\5\t"+
		"\6\13\7\r\b\17\t\21\n\23\13\25\f\27\r\31\16\33\17\35\20\37\21!\2#\2%\2"+
		"\'\22)\2+\2-\23\3\2\13\4\2C\\c|\4\2DDdd\3\2\62\63\3\2\62;\5\2\62;CHch"+
		"\4\2--//\6\2##C\\aac|\6\2\62;C\\aac|\5\2\13\13\17\17\"\"\2\u0093\2\3\3"+
		"\2\2\2\2\5\3\2\2\2\2\7\3\2\2\2\2\t\3\2\2\2\2\13\3\2\2\2\2\r\3\2\2\2\2"+
		"\17\3\2\2\2\2\21\3\2\2\2\2\23\3\2\2\2\2\25\3\2\2\2\2\27\3\2\2\2\2\31\3"+
		"\2\2\2\2\33\3\2\2\2\2\35\3\2\2\2\2\37\3\2\2\2\2\'\3\2\2\2\2-\3\2\2\2\3"+
		"/\3\2\2\2\5\61\3\2\2\2\7\63\3\2\2\2\t\66\3\2\2\2\138\3\2\2\2\r;\3\2\2"+
		"\2\17>\3\2\2\2\21@\3\2\2\2\23B\3\2\2\2\25D\3\2\2\2\27F\3\2\2\2\31M\3\2"+
		"\2\2\33\\\3\2\2\2\35_\3\2\2\2\37h\3\2\2\2!o\3\2\2\2#q\3\2\2\2%s\3\2\2"+
		"\2\'u\3\2\2\2)\u0082\3\2\2\2+\u0084\3\2\2\2-\u0087\3\2\2\2/\60\7\f\2\2"+
		"\60\4\3\2\2\2\61\62\7<\2\2\62\6\3\2\2\2\63\64\7\61\2\2\64\65\7\61\2\2"+
		"\65\b\3\2\2\2\66\67\7%\2\2\67\n\3\2\2\289\7.\2\29:\7z\2\2:\f\3\2\2\2;"+
		"<\7.\2\2<=\7{\2\2=\16\3\2\2\2>?\7*\2\2?\20\3\2\2\2@A\7+\2\2A\22\3\2\2"+
		"\2BC\7}\2\2C\24\3\2\2\2DE\7\177\2\2E\26\3\2\2\2FG\t\2\2\2GH\t\2\2\2HI"+
		"\t\2\2\2I\30\3\2\2\2JN\5\35\17\2KN\5\37\20\2LN\5\33\16\2MJ\3\2\2\2MK\3"+
		"\2\2\2ML\3\2\2\2N\32\3\2\2\2OP\7\62\2\2PR\t\3\2\2QS\5!\21\2RQ\3\2\2\2"+
		"ST\3\2\2\2TR\3\2\2\2TU\3\2\2\2U]\3\2\2\2VX\7\'\2\2WY\5!\21\2XW\3\2\2\2"+
		"YZ\3\2\2\2ZX\3\2\2\2Z[\3\2\2\2[]\3\2\2\2\\O\3\2\2\2\\V\3\2\2\2]\34\3\2"+
		"\2\2^`\5#\22\2_^\3\2\2\2`a\3\2\2\2a_\3\2\2\2ab\3\2\2\2b\36\3\2\2\2ci\7"+
		"&\2\2de\7\62\2\2ei\7z\2\2fg\7\62\2\2gi\7Z\2\2hc\3\2\2\2hd\3\2\2\2hf\3"+
		"\2\2\2ik\3\2\2\2jl\5%\23\2kj\3\2\2\2lm\3\2\2\2mk\3\2\2\2mn\3\2\2\2n \3"+
		"\2\2\2op\t\4\2\2p\"\3\2\2\2qr\t\5\2\2r$\3\2\2\2st\t\6\2\2t&\3\2\2\2uy"+
		"\5)\25\2vx\5+\26\2wv\3\2\2\2x{\3\2\2\2yw\3\2\2\2yz\3\2\2\2z\177\3\2\2"+
		"\2{y\3\2\2\2|~\t\7\2\2}|\3\2\2\2~\u0081\3\2\2\2\177}\3\2\2\2\177\u0080"+
		"\3\2\2\2\u0080(\3\2\2\2\u0081\177\3\2\2\2\u0082\u0083\t\b\2\2\u0083*\3"+
		"\2\2\2\u0084\u0085\t\t\2\2\u0085,\3\2\2\2\u0086\u0088\t\n\2\2\u0087\u0086"+
		"\3\2\2\2\u0088\u0089\3\2\2\2\u0089\u0087\3\2\2\2\u0089\u008a\3\2\2\2\u008a"+
		"\u008b\3\2\2\2\u008b\u008c\b\27\2\2\u008c.\3\2\2\2\r\2MTZ\\ahmy\177\u0089"+
		"\3\b\2\2";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}
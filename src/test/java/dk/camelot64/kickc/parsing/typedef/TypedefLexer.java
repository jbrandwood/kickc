// Generated from /Users/jespergravgaard/c64/kickc/src/test/java/dk/camelot64/kickc/parsing/typedef/Typedef.g4 by ANTLR 4.7
package dk.camelot64.kickc.parsing.typedef;
import org.antlr.v4.runtime.Lexer;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.TokenStream;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.misc.*;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast"})
public class TypedefLexer extends Lexer {
	static { RuntimeMetaData.checkVersion("4.7", RuntimeMetaData.VERSION); }

	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		T__0=1, T__1=2, T__2=3, SIMPLETYPE=4, IDENTIFIER=5, TYPEIDENTIFIER=6, 
		WHITESPACE=7;
	public static String[] channelNames = {
		"DEFAULT_TOKEN_CHANNEL", "HIDDEN"
	};

	public static String[] modeNames = {
		"DEFAULT_MODE"
	};

	public static final String[] ruleNames = {
		"T__0", "T__1", "T__2", "SIMPLETYPE", "IDENTIFIER", "TYPEIDENTIFIER", 
		"WHITESPACE"
	};

	private static final String[] _LITERAL_NAMES = {
		null, "'('", "')'", "'&'"
	};
	private static final String[] _SYMBOLIC_NAMES = {
		null, null, null, null, "SIMPLETYPE", "IDENTIFIER", "TYPEIDENTIFIER", 
		"WHITESPACE"
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


	public TypedefLexer(CharStream input) {
		super(input);
		_interp = new LexerATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}

	@Override
	public String getGrammarFileName() { return "Typedef.g4"; }

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
	public boolean sempred(RuleContext _localctx, int ruleIndex, int predIndex) {
		switch (ruleIndex) {
		case 4:
			return IDENTIFIER_sempred((RuleContext)_localctx, predIndex);
		case 5:
			return TYPEIDENTIFIER_sempred((RuleContext)_localctx, predIndex);
		}
		return true;
	}
	private boolean IDENTIFIER_sempred(RuleContext _localctx, int predIndex) {
		switch (predIndex) {
		case 0:
			return !getText().equals("T");
		}
		return true;
	}
	private boolean TYPEIDENTIFIER_sempred(RuleContext _localctx, int predIndex) {
		switch (predIndex) {
		case 1:
			return getText().equals("T");
		}
		return true;
	}

	public static final String _serializedATN =
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\2\t\65\b\1\4\2\t\2"+
		"\4\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\3\2\3\2\3\3\3\3\3\4\3"+
		"\4\3\5\3\5\3\5\3\5\3\5\3\5\3\5\5\5\37\n\5\3\6\6\6\"\n\6\r\6\16\6#\3\6"+
		"\3\6\3\7\6\7)\n\7\r\7\16\7*\3\7\3\7\3\b\6\b\60\n\b\r\b\16\b\61\3\b\3\b"+
		"\2\2\t\3\3\5\4\7\5\t\6\13\7\r\b\17\t\3\2\4\5\2C\\aac|\5\2\13\f\17\17\""+
		"\"\28\2\3\3\2\2\2\2\5\3\2\2\2\2\7\3\2\2\2\2\t\3\2\2\2\2\13\3\2\2\2\2\r"+
		"\3\2\2\2\2\17\3\2\2\2\3\21\3\2\2\2\5\23\3\2\2\2\7\25\3\2\2\2\t\36\3\2"+
		"\2\2\13!\3\2\2\2\r(\3\2\2\2\17/\3\2\2\2\21\22\7*\2\2\22\4\3\2\2\2\23\24"+
		"\7+\2\2\24\6\3\2\2\2\25\26\7(\2\2\26\b\3\2\2\2\27\30\7e\2\2\30\31\7j\2"+
		"\2\31\32\7c\2\2\32\37\7t\2\2\33\34\7k\2\2\34\35\7p\2\2\35\37\7v\2\2\36"+
		"\27\3\2\2\2\36\33\3\2\2\2\37\n\3\2\2\2 \"\t\2\2\2! \3\2\2\2\"#\3\2\2\2"+
		"#!\3\2\2\2#$\3\2\2\2$%\3\2\2\2%&\6\6\2\2&\f\3\2\2\2\')\t\2\2\2(\'\3\2"+
		"\2\2)*\3\2\2\2*(\3\2\2\2*+\3\2\2\2+,\3\2\2\2,-\6\7\3\2-\16\3\2\2\2.\60"+
		"\t\3\2\2/.\3\2\2\2\60\61\3\2\2\2\61/\3\2\2\2\61\62\3\2\2\2\62\63\3\2\2"+
		"\2\63\64\b\b\2\2\64\20\3\2\2\2\7\2\36#*\61\3\b\2\2";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}
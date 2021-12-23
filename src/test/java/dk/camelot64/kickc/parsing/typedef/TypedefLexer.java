// Generated from /Users/jespergravgaard/c64/kickc/src/test/java/dk/camelot64/kickc/parsing/typedef/Typedef.g4 by ANTLR 4.9.2
package dk.camelot64.kickc.parsing.typedef;

    import java.util.ArrayList;
    import java.util.List;

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
	static { RuntimeMetaData.checkVersion("4.9.2", RuntimeMetaData.VERSION); }

	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		T__0=1, T__1=2, T__2=3, T__3=4, T__4=5, SIMPLETYPE=6, IDENTIFIER=7, TYPEIDENTIFIER=8, 
		WHITESPACE=9;
	public static String[] channelNames = {
		"DEFAULT_TOKEN_CHANNEL", "HIDDEN"
	};

	public static String[] modeNames = {
		"DEFAULT_MODE"
	};

	private static String[] makeRuleNames() {
		return new String[] {
			"T__0", "T__1", "T__2", "T__3", "T__4", "SIMPLETYPE", "IDENTIFIER", "TYPEIDENTIFIER", 
			"WHITESPACE"
		};
	}
	public static final String[] ruleNames = makeRuleNames();

	private static String[] makeLiteralNames() {
		return new String[] {
			null, "'typedef'", "';'", "'('", "')'", "'&'"
		};
	}
	private static final String[] _LITERAL_NAMES = makeLiteralNames();
	private static String[] makeSymbolicNames() {
		return new String[] {
			null, null, null, null, null, null, "SIMPLETYPE", "IDENTIFIER", "TYPEIDENTIFIER", 
			"WHITESPACE"
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


	    List<String> typedefs;

		public TypedefLexer(CharStream input, List<String> typedefs) {
			this(input);
			this.typedefs = typedefs;
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
		case 6:
			return IDENTIFIER_sempred((RuleContext)_localctx, predIndex);
		case 7:
			return TYPEIDENTIFIER_sempred((RuleContext)_localctx, predIndex);
		}
		return true;
	}
	private boolean IDENTIFIER_sempred(RuleContext _localctx, int predIndex) {
		switch (predIndex) {
		case 0:
			return !typedefs.contains(getText());
		}
		return true;
	}
	private boolean TYPEIDENTIFIER_sempred(RuleContext _localctx, int predIndex) {
		switch (predIndex) {
		case 1:
			return typedefs.contains(getText());
		}
		return true;
	}

	public static final String _serializedATN =
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\2\13C\b\1\4\2\t\2\4"+
		"\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n\t\n\3\2\3\2"+
		"\3\2\3\2\3\2\3\2\3\2\3\2\3\3\3\3\3\4\3\4\3\5\3\5\3\6\3\6\3\7\3\7\3\7\3"+
		"\7\3\7\3\7\3\7\5\7-\n\7\3\b\6\b\60\n\b\r\b\16\b\61\3\b\3\b\3\t\6\t\67"+
		"\n\t\r\t\16\t8\3\t\3\t\3\n\6\n>\n\n\r\n\16\n?\3\n\3\n\2\2\13\3\3\5\4\7"+
		"\5\t\6\13\7\r\b\17\t\21\n\23\13\3\2\4\5\2C\\aac|\5\2\13\f\17\17\"\"\2"+
		"F\2\3\3\2\2\2\2\5\3\2\2\2\2\7\3\2\2\2\2\t\3\2\2\2\2\13\3\2\2\2\2\r\3\2"+
		"\2\2\2\17\3\2\2\2\2\21\3\2\2\2\2\23\3\2\2\2\3\25\3\2\2\2\5\35\3\2\2\2"+
		"\7\37\3\2\2\2\t!\3\2\2\2\13#\3\2\2\2\r,\3\2\2\2\17/\3\2\2\2\21\66\3\2"+
		"\2\2\23=\3\2\2\2\25\26\7v\2\2\26\27\7{\2\2\27\30\7r\2\2\30\31\7g\2\2\31"+
		"\32\7f\2\2\32\33\7g\2\2\33\34\7h\2\2\34\4\3\2\2\2\35\36\7=\2\2\36\6\3"+
		"\2\2\2\37 \7*\2\2 \b\3\2\2\2!\"\7+\2\2\"\n\3\2\2\2#$\7(\2\2$\f\3\2\2\2"+
		"%&\7e\2\2&\'\7j\2\2\'(\7c\2\2(-\7t\2\2)*\7k\2\2*+\7p\2\2+-\7v\2\2,%\3"+
		"\2\2\2,)\3\2\2\2-\16\3\2\2\2.\60\t\2\2\2/.\3\2\2\2\60\61\3\2\2\2\61/\3"+
		"\2\2\2\61\62\3\2\2\2\62\63\3\2\2\2\63\64\6\b\2\2\64\20\3\2\2\2\65\67\t"+
		"\2\2\2\66\65\3\2\2\2\678\3\2\2\28\66\3\2\2\289\3\2\2\29:\3\2\2\2:;\6\t"+
		"\3\2;\22\3\2\2\2<>\t\3\2\2=<\3\2\2\2>?\3\2\2\2?=\3\2\2\2?@\3\2\2\2@A\3"+
		"\2\2\2AB\b\n\2\2B\24\3\2\2\2\7\2,\618?\3\b\2\2";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}
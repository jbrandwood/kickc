package dk.camelot64.kickc.preprocessor;

/**
 * Tokens used by the preprocessor
 */
public class CPreprocessorTokens {

   /** The channel containing whitespaces. */
   final int channelWhitespace;
   /** The token type for tokens containing whitespace. */
   final int whitespace;
   /** The token type for #define. */
   final int define;
   /** The token type for define multi-line. */
   final int defineMultiline;
   /** The token type for #undef. */
   final int undef;
   /** The token type for identifiers. */
   final int identifier;
   /** The token type for parenthesis begin. */
   final int parBegin;
   /** The token type for parenthesis end. */
   final int parEnd;
   /** The token type for comma. */
   final int comma;

   public CPreprocessorTokens(int channelWhitespace, int whitespace, int define, int identifier, int defineMultiline, int undef, int parBegin, int parEnd, int comma) {
      this.channelWhitespace = channelWhitespace;
      this.whitespace = whitespace;
      this.define = define;
      this.identifier = identifier;
      this.defineMultiline = defineMultiline;
      this.undef = undef;
      this.parBegin = parBegin;
      this.parEnd = parEnd;
      this.comma = comma;
   }
}

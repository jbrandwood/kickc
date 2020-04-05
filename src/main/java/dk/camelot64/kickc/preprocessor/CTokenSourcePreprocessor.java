package dk.camelot64.kickc.preprocessor;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.parser.CTokenSource;
import org.antlr.v4.runtime.*;

import java.util.*;

/**
 * C preprocessor
 * <p>
 * The preprocessor takes a token source as input and produces macro expanded tokens as output
 */
public class CTokenSourcePreprocessor implements TokenSource {

   /** The token source containing the input */
   private CTokenSource input;

   /**
    * The #defined macros.
    * Maps macro name to the tokens of the expansion
    */
   private Map<String, List<Token>> defines;

   /** The channel containing whitespace. */
   private final int channelWhitespace;
   /** The token type for tokens containing whitespace. */
   private final int tokenWhitespace;
   /** The token type for #define. */
   private final int tokenDefine;
   /** The token type for identifiers. */
   private final int tokenIdentifier;
   /** The token type for define multi-line. */
   private final int tokenDefineMultiline;
   /** The token type for parenthesis begin. */
   private final int tokenParBegin;
   /** The token type for parenthesis end. */
   private final int tokenParEnd;
   /** The token type for comma. */
   private final int tokenComma;

   public CTokenSourcePreprocessor(TokenSource input, int channelWhitespace, int tokenWhitespace, int tokenDefine, int tokenIdentifier, int tokenParBegin, int tokenParEnd, int tokenComma, int tokenDefineMultiline) {
      if(input instanceof CTokenSource) {
         // If possible use the input directly instead of wrapping it
         this.input = (CTokenSource) input;
      } else {
         this.input = new CTokenSource(input);
      }
      this.defines = new LinkedHashMap<>();
      this.channelWhitespace = channelWhitespace;
      this.tokenWhitespace = tokenWhitespace;
      this.tokenDefine = tokenDefine;
      this.tokenIdentifier = tokenIdentifier;
      this.tokenParBegin = tokenParBegin;
      this.tokenParEnd = tokenParEnd;
      this.tokenComma = tokenComma;
      this.tokenDefineMultiline = tokenDefineMultiline;
   }

   @Override
   public Token nextToken() {
      Token token = input.nextToken();
      // Perform preprocessing on tokens as long as it is needed
      while(preprocess(token, input)) {
         token = input.nextToken();
      }
      return token;
   }

   @Override
   public int getLine() {
      return input.getLine();
   }

   @Override
   public int getCharPositionInLine() {
      return input.getCharPositionInLine();
   }

   @Override
   public CharStream getInputStream() {
      return input.getInputStream();
   }

   @Override
   public String getSourceName() {
      return input.getSourceName();
   }

   @Override
   public void setTokenFactory(TokenFactory<?> factory) {
      input.setTokenFactory(factory);
   }

   @Override
   public TokenFactory<?> getTokenFactory() {
      return input.getTokenFactory();
   }

   /**
    * Perform any preprocessing needed on a token. If preprocessing is not needed nothing is done.
    *
    * This method may gobble more tokens from the source (for instance if a macro is being defined) and it may push tokens at the front of the source (if a macro is being expanded).
    *
    * @param inputToken The token to process
    * @param cTokenSource The token source used for getting more tokens or for pushing macro expansions
    * @return true if the input token was preprocessed (and should not be added to the output). False if the token was not a preprocessor token
    */
   private boolean preprocess(Token inputToken, CTokenSource cTokenSource) {
      boolean wasPreprocessed;
      if(inputToken.getType() == tokenDefine) {
         // #define a new macro - find the name
         skipWhitespace(cTokenSource);
         String macroName = nextToken(cTokenSource, tokenIdentifier).getText();
         // Examine whether the macro has parameters
         skipWhitespace(cTokenSource);
         if(cTokenSource.peekToken().getType() == tokenParBegin) {
            // Macro has parameters - find parameter name list
            throw new CompileError("Macros with parameters not supported!");
         }
         // Find body by gobbling tokens until the line ends
         final ArrayList<Token> macroBody = new ArrayList<>();
         boolean macroRead = true;
         while(macroRead) {
            final Token bodyToken = cTokenSource.nextToken();
            if(bodyToken.getType() == tokenDefineMultiline) {
               // Skip the multi-line token, add a newline token and continue reading body on the next line
               final CommonToken newlineToken = new CommonToken(bodyToken);
               newlineToken.setType(tokenWhitespace);
               newlineToken.setChannel(channelWhitespace);
               newlineToken.setText("\n");
               macroBody.add(newlineToken);
               continue;
            }
            if(bodyToken.getChannel() == channelWhitespace && bodyToken.getText().contains("\n")) {
               macroRead = false;
            } else {
               macroBody.add(bodyToken);
            }
         }
         defines.put(macroName, macroBody);
         return true;
      } else {
         if(inputToken.getType() == tokenIdentifier) {
            final String macroName = inputToken.getText();
            List<Token> macroBody = defines.get(macroName);
            if(macroBody != null) {
               // Check for macro recursion
               if(inputToken instanceof ExpansionToken) {
                  if(((ExpansionToken) inputToken).getMacroNames().contains(macroName)) {
                     // Detected macro recursion in the expansion - add directly to output and do not perform expansion!
                     macroBody = null;
                  }
               }
            }
            if(macroBody != null) {
               // Macro expansion is needed
               List<Token> expandedBody = new ArrayList<>();
               for(Token bodyToken : macroBody) {
                  final CommonToken expandedToken = new CommonToken(inputToken);
                  expandedToken.setText(bodyToken.getText());
                  expandedToken.setType(bodyToken.getType());
                  expandedToken.setChannel(bodyToken.getChannel());
                  Set<String> macroNames = new HashSet<>();
                  if(inputToken instanceof ExpansionToken) {
                     // Transfer macro names to the new expansion
                     macroNames = ((ExpansionToken) inputToken).getMacroNames();
                  }
                  macroNames.add(macroName);
                  expandedBody.add(new ExpansionToken(expandedToken, macroNames));
               }
               cTokenSource.addSource(new ListTokenSource(expandedBody));
               return true;
            }
         }
      }
      return false;
   }


   /**
    * Pull first token from a source and check that it matches the expected type. Any other type will produce an error.
    *
    * @param cTokenSource The token source
    * @param tokenType The type to expect
    * @return The token
    */
   private Token nextToken(CTokenSource cTokenSource, int tokenType) {
      final Token token = cTokenSource.nextToken();
      if(token.getType() != tokenType)
         throw new CompileError("Unexpected token. Was expecting " + tokenType);
      return token;
   }

   /**
    * Skip whitespace tokens, positioning iterator at the next non-whitespace
    *
    * @param cTokenSource The token iterator
    */
   private void skipWhitespace(CTokenSource cTokenSource) {
      while(cTokenSource.peekToken().getChannel() == channelWhitespace)
         cTokenSource.nextToken();
   }

   /**
    * A token that is the result of macro expansion.
    * Keeps track of which macros was used for the expansion to avoid macro recursion.
    **/
   public static class ExpansionToken implements Token {

      /** The underlying token. */
      private Token subToken;

      /** The names of all macros used for expanding this token. */
      private Set<String> macroNames;

      ExpansionToken(Token subToken, Set<String> macroNames) {
         this.subToken = subToken;
         this.macroNames = macroNames;
      }

      Set<String> getMacroNames() {
         return macroNames;
      }

      @Override
      public String getText() {
         return subToken.getText();
      }

      @Override
      public int getType() {
         return subToken.getType();
      }

      @Override
      public int getLine() {
         return subToken.getLine();
      }

      @Override
      public int getCharPositionInLine() {
         return subToken.getCharPositionInLine();
      }

      @Override
      public int getChannel() {
         return subToken.getChannel();
      }

      @Override
      public int getTokenIndex() {
         return subToken.getTokenIndex();
      }

      @Override
      public int getStartIndex() {
         return subToken.getStartIndex();
      }

      @Override
      public int getStopIndex() {
         return subToken.getStopIndex();
      }

      @Override
      public TokenSource getTokenSource() {
         return subToken.getTokenSource();
      }

      @Override
      public CharStream getInputStream() {
         return subToken.getInputStream();
      }
   }


}

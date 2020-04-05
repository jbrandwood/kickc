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
public class CPreprocessor implements TokenSource {

   /** The token source containing the input */
   private CTokenSource input;

   /**
    * The #defined macros.
    * Maps macro name to the tokens of the expansion
    */
   private Map<String, List<Token>> defines;

   /** The token types. */
   private CPreprocessorTokens tokenTypes;

   public CPreprocessor(TokenSource input, CPreprocessorTokens tokenTypes) {
      if(input instanceof CTokenSource) {
         // If possible use the input directly instead of wrapping it
         this.input = (CTokenSource) input;
      } else {
         this.input = new CTokenSource(input);
      }
      this.defines = new LinkedHashMap<>();
      this.tokenTypes = tokenTypes;
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
    * <p>
    * This method may gobble more tokens from the source (for instance if a macro is being defined) and it may push tokens at the front of the source (if a macro is being expanded).
    *
    * @param inputToken The token to process
    * @param cTokenSource The token source used for getting more tokens or for pushing macro expansions
    * @return true if the input token was preprocessed (and should not be added to the output). False if the token was not a preprocessor token
    */
   private boolean preprocess(Token inputToken, CTokenSource cTokenSource) {
      if(inputToken.getType() == tokenTypes.define) {
         define(cTokenSource);
         return true;
      } else if(inputToken.getType() == tokenTypes.undef) {
         undef(cTokenSource);
         return true;
      } else if(inputToken.getType() == tokenTypes.ifndef) {
         ifndef(cTokenSource);
         return true;
      } else if(inputToken.getType() == tokenTypes.ifdef) {
         ifdef(cTokenSource);
         return true;
      } else if(inputToken.getType() == tokenTypes.ifelse) {
         // #else means we must skip until #endif
         ifelse(cTokenSource);
         return true;
      } else if(inputToken.getType() == tokenTypes.endif) {
         // Skip #endif - they have already been handled by #if / #else
         return true;
      } else if(inputToken.getType() == tokenTypes.identifier) {
         final boolean expanded = expandMacro(inputToken, cTokenSource);
         if(expanded) return true;
      }
      return false;
   }

   /**
    * Encountered an IDENTIFIER. Attempt to expand as a macro.
    *
    * @param inputToken The IDENTIFIER token
    * @param cTokenSource The token source usable for getting more tokens (eg. parameter values) - and for pushing the expanded body to the front for further processing.
    * @return true if a macro was expanded. False if not.
    */
   private boolean expandMacro(Token inputToken, CTokenSource cTokenSource) {
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
      return false;
   }

   /**
    * Undefine a macro.
    *
    * @param cTokenSource The token source used to get the name
    */
   private void undef(CTokenSource cTokenSource) {
      // #undef a new macro - find the name
      skipWhitespace(cTokenSource);
      String macroName = nextToken(cTokenSource, tokenTypes.identifier).getText();
      this.defines.remove(macroName);
   }

   /**
    * #ifdef checks if a macro is defined.
    *
    * @param cTokenSource The token source used to get the macro name
    */
   private void ifdef(CTokenSource cTokenSource) {
      skipWhitespace(cTokenSource);
      String macroName = nextToken(cTokenSource, tokenTypes.identifier).getText();
      final boolean defined = this.defines.containsKey(macroName);
      if(!defined) {
         iffalse(cTokenSource);
      }
   }

   /**
    * #ifdef checks if a macro is _NOT_ defined.
    *
    * @param cTokenSource The token source used to get the macro name
    */
   private void ifndef(CTokenSource cTokenSource) {
      skipWhitespace(cTokenSource);
      String macroName = nextToken(cTokenSource, tokenTypes.identifier).getText();
      final boolean defined = this.defines.containsKey(macroName);
      if(defined) {
         iffalse(cTokenSource);
      }
   }


   /**
    * Skip tokens based in an #if that is false
    * @param cTokenSource The token source
    */
   private void iffalse(CTokenSource cTokenSource) {
      // Skip tokens until finding a matching #endif - respect nesting
      int nesting = 1;
      while(true) {
         final Token token = cTokenSource.nextToken();
         final int tokenType = token.getType();
         if(tokenType == tokenTypes.ifdef || tokenType == tokenTypes.ifndef) {
            ++nesting;
         } else if(tokenType == tokenTypes.ifelse) {
            if(nesting == 1) {
               // We are at the outer #if - #else means we must generate output from here!
               return;
            }
         } else if(tokenType == tokenTypes.endif) {
            if(--nesting == 0) {
               // We have passed the matching #endif - restart the output!
               return;
            }
         }
      }
   }

   /**
    * #else skips until a matching #endif
    *
    * @param cTokenSource The token source
    */
   private void ifelse(CTokenSource cTokenSource) {
      int nesting = 1;
      while(true) {
         final Token token = cTokenSource.nextToken();
         final int tokenType = token.getType();
         if(tokenType == tokenTypes.ifdef || tokenType == tokenTypes.ifndef) {
            ++nesting;
         } else if(tokenType == tokenTypes.endif) {
            if(--nesting == 0) {
               // We have passed the matching #endif
               return;
            }
         }
      }
   }

   /**
    * Define a macro.
    *
    * @param cTokenSource The token source used to get the macro name and body.
    */
   private void define(CTokenSource cTokenSource) {
      // #define a new macro - find the name
      skipWhitespace(cTokenSource);
      String macroName = nextToken(cTokenSource, tokenTypes.identifier).getText();
      // Examine whether the macro has parameters
      skipWhitespace(cTokenSource);
      if(cTokenSource.peekToken().getType() == tokenTypes.parBegin) {
         // Macro has parameters - find parameter name list
         throw new CompileError("Macros with parameters not supported!");
      }
      // Find body by gobbling tokens until the line ends
      final ArrayList<Token> macroBody = new ArrayList<>();
      while(true) {
         final Token bodyToken = cTokenSource.nextToken();
         if(bodyToken.getType() == tokenTypes.defineMultiline) {
            // Skip the multi-line token, add a newline token and continue reading body on the next line
            final CommonToken newlineToken = new CommonToken(bodyToken);
            newlineToken.setType(tokenTypes.whitespace);
            newlineToken.setChannel(tokenTypes.channelWhitespace);
            newlineToken.setText("\n");
            macroBody.add(newlineToken);
            continue;
         }
         if(bodyToken.getChannel() == tokenTypes.channelWhitespace && bodyToken.getText().contains("\n")) {
            // Done reading the body
            break;
         } else {
            macroBody.add(bodyToken);
         }
      }
      defines.put(macroName, macroBody);
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
    * Skip whitespace tokens (except newlines), positioning iterator at the next non-whitespace
    *
    * @param cTokenSource The token iterator
    */
   private void skipWhitespace(CTokenSource cTokenSource) {
      while(true) {
         final Token token = cTokenSource.peekToken();
         if(token.getChannel() != tokenTypes.channelWhitespace)
            break;
         if(token.getText().contains("\n"))
            break;
         cTokenSource.nextToken();
      }
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

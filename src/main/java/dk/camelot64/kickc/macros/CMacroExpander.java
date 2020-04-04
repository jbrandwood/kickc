package dk.camelot64.kickc.macros;

import dk.camelot64.kickc.model.CompileError;
import org.antlr.v4.runtime.*;

import java.util.*;

/**
 * C Macro expander.
 * <p>
 * The macro expander takes one token source as input and produces a new expanded token source as output
 */
public class CMacroExpander {

   /** The channel containing whitespace. */
   private final int channelWhitespace;
   /** The token type for tokens containing whitespace. */
   private final int tokenWhitespace;
   /** The token type for #define. */
   private final int tokenDefine;
   /** The token type for identifiers. */
   private final int tokenIdentifier;
   /** The token type for parenthesis begin. */
   private final int tokenParBegin;
   /** The token type for parenthesis end. */
   private final int tokenParEnd;
   /** The token type for comma. */
   private final int tokenComma;
   /** The token type for define multi-line. */
   private final int tokenDefineMultiline;

   public CMacroExpander(int channelWhitespace, int tokenWhitespace, int tokenDefine, int tokenIdentifier, int tokenParBegin, int tokenParEnd, int tokenComma, int tokenDefineMultiline) {
      this.channelWhitespace = channelWhitespace;
      this.tokenWhitespace = tokenWhitespace;
      this.tokenDefine = tokenDefine;
      this.tokenIdentifier = tokenIdentifier;
      this.tokenParBegin = tokenParBegin;
      this.tokenParEnd = tokenParEnd;
      this.tokenComma = tokenComma;
      this.tokenDefineMultiline = tokenDefineMultiline;
   }

   public TokenSource expandMacros(TokenSource inputTokenSource) {
      List<Token> inputTokens = getTokenList(inputTokenSource);
      final TokenIterator tokenIterator = new TokenIterator(inputTokens);
      Map<String, List<Token>> macros = new LinkedHashMap<>();
      final ArrayList<Token> expandedTokens = new ArrayList<>();
      while(tokenIterator.hasNext()) {
         Token inputToken = tokenIterator.next();
         if(inputToken.getType() == tokenDefine) {
            // #define a new macro - find the name
            skipWhitespace(tokenIterator);
            String macroName = getToken(tokenIterator, tokenIdentifier).getText();
            // Examine whether the macro has parameters
            skipWhitespace(tokenIterator);
            if(tokenIterator.peek().getType() == tokenParBegin) {
               // Macro has parameters - find parameter name list
               throw new CompileError("Macros with parameters not supported!");
            }
            // Find body by gobbling tokens until the line ends
            final ArrayList<Token> macroBody = new ArrayList<>();
            boolean macroRead = true;
            while(macroRead) {
               final Token bodyToken = tokenIterator.next();
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
            macros.put(macroName, macroBody);
         } else {
            if(inputToken.getType() == tokenIdentifier) {
               final String macroName = inputToken.getText();
               if(macros.containsKey(macroName)) {
                  // Check for macro recursion
                  if(inputToken instanceof ExpansionToken) {
                     if(((ExpansionToken) inputToken).getMacroNames().contains(macroName)) {
                        // Detected macro recursion in the expansion - add directly to output and move on!
                        expandedTokens.add(inputToken);
                        continue;
                     }
                  }
                  // Macro expansion is needed
                  final List<Token> macroBody = macros.get(macroName);
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
                  tokenIterator.addFirst(expandedBody);
               } else {
                  expandedTokens.add(inputToken);
               }
            } else {
               expandedTokens.add(inputToken);
            }
         }
      }
      return new ListTokenSource(expandedTokens);
   }


   private Token getToken(TokenIterator tokenIterator, int tokenType) {
      if(!tokenIterator.hasNext())
         throw new CompileError("File ended unexpectedly. Was expecting token " + tokenType);
      final Token token = tokenIterator.next();
      if(token.getType() != tokenType)
         throw new CompileError("Unexpected token. Was expecting " + tokenType);
      return token;
   }

   /**
    * Skip whitespace tokens, positioning iterator at the next non-whitespace
    *
    * @param tokenIterator The token iterator
    */
   private void skipWhitespace(TokenIterator tokenIterator) {
      while(tokenIterator.hasNext() && tokenIterator.peek().getChannel() == channelWhitespace)
         tokenIterator.next();
   }

   private List<Token> getTokenList(TokenSource inputTokenSource) {
      List<Token> inputTokens = new ArrayList<>();
      Token inputToken;
      do {
         inputToken = inputTokenSource.nextToken();
         inputTokens.add(inputToken);
      } while(inputToken.getType() != Token.EOF);

      return inputTokens;
   }

   /** A token iterator supporting peeking backed by a list of lists of tokens.
    * Macro expansion works by prepending a new list of tokens which contains the body of the macro being expanded */
   static class TokenIterator implements Iterator<Token> {

      Deque<Token> tokens;

      public TokenIterator(Collection<Token> tokens) {
         this.tokens = new LinkedList<>(tokens);
      }

      /**
       * Get the next token without advancing the cursor.
       *
       * @return The next token. null if there are no more tokens.
       */
      public Token peek() {
         return tokens.getFirst();
      }

      @Override
      public boolean hasNext() {
         return !tokens.isEmpty();
      }

      @Override
      public Token next() {
         return tokens.removeFirst();
      }

      /**
       * Add a bunch of tokens to the start of the iterator.
       * This is called when a macro is expanded to add the macro body to the start of the input.
       * @param tokens The tokens to add
       */
      public void addFirst(List<Token> tokens) {
         Collections.reverse(tokens);
         for(Token token : tokens) {
            this.tokens.addFirst(token);
         }
      }

   }


   /** A token that is the result of macro expansion.
    * Keeps track of which macros was used for the expansion.
    * */
   public class ExpansionToken implements Token {

      /** The underlying token. */
      private Token subToken;

      /** The names of all macros used for expanding this token. */
      private Set<String> macroNames;

      public ExpansionToken(Token subToken, Set<String> macroNames) {
         this.subToken = subToken;
         this.macroNames = macroNames;
      }

      public Set<String> getMacroNames() {
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

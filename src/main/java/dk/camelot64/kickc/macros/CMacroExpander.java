package dk.camelot64.kickc.macros;

import org.antlr.v4.runtime.CommonToken;
import org.antlr.v4.runtime.ListTokenSource;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.TokenSource;

import java.util.*;

/**
 * C Macro expander.
 *
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

   public CMacroExpander(int channelWhitespace, int tokenWhitespace, int tokenDefine, int tokenIdentifier) {
      this.channelWhitespace = channelWhitespace;
      this.tokenWhitespace = tokenWhitespace;
      this.tokenDefine = tokenDefine;
      this.tokenIdentifier = tokenIdentifier;
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
            Token macroName = tokenIterator.next();
            while(macroName.getType() == tokenWhitespace)
               macroName = tokenIterator.next();
            // Find body by gobbling tokens until the line ends
            final ArrayList<Token> macroBody = new ArrayList<>();
            boolean macroRead = true;
            while(macroRead) {
               final Token bodyToken = tokenIterator.next();
               if(bodyToken.getChannel() == channelWhitespace && bodyToken.getText().contains("\n")) {
                  macroRead = false;
               } else {
                  macroBody.add(bodyToken);
               }
            }
            macros.put(macroName.getText(), macroBody);
         } else {
            if(inputToken.getType() == tokenIdentifier && macros.containsKey(inputToken.getText())) {
               // Macro expansion is needed
               final List<Token> macroBody = macros.get(inputToken.getText());
               for(Token bodyToken : macroBody) {
                  final CommonToken expandedToken = new CommonToken(inputToken);
                  expandedToken.setText(bodyToken.getText());
                  expandedToken.setType(bodyToken.getType());
                  expandedToken.setChannel(bodyToken.getChannel());
                  expandedTokens.add(expandedToken);
               }
            } else {
               expandedTokens.add(inputToken);
            }
         }
      }
      return new ListTokenSource(expandedTokens);
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

   interface PeekingIterator<T> extends Iterator<T> {

      /**
       * Return the next element without progressing the cursot
       * @return The current element. Null if after the end
       */
      T peek();

   }

   /** A token iterator. */
   static class TokenIterator implements PeekingIterator<Token> {

      ArrayList<Token> tokens;
      int idx = 0;

      public TokenIterator(Collection<Token> tokens) {
         this.tokens = new ArrayList<>(tokens);
      }

      @Override
      public Token peek() {
         return tokens.get(idx);
      }

      @Override
      public boolean hasNext() {
         return idx<tokens.size();
      }

      @Override
      public Token next() {
         final Token token = tokens.get(idx);
         idx++;
         return token;
      }
   }


}

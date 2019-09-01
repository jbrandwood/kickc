package dk.camelot64.kickc.parser;

import org.antlr.v4.runtime.*;

import java.util.Stack;

/**
 * An ANTLR4 Token Source that can keep track of multiple underlying source files.
 */
public class CTokenSourceStack implements TokenSource {

   /** Stack of underlying sources */
   private Stack<TokenSource> sourceStack;

   public CTokenSourceStack() {
      this.sourceStack = new Stack<>();
   }

   /**
    * Pushes a token source at the current location.
    * The pushed source will immediately be used for tokens and only when it is exhausted will tokens resume from the current source
    * @param source The source to push
    */
   public void pushSource(TokenSource source) {
      sourceStack.push(source);
   }

   public TokenSource getCurrentSource() {
      if(sourceStack.size()>0)
         return sourceStack.peek();
      else
         return new TokenSource() {
            @Override
            public Token nextToken() {
               return null;
            }

            @Override
            public int getLine() {
               return 0;
            }

            @Override
            public int getCharPositionInLine() {
               return 0;
            }

            @Override
            public CharStream getInputStream() {
               return null;
            }

            @Override
            public String getSourceName() {
               return "";
            }

            @Override
            public void setTokenFactory(TokenFactory<?> factory) {
            }

            @Override
            public TokenFactory<?> getTokenFactory() {
               return null;
            }
         };
   }

   @Override
   public Token nextToken() {
      TokenSource currentSource = getCurrentSource();
      Token token = currentSource.nextToken();
      if(token.getType()==Token.EOF) {
         // Last token of the current source - pop the stack!
         sourceStack.pop();
         if(!sourceStack.isEmpty()) {
            // Recurse to find next token
            return nextToken();
         }
      }
      return token;
   }

   @Override
   public int getLine() {
      return getCurrentSource().getLine();
   }

   @Override
   public int getCharPositionInLine() {
      return getCurrentSource().getCharPositionInLine();
   }

   @Override
   public CharStream getInputStream() {
      return getCurrentSource().getInputStream();
   }

   @Override
   public String getSourceName() {
      return getCurrentSource().getSourceName();
   }

   @Override
   public void setTokenFactory(TokenFactory<?> factory) {
      throw new RuntimeException("Not implemented!!");
   }

   @Override
   public TokenFactory<?> getTokenFactory() {
      return getCurrentSource().getTokenFactory();
   }
}

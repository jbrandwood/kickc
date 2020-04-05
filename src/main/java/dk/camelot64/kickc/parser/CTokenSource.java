package dk.camelot64.kickc.parser;

import org.antlr.v4.runtime.*;

import java.util.ArrayList;
import java.util.Deque;
import java.util.LinkedList;

/**
 * An ANTLR4 Token Source that supports pushing sub-sources at the front of the stream.
 * This can be used for importing files or for macro expansion.
 */
public class CTokenSource implements TokenSource {

   /** Stack of underlying sources */
   private Deque<TokenSource> subSources;

   public CTokenSource() {
      this.subSources = new LinkedList<>();
   }

   public CTokenSource(TokenSource tokenSource) {
      this.subSources = new LinkedList<>();
      addSource(tokenSource);
   }

   /**
    * Pushes a token source at the current location ).
    * The pushed source will immediately be used for tokens and only when it is exhausted will tokens resume from the current source
    *
    * @param source The source to push
    */
   public void addSource(TokenSource source) {
      subSources.addFirst(source);
   }

   public TokenSource getCurrentSource() {
      return subSources.peekFirst();
   }

   /**
    * Peek the next token without removing it from the source.
    *
    * @return The next token of the source.
    */
   public Token peekToken() {
      // Get the next token
      final Token token = nextToken();
      // And push it back to the front of the stack
      final ArrayList<Token> tokens = new ArrayList<>();
      tokens.add(token);
      addSource(new ListTokenSource(tokens));
      return token;
   }

   @Override
   public Token nextToken() {
      TokenSource currentSource = getCurrentSource();
      Token token = currentSource.nextToken();
      if(token.getType() == Token.EOF && subSources.size() > 1) {
         // We are at the end of the current sub-source and have more sub-sources to go through - move on to the next one!
         subSources.pop();
         return nextToken();
      } else {
         return token;
      }
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

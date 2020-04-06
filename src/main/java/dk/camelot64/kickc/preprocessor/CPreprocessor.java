package dk.camelot64.kickc.preprocessor;

import dk.camelot64.kickc.NumberParser;
import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.operators.OperatorBinary;
import dk.camelot64.kickc.model.operators.OperatorUnary;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.StatementSource;
import dk.camelot64.kickc.model.values.ConstantBool;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;
import dk.camelot64.kickc.parser.*;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.TerminalNode;

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

   public CPreprocessor(TokenSource input, Map<String, List<Token>> defines) {
      if(input instanceof CTokenSource) {
         // If possible use the input directly instead of wrapping it
         this.input = (CTokenSource) input;
      } else {
         this.input = new CTokenSource(input);
      }
      this.defines = defines;
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
      if(inputToken.getType() == KickCLexer.DEFINE) {
         define(cTokenSource);
         return true;
      } else if(inputToken.getType() == KickCLexer.UNDEF) {
         undef(cTokenSource);
         return true;
      } else if(inputToken.getType() == KickCLexer.IFNDEF) {
         ifndef(cTokenSource);
         return true;
      } else if(inputToken.getType() == KickCLexer.IFDEF) {
         ifdef(cTokenSource);
         return true;
      } else if(inputToken.getType() == KickCLexer.IFIF) {
         ifif(cTokenSource);
         return true;
      } else if(inputToken.getType() == KickCLexer.IFELSE) {
         // #else means we must skip until #endif
         ifelse(cTokenSource);
         return true;
      } else if(inputToken.getType() == KickCLexer.ENDIF) {
         // Skip #endif - they have already been handled by #if / #else
         return true;
      } else if(inputToken.getType() == KickCLexer.NAME) {
         return expand(inputToken, cTokenSource);
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
   private boolean expand(Token inputToken, CTokenSource cTokenSource) {
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
      String macroName = nextToken(cTokenSource, KickCLexer.NAME).getText();
      this.defines.remove(macroName);
   }

   /**
    * #ifdef checks if a macro is defined.
    *
    * @param cTokenSource The token source used to get the macro name
    */
   private void ifdef(CTokenSource cTokenSource) {
      skipWhitespace(cTokenSource);
      String macroName = nextToken(cTokenSource, KickCLexer.NAME).getText();
      final boolean defined = this.defines.containsKey(macroName);
      if(!defined) {
         iffalse(cTokenSource);
      }
   }

   /**
    * #if checks if a constant condition expression is non-zero
    *
    * @param cTokenSource The token source used to get the condition
    */
   private void ifif(CTokenSource cTokenSource) {
      // Read the condition body
      ArrayList<Token> conditionTokens = readBody(cTokenSource);
      // Evaluate any uses of the defined operator (to prevent expansion of the named macro)
      evaluateDefinedOperator(conditionTokens);
      // Expand the condition body before evaluating it
      CPreprocessor subPreprocessor = new CPreprocessor(new ListTokenSource(conditionTokens), new HashMap<>(defines));
      // Parse the expression
      KickCParser.ExprContext conditionExpr = ExprParser.parseExpression(subPreprocessor);
      // Evaluate the expression
      Long conditionValue = evaluateExpression(conditionExpr);
      if(conditionValue == null || conditionValue == 0L) {
         iffalse(cTokenSource);
      }
   }

   /**
    * Evaluate a constant condition expression from #if. The special defined operator must be evaluated before calling this.
    *
    * @param conditionExpr The expression
    * @return The result of the evaluation.
    */
   private Long evaluateExpression(KickCParser.ExprContext conditionExpr) {
      KickCParserBaseVisitor<Long> conditionEvaluator = new KickCParserBaseVisitor<Long>() {
         @Override
         public Long visitExprNumber(KickCParser.ExprNumberContext ctx) {
            try {
               ConstantInteger constantInteger = NumberParser.parseIntegerLiteral(ctx.getText());
               return constantInteger.getInteger();
            } catch(NumberFormatException e) {
               throw new CompileError(e.getMessage(), new StatementSource(ctx));
            }
         }

         @Override
         public Long visitExprId(KickCParser.ExprIdContext ctx) {
            return 0L;
         }

         @Override
         public Long visitExprBinary(KickCParser.ExprBinaryContext ctx) {
            Long left = this.visit(ctx.expr(0));
            Long right = this.visit(ctx.expr(1));
            String op = ((TerminalNode) ctx.getChild(1)).getSymbol().getText();
            OperatorBinary operator = (OperatorBinary) Operators.getBinary(op);
            ConstantLiteral result = operator.calculateLiteral(new ConstantInteger(left), new ConstantInteger(right));
            if(result instanceof ConstantInteger) {
               return ((ConstantInteger) result).getInteger();
            } else if(result instanceof ConstantBool) {
               return ((ConstantBool) result).getBool()?1L:0L;
            } else
               return 0L;
         }

         @Override
         public Long visitExprUnary(KickCParser.ExprUnaryContext ctx) {
            Long left = this.visit(ctx.expr());
            String op = ((TerminalNode) ctx.getChild(0)).getSymbol().getText();
            OperatorUnary operator = (OperatorUnary) Operators.getUnary(op);
            ConstantLiteral result = operator.calculateLiteral(new ConstantInteger(left), null);
            if(result instanceof ConstantInteger) {
               return ((ConstantInteger) result).getInteger();
            } else if(result instanceof ConstantBool) {
               return ((ConstantBool) result).getBool()?1L:0L;
            } else
               return 0L;
         }

         @Override
         public Long visitExprPar(KickCParser.ExprParContext ctx) {
            return this.visit(ctx.commaExpr());
         }

      };
      return conditionEvaluator.visit(conditionExpr);
   }

   /**
    * Find and evaluate the special defined X operator which evaluates to 1 if a named macro if defined and 0 if it is undefined.
    * Works by replacing the defined X tokens with the resulting 0/1 value in the passed token list.
    * @param conditionTokens The token list
    */
   private void evaluateDefinedOperator(ArrayList<Token> conditionTokens) {
      // First evaluate the special defined operators
      ListIterator<Token> tokenIt = conditionTokens.listIterator();
      while(tokenIt.hasNext()) {
         Token token = tokenIt.next();
         if(token.getType()== KickCLexer.DEFINED) {
            // Remove the token
            tokenIt.remove();
            // Read the macro name to examine - and skip any parenthesis
            token = getNextSkipWhitespace(tokenIt);
            boolean hasPar = false;
            if(token.getType()==KickCLexer.PAR_BEGIN) {
               tokenIt.remove();
               token = getNextSkipWhitespace(tokenIt);
               hasPar = true;
            }
            if(token.getType()!=KickCLexer.NAME) {
               throw new CompileError("Unexpected token. Was expecting NAME!");
            }
            tokenIt.remove();
            Token macroNameToken = token;
            String macroName = macroNameToken.getText();
            if(hasPar) {
               // Skip closing parenthesis
               token = getNextSkipWhitespace(tokenIt);
               if(token.getType()!=KickCLexer.PAR_END) {
                  throw new CompileError("Unexpected token. Was expecting ')'!");
               }
               tokenIt.remove();
            }
            final boolean defined = defines.containsKey(macroName);
            CommonToken definedToken = new CommonToken(macroNameToken);
            definedToken.setType(KickCLexer.NUMBER);
            definedToken.setText(defined?"1":"0");
            tokenIt.add(definedToken);
         }
      }
   }

   /**
    * Get the next token from an iterator skipping whitespace (unless it has a newline)
    * @param tokenIt The iterator
    * @return The next non-whitespace token
    */
   private Token getNextSkipWhitespace(ListIterator<Token> tokenIt) {
      Token token = tokenIt.next();
      while(token.getChannel()==CParser.CHANNEL_WHITESPACE && !token.getText().contains("\n"))
         token = tokenIt.next();
      return token;
   }

   /**
    * #ifdef checks if a macro is _NOT_ defined.
    *
    * @param cTokenSource The token source used to get the macro name
    */
   private void ifndef(CTokenSource cTokenSource) {
      skipWhitespace(cTokenSource);
      String macroName = nextToken(cTokenSource, KickCLexer.NAME).getText();
      final boolean defined = this.defines.containsKey(macroName);
      if(defined) {
         iffalse(cTokenSource);
      }
   }

   /**
    * Skip tokens based in an #if that is false
    *
    * @param cTokenSource The token source
    */
   private void iffalse(CTokenSource cTokenSource) {
      // Skip tokens until finding a matching #endif - respect nesting
      int nesting = 1;
      while(true) {
         final Token token = cTokenSource.nextToken();
         final int tokenType = token.getType();
         if(tokenType == KickCLexer.IFDEF || tokenType == KickCLexer.IFNDEF || tokenType == KickCLexer.IFIF) {
            ++nesting;
         } else if(tokenType == KickCLexer.IFELSE) {
            if(nesting == 1) {
               // We are at the outer #if - #else means we must generate output from here!
               return;
            }
         } else if(tokenType == KickCLexer.ENDIF) {
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
         if(tokenType == KickCLexer.IFDEF || tokenType == KickCLexer.IFNDEF || tokenType == KickCLexer.IFIF) {
            ++nesting;
         } else if(tokenType == KickCLexer.ENDIF) {
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
      String macroName = nextToken(cTokenSource, KickCLexer.NAME).getText();
      // Examine whether the macro has parameters
      skipWhitespace(cTokenSource);
      if(cTokenSource.peekToken().getType() == KickCLexer.PAR_BEGIN) {
         // Macro has parameters - find parameter name list
         throw new CompileError("Macros with parameters not supported!");
      }
      final ArrayList<Token> macroBody = readBody(cTokenSource);
      defines.put(macroName, macroBody);
   }

   /**
    * Read a preprocessor body (eg. a macro body) until encountering a newline
    *
    * @param cTokenSource The token source to read from
    * @return The list of body tokens read
    */
   private ArrayList<Token> readBody(CTokenSource cTokenSource) {
      // Find body by gobbling tokens until the line ends
      final ArrayList<Token> macroBody = new ArrayList<>();
      while(true) {
         final Token bodyToken = cTokenSource.nextToken();
         if(bodyToken.getType() == KickCLexer.DEFINE_CONTINUE) {
            // Skip the multi-line token, add a newline token and continue reading body on the next line
            final CommonToken newlineToken = new CommonToken(bodyToken);
            newlineToken.setType(KickCLexer.WS);
            newlineToken.setChannel(CParser.CHANNEL_WHITESPACE);
            newlineToken.setText("\n");
            macroBody.add(newlineToken);
            continue;
         }
         if(bodyToken.getChannel() == CParser.CHANNEL_WHITESPACE && bodyToken.getText().contains("\n")) {
            // Done reading the body
            break;
         } else {
            macroBody.add(bodyToken);
         }
      }
      return macroBody;
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
         if(token.getChannel() != CParser.CHANNEL_WHITESPACE)
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

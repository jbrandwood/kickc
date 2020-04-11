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
   private Map<String, Macro> defines;

   /** A defined macro. */
   static class Macro {
      /** The name of the define. */
      final String name;
      /** The parameters. Empty if there are no parameters. */
      final List<String> parameters;
      /** The body. */
      final List<Token> body;

      Macro(String name, List<String> parameters, List<Token> body) {
         this.name = name;
         this.parameters = parameters;
         this.body = body;
      }
   }

   public CPreprocessor(TokenSource input, Map<String, Macro> defines) {
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
         skipToEndIf(cTokenSource);
         return true;
      } else if(inputToken.getType() == KickCLexer.ELIF) {
         // #elif means we must skip until #endif
         skipToEndIf(cTokenSource);
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
      List<String> macroParameters = new ArrayList<>();
      if(cTokenSource.peekToken().getType() == KickCLexer.PAR_BEGIN) {
         // Read past the '('
         cTokenSource.nextToken();
         // Macro has parameters - find parameter name list
         boolean commaNext = false;
         while(true) {
            skipWhitespace(cTokenSource);
            final Token paramToken = cTokenSource.nextToken();
            if(paramToken.getType() == KickCLexer.PAR_END) {
               if(!commaNext && macroParameters.size() > 0)
                  throw new CompileError("Error! #define declared parameter list ends with COMMA.", paramToken);
               // We reached the end of the parameters
               break;
            } else if(!commaNext && paramToken.getType() == KickCLexer.NAME) {
               macroParameters.add(paramToken.getText());
               // Now expect a comma
               commaNext = true;
            } else if(commaNext && paramToken.getType() == KickCLexer.COMMA)
               // Got the comma we needed - expect a name
               commaNext = false;
            else
               // Unexpected token
               throw new CompileError("Error! #define declared parameter not a NAME.", paramToken);
         }
      }
      final ArrayList<Token> macroBody = readBody(cTokenSource);
      defines.put(macroName, new Macro(macroName, macroParameters, macroBody));
   }

   /**
    * Encountered a NAME. Attempt to expand as a macro.
    *
    * @param macroNameToken The NAME token
    * @param cTokenSource The token source usable for getting more tokens (eg. parameter values) - and for pushing the expanded body to the front for further processing.
    * @return true if a macro was expanded. False if not.
    */
   private boolean expand(Token macroNameToken, CTokenSource cTokenSource) {
      final String macroName = macroNameToken.getText();
      Macro macro = defines.get(macroName);
      if(macro != null) {
         // Check for macro recursion
         if(macroNameToken instanceof ExpansionToken) {
            if(((ExpansionToken) macroNameToken).getMacroNames().contains(macroName)) {
               // Detected macro recursion in the expansion - add directly to output and do not perform expansion!
               macro = null;
            }
         }
      }
      if(macro != null) {
         // Handle parameters
         List<List<Token>> paramValues = new ArrayList<>();
         if(!macro.parameters.isEmpty()) {
            // Parse parameter value list
            {
               // Skip '('
               skipWhitespace(cTokenSource);
               nextToken(cTokenSource, KickCLexer.PAR_BEGIN);
               // Read parameter values
               List<Token> paramValue = new ArrayList<>();
               int nesting = 1;
               while(true) {
                  skipWhitespace(cTokenSource);
                  final Token paramToken = cTokenSource.nextToken();
                  if(paramToken.getType() == KickCLexer.PAR_END && nesting == 1) {
                     // We reached the end of the parameters - add the current param unless it is an empty parameter alone in the list
                     if(!paramValues.isEmpty() || !paramValue.isEmpty())
                        paramValues.add(paramValue);
                     break;
                  } else if(paramToken.getType() == KickCLexer.COMMA && nesting == 1) {
                     // We have reached the next parameter value
                     paramValues.add(paramValue);
                     paramValue = new ArrayList<>();
                  } else {
                     // We are reading a parameter value - handle nesting and store it
                     if(paramToken.getType() == KickCLexer.PAR_BEGIN)
                        nesting++;
                     if(paramToken.getType() == KickCLexer.PAR_END)
                        nesting--;
                     paramValue.add(paramToken);
                  }
               }
            }
            // Check parameter list length
            if(macro.parameters.size() != paramValues.size()) {
               throw new CompileError("Error! Wrong number of macro parameters. Expected " + macro.parameters.size() + " was " + paramValues.size(), macroNameToken);
            }
            // Expand parameter values
            List<List<Token>> expandedParamValues = new ArrayList<>();
            for(List<Token> paramTokens : paramValues) {
               List<Token> expandedParamValue = new ArrayList<>();
               CPreprocessor subPreprocessor = new CPreprocessor(new ListTokenSource(paramTokens), new HashMap<>(defines));
               while(true) {
                  final Token expandedToken = subPreprocessor.nextToken();
                  if(expandedToken.getType() == Token.EOF)
                     break;
                  else
                     expandedParamValue.add(expandedToken);
               }
               expandedParamValues.add(expandedParamValue);
               paramValues = expandedParamValues;
            }
         }

         // Perform macro expansion - by expanding the body at the start of the token source
         List<Token> expandedBody = new ArrayList<>();
         final List<Token> macroBody = macro.body;
         for(Token macroBodyToken : macroBody) {
            if(macroBodyToken.getType()==KickCLexer.NAME && macro.parameters.contains(macroBodyToken.getText())) {
               // body token is a parameter name - replace with expanded parameter value
               final int paramIndex = macro.parameters.indexOf(macroBodyToken.getText());
               final List<Token> expandedParamValue = paramValues.get(paramIndex);
               for(Token expandedParamValueToken : expandedParamValue) {
                  addTokenToExpandedBody(expandedParamValueToken, macroNameToken, expandedBody);
               }
            } else {
               // body token is a normal token 
               addTokenToExpandedBody(macroBodyToken, macroNameToken, expandedBody);
            }
         }
         cTokenSource.addSourceFirst(new ListTokenSource(expandedBody));
         return true;
      }
      return false;
   }

   /**
    * Add a macro token to the exapnded macro body. Keeps track of which macros has been used to expand the token using {@link ExpansionToken}
    * @param macroBodyToken The macro body token to add
    * @param macroNameToken The token containing the macro name. Used to get the name and as a source for copying token properties (ensuring file name, line etc. are OK).
    * @param expandedBody The expanded macro body to add the token to
    */
   private void addTokenToExpandedBody(Token macroBodyToken, Token macroNameToken, List<Token> expandedBody) {
      final CommonToken expandedToken = new CommonToken(macroNameToken);
      expandedToken.setText(macroBodyToken.getText());
      expandedToken.setType(macroBodyToken.getType());
      expandedToken.setChannel(macroBodyToken.getChannel());
      Set<String> macroNames = new HashSet<>();
      if(macroNameToken instanceof ExpansionToken) {
         // Transfer macro names to the new expansion
         macroNames = ((ExpansionToken) macroNameToken).getMacroNames();
      }
      macroNames.add(macroNameToken.getText());
      expandedBody.add(new ExpansionToken(expandedToken, macroNames));
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
         skipIfBody(cTokenSource);
      }
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
         skipIfBody(cTokenSource);
      }
   }

   /**
    * #if checks if a constant condition expression is non-zero
    *
    * @param cTokenSource The token source used to get the condition
    */
   private void ifif(CTokenSource cTokenSource) {
      Long conditionValue = readAndEvaluateCondition(cTokenSource);
      if(conditionValue == null || conditionValue == 0L) {
         skipIfBody(cTokenSource);
      }
   }

   /**
    * Read a condition expression ( for #if / #elif ) from a token source and evaluate it. Return the result.
    *
    * @param cTokenSource The token source to read from
    * @return The value of the evaluation of the constant condition expression
    */
   private Long readAndEvaluateCondition(CTokenSource cTokenSource) {
      // Read the condition body
      ArrayList<Token> conditionTokens = readBody(cTokenSource);
      // Evaluate any uses of the defined operator (to prevent expansion of the named macro)
      evaluateDefinedOperator(conditionTokens);
      // Expand the condition body before evaluating it
      CPreprocessor subPreprocessor = new CPreprocessor(new ListTokenSource(conditionTokens), new HashMap<>(defines));
      // Parse the expression
      KickCParser.ExprContext conditionExpr = ExprParser.parseExpression(subPreprocessor);
      // Evaluate the expression
      return evaluateExpression(conditionExpr);
   }

   /**
    * Evaluate a constant condition expression from #if / #eilf.
    * The special defined operator must be evaluated before calling this.
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
               return ((ConstantBool) result).getBool() ? 1L : 0L;
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
               return ((ConstantBool) result).getBool() ? 1L : 0L;
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
    * Find and evaluate the special "defined X" operator which evaluates to 1 if a named macro if defined and 0 if it is undefined.
    * Works by replacing the "defined X" tokens with the resulting 0/1 value in the passed token list.
    *
    * @param conditionTokens The token list
    */
   private void evaluateDefinedOperator(ArrayList<Token> conditionTokens) {
      // First evaluate the special defined operators
      ListIterator<Token> tokenIt = conditionTokens.listIterator();
      while(tokenIt.hasNext()) {
         Token token = tokenIt.next();
         if(token.getType() == KickCLexer.DEFINED) {
            // Remove the token
            tokenIt.remove();
            // Read the macro name to examine - and skip any parenthesis
            token = getNextSkipWhitespace(tokenIt);
            boolean hasPar = false;
            if(token.getType() == KickCLexer.PAR_BEGIN) {
               tokenIt.remove();
               token = getNextSkipWhitespace(tokenIt);
               hasPar = true;
            }
            if(token.getType() != KickCLexer.NAME) {
               throw new CompileError("Unexpected token. Was expecting NAME!", token);
            }
            tokenIt.remove();
            Token macroNameToken = token;
            String macroName = macroNameToken.getText();
            if(hasPar) {
               // Skip closing parenthesis
               token = getNextSkipWhitespace(tokenIt);
               if(token.getType() != KickCLexer.PAR_END) {
                  throw new CompileError("Unexpected token. Was expecting ')'!", token);
               }
               tokenIt.remove();
            }
            final boolean defined = defines.containsKey(macroName);
            CommonToken definedToken = new CommonToken(macroNameToken);
            definedToken.setType(KickCLexer.NUMBER);
            definedToken.setText(defined ? "1" : "0");
            tokenIt.add(definedToken);
         }
      }
   }

   /**
    * Get the next token from an iterator skipping whitespace (unless it has a newline)
    *
    * @param tokenIt The iterator
    * @return The next non-whitespace token
    */
   private Token getNextSkipWhitespace(ListIterator<Token> tokenIt) {
      Token token = tokenIt.next();
      while(token.getChannel() == CParser.CHANNEL_WHITESPACE && !token.getText().contains("\n"))
         token = tokenIt.next();
      return token;
   }

   /**
    * Skip tokens based in an #if that is false - look for a matching #elif, #else or the #endif
    *
    * @param cTokenSource The token source
    */
   private void skipIfBody(CTokenSource cTokenSource) {
      // Skip tokens until finding a matching #endif or a matching #else - respect nesting
      int nesting = 1;
      while(true) {
         final Token token = cTokenSource.nextToken();
         final int tokenType = token.getType();
         if(tokenType == KickCLexer.IFDEF || tokenType == KickCLexer.IFNDEF || tokenType == KickCLexer.IFIF) {
            ++nesting;
         } else if(tokenType == KickCLexer.ELIF) {
            if(nesting == 1) {
               // We are at the outer #if - #elif means we must evaluate the condition and maybe generate output from here!
               final Long conditionValue = readAndEvaluateCondition(cTokenSource);
               if(conditionValue != null && conditionValue != 0L)
                  // #elif condition !=0 - generate output from here!
                  return;
            }
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
    * Skip until a matching #endif
    *
    * @param cTokenSource The token source
    */
   private void skipToEndIf(CTokenSource cTokenSource) {
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
         throw new CompileError("Unexpected token. Was expecting " + tokenType, token);
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

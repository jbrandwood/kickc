package dk.camelot64.kickc.macros;

import org.antlr.v4.runtime.*;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

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
      Map<String, List<Token>> macros = new LinkedHashMap<>();
      final ArrayList<Token> expandedTokens = new ArrayList<>();
      Token inputToken = inputTokenSource.nextToken();
      while(inputToken.getType() != Token.EOF) {
         if(inputToken.getType() == tokenDefine) {
            // #define a new macro - find the name
            Token macroName = inputTokenSource.nextToken();
            while(macroName.getType() == tokenWhitespace)
               macroName = inputTokenSource.nextToken();
            // Find body by gobbling tokens until the line ends
            final ArrayList<Token> macroBody = new ArrayList<>();
            boolean macroRead = true;
            while(macroRead) {
               final Token bodyToken = inputTokenSource.nextToken();
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
         inputToken = inputTokenSource.nextToken();
      }
      return new ListTokenSource(expandedTokens);
   }

}

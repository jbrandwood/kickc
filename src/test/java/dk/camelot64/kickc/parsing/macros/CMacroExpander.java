package dk.camelot64.kickc.parsing.macros;

import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.TokenStreamRewriter;

import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Capable of defining and expanding C macros
 */
public class CMacroExpander {

   Map<String, String> macros;
   TokenStreamRewriter rewriter;

   public CMacroExpander() {
      this.macros = new LinkedHashMap<>();
      macros.put("A", "a");
   }

   public void setRewriter(TokenStreamRewriter rewriter) {
      this.rewriter = rewriter;
   }

   public void define(String macroDefine) {
      System.out.println("Macro defined: "+macroDefine);
   }

   public void expand(String text) {
      final String expanded = macros.get(text);
      if(expanded != null) {
         throw new RuntimeException("Macro expansion!");
      }
   }

}

package dk.camelot64.kickc.parser;

import java.util.List;

/**
 * State used to control lexing/parsing
 */
public class ParserState {

   /** Names of typedefs. Used by lexer to know the difference between normal value IDENTIFIERS and TYPEIDENTIFIERS */
   List<String> typedefs;

   /** True whenever the lexer/parser is parsing ASM. Enables/disables a lexer rules that might interfere.*/
   boolean isAsm;

   public ParserState() {
   }

   public void addTypeDef(String identifier) {
      typedefs.add(identifier);
   }

   public boolean isTypedef(String identifier) {
      return typedefs.contains(identifier);
   }

   public boolean isAsm() {
      return isAsm;
   }

   public void setAsm(boolean asm) {
      isAsm = asm;
   }
}

package dk.camelot64.kickc.fragment;

import dk.camelot64.kickc.parser.KickCLexer;
import dk.camelot64.kickc.parser.KickCParser;
import org.antlr.v4.runtime.*;

/**
 * An ASM fragment template usable for generating KickAssembler code for different bindings.
 * The AsmFragmentTemplateSynthesizer can generate multiple different templates usable for a specific fragment signature.
 */
public class AsmFragmentTemplate {

   /** true if the fragment was loaded from disk. */
   boolean file;
   /** The fragment template signature name. */
   private String signature;
   /** The fragment template body */
   private String body;
   /** The parsed ASM lines. Initially null. Will be non-null, is the template is ever used to generate ASM code. */
   private KickCParser.AsmLinesContext bodyAsm;
   /** The synthesis that created the fragment. null if the fragment template was loaded. */
   private AsmFragmentTemplateSynthesisRule synthesis;

   /** The sub fragment template that the synthesis modified to create this. null if the fragment template was loaded. */
   private AsmFragmentTemplate subFragment;

   public AsmFragmentTemplate(String signature, String body) {
      this.signature = signature;
      this.body = body;
      this.file = true;
   }

   AsmFragmentTemplate(String signature, String body, AsmFragmentTemplateSynthesisRule synthesis, AsmFragmentTemplate subFragment) {
      this.signature = signature;
      this.body = body;
      this.synthesis = synthesis;
      this.subFragment = subFragment;
      this.file = false;
   }

   /**
    * Creates an inline ASM fragment template
    *
    * @param bodyLines Parsed ASM body
    */
   public AsmFragmentTemplate(KickCParser.AsmLinesContext bodyLines) {
      this.signature = "--inline--";
      this.bodyAsm = bodyLines;
   }

   /**
    * Parse an ASM fragment.
    *
    * @param fragmentBody The stream containing the fragment syntax
    * @param fragmentFileName The filename (used in error messages)
    * @return The parsed fragment ready for generating
    */
   private static KickCParser.AsmLinesContext parseBody(String fragmentBody, final String fragmentFileName) {
      CodePointCharStream fragmentCharStream = CharStreams.fromString(fragmentBody);
      KickCLexer kickCLexer = new KickCLexer(fragmentCharStream);
      KickCParser kickCParser = new KickCParser(new CommonTokenStream(kickCLexer));
      kickCParser.addErrorListener(new BaseErrorListener() {
         @Override
         public void syntaxError(Recognizer<?, ?> recognizer, Object offendingSymbol, int line, int charPositionInLine, String msg, RecognitionException e) {
            throw new RuntimeException("Error parsing fragment " + fragmentFileName + "\n - Line: " + line + "\n - Message: " + msg);
         }
      });
      kickCParser.setBuildParseTree(true);
      KickCParser.AsmFileContext asmFile = kickCParser.asmFile();
      return asmFile.asmLines();
   }

   public String getSignature() {
      return signature;
   }

   public String getBody() {
      return body;
   }

   public KickCParser.AsmLinesContext getBodyAsm() {
      if(bodyAsm == null) {
         bodyAsm = parseBody(body, signature);
      }
      return bodyAsm;
   }

   public boolean isFile() {
      return file;
   }

   public AsmFragmentTemplateSynthesisRule getSynthesis() {
      return synthesis;
   }

   public AsmFragmentTemplate getSubFragment() {
      return subFragment;
   }

   public String getName() {
      StringBuilder name = new StringBuilder();
      name.append(signature);
      if(synthesis != null) {
         name.append(" < ");
         name.append(subFragment.getName());
      }
      return name.toString();
   }

   @Override
   public boolean equals(Object o) {
      if(this == o) return true;
      if(o == null || getClass() != o.getClass()) return false;
      AsmFragmentTemplate that = (AsmFragmentTemplate) o;
      return getName().equals(that.getName());
   }

   @Override
   public int hashCode() {
      return getName().hashCode();
   }

}

package dk.camelot64.kickc.model.statements;

import dk.camelot64.kickc.asm.AsmClobber;
import dk.camelot64.kickc.model.Comment;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.values.SymbolVariableRef;
import dk.camelot64.kickc.parser.KickCParser;

import java.util.List;
import java.util.Map;

/** Inline ASM code */
public class StatementAsm extends StatementBase {

   /** ASM Fragment code. */
   private KickCParser.AsmLinesContext asmLines;

   /** All variables/constants referenced in the inline assembler. */
   private Map<String, SymbolVariableRef> referenced;

   /** Declared clobber for the inline ASM. */
   private AsmClobber declaredClobber;

   public StatementAsm(KickCParser.AsmLinesContext asmLines, Map<String, SymbolVariableRef> referenced, AsmClobber declaredClobber, StatementSource source, List<Comment> comments) {
      super(null, source, comments);
      this.asmLines = asmLines;
      this.referenced = referenced;
      this.declaredClobber = declaredClobber;
   }

   @Override
   public String toString(Program program, boolean aliveInfo) {
      StringBuilder txt = new StringBuilder();
      txt.append("asm { ");
      for(KickCParser.AsmLineContext line : asmLines.asmLine()) {
         txt.append(line.getText()).append(" ");
      }
      txt.append(" }");
      return txt.toString();
   }

   public KickCParser.AsmLinesContext getAsmLines() {
      return asmLines;
   }

   public void setReferenced(Map<String, SymbolVariableRef> referenced) {
      this.referenced = referenced;
   }

   public Map<String, SymbolVariableRef> getReferenced() {
      return referenced;
   }

   public AsmClobber getDeclaredClobber() {
      return declaredClobber;
   }

   public void setDeclaredClobber(AsmClobber declaredClobber) {
      this.declaredClobber = declaredClobber;
   }
}

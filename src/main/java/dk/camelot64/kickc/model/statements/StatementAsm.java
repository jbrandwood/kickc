package dk.camelot64.kickc.model.statements;

import dk.camelot64.cpufamily6502.AsmClobber;
import dk.camelot64.kickc.model.Comment;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.values.SymbolRef;
import dk.camelot64.kickc.parser.KickCParser;

import java.util.List;
import java.util.Map;

/** Inline ASM code */
public class StatementAsm extends StatementBase {

   /** Cached parsed ASM code. */
   private KickCParser.AsmLinesContext asmLines;

   /** All variables/constants referenced in the inline assembler. */
   private Map<String, SymbolRef> referenced;

   /** Declared clobber for the inline ASM. */
   private AsmClobber declaredClobber;

   public StatementAsm(KickCParser.AsmLinesContext asmBody, Map<String, SymbolRef> referenced, AsmClobber declaredClobber, StatementSource source, List<Comment> comments) {
      super(source, comments);
      this.asmLines = asmBody;
      this.referenced = referenced;
      this.declaredClobber = declaredClobber;
   }

   @Override
   public String toString(Program program, boolean aliveInfo) {
      StringBuilder txt = new StringBuilder();
      txt.append("asm { ");
      for(KickCParser.AsmLineContext line : getAsmLines().asmLine()) {
         txt.append(line.getText()).append(" ");
      }
      txt.append(" }");
      return txt.toString();
   }

   public KickCParser.AsmLinesContext getAsmLines() {
      return asmLines;
   }

   public void setReferenced(Map<String, SymbolRef> referenced) {
      this.referenced = referenced;
   }

   public Map<String, SymbolRef> getReferenced() {
      return referenced;
   }

   public AsmClobber getDeclaredClobber() {
      return declaredClobber;
   }

   public void setDeclaredClobber(AsmClobber declaredClobber) {
      this.declaredClobber = declaredClobber;
   }
}

package dk.camelot64.kickc.model.statements;

import dk.camelot64.kickc.parser.AsmParser;
import dk.camelot64.kickc.asm.AsmClobber;
import dk.camelot64.kickc.model.Comment;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.values.SymbolRef;
import dk.camelot64.kickc.parser.KickCParser;

import java.util.List;
import java.util.Map;

/** Inline ASM code */
public class StatementAsm extends StatementBase {

   /** ASM code. */
   private String asmBody;

   /** Cached parsed ASM code. */
   private transient KickCParser.AsmLinesContext asmLines;

   /** All variables/constants referenced in the inline assembler. */
   private Map<String, SymbolRef> referenced;

   /** Declared clobber for the inline ASM. */
   private AsmClobber declaredClobber;

   public StatementAsm(String asmBody, Map<String, SymbolRef> referenced, AsmClobber declaredClobber, StatementSource source, List<Comment> comments) {
      super(null, source, comments);
      this.asmBody = asmBody;
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

   public String getAsmBody() {
      return asmBody;
   }

   public KickCParser.AsmLinesContext getAsmLines() {
      if(asmLines==null) {
         this.asmLines = AsmParser.parseAsm(asmBody, getSource());
      }
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

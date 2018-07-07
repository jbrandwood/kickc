package dk.camelot64.kickc.model.statements;

import dk.camelot64.kickc.model.Program;

/** Inline KickAssembler code */
public class StatementKickAsm extends StatementBase {

   /** KickAssembler code. */
   private String kickAsmCode;

   public StatementKickAsm(String kickAsmCode, StatementSource source) {
      super(null, source);
      this.kickAsmCode = kickAsmCode;
   }

   @Override
   public String toString(Program program, boolean aliveInfo) {
      StringBuilder txt = new StringBuilder();
      txt.append("kickasm {{ ");
      txt.append(kickAsmCode);
      txt.append(" }}");
      return txt.toString();
   }

   public String getKickAsmCode() {
      return kickAsmCode;
   }

}
